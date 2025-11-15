#!/usr/bin/env wolframscript
(* Generate nice visualizations with epsilon = 0.01 for PAPER *)

Print["================================================================"];
Print["PAPER VISUALIZATIONS - EPSILON = 0.01"];
Print["================================================================"];
Print[""];

(* ============================================================================ *)
(* P-NORM WITH EPSILON = 0.01                                                 *)
(* ============================================================================ *)

PNormValue[x_, d_, p_, eps_] := Module[{distances, powerSum, count},
  distances = Table[(x - (k*d + d^2))^2 + eps, {k, 0, Floor[x/d]}];
  count = Length[distances];
  powerSum = Total[distances^(-p)];
  N[Power[powerSum / count, -1/p]]
]

Fn[n_, s_] := Module[{terms, dMax},
  dMax = Min[Floor[Sqrt[n]], 100];
  terms = Table[
    Module[{pnorm},
      pnorm = PNormValue[n, d, 3, 0.01];  (* epsilon = 0.01 *)
      If[pnorm > 1, pnorm^(-s), 0]
    ],
    {d, 2, dMax}
  ];
  Total[terms]
]

(* ============================================================================ *)
(* ENVELOPE PLOT                                                              *)
(* ============================================================================ *)

Print["[1/2] Creating envelope visualization..."];

nMax = 127;
allData = Table[{n, Log[1 + Fn[n, 1.0]]}, {n, 2, nMax}];
primeData = Select[allData, PrimeQ[#[[1]]] &];
compositeData = Select[allData, !PrimeQ[#[[1]]] &];

plot1 = ListPlot[{primeData, compositeData},
  PlotStyle -> {Orange, Blue},
  PlotMarkers -> {{"\[FilledCircle]", 8}, {"\[FilledSquare]", 8}},
  PlotLegends -> {"Prvočísla", "Složená čísla"},
  Frame -> True,
  FrameLabel -> {"n", "log(1 + F_n)"},
  PlotLabel -> "P-normové spektrum prvočíselnosti (p=3, \[Epsilon]=1/100)",
  GridLines -> Automatic,
  ImageSize -> 700
];
Export["docs/papers/visualizations/pnorm-envelope-paper.pdf", plot1, "TextOutlines" -> True];
Print["✓ Saved docs/papers/visualizations/pnorm-envelope-paper.pdf"];

(* ============================================================================ *)
(* STRATIFICATION BY OMEGA                                                    *)
(* ============================================================================ *)

Print["[2/2] Creating Omega stratification..."];

composites = Select[Range[2, nMax], !PrimeQ[#] &];
omega2 = Select[composites, PrimeOmega[#] == 2 &];
omega3 = Select[composites, PrimeOmega[#] == 3 &];
omega4 = Select[composites, PrimeOmega[#] >= 4 &];

data2 = Table[{n, Log[1 + Fn[n, 1.0]]}, {n, omega2}];
data3 = Table[{n, Log[1 + Fn[n, 1.0]]}, {n, omega3}];
data4 = Table[{n, Log[1 + Fn[n, 1.0]]}, {n, omega4}];

plot2 = ListPlot[{primeData, data2, data3, data4},
  PlotStyle -> {Orange, Green, Blue, Red},
  PlotMarkers -> {{"\[FilledCircle]", 8}, {"\[FilledSquare]", 8}, {"\[FilledDiamond]", 8}, {"\[FilledUpTriangle]", 8}},
  PlotLegends -> {"Prvočísla", "Ω(n)=2", "Ω(n)=3", "Ω(n)≥4"},
  Frame -> True,
  FrameLabel -> {"n", "log(1 + F_n)"},
  PlotLabel -> "Stratifikace podle Ω(n) (p=3, ε=1/100)",
  GridLines -> Automatic,
  ImageSize -> 700
];
Export["docs/papers/visualizations/pnorm-stratification-paper.pdf", plot2, "TextOutlines" -> True];
Print["✓ Saved docs/papers/visualizations/pnorm-stratification-paper.pdf"];

Print[""];
Print["================================================================"];
Print["DONE - Paper visualizations with epsilon = 0.01"];
Print["================================================================"];
Print[""];
Print["Files created:"];
Print["  - docs/papers/visualizations/pnorm-envelope-paper.pdf"];
Print["  - docs/papers/visualizations/pnorm-stratification-paper.pdf"];
Print[""];
Print["Use these in the paper for nice visual contrast!");
Print[""];
