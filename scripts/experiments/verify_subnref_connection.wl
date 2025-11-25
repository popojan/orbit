#!/usr/bin/env wolframscript
(* Verify user's 2023 formula and explore connection to our proof *)

Print["=== VERIFY SUBNREF CONNECTION ===\n"];

(* User's formula from 2023 *)
a[k_, n_] := 1/4 (1 + 3 (-1)^k) (-1 + 2 n^2 + k) (-1)^n (2^(-3 + 2 k) (-3 + (-1)^k))/Gamma[2 k] Pochhammer[n - k + 2, 2 (k - 2) + 1];
subnref[x_, k_] := Sum[a[i, k] x^(2 i - 1), {i, 1, k + 1}];

Print["Part 1: Verify subnref[x, k] = T_{k+1}(x) - x*T_k(x)\n"];

Do[
  lhs = subnref[x, kval] // Expand;
  rhs = ChebyshevT[kval+1, x] - x * ChebyshevT[kval, x] // Expand;

  match = Simplify[lhs - rhs] == 0;

  Print["k=", kval, ": ", If[match, "MATCH ✓", "DIFFER ✗"]];
  If[!match,
    Print["  LHS: ", lhs];
    Print["  RHS: ", rhs];
  ];
, {kval, 1, 5}];

Print["\n"];

Print["Part 2: Verify subnref[x, k] = -(1-x^2)*U_{k-1}(x)\n"];

Do[
  lhs = subnref[x, kval] // Expand;
  rhs = -(1 - x^2) * ChebyshevU[kval-1, x] // Expand;

  match = Simplify[lhs - rhs] == 0;

  Print["k=", kval, ": ", If[match, "MATCH ✓", "DIFFER ✗"]];
  If[!match,
    Print["  subnref: ", lhs];
    Print["  -(1-x²)U: ", rhs];
  ];
, {kval, 1, 5}];

Print["\n"];

Print["Part 3: Analyze factorial structure in subnref coefficients\n"];

(* For k=3, look at coefficient structure *)
ktest = 3;
Print["Example: k=", ktest, "\n"];

subPoly = subnref[x, ktest] // Expand;
Print["subnref[x,", ktest, "] = ", subPoly];
Print[];

coeffs = CoefficientList[subPoly, x];
Print["Coefficients: ", coeffs];
Print[];

(* Show Pochhammer structure *)
Print["From a[k,n] formula, coefficients involve:\n"];
Print["  - Pochhammer[n-k+2, 2(k-2)+1] (factorial-like)"];
Print["  - Powers of 2"];
Print["  - Alternating signs"];
Print[];

Print["Part 4: Connection to U_m(x+1) - U_{m-1}(x+1)\n"];

(* Our product needs U_m(x+1) - U_{m-1}(x+1) *)
(* Can we express this using subnref? *)

Print["For shifted argument x+1:\n"];

Do[
  deltaU = ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1] // Expand;

  Print["m=", m, ": U_m(x+1) - U_{m-1}(x+1) = ", deltaU];

  (* Check if this relates to subnref at some k *)
  (* U_m - U_{m-1} might relate to T polynomials via mutual recurrence *)

, {m, 1, 4}];

Print["\n"];

Print["Part 5: KEY QUESTION\n"];
Print["Can we express T_n(x+1) * [U_m(x+1) - U_{m-1}(x+1)] using subnref?\n"];

(* For k=4: n=2, m=2 *)
k = 4;
n = Ceiling[k/2];
m = Floor[k/2];

Print["Example: k=", k, " (n=", n, ", m=", m, ")\n"];

tn = ChebyshevT[n, x+1] // Expand;
deltaU = ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1] // Expand;
product = Expand[tn * deltaU];

Print["Our product: ", product];
Print[];

(* Try to relate to mutual recurrence *)
Print["Mutual recurrence at x+1:\n"];
Print["  T_{k+1}(x+1) - (x+1)*T_k(x+1) = -(1-(x+1)^2)*U_{k-1}(x+1)"];
Print["                                  = x(x+2)*U_{k-1}(x+1)"];
Print[];

(* For various k values, check if deltaU relates to this *)
Do[
  rhs = Expand[xvar*(xvar+2) * ChebyshevU[kval-1, xvar+1]] /. xvar -> x;
  Print["k=", kval, ": x(x+2)*U_{", kval-1, "}(x+1) = ", rhs];
, {kval, 2, 4}];

Print["\n"];

Print["Part 6: Look for pattern in U_m(x+1) - U_{m-1}(x+1)\n"];

Print["Hypothesis: U_m(x) - U_{m-1}(x) might have closed form with factorials\n"];

(* Check if U_m - U_{m-1} can be expressed via generating functions *)
(* U_n has generating function 1/(1-2xt+t^2) *)
(* U_n - U_{n-1} comes from (1 - t) * 1/(1-2xt+t^2) *)

Print["Generating function approach:\n"];
Print["  U_n: coefficient of t^n in 1/(1-2xt+t^2)"];
Print["  U_n - U_{n-1}: coefficient of t^n in (1-t)/(1-2xt+t^2)"];
Print[];

(* This might simplify! *)
genFunc = (1-t)/(1-2*x*t+t^2);
Print["Generating function for U_n - U_{n-1}: ", genFunc];
Print[];

(* Extract coefficients *)
Print["Coefficients:\n"];
ser = Series[genFunc /. x -> xsym, {t, 0, 5}] // Normal;
Do[
  coeff = Coefficient[ser, t, nval] // Simplify;
  Print["  [t^", nval, "]: ", coeff];
, {nval, 0, 5}];

Print["\n=== ASSESSMENT ===\n"];
Print["User's subnref formula from 2023 has FACTORIAL structure (Pochhammer)"];
Print["and equals T_{k+1}(x) - x*T_k(x) = -(1-x²)*U_{k-1}(x)\n"];

Print["This connects:");
Print["  1. Factorial/Pochhammer symbols (like our Egypt formula)"];
Print["  2. U polynomials (which appear in our Chebyshev form)"];
Print["  3. Mutual recurrence (structural connection)\n"];

Print["Next: Can we use this to prove coefficient recurrence algebraically?"];
