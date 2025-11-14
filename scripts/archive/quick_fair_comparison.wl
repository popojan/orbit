(* ==================================================================
   QUICK FAIR PRECISION COMPARISON

   Focus on practical methods that complete in reasonable time.
   Test at multiple precision targets: 50, 100, 500, 1000 sqrt digits
   ================================================================== *)

(* Pell solver *)
PellSolve[d_] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {u, r}
];

(* Nested Chebyshev *)
sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/
  ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify;

sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2];
nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1] &, n, m2];

(* Error metrics *)
QuadError[n_, approx_] := Log[10, Abs[n - approx^2]];
SqrtPrecision[n_, approx_] := -QuadError[n, approx]/2;

(* Benchmark one method at one target *)
BenchmarkAtPrecision[d_, targetPrec_, methodName_, computeFunc_, skipWolfram_:False] :=
  Module[{result, ourTime, actualPrec, ourDenom,
          wmResult, wmTime, wmDenom, overhead, speedRatio},

    (* Compute OUR method *)
    {ourTime, result} = AbsoluteTiming[computeFunc[]];

    (* Check if we reached target *)
    actualPrec = Floor[SqrtPrecision[d, result]];
    If[actualPrec < targetPrec,
      Return[{methodName, "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A"}]
    ];

    ourDenom = IntegerLength[Denominator[result]];

    (* Conditionally compute WOLFRAM - skip for very high precision *)
    If[skipWolfram,
      (* High precision - skip Wolfram comparison *)
      {methodName, actualPrec, N[ourTime, 4], ourDenom, "-", "-", "-", "-"},
      (* Modest precision - do full comparison *)
      {wmTime, wmResult} = AbsoluteTiming[
        Rationalize[Sqrt[N[d, actualPrec + 100]], 10^(-actualPrec)]
      ];
      wmDenom = IntegerLength[Denominator[wmResult]];
      overhead = N[ourDenom/wmDenom, 3];
      speedRatio = N[wmTime/ourTime, 3];
      {methodName, actualPrec, N[ourTime, 4], ourDenom, N[wmTime, 4], wmDenom, overhead, speedRatio}
    ]
  ];

(* ===================================================================
   MAIN BENCHMARK
   =================================================================== *)

d = 13;
{x, y} = PellSolve[d];
pellBase = (x - 1)/y;
crude = Floor[Sqrt[d]];

Print["================================================================="];
Print["QUICK FAIR PRECISION COMPARISON: sqrt(", d, ")"];
Print["Pell solution: (", x, ", ", y, ")  =>  base = ", N[pellBase, 6]];
Print["================================================================="];
Print[""];

(* Precision targets (sqrt digits) *)
(* Modest: full comparison with Wolfram *)
(* Ambitious: skip Wolfram (takes too long at high precision) *)
modestTargets = {10, 50, 100, 500, 1000};
ambitiousTargets = {10000, 100000, 1000000};

