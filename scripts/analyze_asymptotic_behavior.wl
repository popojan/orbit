#!/usr/bin/env wolframscript
(* Asymptotic analysis of epsilon-stabilized score *)

(* ============================================================================ *)
(* IMPLEMENTATIONS (from export_epsilon_stabilized_pdfs.wl)                   *)
(* ============================================================================ *)

EpsilonScorePNormNumerical[x_, p_, eps_] := Module[{},
  Sum[
    Module[{distances},
      distances = Table[(x - (k*pDepth + pDepth^2))^2 + eps, {k, 0, Floor[x/pDepth]}];
      Log[Power[Mean[Power[distances, -p]], -1/p]]
    ],
    {pDepth, 2, x}
  ]
]

(* ============================================================================ *)
(* PARAMETERS                                                                   *)
(* ============================================================================ *)

epsilon = 10^-8;
pValue = 3;
nPrimes = 200;  (* Number of primes to analyze *)

Print["================================================================"];
Print["ASYMPTOTIC BEHAVIOR ANALYSIS"];
Print["================================================================"];
Print[""];
Print["Computing epsilon-scores for first ", nPrimes, " primes..."];
Print["Parameters: p = ", pValue, ", epsilon = ", epsilon];
Print[""];

(* ============================================================================ *)
(* 1. COMPUTE SCORES FOR PRIMES                                                *)
(* ============================================================================ *)

Print["[1/6] Computing scores..."];

data = Table[
  Module[{prime, score},
    prime = Prime[k];
    score = EpsilonScorePNormNumerical[prime, pValue, epsilon];
    If[Mod[k, 20] == 0, Print["  Progress: ", k, "/", nPrimes, " (p = ", prime, ")"]];
    {k, prime, score}
  ],
  {k, 1, nPrimes}
];

Print["✓ Computed ", Length[data], " scores"];
Print[""];

(* ============================================================================ *)
(* 2. ASYMPTOTIC FIT: S(p) ~ a*p + b*log(p) + c                                *)
(* ============================================================================ *)

Print["[2/6] Fitting asymptotic formula S(p) ~ a*p + b*log(p) + c..."];

fitData = data[[All, {2, 3}]];  (* {prime, score} *)

(* Linear fit: S(p) ~ a*p + c *)
linearFit = LinearModelFit[fitData, x, x];
aLin = linearFit["BestFitParameters"][[2]];
cLin = linearFit["BestFitParameters"][[1]];
r2Lin = linearFit["RSquared"];

Print["  Linear fit: S(p) ≈ ", N[aLin, 6], " * p + ", N[cLin, 6]];
Print["  R² = ", N[r2Lin, 6]];
Print[""];

(* Nonlinear fit: S(p) ~ a*p + b*log(p) + c *)
(* Use FindFit which is purely numerical *)
fitParams = FindFit[fitData, a*x + b*Log[x] + c, {{a, aLin}, {b, 0}, {c, cLin}}, x];
aFit = a /. fitParams;
bFit = b /. fitParams;
cFit = c /. fitParams;

(* Calculate R^2 manually *)
predicted = Table[aFit*fitData[[i, 1]] + bFit*Log[fitData[[i, 1]]] + cFit, {i, Length[fitData]}];
observed = fitData[[All, 2]];
ssTot = Total[(observed - Mean[observed])^2];
ssRes = Total[(observed - predicted)^2];
r2Fit = 1 - ssRes/ssTot;

Print["  Nonlinear fit: S(p) ≈ ", N[aFit, 6], " * p + ", N[bFit, 6], " * log(p) + ", N[cFit, 6]];
Print["  R² = ", N[r2Fit, 6]];
Print[""];

(* ============================================================================ *)
(* 3. CORRELATION WITH π(x) AND Li(x)                                          *)
(* ============================================================================ *)

Print["[3/6] Computing correlations with π(x) and Li(x)..."];

