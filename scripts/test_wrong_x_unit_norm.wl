#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Test: Where does irrationality come from with wrong x? *)

Print["=== TESTING: IRRATIONALITY SOURCE ===\n"];

(* Pell solver *)
PellSolve[d_] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {u, r}
]

(* Chebyshev term *)
ChebTerm[x_, k_] :=
    1 / (ChebyshevT[Ceiling[k/2], x + 1] *
         (ChebyshevU[Floor[k/2], x + 1] - ChebyshevU[Floor[k/2] - 1, x + 1]))

Print["=== CORRECT PELL SOLUTION ===\n"];

Module[{d = 2, x, y, base, terms},
  {x, y} = PellSolve[d];

  Print["√2: Pell solution x=", x, ", y=", y];
  Print["Verification: x² - d·y² = ", x^2 - d*y^2, " ✓"];
  Print["\nBase: (x-1)/y = ", (x-1)/y, " = ", N[(x-1)/y, 10]];
  Print["  Numerator x-1 = ", x-1, " (integer)"];
  Print["  Denominator y = ", y, " (integer)"];
  Print["  Base is rational: ", Head[(x-1)/y] === Rational];

  Print["\nChebyshev terms at x-1=", x-1, ":");
  terms = Table[ChebTerm[x - 1, k], {k, 1, 5}];
  Do[
    Print["  k=", k, ": ", terms[[k]], " (rational: ", Head[terms[[k]]] === Rational, ")"],
    {k, 1, 5}
  ];

  Print["\n✓ BOTH base AND Chebyshev terms are rational!\n"];
];

Print[StringRepeat["=", 70], "\n"];

Print["=== WRONG x WITH INTEGER y ===\n"];

Module[{d = 2, wrongX = 4, y = 2, norm, base, terms},
  Print["√2: Using WRONG x=", wrongX, " with same y=", y];
  norm = wrongX^2 - d*y^2;
  Print["Norm: x² - d·y² = ", wrongX^2, " - ", d, "·", y^2, " = ", norm];
  Print["  ❌ NOT unit norm!\n"];

  base = (wrongX - 1)/y;
  Print["Base: (x-1)/y = ", base, " = ", N[base, 10]];
  Print["  Base is rational: ", Head[base] === Rational, " ✓"];

  Print["\nChebyshev terms at x-1=", wrongX-1, ":");
  terms = Table[ChebTerm[wrongX - 1, k], {k, 1, 5}];
  Do[
    Print["  k=", k, ": ", terms[[k]], " (rational: ", Head[terms[[k]]] === Rational, ")"],
    {k, 1, 5}
  ];

  Print["\n✓ Chebyshev terms ARE still rational!"];
  Print["✓ Base is rational!");
  Print["❌ But we don't have unit norm, so this doesn't approximate √2 correctly\n"];
];

Print[StringRepeat["=", 70], "\n"];

Print["=== WRONG x WITH UNIT NORM (IRRATIONAL y) ===\n"];

Module[{d = 2, wrongX = 4, y, base, terms},
  Print["√2: Using WRONG x=", wrongX];
  Print["To get unit norm, we need: y = √((x²-1)/d)"];
  y = Sqrt[(wrongX^2 - 1)/d];
  Print["  y = √((", wrongX, "²-1)/", d, ") = √(", wrongX^2-1, "/", d, ") = ", y];
  Print["  y = ", N[y, 15]];
  Print["  y is rational: ", Head[y] === Rational, " ❌ IRRATIONAL!\n"];

  Print["Verification: x² - d·y² = ", Simplify[wrongX^2 - d*y^2], " ✓ unit norm"];

  base = (wrongX - 1)/y;
  Print["\nBase: (x-1)/y = ", (wrongX-1), "/", y, " = ", base];
  Print["  = ", N[base, 15]];
  Print["  Base is rational: ", Head[base] === Rational, " ❌ IRRATIONAL!");
  Print["  ↑↑↑ THIS IS WHERE IRRATIONALITY ENTERS! ↑↑↑\n"];

  Print["Chebyshev terms at x-1=", wrongX-1, ":");
  terms = Table[ChebTerm[wrongX - 1, k], {k, 1, 5}];
  Do[
    Print["  k=", k, ": ", terms[[k]], " (rational: ", Head[terms[[k]]] === Rational, ")"],
    {k, 1, 5}
  ];

  Print["\n✓ Chebyshev terms are STILL rational (they only depend on x)"];
  Print["❌ But base (x-1)/y is IRRATIONAL because y is irrational"];
  Print["❌ Final result = base × (1 + Chebyshev sum) is IRRATIONAL\n"];
];

Print[StringRepeat["=", 70], "\n"];

Print["=== KEY INSIGHT ===\n"];
Print["The Chebyshev terms ONLY depend on x (or x-1).");
Print["They are rational whenever x is an integer!\n"];
Print["The irrationality comes from y = √((x²-1)/d) when x is not a Pell solution.");
Print["The base (x-1)/y becomes irrational when y is irrational.\n"];
Print["The Pell solution is special because it's the unique INTEGER pair (x,y)");
Print["satisfying x² - d·y² = 1, making BOTH x and y rational (integers).\n");

Print["=== TESTING WITH ANOTHER d ===\n"];

Module[{d = 5, correctX, correctY, wrongX, yForWrong},
  {correctX, correctY} = PellSolve[d];
  wrongX = 10;
  yForWrong = Sqrt[(wrongX^2 - 1)/d];

  Print["√5: Correct Pell: x=", correctX, ", y=", correctY];
  Print["    y is integer: ", IntegerQ[correctY], " ✓"];
  Print["    Base (x-1)/y = ", (correctX-1)/correctY, " is rational ✓\n"];

  Print["√5: Wrong x=", wrongX];
  Print["    To get unit norm: y = ", yForWrong];
  Print["    y = ", N[yForWrong, 15]];
  Print["    y is integer: ", IntegerQ[yForWrong], " ❌"];
  Print["    Base (x-1)/y = ", N[(wrongX-1)/yForWrong, 15], " is irrational ❌"];
];

Print["\n=== CONCLUSION ==="];
Print["Chebyshev polynomials are innocent! They produce rational terms for ANY integer x.");
Print["The irrationality enters through y when maintaining unit norm with non-Pell x.\n");

Print["=== TEST COMPLETE ==="];
