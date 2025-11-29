(* Deeper analysis: what determines Σsigns within conflict classes? *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
semiprimeSign[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -1];

Print["=== Conflict (-1,-1,-1): 3 × 5 × p3 ===\n"];
Print["Hypothesis: Σsigns depends on p3 mod 10\n"];

Do[
  p1 = 3; p2 = 5;
  If[PrimeQ[p3] && p3 > p2 &&
     semiprimeSign[p1, p2] == -1 &&
     semiprimeSign[p1, p3] == -1 &&
     semiprimeSign[p2, p3] == -1,

    k = p1 p2 p3;
    ss = signSum[k];
    Print[k, " = 3×5×", p3, ": Σsigns=", ss, ", p3 mod 10 = ", Mod[p3, 10]];
  ],
  {p3, Prime[Range[4, 30]]}
];

Print["\n=== Conflict (-1,1,1): analyze p3 mod (2*p2) ===\n"];

Do[
  p1 = 3;
  If[p2 > p1 && PrimeQ[p3] && p3 > p2 &&
     semiprimeSign[p1, p2] == -1 &&
     semiprimeSign[p1, p3] == 1 &&
     semiprimeSign[p2, p3] == 1,

    k = p1 p2 p3;
    ss = signSum[k];
    Print[k, " = 3×", p2, "×", p3, ": Σsigns=", ss,
          ", p3 mod ", 2 p2, " = ", Mod[p3, 2 p2]];
  ],
  {p2, {5, 11, 17, 23, 29}},
  {p3, Prime[Range[3, 25]]}
];

Print["\n=== General hypothesis: Σsigns depends on all p_i mod 2p_j ===\n"];

(* Test: does the full set of residues determine Σsigns? *)
data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    (* All residues mod 2*other *)
    r12 = Mod[p1, 2 p2];
    r13 = Mod[p1, 2 p3];
    r21 = Mod[p2, 2 p1];
    r23 = Mod[p2, 2 p3];
    r31 = Mod[p3, 2 p1];
    r32 = Mod[p3, 2 p2];
    AppendTo[data, {k, ss, {r12, r13, r21, r23, r31, r32}}];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 12]]}
];

(* Check if residue tuple determines Σsigns *)
groups = GroupBy[data, #[[3]] &];
conflicts = 0;
Do[
  ssVals = Union[#[[2]] & /@ groups[key]];
  If[Length[ssVals] > 1,
    Print["CONFLICT: residues ", key, " → ", ssVals];
    conflicts++
  ],
  {key, Keys[groups]}
];
Print["\nTotal conflicts: ", conflicts, " out of ", Length[Keys[groups]], " residue patterns"];
