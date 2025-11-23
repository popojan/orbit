#!/usr/bin/env wolframscript
(* Visualizations of circi/circj trajectories *)

circi[k_, Rational[a_, b_]] := (1 + I) ((a + I b)^4)^k (a^2 + b^2)^(-2 k)
circj[k_, Rational[a_, b_]] := (a - I b)^(4 k) (a^2 + b^2)^(-2 k)
circjAlg[k_, a_] := (a - I)^(4 k) (a^2 + 1)^(-2 k)
circiAlg[k_, a_] := (1 + I) ((a + I)^4)^k (a^2 + 1)^(-2 k)

Print["Generating visualizations..."];
Print[""];

(* Plot 1: Comparing unit circle (circj) vs √2 circle (circi) *)
rat = 1/2;
maxK = 30;

pointsJ = Table[{Re[#], Im[#]}&@circj[k, rat], {k, 0, maxK}];
pointsI = Table[{Re[#], Im[#]}&@circi[k, rat], {k, 0, maxK}];

plot1 = Graphics[{
  (* Unit circle *)
  {Gray, Dashed, Circle[{0, 0}, 1]},
  {Blue, PointSize[0.015], Point[pointsJ]},
  {Blue, Opacity[0.3], Line[pointsJ]},

  (* √2 circle *)
  {Gray, Dashed, Circle[{0, 0}, Sqrt[2]]},
  {Red, PointSize[0.015], Point[pointsI]},
  {Red, Opacity[0.3], Line[pointsI]},

  (* Labels *)
  Text[Style["circj (r=1)", Blue, 14], {-0.5, -1.3}],
  Text[Style["circi (r=√2)", Red, 14], {-0.7, -1.7}]
},
  PlotRange -> {{-2.2, 2.2}, {-2.2, 2.2}},
  AspectRatio -> 1,
  ImageSize -> 600,
  PlotLabel -> Style["circj vs circi with a/b = 1/2, k = 0..30", 16]
];

Export["/home/jan/github/orbit/viz_circj_vs_circi.png", plot1];
Print["Saved: viz_circj_vs_circi.png"];

(* Plot 2: Special algebraic case with period 12 *)
a24 = 2 + Sqrt[2] + Sqrt[3] + Sqrt[6];
maxK2 = 24;

pointsAlgJ = Table[{Re[#], Im[#]}&@circjAlg[k, a24], {k, 0, maxK2}];
pointsAlgI = Table[{Re[#], Im[#]}&@circiAlg[k, a24], {k, 0, maxK2}];

(* Highlight period points *)
period = 12;
periodPointsJ = Table[{Re[#], Im[#]}&@circjAlg[k, a24], {k, 0, period-1}];
periodPointsI = Table[{Re[#], Im[#]}&@circiAlg[k, a24], {k, 0, period-1}];

plot2 = Graphics[{
  (* Unit circle *)
  {Gray, Dashed, Circle[{0, 0}, 1]},
  {Blue, Opacity[0.2], Line[pointsAlgJ]},
  {Blue, PointSize[0.02], Point[periodPointsJ]},

  (* √2 circle *)
  {Gray, Dashed, Circle[{0, 0}, Sqrt[2]]},
  {Red, Opacity[0.2], Line[pointsAlgI]},
  {Red, PointSize[0.02], Point[periodPointsI]},

  (* Highlight start *)
  {Green, PointSize[0.025], Point[{{1, 0}, {Sqrt[2]/Sqrt[2], Sqrt[2]/Sqrt[2]}}]},

  (* Labels *)
  Text[Style["Period = 12", Bold, 16], {0, -1.8}],
  Text[Style["a = Cot[π/48]", 12], {0, -2.0}]
},
  PlotRange -> {{-2.2, 2.2}, {-2.2, 2.2}},
  AspectRatio -> 1,
  ImageSize -> 600,
  PlotLabel -> Style["Integer Period with a = 2+√2+√3+√6", 16]
];

Export["/home/jan/github/orbit/viz_period_12.png", plot2];
Print["Saved: viz_period_12.png"];

(* Plot 3: Angle progression comparison *)
angles = Table[{k, Arg[circj[k, rat]]*180/Pi}, {k, 0, 20}];
anglesI = Table[{k, Arg[circi[k, rat]]*180/Pi}, {k, 0, 20}];

plot3 = ListPlot[{angles, anglesI},
  PlotStyle -> {{Blue, PointSize[0.015]}, {Red, PointSize[0.015]}},
  Joined -> True,
  PlotLegends -> {"circj (unit)", "circi (√2)"},
  AxesLabel -> {"k", "Angle (degrees)"},
  PlotLabel -> Style["Angle Progression: a/b = 1/2", 16],
  ImageSize -> 700,
  GridLines -> Automatic
];

Export["/home/jan/github/orbit/viz_angles.png", plot3];
Print["Saved: viz_angles.png"];

(* Plot 4: Distance from start for algebraic case *)
a24 = 2 + Sqrt[2] + Sqrt[3] + Sqrt[6];
z0J = circjAlg[0, a24];
z0I = circiAlg[0, a24];

distsJ = Table[{k, Abs[circjAlg[k, a24] - z0J]}, {k, 1, 30}];
distsI = Table[{k, Abs[circiAlg[k, a24] - z0I]}, {k, 1, 30}];

plot4 = ListPlot[{distsJ, distsI},
  PlotStyle -> {{Blue, PointSize[0.015]}, {Red, PointSize[0.015]}},
  Joined -> True,
  PlotLegends -> {"circj (unit)", "circi (√2)"},
  AxesLabel -> {"k", "Distance from start"},
  PlotLabel -> Style["Return to Start: a = 2+√2+√3+√6", 16],
  ImageSize -> 700,
  GridLines -> {{12, 24}, Automatic},
  Epilog -> {
    {Green, Dashed, Line[{{12, 0}, {12, 2.5}}]},
    Text[Style["Period = 12", Green, 12], {12, 2.3}, {-1, 0}]
  }
];

Export["/home/jan/github/orbit/viz_distance.png", plot4];
Print["Saved: viz_distance.png"];

Print[""];
Print["All visualizations generated successfully!"];
