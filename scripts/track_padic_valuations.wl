#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Track p-adic valuations through primorial formula partial sums *)

Print["=== P-ADIC VALUATION TRACKER ===\n"];

(* Helper: Get p-adic valuation of an integer *)
PrimePower[n_, p_] := If[n == 0, Infinity,
  Module[{fi = FactorInteger[Abs[n]]},
    SelectFirst[fi, #[[1]] == p &, {0, 0}][[2]]
  ]
];

(* Track a single prime through the partial sums *)
TrackPrimeValuation[m_, p_] := Module[{
    h, terms, partialSums, data
  },
  h = Floor[(m - 1)/2];

  Print["Tracking prime p = ", p, " through m = ", m];
  Print["Number of terms: h = ", h, "\n"];

  (* Build partial sums *)
  terms = Table[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];
  partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];

  (* Extract valuations *)
  data = Table[{
    k,
    2*k + 1,
    PrimeQ[2*k + 1],
    PrimePower[2*k + 1, p],           (* v_p(2k+1) *)
    Numerator[partialSums[[k]]],
    Denominator[partialSums[[k]]],
    PrimePower[Numerator[partialSums[[k]]], p],    (* v_p(numerator) *)
    PrimePower[Denominator[partialSums[[k]]], p]   (* v_p(denominator) *)
  }, {k, 1, h}];

  Print["k\t2k+1\tPrime?\tv_p(2k+1)\tNumerator\tDenominator\tv_p(num)\tv_p(den)"];
  Print[StringRepeat["-", 120]];

  Do[
    Module[{row = data[[i]]},
      Print[row[[1]], "\t", row[[2]], "\t",
        If[row[[3]], "YES", "no"], "\t",
        row[[4]], "\t\t",
        row[[5]], "\t\t", row[[6]], "\t\t",
        row[[7]], "\t", row[[8]]
      ]
    ],
    {i, 1, Min[20, Length[data]]}
  ];

  If[Length[data] > 20, Print["... (showing first 20 rows)"]];
  Print["\nFinal denominator valuation: v_", p, "(denom) = ",
    Last[data][[8]]];
  Print[""];

  data
];

(* Look for patterns in valuation evolution *)
AnalyzeValuationPattern[m_, p_] := Module[{
    data, denoms, changes
  },
  Print["=== VALUATION PATTERN ANALYSIS ==="];
  Print["m = ", m, ", p = ", p, "\n"];

  data = TrackPrimeValuation[m, p];
  denoms = data[[All, 8]];  (* v_p(denominator) column *)

  (* Find where denominator valuation changes *)
  changes = Position[Differences[denoms], Except[0]] // Flatten;

  Print["Denominator valuation changes at steps: ", changes];
  Print["\nDetails of changes:"];
  Print["k\t2k+1\tv_p(2k+1)\tv_p(den)[k-1]\tv_p(den)[k]\tChange"];
  Print[StringRepeat["-", 80]];

  Do[
    Module[{k = step, prev, curr, change},
      prev = If[k == 1, 0, denoms[[k-1]]];
      curr = denoms[[k]];
      change = curr - prev;
      Print[k, "\t", 2*k+1, "\t", data[[k, 4]], "\t\t",
        prev, "\t\t", curr, "\t\t",
        If[change > 0, "+" <> ToString[change], ToString[change]]
      ]
    ],
    {step, changes}
  ];

  Print["\n"];

  (* Check hypothesis: does v_p(denom) increase when p | (2k+1)? *)
  divisibleSteps = Select[Range[Length[data]],
    data[[#, 4]] > 0 &];  (* Steps where p | (2k+1) *)

  If[Length[divisibleSteps] > 0,
    Print["Steps where p divides (2k+1): ", divisibleSteps];
    Print["Checking if denominator valuation increases at these steps..."];
    Do[
      Module[{k = step, prev, curr},
        prev = If[k == 1, 0, denoms[[k-1]]];
        curr = denoms[[k]];
        Print["  k=", k, ": v_p(", 2*k+1, ") = ", data[[k, 4]],
          ", v_p(denom) ", prev, " → ", curr,
          If[curr > prev, " ✓ INCREASE", " ✗ no change"]
        ]
      ],
      {step, divisibleSteps}
    ];
    Print[""];
  ];
];

(* Track multiple primes simultaneously *)
TrackMultiplePrimes[m_, primes_List] := Module[{
    h, terms, partialSums, data
  },
  h = Floor[(m - 1)/2];

  Print["=== MULTI-PRIME TRACKING ==="];
  Print["m = ", m, ", tracking primes: ", primes, "\n"];

  terms = Table[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];
  partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];

  Print["k\t2k+1\t",
    StringJoin[Riffle[Map["v_" <> ToString[#] <> "(den)" &, primes], "\t"]]
  ];
  Print[StringRepeat["-", 40 + 12*Length[primes]]];

  Do[
    Module[{den = Denominator[partialSums[[k]]],
        vals},
      vals = Map[PrimePower[den, #] &, primes];
      Print[k, "\t", 2*k + 1, "\t",
        StringJoin[Riffle[Map[ToString, vals], "\t"]]
      ]
    ],
    {k, 1, Min[15, h]}
  ];

  If[h > 15, Print["... (showing first 15 rows)"]];
  Print["\n"];
];

(* === RUN ANALYSES === *)

(* Example 1: Track p=3 through m=13 *)
AnalyzeValuationPattern[13, 3];

(* Example 2: Track p=3 through m=27 to see higher powers *)
Print["\n=== EXTENDED ANALYSIS FOR p=3 ==="];
TrackPrimeValuation[27, 3];

(* Example 3: Track p=5 *)
Print["\n"];
AnalyzeValuationPattern[25, 5];

(* Example 4: Multi-prime view *)
Print["\n"];
TrackMultiplePrimes[23, {2, 3, 5, 7}];

(* === HYPOTHESIS TESTING === *)
Print["\n=== HYPOTHESIS: v_p(denominator) always equals 0 or 1 ===\n"];

TestMaxValuation[m_, pmax_] := Module[{
    primes, results
  },
  primes = Select[Range[3, pmax], PrimeQ];

  results = Table[
    Module[{h, terms, partialSums, finalDenom, val},
      h = Floor[(m - 1)/2];
      terms = Table[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];
      partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];
      finalDenom = Denominator[Last[partialSums]];
      val = PrimePower[finalDenom, p];
      {p, val, val <= 1}
    ],
    {p, primes}
  ];

  Print["Testing for m = ", m, ":\n"];
  Print["Prime\tv_p(final_denom)\tSatisfies v_p ≤ 1?"];
  Print[StringRepeat["-", 50]];

  Do[
    Print[result[[1]], "\t", result[[2]], "\t\t\t",
      If[result[[3]], "✓ YES", "✗ NO"]
    ],
    {result, results}
  ];

  violations = Select[results, !Last[#] &];

  If[Length[violations] == 0,
    Print["\n*** ALL PRIMES SATISFY v_p ≤ 1 ***"];
    Print["(In fact, all non-zero valuations equal exactly 1)"],
    Print["\n*** VIOLATIONS FOUND: ***"];
    Print[violations]
  ];

  Print["\n"];

  violations
];

Do[TestMaxValuation[m, 2*Floor[(m-1)/2] + 1], {m, {13, 17, 23, 31}}];

Print["=== ANALYSIS COMPLETE ==="];
