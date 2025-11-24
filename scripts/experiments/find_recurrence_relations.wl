#!/usr/bin/env wolframscript
(* Find recurrence relations for D(x,k) *)

Print["=== RECURRENCE RELATION APPROACH ===\n"];

(* Define both forms *)
factForm[x_, k_] := 1 + Sum[2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]), {i, 1, k}];
chebForm[x_, k_] := ChebyshevT[Ceiling[k/2], x+1] * (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

Print["Step 1: Compute D(x,k) for k=1..8"];
Print["===================================\n"];

dValues = Table[{k, factForm[x, k] // Expand}, {k, 1, 8}];

Do[
  {k, d} = dValues[[i]];
  Print["D(x,", k, ") = ", d];
, {i, 1, Length[dValues]}];
Print[];

Print["Step 2: Look for recurrence in k"];
Print["=================================\n"];

Print["Testing: D(x,k+1) = f(x) * D(x,k) + g(x) * D(x,k-1) ?\n"];

(* Try to find f, g for k=3 *)
d2 = factForm[x, 2] // Expand;
d3 = factForm[x, 3] // Expand;
d4 = factForm[x, 4] // Expand;

Print["Known:"];
Print["  D(x,2) = ", d2];
Print["  D(x,3) = ", d3];
Print["  D(x,4) = ", d4];
Print[];

Print["If D(x,4) = f(x)*D(x,3) + g(x)*D(x,2), we need:"];
Print["  f(x) = ? and g(x) = ?"];
Print[];

(* This is non-trivial - factorial form doesn't have obvious recurrence *)

Print["Step 3: Check Chebyshev side recurrence"];
Print["========================================\n"];

Print["Chebyshev polynomials have known recurrences:"];
Print["  T_{n+1}(y) = 2y*T_n(y) - T_{n-1}(y)"];
Print["  U_{n+1}(y) = 2y*U_n(y) - U_{n-1}(y)"];
Print[];

Print["Our form: T_n(x+1) * (U_m(x+1) - U_{m-1}(x+1))"];
Print["where n = Ceiling[k/2], m = Floor[k/2]"];
Print[];

Print["As k increases:"];
Do[
  n = Ceiling[k/2];
  m = Floor[k/2];
  Print["  k=", k, ": n=", n, ", m=", m];
, {k, 1, 8}];
Print[];

Print["Pattern: n and m increase by 1 every 2 steps"];
Print["This means recurrence in k involves k and k-2, not k and k-1!"];
Print[];

Print["Step 4: Test D(x,k) vs D(x,k-2) relation"];
Print["=========================================\n"];

Do[
  If[k > 2,
    dk = factForm[x, k] // Expand;
    dkMinus2 = factForm[x, k-2] // Expand;

    Print["k=", k, ":"];
    Print["  D(x,", k, ") = ", dk];
    Print["  D(x,", k-2, ") = ", dkMinus2];

    (* Try simple ratio *)
    (* ratio = Simplify[dk / dkMinus2]; *)
    (* Print["  Ratio: ", ratio]; *)
    Print[];
  ];
, {k, 3, 6}];

Print["=== OBSERVATION ==="];
Print["Factorial form doesn't have simple recurrence in k."];
Print["This is because i ranges from 1 to k, adding new terms each step."];
Print[];
Print["Induction approach would require showing:"];
Print["  If equality holds for k-1 and k-2, then holds for k"];
Print["But connecting D(x,k) to D(x,k-1), D(x,k-2) is non-trivial."];
Print[];
Print["BETTER APPROACH: Direct coefficient matching (tedious but systematic)."];
