#!/usr/bin/env wolframscript
(* R(p) PREDICTOR: Using CF period + mod 8 *)

Print[StringRepeat["=", 80]];
Print["R(p) PREDICTOR: Period-Based Model vs Distance-Based Model"];
Print[StringRepeat["=", 80]];
Print[];

(* Helper functions *)
PellSol[D_] := Module[{cf, convs, i},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];
  cf = ContinuedFraction[Sqrt[D], 500];
  convs = Convergents[cf];

  For[i = 1, i <= Length[convs], i++,
    Module[{x, y},
      x = Numerator[convs[[i]]];
      y = Denominator[convs[[i]]];
      If[x^2 - D*y^2 == 1, Return[{x, y}]];
    ]
  ];

  {0, 0}
]

Reg[D_] := Module[{sol, x, y},
  sol = PellSol[D];
  {x, y} = sol;
  If[x > 1, N[Log[x + y*Sqrt[D]], 15], 0.0]
]

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

DistToK2[n_] := Module[{k},
  k = Floor[Sqrt[n]];
  Min[n - k^2, (k+1)^2 - n]
]

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

Print["PHASE 1: TRAINING on primes p <= 500"];
Print[StringRepeat["-", 60]];
Print[];

(* Training data *)
trainingPrimes = Select[Range[3, 500], PrimeQ];
Print["Training primes: ", Length[trainingPrimes]];
Print[];

trainingData = Table[
  Module[{p, R, period, dist, m, mod8},
    p = prime;
    R = Reg[p];
    period = CFPeriod[p];
    dist = DistToK2[p];
    m = M[p];
    mod8 = Mod[p, 8];

    If[R > 0 && period > 0,
      {p, R, period, dist, m, mod8},
      Nothing
    ]
  ],
  {prime, trainingPrimes}
];

trainingData = DeleteCases[trainingData, Nothing];
Print["Training samples: ", Length[trainingData]];
Print[];

(* === MODEL 1: Period-based === *)
Print["MODEL 1: R = baseline(mod8) + β(mod8) × period"];
Print[StringRepeat["-", 60]];
Print[];

(* Fit by mod class *)
periodCoeffs = Association[];
periodBaselines = Association[];

