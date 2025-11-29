(* Examine specific cases in a 4-value class to find distinguishing feature *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

Print["=== Examining class {1, 2} in detail ===\n"];
Print["(p2 mod 5 = 1, p3 mod 5 = 2)\n"];

data = {};
Do[
  p1 = 5;
  If[p1 < p2 < p3 && Mod[p2, 5] == 1 && Mod[p3, 5] == 2,
    k = p1 p2 p3;
    ss = signSum[k];

    (* All the features *)
    inv23 = PowerMod[p2, -1, p3];
    inv32 = PowerMod[p3, -1, p2];
    M2 = p1 p3; M3 = p1 p2;
    c2 = M2 * PowerMod[M2, -1, p2];
    c3 = M3 * PowerMod[M3, -1, p3];

    (* Print examples *)
    If[Length[data] < 40,
      Print["5*", p2, "*", p3, " = ", k, " -> ss=", ss,
            "  inv23=", inv23, "  inv32=", inv32,
            "  c2 mod 4=", Mod[c2, 4], "  c3 mod 4=", Mod[c3, 4]];
    ];

    AppendTo[data, <|"ss" -> ss, "p2" -> p2, "p3" -> p3,
                     "inv23" -> inv23, "inv32" -> inv32,
                     "c2" -> c2, "c3" -> c3,
                     "inv23mod4" -> Mod[inv23, 4], "inv32mod4" -> Mod[inv32, 4],
                     "c2mod4" -> Mod[c2, 4], "c3mod4" -> Mod[c3, 4]|>];
  ],
  {p2, Prime[Range[4, 20]]},
  {p3, Prime[Range[5, 35]]}
];

Print["\n=== Summary ==="];
Print["Total cases: ", Length[data]];
Print["Σsigns values: ", Sort[Union[#["ss"] & /@ data]]];

(* Group by ss and look for patterns *)
Print["\n=== Cases by Σsigns ==="];
Do[
  cases = Select[data, #["ss"] == ssVal &];
  Print["\nΣsigns = ", ssVal, " (", Length[cases], " cases):"];
  Do[
    Print["  p2=", c["p2"], " p3=", c["p3"],
          " inv23%4=", c["inv23mod4"], " inv32%4=", c["inv32mod4"],
          " c2%4=", c["c2mod4"], " c3%4=", c["c3mod4"]],
    {c, Take[cases, Min[5, Length[cases]]]}
  ],
  {ssVal, {-5, -1, 3, 7}}
];

(* Try (inv23 mod 4, inv32 mod 4) *)
Print["\n=== (inv23 mod 4, inv32 mod 4) distribution ==="];
grouped = GroupBy[data, {#["inv23mod4"], #["inv32mod4"]} &];
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  Print[key, " -> ", ssVals, " (", Length[grouped[key]], " cases)"],
  {key, Sort[Keys[grouped]]}
];

(* Try (c2 mod 4, c3 mod 4) *)
Print["\n=== (c2 mod 4, c3 mod 4) distribution ==="];
grouped = GroupBy[data, {#["c2mod4"], #["c3mod4"]} &];
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  Print[key, " -> ", ssVals, " (", Length[grouped[key]], " cases)"],
  {key, Sort[Keys[grouped]]}
];

(* Try combined: (inv23 mod 4 + c2) mod 4 *)
Print["\n=== (inv23+c2) mod 4, (inv32+c3) mod 4 ==="];
dataNew = Map[Append[#, "d1" -> Mod[#["inv23"] + #["c2"], 4], "d2" -> Mod[#["inv32"] + #["c3"], 4]] &, data];
grouped = GroupBy[dataNew, {#["d1"], #["d2"]} &];
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  Print[key, " -> ", ssVals, " (", Length[grouped[key]], " cases)"],
  {key, Sort[Keys[grouped]]}
];
