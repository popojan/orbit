#!/usr/bin/env wolframscript
(* Compare p-norm soft-min with exp/log soft-min *)

(* ============================================================================ *)
(* SYMBOLIC VARIANTS (for theoretical work - clean, differentiable)            *)
(* ============================================================================ *)

(* Pure symbolic p-norm soft-min (single p depth) *)
SoftMinPNormSymbolic[x_, p_, pDepth_] :=
  Power[
    Sum[(x - (k*pDepth + pDepth^2))^(-2*p), {k, 0, Floor[x/pDepth]}] / (Floor[x/pDepth] + 1),
    -1/p
  ]

(* Pure symbolic overall score *)
DistanceProductPNormSymbolic[x_, p_: 2] :=
  Product[SoftMinPNormSymbolic[x, p, pDepth], {pDepth, 2, x}]

(* Pure symbolic exp/log soft-min (original, with squared distances) *)
SoftMinExpLogSymbolic[x_, alpha_, pDepth_] :=
  -1/alpha * Log[Sum[Exp[-alpha * (x - (k*pDepth + pDepth^2))^2], {k, 0, Floor[x/pDepth]}]]

DistanceProductExpLogSymbolic[x_, alpha_: 7] :=
  Product[SoftMinExpLogSymbolic[x, alpha, pDepth], {pDepth, 2, x}]


(* ============================================================================ *)
(* NUMERICAL VARIANTS (stable for large x, efficient for plotting)             *)
(* ============================================================================ *)

(* Numerically stable p-norm soft-min *)
SoftMinPNorm[x_, p_, pDepth_] := Module[{distances},
  distances = Table[(x - (k*pDepth + pDepth^2))^2, {k, 0, Floor[x/pDepth]}];
  Power[Mean[Power[distances, -p]], -1/p]
]

(* Overall product score (p-norm) *)
DistanceProductPNorm[x_, p_: 2] :=
  Product[SoftMinPNorm[x, p, pDepth], {pDepth, 2, x}]

(* Numerically stable exp/log soft-min (log-sum-exp trick) *)
SoftMinExpLog[x_, alpha_, pDepth_] := Module[{distances, negDistSq, M},
  distances = Table[(x - (k*pDepth + pDepth^2))^2, {k, 0, Floor[x/pDepth]}];
  negDistSq = -alpha * distances;
  M = Max[negDistSq];
  -1/alpha * (M + Log[Total[Exp[negDistSq - M]]])
]

(* Overall product score (exp/log) *)
DistanceProductExpLog[x_, alpha_: 7] :=
  Product[SoftMinExpLog[x, alpha, pDepth], {pDepth, 2, x}]


(* ============================================================================ *)
(* PARAMETERS                                                                   *)
(* ============================================================================ *)

nMax = 150;           (* Maximum n for comparison *)
alphaExpLog = 7;      (* Sharpness for exp/log variant *)
pNormValues = {1, 2, 5, 10};  (* Different p values to test *)

Print["Parameters:"];
Print["  n ∈ [1, ", nMax, "]"];
Print["  Exp/log: alpha = ", alphaExpLog];
Print["  P-norm: p ∈ ", pNormValues];
Print[""];


(* ============================================================================ *)
(* VISUALIZATION 1: Comparison of different p-norm values                      *)
(* ============================================================================ *)

Print["Generating p-norm comparison (p = 1, 2, 5, 10)..."];

nPNormMax = Min[100, nMax];

