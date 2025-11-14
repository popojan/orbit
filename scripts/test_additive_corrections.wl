#!/usr/bin/env wolframscript
(* Test additive corrections to factorial terms *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Testing Additive Corrections to Factorial Formula"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

(* Test formula: Sum[(-1)^k · (k! + correction(k))/(2k+1)] *)

corrections = <|
  "No correction (baseline)" -> Function[k, 0],

  (* Polynomial corrections *)
  "Add k" -> Function[k, k],
  "Add k^2" -> Function[k, k^2],
  "Add -k" -> Function[k, -k],
  "Add -k^2" -> Function[k, -k^2],

  (* Lower factorial corrections *)
  "Add (k-1)!" -> Function[k, If[k >= 1, (k-1)!, 1]],
  "Add -(k-1)!" -> Function[k, If[k >= 1, -(k-1)!, -1]],
  "Subtract k·(k-1)!" -> Function[k, If[k >= 1, -k*(k-1)!, 0]],

  (* Binomial corrections *)
  "Add C(k,2)" -> Function[k, Binomial[k, 2]],
  "Add -C(2k,k)" -> Function[k, -Binomial[2k, k]],

  (* Powers of k *)
  "Add 2^k" -> Function[k, 2^k],
  "Add -2^k" -> Function[k, -2^k]
|>;

TestCorrection[name_, correction_, mMax_: 25] := Module[
  {results},

  results = Table[
    Module[{sum, denom, prim, numer, ratio},
      sum = Sum[(-1)^j * (j! + correction[j])/(2j+1), {j, 1, (m-1)/2}];
      denom = Denominator[sum];
      numer = Numerator[sum];
      prim = Primorial[m];
      ratio = prim/denom;

      {m, denom, prim, ratio, IntegerLength[Abs[numer]]}
    ],
    {m, 3, mMax, 2}
  ];

  (* Check for consistent ratio *)
  ratios = results[[All, 4]];
  numerSizes = results[[All, 5]];

  consistentRatio = If[Length[DeleteDuplicates[ratios]] <= 2,
    First[Sort[ratios]],
    "Inconsistent"
  ];

  <|
    "Name" -> name,
    "Consistent ratio" -> consistentRatio,
    "Avg numerator size" -> Mean[numerSizes],
    "Results" -> results
  |>
];

Print["Testing corrections (this may take a moment)...\n"];

testResults = KeyValueMap[
  Function[{name, correction},
    TestCorrection[name, correction, 25]
  ],
  corrections
];

(* Summary table *)
Print[StringRepeat["=", 70]];
Print["SUMMARY"];
Print[StringRepeat["=", 70], "\n"];

Print[Grid[
  Prepend[
    Table[
      {
        result["Name"],
        result["Consistent ratio"],
        NumberForm[result["Avg numerator size"], {4, 1}]
      },
      {result, testResults}
    ],
    {"Correction", "Primorial/Denominator", "Avg Num Digits"}
  ],
  Frame -> All,
  Alignment -> Left
]];

(* Find improvements *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["ANALYSIS: Do any corrections improve the formula?"];
Print[StringRepeat["=", 70], "\n"];

baseline = First[Select[testResults, #["Name"] == "No correction (baseline)" &]];
baselineSize = baseline["Avg numerator size"];

improvements = Select[testResults,
  #["Consistent ratio"] === 2 && #["Avg numerator size"] < baselineSize &
];

If[Length[improvements] > 0,
  Print["✓ Found ", Length[improvements], " corrections that reduce numerator size:\n"];
  Do[
    reduction = 100 * (1 - result["Avg numerator size"]/baselineSize);
    Print["  • ", result["Name"]];
    Print["    Reduction: ", NumberForm[reduction, {4, 1}], "%"];
    Print["    Avg digits: ", NumberForm[result["Avg numerator size"], {4, 1}],
          " vs ", NumberForm[baselineSize, {4, 1}], " baseline"];
    Print[""];
    ,
    {result, improvements}
  ];
  ,
  Print["✗ No corrections reduce numerator size while preserving Primorial/2\n"];
];

(* Check if any give different consistent denominators *)
Print[StringRepeat["=", 70]];
Print["Alternative consistent formulas (different ratios)"];
Print[StringRepeat["=", 70], "\n"];

alternatives = Select[testResults,
  IntegerQ[#["Consistent ratio"]] && #["Consistent ratio"] != 2 &
];

If[Length[alternatives] > 0,
  Do[
    Print["• ", result["Name"]];
    Print["  Gives: Primorial/", result["Consistent ratio"]];
    Print["  Missing primes: ",
          If[result["Consistent ratio"] > 1,
            FactorInteger[result["Consistent ratio"]][[All, 1]],
            "Extra factors"
          ]];
    Print[""];
    ,
    {result, alternatives}
  ];
];

Print["\nDone!"];
