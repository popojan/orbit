#!/usr/bin/env wolframscript
(* Systematic testing of factorial variants for primorial formulas *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

(* ============================================ *)
(* DEFINE FACTORIAL VARIANTS *)
(* ============================================ *)

variants = <|
  "Original k!" -> Function[k, k!],

  "Falling k(k-1)" -> Function[k, k*(k-1)],
  "Falling k(k-1)(k-2)" -> Function[k, k*(k-1)*(k-2)],
  "Falling k!/(k-2)!" -> Function[k, k!/(k-2)!],

  "(k-1)!" -> Function[k, (k-1)!],
  "(k-1)! if k>1" -> Function[k, If[k>1, (k-1)!, 1]],

  "Central binomial C(2k,k)" -> Function[k, Binomial[2k, k]],

  "Odd double factorial (2k-1)!!" -> Function[k,
    Product[2j-1, {j, 1, k}]
  ],

  "k! / 2^ν_2(k!)" -> Function[k,
    k! / 2^IntegerExponent[k!, 2]
  ],

  "k! - k(k-1)!" -> Function[k, If[k==1, 1, k! - k*(k-1)!]],

  "Linear: k! - (k-1)(k-1)!" -> Function[k,
    If[k==1, 1, k! - (k-1)*(k-1)!]
  ],

  "(k!)^2" -> Function[k, (k!)^2]
|>;

(* ============================================ *)
(* TEST FRAMEWORK *)
(* ============================================ *)

TestVariant[name_, f_, mMax_: 21] := Module[
  {results, primorialMatches, numeratorSizes},

  results = Table[
    Module[{sum, denom, prim},
      sum = (1/2) * Sum[(-1)^j * f[j]/(2j+1), {j, 1, (m-1)/2}];
      denom = Denominator[sum];
      prim = Primorial[m];

      {m, denom, prim, denom == prim, Numerator[sum], IntegerLength[Abs[Numerator[sum]]]}
    ],
    {m, 3, mMax, 2}
  ];

  primorialMatches = Count[results, {_, _, _, True, _, _}];
  numeratorSizes = Mean[results[[All, 6]]];

  <|
    "Name" -> name,
    "Success rate" -> primorialMatches <> "/" <> ToString[Length[results]],
    "Avg num digits" -> N[numeratorSizes],
    "First failure at m" -> SelectFirst[results, !#[[4]]&, {"None"}][[1]],
    "Details" -> results[[All, {1, 4, 6}]]
  |>
];

(* ============================================ *)
(* RUN TESTS *)
(* ============================================ *)

Print["=" ~~ StringRepeat["=", 70]];
Print["Testing Factorial Variants for Primorial Formulas"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

testResults = KeyValueMap[
  Function[{name, f},
    Print["Testing: ", name];
    TestVariant[name, f, 21]
  ],
  variants
];

(* ============================================ *)
(* SUMMARY REPORT *)
(* ============================================ *)

Print["\n", "=" ~~ StringRepeat["=", 70]];
Print["SUMMARY"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

(* Sort by success rate *)
sorted = SortBy[testResults, -ToExpression[StringSplit[#["Success rate"], "/"][[1]]]&];

Print["Ranked by success rate:\n"];
Do[
  Print[i, ". ", result["Name"]];
  Print["   Success: ", result["Success rate"]];
  Print["   Avg numerator size: ", Round[result["Avg num digits"], 0.1], " digits"];
  If[result["First failure at m"] != "None",
    Print["   First failure: m = ", result["First failure at m"]]
  ];
  Print[""];
  ,
  {i, 1},
  {result, sorted}
];

(* ============================================ *)
(* DETAILED ANALYSIS OF WINNERS *)
(* ============================================ *)

winners = Select[testResults,
  ToExpression[StringSplit[#["Success rate"], "/"][[1]]] == 10 &
];

If[Length[winners] > 0,
  Print["\n", "=" ~~ StringRepeat["=", 70]];
  Print["PERFECT CANDIDATES (100% success)"];
  Print["=" ~~ StringRepeat["=", 70], "\n"];

  Do[
    Print["Variant: ", winner["Name"]];
    Print["Numerator sizes by m:"];
    Print[Grid[winner["Details"], Frame -> All,
      Headings -> {None, {"m", "Match?", "Digits"}}]];
    Print[""];
    ,
    {winner, winners}
  ];
];

(* ============================================ *)
(* FACTORIAL INEQUALITY CHECK *)
(* ============================================ *)

Print["\n", "=" ~~ StringRepeat["=", 70]];
Print["FACTORIAL INEQUALITY CHECK"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

Print["For successful variants, checking: ν_p(f(k)) ≥ ν_p(2k+1) - 1\n"];

CheckFactorialInequality[f_, kMax_: 20] := Module[{violations},
  violations = Flatten[Table[
    Module[{n = 2k+1, primes, checks},
      primes = Select[FactorInteger[n][[All, 1]], # >= 3 &];
      checks = Table[
        Module[{alpha, nuF, inequality},
          alpha = IntegerExponent[n, p];
          If[alpha >= 2,
            nuF = IntegerExponent[f[k], p];
            inequality = nuF >= alpha - 1;
            If[!inequality,
              {k, n, p, alpha, nuF, alpha - 1},
              Nothing
            ],
            Nothing
          ]
        ],
        {p, primes}
      ];
      checks
    ],
    {k, 1, kMax}
  ], 1];

  If[Length[violations] == 0,
    "✓ No violations found",
    violations
  ]
];

Do[
  If[winner["Success rate"] == "10/10",
    Module[{f, check},
      f = variants[winner["Name"]];
      Print["Checking: ", winner["Name"]];
      check = CheckFactorialInequality[f, 15];
      If[check === "✓ No violations found",
        Print["  ", check],
        Print["  Violations: ", check]
      ];
      Print[""];
    ]
  ],
  {winner, testResults}
];

Print["\nDone!"];
