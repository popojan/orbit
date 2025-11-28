(* Hybrid approach: mod 4 + mod 2 combinations *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  p1 = 5;
  If[p1 < p2 < p3 && Mod[p2, 5] == 1 && Mod[p3, 5] == 2,
    k = p1 p2 p3;
    ss = signSum[k];

    inv23 = PowerMod[p2, -1, p3];
    inv32 = PowerMod[p3, -1, p2];
    M2 = p1 p3; M3 = p1 p2;
    c2 = M2 * PowerMod[M2, -1, p2];
    c3 = M3 * PowerMod[M3, -1, p3];

    AppendTo[data, <|"ss" -> ss,
      "c2m4" -> Mod[c2, 4], "c3m4" -> Mod[c3, 4],
      "c2m2" -> Mod[c2, 2], "c3m2" -> Mod[c3, 2],
      "inv23m4" -> Mod[inv23, 4], "inv32m4" -> Mod[inv32, 4],
      "inv23m2" -> Mod[inv23, 2], "inv32m2" -> Mod[inv32, 2]|>];
  ],
  {p2, Prime[Range[4, 30]]},
  {p3, Prime[Range[5, 50]]}
];

Print["=== Class {1, 2}: Hybrid signatures ===\n"];
Print["Total cases: ", Length[data]];
Print["Values: ", Sort[Union[#["ss"] & /@ data]], "\n"];

(* Key insight: (c2m4, c3m4) gives 10 patterns, some unique *)
(* Try combining with inv parities *)

(* Test: (c2 mod 4, c3 mod 4, inv23 mod 2) *)
Print["=== (c2m4, c3m4, inv23m2) ==="];
grouped = GroupBy[data, {#["c2m4"], #["c3m4"], #["inv23m2"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  If[Length[ssVals] > 1,
    conflicts++;
    Print["CONFLICT: ", key, " -> ", ssVals]
  ],
  {key, Sort[Keys[grouped]]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped]], "\n"];

If[conflicts == 0,
  Print["SUCCESS! Lookup table:"];
  Do[
    Print["  ", key, " -> ", First[Union[#["ss"] & /@ grouped[key]]]],
    {key, Sort[Keys[grouped]]}
  ];
];

(* Test: (c2 mod 4, c3 mod 4, inv32 mod 2) *)
Print["=== (c2m4, c3m4, inv32m2) ==="];
grouped = GroupBy[data, {#["c2m4"], #["c3m4"], #["inv32m2"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  If[Length[ssVals] > 1, conflicts++],
  {key, Keys[grouped]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped]], "\n"];

(* Test: (inv23 mod 4, c3 mod 4) - maybe this is the right combo *)
Print["=== (inv23m4, c3m4) ==="];
grouped = GroupBy[data, {#["inv23m4"], #["c3m4"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  If[Length[ssVals] > 1,
    conflicts++;
    Print["CONFLICT: ", key, " -> ", ssVals]
  ],
  {key, Sort[Keys[grouped]]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped]], "\n"];

(* Test: (inv32 mod 4, c2 mod 4) *)
Print["=== (inv32m4, c2m4) ==="];
grouped = GroupBy[data, {#["inv32m4"], #["c2m4"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  If[Length[ssVals] > 1,
    conflicts++;
    Print["CONFLICT: ", key, " -> ", ssVals]
  ],
  {key, Sort[Keys[grouped]]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped]], "\n"];

(* Test: ((inv23+c2) mod 4, (inv32+c3) mod 4) *)
Print["=== ((inv23+c2) mod 4, (inv32+c3) mod 4) ==="];
dataMod = Map[Function[d, <|d, "sum1" -> Mod[d["inv23m4"] + d["c2m4"], 4],
                              "sum2" -> Mod[d["inv32m4"] + d["c3m4"], 4]|>], data];
grouped = GroupBy[dataMod, {#["sum1"], #["sum2"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  If[Length[ssVals] > 1,
    conflicts++;
    Print["CONFLICT: ", key, " -> ", ssVals]
  ],
  {key, Sort[Keys[grouped]]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped]], "\n"];

If[conflicts == 0,
  Print["SUCCESS! Lookup table:"];
  Do[
    Print["  ", key, " -> ", First[Union[#["ss"] & /@ grouped[key]]]],
    {key, Sort[Keys[grouped]]}
  ];
];
