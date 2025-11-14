#!/usr/bin/env wolframscript
(* Test if offset factorial sums eventually stabilize to constant ratio *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Testing for EVENTUAL Stabilization of Ratios"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

TestStabilization[a_, mMax_: 81] := Module[
  {results, ratios, lastN, allSame, stableRatio, firstStable},

  (* Compute all ratios *)
  results = Table[
    Module[{kMax, sum, denom, prim, ratio},
      kMax = Floor[(m-1)/2];

      If[kMax < a,
        Nothing,
        sum = Sum[(-1)^k * (k-a)!/(2k+1), {k, a, kMax}];
        denom = Denominator[sum];
        prim = Primorial[m];
        ratio = prim/denom;
        {m, ratio}
      ]
    ],
    {m, 3, mMax, 2}
  ];

  If[Length[results] < 10,
    Return[<|"a" -> a, "Status" -> "Too few terms"|>]
  ];

  ratios = results[[All, 2]];

  (* Check last N values for stability *)
  lastN = 10;
  If[Length[ratios] >= lastN,
    lastRatios = Take[ratios, -lastN];
    allSame = Length[DeleteDuplicates[lastRatios]] == 1;

    If[allSame,
      stableRatio = lastRatios[[1]];

      (* Find where stabilization started *)
      firstStable = Nothing;
      Do[
        If[i >= 5,  (* Need at least 5 consecutive *)
          If[Length[DeleteDuplicates[ratios[[i;;]]]] == 1,
            firstStable = results[[i, 1]];
            Break[];
          ]
        ],
        {i, 1, Length[ratios]}
      ];

      <|
        "a" -> a,
        "Status" -> "STABLE",
        "Stable ratio" -> stableRatio,
        "Stable from m" -> firstStable,
        "Formula" -> If[IntegerQ[stableRatio] && stableRatio > 0,
          "Primorial/" <> ToString[stableRatio],
          "Primorial·" <> ToString[1/stableRatio]
        ],
        "Missing primes" -> If[IntegerQ[stableRatio] && stableRatio > 0,
          FactorInteger[stableRatio][[All, 1]],
          "Extra factors"
        ],
        "Sample ratios" -> {
          results[[1]],
          If[Length[results] > 5, results[[5]], Nothing],
          If[Length[results] > 10, results[[10]], Nothing],
          results[[-1]]
        }
      |>,

      (* Not stable *)
      <|
        "a" -> a,
        "Status" -> "UNSTABLE",
        "Last 10 ratios" -> Take[ratios, -10]
      |>
    ],

    <|"a" -> a, "Status" -> "Too few terms"|>
  ]
];

(* Test offsets 0 through 15 *)
summaryResults = Table[TestStabilization[a, 81], {a, 0, 15}];

(* Print detailed results for stable cases *)
stableCases = Select[summaryResults, #["Status"] == "STABLE" &];

If[Length[stableCases] > 0,
  Print["STABLE FORMULAS FOUND!\n"];
  Do[
    Print["Offset a = ", result["a"], ": (k-", result["a"], ")!"];
    Print["  Stable ratio: ", result["Stable ratio"]];
    Print["  Formula: ", result["Formula"]];
    If[result["Missing primes"] =!= "Extra factors",
      Print["  Missing primes: ", result["Missing primes"]];
    ];
    Print["  Stable from m ≥ ", result["Stable from m"]];
    Print["  Sample progression:"];
    Do[
      {m, ratio} = sample;
      Print["    m=", m, ": ratio = ", N[ratio, 4]];
      ,
      {sample, result["Sample ratios"]}
    ];
    Print[""];
    ,
    {result, stableCases}
  ];
];

(* Summary table *)
Print[StringRepeat["=", 70]];
Print["SUMMARY TABLE"];
Print[StringRepeat["=", 70]];
Print["a | Status | Stable Ratio | Stable From m | Formula"];
Print[StringRepeat["-", 70]];

Do[
  a = result["a"];
  status = result["Status"];

  If[status == "STABLE",
    Print[
      StringPadRight[ToString[a], 2], " | ",
      StringPadRight[status, 8], " | ",
      StringPadRight[ToString[result["Stable ratio"]], 12], " | ",
      StringPadRight[ToString[result["Stable from m"]], 13], " | ",
      result["Formula"]
    ];
    ,
    Print[StringPadRight[ToString[a], 2], " | ", status];
  ];
  ,
  {result, summaryResults}
];

Print["\n" ~~ StringRepeat["=", 70]];
Print["CONCLUSION"];
Print[StringRepeat["=", 70]];

stableCount = Length[stableCases];
Print["\n✓ Found ", stableCount, " formulas with eventual stabilization!"];

If[stableCount > 0,
  Print["\nKey findings:"];
  Do[
    a = result["a"];
    ratio = result["Stable ratio"];
    mStable = result["Stable from m"];

    factorReduction = If[a > 0, " (" <> ToString[N[a!, 3]] <> "x smaller than k!)", ""];

    Print["  • (k-", a, ")! gives ", result["Formula"],
          " for m ≥ ", mStable, factorReduction];
    ,
    {result, stableCases}
  ];

  (* Find the best (largest a with reasonable stabilization point) *)
  goodCases = Select[stableCases,
    #["Stable from m"] < 30 && IntegerQ[#["Stable ratio"]] &
  ];

  If[Length[goodCases] > 0,
    bestCase = Last[SortBy[goodCases, #["a"]&]];
    Print["\n★ BEST FORMULA: (k-", bestCase["a"], ")! starting from k=", bestCase["a"]];
    Print["  Factorial is ", bestCase["a"], "! = ",
          bestCase["a"]!, " times smaller than k!"];
    Print["  Gives ", bestCase["Formula"], " for all m ≥ ", bestCase["Stable from m"]];
  ];
];

Print["\nDone!"];
