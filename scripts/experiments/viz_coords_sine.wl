#!/usr/bin/env wolframscript
(* Plot x,y coordinates as sine waves *)

circjAlg[k_, a_] := (a - I)^(4 k) (a^2 + 1)^(-2 k);
circiAlg[k_, a_] := (1 + I) ((a + I)^4)^k (a^2 + 1)^(-2 k);

Print["Plotting x,y coordinates as sinusoids..."];

a24 = 2 + Sqrt[2] + Sqrt[3] + Sqrt[6];
maxK = 36;

(* Discrete points *)
xPointsJ = Table[{k, Re[circjAlg[k, a24]]}, {k, 0, maxK}];
yPointsJ = Table[{k, Im[circjAlg[k, a24]]}, {k, 0, maxK}];

xPointsI = Table[{k, Re[circiAlg[k, a24]]}, {k, 0, maxK}];
yPointsI = Table[{k, Im[circiAlg[k, a24]]}, {k, 0, maxK}];

(* Theoretical continuous curves *)
omega = 4*ArcTan[1/a24];  (* angular frequency *)
Print["Angular frequency: ω = ", N[omega, 6], " rad/step"];
Print["Period: T = 2π/ω = ", N[2*Pi/omega], " steps"];
Print[""];

(* For circj (unit circle, starting at (1,0)) *)
xTheoryJ[k_] := Cos[omega * k];
yTheoryJ[k_] := Sin[omega * k];

(* For circi (√2 circle, starting at (1,1)/√2) *)
xTheoryI[k_] := Sqrt[2] * Cos[Pi/4 + omega * k];
yTheoryI[k_] := Sqrt[2] * Sin[Pi/4 + omega * k];

(* Plot x-coordinate for unit circle *)
plot1 = Plot[xTheoryJ[k], {k, 0, maxK},
  PlotStyle -> {Gray, Dashed, Thickness[0.003]},
  PlotRange -> {{0, maxK}, {-1.2, 1.2}},
  AxesLabel -> {"k", "x"},
  PlotLabel -> Style["circj: x-coordinate (unit circle)", 16],
  ImageSize -> 800,
  GridLines -> {Range[0, maxK, 12], {0}},
  Epilog -> {
    Black, PointSize[0.012], Point[xPointsJ],
    Green, Dashed, Line[{{12, -1.2}, {12, 1.2}}],
    Green, Dashed, Line[{{24, -1.2}, {24, 1.2}}],
    Text[Style["Period = 12", Green, 12], {12, 1.1}, {-1, 0}]
  }
];

Export["/home/jan/github/orbit/viz_x_unit.png", plot1];
Print["Saved: viz_x_unit.png"];

(* Plot y-coordinate for unit circle *)
plot2 = Plot[yTheoryJ[k], {k, 0, maxK},
  PlotStyle -> {Gray, Dashed, Thickness[0.003]},
  PlotRange -> {{0, maxK}, {-1.2, 1.2}},
  AxesLabel -> {"k", "y"},
  PlotLabel -> Style["circj: y-coordinate (unit circle)", 16],
  ImageSize -> 800,
  GridLines -> {Range[0, maxK, 12], {0}},
  Epilog -> {
    Black, PointSize[0.012], Point[yPointsJ],
    Green, Dashed, Line[{{12, -1.2}, {12, 1.2}}],
    Green, Dashed, Line[{{24, -1.2}, {24, 1.2}}]
  }
];

Export["/home/jan/github/orbit/viz_y_unit.png", plot2];
Print["Saved: viz_y_unit.png"];

(* Plot x-coordinate for √2 circle *)
plot3 = Plot[xTheoryI[k], {k, 0, maxK},
  PlotStyle -> {Red, Dashed, Thickness[0.003]},
  PlotRange -> {{0, maxK}, {-1.6, 1.6}},
  AxesLabel -> {"k", "x"},
  PlotLabel -> Style["circi: x-coordinate (√2 circle)", 16],
  ImageSize -> 800,
  GridLines -> {Range[0, maxK, 12], {0}},
  Epilog -> {
    Black, PointSize[0.012], Point[xPointsI],
    Green, Dashed, Line[{{12, -1.6}, {12, 1.6}}],
    Green, Dashed, Line[{{24, -1.6}, {24, 1.6}}]
  }
];

Export["/home/jan/github/orbit/viz_x_sqrt2.png", plot3];
Print["Saved: viz_x_sqrt2.png"];

(* Plot y-coordinate for √2 circle *)
plot4 = Plot[yTheoryI[k], {k, 0, maxK},
  PlotStyle -> {Red, Dashed, Thickness[0.003]},
  PlotRange -> {{0, maxK}, {-1.6, 1.6}},
  AxesLabel -> {"k", "y"},
  PlotLabel -> Style["circi: y-coordinate (√2 circle)", 16],
  ImageSize -> 800,
  GridLines -> {Range[0, maxK, 12], {0}},
  Epilog -> {
    Black, PointSize[0.012], Point[yPointsI],
    Green, Dashed, Line[{{12, -1.6}, {12, 1.6}}],
    Green, Dashed, Line[{{24, -1.6}, {24, 1.6}}]
  }
];

Export["/home/jan/github/orbit/viz_y_sqrt2.png", plot4];
Print["Saved: viz_y_sqrt2.png"];

(* Combined x and y for unit circle *)
plot5 = Plot[{xTheoryJ[k], yTheoryJ[k]}, {k, 0, maxK},
  PlotStyle -> {{Blue, Dashed, Thickness[0.002]}, {Red, Dashed, Thickness[0.002]}},
  PlotRange -> {{0, maxK}, {-1.2, 1.2}},
  AxesLabel -> {"k", "coordinate"},
  PlotLabel -> Style["circj: x (blue) and y (red) coordinates", 16],
  ImageSize -> 800,
  GridLines -> {Range[0, maxK, 12], {0}},
  Epilog -> {
    Blue, PointSize[0.01], Point[xPointsJ],
    Red, PointSize[0.01], Point[yPointsJ],
    Green, Dashed, Line[{{12, -1.2}, {12, 1.2}}],
    Green, Dashed, Line[{{24, -1.2}, {24, 1.2}}]
  }
];

Export["/home/jan/github/orbit/viz_xy_combined.png", plot5];
Print["Saved: viz_xy_combined.png"];

Print[""];
Print["All coordinate sinusoid visualizations generated!"];
