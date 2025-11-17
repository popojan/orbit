#!/usr/bin/env wolframscript
(* FALSIFICATION TEST: Can we PREDICT R(n) from theory? *)

Print[StringRepeat["=", 80]];
Print["FALSIFICATION TEST: Predictive Model for R(n)"];
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

DistToK2[n_] := Module[{k},
  k = Floor[Sqrt[n]];
  Min[n - k^2, (k+1)^2 - n]
]

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

(* === TRAINING SET: n <= 100 === *)
Print["PHASE 1: BUILD MODEL FROM n <= 100"];
Print[StringRepeat["-", 60]];
Print[];

trainingData = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{R, dist, m, mod8},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      mod8 = Mod[n, 8];
      If[R > 0, {n, R, dist, m, mod8}, Nothing]
    ],
    Nothing
  ],
  {n, 3, 100}
];

trainingData = DeleteCases[trainingData, Nothing];

Print["Training set: ", Length[trainingData], " odd n <= 100"];
Print[];

(* Baselines by mod 8 *)
baselines = Association[];
For[mod = 1, mod <= 7, mod += 2,
  subset = Select[trainingData, #[[5]] == mod &];
  If[Length[subset] > 0,
    baselines[mod] = Mean[subset[[All, 2]]];
    Print["g(", mod, ") = ", N[baselines[mod], 4], " (n=", Length[subset], ")"];
  ]
];

Print[];

(* Fit linear model: R = g(mod8) * (1 + α*dist - β*M) *)
Print["Fitting model: R = g(mod8) * (1 + alpha*dist - beta*M)"];
Print[];

(* For each mod class, fit α and β *)
coeffs = Association[];
For[mod = 1, mod <= 7, mod += 2,
  subset = Select[trainingData, #[[5]] == mod &];
  If[Length[subset] > 5,
    RVals = subset[[All, 2]];
    distVals = subset[[All, 3]];
    MVals = subset[[All, 4]];

    (* Normalize by baseline *)
    RNorm = RVals / baselines[mod];

    (* Fit: R_norm = const + α*dist - β*M *)
    (* Prepare data: each row is {dist, M, R_normalized} *)
    fitData = Transpose[{distVals, MVals, RNorm}];

    fit = LinearModelFit[fitData, {1, dist, M}, {dist, M}];

    params = fit["BestFitParameters"];
    coeffs[mod] = {
      params[[2]],  (* α for dist *)
      params[[3]],  (* β for M *)
      params[[1]]   (* constant *)
    };

    Print["mod ", mod, ": α=", N[coeffs[mod][[1]], 3],
          ", β=", N[coeffs[mod][[2]], 3],
          ", R²=", N[fit["RSquared"], 3]];
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* === TEST SET: 100 < n <= 200 === *)
Print["PHASE 2: PREDICT UNSEEN n (100 < n <= 200)"];
Print[StringRepeat["-", 60]];
Print[];

testData = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]] && n > 100,
    Module[{R, dist, m, mod8},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      mod8 = Mod[n, 8];
      If[R > 0, {n, R, dist, m, mod8}, Nothing]
    ],
    Nothing
  ],
  {n, 101, 200}
];

testData = DeleteCases[testData, Nothing];

Print["Test set: ", Length[testData], " odd n (100 < n <= 200)"];
Print[];

(* Make predictions *)
predictions = Table[
  {n, Rtrue, dist, m, mod8} = testData[[i]];

  If[KeyExistsQ[baselines, mod8] && KeyExistsQ[coeffs, mod8],
    baseline = baselines[mod8];
    {alpha, beta, const} = coeffs[mod8];

    (* Predict: R = baseline * (const + α*dist - β*M) *)
    Rpred = baseline * (const + alpha*dist - beta*m);

    (* CORRECTED METRICS *)
    (* 1. MAE on R (log scale) *)
    errorR = Abs[Rtrue - Rpred];

    (* 2. Error on x (exponential scale) *)
    (* x = cosh(R) from x^2 - ny^2 = 1, x + y√n = e^R *)
    xTrue = Cosh[Rtrue];
    xPred = Cosh[Rpred];
    errorX = Abs[xTrue - xPred];

    (* 3. Relative error on x (percent) *)
    relErrorX = errorX / xTrue;

    (* 4. Integer precision achieved? *)
    integerPrecision = If[errorX < 1, 1, 0];

    {n, Rtrue, Rpred, errorR, xTrue, xPred, errorX, relErrorX, integerPrecision, mod8},

    (* No model for this mod8 *)
    Nothing
  ],
  {i, Length[testData]}
];

predictions = DeleteCases[predictions, Nothing];

Print["PREDICTIONS vs ACTUAL:"];
Print[StringRepeat["-", 80]];
Print["n    mod8  R(act)   R(pred)  ΔR      x(actual)    x(pred)      Δx         IntPrec?"];
Print[StringRepeat["-", 80]];

