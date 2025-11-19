#!/usr/bin/env wolframscript
(* ::Package:: *)

(*
  Algebraic Proof Attempt: Egypt-Chebyshev Equivalence

  Goal: Prove that for all x, j:

    FactorialTerm[x,j] = ChebyshevTerm[x,j]

  Equivalently:

    1/(1 + Sum[2^(i-1) x^i (j+i)!/((j-i)!(2i)!), {i,1,j}])
    =
    1/(T_{⌈j/2⌉}(x+1) · (U_{⌊j/2⌋}(x+1) - U_{⌊j/2⌋-1}(x+1)))

  Strategy:
    1. Verify small cases (j=1,2,3,4) symbolically
    2. Look for patterns in expansions
    3. Attempt inductive proof
    4. Search for generating function connection

  See: docs/egypt-chebyshev-equivalence.md
*)

Print["="*70];
Print["Egypt-Chebyshev Equivalence - Algebraic Proof Attempt"];
Print["="*70];
Print[];

(* Helper: Expand factorial term symbolically *)
expandFactorialTerm[x_, j_] := Module[{sum},
  sum = Sum[2^(i-1) * x^i * Factorial[j+i] / (Factorial[j-i] * Factorial[2*i]), {i, 1, j}];
  1 / (1 + sum) // Simplify
]

(* Helper: Expand Chebyshev term symbolically *)
expandChebyshevTerm[x_, j_] := Module[{c, f, t, u0, u1, denom},
  c = Ceiling[j/2];
  f = Floor[j/2];
  t = ChebyshevT[c, x + 1];
  u0 = ChebyshevU[f, x + 1];
  u1 = If[f >= 1, ChebyshevU[f - 1, x + 1], 0];
  denom = t * (u0 - u1);
  1 / denom // Simplify
]

(* Verify and display small cases *)
Print["CASE-BY-CASE VERIFICATION"];
Print["="*70];
Print[];

Do[
  Print["Case j=", j];
  Print[StringPadRight["", 70, "-"]];
  Print[];

  (* Factorial formula *)
  Module[{fac, facExpanded, facSimplified},
    Print["Factorial formula:"];
    fac = 1 / (1 + Sum[2^(i-1) * x^i * Factorial[j+i] / (Factorial[j-i] * Factorial[2*i]), {i, 1, j}]);
    Print["  Raw: ", fac];

    facExpanded = expandFactorialTerm[x, j];
    Print["  Simplified: ", facExpanded];
    Print[];
  ];

  (* Chebyshev formula *)
  Module[{c, f, cheb, chebExpanded},
    c = Ceiling[j/2];
    f = Floor[j/2];
    Print["Chebyshev formula (⌈j/2⌉=", c, ", ⌊j/2⌋=", f, "):"];

    cheb = 1 / (ChebyshevT[c, x+1] * (ChebyshevU[f, x+1] - ChebyshevU[f-1, x+1]));
    Print["  Raw: ", cheb];

    chebExpanded = expandChebyshevTerm[x, j];
    Print["  Expanded: ", chebExpanded];
    Print[];
  ];

  (* Test equality *)
  Module[{fac, cheb, diff},
    fac = expandFactorialTerm[x, j];
    cheb = expandChebyshevTerm[x, j];
    diff = Simplify[fac - cheb];

    Print["Equality test:"];
    Print["  Difference: ", diff];
    Print["  Equal? ", diff == 0];
    Print[];
  ];

  Print[];
  ,
  {j, 1, 5}
];

Print["="*70];
Print[];

(* Detailed expansion for j=1 *)
Print["DETAILED EXPANSION: j=1"];
Print["="*70];
Print[];

Print["Factorial side:"];
Print["  i=1: 2^0 · x · 2!/(0!·2!) = 1·x·2/2 = x"];
Print["  Sum: 1 + x"];
Print["  Result: 1/(1+x)"];
Print[];

Print["Chebyshev side:"];
Print["  ⌈1/2⌉=1, ⌊1/2⌋=0"];
Print["  T₁(y) = y"];
Print["  U₀(y) = 1, U₋₁(y) = 0"];
Print["  Denominator: (x+1)·(1-0) = x+1"];
Print["  Result: 1/(x+1)"];
Print[];

Print["✓ EQUAL for j=1"];
Print[];
Print["="*70];
Print[];

(* Detailed expansion for j=2 *)
Print["DETAILED EXPANSION: j=2"];
Print["="*70];
Print[];

Print["Factorial side:"];
Print["  i=1: 2^0 · x · 3!/(1!·2!) = x·6/2 = 3x"];
Print["  i=2: 2^1 · x² · 4!/(0!·4!) = 2x²·24/24 = 2x²"];
Print["  Sum: 1 + 3x + 2x²"];
Print["  Result: 1/(1 + 3x + 2x²)"];
Print[];

Print["Chebyshev side:"];
Print["  ⌈2/2⌉=1, ⌊2/2⌋=1"];
Print["  T₁(y) = y"];
Print["  U₁(y) = 2y, U₀(y) = 1"];
Print["  Denominator: (x+1)·(2(x+1)-1) = (x+1)(2x+1)"];
Print["  Expand: 2x² + x + 2x + 1 = 2x² + 3x + 1"];
Print["  Result: 1/(2x² + 3x + 1)"];
Print[];

Print["✓ EQUAL for j=2"];
Print[];
Print["="*70];
Print[];

(* Pattern analysis *)
Print["PATTERN ANALYSIS"];
Print["="*70];
Print[];

Print["Observations:"];
Print["  1. Both formulas produce rational functions in x"];
Print["  2. Denominators are polynomials of degree ⌊j/2⌋ + ⌈j/2⌉"];
Print["  3. For j=1: degree 1 (linear)"];
Print["  4. For j=2: degree 2 (quadratic)"];
Print["  5. Coefficients match exactly when expanded"];
Print[];

Print["Key question: Why do factorials = Chebyshev polynomials?"];
Print[];

Print["Possible approaches:"];
Print["  A. Generating function for factorial sum"];
Print["  B. Known Chebyshev identity linking to binomial coefficients"];
Print["  C. Induction on j (if pattern holds)"];
Print["  D. Connection via Pell equation (x² - ny² = 1 structure)"];
Print[];

Print["="*70];
Print[];

(* Generate polynomial coefficients for pattern matching *)
Print["COEFFICIENT ANALYSIS"];
Print["="*70];
Print[];

Do[
  Module[{fac, cheb, facPoly, chebPoly, facCoeffs, chebCoeffs},
    fac = expandFactorialTerm[x, j];
    cheb = expandChebyshevTerm[x, j];

    (* Extract denominator polynomials *)
    facPoly = 1/fac // Simplify;
    chebPoly = 1/cheb // Simplify;

    facCoeffs = CoefficientList[facPoly, x];
    chebCoeffs = CoefficientList[chebPoly, x];

    Print["j=", j, ":"];
    Print["  Factorial coefficients: ", facCoeffs];
    Print["  Chebyshev coefficients: ", chebCoeffs];
    Print["  Match? ", facCoeffs == chebCoeffs];
    Print[];
  ],
  {j, 1, 5}
];

Print["="*70];
Print["Analysis complete. Next steps:"];
Print["  1. Search literature for known Chebyshev-factorial identities"];
Print["  2. Attempt generating function proof"];
Print["  3. Explore connection to Pell equation structure"];
Print["="*70];
