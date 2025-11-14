#!/usr/bin/env wolframscript
(* Test non-alternating formulas for predictable numerator structure *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Testing Non-Alternating Formulas: Are Numerators Predictable?"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

Print["HYPOTHESIS: Alternating sign creates chaotic cancellations."];
Print["Without it, numerators might be predictable!\n"];

(* Test non-alternating versions *)
formulas = <|
  "Baseline (alternating)" -> {Function[k, (-1)^k * k!], 1/2},

  (* Non-alternating *)
  "No alternation: k!" -> {Function[k, k!], 1},
  "No alternation: k!/6" -> {Function[k, k!/6], 1},

  (* Try corrections without alternation *)
  "No alt: (k-1)!" -> {Function[k, If[k>=1, (k-1)!, 1]], 1},
  "No alt: k!/2" -> {Function[k, k!/2], 1},
  "No alt: k! - k" -> {Function[k, k! - k], 1},
  "No alt: k! - k^2" -> {Function[k, k! - k^2], 1},

  (* Even/odd k only *)
  "Even k only: (-1)^k k!" -> {Function[k, If[EvenQ[k], k!, 0]], 1/2},
  "Odd k only: (-1)^k k!" -> {Function[k, If[OddQ[k], -k!, 0]], 1/2}
|>;

TestFormula[name_, f_, prefactor_, mMin_: 3, mMax_: 31] := Module[
  {results, numerators, denominators},

  results = Table[
    Module[{sum, denom, numer, prim, ratio},
      sum = prefactor * Sum[f[j]/(2j+1), {j, 1, (m-1)/2}];
      denom = Denominator[sum];
      numer = Numerator[sum];
      prim = Primorial[m];
      ratio = prim/denom;

      {m, denom, prim, ratio, numer, IntegerLength[Abs[numer]]}
    ],
    {m, mMin, mMax, 2}
  ];

  numerators = results[[All, 5]];
  denominators = results[[All, 2]];
  ratios = results[[All, 4]];

  (* Check stability *)
  lastRatios = If[Length[ratios] >= 5, Take[ratios, -5], ratios];
  isStable = Length[DeleteDuplicates[lastRatios]] == 1;
  stableRatio = If[isStable, Last[ratios], "Unstable"];
  stableFrom = If[isStable,
    Module[{i},
      For[i = 1, i <= Length[ratios], i++,
        If[Length[DeleteDuplicates[ratios[[i;;]]]] == 1,
          Return[results[[i, 1]]]
        ]
      ];
      results[[1, 1]]
    ],
    "N/A"
  ];

  (* Analyze numerator patterns *)

  (* 1. Growth ratios *)
  numRatios = Table[
    If[numerators[[i]] != 0 && numerators[[i+1]] != 0,
      N[numerators[[i+1]] / numerators[[i]], 4],
      Missing[]
    ],
    {i, 1, Length[numerators]-1}
  ];
  validNumRatios = DeleteMissing[numRatios];

  (* 2. Differences (arithmetic?) *)
  diffs = Differences[numerators];
  secondDiffs = If[Length[diffs] > 1, Differences[diffs], {}];

  (* 3. Check for simple patterns *)
  allPrime = AllTrue[Select[Abs[numerators], # > 1 &], PrimeQ];
  allEven = AllTrue[numerators, EvenQ];
  allDivByConst = Module[{gcd = GCD @@ numerators},
    If[gcd > 1, gcd, Nothing]
  ];

  (* 4. Factorizations *)
  factorizations = Table[
    If[Abs[n] > 1 && Abs[n] < 10^8,
      FactorInteger[Abs[n]],
      "TooLarge"
    ],
    {n, Take[numerators, UpTo[6]]}
  ];

  <|
    "Name" -> name,
    "Stable ratio" -> stableRatio,
    "Stable from" -> stableFrom,
    "Sample numerators" -> Take[numerators, UpTo[8]],
    "Avg num size" -> Mean[results[[All, 6]]],
    "Growth mean" -> If[Length[validNumRatios] > 0, Mean[validNumRatios], "N/A"],
    "Growth stddev" -> If[Length[validNumRatios] > 0, StandardDeviation[validNumRatios], "N/A"],
    "All prime?" -> allPrime,
    "All even?" -> allEven,
    "Common divisor" -> allDivByConst,
    "First diffs" -> Take[diffs, UpTo[6]],
    "Second diffs" -> Take[secondDiffs, UpTo[5]],
    "Factorizations" -> factorizations
  |>
];

Print["Testing formulas...\n"];

testResults = KeyValueMap[
  Function[{name, params},
    {f, prefactor} = params;
    Print["  ", name];
    TestFormula[name, f, prefactor, 3, 31]
  ],
  formulas
];

(* Summary table *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["SUMMARY: Stability and Patterns"];
Print[StringRepeat["=", 70], "\n"];

Print[Grid[
  Prepend[
    Table[
      {
        result["Name"],
        result["Stable ratio"],
        result["Stable from"],
        NumberForm[result["Avg num size"], {4, 1}],
        If[result["All prime?"], "ALL PRIME", ""],
        If[result["All even?"], "ALL EVEN", ""]
      },
      {result, testResults}
    ],
    {"Formula", "Stable Ratio", "From m", "Avg Digits", "Pattern?", ""}
  ],
  Frame -> All,
  Alignment -> Left
]];

(* Detailed analysis *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["DETAILED PATTERN ANALYSIS"];
Print[StringRepeat["=", 70], "\n"];

Do[
  Print["━━━ ", result["Name"], " ━━━"];
  Print["Stable: ", result["Stable ratio"], " from m=", result["Stable from"]];
  Print["Numerators: ", result["Sample numerators"]];

  If[result["All prime?"],
    Print["★ ALL NUMERATORS ARE PRIME! ★"];
  ];

  If[result["All even?"],
    Print["★ ALL NUMERATORS ARE EVEN! ★"];
  ];

  If[result["Common divisor"] =!= Nothing,
    Print["★ Common divisor: ", result["Common divisor"], " ★"];
  ];

  Print["First differences: ", result["First diffs"]];
  If[Length[result["Second diffs"]] > 0,
    Print["Second differences: ", result["Second diffs"]];

    (* Check if second diffs constant *)
    If[Length[DeleteDuplicates[result["Second diffs"]]] == 1,
      Print["→ QUADRATIC SEQUENCE! a·m² + b·m + c form"];
    ];
  ];

  Print["Growth factor: ", result["Growth mean"],
        " (σ=", result["Growth stddev"], ")"];

  If[NumericQ[result["Growth stddev"]] && result["Growth stddev"] < 1,
    Print["→ Nearly geometric progression!");
  ];

  Print["Factorizations: "];
  Do[
    If[fact =!= "TooLarge",
      Print["  ", fact];
    ];
    ,
    {fact, result["Factorizations"]}
  ];

  Print[""];
  ,
  {result, testResults}
];

Print[StringRepeat["=", 70]];
Print["CONCLUSION"];
Print[StringRepeat["=", 70], "\n"];

(* Check if any formula has predictable numerators *)
predictable = Select[testResults,
  #["All prime?"] ||
  #["All even?"] ||
  #["Common divisor"] =!= Nothing ||
  (NumericQ[#["Growth stddev"]] && #["Growth stddev"] < 1) &
];

If[Length[predictable] > 0,
  Print["✓✓✓ BREAKTHROUGH: Found ", Length[predictable], " formulas with pattern!\n"];
  Do[
    Print["• ", result["Name"]];
    ,
    {result, predictable}
  ];
  ,
  Print["✗ No clear patterns found in numerators, even without alternation.\n"];
  Print["The unpredictability seems fundamental to the primorial structure."];
];

Print["\nDone!"];
