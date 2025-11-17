#!/usr/bin/env wolframscript
(* LEARNED COEFFICIENTS MODEL with h(n) *)

Print[StringRepeat["=", 80]];
Print["LEARNED MODEL: R ~ g(mod8) * f(dist, M, h)"];
Print[StringRepeat["=", 80]];
Print[];

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

DistToK2[n_] := Module[{k},
  k = Floor[Sqrt[n]];
  Min[n - k^2, (k+1)^2 - n]
]

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

(* Class number - only for square-free n *)
ClassNumber[n_] := Module[{factors},
  factors = FactorInteger[n];
  If[Max[factors[[All, 2]]] > 1,
    Return[Missing["NotSquareFree"]]
  ];
  (* Use Mathematica's built-in *)
  NumberFieldClassNumber[Sqrt[n]]
]

(* === TRAIN === *)
Print["PHASE 1: Learn from n <= 100"];
Print[];

trainData = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{R, dist, m, h, mod8},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      h = ClassNumber[n];
      mod8 = Mod[n, 8];
      If[R > 0 && !MissingQ[h],
        {n, R, dist, m, h, mod8},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 3, 100}
];

trainData = DeleteCases[trainData, Nothing];

Print["Training: ", Length[trainData], " square-free odd n"];
Print[];

(* Baselines *)
baselines = Association[];
For[mod = 1, mod <= 7, mod += 2,
  subset = Select[trainData, #[[6]] == mod &];
  If[Length[subset] > 0,
    baselines[mod] = Mean[subset[[All, 2]]];
    Print["g(", mod, ") = ", N[baselines[mod], 4], " (n=", Length[subset], ")"];
  ]
];

Print[];

(* Learn coefficients from RESIDUALS *)
Print["Learning coefficients from normalized residuals:"];
Print[];

(* Normalize by baseline first *)
trainNormalized = Table[
  {n, R, dist, m, h, mod8} = trainData[[i]];
  baseline = baselines[mod8];
  Rnorm = R / baseline;  (* ratio to baseline *)
  {n, Rnorm, dist, m, h, mod8},
  {i, Length[trainData]}
];

(* Now fit: R_norm = 1 + alpha*dist + beta*M + gamma*h *)
RnormVals = trainNormalized[[All, 2]];
distVals = trainNormalized[[All, 3]];
MVals = trainNormalized[[All, 4]];
hVals = trainNormalized[[All, 5]];

(* Simple correlations *)
corrDist = Correlation[N[distVals], N[RnormVals]];
corrM = Correlation[N[MVals], N[RnormVals]];
corrH = Correlation[N[hVals], N[RnormVals]];

Print["Correlations with R_normalized:"];
Print["  dist: ", N[corrDist, 4]];
Print["  M:    ", N[corrM, 4]];
Print["  h:    ", N[corrH, 4]];
Print[];

(* Compute coefficients as correlation * (std_y / std_x) *)
alphaDist = corrDist * StandardDeviation[N[RnormVals]] / StandardDeviation[N[distVals]];
betaM = corrM * StandardDeviation[N[RnormVals]] / StandardDeviation[N[MVals]];
gammaH = corrH * StandardDeviation[N[RnormVals]] / StandardDeviation[N[hVals]];

Print["LEARNED COEFFICIENTS:"];
Print["  alpha (dist):  ", N[alphaDist, 4]];
Print["  beta  (M):     ", N[betaM, 4]];
Print["  gamma (h):     ", N[gammaH, 4]];
Print[];

Print["Model: R(n) = g(n mod 8) * (1 + ", N[alphaDist, 3], "*dist + ",
      N[betaM, 3], "*M + ", N[gammaH, 3], "*h)"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* === TEST === *)
Print["PHASE 2: Predict on 100 < n <= 200"];
Print[];

testData = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]] && n > 100,
    Module[{R, dist, m, h, mod8},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      h = ClassNumber[n];
      mod8 = Mod[n, 8];
      If[R > 0 && !MissingQ[h],
        {n, R, dist, m, h, mod8},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 101, 200}
];

testData = DeleteCases[testData, Nothing];

Print["Test: ", Length[testData], " square-free odd n"];
Print[];

(* Predictions *)
RTrue = testData[[All, 2]];

predBaseline = Table[baselines[testData[[i, 6]]], {i, Length[testData]}];

predFull = Table[
  {n, Rtrue, dist, m, h, mod8} = testData[[i]];
  baseline = baselines[mod8];
  baseline * (1 + alphaDist*dist + betaM*m + gammaH*h),
  {i, Length[testData]}
];

(* Correlations *)
corrBaseline = Correlation[N[RTrue], N[predBaseline]];
corrFull = Correlation[N[RTrue], N[predFull]];

Print["RESULTS:"];
Print[StringRepeat["-", 60]];
Print["Baseline only:            r = ", N[corrBaseline, 4]];
Print["Full (dist + M + h):      r = ", N[corrFull, 4]];
Print[];

improvement = 100 * (corrFull - corrBaseline) / corrBaseline;
Print["Improvement: +", N[improvement, 3], "%"];
Print[];

(* Error statistics *)
errorsFull = Table[
  Abs[RTrue[[i]] - predFull[[i]]] / RTrue[[i]],
  {i, Length[RTrue]}
];

Print["Mean relative error: ", N[100*Mean[errorsFull], 2], "%"];
Print["Median relative error: ", N[100*Median[errorsFull], 2], "%"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

Print["INTERPRETATION:"];
Print[StringRepeat["-", 60]];
Print[];
Print["Class number h(n):"];
Print["  - Counts ideal classes in Z[sqrt(n)]"];
Print["  - h=1: unique factorization (easier Pell)"];
Print["  - h>1: non-unique factorization (harder Pell)"];
Print["  - Correlation h <-> R: ", N[corrH, 3], If[corrH < 0, " (anti-corr)", ""]];
Print[];
Print["Distance to k^2:"];
Print["  - Determines CF first term a_1 = floor(2k/c)"];
Print["  - Larger c -> smaller a_1 -> longer period -> larger R"];
Print["  - Correlation dist <-> R_norm: ", N[corrDist, 3]];
Print[];
Print["Childhood M(n):"];
Print["  - Counts 'obstacles' (divisors between 2 and sqrt(n))"];
Print["  - More divisors -> easier Pell (smaller R)"];
Print["  - Correlation M <-> R_norm: ", N[corrM, 3], If[corrM < 0, " (anti-corr)", ""]];
Print[];

Print[StringRepeat["=", 80]];
