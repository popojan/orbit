(* ::Package:: *)

(* CyclotomicFFT: Fully Rational FFT via Cyclotomic Fields

   Represents complex numbers as ℚ-linear combinations of roots of unity:
     z = Σ aₖ ζₙᵏ  where aₖ ∈ ℚ and ζₙ = e^(2πi/n)

   All FFT operations (including butterfly addition!) stay in rationals.

   Reference: docs/sessions/2025-12-11-gauss-fft-hartley/README.md
*)

BeginPackage["Orbit`"];

(* ============================================ *)
(* CYCLOTOMIC ELEMENT REPRESENTATION            *)
(* ============================================ *)

CyclotomicElement::usage = "CyclotomicElement[n, coeffs] represents Σ aₖ ζₙᵏ
where coeffs = {a₀, a₁, ..., a_{m-1}} and ζₙ = e^(2πi/n).
The number of coefficients m = EulerPhi[n] or n (full form).
All operations preserve rational coefficients.";

CyclotomicOrder::usage = "CyclotomicOrder[elem] returns the cyclotomic order n of the element.";

CyclotomicCoeffs::usage = "CyclotomicCoeffs[elem] returns the rational coefficients.";

CyclotomicToComplex::usage = "CyclotomicToComplex[elem] evaluates to complex number.
This is the ONLY function that leaves rationals.";

CyclotomicToRational::usage = "CyclotomicToRational[elem] extracts rational value if result is real.
Otherwise returns the complex result from CyclotomicToComplex.";

CyclotomicToGamma::usage = "CyclotomicToGamma[elem] converts to γ framework expression.
Returns {x, y} where x and y are sums of γ[t] terms.
Use // α to convert to classical cos/sin form.";

CyclotomicFromReal::usage = "CyclotomicFromReal[x, n] creates cyclotomic element from real rational x.";

CyclotomicFromComplex::usage = "CyclotomicFromComplex[z, n] creates cyclotomic element from z ∈ ℚ(i).
Only works if n divisible by 4.";

CyclotomicRealPart::usage = "CyclotomicRealPart[elem] extracts the real part of a cyclotomic element.
For power-of-2 order n, returns (a₀ - a_{n/2}) where ζ^(n/2) = -1.";

CyclotomicImagPart::usage = "CyclotomicImagPart[elem] extracts the imaginary part.
For n divisible by 4, returns (a_{n/4} - a_{3n/4}) where ζ^(n/4) = i.";

(* ============================================ *)
(* CYCLOTOMIC ARITHMETIC                        *)
(* ============================================ *)

CyclotomicAdd::usage = "CyclotomicAdd[a, b] adds two cyclotomic elements.
Coefficients are added componentwise. Result is rational.";

CyclotomicSubtract::usage = "CyclotomicSubtract[a, b] subtracts cyclotomic elements.";

CyclotomicMultiply::usage = "CyclotomicMultiply[a, b] multiplies cyclotomic elements.
Uses polynomial multiplication with reduction ζⁿ = 1. Result is rational.";

CyclotomicNegate::usage = "CyclotomicNegate[a] negates a cyclotomic element.";

CyclotomicScale::usage = "CyclotomicScale[a, r] scales by rational r.";

(* ============================================ *)
(* FFT-SPECIFIC OPERATIONS                      *)
(* ============================================ *)

CyclotomicTwiddle::usage = "CyclotomicTwiddle[n, k] returns ω^k = e^(-2πik/n) as cyclotomic element.
These are the FFT twiddle factors.";

CyclotomicButterfly::usage = "CyclotomicButterfly[e, o, twiddle] computes butterfly operation.
Returns {e + twiddle*o, e - twiddle*o}. Fully rational!";

CyclotomicDFT::usage = "CyclotomicDFT[list] computes DFT of rational inputs.
Returns list of CyclotomicElement. All coefficients stay rational.";

CyclotomicInverseDFT::usage = "CyclotomicInverseDFT[list] computes inverse DFT.";

