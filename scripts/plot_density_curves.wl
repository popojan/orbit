#!/usr/bin/env wolframscript

(* Plot density curves for comparison *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];

Print["=== PLOTTING DENSITY CURVES ==="];
Print[""];

(* Generate data *)
nmax = 100000;
checkpoints = Range[100, nmax, 500];  (* Every 500 *)

Print["Computing densities at ", Length[checkpoints], " checkpoints..."];

primes = Select[Range[2, nmax], PrimeQ];
semiprimes = Select[Range[4, nmax], PrimeOmega[#] == 2 &];
almostPrimes3 = Select[Range[8, nmax], PrimeOmega[#] == 3 &];
almostPrimes4 = Select[Range[16, nmax], PrimeOmega[#] == 4 &];

Print["  Primes: ", Length[primes]];
Print["  Semiprimes: ", Length[semiprimes]];
Print["  3-almost: ", Length[almostPrimes3]];
Print["  4-almost: ", Length[almostPrimes4]];
Print[""];

ComputeDensityCurve[seq_] := Table[
  {n, N[Count[seq, x_ /; x <= n] / n]},
  {n, checkpoints}
]

Print["Computing curves..."];
curvePrimes = ComputeDensityCurve[primes];
curveSemi = ComputeDensityCurve[semiprimes];
curveAlmost3 = ComputeDensityCurve[almostPrimes3];
curveAlmost4 = ComputeDensityCurve[almostPrimes4];

Print["Creating plot..."];

plot = ListPlot[
  {curvePrimes, curveSemi, curveAlmost3, curveAlmost4},
  PlotStyle -> {
    Directive[Thick, Blue],
    Directive[Thick, Red],
    Directive[Thick, Green],
    Directive[Thick, Orange]
  },
  PlotLegends -> {"Primes", "Semiprimes", "3-almost", "4-almost"},
  Frame -> True,
  FrameLabel -> {"n", "Density (count ≤ n / n)"},
  PlotLabel -> Style["Density Curves: k-almost Primes vs Primes", 16, Bold],
  ImageSize -> 1000,
  GridLines -> Automatic
];

Export["reports/density_comparison.png", plot];
Print["✓ Exported reports/density_comparison.png"];

(* Log scale version *)
plotLog = ListLogPlot[
  {curvePrimes, curveSemi, curveAlmost3, curveAlmost4},
  PlotStyle -> {
    Directive[Thick, Blue],
    Directive[Thick, Red],
    Directive[Thick, Green],
    Directive[Thick, Orange]
  },
  PlotLegends -> {"Primes", "Semiprimes", "3-almost", "4-almost"},
  Frame -> True,
  FrameLabel -> {"n (log scale)", "Density"},
  PlotLabel -> Style["Density Curves (Log Scale)", 16, Bold],
  ImageSize -> 1000,
  GridLines -> Automatic
];

Export["reports/density_comparison_log.png", plotLog];
Print["✓ Exported reports/density_comparison_log.png"];

(* Summary statistics *)
Print[""];
Print["=== FINAL DENSITIES (at n=100,000) ==="];
Print[""];
Print["Primes:       ", curvePrimes[[-1, 2]]];
Print["Semiprimes:   ", curveSemi[[-1, 2]]];
Print["3-almost:     ", curveAlmost3[[-1, 2]]];
Print["4-almost:     ", curveAlmost4[[-1, 2]]];
Print[""];
Print["Theoretical expectations:"];
Print["  Primes: ~1/ln(100000) = ", N[1/Log[100000]]];
Print["  k-almost: roughly constant fractions");

Print[""];
Print["=== COMPLETE ===");
