#!/usr/bin/env wolframscript
(* Optimized m1=1 vs m1=2 Wall-Clock Comparison *)

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
time11 = AbsoluteTiming[result11 = Orbit`Private`NestedChebyshevSqrt[d, {1, 2}]][[1]];
time21 = AbsoluteTiming[result21 = Orbit`Private`NestedChebyshevSqrt[d, {2, 1}]][[1]];
prec11 = Floor[-QuadError[d, result11]];
prec21 = Floor[-QuadError[d, result21]];
Print["  m1=1, m2=2: ", prec11, " digits in ", N[time11, 5], "s"];
Print["  m1=2, m2=1: ", prec21, " digits in ", N[time21, 5], "s"];
If[time11 < time21,
  Print["  Winner: m1=1 (", N[time21/time11, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time11/time21, 3], "x faster)"]
];
Print[];

(* Test 2: ~1k digits *)
Print["TEST 2: ~1k digits target"];
Print["----------------------------------------"];
time12 = AbsoluteTiming[result12 = Orbit`Private`NestedChebyshevSqrt[d, {1, 3}]][[1]];
time22 = AbsoluteTiming[result22 = Orbit`Private`NestedChebyshevSqrt[d, {2, 2}]][[1]];
prec12 = Floor[-QuadError[d, result12]];
prec22 = Floor[-QuadError[d, result22]];
Print["  m1=1, m2=3: ", prec12, " digits in ", N[time12, 5], "s"];
Print["  m1=2, m2=2: ", prec22, " digits in ", N[time22, 5], "s"];
If[time12 < time22,
  Print["  Winner: m1=1 (", N[time22/time12, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time12/time22, 3], "x faster)"]
];
Print[];

(* Test 3: ~10k digits *)
Print["TEST 3: ~10k digits target"];
Print["----------------------------------------"];
time13 = AbsoluteTiming[result13 = Orbit`Private`NestedChebyshevSqrt[d, {1, 4}]][[1]];
time23 = AbsoluteTiming[result23 = Orbit`Private`NestedChebyshevSqrt[d, {2, 3}]][[1]];
prec13 = Floor[-QuadError[d, result13]];
prec23 = Floor[-QuadError[d, result23]];
Print["  m1=1, m2=4: ", prec13, " digits in ", N[time13, 5], "s"];
Print["  m1=2, m2=3: ", prec23, " digits in ", N[time23, 5], "s"];
If[time13 < time23,
  Print["  Winner: m1=1 (", N[time23/time13, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time13/time23, 3], "x faster)"]
];
Print[];

(* Test 4: ~100k digits *)
Print["TEST 4: ~100k digits target"];
Print["----------------------------------------"];
time14 = AbsoluteTiming[result14 = Orbit`Private`NestedChebyshevSqrt[d, {1, 5}]][[1]];
time24 = AbsoluteTiming[result24 = Orbit`Private`NestedChebyshevSqrt[d, {2, 4}]][[1]];
prec14 = Floor[-QuadError[d, result14]];
prec24 = Floor[-QuadError[d, result24]];
Print["  m1=1, m2=5: ", prec14, " digits in ", N[time14, 5], "s"];
Print["  m1=2, m2=4: ", prec24, " digits in ", N[time24, 5], "s"];
If[time14 < time24,
  Print["  Winner: m1=1 (", N[time24/time14, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time14/time24, 3], "x faster)"]
];
Print[];

(* Test 5: ~1M digits *)
Print["TEST 5: ~1M digits target"];
Print["----------------------------------------"];
time15 = AbsoluteTiming[result15 = Orbit`Private`NestedChebyshevSqrt[d, {1, 6}]][[1]];
time25 = AbsoluteTiming[result25 = Orbit`Private`NestedChebyshevSqrt[d, {2, 5}]][[1]];
prec15 = Floor[-QuadError[d, result15]];
prec25 = Floor[-QuadError[d, result25]];
Print["  m1=1, m2=6: ", prec15, " digits in ", N[time15, 5], "s"];
Print["  m1=2, m2=5: ", prec25, " digits in ", N[time25, 5], "s"];
If[time15 < time25,
  Print["  Winner: m1=1 (", N[time25/time15, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time15/time25, 3], "x faster)"]
];
Print[];

(* Test 6: High precision ~5M digits *)
Print["TEST 6: ~5M digits target"];
Print["----------------------------------------"];
time16 = AbsoluteTiming[result16 = Orbit`Private`NestedChebyshevSqrt[d, {1, 7}]][[1]];
time26 = AbsoluteTiming[result26 = Orbit`Private`NestedChebyshevSqrt[d, {2, 6}]][[1]];
prec16 = Floor[-QuadError[d, result16]];
prec26 = Floor[-QuadError[d, result26]];
Print["  m1=1, m2=7: ", prec16, " digits in ", N[time16, 5], "s"];
Print["  m1=2, m2=6: ", prec26, " digits in ", N[time26, 5], "s"];
If[time16 < time26,
  Print["  Winner: m1=1 (", N[time26/time16, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time16/time26, 3], "x faster)"]
];
Print[];

Print["================================================================"];
Print["SUMMARY"];
Print["================================================================"];
Print[];

times1 = {time11, time12, time13, time14, time15, time16};
times2 = {time21, time22, time23, time24, time25, time26};
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
If[Last[speedups] > First[speedups],
  Print["Trend: m1=1 advantage GROWING with precision"],
  Print["Trend: m1=2 catching up at higher precision"]
];
Print[];

Print["Conclusion:"];
If[Mean[speedups] > 1.05,
  Print["  m1=1 is FASTER on average - your intuition was correct!"],
  If[Mean[speedups] < 0.95,
    Print["  m1=2 is FASTER on average"],
    Print["  Performance is EQUIVALENT (within 5%)"]]
];