(* ============================================ *)
(* CONVERSION WITH CIRC FRAMEWORK               *)
(* ============================================ *)

CyclotomicFromCirc::usage = "CyclotomicFromCirc[t, n] converts Circ parameter to cyclotomic.
The phase φ[t] becomes a cyclotomic element with rational coefficients.";

(* ============================================ *)
(* SHORT ALIASES (Greek letters)               *)
(* ============================================ *)

\[CapitalPhi]::usage = "\[CapitalPhi][list] is a short alias for CyclotomicDFT.
Type: Esc+P+h+i+Esc or Esc+F+Esc

Convolution via FFT:  \[CapitalPsi][\[CapitalPhi][a] \[CapitalPhi][b]]
(displays as: Ψ[Φ[a] Φ[b]])";

\[CapitalPsi]::usage = "\[CapitalPsi][list] is a short alias for CyclotomicInverseDFT.
Type: Esc+P+s+i+Esc or Esc+Y+Esc

Convolution via FFT:  \[CapitalPsi][\[CapitalPhi][a] \[CapitalPhi][b]]
(displays as: Ψ[Φ[a] Φ[b]])";

CyclotomicToCircPhases::usage = "CyclotomicToCircPhases[elem] attempts to express as sum of Circ phases.
Returns {coeffs, phases} where elem = Σ coeffs[[k]] φ[phases[[k]]].";

Begin["`Private`"];

(* ============================================ *)
(* INTERNAL: MINIMAL POLYNOMIAL REDUCTION       *)
(* Reduce to basis of dimension φ(n) using      *)
(* cyclotomic polynomial Φₙ(ζ) = 0              *)
(* ============================================ *)

(* Reduce polynomial coefficients modulo cyclotomic polynomial Φₙ *)
(* This gives canonical representation in minimal basis {1, ζ, ..., ζ^(φ(n)-1)} *)
reduceCoeffsCyclotomic[coeffs_List, n_Integer] := Module[
  {phi = EulerPhi[n], cyclo, poly, reduced},

  (* Build polynomial from coefficients *)
  poly = Sum[coeffs[[k]] Global`x^(k-1), {k, 1, Length[coeffs]}];

  (* Get cyclotomic polynomial *)
  cyclo = Cyclotomic[n, Global`x];

  (* Reduce modulo cyclotomic polynomial *)
  (* PolynomialRemainder gives remainder of poly/cyclo *)
  reduced = PolynomialRemainder[poly, cyclo, Global`x];

  (* Extract coefficients, pad to φ(n) *)
  PadRight[CoefficientList[reduced, Global`x], phi]
]

(* Legacy: Full reduction using only ζⁿ = 1 (keeps n coefficients) *)
reduceCoeffsFull[coeffs_List, n_Integer] := Module[{result},
  If[Length[coeffs] <= n,
    Return[PadRight[coeffs, n]]
  ];
  (* Fold coefficients using ζⁿ = 1 *)
  result = Table[0, n];
  Do[
    result[[Mod[k - 1, n] + 1]] += coeffs[[k]];
    , {k, 1, Length[coeffs]}
  ];
  result
]

(* ============================================ *)
(* CYCLOTOMIC ELEMENT STRUCTURE                 *)
(* ============================================ *)

(* Constructor - normalize coefficients using cyclotomic polynomial *)
(* Result has φ(n) coefficients in minimal basis *)
CyclotomicElement[n_Integer, coeffs_List] /; IntegerQ[n] && n > 0 :=
  CyclotomicElement[n, reduceCoeffsCyclotomic[coeffs, n]] /; Length[coeffs] != EulerPhi[n]

(* Accessors *)
CyclotomicOrder[CyclotomicElement[n_, _]] := n
CyclotomicCoeffs[CyclotomicElement[_, coeffs_]] := coeffs
CyclotomicDimension[CyclotomicElement[n_, _]] := EulerPhi[n]

