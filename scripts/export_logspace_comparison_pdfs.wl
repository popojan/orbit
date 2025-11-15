#!/usr/bin/env wolframscript
(* Log-space aggregation (sum of logs instead of product) *)

(* ============================================================================ *)
(* COMPLETE FORMULAS FOR COPY-PASTE TO WOLFRAM DESKTOP                        *)
(* ============================================================================ *)

(*
   P-NORM VERSION (two parameters: n, p)
   =====================================

   Clean symbolic formula (no Table/Module):

   LogSpaceScorePNorm[n_, p_] :=
     Sum[
       Log[Power[
         Sum[(n - (k*pDepth + pDepth^2))^(-2*p), {k, 0, Floor[n/pDepth]}] / (Floor[n/pDepth] + 1),
         -1/p
       ]],
       {pDepth, 2, n}
     ]

   Usage:
   - n: integer to test (1, 2, 3, ...)
   - p: sharpness parameter (try p = 2, 3, 5)
   - Higher p → sharper separation
   - Returns: log-space score (higher = more prime-like)

   Example:
   LogSpaceScorePNorm[17, 3]  (* score for prime 17 with p=3 *)
   LogSpaceScorePNorm[18, 3]  (* score for composite 18 with p=3 *)


   EXP/LOG VERSION (two parameters: n, alpha)
   ==========================================

   Clean symbolic formula (no Table/Module):

   LogSpaceScoreExpLog[n_, alpha_] :=
     Sum[
       Log[-1/alpha * Log[Sum[Exp[-alpha * (n - (k*pDepth + pDepth^2))^2], {k, 0, Floor[n/pDepth]}]]],
       {pDepth, 2, n}
     ]

   Usage:
   - n: integer to test
   - alpha: sharpness parameter (try alpha = 5, 7, 10)
   - Higher alpha → sharper separation
   - Returns: log-space score (higher = more prime-like)

   Example:
   LogSpaceScoreExpLog[17, 7]  (* score for prime 17 with alpha=7 *)
   LogSpaceScoreExpLog[18, 7]  (* score for composite 18 with alpha=7 *)
*)

(* ============================================================================ *)
(* NUMERICAL IMPLEMENTATIONS (for visualization)                               *)
(* ============================================================================ *)

(* P-norm: numerically stable *)
SoftMinPNormLogSpace[x_, p_] := Module[{distances},
  distances = Table[(x - (k*pDepth + pDepth^2))^2, {k, 0, Floor[x/pDepth]}];
  Log[Power[Mean[Power[distances, -p]], -1/p]]
]

LogSpaceScorePNormNumerical[x_, p_] :=
  Sum[SoftMinPNormLogSpace[x, p], {pDepth, 2, x}]

(* Exp/log: numerically stable with log-sum-exp *)
SoftMinExpLogLogSpace[x_, alpha_] := Module[{distances, negDistSq, M},
  distances = Table[(x - (k*pDepth + pDepth^2))^2, {k, 0, Floor[x/pDepth]}];
  negDistSq = -alpha * distances;
  M = Max[negDistSq];
  Log[-1/alpha * (M + Log[Total[Exp[negDistSq - M]]])]
]

LogSpaceScoreExpLogNumerical[x_, alpha_] :=
  Sum[SoftMinExpLogLogSpace[x, alpha], {pDepth, 2, x}]


(* ============================================================================ *)
(* PARAMETERS                                                                   *)
(* ============================================================================ *)

nMax = 150;
pValues = {2, 3, 5};
alphaValue = 7;

Print["================================================================="];
Print["LOG-SPACE AGGREGATION: Sum of Logs Instead of Product"];
Print["================================================================="];
Print[""];
Print["Parameters:"];
Print["  n ∈ [1, ", nMax, "]"];
Print["  P-norm: p ∈ ", pValues];
Print["  Exp/log: alpha = ", alphaValue];
Print[""];


(* ============================================================================ *)
(* VISUALIZATION 1: P-norm comparison (different p values)                     *)
(* ============================================================================ *)

Print["Generating p-norm log-space comparison (p = 2, 3, 5)..."];

