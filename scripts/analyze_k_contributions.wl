#!/usr/bin/env wolframscript
(* Analyze: What fraction of d=2 term comes from k=0,1 vs k>=2? *)

Print["================================================================"];
Print["K-CONTRIBUTION BREAKDOWN FOR d=2 TERM"];
Print["================================================================"];
Print[""];
Print["Question: Can we truncate at k=1 and keep 99.8% of 99.8%?"];
Print[""];

(* ============================================================================ *)
(* DISTANCE FUNCTION                                                          *)
(* ============================================================================ *)

Dist[n_, k_, d_, eps_: 1.0] := (n - k*d - d^2)^2 + eps

(* ============================================================================ *)
(* ANALYZE d=2 TERM BY k                                                      *)
(* ============================================================================ *)

Print["[1/4] For n=2, α=3, ε=1: Breakdown by k for d=2"];
Print[""];

n = 2;
alpha = 3;
eps = 1;
d = 2;

(* Compute terms up to k=50 *)
terms = Table[
  {k, Dist[n, k, d, eps], Dist[n, k, d, eps]^(-alpha)},
  {k, 0, 50}
];

(* Partial sums *)
partialK0 = terms[[1, 3]];
partialK01 = Total[terms[[1;;2, 3]]];
partialK012 = Total[terms[[1;;3, 3]]];
partialAll = Total[terms[[All, 3]]];

Print["Individual k contributions:"];
Print["  k=0: ", N[terms[[1, 3]], 8], " (dist = ", terms[[1, 2]], ")"];
Print["  k=1: ", N[terms[[2, 3]], 8], " (dist = ", terms[[2, 2]], ")"];
Print["  k=2: ", N[terms[[3, 3]], 8], " (dist = ", terms[[3, 2]], ")"];
Print["  k=3: ", N[terms[[4, 3]], 8], " (dist = ", terms[[4, 2]], ")"];
Print[""];

Print["Cumulative contributions:"];
Print["  k=0 only:     ", N[partialK0, 8], "  (", N[100*partialK0/partialAll, 2], "%)"];
Print["  k=0,1:        ", N[partialK01, 8], "  (", N[100*partialK01/partialAll, 2], "%)"];
Print["  k=0,1,2:      ", N[partialK012, 8], "  (", N[100*partialK012/partialAll, 2], "%)"];
Print["  k=0..50 (all):", N[partialAll, 8], "  (100%)"];
Print[""];

percentK01 = 100*partialK01/partialAll;
Print["*** k∈{0,1} captures ", N[percentK01, 3], "% of d=2 term ***"];
Print[""];

(* ============================================================================ *)
(* TEST 2: Pattern across multiple n                                          *)
(* ============================================================================ *)

Print["[2/4] Testing k∈{0,1} truncation across n=2..30"];
Print[""];

AnalyzeKTruncation[n_, alpha_, eps_] := Module[{d, fullSum, truncSum, ratio},
  d = 2;
  fullSum = Sum[Dist[n, k, d, eps]^(-alpha), {k, 0, 100}];
  truncSum = Sum[Dist[n, k, d, eps]^(-alpha), {k, 0, 1}];
  ratio = truncSum / fullSum;
  {n, N[fullSum, 6], N[truncSum, 6], N[ratio, 5]}
];

results = Table[AnalyzeKTruncation[n, 3.0, 1.0], {n, 2, 30}];

Print["n\tFull d=2\tTrunc k≤1\tRatio"];
Print[StringRepeat["-", 60]];
Do[
  Print[results[[i, 1]], "\t", results[[i, 2]], "\t", results[[i, 3]], "\t", results[[i, 4]]],
  {i, 1, Length[results]}
];
Print[""];

avgRatio = Mean[results[[All, 4]]];
Print["Average ratio (k≤1 vs full): ", N[avgRatio, 4]];
Print[""];

(* ============================================================================ *)
(* TEST 3: Does truncation preserve stratification?                           *)
(* ============================================================================ *)

Print["[3/4] Stratification test: Full vs Truncated d=2 term"];
Print[""];

FnD2Full[n_, alpha_, eps_] := Module[{d, sum},
  d = 2;
  Sum[Dist[n, k, d, eps]^(-alpha), {k, 0, 100}]
];

FnD2Trunc[n_, alpha_, eps_] := Module[{d, sum},
  d = 2;
  Sum[Dist[n, k, d, eps]^(-alpha), {k, 0, 1}]
];

testRange = Range[2, 50];
dataFull = Table[{n, FnD2Full[n, 3.0, 1.0], PrimeQ[n]}, {n, testRange}];
dataTrunc = Table[{n, FnD2Trunc[n, 3.0, 1.0], PrimeQ[n]}, {n, testRange}];