(* Display form: clean ζ notation *)
(* ζₙᵏ corresponds to κ[ρ[n,k]] in γ framework, but we display as ζᵏ for readability *)
(* Use Expand[elem] to convert to γ framework *)

Format[CyclotomicElement[n_, coeffs_]] := Module[{terms},
  terms = Table[
    If[coeffs[[k+1]] == 0, Nothing,
      If[k == 0, coeffs[[1]],
        If[coeffs[[k+1]] == 1, Superscript["\[Zeta]", k],
          If[coeffs[[k+1]] == -1, -Superscript["\[Zeta]", k],
            coeffs[[k+1]] Superscript["\[Zeta]", k]
          ]
        ]
      ]
    ],
    {k, 0, Length[coeffs] - 1}
  ];
  If[terms === {}, 0,
    Row[{Subscript["\[DoubleStruckCapitalQ]", n], "[", Plus @@ terms, "]"}]
  ]
]

(* Expand: convert ζ to γ framework via κ[ρ[n,k]] *)
CyclotomicElement /: Expand[CyclotomicElement[n_, coeffs_]] :=
  CyclotomicToGamma[CyclotomicElement[n, coeffs]]

(* ============================================ *)
(* CYCLOTOMIC ARITHMETIC                        *)
(* ============================================ *)

CyclotomicAdd[CyclotomicElement[n_, a_], CyclotomicElement[n_, b_]] :=
  CyclotomicElement[n, a + b]

CyclotomicAdd[a_CyclotomicElement, b_CyclotomicElement] := Module[{n},
  (* Different orders - promote to LCM *)
  n = LCM[CyclotomicOrder[a], CyclotomicOrder[b]];
  CyclotomicAdd[promoteTo[a, n], promoteTo[b, n]]
]

CyclotomicSubtract[a_, b_] := CyclotomicAdd[a, CyclotomicNegate[b]]

CyclotomicNegate[CyclotomicElement[n_, coeffs_]] :=
  CyclotomicElement[n, -coeffs]

CyclotomicScale[CyclotomicElement[n_, coeffs_], r_] :=
  CyclotomicElement[n, r * coeffs]

(* Multiplication: polynomial product with reduction *)
CyclotomicMultiply[CyclotomicElement[n_, a_], CyclotomicElement[n_, b_]] := Module[
  {m = Length[a], product, reduced},
  (* Polynomial multiplication *)
  product = Table[
    Sum[If[j >= 1 && j <= m && k-j+1 >= 1 && k-j+1 <= m, a[[j]] b[[k-j+1]], 0], {j, 1, k}],
    {k, 1, 2m - 1}
  ];
  (* Reduce using ζⁿ = 1 *)
  reduced = Table[0, n];
  Do[
    reduced[[Mod[k - 1, n] + 1]] += product[[k]];
    , {k, 1, Length[product]}
  ];
  CyclotomicElement[n, reduced]
]

CyclotomicMultiply[a_CyclotomicElement, b_CyclotomicElement] := Module[{n},
  n = LCM[CyclotomicOrder[a], CyclotomicOrder[b]];
  CyclotomicMultiply[promoteTo[a, n], promoteTo[b, n]]
]

(* Promote to higher order cyclotomic field *)
promoteTo[CyclotomicElement[n_, coeffs_], m_] /; Divisible[m, n] := Module[
  {factor = m/n, newCoeffs},
  newCoeffs = Table[0, m];
  Do[
    newCoeffs[[factor (k - 1) + 1]] = coeffs[[k]];
    , {k, 1, n}
  ];
  CyclotomicElement[m, newCoeffs]
]

promoteTo[elem_CyclotomicElement, n_] /; CyclotomicOrder[elem] == n := elem

(* ============================================ *)
(* CONVERSION TO COMPLEX                        *)
(* ============================================ *)

