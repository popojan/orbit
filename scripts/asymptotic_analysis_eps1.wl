#!/usr/bin/env wolframscript
(* Asymptotic analysis with epsilon = 1.0 - for THEORY *)

Print["================================================================"];
Print["ASYMPTOTIC ANALYSIS - EPSILON = 1.0 (THEORY)"];
Print["================================================================"];
Print[""];
Print["Goal: Find F_p(s) ~ a*log^alpha(p) or similar"];
Print[""];

(* ============================================================================ *)
(* P-NORM WITH EPSILON = 1.0                                                  *)
(* ============================================================================ *)

PNormValue[x_, d_, p_, eps_] := Module[{distances, powerSum, count},
  distances = Table[(x - (k*d + d^2))^2 + eps, {k, 0, Floor[x/d]}];
  count = Length[distances];
  powerSum = Total[distances^(-p)];
  N[Power[powerSum / count, -1/p]]
]

(* F_n(s) with sqrt(n) limit *)
Fn[n_, s_] := Module[{terms, dMax},
  dMax = Min[Floor[Sqrt[n]], 100];
  terms = Table[
    Module[{pnorm},
      pnorm = PNormValue[n, d, 3, 1.0];  (* epsilon = 1.0 *)
      If[pnorm > 1, pnorm^(-s), 0]
    ],
    {d, 2, dMax}
  ];
  Total[terms]
]

(* ============================================================================ *)
(* COMPUTE F_p FOR PRIMES                                                      *)
(* ============================================================================ *)

Print["[1/4] Computing F_p(s=1) for primes up to 1000..."];
Print[""];

primes = Prime[Range[168]];  (* Primes up to 1000 *)
scores = Table[
  Module[{p, score},
    p = primes[[i]];
    score = Fn[p, 1.0];
    If[Mod[i, 20] == 0, Print["  Progress: ", i, "/168 (p = ", p, ")"]];
    {p, score}
  ],
  {i, 1, Length[primes]}
];

Print["✓ Computed ", Length[scores], " scores"];
Print[""];

(* ============================================================================ *)
(* FIT ASYMPTOTIC FORMULA                                                     *)
(* ============================================================================ *)

Print["[2/4] Fitting asymptotic formulas..."];
Print[""];

(* Extract data *)
primeValues = scores[[All, 1]];
scoreValues = scores[[All, 2]];

(* Try different fits *)
Print["Testing models:"];
Print["  Model 1: F_p ~ a*log(p) + b"];
Print["  Model 2: F_p ~ a*p^alpha + b"];
Print["  Model 3: F_p ~ a*log(p)^alpha + b"];
Print[""];

(* Log fit *)
logFit = FindFit[scores, a*Log[p] + b, {a, b}, p];
Print["Model 1 fit: F_p ≈ ", a*Log[p] + b /. logFit];
Print["  Parameters: a = ", a /. logFit, ", b = ", b /. logFit];
residuals1 = Total[(scoreValues - (a*Log[primeValues] + b /. logFit))^2];
Print["  Residual: ", N[residuals1, 4]];
Print[""];

(* Power fit *)
powerFit = FindFit[scores, a*p^alpha + b, {a, alpha, b}, p];
Print["Model 2 fit: F_p ≈ ", a*p^alpha + b /. powerFit];
Print["  Parameters: a = ", a /. powerFit, ", alpha = ", alpha /. powerFit, ", b = ", b /. powerFit];
residuals2 = Total[(scoreValues - (a*primeValues^alpha + b /. powerFit))^2];
Print["  Residual: ", N[residuals2, 4]];
Print[""];

(* Log-power fit *)
logPowerFit = FindFit[scores, a*Log[p]^alpha + b, {a, alpha, b}, p];
Print["Model 3 fit: F_p ≈ ", a*Log[p]^alpha + b /. logPowerFit];
Print["  Parameters: a = ", a /. logPowerFit, ", alpha = ", alpha /. logPowerFit, ", b = ", b /. logPowerFit];
residuals3 = Total[(scoreValues - (a*Log[primeValues]^alpha + b /. logPowerFit))^2];
Print["  Residual: ", N[residuals3, 4]];
Print[""];

(* Best fit *)
bestModel = MinimalBy[
  {{"log", residuals1}, {"power", residuals2}, {"log-power", residuals3}},
  Last
][[1, 1]];
Print["✓ Best model: ", bestModel];
Print[""];

(* ============================================================================ *)
(* COMPOSITE ANALYSIS BY OMEGA                                                *)
(* ============================================================================ *)

Print["[3/4] Analyzing F_n for composites by Omega(n)..."];
Print[""];

