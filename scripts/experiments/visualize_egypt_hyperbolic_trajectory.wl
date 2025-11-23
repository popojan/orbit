#!/usr/bin/env wolframscript
(* Visualize Egypt sequence in hyperbolic coordinates *)

<< Orbit`

Print["Visualizing Egypt sequence in hyperbolic space...\n"];

(* Compute Egypt sequence for sqrt(n) *)
computeEgyptSequence[n_, maxK_] := Module[{seq},
  seq = Table[
    Module[{x, s, r},
      x = n - 1;
      r = n / Sum[FactorialTerm[x, j], {j, 1, k}];
      s = ArcSinh[Sqrt[(r-1)/2]];  (* hyperbolic coordinate *)
      {k, r, s, (1+2*k)*s}  (* k, r_k, s_k, scaled coordinate *)
    ],
    {k, 1, maxK}
  ];
  seq
];

(* Test case: sqrt(13) *)
n = 13;
maxK = 20;
target = Sqrt[n];

Print["Computing Egypt sequence for sqrt(", n, ")...\n"];
seq = computeEgyptSequence[n, maxK];

Print["k\tr_k\t\t\ts_k\t\t(1+2k)*s_k"];
Print[StringRepeat["-", 70]];
Do[
  {k, r, s, scaled} = seq[[i]];
  Print[k, "\t", N[r, 10], "\t", N[s, 8], "\t", N[scaled, 8]];
, {i, 1, Min[10, Length[seq]]}];
Print["...\n"];

(* Plot 1: r_k trajectory *)
Print["Creating plot 1: r_k convergence...\n"];
rValues = seq[[All, 2]];
plot1 = ListPlot[
  {rValues, Table[target, {Length[rValues]}]},
  Joined -> {True, False},
  PlotStyle -> {Blue, {Red, Dashed}},
  PlotLegends -> {"r_k", "sqrt(13)"},
  AxesLabel -> {"k", "r_k"},
  PlotLabel -> "Egypt Sequence Convergence",
  GridLines -> Automatic,
  ImageSize -> 500
];

(* Plot 2: s_k in hyperbolic coordinates *)
Print["Creating plot 2: hyperbolic coordinate s_k...\n"];
sValues = seq[[All, 3]];
plot2 = ListPlot[
  sValues,
  Joined -> True,
  PlotStyle -> Blue,
  AxesLabel -> {"k", "s_k = ArcSinh[sqrt((r_k-1)/2)]"},
  PlotLabel -> "Hyperbolic Coordinate Evolution",
  GridLines -> Automatic,
  ImageSize -> 500
];

(* Plot 3: Scaled coordinate (1+2k)*s_k *)
Print["Creating plot 3: scaled hyperbolic coordinate...\n"];
scaledValues = seq[[All, 4]];
plot3 = ListPlot[
  scaledValues,
  Joined -> True,
  PlotStyle -> Purple,
  AxesLabel -> {"k", "(1+2k)*s_k"},
  PlotLabel -> "Scaled Hyperbolic Coordinate (factor from bridge)",
  GridLines -> Automatic,
  ImageSize -> 500
];

(* Plot 4: Phase space (s_k vs k) with velocity *)
Print["Creating plot 4: phase space...\n"];
velocities = Table[
  If[i > 1,
    (sValues[[i]] - sValues[[i-1]]),
    0
  ],
  {i, 1, Length[sValues]}
];

plot4 = ListPlot[
  Transpose[{sValues, velocities}],
  AxesLabel -> {"s_k", "ds/dk"},
  PlotLabel -> "Phase Space (position vs velocity)",
  GridLines -> Automatic,
  ImageSize -> 500
];

(* Plot 5: Trajectory in (k, s_k) space *)
Print["Creating plot 5: 2D trajectory...\n"];
trajectory = Transpose[{Range[Length[sValues]], sValues}];
plot5 = ListLinePlot[
  trajectory,
  AxesLabel -> {"k", "s_k"},
  PlotLabel -> "Trajectory in Hyperbolic Space",
  Mesh -> All,
  MeshStyle -> Red,
  ImageSize -> 500
];

(* Check if it's a geodesic *)
Print["Checking geodesic properties...\n"];

(* In hyperbolic space, geodesics have constant velocity *)
Print["Velocity ds/dk:\n"];
Print["k\tds/dk"];
Print[StringRepeat["-", 30]];
Do[
  If[i > 1,
    vel = sValues[[i]] - sValues[[i-1]];
    Print[i, "\t", N[vel, 6]];
  ];
, {i, 2, Min[10, Length[sValues]]}];
Print[];

(* Check if velocity is decreasing (expected for convergence) *)
velDiffs = Table[
  If[i > 2,
    velocities[[i]] - velocities[[i-1]],
    0
  ],
  {i, 3, Length[velocities]}
];

Print["Velocity changes (acceleration):\n"];
Print["Mean: ", N[Mean[velDiffs], 6]];
Print["Std: ", N[StandardDeviation[velDiffs], 6]];
Print["Trend: ", If[Mean[velDiffs] < 0, "DECREASING (converging)", "INCREASING"]];
Print[];

(* Export plots *)
Print["Exporting visualizations...\n"];
Export["visualizations/viz_egypt_convergence.png", plot1];
Export["visualizations/viz_egypt_hyperbolic_s.png", plot2];
Export["visualizations/viz_egypt_scaled_coordinate.png", plot3];
Export["visualizations/viz_egypt_phase_space.png", plot4];
Export["visualizations/viz_egypt_trajectory.png", plot5];

(* Combined plot *)
combined = GraphicsGrid[
  {{plot1, plot2}, {plot3, plot4}},
  ImageSize -> 900
];
Export["visualizations/viz_egypt_hyperbolic_combined.png", combined];

Print["All plots exported!\n"];

(* Compare with theoretical prediction *)
Print["ANALYSIS:\n"];
Print["If Egypt follows hyperbolic geodesic, we expect:"];
Print["  - Exponential approach to target");
Print["  - Constant or smoothly varying velocity in s coordinates");
Print["  - Specific curvature in phase space"];
Print[];

Print["Observed:"];
Print["  - Convergence rate: ~", N[(rValues[[-1]] - target)/(rValues[[1]] - target), 4]];
Print["  - s_k final value: ", N[sValues[[-1]], 8]];
Print["  - Scaled coordinate range: [", N[Min[scaledValues], 4], ", ", N[Max[scaledValues], 4], "]"];
Print[];

Print["DONE!");
