#!/usr/bin/env wolframscript
(* Systematic search for zeros of F_n(s) in complex plane *)

(* ============================================================================ *)
(* FUNCTION DEFINITION                                                         *)
(* ============================================================================ *)

SoftMinSquared[x_, d_, alpha_] := Module[{distances, negDistSq, M},
  distances = Table[(x - (k*d + d^2))^2, {k, 0, Floor[x/d]}];
  negDistSq = -alpha * distances;
  M = Max[negDistSq];
  -1/alpha * (M + Log[Total[Exp[negDistSq - M]]])
]

DirichletLikeSumComplex[n_, alpha_, s_, maxD_: 300] := Module[{terms},
  terms = Table[
    Module[{softMin},
      softMin = SoftMinSquared[n, d, alpha];
      If[softMin > 0, softMin^(-s), 0]
    ],
    {d, 2, Min[maxD, 5*n]}
  ];
  Total[terms]
]

(* ============================================================================ *)
(* PARAMETERS                                                                   *)
(* ============================================================================ *)

alpha = 7;
testPrime = 23;
testComposite = 24;

(* Search region *)
sigmaMin = -1.0;
sigmaMax = 3.0;
tMin = -10.0;
tMax = 10.0;
gridStep = 0.2;  (* Coarse grid first *)

Print["================================================================"];
Print["SYSTEMATIC SEARCH FOR ZEROS IN COMPLEX PLANE"];
Print["================================================================"];
Print[""];
Print["Test values: prime = ", testPrime, ", composite = ", testComposite];
Print["Alpha = ", alpha];
Print[""];
Print["Search region:"];
Print["  Re(s) ∈ [", sigmaMin, ", ", sigmaMax, "]"];
Print["  Im(s) ∈ [", tMin, ", ", tMax, "]"];
Print["  Grid step: ", gridStep];
Print[""];

(* ============================================================================ *)
(* 1. COARSE GRID SEARCH                                                       *)
(* ============================================================================ *)

Print["[1/4] Coarse grid search for minima of |F_n(s)|..."];
Print[""];

(* Sample grid *)
gridSigma = Table[σ, {σ, sigmaMin, sigmaMax, gridStep}];
gridT = Table[t, {t, tMin, tMax, gridStep}];

Print["Grid size: ", Length[gridSigma], " × ", Length[gridT], " = ",
      Length[gridSigma] * Length[gridT], " points"];
Print["Computing for prime n = ", testPrime, "..."];

primeGridData = Table[
  {σ, t, Abs[DirichletLikeSumComplex[testPrime, alpha, σ + I*t]]},
  {σ, gridSigma}, {t, gridT}
];

Print["✓ Grid computed"];
Print[""];

(* Find local minima *)
flatData = Flatten[primeGridData, 1];
minMagnitude = Min[flatData[[All, 3]]];
meanMagnitude = Mean[flatData[[All, 3]]];

Print["Statistics for |F_", testPrime, "(s)|:"];
Print["  Min: ", N[minMagnitude, 6]];
Print["  Mean: ", N[meanMagnitude, 6]];
Print["  Max: ", N[Max[flatData[[All, 3]]], 6]];
Print[""];

