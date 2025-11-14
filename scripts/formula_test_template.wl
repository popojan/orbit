#!/usr/bin/env wolframscript
(* Template for testing primorial formula variations *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

(* ====================================================================== *)
(* DEFINE YOUR FORMULAS HERE - Add as many as you want *)
(* ====================================================================== *)

formulas = <|
  "Original" -> Function[m,
    (1/2) * Sum[(-1)^k * k! / (2k + 1), {k, 1, Floor[(m - 1)/2]}]
  ],

  "No alternating (1/6)" -> Function[m,
    (1/6) * Sum[k! / (2k + 1), {k, 1, Floor[(m - 1)/2]}]
  ],

  "Extra /2k division" -> Function[m,
    Sum[(-1)^k * k! / (2k + 1) / (2k), {k, 1, Floor[(m - 1)/2]}]
  ],

  "Fractional part" -> Function[m,
    Sum[Mod[(-1)^k * k! / (2k + 1) / (2k), 1], {k, 1, Floor[(m - 1)/2]}]
  ],

  (* Add more formulas here *)
  "Example: k-1 factorial" -> Function[m,
    Sum[(-1)^k * (k - 1)! / (2k + 1), {k, 1, Floor[(m - 1)/2]}]
  ]
|>;

(* ====================================================================== *)
(* TEST CONFIGURATION *)
(* ====================================================================== *)

(* Which m values to test *)
testRange = Range[3, 21, 2];  (* Odd values from 3 to 21 *)

(* Which formulas to test (comment out to test all) *)
(* formulasToTest = {"Original", "Extra /2k division", "Fractional part"}; *)
formulasToTest = Keys[formulas];  (* Test all *)

(* ====================================================================== *)
(* TESTING INFRASTRUCTURE - DON'T MODIFY *)
(* ====================================================================== *)

TestFormula[name_, formula_, m_] := Module[
  {result, prim, denom, num, numSize},

  result = Quiet[formula[m]];
  prim = Primorial[m];
  denom = Denominator[result];
  num = Numerator[result];
  numSize = If[num == 0, 0, IntegerLength[Abs[num]]];

  <|
    "Formula" -> name,
    "m" -> m,
    "Numerator" -> num,
    "Num digits" -> numSize,
    "Denominator" -> denom,
    "Primorial" -> prim,
    "Denom = Prim?" -> (denom == prim),
    "Denom / Prim" -> N[denom / prim],
    "Result" -> result
  |>
];

(* Run all tests *)
Print["=" ~~ StringRepeat["=", 70]];
Print["Testing ", Length[formulasToTest], " formulas on ", Length[testRange], " values"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

results = Flatten[Table[
  TestFormula[name, formulas[name], m],
  {name, formulasToTest},
  {m, testRange}
], 1];

(* ====================================================================== *)
(* ANALYSIS AND REPORTING *)
(* ====================================================================== *)

(* Group by formula *)
Print["Summary by formula:\n"];
Do[
  Module[{formulaResults, successes, failures},
    formulaResults = Select[results, #["Formula"] == name &];
    successes = Count[formulaResults, _?(#["Denom = Prim?"] &)];
    failures = Length[formulaResults] - successes;

    Print[name, ":"];
    Print["  Success rate: ", successes, "/", Length[formulaResults]];
    If[successes > 0,
      Print["  Avg numerator size: ",
        Mean[Select[formulaResults, #["Denom = Prim?"] &][[All, "Num digits"]]], " digits"]
    ];
    If[failures > 0,
      Print["  Failed at m = ", Select[formulaResults, !#["Denom = Prim?"] &][[All, "m"]]]
    ];
    Print[""];
  ],
  {name, formulasToTest}
];

(* Detailed comparison table *)
Print["\n", "=" ~~ StringRepeat["=", 70]];
Print["Detailed Results"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

comparisonTable = Dataset[results[[ All, {"Formula", "m", "Num digits", "Denom = Prim?", "Denom / Prim"} ]]];
Print[comparisonTable];

(* Find best formula (smallest numerators among working formulas) *)
Print["\n", "=" ~~ StringRepeat["=", 70]];
Print["Best Formulas (by numerator size)"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

workingResults = Select[results, #["Denom = Prim?"] &];
If[Length[workingResults] > 0,
  avgSizes = GroupBy[workingResults, #["Formula"] &, Mean[#[[All, "Num digits"]]] &];
  sorted = Reverse @ SortBy[Normal[avgSizes], Last];
  Do[
    Print[i, ". ", formula, ": avg ", Round[size, 0.1], " digits"],
    {i, 1}, {formula, size} = sorted
  ];
,
  Print["No working formulas found!"];
];

(* Export detailed results *)
exportFile = "reports/formula_comparison_results.json";
Export[exportFile, results];
Print["\nDetailed results exported to: ", exportFile];
