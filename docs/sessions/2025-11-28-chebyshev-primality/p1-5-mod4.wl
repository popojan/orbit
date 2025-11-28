(* Explore mod 4 information for 4-value classes *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    (* mod 4 information *)
    inv23m4 = Mod[PowerMod[p2, -1, p3], 4];
    inv32m4 = Mod[PowerMod[p3, -1, p2], 4];

    M2 = p1 p3; M3 = p1 p2;
    c2m4 = Mod[M2 PowerMod[M2, -1, p2], 4];
    c3m4 = Mod[M3 PowerMod[M3, -1, p3], 4];

    (* Also direct residues *)
    p2m4 = Mod[p2, 4];
    p3m4 = Mod[p3, 4];

    AppendTo[data, <|"ss" -> ss, "r2" -> r2, "r3" -> r3,
                     "inv23m4" -> inv23m4, "inv32m4" -> inv32m4,
                     "c2m4" -> c2m4, "c3m4" -> c3m4,
                     "p2m4" -> p2m4, "p3m4" -> p3m4|>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 25]]},
  {p3, Prime[Range[5, 40]]}
];

byClass = GroupBy[data, {#["r2"], #["r3"]} &];

fourValClasses = {{1, 2}, {1, 3}, {2, 1}, {2, 4}, {3, 1}, {3, 4}, {4, 2}, {4, 3}};

Print["=== Testing mod 4 signatures for 4-value classes ===\n"];

Do[
  classData = byClass[key];
  ssVals = Sort[Union[#["ss"] & /@ classData]];
  Print["Class ", key, ": ", ssVals];

  (* Try (inv23 mod 4, inv32 mod 4) *)
  grouped = GroupBy[classData, {#["inv23m4"], #["inv32m4"]} &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (inv23 mod 4, inv32 mod 4): ", Length[Keys[grouped]], " patterns, ", conflicts, " conflicts"];
  If[conflicts == 0,
    Print["    SUCCESS!"];
    Do[Print["    ", k2, " → ", First[Union[#["ss"] & /@ grouped[k2]]]], {k2, Sort[Keys[grouped]]}];
  ];

  (* Try (p2 mod 4, p3 mod 4) *)
  grouped = GroupBy[classData, {#["p2m4"], #["p3m4"]} &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (p2 mod 4, p3 mod 4): ", Length[Keys[grouped]], " patterns, ", conflicts, " conflicts"];
  If[conflicts == 0,
    Print["    SUCCESS!"];
    Do[Print["    ", k2, " → ", First[Union[#["ss"] & /@ grouped[k2]]]], {k2, Sort[Keys[grouped]]}];
  ];

  (* Try (c2 mod 4, c3 mod 4) *)
  grouped = GroupBy[classData, {#["c2m4"], #["c3m4"]} &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (c2 mod 4, c3 mod 4): ", Length[Keys[grouped]], " patterns, ", conflicts, " conflicts"];
  If[conflicts == 0,
    Print["    SUCCESS!"];
  ];

  (* Try (inv32 mod 4, c3 mod 4) *)
  grouped = GroupBy[classData, {#["inv32m4"], #["c3m4"]} &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (inv32 mod 4, c3 mod 4): ", Length[Keys[grouped]], " patterns, ", conflicts, " conflicts"];
  If[conflicts == 0,
    Print["    SUCCESS!"];
  ];

  Print[""],
  {key, fourValClasses}
];
