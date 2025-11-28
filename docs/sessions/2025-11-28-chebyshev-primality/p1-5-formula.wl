(* Find formula for p1=5: classify by (p2 mod 5, p3 mod 5) *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Collect data for p1=5 *)
data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    (* CRT coefficients *)
    M2 = p1 p3; M3 = p1 p2;
    e2 = PowerMod[M2, -1, p2];
    e3 = PowerMod[M3, -1, p3];
    c2 = Mod[M2 e2, 2];
    c3 = Mod[M3 e3, 2];

    (* Inverse parities *)
    inv12 = Mod[PowerMod[p1, -1, p2], 2];
    inv13 = Mod[PowerMod[p1, -1, p3], 2];
    inv23 = Mod[PowerMod[p2, -1, p3], 2];

    delta = Mod[c2 + c3 + inv12 + inv13 + inv23, 2];

    AppendTo[data, <|
      "k" -> k, "p2" -> p2, "p3" -> p3, "ss" -> ss,
      "r2" -> r2, "r3" -> r3, "delta" -> delta,
      "c2" -> c2, "c3" -> c3,
      "inv12" -> inv12, "inv13" -> inv13, "inv23" -> inv23
    |>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 20]]},
  {p3, Prime[Range[5, 30]]}
];

Print["=== Data for p1=5: ", Length[data], " cases ===\n"];

(* Group by residue class *)
Print["=== Σsigns by (r2, r3) = (p2 mod 5, p3 mod 5) ==="];
grouped = GroupBy[data, {#["r2"], #["r3"]} &];
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  Print[key, " → Σsigns ∈ ", ssVals, " (", Length[grouped[key]], " cases)"],
  {key, Sort[Keys[grouped]]}
];

Print["\n=== Test: does (r2, r3, delta) determine Σsigns? ==="];
grouped2 = GroupBy[data, {#["r2"], #["r3"], #["delta"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped2[key]];
  If[Length[ssVals] > 1,
    Print["CONFLICT: ", key, " → ", ssVals];
    conflicts++
  ],
  {key, Keys[grouped2]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped2]]];

If[conflicts == 0,
  Print["\n=== SUCCESS! (r2, r3, δ) determines Σsigns for p1=5 ==="];
  Print["Building lookup table:"];
  Do[
    ss = First[#["ss"] & /@ grouped2[key]];
    {r2, r3, d} = key;
    Print["  (", r2, ", ", r3, ", δ=", d, ") → ", ss],
    {key, Sort[Keys[grouped2]]}
  ]
];
