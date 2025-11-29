(* Alternative view: express formula in terms of semiprime sign sums *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
semiprimeSignSum[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

(* Original claim: Σsigns(pqr) = Σsigns(pq) + Σsigns(pr) + Σsigns(qr) + 4c *)

Print["=== Express c in terms of semiprime parities ===\n"];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    ss12 = semiprimeSignSum[p1, p2];
    ss13 = semiprimeSignSum[p1, p3];
    ss23 = semiprimeSignSum[p2, p3];
    sum3 = ss12 + ss13 + ss23;
    c = (ss - sum3)/4;

    (* Convert semiprime signs to parities: ss = 1 iff odd, ss = -3 iff even *)
    par12 = If[ss12 == 1, 1, 0];
    par13 = If[ss13 == 1, 1, 0];
    par23 = If[ss23 == 1, 1, 0];

    (* Residue classes *)
    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    AppendTo[data, {p1, p2, p3, ss, c, par12, par13, par23, r2, r3}];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 20]]}
];

Print["Looking for c = f(par12, par13, par23, r2, r3)..."];

(* Group by signature *)
grouped = GroupBy[data, {#[[6]], #[[7]], #[[8]], #[[9]], #[[10]]} &];
Print["Distinct signatures: ", Length[Keys[grouped]]];

conflicts = 0;
Do[
  cVals = Union[#[[5]] & /@ grouped[key]];
  If[Length[cVals] == 1,
    Print[key, " → c=", First[cVals]],
    Print["CONFLICT: ", key, " → c ∈ ", cVals];
    conflicts++
  ],
  {key, Sort[Keys[grouped]]}
];

Print["\nConflicts: ", conflicts];

If[conflicts == 0,
  Print["\n=== SIMPLER FORMULA FOUND! ==="];
  Print["c = f(par12, par13, par23, p2 mod 3, p3 mod 3)"];
  Print["where par_ij = 1 if p_i^{-1} mod p_j is odd, 0 otherwise"];
];
