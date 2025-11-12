#!/usr/bin/env wolframscript
(* Test: Combining Pell solution with sqrttrf refinement *)

Print["=== COMBINING PELL + sqrttrf REFINEMENT ==="];
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

(* Original Chebyshev term *)
ChebTerm[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x + 1] *
  (ChebyshevU[Floor[k/2], x + 1] - ChebyshevU[Floor[k/2] - 1, x + 1]))

SqrtPellCheb[d_, numTerms_] := Module[{x, y, base},
  {x, y} = PellSolve[d];
  base = (x - 1)/y;
  base * (1 + Sum[ChebTerm[x - 1, k], {k, 1, numTerms}])
]

(* sqrttrf refinement *)
sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/
  ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]

nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1]&, n, m2]

(* Quadratic error *)
QuadError[n_, approx_] := Log[10, Abs[n - approx^2]]

Print["HYPOTHESIS: Starting sqrttrf from Pell-derived base gives best of both worlds"];
Print[""];

TestCombination[d_] := Module[{x, y, pellBase, crude},
  {x, y} = PellSolve[d];
  pellBase = (x - 1)/y;
  crude = Floor[Sqrt[d]];

  Print["=== sqrt(", d, ") ==="];
  Print["Pell solution: x=", x, ", y=", y];
  Print["Pell base: (x-1)/y = ", pellBase, " = ", N[pellBase, 15]];
  Print["Crude approximation: ", crude];
  Print[""];

  Print["COMPARISON 1: Original Pell+Chebyshev"];
  Print["k\tLog10|d - approx^2|\tDecimal places"];
  Print[StringRepeat["-", 60]];
  Do[
    Module[{approx, qerr},
      approx = SqrtPellCheb[d, k];
      qerr = QuadError[d, approx];
      Print[k, "\t", N[qerr, 8], "\t\t", N[-qerr, 5]];
    ],
    {k, {1, 3, 5, 10}}
  ];
  Print[""];

  Print["COMPARISON 2: sqrttrf from CRUDE start"];
  Print["m\tLog10|d - approx^2|\tDecimal places"];
  Print[StringRepeat["-", 60]];
  Do[
    Module[{approx, qerr},
      approx = sqrttrf[d, crude, m];
      qerr = QuadError[d, approx];
      Print[m, "\t", N[qerr, 8], "\t\t", N[-qerr, 5]];
    ],
    {m, {1, 3, 5, 10}}
  ];
  Print[""];

  Print["COMPARISON 3: sqrttrf from PELL BASE start"];
  Print["m\tLog10|d - approx^2|\tDecimal places"];
  Print[StringRepeat["-", 60]];
  Do[
    Module[{approx, qerr},
      approx = sqrttrf[d, pellBase, m];
      qerr = QuadError[d, approx];
      Print[m, "\t", N[qerr, 8], "\t\t", N[-qerr, 5]];
    ],
    {m, {1, 3, 5, 10}}
  ];
  Print[""];

  Print["COMPARISON 4: NESTED from Pell base (m1=3)"];
  Print["nest\tLog10|d - approx^2|\tDecimal places"];
  Print[StringRepeat["-", 60]];
  Do[
    Module[{approx, qerr},
      approx = nestqrt[d, pellBase, {3, nest}];
      qerr = QuadError[d, approx];
      Print[nest, "\t", N[qerr, 8], "\t\t", N[-qerr, 5]];
    ],
    {nest, {0, 1, 2, 3}}
  ];
  Print[""];

  Print["COMPARISON 5: NESTED from crude start (m1=3)"];
  Print["nest\tLog10|d - approx^2|\tDecimal places"];
  Print[StringRepeat["-", 60]];
  Do[
    Module[{approx, qerr},
      approx = nestqrt[d, crude, {3, nest}];
      qerr = QuadError[d, approx];
      Print[nest, "\t", N[qerr, 8], "\t\t", N[-qerr, 5]];
    ],
    {nest, {0, 1, 2, 3}}
  ];
  Print[""];

  Print[StringRepeat["=", 70]];
  Print[""];
];

TestCombination[2];
TestCombination[5];
TestCombination[13];

Print["=== KEY FINDING ==="];
Print["Does starting from Pell base improve sqrttrf convergence?"];
Print["Or does sqrttrf converge so fast that the starting point doesn't matter?"];
Print[""];

Print["=== TEST COMPLETE ==="];
