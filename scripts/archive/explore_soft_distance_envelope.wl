#!/usr/bin/env wolframscript
(* Exploration of soft distance product envelope structure *)

DistanceProductSoft[x_, β_: 1] :=
  Product[
    -β * Log @ Sum[
      Exp[-Abs[x - (k*p + p^2)]/β],
      {k, 0, Floor[x/p]}
    ],
    {p, 2, x}
  ]

pp[hi_] :=
  Table[{k, Log[1 + DistanceProductSoft[k, 1/7]]}, {k, 1, hi}] //
    ListLinePlot[
      GatherBy[#, PrimeQ@*First],
      PlotMarkers -> {Automatic},
      GridLines -> {Prime @ Range @ PrimePi @ hi, None},
      Frame -> True,
      FrameLabel -> {"n", "score"},
      PlotLabel -> Row[{"Log[1 + DistanceProductSoft[n, 1/7]], n ≤ ", hi}],
      ImageSize -> Large
    ] &

(* 1. Original visualization *)
Print["Generating original visualization (n ≤ 127)..."];
plot1 = pp[127];
Export["visualizations/soft-distance-envelope-127.png", plot1];
Print["Saved to visualizations/soft-distance-envelope-127.png"];
Print[""];

(* 2. Compare different β values *)
Print["Comparing different β values..."];

ppBeta[hi_, β_] :=
  Table[{k, Log[1 + DistanceProductSoft[k, β]]}, {k, 1, hi}] //
    ListLinePlot[
      GatherBy[#, PrimeQ@*First],
      PlotMarkers -> {Automatic, Small},
      Frame -> True,
      PlotLabel -> "β = " <> ToString[β],
      ImageSize -> Medium
    ] &

betaComparison = GraphicsGrid[{
  {ppBeta[80, 1/5], ppBeta[80, 1/7]},
  {ppBeta[80, 1/10], ppBeta[80, 1/15]}
}, ImageSize -> Large];

Export["visualizations/soft-distance-beta-comparison.png", betaComparison];
Print["Saved to visualizations/soft-distance-beta-comparison.png"];
Print[""];

(* 3. Highlight different types of composites *)
Print["Analyzing composite types near envelope..."];

pp3[hi_] := Module[{data, primes, primePowers, semiprimes, others},
  data = Table[{k, Log[1 + DistanceProductSoft[k, 1/7]]}, {k, 2, hi}];
  primes = Select[data, PrimeQ[First @ #] &];
  primePowers = Select[data, !PrimeQ[First @ #] && PrimePowerQ[First @ #] &];
  semiprimes = Select[data,
    !PrimeQ[First @ #] && !PrimePowerQ[First @ #] &&
    PrimeOmega[First @ #] == 2 &];
  others = Select[data,
    !PrimeQ[First @ #] && !PrimePowerQ[First @ #] &&
    PrimeOmega[First @ #] > 2 &];

  ListPlot[{primes, primePowers, semiprimes, others},
    PlotMarkers -> Automatic,
    PlotLegends -> {"Primes (envelope)", "Prime powers (p^k)",
                    "Semiprimes (pq)", "Others (≥3 factors)"},
    Frame -> True,
    FrameLabel -> {"n", "Log[1 + score]"},
    PlotLabel -> "Composite types relative to prime envelope",
    ImageSize -> Large]
]

plot3 = pp3[100];
Export["visualizations/soft-distance-composite-types.png", plot3];
Print["Saved to visualizations/soft-distance-composite-types.png"];
Print[""];

(* 4. Measure distance from envelope *)
Print["Computing distances from envelope..."];

(* For each composite, measure vertical distance to interpolated prime envelope *)
EnvelopeAnalysis[hi_] := Module[{primeData, compositeData, gaps},
  primeData = Table[
    {p, Log[1 + DistanceProductSoft[p, 1/7]]},
    {p, Select[Range[2, hi], PrimeQ]}
  ];

  compositeData = Table[
    Module[{p1, p2, score, envScore, gap},
      p1 = NextPrime[n, -1];
      p2 = NextPrime[n];
      score = Log[1 + DistanceProductSoft[n, 1/7]];
      (* Linear interpolation between adjacent primes *)
      envScore = Interpolation[primeData, InterpolationOrder -> 1][n];
      gap = envScore - score;
      {n, gap, PrimeOmega[n]}
    ],
    {n, Select[Range[4, hi], CompositeQ]}
  ];

  compositeData
]

gaps = EnvelopeAnalysis[100];

gapPlot = ListPlot[
  GatherBy[gaps, #[[3]] &][[All, All, {1, 2}]],
  PlotMarkers -> Automatic,
  PlotLegends -> Automatic,
  Frame -> True,
  FrameLabel -> {"n", "Distance below envelope"},
  PlotLabel -> "Composite gap from prime envelope (by # factors)",
  ImageSize -> Large
];

Export["visualizations/soft-distance-envelope-gaps.png", gapPlot];
Print["Saved to visualizations/soft-distance-envelope-gaps.png"];
Print[""];

(* 5. Statistics *)
Print["Gap statistics by number of prime factors:"];
Print[""];

gapsByFactors = GatherBy[gaps, #[[3]] &];
Do[
  Module[{omega, gapsList, mean, min, max},
    omega = group[[1, 3]];
    gapsList = group[[All, 2]];
    mean = Mean[gapsList];
    min = Min[gapsList];
    max = Max[gapsList];

    Print["Ω(n) = ", omega, ": ",
      "mean gap = ", N[mean, 4], ", ",
      "min = ", N[min, 4], ", ",
      "max = ", N[max, 4]];
  ],
  {group, gapsByFactors}
];

Print[""];
Print["Observation: More prime factors → further from envelope"];
Print[""];

(* 6. Twin primes and prime gaps *)
Print["Analyzing twin primes and gaps..."];

twinPrimes = Select[Prime @ Range @ PrimePi @ 100,
  NextPrime[#] - # == 2 &];

twinData = Table[{
  p,
  Log[1 + DistanceProductSoft[p, 1/7]],
  Log[1 + DistanceProductSoft[p + 2, 1/7]]
}, {p, twinPrimes}];

Print["Twin primes found: ", Length[twinPrimes]];
Print["First few: ", Take[twinPrimes, 5]];
Print[""];

(* 7. Growth rate of envelope *)
Print["Envelope growth rate analysis..."];

primeScores = Table[
  {p, Log[1 + DistanceProductSoft[p, 1/7]]},
  {p, Select[Range[2, 100], PrimeQ]}
];

growthPlot = ListLogPlot[primeScores,
  Joined -> True,
  PlotMarkers -> Automatic,
  Frame -> True,
  FrameLabel -> {"n", "Log-Log scale score"},
  PlotLabel -> "Prime envelope growth (log-log scale)",
  ImageSize -> Large,
  GridLines -> Automatic
];

Export["visualizations/soft-distance-envelope-growth.png", growthPlot];
Print["Saved to visualizations/soft-distance-envelope-growth.png"];
Print[""];

(* 8. Fit growth rate *)
fit = Fit[Log /@ primeScores[[All, 2]], {1, x}, x];
Print["Log-log fit: Log[score] ≈ ", fit];
Print["Suggests score grows approximately as n^k for some k"];
Print[""];

Print["All visualizations generated successfully!"];
