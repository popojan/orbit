#!/usr/bin/env wolframscript
(* Export soft distance visualizations as vector PDFs *)

DistanceProductSoft[x_, β_: 1] :=
  Product[
    -β * Log @ Sum[
      Exp[-Abs[x - (k*p + p^2)]/β],
      {k, 0, Floor[x/p]}
    ],
    {p, 2, x}
  ]

(* 1. Main envelope plot *)
Print["Generating envelope plot (n ≤ 127)..."];

plot1 = Table[{k, Log[1 + DistanceProductSoft[k, 1/7]]}, {k, 1, 127}] //
  ListLinePlot[
    GatherBy[#, PrimeQ@*First],
    PlotMarkers -> {Automatic},
    GridLines -> {Prime @ Range @ PrimePi @ 127, None},
    Frame -> True,
    FrameLabel -> {"n", "score"},
    PlotLabel -> "Log[1 + DistanceProductSoft[n, 1/7]], n ≤ 127",
    ImageSize -> 600
  ] &;

Export["visualizations/soft-distance-envelope-127.pdf", plot1];
Print["✓ Saved visualizations/soft-distance-envelope-127.pdf"];

(* 2. Composite types stratification *)
Print["Generating composite types plot..."];

plot2 = Module[{data, primes, primePowers, semiprimes, others},
  data = Table[{k, Log[1 + DistanceProductSoft[k, 1/7]]}, {k, 2, 100}];
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
    ImageSize -> 600]
];

Export["visualizations/soft-distance-composite-types.pdf", plot2];
Print["✓ Saved visualizations/soft-distance-composite-types.pdf"];

Print[""];
Print["Vector PDFs generated successfully!"];