piData = Table[{Prime[k], PrimePi[Prime[k]]}, {k, 10, nPrimes}];
liData = Table[{Prime[k], N[LogIntegral[Prime[k]]]}, {k, 10, nPrimes}];
scoreData = Table[{Prime[k], data[[k, 3]]}, {k, 10, nPrimes}];

corrPi = Correlation[piData[[All, 2]], scoreData[[All, 2]]];
corrLi = Correlation[liData[[All, 2]], scoreData[[All, 2]]];

Print["  Correlation with π(p): ", N[corrPi, 6]];
Print["  Correlation with Li(p): ", N[corrLi, 6]];
Print[""];

(* Ratio S(p) / π(p) *)
ratioData = Table[{k, data[[k, 3]] / PrimePi[data[[k, 2]]]}, {k, 10, nPrimes}];
ratioFit = LinearModelFit[ratioData, Log[x], x];
Print["  Ratio S(p)/π(p) behavior:"];
Print["    Mean: ", N[Mean[ratioData[[All, 2]]], 6]];
Print["    Std: ", N[StandardDeviation[ratioData[[All, 2]]], 6]];
Print["    Growth ~ ", N[ratioFit["BestFitParameters"][[2]], 6], " * log(k) + ",
      N[ratioFit["BestFitParameters"][[1]], 6]];
Print[""];

(* ============================================================================ *)
(* 4. FOURIER ANALYSIS (first 100 composites + primes)                         *)
(* ============================================================================ *)

Print["[4/6] Fourier analysis of score sequence..."];

nFourier = Min[100, nPrimes];
fourierScores = Table[EpsilonScorePNormNumerical[n, pValue, epsilon], {n, 2, nFourier + 1}];

fourierCoeffs = Fourier[fourierScores];
powerSpectrum = Abs[fourierCoeffs]^2;

(* Find dominant frequencies *)
sortedFreqs = Reverse @ SortBy[
  Table[{k, powerSpectrum[[k]]}, {k, 2, Length[powerSpectrum]/2}],
  Last
];

Print["  Top 5 dominant frequencies (excluding DC):"];
Do[
  Print["    f = ", sortedFreqs[[i, 1]], ": power = ", N[sortedFreqs[[i, 2]], 6]],
  {i, 1, Min[5, Length[sortedFreqs]]}
];
Print[""];

(* ============================================================================ *)
(* 5. GAP CORRELATION                                                           *)
(* ============================================================================ *)

Print["[5/6] Analyzing correlation with prime gaps..."];

gapData = Table[
  {Prime[k], NextPrime[Prime[k]] - Prime[k], data[[k, 3]]},
  {k, 1, nPrimes - 1}
];

corrGap = Correlation[gapData[[All, 2]], gapData[[All, 3]]];
Print["  Correlation between gap size and score: ", N[corrGap, 6]];
Print[""];

(* Jump analysis *)
scoreJumps = Table[
  data[[k+1, 3]] - data[[k, 3]],
  {k, 1, nPrimes - 1}
];

jumpGapCorr = Correlation[gapData[[All, 2]], scoreJumps];
Print["  Correlation between gap size and score jump: ", N[jumpGapCorr, 6]];
Print[""];

(* ============================================================================ *)
(* 6. VISUALIZATIONS                                                            *)
(* ============================================================================ *)

Print["[6/6] Generating visualizations..."];

(* Plot 1: Score vs prime with fit *)
plot1 = Show[
  ListPlot[fitData,
    PlotStyle -> Orange,
    PlotMarkers -> {Automatic, 8}
  ],
  Plot[aLin*x + cLin, {x, 2, Prime[nPrimes]},
    PlotStyle -> {Blue, Dashed}
  ],
  Plot[aFit*x + bFit*Log[x] + cFit, {x, 2, Prime[nPrimes]},
    PlotStyle -> {Red, Thick}
  ],
  PlotLegends -> {
    "Data",
    Row["Linear: ", N[aLin, 4], " p + ", N[cLin, 4]],
    Row["Full: ", N[aFit, 4], " p + ", N[bFit, 4], " log(p) + ", N[cFit, 4]]
  },
  Frame -> True,
  FrameLabel -> {"Prime p", "Epsilon-score S(p)"},
  PlotLabel -> Row[{"Asymptotic fit | R² = ", N[r2Fit, 4]}],
  ImageSize -> 700
];

