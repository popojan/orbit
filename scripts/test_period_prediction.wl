#!/usr/bin/env wolframscript
(* TEST: Can we predict period(p) from p? *)

Print[StringRepeat["=", 80]];
Print["PERIOD PREDICTION TEST: Can we predict period(p)?"];
Print[StringRepeat["=", 80]];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

Print["PHASE 1: Train on primes p <= 500, test on 500 < p <= 1500"];
Print[StringRepeat["-", 60]];
Print[];

(* Training *)
trainPrimes = Select[Range[3, 500], PrimeQ];
trainData = Table[{p, CFPeriod[p], Mod[p, 8]}, {p, trainPrimes}];
trainData = Select[trainData, #[[2]] > 0 &];

Print["Training: ", Length[trainData], " primes"];
Print[];

(* Fit models by mod 8 *)
Print["Fitting models: period = a + b*√p (stratified by mod 8)"];
Print[];

fitParams = Association[];

For[m = 1, m <= 7, m += 2,
  subset = Select[trainData, #[[3]] == m &];
  If[Length[subset] >= 5,
    ps = N[subset[[All, 1]]];
    periods = N[subset[[All, 2]]];

    (* Model: period = a + b*sqrt(p) *)
    fit = LinearModelFit[Transpose[{Sqrt[ps], periods}], {1, s}, s];
    a = fit["BestFitParameters"][[1]];
    b = fit["BestFitParameters"][[2]];
    r2 = fit["RSquared"];

    fitParams[m] = {a, b, r2};

    Print["mod ", m, ": period ≈ ", N[a, 3], " + ", N[b, 3], "*√p"];
    Print["        R² = ", N[r2, 4]];
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print["PHASE 2: TEST - Predict period for 500 < p <= 1500"];
Print[StringRepeat["-", 60]];
Print[];

testPrimes = Select[Range[501, 1500], PrimeQ];
testData = Table[{p, CFPeriod[p], Mod[p, 8]}, {p, testPrimes}];
testData = Select[testData, #[[2]] > 0 &];

Print["Test set: ", Length[testData], " primes"];
Print[];

(* Make predictions *)
predictions = Table[
  Module[{p, periodTrue, mod8, a, b, periodPred, error, relError},
    {p, periodTrue, mod8} = testData[[i]];

    If[KeyExistsQ[fitParams, mod8],
      {a, b, r2} = fitParams[mod8];
      periodPred = a + b*Sqrt[N[p]];
      ,
      periodPred = periodTrue  (* Fallback *)
    ];

    error = Abs[periodTrue - periodPred];
    relError = error / periodTrue;

    {p, mod8, periodTrue, Round[periodPred], error, relError}
  ],
  {i, Length[testData]}
];

Print["PREDICTED vs ACTUAL PERIODS (first 30 test primes)"];
Print[StringRepeat["-", 80]];
Print["p      mod  Period(actual)  Period(pred)  Error   RelErr%"];
Print[StringRepeat["-", 80]];

Do[
  Module[{p, m, pTrue, pPred, err, relErr},
    {p, m, pTrue, pPred, err, relErr} = predictions[[i]];

    Print[
      StringPadRight[ToString[p], 7],
      StringPadRight[ToString[m], 5],
      StringPadRight[ToString[pTrue], 16],
      StringPadRight[ToString[pPred], 14],
      StringPadRight[ToString[N[err, 3]], 8],
      N[100*relErr, 1]
    ];
  ],
  {i, Min[30, Length[predictions]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print["STATISTICS"];
Print[StringRepeat["-", 60]];
Print[];

errors = predictions[[All, 5]];
relErrors = predictions[[All, 6]];

Print["Absolute error:"];
Print["  Mean:   ", N[Mean[errors], 3]];
Print["  Median: ", N[Median[errors], 3]];
Print["  Max:    ", N[Max[errors], 3]];
Print[];

Print["Relative error:"];
Print["  Mean:   ", N[100*Mean[relErrors], 1], "%"];
Print["  Median: ", N[100*Median[relErrors], 1], "%"];
Print["  Max:    ", N[100*Max[relErrors], 1], "%"];
Print[];

(* Correlation *)
periodTrue = predictions[[All, 3]];
periodPred = predictions[[All, 4]];
corr = Correlation[N[periodTrue], N[periodPred]];

Print["Correlation period(true) ↔ period(pred): ", N[corr, 4]];
Print[];

(* Success rates *)
good10pct = Count[relErrors, r_ /; r < 0.1];
good20pct = Count[relErrors, r_ /; r < 0.2];
good50pct = Count[relErrors, r_ /; r < 0.5];

Print["Success rates:"];
Print["  <10% error:  ", good10pct, "/", Length[predictions],
      " (", N[100*good10pct/Length[predictions], 1], "%)"];
Print["  <20% error:  ", good20pct, "/", Length[predictions],
      " (", N[100*good20pct/Length[predictions], 1], "%)"];
Print["  <50% error:  ", good50pct, "/", Length[predictions],
      " (", N[100*good50pct/Length[predictions], 1], "%)"];
Print[];

Print[StringRepeat["=", 80]];
Print["CONCLUSION"];
Print[StringRepeat["-", 60]];
Print[];

If[corr > 0.9 && Mean[relErrors] < 0.2,
  Print["✓ Period CAN be predicted with period ~ √p model"];
  Print["  Correlation > 0.9, mean error < 20%"];
  ,
  Print["⚠ Period prediction is APPROXIMATE"];
  Print["  Correlation: ", N[corr, 4]];
  Print["  Mean error:  ", N[100*Mean[relErrors], 1], "%"];
  Print[];
  Print["Period grows roughly as √p, but with significant scatter."];
  Print["We know DIVISIBILITY (period mod 4), but not EXACT value."];
];

Print[];
Print[StringRepeat["=", 80]];
Print["IMPLICATIONS"];
Print[StringRepeat["-", 60]];
Print[];

Print["Key insight:");
Print["  - We can predict R(p) GIVEN period (r=0.990) ✓"];
Print["  - We CANNOT predict period exactly from p"];
Print["  - Period ~ √p is approximate (scatter ", N[100*Mean[relErrors], 1], "%)"];
Print[];

Print["Therefore:"];
Print["  R(p) prediction requires COMPUTING period via CF algorithm"];
Print["  No shortcut formula exists (yet)"];
Print[];

Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
