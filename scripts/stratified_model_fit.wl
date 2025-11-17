#!/usr/bin/env wolframscript
(* STRATIFIED MODEL: g(mod8, isPrime) × (const + α·dist - β·M) *)

Print[StringRepeat["=", 80]];
Print["STRATIFIED MODEL WITH PRIME/COMPOSITE SPLIT"];
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
Print["PHASE 1: BUILD STRATIFIED MODEL FROM n <= 100"];
Print[StringRepeat["-", 60]];
Print[];

trainingData = Flatten[Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{R, dist, m, mod8, isPrime},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      mod8 = Mod[n, 8];
      isPrime = PrimeQ[n];
      If[R > 0, {{n, R, dist, m, mod8, isPrime}}, {}]
    ],
    {}
  ],
  {n, 3, 100}
], 1];

Print["Training set: ", Length[trainingData], " odd n <= 100"];
Print[];

(* Baselines by (mod 8, isPrime) *)
baselines = Association[];

For[mod = 1, mod <= 7, mod += 2,
  For[isPrime = 0, isPrime <= 1, isPrime++,
    key = {mod, isPrime == 1};
    subset = Select[trainingData, #[[5]] == mod && #[[6]] == (isPrime == 1) &];

    If[Length[subset] >= 3,
      baselines[key] = Mean[subset[[All, 2]]];
      Print["g(", mod, ", ", If[isPrime == 1, "prime", "comp"], ") = ",
            N[baselines[key], 4], " (n=", Length[subset], ")"];
    ]
  ]
];

Print[];
Print["Testing three model variants:");
Print["  (1) R = g * (1 + α·dist - β·M)       [const=1 fixed]"];
Print["  (2) R = g + α·dist - β·M              [additive]"];
Print["  (3) R = g * (const + α·dist - β·M)   [full model]"];
Print[StringRepeat["-", 60]];
Print[];

(* Store coefficients for best model *)
coeffsRational = Association[];
modelType = Association[];  (* Track which model variant works best *)

For[mod = 1, mod <= 7, mod += 2,
  For[isPrime = 0, isPrime <= 1, isPrime++,
    key = {mod, isPrime == 1};
    subset = Select[trainingData, #[[5]] == mod && #[[6]] == (isPrime == 1) &];

    If[Length[subset] >= 3,
      RVals = subset[[All, 2]];
      distVals = subset[[All, 3]];
      MVals = subset[[All, 4]];

      If[KeyExistsQ[baselines, key],
        baseline = baselines[key];

        (* Try 3 model variants *)
        bestR2 = -1;
        bestModel = 1;
        bestCoeffs = {0, 0, 1};

        (* Model 1: R = g * (1 + α·dist - β·M) *)
        result1 = NMinimize[
          Sum[(RVals[[i]] - baseline * (1 + a*distVals[[i]] - b*MVals[[i]]))^2,
              {i, Length[subset]}],
          {a, b}
        ];
        yMean1 = Mean[RVals];
        ssTot1 = Sum[(RVals[[i]] - yMean1)^2, {i, Length[subset]}];
        r2_1 = 1 - result1[[1]]/ssTot1;
        {a1, b1} = {a, b} /. result1[[2]];
        If[r2_1 > bestR2, bestR2 = r2_1; bestModel = 1; bestCoeffs = {a1, b1, 1}];

        (* Model 2: R = g + α·dist - β·M *)
        result2 = NMinimize[
          Sum[(RVals[[i]] - (baseline + a*distVals[[i]] - b*MVals[[i]]))^2,
              {i, Length[subset]}],
          {a, b}
        ];
        r2_2 = 1 - result2[[1]]/ssTot1;
        {a2, b2} = {a, b} /. result2[[2]];
        If[r2_2 > bestR2, bestR2 = r2_2; bestModel = 2; bestCoeffs = {a2, b2, 0}];

        (* Model 3: R = g * (const + α·dist - β·M) *)
        RNorm = RVals / baseline;
        result3 = NMinimize[
          Sum[(RNorm[[i]] - (c + a*distVals[[i]] - b*MVals[[i]]))^2,
              {i, Length[subset]}],
          {c, a, b}
        ];
        yMean3 = Mean[RNorm];
        ssTot3 = Sum[(RNorm[[i]] - yMean3)^2, {i, Length[subset]}];
        r2_3 = 1 - result3[[1]]/ssTot3;
        {a3, b3, c3} = {a, b, c} /. result3[[2]];
        If[r2_3 > bestR2, bestR2 = r2_3; bestModel = 3; bestCoeffs = {a3, b3, c3}];

        (* Rationalize best coefficients *)
        coeffsRat = Rationalize[bestCoeffs, 10^-3];
        If[Denominator[coeffsRat[[1]]] <= 100 && Denominator[coeffsRat[[2]]] <= 100,
          coeffsRational[key] = coeffsRat,
          coeffsRational[key] = bestCoeffs
        ];
        modelType[key] = bestModel;

        Print["mod ", mod, " (", If[isPrime == 1, "prime", "comp"], "): ",
              "Model ", bestModel, ", α=", ToString[coeffsRational[key][[1]]],
              ", β=", ToString[coeffsRational[key][[2]]],
              ", R²=", N[bestR2, 3]];
      ]
    ]
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* === PHASE 2: TEST === *)
Print["PHASE 2: PREDICT UNSEEN n (100 < n <= 400)"];
Print[StringRepeat["-", 60]];
Print[];

testData = Flatten[Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]] && n > 100,
    Module[{R, dist, m, mod8, isPrime},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      mod8 = Mod[n, 8];
      isPrime = PrimeQ[n];
      If[R > 0, {{n, R, dist, m, mod8, isPrime}}, {}]
    ],
    {}
  ],
  {n, 101, 400}
], 1];

