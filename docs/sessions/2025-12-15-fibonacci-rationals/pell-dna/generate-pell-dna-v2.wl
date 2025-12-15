(* Pell DNA Database Generator v2 *)
(* Focus: Zeckendorf representation + educational structure *)

(* Fibonacci numbers *)
fibs = Module[{f = {1, 2}},
  While[Last[f] < 10^15, AppendTo[f, f[[-1]] + f[[-2]]]];
  f
];

(* Zeckendorf representation *)
zeckendorf[0] := {}
zeckendorf[n_] := Module[{result = {}, remaining = n, idx},
  idx = Length[fibs];
  While[remaining > 0 && idx >= 1,
    If[fibs[[idx]] <= remaining,
      AppendTo[result, idx];
      remaining -= fibs[[idx]];
      idx -= 2;  (* Skip adjacent *)
    ,
      idx--;
    ]
  ];
  result
]

(* Pell fundamental solution using CF *)
pellFundamental[d_] := Module[{cf, n, p, q},
  If[IntegerQ[Sqrt[d]], Return[{0, 0}]];
  cf = ContinuedFraction[Sqrt[d], 500];
  For[n = 2, n <= Length[cf], n++,
    {p, q} = {Numerator[#], Denominator[#]} &@ FromContinuedFraction[Take[cf, n]];
    If[p^2 - d*q^2 == 1, Return[{p, q}]];
    If[p^2 - d*q^2 == -1,
      Return[{p^2 + d*q^2, 2*p*q}]  (* Double to get norm +1 *)
    ];
  ];
  {0, 0}
];

(* CF period for sqrt(D) *)
cfPeriod[d_] := Module[{cf},
  If[IntegerQ[Sqrt[d]], Return[0]];
  cf = ContinuedFraction[Sqrt[d]];
  If[ListQ[cf] && Length[cf] >= 2 && ListQ[cf[[2]]],
    Length[cf[[2]]],
    0
  ]
];

(* Generate database *)
Print["=== PELL DNA DATABASE ===\n"];
Print["D\tperiod\tx\ty\t|zeck(x)|\tzeck(x)"];
Print[StringJoin[Table["-", 80]]];

results = {};
Do[
  If[!IntegerQ[Sqrt[d]],
    {x, y} = pellFundamental[d];
    If[x > 0,
      period = cfPeriod[d];
      zx = zeckendorf[x];
      AppendTo[results, <|
        "D" -> d,
        "period" -> period,
        "x" -> x,
        "y" -> y,
        "zeckLen" -> Length[zx],
        "zeck" -> zx
      |>];
      Print[d, "\t", period, "\t",
        If[x < 10^6, x, ToString[IntegerLength[x]] <> "dig"], "\t",
        If[y < 10^6, y, ToString[IntegerLength[y]] <> "dig"], "\t",
        Length[zx], "\t",
        If[Length[zx] <= 8, zx, Take[zx, 5] ~Join~ {"..."}]
      ]
    ]
  ],
  {d, 2, 200}
];

(* Export as JSON *)
Print["\n=== JSON EXPORT ===\n"];
Print["const PELL_DATA = ["];
Do[
  r = results[[i]];
  Print["  {D:", r["D"], ", period:", r["period"],
    ", x:\"", r["x"], "\", y:\"", r["y"],
    "\", zeck:", r["zeck"], "},"];
  , {i, Min[50, Length[results]]}
];
Print["  // ... truncated"];
Print["];"];

(* Summary statistics *)
Print["\n=== STATISTICS ==="];
Print["Total D values: ", Length[results]];
Print["Max period: ", Max[#["period"] & /@ results]];
Print["Max |zeck|: ", Max[#["zeckLen"] & /@ results]];

(* Correlation analysis *)
periods = #["period"] & /@ results;
zeckLens = #["zeckLen"] & /@ results;
corr = Correlation[periods, zeckLens];
Print["Period-Zeck correlation: ", N[corr, 3]];
