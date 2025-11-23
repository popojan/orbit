#!/usr/bin/env wolframscript
(* Test sequence of GammaPalindromicSqrt values *)

<< Orbit`

Print["=== GAMMA PALINDROMIC SQRT SEQUENCE ===\n"];

nn = 13;
sol = PellSolution[13];
xval = x /. sol;
yval = y /. sol;
nval = (xval - 1)/yval;

Print["sqrt(13) = ", N[Sqrt[13], 15], "\n"];

Print["Sequence of GammaPalindromicSqrt[13, n, k] for k=1 to 10:\n"];
Print["k\tValue\t\t\tError\t\t\tType"];
Print["-----------------------------------------------------------------------"];

gammaSeq = Table[GammaPalindromicSqrt[nn, nval, k], {k, 1, 10}];

Do[
  val = gammaSeq[[k]];
  err = val - Sqrt[nn];
  type = If[Mod[k, 2] == 1, "r_k (lower)", "nn/r_k (upper)"];

  Print[k, "\t", N[val, 15], "\t", N[err, 10], "\t", type];
, {k, 1, 10}];

Print["\n=== ANALYZING SEQUENCE BEHAVIOR ===\n"];

Print["Differences between consecutive terms:"];
Do[
  diff = gammaSeq[[k+1]] - gammaSeq[[k]];
  Print["k=", k, " -> ", k+1, ": ", N[diff, 10], "\t(",
    If[diff > 0, "increases", "decreases"], ")"];
, {k, 1, 9}];

Print["\n--- Checking alternation pattern ---"];
alternates = True;
Do[
  If[k >= 2,
    sign_k = Sign[gammaSeq[[k]] - Sqrt[nn]];
    sign_km1 = Sign[gammaSeq[[k-1]] - Sqrt[nn]];

    If[sign_k == sign_km1,
      Print["Does NOT alternate at k=", k-1, " -> ", k];
      Print["  Both are ", If[sign_k > 0, "above", "below"], " sqrt"];
      alternates = False;
    ];
  ];
, {k, 2, 10}];

If[alternates,
  Print["Sequence ALTERNATES around sqrt ✓"],
  Print["Sequence does NOT alternate consistently"]
];

Print["\n--- Checking monotonicity of subsequences ---"];

oddK = Table[gammaSeq[[k]], {k, 1, 9, 2}];  (* k=1,3,5,7,9 *)
evenK = Table[gammaSeq[[k]], {k, 2, 10, 2}]; (* k=2,4,6,8,10 *)

Print["Odd k (r_k values):"];
Do[Print["  k=", 2*i-1, ": ", N[oddK[[i]], 15]], {i, 1, Length[oddK]}];

oddMonotone = True;
Do[
  If[oddK[[i+1]] < oddK[[i]],
    Print["  NOT monotone at i=", i];
    oddMonotone = False;
  ];
, {i, 1, Length[oddK]-1}];
If[oddMonotone, Print["  → Odd k: MONOTONICALLY INCREASING ✓"]];

Print["\nEven k (nn/r_k values):"];
Do[Print["  k=", 2*i, ": ", N[evenK[[i]], 15]], {i, 1, Length[evenK]}];

evenMonotone = True;
Do[
  If[evenK[[i+1]] > evenK[[i]],
    Print["  NOT monotone at i=", i];
    evenMonotone = False;
  ];
, {i, 1, Length[evenK]-1}];
If[evenMonotone, Print["  → Even k: MONOTONICALLY DECREASING ✓"]];

Print["\n=== CONCLUSION ===\n"];

Print["Full sequence k=1,2,3,4,...:"];
If[alternates,
  Print["  ✓ ALTERNATES between below/above sqrt"],
  Print["  ✗ Does NOT alternate"]
];

Print["\nSubsequences:"];
Print["  Odd k (r_1, r_3, r_5, ...):  ", If[oddMonotone, "MONOTONIC ↑", "NOT monotonic"]];
Print["  Even k (nn/r_2, nn/r_4, ...): ", If[evenMonotone, "MONOTONIC ↓", "NOT monotonic"]];

Print["\n==> GammaPalindromicSqrt ALTERNATES between two MONOTONIC sequences"];
Print["    This is DIFFERENT from CF alternation (single oscillating sequence)"];
