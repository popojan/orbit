#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Direct test of Chebyshev convergence - no package loading *)

Print["=== DIRECT CHEBYSHEV CONVERGENCE TEST ===\n"];

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

(* Test convergence for sqrt(d) *)
TestConvergence[d_] := Module[{x, y, base, approx, actual},
  {x, y} = PellSolve[d];
  base = (x - 1)/y;
  actual = Sqrt[d];

  Print["√", d, ": Pell solution x=", x, ", y=", y];
  Print["Base (x-1)/y = ", base, " = ", N[base, 15]];
  Print["\nConvergence with increasing Chebyshev terms:"];
  Print["k\tApproximation\t\t\tError"];
  Print[StringRepeat["-", 70]];

  Do[
    approx = base * (1 + Sum[ChebTerm[x - 1, j], {j, 1, k}]);
    Print[k, "\t", N[approx, 15], "\t", N[Abs[approx - actual], 5]],
    {k, 0, 10}
  ];
  Print["\n"];
]

(* Test several square roots *)
Do[TestConvergence[d], {d, {2, 3, 5, 7, 13}}];

Print["=== ANALYZING INDIVIDUAL TERMS ===\n"];

(* Look at individual Chebyshev terms for √2 *)
Module[{x, y, terms},
  {x, y} = PellSolve[2];
  Print["√2: x=", x, ", y=", y, ", x-1=", x-1];
  Print["\nIndividual Chebyshev terms at x-1=", x-1, ":\n"];
  Print["k\tTerm value\t\tRational?"];
  Print[StringRepeat["-", 60]];

  terms = Table[ChebTerm[x - 1, k], {k, 1, 10}];
  Do[
    Print[k, "\t", N[terms[[k]], 10], "\t",
      If[Head[terms[[k]]] === Rational, "✓ YES", "no"]],
    {k, 1, 10}
  ];

  Print["\nSum of first 10 terms: ", N[Total[terms], 15]];
  Print["All terms rational? ", AllTrue[terms, Head[#] === Rational &]];
]

Print["\n"];

Print["=== TESTING NON-PELL VALUES ===\n"];

(* What happens if we use x-1 that's NOT from Pell solution? *)
Module[{d = 2, x, y, wrongX},
  {x, y} = PellSolve[d];
  wrongX = x - 1 + 1;  (* Off by 1 from Pell solution *)

  Print["√2: Correct x-1 = ", x-1, " (from Pell)"];
  Print["Testing with wrong x-1 = ", wrongX, " (off by 1)\n"];

  Print["Terms with CORRECT x-1:"];
  Do[
    Print["k=", k, ": ", ChebTerm[x - 1, k]],
    {k, 1, 3}
  ];

  Print["\nTerms with WRONG x-1:"];
  Do[
    Print["k=", k, ": ", ChebTerm[wrongX, k]],
    {k, 1, 3}
  ];
]

Print["\n=== TEST COMPLETE ==="];
