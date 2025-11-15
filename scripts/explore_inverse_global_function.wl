#!/usr/bin/env wolframscript
(* Explore INVERSE global function - composites contribute less! *)

(* ============================================================================ *)
(* F_n(s) DEFINITION - P-NORM                                                 *)
(* ============================================================================ *)

(* P-norm soft-minimum with epsilon regularization *)
PNormValue[x_, d_, p_, eps_] := Module[{distances, powerSum, count},
  distances = Table[(x - (k*d + d^2))^2 + eps, {k, 0, Floor[x/d]}];
  count = Length[distances];
  powerSum = Total[distances^(-p)];
  Power[powerSum / count, -1/p]
]

(* F_n(s) = Sum_d (p-norm_d)^(-s) *)
(* Use FULL limit for stability *)
Fn[n_, p_, eps_, s_] := Module[{terms},
  terms = Table[
    Module[{pnorm},
      pnorm = PNormValue[n, d, p, eps];
      If[pnorm > 1, pnorm^(-s), 0]
    ],
    {d, 2, Min[n, 100]}
  ];
  Total[terms]
]

(* Shorthand *)
F[n_, s_] := Fn[n, 3, 1.0, s]

(* ============================================================================ *)
(* GLOBAL FUNCTION VARIANTS                                                   *)
(* ============================================================================ *)

(* Variant A: Direct sum (baseline) *)
GDirect[s_, sigma_, nMax_] := Sum[F[n, s] / n^sigma, {n, 2, nMax}]

(* Variant B: INVERSE - composites weighted DOWN *)
GInverse[s_, sigma_, nMax_] := Sum[1 / (F[n, s] * n^sigma), {n, 2, nMax}]

(* Variant C: Power inverse *)
GPowerInv[s_, sigma_, p_, nMax_] := Sum[1 / (F[n, s]^p * n^sigma), {n, 2, nMax}]

(* Variant D: Log-transform *)
GLog[s_, sigma_, nMax_] := Sum[Log[F[n, s]] / n^sigma, {n, 2, nMax}]

(* ============================================================================ *)
(* PRIME vs COMPOSITE SEPARATION                                              *)
(* ============================================================================ *)

(* For inverse variant *)
GInversePrimes[s_, sigma_, nMax_] := Sum[
  If[PrimeQ[n], 1 / (F[n, s] * n^sigma), 0],
  {n, 2, nMax}
]

GInverseComposites[s_, sigma_, nMax_] := Sum[
  If[!PrimeQ[n] && n > 1, 1 / (F[n, s] * n^sigma), 0],
  {n, 2, nMax}
]

(* ============================================================================ *)
(* PARAMETERS                                                                  *)
(* ============================================================================ *)

Print["================================================================"];
Print["INVERSE GLOBAL FUNCTION EXPLORATION"];
Print["================================================================"];
Print[""];
Print["Hypothesis: Inverse G_inv = Sum 1/(F_n * n^sigma)"];
Print["  -> Composites (large F_n) contribute LESS"];
Print["  -> Primes (small F_n) contribute MORE"];
Print["  -> Better convergence?"];
Print["  -> Connection to zeta function?"];
Print[""];

(* ============================================================================ *)
(* 1. CONVERGENCE COMPARISON                                                  *)
(* ============================================================================ *)

Print["[1/4] Convergence comparison: Direct vs Inverse..."];
Print[""];

testS = 1.0;
testSigma = 1.5;
nValues = {10, 20, 30, 50, 100};

Print["For s = ", testS, ", sigma = ", testSigma, ":"];
Print[""];

directSums = Table[GDirect[testS, testSigma, n], {n, nValues}];
inverseSums = Table[GInverse[testS, testSigma, n], {n, nValues}];

Print["Direct G(s,sigma):"];
Print["  Values: ", N[directSums, 5]];
If[Length[directSums] >= 2,
  relChange = Abs[(Last[directSums] - directSums[[-2]]) / Last[directSums]];
  Print["  Convergence: ", If[relChange < 0.01, "YES", "SLOW"], " (", N[100*relChange, 2], "%)"]
];
Print[""];

Print["Inverse G_inv(s,sigma):"];
Print["  Values: ", N[inverseSums, 5]];
If[Length[inverseSums] >= 2,
  relChange = Abs[(Last[inverseSums] - inverseSums[[-2]]) / Last[inverseSums]];
  Print["  Convergence: ", If[relChange < 0.01, "YES", "SLOW"], " (", N[100*relChange, 2], "%)"]
];
Print[""];

(* ============================================================================ *)
(* 2. PRIME DOMINANCE                                                         *)
(* ============================================================================ *)

Print["[2/4] Prime dominance in inverse..."];
Print[""];

nTest = 50;

inverseTot = GInverse[testS, testSigma, nTest];
inversePrimes = GInversePrimes[testS, testSigma, nTest];
inverseComps = GInverseComposites[testS, testSigma, nTest];

Print["For s = ", testS, ", sigma = ", testSigma, ", n <= ", nTest, ":"];
Print["  Total G_inv:       ", N[inverseTot, 6]];
Print["  Primes only:       ", N[inversePrimes, 6], " (", N[100*inversePrimes/inverseTot, 2], "%)"];
Print["  Composites only:   ", N[inverseComps, 6], " (", N[100*inverseComps/inverseTot, 2], "%)"];
Print[""];

Print["Hypothesis: Primes should dominate MORE in inverse than in direct"];
Print[""];

