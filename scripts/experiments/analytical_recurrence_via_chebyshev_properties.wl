#!/usr/bin/env wolframscript
(* Analytical proof of recurrence using Chebyshev three-term recurrence *)

Print["=== ANALYTICAL RECURRENCE PROOF ===\n"];

Print["Strategy: Use Chebyshev three-term recurrence relations"];
Print["to derive coefficient recurrence for product T_n(x+1) * DeltaU_m(x+1)\n"];

Print["Standard Chebyshev recurrences:"];
Print["  T_{n+1}(y) = 2y T_n(y) - T_{n-1}(y)"];
Print["  U_{n+1}(y) = 2y U_n(y) - U_{n-1}(y)"];
Print["\n"];

Print["Part 1: Coefficient recurrence for T_n(x+1)\n"];

(* For T_n(x+1), use shifted recurrence *)
(* Let P_n(x) = T_n(x+1) *)
(* Then: P_{n+1}(x) = T_{n+1}(x+1) = 2(x+1) T_n(x+1) - T_{n-1}(x+1) *)
(*                   = 2(x+1) P_n(x) - P_{n-1}(x) *)

Print["Let P_n(x) = T_n(x+1)"];
Print["Recurrence: P_{n+1}(x) = 2(x+1) P_n(x) - P_{n-1}(x)"];
Print["           = (2x+2) P_n(x) - P_{n-1}(x)"];
Print["\n"];

Print["Verification:"];
Do[
  pn = ChebyshevT[n, x+1] // Expand;
  pnp1_rec = Expand[(2*x+2)*pn - ChebyshevT[n-1, x+1]];
  pnp1_direct = ChebyshevT[n+1, x+1] // Expand;

  match = (pnp1_rec == pnp1_direct);
  Print["  n=", n, ": P_{n+1} via recurrence ", If[match, "MATCHES", "DIFFERS"], " from direct"];
, {n, 1, 4}];
Print["\n"];

Print["Part 2: Coefficient recurrence for U_n(x+1)\n"];

Print["Let Q_n(x) = U_n(x+1)"];
Print["Recurrence: Q_{n+1}(x) = 2(x+1) Q_n(x) - Q_{n-1}(x)"];
Print["\n"];

Print["Verification:"];
Do[
  qn = ChebyshevU[n, x+1] // Expand;
  qnp1_rec = Expand[(2*x+2)*qn - ChebyshevU[n-1, x+1]];
  qnp1_direct = ChebyshevU[n+1, x+1] // Expand;

  match = (qnp1_rec == qnp1_direct);
  Print["  n=", n, ": Q_{n+1} via recurrence ", If[match, "MATCHES", "DIFFERS"], " from direct"];
, {n, 0, 4}];
Print["\n"];

Print["Part 3: Derive recurrence for product coefficients\n"];

(* For specific k, compute product and extract recurrence pattern *)
k = 4;
n = Ceiling[k/2];
m = Floor[k/2];

Print["Example: k=", k, " (n=", n, ", m=", m, ")\n"];

tn = ChebyshevT[n, x+1] // Expand;
deltaU = (ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1]) // Expand;
product = Expand[tn * deltaU];

Print["T_", n, "(x+1) = ", tn];
Print["DeltaU_", m, "(x+1) = ", deltaU];
Print["Product = ", product];
Print["\n"];

coeffs = CoefficientList[product, x];
Print["Coefficients: ", coeffs];
Print["\n"];

(* Check if product satisfies a recurrence in n *)
Print["Part 4: Look for pattern using different k values\n"];

(* Generate table of products for k=1..8 *)
Print["Products for k=1..8:\n"];
Do[
  n_k = Ceiling[k_iter/2];
  m_k = Floor[k_iter/2];

  tn_k = ChebyshevT[n_k, x+1];
  deltaU_k = ChebyshevU[m_k, x+1] - ChebyshevU[m_k-1, x+1];
  prod_k = Expand[tn_k * deltaU_k];

  Print["  k=", k_iter, " (n=", n_k, ", m=", m_k, "): ", prod_k];
, {k_iter, 1, 6}];
Print["\n"];

Print["Part 5: Analyze coefficient structure using hypergeometric form\n"];

(* Express coefficients in terms of factorials *)
Print["Factorial form coefficients:"];
Do[
  c_fac = If[i == 0, 1, 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i])];
  Print["  c_F[", i, "] = ", c_fac];
, {i, 0, k}];
Print["\n"];

(* Rewrite as Pochhammer *)
Print["Using Pochhammer symbols (rising factorial):"];
Print["  (k+i)! / (k-i)! = Pochhammer[k-i+1, 2i]"];
Print["  So: c_F[i] = 2^(i-1) * Pochhammer[k-i+1, 2i] / (2i)!"];
Print["\n"];

Print["This is a HYPERGEOMETRIC term in i:"];
Print["  c_F[i] / c_F[i-1] = ratio of hypergeometric terms"];
Print["\n"];

(* Compute ratio *)
Print["Ratio c_F[i] / c_F[i-1]:"];
Print["  = [2^(i-1) * Poch[k-i+1, 2i] / (2i)!] / [2^(i-2) * Poch[k-i+2, 2i-2] / (2i-2)!]"];
Print["  = 2 * Poch[k-i+1, 2i] * (2i-2)! / (Poch[k-i+2, 2i-2] * (2i)!)"];
Print["\n"];

(* Simplify Pochhammer ratio *)
Print["Pochhammer property: Poch[a, n] = a * Poch[a+1, n-1]"];
Print["  Poch[k-i+1, 2i] = (k-i+1) * Poch[k-i+2, 2i-1]"];
Print["                  = (k-i+1) * (k-i+2) * Poch[k-i+3, 2i-2]  (apply twice)"];
Print["\n"];

(* But Poch[k-i+2, 2i-2] is in denominator *)
Print["Wait, denominator has Poch[k-i+2, 2i-2]"];
Print["Numerator has Poch[k-i+1, 2i] = (k-i+1)(k-i+2)...(k+i)"];
Print["Denominator has Poch[k-i+2, 2i-2] = (k-i+2)(k-i+3)...(k+i-1)"];
Print["\n"];

Print["Ratio = (k-i+1)(k-i+2)...(k+i) / [(k-i+2)(k-i+3)...(k+i-1)]"];
Print["      = (k-i+1) * (k+i) / 1  (most terms cancel)"];
Print["      = (k-i+1)(k+i)"];
Print["\n"];

Print["Factorial ratio: (2i-2)! / (2i)! = 1 / ((2i)(2i-1))"];
Print["\n"];

Print["TOTAL RATIO: c_F[i] / c_F[i-1] = 2 * (k-i+1)(k+i) / ((2i)(2i-1))"];
Print["                                = 2(k+i)(k-i+1) / ((2i)(2i-1))  ✓✓✓"];
Print["\n"];

Print["This CONFIRMS the factorial recurrence algebraically!"];
Print["\n"];

Print["=== NEXT: Prove Chebyshev product satisfies same recurrence ===\n"];
Print["This requires analyzing coefficients of T_n(x+1) * DeltaU_m(x+1)"];
Print["using Chebyshev polynomial properties...\n"];
