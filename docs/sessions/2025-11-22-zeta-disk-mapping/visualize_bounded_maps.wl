#!/usr/bin/env wolframscript
(* Map critical line to bounded interval using various functions *)

Print["Testing bounded maps of critical line (assuming RH)...\n"];

(* Get first 50 zeta zeros *)
nZeros = 50;
zetaZeros = Table[ZetaZero[n], {n, 1, nZeros}];
zetaT = Im /@ zetaZeros;  (* Extract t_n values *)

Print["First 10 imaginary parts t_n:"];
Do[
  Print["  t_", i, " = ", N[zetaT[[i]], 8]];
, {i, 1, 10}];
Print[];

(* Various bounded maps *)
(* Map 1: Hyperbolic tangent (most compressed) *)
map1[t_] := Tanh[t/20];  (* Scale factor 20 *)

(* Map 2: Rational (algebraic decay) *)
map2[t_] := t/Sqrt[1 + t^2];

(* Map 3: Arctangent (bounded to [-π/2, π/2]) *)
map3[t_] := ArcTan[t/10];  (* Scale factor 10 *)

(* Map 4: Error function (sigmoid-like) *)
map4[t_] := Erf[t/30];  (* Scale factor 30 *)

(* Apply transformations *)
zeros1 = map1 /@ zetaT;
zeros2 = map2 /@ zetaT;
zeros3 = map3 /@ zetaT;
zeros4 = map4 /@ zetaT;

Print["First 5 zeros under different maps:\n"];

Print["Map 1: tanh(t/20)"];
Do[Print["  w_", i, " = ", N[zeros1[[i]], 8]], {i, 1, 5}];
Print[];

Print["Map 2: t/sqrt(1+t²)"];
Do[Print["  w_", i, " = ", N[zeros2[[i]], 8]], {i, 1, 5}];
Print[];

Print["Map 3: arctan(t/10)"];
Do[Print["  w_", i, " = ", N[zeros3[[i]], 8]], {i, 1, 5}];
Print[];

Print["Map 4: erf(t/30)"];
Do[Print["  w_", i, " = ", N[zeros4[[i]], 8]], {i, 1, 5}];
Print[];

(* Statistics *)
Print["=== SPREAD STATISTICS ===\n"];

stats[name_, data_] := Module[{min, max, range, spacings},
  min = Min[data];
  max = Max[data];
  range = max - min;
  spacings = Table[Abs[data[[i+1]] - data[[i]]], {i, 1, Length[data]-1}];
  Print[name, ":"];
  Print["  Range: [", N[min, 6], ", ", N[max, 6], "] (width = ", N[range, 6], ")"];
  Print["  Spacing: min=", N[Min[spacings], 6], ", max=", N[Max[spacings], 6],
        ", mean=", N[Mean[spacings], 6]];
  Print[];
];

stats["tanh(t/20)", zeros1];
stats["t/sqrt(1+t²)", zeros2];
stats["arctan(t/10)", zeros3];
stats["erf(t/30)", zeros4];

(* Visualizations *)
Print["Creating visualizations...\n"];

(* Helper function for scatter plot on real line *)
makeLinePlot[data_, label_, color_] := Graphics[{
  (* Horizontal axis *)
  {Gray, Line[{{-1.2, 0}, {1.2, 0}}]},
  (* Tick marks at -1, 0, 1 *)
  {Gray, Line[{{-1, -0.05}, {-1, 0.05}}], Line[{{0, -0.05}, {0, 0.05}}],
   Line[{{1, -0.05}, {1, 0.05}}]},
  Text["-1", {-1, -0.15}], Text["0", {0, -0.15}], Text["1", {1, -0.15}],
  (* Data points *)
  {color, PointSize[0.015], Point[{#, 0}& /@ N[data]]},
  (* Label *)
  Text[Style[label, Bold, 12], {0, 0.3}]
},
  PlotRange -> {{-1.3, 1.3}, {-0.4, 0.4}},
  AspectRatio -> 0.3,
  Frame -> False,
  ImageSize -> 800
];

plot1 = makeLinePlot[zeros1, "w = tanh(t/20)", Blue];
plot2 = makeLinePlot[zeros2, "w = t/√(1+t²)", Red];
plot3 = makeLinePlot[zeros3, "w = arctan(t/10)", Green];
plot4 = makeLinePlot[zeros4, "w = erf(t/30)", Orange];

combined = GraphicsColumn[{plot1, plot2, plot3, plot4},
  ImageSize -> 800,
  Spacings -> 30,
  PlotLabel -> Style["Bounded Maps of Zeta Zeros on Critical Line", Bold, 16]
];

Export["viz_bounded_maps.png", combined];
Print["Exported: viz_bounded_maps.png"];

(* Also create histogram of spacings for best map *)
bestData = zeros2;  (* t/sqrt(1+t²) has good balance *)
spacings = Table[bestData[[i+1]] - bestData[[i]], {i, 1, nZeros-1}];

histPlot = Histogram[N[spacings], 15,
  PlotLabel -> Style["Spacing Distribution: w = t/√(1+t²)", Bold, 14],
  AxesLabel -> {"Spacing Δw", "Count"},
  ImageSize -> 600,
  ChartStyle -> Blue
];

Export["viz_bounded_spacing_histogram.png", histPlot];
Print["Exported: viz_bounded_spacing_histogram.png"];

Print["\nDONE!"];
