(* Find optimal δ formula for EACH residue class separately *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

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

    pars = {inv12, inv13, inv21, inv23, inv31, inv32, c1, c2, c3};
    AppendTo[data, <|"ss" -> ss, "r2" -> r2, "r3" -> r3, "pars" -> pars|>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 25]]},
  {p3, Prime[Range[5, 40]]}
];

byClass = GroupBy[data, {#["r2"], #["r3"]} &];
parNames = {"inv12", "inv13", "inv21", "inv23", "inv31", "inv32", "c1", "c2", "c3"};

Print["=== Per-class optimal formula ===\n"];
Print["Total cases: ", Length[data], "\n"];

formulas = <||>;

Do[
  classData = byClass[key];
  ssVals = Sort[Union[#["ss"] & /@ classData]];
  nVals = Length[ssVals];

  Print["Class ", key, ": ", nVals, " values ", ssVals];

  If[nVals == 1,
    (* Constant *)
    formulas[key] = <|"type" -> "constant", "value" -> First[ssVals]|>;
    Print["  → Constant: ", First[ssVals], "\n"];
    ,
    If[nVals == 2,
      (* Try 1-bit δ *)
      found = False;
      Do[
        mask = IntegerDigits[m, 2, 9];
        If[Total[mask] >= 1,
          delta = Mod[Total[mask * #["pars"]], 2] & /@ classData;
          grouped = GroupBy[Thread[{delta, #["ss"] & /@ classData}], First -> Last];
          ssPerDelta = Union /@ grouped;
          If[AllTrue[ssPerDelta, Length[#] == 1 &],
            activePars = Pick[parNames, mask, 1];
            val0 = First[ssPerDelta[0]];
            val1 = First[ssPerDelta[1]];
            formulas[key] = <|"type" -> "1bit", "mask" -> mask,
                              "pars" -> activePars, "val0" -> val0, "val1" -> val1|>;
            Print["  → δ = ", StringRiffle[activePars, " ⊕ "]];
            Print["    δ=0 → ", val0, ", δ=1 → ", val1, "\n"];
            found = True;
            Break[]
          ]
        ],
        {m, 1, 511}
      ];
      If[!found, Print["  → NO 1-bit formula found!\n"]];
      ,
      (* nVals > 2: Try 2-bit (δ1, δ2) *)
      found = False;
      Do[
        mask1 = IntegerDigits[m1, 2, 9];
        mask2 = IntegerDigits[m2, 2, 9];
        If[Total[mask1] >= 1 && Total[mask2] >= 1 && m1 < m2,
          d1 = Mod[Total[mask1 * #["pars"]], 2] & /@ classData;
          d2 = Mod[Total[mask2 * #["pars"]], 2] & /@ classData;
          keys = Thread[{d1, d2}];
          grouped = GroupBy[Thread[{keys, #["ss"] & /@ classData}], First -> Last];
          ssPerD = Union /@ grouped;
          If[AllTrue[ssPerD, Length[#] == 1 &],
            p1s = Pick[parNames, mask1, 1];
            p2s = Pick[parNames, mask2, 1];
            lookup = Association[# -> First[ssPerD[#]] & /@ Keys[grouped]];
            formulas[key] = <|"type" -> "2bit", "mask1" -> mask1, "mask2" -> mask2,
                              "pars1" -> p1s, "pars2" -> p2s, "lookup" -> lookup|>;
            Print["  → δ1 = ", StringRiffle[p1s, " ⊕ "], ", δ2 = ", StringRiffle[p2s, " ⊕ "]];
            Do[Print["    ", k2, " → ", lookup[k2]], {k2, Sort[Keys[lookup]]}];
            Print[""];
            found = True;
            Break[]
          ]
        ],
        {m1, 1, 511}, {m2, 1, 511}
      ];
      If[!found, Print["  → NO 2-bit formula found!\n"]];
    ]
  ],
  {key, Sort[Keys[byClass]]}
];

Print["\n=== Summary ==="];
Print["Classes with formulas: ", Length[formulas]];
Print["Classes in data: ", Length[Keys[byClass]]];
