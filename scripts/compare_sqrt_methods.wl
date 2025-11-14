#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Comparison: Original Pell+Chebyshev vs Fast sqrttrf Refinement *)

Print["=== COMPARING SQRT APPROXIMATION METHODS ===\n"];

(* ========== METHOD 1: Original (Pell + Chebyshev terms) ========== *)

PellSolve[d_] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {u, r}
]

ChebTerm[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x + 1] *
  (ChebyshevU[Floor[k/2], x + 1] - ChebyshevU[Floor[k/2] - 1, x + 1]))

SqrtOriginal[d_, numTerms_] := Module[{x, y, base},
  {x, y} = PellSolve[d];
  base = (x - 1)/y;
  base * (1 + Sum[ChebTerm[x - 1, k], {k, 1, numTerms}])
]

(* ========== METHOD 2: Fast sqrttrf Refinement ========== *)

sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]

nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1]&, n, m2]

(* ========== COMPARISON ========== *)

Print["=== METHOD 1: Original Pell+Chebyshev ==="];
Print["Requires: Pell solution (expensive for large d)"];
Print["Convergence: Very fast once Pell solution is known\n"];

Print["=== METHOD 2: sqrttrf Refinement ==="];
Print["Requires: Only a rough starting approximation n"];
Print["Convergence: Iterative refinement\n"];

Print[StringRepeat["=", 70], "\n"];

CompareConvergence[d_, n0_] := Module[{},
  Print["√", d, " (starting approximation n=", n0, "):\n"];

  Print["METHOD 1: Original Pell+Chebyshev"];
  Print["k\tApproximation\t\t\tError\t\tTerms Rational?"];
  Print[StringRepeat["-", 80]];
  Do[
    Module[{approx, err, x, y, terms, allRational},
      {x, y} = PellSolve[d];
      terms = Table[ChebTerm[x - 1, j], {j, 1, k}];
      allRational = AllTrue[terms, Head[#] === Rational &];
      approx = SqrtOriginal[d, k];
      err = Abs[approx - Sqrt[d]];
      Print[k, "\t", N[approx, 15], "\t", N[err, 5], "\t", If[allRational, "✓", "✗"]];
    ],
    {k, {1, 2, 3, 5, 10}}
  ];
  Print["\n"];

  Print["METHOD 2: sqrttrf (single application, varying m)"];
  Print["m\tApproximation\t\t\tError"];
  Print[StringRepeat["-", 70]];
  Do[
    Module[{approx, err},
      approx = sqrttrf[d, n0, m];
      err = Abs[approx - Sqrt[d]];
      Print[m, "\t", N[approx, 15], "\t", N[err, 5]];
    ],
    {m, {1, 2, 3, 5, 10}}
  ];
  Print["\n"];

  Print["METHOD 2b: nestqrt (m1=3, varying nesting depth)"];
  Print["nest\tApproximation\t\t\tError"];
  Print[StringRepeat["-", 70]];
  Do[
    Module[{approx, err},
      approx = nestqrt[d, n0, {3, nest}];
      err = Abs[approx - Sqrt[d]];
      Print[nest, "\t", N[approx, 15], "\t", N[err, 5]];
    ],
    {nest, {0, 1, 2, 3}}
  ];
  Print["\n"];
];

CompareConvergence[2, 1];
CompareConvergence[5, 2];
CompareConvergence[13, 3];

Print[StringRepeat["=", 70], "\n"];

Print["=== KEY OBSERVATIONS ===\n"];
Print["METHOD 1 (Original):"];
Print["  ✓ All Chebyshev terms are perfectly RATIONAL (at Pell solution)");
Print["  ✓ Extremely fast convergence");
Print["  ✗ Requires solving Pell equation first (expensive)\n"];

Print["METHOD 2 (sqrttrf):"];
Print["  ✓ Works with any starting approximation");
Print["  ✓ Nested version converges EXTREMELY fast (2-3 iterations to machine precision)");
Print["  ? Contains irrational terms (√ in ChebyshevU argument)");
Print["  ✓ No need to solve Pell equation!\n"];

Print["=== INVESTIGATION QUESTION ==="];
Print["Does sqrttrf become rational at specific values of (nn, n)?"];
Print["If so, can we characterize those values?\n"];

(* Test rationality of sqrttrf *)
Print["Testing sqrttrf rationality:\n"];

TestRationality[d_, n_] := Module[{result, m},
  Print["√", d, " with n=", n, ":"];
  Do[
    result = sqrttrf[d, n, m];
    Print["  m=", m, ": ", If[Head[result] === Rational, "✓ RATIONAL", "✗ irrational"],
      " = ", If[Head[result] === Rational, result, N[result, 10]]],
    {m, 1, 3}
  ];
  Print["\n"];
];

(* Test at Pell solution values *)
Module[{x, y},
  {x, y} = PellSolve[2];
  Print["At Pell solution for √2: x=", x, ", y=", y];
  Print["Testing with n = (x-1)/y = ", (x-1)/y, ":\n"];
  TestRationality[2, (x-1)/y];
];

Module[{x, y},
  {x, y} = PellSolve[5];
  Print["At Pell solution for √5: x=", x, ", y=", y];
  Print["Testing with n = (x-1)/y = ", (x-1)/y, ":\n"];
  TestRationality[5, (x-1)/y];
];

Print["=== ANALYSIS COMPLETE ==="];
