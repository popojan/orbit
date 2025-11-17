#!/usr/bin/env wolframscript
(*
Visualize geometric structure of (n,d) space for pellc rational solutions
Generate plots to reveal patterns invisible in numerical data
*)

Print["=== GENERATING GEOMETRIC VISUALIZATIONS ==="];
Print[];

(* Check if nd² - 1 is a perfect square *)
IsPerfectSquare[disc_] := Module[{sqrtDisc},
  If[disc < 0, Return[False]];
  sqrtDisc = Sqrt[disc];
  (IntegerQ[sqrtDisc] || Head[sqrtDisc] === Rational) && disc >= 0
]

(* Generate all points *)
GeneratePoints[maxDenom_] := Module[{
    nVals, dVals, points = {}, disc
  },
  nVals = Join[
    FareySequence[maxDenom],
    1 + FareySequence[maxDenom],
    2 + FareySequence[maxDenom],
    3 + FareySequence[maxDenom],
    4 + FareySequence[maxDenom]
  ];
  nVals = DeleteDuplicates[Select[nVals, # > 0 &]];
  dVals = nVals;

  Print["Generating points with denom ≤ ", maxDenom, "..."];

  Do[
    Do[
      disc = n * d^2 - 1;
      If[IsPerfectSquare[disc],
        AppendTo[points, {N[n], N[d], disc, Sqrt[disc]}]
      ],
      {d, dVals}
    ],
    {n, nVals}
  ];

  Print["Found ", Length[points], " points"];
  points
]

(* Generate points *)
maxDenom = 30;
points = GeneratePoints[maxDenom];

Print[];
Print["Creating visualizations..."];
Print[];

(* Extract coordinates *)
coords = points[[All, {1, 2}]];
discs = points[[All, 3]];
sqrtDiscs = points[[All, 4]];

(* Plot 1: Basic scatter in (n,d) space *)
Print["Plot 1: (n,d) scatter plot"];
plot1 = ListPlot[coords,
  PlotLabel -> "pellc Rational Solutions: nd² - 1 = k²",
  AxesLabel -> {"n", "d"},
  PlotStyle -> {PointSize[0.008], Opacity[0.6]},
  AspectRatio -> 1,
  PlotRange -> {{0, 5}, {0, 5}},
  GridLines -> Automatic,
  ImageSize -> 600
];

Export["visualizations/pellc_scatter.png", plot1];
Print["  Saved: visualizations/pellc_scatter.png"];
Print[];

(* Plot 2: Color-coded by discriminant value *)
Print["Plot 2: Colored by discriminant k²"];

(* Discretize discriminants for coloring *)
uniqueDiscs = Sort[DeleteDuplicates[discs]];
colorMap = Association[Thread[uniqueDiscs -> Range[Length[uniqueDiscs]]]];
colors = colorMap /@ discs;

plot2 = ListPlot[coords,
  PlotLabel -> "Colored by discriminant k² = nd² - 1",
  AxesLabel -> {"n", "d"},
  PlotStyle -> {PointSize[0.01], Opacity[0.7]},
  AspectRatio -> 1,
  PlotRange -> {{0, 5}, {0, 5}},
  PlotLegends -> Placed[
    SwatchLegend[
      ColorData["Rainbow"] /@ Rescale[Range[Min[10, Length[uniqueDiscs]]]],
      Take[uniqueDiscs, Min[10, Length[uniqueDiscs]]]
    ],
    Right
  ],
  ColorFunction -> Function[{x, y},
    ColorData["Rainbow"][Rescale[colorMap[discs[[Position[coords, {x, y}][[1, 1]]]]], {1, Length[uniqueDiscs]}]]
  ],
  ImageSize -> 700
];

Export["visualizations/pellc_colored.png", plot2];
Print["  Saved: visualizations/pellc_colored.png"];
Print[];

(* Plot 3: Hyperbola families *)
Print["Plot 3: Hyperbola families nd² = k² + 1"];

(* Select a few discriminant values to show hyperbolas *)
selectedDiscs = Take[Sort[uniqueDiscs], Min[8, Length[uniqueDiscs]]];

hyperbolaPlots = Table[
  Module[{k2 = disc, k},
    k = Sqrt[k2];
    Plot[Sqrt[(k2 + 1)/n], {n, 0.1, 5},
      PlotStyle -> {Thick, Opacity[0.5]},
      PlotLabel -> "k² = " <> ToString[k2]
    ]
  ],
  {disc, selectedDiscs}
];

plot3 = Show[
  hyperbolaPlots,
  ListPlot[coords, PlotStyle -> {Black, PointSize[0.008]}],
  PlotLabel -> "Hyperbola families: nd² = k² + 1",
  AxesLabel -> {"n", "d"},
  AspectRatio -> 1,
  PlotRange -> {{0, 5}, {0, 3}},
  ImageSize -> 700
];

Export["visualizations/pellc_hyperbolas.png", plot3];
Print["  Saved: visualizations/pellc_hyperbolas.png"];
Print[];

(* Plot 4: Distribution of discriminants *)
Print["Plot 4: Discriminant distribution"];

discHistogram = Histogram[sqrtDiscs,
  PlotLabel -> "Distribution of √(nd² - 1) values",
  AxesLabel -> {"√k", "Count"},
  ImageSize -> 600
];

Export["visualizations/pellc_disc_histogram.png", discHistogram];
Print["  Saved: visualizations/pellc_disc_histogram.png"];
Print[];

(* Plot 5: Separate primes vs composites for n *)
Print["Plot 5: Primes vs composites"];

primePts = Select[points, PrimeQ[Numerator[#[[1]]]] && Denominator[#[[1]]] == 1 &][[All, {1, 2}]];
compositePts = Select[points, !PrimeQ[Numerator[#[[1]]]] || Denominator[#[[1]]] != 1 &][[All, {1, 2}]];

plot5 = ListPlot[{primePts, compositePts},
  PlotLabel -> "Prime vs Composite n values",
  AxesLabel -> {"n", "d"},
  PlotStyle -> {
    {Red, PointSize[0.012], Opacity[0.8]},
    {Blue, PointSize[0.008], Opacity[0.4]}
  },
  AspectRatio -> 1,
  PlotRange -> {{0, 5}, {0, 5}},
  PlotLegends -> {"Prime n", "Composite/Rational n"},
  ImageSize -> 600
];

Export["visualizations/pellc_primes.png", plot5];
Print["  Saved: visualizations/pellc_primes.png"];
Print[];

(* Plot 6: Log-log plot with different k² families *)
Print["Plot 6: Points grouped by discriminant family"];

(* Group by discriminant *)
families = GatherBy[points, #[[3]] &];
Print["Found ", Length[families], " distinct discriminant values"];

(* Take largest families *)
sortedFamilies = SortBy[families, -Length[#] &];
topFamilies = Take[sortedFamilies, Min[12, Length[sortedFamilies]]];

familyPlots = Table[
  Module[{fam = family, coords, disc},
    coords = fam[[All, {1, 2}]];
    disc = fam[[1, 3]];
    {coords, "k² = " <> ToString[disc]}
  ],
  {family, topFamilies}
];

plot6 = ListPlot[familyPlots[[All, 1]],
  PlotLabel -> "Largest discriminant families",
  AxesLabel -> {"n", "d"},
  PlotLegends -> familyPlots[[All, 2]],
  PlotStyle -> Table[{PointSize[0.01], Opacity[0.7]}, {Length[topFamilies]}],
  AspectRatio -> 1,
  PlotRange -> {{0, 5}, {0, 5}},
  ImageSize -> 700
];

Export["visualizations/pellc_families.png", plot6];
Print["  Saved: visualizations/pellc_families.png"];
Print[];

(* Summary *)
Print[StringRepeat["=", 70]];
Print["VISUALIZATION COMPLETE"];
Print[StringRepeat["=", 70]];
Print[];
Print["Generated plots:"];
Print["  1. visualizations/pellc_scatter.png - Basic (n,d) scatter"];
Print["  2. visualizations/pellc_colored.png - Color-coded by discriminant"];
Print["  3. visualizations/pellc_hyperbolas.png - Hyperbola families"];
Print["  4. visualizations/pellc_disc_histogram.png - Discriminant distribution"];
Print["  5. visualizations/pellc_primes.png - Primes vs composites"];
Print["  6. visualizations/pellc_families.png - Top discriminant families"];
Print[];
Print["Open these images to explore geometric structure!"];
