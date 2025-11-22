#!/usr/bin/env wolframscript
(* Map zeta zeros to logarithmic spiral using density formula *)

Print["Mapping zeta zeros to spiral using Riemann-von Mangoldt formula...\n"];

(* Riemann-von Mangoldt counting function (approximation) *)
countingFunction[t_] := (t/(2*Pi)) * Log[t/(2*Pi*E)] + 7/8;

(* Get zeta zeros *)
nZeros = 100;
zetaZeros = Table[ZetaZero[n], {n, 1, nZeros}];
zetaT = Im /@ zetaZeros;

Print["First 10 zeros:"];
Do[
  t = zetaT[[i]];
  nEst = countingFunction[t];
  Print["  n=", i, ": t=", N[t, 8], ", n(t)=", N[nEst, 6],
        " (actual n=", i, ", error=", N[Abs[i - nEst], 4], ")"];
, {i, 1, 10}];
Print[];

(* Spiral mappings *)
(* Variant 1: r = sqrt(n(t)), θ = t/scale *)
spiral1[t_, scale_] := Module[{n, r, theta},
  n = countingFunction[t];
  r = Sqrt[n];
  theta = t/scale;
  r * Exp[I*theta]
];

(* Variant 2: r = log(1 + n(t)), θ = t/scale *)
spiral2[t_, scale_] := Module[{n, r, theta},
  n = countingFunction[t];
  r = Log[1 + n];
  theta = t/scale;
  r * Exp[I*theta]
];

(* Variant 3: r = n(t)^(1/3), θ = t/scale *)
spiral3[t_, scale_] := Module[{n, r, theta},
  n = countingFunction[t];
  r = n^(1/3);
  theta = t/scale;
  r * Exp[I*theta]
];

(* Try different angular scales *)
scale = 5;  (* Controls how tightly wound the spiral is *)

zeros1 = spiral1[#, scale]& /@ zetaT;
zeros2 = spiral2[#, scale]& /@ zetaT;
zeros3 = spiral3[#, scale]& /@ zetaT;

Print["Spiral statistics (scale = ", scale, "):\n"];

stats[name_, data_] := Module[{radii, angles, spacings},
  radii = Abs /@ data;
  angles = Arg /@ data;
  spacings = Table[Abs[data[[i+1]] - data[[i]]], {i, 1, Length[data]-1}];
  Print[name, ":"];
  Print["  Radii: min=", N[Min[radii], 6], ", max=", N[Max[radii], 6]];
  Print["  Angles: min=", N[Min[angles], 6], ", max=", N[Max[angles], 6]];
  Print["  Euclidean spacing: min=", N[Min[spacings], 6],
        ", max=", N[Max[spacings], 6], ", mean=", N[Mean[spacings], 6]];
  Print[];
];

stats["r = √n(t)", zeros1];
stats["r = log(1+n(t))", zeros2];
stats["r = n(t)^(1/3)", zeros3];

(* Visualizations *)
Print["Creating visualizations...\n"];

makeSpiral[data_, label_, color_] := Module[{points, maxR},
  points = {Re[#], Im[#]}& /@ N[data];
  maxR = Max[Abs /@ data];
  Graphics[{
    (* Spiral guide circles *)
    Table[{LightGray, Dashed, Circle[{0, 0}, r]}, {r, 1, maxR, maxR/5}],
    (* Axes *)
    {LightGray, Line[{{-maxR, 0}, {maxR, 0}}], Line[{{0, -maxR}, {0, maxR}}]},
    (* Data points *)
    {color, PointSize[0.01], Point[points]},
    (* Connect consecutive points *)
    {color, Opacity[0.3], Line[points]},
    (* Label *)
    Text[Style[label, Bold, 14], {0, maxR*1.15}]
  },
    PlotRange -> {{-maxR*1.2, maxR*1.2}, {-maxR*1.2, maxR*1.2}},
    AspectRatio -> 1,
    Frame -> True,
    FrameLabel -> {"Re(w)", "Im(w)"},
    ImageSize -> 500
  ]
];

plot1 = makeSpiral[zeros1, "r = √n(t), θ = t/" <> ToString[scale], Blue];
plot2 = makeSpiral[zeros2, "r = log(1+n(t)), θ = t/" <> ToString[scale], Red];
plot3 = makeSpiral[zeros3, "r = n(t)^(1/3), θ = t/" <> ToString[scale], Green];

combined = GraphicsGrid[{{plot1, plot2}, {plot3, Graphics[]}},
  ImageSize -> 1000,
  PlotLabel -> Style["Logarithmic Spiral Mapping of Zeta Zeros", Bold, 16]
];

Export["viz_spiral_mapping.png", combined];
Print["Exported: viz_spiral_mapping.png"];

(* Also create polar plot showing angular distribution *)
polarPlot = PolarPlot[{
  Sqrt[countingFunction[scale*theta]],
  Log[1 + countingFunction[scale*theta]],
  countingFunction[scale*theta]^(1/3)
}, {theta, 0, 4*Pi},
  PlotStyle -> {Blue, Red, Green},
  PlotLegends -> {"√n(t)", "log(1+n(t))", "n(t)^(1/3)"},
  PlotLabel -> Style["Spiral Curves", Bold, 14],
  ImageSize -> 500
];

Export["viz_spiral_curves.png", polarPlot];
Print["Exported: viz_spiral_curves.png"];

(* Spacing analysis *)
Print["\n=== SPACING ANALYSIS ===\n"];

spacings1 = Table[Abs[zeros1[[i+1]] - zeros1[[i]]], {i, 1, nZeros-1}];
Print["Variant 1 (r = √n(t)):"];
Print["  Spacing variability (std/mean): ", N[StandardDeviation[spacings1]/Mean[spacings1], 4]];
Print["  Coefficient of variation: ", N[100*StandardDeviation[spacings1]/Mean[spacings1], 2], "%"];
Print[];

spacings2 = Table[Abs[zeros2[[i+1]] - zeros2[[i]]], {i, 1, nZeros-1}];
Print["Variant 2 (r = log(1+n(t))):"];
Print["  Spacing variability (std/mean): ", N[StandardDeviation[spacings2]/Mean[spacings2], 4]];
Print["  Coefficient of variation: ", N[100*StandardDeviation[spacings2]/Mean[spacings2], 2], "%"];
Print[];

spacings3 = Table[Abs[zeros3[[i+1]] - zeros3[[i]]], {i, 1, nZeros-1}];
Print["Variant 3 (r = n(t)^(1/3)):"];
Print["  Spacing variability (std/mean): ", N[StandardDeviation[spacings3]/Mean[spacings3], 4]];
Print["  Coefficient of variation: ", N[100*StandardDeviation[spacings3]/Mean[spacings3], 2], "%"];
Print[];

Print["DONE!"];
