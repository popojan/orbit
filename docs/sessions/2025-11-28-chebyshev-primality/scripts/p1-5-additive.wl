(* Explore ADDITIVE combinations of primes for predicting Σsigns *)

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

    (* More additive parities *)
    diffMod2 = Mod[diff, 2];
    diffMod4 = Mod[diff, 4];
    diffMod8 = Mod[diff, 8];
    diffModP1 = Mod[diff, p1];

    sumMod2 = Mod[sum23, 2];
    sumMod4 = Mod[sum23, 4];
    sumMod8 = Mod[sum23, 8];
    sumModP1 = Mod[sum23, p1];

    (* Floor quotients *)
    q2 = Quotient[p2, p1];
    q3 = Quotient[p3, p1];
    qDiff = q3 - q2;

    AppendTo[data, <|"ss" -> ss, "r2" -> r2, "r3" -> r3, "p2" -> p2, "p3" -> p3,
                     "diff" -> diff, "sum23" -> sum23,
                     "diffMod4" -> diffMod4, "diffMod8" -> diffMod8, "diffModP1" -> diffModP1,
                     "sumMod4" -> sumMod4, "sumMod8" -> sumMod8, "sumModP1" -> sumModP1,
                     "qDiff" -> qDiff|>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 25]]},
  {p3, Prime[Range[5, 40]]}
];

byClass = GroupBy[data, {#["r2"], #["r3"]} &];

fourValClasses = {{1, 2}, {1, 3}, {2, 1}, {2, 4}, {3, 1}, {3, 4}, {4, 2}, {4, 3}};

Print["=== Testing ADDITIVE signatures for 4-value classes ===\n"];

Do[
  classData = byClass[key];
  ssVals = Sort[Union[#["ss"] & /@ classData]];
  Print["Class ", key, ": ", ssVals];

  (* Test: (p3 - p2) mod 8 *)
  grouped = GroupBy[classData, #["diffMod8"] &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (p3-p2) mod 8: ", conflicts, " conflicts"];
  If[conflicts == 0, Print["    SUCCESS!"]];

  (* Test: (p3 - p2) mod 5 (= mod p1) *)
  grouped = GroupBy[classData, #["diffModP1"] &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (p3-p2) mod p1: ", conflicts, " conflicts"];
  If[conflicts == 0, Print["    SUCCESS!"]];

  (* Test: (p2 + p3) mod 8 *)
  grouped = GroupBy[classData, #["sumMod8"] &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (p2+p3) mod 8: ", conflicts, " conflicts"];
  If[conflicts == 0, Print["    SUCCESS!"]];

  (* Test: (p2 + p3) mod p1 *)
  grouped = GroupBy[classData, #["sumModP1"] &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  (p2+p3) mod p1: ", conflicts, " conflicts"];
  If[conflicts == 0, Print["    SUCCESS!"]];

  (* Test: quotient diff q3 - q2 mod 2 *)
  grouped = GroupBy[classData, Mod[#["qDiff"], 2] &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  qDiff mod 2: ", conflicts, " conflicts"];
  If[conflicts == 0,
    Print["    SUCCESS!"];
    Do[Print["    qDiff=", k2, " → ", Union[#["ss"] & /@ grouped[k2]]], {k2, Sort[Keys[grouped]]}];
  ];

  (* Test: quotient diff q3 - q2 mod 4 *)
  grouped = GroupBy[classData, Mod[#["qDiff"], 4] &];
  conflicts = Count[Length /@ (Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped]), x_ /; x > 1];
  Print["  qDiff mod 4: ", conflicts, " conflicts"];
  If[conflicts == 0, Print["    SUCCESS!"]];

  Print[""],
  {key, fourValClasses}
];
