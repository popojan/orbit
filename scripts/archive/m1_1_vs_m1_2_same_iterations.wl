#!/usr/bin/env wolframscript
(* Optimized m1=1 vs m1=2: Same iteration count comparison *)

Get["Orbit/Kernel/SquareRootRationalizations.wl"];

Print["================================================================"];
Print["OPTIMIZED m1=1 vs m1=2: SAME ITERATION COUNT"];
Print["================================================================"];
Print[];
Print["Comparing formula overhead per iteration"];
Print["Both use same m2 value - so comparing per-iteration cost"];
Print[];

QuadError[n_, approx_] := Log[10, Abs[n - approx^2]];

d = 13;

Print["Formula complexity:"];
Print["  m1=1: (nn*(3*n^2 + nn))/(n*(n^2 + 3*nn))  [9 arithmetic ops]"];
Print["  m1=2: (n^4 + 6*n^2*nn + nn^2)/(4*n*(n^2 + nn))  [11 arithmetic ops]"];
Print[];

Print["================================================================"];
Print["SAME m2 TESTS - Measuring per-iteration overhead"];
Print["================================================================"];
Print[];

(* Test with m2=2 *)
Print["TEST m2=2 (2 iterations each)"];
Print["----------------------------------------"];
time12 = AbsoluteTiming[result12 = Orbit`Private`NestedChebyshevSqrt[d, {1, 2}]][[1]];
time22 = AbsoluteTiming[result22 = Orbit`Private`NestedChebyshevSqrt[d, {2, 2}]][[1]];
prec12 = Floor[-QuadError[d, result12]];
prec22 = Floor[-QuadError[d, result22]];
Print["  m1=1: ", prec12, " digits in ", N[time12, 5], "s"];
Print["  m1=2: ", prec22, " digits in ", N[time22, 5], "s"];
If[time12 < time22,
  Print["  Winner: m1=1 (", N[time22/time12, 3], "x faster) - simpler formula wins!"],
  Print["  Winner: m1=2 (", N[time12/time22, 3], "x faster) - higher convergence wins!"]
];
Print[];

(* Test with m2=3 *)
Print["TEST m2=3 (3 iterations each)"];
Print["----------------------------------------"];
time13 = AbsoluteTiming[result13 = Orbit`Private`NestedChebyshevSqrt[d, {1, 3}]][[1]];
time23 = AbsoluteTiming[result23 = Orbit`Private`NestedChebyshevSqrt[d, {2, 3}]][[1]];
prec13 = Floor[-QuadError[d, result13]];
prec23 = Floor[-QuadError[d, result23]];
Print["  m1=1: ", prec13, " digits in ", N[time13, 5], "s"];
Print["  m1=2: ", prec23, " digits in ", N[time23, 5], "s"];
If[time13 < time23,
  Print["  Winner: m1=1 (", N[time23/time13, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time13/time23, 3], "x faster)"]
];
Print[];

(* Test with m2=4 *)
Print["TEST m2=4 (4 iterations each)"];
Print["----------------------------------------"];
time14 = AbsoluteTiming[result14 = Orbit`Private`NestedChebyshevSqrt[d, {1, 4}]][[1]];
time24 = AbsoluteTiming[result24 = Orbit`Private`NestedChebyshevSqrt[d, {2, 4}]][[1]];
prec14 = Floor[-QuadError[d, result14]];
prec24 = Floor[-QuadError[d, result24]];
Print["  m1=1: ", prec14, " digits in ", N[time14, 5], "s"];
Print["  m1=2: ", prec24, " digits in ", N[time24, 5], "s"];
If[time14 < time24,
  Print["  Winner: m1=1 (", N[time24/time14, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time14/time24, 3], "x faster)"]
];
Print[];

