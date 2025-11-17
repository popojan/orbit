#!/usr/bin/env wolframscript
(* TEST: p = k² - c for small c *)

Print[StringRepeat["=", 80]];
Print["VZDUŠNÁ ČÁRA TEST: p = k² - c (approaching from below)"];
Print[StringRepeat["=", 80]];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

(* Test k² - c for c = 1,2,3,4 *)
Print["Testing p = k² - c for c ∈ {1,2,3,4}.."];
Print[];

For[c = 1, c <= 4, c++,
  cases = DeleteCases[Table[
    Module[{p, period},
      p = k^2 - c;
      If[p > 2 && PrimeQ[p],
        period = CFPeriod[p];
        {k, p, period},
        Nothing
      ]
    ],
    {k, 2, 30}
  ], Nothing];

  Print[StringRepeat["=", 80]];
  Print["CASE: c = ", c, " (p = k² - ", c, ")"];
  Print[StringRepeat["=", 80]];
  Print[];

  If[Length[cases] > 0,
    Print["Found ", Length[cases], " primes"];
    Print[];

    Print["k    p      period"];
    Print[StringRepeat["-", 40]];

    Do[
      {k, p, per} = cases[[i]];
      Print[
        StringPadRight[ToString[k], 5],
        StringPadRight[ToString[p], 7],
        per
      ];
      ,
      {i, Length[cases]}
    ];

    Print[];

    (* Period analysis *)
    periods = cases[[All, 3]];
    uniquePeriods = Union[periods];

    Print["Unique periods: ", uniquePeriods];

    If[Length[uniquePeriods] == 1,
      Print["★★★ CONSTANT: period = ", uniquePeriods[[1]], " for ALL p = k² - ", c];
      Print["    VZDUŠNÁ ČÁRA EXISTS!"];
      ,
      Print["Periods vary: ", uniquePeriods];

      (* Check parity *)
      allEven = AllTrue[periods, EvenQ];
      allOdd = AllTrue[periods, OddQ];

      If[allEven,
        Print["★ All periods are EVEN"];
      ];
      If[allOdd,
        Print["★ All periods are ODD"];
      ];

      (* Check if period = 2k pattern *)
      ratios = Table[N[cases[[i,3]] / cases[[i,1]]], {i, Length[cases]}];
      Print["period/k ratios: ", ratios];
    ];

    Print[];
  ,
    Print["No primes found for c = ", c];
    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["SUMMARY: p = k² ± c PATTERNS"];
Print[StringRepeat["=", 80]];
Print[];

Print["ABOVE k² (p = k² + c):"];
Print["  c=1: period = 1 (constant) ✓ VZDUŠNÁ ČÁRA"];
Print["  c=2: period = 2 (constant) ✓ VZDUŠNÁ ČÁRA"];
Print["  c=3: period = EVEN (varies)"];
Print[];

Print["BELOW k² (p = k² - c):"];
(* Summarize findings from above *)
Print["  c=1: (k-1)(k+1) always composite");
Print["  c=2,3,4: [see results above]"];
Print[];

Print["Hypothesis: Distance from k² determines CF structure"];
Print["  Small |c| → predictable period?");
Print["  Below vs. above k² → different patterns?");
Print[];

Print[StringRepeat["=", 80]];
Print["DETAILED: k² - 2 ANALYSIS"];
Print[StringRepeat["=", 80]];
Print[];

(* Focus on k² - 2 *)
cases2 = DeleteCases[Table[
  Module[{p, period, cf},
    p = k^2 - 2;
    If[p > 2 && PrimeQ[p],
      period = CFPeriod[p];
      cf = ContinuedFraction[Sqrt[p]];
      {k, p, period, cf[[2]]},
      Nothing
    ]
  ],
  {k, 2, 20}
], Nothing];

If[Length[cases2] > 0,
  Print["p = k² - 2 cases:"];
  Print[];

  Print["k    p      period  CF terms"];
  Print[StringRepeat["-", 70]];

  Do[
    {k, p, per, cfTerms} = cases2[[i]];
    Print[
      StringPadRight[ToString[k], 5],
      StringPadRight[ToString[p], 7],
      StringPadRight[ToString[per], 8],
      cfTerms
    ];
    ,
    {i, Length[cases2]}
  ];

  Print[];

  periods = cases2[[All, 3]];
  uniquePeriods = Union[periods];

  If[Length[uniquePeriods] == 1,
    Print["★★★ BREAKTHROUGH: p = k² - 2 has constant period = ", uniquePeriods[[1]]];
    Print["    This mirrors p = k² + 2 (also period = 2)!"];
    Print["    SYMMETRY around k²!");
    ,
    Print["Periods: ", uniquePeriods];
    Print["Mean period: ", N[Mean[periods]]];

    (* Check for 2k pattern *)
    If[Length[cases2] >= 3,
      firstThree = cases2[[1;;3]];
      ratios = Table[firstThree[[i,3]] / firstThree[[i,1]], {i, 3}];
      Print["period/k for first 3: ", ratios];

      If[AllTrue[ratios, # == 2 &],
        Print["★ Pattern: period = 2k for k² - 2!"];
      ];
    ];
  ];
];

Print[];
Print["TEST COMPLETE"];
