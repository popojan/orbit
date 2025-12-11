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

CyclotomicToCircPhases::usage = "CyclotomicToCircPhases[elem] attempts to express as sum of Circ phases.
Returns {coeffs, phases} where elem = Σ coeffs[[k]] φ[phases[[k]]].";

Begin["`Private`"];

(* ============================================ *)
(* INTERNAL: MINIMAL POLYNOMIAL REDUCTION       *)
(* For n=2^k, we use ζ^(n/2) = -1                *)
(* ============================================ *)

(* Reduce coefficients using ζ^(n/2) = -1 for power-of-2 *)
reduceCoeffs[coeffs_List, n_Integer] := Module[{m = Length[coeffs], half = n/2, reduced},
  If[m <= half, Return[PadRight[coeffs, half]]];
  (* Fold high coefficients using ζ^half = -1 *)
  reduced = Take[coeffs, half];
  Do[
    reduced[[Mod[k - 1, half] + 1]] -= coeffs[[k]];
    , {k, half + 1, m}
  ];
  reduced
]

(* Full reduction for general n - use ζⁿ = 1 *)
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

(* Canonical reduction for power-of-2: use ζ^(n/2) = -1 *)
reduceCanonical[coeffs_List, n_Integer] := Module[{half, result},
  If[!IntegerQ[Log2[n]], Return[coeffs]];  (* Only for power-of-2 *)
  half = n / 2;
  If[Length[coeffs] <= half, Return[PadRight[coeffs, half]]];
  (* ζ^half = -1, so ζ^(half+k) = -ζ^k *)
  result = Take[PadRight[coeffs, n], half];
  Do[
    result[[k]] -= coeffs[[half + k]];
    , {k, 1, Min[half, Length[coeffs] - half]}
  ];
  result
]

(* ============================================ *)
(* CYCLOTOMIC ELEMENT STRUCTURE                 *)
(* ============================================ *)

(* Constructor - normalize coefficients *)
CyclotomicElement[n_Integer, coeffs_List] /; IntegerQ[n] && n > 0 :=
  CyclotomicElement[n, reduceCoeffsFull[coeffs, n]] /; Length[coeffs] != n

(* Accessors *)
CyclotomicOrder[CyclotomicElement[n_, _]] := n
CyclotomicCoeffs[CyclotomicElement[_, coeffs_]] := coeffs

(* Display form *)
Format[CyclotomicElement[n_, coeffs_]] := Module[{terms, ζ},
  terms = Table[
    If[coeffs[[k+1]] == 0, Nothing,
      If[k == 0, coeffs[[1]],
        If[coeffs[[k+1]] == 1, Superscript["ζ", k],
          If[coeffs[[k+1]] == -1, -Superscript["ζ", k],
            coeffs[[k+1]] Superscript["ζ", k]
          ]
        ]
      ]
    ],
    {k, 0, Length[coeffs] - 1}
  ];
  If[terms === {}, 0,
    Row[{Subscript["ℚ", n], "[", Plus @@ terms, "]"}]
  ]
]

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

CyclotomicToComplex[CyclotomicElement[n_, coeffs_]] := Module[{ζ = Exp[2 Pi I / n]},
  Sum[coeffs[[k + 1]] ζ^k, {k, 0, n - 1}]
]

(* ============================================ *)
(* CONSTRUCTORS                                 *)
(* ============================================ *)

CyclotomicFromReal[x_, n_Integer] := CyclotomicElement[n, PadRight[{x}, n]]

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

(* Extract as {Re, Im} pair - both rational! *)
CyclotomicToRational[elem_CyclotomicElement] := {
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

End[];

EndPackage[];
