(* Verification of B(n,k) Complex Analysis Results *)
(* December 2, 2025 *)

Print["=== B(n,k) Complex Analysis Verification ===\n"];

(* Definitions *)
beta[n_] := n^2 Cos[Pi/n]/(4 - n^2);
B[n_, k_] := 1 + beta[n] Cos[(2k-1)Pi/n];
delta[n_] := n ArcCosh[-1/beta[n]]/(2 Pi);

(* Universal constant *)
deltaInfinity = Sqrt[Pi^2 - 8]/(2 Pi);

Print["1. UNIVERSAL CONSTANT"];
Print["   delta(infinity) = Sqrt[Pi^2 - 8]/(2 Pi)"];
Print["                   = ", N[deltaInfinity, 20]];
Print[""];

(* Verify convergence *)
Print["2. CONVERGENCE VERIFICATION"];
Print["   n       delta(n)              Error"];
Do[
  d = N[delta[n], 20];
  err = Abs[d - deltaInfinity];
  Print["   ", PaddedForm[n, 5], "  ", NumberForm[d, 15], "  ", ScientificForm[err, 3]],
  {n, {10, 100, 1000, 10000}}
];
Print[""];

(* Verify zeros *)
Print["3. ZERO VERIFICATION"];
Print["   Checking B(n, k_zero) = 0 for computed zeros...\n"];

Do[
  d = delta[n];
  (* Zero at k = 1/2 + i*delta *)
  kZero = 1/2 + I d;
  val = B[n, kZero] // ComplexExpand // N;
  Print["   n=", n, ": B(", n, ", 1/2 + i*delta) = ", val,
    If[Abs[val] < 10^-10, " OK", " FAILED"]],
  {n, {5, 10, 20, 50}}
];
Print[""];

(* Verify no real zeros *)
Print["4. NO REAL ZEROS VERIFICATION"];
Print["   Checking -1/beta(n) > 1 for all n >= 3...\n"];

allGood = True;
Do[
  c = -1/beta[n] // N;
  If[c <= 1, allGood = False; Print["   FAILED at n=", n]],
  {n, 3, 1000}
];
If[allGood,
  Print["   All n in [3, 1000]: -1/beta(n) > 1  OK"]
];
Print[""];

(* Verify symmetries *)
Print["5. SYMMETRY VERIFICATION"];

testN = 7;
testK = 2.3 + 0.5 I;

Print["   Using n=", testN, ", k=", testK];
Print[""];

(* B(n, 1-k) = B(n, k) *)
sym1 = B[testN, 1 - testK] - B[testN, testK] // ComplexExpand // N // Chop;
Print["   B(n, 1-k) - B(n, k) = ", sym1,
  If[sym1 == 0, "  OK", "  FAILED"]];

(* B(-n, k) = B(n, k) *)
sym2 = B[-testN, testK] - B[testN, testK] // ComplexExpand // N // Chop;
Print["   B(-n, k) - B(n, k) = ", sym2,
  If[sym2 == 0, "  OK", "  FAILED"]];

(* B(n, k+n) = B(n, k) *)
sym3 = B[testN, testK + testN] - B[testN, testK] // ComplexExpand // N // Chop;
Print["   B(n, k+n) - B(n, k) = ", sym3,
  If[sym3 == 0, "  OK", "  FAILED"]];

Print[""];

(* Critical points *)
Print["6. CRITICAL POINTS"];
Print["   Maximum at k = (n+1)/2:"];
Do[
  maxK = (n + 1)/2;
  maxVal = B[n, maxK] // N;
  Print["   n=", PaddedForm[n, 3], ": B(n, (n+1)/2) = ", NumberForm[maxVal, 10]],
  {n, {5, 10, 50, 100, 1000}}
];
Print["   Limit: 2\n"];

Print["   Minimum at k = 1/2:"];
Do[
  minK = 1/2;
  minVal = B[n, minK] // N;
  Print["   n=", PaddedForm[n, 3], ": B(n, 1/2) = ", NumberForm[minVal, 10]],
  {n, {5, 10, 50, 100, 1000}}
];
Print["   Limit: 0\n"];

Print["=== ALL VERIFICATIONS COMPLETE ==="];
