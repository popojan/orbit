(* Prime Interference — Analysis Script *)
(* Run: wolframscript -file docs/sessions/2026-02-19-prime-interference-moire/run_analysis.wl *)

smoothstepVal[d_, w_] := Module[{t = Min[d/w, 1.0]}, t*t*(3.0 - 2.0*t)];

interferencePoint[px_, py_, nLines_, lw_] :=
Module[{dist = 1.0, fi, norm, dPos, dNeg},
  Do[
    fi = N[i];
    norm = Sqrt[1.0 + fi*fi];
    dPos = Abs[px + fi*py - fi*fi] / norm;
    dNeg = Abs[fi*py - px + fi*fi] / norm;
    dist *= smoothstepVal[dPos, lw];
    dist *= smoothstepVal[dNeg, lw];,
    {i, 1, nLines}
  ];
  dist
];

basePath = "docs/sessions/2026-02-19-prime-interference-moire/figures/";

Print["Computing intensity profile along y=0, x in [1, 60]..."];
profile = Table[
  {x, interferencePoint[x, 0.0, 30, 0.3]},
  {x, 1.0, 60.0, 0.06}
];
Print["  Profile length: ", Length[profile]];

(* Prime vs composite statistics *)
nearestVal[n_] := Module[{idx},
  idx = First[Nearest[profile[[All, 1]] -> "Index", N[n]]];
  profile[[idx, 2]]
];
primes = Select[Range[2, 59], PrimeQ];
composites = Select[Range[4, 59], !PrimeQ[#] &];
Print["  Mean dist at PRIMES:     ", Mean[nearestVal /@ primes] // N];
Print["  Mean dist at COMPOSITES: ", Mean[nearestVal /@ composites] // N];
Print[];

(* Individual values *)
Print["Individual values at integers 2-30:"];
Do[
  Print["  ", n, If[PrimeQ[n], " (P)", "    "], " -> dist = ",
    NumberForm[nearestVal[n] // N, 4]],
  {n, 2, 30}
];
Print[];

(* Export intensity plot with prime markers *)
Print["Exporting intensity plot..."];
plt = Show[
  ListLinePlot[profile, PlotRange -> All,
    PlotLabel -> "Intensity along y = 0 (white = near line, black = far)",
    FrameLabel -> {"x (natural number)", "dist (0 = on line, 1 = far)"},
    Frame -> True, ImageSize -> 800],
  Graphics[{Red, Dashed,
    Table[InfiniteLine[{p, 0}, {0, 1}], {p, primes}]}],
  Graphics[{Red,
    Table[Text[Style[p, 7], {p, -0.04}], {p, primes}]}]
];
Export[basePath <> "intensity_y0.png", plt];
Print["  Done."];

(* Power spectrum *)
Print["Computing power spectrum..."];
vals = profile[[All, 2]];
ft = Fourier[vals - Mean[vals]];
power = Abs[ft[[1 ;; Floor[Length[vals]/2]]]]^2;
freqs = N[Range[0, Floor[Length[vals]/2] - 1]] / Length[vals];
specPlot = ListLogPlot[Transpose[{freqs, power}],
  PlotRange -> All, Joined -> True,
  FrameLabel -> {"Spatial frequency", "Power"},
  PlotLabel -> "FFT of intensity along y = 0 (x = 1..60)",
  Frame -> True, ImageSize -> 800];
Export[basePath <> "spectrum_y0.png", specPlot];
Print["  Done."];

(* Render small image *)
Print["Rendering 200x100 image (x: 0-50, y: -25..25)..."];
img = Table[
  interferencePoint[x, y, 25, 0.3],
  {y, 25.0, -25.0, -0.5},
  {x, 0.0, 50.0, 0.25}
];
Export[basePath <> "test_render.png",
  Image[img, ColorSpace -> "Grayscale"]];
Print["  Done."];

Print[];
Print["All outputs in: ", basePath];