For[m = 1, m <= 7, m += 2,
  subset = Select[trainingData, #[[6]] == m &];

  If[Length[subset] >= 5,
    RVals = subset[[All, 2]];
    periods = subset[[All, 3]];

    (* Linear fit: R = a + b*period *)
    data = Transpose[{N[periods], N[RVals]}];
    fit = LinearModelFit[data, {1, p}, p];

    periodBaselines[m] = fit["BestFitParameters"][[1]];
    periodCoeffs[m] = fit["BestFitParameters"][[2]];

    r2 = fit["RSquared"];

    Print["mod ", m, ": R = ", N[periodBaselines[m], 4], " + ",
          N[periodCoeffs[m], 4], " × period"];
    Print["       R² = ", N[r2, 4], " (n=", Length[subset], ")"];
  ]
];

Print[];

(* === MODEL 2: Distance-based (from failed ML) === *)
Print["MODEL 2: R = baseline(mod8) × (const + α×dist - β×M)"];
Print[StringRepeat["-", 60]];
Print[];

Print["Using rational coefficients from rational_coefficient_fit.wl:"];
Print[];

(* Coefficients from previous ML work *)
distBaselines = <|
  1 -> 12.0,  (* Approximate from previous fits *)
  3 -> 8.5,
  5 -> 11.0,
  7 -> 7.5
|>;

distCoeffs = <|
  1 -> {3/46, 25/38, 20/21},    (* {α, β, const} *)
  3 -> {9/67, 21/76, 82/113},
  5 -> {5/28, 33/82, 11/19},
  7 -> {3/22, 5/18, 13/19}
|>;

For[m = 1, m <= 7, m += 2,
  If[KeyExistsQ[distCoeffs, m],
    {alpha, beta, const} = distCoeffs[m];
    baseline = distBaselines[m];
    Print["mod ", m, ": R = ", N[baseline, 3], " × (",
          N[const, 3], " + ", N[alpha, 3], "×dist - ", N[beta, 3], "×M)"];
  ]
];

Print[];

(* === PHASE 2: TEST on primes 500 < p <= 2000 === *)
Print[StringRepeat["=", 80]];
Print["PHASE 2: TESTING on primes 500 < p <= 2000"];
Print[StringRepeat["-", 60]];
Print[];

testPrimes = Select[Range[501, 2000], PrimeQ];
Print["Test primes: ", Length[testPrimes]];
Print[];

testData = Table[
  Module[{p, R, period, dist, m, mod8},
    p = prime;
    R = Reg[p];
    period = CFPeriod[p];
    dist = DistToK2[p];
    m = M[p];
    mod8 = Mod[p, 8];

    If[R > 0 && period > 0,
      {p, R, period, dist, m, mod8},
      Nothing
    ]
  ],
  {prime, testPrimes}
];

testData = DeleteCases[testData, Nothing];
Print["Test samples: ", Length[testData]];
Print[];

(* Make predictions *)
predictions = Table[
  Module[{p, Rtrue, period, dist, m, mod8,
          RpredPeriod, RpredDist,
          errorPeriod, errorDist,
          xTrue, xPredPeriod, xPredDist,
          relErrorPeriod, relErrorDist},

    {p, Rtrue, period, dist, m, mod8} = testData[[i]];

    (* Period-based prediction *)
    If[KeyExistsQ[periodBaselines, mod8] && KeyExistsQ[periodCoeffs, mod8],
      RpredPeriod = periodBaselines[mod8] + periodCoeffs[mod8] * period,
      RpredPeriod = Rtrue  (* Fallback *)
    ];

    (* Distance-based prediction *)
    If[KeyExistsQ[distBaselines, mod8] && KeyExistsQ[distCoeffs, mod8],
      {alpha, beta, const} = distCoeffs[mod8];
      baseline = distBaselines[mod8];
      RpredDist = baseline * (const + alpha*dist - beta*m),
      RpredDist = Rtrue  (* Fallback *)
    ];

    (* Errors on R *)
    errorPeriod = Abs[Rtrue - RpredPeriod];
    errorDist = Abs[Rtrue - RpredDist];

    (* Relative errors on x *)
    xTrue = Cosh[Rtrue];
    xPredPeriod = Cosh[RpredPeriod];
    xPredDist = Cosh[RpredDist];

    relErrorPeriod = Abs[xTrue - xPredPeriod] / xTrue;
    relErrorDist = Abs[xTrue - xPredDist] / xTrue;

    {p, Rtrue, RpredPeriod, RpredDist,
     errorPeriod, errorDist,
     relErrorPeriod, relErrorDist,
     mod8}
  ],
  {i, Length[testData]}
];

Print["RESULTS: First 20 predictions"];
Print[StringRepeat["-", 80]];
Print["p     mod  R(true)  R(period) R(dist)   Err(per) Err(dis)  RelErr%(per) RelErr%(dis)"];
Print[StringRepeat["-", 80]];

Do[
  Module[{p, Rt, Rp, Rd, ep, ed, relp, reld, m},
    {p, Rt, Rp, Rd, ep, ed, relp, reld, m} = predictions[[i]];

    Print[
      StringPadRight[ToString[p], 6],
      StringPadRight[ToString[m], 5],
      StringPadRight[ToString[N[Rt, 4]], 9],
      StringPadRight[ToString[N[Rp, 4]], 10],
      StringPadRight[ToString[N[Rd, 4]], 10],
      StringPadRight[ToString[N[ep, 3]], 9],
      StringPadRight[ToString[N[ed, 3]], 10],
      StringPadRight[ToString[N[100*relp, 2]], 13],
      N[100*reld, 2]
    ];
  ],
  {i, Min[20, Length[predictions]]}
];

Print[];

(* === COMPARISON === *)
Print[StringRepeat["=", 80]];
Print["MODEL COMPARISON"];
Print[StringRepeat["-", 60]];
Print[];

RTrue = predictions[[All, 2]];
RPredPeriod = predictions[[All, 3]];
RPredDist = predictions[[All, 4]];

errorsPeriod = predictions[[All, 5]];
errorsDist = predictions[[All, 6]];

relErrorsPeriod = predictions[[All, 7]];
relErrorsDist = predictions[[All, 8]];

(* Correlations *)
corrPeriod = Correlation[N[RTrue], N[RPredPeriod]];
corrDist = Correlation[N[RTrue], N[RPredDist]];

Print["PERIOD-BASED MODEL:"];
Print["  Correlation R(pred) ↔ R(true): ", N[corrPeriod, 4]];
Print["  MAE(R):                        ", N[Mean[errorsPeriod], 4]];
Print["  Median error(R):               ", N[Median[errorsPeriod], 4]];
Print["  Mean relative error(x):        ", N[100*Mean[relErrorsPeriod], 2], "%"];
Print["  Median relative error(x):      ", N[100*Median[relErrorsPeriod], 2], "%"];
Print[];

Print["DISTANCE-BASED MODEL:"];
Print["  Correlation R(pred) ↔ R(true): ", N[corrDist, 4]];
Print["  MAE(R):                        ", N[Mean[errorsDist], 4]];
Print["  Median error(R):               ", N[Median[errorsDist], 4]];
Print["  Mean relative error(x):        ", N[100*Mean[relErrorsDist], 1], "%"];
Print["  Median relative error(x):      ", N[100*Median[relErrorsDist], 1], "%"];
Print[];

Print["IMPROVEMENT (Period vs Distance):"];
Print["  Correlation:      ", If[corrPeriod > corrDist, "✓", "✗"],
      " (", N[100*(corrPeriod - corrDist)/corrDist, 1], "% better)"];
Print["  MAE(R):           ", If[Mean[errorsPeriod] < Mean[errorsDist], "✓", "✗"],
      " (", N[100*(Mean[errorsDist] - Mean[errorsPeriod])/Mean[errorsDist], 1], "% better)"];
Print["  Rel error(x):     ", If[Mean[relErrorsPeriod] < Mean[relErrorsDist], "✓", "✗"],
      " (", N[100*(Mean[relErrorsDist] - Mean[relErrorsPeriod])/Mean[relErrorsDist], 1], "% better)"];
Print[];

Print[StringRepeat["=", 80]];
Print["CONCLUSION"];
Print[StringRepeat["-", 60]];
Print[];

If[corrPeriod > 0.95 && corrPeriod > corrDist,
  Print["✓ PERIOD-BASED MODEL is SUPERIOR!"];
  Print["  - Correlation > 0.95"];
  Print["  - Beats distance-based model"];
  Print["  - Ready for production use"];
  ,
  Print["⚠ Model needs improvement"];
  Print["  - Correlation: ", N[corrPeriod, 4]];
  Print["  - Distance model may be competitive"];
];

Print[];
Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
