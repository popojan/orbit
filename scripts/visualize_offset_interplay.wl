#!/usr/bin/env wolframscript
(* Visualize the interplay between offset a and value m *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Analyzing Interplay Between Offset a and Stabilization m"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

(* Compute ratio grid *)
Print["Computing ratio grid (this may take a moment)...\n"];

maxA = 12;
maxM = 81;

ratioData = Table[
  Module[{kMax, sum, denom, prim, ratio},
    kMax = Floor[(m-1)/2];

    If[kMax < a,
      Missing["NotEnoughTerms"],
      sum = Sum[(-1)^k * (k-a)!/(2k+1), {k, a, kMax}];
      denom = Denominator[sum];
      prim = Primorial[m];
      ratio = N[prim/denom];
      ratio
    ]
  ],
  {a, 0, maxA},
  {m, 3, maxM, 2}
];

(* Create line plots for each offset *)
Print["Creating line plots for each offset...\n"];

plots = Table[
  Module[{data, validData, mVals},
    data = ratioData[[a+1]];
    mVals = Range[3, maxM, 2];
    validData = Select[Transpose[{mVals, data}], NumericQ[#[[2]]] &];

    If[Length[validData] > 0,
      ListLinePlot[validData,
        PlotLabel -> "Offset a=" <> ToString[a] <> " [(k-" <> ToString[a] <> ")!]",
        AxesLabel -> {"m", "Primorial/Denominator"},
        PlotStyle -> Thick,
        GridLines -> Automatic,
        ImageSize -> 400,
        PlotRange -> {Automatic, {0, Automatic}}
      ],
      Nothing
    ]
  ],
  {a, 0, Min[maxA, 11]}
];

(* Export individual plots *)
Export["/home/jan/github/orbit/reports/offset_evolution_grid.png",
  GraphicsGrid[Partition[plots, 3, 3, 1, {}],
    ImageSize -> 1200,
    Spacings -> {10, 10}
  ]
];

Print["✓ Exported: reports/offset_evolution_grid.png\n"];

(* Create combined plot *)
Print["Creating combined comparison plot...\n"];

combinedData = Table[
  Module[{data, validData, mVals},
    data = ratioData[[a+1]];
    mVals = Range[3, maxM, 2];
    validData = Select[Transpose[{mVals, data}], NumericQ[#[[2]]] &];
    If[Length[validData] > 5, validData, Nothing]
  ],
  {a, 0, 8}
];

combinedPlot = ListLinePlot[combinedData,
  PlotLabel -> "Ratio Evolution for Different Offsets",
  AxesLabel -> {"m", "Primorial/Denominator"},
  PlotLegends -> Table["a=" <> ToString[a], {a, 0, 8}],
  PlotStyle -> Thick,
  GridLines -> Automatic,
  ImageSize -> 800,
  PlotRange -> {{0, maxM}, {0, 10}}
];

Export["/home/jan/github/orbit/reports/offset_comparison.png", combinedPlot];
Print["✓ Exported: reports/offset_comparison.png\n"];

(* Create heatmap *)
Print["Creating heatmap visualization...\n"];

(* Convert to log scale for better visualization *)
logRatioData = ratioData /. {
  x_?NumericQ :> If[x > 0, Log[10, x], Missing[]],
  Missing[_] -> Missing[]
};

heatmap = ArrayPlot[logRatioData,
  ColorFunction -> "TemperatureMap",
  PlotLabel -> "Log10(Primorial/Denominator) Heatmap",
  FrameLabel -> {"m (odd values from 3 to " <> ToString[maxM] <> ")",
                 "Offset a"},
  PlotLegends -> Automatic,
  ImageSize -> 800,
  DataReversed -> True,
  FrameTicks -> {
    {Table[{i, ToString[i]}, {i, 0, maxA, 2}], None},
    {Table[{(m-3)/2 + 1, ToString[m]}, {m, 3, maxM, 10}], None}
  }
];

Export["/home/jan/github/orbit/reports/offset_heatmap.png", heatmap];
Print["✓ Exported: reports/offset_heatmap.png\n"];

(* Analyze stabilization pattern *)
Print["Analyzing stabilization patterns...\n"];

stabilizationData = Table[
  Module[{data, mVals, validData, lastN, stableRatio, firstStable},
    data = ratioData[[a+1]];
    mVals = Range[3, maxM, 2];
    validData = Select[Transpose[{mVals, data}], NumericQ[#[[2]]] &];

    If[Length[validData] < 10,
      {a, Missing["TooFew"], Missing[], Missing[]},

      lastN = 10;
      lastValues = Take[validData[[All, 2]], -lastN];

      If[StandardDeviation[lastValues] < 0.001,
        (* Stable *)
        stableRatio = Mean[lastValues];

        (* Find first stable point *)
        firstStable = Missing[];
        Do[
          If[i >= 5,
            subset = validData[[i;;, 2]];
            If[StandardDeviation[subset] < 0.001,
              firstStable = validData[[i, 1]];
              Break[];
            ]
          ],
          {i, 1, Length[validData]}
        ];

        {a, stableRatio, firstStable, Length[validData]},

        (* Not stable *)
        {a, Missing["Unstable"], Missing[], Length[validData]}
      ]
    ]
  ],
  {a, 0, maxA}
];

(* Create stabilization plot *)
stablePoints = Select[stabilizationData,
  NumericQ[#[[2]]] && NumericQ[#[[3]]] &
];

If[Length[stablePoints] > 0,
  (* Plot 1: Stabilization point vs offset *)
  stabilizationPlot = ListPlot[
    stablePoints[[All, {1, 3}]],
    PlotLabel -> "Stabilization Point vs Offset",
    AxesLabel -> {"Offset a", "m where ratio stabilizes"},
    PlotStyle -> {PointSize[0.02], Red},
    GridLines -> Automatic,
    ImageSize -> 600,
    Joined -> False
  ];

  Export["/home/jan/github/orbit/reports/stabilization_points.png",
    stabilizationPlot];
  Print["✓ Exported: reports/stabilization_points.png\n"];

  (* Plot 2: Stable ratio vs offset *)
  stableRatioPlot = ListPlot[
    stablePoints[[All, {1, 2}]],
    PlotLabel -> "Stable Ratio vs Offset",
    AxesLabel -> {"Offset a", "Stable Primorial/Denominator"},
    PlotStyle -> {PointSize[0.02], Blue},
    GridLines -> Automatic,
    ImageSize -> 600,
    Joined -> False
  ];

  Export["/home/jan/github/orbit/reports/stable_ratios.png",
    stableRatioPlot];
  Print["✓ Exported: reports/stable_ratios.png\n"];
];

(* Create analysis table *)
Print[StringRepeat["=", 70]];
Print["DETAILED ANALYSIS TABLE"];
Print[StringRepeat["=", 70], "\n"];

Print[Grid[
  Prepend[
    Table[
      {
        a,
        If[NumericQ[stabilizationData[[a+1, 2]]],
          NumberForm[stabilizationData[[a+1, 2]], {5, 3}],
          stabilizationData[[a+1, 2]]
        ],
        If[NumericQ[stabilizationData[[a+1, 3]]],
          stabilizationData[[a+1, 3]],
          "N/A"
        ],
        If[a > 0, NumberForm[N[a!], {4, 1}], "1"],
        (* Advantage metric: (factorial reduction) / (delay cost) *)
        If[NumericQ[stabilizationData[[a+1, 3]]] && a > 0,
          NumberForm[N[a! / stabilizationData[[a+1, 3]]], {4, 2}],
          "N/A"
        ]
      },
      {a, 0, maxA}
    ],
    {"a", "Stable Ratio", "Stable from m", "a! (reduction)", "a!/m_stable"}
  ],
  Frame -> All,
  Alignment -> Left
]];

(* Identify "good" offsets *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["GOOD OFFSETS (ratio ≈ 2 with reasonable stabilization point)"];
Print[StringRepeat["=", 70], "\n"];

goodOffsets = Select[stabilizationData,
  NumericQ[#[[2]]] && NumericQ[#[[3]]] &&
  Abs[#[[2]] - 2.0] < 0.1 &&  (* Close to ratio = 2 *)
  #[[3]] < 50 &                (* Stabilizes before m=50 *)
];

If[Length[goodOffsets] > 0,
  Do[
    {a, ratio, mStable, nTerms} = offset;
    reduction = If[a > 0, a!, 1];
    Print["a=", a, ": (k-", a, ")!"];
    Print["  Factorial reduction: ", NumberForm[N[reduction], {6, 1}], "x"];
    Print["  Stable from: m=", mStable];
    Print["  Stable ratio: ", NumberForm[ratio, {5, 3}], " (gives Primorial/2)"];
    Print["  Efficiency: ", NumberForm[N[reduction/mStable], {4, 2}],
          " (reduction per m-delay)"];
    Print[""];
    ,
    {offset, goodOffsets}
  ];

  (* Find optimal *)
  bestOffset = Last[SortBy[goodOffsets, #[[1]]! / #[[3]] &]];
  Print["★ OPTIMAL CHOICE: a=", bestOffset[[1]]];
  Print["  Best tradeoff between factorial reduction and stabilization delay"];
];

Print["Done!"];
