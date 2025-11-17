#!/usr/bin/env wolframscript
(* ERROR ANALYSIS: Where does the model fail? *)

Print[StringRepeat["=", 80]];
Print["ERROR ANALYSIS: Prediction Failure Patterns"];
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

(* Class number approximation via Dirichlet *)
ClassNumber[n_] := Module[{L1},
  If[IntegerQ[Sqrt[n]], Return[0]];
  L1 = N[Sum[KroneckerSymbol[n, k]/k, {k, 1, 1000}], 10];
  Round[Abs[L1 * Sqrt[n] / Log[Reg[n] + 10^-10]]]
]

(* Check if sum of two squares *)
IsSumOfSquares[n_] := Module[{factors},
  factors = FactorInteger[n];
  AllTrue[factors, #[[1]] == 2 || Mod[#[[1]], 4] == 1 || EvenQ[#[[2]]] &]
]

(* CF period length (expensive, so cached) *)
CFPeriod[n_] := Module[{cf},
  If[IntegerQ[Sqrt[n]], Return[0]];
  cf = ContinuedFraction[Sqrt[n], 1000];
  Length[cf[[2]]]
]

(* === BUILD MODEL === *)
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

baselines = Association[];
For[mod = 1, mod <= 7, mod += 2,
  subset = Select[trainingData, #[[5]] == mod &];
  If[Length[subset] > 0, baselines[mod] = Mean[subset[[All, 2]]]];
];

(* Use rational coefficients from previous fit *)
coeffsRational = Association[
  1 -> {3/46, 25/38, 20/21},
  3 -> {9/67, 21/76, 82/113},
  5 -> {5/28, 33/82, 11/19},
  7 -> {3/22, 5/18, 13/19}
];

Print["Using rational coefficients from previous fit"];
Print[];

(* === TEST SET === *)
Print["PHASE 2: TEST SET n (100 < n <= 400)"];
Print[StringRepeat["-", 60]];
Print[];

Print["Computing test data (this may take a minute for CF periods)..."];
testData = Flatten[Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]] && n > 100,
    Module[{R, dist, m, mod8, h, isPrime, isSemiprime, sumOfSq, cfPeriod},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      mod8 = Mod[n, 8];
      h = ClassNumber[n];
      isPrime = PrimeQ[n];

      (* Semiprime check *)
      isSemiprime = If[!isPrime && Length[FactorInteger[n]] <= 2 &&
                       Total[FactorInteger[n][[All, 2]]] == 2, True, False];

      sumOfSq = IsSumOfSquares[n];
      cfPeriod = CFPeriod[n];

      If[Mod[n, 50] == 1, Print["  n = ", n, "..."]];

      If[R > 0, {{n, R, dist, m, mod8, h, isPrime, isSemiprime, sumOfSq, cfPeriod}}, {}]
    ],
    {}
  ],
  {n, 101, 400}
], 1];

Print["Test set: ", Length[testData], " odd n"];
Print[];

(* === PREDICTIONS === *)
predictions = Table[
  Module[{n, Rtrue, dist, m, mod8, h, isPrime, isSemi, sumSq, period,
          baseline, alpha, beta, const, Rpred, errorR, xTrue, xPred,
          errorX, relErrorX},

    {n, Rtrue, dist, m, mod8, h, isPrime, isSemi, sumSq, period} = testData[[i]];

    If[KeyExistsQ[baselines, mod8] && KeyExistsQ[coeffsRational, mod8],
      baseline = baselines[mod8];
      {alpha, beta, const} = coeffsRational[mod8];

      Rpred = baseline * (const + alpha*dist - beta*m);

      errorR = Abs[Rtrue - Rpred];
      xTrue = Cosh[Rtrue];
      xPred = Cosh[Rpred];
      errorX = Abs[xTrue - xPred];
      relErrorX = errorX / xTrue;

      {n, Rtrue, Rpred, errorR, relErrorX, mod8, dist, m, h,
       isPrime, isSemi, sumSq, period, FactorInteger[n]},

      Nothing
    ]
  ],
  {i, Length[testData]}
];

predictions = DeleteCases[predictions, Nothing];

Print[StringRepeat["=", 80]];
Print[];

(* === ERROR ANALYSIS === *)
Print["ERROR ANALYSIS: TOP 20 OUTLIERS (by relative error on x)"];
Print[StringRepeat["-", 60]];
Print[];