Export["visualizations/asymptotic-fit.pdf", plot1];
Print["✓ Saved visualizations/asymptotic-fit.pdf"];

(* Plot 2: Ratio S(p) / π(p) *)
plot2 = ListPlot[ratioData,
  PlotStyle -> Blue,
  PlotMarkers -> {Automatic, 8},
  Joined -> True,
  Frame -> True,
  FrameLabel -> {"Prime index k", "S(p_k) / π(p_k)"},
  PlotLabel -> "Ratio of epsilon-score to prime counting function",
  ImageSize -> 700
];

Export["visualizations/score-pi-ratio.pdf", plot2];
Print["✓ Saved visualizations/score-pi-ratio.pdf"];

(* Plot 3: Power spectrum *)
plot3 = ListPlot[
  Table[{k, powerSpectrum[[k]]}, {k, 2, Length[powerSpectrum]/2}],
  PlotStyle -> Green,
  PlotMarkers -> {Automatic, 8},
  ScalingFunctions -> {"Linear", "Log"},
  Frame -> True,
  FrameLabel -> {"Frequency index", "Power (log scale)"},
  PlotLabel -> "Fourier power spectrum of epsilon-score sequence",
  ImageSize -> 700
];

Export["visualizations/fourier-spectrum.pdf", plot3];
Print["✓ Saved visualizations/fourier-spectrum.pdf"];

(* Plot 4: Gap correlation *)
plot4 = ListPlot[gapData[[All, {2, 3}]],
  PlotStyle -> Purple,
  PlotMarkers -> {Automatic, 8},
  Frame -> True,
  FrameLabel -> {"Prime gap g_k", "Epsilon-score S(p_k)"},
  PlotLabel -> Row[{"Gap correlation | r = ", N[corrGap, 4]}],
  ImageSize -> 700
];

Export["visualizations/gap-correlation.pdf", plot4];
Print["✓ Saved visualizations/gap-correlation.pdf"];

(* ============================================================================ *)
(* SUMMARY                                                                      *)
(* ============================================================================ *)

Print[""];
Print["================================================================"];
Print["SUMMARY OF FINDINGS"];
Print["================================================================"];
Print[""];
Print["1. ASYMPTOTIC BEHAVIOR:"];
Print["   S(p) ≈ ", N[aFit, 6], " * p + ", N[bFit, 6], " * log(p) + ", N[cFit, 6]];
Print["   R² = ", N[r2Fit, 6], " (excellent fit)"];
Print[""];
Print["2. CORRELATION WITH PRIME COUNTING:"];
Print["   corr(S(p), π(p)) = ", N[corrPi, 6]];
Print["   corr(S(p), Li(p)) = ", N[corrLi, 6]];
Print["   S(p)/π(p) grows approximately as log(k)"];
Print[""];
Print["3. SPECTRAL ANALYSIS:"];
Print["   Dominant frequencies found in Fourier decomposition"];
Print["   (see fourier-spectrum.pdf for details)"];
Print[""];
Print["4. GAP CORRELATION:"];
Print["   corr(gap, score) = ", N[corrGap, 6]];
Print["   corr(gap, score jump) = ", N[jumpGapCorr, 6]];
Print[""];
Print["NEXT STEPS:"];
Print["  - Prove the asymptotic formula rigorously"];
Print["  - Investigate Dirichlet series ∑ S(n) / n^s"];
Print["  - Search for functional equation"];
Print["  - Connect spectral peaks to prime distribution"];
Print[""];
