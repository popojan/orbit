#!/usr/bin/env wolframscript
(* Test: Symbolic solution with PATIENT timeout *)

Print["================================================================"];
Print["SYMBOLIC SOLUTION TEST: Patient Evaluation"];
Print["================================================================"];
Print[""];

(* ============================================================================ *)
(* TEST 1: Inner k-sum for general symbolic parameters                        *)
(* ============================================================================ *)

Print["[1/2] Inner k-sum with symbolic n, d, alpha, eps:"];
Print[""];
Print["Attempting: Sum_{k=0}^∞ [(n - kd - d²)² + ε]^{-α}"];
Print[""];
Print["This may take several minutes... please wait."];
Print[""];

startTime = AbsoluteTime[];

(* Remove timeout - let it run as long as needed *)
innerSymbolic = Sum[((n - k*d - d^2)^2 + eps)^(-alpha), {k, 0, Infinity},
  Assumptions -> {
    n ∈ Integers, d ∈ Integers, alpha > 1, eps > 0,
    n > 0, d > 1
  }
];

elapsed = AbsoluteTime[] - startTime;

Print["Result after ", Round[elapsed], " seconds:"];
Print[""];
Print[innerSymbolic];
Print[""];

(* ============================================================================ *)
(* TEST 2: Double sum for n=2                                                 *)
(* ============================================================================ *)

Print["[2/2] Full double sum for n=2, α=3, ε=1:"];
Print[""];
Print["F_2(3) = Σ_{d=2}^∞ Σ_{k=0}^∞ [(2 - kd - d²)² + 1]^{-3}"];
Print[""];
Print["This will take even longer... patience!"];
Print[""];

n = 2;
alpha = 3;
eps = 1;

startTime = AbsoluteTime[];

(* Let it run without timeout *)
doubleSum = Sum[
  Sum[((n - k*d - d^2)^2 + eps)^(-alpha), {k, 0, Infinity}],
  {d, 2, Infinity}
];

elapsed = AbsoluteTime[] - startTime;

Print["Result after ", Round[elapsed], " seconds:"];
Print[""];
Print[doubleSum];
Print[""];
Print["Numerical value: ", N[doubleSum, 12]];
Print[""];

Print["================================================================"];
Print["COMPLETE"];
Print["================================================================"];
