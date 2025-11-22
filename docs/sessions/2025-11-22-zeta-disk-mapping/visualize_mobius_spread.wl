#!/usr/bin/env wolframscript
(* Visualize zeta zeros before and after Möbius transformation *)

Print["Computing zeta zeros and transformations...\n"];

(* Original transformation: critical strip -> disk *)
diskMap[s_] := Tanh[Pi*I*(s - 1/2)/2];

(* Möbius automorphism to spread the cluster *)
mobiusSpread[w_] := (w + 1)/(1 - w);

(* Compute first 50 zeros *)
nZeros = 50;
zetaZeros = Table[ZetaZero[n], {n, 1, nZeros}];
zerosInDisk = diskMap /@ zetaZeros;
zerosSpread = mobiusSpread /@ zerosInDisk;

Print["First 10 zeros in original disk:"];
Do[
  Print["  w_", i, " = ", N[zerosInDisk[[i]], 6]];
, {i, 1, Min[10, nZeros]}];
Print[];

Print["First 10 zeros after Möbius spread:"];
Do[
  Print["  w'_", i, " = ", N[zerosSpread[[i]], 6]];
, {i, 1, Min[10, nZeros]}];
Print[];

(* Create visualizations *)
Print["Creating visualizations...\n"];

(* Plot 1: Original clustering near w = -1 *)
plot1 = Graphics[{
  (* Unit circle *)
  {Gray, Dashed, Circle[{0, 0}, 1]},
  (* Real and imaginary axes *)
  {LightGray, Line[{{-1.2, 0}, {1.2, 0}}]},
  {LightGray, Line[{{0, -1.2}, {0, 1.2}}]},
  (* Special points *)
  {Red, PointSize[0.02], Point[{-1, 0}]},
  Text[Style["w = -1\n(cluster)", Red, 10], {-1, -0.15}],
  (* Zeta zeros *)
  {Blue, PointSize[0.015], Point[{Re[#], Im[#]}& /@ N[zerosInDisk]]},
  Text[Style["Zeta zeros\n(clustered)", Blue, 12], {0.5, 0.8}]
},
  PlotRange -> {{-1.3, 1.3}, {-1.3, 1.3}},
  AspectRatio -> 1,
  Frame -> True,
  FrameLabel -> {"Re(w)", "Im(w)"},
  PlotLabel -> Style["Original: Zeros clustered at w = -1", Bold, 14],
  ImageSize -> 500
];

(* Plot 2: After Möbius transformation *)
(* Need to handle points that map outside unit circle *)
spreadPoints = N[zerosSpread];
insideDisk = Select[spreadPoints, Abs[#] < 5 &]; (* Keep only reasonable points *)

plot2 = Graphics[{
  (* Unit circle (for reference, not a boundary anymore) *)
  {Gray, Dashed, Circle[{0, 0}, 1]},
  (* Real and imaginary axes *)
  {LightGray, Line[{{-5, 0}, {5, 0}}]},
  {LightGray, Line[{{0, -5}, {0, 5}}]},
  (* Special points *)
  {Red, PointSize[0.02], Point[{0, 0}]},
  Text[Style["w' = 0\n(was w=-1)", Red, 10], {0.3, -0.3}],
  (* Transformed zeros *)
  {Blue, PointSize[0.015], Point[{Re[#], Im[#]}& /@ insideDisk]},
  Text[Style["Zeros\n(spread out)", Blue, 12], {3, 4}]
},
  PlotRange -> {{-5, 5}, {-5, 5}},
  AspectRatio -> 1,
  Frame -> True,
  FrameLabel -> {"Re(w')", "Im(w')"},
  PlotLabel -> Style["After Möbius: w' = (w+1)/(1-w)", Bold, 14],
  ImageSize -> 500
];

(* Combined plot *)
combined = GraphicsRow[{plot1, plot2}, ImageSize -> 1000,
  PlotLabel -> Style["Möbius Transformation: Spreading the Cluster", Bold, 16]];

(* Export *)
Export["viz_mobius_comparison.png", combined];
Print["Exported: viz_mobius_comparison.png"];

(* Statistics *)
Print["\n=== STATISTICS ===\n"];

originalDistances = Table[Abs[zerosInDisk[[i+1]] - zerosInDisk[[i]]], {i, 1, nZeros-1}];
spreadDistances = Table[Abs[zerosSpread[[i+1]] - zerosSpread[[i]]], {i, 1, nZeros-1}];

Print["Original spacing (Euclidean distance between consecutive zeros):"];
Print["  Min:  ", N[Min[originalDistances], 6]];
Print["  Max:  ", N[Max[originalDistances], 6]];
Print["  Mean: ", N[Mean[originalDistances], 6]];
Print[];

Print["After Möbius (Euclidean distance):"];
Print["  Min:  ", N[Min[spreadDistances], 6]];
Print["  Max:  ", N[Max[spreadDistances], 6]];
Print["  Mean: ", N[Mean[spreadDistances], 6]];
Print[];

Print["Spread ratio (max/min):"];
Print["  Original: ", N[Max[originalDistances]/Min[originalDistances], 3]];
Print["  Möbius:   ", N[Max[spreadDistances]/Min[spreadDistances], 3]];
Print[];

Print["DONE!"];
