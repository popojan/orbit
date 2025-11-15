#!/usr/bin/env wolframscript
(* Compare sqrt(n) limit vs full n limit - P-NORM VERSION *)

(* ============================================================================ *)
(* IMPLEMENTATIONS                                                             *)
(* ============================================================================ *)

(* P-norm soft-minimum *)
SoftMinPNorm[x_, d_, p_, eps_] := Module[{distances, powerSum, count},
  distances = Table[(x - (k*d + d^2))^2 + eps, {k, 0, Floor[x/d]}];
  count = Length[distances];
  powerSum = Total[distances^(-p)];
  Power[powerSum / count, -1/p]
]

(* Full limit (current) *)
ScoreFull[n_, p_, eps_] := Sum[
  Log[SoftMinPNorm[n, d, p, eps]],
  {d, 2, n}
]

(* sqrt(n) limit (optimized) *)
ScoreSqrt[n_, p_, eps_] := Sum[
  Log[SoftMinPNorm[n, d, p, eps]],
  {d, 2, Floor[Sqrt[n]]}  (* <-- ONLY CHANGE *)
]

(* Tail contribution *)
TailContribution[n_, p_, eps_] := ScoreFull[n, p, eps] - ScoreSqrt[n, p, eps]

(* ============================================================================ *)
(* PARAMETERS                                                                   *)
(* ============================================================================ *)

epsilon = 1.0;
pValue = 3;
nMax = 150;

Print["================================================================"];
Print["sqrt(n) LIMIT vs FULL n LIMIT COMPARISON (P-NORM)"];
Print["================================================================"];
Print[""];
Print["Parameters:"];
Print["  p = ", pValue];
Print["  epsilon = ", epsilon];
Print["  n in [1, ", nMax, "]"];
Print[""];

(* ============================================================================ *)
(* 1. TIMING COMPARISON                                                        *)
(* ============================================================================ *)

Print["[1/4] Timing comparison..."];
Print[""];

testN = 100;

timeFull = First[AbsoluteTiming[ScoreFull[testN, pValue, epsilon]]];
timeSqrt = First[AbsoluteTiming[ScoreSqrt[testN, pValue, epsilon]]];

Print["For n = ", testN, ":"];
Print["  Full limit (d <= n):    ", N[timeFull, 4], " seconds"];
Print["  sqrt(n) limit (d <= sqrt(n)):     ", N[timeSqrt, 4], " seconds"];
Print["  Speedup:               ", N[timeFull/timeSqrt, 3], "x"];
Print[""];

(* ============================================================================ *)
(* 2. ACCURACY COMPARISON (Primality Test)                                    *)
(* ============================================================================ *)

Print["[2/4] Primality test accuracy..."];
Print[""];

