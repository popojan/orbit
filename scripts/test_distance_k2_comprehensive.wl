#!/usr/bin/env wolframscript
(* Comprehensive test: Distance to k² + mod 8 + class number *)

Print[StringRepeat["=", 80]];
Print["DISTANCE TO PERFECT SQUARE: Comprehensive Analysis"];
Print[StringRepeat["=", 80]];
Print[];

(* Helper functions *)
PellSol[D_] := Module[{sol},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];
  sol = Solve[x^2 - D*y^2 == 1, {x, y}, PositiveIntegers] /. C[1] -> 1;
  If[sol === {}, {0, 0}, {x, y} /. First[sol]]
]

Reg[D_] := Module[{sol, x, y},
  sol = PellSol[D];
  {x, y} = sol;
  If[x > 1, N[Log[x + y*Sqrt[D]], 15], 0.0]
]

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

(* Distance to nearest perfect square *)
DistToK2[n_] := Module[{k},
  k = Floor[Sqrt[n]];
  Min[n - k^2, (k+1)^2 - n]
]

(* Which k² is closer: below or above? *)
K2Direction[n_] := Module[{k},
  k = Floor[Sqrt[n]];
  If[n - k^2 <= (k+1)^2 - n, "above k²", "below (k+1)²"]
]

(* Class number (for square-free only) *)
ClassNum[n_] := Module[{h},
  If[!SquareFreeQ[n] || IntegerQ[Sqrt[n]], Return[0]];
  h = NumberFieldClassNumber[Sqrt[n]];
  h
]

(* Collect comprehensive data *)
Print["Collecting data for n = 2..200 (non-perfect-squares)..."];
Print[];

