(* Prime Interference — Average density over full segment y in [-(x-1), x-1] *)
(* This captures the complete factorization signature at each x position. *)
(*
   At x = n, cross-family intersection points lie at (n, i-j) for n = ij.
   All such points satisfy |i-j| <= n-1, so they fall within [-(n-1), n-1].
   Primes have NO interior intersections -> higher average density.
   Composites have extra intersections -> lower average density.
*)

smoothstepVal[d_, w_] := Module[{t = Min[d/w, 1.0]}, t*t*(3.0 - 2.0*t)];

interferencePoint[px_, py_, nLines_, lw_] :=
Module[{dist = 1.0, fi, norm, dPos, dNeg, t},
  Do[
    fi = N[i];
    norm = Sqrt[1.0 + fi*fi];
    dPos = Abs[px + fi*py - fi*fi] / norm;
    dNeg = Abs[fi*py - px + fi*fi] / norm;
    t = Min[dPos/lw, 1.0]; dist *= t*t*(3.0 - 2.0*t);
    t = Min[dNeg/lw, 1.0]; dist *= t*t*(3.0 - 2.0*t);,
    {i, 1, nLines}
  ];
  dist
];

(* Average density over segment y in [-(x-1), x-1] at integer x = n *)
(* nLines adaptive: need i up to ~n to cover all lines crossing the segment *)
(* ySamples: number of sample points along the vertical segment *)
segmentDensity[n_Integer, ySamples_Integer : 200, lw_ : 0.2] :=
Module[{yMax, ys, nLines, vals},
  yMax = N[n - 1];
  If[yMax <= 0, Return[1.0]];
  nLines = n + 2;  (* all lines that cross the segment, plus margin *)
  ys = Subdivide[-yMax, yMax, ySamples - 1];
  vals = Table[interferencePoint[N[n], y, nLines, lw], {y, ys}];
  Mean[vals]
];

basePath = "docs/sessions/2026-02-19-prime-interference-moire/figures/";
nMax = 150;

Print["Computing average segment density for n = 2..", nMax, "..."];
Print["  (adaptive nLines, 200 y-samples per point)"];

densities = Table[
  If[Mod[n, 25] == 0, Print["  n = ", n, "..."]];
  {n, segmentDensity[n, 200, 0.2]},
  {n, 2, nMax}
];
Print["  Done."];

(* Separate primes and composites *)
primeData = Select[densities, PrimeQ[#[[1]]] &];
compData = Select[densities, !PrimeQ[#[[1]]] &];

Print[];
Print["Statistics:"];
Print["  Mean density at PRIMES:     ", Mean[primeData[[All, 2]]] // N];
Print["  Mean density at COMPOSITES: ", Mean[compData[[All, 2]]] // N];
Print[];

(* Show some values *)
Print["Sample values (n, density, prime?):"];
Do[
  With[{d = densities[[n - 1]]},
    Print["  ", d[[1]],
      If[PrimeQ[d[[1]]], " (P)", "    "],
      " -> ", NumberForm[d[[2]], 5]]
  ],
  {n, 2, 40}
];

(* Main plot: density vs n, primes highlighted *)
Print[];
Print["Exporting plots..."];

mainPlot = Show[
  ListPlot[{primeData, compData},
    PlotStyle -> {{Red, PointSize[0.008]}, {Blue, PointSize[0.005]}},
    PlotLegends -> {"Primes", "Composites"},
    PlotRange -> All,
    PlotLabel -> "Average interference density over y \[Element] [-(n-1), n-1]",
    FrameLabel -> {"n", "Mean density (1 = far from lines, 0 = on lines)"},
    Frame -> True, ImageSize -> 900],
  (* Add connecting line for full signal *)
  ListLinePlot[densities, PlotStyle -> {Gray, Thin}]
];
Export[basePath <> "segment_density.png", mainPlot];
Print["  segment_density.png"];

(* Power spectrum of the density signal *)
vals = densities[[All, 2]];
ft = Fourier[vals - Mean[vals]];
power = Abs[ft[[1 ;; Floor[Length[vals]/2]]]]^2;
freqs = N[Range[0, Floor[Length[vals]/2] - 1]] / Length[vals];

specPlot = ListLogPlot[Transpose[{freqs, power}],
  PlotRange -> All, Joined -> True,
  FrameLabel -> {"Spatial frequency", "Power"},
  PlotLabel -> "FFT of segment density signal (n = 2.." <> ToString[nMax] <> ")",
  Frame -> True, ImageSize -> 800];
Export[basePath <> "segment_spectrum.png", specPlot];
Print["  segment_spectrum.png"];

(* Density difference: prime - nearest composite *)
(* Shows how "distinguishable" each prime is *)
Print[];
Print["Density at specific primes vs neighboring composites:"];
Do[
  With[{
    pd = densities[[p - 1, 2]],
    ld = If[p > 2, densities[[p - 2, 2]], Null],
    rd = densities[[p, 2]]},
    Print["  ", p-1, " (", NumberForm[ld, 4], ") | ",
      p, " P (", NumberForm[pd, 4], ") | ",
      p+1, " (", NumberForm[rd, 4], ")"]
  ],
  {p, Select[Range[2, Min[nMax - 1, 60]], PrimeQ]}
];

Print[];
Print["All outputs in: ", basePath];