(* Convert from minimal basis (φ(n) coefficients) to complex number *)
CyclotomicToComplex[CyclotomicElement[n_, coeffs_]] := Module[
  {phi = EulerPhi[n], ζ = Exp[2 Pi I / n]},
  (* coeffs has length φ(n), basis is {1, ζ, ζ², ..., ζ^(φ(n)-1)} *)
  Sum[coeffs[[k + 1]] ζ^k, {k, 0, phi - 1}] // Simplify
]

(* Convert to γ framework expression: sum of κ[ρ[n,k]] terms *)
(* Returns {x-component, y-component} where each is sum of γ[t] terms *)
CyclotomicToGamma[CyclotomicElement[n_, coeffs_]] := Module[{phi = EulerPhi[n]},
  Sum[
    If[coeffs[[k + 1]] == 0, {0, 0},
      coeffs[[k + 1]] * If[k == 0, {1, 0}, \[Kappa][\[Rho][n, k]]]
    ],
    {k, 0, phi - 1}
  ]
]

(* α support: reveal classical form via γ → cos conversion *)
\[Alpha][elem_CyclotomicElement] := \[Alpha][CyclotomicToGamma[elem]]


(* ============================================ *)
(* CONSTRUCTORS                                 *)
(* ============================================ *)

CyclotomicFromReal[x_, n_Integer] := CyclotomicElement[n, PadRight[{x}, EulerPhi[n]]]

(* ============================================ *)
(* REAL/IMAG EXTRACTION                         *)
(* ============================================ *)

(* For ζ = e^(2πi/n):
   ζ^(n/2) = e^(πi) = -1
   ζ^(n/4) = e^(πi/2) = i
   So: Re[z] comes from coefficients of 1 and ζ^(n/2) = -1
       Im[z] comes from coefficients of ζ^(n/4) = i and ζ^(3n/4) = -i *)

CyclotomicRealPart[CyclotomicElement[n_, coeffs_]] := Module[{half = n/2},
  If[!IntegerQ[half], Return[$Failed]];
  coeffs[[1]] - coeffs[[half + 1]]
]

CyclotomicImagPart[CyclotomicElement[n_, coeffs_]] := Module[{quarter = n/4},
  If[!IntegerQ[quarter], Return[$Failed]];
  coeffs[[quarter + 1]] - coeffs[[3 quarter + 1]]
]

