#!/usr/bin/env wolframscript
(* Visualize Egypt trajectory inside Poincare disk and its inversion outside *)

<< Orbit`

Print["Visualizing Egypt trajectory with Poincare disk inversion\n"];

(* Compute Egypt approximation r_k for given n and k *)
egyptApprox[n_, k_] := Module[{x, denom},
  x = n - 1;
  denom = Sum[FactorialTerm[x, j], {j, 1, k}];
  N[n / denom, 15]
];

(* Convert to Poincare radius *)
poincareRadius[x_] := Tanh[ArcSinh[Sqrt[x/2]]];

(* Compute Egypt sequence in Poincare coordinates *)
computePoincareSequence[n_, maxK_] := Module[{seq},
  seq = Table[
    Module[{r, x, rPoincare, rInv},
      r = egyptApprox[n, k];
      x = r - 1;
      rPoincare = poincareRadius[x];
      rInv = 1 / rPoincare;  (* Inverted radius *)
      {k, r, x, rPoincare, rInv}
    ],
    {k, 1, maxK}
  ];
  seq
];

(* Test cases *)
testCases = {
  {2, "sqrt(2)", 50},
  {5, "sqrt(5)", 50},
  {13, "sqrt(13)", 50}
};

allPlots = {};

Do[
  {n, label, maxK} = testCases[[caseIdx]];

  Print["Computing Poincare trajectory for ", label, "..."];
  seq = computePoincareSequence[n, maxK];

  (* Extract data *)
  kValues = seq[[All, 1]];
  rPoincareInside = seq[[All, 4]];
  rPoincareOutside = seq[[All, 5]];

  (* Convert to 2D points (using angle based on k) *)
  insidePoints = Table[
    {rPoincareInside[[i]] * Cos[2*Pi*i/(maxK+5)],
     rPoincareInside[[i]] * Sin[2*Pi*i/(maxK+5)]},
    {i, 1, Length[rPoincareInside]}
  ];

  outsidePoints = Table[
    {rPoincareOutside[[i]] * Cos[2*Pi*i/(maxK+5)],
     rPoincareOutside[[i]] * Sin[2*Pi*i/(maxK+5)]},
    {i, 1, Length[rPoincareOutside]}
  ];

  (* Create visualization *)
  plot = Graphics[{
    (* Unit circle boundary *)
    {Thick, Black, Circle[{0, 0}, 1]},

    (* Inside trajectory (upper sheet) *)
    {Blue, PointSize[0.015], Point[insidePoints]},
    {Blue, Opacity[0.3], Line[insidePoints]},

    (* Outside trajectory (lower sheet, inverted) *)
    {Red, PointSize[0.015], Point[outsidePoints]},
    {Red, Opacity[0.3], Line[outsidePoints]},

    (* Connection lines *)
    Table[
      {Gray, Dashed, Opacity[0.2],
       Line[{insidePoints[[i]], outsidePoints[[i]]}]},
      {i, 1, Length[insidePoints]}
    ],

    (* Labels *)
    {Blue, Text[Style["Upper sheet\n(inside disk)", 12], {0.5, -0.8}]},
    {Red, Text[Style["Lower sheet\n(outside, inverted)", 12], {1.5, -1.5}]},
    {Black, Text[Style["Unit circle", 10], {0.7, 0.7}]},

    (* Mark k values every 5 steps *)
    Table[
      {Blue, Text[Style[ToString[kValues[[i]]], 8],
                  insidePoints[[i]] + {0.08, 0.08}]},
      {i, 1, Min[50, Length[insidePoints]], 5}
    ],
    Table[
      {Red, Text[Style[ToString[kValues[[i]]], 8],
                  outsidePoints[[i]] + {0.08, 0.08}]},
      {i, 1, Min[50, Length[outsidePoints]], 10}
    ]
  },
  PlotRange -> {{-3, 3}, {-3, 3}},
  AspectRatio -> 1,
  PlotLabel -> Style["Egypt Trajectory: " <> label <> " with Poincare Inversion", 14, Bold],
  Frame -> True,
  GridLines -> Automatic,
  ImageSize -> 800
  ];

  (* Export *)
  filename = "visualizations/viz_poincare_inversion_" <> ToString[n] <> ".png";
  Export[filename, plot];
  Print["Exported: ", filename];

  AppendTo[allPlots, plot];
  Print[];

, {caseIdx, 1, Length[testCases]}];

(* Create radial plot showing r vs k *)
Print["Creating radial distance plot...\n"];

radialPlot = ListLogPlot[
  Table[
    {n, label, maxK} = testCases[[i]];
    seq = computePoincareSequence[n, maxK];
    Labeled[
      Transpose[{seq[[All, 1]], seq[[All, 4]]}],
      label,
      Above
    ]
  , {i, 1, Length[testCases]}],
  Joined -> True,
  PlotStyle -> {Blue, Green, Purple},
  PlotMarkers -> Automatic,
  AxesLabel -> {"k", "Poincare radius r"},
  PlotLabel -> "Egypt Convergence in Poincare Disk",
  GridLines -> {{}, {1}},
  GridLinesStyle -> Directive[Red, Dashed],
  PlotLegends -> testCases[[All, 2]],
  ImageSize -> 600
];

Export["visualizations/viz_poincare_radial.png", radialPlot];
Print["Exported: visualizations/viz_poincare_radial.png\n"];

(* Inversion ratio analysis *)
Print["Inversion ratio analysis:\n"];
Print["k\tr_inside\tr_outside\tr_in * r_out\n"];
Print[StringRepeat["-", 60]];

{n, label, maxK} = testCases[[3]];  (* Use sqrt(13) *)
seq = computePoincareSequence[n, maxK];

Do[
  {k, r, x, rIn, rOut} = seq[[i]];
  product = rIn * rOut;
  Print[k, "\t", N[rIn, 6], "\t", N[rOut, 6], "\t", N[product, 8]];
, {i, 1, Min[10, Length[seq]]}];

Print["\nAll products should equal 1 (inversion property)"];
products = Table[seq[[i, 4]] * seq[[i, 5]], {i, 1, Length[seq]}];
Print["Max deviation from 1: ", N[Max[Abs[products - 1]], 6]];
Print[];

(* Combined visualization with both radial views *)
Print["Creating combined radial visualization...\n"];

{n, label, maxK} = testCases[[3]];
seq = computePoincareSequence[n, maxK];

combinedRadial = ListPlot[
  {
    Transpose[{seq[[All, 1]], seq[[All, 4]]}],  (* Inside *)
    Transpose[{seq[[All, 1]], seq[[All, 5]]}]   (* Outside *)
  },
  Joined -> True,
  PlotStyle -> {{Blue, Thick}, {Red, Thick}},
  PlotLegends -> {"Inside disk (r < 1)", "Outside disk (r > 1)"},
  AxesLabel -> {"k", "Poincare radius"},
  PlotLabel -> "Egypt " <> label <> ": Inversion Symmetry",
  GridLines -> {{}, {1}},
  GridLinesStyle -> Directive[Black, Thick],
  PlotRange -> All,
  ImageSize -> 600
];

Export["visualizations/viz_poincare_inversion_radial.png", combinedRadial];
Print["Exported: visualizations/viz_poincare_inversion_radial.png\n"];

Print["DONE! All visualizations created.\n"];
