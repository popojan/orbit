(* Combine additive features to resolve 4-value classes *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    (* Additive features *)
    diff = p3 - p2;
    sum23 = p2 + p3;

    diffModP1 = Mod[diff, p1];
    sumModP1 = Mod[sum23, p1];

    q2 = Quotient[p2, p1];
    q3 = Quotient[p3, p1];
    qDiffMod2 = Mod[q3 - q2, 2];

    (* Also mod 2 of primes *)
    p2Mod4 = Mod[p2, 4];
    p3Mod4 = Mod[p3, 4];

    AppendTo[data, <|"ss" -> ss, "r2" -> r2, "r3" -> r3,
                     "diffModP1" -> diffModP1, "sumModP1" -> sumModP1,
                     "qDiffMod2" -> qDiffMod2,
                     "p2Mod4" -> p2Mod4, "p3Mod4" -> p3Mod4|>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 25]]},
  {p3, Prime[Range[5, 40]]}
];

byClass = GroupBy[data, {#["r2"], #["r3"]} &];

fourValClasses = {{1, 2}, {1, 3}, {2, 1}, {2, 4}, {3, 1}, {3, 4}, {4, 2}, {4, 3}};

Print["=== Combining additive features ===\n"];

Do[
  classData = byClass[key];
  ssVals = Sort[Union[#["ss"] & /@ classData]];
  Print["Class ", key, ": ", ssVals];

  (* Test: ((p3-p2) mod 5, qDiff mod 2) *)
  grouped = GroupBy[classData, {#["diffModP1"], #["qDiffMod2"]} &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (diffModP1, qDiffMod2): ", conflicts, " conflicts"];
  If[conflicts == 0,
    Print["    SUCCESS!"];
    Do[Print["    ", k2, " -> ", First[Union[#["ss"] & /@ grouped[k2]]]], {k2, Sort[Keys[grouped]]}];
  ];

  (* Test: ((p2+p3) mod 5, qDiff mod 2) *)
  grouped = GroupBy[classData, {#["sumModP1"], #["qDiffMod2"]} &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (sumModP1, qDiffMod2): ", conflicts, " conflicts"];
  If[conflicts == 0, Print["    SUCCESS!"]];

  (* Test: (diffModP1, p2 mod 4) *)
  grouped = GroupBy[classData, {#["diffModP1"], #["p2Mod4"]} &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (diffModP1, p2Mod4): ", conflicts, " conflicts"];
  If[conflicts == 0, Print["    SUCCESS!"]];

  (* Test: (diffModP1, p3 mod 4) *)
  grouped = GroupBy[classData, {#["diffModP1"], #["p3Mod4"]} &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (diffModP1, p3Mod4): ", conflicts, " conflicts"];
  If[conflicts == 0, Print["    SUCCESS!"]];

  Print[""],
  {key, fourValClasses}
];