(* Extract as rational value if result is real, otherwise return complex *)
CyclotomicToRational[elem_CyclotomicElement] := Module[{z},
  z = CyclotomicToComplex[elem];
  If[Im[z] === 0 || PossibleZeroQ[Im[z]], Re[z] // Simplify, z]
]

(* Extract as {Re, Im} pair - only works for n divisible by 4, uses full basis *)
CyclotomicToRationalPair[elem_CyclotomicElement] := {
  CyclotomicRealPart[elem],
  CyclotomicImagPart[elem]
}

CyclotomicFromComplex[z_, n_Integer] /; Divisible[n, 4] := Module[
  {re = Re[z], im = Im[z], coeffs},
  (* ζ^(n/4) = i for power-of-2 aligned n *)
  coeffs = Table[0, n];
  coeffs[[1]] = re;
  coeffs[[n/4 + 1]] = im;
  CyclotomicElement[n, coeffs]
]

(* ============================================ *)
(* FFT TWIDDLE FACTORS                          *)
(* ============================================ *)

(* ω^k = e^(-2πik/n) = ζ^(-k) = ζ^(n-k) *)
CyclotomicTwiddle[n_Integer, k_Integer] := Module[{coeffs, idx},
  coeffs = Table[0, n];
  idx = Mod[-k, n] + 1;  (* ζ^(-k) = ζ^(n-k) *)
  coeffs[[idx]] = 1;
  CyclotomicElement[n, coeffs]
]

(* ============================================ *)
(* FFT BUTTERFLY                                *)
(* ============================================ *)

CyclotomicButterfly[e_CyclotomicElement, o_CyclotomicElement, tw_CyclotomicElement] := Module[
  {twO = CyclotomicMultiply[tw, o]},
  {CyclotomicAdd[e, twO], CyclotomicSubtract[e, twO]}
]

(* ============================================ *)
(* FULL DFT                                     *)
(* ============================================ *)

(* Helper: sum list of cyclotomic elements *)
cyclotomicSum[elems_List] := Module[{n, coeffs},
  n = CyclotomicOrder[First[elems]];
  coeffs = Total[CyclotomicCoeffs /@ elems];
  CyclotomicElement[n, coeffs]
]

CyclotomicDFT[input_List] := Module[{n = Length[input], x},
  (* Convert inputs to cyclotomic *)
  x = CyclotomicFromReal[#, n] & /@ input;

  (* Direct DFT computation: X[k] = Σ_j x[j] ω^(jk) *)
  Table[
    cyclotomicSum @ Table[
      CyclotomicMultiply[x[[j + 1]], CyclotomicTwiddle[n, j * k]],
      {j, 0, n - 1}
    ],
    {k, 0, n - 1}
  ]
]

CyclotomicInverseDFT[input_List] := Module[{n = Length[input], ord},
  (* IDFT: x[j] = (1/n) Σ_k X[k] ζ^(jk) *)
  (* Note: ζ = e^(2πi/n), while ω = e^(-2πi/n) = ζ^(-1) *)
  (* So ω^(-jk) = ζ^(jk) *)
  ord = CyclotomicOrder[First[input]];
  Table[
    CyclotomicScale[
      cyclotomicSum @ Table[
        CyclotomicMultiply[input[[k + 1]], zetaPower[ord, j * k]],
        {k, 0, n - 1}
      ],
      1/n
    ],
    {j, 0, n - 1}
  ]
]

(* ζ^k (forward rotation, not twiddle) *)
zetaPower[n_Integer, k_Integer] := Module[{coeffs, idx},
  coeffs = Table[0, n];
  idx = Mod[k, n] + 1;
  coeffs[[idx]] = 1;
  CyclotomicElement[n, coeffs]
]

(* ============================================ *)
(* CIRC FRAMEWORK CONNECTION                    *)
(* ============================================ *)

(* Convert Circ phase to cyclotomic element *)
(* φ[t] = e^(i(3π/4 + πt)) = e^(3πi/4) · e^(πit) *)
(* For t = 2k/n - 5/4, this is a root of unity *)
CyclotomicFromCirc[t_?NumericQ, n_Integer] := Module[
  {k, coeffs},
  (* φ[t] corresponds to e^(i(3π/4 + πt)) *)
  (* = ζ_8^3 · ζ_n^(nt/2 + ...) — complicated! *)
  (* For now, just verify t gives n-th root *)
  k = (t + 5/4) * n / 2;
  If[IntegerQ[k],
    CyclotomicTwiddle[n, -k],  (* ω = e^(-2πi/n), so φ relates inversely *)
    $Failed
  ]
]

(* ============================================ *)
(* GREEK LETTER ALIASES                        *)
(* ============================================ *)

(* Φ = Forward DFT (Esc+F+Esc or Esc+Phi+Esc) *)
\[CapitalPhi][x_List] := CyclotomicDFT[x]

(* Ψ = Inverse DFT (Esc+Y+Esc or Esc+Psi+Esc) *)
\[CapitalPsi][x_List] := CyclotomicInverseDFT[x]

(* Element-wise multiplication of cyclotomic lists: use CircleTimes ⊗ *)
(* Type: Esc + c + * + Esc *)
CircleTimes[a_List, b_List] /; AllTrue[a, Head[#] === CyclotomicElement &] &&
                               AllTrue[b, Head[#] === CyclotomicElement &] :=
  MapThread[CyclotomicMultiply, {a, b}]

(* Full convolution shorthand: Ψ[Φ[a] ⊗ Φ[b]] *)

End[];

EndPackage[];
