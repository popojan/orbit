#!/usr/bin/env wolframscript
(* Verify exactly what user tested *)

Print["=== VERIFY USER'S TEST ===\n"];

(* User's formula *)
a[k_, n_] := 1/4 (1 + 3 (-1)^k) (-1 + 2 n^2 + k) (-1)^n (2^(-3 + 2 k) (-3 + (-1)^k))/Gamma[2 k] Pochhammer[n - k + 2, 2 (k - 2) + 1];
subnref[x_, k_] := Sum[a[i, k] x^(2 i - 1), {i, 1, k + 1}];

(* Alternative definition *)
subnref2[x_, k_] := ChebyshevT[k + 1, x] - x*ChebyshevT[k, x];

Print["User's test: subnref[x, 2] - subnref2[x, 4] == 0\n"];
Print[];

val1 = subnref[x, 2] // Expand;
val2 = subnref2[x, 4] // Expand;

Print["subnref[x, 2] = ", val1];
Print["subnref2[x, 4] = ", val2];
Print[];

diff = FullSimplify[val1 - val2];
Print["Difference = ", diff];
Print["Match: ", diff === 0];
Print[];

(* If this works, maybe the pattern is subnref[x, k] = subnref2[x, 2k]? *)
Print["Hypothesis: subnref[x, k] = subnref2[x, 2k] = T_{2k+1}(x) - x*T_{2k}(x)\n"];
Print[];

Print["Testing pattern:\n"];
Do[
  lhs = subnref[x, kval];
  rhs = subnref2[x, 2*kval];

  diff = FullSimplify[lhs - rhs];
  match = (diff === 0);

  Print["k=", kval, ": subnref[x,", kval, "] vs subnref2[x,", 2*kval, "]: ",
        If[match, "MATCH ✓", "DIFFER ✗"]];

  If[!match && kval <= 3,
    Print["  Difference: ", diff];
  ];
, {kval, 1, 5}];

Print["\n"];

(* Maybe it's not 2k but some other relation? *)
Print["Let me search for the pattern...\n"];
Print["For each k in subnref, find which subnref2 index it equals:\n"];

Do[
  val = subnref[x, ktest] // Expand;

  foundMatch = False;
  Do[
    candidate = subnref2[x, ktest2] // Expand;
    If[FullSimplify[val - candidate] === 0,
      Print["subnref[x, ", ktest, "] = subnref2[x, ", ktest2, "] = T_{", ktest2+1, "} - x*T_{", ktest2, "}"];
      foundMatch = True;
      Break[];
    ];
  , {ktest2, 0, 15}];

  If[!foundMatch,
    Print["subnref[x, ", ktest, "]: NO MATCH FOUND in range"];
  ];
, {ktest, 0, 4}];