data = Table[
  If[!IntegerQ[Sqrt[n]],
    Module[{R, m, dist, dir, mod8, h, sqFree},
      R = Reg[n];
      m = M[n];
      dist = DistToK2[n];
      dir = K2Direction[n];
      mod8 = Mod[n, 8];
      sqFree = SquareFreeQ[n];
      h = If[sqFree, ClassNum[n], 0];

      If[R > 0,
        {n, R, m, dist, dir, mod8, sqFree, h},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 2, 200}
];

data = DeleteCases[data, Nothing];

Print["Collected ", Length[data], " non-square n"];
Print[];

(* === OVERALL CORRELATIONS === *)
Print["=== OVERALL CORRELATIONS ==="];
Print[StringRepeat["-", 40]];

RVals = data[[All, 2]];
MVals = data[[All, 3]];
distVals = data[[All, 4]];

Print["dist(n,k²) ↔ R(n):  ", N[Correlation[N[distVals], N[RVals]], 4]];
Print["M(n) ↔ R(n):        ", N[Correlation[N[MVals], N[RVals]], 4]];
Print["dist ↔ M:           ", N[Correlation[N[distVals], N[MVals]], 4]];
Print[];

(* === BY MOD 8 === *)
Print["=== DISTANCE ↔ R BY MOD 8 ==="];
Print[StringRepeat["-", 40]];

For[mod = 1, mod <= 7, mod++,
  Module[{subset, distSub, RSub, corr},
    subset = Select[data, #[[6]] == mod &];
    If[Length[subset] > 5,
      distSub = subset[[All, 4]];
      RSub = subset[[All, 2]];
      corr = Correlation[N[distSub], N[RSub]];

      Print["n ≡ ", mod, " (mod 8):"];
      Print["  Count:      ", Length[subset]];
      Print["  Mean dist:  ", N[Mean[distSub], 4]];
      Print["  Mean R:     ", N[Mean[RSub], 4]];
      Print["  dist ↔ R:   ", N[corr, 4]];
      Print[];
    ]
  ]
];

Print[StringRepeat["=", 80]];
Print[];

(* === DIRECTION: above vs below k² === *)
Print["=== DISTANCE DIRECTION ANALYSIS ==="];
Print[StringRepeat["-", 40]];

aboveData = Select[data, #[[5]] == "above k²" &];
belowData = Select[data, #[[5]] == "below (k+1)²" &];

Print["n closer to k² (above): ", Length[aboveData]];
Print["  Mean R: ", N[Mean[aboveData[[All, 2]]], 4]];
Print[];

Print["n closer to (k+1)² (below): ", Length[belowData]];
Print["  Mean R: ", N[Mean[belowData[[All, 2]]], 4]];
Print[];

If[Length[aboveData] > 5 && Length[belowData] > 5,
  tTest = TTest[aboveData[[All, 2]], belowData[[All, 2]]];
  Print["T-test p-value: ", N[tTest, 4]];
  If[tTest < 0.05,
    Print["✅ SIGNIFICANT difference! Position relative to k² matters."],
    Print["❌ No significant difference by direction."]
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* === SQUARE-FREE ONLY (with class number) === *)
Print["=== SQUARE-FREE n ONLY (with h) ==="];
Print[StringRepeat["-", 40]];

sqFreeData = Select[data, #[[7]] == True && #[[8]] > 0 &];

Print["Square-free n: ", Length[sqFreeData]];
Print[];

distSF = sqFreeData[[All, 4]];
RSF = sqFreeData[[All, 2]];
hSF = sqFreeData[[All, 8]];

Print["Correlations (square-free only):"];
Print["  dist ↔ R:  ", N[Correlation[N[distSF], N[RSF]], 4]];
Print["  dist ↔ h:  ", N[Correlation[N[distSF], N[hSF]], 4]];
Print["  h ↔ R:     ", N[Correlation[N[hSF], N[RSF]], 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* === ODD n ONLY === *)
Print["=== ODD n ONLY (cleaner data) ==="];
Print[StringRepeat["-", 40]];

oddData = Select[data, OddQ[#[[1]]] &];
Print["Odd n: ", Length[oddData]];
Print[];

distOdd = oddData[[All, 4]];
ROdd = oddData[[All, 2]];
MOdd = oddData[[All, 3]];

Print["Correlations (odd n only):"];
Print["  dist ↔ R:  ", N[Correlation[N[distOdd], N[ROdd]], 4]];
Print["  M ↔ R:     ", N[Correlation[N[MOdd], N[ROdd]], 4]];
Print["  dist ↔ M:  ", N[Correlation[N[distOdd], N[MOdd]], 4]];
Print[];

(* By mod 8 for odd *)
Print["By mod 8 (odd n):"];
For[mod = 1, mod <= 7, mod += 2,
  Module[{subset, distSub, RSub, corr},
    subset = Select[oddData, #[[6]] == mod &];
    If[Length[subset] > 5,
      distSub = subset[[All, 4]];
      RSub = subset[[All, 2]];
      corr = Correlation[N[distSub], N[RSub]];

      Print["  n ≡ ", mod, ": dist↔R = ", N[corr, 4],
            " (", Length[subset], " points)"];
    ]
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* === MULTIVARIATE: dist + M combined === *)
Print["=== COMBINED PREDICTORS (odd n) ==="];
Print[StringRepeat["-", 40]];

Print["Question: Does dist + M together predict R better than alone?"];
Print[];

(* Linear model: R ~ a*dist + b*M + c *)
fitData = Table[{{distOdd[[i]], MOdd[[i]]}, ROdd[[i]]}, {i, Length[oddData]}];
fit = LinearModelFit[fitData, {x, y}, {x, y}];

Print["Linear model: R(n) ≈ a·dist + b·M + c"];
Print["  a (dist coef): ", N[fit["BestFitParameters"][[2]], 4]];
Print["  b (M coef):    ", N[fit["BestFitParameters"][[3]], 4]];
Print["  c (intercept): ", N[fit["BestFitParameters"][[1]], 4]];
Print["  R²:            ", N[fit["RSquared"], 4]];
Print["  Correlation:   ", N[Sqrt[fit["RSquared"]], 4]];
Print[];

(* Compare to individual predictors *)
corrDistOnly = Correlation[N[distOdd], N[ROdd]];
corrMOnly = Correlation[N[MOdd], N[ROdd]];

Print["Comparison:"];
Print["  dist alone:     r = ", N[corrDistOnly, 4], ", R² = ", N[corrDistOnly^2, 4]];
Print["  M alone:        r = ", N[corrMOnly, 4], ", R² = ", N[corrMOnly^2, 4]];
Print["  dist + M:       R² = ", N[fit["RSquared"], 4]];
Print[];

improvement = (fit["RSquared"] - Max[corrDistOnly^2, corrMOnly^2]) / Max[corrDistOnly^2, corrMOnly^2];
Print["Improvement: ", N[100*improvement, 2], "%"];

If[improvement > 0.1,
  Print["✅ COMBINED MODEL significantly better!"],
  Print["❌ Combined model not much better than best individual predictor."]
];

Print[];
Print[StringRepeat["=", 80]];
Print["ANALYSIS COMPLETE"];
