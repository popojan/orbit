#!/usr/bin/env wolframscript
(* SIMPLE PREDICTION TEST: Can baseline alone predict R(n)? *)

Print[StringRepeat["=", 80]];
Print["SIMPLE PREDICTION: R from baseline g(n mod 8) only"];
Print[StringRepeat["=", 80]];
Print[];

(* Helpers *)
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

(* === TRAIN ON n <= 100 === *)
Print["PHASE 1: Learn baselines from n <= 100"];
Print[];

trainData = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    R = Reg[n];
    If[R > 0, {n, R, Mod[n, 8]}, Nothing],
    Nothing
  ],
  {n, 3, 100}
];

trainData = DeleteCases[trainData, Nothing];
Print["Training: ", Length[trainData], " odd n"];
Print[];

(* Compute baselines *)
baselines = Association[];
For[mod = 1, mod <= 7, mod += 2,
  subset = Select[trainData, #[[3]] == mod &];
  If[Length[subset] > 0,
    baselines[mod] = Mean[subset[[All, 2]]];
    Print["g(", mod, ") = ", N[baselines[mod], 5], " (n=", Length[subset], ")"];
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* === TEST ON 100 < n <= 200 === *)
Print["PHASE 2: Predict unseen n (100 < n <= 200)"];
Print[];

testData = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]] && n > 100,
    R = Reg[n];
    If[R > 0, {n, R, Mod[n, 8]}, Nothing],
    Nothing
  ],
  {n, 101, 200}
];

testData = DeleteCases[testData, Nothing];
Print["Test: ", Length[testData], " odd n"];
Print[];

(* Predict using ONLY baseline *)
predictions = Table[
  {n, Rtrue, mod8} = testData[[i]];

  If[KeyExistsQ[baselines, mod8],
    Rpred = baselines[mod8];
    error = Abs[Rtrue - Rpred];
    relError = error / Rtrue;
    {n, Rtrue, Rpred, error, relError, mod8},
    Nothing
  ],
  {i, Length[testData]}
];

predictions = DeleteCases[predictions, Nothing];

Print["PREDICTIONS (baseline only):"];
Print[StringRepeat["-", 70]];
Print["n    mod8  R(true)   R(pred)   Error    Rel.Err"];
Print[StringRepeat["-", 70]];

Do[
  {n, Rtrue, Rpred, err, relErr, mod8} = predictions[[i]];
  Print[
    StringPadRight[ToString[n], 5],
    StringPadRight[ToString[mod8], 6],
    StringPadRight[ToString[N[Rtrue, 5]], 10],
    StringPadRight[ToString[N[Rpred, 5]], 10],
    StringPadRight[ToString[N[err, 4]], 9],
    N[100*relErr, 2], "%"
  ];
  ,
  {i, Min[30, Length[predictions]]}
];

Print[];

(* Statistics *)
errors = predictions[[All, 4]];
relErrors = predictions[[All, 5]];

Print["STATISTICS:"];
Print[StringRepeat["-", 60]];
Print["Mean absolute error:  ", N[Mean[errors], 4]];
Print["Mean relative error:  ", N[100*Mean[relErrors], 2], "%"];
Print["Median relative error:", N[100*Median[relErrors], 2], "%"];
Print[];

(* Correlation *)
RTrue = predictions[[All, 2]];
RPred = predictions[[All, 3]];
corr = Correlation[N[RTrue], N[RPred]];

Print["Correlation R(pred) <-> R(true): ", N[corr, 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* === VERDICT === *)
Print["FALSIFICATION TEST:"];
Print[StringRepeat["-", 60]];
Print[];

Print["Baseline-only prediction (no dist, no M):"];
Print["  Correlation:  ", N[corr, 4],
      If[corr > 0.4, " ✓ Some predictive power", " ✗ Weak"]];
Print["  Rel. error:   ", N[100*Mean[relErrors], 2], "%",
      If[Mean[relErrors] < 0.5, " ✓ Reasonable", " ✗ Poor"]];

Print[];

If[corr > 0.4,
  Print["✓ Baseline ALONE has predictive power!"];
  Print["  Mod 8 classification is meaningful."];
  Print["  Adding dist + M should improve further."],
  Print["✗ Baseline alone insufficient"];
  Print["  Need dist + M to predict R(n)")
];

Print[];
Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
