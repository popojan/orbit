(* ::Package:: *)
(* Prime Interference — Wolfram Language port of prime_interference.glsl *)
(*
   Two families of lines for i = 1, 2, 3, ...:
     Positive: y = i - x/i   (slope -1/i)
     Negative: y = -i + x/i  (slope +1/i)

   Cross-family intersections at (i*j, i-j) encode factorizations.
   Primes p have intersections only at y = ±(p-1) (boundary).

   Distance from (px, py) to line i:
     Positive family: |px + i·py - i²| / √(1 + i²)
     Negative family: |i·py - px + i²| / √(1 + i²)
*)

(* --- Core compiled kernel ------------------------------------------------ *)

primeInterferenceKernel = Compile[
  {{px, _Real}, {py, _Real}, {nLines, _Integer}, {lineWidth, _Real}},
  Module[{dist = 1.0, dPos, dNeg, norm, fi, t},
    Do[
      fi = N[i];
      norm = Sqrt[1.0 + fi*fi];
      (* Positive family: y = i - x/i *)
      dPos = Abs[px + fi*py - fi*fi] / norm;
      (* Negative family: y = -i + x/i *)
      dNeg = Abs[fi*py - px + fi*fi] / norm;
      (* Smoothstep: 0 on line, 1 far away *)
      t = Min[dPos/lineWidth, 1.0];
      dist *= t*t*(3.0 - 2.0*t);
      t = Min[dNeg/lineWidth, 1.0];
      dist *= t*t*(3.0 - 2.0*t);,
      {i, 1, nLines}
    ];
    dist
  ],
  CompilationTarget -> "C",
  RuntimeOptions -> "Speed"
];

(* --- Rendering function -------------------------------------------------- *)

Options[RenderPrimeInterference] = {
  "Resolution" -> {800, 600},
  "LineWidth" -> 0.2,         (* smoothstep edge width in math coords *)
  "ColorMap" -> (GrayLevel[1 - #] &)  (* white lines on black *)
};

RenderPrimeInterference[xRange : {x0_?NumericQ, x1_?NumericQ},
                         yRange : {y0_?NumericQ, y1_?NumericQ},
                         OptionsPattern[]] :=
Module[{res, lw, nLines, xs, ys, data},
  res = OptionValue["Resolution"];
  lw = OptionValue["LineWidth"];
  (* Need enough lines to cover the vertical extent *)
  nLines = Ceiling[Max[Abs[y0], Abs[y1]]] + 5;

  xs = Subdivide[N[x0], N[x1], res[[1]] - 1];
  ys = Subdivide[N[y0], N[y1], res[[2]] - 1];

  data = ParallelTable[
    primeInterferenceKernel[x, y, nLines, lw],
    {y, Reverse[ys]},  (* top of image = positive y *)
    {x, xs}
  ];

  Image[data, ColorSpace -> "Grayscale"]
];

(* Convenience: render by "zoom level" matching the shader's time parameter *)
RenderPrimeInterference[zoom_?NumericQ, opts : OptionsPattern[]] :=
Module[{scale, res, xMax, yMax},
  res = OptionValue[RenderPrimeInterference, {opts}, "Resolution"];
  scale = 10.0 / Sqrt[1.0 + zoom];
  xMax = res[[1]] / scale;
  yMax = res[[2]] / (2.0 * scale);
  RenderPrimeInterference[{0, xMax}, {-yMax, yMax}, opts]
];

(* --- Analysis functions -------------------------------------------------- *)

(* Extract 1D intensity profile along y = ySlice *)
IntensityProfile[xRange : {x0_?NumericQ, x1_?NumericQ},
                 ySlice_?NumericQ,
                 nPoints_Integer : 2000,
                 nLines_Integer : 50,
                 lineWidth_ : 0.2] :=
Module[{xs},
  xs = Subdivide[N[x0], N[x1], nPoints - 1];
  Table[
    {x, primeInterferenceKernel[x, N[ySlice], nLines, lineWidth]},
    {x, xs}
  ]
];

(* Highlight primes on an intensity profile *)
AnnotatePrimes[profile_List, maxPrime_Integer : 100] :=
Module[{primes, xVals},
  xVals = profile[[All, 1]];
  primes = Select[Prime[Range[PrimePi[maxPrime]]],
                  # >= Min[xVals] && # <= Max[xVals] &];
  Show[
    ListLinePlot[profile, PlotRange -> All,
      PlotLabel -> "Intensity along y = 0",
      FrameLabel -> {"x (natural number)", "dist (0 = on line)"},
      Frame -> True],
    Graphics[{Red, Dashed,
      Table[InfiniteLine[{p, 0}, {0, 1}], {p, primes}]}],
    Graphics[{Red,
      Table[Text[Style[p, 8], {p, -0.05}], {p, primes}]}]
  ]
];

(* Power spectrum of intensity profile *)
IntensitySpectrum[profile_List] :=
Module[{vals, n, ft, freqs, power},
  vals = profile[[All, 2]];
  n = Length[vals];
  ft = Fourier[vals - Mean[vals]];  (* remove DC *)
  power = Abs[ft[[1 ;; Floor[n/2]]]]^2;
  freqs = Range[0, Floor[n/2] - 1] / n;
  Transpose[{freqs, power}]
];

(* --- Quick demo ---------------------------------------------------------- *)

(*
  (* Render at zoom=0 (initial view, x up to ~80) *)
  img = RenderPrimeInterference[0]

  (* Render a specific x-range centered on y=0 *)
  img = RenderPrimeInterference[{0, 100}, {-50, 50}]

  (* Extract intensity along y=0 and annotate primes *)
  profile = IntensityProfile[{0, 100}, 0.0, 2000, 50];
  AnnotatePrimes[profile, 100]

  (* Power spectrum *)
  spec = IntensitySpectrum[profile];
  ListLogPlot[spec, PlotRange -> All, Joined -> True,
    FrameLabel -> {"Spatial frequency", "Power"},
    PlotLabel -> "FFT of intensity along y = 0"]

  (* Animate zoom-out *)
  Manipulate[
    RenderPrimeInterference[zoom, "Resolution" -> {400, 300}],
    {zoom, 0, 200, 1}
  ]
*)

(* --- Notes on GPU acceleration ------------------------------------------- *)
(*
  Wolfram has NO native GLSL support, but two paths for GPU:

  1. OpenCLFunction (cross-platform):
     kernel = OpenCLFunctionLoad[openCLSource, "main", args, blockSize];
     The OpenCL C syntax is close enough to GLSL that porting is mechanical.

  2. CUDAFunction (NVIDIA only):
     kernel = CUDAFunctionLoad[cudaSource, "main", args, blockSize];

  For this shader, the pure Wolfram Compile["C"] version should handle
  resolutions up to ~1000x1000 in seconds. GPU would matter for:
  - Real-time interaction (Manipulate at high res)
  - Very high resolution renders for spectral analysis
  - Parameter sweeps (many zoom levels)

  The GLSL original can also be run on shadertoy.com for interactive use.
*)
