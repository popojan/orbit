(* Try to find simpler formula for p1=5 *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    (* All parities *)
    inv12 = Mod[PowerMod[p1, -1, p2], 2];
    inv13 = Mod[PowerMod[p1, -1, p3], 2];
    inv21 = Mod[PowerMod[p2, -1, p1], 2];
    inv23 = Mod[PowerMod[p2, -1, p3], 2];
    inv31 = Mod[PowerMod[p3, -1, p1], 2];
    inv32 = Mod[PowerMod[p3, -1, p2], 2];

    M1 = p2 p3; M2 = p1 p3; M3 = p1 p2;
    c1 = Mod[M1 PowerMod[M1, -1, p1], 2];
    c2 = Mod[M2 PowerMod[M2, -1, p2], 2];
    c3 = Mod[M3 PowerMod[M3, -1, p3], 2];

    (* Try different "delta" combinations *)
    delta5 = Mod[inv12 + inv13 + inv23 + c2 + c3, 2];  (* original for p1=3 *)
    delta9 = Mod[inv12 + inv13 + inv21 + inv23 + inv31 + inv32 + c1 + c2 + c3, 2];
    deltaInv = Mod[inv12 + inv13 + inv21 + inv23 + inv31 + inv32, 2];
    deltaCRT = Mod[c1 + c2 + c3, 2];

    AppendTo[data, <|
      "k" -> k, "ss" -> ss, "r2" -> r2, "r3" -> r3,
      "delta5" -> delta5, "delta9" -> delta9,
      "deltaInv" -> deltaInv, "deltaCRT" -> deltaCRT
    |>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 20]]},
  {p3, Prime[Range[5, 30]]}
];

Print["=== Try: (r2, r3, delta9) ==="];
grouped = GroupBy[data, {#["r2"], #["r3"], #["delta9"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  If[Length[ssVals] > 1, conflicts++],
  {key, Keys[grouped]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped]]];

Print["\n=== Try: (r2, r3, deltaInv, deltaCRT) ==="];
grouped2 = GroupBy[data, {#["r2"], #["r3"], #["deltaInv"], #["deltaCRT"]} &];
conflicts2 = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped2[key]];
  If[Length[ssVals] > 1, conflicts2++],
  {key, Keys[grouped2]}
];
Print["Conflicts: ", conflicts2, " / ", Length[Keys[grouped2]]];

If[conflicts2 == 0,
  Print["\n=== (r2, r3, δ_inv, δ_CRT) works! ==="];
  Print["δ_inv = Σ(6 inverse parities) mod 2"];
  Print["δ_CRT = Σ(3 CRT parities) mod 2"];
  Print["\nLookup table:"];
  Do[
    ss = First[#["ss"] & /@ grouped2[key]];
    Print["  ", key, " → ", ss],
    {key, Sort[Keys[grouped2]]}
  ]
];
