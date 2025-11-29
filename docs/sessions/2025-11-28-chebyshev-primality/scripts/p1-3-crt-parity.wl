(* Verify p1=3 formula fits the CRT parity framework *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

Print["=== p1=3: CRT parity analysis ===\n"];

(* Check (b1, b2, b3) patterns for p1=3 *)
Print["Parity patterns (b1, b2, b3) for p1=3:\n"];

data = {};
Do[
  p1 = 3;
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    (* CRT coefficients *)
    c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
    c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
    c3 = p1 p2 * PowerMod[p1 p2, -1, p3];

    b1 = Mod[c1, 2];
    b2 = Mod[c2, 2];
    b3 = Mod[c3, 2];

    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    (* Our original delta *)
    inv12 = Mod[PowerMod[p1, -1, p2], 2];
    inv13 = Mod[PowerMod[p1, -1, p3], 2];
    inv23 = Mod[PowerMod[p2, -1, p3], 2];
    deltaOrig = Mod[c2 + c3 + inv12 + inv13 + inv23, 2];

    AppendTo[data, <|"k" -> k, "ss" -> ss, "r2" -> r2, "r3" -> r3,
                     "b1" -> b1, "b2" -> b2, "b3" -> b3,
                     "c2mod2" -> Mod[c2, 2], "c3mod2" -> Mod[c3, 2],
                     "deltaOrig" -> deltaOrig|>];

    If[Length[data] <= 20,
      Print["3*", p2, "*", p3, ": (b1,b2,b3)=(", b1, ",", b2, ",", b3,
            ") class=(", r2, ",", r3, ") ss=", ss];
    ];
  ],
  {p2, Prime[Range[3, 15]]},
  {p3, Prime[Range[4, 20]]}
];

Print["\n=== Pattern analysis ===\n"];

(* Group by (b1, b2, b3) *)
byB = GroupBy[data, {#["b1"], #["b2"], #["b3"]} &];
Print["Distinct (b1, b2, b3) patterns: ", Length[byB]];
Do[
  Print["  ", key, ": ", Length[byB[key]], " cases"],
  {key, Sort[Keys[byB]]}
];

(* Key insight for p1=3: what's special? *)
Print["\n=== Connection to original delta ===\n"];

(* For p1=3, we have only 4 residue classes: (1,1), (1,2), (2,1), (2,2) *)
byClass = GroupBy[data, {#["r2"], #["r3"]} &];

Do[
  classData = byClass[key];
  Print["Class ", key, ":"];

  (* Check if (b1,b2,b3) is constant within class *)
  bPatterns = Union[{#["b1"], #["b2"], #["b3"]} & /@ classData];
  Print["  (b1,b2,b3) patterns: ", bPatterns];

  (* Check if deltaOrig predicts ss *)
  grouped = GroupBy[classData, #["deltaOrig"] &];
  Do[
    ssVals = Union[#["ss"] & /@ grouped[d]];
    Print["    δ=", d, " → ss ∈ ", ssVals],
    {d, Sort[Keys[grouped]]}
  ];
  Print[""],
  {key, Sort[Keys[byClass]]}
];

(* Verify countByParity matches for p1=3 *)
Print["=== Verify CRT parity formula for p1=3 ===\n"];

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

errors = 0;
Do[
  d = data[[i]];
  formula = countByParity[3, Prime[PrimePi[d["k"]/3/Prime[PrimePi[Sqrt[d["k"]/3]]]]], 0];
  (* Simpler: just recompute *)
  {p1, p2, p3} = {3, 0, 0};
  (* Extract primes from k *)
  factors = FactorInteger[d["k"]];
  {p1, p2, p3} = Sort[factors[[All, 1]]];
  formula = countByParity[p1, p2, p3];
  If[formula != d["ss"],
    Print["ERROR: k=", d["k"], " ss=", d["ss"], " formula=", formula];
    errors++
  ],
  {i, Length[data]}
];
Print["Errors: ", errors, " / ", Length[data]];

If[errors == 0,
  Print["\nSUCCESS! CRT parity formula works for p1=3"];
];
