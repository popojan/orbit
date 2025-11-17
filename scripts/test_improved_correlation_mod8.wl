#!/usr/bin/env wolframscript
(*
Test: Does mod 8 stratification improve M(D) ↔ R(D) correlation?

Hypothesis: -0.33 correlation is weakened by mod 8 mixing.
If we condition on mod 8 class, correlation should strengthen.
*)

Print[StringRepeat["=", 80]];
Print["IMPROVED M-R CORRELATION WITH MOD 8 STRATIFICATION"];
Print[StringRepeat["=", 80]];
Print[];

(* M(n) - childhood function *)
M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

(* Fundamental Pell solution *)
PellSol[D_] := Module[{sol},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];
  sol = Solve[x^2 - D*y^2 == 1, {x, y}, PositiveIntegers] /. C[1] -> 1;
  If[sol === {}, {0, 0}, {x, y} /. First[sol]]
]

(* Regulator *)
Regulator[D_] := Module[{sol, x, y},
  sol = PellSol[D];
  {x, y} = sol;
  If[x == 0 || x == 1, 0.0, N[Log[x + y*Sqrt[D]], 20]]
]

(* Collect data for n = 2..200, exclude perfect squares *)
Print["Computing M(n) and R(n) for n = 2..200..."];
Print[];

data = Table[
  If[IntegerQ[Sqrt[n]],
    Nothing,  (* Skip perfect squares *)
    Module[{m, R},
      m = M[n];
      R = Regulator[n];
      If[R > 0,
        {n, m, R, Mod[n, 8]},
        Nothing
      ]
    ]
  ],
  {n, 2, 200}
];

data = DeleteCases[data, Nothing];

Print["Collected ", Length[data], " data points"];
Print[];

(* Overall correlation *)
allM = data[[All, 2]];
allR = data[[All, 3]];

overallCorr = Correlation[allM, allR];

Print["OVERALL CORRELATION (all n mixed):"];
Print["  M(n) ↔ R(n): ", N[overallCorr, 4]];
Print[];

(* Stratify by mod 8 *)
data1 = Select[data, #[[4]] == 1 &];
data2 = Select[data, #[[4]] == 2 &];
data3 = Select[data, #[[4]] == 3 &];
data4 = Select[data, #[[4]] == 4 &];
data5 = Select[data, #[[4]] == 5 &];
data6 = Select[data, #[[4]] == 6 &];
data7 = Select[data, #[[4]] == 7 &];

Print[StringRepeat["=", 80]];
Print["STRATIFIED BY MOD 8"];
Print[StringRepeat["=", 80]];
Print[];

(* Compute correlations for each class *)
correlations = {};

Do[
  Module[{subset, Mvals, Rvals, corr, meanM, meanR},
    subset = Select[data, #[[4]] == mod &];
    If[Length[subset] > 5,  (* Need enough points *)
      Mvals = subset[[All, 2]];
      Rvals = subset[[All, 3]];
      corr = Correlation[Mvals, Rvals];
      meanM = Mean[Mvals];
      meanR = Mean[Rvals];

      AppendTo[correlations, {mod, Length[subset], corr, meanM, meanR}];

      Print["n ≡ ", mod, " (mod 8):"];
      Print["  Count: ", Length[subset]];
      Print["  Mean M: ", N[meanM, 4]];
      Print["  Mean R: ", N[meanR, 4]];
      Print["  M ↔ R correlation: ", N[corr, 4]];

      If[Abs[corr] > Abs[overallCorr],
        Print["    → STRONGER than overall! ⭐"],
        Print["    → Weaker than overall"]
      ];
      Print[];
    ]
  ],
  {mod, 1, 7}
];

Print[StringRepeat["=", 80]];
Print["COMPARISON"];
Print[StringRepeat["=", 80]];
Print[];

Print["Overall (mixed):      M ↔ R = ", N[overallCorr, 4]];
Print[];

validCorrs = Select[correlations, Length[#] >= 5 &][[All, 3]];

If[Length[validCorrs] > 0,
  meanStratified = Mean[Abs /@ validCorrs];
  Print["Mean |correlation| within mod 8 classes: ", N[meanStratified, 4]];
  Print[];

  If[meanStratified > Abs[overallCorr],
    Print["✅ HYPOTHESIS CONFIRMED!"];
    Print["   Stratification by mod 8 STRENGTHENS correlation!"];
    Print["   Improvement: ", N[100*(meanStratified/Abs[overallCorr] - 1), 2], "%"];
    ,
    Print["❌ HYPOTHESIS REJECTED"];
    Print["   Stratification does not improve correlation"];
  ];
  Print[];
];

Print[StringRepeat["=", 80]];
Print["DETAILED BREAKDOWN"];
Print[StringRepeat["=", 80]];
Print[];

Print["n mod 8  Count  M↔R corr  Mean M  Mean R"];
Print[StringRepeat["-", 50]];
Do[
  If[Length[corr] >= 3,
    Print[
      corr[[1]], "        ",
      corr[[2]], "     ",
      N[corr[[3]], 4], "    ",
      N[corr[[4]], 3], "    ",
      N[corr[[5]], 4]
    ]
  ],
  {corr, correlations}
];

Print[];
Print["Analysis complete."];
Print[StringRepeat["=", 80]];
