#!/usr/bin/env wolframscript
(* Optimized m1=1 vs m1=2 Wall-Clock Comparison *)

(* Load optimized functions *)
Get["Orbit/Kernel/SquareRootRationalizations.wl"];

Print["================================================================"];
Print["OPTIMIZED m1=1 vs m1=2 WALL-CLOCK COMPARISON"];
Print["================================================================"];
Print[];

QuadError[n_, approx_] := Log[10, Abs[n - approx^2]];

d = 13;

Print["Convergence rates:"];
Print["  m1=1: ~6x precision per iteration"];
Print["  m1=2: ~8x precision per iteration"];
Print[];

Print["================================================================"];
Print["MATCHED PRECISION TESTS"];
Print["================================================================"];
Print[];

(* Test 1: ~100 digits *)
Print["TEST 1: ~100 digits target"];
Print["----------------------------------------"];
m1_1_t1 = AbsoluteTiming[r1_1 = Orbit`Private`NestedChebyshevSqrt[d, {1, 2}]];
m1_2_t1 = AbsoluteTiming[r1_2 = Orbit`Private`NestedChebyshevSqrt[d, {2, 1}]];
Print["  m1=1, m2=2: ", Floor[-QuadError[d, r1_1]], " digits in ", N[m1_1_t1[[1]], 5], "s"];
Print["  m1=2, m2=1: ", Floor[-QuadError[d, r1_2]], " digits in ", N[m1_2_t1[[1]], 5], "s"];
If[m1_1_t1[[1]] < m1_2_t1[[1]],
  Print["  Winner: m1=1 (", N[m1_2_t1[[1]]/m1_1_t1[[1]], 3], "x faster)"],
  Print["  Winner: m1=2 (", N[m1_1_t1[[1]]/m1_2_t1[[1]], 3], "x faster)"]
];
Print[];

(* Test 2: ~1k digits *)
Print["TEST 2: ~1k digits target"];
Print["----------------------------------------"];
m1_1_t2 = AbsoluteTiming[r2_1 = Orbit`Private`NestedChebyshevSqrt[d, {1, 3}]];
m1_2_t2 = AbsoluteTiming[r2_2 = Orbit`Private`NestedChebyshevSqrt[d, {2, 2}]];
Print["  m1=1, m2=3: ", Floor[-QuadError[d, r2_1]], " digits in ", N[m1_1_t2[[1]], 5], "s"];
Print["  m1=2, m2=2: ", Floor[-QuadError[d, r2_2]], " digits in ", N[m1_2_t2[[1]], 5], "s"];
If[m1_1_t2[[1]] < m1_2_t2[[1]],
  Print["  Winner: m1=1 (", N[m1_2_t2[[1]]/m1_1_t2[[1]], 3], "x faster)"],
  Print["  Winner: m1=2 (", N[m1_1_t2[[1]]/m1_2_t2[[1]], 3], "x faster)"]
];
Print[];

(* Test 3: ~10k digits *)
Print["TEST 3: ~10k digits target"];
Print["----------------------------------------"];
m1_1_t3 = AbsoluteTiming[r3_1 = Orbit`Private`NestedChebyshevSqrt[d, {1, 4}]];
m1_2_t3 = AbsoluteTiming[r3_2 = Orbit`Private`NestedChebyshevSqrt[d, {2, 3}]];
Print["  m1=1, m2=4: ", Floor[-QuadError[d, r3_1]], " digits in ", N[m1_1_t3[[1]], 5], "s"];
Print["  m1=2, m2=3: ", Floor[-QuadError[d, r3_2]], " digits in ", N[m1_2_t3[[1]], 5], "s"];
If[m1_1_t3[[1]] < m1_2_t3[[1]],
  Print["  Winner: m1=1 (", N[m1_2_t3[[1]]/m1_1_t3[[1]], 3], "x faster)"],
  Print["  Winner: m1=2 (", N[m1_1_t3[[1]]/m1_2_t3[[1]], 3], "x faster)"]
];
Print[];