Print["Test set: ", Length[testData], " odd n (100 < n <= 400)"];
Print[];

(* Make predictions *)
predictions = Table[
  Module[{n, Rtrue, dist, m, mod8, isPrime, key, baseline, alpha, beta, const,
          Rpred, errorR, xTrue, xPred, errorX, relErrorX, good1pct, good01pct, mType},

    {n, Rtrue, dist, m, mod8, isPrime} = testData[[i]];
    key = {mod8, isPrime};

    If[KeyExistsQ[baselines, key] && KeyExistsQ[coeffsRational, key] && KeyExistsQ[modelType, key],
      baseline = baselines[key];
      {alpha, beta, const} = coeffsRational[key];
      mType = modelType[key];

      (* Predict R based on model type *)
      Rpred = Which[
        mType == 1, baseline * (1 + alpha*dist - beta*m),
        mType == 2, baseline + alpha*dist - beta*m,
        mType == 3, baseline * (const + alpha*dist - beta*m),
        True, baseline
      ];

      (* Errors *)
      errorR = Abs[Rtrue - Rpred];
      xTrue = Cosh[Rtrue];
      xPred = Cosh[Rpred];
      errorX = Abs[xTrue - xPred];
      relErrorX = errorX / xTrue;

      (* Success criteria *)
      good1pct = If[relErrorX < 0.01, 1, 0];
      good01pct = If[relErrorX < 0.001, 1, 0];

      {n, Rtrue, Rpred, errorR, relErrorX, good1pct, good01pct, mod8, isPrime},

      Nothing
    ]
  ],
  {i, Length[testData]}
];

predictions = DeleteCases[predictions, Nothing];

Print["PREDICTIONS vs ACTUAL (first 20):"];
Print[StringRepeat["-", 80]];
Print["n    Type   mod  R(act)   R(pred)  ΔR      RelErr%   <1%?  <0.1%?"];
Print[StringRepeat["-", 80]];

Do[
  Module[{n, Rtrue, Rpred, errR, relErr, g1, g01, mod8, isPrime, typeStr},
    {n, Rtrue, Rpred, errR, relErr, g1, g01, mod8, isPrime} = predictions[[i]];
    typeStr = If[isPrime, "P", "C"];

    Print[
      StringPadRight[ToString[n], 5],
      StringPadRight[typeStr, 7],
      StringPadRight[ToString[mod8], 5],
      StringPadRight[ToString[N[Rtrue, 4]], 9],
      StringPadRight[ToString[N[Rpred, 4]], 9],
      StringPadRight[ToString[N[errR, 3]], 8],
      StringPadRight[ToString[N[100*relErr, 2]], 10],
      If[g1 == 1, "✓    ", "✗    "],
      If[g01 == 1, "✓", "✗"]
    ];
  ],
  {i, Min[20, Length[predictions]]}
];

Print[];

(* Statistics *)
errorsR = predictions[[All, 4]];
relErrorsX = predictions[[All, 5]];
good1pct = predictions[[All, 6]];
good01pct = predictions[[All, 7]];

Print["PREDICTION STATISTICS (STRATIFIED MODEL):"];
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
Print["FALSIFICATION TEST (stratified model):"];
Print[StringRepeat["-", 60]];
Print[];

Print["Criteria:"];
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
  Print["✓ THEORY USEFUL (", passCount, "/4 criteria passed)"];
  Print["   Model has practical predictive power"],
  Print["✗ THEORY INSUFFICIENT (", passCount, "/4 criteria passed)"];
  Print["   Needs improvement or fundamental rethink"]
];

Print[];
Print[StringRepeat["=", 80]];

(* COMPARISON WITH UNSTRATIFIED *)
Print[];
Print["COMPARISON: Stratified vs Unstratified Model"];
Print[StringRepeat["-", 60]];
Print[];
Print["This stratified model split training data by (mod8, isPrime),"];
Print["creating 8 baseline functions instead of 4."];
Print[];
Print["Expected improvement: ~50% reduction in error for outliers"];
Print[];

Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
