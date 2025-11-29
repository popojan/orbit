(* Extended analysis for p1=5: add more parities *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    (* All 6 inverse parities *)
    inv12 = Mod[PowerMod[p1, -1, p2], 2];
    inv13 = Mod[PowerMod[p1, -1, p3], 2];
    inv21 = Mod[PowerMod[p2, -1, p1], 2];
    inv23 = Mod[PowerMod[p2, -1, p3], 2];
    inv31 = Mod[PowerMod[p3, -1, p1], 2];
    inv32 = Mod[PowerMod[p3, -1, p2], 2];

    (* CRT coefficients *)
    M1 = p2 p3; M2 = p1 p3; M3 = p1 p2;
    e1 = PowerMod[M1, -1, p1];
    e2 = PowerMod[M2, -1, p2];
    e3 = PowerMod[M3, -1, p3];
    c1 = Mod[M1 e1, 2];
    c2 = Mod[M2 e2, 2];
    c3 = Mod[M3 e3, 2];

    AppendTo[data, <|
      "k" -> k, "p2" -> p2, "p3" -> p3, "ss" -> ss,
      "r2" -> r2, "r3" -> r3,
      "inv12" -> inv12, "inv13" -> inv13, "inv21" -> inv21,
      "inv23" -> inv23, "inv31" -> inv31, "inv32" -> inv32,
      "c1" -> c1, "c2" -> c2, "c3" -> c3
    |>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 20]]},
  {p3, Prime[Range[5, 30]]}
];

Print["=== Test: (r2, r3) + all 6 inverse parities ==="];
grouped = GroupBy[data, {#["r2"], #["r3"],
                         #["inv12"], #["inv13"], #["inv21"],
                         #["inv23"], #["inv31"], #["inv32"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  If[Length[ssVals] > 1,
    conflicts++
  ],
  {key, Keys[grouped]}
];
Print["Conflicts with 6 parities: ", conflicts, " / ", Length[Keys[grouped]]];

Print["\n=== Test: (r2, r3) + all 6 inv parities + 3 CRT parities ==="];
grouped2 = GroupBy[data, {#["r2"], #["r3"],
                          #["inv12"], #["inv13"], #["inv21"],
                          #["inv23"], #["inv31"], #["inv32"],
                          #["c1"], #["c2"], #["c3"]} &];
conflicts2 = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped2[key]];
  If[Length[ssVals] > 1,
    Print["CONFLICT: ", key, " → ", ssVals];
    conflicts2++
  ],
  {key, Keys[grouped2]}
];
Print["Conflicts with 6 inv + 3 CRT: ", conflicts2, " / ", Length[Keys[grouped2]]];

If[conflicts2 == 0,
  Print["\n=== SUCCESS! Full signature determines Σsigns ==="]
];