(* Test 4: ~100k digits *)
Print["TEST 4: ~100k digits target"];
Print["----------------------------------------"];
m1_1_t4 = AbsoluteTiming[r4_1 = Orbit`Private`NestedChebyshevSqrt[d, {1, 5}]];
m1_2_t4 = AbsoluteTiming[r4_2 = Orbit`Private`NestedChebyshevSqrt[d, {2, 4}]];
Print["  m1=1, m2=5: ", Floor[-QuadError[d, r4_1]], " digits in ", N[m1_1_t4[[1]], 5], "s"];
Print["  m1=2, m2=4: ", Floor[-QuadError[d, r4_2]], " digits in ", N[m1_2_t4[[1]], 5], "s"];
If[m1_1_t4[[1]] < m1_2_t4[[1]],
  Print["  Winner: m1=1 (", N[m1_2_t4[[1]]/m1_1_t4[[1]], 3], "x faster)"],
  Print["  Winner: m1=2 (", N[m1_1_t4[[1]]/m1_2_t4[[1]], 3], "x faster)"]
];
Print[];

(* Test 5: ~1M digits *)
Print["TEST 5: ~1M digits target"];
Print["----------------------------------------"];
m1_1_t5 = AbsoluteTiming[r5_1 = Orbit`Private`NestedChebyshevSqrt[d, {1, 6}]];
m1_2_t5 = AbsoluteTiming[r5_2 = Orbit`Private`NestedChebyshevSqrt[d, {2, 5}]];
Print["  m1=1, m2=6: ", Floor[-QuadError[d, r5_1]], " digits in ", N[m1_1_t5[[1]], 5], "s"];
Print["  m1=2, m2=5: ", Floor[-QuadError[d, r5_2]], " digits in ", N[m1_2_t5[[1]], 5], "s"];
If[m1_1_t5[[1]] < m1_2_t5[[1]],
  Print["  Winner: m1=1 (", N[m1_2_t5[[1]]/m1_1_t5[[1]], 3], "x faster)"],
  Print["  Winner: m1=2 (", N[m1_1_t5[[1]]/m1_2_t5[[1]], 3], "x faster)"]
];
Print[];

(* Test 6: High precision ~5M digits *)
Print["TEST 6: ~5M digits target"];
Print["----------------------------------------"];
m1_1_t6 = AbsoluteTiming[r6_1 = Orbit`Private`NestedChebyshevSqrt[d, {1, 7}]];
m1_2_t6 = AbsoluteTiming[r6_2 = Orbit`Private`NestedChebyshevSqrt[d, {2, 6}]];
Print["  m1=1, m2=7: ", Floor[-QuadError[d, r6_1]], " digits in ", N[m1_1_t6[[1]], 5], "s"];
Print["  m1=2, m2=6: ", Floor[-QuadError[d, r6_2]], " digits in ", N[m1_2_t6[[1]], 5], "s"];
If[m1_1_t6[[1]] < m1_2_t6[[1]],
  Print["  Winner: m1=1 (", N[m1_2_t6[[1]]/m1_1_t6[[1]], 3], "x faster)"],
  Print["  Winner: m1=2 (", N[m1_1_t6[[1]]/m1_2_t6[[1]], 3], "x faster)"]
];
Print[];

Print["================================================================"];
Print["SUMMARY"];
Print["================================================================"];
Print[];

times1 = {m1_1_t1[[1]], m1_1_t2[[1]], m1_1_t3[[1]], m1_1_t4[[1]], m1_1_t5[[1]], m1_1_t6[[1]]};
times2 = {m1_2_t1[[1]], m1_2_t2[[1]], m1_2_t3[[1]], m1_2_t4[[1]], m1_2_t5[[1]], m1_2_t6[[1]]};
speedups = times2/times1;

Print["Speedup factor (m1=2 time / m1=1 time):"];
Do[
  If[speedups[[i]] > 1,
    Print["  Test ", i, ": m1=1 wins by ", N[speedups[[i]], 3], "x"],
    Print["  Test ", i, ": m1=2 wins by ", N[1/speedups[[i]], 3], "x"]
  ],
  {i, 1, Length[speedups]}
];
Print[];

Print["Average speedup: ", N[Mean[speedups], 3], "x"];
Print["Trend: ", If[Last[speedups] > First[speedups], "m1=1 advantage growing", "m1=2 advantage growing"]];
Print[];

Print["Conclusion:"];
If[Mean[speedups] > 1.05,
  Print["  m1=1 is FASTER on average - your intuition was correct!"],
  If[Mean[speedups] < 0.95,
    Print["  m1=2 is FASTER on average"],
    Print["  Performance is EQUIVALENT (within 5%)"]]
];
