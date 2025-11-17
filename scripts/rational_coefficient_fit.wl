#!/usr/bin/env wolframscript
(* RATIONAL COEFFICIENT FITTING: Search for algebraic structure in R(n) model *)

Print[StringRepeat["=", 80]];
Print["RATIONAL COEFFICIENT FITTING: Algebraic Structure Search"];
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
Print["Fitting: R = g(mod8) * (const + \[Alpha]\[CenterDot]dist - \[Beta]\[CenterDot]M)"];
Print[StringRepeat["-", 60]];
Print[];

(* Fit per mod class using NMinimize *)
coeffsNumerical = Association[];
coeffsRational = Association[];
tolerances = {10^-8, 10^-6, 10^-4, 10^-3};

For[mod = 1, mod <= 7, mod += 2,
  subset = Select[trainingData, #[[5]] == mod &];
  If[Length[subset] > 5,
    RVals = subset[[All, 2]];
    distVals = subset[[All, 3]];
    MVals = subset[[All, 4]];

    (* Normalize *)
    RNorm = RVals / baselines[mod];

    Print["mod ", mod, ":"];
    Print["  Finding optimal coefficients..."];

    (* NMinimize to find best fit *)
    result = NMinimize[
      Sum[(RNorm[[i]] - (c + a*distVals[[i]] - b*MVals[[i]]))^2, {i, Length[subset]}],
      {c, a, b}
    ];

    ssError = result[[1]];
    {cOpt, aOpt, bOpt} = {c, a, b} /. result[[2]];

    coeffsNumerical[mod] = {aOpt, bOpt, cOpt};

    (* Calculate R^2 *)
    yMean = Mean[RNorm];
    ssTot = Sum[(RNorm[[i]] - yMean)^2, {i, Length[subset]}];
    rSquared = 1 - ssError/ssTot;

    Print["  Numerical: \[Alpha]=", N[aOpt, 6], ", \[Beta]=", N[bOpt, 6], ", const=", N[cOpt, 6]];
    Print["  R\[TwoSuperior]=", N[rSquared, 4]];
    Print[];

    (* Try to rationalize with various tolerances *)
    Print["  Rationalizing..."];
    bestRational = Null;
    bestTolerance = Null;

    For[tol = 1, tol <= Length[tolerances], tol++,
      currentTol = tolerances[[tol]];
      {cRat, aRat, bRat} = Rationalize[{cOpt, aOpt, bOpt}, currentTol];

      (* Check if we got simple fractions *)
      If[Denominator[aRat] <= 100 && Denominator[bRat] <= 100,
        (* Test prediction quality with rationalized coefficients *)
        RNormPredRat = Table[cRat + aRat*distVals[[i]] - bRat*MVals[[i]], {i, Length[subset]}];
        ssErrorRat = Sum[(RNorm[[i]] - RNormPredRat[[i]])^2, {i, Length[subset]}];
        rSquaredRat = 1 - ssErrorRat/ssTot;

        (* If quality is still good (>90% of original R^2), accept *)
        If[rSquaredRat > 0.9 * rSquared && bestRational === Null,
          bestRational = {aRat, bRat, cRat};
          bestTolerance = currentTol;
          Print["    Tolerance ", currentTol, ": \[Alpha]=", aRat, ", \[Beta]=", bRat, ", const=", cRat];
          Print["    R\[TwoSuperior]=", N[rSquaredRat, 4], " (", N[100*rSquaredRat/rSquared, 1], "% of optimal)"];

          If[Denominator[aRat] < 20 || Denominator[bRat] < 20,
            Print["    \[RightArrow] SIMPLE FRACTIONS FOUND! \[LeftArrow]"];
          ];
        ];
      ];
    ];

    If[bestRational =!= Null,
      coeffsRational[mod] = bestRational,
      Print["    No good rational approximation found"];
      coeffsRational[mod] = coeffsNumerical[mod]
    ];

    Print[];
  ]
];

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

(* Predictions with RATIONAL coefficients *)
predictions = Table[
  Module[{n, Rtrue, dist, m, mod8, baseline, alpha, beta, const, Rpred,
          errorR, xTrue, xPred, errorX, relErrorX, good1pct, good01pct},

    {n, Rtrue, dist, m, mod8} = testData[[i]];

    If[KeyExistsQ[baselines, mod8] && KeyExistsQ[coeffsRational, mod8],
      baseline = baselines[mod8];
      {alpha, beta, const} = coeffsRational[mod8];

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

Print["PREDICTIONS vs ACTUAL (first 20, using RATIONAL coefficients):"];
Print[StringRepeat["-", 80]];
Print["n    mod8  R(act)   R(pred)  \[CapitalDelta]R      RelErr(x)   <1%?  <0.1%?"];
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
      If[g1 == 1, "\[CheckmarkedBox]    ", "\[Ballot]    "],
      If[g01 == 1, "\[CheckmarkedBox]", "\[Ballot]"]
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

Print["PREDICTION STATISTICS (RATIONAL COEFFICIENTS):"];
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

(* SUMMARY *)
Print["RATIONAL COEFFICIENT SUMMARY:"];
Print[StringRepeat["-", 60]];
Print[];

For[mod = 1, mod <= 7, mod += 2,
  If[KeyExistsQ[coeffsRational, mod],
    {alpha, beta, const} = coeffsRational[mod];
    Print["mod ", mod, ":"];
    Print["  \[Alpha] = ", alpha, " = ", N[alpha, 6]];
    Print["  \[Beta] = ", beta, " = ", N[beta, 6]];
    Print["  const = ", const, " = ", N[const, 6]];
    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print[];

(* FALSIFICATION *)
Print["FALSIFICATION TEST (with rational coefficients):"];
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
      If[corrR > 0.7, " \[CheckmarkedBox] PASS", " \[Ballot] FAIL"]];
Print["  2. MAE(R):         ", N[Mean[errorsR], 4],
      If[Mean[errorsR] < 2.0, " \[CheckmarkedBox] PASS", " \[Ballot] FAIL"]];
Print["  3. Mean rel err:   ", N[100*Mean[relErrorsX], 2], "%",
      If[Mean[relErrorsX] < 0.5, " \[CheckmarkedBox] PASS", " \[Ballot] FAIL"]];
Print["  4. Success <1%:    ", N[100*Mean[good1pct], 1], "%",
      If[Mean[good1pct] > 0.3, " \[CheckmarkedBox] PASS", " \[Ballot] FAIL"]];

Print[];

passCount = 0;
If[corrR > 0.7, passCount++];
If[Mean[errorsR] < 2.0, passCount++];
If[Mean[relErrorsX] < 0.5, passCount++];
If[Mean[good1pct] > 0.3, passCount++];

If[passCount >= 3,
  Print["\[LongDash]\[RightGuillemet] THEORY USEFUL (", passCount, "/4 criteria passed)"];
  Print["   Model has practical predictive power"],
  Print["\[Times] THEORY INSUFFICIENT (", passCount, "/4 criteria passed)"];
  Print["   Needs improvement or fundamental rethink"]
];

Print[];
Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
