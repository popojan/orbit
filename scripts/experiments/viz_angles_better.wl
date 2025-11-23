#!/usr/bin/env wolframscript
(* Better angle progression visualization *)

circjAlg[k_, a_] := (a - I)^(4 k) (a^2 + 1)^(-2 k);
circiAlg[k_, a_] := (1 + I) ((a + I)^4)^k (a^2 + 1)^(-2 k);

Print["Generating better angle visualizations..."];

(* Use algebraic case with period 12 *)
a24 = 2 + Sqrt[2] + Sqrt[3] + Sqrt[6];

(* Compute angles for discrete k *)
maxK = 36;
anglesJ = Table[{k, Arg[circjAlg[k, a24]]*180/Pi}, {k, 0, maxK}];
anglesI = Table[{k, Arg[circiAlg[k, a24]]*180/Pi}, {k, 0, maxK}];

(* Theoretical continuous function *)
(* For circjAlg: angle = 4k * arctan(1/a) mod 2π *)
baseAngle = 4*ArcTan[1/a24];
Print["Base angle per step: ", N[baseAngle*180/Pi, 5], "°"];
Print["Period: ", N[2*Pi/baseAngle], " (should be 12)"];
Print[""];

(* Continuous theoretical curve *)
theoreticalAngle[k_] := Mod[4*k*ArcTan[1/a24]*180/Pi, 360, -180];

(* Plot for circjAlg (unit circle) *)
plot1 = Plot[theoreticalAngle[k], {k, 0, maxK},
  PlotStyle -> {Gray, Dashed, Thickness[0.003]},
  PlotRange -> {{0, maxK}, {-200, 200}},
  AxesLabel -> {"k", "Angle (°)"},
  PlotLabel -> Style["circjAlg: Angle Progression (unit circle)", 16],
  ImageSize -> 800,
  GridLines -> {Range[0, maxK, 12], Automatic},
  Epilog -> {
    Black, PointSize[0.012], Point[anglesJ],
    Green, Dashed, Line[{{12, -200}, {12, 200}}],
    Green, Dashed, Line[{{24, -200}, {24, 200}}],
    Text[Style["Period = 12", Green, 12], {12, 180}, {-1, 0}]
  }
];

Export["/home/jan/github/orbit/viz_angles_unit.png", plot1];
Print["Saved: viz_angles_unit.png"];

(* Plot for circiAlg (√2 circle) - shifted by 45° *)
theoreticalAngleI[k_] := Mod[45 + 4*k*ArcTan[1/a24]*180/Pi, 360, -180];

plot2 = Plot[theoreticalAngleI[k], {k, 0, maxK},
  PlotStyle -> {Gray, Dashed, Thickness[0.003]},
  PlotRange -> {{0, maxK}, {-200, 200}},
  AxesLabel -> {"k", "Angle (°)"},
  PlotLabel -> Style["circiAlg: Angle Progression (√2 circle, +45° offset)", 16],
  ImageSize -> 800,
  GridLines -> {Range[0, maxK, 12], Automatic},
  Epilog -> {
    Black, PointSize[0.012], Point[anglesI],
    Green, Dashed, Line[{{12, -200}, {12, 200}}],
    Green, Dashed, Line[{{24, -200}, {24, 200}}],
    Text[Style["Period = 12", Green, 12], {12, 180}, {-1, 0}]
  }
];

Export["/home/jan/github/orbit/viz_angles_sqrt2.png", plot2];
Print["Saved: viz_angles_sqrt2.png"];

(* Combined plot - both on same graph *)
plot3 = Plot[{theoreticalAngle[k], theoreticalAngleI[k]}, {k, 0, maxK},
  PlotStyle -> {{Blue, Dashed, Thickness[0.002]}, {Red, Dashed, Thickness[0.002]}},
  PlotRange -> {{0, maxK}, {-200, 200}},
  AxesLabel -> {"k", "Angle (°)"},
  PlotLabel -> Style["Angle Progression Comparison", 16],
  ImageSize -> 800,
  GridLines -> {Range[0, maxK, 12], {0, 45, 90, -90, -180, 180}},
  Epilog -> {
    Blue, PointSize[0.01], Point[anglesJ],
    Red, PointSize[0.01], Point[anglesI],
    Green, Dashed, Line[{{12, -200}, {12, 200}}],
    Green, Dashed, Line[{{24, -200}, {24, 200}}],
    Text[Style["circj (unit)", Blue, 12], {2, -150}],
    Text[Style["circi (√2)", Red, 12], {2, 100}]
  }
];

Export["/home/jan/github/orbit/viz_angles_combined.png", plot3];
Print["Saved: viz_angles_combined.png"];

(* Residuals - how well do points match theory? *)
residualsJ = Table[{k, Arg[circjAlg[k, a24]]*180/Pi - theoreticalAngle[k]}, {k, 0, maxK}];

plot4 = ListPlot[residualsJ,
  PlotStyle -> {Blue, PointSize[0.012]},
  AxesLabel -> {"k", "Residual (°)"},
  PlotLabel -> Style["Deviation from Theoretical Angle", 14],
  ImageSize -> 700,
  GridLines -> Automatic
];

Export["/home/jan/github/orbit/viz_angles_residuals.png", plot4];
Print["Saved: viz_angles_residuals.png"];

Print[""];
Print["All angle visualizations generated!"];