composites = Select[Range[2, 200], !PrimeQ[#] &];
compositeData = Table[
  Module[{n, omega, score},
    n = composites[[i]];
    omega = PrimeOmega[n];
    score = Fn[n, 1.0];
    {n, omega, score}
  ],
  {i, 1, Length[composites]}
];

(* Group by Omega *)
omegaGroups = GatherBy[compositeData, #[[2]] &];
omegaStats = Table[
  Module[{omega, group, scores, mean},
    omega = group[[1, 2]];
    scores = group[[All, 3]];
    mean = Mean[scores];
    {omega, Length[group], mean, Min[scores], Max[scores]}
  ],
  {group, omegaGroups}
];

Print["Omega(n)  Count  Mean F_n   Min      Max"];
Print["----------------------------------------------"];
Do[
  Print[StringPadRight[ToString[row[[1]]], 9],
        StringPadRight[ToString[row[[2]]], 7],
        StringPadRight[ToString[N[row[[3]], 4]], 11],
        StringPadRight[ToString[N[row[[4]], 4]], 9],
        ToString[N[row[[5]], 4]]],
  {row, omegaStats}
];
Print[""];

(* ============================================================================ *)
(* VISUALIZATION                                                              *)
(* ============================================================================ *)

Print["[4/4] Generating visualizations..."];

(* Log-log plot *)
plot1 = ListLogLogPlot[scores,
  PlotStyle -> Orange,
  PlotMarkers -> Automatic,
  Frame -> True,
  FrameLabel -> {"Prime p", "F_p(s=1)"},
  PlotLabel -> "Asymptotic behavior of F_p (epsilon = 1.0)",
  GridLines -> Automatic,
  ImageSize -> 800
];
Export["visualizations/asymptotic-fp-loglog-eps1.pdf", plot1];
Print["Saved visualizations/asymptotic-fp-loglog-eps1.pdf"];

(* Linear plot with fit *)
fitCurve = Which[
  bestModel == "log", a*Log[x] + b /. logFit,
  bestModel == "power", a*x^alpha + b /. powerFit,
  bestModel == "log-power", a*Log[x]^alpha + b /. logPowerFit
];

plot2 = Show[
  ListPlot[scores, PlotStyle -> Orange, PlotMarkers -> Automatic],
  Plot[fitCurve, {x, 2, 1000}, PlotStyle -> {Blue, Dashed}],
  Frame -> True,
  FrameLabel -> {"Prime p", "F_p(s=1)"},
  PlotLabel -> Row[{"Asymptotic fit (epsilon = 1.0): ", bestModel}],
  PlotLegends -> {"Data", "Fit"},
  ImageSize -> 800
];
Export["visualizations/asymptotic-fp-fit-eps1.pdf", plot2];
Print["Saved visualizations/asymptotic-fp-fit-eps1.pdf"];

(* Omega stratification *)
plot3 = BarChart[omegaStats[[All, {1, 3}]],
  ChartLabels -> omegaStats[[All, 1]],
  Frame -> True,
  FrameLabel -> {"Omega(n)", "Mean F_n(s=1)"},
  PlotLabel -> "F_n growth by Omega(n) (epsilon = 1.0)",
  ChartStyle -> Blue,
  ImageSize -> 800
];
Export["visualizations/omega-stratification-eps1.pdf", plot3];
Print["Saved visualizations/omega-stratification-eps1.pdf"];

(* ============================================================================ *)
(* SUMMARY                                                                     *)
(* ============================================================================ *)

Print[""];
Print["================================================================"];
Print["SUMMARY - ASYMPTOTIC ANALYSIS (EPSILON = 1.0)"];
Print["================================================================"];
Print[""];

Print["BEST FIT MODEL: ", bestModel];
Which[
  bestModel == "log",
  Print["  F_p(s=1) ≈ ", N[a /. logFit, 4], "*log(p) + ", N[b /. logFit, 4]],
  bestModel == "power",
  Print["  F_p(s=1) ≈ ", N[a /. powerFit, 4], "*p^", N[alpha /. powerFit, 4], " + ", N[b /. powerFit, 4]],
  bestModel == "log-power",
  Print["  F_p(s=1) ≈ ", N[a /. logPowerFit, 4], "*log(p)^", N[alpha /. logPowerFit, 4], " + ", N[b /. logPowerFit, 4]]
];
Print[""];

Print["OMEGA STRATIFICATION:"];
Print["  Omega(n) = 2: Mean F_n = ", N[omegaStats[[1, 3]], 4]];
Print["  Omega(n) = 3: Mean F_n = ", N[omegaStats[[2, 3]], 4]];
Print["  Omega(n) = 4: Mean F_n = ", N[omegaStats[[3, 3]], 4]];
Print[""];

Print["NEXT STEPS FOR THEORY:"];
Print["  1. Prove asymptotic formula from power mean definition"];
Print["  2. Estimate growth by Omega(n)"];
Print["  3. Prove inverse dominance using these estimates"];
Print[""];

(* Export data *)
Export["data/asymptotic-primes-eps1.csv", scores, "CSV"];
Export["data/asymptotic-composites-eps1.csv", compositeData, "CSV"];
Print["Exported data to data/ directory"];
Print[""];
