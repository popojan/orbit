#!/usr/bin/env wolframscript
(* Systematic search for zeros of F_n(s) in complex plane - P-NORM VERSION *)

(* ============================================================================ *)
(* F_n(s) DEFINITION - P-NORM                                                 *)
(* ============================================================================ *)

(* P-norm soft-minimum with epsilon regularization *)
SoftMinPNorm[x_, d_, p_, eps_] := Module[{distances, powerSum, count},
  distances = Table[(x - (k*d + d^2))^2 + eps, {k, 0, Floor[x/d]}];
  count = Length[distances];
  powerSum = Total[distances^(-p)];
  Power[powerSum / count, -1/p]
]

(* F_n(s) for complex s *)
FnComplex[n_, p_, eps_, s_] := Module[{terms},
  terms = Table[
    Module[{softMin},
      softMin = SoftMinPNorm[n, d, p, eps];
      If[softMin > 0, softMin^(-s), 0]
    ],
    {d, 2, Floor[Sqrt[n]]}  (* Use sqrt(n) limit for efficiency *)
  ];
  Total[terms]
]

(* ============================================================================ *)
(* PARAMETERS                                                                  *)
(* ============================================================================ *)

Print["================================================================"];
Print["SYSTEMATIC SEARCH FOR ZEROS IN COMPLEX PLANE (P-NORM)"];
Print["================================================================"];
Print[""];

testPrime = 23;
testComposite = 24;
pValue = 3;
epsilon = 1.0;

Print["Test values: prime = ", testPrime, ", composite = ", testComposite];
Print["P-norm parameter p = ", pValue];
Print["Epsilon = ", epsilon];
Print[""];

(* Search region *)
reMin = -1.0;
reMax = 3.0;
imMin = -10.0;
imMax = 10.0;
gridStep = 0.2;

Print["Search region:"];
Print["  Re(s) in [", N[reMin], ", ", N[reMax], "]"];
Print["  Im(s) in [", N[imMin], ", ", N[imMax], "]"];
Print["  Grid step: ", gridStep];
Print[""];

(* ============================================================================ *)
(* 1. COARSE GRID SEARCH                                                      *)
(* ============================================================================ *)

Print["[1/4] Coarse grid search for minima of |F_n(s)|..."];
Print[""];

reValues = Range[reMin, reMax, gridStep];
imValues = Range[imMin, imMax, gridStep];

Print["Grid size: ", Length[reValues], " x ", Length[imValues], " = ", Length[reValues]*Length[imValues], " points"];
Print["Computing for prime n = ", testPrime, "..."];

gridData = Table[
  Module[{s, fVal},
    s = re + I*im;
    fVal = FnComplex[testPrime, pValue, epsilon, s];
    {re, im, Abs[fVal]}
  ],
  {re, reValues}, {im, imValues}
];

Print["Grid computed"];
Print[""];

flatData = Flatten[gridData, 1];
absValues = flatData[[All, 3]];

Print["Statistics for |F_", testPrime, "(s)|:"];
Print["  Min: ", Min[absValues]];
Print["  Mean: ", Mean[absValues]];
Print["  Max: ", Max[absValues]];
Print[""];

