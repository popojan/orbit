#!/usr/bin/env wolframscript
(* Test the optimized SquareRootRationalizations paclet *)

(* Load the paclet *)
<< Orbit`

Print["================================================================"];
Print["TESTING OPTIMIZED PACLET: SquareRootRationalizations"];
Print["================================================================"];
Print[];

(* Test 1: Verify m1=1 uses optimized formula *)
Print["TEST 1: m1=1 optimization check"];
Print["Computing NestedChebyshevSqrt[13, {1, 5}]..."];
result1 = AbsoluteTiming[NestedChebyshevSqrt[13, {1, 5}]];
Print["  Time: ", N[result1[[1]], 4], "s"];
Print["  Precision: ", Floor[-Log[10, Abs[13 - result1[[2]]^2]]], " digits"];
Print["  (Should be fast - using optimized m1=1 formula)"];
Print[];

(* Test 2: Verify m1=2 uses optimized formula *)
Print["TEST 2: m1=2 optimization check"];
Print["Computing NestedChebyshevSqrt[13, {2, 4}]..."];
result2 = AbsoluteTiming[NestedChebyshevSqrt[13, {2, 4}]];
Print["  Time: ", N[result2[[1]], 4], "s"];
Print["  Precision: ", Floor[-Log[10, Abs[13 - result2[[2]]^2]]], " digits"];
Print["  (Should be fast - using optimized m1=2 formula)"];
Print[];

(* Test 3: Verify m1=3 uses general formula *)
Print["TEST 3: m1=3 general formula check"];
Print["Computing NestedChebyshevSqrt[13, {3, 3}]..."];
result3 = AbsoluteTiming[NestedChebyshevSqrt[13, {3, 3}]];
Print["  Time: ", N[result3[[1]], 4], "s"];
Print["  Precision: ", Floor[-Log[10, Abs[13 - result3[[2]]^2]]], " digits"];
Print["  (Uses general ChebyshevU formula)"];
Print[];

(* Test 4: High precision with m1=1 *)
Print["TEST 4: High precision with optimized m1=1"];
Print["Computing NestedChebyshevSqrt[13, {1, 7}] (~871k digits)..."];
result4 = AbsoluteTiming[NestedChebyshevSqrt[13, {1, 7}]];
Print["  Time: ", N[result4[[1]], 4], "s"];
Print["  Precision: ", Floor[-Log[10, Abs[13 - result4[[2]]^2]]], " digits"];
Print["  Denominator length: ", IntegerLength[Denominator[result4[[2]]]], " digits"];
Print["  (Should complete in ~0.09s)"];
Print[];

(* Test 5: Verify correctness - compare m1=1 and m1=2 *)
Print["TEST 5: Correctness verification"];
r1 = NestedChebyshevSqrt[13, {1, 3}];
r2 = NestedChebyshevSqrt[13, {2, 2}];
r3 = NestedChebyshevSqrt[13, {3, 2}];
Print["  m1=1, m2=3: ", Floor[-Log[10, Abs[13 - r1^2]]], " digits"];
Print["  m1=2, m2=2: ", Floor[-Log[10, Abs[13 - r2^2]]], " digits"];
Print["  m1=3, m2=2: ", Floor[-Log[10, Abs[13 - r3^2]]], " digits"];
Print["  (All should produce correct rational approximations)"];
Print[];

Print["================================================================"];
Print["ALL TESTS COMPLETED"];
Print["================================================================"];