(* Find points where |F| is unusually small *)
threshold = Max[0.1, minMagnitude * 2];
candidates = Select[flatData, #[[3]] < threshold &];

Print["Candidates (|F| < ", N[threshold, 4], "):"];
If[Length[candidates] > 0,
  Do[
    Print["  s = ", N[candidates[[i, 1]], 3], " + ", N[candidates[[i, 2]], 3], "i : |F| = ",
          N[candidates[[i, 3]], 5]],
    {i, 1, Min[20, Length[candidates]]}
  ];
  If[Length[candidates] > 20, Print["  ... (", Length[candidates] - 20, " more)"]],
  Print["  None found (no obvious zeros in this region)"]
];
Print[""];

(* ============================================================================ *)
(* 2. REFINED SEARCH NEAR CANDIDATES                                           *)
(* ============================================================================ *)

Print["[2/4] Refined search near candidates..."];
Print[""];

refinedZeros = {};

If[Length[candidates] > 0,
  Print["Refining top ", Min[10, Length[candidates]], " candidates..."];

  Do[
    Module[{s0, σ0, t0, result},
      σ0 = candidates[[i, 1]];
      t0 = candidates[[i, 2]];
      s0 = σ0 + I*t0;

      (* Try to find exact zero using FindRoot *)
      result = Quiet[Check[
        FindRoot[
          DirichletLikeSumComplex[testPrime, alpha, s] == 0,
          {s, s0},
          MaxIterations -> 100
        ],
        $Failed
      ]];

      If[result =!= $Failed,
        Module[{sZero, fValue},
          sZero = s /. result;
          fValue = DirichletLikeSumComplex[testPrime, alpha, sZero];

          (* Verify it's actually close to zero *)
          If[Abs[fValue] < 0.001,
            AppendTo[refinedZeros, {sZero, Abs[fValue]}];
            Print["  ✓ Potential zero found: s = ", N[sZero, 5], ", |F(s)| = ", N[Abs[fValue], 8]]
          ]
        ]
      ]
    ],
    {i, 1, Min[10, Length[candidates]]}
  ];

  If[Length[refinedZeros] == 0,
    Print["  No exact zeros found (candidates were local minima, not zeros)"]
  ],

  Print["  No candidates to refine"]
];
Print[""];

(* ============================================================================ *)
(* 3. SPECIAL REGIONS: Critical line and real axis                             *)
(* ============================================================================ *)

Print["[3/4] Checking special regions..."];
Print[""];

(* Critical line Re(s) = 1/2 *)
Print["Critical line (Re(s) = 1/2):"];
criticalLineData = Table[
  {t, Abs[DirichletLikeSumComplex[testPrime, alpha, 1/2 + I*t]]},
  {t, -10, 10, 0.1}
];

criticalMin = MinimalBy[criticalLineData, Last, 1][[1]];
Print["  Minimum at t = ", N[criticalMin[[1]], 4], " : |F| = ", N[criticalMin[[2]], 6]];

If[criticalMin[[2]] < 0.01,
  Print["  ⚠ Very small value - potential zero!"],
  Print["  ✓ No zero on critical line (Im ∈ [-10, 10])")
];
Print[""];

(* Real axis *)
Print["Real axis (Im(s) = 0):"];
realAxisData = Table[
  {σ, DirichletLikeSumComplex[testPrime, alpha, σ]},
  {σ, -1, 3, 0.05}
];

realMin = MinimalBy[realAxisData, Abs[Last[#]]&, 1][[1]];
Print["  Minimum at σ = ", N[realMin[[1]], 4], " : F = ", N[realMin[[2]], 6]];

If[Abs[realMin[[2]]] < 0.01,
  Print["  ⚠ Very small value - potential zero!"],
  Print["  ✓ No zero on real axis (σ ∈ [-1, 3])")
];
Print[""];

(* ============================================================================ *)
(* 4. COMPARISON: Prime vs Composite                                           *)
(* ============================================================================ *)

Print["[4/4] Comparing prime vs composite..."];
Print[""];

compositeGridData = Table[
  {σ, t, Abs[DirichletLikeSumComplex[testComposite, alpha, σ + I*t]]},
  {σ, gridSigma}, {t, gridT}
];

flatComposite = Flatten[compositeGridData, 1];
minCompMag = Min[flatComposite[[All, 3]]];

Print["For composite n = ", testComposite, ":");
Print["  Min |F|: ", N[minCompMag, 6]];
Print[""];

Print["Comparison:");
Print["  Prime min:     ", N[minMagnitude, 6]];
Print["  Composite min: ", N[minCompMag, 6]];
Print["  Ratio:         ", N[minCompMag / minMagnitude, 4]];
Print[""];

(* ============================================================================ *)
(* VISUALIZATIONS                                                               *)
(* ============================================================================ *)

Print["Generating visualizations..."];

(* Plot 1: |F_n(s)| for prime in complex plane *)
plot1 = ListDensityPlot[
  Flatten[primeGridData, 1],
  ColorFunction -> "TemperatureMap",
  PlotLegends -> Automatic,
  FrameLabel -> {"Re(s)", "Im(s)"},
  PlotLabel -> Row["Magnitude |F_", testPrime, "(s)| in complex plane"],
  ImageSize -> 700,
  InterpolationOrder -> 2
];

Export["visualizations/complex-magnitude-heatmap-prime.pdf", plot1];
Print["✓ Saved visualizations/complex-magnitude-heatmap-prime.pdf"];

(* Plot 2: Contour plot *)
plot2 = ListContourPlot[
  Flatten[primeGridData, 1],
  Contours -> 20,
  ColorFunction -> "Rainbow",
  PlotLegends -> Automatic,
  FrameLabel -> {"Re(s)", "Im(s)"},
  PlotLabel -> Row["Contours of |F_", testPrime, "(s)|"],
  ImageSize -> 700
];

Export["visualizations/complex-contours-prime.pdf", plot2];
Print["✓ Saved visualizations/complex-contours-prime.pdf"];

(* Plot 3: Comparison - side by side *)
plot3a = ListDensityPlot[
  Flatten[primeGridData, 1],
  ColorFunction -> "TemperatureMap",
  PlotLabel -> Row["Prime: n = ", testPrime],
  FrameLabel -> {"Re(s)", "Im(s)"},
  ImageSize -> 350
];

plot3b = ListDensityPlot[
  Flatten[compositeGridData, 1],
  ColorFunction -> "TemperatureMap",
  PlotLabel -> Row["Composite: n = ", testComposite],
  FrameLabel -> {"Re(s)", "Im(s)"},
  ImageSize -> 350
];

plot3 = GraphicsRow[{plot3a, plot3b}, ImageSize -> 700];

Export["visualizations/complex-comparison-prime-vs-composite.pdf", plot3];
Print["✓ Saved visualizations/complex-comparison-prime-vs-composite.pdf"];

(* Plot 4: Cross-sections *)
plot4 = GraphicsGrid[{
  {
    (* Real axis *)
    ListLinePlot[realAxisData,
      PlotLabel -> "Real axis (Im=0)",
      FrameLabel -> {"Re(s)", "F(s)"},
      Frame -> True,
      ImageSize -> 300
    ],
    (* Critical line *)
    ListLinePlot[criticalLineData,
      PlotLabel -> "Critical line (Re=1/2)",
      FrameLabel -> {"Im(s)", "|F(s)|"},
      Frame -> True,
      ImageSize -> 300
    ]
  },
  {
    (* Vertical slice at σ=1 *)
    ListLinePlot[
      Table[{t, Abs[DirichletLikeSumComplex[testPrime, alpha, 1 + I*t]]}, {t, -10, 10, 0.1}],
      PlotLabel -> "Vertical (Re=1)",
      FrameLabel -> {"Im(s)", "|F(s)|"},
      Frame -> True,
      ImageSize -> 300
    ],
    (* Horizontal slice at t=5 *)
    ListLinePlot[
      Table[{σ, Abs[DirichletLikeSumComplex[testPrime, alpha, σ + 5*I]]}, {σ, -1, 3, 0.05}],
      PlotLabel -> "Horizontal (Im=5)",
      FrameLabel -> {"Re(s)", "|F(s)|"},
      Frame -> True,
      ImageSize -> 300
    ]
  }
}, ImageSize -> 700];

Export["visualizations/complex-cross-sections.pdf", plot4];
Print["✓ Saved visualizations/complex-cross-sections.pdf"];

(* ============================================================================ *)
(* SUMMARY                                                                      *)
(* ============================================================================ *)

Print[""];
Print["================================================================"];
Print["SUMMARY OF ZERO SEARCH"];
Print["================================================================"];
Print[""];

If[Length[refinedZeros] > 0,
  Print["🎯 ZEROS FOUND: ", Length[refinedZeros]];
  Print[""];
  Do[
    Print["  Zero #", i, ": s = ", N[refinedZeros[[i, 1]], 6]];
    Print["          |F(s)| = ", N[refinedZeros[[i, 2]], 10]];
    Print[""],
    {i, Length[refinedZeros]}
  ];
  Print["IMPLICATIONS:"];
  Print["  • F_n(s) has zeros in complex plane"];
  Print["  • Study distribution of zeros"];
  Print["  • Check if they lie on specific curves"];
  Print["  • Connection to prime structure?"],

  Print["✓ NO ZEROS FOUND in searched region"];
  Print[""];
  Print["  Re(s) ∈ [", sigmaMin, ", ", sigmaMax, "]");
  Print["  Im(s) ∈ [", tMin, ", ", tMax, "]"];
  Print[""];
  Print["IMPLICATIONS:");
  Print["  • F_n(s) may be entire function without zeros"];
  Print["  • If true: F_n(s) = exp(g(s)) for some entire g"];
  Print["  • Very special class of functions!");
  Print["  • Similar to exp(z), cos(z)+i·sin(z)+1, etc."];
  Print[""];
  Print["NEXT STEPS:");
  Print["  • Extend search to larger region");
  Print["  • Prove theoretically that no zeros exist");
  Print["  • Study g(s) = log(F_n(s))")
];

Print[""];
Print["Minimum |F| found: ", N[minMagnitude, 8]];
Print["At: s ≈ ", N[candidates[[1, 1]], 4], " + ", N[candidates[[1, 2]], 4], "i"];
Print[""];