plotPNormLogSpace = Module[{datasets},
  datasets = Table[
    {p, Table[{k, LogSpaceScorePNormNumerical[k, p]}, {k, 1, nMax}]},
    {p, pValues}
  ];

  ListLinePlot[
    Map[
      ListLinePlot[
        GatherBy[#[[2]], PrimeQ@*First],
        PlotMarkers -> {Automatic},
        PlotStyle -> {Directive[Orange, PointSize[0.01]], Directive[Blue, PointSize[0.008]]},
        PlotLabel -> Row[{"p = ", #[[1]]}]
      ] &,
      datasets
    ],
    PlotLayout -> "Column",
    Frame -> True,
    FrameLabel -> {"n", "Log-space score"},
    ImageSize -> 700
  ]
];

Export["visualizations/logspace-pnorm-comparison.pdf", plotPNormLogSpace];
Print["✓ Saved visualizations/logspace-pnorm-comparison.pdf"];


(* ============================================================================ *)
(* VISUALIZATION 2: P-norm envelope (p=3, best balance)                        *)
(* ============================================================================ *)

Print[""];
Print["Generating p-norm log-space envelope (p=3)..."];

pBest = 3;

plotPNormEnvelope = Table[{k, LogSpaceScorePNormNumerical[k, pBest]}, {k, 1, nMax}] //
  ListLinePlot[
    GatherBy[#, PrimeQ@*First],
    PlotMarkers -> {Automatic},
    GridLines -> {Prime @ Range @ PrimePi @ nMax, None},
    Frame -> True,
    FrameLabel -> {"n", "Log-space score"},
    PlotLabel -> Row[{"P-norm log-space envelope | p = ", pBest, " | n ≤ ", nMax}],
    PlotStyle -> {
      Directive[Orange, PointSize[0.012]],
      Directive[Blue, PointSize[0.01]]
    },
    PlotLegends -> {"Primes (envelope)", "Composites"},
    ImageSize -> 700
  ] &;

Export["visualizations/logspace-pnorm-envelope-p" <> ToString[pBest] <> ".pdf", plotPNormEnvelope];
Print["✓ Saved visualizations/logspace-pnorm-envelope-p", pBest, ".pdf"];


(* ============================================================================ *)
(* VISUALIZATION 3: Exp/log envelope (for comparison)                          *)
(* ============================================================================ *)

Print[""];
Print["Generating exp/log log-space envelope (alpha=", alphaValue, ")..."];

plotExpLogEnvelope = Table[{k, LogSpaceScoreExpLogNumerical[k, alphaValue]}, {k, 1, nMax}] //
  ListLinePlot[
    GatherBy[#, PrimeQ@*First],
    PlotMarkers -> {Automatic},
    GridLines -> {Prime @ Range @ PrimePi @ nMax, None},
    Frame -> True,
    FrameLabel -> {"n", "Log-space score"},
    PlotLabel -> Row[{"Exp/log log-space envelope | alpha = ", alphaValue, " | n ≤ ", nMax}],
    PlotStyle -> {
      Directive[Orange, PointSize[0.012]],
      Directive[Blue, PointSize[0.01]]
    },
    PlotLegends -> {"Primes (envelope)", "Composites"},
    ImageSize -> 700
  ] &;

Export["visualizations/logspace-explog-envelope-alpha" <> ToString[alphaValue] <> ".pdf", plotExpLogEnvelope];
Print["✓ Saved visualizations/logspace-explog-envelope-alpha", alphaValue, ".pdf"];


(* ============================================================================ *)
(* VISUALIZATION 4: Direct comparison p-norm vs exp/log                        *)
(* ============================================================================ *)

Print[""];
Print["Generating direct comparison (p=3 vs alpha=7)..."];

nComp = Min[100, nMax];

plotComparison = Module[{dataPNorm, dataExpLog},
  dataPNorm = Table[{k, LogSpaceScorePNormNumerical[k, 3]}, {k, 1, nComp}];
  dataExpLog = Table[{k, LogSpaceScoreExpLogNumerical[k, 7]}, {k, 1, nComp}];

  Show[
    ListLinePlot[
      GatherBy[dataPNorm, PrimeQ@*First],
      PlotMarkers -> {Graphics[{Orange, Disk[]}, ImageSize -> 10], Graphics[{Blue, Disk[]}, ImageSize -> 8]},
      PlotStyle -> {Orange, Blue}
    ],
    ListLinePlot[
      GatherBy[dataExpLog, PrimeQ@*First],
      PlotMarkers -> {Graphics[{Orange, EdgeForm[Black], FaceForm[], Circle[]}, ImageSize -> 10],
                      Graphics[{Blue, EdgeForm[Black], FaceForm[], Circle[]}, ImageSize -> 8]},
      PlotStyle -> {Orange, Blue}
    ],
    Frame -> True,
    FrameLabel -> {"n", "Log-space score"},
    PlotLabel -> "Log-space: P-norm (p=3, filled) vs Exp/log (alpha=7, hollow)",
    PlotLegends -> {"P-norm primes", "P-norm composites", "Exp/log primes", "Exp/log composites"},
    GridLines -> {Prime @ Range @ PrimePi @ nComp, None},
    ImageSize -> 700
  ]
];

Export["visualizations/logspace-comparison-pnorm-vs-explog.pdf", plotComparison];
Print["✓ Saved visualizations/logspace-comparison-pnorm-vs-explog.pdf"];


(* ============================================================================ *)
(* SUMMARY                                                                      *)
(* ============================================================================ *)

Print[""];
Print["================================================================="];
Print["All visualizations generated successfully!");
Print["================================================================="];
Print[""];
Print["Summary:"];
Print["  1. P-norm comparison (p = 2, 3, 5) in log-space"];
Print["  2. P-norm envelope (p = 3)"];
Print["  3. Exp/log envelope (alpha = 7)"];
Print["  4. Direct comparison: p-norm vs exp/log"];
Print[""];
Print["Key formulas for Wolfram Desktop:"];
Print[""];
Print["P-NORM (two parameters: n, p):"];
Print["  LogSpaceScorePNorm[n_, p_] := Sum["];
Print["    Log[Power["];
Print["      Sum[(n-(k*d+d^2))^(-2*p),{k,0,Floor[n/d]}]/(Floor[n/d]+1),"];
Print["      -1/p]],"];
Print["    {d, 2, n}]"];
Print[""];
Print["EXP/LOG (two parameters: n, alpha):"];
Print["  LogSpaceScoreExpLog[n_, alpha_] := Sum["];
Print["    Log[-1/alpha * Log[Sum[Exp[-alpha*(n-(k*d+d^2))^2],{k,0,Floor[n/d]}]]],"];
Print["    {d, 2, n}]"];
Print[""];
Print["Next steps:"];
Print["  - Try different p values (2 = smooth, 5 = sharp)"];
Print["  - Compare with original product-based scores"];
Print["  - Analyze growth rate of log-space score"];
Print["  - Look for connection to zeta function!");
