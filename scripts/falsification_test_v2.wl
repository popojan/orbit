#!/usr/bin/env wolframscript
(* FALSIFICATION TEST V2: Relative error metrics *)

Print[StringRepeat["=", 80]];
Print["FALSIFICATION TEST V2: R(n) Prediction with Relative Error"];
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

(* === PHASE 1: TRAINING === *)
Print["PHASE 1: BUILD MODEL FROM n <= 100"];
Print[StringRepeat["-", 60]];
Print[];

trainingData = Flatten[Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{R, dist, m, mod8},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      mod8 = Mod[n, 8];
      If[R > 0, {{n, R, dist, m, mod8}}, {}]
    ],
    {}
  ],
  {n, 3, 100}
], 1];

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
Print["Fitting: R = g(mod8) * (1 + α·dist - β·M)"];
Print[];

(* Fit per mod class *)
coeffs = Association[];
For[mod = 1, mod <= 7, mod += 2,
  subset = Select[trainingData, #[[5]] == mod &];
  If[Length[subset] > 5,
    RVals = subset[[All, 2]];
    distVals = subset[[All, 3]];
    MVals = subset[[All, 4]];

    (* Normalize *)
    RNorm = RVals / baselines[mod];

    (* Linear fit *)
    data = Transpose[{distVals, MVals, RNorm}];
    fit = LinearModelFit[data, {1, d, m}, {d, m}];
    params = fit["BestFitParameters"];

    coeffs[mod] = {
      params[[2]],  (* α *)
      params[[3]],  (* β *)
      params[[1]]   (* const *)
    };

    Print["mod ", mod, ": α=", N[coeffs[mod][[1]], 3],
          ", β=", N[coeffs[mod][[2]], 3],
          ", R²=", N[fit["RSquared"], 3]];
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* === PHASE 2: TEST === *)
Print["PHASE 2: PREDICT UNSEEN n (100 < n <= 200)"];
Print[StringRepeat["-", 60]];
Print[];

testData = Flatten[Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]] && n > 100,
    Module[{R, dist, m, mod8},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      mod8 = Mod[n, 8];
      If[R > 0, {{n, R, dist, m, mod8}}, {}]
    ],
    {}
  ],
  {n, 101, 200}
], 1];

Print["Test set: ", Length[testData], " odd n (100 < n <= 200)"];
Print[];

(* Make predictions *)
predictions = Table[
  Module[{n, Rtrue, dist, m, mod8, baseline, alpha, beta, const, Rpred,
          errorR, xTrue, xPred, errorX, relErrorX, good1pct, good01pct},

    {n, Rtrue, dist, m, mod8} = testData[[i]];

    If[KeyExistsQ[baselines, mod8] && KeyExistsQ[coeffs, mod8],
      baseline = baselines[mod8];
      {alpha, beta, const} = coeffs[mod8];

      (* Predict R *)
      Rpred = baseline * (const + alpha*dist - beta*m);

      (* Error on R (log scale) *)
      errorR = Abs[Rtrue - Rpred];

      (* Error on x (exponential scale) *)
      xTrue = Cosh[Rtrue];
      xPred = Cosh[Rpred];
      errorX = Abs[xTrue - xPred];

      (* RELATIVE error on x *)
      relErrorX = errorX / xTrue;

      (* Success criteria *)
      good1pct = If[relErrorX < 0.01, 1, 0];    (* <1% *)
      good01pct = If[relErrorX < 0.001, 1, 0];  (* <0.1% *)

      {n, Rtrue, Rpred, errorR, xTrue, xPred, errorX, relErrorX, good1pct, good01pct, mod8},

      Nothing
    ]
  ],
  {i, Length[testData]}
];

predictions = DeleteCases[predictions, Nothing];

Print["PREDICTIONS vs ACTUAL (first 20):"];
Print[StringRepeat["-", 80]];
Print["n    mod8  R(act)   R(pred)  ΔR      RelErr(x)   <1%?  <0.1%?"];
Print[StringRepeat["-", 80]];

