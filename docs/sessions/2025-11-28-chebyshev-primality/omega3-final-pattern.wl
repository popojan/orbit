(* Combine mod 3 pattern with CRT parity to find complete formula *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    (* Residue mod p1=3 *)
    r2 = Mod[p2, 3];
    r3 = Mod[p3, 3];

    (* CRT coefficients parities *)
    M1 = p2 p3; M2 = p1 p3; M3 = p1 p2;
    e1 = PowerMod[M1, -1, p1];
    e2 = PowerMod[M2, -1, p2];
    e3 = PowerMod[M3, -1, p3];
    c1 = Mod[M1 e1, 2];
    c2 = Mod[M2 e2, 2];
    c3 = Mod[M3 e3, 2];

    (* Inverse parities (from semiprime analysis) *)
    inv12par = Mod[PowerMod[p1, -1, p2], 2];
    inv13par = Mod[PowerMod[p1, -1, p3], 2];
    inv23par = Mod[PowerMod[p2, -1, p3], 2];

    AppendTo[data, <|
      "k" -> k, "p2" -> p2, "p3" -> p3, "ss" -> ss,
      "r2" -> r2, "r3" -> r3,
      "c" -> {c1, c2, c3},
      "inv" -> {inv12par, inv13par, inv23par}
    |>];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 20]]}
];

(* Split by mod 3 pattern first *)
class22 = Select[data, #["r2"] == 2 && #["r3"] == 2 &];
classOther = Select[data, !( #["r2"] == 2 && #["r3"] == 2) &];

Print["=== Class (2,2): both p2, p3 ≡ 2 (mod 3) ==="];
Print["ss values: ", Union[#["ss"] & /@ class22]];
Print["Looking for pattern within -9 vs -5:"];
grouped = GroupBy[class22, #["c"] &];
Do[
  ssVals = #["ss"] & /@ grouped[key];
  Print["  CRT=", key, " → ss ∈ ", Union[ssVals]],
  {key, Sort[Keys[grouped]]}
];

Print["\n=== Other classes: at least one ≢ 2 (mod 3) ==="];
Print["ss values: ", Union[#["ss"] & /@ classOther]];
grouped2 = GroupBy[classOther, #["c"] &];
Do[
  ssVals = #["ss"] & /@ grouped2[key];
  Print["  CRT=", key, " → ss ∈ ", Union[ssVals]],
  {key, Sort[Keys[grouped2]]}
];

(* Try adding inverse parities *)
Print["\n=== Class (2,2) with inverse parities ==="];
grouped3 = GroupBy[class22, {#["c"], #["inv"]} &];
Do[
  ssVals = Union[#["ss"] & /@ grouped3[key]];
  If[Length[ssVals] > 1,
    Print["  CONFLICT: ", key, " → ", ssVals],
    Print["  ", key, " → ", First[ssVals]]
  ],
  {key, Sort[Keys[grouped3]]}
];

Print["\n=== Other class with inverse parities ==="];
grouped4 = GroupBy[classOther, {#["c"], #["inv"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped4[key]];
  If[Length[ssVals] > 1,
    Print["  CONFLICT: ", key, " → ", ssVals];
    conflicts++
  ],
  {key, Sort[Keys[grouped4]]}
];
Print["Conflicts in other class: ", conflicts, " / ", Length[Keys[grouped4]]];
