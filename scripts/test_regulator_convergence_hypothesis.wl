#!/usr/bin/env wolframscript
(* Test regulator hypothesis: convergence rate ∝ R(d) *)

Print["Testing Regulator-Convergence Hypothesis"];
Print["============================================\n"];

(* Load Orbit paclet *)
<< Orbit`

(* Choose diverse test cases with varying regulators *)
testPrimes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 61, 67, 71, 73};

(* Fixed parameters for all tests *)
m1 = 3;
m2 = 3;

Print["Parameters: m1 = ", m1, ", m2 = ", m2, "\n"];

(* Function to compute regulator *)
Regulator[d_] := Module[{sol, x, y},
  sol = PellSolution[d];
  x = x /. sol;
  y = y /. sol;
  N[Log[x + y Sqrt[N[d]]], 20]
]

(* Function to measure precision (negative log10 of squared error) *)
MeasurePrecision[d_, approx_] := Module[{err},
  err = Abs[d - approx^2];
  If[err == 0,
    Infinity,
    -N[Log[10, err], 20]
  ]
]

(* Run tests *)
results = Table[
  Module[{reg, approx, digits, x0, y0, sol},
    (* Compute regulator *)
    reg = Regulator[d];

    (* Get Pell solution for reference *)
    sol = PellSolution[d];
    x0 = x /. sol;
    y0 = y /. sol;

    (* Run nested iteration *)
    approx = NestedChebyshevSqrt[d, {m1, m2}];

    (* Measure precision *)
    digits = MeasurePrecision[d, approx];

    Print["d = ", d, ": R = ", reg, ", digits = ", digits,
          " (Pell: ", x0, ", ", y0, ")"];

    {d, reg, digits, x0, y0}
  ],
  {d, testPrimes}
];

Print["\n=== Analysis ===\n"];

(* Extract columns *)
regulators = results[[All, 2]];
precisions = results[[All, 3]];

(* Linear regression: digits = a + b * R(d) *)
fit = Fit[Transpose[{regulators, precisions}], {1, x}, x];

Print["Linear fit: digits = ", fit];

(* Compute correlation *)
correlation = Correlation[regulators, precisions];
Print["Correlation R(d) vs digits: r = ", N[correlation, 4]];

(* Plot *)
plot = ListPlot[
  Transpose[{regulators, precisions}],
  AxesLabel -> {"Regulator R(d)", "Digits achieved"},
  PlotLabel -> StringForm["Nested Chebyshev (m1=``, m2=``): Precision vs Regulator", m1, m2],
  PlotMarkers -> Automatic,
  GridLines -> Automatic,
  Epilog -> {Red, Dashed,
    Line[{{Min[regulators], fit /. x -> Min[regulators]},
          {Max[regulators], fit /. x -> Max[regulators]}}]}
];

Export["/home/user/orbit/scripts/regulator_convergence_plot.png", plot, ImageResolution -> 200];

Print["\nPlot saved to: scripts/regulator_convergence_plot.png"];

(* Test alternative hypothesis: digits ∝ log(x0) or log(y0) *)
logX0 = Log[10, results[[All, 4]] // N];
logY0 = Log[10, results[[All, 5]] // N];

corrLogX = Correlation[logX0, precisions];
corrLogY = Correlation[logY0, precisions];

Print["\nAlternative correlations:"];
Print["  log10(x0) vs digits: r = ", N[corrLogX, 4]];
Print["  log10(y0) vs digits: r = ", N[corrLogY, 4]];

(* Since R(d) ≈ log(x0) for large x0, these should be similar *)
Print["\nNote: R(d) ≈ log(x0 + y0√d) ≈ log(x0) + log(1 + (y0/x0)√d)"];
Print["      For large x0/y0 → √d, this ≈ log(x0) + constant"];

(* Summary table *)
Print["\n=== Summary Table ===\n"];
Print[StringForm["{:<8} {:<12} {:<12} {:<12}", "d", "R(d)", "digits", "digits/R"]];
Print[StringPadRight["", 50, "-"]];

Do[
  Print[StringForm["{:<8} {:<12} {:<12} {:<12}",
    results[[i, 1]],
    NumberForm[results[[i, 2]], {6, 2}],
    NumberForm[results[[i, 3]], {6, 1}],
    NumberForm[results[[i, 3]] / results[[i, 2]], {6, 2}]
  ]],
  {i, Length[results]}
];

(* Check if ratio digits/R is roughly constant *)
ratios = precisions / regulators;
meanRatio = Mean[ratios];
stdRatio = StandardDeviation[ratios];

Print["\ndigits/R ratio: mean = ", N[meanRatio, 4], ", std dev = ", N[stdRatio, 4]];
Print["Coefficient of variation: ", N[stdRatio/meanRatio * 100, 3], "%"];

Print["\n=== CONCLUSION ==="];
If[correlation > 0.95,
  Print["✓ STRONG LINEAR RELATIONSHIP CONFIRMED (r > 0.95)"];
  Print["  Hypothesis: digits ≈ α · R(d) for constant α ≈ ", N[meanRatio, 4]];
  Print["  This could elevate Conjecture to THEOREM!"],
  If[correlation > 0.7,
    Print["✓ MODERATE CORRELATION (r > 0.7)"];
    Print["  R(d) explains significant variance but other factors present"],
    Print["✗ WEAK/NO CORRELATION"];
    Print["  Regulator hypothesis FALSIFIED"]
  ]
];
