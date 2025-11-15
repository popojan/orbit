#!/usr/bin/env wolframscript
(* Export soft distance visualizations with squared distances - numerically stable *)

(* Numerically stable soft-minimum with squared distances *)
SoftMinDistanceSquared[x_, p_, alpha_] := Module[{distances, negDistSq, M},
  (* Squared distances for all k *)
  distances = Table[(x - (k*p + p^2))^2, {k, 0, Floor[x/p]}];

  (* Negative squared distances * alpha (exponent arguments) *)
  negDistSq = -alpha * distances;

  (* Maximum for log-sum-exp stability *)
  M = Max[negDistSq];

  (* Stable soft-min: -1/alpha * (M + log(sum(exp(negDistSq - M)))) *)
  -1/alpha * (M + Log[Total[Exp[negDistSq - M]]])
]

(* Overall product score (numerically stable) *)
DistanceProductSoftSquaredStable[x_, alpha_: 7] :=
  Product[SoftMinDistanceSquared[x, p, alpha], {p, 2, x}]

(* Parameters *)
nMax = 250;  (* Maximum n to compute *)
alpha = 7;       (* Sharpness parameter (inverted beta, where beta = 1/alpha) *)

Print["Parameters:"];
Print["  n ∈ [1, ", nMax, "]"];
Print["  alpha = ", alpha, " (equivalent to beta = ", N[1/alpha], ")"];
Print["  Using squared distances with log-sum-exp stabilization"];
Print[""];

(* 1. Main envelope plot *)
Print["Generating envelope plot (n ≤ ", nMax, ")..."];

plot1 = Table[{k, Log[1 + DistanceProductSoftSquaredStable[k, alpha]]}, {k, 1, nMax}] //
  ListLinePlot[
    GatherBy[#, PrimeQ@*First],
    PlotMarkers -> {Automatic},
    GridLines -> {Prime @ Range @ PrimePi @ nMax, None},
    Frame -> True,
    FrameLabel -> {"n", "Log[1 + score]"},
    PlotLabel -> Row[{
      "Soft-min with d² distance | alpha = ", alpha, " | n ≤ ", nMax
    }],
    PlotStyle -> {
      Directive[Orange, PointSize[0.012]],     (* Primes *)
      Directive[Blue, PointSize[0.01]]         (* Composites *)
    },
    PlotLegends -> {"Primes (envelope)", "Composites"},
    ImageSize -> 700
  ] &;

Export["visualizations/soft-distance-squared-envelope-" <> ToString[nMax] <> ".pdf", plot1];
Print["✓ Saved visualizations/soft-distance-squared-envelope-", nMax, ".pdf"];

(* 2. Composite types stratification *)
Print["Generating composite types stratification..."];

nStratMax = Min[100, nMax];  (* Use smaller range for stratification clarity *)

plot2 = Module[{data, primes, primePowers, semiprimes, others},
  data = Table[{k, Log[1 + DistanceProductSoftSquaredStable[k, alpha]]}, {k, 2, nStratMax}];

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
    PlotStyle -> {
      Directive[Orange, PointSize[0.012]],     (* Primes *)
      Directive[Green, PointSize[0.01]],       (* Prime powers *)
      Directive[Blue, PointSize[0.01]],        (* Semiprimes *)
      Directive[Red, PointSize[0.01]]          (* Others *)
    },
    PlotLegends -> {
      "Primes (envelope)",
      "Prime powers p^k (k≥2)",
      "Semiprimes pq",
      "Ω(n) ≥ 3"
    },
    Frame -> True,
    FrameLabel -> {"n", "Log[1 + score]"},
    PlotLabel -> Row[{
      "Stratification by Ω(n) | alpha = ", alpha, " | squared distances"
    }],
    ImageSize -> 700]
];

Export["visualizations/soft-distance-squared-composite-types.pdf", plot2];
Print["✓ Saved visualizations/soft-distance-squared-composite-types.pdf"];

(* 3. Comparison with linear distance (if time permits) *)
Print[""];
Print["Generating comparison with linear distance..."];

(* Original linear distance (for comparison) *)
DistanceProductSoftLinear[x_, alpha_: 7] :=
  Product[
    -1/alpha * Log @ Sum[
      Exp[-alpha * Abs[x - (k*p + p^2)]],
      {k, 0, Floor[x/p]}
    ],
    {p, 2, x}
  ]

nCompMax = Min[60, nMax];  (* Smaller range for comparison clarity *)

plot3 = Module[{dataLinear, dataSquared},
  dataLinear = Table[{k, Log[1 + DistanceProductSoftLinear[k, alpha]]}, {k, 1, nCompMax}];
  dataSquared = Table[{k, Log[1 + DistanceProductSoftSquaredStable[k, alpha]]}, {k, 1, nCompMax}];

  ListLinePlot[{dataLinear, dataSquared},
    PlotMarkers -> {Automatic, Automatic},
    PlotStyle -> {
      Directive[Gray, Dashed],
      Directive[Blue, Thickness[0.004]]
    },
    PlotLegends -> {"Linear distance |d|", "Squared distance d²"},
    Frame -> True,
    FrameLabel -> {"n", "Log[1 + score]"},
    PlotLabel -> Row[{"Comparison: |d| vs d² | alpha = ", alpha}],
    ImageSize -> 700]
];

Export["visualizations/soft-distance-comparison-linear-vs-squared.pdf", plot3];
Print["✓ Saved visualizations/soft-distance-comparison-linear-vs-squared.pdf"];

Print[""];
Print["All visualizations generated successfully!"];
Print[""];
Print["Summary:"];
Print["  1. Envelope plot: primes vs composites"];
Print["  2. Stratification: by prime factorization type Ω(n)"];
Print["  3. Comparison: linear |d| vs squared d² distances"];
Print[""];
Print["Next steps:"];
Print["  - Adjust alpha to control sharpness (higher alpha → sharper separation)"];
Print["  - Adjust nMax to explore larger ranges (may be slower)"];
Print["  - Compare different distance powers (d^γ for γ = 1, 1.5, 2, 3)"];
