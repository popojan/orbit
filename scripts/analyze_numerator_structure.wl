#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Analyze numerator structure to understand GCD cancellation *)

Print["=== NUMERATOR STRUCTURE ANALYSIS ===\n"];

(* Helper *)
PrimePower[n_, p_] := If[n == 0, Infinity,
  Module[{fi = FactorInteger[Abs[n]]},
    SelectFirst[fi, #[[1]] == p &, {0, 0}][[2]]
  ]
];

(* Examine GCD between consecutive partial sums *)
AnalyzeGCDPattern[m_] := Module[{
    h, terms, partialSums, data
  },
  h = Floor[(m - 1)/2];

  Print["Analyzing GCD patterns for m = ", m, "\n"];

  terms = Table[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];
  partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];

  Print["Step-by-step addition analysis:\n"];
  Print["k\t2k+1\tNum[k]\tDen[k]\tGCD(Num[k], Den[k])\tAny common factors?"];
  Print[StringRepeat["-", 100]];

  Do[
    Module[{num, den, gcd},
      num = Abs[Numerator[partialSums[[k]]]];
      den = Denominator[partialSums[[k]]];
      gcd = GCD[num, den];
      Print[k, "\t", 2*k+1, "\t", num, "\t", den, "\t", gcd, "\t\t",
        If[gcd == 1, "NO - coprime ✓", "YES - " <> ToString[FactorInteger[gcd]]]
      ]
    ],
    {k, 1, Min[12, h]}
  ];

  If[h > 12, Print["..."]];
  Print["\n"];
];

AnalyzeGCDPattern[23];

(* Look at what happens when adding individual terms *)
AnalyzeTermAddition[m_, k_] := Module[{
    terms, prevSum, newTerm, prevNum, prevDen, termNum, termDen,
    combinedNum, combinedDen, gcd, reducedNum, reducedDen
  },

  Print["=== DETAILED ADDITION AT STEP k = ", k, " (m = ", m, ") ===\n"];

  terms = Table[(-1)^i * (i!)/(2*i + 1), {i, 1, k}];

  prevSum = If[k == 1, 0, Sum[1/2 * terms[[i]], {i, 1, k-1}]];
  newTerm = 1/2 * terms[[k]];

  prevNum = If[k == 1, 0, Numerator[prevSum]];
  prevDen = If[k == 1, 1, Denominator[prevSum]];
  termNum = Numerator[newTerm];
  termDen = Denominator[newTerm];

  Print["Previous partial sum: ", prevNum, "/", prevDen];
  Print["New term to add: ", termNum, "/", termDen];
  Print["Term denominator 2k+1 = ", 2*k+1, " = ", FactorInteger[2*k+1], "\n"];

  (* Before reduction *)
  combinedNum = prevNum * termDen + termNum * prevDen;
  combinedDen = prevDen * termDen;

  Print["Before GCD reduction:"];
  Print["  Numerator: ", combinedNum];
  Print["  Denominator: ", combinedDen];
  Print["  Denom factorization: ", FactorInteger[combinedDen], "\n"];

  (* After reduction *)
  gcd = GCD[Abs[combinedNum], combinedDen];
  reducedNum = combinedNum / gcd;
  reducedDen = combinedDen / gcd;

  Print["GCD: ", gcd];
  Print["GCD factorization: ", FactorInteger[gcd], "\n"];

  Print["After GCD reduction:"];
  Print["  Numerator: ", reducedNum];
  Print["  Denominator: ", reducedDen];
  Print["  Denom factorization: ", FactorInteger[reducedDen], "\n"];

  (* Check which prime powers got cancelled *)
  beforeFactors = FactorInteger[combinedDen];
  afterFactors = FactorInteger[reducedDen];

  Print["Powers that decreased:"];
  Do[
    Module[{p = beforeFactors[[i, 1]], powBefore, powAfter},
      powBefore = beforeFactors[[i, 2]];
      powAfter = SelectFirst[afterFactors, #[[1]] == p &, {0, 0}][[2]];
      If[powAfter < powBefore,
        Print["  ", p, ": ", powBefore, " → ", powAfter,
          " (cancelled ", p, "^", powBefore - powAfter, ")"]
      ]
    ],
    {i, Length[beforeFactors]}
  ];

  Print["\n"];
];

(* Examine steps where 2k+1 has prime powers *)
Print["=== EXAMINING STEPS WITH PRIME POWERS IN DENOMINATOR ===\n"];

(* k=4: 2k+1 = 9 = 3² *)
AnalyzeTermAddition[13, 4];

(* k=12: 2k+1 = 25 = 5² *)
AnalyzeTermAddition[25, 12];

(* k=13: 2k+1 = 27 = 3³ *)
AnalyzeTermAddition[27, 13];

(* === Look for patterns in numerator primality === *)
Print["=== NUMERATOR PRIMALITY ANALYSIS ===\n"];

AnalyzeNumeratorPrimality[mmax_] := Module[{
    results
  },
  Print["Checking numerator primality up to m = ", mmax, "\n"];

  results = Flatten[Table[
    Module[{h, terms, partialSums, data},
      h = Floor[(m - 1)/2];
      terms = Table[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];
      partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];

      Table[{
        m, k,
        Abs[Numerator[partialSums[[k]]]],
        PrimeQ[Abs[Numerator[partialSums[[k]]]]]
      }, {k, 1, h}]
    ],
    {m, 3, mmax, 2}
  ], 1];

  primeCount = Count[results, {_, _, _, True}];
  totalCount = Length[results];

  Print["Total numerators checked: ", totalCount];
  Print["Prime numerators: ", primeCount, " (",
    N[100.0 * primeCount / totalCount], "%)"];
  Print["Composite numerators: ", totalCount - primeCount, "\n"];

  Print["First 20 numerators (showing if prime):"];
  Print["m\tk\tNumerator\t\t\tPrime?"];
  Print[StringRepeat["-", 80]];
  Do[
    Print[results[[i, 1]], "\t", results[[i, 2]], "\t",
      results[[i, 3]], "\t\t",
      If[results[[i, 4]], "YES ✓", "no"]
    ],
    {i, 1, Min[20, Length[results]]}
  ];

  Print["\n"];
];

AnalyzeNumeratorPrimality[15];

Print["=== ANALYSIS COMPLETE ==="];
