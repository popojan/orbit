#!/usr/bin/env wolframscript
(* Comprehensive sqrt rationalization benchmark *)

Print["=== COMPREHENSIVE SQRT BENCHMARK ==="];
Print[""];

PellSolve[d_] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {u, r}
]

(* Original Chebyshev terms *)
ChebTerm[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x + 1] *
  (ChebyshevU[Floor[k/2], x + 1] - ChebyshevU[Floor[k/2] - 1, x + 1]))

EgyptianMethod[d_, numTerms_] := Module[{x, y, base},
  {x, y} = PellSolve[d];
  base = (x - 1)/y;
  base * (1 + Sum[ChebTerm[x - 1, k], {k, 1, numTerms}])
]

(* sqrttrf *)
sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/
  ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]
nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1]&, n, m2]

QuadError[n_, approx_] := Log[10, Abs[n - approx^2]]

ComprehensiveBenchmark[d_, targetDigits_] := Module[{
    pellTime, x, y, pellBase, crude,
    mathTime, egyptTime, nestedPellTime, nestedCrudeTime,
    mathResult, egyptResult, nestedPellResult, nestedCrudeResult,
    egyptIter, nestedIter
  },

  Print["=== sqrt(", d, ") to ~", targetDigits, " digits ==="];
  Print[""];

  (* Solve Pell equation *)
  pellTime = AbsoluteTiming[
    {x, y} = PellSolve[d];
    pellBase = (x - 1)/y;
  ][[1]];
  crude = Floor[Sqrt[d]];

  Print["Pell solution: x=", x, ", y=", y];
  Print["  Pell solve time: ", N[pellTime, 4], "s"];
  Print["  Pell base: ", N[pellBase, 10]];
  Print["  Crude start: ", crude];
  Print[""];

  (* Mathematica Rationalize *)
  Print["METHOD 1: Mathematica Rationalize"];
  mathTime = AbsoluteTiming[
    mathResult = Rationalize[Sqrt[N[d, targetDigits + 100]], 10^(-targetDigits)]
  ][[1]];
  Print["  Time: ", N[mathTime, 4], "s"];
  Print["  Digits: ", Floor[-QuadError[d, mathResult]]];
  Print[""];

  (* Egyptian fraction (original method) *)
  Print["METHOD 2: Egyptian fraction (Pell + Chebyshev sum)"];
  egyptIter = Ceiling[targetDigits / 7]; (* rough estimate *)
  egyptTime = AbsoluteTiming[
    egyptResult = EgyptianMethod[d, egyptIter]
  ][[1]];
  Print["  Time (incl Pell): ", N[egyptTime + pellTime, 4], "s"];
  Print["  Terms used: ", egyptIter];
  Print["  Digits: ", Floor[-QuadError[d, egyptResult]]];
  Print[""];

  (* Nested sqrttrf WITH Pell base *)
  Print["METHOD 3: Nested sqrttrf (WITH Pell base)"];
  nestedIter = Max[3, Ceiling[Log[10, targetDigits]]];
  nestedPellTime = AbsoluteTiming[
    nestedPellResult = nestqrt[d, pellBase, {3, nestedIter}]
  ][[1]];
  Print["  Time (incl Pell): ", N[nestedPellTime + pellTime, 4], "s"];
  Print["  Time (excl Pell): ", N[nestedPellTime, 4], "s"];
  Print["  Iterations: ", nestedIter];
  Print["  Digits: ", Floor[-QuadError[d, nestedPellResult]]];
  Print[""];

  (* Nested sqrttrf WITHOUT Pell (crude start) *)
  Print["METHOD 4: Nested sqrttrf (WITHOUT Pell, crude start)"];
  nestedCrudeTime = AbsoluteTiming[
    nestedCrudeResult = nestqrt[d, crude, {3, nestedIter + 1}]
  ][[1]];
  Print["  Time (no Pell): ", N[nestedCrudeTime, 4], "s"];
  Print["  Iterations: ", nestedIter + 1];
  Print["  Digits: ", Floor[-QuadError[d, nestedCrudeResult]]];
  Print[""];

  Print["SPEEDUP vs Mathematica:"];
  Print["  Egyptian (with Pell): ", N[mathTime / (egyptTime + pellTime), 3], "x"];
  Print["  Nested (with Pell): ", N[mathTime / (nestedPellTime + pellTime), 3], "x"];
  Print["  Nested (excl Pell calc): ", N[mathTime / nestedPellTime, 3], "x"];
  Print["  Nested (no Pell needed): ", N[mathTime / nestedCrudeTime, 3], "x"];
  Print[""];

  Print[StringRepeat["=", 70]];
  Print[""];
];

(* Test different scenarios *)
ComprehensiveBenchmark[13, 10000];
ComprehensiveBenchmark[2, 10000];

Print["=== KEY INSIGHTS ==="];
Print["1. Pell solving can be significant overhead for some d");
Print["2. Nested WITHOUT Pell still very competitive (no Pell needed!)");
Print["3. Egyptian method (sum) vs nested have different convergence");
Print["4. For repeated use, Pell cost amortizes across many precision levels"];
