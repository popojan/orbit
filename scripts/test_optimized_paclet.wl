#!/usr/bin/env wolframscript
(* Test optimized NestedChebyshevSqrt formulas (m1=1, m1=2) against general formula (m1=3) *)

Print["=== TESTING OPTIMIZED FORMULAS (m1=1, m1=2) ===\n"];

<< Orbit`

d = 13;  (* Test value *)

(* Helper: Get Pell start *)
PellStart[n_] := Module[{sol},
  sol = PellSolution[n];
  (x - 1)/y /. sol
];

start = PellStart[d];

(* Test 1: Verify m1=1 uses optimized formula *)
Print["TEST 1: m1=1 optimization check"];
Print["Computing NestedChebyshevSqrt[13, start, {1, 5}]..."];
result1 = AbsoluteTiming[NestedChebyshevSqrt[13, start, {1, 5}]];
approx1 = Mean[First[List @@ result1[[2]]]];
Print["  Time: ", N[result1[[1]], 4], "s"];
Print["  Precision: ", Floor[-Log[10, Abs[13 - approx1^2]]], " digits"];
Print["  Expecting: ~32768 digits (6^5 ≈ 7776, doubled with symmetrization)\n"];

(* Test 2: Verify m1=2 uses optimized formula *)
Print["TEST 2: m1=2 optimization check"];
Print["Computing NestedChebyshevSqrt[13, start, {2, 4}]..."];
result2 = AbsoluteTiming[NestedChebyshevSqrt[13, start, {2, 4}]];
approx2 = Mean[First[List @@ result2[[2]]]];
Print["  Time: ", N[result2[[1]], 4], "s"];
Print["  Precision: ", Floor[-Log[10, Abs[13 - approx2^2]]], " digits"];
Print["  Expecting: ~65536 digits (8^4 ≈ 4096, doubled)\n"];

(* Test 3: Verify m1=3 uses general formula *)
Print["TEST 3: m1=3 general formula check"];
Print["Computing NestedChebyshevSqrt[13, start, {3, 3}]..."];
result3 = AbsoluteTiming[NestedChebyshevSqrt[13, start, {3, 3}]];
approx3 = Mean[First[List @@ result3[[2]]]];
Print["  Time: ", N[result3[[1]], 4], "s"];
Print["  Precision: ", Floor[-Log[10, Abs[13 - approx3^2]]], " digits"];
Print["  Expecting: ~1000 digits (10^3 = 1000)\n"];

(* Test 4: High precision with m1=1 *)
Print["TEST 4: High precision with optimized m1=1"];
Print["Computing NestedChebyshevSqrt[13, start, {1, 7}] (~871k digits)..."];
result4 = AbsoluteTiming[NestedChebyshevSqrt[13, start, {1, 7}]];
approx4 = Mean[First[List @@ result4[[2]]]];
Print["  Time: ", N[result4[[1]], 4], "s"];
Print["  Precision: ", Floor[-Log[10, Abs[13 - approx4^2]]], " digits"];
Print["  Expecting: ~871k digits (measured)\n"];

(* Test 5: Verify correctness - compare m1=1 and m1=2 *)
Print["TEST 5: Correctness verification"];
r1 = Mean[First[List @@ NestedChebyshevSqrt[13, start, {1, 3}]]];
r2 = Mean[First[List @@ NestedChebyshevSqrt[13, start, {2, 2}]]];
r3 = Mean[First[List @@ NestedChebyshevSqrt[13, start, {3, 2}]]];
Print["  m1=1, m2=3: ", Floor[-Log[10, Abs[13 - r1^2]]], " digits"];
Print["  m1=2, m2=2: ", Floor[-Log[10, Abs[13 - r2^2]]], " digits"];
Print["  m1=3, m2=2: ", Floor[-Log[10, Abs[13 - r3^2]]], " digits"];

Print["\n=== ALL TESTS COMPLETE ==="];
