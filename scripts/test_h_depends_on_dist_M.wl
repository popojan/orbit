#!/usr/bin/env wolframscript
(* TEST: Does h(n) depend on dist, M, mod8? *)

Print[StringRepeat["=", 80]];
Print["TEST: Is h(n) intermediate variable?"];
Print[StringRepeat["=", 80]];
Print[];

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

(* Collect data *)
data = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{h, dist, m, mod8},
      h = ClassNumber[n];
      dist = DistToK2[n];
      m = M[n];
      mod8 = Mod[n, 8];
      If[!MissingQ[h],
        {n, h, dist, m, mod8},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 3, 200}
];

data = DeleteCases[data, Nothing];

Print["Data: ", Length[data], " square-free odd n"];
Print[];

(* Extract *)
hVals = data[[All, 2]];
distVals = data[[All, 3]];
MVals = data[[All, 4]];

(* Correlations *)
Print["CORRELATIONS WITH h(n):"];
Print[StringRepeat["-", 60]];
Print["  dist <-> h:  ", N[Correlation[N[distVals], N[hVals]], 4]];
Print["  M <-> h:     ", N[Correlation[N[MVals], N[hVals]], 4]];
Print[];

(* By mod 8 *)
Print["BY MOD 8 CLASS:"];
Print[StringRepeat["-", 60]];

For[mod = 1, mod <= 7, mod += 2,
  subset = Select[data, #[[5]] == mod &];
  If[Length[subset] > 10,
    hSub = subset[[All, 2]];
    distSub = subset[[All, 3]];
    MSub = subset[[All, 4]];

    corrDist = Correlation[N[distSub], N[hSub]];
    corrM = Correlation[N[MSub], N[hSub]];

    Print["mod ", mod, ": dist<->h = ", N[corrDist, 3],
          ", M<->h = ", N[corrM, 3]];
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["INTERPRETATION:"];
Print[StringRepeat["-", 60]];
Print[];
Print["If h correlates with dist/M, then h is NOT independent factor!"];
Print["Causal chain: dist, M, mod8  ->  h(n)  ->  R(n)"];
Print[];
Print["Then we can eliminate h from theory:"];
Print["  R(n) ~ sqrt(n) * L(1,chi_n) / h(n)"];
Print["       ~ sqrt(n) * L(1,chi_n) * g(dist, M, mod8)"];
Print[];
Print["Where g absorbs 1/h dependence on dist/M/mod8!");
Print[];

Print[StringRepeat["=", 80]];
