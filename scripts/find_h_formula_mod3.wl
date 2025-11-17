#!/usr/bin/env wolframscript
(* FIND h = f(M) for n ≡ 3 (mod 8) *)

Print[StringRepeat["=", 80]];
Print["FINDING h = f(M) for n ≡ 3 (mod 8)"];
Print[StringRepeat["=", 80]];
Print[];

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

ClassNumber[n_] := Module[{factors},
  factors = FactorInteger[n];
  If[Max[factors[[All, 2]]] > 1, Return[Missing["NotSquareFree"]]];
  NumberFieldClassNumber[Sqrt[n]]
]

(* Collect n ≡ 3 (mod 8) *)
Print["Collecting n ≡ 3 (mod 8) data..."];
Print[];

data = Table[
  If[Mod[n, 8] == 3 && OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{h, m},
      h = ClassNumber[n];
      m = M[n];
      If[!MissingQ[h],
        {n, m, h},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 3, 400}
];

data = DeleteCases[data, Nothing];

Print["Found ", Length[data], " square-free n ≡ 3"];
Print[];

(* Display data *)
Print["DATA TABLE (n ≡ 3):"];
Print[StringRepeat["-", 60]];
Print["n       M(n)    h(n)"];
Print[StringRepeat["-", 60]];

Do[
  {n, m, h} = data[[i]];
  Print[
    StringPadRight[ToString[n], 8],
    StringPadRight[ToString[m], 8],
    h
  ];
  ,
  {i, Min[30, Length[data]]}
];

If[Length[data] > 30,
  Print["... (showing first 30 of ", Length[data], ")"];
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Group by M *)
Print["GROUPING BY M(n):"];
Print[StringRepeat["-", 60]];

grouped = GroupBy[data, #[[2]] &];
mValues = Sort[Keys[grouped]];

Do[
  m = mValues[[i]];
  cases = grouped[m];
  hVals = cases[[All, 3]];

  Print["M = ", m, ": ", Length[cases], " cases"];
  Print["  h values: ", Union[hVals]];
  Print["  Mean h: ", N[Mean[hVals], 4]];
  Print["  All same? ", If[Length[Union[hVals]] == 1, "YES ✓", "NO"]];
  Print[];
  ,
  {i, Length[mValues]}
];

Print[StringRepeat["=", 80]];
Print[];

(* Try to find formula *)
Print["HYPOTHESIS TESTING:"];
Print[StringRepeat["-", 60]];
Print[];

MVals = data[[All, 2]];
hVals = data[[All, 3]];

Print["Test 1: h = a + b*M (linear)"];
fit = LinearModelFit[Transpose[{MVals, hVals}], x, x];
Print["  Fit: h = ", fit["BestFitParameters"][[1]], " + ",
      fit["BestFitParameters"][[2]], " * M"];
Print["  R² = ", N[fit["RSquared"], 4]];
Print[];

Print["Test 2: h = M + c (offset)"];
offsets = hVals - MVals;
Print["  h - M values: ", Union[offsets]];
Print["  Mean offset: ", N[Mean[offsets], 4]];
Print["  All same? ", If[Length[Union[offsets]] == 1, "YES ✓", "NO"]];
Print[];

Print["Test 3: h = M (identity)"];
correct = Count[hVals - MVals, 0];
Print["  Exact matches: ", correct, " / ", Length[hVals]];
Print[];

Print["Test 4: h = f(M) lookup table"];
lookup = Association[];
Do[
  m = mValues[[i]];
  cases = grouped[m];
  hValsForM = Union[cases[[All, 3]]];
  If[Length[hValsForM] == 1,
    lookup[m] = First[hValsForM];
  ];
  ,
  {i, Length[mValues]}
];

If[Length[lookup] > 0,
  Print["  Deterministic mapping found:"];
  Do[
    Print["    M = ", key, " -> h = ", lookup[key]];
    ,
    {key, Sort[Keys[lookup]]}
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["CONCLUSION:"];
Print[StringRepeat["-", 60]];
Print[];

If[fit["RSquared"] > 0.99,
  Print["LINEAR FORMULA FOUND: h ≈ ", N[fit["BestFitParameters"][[1]], 3],
        " + ", N[fit["BestFitParameters"][[2]], 3], " * M"];
  Print["R² = ", N[fit["RSquared"], 4], " (excellent fit!)"];
];

If[Length[Union[offsets]] == 1,
  Print["OFFSET FORMULA FOUND: h = M + ", First[offsets]];
  Print["(exact for all cases!)"];
];

If[correct == Length[hVals],
  Print["IDENTITY FOUND: h = M exactly!");
];

Print[];
Print[StringRepeat["=", 80]];
