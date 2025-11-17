#!/usr/bin/env wolframscript
(* CF PATTERN ANALYSIS: How mod 8 + distance determines CF structure *)

Print[StringRepeat["=", 80]];
Print["CONTINUED FRACTION PATTERN ANALYSIS"];
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

(* Direct CF computation for sqrt(n) *)
CFData[n_] := Module[{a0, m, d, a, period, seen, state, maxSteps},
  If[IntegerQ[Sqrt[n]], Return[{0, {}}]];

  a0 = Floor[Sqrt[n]];
  m = 0;
  d = 1;
  a = a0;

  period = {};
  seen = <||>;
  maxSteps = 100;

  (* Iterate to find periodic part *)
  Do[
    m = d*a - m;
    d = (n - m^2)/d;
    a = Floor[(a0 + m)/d];

    state = {m, d};
    If[KeyExistsQ[seen, state],
      Break[]
    ];

    seen[state] = i;
    AppendTo[period, a];
    ,
    {i, maxSteps}
  ];

  {a0, period}
]

(* Analyze CF structure *)
Print["Analyzing CF patterns for n = 2..100..."];
Print[];

data = Table[
  If[!IntegerQ[Sqrt[n]],
    Module[{R, k, c, mod4, mod8, cfData, a0, period, periodLen, a1},
      R = Reg[n];
      k = Floor[Sqrt[n]];
      c = n - k^2;
      mod4 = Mod[n, 4];
      mod8 = Mod[n, 8];

      cfData = CFData[n];
      a0 = cfData[[1]];
      period = cfData[[2]];
      periodLen = Length[period];

      a1 = If[periodLen > 0, period[[1]], 0];

      If[R > 0 && periodLen > 0,
        {n, R, k, c, mod4, mod8, a0, a1, periodLen, period},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 2, 100}
];

data = DeleteCases[data, Nothing];

Print["Collected ", Length[data], " non-squares"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* First examples *)
Print["EXAMPLES OF CF STRUCTURE:"];
Print[StringRepeat["-", 80]];
Print["n    k  c  mod8  a0  a1  period  R(n)     CF period"];
Print[StringRepeat["-", 80]];

Do[
  {n, R, k, c, mod4, mod8, a0, a1, periodLen, period} = data[[i]];
  Print[
    StringPadRight[ToString[n], 5],
    StringPadRight[ToString[k], 3],
    StringPadRight[ToString[c], 3],
    StringPadRight[ToString[mod8], 6],
    StringPadRight[ToString[a0], 4],
    StringPadRight[ToString[a1], 4],
    StringPadRight[ToString[periodLen], 8],
    StringPadRight[ToString[N[R, 3]], 9],
    Take[period, Min[8, Length[period]]]
  ];
  ,
  {i, Min[30, Length[data]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Period length statistics *)
Print["PERIOD LENGTH ANALYSIS:"];
Print[StringRepeat["-", 60]];

periodLengths = data[[All, 9]];
RVals = data[[All, 2]];

Print["Period length vs R correlation: ",
      N[Correlation[N[periodLengths], N[RVals]], 4]];
Print[];

Print["By mod 8:"];
For[mod = 1, mod <= 7, mod += 2,
  subset = Select[data, #[[6]] == mod &];
  If[Length[subset] > 5,
    periods = subset[[All, 9]];
    Rs = subset[[All, 2]];
    corr = Correlation[N[periods], N[Rs]];

    Print["  mod ", mod, ": period <-> R = ", N[corr, 3],
          ", mean period = ", N[Mean[periods], 2],
          ", mean R = ", N[Mean[Rs], 2]];
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* First term a1 vs distance *)
Print["FIRST TERM a1 VS DISTANCE:"];
Print[StringRepeat["-", 60]];

a1Vals = data[[All, 8]];
distVals = data[[All, 4]];

Print["Theoretical: a1 = floor(2k/c)"];
Print[];

(* Check theory *)
theoretical = Table[
  {n, R, k, c, mod4, mod8, a0, a1, periodLen, period} = data[[i]];
  Floor[2*k/c]
  ,
  {i, Length[data]}
];

matches = Count[MapThread[Equal, {a1Vals, theoretical}], True];
Print["Theory matches: ", matches, "/", Length[data],
      " (", N[100.0*matches/Length[data], 1], "%)"];
Print[];

(* Find violations *)
violations = Select[Range[Length[data]], a1Vals[[#]] != theoretical[[#]] &];

If[Length[violations] > 0,
  Print["Violations (first 10):"];
  Do[
    i = violations[[j]];
    {n, R, k, c, mod4, mod8, a0, a1, periodLen, period} = data[[i]];
    theo = theoretical[[i]];
    Print["  n=", n, ": a1=", a1, " vs theo=", theo,
          " (k=", k, ", c=", c, ", 2k/c=", N[2*k/c, 3], ")"];
    ,
    {j, Min[10, Length[violations]]}
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Period length by distance *)
Print["PERIOD LENGTH VS DISTANCE:"];
Print[StringRepeat["-", 60]];

Print["Correlation period <-> distance: ",
      N[Correlation[N[periodLengths], N[distVals]], 4]];
Print[];

(* Group by distance *)
distGroups = {1, 2, 3, {4, 5}, {6, 10}, {11, 100}};

Do[
  If[ListQ[dGroup],
    subset = Select[data, dGroup[[1]] <= #[[4]] <= dGroup[[2]] &];
    label = ToString[dGroup[[1]]] <> "-" <> ToString[dGroup[[2]]];
    ,
    subset = Select[data, #[[4]] == dGroup &];
    label = ToString[dGroup];
  ];

  If[Length[subset] > 0,
    periods = subset[[All, 9]];
    Rs = subset[[All, 2]];
    Print["  c = ", label, ": mean period = ", N[Mean[periods], 2],
          ", mean R = ", N[Mean[Rs], 2],
          " (", Length[subset], " cases)"];
  ];
  ,
  {dGroup, distGroups}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Palindrome check *)
Print["PALINDROME STRUCTURE:"];
Print[StringRepeat["-", 60]];

palindromeCount = Count[data, Module[{period},
  period = #[[10]];
  period === Reverse[period]
] &];

Print["Perfect palindromes: ", palindromeCount, "/", Length[data],
      " (", N[100.0*palindromeCount/Length[data], 1], "%)"];
Print[];

(* CF periods are ALMOST palindromes - symmetric except last term *)
almostPalindromes = Count[data, Module[{period, middle},
  period = #[[10]];
  If[Length[period] <= 1, False,
    middle = Most[period];
    Last[period] == 2*First[period] && middle === Reverse[middle]
  ]
] &];

Print["Almost palindromes (standard form): ", almostPalindromes, "/", Length[data],
      " (", N[100.0*almostPalindromes/Length[data], 1], "%)"];
Print[];

Print["Standard form: sqrt(n) = [a0; a1, a2, ..., a2, a1, 2*a0]"];
Print["              (period ends with 2*a0)"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

Print["KEY QUESTIONS:"];
Print[StringRepeat["-", 60]];
Print[];
Print["1. Can we predict period length from (mod 8, distance)?"];
Print["2. Does period length fully determine R(n)?"];
Print["3. Are there CF patterns specific to mod 8 classes?"];
Print["4. Can we classify CF structures beyond just period length?"];
Print[];

Print[StringRepeat["=", 80]];
