#!/usr/bin/env wolframscript
(* Test different Cayley scaling factors *)

Print["Testing scaled Cayley transformations...\n"];

(* Step 1: s -> z (same as before) *)
expMap[s_] := Exp[Pi*I*(s - 1/2)];

(* Step 2: Various Cayley variants *)
cayleyStandard[z_] := (z - 1)/(z + 1);
cayleyScaled[z_, alpha_] := (alpha*z - 1)/(alpha*z + 1);

(* Compute first 30 zeros *)
nZeros = 30;
zetaZeros = Table[ZetaZero[n], {n, 1, nZeros}];
zerosExpMap = expMap /@ zetaZeros;

(* Apply different transformations *)
zerosStandard = cayleyStandard /@ zerosExpMap;
zerosAlpha001 = cayleyScaled[#, 1/100]& /@ zerosExpMap;
zerosAlpha100 = cayleyScaled[#, 100]& /@ zerosExpMap;

Print["First 5 zeros with standard Cayley w = (z-1)/(z+1):"];
Do[
  Print["  w_", i, " = ", N[zerosStandard[[i]], 8]];
, {i, 1, 5}];
Print[];

Print["First 5 zeros with α=1/100: w = (z/100-1)/(z/100+1):"];
Do[
  Print["  w_", i, " = ", N[zerosAlpha001[[i]], 8]];
, {i, 1, 5}];
Print[];

Print["First 5 zeros with α=100: w = (100z-1)/(100z+1):"];
Do[
  Print["  w_", i, " = ", N[zerosAlpha100[[i]], 8]];
, {i, 1, 5}];
Print[];

(* Statistics *)
Print["=== MODULI STATISTICS ===\n"];

Print["Standard Cayley:"];
moduliStd = Abs /@ zerosStandard;
Print["  Min |w|: ", N[Min[moduliStd], 8]];
Print["  Max |w|: ", N[Max[moduliStd], 8]];
Print["  All ≈ 1? ", If[Max[moduliStd] - Min[moduliStd] < 0.01, "YES (clustered)", "NO (spread)"]];
Print[];

Print["α = 1/100:"];
moduli001 = Abs /@ zerosAlpha001;
Print["  Min |w|: ", N[Min[moduli001], 8]];
Print["  Max |w|: ", N[Max[moduli001], 8]];
Print["  All ≈ 1? ", If[Max[moduli001] - Min[moduli001] < 0.01, "YES (clustered)", "NO (spread)"]];
Print[];

Print["α = 100:"];
moduli100 = Abs /@ zerosAlpha100;
Print["  Min |w|: ", N[Min[moduli100], 8]];
Print["  Max |w|: ", N[Max[moduli100], 8]];
Print["  All ≈ 1? ", If[Max[moduli100] - Min[moduli100] < 0.01, "YES (clustered)", "NO (spread)"]];
Print[];

(* Visualization *)
Print["Creating visualization...\n"];

plotStd = Graphics[{
  {Gray, Dashed, Circle[{0, 0}, 1]},
  {LightGray, Line[{{-1.2, 0}, {1.2, 0}}], Line[{{0, -1.2}, {0, 1.2}}]},
  {Blue, PointSize[0.02], Point[{Re[#], Im[#]}& /@ N[zerosStandard]]},
  Text[Style["Standard\nw=(z-1)/(z+1)", Bold, 12], {0, -1.1}]
},
  PlotRange -> {{-1.3, 1.3}, {-1.3, 1.3}},
  AspectRatio -> 1,
  Frame -> True,
  ImageSize -> 400
];

plot001 = Graphics[{
  {Gray, Dashed, Circle[{0, 0}, 1]},
  {LightGray, Line[{{-1.2, 0}, {1.2, 0}}], Line[{{0, -1.2}, {0, 1.2}}]},
  {Red, PointSize[0.02], Point[{Re[#], Im[#]}& /@ N[zerosAlpha001]]},
  Text[Style["α = 1/100\nw=(z/100-1)/(z/100+1)", Bold, 12], {0, -1.1}]
},
  PlotRange -> {{-1.3, 1.3}, {-1.3, 1.3}},
  AspectRatio -> 1,
  Frame -> True,
  ImageSize -> 400
];

plot100 = Graphics[{
  {Gray, Dashed, Circle[{0, 0}, 1]},
  {LightGray, Line[{{-1.2, 0}, {1.2, 0}}], Line[{{0, -1.2}, {0, 1.2}}]},
  {Green, PointSize[0.02], Point[{Re[#], Im[#]}& /@ N[zerosAlpha100]]},
  Text[Style["α = 100\nw=(100z-1)/(100z+1)", Bold, 12], {0, -1.1}]
},
  PlotRange -> {{-1.3, 1.3}, {-1.3, 1.3}},
  AspectRatio -> 1,
  Frame -> True,
  ImageSize -> 400
];

combined = GraphicsGrid[{{plotStd, plot001, plot100}},
  ImageSize -> 1200,
  PlotLabel -> Style["Cayley Transform with Different Scaling", Bold, 16]
];

Export["viz_scaled_cayley.png", combined];
Print["Exported: viz_scaled_cayley.png"];

Print["\nDONE!"];
