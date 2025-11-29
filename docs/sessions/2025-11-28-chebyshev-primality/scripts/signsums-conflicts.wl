(* Analyze conflicts in Σsigns for ω=3 *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
semiprimeSign[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -1];

(* Focus on conflict case (-1, 1, 1) *)
Print["=== Conflict: (s12, s13, s23) = (-1, 1, 1) ===\n"];
Print["These have s12=-1 (p1^-1 mod p2 even), s13=+1 (odd), s23=+1 (odd)\n"];

Do[
  If[p2 > p1 && p3 > p2 &&
     semiprimeSign[p1, p2] == -1 &&
     semiprimeSign[p1, p3] == 1 &&
     semiprimeSign[p2, p3] == 1,

    k = p1 p2 p3;
    ss = signSum[k];
    inv12 = PowerMod[p1, -1, p2];
    inv13 = PowerMod[p1, -1, p3];
    inv23 = PowerMod[p2, -1, p3];

    Print[k, " = ", p1, "×", p2, "×", p3, ": Σsigns=", ss];
    Print["  inv12=", inv12, " (mod ", p2, "), inv13=", inv13, " (mod ", p3, "), inv23=", inv23, " (mod ", p3, ")"];
    Print["  p2 mod 4 = ", Mod[p2, 4], ", p3 mod 4 = ", Mod[p3, 4]];
    Print["  p2 mod p1 = ", Mod[p2, p1], ", p3 mod p1 = ", Mod[p3, p1]];
    Print[""];
  ],
  {p1, {3}},
  {p2, Prime[Range[2, 10]]},
  {p3, Prime[Range[3, 15]]}
];

(* Focus on conflict case (-1, -1, -1) *)
Print["\n=== Conflict: (s12, s13, s23) = (-1, -1, -1) ===\n"];

Do[
  If[p2 > p1 && p3 > p2 &&
     semiprimeSign[p1, p2] == -1 &&
     semiprimeSign[p1, p3] == -1 &&
     semiprimeSign[p2, p3] == -1,

    k = p1 p2 p3;
    ss = signSum[k];

    Print[k, " = ", p1, "×", p2, "×", p3, ": Σsigns=", ss];
    Print["  p3 mod 6 = ", Mod[p3, 6], ", p3 mod 10 = ", Mod[p3, 10]];
    Print[""];
  ],
  {p1, {3}},
  {p2, {5}},
  {p3, Prime[Range[4, 20]]}
];