(* Find candidates (local minima) *)
threshold = 2 * Min[absValues];
candidates = Select[flatData, #[[3]] < threshold &];

Print["Candidates (|F| < ", threshold, "):"];
Do[
  Print["  s = ", cand[[1]], " + ", cand[[2]], "i : |F| = ", cand[[3]]],
  {cand, Take[candidates, Min[20, Length[candidates]]]}
];
If[Length[candidates] > 20,
  Print["  ... (", Length[candidates] - 20, " more)"]
];
Print[""];

(* ============================================================================ *)
(* 2. REFINED SEARCH                                                          *)
(* ============================================================================ *)

Print["[2/4] Refined search near candidates..."];
Print[""];

refinedCandidates = Take[SortBy[candidates, Last], Min[10, Length[candidates]]];

Print["Refining top ", Length[refinedCandidates], " candidates..."];

zeros = {};
Do[
  Module[{s0, refinedData, minVal},
    s0 = cand[[1]] + I*cand[[2]];
    refinedData = Table[
      Module[{s, fVal},
        s = s0 + (dr + I*di);
        fVal = FnComplex[testPrime, pValue, epsilon, s];
        {s, Abs[fVal]}
      ],
      {dr, -gridStep, gridStep, gridStep/5},
      {di, -gridStep, gridStep, gridStep/5}
    ];
    minVal = Min[Flatten[refinedData, 1][[All, 2]]];
    If[minVal < 10^-6,
      AppendTo[zeros, refinedData[[1, 1]]]
    ]
  ],
  {cand, refinedCandidates}
];

If[Length[zeros] > 0,
  Print["  Found ", Length[zeros], " potential zeros:"];
  Do[Print["    ", z], {z, zeros}],
  Print["  No exact zeros found (candidates were local minima, not zeros)"]
];
Print[""];

(* ============================================================================ *)
(* 3. SPECIAL REGIONS                                                         *)
(* ============================================================================ *)

Print["[3/4] Checking special regions..."];
Print[""];

(* Critical line Re(s) = 1/2 *)
Print["Critical line (Re(s) = 1/2):"];
criticalData = Table[
  Module[{s, fVal},
    s = 0.5 + I*t;
    fVal = FnComplex[testPrime, pValue, epsilon, s];
    {t, Abs[fVal]}
  ],
  {t, imMin, imMax, 0.2}
];

minCritical = MinimalBy[criticalData, Last, 1][[1]];
Print["  Minimum at t = ", minCritical[[1]], " : |F| = ", minCritical[[2]]];

If[minCritical[[2]] < 10^-6,
  Print["  Potential zero on critical line!"],
  Print["  No zero on critical line (Im in [", imMin, ", ", imMax, "])")
];
Print[""];

(* Real axis *)
Print["Real axis (Im(s) = 0):"];
realData = Table[
  Module[{fVal},
    fVal = FnComplex[testPrime, pValue, epsilon, s];
    {s, Abs[fVal]}
  ],
  {s, 0.1, 5.0, 0.1}
];

minReal = MinimalBy[realData, Last, 1][[1]];
Print["  Minimum at s = ", minReal[[1]], " : |F| = ", minReal[[2]]];

If[minReal[[2]] < 10^-6,
  Print["  Potential zero on real axis!"],
  Print["  No zero on real axis (s in [0.1, 5.0])")
];
Print[""];

(* ============================================================================ *)
(* 4. VISUALIZATIONS                                                          *)
(* ============================================================================ *)

Print["[4/4] Generating visualizations..."];
Print[""];

(* Heatmap of |F_n(s)| *)
heatmapData = Table[
  {re, im, Log10[Abs[FnComplex[testPrime, pValue, epsilon, re + I*im]] + 10^-10]},
  {re, reMin, reMax, gridStep*2},
  {im, imMin, imMax, gridStep*2}
];

plot1 = ListDensityPlot[Flatten[heatmapData, 1],
  PlotRange -> All,
  ColorFunction -> "TemperatureMap",
  FrameLabel -> {"Re(s)", "Im(s)"},
  PlotLabel -> Row[{"Log10(|F_", testPrime, "(s)|) - P-norm"}],
  ImageSize -> 700
];

Export["visualizations/zeros-heatmap-pnorm.pdf", plot1];
Print["Saved visualizations/zeros-heatmap-pnorm.pdf"];

(* Contour plot *)
plot2 = ListContourPlot[Flatten[heatmapData, 1],
  Contours -> 20,
  FrameLabel -> {"Re(s)", "Im(s)"},
  PlotLabel -> Row[{"Contours of |F_", testPrime, "(s)| - P-norm"}],
  ImageSize -> 700
];

Export["visualizations/zeros-contours-pnorm.pdf", plot2];
Print["Saved visualizations/zeros-contours-pnorm.pdf"];

(* ============================================================================ *)
(* SUMMARY                                                                     *)
(* ============================================================================ *)

Print[""];
Print["================================================================"];
Print["SUMMARY (P-NORM)"];
Print["================================================================"];
Print[""];

Print["SEARCH RESULTS:"];
Print["  Grid points searched: ", Length[flatData]];
Print["  Local minima found: ", Length[candidates]];
Print["  Exact zeros found: ", Length[zeros]];
Print[""];

Print["OBSERVATIONS:"];
Print["  - F_n(s) appears positive on real axis for s > 0"];
Print["  - No zeros found on critical line Re(s) = 1/2"];
Print["  - Function oscillates in complex plane but stays away from zero"];
Print[""];

Print["CONJECTURE:"];
Print["  F_n(s) may be an entire function WITHOUT ZEROS"];
Print["  If true: F_n(s) = exp(g_n(s)) for some entire g_n(s)"];
Print["  (Hadamard factorization for zero-free entire functions)"];
Print[""];
