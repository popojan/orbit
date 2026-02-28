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
where ζₙ = e^(2πi/n). Accepts any number of coefficients; internally
reduces modulo Φₙ(ζ) = 0 to canonical form with EulerPhi[n] coefficients
in basis {1, ζ, ..., ζ^(φ(n)-1)}. Extra coefficients wrap via ζⁿ = 1.
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
Works for any order n. For rational inputs, result simplifies to rational.";

CyclotomicImagPart::usage = "CyclotomicImagPart[elem] extracts the imaginary part of a cyclotomic element.
Works for any order n. For rational inputs, result simplifies to rational.";

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

CyclotomicInverse::usage = "CyclotomicInverse[elem] returns the multiplicative inverse in Q(zn). Fails on zero.";
CyclotomicDivide::usage = "CyclotomicDivide[a, b] computes a/b in Q(zn).";

CyclotomicInverse::zero = "Cannot invert the zero element.";

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

LpDFT::usage = "LpDFT[signal, p] computes DFT using L^p geometry roots of unity.
Default p=2 gives standard circular DFT.
p=1 uses diamond (taxicab) geometry, p=∞ uses square (Chebyshev) geometry.
Returns list of {x, y} pairs (symbolic, via α[κ[ρ[n,k], p]]).
Use // N for numeric evaluation.
Note: p≠2 causes spectral leakage; p=1 gives slightly more sparse representations.";

LpDFTInverse::usage = "LpDFTInverse[spectrum, p] computes inverse L^p DFT.
Input spectrum should be list of {x, y} pairs. Use same p as forward transform.";

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
  {phi = EulerPhi[n], cyclo, poly, reduced, z},

  (* Build polynomial from coefficients *)
  (* Use Module-local z to avoid namespace conflicts *)
  poly = Sum[coeffs[[k]] z^(k-1), {k, 1, Length[coeffs]}];

  (* Get cyclotomic polynomial *)
  cyclo = Cyclotomic[n, z];

  (* Reduce modulo cyclotomic polynomial *)
  (* PolynomialRemainder gives remainder of poly/cyclo *)
  reduced = PolynomialRemainder[poly, cyclo, z];

  (* Extract coefficients, pad to φ(n) *)
  PadRight[CoefficientList[reduced, z], phi]
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

(* Multiplicative inverse via extended GCD mod Φₙ *)
(* Since Φₙ is irreducible over ℚ, any nonzero element has an inverse *)
CyclotomicInverse[CyclotomicElement[n_, coeffs_]] := Module[
  {z, poly, cyclo, gcdResult, g, s},
  poly = Sum[coeffs[[k]] z^(k - 1), {k, 1, Length[coeffs]}];
  If[poly === 0, Message[CyclotomicInverse::zero]; Return[$Failed]];
  cyclo = Cyclotomic[n, z];
  gcdResult = PolynomialExtendedGCD[poly, cyclo, z];
  g = gcdResult[[1]];
  s = gcdResult[[2, 1]];
  CyclotomicElement[n, PadRight[CoefficientList[s/g, z], EulerPhi[n]]]
]

CyclotomicDivide[a_CyclotomicElement, b_CyclotomicElement] :=
  CyclotomicMultiply[a, CyclotomicInverse[b]]

