(* Survey of roots of master equation (2t-1)^q = t^{p+q}
   for rational slopes p/q from a Farey-like sequence.
   Plot all roots in the complex plane, colored by slope. *)

(* === Compute roots for a given slope === *)
masterRoots[p_, q_] := Module[{t, poly, roots},
  poly = Cancel[((2 t - 1)^q - t^(p + q)) / (t - 1)];
  roots = t /. Solve[poly == 0, t];
  N[roots, 15]
]

(* === Gather slopes: Farey-like sequence with small denominators === *)
slopes = {};
Do[
  Do[
    If[GCD[p, q] == 1 && p > q,
      AppendTo[slopes, {p, q}]
    ],
    {p, q + 1, 4 q}  (* slopes from just above 1 to 4 *)
  ],
  {q, 1, 6}
];
slopes = SortBy[slopes, #[[1]]/#[[2]] &];

Print["=== SPECTRAL SURVEY: roots of (2t-1)^q = t^{p+q} ===\n"];
Print[Length[slopes], " slopes from ", N[slopes[[1,1]]/slopes[[1,2]], 3],
  " to ", N[slopes[[-1,1]]/slopes[[-1,2]], 3], "\n"];

(* === Compute all roots === *)
allData = {};
Do[
  {p, q} = s;
  roots = masterRoots[p, q];
  alpha = N[p/q, 5];

  (* Classify: real in (0,1), real outside, complex *)
  realIn = Select[roots, Im[#] == 0 && 0 < Re[#] < 1 &];
  realOut = Select[roots, Im[#] == 0 && (Re[#] <= 0 || Re[#] >= 1) &];
  complex = Select[roots, Im[#] != 0 && Im[#] > 0 &]; (* upper half only, pairs *)

  Print[p, "/", q, " = ", alpha,
    "  deg=", Length[roots],
    "  |t|<1: ", Length[Select[roots, Abs[#] < 1 &]],
    " (expect q=", q, ")",
    "  real(0,1): ", Length[realIn],
    "  complex pairs: ", Length[complex]];

  (* Print exact roots for small cases *)
  If[Length[roots] <= 6,
    Do[
      r = roots[[i]];
      marker = If[Abs[r] < 1, " <-- |t|<1", ""];
      Print["    t = ", r, marker];,
      {i, Length[roots]}
    ];
  ];

  AppendTo[allData, {p, q, roots}];,
  {s, slopes}
];

(* === EXACT roots for the simplest slopes === *)
Print["\n=== EXACT ROOTS (symbolic) ===\n"];

Do[
  {p, q} = s;
  t = Symbol["t"];
  poly = Cancel[((2 t - 1)^q - t^(p + q)) / (t - 1)];
  Print["Slope ", p, "/", q, ":  ", Collect[poly, t], " = 0"];
  exactRoots = t /. Solve[poly == 0, t];
  Do[
    Print["  t = ", exactRoots[[i]],
      "  = ", N[exactRoots[[i]], 10],
      If[Abs[N[exactRoots[[i]], 20]] < 1, "  <-- |t|<1", ""]];,
    {i, Length[exactRoots]}
  ];
  Print[];,
  {s, {{2,1}, {3,1}, {3,2}, {4,3}, {5,3}, {5,2}}}
];

(* === PLOT: all roots in complex plane === *)
Print["\n=== GENERATING PLOT ==="];

plotData = {};
colors = {};
Do[
  {p, q, roots} = allData[[i]];
  alpha = p/q;
  (* Color by alpha: blue (near 1) to red (near 4) *)
  hue = (alpha - 1) / 3; (* 0 to 1 *)
  color = Hue[0.7 - 0.7 hue]; (* blue to red *)

  Do[
    r = roots[[j]];
    (* Plot both the root and its conjugate if complex *)
    AppendTo[plotData, {Re[r], Im[r]}];
    AppendTo[colors, color];
    If[Im[r] != 0,
      AppendTo[plotData, {Re[r], -Im[r]}];
      AppendTo[colors, color];
    ];,
    {j, Length[roots]}
  ];,
  {i, Length[allData]}
];

(* Unit circle for reference *)
circle = Table[{Cos[th], Sin[th]}, {th, 0, 2 Pi, Pi/100}];

plt = Show[
  ListPlot[{plotData},
    PlotStyle -> {PointSize[0.008]},
    AspectRatio -> 1,
    PlotRange -> {{-2.5, 2.5}, {-2.5, 2.5}},
    Frame -> True,
    FrameLabel -> {"Re(t)", "Im(t)"},
    PlotLabel -> "Roots of (2t-1)^q = t^{p+q}\nfor rational slopes p/q, q=1..6"
  ],
  ListLinePlot[{circle},
    PlotStyle -> {Gray, Dashed}
  ],
  Graphics[{Red, PointSize[0.015], Point[{1/2, 0}]}],  (* t=1/2 limit *)
  Graphics[{Red, PointSize[0.015], Point[{1, 0}]}],     (* t=1 trivial *)
  Graphics[Text["t=1/2", {0.5, 0.1}]],
  Graphics[Text["|t|=1", {0.3, 0.95}]]
];

figDir = FileNameJoin[{DirectoryName[$InputFileName], "..", "figures"}];
If[!DirectoryQ[figDir], CreateDirectory[figDir]];
outFile = FileNameJoin[{figDir, "spectral_roots.png"}];
Export[outFile, plt, ImageResolution -> 150, ImageSize -> 600];
Print["Plot saved to ", outFile];

(* === PLOT 2: only roots with |t| < 1 (the "spectrum") === *)
specData = {};
specColors = {};
specLabels = {};
Do[
  {p, q, roots} = allData[[i]];
  alpha = p/q;
  good = Select[roots, Abs[#] < 1 &];
  hue = (alpha - 1) / 3;
  color = Hue[0.7 - 0.7 hue];
  Do[
    AppendTo[specData, {Re[good[[j]]], Im[good[[j]]]}];
    AppendTo[specColors, color];,
    {j, Length[good]}
  ];,
  {i, Length[allData]}
];

plt2 = ListPlot[{specData},
  PlotStyle -> {PointSize[0.012]},
  AspectRatio -> 1,
  PlotRange -> {{0, 0.85}, {-0.15, 0.15}},
  Frame -> True,
  FrameLabel -> {"Re(t)", "Im(t)"},
  PlotLabel -> "Roots with |t|<1 (\"spectrum\")\nfor slopes p/q, q=1..6",
  GridLines -> {{1/2}, {0}},
  GridLinesStyle -> {Gray, Dashed}
];

outFile2 = FileNameJoin[{figDir, "spectral_roots_interior.png"}];
Export[outFile2, plt2, ImageResolution -> 150, ImageSize -> 600];
Print["Plot saved to ", outFile2];

Print["\n=== DONE ==="];
