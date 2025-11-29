(* Derive general formula for any p1 *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

countByParity[p1_, p2_, p3_] := Module[
  {k = p1 p2 p3, c1, c2, c3, odd = 0, even = 0, n},
  c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
  c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
  c3 = p1 p2 * PowerMod[p1 p2, -1, p3];
  Do[
    If[GCD[a1, p1] == 1 && GCD[a2, p2] == 1 && GCD[a3, p3] == 1,
      n = Mod[a1 c1 + a2 c2 + a3 c3, k];
      If[GCD[n - 1, k] == 1,
        If[OddQ[n], odd++, even++]
      ]
    ],
    {a1, 1, p1 - 1},
    {a2, 1, p2 - 1},
    {a3, 1, p3 - 1}
  ];
  odd - even
];

Print["=== Testing general CRT parity formula ===\n"];

(* Test for p1 = 3, 5, 7 *)
Do[
  Print["p1 = ", p1x, ":"];
  errors = 0;
  total = 0;
  Do[
    If[p1x < p2 < p3,
      k = p1x p2 p3;
      ss = signSum[k];
      formula = countByParity[p1x, p2, p3];
      total++;
      If[ss != formula,
        errors++;
        If[errors <= 3, Print["  ERROR: ", p1x, "*", p2, "*", p3, " ss=", ss, " formula=", formula]]
      ]
    ],
    {p2, Prime[Range[PrimePi[p1x] + 1, 15]]},
    {p3, Prime[Range[PrimePi[p1x] + 2, 20]]}
  ];
  Print["  Tested: ", total, " cases, Errors: ", errors];
  Print[""],
  {p1x, {3, 5, 7}}
];

Print["=== Analyzing b1 pattern ===\n"];

(* Check if b1 depends only on residue class for each p1 *)
Do[
  Print["p1 = ", p1x, ":"];
  data = {};
  Do[
    If[p1x < p2 < p3,
      c1 = p2 p3 * PowerMod[p2 p3, -1, p1x];
      b1 = Mod[c1, 2];
      r2 = Mod[p2, p1x];
      r3 = Mod[p3, p1x];
      AppendTo[data, <|"r2" -> r2, "r3" -> r3, "b1" -> b1|>];
    ],
    {p2, Prime[Range[PrimePi[p1x] + 1, 12]]},
    {p3, Prime[Range[PrimePi[p1x] + 2, 15]]}
  ];

  (* Check if b1 is constant per (r2, r3) class *)
  byClass = GroupBy[data, {#["r2"], #["r3"]} &];
  consistent = True;
  Do[
    b1Vals = Union[#["b1"] & /@ byClass[key]];
    If[Length[b1Vals] > 1,
      Print["  Class ", key, ": b1 NOT constant! Values: ", b1Vals];
      consistent = False,
      Print["  Class ", key, ": b1 = ", First[b1Vals]]
    ],
    {key, Sort[Keys[byClass]]}
  ];
  If[consistent, Print["  → b1 is constant per class!"]];
  Print[""],
  {p1x, {3, 5, 7}}
];

(* Closed form for b1? *)
Print["=== Trying to find b1 formula ===\n"];

Do[
  Print["p1 = ", p1x, ":"];
  data = {};
  Do[
    If[p1x < p2 < p3,
      c1 = p2 p3 * PowerMod[p2 p3, -1, p1x];
      b1 = Mod[c1, 2];
      r2 = Mod[p2, p1x];
      r3 = Mod[p3, p1x];
      (* Try formulas *)
      guess1 = Mod[r2 + r3, 2];
      guess2 = Mod[r2 * r3, 2];
      guess3 = Mod[r2 + r3 + 1, 2];
      guess4 = Mod[PowerMod[r2, -1, p1x] + PowerMod[r3, -1, p1x], 2];
      AppendTo[data, <|"r2" -> r2, "r3" -> r3, "b1" -> b1,
                       "g1" -> guess1, "g2" -> guess2, "g3" -> guess3, "g4" -> guess4|>];
    ],
    {p2, Prime[Range[PrimePi[p1x] + 1, 10]]},
    {p3, Prime[Range[PrimePi[p1x] + 2, 12]]}
  ];

  Print["  Testing b1 = (r2 + r3) mod 2: ",
        Count[data, d_ /; d["b1"] == d["g1"]], "/", Length[data]];
  Print["  Testing b1 = (r2 * r3) mod 2: ",
        Count[data, d_ /; d["b1"] == d["g2"]], "/", Length[data]];
  Print["  Testing b1 = (r2 + r3 + 1) mod 2: ",
        Count[data, d_ /; d["b1"] == d["g3"]], "/", Length[data]];
  Print["  Testing b1 = (r2^-1 + r3^-1) mod 2: ",
        Count[data, d_ /; d["b1"] == d["g4"]], "/", Length[data]];
  Print[""],
  {p1x, {3, 5, 7}}
];