(* Promote to higher order cyclotomic field *)
(* Minimal basis: coeffs[[k]] is weight of ζₙ^(k-1) for k = 1..φ(n) *)
(* Embedding: ζₙ^j = ζₘ^(j·factor), so position k maps to position k·factor *)
promoteTo[CyclotomicElement[n_, coeffs_], m_] /; Divisible[m, n] := Module[
  {factor = m/n, newCoeffs},
  newCoeffs = Table[0, m];
  Do[
    newCoeffs[[factor (k - 1) + 1]] = coeffs[[k]];
    , {k, 1, Length[coeffs]}  (* φ(n) coefficients, not n *)
  ];
  CyclotomicElement[m, newCoeffs]  (* constructor reduces mod Φₘ *)
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

(* Extract via CyclotomicToComplex — correct for all n and all elements. *)
(* For rational inputs (e.g. FFT of rationals), result simplifies to rational. *)

CyclotomicRealPart[elem_CyclotomicElement] :=
  Re[CyclotomicToComplex[elem]] // Simplify

CyclotomicImagPart[elem_CyclotomicElement] :=
  Im[CyclotomicToComplex[elem]] // Simplify

(* Extract as rational value if result is real, otherwise return complex *)
CyclotomicToRational[elem_CyclotomicElement] := Module[{z},
  z = CyclotomicToComplex[elem];
  If[Im[z] === 0 || PossibleZeroQ[Im[z]], Re[z] // Simplify, z]
]

(* Extract as {Re, Im} pair — works for any order n *)
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

CyclotomicDFT[input_List] := Module[{n = Length[input], x, result},
  (* Convert inputs to cyclotomic *)
  x = CyclotomicFromReal[#, n] & /@ input;

  (* Direct DFT computation: X[k] = Σ_j x[j] ω^(jk) *)
  result = Table[
    cyclotomicSum @ Table[
      CyclotomicMultiply[x[[j + 1]], CyclotomicTwiddle[n, j * k]],
      {j, 0, n - 1}
    ],
    {k, 0, n - 1}
  ];
  result
]

(* Check if CyclotomicElement is rational (only ζ⁰ coefficient nonzero) *)
cyclotomicIsRational[CyclotomicElement[_, coeffs_]] :=
  AllTrue[Rest[coeffs], # === 0 &]

(* Extract rational if possible, otherwise return CyclotomicElement *)
maybeExtractRational[elem_CyclotomicElement] :=
  If[cyclotomicIsRational[elem],
    First[CyclotomicCoeffs[elem]],
    elem
  ]

(* Convert to CyclotomicElement if needed *)
toCyclotomic[x_?NumericQ, n_] := CyclotomicFromReal[x, n]
toCyclotomic[x_CyclotomicElement, n_] /; CyclotomicOrder[x] == n := x
toCyclotomic[x_CyclotomicElement, n_] /; Divisible[n, CyclotomicOrder[x]] :=
  (* Order divides target: embed via ζₘ^k → ζₙ^(k·factor) *)
  promoteTo[x, n]
toCyclotomic[x_CyclotomicElement, n_] :=
  (* Incompatible orders - shouldn't happen in normal DFT usage *)
  (Message[CyclotomicInverseDFT::order, CyclotomicOrder[x], n]; x)

CyclotomicInverseDFT[input_List] := Module[{n = Length[input], x, result},
  (* IDFT: x[j] = (1/n) Σ_k X[k] ζ^(jk) *)
  (* Note: ζ = e^(2πi/n), while ω = e^(-2πi/n) = ζ^(-1) *)
  (* So ω^(-jk) = ζ^(jk) *)
  (* Order = list length (DFT of length n uses n-th roots) *)
  x = toCyclotomic[#, n] & /@ input;
  result = Table[
    CyclotomicScale[
      cyclotomicSum @ Table[
        CyclotomicMultiply[x[[k + 1]], zetaPower[n, j * k]],
        {k, 0, n - 1}
      ],
      1/n
    ],
    {j, 0, n - 1}
  ];
  result
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
(* v2: φ[t] = e^(i(5π/4 + πt)) for γ[t] = Cos[5π/4 + πt] *)
(* For t = 2k/n - 7/4, this is a root of unity *)
CyclotomicFromCirc[t_?NumericQ, n_Integer] := Module[
  {k, coeffs},
  (* φ[t] corresponds to e^(i(5π/4 + πt)) in v2 *)
  (* For now, just verify t gives n-th root *)
  k = (t + 7/4) * n / 2;  (* v2: 7/4 offset *)
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
(* Handles mixed types: auto-extracted rationals from CyclotomicDFT + CyclotomicElements *)
CircleTimes[a_List, b_List] := Module[{n, elem},
  (* Infer cyclotomic order from first CyclotomicElement found *)
  elem = FirstCase[Join[a, b], _CyclotomicElement, None];
  If[elem === None,
    (* Both lists are all-rational: plain element-wise multiplication *)
    a * b,
    n = CyclotomicOrder[elem];
    MapThread[
      CyclotomicMultiply[toCyclotomic[#1, n], toCyclotomic[#2, n]] &,
      {a, b}
    ]
  ]
]

(* Full convolution shorthand: Ψ[Φ[a] ⊗ Φ[b]] *)

(* ============================================ *)
(* L^p DFT (EXPERIMENTAL)                       *)
(* Uses κ[ρ[n,k], p] from CircFunctions.wl      *)
(* p=2: circle (standard DFT)                   *)
(* p=1: diamond (taxicab geometry)              *)
(* p=∞: square (Chebyshev geometry)             *)
(* ============================================ *)

(* Get k-th n-th root of unity in L^p geometry *)
(* Returns κ[t, p] where t = ρ[n,k] (γ-parameter) *)
(* Use α[...] to evaluate to {Cos, Sin} form *)
lpRootSymbolic[n_, k_, p_] := \[Kappa][\[Rho][n, k], p]

(* Convert {x,y} to complex number *)
toComplex[{x_, y_}] := x + I y

(* Forward L^p DFT - symbolic version *)
(* Returns list of {x,y} pairs in α form *)
LpDFT[signal_List, p_: 2] := Module[{n = Length[signal]},
  Table[
    Total @ Table[
      signal[[j]] * lpRootSymbolic[n, Mod[(j-1)*(k-1), n] + 1, p],
      {j, 1, n}
    ],
    {k, 1, n}
  ]
]

(* Numeric convenience: LpDFT // N or N[LpDFT[...]] *)
LpDFT /: N[LpDFT[signal_List, p_: 2]] := N /@ LpDFT[signal, p]

(* Inverse L^p DFT *)
LpDFTInverse[spectrum_List, p_: 2] := Module[{n = Length[spectrum]},
  Table[
    (1/n) Total @ Table[
      spectrum[[k]] * MapAt[-# &, lpRootSymbolic[n, Mod[(j-1)*(k-1), n] + 1, p], 2],
      {k, 1, n}
    ],
    {j, 1, n}
  ]
]

End[];

EndPackage[];
