#!/usr/bin/env wolframscript
(* SIMPLE FULL MODEL TEST *)

Print[StringRepeat["=", 80]];
Print["FULL MODEL TEST: baseline + dist + M"];
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

(* === TRAIN === *)
trainData = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    {n, Reg[n], DistToK2[n], M[n], Mod[n, 8]},
    Nothing
  ],
  {n, 3, 100}
];

trainData = Select[trainData, #[[2]] > 0 &];

Print["Training: ", Length[trainData], " odd n <= 100"];
Print[];

(* Baselines *)
baselines = Association[];
For[mod = 1, mod <= 7, mod += 2,
  subset = Select[trainData, #[[5]] == mod &];
  baselines[mod] = Mean[subset[[All, 2]]];
  Print["g(", mod, ") = ", N[baselines[mod], 4]];
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* === TEST === *)
testData = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]] && n > 100,
    {n, Reg[n], DistToK2[n], M[n], Mod[n, 8]},
    Nothing
  ],
  {n, 101, 200}
];

testData = Select[testData, #[[2]] > 0 &];

Print["Test: ", Length[testData], " odd n (100 < n <= 200)"];
Print[];

(* Three predictions *)
predBaseline = Table[baselines[testData[[i, 5]]], {i, Length[testData]}];

predWithDist = Table[
  baseline = baselines[testData[[i, 5]]];
  dist = testData[[i, 3]];
  baseline * (1 + 0.1 * dist),  (* simple heuristic *)
  {i, Length[testData]}
];

predWithDistM = Table[
  baseline = baselines[testData[[i, 5]]];
  dist = testData[[i, 3]];
  m = testData[[i, 4]];
  baseline * (1 + 0.1*dist - 0.05*m),  (* simple heuristic *)
  {i, Length[testData]}
];

RTrue = testData[[All, 2]];

corrBaseline = Correlation[N[RTrue], N[predBaseline]];
corrDist = Correlation[N[RTrue], N[predWithDist]];
corrFull = Correlation[N[RTrue], N[predWithDistM]];

Print["CORRELATIONS:"];
Print[StringRepeat["-", 60]];
Print["Baseline only:         r = ", N[corrBaseline, 4]];
Print["Baseline + dist:       r = ", N[corrDist, 4]];
Print["Baseline + dist + M:   r = ", N[corrFull, 4]];
Print[];

If[corrDist > corrBaseline,
  Print["dist adds predictive power! Improvement: +", 
        N[100*(corrDist - corrBaseline), 2], "%"]
];

If[corrFull > corrDist,
  Print["M adds further improvement! +", 
        N[100*(corrFull - corrDist), 2], "%"]
];

Print[];
Print[StringRepeat["=", 80]];
