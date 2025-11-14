#!/usr/bin/env wolframscript
(* Test p-adic theoretically-motivated corrections *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Testing p-adic Theoretically-Motivated Corrections"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

Print["GOAL REMINDER:"];
Print["  Proxy: Reduce numerator magnitude"];
Print["  Ultimate: Find predictable/nice numerator structure\n"];

(* Corrections designed from p-adic constraints *)
corrections = <|
  "Baseline: k!" -> Function[k, k!],

  (* Remove factors of 2 *)
  "k! / 2^ν_2(k!)" -> Function[k, k! / 2^IntegerExponent[k!, 2]],
  "k! - k!/2" -> Function[k, k!/2],

  (* Remove small primes *)
  "k! / 2" -> Function[k, k!/2],
  "k! / 6" -> Function[k, k!/6],
  "k! / 30" -> Function[k, k!/30],

  (* Strategic alternating corrections *)
  "k! + (-1)^k · (k-1)!" -> Function[k, k! + If[k>=1, (-1)^k * (k-1)!, 0]],
  "k! - (-1)^k · k" -> Function[k, k! - (-1)^k * k],

  (* Offset-like but as correction *)
  "k! - 5040" -> Function[k, k! - 5040],
  "k! - k^2" -> Function[k, k! - k^2]
|>;

TestCorrection[name_, f_, mMax_: 31] := Module[
  {results, numerators},

  results = Table[
    Module[{sum, denom, numer, prim, ratio},
      sum = Sum[(-1)^j * f[j]/(2j+1), {j, 1, (m-1)/2}];
      denom = Denominator[sum];
      numer = Numerator[sum];
      prim = Primorial[m];
      ratio = prim/denom;

      {m, denom, prim, ratio, numer, IntegerLength[Abs[numer]]}
    ],
    {m, 3, mMax, 2}
  ];

  numerators = results[[All, 5]];

  (* Check for patterns in numerators *)
  numSizes = results[[All, 6]];
  ratios = results[[All, 4]];

  (* Check eventual stabilization *)
  lastRatios = If[Length[ratios] >= 5, Take[ratios, -5], ratios];
  isStable = Length[DeleteDuplicates[lastRatios]] == 1;
  stableRatio = If[isStable, Last[ratios], "Unstable"];

  (* Check for numerator patterns *)
  numRatios = Table[
    If[numerators[[i]] != 0 && numerators[[i+1]] != 0,
      N[numerators[[i+1]] / numerators[[i]], 3],
      Missing[]
    ],
    {i, 1, Length[numerators]-1}
  ];
  validNumRatios = DeleteMissing[numRatios];

  (* Check for recurrence *)
  hasRecurrence = If[Length[validNumRatios] > 3,
    StandardDeviation[validNumRatios] < 1.0,  (* Nearly constant growth *)
    False
  ];

  (* Check if numerators are "nice" (small, factorizable) *)
  niceCount = Count[Abs[numerators], n_ /; n < 1000];

  <|
    "Name" -> name,
    "Stable ratio" -> stableRatio,
    "Avg num size" -> Mean[numSizes],
    "Has recurrence?" -> hasRecurrence,
    "Nice numerator %" -> N[100 * niceCount / Length[numerators]],
    "Sample numerators" -> Take[numerators, UpTo[6]],
    "Numerator growth" -> If[Length[validNumRatios] > 0,
      Mean[validNumRatios],
      "N/A"
    ]
  |>
];

Print["Testing corrections...\n"];

testResults = KeyValueMap[
  Function[{name, f},
    Print["  Testing: ", name];
    TestCorrection[name, f, 31]
  ],
  corrections
];

(* Summary table *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["SUMMARY: Stable Ratio and Numerator Properties"];
Print[StringRepeat["=", 70], "\n"];

Print[Grid[
  Prepend[
    Table[
      {
        result["Name"],
        result["Stable ratio"],
        NumberForm[result["Avg num size"], {4, 1}],
        If[result["Has recurrence?"], "✓", "✗"],
        NumberForm[result["Nice numerator %"], {4, 1}]
      },
      {result, testResults}
    ],
    {"Correction", "Stable Ratio", "Avg Digits", "Recurrence?", "Nice %"}
  ],
  Frame -> All,
  Alignment -> Left
]];

(* Detailed analysis of promising candidates *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["DETAILED ANALYSIS: Promising Corrections"];
Print[StringRepeat["=", 70], "\n"];

promising = Select[testResults,
  (#["Stable ratio"] =!= "Unstable" || #["Has recurrence?"] || #["Nice numerator %"] > 30) &
];

If[Length[promising] > 0,
  Do[
    Print["• ", result["Name"]];
    Print["  Stable ratio: ", result["Stable ratio"]];
    Print["  Avg numerator size: ", NumberForm[result["Avg num size"], {4, 1}], " digits"];
    Print["  Numerator growth factor: ", result["Numerator growth"]];
    Print["  Nice numerators: ", NumberForm[result["Nice numerator %"], {4, 1}], "%"];
    Print["  Sample numerators: ", Take[result["Sample numerators"], UpTo[4]]];

    (* Check for patterns *)
    nums = result["Sample numerators"];
    If[Length[nums] > 2,
      (* Check if they're in OEIS *)
      Print["  Checking for known patterns..."];

      (* Simple checks *)
      If[AllTrue[nums, PrimeQ],
        Print["    → All numerators are PRIME!"];
      ];

      diffs = Differences[nums];
      If[Length[DeleteDuplicates[diffs]] == 1,
        Print["    → ARITHMETIC sequence! Difference: ", diffs[[1]]];
      ];

      If[Length[nums] > 3,
        secondDiffs = Differences[diffs];
        If[Length[DeleteDuplicates[secondDiffs]] == 1,
          Print["    → QUADRATIC sequence! Second diff: ", secondDiffs[[1]]];
        ];
      ];
    ];

    Print[""];
    ,
    {result, promising}
  ];
  ,
  Print["No promising corrections found.\n"];
];

(* Compare magnitude reduction *)
Print[StringRepeat["=", 70]];
Print["MAGNITUDE REDUCTION vs BASELINE"];
Print[StringRepeat["=", 70], "\n"];

baseline = First[Select[testResults, #["Name"] == "Baseline: k!" &]];
baselineSize = baseline["Avg num size"];

improvements = Select[testResults,
  NumericQ[#["Avg num size"]] && #["Avg num size"] < baselineSize &
];

If[Length[improvements] > 0,
  Print["Found ", Length[improvements], " corrections that reduce magnitude:\n"];
  Do[
    reduction = 100 * (1 - result["Avg num size"]/baselineSize);
    Print["  ", result["Name"]];
    Print["    Reduction: ", NumberForm[reduction, {4, 1}], "%"];
    Print["    Stable? ", If[result["Stable ratio"] =!= "Unstable", "Yes (" <> ToString[result["Stable ratio"]] <> ")", "No"]];
    Print[""];
    ,
    {result, improvements}
  ];
  ,
  Print["No corrections reduce magnitude.\n"];
];

Print["Done!"];
