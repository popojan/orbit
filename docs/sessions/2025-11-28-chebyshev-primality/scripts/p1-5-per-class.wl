(* Analyze each residue class separately for p1=5 *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    (* All parities as individual bits *)
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

    AppendTo[data, <|
      "k" -> k, "ss" -> ss, "r2" -> r2, "r3" -> r3,
      "inv12" -> inv12, "inv13" -> inv13, "inv21" -> inv21,
      "inv23" -> inv23, "inv31" -> inv31, "inv32" -> inv32,
      "c1" -> c1, "c2" -> c2, "c3" -> c3
    |>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 25]]},
  {p3, Prime[Range[5, 40]]}
];

Print["Total cases: ", Length[data]];

(* For each residue class, find minimal distinguishing signature *)
byClass = GroupBy[data, {#["r2"], #["r3"]} &];

Print["\n=== Analysis per residue class ===\n"];

Do[
  classData = byClass[key];
  ssVals = Union[#["ss"] & /@ classData];
  Print["Class ", key, ": Σsigns ∈ ", ssVals, " (", Length[classData], " cases)"];

  (* Try to find simplest distinguishing feature *)
  If[Length[ssVals] == 1,
    Print["  → Constant: Σsigns = ", First[ssVals]],

    (* Try single parities *)
    found = False;
    Do[
      grouped = GroupBy[classData, #[par] &];
      ssPerPar = Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped];
      If[AllTrue[ssPerPar, Length[#] == 1 &],
        Print["  → Determined by: ", par];
        Do[
          Print["    ", par, "=", pv, " → ", First[#["ss"] & /@ grouped[pv]]],
          {pv, Sort[Keys[grouped]]}
        ];
        found = True;
        Break[]
      ],
      {par, {"inv12", "inv13", "inv21", "inv23", "inv31", "inv32", "c1", "c2", "c3"}}
    ];

    If[!found,
      (* Try pairs of parities *)
      Do[
        grouped = GroupBy[classData, {#[p1x], #[p2x]} &];
        ssPerPar = Union[#["ss"] & /@ grouped[#]] & /@ Keys[grouped];
        If[AllTrue[ssPerPar, Length[#] == 1 &],
          Print["  → Determined by: (", p1x, ", ", p2x, ")"];
          found = True;
          Break[]
        ],
        {p1x, {"inv12", "inv13", "inv21", "inv23", "inv31", "inv32", "c1", "c2", "c3"}},
        {p2x, {"inv12", "inv13", "inv21", "inv23", "inv31", "inv32", "c1", "c2", "c3"}}
      ]
    ];

    If[!found,
      Print["  → Needs 3+ parities"]
    ]
  ];
  Print[""],
  {key, Sort[Keys[byClass]]}
];
