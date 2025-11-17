#!/usr/bin/env wolframscript
(* ANALYZE M=1 cases for n ≡ 3: What determines h? *)

Print[StringRepeat["=", 80]];
Print["ANALYZING M=1 cases for n ≡ 3: What determines h?"];
Print[StringRepeat["=", 80]];
Print[];

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

ClassNumber[n_] := Module[{factors},
  factors = FactorInteger[n];
  If[Max[factors[[All, 2]]] > 1, Return[Missing["NotSquareFree"]]];
  NumberFieldClassNumber[Sqrt[n]]
]

DistToK2[n_] := Module[{k},
  k = Floor[Sqrt[n]];
  Min[n - k^2, (k+1)^2 - n]
]

(* Collect M=1 cases for n ≡ 3 *)
data = Table[
  If[Mod[n, 8] == 3 && OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{h, m, dist, factors, omega},
      m = M[n];
      If[m == 1,
        h = ClassNumber[n];
        dist = DistToK2[n];
        factors = FactorInteger[n];
        omega = Length[factors];  (* number of prime factors *)
        If[!MissingQ[h],
          {n, h, dist, omega, factors},
          Nothing
        ],
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 3, 400}
];

data = DeleteCases[data, Nothing];

Print["Found ", Length[data], " cases with M=1"];
Print[];

(* Display *)
Print["DATA (M=1, n ≡ 3):"];
Print[StringRepeat["-", 70]];
Print["n       h    dist  omega  factorization"];
Print[StringRepeat["-", 70]];

Do[
  {n, h, dist, omega, factors} = data[[i]];
  Print[
    StringPadRight[ToString[n], 8],
    StringPadRight[ToString[h], 5],
    StringPadRight[ToString[dist], 6],
    StringPadRight[ToString[omega], 7],
    factors
  ];
  ,
  {i, Length[data]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Group by h *)
Print["GROUPING BY h:"];
Print[StringRepeat["-", 60]];
Print[];

byH = GroupBy[data, #[[2]] &];

Do[
  h = key;
  cases = byH[h];
  Print["h = ", h, ": ", Length[cases], " cases"];
  Print["  n values: ", cases[[All, 1]]];
  Print["  dist values: ", cases[[All, 3]]];
  Print["  omega values: ", cases[[All, 4]]];
  Print[];
  ,
  {key, Sort[Keys[byH]]}
];

Print[StringRepeat["=", 80]];
Print[];

(* Correlations *)
hVals = data[[All, 2]];
distVals = data[[All, 3]];
omegaVals = data[[All, 4]];

Print["CORRELATIONS:"];
Print[StringRepeat["-", 60]];
Print["  dist <-> h:   ", N[Correlation[N[distVals], N[hVals]], 4]];
Print["  omega <-> h:  ", N[Correlation[N[omegaVals], N[hVals]], 4]];
Print[];

(* Pattern search *)
Print["PATTERN SEARCH:"];
Print[StringRepeat["-", 60]];
Print[];

Print["Test: h depends on smallest prime factor?"];
Do[
  {n, h, dist, omega, factors} = data[[i]];
  smallestP = factors[[1, 1]];
  Print["n=", n, ": h=", h, ", smallest prime = ", smallestP,
        ", p mod 8 = ", Mod[smallestP, 8]];
  ,
  {i, Min[10, Length[data]]}
];

Print[];
Print[StringRepeat["=", 80]];
