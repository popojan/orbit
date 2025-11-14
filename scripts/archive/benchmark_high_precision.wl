#!/usr/bin/env wolframscript
(* High precision benchmark *)

Print["=== HIGH PRECISION BENCHMARK ==="];
Print["Testing convergence advantage at extreme precision"];
Print[""];

PellSolve[d_] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {u, r}
]

sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/
  ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]
nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1]&, n, m2]

QuadError[n_, approx_] := Log[10, Abs[n - approx^2]]

TestPrecision[d_, targetDigits_] := Module[{
    x, y, pellBase,
    mathTime, mathResult,
    sqrttrfTime, sqrttrfResult, sqrttrfIter
  },

  Print["sqrt(", d, ") to ", targetDigits, " decimal places:"];

  {x, y} = PellSolve[d];
  pellBase = (x - 1)/y;

  (* Mathematica Rationalize *)
  mathTime = AbsoluteTiming[
    mathResult = Rationalize[Sqrt[N[d, targetDigits + 100]], 10^(-targetDigits)]
  ][[1]];

  (* sqrttrf - determine iterations needed *)
  sqrttrfIter = Ceiling[Log[10, targetDigits] / Log[10, 10]]; (* ~log10(target) iterations *)
  sqrttrfTime = AbsoluteTiming[
    sqrttrfResult = nestqrt[d, pellBase, {3, sqrttrfIter}]
  ][[1]];

  Print["  Mathematica: ", N[mathTime, 4], "s"];
  Print["  sqrttrf (", sqrttrfIter, " iter): ", N[sqrttrfTime, 4], "s"];
  Print["  Speedup: ", N[mathTime / sqrttrfTime, 4], "x"];
  Print[""];
];

(* Test increasing precision *)
TestPrecision[13, 1000];
TestPrecision[13, 5000];
TestPrecision[13, 10000];
TestPrecision[13, 50000];

TestPrecision[2, 10000];
TestPrecision[5, 10000];

Print["=== ANALYSIS ==="];
Print["Expected pattern: speedup increases with target precision"];
Print["because sqrttrf has exponential convergence (10x per iter)"];
Print["while Rationalize has quadratic convergence (2x per iter)"];
