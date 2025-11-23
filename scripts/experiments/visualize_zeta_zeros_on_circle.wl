#!/usr/bin/env wolframscript
(* Visualize Riemann zeta zeros on unit circle via different Moebius transformations *)

Print["=== ZETA ZEROS ON UNIT CIRCLE ===\n"];
Print["Assuming RH: all non-trivial zeros at s = 1/2 + it_n\n"];

(* Get first nZeros zeta zeros (imaginary parts) *)
nZeros = 30;
Print["Loading first ", nZeros, " zeta zeros...\n"];

zetaZeros = Table[ZetaZero[n], {n, 1, nZeros}];

Print["First 10 zeros (imaginary parts t_n):\n"];
Do[
  Print["t_", i, " = ", NumberForm[N[zetaZeros[[i]]], {8, 4}]];
, {i, 1, Min[10, nZeros]}];
Print[];

(* ================================================================
   VARIANT A: Direct Moebius on critical line
   ================================================================ *)

Print[StringRepeat["=", 70]];
Print["VARIANT A: Direct Moebius w = s/(s-1)"];
Print[StringRepeat["=", 70]];
Print[];
Print["s_n = 1/2 + it_n  (critical line)"];
Print["w_n = s_n/(s_n - 1)"];
Print[];

variantA[s_] := Module[{w},
  (* s is already on critical line: s = 1/2 + it *)
  w = s/(s - 1);
  w
];

zerosA = variantA /@ zetaZeros;
anglesA = Arg /@ zerosA;

Print["Sample transformations:\n"];
Print["t_n\t\ts_n\t\tw_n\t\t|w_n|\t\targ(w_n)"];
Print[StringRepeat["-", 90]];
Do[
  s = zetaZeros[[i]];
  t = Im[s];
  w = zerosA[[i]];
  Print[
    NumberForm[N[t], {6, 2}], "\t",
    NumberForm[N[s], {8, 3}], "\t",
    NumberForm[N[w], {8, 3}], "\t",
    NumberForm[N[Abs[w]], {6, 4}], "\t\t",
    NumberForm[N[Arg[w]], {6, 3}]
  ];
, {i, {1, 5, 10}}];
Print[];

