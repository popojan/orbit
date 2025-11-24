#!/usr/bin/env wolframscript
(* Attempt: Prove via recurrence relation *)

Print["=== RECURRENCE RELATION APPROACH ===\n"];

factForm[x_, k_] := 1 + Sum[2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]), {i, 1, k}];

chebForm[x_, k_] := ChebyshevT[Ceiling[k/2], x+1] *
  (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

Print["Step 1: Check if factorial form satisfies recurrence"];
Print["=====================================================\n"];

Print["Chebyshev recurrence:"];
Print["  T_{n+1}(y) = 2y*T_n(y) - T_{n-1}(y)"];
Print["  U_{n+1}(y) = 2y*U_n(y) - U_{n-1}(y)\n"];

Print["Question: Does D(x,k) satisfy a similar recurrence?\n"];

Print["Computing D(x,k) for k=1..6:\n"];
Do[
  d[k] = factForm[x, k] // Expand;
  Print["D(x,", k, ") = ", d[k]];
, {k, 1, 6}];
Print["\n"];

Print["Step 2: Look for pattern in D(x,k+1) vs D(x,k)"];
Print["================================================\n"];

Print["Check if: D(x,k+1) = f(x) * D(x,k) + g(x) * D(x,k-1)\n"];

Do[
  Print["k=", k, ":"];
  Print["  D(x,", k+1, ") = ", d[k+1]];
  Print["  D(x,", k, ") = ", d[k]];

  (* Try to find relationship *)
  (* This is complex - would need symbolic manipulation *)

  Print[];
, {k, 1, 4}];

Print["Step 3: Alternative - verify via Chebyshev recursion"];
Print["=====================================================\n"];

Print["We know Chebyshev form satisfies recursion."];
Print["If we can show factorial form = Chebyshev form algebraically,"];
Print["then factorial form inherits the recursion property.\n"];

Print["But that's circular reasoning - we're trying to prove equality!\n"];

Print["Step 4: Try coefficient extraction approach"];
Print["============================================\n"];

Print["Extract k-th coefficient from Chebyshev product:\n"];

Do[
  n = Ceiling[k/2];
  m = Floor[k/2];

  Print["k=", k, ": n=", n, ", m=", m];

  (* Expand T_n and U_m explicitly *)
  tn = ChebyshevT[n, x+1] // Expand;
  um = ChebyshevU[m, x+1] // Expand;
  umPrev = ChebyshevU[m-1, x+1] // Expand;

  Print["  T_", n, "(x+1) = ", tn];
  Print["  U_", m, "(x+1) - U_", m-1, "(x+1) = ", um - umPrev // Expand];

  product = tn * (um - umPrev) // Expand;
  Print["  Product = ", product];

  (* Compare coefficient of x^1 *)
  chebCoeff1 = Coefficient[product, x, 1];
  factCoeff1 = 2^(1-1) * Factorial[k+1]/(Factorial[k-1] * Factorial[2*1]);

  Print["  Coeff of x: Cheb=", chebCoeff1, ", Fact=", factCoeff1];
  Print[];
, {k, 1, 5}];

Print["Step 5: Observation"];
Print["===================\n"];

Print["The challenge: We need to prove that"];
Print["  [coefficient of x^i in T_n(x+1)*(U_m(x+1)-U_{m-1}(x+1))]"];
Print["  = 2^(i-1) * (k+i)! / ((k-i)! * (2i)!)\n"];

Print["This requires extracting explicit formula for Chebyshev"];
Print["polynomial coefficients, which is non-trivial.\n"];

Print["Standard approach would be:"];
Print["  1. Use explicit Chebyshev coefficient formulas"];
Print["  2. Compute product coefficient via convolution"];
Print["  3. Show it matches factorial form\n"];

Print["This is algebraically intensive but doable in principle."];
