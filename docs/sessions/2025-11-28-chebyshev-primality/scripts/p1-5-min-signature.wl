(* Find minimal distinguishing signature for each class *)

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

    (* Try linear combination over F2 *)
    pars = {inv12, inv13, inv21, inv23, inv31, inv32, c1, c2, c3};

    AppendTo[data, <|"ss" -> ss, "r2" -> r2, "r3" -> r3, "pars" -> pars|>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 20]]},
  {p3, Prime[Range[5, 30]]}
];

byClass = GroupBy[data, {#["r2"], #["r3"]} &];

(* For each class, try XOR combinations *)
parNames = {"inv12", "inv13", "inv21", "inv23", "inv31", "inv32", "c1", "c2", "c3"};

Print["=== Finding linear combinations over F2 ===\n"];

Do[
  classData = byClass[key];
  ssVals = Sort[Union[#["ss"] & /@ classData]];
  nVals = Length[ssVals];

  If[nVals <= 2,
    (* Try single XOR of parities *)
    found = False;
    Do[
      mask = IntegerDigits[m, 2, 9];
      If[Total[mask] >= 1,
        delta = Mod[Total[mask * #["pars"]], 2] & /@ classData;
        grouped = GroupBy[Thread[{delta, #["ss"] & /@ classData}], First -> Last];
        ssPerDelta = Union /@ grouped;
        If[AllTrue[ssPerDelta, Length[#] == 1 &],
          activePars = Pick[parNames, mask, 1];
          Print["Class ", key, " (", ssVals, "): δ = ", StringRiffle[activePars, " ⊕ "]];
          Print["  δ=0 → ", First[ssPerDelta[0]], ", δ=1 → ", First[ssPerDelta[1]]];
          found = True;
          Break[]
        ]
      ],
      {m, 1, 511}
    ];
    If[!found, Print["Class ", key, ": NO single δ found"]]
    ,
    (* 4 values - need 2 bits *)
    Print["Class ", key, " (", ssVals, "): needs 2 bits - searching..."];
    found = False;
    Do[
      mask1 = IntegerDigits[m1, 2, 9];
      mask2 = IntegerDigits[m2, 2, 9];
      If[Total[mask1] >= 1 && Total[mask2] >= 1 && m1 < m2,
        d1 = Mod[Total[mask1 * #["pars"]], 2] & /@ classData;
        d2 = Mod[Total[mask2 * #["pars"]], 2] & /@ classData;
        grouped = GroupBy[Thread[{Thread[{d1, d2}], #["ss"] & /@ classData}], First -> Last];
        ssPerD = Union /@ grouped;
        If[AllTrue[ssPerD, Length[#] == 1 &],
          Print["  Found! δ1 = ", Pick[parNames, mask1, 1], ", δ2 = ", Pick[parNames, mask2, 1]];
          found = True;
          Break[]
        ]
      ],
      {m1, 1, 511}, {m2, 1, 511}
    ];
    If[!found, Print["  NOT found with 2 δ's"]]
  ],
  {key, Sort[Keys[byClass]]}
];