(* MODEST TARGETS - Full comparison *)
Do[
  Print[""];
  Print[StringRepeat["=", 70]];
  Print["TARGET: ", targetPrec, " sqrt digits (with Wolfram comparison)"];
  Print[StringRepeat["=", 70]];

  (* Define methods to test - ONLY fast ones *)
  methods = {
    {"Nested m1=3,m2=2 (Pell)", nestqrt[d, pellBase, {3, 2}]&},
    {"Nested m1=3,m2=3 (Pell)", nestqrt[d, pellBase, {3, 3}]&},
    {"Nested m1=2,m2=4 (Pell)", nestqrt[d, pellBase, {2, 4}]&},
    {"Nested m1=2,m2=5 (Pell)", nestqrt[d, pellBase, {2, 5}]&},
    {"Nested m1=1,m2=7 (Pell)", nestqrt[d, pellBase, {1, 7}]&},
    {"Nested m1=3,m2=2 (crude)", nestqrt[d, crude, {3, 2}]&},
    {"Nested m1=3,m2=3 (crude)", nestqrt[d, crude, {3, 3}]&}
  };

  (* Benchmark each method *)
  results = Table[
    BenchmarkAtPrecision[d, targetPrec, methods[[i, 1]], methods[[i, 2]], False],
    {i, 1, Length[methods]}
  ];

  (* Filter out N/A results *)
  valid = Select[results, #[[2]] =!= "N/A" &];

  If[Length[valid] > 0,
    Print[""];
    Print[Grid[
      Prepend[valid,
        {"Method", "Achieved", "Our Time", "Our Denom", "WM Time", "WM Denom", "Overhead", "Speed"}],
      Frame -> All,
      Alignment -> {{Left, Right, Right, Right, Right, Right, Right, Right}},
      Spacings -> {2, 1},
      ItemStyle -> {Automatic, {1 -> Bold}}
    ]];
    Print[""],
    Print["  No methods reached target precision"];
    Print[""]
  ];

, {targetPrec, modestTargets}];

(* AMBITIOUS TARGETS - No Wolfram comparison *)
Do[
  Print[""];
  Print[StringRepeat["=", 70]];
  Print["TARGET: ", targetPrec, " sqrt digits (our method only, Wolfram skipped)"];
  Print[StringRepeat["=", 70]];

  (* Add more powerful methods for ambitious targets *)
  methods = {
    {"Nested m1=3,m2=3 (Pell)", nestqrt[d, pellBase, {3, 3}]&},
    {"Nested m1=3,m2=4 (Pell)", nestqrt[d, pellBase, {3, 4}]&},
    {"Nested m1=2,m2=5 (Pell)", nestqrt[d, pellBase, {2, 5}]&},
    {"Nested m1=2,m2=6 (Pell)", nestqrt[d, pellBase, {2, 6}]&},
    {"Nested m1=1,m2=8 (Pell)", nestqrt[d, pellBase, {1, 8}]&},
    {"Nested m1=1,m2=9 (Pell)", nestqrt[d, pellBase, {1, 9}]&},
    {"Nested m1=1,m2=10 (Pell)", nestqrt[d, pellBase, {1, 10}]&}
  };

  (* Benchmark each method WITHOUT Wolfram *)
  results = Table[
    BenchmarkAtPrecision[d, targetPrec, methods[[i, 1]], methods[[i, 2]], True],
    {i, 1, Length[methods]}
  ];

  (* Filter out N/A results *)
  valid = Select[results, #[[2]] =!= "N/A" &];

  If[Length[valid] > 0,
    Print[""];
    Print[Grid[
      Prepend[valid,
        {"Method", "Achieved", "Our Time", "Our Denom", "WM Time", "WM Denom", "Overhead", "Speed"}],
      Frame -> All,
      Alignment -> {{Left, Right, Right, Right, Right, Right, Right, Right}},
      Spacings -> {2, 1},
      ItemStyle -> {Automatic, {1 -> Bold}}
    ]];
    Print[""],
    Print["  No methods reached target precision"];
    Print[""]
  ];

, {targetPrec, ambitiousTargets}];

Print[""];
Print["================================================================="];
Print["LEGEND"];
Print["  Achieved   = Actual sqrt precision achieved (may overshoot)"];
Print["  Our Time   = Time to compute with our method"];
Print["  Our Denom  = Number of digits in our rational's denominator"];
Print["  WM Time    = Wolfram Rationalize time at SAME precision"];
Print["  WM Denom   = Wolfram denominator (optimal via CF convergents)"];
Print["  Overhead   = (Our Denom) / (WM Denom) - size penalty"];
Print["  Speed      = (WM Time) / (Our Time) - speedup if >1"];
Print["  '-'        = Skipped (too slow for Wolfram at this precision)"];
Print[""];
Print["KEY INSIGHTS TO EXTRACT:"];
Print["  1. Which method is fastest at each precision level?"];
Print["  2. What is the time tradeoff vs CF optimality?"];
Print["  3. How does m1/m2 choice affect speed and size?"];
Print["  4. When does Pell base matter vs crude start?"];
Print["  5. At what precision do we become competitive with Rationalize?"];
Print["  6. For ambitious targets: Which m1/m2 balances speed vs precision?"];
Print["================================================================="];
