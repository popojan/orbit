#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Test Square Root Rationalizations module *)

Print["=== TESTING SQUARE ROOT RATIONALIZATIONS ===\n"];

(* Load the paclet *)
SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
<< Orbit`

Print["=== PELL EQUATION SOLVER ===\n"];

(* Test Pell solver *)
TestPell[d_] := Module[{sol, x, y},
  Print["d = ", d];
  sol = PellSolution[d];
  {x, y} = {x, y} /. sol;
  Print["  Solution: x = ", x, ", y = ", y];
  Print["  Verification: x² - d·y² = ", x^2 - d*y^2];
  Print["  √", d, " ≈ x/y = ", N[x/y, 10]];
  Print["  Actual √", d, " = ", N[Sqrt[d], 10]];
  Print["  Error: ", N[Abs[x/y - Sqrt[d]], 5], "\n"];
];

Do[TestPell[d], {d, {2, 3, 5, 7, 13, 17}}];

Print["=== CHEBYSHEV TERM FUNCTION ===\n"];

Print["Testing ChebyshevTerm for small k with x = 2:\n"];
Do[
  Print["k = ", k, ": ", N[ChebyshevTerm[2, k], 8]],
  {k, 1, 6}
];
Print["\n"];

Print["=== SQRT RATIONALIZATION - METHOD: List ===\n"];

TestSqrtList[n_] := Module[{result, base, terms, approx},
  result = SqrtRationalization[n, Method -> "List", Accuracy -> 6];
  base = result[[1]];
  terms = result[[2]];
  approx = base * Total[terms];

  Print["√", n, ":"];
  Print["  Base (x-1)/y: ", base];
  Print["  Terms: ", terms];
  Print["  Approximation: ", N[approx, 12]];
  Print["  Actual: ", N[Sqrt[n], 12]];
  Print["  Error: ", N[Abs[approx - Sqrt[n]], 5], "\n"];
];

Do[TestSqrtList[n], {n, {2, 5, 13}}];

Print["=== SQRT RATIONALIZATION - METHOD: Rational ===\n"];

TestSqrtRational[n_] := Module[{approx},
  approx = SqrtRationalization[n, Method -> "Rational", Accuracy -> 8];

  Print["√", n, ":"];
  Print["  Rational: ", approx];
  Print["  Decimal: ", N[approx, 15]];
  Print["  Actual: ", N[Sqrt[n], 15]];
  Print["  Error: ", N[Abs[approx - Sqrt[n]], 5], "\n"];
];

Do[TestSqrtRational[n], {n, {2, 3, 5}}];

Print["=== ACCURACY COMPARISON ===\n"];

CompareAccuracy[n_] := Module[{},
  Print["√", n, " with varying accuracy:\n"];
  Print["Acc\tApproximation\t\tError"];
  Print[StringRepeat["-", 60]];
  Do[
    Module[{approx, err},
      approx = SqrtRationalization[n, Method -> "Rational", Accuracy -> acc];
      err = Abs[approx - Sqrt[n]];
      Print[acc, "\t", N[approx, 10], "\t", N[err, 5]];
    ],
    {acc, {2, 4, 6, 8, 10}}
  ];
  Print["\n"];
];

CompareAccuracy[7];

Print["=== GOLDEN RATIO CONNECTION ===\n"];

(* √5 is related to golden ratio: φ = (1 + √5)/2 *)
Module[{sqrt5, phi, approx},
  sqrt5 = SqrtRationalization[5, Method -> "Rational", Accuracy -> 10];
  phi = (1 + sqrt5)/2;
  approx = (1 + Sqrt[5])/2;

  Print["√5 approximation: ", N[sqrt5, 15]];
  Print["Golden ratio φ = (1 + √5)/2: ", N[phi, 15]];
  Print["Actual φ: ", N[approx, 15]];
  Print["Error: ", N[Abs[phi - approx], 5]];
  Print["\n"];
];

Print["=== METHOD: Expression (Symbolic) ===\n"];

(* Show symbolic form *)
Print["√2 with held Chebyshev terms:\n"];
expr = SqrtRationalization[2, Method -> "Expression", Accuracy -> 3];
Print[expr];
Print["\n"];

Print["=== VERIFICATION: ALL METHODS AGREE ===\n"];

VerifyMethods[n_] := Module[{list, rat, expr, listVal, exprVal},
  list = SqrtRationalization[n, Method -> "List", Accuracy -> 6];
  rat = SqrtRationalization[n, Method -> "Rational", Accuracy -> 6];
  expr = SqrtRationalization[n, Method -> "Expression", Accuracy -> 6];

  listVal = list[[1]] * Total[list[[2]]];
  exprVal = ReleaseHold[expr];

  Print["√", n, ":"];
  Print["  List method: ", N[listVal, 12]];
  Print["  Rational method: ", N[rat, 12]];
  Print["  Expression method: ", N[exprVal, 12]];
  Print["  All agree: ", N[listVal] == N[rat] && N[rat] == N[exprVal]];
  Print["\n"];
];

Do[VerifyMethods[n], {n, {2, 3, 5}}];

Print["=== TESTS COMPLETE ==="];
