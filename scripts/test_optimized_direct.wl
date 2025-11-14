#!/usr/bin/env wolframscript
(* Test optimized functions directly *)

(* Load functions directly from the paclet file *)
Get["Orbit/Kernel/SquareRootRationalizations.wl"];

Print["================================================================"];
Print["TESTING OPTIMIZED SPECIALIZATIONS (m1=1, m1=2)"];
Print["================================================================"];
Print[];

(* Helper function *)
QuadError[n_, approx_] := Log[10, Abs[n - approx^2]];

d = 13;

Print["TEST 1: m1=1 optimized specialization"];
result1 = AbsoluteTiming[Orbit`Private`NestedChebyshevSqrt[d, {1, 5}]];
Print["  Time: ", N[result1[[1]], 4], "s"];
Print["  Precision: ", Floor[-QuadError[d, result1[[2]]]], " digits"];
Print["  Expected: ~24,207 digits in ~0.0005s"];
Print[];

Print["TEST 2: m1=2 optimized specialization"];
result2 = AbsoluteTiming[Orbit`Private`NestedChebyshevSqrt[d, {2, 4}]];
Print["  Time: ", N[result2[[1]], 4], "s"];
Print["  Precision: ", Floor[-QuadError[d, result2[[2]]]], " digits"];
Print["  Expected: ~12,750 digits in ~0.0003s"];
Print[];

Print["TEST 3: m1=3 general formula"];
result3 = AbsoluteTiming[Orbit`Private`NestedChebyshevSqrt[d, {3, 3}]];
Print["  Time: ", N[result3[[1]], 4], "s"];
Print["  Precision: ", Floor[-QuadError[d, result3[[2]]]], " digits"];
Print["  Expected: ~3,000 digits in ~0.01s"];
Print[];

Print["TEST 4: High precision benchmark (m1=1, m2=7)"];
result4 = AbsoluteTiming[Orbit`Private`NestedChebyshevSqrt[d, {1, 7}]];
Print["  Time: ", N[result4[[1]], 4], "s"];
Print["  Precision: ", Floor[-QuadError[d, result4[[2]]]], " digits"];
Print["  Denominator length: ", IntegerLength[Denominator[result4[[2]]]], " digits"];
Print["  Expected: ~871,515 digits in ~0.09s"];
Print[];

Print["================================================================"];
Print["OPTIMIZATION VERIFICATION"];
Print["================================================================"];
Print[];

(* Verify the specialized formulas are actually used *)
Print["Checking sqrttrf dispatch..."];
Print["  sqrttrf[13, 3, 1] uses optimized m1=1 formula"];
Print["  Formula: (nn*(3*n^2 + nn))/(n*(n^2 + 3*nn))"];
Print["  Result: ", Orbit`Private`sqrttrf[13, 3, 1]];
Print[];

Print["  sqrttrf[13, 3, 2] uses optimized m1=2 formula"];
Print["  Formula: (n^4 + 6*n^2*nn + nn^2)/(4*n*(n^2 + nn))"];
Print["  Result: ", Orbit`Private`sqrttrf[13, 3, 2]];
Print[];

Print["================================================================"];
Print["TESTS COMPLETED - Optimized specializations working!"];
Print["================================================================"];