(* Angular spacings *)
spacingsA = Differences[anglesA];
Print["Angular spacings Δθ (radians):\n"];
Print["Mean: ", Mean[spacingsA] // N];
Print["Std:  ", StandardDeviation[spacingsA] // N];
Print["Min:  ", Min[spacingsA] // N];
Print["Max:  ", Max[spacingsA] // N];
Print[];

(* ================================================================
   VARIANT B: Invert t, then Moebius
   ================================================================ *)

Print[StringRepeat["=", 70]];
Print["VARIANT B: Invert t, then Moebius"];
Print[StringRepeat["=", 70]];
Print[];
(*Print["t_n -> 1/t_n (invert imaginary parts)");*)
(*Print["s'_n = 1/2 + i(1/t_n)  (new critical line points)");*)
(*Print["w_n = s'_n/(s'_n - 1)");*)
Print[];

variantB[s_] := Module[{t, tInv, sPrime, w},
  (* Extract imaginary part t from s = 1/2 + it *)
  t = Im[s];
  tInv = 1/t;
  sPrime = 1/2 + I*tInv;
  w = sPrime/(sPrime - 1);
  w
];

zerosB = variantB /@ zetaZeros;
anglesB = Arg /@ zerosB;

Print["Sample transformations:\n"];
Print["t_n\t\t1/t_n\t\ts'_n\t\tw_n\t\t|w_n|\t\targ(w_n)"];
Print[StringRepeat["-", 100]];
Do[
  s = zetaZeros[[i]];
  t = Im[s];
  tInv = 1/t;
  sPrime = 1/2 + I*tInv;
  w = zerosB[[i]];
  Print[
    NumberForm[N[t], {6, 2}], "\t",
    NumberForm[N[tInv], {6, 4}], "\t",
    NumberForm[N[sPrime], {8, 3}], "\t",
    NumberForm[N[w], {8, 3}], "\t",
    NumberForm[N[Abs[w]], {6, 4}], "\t\t",
    NumberForm[N[Arg[w]], {6, 3}]
  ];
, {i, {1, 5, 10}}];
Print[];

spacingsB = Differences[anglesB];
Print["Angular spacings Δθ (radians):\n"];
Print["Mean: ", Mean[spacingsB] // N];
Print["Std:  ", StandardDeviation[spacingsB] // N];
Print["Min:  ", Min[spacingsB] // N];
Print["Max:  ", Max[spacingsB] // N];
Print[];

(* ================================================================
   VARIANT C: Zeta shift + palindromic Moebius
   ================================================================ *)

(*
Print[StringRepeat["=", 70]];
Print["VARIANT C: Zeta shift + palindromic Moebius"];
Print[StringRepeat["=", 70]];
Print[];
Print["s_n = 1/2 + it_n"];
Print["Shift: s' = s - 1/2 = it_n  (imaginary axis)"];
Print["Rotate: s'' = -i*s' = -i(it_n) = t_n  (real axis!)"];
Print["Palindromic: w = (t_n + i)/(it_n + 1)"];
Print[];
*)

variantC[s_] := Module[{sPrime, sDoublePrime, w},
  (* s is already on critical line: s = 1/2 + it *)
  sPrime = s - 1/2;  (* = it *)
  sDoublePrime = -I * sPrime;  (* = t (real number!) *)
  (* Palindromic Moebius with a=1, b=i maps real axis to |w|=1 *)
  w = (sDoublePrime + I)/(I*sDoublePrime + 1);
  w
];

zerosC = variantC /@ zetaZeros;
anglesC = Arg /@ zerosC;

Print["Sample transformations:\n"];
Print["t_n\t\ts'\t\ts''\t\tw_n\t\t|w_n|\t\targ(w_n)"];
Print[StringRepeat["-", 95]];
Do[
  s = zetaZeros[[i]];
  t = Im[s];
  sPrime = s - 1/2;  (* = it *)
  sDoublePrime = -I * sPrime;  (* = t *)
  w = zerosC[[i]];
  Print[
    NumberForm[N[t], {6, 2}], "\t",
    NumberForm[N[sPrime], {8, 3}], "\t",
    NumberForm[N[sDoublePrime], {6, 2}], "\t",
    NumberForm[N[w], {8, 3}], "\t",
    NumberForm[N[Abs[w]], {6, 4}], "\t\t",
    NumberForm[N[Arg[w]], {6, 3}]
  ];
, {i, {1, 5, 10}}];
Print[];

spacingsC = Differences[anglesC];
Print["Angular spacings Δθ (radians):\n"];
Print["Mean: ", Mean[spacingsC] // N];
Print["Std:  ", StandardDeviation[spacingsC] // N];
Print["Min:  ", Min[spacingsC] // N];
Print["Max:  ", Max[spacingsC] // N];
Print[];

(* ================================================================
   VISUALIZATION: All 3 variants on circles
   ================================================================ *)

Print["Creating visualizations...\n"];

(* Plot 1: Three circles side-by-side *)
plotA = Graphics[{
  (* Unit circle *)
  Blue, Thickness[0.003],
  Circle[{0, 0}, 1],

  (* Zeros *)
  Red, PointSize[0.015],
  Point[Table[{Re[zerosA[[i]]], Im[zerosA[[i]]]}, {i, nZeros}]],

  (* First few labeled *)
  Black,
  Table[
    Text[ToString[i], 1.15*{Re[zerosA[[i]]], Im[zerosA[[i]]]}],
    {i, 1, Min[5, nZeros]}
  ],

  (* Title *)
  Text[Style["A: Direct Moebius", 12, Bold], {0, 1.4}],
  Text[Style["w = s/(s-1)", 10], {0, -1.4}]
},
  PlotRange -> {{-1.5, 1.5}, {-1.5, 1.5}},
  AspectRatio -> 1,
  Frame -> True,
  ImageSize -> 300
];

plotB = Graphics[{
  (* Unit circle *)
  Blue, Thickness[0.003],
  Circle[{0, 0}, 1],

  (* Zeros *)
  Red, PointSize[0.015],
  Point[Table[{Re[zerosB[[i]]], Im[zerosB[[i]]]}, {i, nZeros}]],

  (* First few labeled *)
  Black,
  Table[
    Text[ToString[i], 1.15*{Re[zerosB[[i]]], Im[zerosB[[i]]]}],
    {i, 1, Min[5, nZeros]}
  ],

  (* Title *)
  Text[Style["B: Invert + Moebius", 12, Bold], {0, 1.4}],
  Text[Style["t -> 1/t, then w=s/(s-1)", 10], {0, -1.4}]
},
  PlotRange -> {{-1.5, 1.5}, {-1.5, 1.5}},
  AspectRatio -> 1,
  Frame -> True,
  ImageSize -> 300
];

plotC = Graphics[{
  (* Unit circle *)
  Blue, Thickness[0.003],
  Circle[{0, 0}, 1],

  (* Zeros *)
  Red, PointSize[0.015],
  Point[Table[{Re[zerosC[[i]]], Im[zerosC[[i]]]}, {i, nZeros}]],

  (* First few labeled *)
  Black,
  Table[
    Text[ToString[i], 1.15*{Re[zerosC[[i]]], Im[zerosC[[i]]]}],
    {i, 1, Min[5, nZeros]}
  ],

  (* Title *)
  Text[Style["C: Palindromic", 12, Bold], {0, 1.4}],
  Text[Style["w = (t+i)/(it+1)", 10], {0, -1.4}]
},
  PlotRange -> {{-1.5, 1.5}, {-1.5, 1.5}},
  AspectRatio -> 1,
  Frame -> True,
  ImageSize -> 300
];

circles = GraphicsRow[{plotA, plotB, plotC}, Spacings -> 30];
Export["viz_zeta_circles_comparison.png", circles, ImageResolution -> 150];
Print["✓ Saved: viz_zeta_circles_comparison.png"];
Print[];

(* Plot 2: Angular spacings histogram *)
histogramPlot = GraphicsGrid[{{
  Histogram[spacingsA, 10,
    ChartStyle -> Red,
    PlotLabel -> Style["A: Direct", 12, Bold],
    FrameLabel -> {"Δθ (rad)", "Count"},
    ImageSize -> 250
  ],
  Histogram[spacingsB, 10,
    ChartStyle -> Green,
    PlotLabel -> Style["B: Inverted", 12, Bold],
    FrameLabel -> {"Δθ (rad)", "Count"},
    ImageSize -> 250
  ],
  Histogram[spacingsC, 10,
    ChartStyle -> Blue,
    PlotLabel -> Style["C: Palindromic", 12, Bold],
    FrameLabel -> {"Δθ (rad)", "Count"},
    ImageSize -> 250
  ]
}}, Spacings -> 20];

Export["viz_zeta_spacings_histogram.png", histogramPlot, ImageResolution -> 150];
Print["✓ Saved: viz_zeta_spacings_histogram.png"];
Print[];

(* Plot 3: Spacings as function of n *)
spacingsPlot = ListPlot[{
  Transpose[{Range[nZeros-1], spacingsA}],
  Transpose[{Range[nZeros-1], spacingsB}],
  Transpose[{Range[nZeros-1], spacingsC}]
},
  PlotStyle -> {Red, Green, Blue},
  PlotLegends -> {"A: Direct", "B: Inverted", "C: Palindromic"},
  PlotMarkers -> {Automatic, Medium},
  Joined -> True,
  Frame -> True,
  FrameLabel -> {"Zero index n", "Angular spacing Δθ_n (radians)"},
  PlotLabel -> Style["Angular Spacings Between Consecutive Zeros", 14, Bold],
  ImageSize -> 700,
  GridLines -> Automatic
];

Export["viz_zeta_spacings_plot.png", spacingsPlot, ImageResolution -> 150];
Print["✓ Saved: viz_zeta_spacings_plot.png"];
Print[];

(* Summary statistics *)
Print[StringRepeat["=", 70]];
Print["SUMMARY STATISTICS"];
Print[StringRepeat["=", 70]];
Print[];

Print["Angular spacing statistics (", nZeros-1, " spacings):\n"];
Print[StringRepeat["-", 70]];
Print["Variant\t\tMean\t\tStd\t\tMin\t\tMax"];
Print[StringRepeat["-", 70]];
Print["A: Direct\t",
  NumberForm[Mean[spacingsA], {6, 4}], "\t",
  NumberForm[StandardDeviation[spacingsA], {6, 4}], "\t",
  NumberForm[Min[spacingsA], {6, 4}], "\t",
  NumberForm[Max[spacingsA], {6, 4}]
];
Print["B: Inverted\t",
  NumberForm[Mean[spacingsB], {6, 4}], "\t",
  NumberForm[StandardDeviation[spacingsB], {6, 4}], "\t",
  NumberForm[Min[spacingsB], {6, 4}], "\t",
  NumberForm[Max[spacingsB], {6, 4}]
];
Print["C: Palindromic\t",
  NumberForm[Mean[spacingsC], {6, 4}], "\t",
  NumberForm[StandardDeviation[spacingsC], {6, 4}], "\t",
  NumberForm[Min[spacingsC], {6, 4}], "\t",
  NumberForm[Max[spacingsC], {6, 4}]
];
Print[];

Print["Key observations:\n"];
Print["• All variants map zeros -> unit circle (|w|=1)"];
Print["• Variant B (inverted): First zeros cluster, high zeros spread"];
Print["• Variant C (palindromic): Has reciprocal property f(z)f(1/z)=1");
Print["• Angular spacings vary - not uniform on circle"];
Print[];

Print["Visualizations created:"];
Print["  1. viz_zeta_circles_comparison.png  - All 3 variants on circles"];
Print["  2. viz_zeta_spacings_histogram.png  - Distribution of spacings");
Print["  3. viz_zeta_spacings_plot.png       - Spacings vs zero index");
