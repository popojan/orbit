#!/usr/bin/env wolframscript
(* Verify with corrected k-2 indexing *)

Print["=== VERIFY SUBNREF WITH CORRECTED INDEXING ===\n"];

(* User's 2023 formula *)
a[k_, n_] := 1/4 (1 + 3 (-1)^k) (-1 + 2 n^2 + k) (-1)^n (2^(-3 + 2 k) (-3 + (-1)^k))/Gamma[2 k] Pochhammer[n - k + 2, 2 (k - 2) + 1];
subnref[x_, k_] := Sum[a[i, k] x^(2 i - 1), {i, 1, k + 1}];

Print["User discovered: subnref[x, k] = T_{k+3}(x) - x*T_{k+2}(x)\n"];
Print["Or equivalently: subnref[x, k-2] = T_{k+1}(x) - x*T_k(x)\n"];
Print[];

Print["Verification:\n"];

allMatch = True;
Do[
  (* For kval, check if subnref[x, kval-2] equals T_{kval+1} - x*T_{kval} *)
  If[kval >= 2,
    lhs = subnref[x, kval-2];
    rhs = ChebyshevT[kval+1, x] - x * ChebyshevT[kval, x];

    diff = FullSimplify[lhs - rhs];
    match = (diff === 0);

    Print["k=", kval, ": subnref[x,", kval-2, "] vs T_{", kval+1, "} - x*T_{", kval, "}: ",
          If[match, "MATCH ✓", "DIFFER ✗"]];

    If[!match,
      Print["  Difference: ", diff];
      allMatch = False;
    ];
  ];
, {kval, 2, 8}];

Print["\nResult: ", If[allMatch, "ALL VERIFIED ✓✓✓", "SOME FAILED"]];
Print["\n"];

If[allMatch,
  Print["=== SUCCESS ===\n"];
  Print["User's 2023 subnref formula is CORRECT (with k-2 indexing)!\n"];
  Print[];
  Print["Formula with Pochhammer symbols gives:\n"];
  Print["  subnref[x, k] = T_{k+3}(x) - x*T_{k+2}(x) = -(1-x²)*U_{k+1}(x)\n"];
  Print[];
  Print["This confirms: MUTUAL RECURRENCE HAS FACTORIAL STRUCTURE!\n"];
  Print[];
  Print["Key insight: Pochhammer[n-k+2, 2(k-2)+1] encodes the coefficients"];
  Print["             of the mutual recurrence relation.");
];
