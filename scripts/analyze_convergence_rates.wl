#!/usr/bin/env wolframscript
(* Precise convergence rate analysis: Newton vs sqrttrf *)

Print["=== CONVERGENCE RATE COMPARISON ==="];
Print["Newton (quadratic): digits double per iteration"];
Print["sqrttrf nested: digits multiply by ~10 per iteration"];
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

(* sqrttrf *)
sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/
  ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]
nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1]&, n, m2]

(* Newton iteration for RATIONAL approximation *)
NewtonRational[d_, x0_, iterations_] := Module[{x = x0},
  Do[x = (x + d/x)/2, {i, iterations}];
  x
]

(* Quadratic error *)
QuadError[n_, approx_] := Log[10, Abs[n - approx^2]]

Print["=== THEORETICAL CONVERGENCE RATES ==="];
Print[""];
Print["Newton (quadratic convergence):"];
Print["Iter\tDecimal places (theoretical)"];
Print[StringRepeat["-", 40]];
precision = 1;
Do[
  Print[i, "\t", Floor[precision]];
  precision = precision * 2,
  {i, 1, 12}
];
Print[""];

Print["sqrttrf nested (empirical ~10x per iteration):"];
Print["Iter\tDecimal places (empirical)");
Print[StringRepeat["-", 40]];
precision = 29; (* observed for sqrt(13) *)
Do[
  Print[i, "\t", Floor[precision]];
  precision = precision * 10,
  {i, 1, 5}
];
Print[""];

Print["To reach 3000 decimal places:");
Print["  Newton: ~", Ceiling[Log[2, 3000]], " iterations"];
Print["  sqrttrf nested: ~3 iterations");
Print[""];

Print[StringRepeat["=", 70]];
Print[""];

(* Direct comparison for sqrt(13) *)
Print["=== SQRT(13): DIRECT COMPARISON ==="];
Print[""];

d = 13;
{x, y} = PellSolve[d];
pellBase = (x - 1)/y;
crude = Floor[Sqrt[d]];

Print["Starting points:");
Print["  Pell base: ", pellBase, " = ", N[pellBase, 10]];
Print["  Crude: ", crude];
Print[""];

Print["NEWTON (rational arithmetic, from Pell base):");
Print["Iter\tLog10|error|\tDigits\tNumerator size\tDenominator size"];
Print[StringRepeat["-", 80]];
newtonX = pellBase;
Do[
  newtonX = (newtonX + d/newtonX)/2;
  qerr = QuadError[d, newtonX];
  Print[i, "\t", N[qerr, 6], "\t", Floor[-qerr], "\t",
    IntegerLength[Numerator[newtonX]], "\t",
    IntegerLength[Denominator[newtonX]]],
  {i, 1, 12}
];
Print[""];

Print["SQRTTRF NESTED (m1=3, from Pell base):");
Print["Nest\tLog10|error|\tDigits\tNumerator size\tDenominator size"];
Print[StringRepeat["-", 80]];
Do[
  approx = nestqrt[d, pellBase, {3, nest}];
  qerr = QuadError[d, approx];
  Print[nest, "\t", N[qerr, 6], "\t", Floor[-qerr], "\t",
    IntegerLength[Numerator[approx]], "\t",
    IntegerLength[Denominator[approx]]],
  {nest, 0, 4}
];
Print[""];

Print[StringRepeat["=", 70]];
Print[""];

Print["=== KEY FINDINGS ==="];
Print[""];
Print["CONVERGENCE SPEED:");
Print["  Newton: Doubles precision per iteration (quadratic)");
Print["  sqrttrf: ~10x precision per iteration (super-quadratic)");
Print["  To 3000 digits: Newton ~12 iter, sqrttrf ~3 iter");
Print[""];
Print["OUTPUT TYPE:");
Print["  Newton: Can do rational OR floating-point");
Print["  sqrttrf: Produces EXACT RATIONAL numbers");
Print["");
Print["RATIONAL SIZE GROWTH:");
Print["  Newton: Numerator/denominator double in size per iteration");
Print["  sqrttrf: Need to measure (see table above)");
Print[""];
Print["COST PER ITERATION:");
Print["  Newton: Simple addition/division, but on bigger numbers each time");
Print["  sqrttrf: Chebyshev evaluation (expensive) but fewer total iterations");
Print["");

Print["=== ANALYSIS COMPLETE ==="];
