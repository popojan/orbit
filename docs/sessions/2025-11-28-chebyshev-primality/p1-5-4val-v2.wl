(* Try (inv23, inv32) or (c2, c3) as 2-bit key for 4-value classes *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    inv23 = Mod[PowerMod[p2, -1, p3], 2];
    inv32 = Mod[PowerMod[p3, -1, p2], 2];
    M2 = p1 p3; M3 = p1 p2;
    c2 = Mod[M2 PowerMod[M2, -1, p2], 2];
    c3 = Mod[M3 PowerMod[M3, -1, p3], 2];

    AppendTo[data, <|"ss" -> ss, "r2" -> r2, "r3" -> r3,
                     "inv23" -> inv23, "inv32" -> inv32, "c2" -> c2, "c3" -> c3|>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 20]]},
  {p3, Prime[Range[5, 30]]}
];

byClass = GroupBy[data, {#["r2"], #["r3"]} &];

(* 4-value classes *)
fourValClasses = {{1, 2}, {1, 3}, {2, 1}, {2, 4}, {3, 1}, {3, 4}, {4, 2}, {4, 3}};

Print["=== Test: (inv23, c2) as 2-bit key ==="];
Do[
  classData = byClass[key];
  grouped = GroupBy[classData, {#["inv23"], #["c2"]} &];
  conflicts = 0;
  Do[
    ssVals = Union[#["ss"] & /@ grouped[k2]];
    If[Length[ssVals] > 1, conflicts++],
    {k2, Keys[grouped]}
  ];
  Print[key, ": conflicts = ", conflicts, " / ", Length[Keys[grouped]]],
  {key, fourValClasses}
];

Print["\n=== Test: (inv32, c3) as 2-bit key ==="];
Do[
  classData = byClass[key];
  grouped = GroupBy[classData, {#["inv32"], #["c3"]} &];
  conflicts = 0;
  Do[
    ssVals = Union[#["ss"] & /@ grouped[k2]];
    If[Length[ssVals] > 1, conflicts++],
    {k2, Keys[grouped]}
  ];
  Print[key, ": conflicts = ", conflicts, " / ", Length[Keys[grouped]]],
  {key, fourValClasses}
];

Print["\n=== Test: (inv23, inv32) as 2-bit key ==="];
Do[
  classData = byClass[key];
  grouped = GroupBy[classData, {#["inv23"], #["inv32"]} &];
  conflicts = 0;
  Do[
    ssVals = Union[#["ss"] & /@ grouped[k2]];
    If[Length[ssVals] > 1, conflicts++],
    {k2, Keys[grouped]}
  ];
  Print[key, ": conflicts = ", conflicts, " / ", Length[Keys[grouped]]],
  {key, fourValClasses}
];

Print["\n=== Test: (c2, c3) as 2-bit key ==="];
Do[
  classData = byClass[key];
  grouped = GroupBy[classData, {#["c2"], #["c3"]} &];
  conflicts = 0;
  Do[
    ssVals = Union[#["ss"] & /@ grouped[k2]];
    If[Length[ssVals] > 1, conflicts++],
    {k2, Keys[grouped]}
  ];
  Print[key, ": conflicts = ", conflicts, " / ", Length[Keys[grouped]]],
  {key, fourValClasses}
];

Print["\n=== Test: (inv23 ⊕ c2, inv32 ⊕ c3) as 2-bit key ==="];
Do[
  classData = byClass[key];
  classData = Map[Append[#, "d1" -> Mod[#["inv23"] + #["c2"], 2],
                          "d2" -> Mod[#["inv32"] + #["c3"], 2]] &, classData];
  grouped = GroupBy[classData, {#["d1"], #["d2"]} &];
  conflicts = 0;
  Do[
    ssVals = Union[#["ss"] & /@ grouped[k2]];
    If[Length[ssVals] > 1, conflicts++],
    {k2, Keys[grouped]}
  ];
  If[conflicts == 0,
    Print[key, ": SUCCESS! 0 conflicts"];
    Print["  Lookup:"];
    Do[
      Print["    ", k2, " → ", First[Union[#["ss"] & /@ grouped[k2]]]],
      {k2, Sort[Keys[grouped]]}
    ],
    Print[key, ": conflicts = ", conflicts]
  ],
  {key, fourValClasses}
];
