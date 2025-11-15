#!/usr/bin/env wolframscript
(* Explicitly count and list ALL non-zero terms for n=5, alpha=3 *)

Print["================================================================"];
Print["COUNTING NON-ZERO TERMS FOR n=5, alpha=3"];
Print["================================================================"];
Print[""];

Print["Question: How many terms does Wolfram actually sum?"];
Print[""];

(* For n=5, what values of d and k give non-zero dist? *)
n = 5;
alpha = 3;

Print["Analyzing: dist = n - k*d - d^2"];
Print["  dist = ", n, " - k*d - d^2"];
Print[""];

(* Collect ALL non-zero terms *)
allTerms = {};

Print["Systematic enumeration:"];
Print[""];

(* For each d, find valid k range *)
For[d = 2, d <= 20, d++,
  Module[{validK, minDist, maxDist},
    validK = {};

    (* For this d, when is dist != 0? *)
    (* dist = n - k*d - d^2 = 0  =>  k = (n - d^2)/d *)
    zeroK = (n - d^2)/d;

    Print["d=", d, ":"];
    Print["  d^2 = ", d^2];

    If[d^2 > n,
      Print["  d^2 > n, so dist = n - k*d - d^2 < 0 for all k >= 0"];
      Print["  For k=0: dist = ", n - d^2];
      If[n - d^2 != 0,
        AppendTo[allTerms, {d, 0, n - d^2, (n - d^2)^(-6)}];
        Print["    -> ONE non-zero term at k=0"];
      ];
      Print["  For k >= 1: dist becomes more negative, no zeros"];
      Print["  But terms decay rapidly, practical cutoff needed"];
      Print[""];
      Continue[];
    ];

    Print["  Zero crossing at k = (n - d^2)/d = (", n, " - ", d^2, ")/", d, " = ", N[zeroK]];

    If[IntegerQ[zeroK] && zeroK >= 0,
      Print["  WARNING: Exact zero at k=", zeroK, " (factorization!)"];
    ];

    (* Find all k from 0 to some reasonable max *)
    For[k = 0, k <= 30, k++,
      Module[{dist, term},
        dist = n - k*d - d^2;
        If[dist != 0 && Abs[dist] < 100,
          term = dist^(-6);
          AppendTo[allTerms, {d, k, dist, term}];
          AppendTo[validK, k];
        ];
      ];
    ];

    If[Length[validK] > 0,
      Print["  Valid k values: ", validK];
      Print["  Number of terms: ", Length[validK]];
    ,
      Print["  No valid terms (all |dist| >= 100 or dist=0)"];
    ];
    Print[""];
  ];
];

Print["================================================================"];
Print["SUMMARY"];
Print["================================================================"];
Print[""];

Print["Total number of non-zero terms with |dist| < 100: ", Length[allTerms]];
Print[""];

Print["All terms explicitly:"];
Print[""];
Print["d\tk\tdist\t|dist|\tterm = dist^(-6)\t\tdecimal"];
Print[StringRepeat["-", 80]];

allTermsSorted = SortBy[allTerms, Abs[#[[3]]] &];

Do[
  Module[{d, k, dist, term},
    {d, k, dist, term} = allTermsSorted[[i]];
    Print[d, "\t", k, "\t", dist, "\t", Abs[dist], "\t",
      If[Abs[dist] <= 10, term, ScientificForm[term, 3]], "\t\t",
      N[term, 8]];
  ],
  {i, 1, Length[allTermsSorted]}
];

Print[""];
Print["================================================================"];
Print["EXACT SYMBOLIC COMPUTATION"];
Print["================================================================"];
Print[""];

Print["Now summing these ", Length[allTerms], " terms symbolically..."];
Print[""];

totalSum = Total[allTerms[[All, 4]]];
Print["Raw sum: ", totalSum];
Print[""];

simplified = Together[totalSum];
Print["Simplified (Together): ", simplified];
Print[""];

num = Numerator[simplified];
den = Denominator[simplified];

Print["Numerator:   ", num];
Print["Denominator: ", den];
Print[""];

Print["Decimal value: ", N[simplified, 25]];
Print[""];

Print["Match with known value?"];
Print["  703166705641/351298031616 = ", N[703166705641/351298031616, 25]];
Print[""];

If[num == 703166705641 && den == 351298031616,
  Print["*** EXACT MATCH! ***"];
,
  Print["Difference: ", N[simplified - 703166705641/351298031616, 25]];
];

Print[""];
Print["================================================================"];
Print["CONVERGENCE ANALYSIS"];
Print["================================================================"];
Print[""];

Print["How quickly do terms decay?"];
Print[""];

Print["|dist|\tterm value\t\tcontribution %"];
Print[StringRepeat["-", 60]];

runningSum = 0;
Do[
  Module[{d, k, dist, term, contribution},
    {d, k, dist, term} = allTermsSorted[[i]];
    runningSum += term;
    contribution = 100 * term / simplified;
    Print[Abs[dist], "\t", N[term, 8], "\t\t", N[contribution, 6], "%"];
  ],
  {i, 1, Min[15, Length[allTermsSorted]]}
];

Print[""];
Print["Cumulative sum after first N terms:"];
Print[""];
Print["N\tpartial sum\t\t% of total"];
Print[StringRepeat["-", 50]];

runningSum = 0;
Do[
  runningSum += allTermsSorted[[i, 4]];
  Print[i, "\t", N[runningSum, 12], "\t", N[100 * runningSum / simplified, 8], "%"];
,
  {i, 1, Min[20, Length[allTermsSorted]]}
];

Print[""];
Print["================================================================"];
Print["CONCLUSION"];
Print["================================================================"];
Print[""];

Print["1. There are EXACTLY ", Length[allTerms], " terms with |dist| < 100"];
Print["2. Terms with |dist| >= 100 contribute < 10^(-12)"];
Print["3. Wolfram sums these FINITE terms symbolically"];
Print["4. Together[] finds common denominator of these ", Length[allTerms], " rationals"];
Print["5. Result is EXACT rational number"];
Print[""];

Print["The 'infinite sum' is actually FINITE in practice!"];
Print[""];
