#!/usr/bin/env wolframscript
(* Test factorial variants for partial primorials *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

(* Test variants *)
variants = <|
  "k!" -> Function[k, k!],
  "(k-1)!" -> Function[k, (k-1)!],
  "(k-2)!" -> Function[k, If[k >= 2, (k-2)!, 1]],
  "(k-3)!" -> Function[k, If[k >= 3, (k-3)!, 1]],
  "k(k-1)" -> Function[k, k*(k-1)],
  "k(k-1)(k-2)" -> Function[k, If[k >= 2, k*(k-1)*(k-2), k]]
|>;

TestVariant[name_, f_, mMax_: 25] := Module[
  {results},

  results = Table[
    Module[{sum, denom, prim, ratio, ratioFactored},
      sum = Sum[(-1)^j * f[j]/(2j+1), {j, 1, (m-1)/2}];
      denom = Denominator[sum];
      prim = Primorial[m];
      ratio = prim/denom;
      ratioFactored = If[IntegerQ[ratio] && ratio > 0, FactorInteger[ratio], "N/A"];

      {m, denom, prim, ratio, ratioFactored}
    ],
    {m, 3, mMax, 2}
  ];

  <|
    "Name" -> name,
    "Results" -> results
  |>
];

Print["=" ~~ StringRepeat["=", 70]];
Print["Testing Factorial Variants for Partial Primorials"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

testResults = KeyValueMap[
  Function[{name, f},
    Print["Testing: ", name];
    result = TestVariant[name, f, 25];

    Print["m | Denominator | Primorial | Ratio | Missing Primes"];
    Print[StringRepeat["-", 70]];

    Do[
      {m, denom, prim, ratio, factored} = row;
      Print[m, " | ", denom, " | ", prim, " | ", ratio, " | ", factored];
      ,
      {row, result["Results"]}
    ];

    (* Analyze pattern *)
    ratios = result["Results"][[All, 4]];
    factorizations = result["Results"][[All, 5]];

    (* Check if ratios are consistent *)
    integerRatios = Select[ratios, IntegerQ[#] && # > 0 &];
    uniqueRatios = DeleteDuplicates[integerRatios];

    Print["\nPattern Analysis:"];
    If[Length[uniqueRatios] == 1 && uniqueRatios[[1]] > 1,
      Print["  ✓ Consistent ratio: ", uniqueRatios[[1]]];
      Print["  ✓ Missing primes: ", FactorInteger[uniqueRatios[[1]]][[All, 1]]];
      Print["  ✓ Formula gives: Primorial/", uniqueRatios[[1]]];
      ,
      If[AllTrue[ratios, # == 1 &],
        Print["  ✓ Gives FULL primorial"];
        ,
        Print["  ✗ Inconsistent or non-integer ratios"];
        Print["  Unique ratios: ", Take[uniqueRatios, UpTo[5]]];
      ]
    ];

    Print["\n"];
    result
  ],
  variants
];

Print["=" ~~ StringRepeat["=", 70]];
Print["SUMMARY"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

Do[
  Module[{name, results, ratios, uniqueRatios},
    name = result["Name"];
    results = result["Results"];
    ratios = results[[All, 4]];
    uniqueRatios = DeleteDuplicates[Select[ratios, IntegerQ[#] && # > 0 &]];

    Print[name, ":"];
    If[Length[uniqueRatios] == 1,
      If[uniqueRatios[[1]] == 1,
        Print["  → Full primorial"];
        ,
        Print["  → Primorial/", uniqueRatios[[1]],
              " (missing ", FactorInteger[uniqueRatios[[1]]][[All, 1]], ")"];
      ];
      ,
      Print["  → Inconsistent/Failed"];
    ];
  ];
  ,
  {result, testResults}
];

Print["\nDone!"];
