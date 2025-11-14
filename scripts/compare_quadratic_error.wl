#!/usr/bin/env wolframscript
(* Comparison using QUADRATIC ERROR *)

Print["=== SQRT METHODS: QUADRATIC ERROR COMPARISON ==="];
Print[""];

(* Pell solver *)
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

(* Fast sqrttrf refinement *)
sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/
  ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]

nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1]&, n, m2]

(* Signed quadratic error *)
QuadError[n_, approx_] := Log[10, n - approx^2]

CompareQuadraticError[d_, n0_] := Module[{},
  Print["=== sqrt(", d, ") starting from n=", n0, " ==="];
  Print[""];

  Print["METHOD 1: Pell+Chebyshev (all terms rational)"];
  Print["k", "\t", "Log10(d - approx^2)", "\t", "~Decimal places"];
  Print[StringRepeat["-", 60]];
  Do[
    Module[{approx, qerr},
      approx = SqrtOriginal[d, k];
      qerr = QuadError[d, approx];
      Print[k, "\t", N[qerr, 8], "\t\t\t", N[-qerr, 5]];
    ],
    {k, {1, 2, 3, 5, 10}}
  ];
  Print[""];

  Print["METHOD 2: sqrttrf (single step, varying m)"];
  Print["m", "\t", "Log10(d - approx^2)", "\t", "~Decimal places"];
  Print[StringRepeat["-", 60]];
  Do[
    Module[{approx, qerr},
      approx = sqrttrf[d, n0, m];
      qerr = QuadError[d, approx];
      Print[m, "\t", N[qerr, 8], "\t\t\t", N[-qerr, 5]];
    ],
    {m, {1, 2, 3, 5, 10}}
  ];
  Print[""];

  Print["METHOD 2b: nestqrt (m1=3, varying nest depth)"];
  Print["nest", "\t", "Log10(d - approx^2)", "\t", "~Decimal places"];
  Print[StringRepeat["-", 60]];
  Do[
    Module[{approx, qerr},
      approx = nestqrt[d, n0, {3, nest}];
      qerr = QuadError[d, approx];
      Print[nest, "\t", N[qerr, 8], "\t\t\t", N[-qerr, 5]];
    ],
    {nest, {0, 1, 2, 3, 4}}
  ];
  Print[""];
  Print[StringRepeat["=", 70]];
  Print[""];
];

(* Test multiple values *)
CompareQuadraticError[2, 1];
CompareQuadraticError[5, 2];
CompareQuadraticError[13, 3];

Print["=== ANALYSIS COMPLETE ==="];
