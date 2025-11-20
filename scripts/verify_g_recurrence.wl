#!/usr/bin/env wolframscript
(* CRITICAL CHECK: Verify that g(n,k) = [x^k] ΔU_n(x+1) satisfies the derived recurrence *)

Print["="*70];
Print["VERIFY: g(n,k) RECURRENCE FROM POLYNOMIAL COEFFICIENTS"];
Print["="*70];
Print[];

Print["Theoretical derivation claimed:"];
Print["  g(n+2,k) = 4*g(n,k-2) + 8*g(n,k-1) + 2*g(n,k) - g(n-2,k)"];
Print[];
Print["where g(n,k) = [x^k] ΔU_n(x+1) are ACTUAL polynomial coefficients."];
Print[];
Print["This check verifies the derivation was correct!"];
Print[];
Print["="*70];
Print[];

(* Compute Chebyshev U polynomials *)
U[n_, x_] := ChebyshevU[n, x];

(* Compute ΔU_n = U_n - U_{n-1} *)
ΔU[n_, x_] := U[n, x] - U[n-1, x];

(* Extract coefficient [x^k] from polynomial *)
coeff[poly_, k_] := Coefficient[poly, x, k];

(* Define g(n,k) = [x^k] ΔU_n(x+1) *)
g[n_, k_] := coeff[ΔU[n, x+1], k];

Print["STEP 1: Compute g(n,k) for various n, k"];
Print["-"*70];
Print[];

(* Compute table of g values *)
Print["Computing g(n,k) for n ∈ {2,4,6,8,10,12,14}, k ∈ {0..n}"];
Print[];

gTable = Table[{n, k, g[n, k]}, {n, 2, 14, 2}, {k, 0, n}] // Flatten[#, 1]&;

Print["Sample values:"];
Do[
  If[k <= 5,
    Print["  g(", n, ",", k, ") = ", g[n, k]];
  ];
, {n, {2, 4, 6, 8}}, {k, 0, Min[n, 5]}];
Print[];

Print["="*70];
Print["STEP 2: Verify recurrence relation"];
Print["-"*70];
Print[];

Print["Checking: g(n+2,k) = 4*g(n,k-2) + 8*g(n,k-1) + 2*g(n,k) - g(n-2,k)"];
Print[];

allPass = True;
failCount = 0;
passCount = 0;

(* Test for n ∈ {4,6,8,10,12} (need n-2 and n+2 to be valid) *)
(* Test for k ∈ {2..n} (need k-2 to be valid) *)

testCases = Flatten[Table[{n, k}, {n, 4, 12, 2}, {k, 2, n}], 1];

Print["Testing ", Length[testCases], " cases..."];
Print[];

Do[
  {n, k} = testCase;

  (* LHS: g(n+2, k) *)
  lhs = g[n+2, k];

  (* RHS: 4*g(n,k-2) + 8*g(n,k-1) + 2*g(n,k) - g(n-2,k) *)
  term1 = 4 * g[n, k-2];
  term2 = 8 * g[n, k-1];
  term3 = 2 * g[n, k];
  term4 = g[n-2, k];

  rhs = term1 + term2 + term3 - term4;

  match = (lhs == rhs);

  If[match,
    passCount++;
    (* Print["✓ n=", n, ", k=", k, ": ", lhs, " = ", rhs]; *)
    ,
    failCount++;
    allPass = False;
    Print["✗ FAIL at n=", n, ", k=", k];
    Print["  LHS = g(", n+2, ",", k, ") = ", lhs];
    Print["  RHS = 4*g(", n, ",", k-2, ") + 8*g(", n, ",", k-1, ") + 2*g(", n, ",", k, ") - g(", n-2, ",", k, ")"];
    Print["      = 4*", g[n,k-2], " + 8*", g[n,k-1], " + 2*", g[n,k], " - ", g[n-2,k]];
    Print["      = ", term1, " + ", term2, " + ", term3, " - ", term4];
    Print["      = ", rhs];
    Print["  DIFFERENCE: ", lhs - rhs];
    Print[];
  ];
, {testCase, testCases}];

Print["="*70];
Print["RESULTS"];
Print["="*70];
Print[];

Print["Passed: ", passCount, " / ", Length[testCases]];
Print["Failed: ", failCount, " / ", Length[testCases]];
Print[];

If[allPass,
  Print["SUCCESS: All test cases pass!"];
  Print[];
  Print["CONCLUSION: The derived recurrence is CORRECT."];
  Print["g(n,k) from polynomial coefficients satisfies:"];
  Print["  g(n+2,k) = 4*g(n,k-2) + 8*g(n,k-1) + 2*g(n,k) - g(n-2,k)"];
  Print[];
  Print["This validates the theoretical derivation from Chebyshev structure."];
  ,
  Print["FAILURE: Recurrence does NOT hold for actual polynomial coefficients!"];
  Print[];
  Print["This means there is an ERROR in the theoretical derivation."];
  Print["Need to re-examine the coefficient extraction step."];
];

Print[];
Print["="*70];
Print["STEP 3: Also verify the simpler step-1 recurrence"];
Print["-"*70];
Print[];

Print["Chebyshev gives: ΔU_{n+1}(x) = 2x*ΔU_n(x) - ΔU_{n-1}(x)"];
Print["With shift x→x+1: ΔU_{n+1}(x+1) = 2(x+1)*ΔU_n(x+1) - ΔU_{n-1}(x+1)"];
Print[];

Print["Extracting [x^k]: g(n+1,k) = 2*g(n,k-1) + 2*g(n,k) - g(n-1,k)"];
Print[];

allPassStep1 = True;
failCountStep1 = 0;
passCountStep1 = 0;

testCasesStep1 = Flatten[Table[{n, k}, {n, 2, 12, 1}, {k, 1, n}], 1];

Print["Testing ", Length[testCasesStep1], " cases for step-1 recurrence..."];
Print[];

Do[
  {n, k} = testCase;

  lhs = g[n+1, k];
  rhs = 2*g[n, k-1] + 2*g[n, k] - g[n-1, k];

  match = (lhs == rhs);

  If[match,
    passCountStep1++;
    ,
    failCountStep1++;
    allPassStep1 = False;
    Print["✗ FAIL at n=", n, ", k=", k];
    Print["  g(", n+1, ",", k, ") = ", lhs];
    Print["  2*g(", n, ",", k-1, ") + 2*g(", n, ",", k, ") - g(", n-1, ",", k, ") = ", rhs];
    Print["  DIFFERENCE: ", lhs - rhs];
    Print[];
  ];
, {testCase, testCasesStep1}];

Print["Step-1 recurrence results:"];
Print["Passed: ", passCountStep1, " / ", Length[testCasesStep1]];
Print["Failed: ", failCountStep1, " / ", Length[testCasesStep1]];
Print[];

If[allPassStep1,
  Print["✓ Step-1 recurrence is correct."];
  ,
  Print["✗ Step-1 recurrence also has errors!"];
];

Print[];