plotPNormComparison = Module[{datasets},
  datasets = Table[
    {p, Table[{k, Log[1 + DistanceProductPNorm[k, p]]}, {k, 1, nPNormMax}]},
    {p, pNormValues}
  ];

  ListLinePlot[
    datasets[[All, 2]],
    PlotLegends -> (Row[{"p = ", #}] & /@ pNormValues),
    PlotStyle -> Table[Directive[Thickness[0.005]], {Length[pNormValues]}],
    Frame -> True,
    FrameLabel -> {"n", "Log[1 + score]"},
    PlotLabel -> "P-norm soft-min comparison | Higher p → sharper minimum",
    GridLines -> {Prime @ Range @ PrimePi @ nPNormMax, None},
    ImageSize -> 700
  ]
];

Export["visualizations/pnorm-comparison-different-p.pdf", plotPNormComparison];
Print["✓ Saved visualizations/pnorm-comparison-different-p.pdf"];


(* ============================================================================ *)
(* VISUALIZATION 2: P-norm vs Exp/log (matched "sharpness")                    *)
(* ============================================================================ *)

Print[""];
Print["Generating p-norm vs exp/log comparison..."];

(* Try to match sharpness: p=5 is roughly comparable to alpha=7 *)
pMatched = 5;
nCompMax = Min[80, nMax];

plotMethodComparison = Module[{dataPNorm, dataExpLog, primesPNorm, compPNorm, primesExpLog, compExpLog},
  (* Compute data *)
  dataPNorm = Table[{k, Log[1 + DistanceProductPNorm[k, pMatched]]}, {k, 1, nCompMax}];
  dataExpLog = Table[{k, Log[1 + DistanceProductExpLog[k, alphaExpLog]]}, {k, 1, nCompMax}];

  (* Separate primes and composites *)
  primesPNorm = Select[dataPNorm, PrimeQ[First[#]] &];
  compPNorm = Select[dataPNorm, !PrimeQ[First[#]] &];
  primesExpLog = Select[dataExpLog, PrimeQ[First[#]] &];
  compExpLog = Select[dataExpLog, !PrimeQ[First[#]] &];

  ListPlot[
    {primesPNorm, compPNorm, primesExpLog, compExpLog},
    PlotMarkers -> {
      Graphics[{Orange, Disk[]}, ImageSize -> 10],
      Graphics[{Blue, Disk[]}, ImageSize -> 8],
      Graphics[{Orange, EdgeForm[Black], FaceForm[], Circle[]}, ImageSize -> 10],
      Graphics[{Blue, EdgeForm[Black], FaceForm[], Circle[]}, ImageSize -> 8]
    },
    PlotLegends -> {
      Row[{"P-norm (p=", pMatched, "): Primes"}],
      Row[{"P-norm (p=", pMatched, "): Composites"}],
      Row[{"Exp/log (α=", alphaExpLog, "): Primes"}],
      Row[{"Exp/log (α=", alphaExpLog, "): Composites"}]
    },
    Frame -> True,
    FrameLabel -> {"n", "Log[1 + score]"},
    PlotLabel -> Row[{"Method comparison | P-norm (filled) vs Exp/log (hollow)"}],
    GridLines -> {Prime @ Range @ PrimePi @ nCompMax, None},
    ImageSize -> 700
  ]
];

Export["visualizations/pnorm-vs-explog-comparison.pdf", plotMethodComparison];
Print["✓ Saved visualizations/pnorm-vs-explog-comparison.pdf"];


(* ============================================================================ *)
(* VISUALIZATION 3: Envelope with p-norm (like original style)                 *)
(* ============================================================================ *)

Print[""];
Print["Generating p-norm envelope (p=3 for better stratification)..."];

pEnv = 3;  (* Use p=3 for better balance between sharpness and stratification *)
nEnvMax = Min[150, nMax];

plotPNormEnvelope = Table[{k, Log[1 + DistanceProductPNorm[k, pEnv]]}, {k, 1, nEnvMax}] //
  ListLinePlot[
    GatherBy[#, PrimeQ@*First],
    PlotMarkers -> {Automatic},
    GridLines -> {Prime @ Range @ PrimePi @ nEnvMax, None},
    Frame -> True,
    FrameLabel -> {"n", "Log[1 + score]"},
    PlotLabel -> Row[{"P-norm envelope | p = ", pEnv, " | n ≤ ", nEnvMax}],
    PlotStyle -> {
      Directive[Orange, PointSize[0.012]],     (* Primes *)
      Directive[Blue, PointSize[0.01]]         (* Composites *)
    },
    PlotLegends -> {"Primes (envelope)", "Composites"},
    ImageSize -> 700
  ] &;

Export["visualizations/pnorm-envelope-p" <> ToString[pEnv] <> ".pdf", plotPNormEnvelope];
Print["✓ Saved visualizations/pnorm-envelope-p", pEnv, ".pdf"];

(* Also generate with p=5 for comparison *)
Print[""];
Print["Generating p-norm envelope (p=5 for sharper separation)..."];

pEnvSharp = 5;

plotPNormEnvelopeSharp = Table[{k, Log[1 + DistanceProductPNorm[k, pEnvSharp]]}, {k, 1, nEnvMax}] //
  ListLinePlot[
    GatherBy[#, PrimeQ@*First],
    PlotMarkers -> {Automatic},
    GridLines -> {Prime @ Range @ PrimePi @ nEnvMax, None},
    Frame -> True,
    FrameLabel -> {"n", "Log[1 + score]"},
    PlotLabel -> Row[{"P-norm envelope | p = ", pEnvSharp, " | n ≤ ", nEnvMax}],
    PlotStyle -> {
      Directive[Orange, PointSize[0.012]],     (* Primes *)
      Directive[Blue, PointSize[0.01]]         (* Composites *)
    },
    PlotLegends -> {"Primes (envelope)", "Composites"},
    ImageSize -> 700
  ] &;

Export["visualizations/pnorm-envelope-p" <> ToString[pEnvSharp] <> ".pdf", plotPNormEnvelopeSharp];
Print["✓ Saved visualizations/pnorm-envelope-p", pEnvSharp, ".pdf"];


(* ============================================================================ *)
(* SUMMARY                                                                      *)
(* ============================================================================ *)

Print[""];
Print["All visualizations generated successfully!"];
Print[""];
Print["Summary:"];
Print["  1. P-norm comparison: effect of p on sharpness (p = 1, 2, 5, 10)"];
Print["  2. Method comparison: p-norm (p=5) vs exp/log (α=7)"];
Print["  3. P-norm envelope: p=3 (balanced) and p=5 (sharp)"];
Print[""];
Print["Key insights:"];
Print["  - P-norm is algebraically cleaner (no exp/log, no abs)"];
Print["  - Higher p → sharper approximation to true minimum"];
Print["  - p ≈ 5 gives similar results to exp/log with α ≈ 7"];
Print["  - p = 3 provides good balance for visualizing stratification"];
Print["  - p = 5+ is very sharp (binary: prime vs composite)"];
Print["  - Both methods show same envelope structure"];
Print[""];
Print["Symbolic variants available for theoretical work:"];
Print["  - SoftMinPNormSymbolic[x, p, pDepth]"];
Print["  - DistanceProductPNormSymbolic[x, p]"];
Print["  - SoftMinExpLogSymbolic[x, alpha, pDepth]"];
Print["  - DistanceProductExpLogSymbolic[x, alpha]"];
Print[""];
Print["For paper:"];
Print["  - Main: exp/log with d² (best stratification visibility)"];
Print["  - Alternative: p-norm (cleaner algebra, same envelope)"];
Print["  - Mention: d² eliminates abs(), α = 1/β is more intuitive"];
