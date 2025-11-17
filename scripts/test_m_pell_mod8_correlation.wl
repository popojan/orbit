#!/usr/bin/env wolframscript
(*
Test M(p) ↔ R(p) correlation with mod 8 stratification

Question: Does mod 8 structure R(p)?
- p ≡ 7 (mod 8) → x ≡ +1 (mod p) [PROVEN]
- p ≡ 1,3 (mod 8) → x ≡ -1 (mod p) [PROVEN]
*)

Print[StringRepeat["=", 80]];
Print["M(p) ↔ R(p) CORRELATION WITH MOD 8 STRATIFICATION"];
Print[StringRepeat["=", 80]];
Print[];

(* M(n) - childhood function *)
M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

(* Fundamental Pell solution *)
FundamentalPellSolution[D_] := Module[{sol},
  If[IntegerQ[Sqrt[D]],
    Return[{1, 0}]  (* Perfect square - trivial *)
  ];
  sol = Solve[x^2 - D*y^2 == 1, {x, y}, PositiveIntegers] /. C[1] -> 1;
  If[sol === {},
    {0, 0},  (* No solution *)
    {x, y} /. First[sol]
  ]
]

(* Regulator R(D) = log(x + y√D) *)
Regulator[D_] := Module[{sol, x, y},
  sol = FundamentalPellSolution[D];
  {x, y} = sol;
  If[x == 0 || x == 1,
    0.0,  (* Trivial case *)
    N[Log[x + y*Sqrt[D]], 20]
  ]
]

(* CF period length *)
CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D], 1000];
  If[Length[cf] < 2, 0, Length[cf] - 1]
]

(* Collect data for primes *)
primes = Select[Range[3, 500], PrimeQ];

Print["Computing for ", Length[primes], " primes..."];
Print[];

data = Table[
  Module[{p, sol, x, y, R, period, xModP},
    p = prime;
    sol = FundamentalPellSolution[p];
    {x, y} = sol;

    If[x == 0 || x == 1,
      Nothing,  (* Skip failures *)
      R = Regulator[p];
      period = CFPeriod[p];
      xModP = Mod[x, p];

      {
        "p" -> p,
        "M" -> M[p],
        "R" -> R,
        "period" -> period,
        "x" -> x,
        "y" -> y,
        "xModP" -> xModP,
        "pMod8" -> Mod[p, 8]
      }
    ]
  ],
  {prime, primes}
];

data = DeleteCases[data, Nothing];

Print["Collected ", Length[data], " data points"];
Print[];

(* Stratify by mod 8 *)
data1 = Select[data, #["pMod8"] == 1 &];
data3 = Select[data, #["pMod8"] == 3 &];
data7 = Select[data, #["pMod8"] == 7 &];

Print[StringRepeat["=", 80]];
Print["STATISTICS BY MOD 8 CLASS"];
Print[StringRepeat["=", 80]];
Print[];

(* Helper to print stats *)
PrintModStats[modVal_, dataset_, label_] := Module[{
    Rvals, periodVals, xModPVals, meanR, stdR, meanPeriod,
    xPlus1, xMinus1
  },
  If[Length[dataset] == 0, Return[]];

  Rvals = #["R"] & /@ dataset;
  periodVals = #["period"] & /@ dataset;
  xModPVals = #["xModP"] & /@ dataset;

  meanR = Mean[Rvals];
  stdR = If[Length[Rvals] > 1, StandardDeviation[Rvals], 0];
  meanPeriod = Mean[periodVals];

  (* Check x mod p pattern *)
  xPlus1 = Count[xModPVals, 1];
  xMinus1 = Count[Table[
    xModPVals[[i]] == dataset[[i]]["p"] - 1,
    {i, Length[dataset]}
  ], True];

  Print[label, ":"];
  Print["  Count: ", Length[dataset]];
  Print["  Mean R: ", N[meanR, 6]];
  Print["  Std R: ", N[stdR, 6]];
  Print["  Mean period: ", N[meanPeriod, 4]];
  Print["  x ≡ +1 (mod p): ", xPlus1, "/", Length[dataset],
    " = ", N[100*xPlus1/Length[dataset], 3], "%"];
  Print["  x ≡ -1 (mod p): ", xMinus1, "/", Length[dataset],
    " = ", N[100*xMinus1/Length[dataset], 3], "%"];
  Print[];
]

PrintModStats[1, data1, "p ≡ 1 (mod 8)"];
PrintModStats[3, data3, "p ≡ 3 (mod 8)"];
PrintModStats[7, data7, "p ≡ 7 (mod 8)"];

(* Compare R distributions *)
Print[StringRepeat["=", 80]];
Print["COMPARISON: R(p) BY MOD 8 CLASS"];
Print[StringRepeat["=", 80]];
Print[];

R1 = #["R"] & /@ data1;
R3 = #["R"] & /@ data3;
R7 = #["R"] & /@ data7;

If[Length[R1] > 0 && Length[R3] > 0 && Length[R7] > 0,
  Print["Mean R (p ≡ 1): ", N[Mean[R1], 6]];
  Print["Mean R (p ≡ 3): ", N[Mean[R3], 6]];
  Print["Mean R (p ≡ 7): ", N[Mean[R7], 6]];
  Print[];

  (* ANOVA-style comparison *)
  allR = Join[R1, R3, R7];
  grandMean = Mean[allR];

  betweenVar = (
    Length[R1] * (Mean[R1] - grandMean)^2 +
    Length[R3] * (Mean[R3] - grandMean)^2 +
    Length[R7] * (Mean[R7] - grandMean)^2
  );

  Print["Grand mean R: ", N[grandMean, 6]];
  Print["Between-group variance: ", N[betweenVar, 6]];
  Print[];

  If[betweenVar > 10,
    Print["  → SIGNIFICANT difference between mod 8 classes! ⭐"],
    Print["  → No significant difference by mod 8"]
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print["SAMPLE DATA (first 10 from each class)"];
Print[StringRepeat["=", 80]];
Print[];

PrintSample[dataset_, label_] := Module[{},
  Print[label, ":"];
  Print["   p     R      Period  x mod p"];
  Print[StringRepeat["-", 40]];
  Do[
    Module[{d = dataset[[i]], xModLabel},
      xModLabel = If[d["xModP"] == 1, "+1", ToString[d["xModP"]]];
      Print[
        d["p"], "  ",
        N[d["R"], 5], "  ",
        d["period"], "    ",
        xModLabel
      ];
    ],
    {i, 1, Min[10, Length[dataset]]}
  ];
  Print[];
]

PrintSample[data1, "p ≡ 1 (mod 8)"];
PrintSample[data3, "p ≡ 3 (mod 8)"];
PrintSample[data7, "p ≡ 7 (mod 8)"];

Print[StringRepeat["=", 80]];
Print["CONCLUSION"];
Print[StringRepeat["=", 80]];
Print[];
Print["Question: Does mod 8 structure R(p)?"];
Print["Answer: [See statistics above]"];
Print[];

(* Correlation test *)
If[Length[data] > 10,
  Module[{pMod8Vals, Rvals, corr},
    pMod8Vals = N[#["pMod8"] & /@ data];
    Rvals = N[#["R"] & /@ data];
    corr = Correlation[pMod8Vals, Rvals];
    Print["Correlation: p mod 8 ↔ R(p) = ", N[corr, 4]];
    If[Abs[corr] > 0.3,
      Print["  → SIGNIFICANT correlation! ⭐"],
      Print["  → Weak/no correlation"]
    ];
  ]
];

Print[];
Print["Analysis complete."];
