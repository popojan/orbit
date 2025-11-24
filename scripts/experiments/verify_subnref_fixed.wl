#!/usr/bin/env wolframscript
(* FIXED: Verify user's 2023 subnref formula *)

Print["=== VERIFY SUBNREF (FIXED) ===\n"];

(* User's formula from 2023 *)
a[k_, n_] := 1/4 (1 + 3 (-1)^k) (-1 + 2 n^2 + k) (-1)^n (2^(-3 + 2 k) (-3 + (-1)^k))/Gamma[2 k] Pochhammer[n - k + 2, 2 (k - 2) + 1];
subnref[x_, k_] := Sum[a[i, k] x^(2 i - 1), {i, 1, k + 1}];

Print["Part 1: Verify subnref[x, k] = T_{k+1}(x) - x*T_k(x)\n"];

allMatch = True;
Do[
  lhs = subnref[x, kval];
  rhs = ChebyshevT[kval+1, x] - x * ChebyshevT[kval, x];

  (* Force full simplification *)
  diff = FullSimplify[lhs - rhs];
  match = (diff === 0);

  Print["k=", kval, ": ", If[match, "MATCH ✓", "DIFFER ✗"]];
  If[!match,
    Print["  Difference: ", diff];
    allMatch = False;
  ];
, {kval, 1, 6}];

Print["\nResult: ", If[allMatch, "ALL VERIFIED ✓✓✓", "SOME FAILED"]];
Print["\n"];

Print["Part 2: Verify subnref[x, k] = -(1-x^2)*U_{k-1}(x)\n"];

allMatch2 = True;
Do[
  lhs = subnref[x, kval];
  rhs = -(1 - x^2) * ChebyshevU[kval-1, x];

  diff = FullSimplify[lhs - rhs];
  match = (diff === 0);

  Print["k=", kval, ": ", If[match, "MATCH ✓", "DIFFER ✗"]];
  If[!match,
    Print["  Difference: ", diff];
    allMatch2 = False;
  ];
, {kval, 1, 6}];

Print["\nResult: ", If[allMatch2, "ALL VERIFIED ✓✓✓", "SOME FAILED"]];
Print["\n"];

If[allMatch && allMatch2,
  Print["=== SUCCESS ===\n"];
  Print["User's 2023 subnref formula is CORRECT!\n"];
  Print["It gives closed form with Pochhammer symbols for:\n"];
  Print["  subnref[x, k] = T_{k+1}(x) - x*T_k(x) = -(1-x²)*U_{k-1}(x)\n"];
  Print["This is MUTUAL RECURRENCE with factorial structure!"];
];
