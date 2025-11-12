(* ::Package:: *)

(* Square Root Rationalizations via Chebyshev Polynomials and Pell Equations *)

BeginPackage["Orbit`"];

SqrtRationalization::usage = "SqrtRationalization[n] computes a rational approximation to Sqrt[n] using Pell equation solutions and Chebyshev polynomial refinement.

Options:
  Method -> \"Rational\" | \"List\" | \"Expression\"
  Accuracy -> integer (number of Chebyshev terms, default 8)

The method uses the fundamental solution to x² - n·y² = 1, then refines using Chebyshev-based terms.

IMPORTANT: The Chebyshev series yields exact rational results ONLY when evaluated at x-1 where (x,y) is the Pell solution. This is a characterization property - the Pell solution is the unique point where the rationalization is perfectly rational.";

PellSolution::usage = "PellSolution[d] finds the fundamental solution {x, y} to the Pell equation x² - d·y² = 1.

Returns: {x -> value, y -> value}

Uses Wildberger's efficient algorithm from:
https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf";

ChebyshevTerm::usage = "ChebyshevTerm[x, k] computes the k-th term in the Chebyshev-based rational approximation series.

Formula:
  1 / (ChebyshevT[⌈k/2⌉, x+1] · (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1]))

where T is Chebyshev polynomial of the first kind, U is second kind.";

NestedChebyshevSqrt::usage = "NestedChebyshevSqrt[n, {m1, m2}] computes ultra-high precision rational sqrt approximations using nested Chebyshev iterations.

Parameters:
  n   - the number whose square root to approximate
  {m1, m2} - iteration parameters:
    m1 = Chebyshev order per iteration (1, 2, or 3 recommended)
    m2 = number of nesting iterations

Options:
  StartingPoint -> \"Pell\" | \"Crude\" | rational (default: \"Pell\")

Precision scaling:
  - Each iteration roughly squares or cubes the precision (depending on m1)
  - m1=1: ~6x precision per iteration (optimized: 20x faster than general formula)
  - m1=2: ~8x precision per iteration (optimized: 20x faster than general formula)
  - m1=3: ~10x precision per iteration (uses general ChebyshevU formula)

Performance:
  - m1=1 and m1=2 use pre-simplified formulas (no ChebyshevU evaluation)
  - Crossover vs Babylonian method: ~4000 digits
  - Speedup grows with precision: 1.7x at 4k digits → 2.7x at 871k digits

Examples:
  NestedChebyshevSqrt[13, {3, 3}] achieves ~3000 digits in 0.01 seconds
  NestedChebyshevSqrt[13, {1, 7}] achieves ~871k digits in 0.09 seconds
  NestedChebyshevSqrt[13, {1, 10}] achieves ~60 million digits (62M demonstration)

This is the most powerful method for extreme precision, far exceeding continued fractions in speed at high precision.";

Begin["`Private`"];

(* Chebyshev-based term for rational approximation *)
ChebyshevTerm[x_, k_] :=
    1 / (     ChebyshevT[Ceiling[k/2],     x + 1]
          (   ChebyshevU[  Floor[k/2],     x + 1]
            - ChebyshevU[  Floor[k/2] - 1, x + 1]))

(* Sum of Chebyshev terms *)
sqrtTerms[x_, n_] :=
    1 + Sum[ChebyshevTerm[x, j], {j, 1, n}]

(* Held form for symbolic display *)
sqrtTermsHeld[x_, n_] :=
    1 + Sum[HoldForm[#]& @ ChebyshevTerm[x, j], {j, 1, n}]

(* List form *)
sqrtTermsList[x_, n_] :=
    Join[{1}, Table[ChebyshevTerm[x, j], {j, 1, n}]]

(* Pell equation solver - Wildberger's algorithm
   https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf *)
PellSolution[d_] := Module[
  { a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {x -> u, y -> r} ]

(* Main rationalization function *)
SqrtRationalization[n_, OptionsPattern[]] :=
    Module[{sol, acc = OptionValue[Accuracy]},
        sol = PellSolution[n];
        Switch[OptionValue[Method],
            "List",
                {(x - 1) / y, sqrtTermsList[x - 1, acc]} /. sol
            ,
            "Rational",
                (x - 1) / y sqrtTerms[x - 1, acc] /. sol
            ,
            "Expression",
                (x - 1) / y sqrtTermsHeld[x - 1, acc] /. sol
        ]
    ]

Options[SqrtRationalization] = {Method -> "List", Accuracy -> 8}

(* ===================================================================
   NESTED CHEBYSHEV METHODS - Ultra-high precision
   =================================================================== *)

(* OPTIMIZED SPECIALIZATIONS: Pre-simplified formulas for m=1 and m=2
   These eliminate expensive ChebyshevU evaluations and Simplify calls,
   providing ~20x speedup per iteration.

   Derivation: For m=1, ChebyshevU[0,x]=1 and ChebyshevU[2,x]=4x²-1
   simplify externally to eliminate symbolic computation from hot loop.

   Performance: Optimized m=1 achieves 2.7x speedup over Babylonian method
   at 871k digit precision, with 6x convergence rate per iteration.
*)

(* m=1 optimized: features factor of 3 in numerator and denominator *)
sqrttrfOpt1[nn_, n_] := (nn*(3*n^2 + nn))/(n*(n^2 + 3*nn))

(* m=2 optimized: features factor of 6 in numerator *)
sqrttrfOpt2[nn_, n_] := (n^4 + 6*n^2*nn + nn^2)/(4*n*(n^2 + nn))

(* Core Chebyshev-U based single refinement step - with smart dispatch *)
sqrttrf[nn_, n_, 1] := sqrttrfOpt1[nn, n]
sqrttrf[nn_, n_, 2] := sqrttrfOpt2[nn, n]
sqrttrf[nn_, n_, m_] :=
  (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
    ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]] /
    ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

(* Symmetrization step - applies sqrttrf then averages *)
sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]

(* Nested iteration - the power method *)
nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1] &, n, m2]

(* User-facing function with options *)
NestedChebyshevSqrt[n_, {m1_, m2_}, OptionsPattern[]] :=
  Module[{start},
    start = Switch[OptionValue[StartingPoint],
      "Pell",
        Module[{sol = PellSolution[n]},
          (x - 1)/y /. sol
        ],
      "Crude",
        Floor[Sqrt[N[n]]],
      _,
        OptionValue[StartingPoint]
    ];
    nestqrt[n, start, {m1, m2}]
  ]

Options[NestedChebyshevSqrt] = {StartingPoint -> "Pell"}

End[];

EndPackage[];