Do[
  {n, Rtrue, Rpred, errR, xTrue, xPred, errX, relErrX, intPrec, mod8} = predictions[[i]];
  Print[
    StringPadRight[ToString[n], 5],
    StringPadRight[ToString[mod8], 6],
    StringPadRight[ToString[N[Rtrue, 4]], 9],
    StringPadRight[ToString[N[Rpred, 4]], 9],
    StringPadRight[ToString[N[errR, 3]], 8],
    StringPadRight[ToString[NumberForm[xTrue, {6,0}]], 13],
    StringPadRight[ToString[NumberForm[xPred, {6,0}]], 13],
    StringPadRight[ToString[NumberForm[errX, {4,1}]], 11],
    If[intPrec == 1, "✓", "✗"]
  ];
  ,
  {i, Min[30, Length[predictions]]}
];

Print[];

(* Statistics *)
errorsR = predictions[[All, 4]];
xTrueVals = predictions[[All, 5]];
xPredVals = predictions[[All, 6]];
errorsX = predictions[[All, 7]];
relErrorsX = predictions[[All, 8]];
intPrecVals = predictions[[All, 9]];

Print["PREDICTION STATISTICS:"];
Print[StringRepeat["-", 60]];
Print[];
Print["On R (log scale):"];
Print["  MAE(R):        ", N[Mean[errorsR], 4]];
Print["  Median AE(R):  ", N[Median[errorsR], 4]];
Print["  Max error(R):  ", N[Max[errorsR], 4]];
Print[];
Print["On x (exponential scale):"];
Print["  MAE(x):        ", NumberForm[Mean[errorsX], {6,0}]];
Print["  Median AE(x):  ", NumberForm[Median[errorsX], {6,0}]];
Print["  Max error(x):  ", NumberForm[Max[errorsX], {8,0}]];
Print["  Mean rel err:  ", N[100*Mean[relErrorsX], 2], "%"];
Print[];
Print["Integer precision achieved: ", Total[intPrecVals], "/", Length[intPrecVals],
      " (", N[100*Mean[intPrecVals], 1], "%)"];
Print[];

(* Correlation predicted vs actual *)
RTrue = predictions[[All, 2]];
RPred = predictions[[All, 3]];
corrPredTrue = Correlation[N[RTrue], N[RPred]];

Print["Correlation R(pred) <-> R(actual): ", N[corrPredTrue, 4]];

(* Correlation on x scale *)
corrXPredTrue = Correlation[N[xTrueVals], N[xPredVals]];
Print["Correlation x(pred) <-> x(actual): ", N[corrXPredTrue, 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* === FALSIFICATION CRITERIA === *)
Print["FALSIFICATION TEST:"];
Print[StringRepeat["-", 60]];
Print[];

Print["FALSIFICATION CRITERIA:"];
Print[];
Print["If theory is USEFUL, we expect:"];
Print["  1. Correlation R(pred) <-> R(actual) > 0.7"];
Print["  2. MAE(R) < 2.0  (log scale acceptable)"];
Print["  3. Integer precision (|x_pred - x_actual| < 1) in >50% cases"];
Print["  4. Mean x error < 10^6  (practical Pell solving)"];
Print[];

Print["RESULTS:"];
Print["  1. Correlation(R): ", N[corrPredTrue, 4],
      If[corrPredTrue > 0.7, " ✓ PASS", " ✗ FAIL"]];
Print["  2. MAE(R):         ", N[Mean[errorsR], 4],
      If[Mean[errorsR] < 2.0, " ✓ PASS", " ✗ FAIL"]];
Print["  3. Int precision:  ", N[100*Mean[intPrecVals], 1], "%",
      If[Mean[intPrecVals] > 0.5, " ✓ PASS", " ✗ FAIL"]];
Print["  4. MAE(x):         ", NumberForm[Mean[errorsX], {6,1}],
      If[Mean[errorsX] < 1000000, " ✓ PASS", " ✗ FAIL"]];

bias = Mean[predictions[[All, 3]] - predictions[[All, 2]]];
Print["  5. Bias (R):       ", N[bias, 4],
      If[Abs[bias] < 1, " ✓ PASS (no systematic bias)", " ⚠ Warning (biased)"]];

Print[];

passCount = 0;
If[corrPredTrue > 0.7, passCount++];
If[Mean[errorsR] < 2.0, passCount++];
If[Mean[intPrecVals] > 0.5, passCount++];
If[Mean[errorsX] < 1000000, passCount++];

If[passCount >= 3,
  Print["✅ THEORY USEFUL for prediction (", passCount, "/4 criteria passed)"];
  Print["   Model has practical predictive power for Pell solutions"],
  Print["❌ THEORY INSUFFICIENT (", passCount, "/4 criteria passed)"];
  Print["   Missing factors or fundamental limitation"]
];

Print[];
Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