(* Sort by relative error *)
sortedPredictions = Reverse[SortBy[predictions, #[[5]] &]];
topOutliers = Take[sortedPredictions, Min[20, Length[sortedPredictions]]];

Print[StringForm["``  ``  ``  ``  ``  ``  ``  ``  ``  ``",
  StringPadRight["n", 5],
  StringPadRight["mod", 4],
  StringPadRight["R(act)", 8],
  StringPadRight["R(prd)", 8],
  StringPadRight["RelErr%", 8],
  StringPadRight["dist", 5],
  StringPadRight["M", 3],
  StringPadRight["h", 3],
  StringPadRight["Type", 10],
  "Factorization"
]];
Print[StringRepeat["-", 100]];

Do[
  Module[{n, Rtrue, Rpred, errR, relErr, mod8, dist, m, h,
          isPrime, isSemi, sumSq, period, factors, typeStr},

    {n, Rtrue, Rpred, errR, relErr, mod8, dist, m, h,
     isPrime, isSemi, sumSq, period, factors} = topOutliers[[i]];

    typeStr = Which[
      isPrime, "PRIME",
      isSemi, "SEMIPRIME",
      Length[factors] == 1, "PRIME^k",
      True, "COMPOSITE"
    ];

    If[sumSq, typeStr = typeStr <> "*"];

    Print[StringForm["``  ``  ``  ``  ``  ``  ``  ``  ``  ``",
      StringPadRight[ToString[n], 5],
      StringPadRight[ToString[mod8], 4],
      StringPadRight[ToString[N[Rtrue, 3]], 8],
      StringPadRight[ToString[N[Rpred, 3]], 8],
      StringPadRight[ToString[Round[100*relErr]], 8],
      StringPadRight[ToString[dist], 5],
      StringPadRight[ToString[m], 3],
      StringPadRight[ToString[h], 3],
      StringPadRight[typeStr, 10],
      ToString[factors]
    ]];
  ],
  {i, Length[topOutliers]}
];

Print[];
Print["* = sum of two squares"];
Print[];

(* === STATISTICS === *)
Print[StringRepeat["=", 80]];
Print[];
Print["ERROR STATISTICS BY CATEGORY"];
Print[StringRepeat["-", 60]];
Print[];

(* By mod 8 *)
Print["By mod 8:"];
For[mod = 1, mod <= 7, mod += 2,
  subset = Select[predictions, #[[6]] == mod &];
  If[Length[subset] > 0,
    meanErr = Mean[subset[[All, 5]]];
    medianErr = Median[subset[[All, 5]]];
    Print["  mod ", mod, ": mean=", N[100*meanErr, 3], "%, median=",
          N[100*medianErr, 3], "% (n=", Length[subset], ")"];
  ]
];
Print[];

(* By prime/composite *)
primeSet = Select[predictions, #[[10]] &];
compositeSet = Select[predictions, !#[[10]] &];

Print["By type:"];
Print["  Primes:     mean=", N[100*Mean[primeSet[[All, 5]]], 3], "% (n=",
      Length[primeSet], ")"];
Print["  Composites: mean=", N[100*Mean[compositeSet[[All, 5]]], 3], "% (n=",
      Length[compositeSet], ")"];
Print[];

(* By sum of squares *)
sumSqYes = Select[predictions, #[[12]] &];
sumSqNo = Select[predictions, !#[[12]] &];

Print["By sum of two squares:"];
Print["  YES: mean=", N[100*Mean[sumSqYes[[All, 5]]], 3], "% (n=",
      Length[sumSqYes], ")"];
Print["  NO:  mean=", N[100*Mean[sumSqNo[[All, 5]]], 3], "% (n=",
      Length[sumSqNo], ")"];
Print[];

(* === CORRELATIONS === *)
Print[StringRepeat["=", 80]];
Print[];
Print["CORRELATION: Relative Error vs Features"];
Print[StringRepeat["-", 60]];
Print[];

relErrors = predictions[[All, 5]];
distVals = predictions[[All, 7]];
mVals = predictions[[All, 8]];
hVals = predictions[[All, 9]];
periodVals = predictions[[All, 13]];

Print["Correlations with relative error:"];
Print["  dist to k^2:  ", N[Correlation[N[relErrors], N[distVals]], 4]];
Print["  M(n):         ", N[Correlation[N[relErrors], N[mVals]], 4]];
Print["  h(n):         ", N[Correlation[N[relErrors], N[hVals]], 4]];
Print["  CF period:    ", N[Correlation[N[relErrors], N[periodVals]], 4]];
Print[];

(* === MISSING FACTOR SEARCH === *)
Print[StringRepeat["=", 80]];
Print[];
Print["SEARCH FOR MISSING FACTORS"];
Print[StringRepeat["-", 60]];
Print[];

Print["Testing if adding factors improves correlation.."];
Print[];

(* Current model: R ~ g(mod8) * (const + a*dist - b*M) *)
(* Test: R ~ g(mod8) * (const + a*dist - b*M + c*h) *)

For[mod = 1, mod <= 7, mod += 2,
  subset = Select[predictions, #[[6]] == mod &];
  If[Length[subset] > 5,
    RTrue = subset[[All, 2]];
    RPred = subset[[All, 3]];
    distSub = subset[[All, 7]];
    mSub = subset[[All, 8]];
    hSub = subset[[All, 9]];
    periodSub = subset[[All, 13]];

    (* Current correlation *)
    corrCurrent = Correlation[N[RTrue], N[RPred]];

    Print["mod ", mod, " (n=", Length[subset], "):"];
    Print["  Current R^2:  ", N[corrCurrent^2, 3]];

    (* Try adding h *)
    result = NMinimize[
      Sum[(RTrue[[i]] - (c + a*distSub[[i]] - b*mSub[[i]] + d*hSub[[i]]))^2,
          {i, Length[subset]}],
      {c, a, b, d}
    ];
    RNormPredH = Table[
      c + a*distSub[[i]] - b*mSub[[i]] + d*hSub[[i]] /. result[[2]],
      {i, Length[subset]}
    ];
    corrWithH = Correlation[N[RTrue], N[RNormPredH]];

    Print["  With h(n):    ", N[corrWithH^2, 3],
          If[corrWithH^2 > corrCurrent^2, " (+)", " (-)"]];

    (* Try adding period *)
    result2 = NMinimize[
      Sum[(RTrue[[i]] - (c + a*distSub[[i]] - b*mSub[[i]] + e*periodSub[[i]]))^2,
          {i, Length[subset]}],
      {c, a, b, e}
    ];
    RNormPredP = Table[
      c + a*distSub[[i]] - b*mSub[[i]] + e*periodSub[[i]] /. result2[[2]],
      {i, Length[subset]}
    ];
    corrWithPeriod = Correlation[N[RTrue], N[RNormPredP]];

    Print["  With period:  ", N[corrWithPeriod^2, 3],
          If[corrWithPeriod^2 > corrCurrent^2, " (+)", " (-)"]];
    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["ANALYSIS COMPLETE"];
