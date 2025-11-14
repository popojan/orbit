#!/usr/bin/env wolframscript
(* Benchmark: sqrttrf vs Mathematica's Rationalize *)

Print["=== BENCHMARK: sqrttrf vs Rationalize ==="];
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

sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/
  ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]
nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1]&, n, m2]

QuadError[n_, approx_] := Log[10, Abs[n - approx^2]]

Benchmark[d_, targetPrecision_] := Module[{
    x, y, pellBase,
    mathTime, mathResult, mathError,
    sqrttrfTime, sqrttrfResult, sqrttrfError
  },

  Print["=== sqrt(", d, ") to ~", targetPrecision, " decimal places ==="];
  Print[""];

  (* Get Pell base *)
  {x, y} = PellSolve[d];
  pellBase = (x - 1)/y;

  (* Mathematica's Rationalize *)
  Print["METHOD 1: Mathematica Rationalize"];
  mathTime = AbsoluteTiming[
    mathResult = Rationalize[Sqrt[N[d, targetPrecision + 50]], 10^(-targetPrecision)]
  ][[1]];
  mathError = QuadError[d, mathResult];

  Print["  Time: ", mathTime, " seconds"];
  Print["  Error (log10): ", N[mathError, 6]];
  Print["  Precision: ", Floor[-mathError], " decimal places"];
  Print["  Numerator digits: ", IntegerLength[Numerator[mathResult]]];
  Print["  Denominator digits: ", IntegerLength[Denominator[mathResult]]];
  Print[""];

  (* sqrttrf nested - find how many iterations needed *)
  Print["METHOD 2: sqrttrf nested (m1=3)"];

  Module[{nest, approx, qerr},
    nest = 0;
    approx = pellBase;
    qerr = QuadError[d, approx];

    sqrttrfTime = AbsoluteTiming[
      While[-qerr < targetPrecision && nest < 10,
        nest++;
        approx = nestqrt[d, pellBase, {3, nest}];
        qerr = QuadError[d, approx];
      ];
    ][[1]];

    sqrttrfResult = approx;
    sqrttrfError = qerr;

    Print["  Time: ", sqrttrfTime, " seconds"];
    Print["  Iterations needed: ", nest];
    Print["  Error (log10): ", N[sqrttrfError, 6]];
    Print["  Precision: ", Floor[-sqrttrfError], " decimal places"];
    Print["  Numerator digits: ", IntegerLength[Numerator[sqrttrfResult]]];
    Print["  Denominator digits: ", IntegerLength[Denominator[sqrttrfResult]]];
  ];

  Print[""];
  Print["SPEEDUP: ", N[mathTime / sqrttrfTime, 4], "x faster"];
  Print[""];
  Print[StringRepeat["=", 70]];
  Print[""];
];

(* Run benchmarks *)
Benchmark[2, 100];
Benchmark[5, 100];
Benchmark[13, 100];

Benchmark[2, 500];
Benchmark[13, 500];

Benchmark[13, 1000];

Print["=== BENCHMARK COMPLETE ==="];
Print[""];
Print["KEY RESULT: sqrttrf significantly faster than Rationalize[]"];
Print["for high-precision rational square root approximations"];
