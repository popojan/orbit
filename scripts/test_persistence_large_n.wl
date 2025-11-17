#!/usr/bin/env wolframscript
(* PERSISTENCE TEST: Does model work for n > 200? *)

Print[StringRepeat["=", 80]];
Print["PERSISTENCE TEST: n in (200, 400]"];
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

ClassNumber[n_] := Module[{factors},
  factors = FactorInteger[n];
  If[Max[factors[[All, 2]]] > 1, Return[Missing["NotSquareFree"]]];
  NumberFieldClassNumber[Sqrt[n]]
]

(* Baselines from n <= 100 *)
baselines = <|1 -> 9.4246, 3 -> 5.768, 5 -> 9.3603, 7 -> 4.7895|>;

(* Learned coefficients from n <= 100 *)
alpha = 0.1125;
beta = -0.309;
gamma = -0.1126;

Print["Using model from n <= 100:"];
Print["  Baselines: g(1)=9.42, g(3)=5.77, g(5)=9.36, g(7)=4.79"];
Print["  Coefficients: alpha=0.11, beta=-0.31, gamma=-0.11"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Test on 200 < n <= 400 *)
Print["Computing test set (200 < n <= 400)..."];
Print[];

testData = Table[
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
  {n, 201, 400}
];

testData = DeleteCases[testData, Nothing];

Print["Test set: ", Length[testData], " square-free odd n"];
Print[];

(* Predictions *)
RTrue = testData[[All, 2]];

predBaseline = Table[baselines[testData[[i, 6]]], {i, Length[testData]}];

predFull = Table[
  {n, Rtrue, dist, m, h, mod8} = testData[[i]];
  baseline = baselines[mod8];
  baseline * (1 + alpha*dist + beta*m + gamma*h),
  {i, Length[testData]}
];

(* Correlations *)
corrBaseline = Correlation[N[RTrue], N[predBaseline]];
corrFull = Correlation[N[RTrue], N[predFull]];

Print["RESULTS:"];
Print[StringRepeat["-", 60]];
Print["Baseline only:            r = ", N[corrBaseline, 4]];
Print["Full model:               r = ", N[corrFull, 4]];
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

(* Compare to training range *)
Print["COMPARISON TO TRAINING (100 < n <= 200):"];
Print[StringRepeat["-", 60]];
Print["Training range:  r = 0.64, error = 39%"];
Print["Large n range:   r = ", N[corrFull, 4], ", error = ",
      N[100*Mean[errorsFull], 2], "%"];
Print[];

If[Abs[corrFull - 0.64] < 0.1,
  Print["PERSISTENCE CONFIRMED: Model stable across ranges!"],
  Print["Model performance changed: ",
        If[corrFull > 0.64, "IMPROVED", "DEGRADED"]]
];

Print[];
Print[StringRepeat["=", 80]];
