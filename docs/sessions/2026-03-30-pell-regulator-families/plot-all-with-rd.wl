(* plot-all-with-rd.wl — Plot all 100k regulators with R-D families highlighted
 *
 * Usage: wolframscript -file plot-all-with-rd.wl
 *)

reg = Flatten@Import["~/github/zzz/build/reg100k.csv", "Data"];
Print["Loaded ", Length@reg, " entries"];

(* Distance to nearest even square above *)
even[n_] := Module[{m = Ceiling[Sqrt[n]]}, If[OddQ[m], m - 1, m]];
dist[n_] := n - even[n]^2;

(* R-D condition: n = m^2 + d where d | 4m *)
isRD[n_] := Module[{m = even[n], d},
  d = n - m^2;
  d != 0 && Mod[4 m, Abs[d]] == 0
];

(* Classify every non-square n *)
nonsq = Select[Range[2, Length@reg], reg[[#]] > 0 &];
rd = Select[nonsq, isRD];
nonrd = Complement[nonsq, rd];

Print[Length@rd, " R-D type (", Round[100. Length@rd / Length@nonsq], "%)"];
Print[Length@nonrd, " non-R-D (", Round[100. Length@nonrd / Length@nonsq], "%)"];

(* Build plot data *)
rdPts = {#, reg[[#]]} & /@ rd;
nonrdPts = {#, reg[[#]]} & /@ nonrd;

(* For the R-D points, color by |d| *)
rdByD = GroupBy[rd, Abs[dist[#]] &];
colors = <|1 -> Red, 2 -> Blue, 4 -> Darker@Green,
  8 -> Orange, 16 -> Purple|>;

rdPlots = KeyValueMap[
  Function[{absD, ns},
    ListPlot[{#, reg[[#]]} & /@ ns,
      PlotStyle -> Directive[Lookup[colors, absD, Gray], PointSize[Small]],
      PlotLegends -> {"|d|=" <> ToString[absD]}
    ]
  ],
  KeySort@Select[rdByD, MemberQ[{1, 2, 4, 8, 16}, Key@#] &]
];

(* Background: all non-R-D points in light gray *)
bgPlot = ListPlot[nonrdPts,
  PlotStyle -> Directive[GrayLevel[0.8], PointSize[Tiny]],
  PlotLegends -> {"non-R-D"}
];

(* Combined plot *)
full = Show[bgPlot, Sequence @@ rdPlots,
  PlotRange -> All,
  AxesLabel -> {"n", "R"},
  PlotLabel -> "Pell regulators: R-D families (colored) vs rest (gray)",
  ImageSize -> 1200
];

Export["~/github/orbit/docs/sessions/2026-03-30-pell-regulator-families/all-regulators-rd.png",
  full, "PNG", ImageResolution -> 150];
Print["Saved all-regulators-rd.png"];

(* Also a zoomed version for n < 5000 *)
zoomed = Show[bgPlot, Sequence @@ rdPlots,
  PlotRange -> {{0, 5000}, All},
  AxesLabel -> {"n", "R"},
  PlotLabel -> "Pell regulators n<5000: R-D families highlighted",
  ImageSize -> 1200
];

Export["~/github/orbit/docs/sessions/2026-03-30-pell-regulator-families/regulators-zoom-5k.png",
  zoomed, "PNG", ImageResolution -> 150];
Print["Saved regulators-zoom-5k.png"];

(* Stats: what fraction of the "easy" (small R) values are R-D? *)
Print["\n=== R-D coverage by regulator size ==="];
Do[
  small = Select[nonsq, reg[[#]] < threshold &];
  rdSmall = Select[small, isRD];
  Print["  R < ", threshold, ": ", Length@rdSmall, "/", Length@small,
    " = ", Round[100. Length@rdSmall / Max[Length@small, 1]], "% are R-D"],
{threshold, {10, 20, 50, 100, 500, 1000}}];

(* Stats: R-D by distance *)
Print["\n=== R-D entries by |d| ==="];
Do[
  cnt = Length@Lookup[rdByD, absD, {}];
  Print["  |d|=", absD, ": ", cnt, " entries"],
{absD, Sort@Keys@rdByD}];