(* ============================================================================ *)
(* 3. COMPARISON WITH ZETA                                                    *)
(* ============================================================================ *)

Print["[3/4] Comparison with zeta(s)..."];
Print[""];

sTestValues = {0.8, 1.0, 1.2, 1.5, 2.0};
sigmaFixed = 2.0;
nMaxFixed = 50;

Print["G_inv(s, sigma=", sigmaFixed, ") vs zeta(s):"];
Print[""];
Print["s\tG_inv\t\tzeta(s)\t\tG_inv/zeta"];

Do[
  Module[{gInv, zetaVal},
    gInv = GInverse[s, sigmaFixed, nMaxFixed];
    zetaVal = Zeta[s];
    Print[N[s, 3], "\t", N[gInv, 5], "\t\t", N[zetaVal, 5], "\t\t", N[gInv/zetaVal, 4]]
  ],
  {s, sTestValues}
];
Print[""];

(* ============================================================================ *)
(* 4. POWER INVERSE EXPLORATION                                               *)
(* ============================================================================ *)

Print["[4/4] Power inverse: 1/(F_n^p * n^sigma)..."];
Print[""];

powerValues = {1, 2, 3};
sFixed = 1.0;
sigmaFixed2 = 1.5;
nMaxFixed2 = 50;

Print["For s = ", sFixed, ", sigma = ", sigmaFixed2, ":"];
Print[""];
Print["p\tG_p\t\tConvergence"];

Do[
  Module[{partials, last, secondLast, relChange},
    partials = Table[
      GPowerInv[sFixed, sigmaFixed2, p, n],
      {n, {20, 30, 40, 50}}
    ];
    last = Last[partials];
    secondLast = partials[[-2]];
    relChange = Abs[(last - secondLast) / last];
    Print[p, "\t", N[last, 5], "\t\t", N[100*relChange, 2], "%"]
  ],
  {p, powerValues}
];
Print[""];

(* ============================================================================ *)
(* VISUALIZATIONS                                                              *)
(* ============================================================================ *)

Print["Generating visualizations..."];

(* Convergence plot *)
plot1 = ListLinePlot[
  {
    Transpose[{nValues, directSums}],
    Transpose[{nValues, inverseSums}]
  },
  PlotStyle -> {Blue, Orange},
  PlotMarkers -> Automatic,
  PlotLegends -> {"Direct G", "Inverse G_inv"},
  Frame -> True,
  FrameLabel -> {"nMax", "Sum value"},
  PlotLabel -> Row[{"Convergence comparison (s=", testS, ", sigma=", testSigma, ")"}],
  ImageSize -> 700
];

Export["visualizations/inverse-convergence-comparison.pdf", plot1];
Print["Saved visualizations/inverse-convergence-comparison.pdf"];

(* Prime contribution comparison *)
directPrimes = Sum[If[PrimeQ[n], F[n, testS]/n^testSigma, 0], {n, 2, nTest}];
directTotal = GDirect[testS, testSigma, nTest];

plot2 = BarChart[
  {
    {N[100*directPrimes/directTotal], N[100*(directTotal-directPrimes)/directTotal]},
    {N[100*inversePrimes/inverseTot], N[100*inverseComps/inverseTot]}
  },
  ChartLabels -> {{"Direct G", "Inverse G_inv"}, {"Primes", "Composites"}},
  ChartLegends -> {"Primes", "Composites"},
  PlotLabel -> "Prime vs Composite contribution (%)",
  ImageSize -> 700,
  ChartStyle -> {Orange, Blue}
];

Export["visualizations/inverse-prime-dominance.pdf", plot2];
Print["Saved visualizations/inverse-prime-dominance.pdf"];

(* ============================================================================ *)
(* SUMMARY AND INSIGHTS                                                        *)
(* ============================================================================ *)

Print[""];
Print["================================================================"];
Print["SUMMARY - INVERSE EXPLORATION"];
Print["================================================================"];
Print[""];

Print["KEY FINDINGS:"];
Print[""];

(* Check if inverse converges better *)
directConv = Abs[(directSums[[-1]] - directSums[[-2]]) / directSums[[-1]]];
inverseConv = Abs[(inverseSums[[-1]] - inverseSums[[-2]]) / inverseSums[[-1]]];

If[inverseConv < directConv,
  Print["  CONVERGENCE: Inverse converges FASTER than direct"],
  Print["  CONVERGENCE: Direct converges faster"]
];
Print["    Direct:  ", N[100*directConv, 2], "%"];
Print["    Inverse: ", N[100*inverseConv, 2], "%"];
Print[""];

(* Check prime dominance *)
directPrimePercent = 100*directPrimes/directTotal;
inversePrimePercent = 100*inversePrimes/inverseTot;

If[inversePrimePercent > directPrimePercent,
  Print["  PRIME DOMINANCE: Inverse AMPLIFIES prime contribution"],
  Print["  PRIME DOMINANCE: Similar to direct"]
];
Print["    Direct:  ", N[directPrimePercent, 2], "%"];
Print["    Inverse: ", N[inversePrimePercent, 2], "%"];
Print[""];

Print["NEXT STEPS:"];
Print["  1. Test functional equation for G_inv"];
Print["  2. Study zeros of G_inv in complex plane"];
Print["  3. Explore connection to prime number theorem"];
Print["  4. Try Mellin transform approach"];
Print[""];