(* Separate primes and composites *)
fullPrimes = Select[dataFull, #[[3]] &];
fullComps = Select[dataFull, !#[[3]] &];
truncPrimes = Select[dataTrunc, #[[3]] &];
truncComps = Select[dataTrunc, !#[[3]] &];

(* Means *)
meanFullPrime = Mean[fullPrimes[[All, 2]]];
meanFullComp = Mean[fullComps[[All, 2]]];
meanTruncPrime = Mean[truncPrimes[[All, 2]]];
meanTruncComp = Mean[truncComps[[All, 2]]];

Print["FULL d=2 term (k=0..100):"];
Print["  Primes:     ", N[meanFullPrime, 5]];
Print["  Composites: ", N[meanFullComp, 5]];
Print["  Separation: ", N[meanFullComp/meanFullPrime, 3], "×"];
Print[""];

Print["TRUNCATED d=2 term (k=0,1 only):"];
Print["  Primes:     ", N[meanTruncPrime, 5]];
Print["  Composites: ", N[meanTruncComp, 5]];
Print["  Separation: ", N[meanTruncComp/meanTruncPrime, 3], "×"];
Print[""];

(* Correlations *)
corrFull = Correlation[dataFull[[All, 2]], Boole[dataFull[[All, 3]]]];
corrTrunc = Correlation[dataTrunc[[All, 2]], Boole[dataTrunc[[All, 3]]]];

Print["Correlation with PrimeQ:"];
Print["  Full:      ", N[corrFull, 4]];
Print["  Truncated: ", N[corrTrunc, 4]];
Print[""];

(* ============================================================================ *)
(* TEST 4: Which k-values matter most?                                        *)
(* ============================================================================ *)

Print["[4/4] Which k contribute significantly?"];
Print[""];

(* For n=20 (composite), analyze full k-distribution *)
n = 20;
d = 2;
alpha = 3.0;

kTerms = Table[
  {k, Dist[n, k, d, 1.0], Dist[n, k, d, 1.0]^(-alpha)},
  {k, 0, 20}
];

totalSum = Total[kTerms[[All, 3]]];
cumulativePercent = Table[
  {k, N[100 * Total[kTerms[[1;;k+1, 3]]]/totalSum, 3]},
  {k, 0, 20}
];

Print["For n=20 (composite), d=2, cumulative % by k:"];
Print["k\tCumulative %"];
Print[StringRepeat["-", 30]];
Do[
  Print[cumulativePercent[[i, 1]], "\t", cumulativePercent[[i, 2]], "%"],
  {i, 1, Min[10, Length[cumulativePercent]]}
];
Print[""];

k95 = SelectFirst[cumulativePercent, #[[2]] >= 95.0 &];
Print["To capture 95% of d=2 term, need k ≤ ", k95[[1]]];
Print[""];

(* ============================================================================ *)
(* CONCLUSION                                                                  *)
(* ============================================================================ *)

Print["================================================================"];
Print["CONCLUSION"];
Print["================================================================"];
Print[""];

Print["KEY FINDINGS:"];
Print["  1. For n=2: k∈{0,1} captures ", N[percentK01, 2], "% of d=2 term"];
Print["  2. Average across n=2..30: ", N[100*avgRatio, 2], "%"];
Print["  3. Stratification preserved: ", If[Abs[corrTrunc] > 0.5, "YES", "WEAK"]];
Print["  4. Correlation strength: Full=", N[corrFull, 3], ", Trunc=", N[corrTrunc, 3]];
Print[""];

If[avgRatio > 0.95,
  Print["✓ TRUNCATION TO k≤1 IS VIABLE!"],
  If[avgRatio > 0.85,
    Print["~ TRUNCATION TO k≤1 LOSES SOME SIGNAL BUT MAY WORK"],
    Print["✗ TRUNCATION TO k≤1 LOSES TOO MUCH"]
  ]
];
Print[""];

If[avgRatio > 0.95,
  Module[{},
    Print["SIMPLIFIED FORMULA (if k≤1 truncation works):"];
    Print[""];
    Print["F_n(α) ≈ Σ_{d=2}^∞ Σ_{k=0}^1 [(n - kd - d²)² + ε]^{-α}"];
    Print[""];
    Print["This is a HUGE simplification:"];
    Print["  - Inner sum: FINITE (just 2 terms!)"];
    Print["  - Outer sum: Still infinite but dominated by small d"];
    Print["  - No convergence worries for inner sum"];
    Print["  - Exact symbolic computation possible"];
    Print[""];
  ]
];

Print["Further investigation needed:"];
Print["  - Test with different α values"];
Print["  - Compare full F_n (all d terms) with k≤1 truncation"];
Print["  - Optimize: maybe k≤2 or k≤3 is sweet spot?"];
Print[""];