Do[
  Module[{n, Rtrue, Rpred, errR, xTrue, xPred, errX, relErrX, g1, g01, mod8},
    {n, Rtrue, Rpred, errR, xTrue, xPred, errX, relErrX, g1, g01, mod8} = predictions[[i]];
    Print[
      StringPadRight[ToString[n], 5],
      StringPadRight[ToString[mod8], 6],
      StringPadRight[ToString[N[Rtrue, 4]], 9],
      StringPadRight[ToString[N[Rpred, 4]], 9],
      StringPadRight[ToString[N[errR, 3]], 8],
      StringPadRight[ToString[N[100*relErrX, 2]], 12],
      If[g1 == 1, "✓    ", "✗    "],
      If[g01 == 1, "✓", "✗"]
    ];
  ],
  {i, Min[20, Length[predictions]]}
];

Print[];

(* Statistics *)
errorsR = predictions[[All, 4]];
relErrorsX = predictions[[All, 8]];
good1pct = predictions[[All, 9]];
good01pct = predictions[[All, 10]];

Print["PREDICTION STATISTICS:"];
Print[StringRepeat["-", 60]];
Print[];
Print["On R (log scale):"];
Print["  MAE(R):        ", N[Mean[errorsR], 4]];
Print["  Median AE(R):  ", N[Median[errorsR], 4]];
Print["  Max error(R):  ", N[Max[errorsR], 4]];
Print[];
Print["On x (exponential scale, RELATIVE):"];
Print["  Mean rel err:  ", N[100*Mean[relErrorsX], 2], "%"];
Print["  Median rel err:", N[100*Median[relErrorsX], 2], "%"];
Print["  Max rel err:   ", N[100*Max[relErrorsX], 1], "%"];
Print[];
Print["Success rates:"];
Print["  <1% error:     ", Total[good1pct], "/", Length[good1pct],
      " (", N[100*Mean[good1pct], 1], "%)"];
Print["  <0.1% error:   ", Total[good01pct], "/", Length[good01pct],
      " (", N[100*Mean[good01pct], 1], "%)"];
Print[];

(* Correlation *)
RTrue = predictions[[All, 2]];
RPred = predictions[[All, 3]];
corrR = Correlation[N[RTrue], N[RPred]];

Print["Correlation R(pred) <-> R(actual): ", N[corrR, 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* FALSIFICATION *)
Print["FALSIFICATION TEST:"];
Print[StringRepeat["-", 60]];
Print[];

Print["Criteria (RELATIVE error on x):"];
Print["  1. Correlation R(pred) <-> R(actual) > 0.7"];
Print["  2. MAE(R) < 2.0"];
Print["  3. Mean relative error on x < 50%"];
Print["  4. Success rate (<1% rel error) > 30%"];
Print[];

Print["RESULTS:"];
Print["  1. Correlation(R): ", N[corrR, 4],
      If[corrR > 0.7, " ✓ PASS", " ✗ FAIL"]];
Print["  2. MAE(R):         ", N[Mean[errorsR], 4],
      If[Mean[errorsR] < 2.0, " ✓ PASS", " ✗ FAIL"]];
Print["  3. Mean rel err:   ", N[100*Mean[relErrorsX], 2], "%",
      If[Mean[relErrorsX] < 0.5, " ✓ PASS", " ✗ FAIL"]];
Print["  4. Success <1%:    ", N[100*Mean[good1pct], 1], "%",
      If[Mean[good1pct] > 0.3, " ✓ PASS", " ✗ FAIL"]];

Print[];

passCount = 0;
If[corrR > 0.7, passCount++];
If[Mean[errorsR] < 2.0, passCount++];
If[Mean[relErrorsX] < 0.5, passCount++];
If[Mean[good1pct] > 0.3, passCount++];

If[passCount >= 3,
  Print["✅ THEORY USEFUL (", passCount, "/4 criteria passed)"];
  Print["   Model has practical predictive power"],
  Print["❌ THEORY INSUFFICIENT (", passCount, "/4 criteria passed)"];
  Print["   Needs improvement or fundamental rethink"]
];

Print[];
Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