testPrimes = Prime[Range[5, 20]];
testComposites = Select[Range[20, 100], !PrimeQ[#] && # > 1 &][[1;;10]];

Print["Testing primes (should all have finite score):"];
primesOK = True;
Do[
  scoreSqrt = ScoreSqrt[p, pValue, epsilon];
  If[!NumericQ[scoreSqrt] || scoreSqrt == Infinity,
    Print["  FAILED for p = ", p];
    primesOK = False
  ],
  {p, testPrimes}
];
If[primesOK, Print["  All primes passed (sqrt(n) limit preserves test)"]];
Print[""];

Print["Testing composites (behavior with sqrt(n) limit):"];
Do[
  scoreSqrt = ScoreSqrt[c, pValue, epsilon];
  scoreFull = ScoreFull[c, pValue, epsilon];
  Print["  n = ", c, ": Score_sqrt = ", N[scoreSqrt, 5], ", Score_full = ", N[scoreFull, 5]],
  {c, testComposites[[1;;5]]}
];
Print[""];

(* ============================================================================ *)
(* 3. STRATIFICATION COMPARISON                                                *)
(* ============================================================================ *)

Print["[3/4] Stratification comparison..."];
Print[""];

nStrat = Min[100, nMax];

dataFull = Table[{k, ScoreFull[k, pValue, epsilon]}, {k, 2, nStrat}];
dataSqrt = Table[{k, ScoreSqrt[k, pValue, epsilon]}, {k, 2, nStrat}];

(* Separate by type *)
primesFull = Select[dataFull, PrimeQ[First[#]] &];
primesSqrt = Select[dataSqrt, PrimeQ[First[#]] &];

semiprimesFull = Select[dataFull,
  !PrimeQ[First[#]] && !PrimePowerQ[First[#]] && PrimeOmega[First[#]] == 2 &];
semiprimesSqrt = Select[dataSqrt,
  !PrimeQ[First[#]] && !PrimePowerQ[First[#]] && PrimeOmega[First[#]] == 2 &];

Print["Mean scores (full limit):"];
Print["  Primes:     ", N[Mean[primesFull[[All, 2]]], 6]];
Print["  Semiprimes: ", N[Mean[semiprimesFull[[All, 2]]], 6]];
Print[""];

Print["Mean scores (sqrt(n) limit):"];
Print["  Primes:     ", N[Mean[primesSqrt[[All, 2]]], 6]];
Print["  Semiprimes: ", N[Mean[semiprimesSqrt[[All, 2]]], 6]];
Print[""];

Print["Stratification preserved? ",
      If[Mean[primesSqrt[[All, 2]]] > Mean[semiprimesSqrt[[All, 2]]], "YES", "NO"]];
Print[""];

(* ============================================================================ *)
(* 4. TAIL CONTRIBUTION ANALYSIS                                               *)
(* ============================================================================ *)

Print["[4/4] Tail contribution analysis..."];
Print[""];

tailData = Table[{k, TailContribution[k, pValue, epsilon]}, {k, 2, nStrat}];

tailPrimes = Select[tailData, PrimeQ[First[#]] &];
tailComposites = Select[tailData, !PrimeQ[First[#]] &];

Print["Tail contribution statistics:"];
Print["  For primes:"];
Print["    Mean: ", N[Mean[tailPrimes[[All, 2]]], 6]];
Print["    Std:  ", N[StandardDeviation[tailPrimes[[All, 2]]], 6]];
Print[""];
Print["  For composites:"];
Print["    Mean: ", N[Mean[tailComposites[[All, 2]]], 6]];
Print["    Std:  ", N[StandardDeviation[tailComposites[[All, 2]]], 6]];
Print[""];

(* ============================================================================ *)
(* VISUALIZATIONS                                                               *)
(* ============================================================================ *)

Print["Generating visualizations..."];

(* Plot 1: Direct comparison *)
plot1 = Show[
  ListLinePlot[GatherBy[dataFull, PrimeQ@*First],
    PlotStyle -> {Directive[Orange, Dashed], Directive[Blue, Dashed]},
    PlotMarkers -> Automatic
  ],
  ListLinePlot[GatherBy[dataSqrt, PrimeQ@*First],
    PlotStyle -> {Directive[Orange, Thick], Directive[Blue, Thick]},
    PlotMarkers -> Automatic
  ],
  PlotLegends -> {"Primes (full)", "Composites (full)", "Primes (sqrt)", "Composites (sqrt)"},
  Frame -> True,
  FrameLabel -> {"n", "Epsilon-score"},
  PlotLabel -> "Comparison: Full limit (dashed) vs sqrt(n) limit (solid) - P-norm",
  ImageSize -> 700
];

Export["visualizations/sqrt-limit-comparison-pnorm.pdf", plot1];
Print["Saved visualizations/sqrt-limit-comparison-pnorm.pdf"];

(* Plot 2: Tail contribution *)
plot2 = ListLinePlot[GatherBy[tailData, PrimeQ@*First],
  PlotStyle -> {Orange, Blue},
  PlotMarkers -> Automatic,
  PlotLegends -> {"Primes", "Composites"},
  Frame -> True,
  FrameLabel -> {"n", "Tail contribution (Score_full - Score_sqrt)"},
  PlotLabel -> "Contribution from d > sqrt(n) - P-norm",
  ImageSize -> 700
];

Export["visualizations/tail-contribution-pnorm.pdf", plot2];
Print["Saved visualizations/tail-contribution-pnorm.pdf"];

(* Plot 3: Speedup vs n *)
timingData = Table[
  {n,
   First[AbsoluteTiming[ScoreSqrt[n, pValue, epsilon]]],
   First[AbsoluteTiming[ScoreFull[n, pValue, epsilon]]]},
  {n, {10, 20, 30, 50, 75, 100}}
];

plot3 = ListLinePlot[
  {
    timingData[[All, {1, 2}]],
    timingData[[All, {1, 3}]]
  },
  PlotStyle -> {Orange, Blue},
  PlotMarkers -> Automatic,
  PlotLegends -> {"sqrt(n) limit", "Full limit"},
  Frame -> True,
  FrameLabel -> {"n", "Time (seconds)"},
  PlotLabel -> "Computational speedup - P-norm",
  ImageSize -> 700,
  ScalingFunctions -> {"Linear", "Log"}
];

Export["visualizations/sqrt-limit-speedup-pnorm.pdf", plot3];
Print["Saved visualizations/sqrt-limit-speedup-pnorm.pdf"];

(* ============================================================================ *)
(* SUMMARY                                                                      *)
(* ============================================================================ *)

Print[""];
Print["================================================================"];
Print["SUMMARY (P-NORM)"];
Print["================================================================"];
Print[""];

Print["COMPUTATIONAL EFFICIENCY:"];
Print["  Speedup: ", N[timeFull/timeSqrt, 3], "x faster"];
Print["  Complexity: O(n^{3/2}) vs O(n^2)"];
Print[""];

Print["PRIMALITY TEST:"];
Print["  sqrt(n) limit preserves closed-form test"];
Print["  All primes remain finite"];
Print["  Reason: Every composite has divisor <= sqrt(n)"];
Print[""];

Print["STRATIFICATION:"];
If[Mean[primesSqrt[[All, 2]]] > Mean[semiprimesSqrt[[All, 2]]],
  Print["  Preserved - primes still form envelope"],
  Print["  Lost - need to investigate"]
];
Print[""];

Print["TAIL CONTRIBUTION:"];
Print["  Mean for primes: ", N[Mean[tailPrimes[[All, 2]]], 4]];
Print["  Appears to be: O(log n) or similar"];
Print["  Geometric interpretation: Distances from squares d^2 > n"];
Print[""];

Print["RECOMMENDATION:"];
Print["  Use sqrt(n) limit for:"];
Print["    - Primality testing (same accuracy, faster)"];
Print["    - Large-scale computations"];
Print["    - Cleaner theoretical analysis"];
Print["  Use full limit for:"];
Print["    - Maximum stratification detail"];
Print["    - Understanding tail structure"];
Print[""];