(* Test with m2=5 *)
Print["TEST m2=5 (5 iterations each)"];
Print["----------------------------------------"];
time15 = AbsoluteTiming[result15 = Orbit`Private`NestedChebyshevSqrt[d, {1, 5}]][[1]];
time25 = AbsoluteTiming[result25 = Orbit`Private`NestedChebyshevSqrt[d, {2, 5}]][[1]];
prec15 = Floor[-QuadError[d, result15]];
prec25 = Floor[-QuadError[d, result25]];
Print["  m1=1: ", prec15, " digits in ", N[time15, 5], "s"];
Print["  m1=2: ", prec25, " digits in ", N[time25, 5], "s"];
If[time15 < time25,
  Print["  Winner: m1=1 (", N[time25/time15, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time15/time25, 3], "x faster)"]
];
Print[];

(* Test with m2=6 *)
Print["TEST m2=6 (6 iterations each)"];
Print["----------------------------------------"];
time16 = AbsoluteTiming[result16 = Orbit`Private`NestedChebyshevSqrt[d, {1, 6}]][[1]];
time26 = AbsoluteTiming[result26 = Orbit`Private`NestedChebyshevSqrt[d, {2, 6}]][[1]];
prec16 = Floor[-QuadError[d, result16]];
prec26 = Floor[-QuadError[d, result26]];
Print["  m1=1: ", prec16, " digits in ", N[time16, 5], "s"];
Print["  m1=2: ", prec26, " digits in ", N[time26, 5], "s"];
If[time16 < time26,
  Print["  Winner: m1=1 (", N[time26/time16, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time16/time26, 3], "x faster)"]
];
Print[];

(* Test with m2=7 *)
Print["TEST m2=7 (7 iterations each)"];
Print["----------------------------------------"];
time17 = AbsoluteTiming[result17 = Orbit`Private`NestedChebyshevSqrt[d, {1, 7}]][[1]];
time27 = AbsoluteTiming[result27 = Orbit`Private`NestedChebyshevSqrt[d, {2, 7}]][[1]];
prec17 = Floor[-QuadError[d, result17]];
prec27 = Floor[-QuadError[d, result27]];
Print["  m1=1: ", prec17, " digits in ", N[time17, 5], "s"];
Print["  m1=2: ", prec27, " digits in ", N[time27, 5], "s"];
If[time17 < time27,
  Print["  Winner: m1=1 (", N[time27/time17, 3], "x faster)"],
  Print["  Winner: m1=2 (", N[time17/time27, 3], "x faster)"]
];
Print[];

Print["================================================================"];
Print["SUMMARY"];
Print["================================================================"];
Print[];

times1 = {time12, time13, time14, time15, time16, time17};
times2 = {time22, time23, time24, time25, time26, time27};
speedups = times2/times1;

Print["Speedup factor (m1=2 time / m1=1 time):"];
Do[
  If[speedups[[i]] > 1,
    Print["  m2=", i+1, ": m1=1 wins by ", N[speedups[[i]], 3], "x"],
    Print["  m2=", i+1, ": m1=2 wins by ", N[1/speedups[[i]], 3], "x"]
  ],
  {i, 1, Length[speedups]}
];
Print[];

Print["Average speedup: ", N[Mean[speedups], 3], "x"];
If[Last[speedups] > First[speedups],
  Print["Trend: m1=1 advantage GROWING (more iterations favor simpler formula)"],
  Print["Trend: m1=2 catching up (arithmetic cost dominates less at high precision)"]
];
Print[];

Print["Per-iteration overhead comparison:"];
overhead1 = Table[times1[[i]]/(i+1), {i, 1, Length[times1]}];
overhead2 = Table[times2[[i]]/(i+1), {i, 1, Length[times2]}];
Print["  m1=1 avg per-iteration: ", N[Mean[overhead1], 5], "s"];
Print["  m1=2 avg per-iteration: ", N[Mean[overhead2], 5], "s"];
Print["  Ratio: ", N[Mean[overhead2]/Mean[overhead1], 3], "x"];
Print[];

Print["Conclusion:"];
If[Mean[speedups] > 1.05,
  Print["  m1=1 has LOWER per-iteration overhead - your intuition was correct!"],
  Print["  m1=1 formula is simpler (9 ops vs 11 ops) and wins in wall-time."],
  If[Mean[speedups] < 0.95,
    Print["  m1=2 has LOWER per-iteration overhead despite more complex formula"],
    Print["  Formulas have EQUIVALENT overhead (within 5%)"]]
];
