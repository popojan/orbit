(* Direct computation of Σsigns for semiprimes *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;

(* Sign of lobe n is (-1)^(n-1): odd n → +1, even n → -1 *)
signSum[k_] := Module[{primLobes},
  primLobes = Select[Range[2, k-1], isPrimitiveLobe[#, k] &];
  Total[(-1)^(# - 1) & /@ primLobes]
];

(* Also compute #odd - #even directly *)
signSumDirect[k_] := Module[{primLobes, odd, even},
  primLobes = Select[Range[2, k-1], isPrimitiveLobe[#, k] &];
  odd = Count[primLobes, n_ /; OddQ[n]];
  even = Count[primLobes, n_ /; EvenQ[n]];
  {odd, even, odd - even, primLobes}
];

Print["=== PRIME POWERS ==="];
Do[
  {odd, even, diff, lobes} = signSumDirect[p^e];
  Print[p^e, " = ", p, "^", e, ": lobes=", lobes,
        " #odd=", odd, " #even=", even, " Σsigns=", diff],
  {p, {3, 5, 7}}, {e, {1, 2}}
];

Print["\n=== SEMIPRIMES 3×q ==="];
Do[
  k = 3 q;
  {odd, even, diff, lobes} = signSumDirect[k];
  Print[k, " = 3×", q, " (q mod 6 = ", Mod[q, 6], "): ",
        "lobes=", lobes, " #odd=", odd, " #even=", even, " Σsigns=", diff],
  {q, {5, 7, 11, 13, 17, 19, 23, 29, 31}}
];

Print["\n=== SEMIPRIMES 5×q ==="];
Do[
  k = 5 q;
  {odd, even, diff, lobes} = signSumDirect[k];
  Print[k, " = 5×", q, ": lobes=", lobes, " #odd=", odd, " #even=", even, " Σsigns=", diff],
  {q, {7, 11, 13, 17, 19, 23, 29}}
];

Print["\n=== SEMIPRIMES 7×q ==="];
Do[
  k = 7 q;
  {odd, even, diff, lobes} = signSumDirect[k];
  Print[k, " = 7×", q, ": lobes=", lobes, " #odd=", odd, " #even=", even, " Σsigns=", diff],
  {q, {11, 13, 17, 19, 23, 29}}
];
