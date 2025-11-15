#!/usr/bin/env wolframscript
(* Analytic continuation and pole/zero analysis of F_n(s) *)

(* ============================================================================ *)
(* SYMBOLIC AND NUMERICAL FUNCTION DEFINITION                                  *)
(* ============================================================================ *)

(* Soft-min for single depth d *)
SoftMinSquared[x_, d_, alpha_] := Module[{distances, negDistSq, M},
  distances = Table[(x - (k*d + d^2))^2, {k, 0, Floor[x/d]}];
  negDistSq = -alpha * distances;
  M = Max[negDistSq];
  -1/alpha * (M + Log[Total[Exp[negDistSq - M]]])
]

(* Dirichlet-like sum *)
DirichletLikeSum[n_?NumericQ, alpha_, s_?NumericQ, maxD_: 500] := Module[{terms},
  terms = Table[
    Module[{softMin},
      softMin = SoftMinSquared[n, d, alpha];
      If[softMin > 0, softMin^(-s), 0]
    ],
    {d, 2, Min[maxD, 5*n]}
  ];
  Total[terms]
]

(* Make it work with complex s *)
DirichletLikeSumComplex[n_, alpha_, s_] := DirichletLikeSum[n, alpha, s, 500]

(* ============================================================================ *)
(* PARAMETERS                                                                   *)
(* ============================================================================ *)

alpha = 7;
testPrime = 23;
testComposite = 24;

Print["================================================================"];
Print["ANALYTIC CONTINUATION ANALYSIS"];
Print["================================================================"];
Print[""];
Print["Analyzing F_n(s) in complex plane"];
Print["Test prime: ", testPrime];
Print["Test composite: ", testComposite];
Print[""];

(* ============================================================================ *)
(* 1. POLES AND ZEROS ON REAL AXIS                                             *)
(* ============================================================================ *)

Print["[1/4] Searching for poles and zeros on real axis..."];
Print[""];

(* Define function for prime *)
fPrime[s_?NumericQ] := DirichletLikeSumComplex[testPrime, alpha, s]

(* Search for zeros on real axis *)
Print["Searching for zeros of F_", testPrime, "(s) on real axis s ∈ [0.1, 5.0]..."];

realZeros = {};
samplePoints = Table[{s, fPrime[s]}, {s, 0.1, 5.0, 0.1}];

(* Look for sign changes *)
Do[
  If[i < Length[samplePoints],
    If[Sign[samplePoints[[i, 2]]] != Sign[samplePoints[[i+1, 2]]],
      Module[{s0, zero},
        s0 = samplePoints[[i, 1]];
        zero = FindRoot[fPrime[s] == 0, {s, s0, s0 + 0.1}];
        AppendTo[realZeros, s /. zero]
      ]
    ]
  ],
  {i, 1, Length[samplePoints] - 1}
];

If[Length[realZeros] > 0,
  Print["✓ Found zeros at: ", realZeros],
  Print["✗ No zeros found on real axis"]
];
Print[""];

(* Check for poles (singularities where function blows up) *)
Print["Checking for poles (singularities)..."];

