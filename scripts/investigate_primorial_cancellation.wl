#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Investigation: Why do higher prime powers cancel in the primorial formula? *)

Print["=== PRIMORIAL CANCELLATION INVESTIGATION ===\n"];

(* Helper: Pretty print factorization *)
FormatFactorization[n_] := If[n == 1, "1",
  StringJoin[Riffle[
    Map[If[#[[2]] == 1, ToString[#[[1]]], ToString[#[[1]]] <> "^" <> ToString[#[[2]]]] &,
      FactorInteger[n]],
    " × "]]
];

(* Helper: Get max power of prime p in n *)
PrimePower[n_, p_] := If[n == 0, 0, Module[{fi = FactorInteger[n]},
  SelectFirst[fi, #[[1]] == p &, {0, 0}][[2]]
]];

(* === INVESTIGATION 1: Track Denominator Evolution === *)
Print["=== INVESTIGATION 1: Denominator Evolution ==="];
Print["Tracking how denominator changes as we add each term\n"];

InvestigateDenominatorEvolution[m_] := Module[{
    terms, partialSums, denoms, factorizations
  },
  Print["m = ", m, " (primorial = ", FormatFactorization[Times @@ Prime @ Range @ PrimePi[m]], ")"];
  Print["Target PrimePi[m] = ", PrimePi[m], "\n"];

  (* Build partial sums *)
  terms = Table[(-1)^k * (k!)/(2*k + 1), {k, 1, Floor[(m - 1)/2]}];
  partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];
  denoms = Denominator /@ partialSums;
  factorizations = FactorInteger /@ denoms;

  Print["k\tDenominator\t\tFactorization"];
  Print[StringRepeat["-", 80]];
  Do[
    Print[k, "\t", denoms[[k]], "\t\t", FormatFactorization[denoms[[k]]]],
    {k, Length[denoms]}
  ];
  Print["\nFinal denominator: ", Last[denoms]];
  Print["Expected primorial: ", Times @@ Prime @ Range @ PrimePi[m]];
  Print["Match: ", Last[denoms] == Times @@ Prime @ Range @ PrimePi[m]];
  Print[""];

  denoms
];

(* Test for small values *)
Do[InvestigateDenominatorEvolution[m], {m, {5, 7, 11, 13}}];

(* === INVESTIGATION 2: Individual Term Structure === *)
Print["\n=== INVESTIGATION 2: Individual Term Structure ==="];
Print["Examining numerators and denominators of individual terms\n"];

InvestigateTerms[m_] := Module[{h, terms, numers, denoms},
  h = Floor[(m - 1)/2];
  Print["m = ", m, ", computing ", h, " terms:\n"];

  terms = Table[{k, (-1)^k * (k!)/(2*k + 1)}, {k, 1, h}];

  Print["k\tk!\t\t2k+1\t\tNumerator\t\tDenominator"];
  Print[StringRepeat["-", 100]];
  Do[
    Module[{k = term[[1]], rat = term[[2]], num, den},
      num = Numerator[rat];
      den = Denominator[rat];
      Print[k, "\t", FormatFactorization[k!], "\t\t",
        2*k + 1, "\t\t", FormatFactorization[Abs[num]], "\t\t",
        FormatFactorization[den]];
    ],
    {term, terms}
  ];
  Print[""];
];

InvestigateTerms[13];

(* === INVESTIGATION 3: Prime Power Tracking === *)
Print["\n=== INVESTIGATION 3: Prime Power Tracking ==="];
Print["Track the power of each prime through partial sums\n"];

TrackPrimePowers[m_] := Module[{
    denoms, primes, powerTable
  },
  Print["m = ", m];

  (* Get partial sum denominators *)
  denoms = InvestigateDenominatorEvolution[m];
  primes = Prime[Range[PrimePi[m] + 3]]; (* Include a few extra *)

  (* Build table of prime powers *)
  powerTable = Table[
    {p, Table[PrimePower[d, p], {d, denoms}]},
    {p, primes}
  ];

  Print["\nPrime power evolution (rows=primes, cols=after k terms):"];
  Print["Prime\t", Table["k=" <> ToString[k], {k, Length[denoms]}]];
  Print[StringRepeat["-", 80]];
  Do[
    Module[{p = row[[1]], powers = row[[2]]},
      If[Max[powers] > 0, (* Only show primes that appear *)
        Print[p, "\t", powers]
      ]
    ],
    {row, powerTable}
  ];
  Print[""];
];

(* Skip the full output for now, just note it's available *)
(* TrackPrimePowers[13]; *)

(* === INVESTIGATION 4: When Do Primes Enter/Exit? === *)
Print["\n=== INVESTIGATION 4: Prime Entry and Exit Points ==="];
Print["When does each prime first appear and reach final power?\n"];

AnalyzePrimeLifecycle[m_] := Module[{
    denoms, primes, lifecycle
  },
  Print["m = ", m, " (primorial = ", FormatFactorization[Times @@ Prime @ Range @ PrimePi[m]], ")\n"];

  (* Get denominators *)
  terms = Table[(-1)^k * (k!)/(2*k + 1), {k, 1, Floor[(m - 1)/2]}];
  partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];
  denoms = Denominator /@ partialSums;

  primes = Select[Prime[Range[PrimePi[m] + 2]], # <= m &];

  Print["Prime\tFirst\tMax\tFinal\tStatus"];
  Print[StringRepeat["-", 60]];

  Do[
    Module[{powers, firstAppear, maxPower, finalPower, status},
      powers = Table[PrimePower[d, p], {d, denoms}];
      firstAppear = FirstPosition[powers, _?(# > 0 &), {Missing[]}][[1]];
      maxPower = Max[powers];
      finalPower = Last[powers];
      status = Which[
        finalPower == 1, "✓ Primorial (power 1)",
        finalPower == 0, "✗ Cancelled out",
        finalPower > 1, "✗ Higher power (bug?)"
      ];
      Print[p, "\t", firstAppear, "\t", maxPower, "\t", finalPower, "\t", status];
    ],
    {p, primes}
  ];
  Print[""];
];

Do[AnalyzePrimeLifecycle[m], {m, {7, 11, 13, 17}}];

(* === INVESTIGATION 5: GCD Patterns === *)
Print["\n=== INVESTIGATION 5: GCD Between Consecutive Partial Sums ==="];
Print["Looking for systematic cancellations\n"];

AnalyzeGCDPattern[m_] := Module[{
    terms, partialSums, denoms, gcds
  },
  Print["m = ", m, "\n"];

  terms = Table[(-1)^k * (k!)/(2*k + 1), {k, 1, Floor[(m - 1)/2]}];
  partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];
  denoms = Denominator /@ partialSums;

  gcds = Table[GCD[denoms[[i]], denoms[[i + 1]]], {i, 1, Length[denoms] - 1}];

  Print["k\tD[k]\t\tD[k+1]\t\tGCD\t\tRatio D[k+1]/GCD"];
  Print[StringRepeat["-", 100]];
  Do[
    Print[k, "\t", denoms[[k]], "\t\t", denoms[[k + 1]], "\t\t",
      gcds[[k]], "\t\t", denoms[[k + 1]]/gcds[[k]]],
    {k, 1, Min[10, Length[gcds]]}
  ];
  Print["..."];
  Print[""];
];

AnalyzeGCDPattern[11];

(* === INVESTIGATION 6: Comparison to Legendre's Formula === *)
Print["\n=== INVESTIGATION 6: Comparison to Legendre's Formula ==="];
Print["Legendre's formula for factorial prime factorization\n"];

CompareToLegendre[m_] := Module[{
    h, primes
  },
  h = Floor[(m - 1)/2];
  primes = Prime[Range[PrimePi[m]]];

  Print["m = ", m, ", h = ", h, "\n"];
  Print["For k! in the terms, Legendre's formula gives ν_p(k!) = Σ floor(k/p^i):\n"];
  Print["k\t", Map[ToString, primes], "\t\tDenominator of k!/(2k+1)"];
  Print[StringRepeat["-", 80]];

  Do[
    Module[{powers, den},
      powers = Table[Sum[Floor[k/p^i], {i, 1, 10}], {p, primes}];
      den = Denominator[(k!)/(2*k + 1)];
      Print[k, "\t", powers, "\t", FormatFactorization[den]];
    ],
    {k, 1, h}
  ];
  Print[""];
];

CompareToLegendre[11];

Print["=== INVESTIGATION COMPLETE ==="];
Print["Next steps: Look for patterns in the output above!"];
