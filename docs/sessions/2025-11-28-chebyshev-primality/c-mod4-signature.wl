(* Try inverse values mod 4, not just parity *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    ss12 = If[OddQ[PowerMod[p1, -1, p2]], 1, -3];
    ss13 = If[OddQ[PowerMod[p1, -1, p3]], 1, -3];
    ss23 = If[OddQ[PowerMod[p2, -1, p3]], 1, -3];
    sum3 = ss12 + ss13 + ss23;
    c = (ss - sum3)/4;

    (* Inverse values mod 4 *)
    inv12 = PowerMod[p1, -1, p2];
    inv13 = PowerMod[p1, -1, p3];
    inv21 = PowerMod[p2, -1, p1];
    inv23 = PowerMod[p2, -1, p3];
    inv31 = PowerMod[p3, -1, p1];
    inv32 = PowerMod[p3, -1, p2];

    m12 = Mod[inv12, 4];
    m13 = Mod[inv13, 4];
    m21 = Mod[inv21, 4];
    m23 = Mod[inv23, 4];
    m31 = Mod[inv31, 4];
    m32 = Mod[inv32, 4];

    AppendTo[data, <|
      "k" -> k, "p1" -> p1, "p2" -> p2, "p3" -> p3, "c" -> c,
      "m12" -> m12, "m13" -> m13, "m21" -> m21,
      "m23" -> m23, "m31" -> m31, "m32" -> m32,
      "inv23" -> inv23, "inv32" -> inv32
    |>];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 15]]},
  {p3, Prime[Range[4, 25]]}
];

Print["=== Test: all 6 inverses mod 4 ==="];
grouped = GroupBy[data, {#["m12"], #["m13"], #["m21"], #["m23"], #["m31"], #["m32"]} &];
conflicts = 0;
uniqueDet = 0;
Do[
  cVals = Union[#["c"] & /@ grouped[key]];
  If[Length[cVals] > 1,
    conflicts++
  ],
  {key, Keys[grouped]}
];
Print["Total conflicts with mod-4: ", conflicts, " / ", Length[Keys[grouped]], " patterns"];

(* Look at conflict pairs - what distinguishes them? *)
Print["\n=== Analyzing conflict pairs ==="];
conflictKeys = Select[Keys[grouped], Length[Union[#["c"] & /@ grouped[#]]] > 1 &];

(* Take first conflict and examine *)
If[Length[conflictKeys] > 0,
  key = conflictKeys[[1]];
  Print["Conflict at ", key];
  conflictData = grouped[key];
  Do[
    d = row;
    Print["  ", d["k"], " = 3×", d["p2"], "×", d["p3"],
          ": c=", d["c"],
          ", inv23=", d["inv23"], " (mod ", d["p3"], ")",
          ", inv32=", d["inv32"], " (mod ", d["p2"], ")"],
    {row, conflictData}
  ];
];

(* Try: add the "cross inverse" product mod something *)
Print["\n=== Try: inv23 * inv32 mod p3 ==="];
dataX = data;
dataX = Map[Append[#, "cross" -> Mod[#["inv23"] * #["inv32"], #["p3"]]] &, dataX];

grouped2 = GroupBy[dataX, {#["m12"], #["m13"], #["m21"], #["m23"], #["m31"], #["m32"], Mod[#["cross"], 4]} &];
conflicts2 = 0;
Do[
  cVals = Union[#["c"] & /@ grouped2[key]];
  If[Length[cVals] > 1,
    conflicts2++
  ],
  {key, Keys[grouped2]}
];
Print["Conflicts with mod-4 + cross: ", conflicts2, " / ", Length[Keys[grouped2]], " patterns"];