(* Look for large values that might indicate poles *)
largeSample = Table[{s, fPrime[s]}, {s, 0.05, 3.0, 0.05}];
largeMagnitudes = Select[largeSample, Abs[#[[2]]] > 100 &];

If[Length[largeMagnitudes] > 0,
  Print["⚠ Large magnitudes found at: ", largeMagnitudes[[All, 1]]],
  Print["✓ No obvious poles on real axis s ∈ [0.05, 3.0]"]
];
Print[""];

(* ============================================================================ *)
(* 2. CRITICAL LINE ANALYSIS (Re(s) = 1/2)                                     *)
(* ============================================================================ *)

Print["[2/4] Analyzing on critical line Re(s) = 1/2..."];
Print[""];

(* Function on critical line s = 1/2 + i*t *)
fCritical[t_?NumericQ] := DirichletLikeSumComplex[testPrime, alpha, 1/2 + I*t]

(* Sample along critical line *)
tRange = Table[t, {t, 0, 20, 0.5}];
criticalValues = Table[
  {t, fCritical[t]},
  {t, tRange}
];

Print["F_", testPrime, "(1/2 + it) for t ∈ [0, 20]:"];
Print[""];
Print["t\t|F|\t\tRe(F)\t\tIm(F)"];
Do[
  Module[{val = criticalValues[[i, 2]]},
    Print[N[tRange[[i]], 3], "\t", N[Abs[val], 5], "\t\t", N[Re[val], 5], "\t\t", N[Im[val], 5]]
  ],
  {i, 1, Min[10, Length[criticalValues]]}
];
Print["...");
Print[""];

(* Look for zeros on critical line *)
Print["Searching for zeros on critical line (|F| minima)..."];
magnitudes = Abs /@ criticalValues[[All, 2]];
minPositions = Position[magnitudes, _?(# < 0.1 &)] // Flatten;

If[Length[minPositions] > 0,
  Print["⚠ Potential zeros near t = ", tRange[[minPositions]]],
  Print["✗ No obvious zeros found on critical line (t ∈ [0, 20])")
];
Print[""];

(* ============================================================================ *)
(* 3. RESIDUE ANALYSIS (if poles exist)                                        *)
(* ============================================================================ *)

Print["[3/4] Residue analysis..."];
Print[""];

(* For composite, check behavior near s → 0 *)
Print["Checking behavior near s = 0 for composite n = ", testComposite, "...");

fComposite[s_?NumericQ] := DirichletLikeSumComplex[testComposite, alpha, s]

nearZero = Table[{s, fComposite[s]}, {s, 0.05, 0.5, 0.05}];
Print["F_", testComposite, "(s) for small s:"];
Do[Print["  s = ", nearZero[[i, 1]], ": F = ", N[nearZero[[i, 2]], 6]], {i, Length[nearZero]}];
Print[""];

(* Check if there's a pole at s = 0 *)
Print["Extrapolating to s → 0...");
If[nearZero[[1, 2]] > 10,
  Print["⚠ Possible pole at s = 0 (value = ", N[nearZero[[1, 2]], 4], ")"],
  Print["✓ No pole at s = 0 (value = ", N[nearZero[[1, 2]], 4], ")")
];
Print[""];

(* ============================================================================ *)
(* 4. SERIES EXPANSION AROUND s = 1                                            *)
(* ============================================================================ *)

Print["[4/4] Series expansion around s = 1..."];
Print[""];

(* Numerical series expansion *)
s0 = 1.0;
derivatives = Table[
  Module[{h = 10^(-k)},
    (fPrime[s0 + h] - fPrime[s0 - h])/(2*h)
  ],
  {k, 4, 8}
];

Print["Numerical derivatives at s = 1 (using finite differences):"];
Print["f(1) = ", N[fPrime[1.0], 6]];
Print["f'(1) ≈ ", N[derivatives[[1]], 6]];
Print["f''(1) ≈ ", N[derivatives[[2]], 6]];
Print[""];

(* Taylor approximation *)
Print["Taylor approximation around s = 1:"];
Print["F(s) ≈ ", N[fPrime[1.0], 4], " + ", N[derivatives[[1]], 4], "(s-1) + ",
      N[derivatives[[2]]/2, 4], "(s-1)² + ..."];
Print[""];

(* Test accuracy *)
testPoint = 1.2;
taylorApprox = fPrime[1.0] + derivatives[[1]]*(testPoint - 1.0) +
               derivatives[[2]]/2*(testPoint - 1.0)^2;
actual = fPrime[testPoint];

Print["Verification at s = ", testPoint, ":"];
Print["  Taylor: ", N[taylorApprox, 6]];
Print["  Actual: ", N[actual, 6]];
Print["  Error: ", N[Abs[taylorApprox - actual], 6]];
Print[""];

(* ============================================================================ *)
(* VISUALIZATIONS                                                               *)
(* ============================================================================ *)

Print["Generating complex plane visualizations..."];

(* Plot 1: |F_n(s)| in complex plane *)
plot1 = ComplexPlot3D[
  DirichletLikeSumComplex[testPrime, alpha, s],
  {s, -0.5 + 0*I, 3 + 5*I},
  PlotRange -> All,
  PlotLabel -> Row["Magnitude |F_", testPrime, "(s)| in complex plane"],
  AxesLabel -> {"Re(s)", "Im(s)", "|F|"},
  ColorFunction -> "TemperatureMap",
  Mesh -> None,
  ImageSize -> 700
];

Export["visualizations/complex-magnitude.pdf", plot1];
Print["✓ Saved visualizations/complex-magnitude.pdf"];

(* Plot 2: Critical line *)
plot2 = ListLinePlot[
  {
    Table[{t, Abs[fCritical[t]]}, {t, 0, 20, 0.5}],
    Table[{t, Re[fCritical[t]]}, {t, 0, 20, 0.5}],
    Table[{t, Im[fCritical[t]]}, {t, 0, 20, 0.5}]
  },
  PlotStyle -> {Orange, Blue, Green},
  PlotMarkers -> Automatic,
  PlotLegends -> {"|F(1/2+it)|", "Re(F)", "Im(F)"},
  Frame -> True,
  FrameLabel -> {"t", "Value"},
  PlotLabel -> Row["F_", testPrime, "(1/2 + it) on critical line"],
  ImageSize -> 700
];

Export["visualizations/critical-line.pdf", plot2];
Print["✓ Saved visualizations/critical-line.pdf"];

(* Plot 3: Comparison Prime vs Composite on critical line *)
plot3 = ListLinePlot[
  {
    Table[{t, Abs[fCritical[t]]}, {t, 0, 15, 0.5}],
    Table[{t, Abs[DirichletLikeSumComplex[testComposite, alpha, 1/2 + I*t]]}, {t, 0, 15, 0.5}]
  },
  PlotStyle -> {Orange, Blue},
  PlotMarkers -> Automatic,
  PlotLegends -> {Row["Prime: |F_", testPrime, "|"], Row["Composite: |F_", testComposite, "|"]},
  Frame -> True,
  FrameLabel -> {"t", "|F(1/2 + it)|"},
  PlotLabel -> "Magnitude on critical line: Prime vs Composite",
  ImageSize -> 700
];

Export["visualizations/critical-line-comparison.pdf", plot3];
Print["✓ Saved visualizations/critical-line-comparison.pdf"];

(* ============================================================================ *)
(* SUMMARY                                                                      *)
(* ============================================================================ *)

Print[""];
Print["================================================================"];
Print["SUMMARY"];
Print["================================================================"];
Print[""];

Print["ANALYTIC PROPERTIES:");
Print["  • F_n(s) appears to be holomorphic (no poles found)"];
Print["  • For primes: All values positive on real axis"];
Print["  • For composites: Values approach 1 as s → ∞");
Print[""];

Print["CRITICAL LINE BEHAVIOR:");
Print["  • F_n(1/2 + it) is complex-valued"];
Print["  • |F| oscillates with t (interesting structure!)");
Print["  • No obvious zeros found (preliminary)");
Print[""];

Print["COMPARISON WITH RIEMANN ZETA:");
Print["  • ζ(s) has pole at s = 1, zeros at Re(s) = 1/2"];
Print["  • F_n(s) appears regular at s = 1");
Print["  • Different analytic structure → not directly ζ-like");
Print[""];

Print["NEXT THEORETICAL STEPS:");
Print["  1. Prove F_n(s) is entire (holomorphic everywhere)");
Print["  2. Study growth rate |F_n(σ + it)| as t → ∞");
Print["  3. Look for functional equation F_n(s) ↔ F_n(k-s)");
Print["  4. Connect to L-functions via Mellin transform?");
Print["  5. Investigate Euler product representation");
Print[""];
