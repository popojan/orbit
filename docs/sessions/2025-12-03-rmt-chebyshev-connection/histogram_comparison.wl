(* Compare full histogram shape: Chebyshev+noise vs GOE vs Poisson *)

(* Jacobi matrix for Chebyshev *)
jacobiChebyshev[n_] := SparseArray[{
  Band[{1, 2}] -> Table[1/2, {k, 1, n - 1}],
  Band[{2, 1}] -> Table[1/2, {k, 1, n - 1}]
}, {n, n}];

(* Wigner surmise PDFs *)
pGOE[s_] := (Pi/2) s Exp[-Pi s^2/4];
pGUE[s_] := (32/Pi^2) s^2 Exp[-4 s^2/Pi];
pPoisson[s_] := Exp[-s];

(* Generate spacings from Chebyshev Jacobi + noise *)
nSize = 50;
eps = 0.1;
nTrials = 500;

allSpacings = {};
Do[
  noise = RandomVariate[NormalDistribution[], {nSize, nSize}];
  noise = (noise + Transpose[noise])/2;
  mat = N[jacobiChebyshev[nSize]] + eps * noise;
  eigs = Sort[Eigenvalues[mat]];
  spacings = Differences[eigs];
  meanS = Mean[spacings];
  normalized = spacings / meanS;
  allSpacings = Join[allSpacings, normalized],
  {nTrials}
];

Print["Generated ", Length[allSpacings], " spacings from Chebyshev+noise"];

(* Also generate pure GOE spacings for comparison *)
goeSpacings = {};
Do[
  goeMatrix = RandomVariate[NormalDistribution[], {nSize, nSize}];
  goeMatrix = (goeMatrix + Transpose[goeMatrix])/(2 Sqrt[2 nSize]);
  eigs = Sort[Eigenvalues[goeMatrix]];
  spacings = Differences[eigs];
  meanS = Mean[spacings];
  normalized = spacings / meanS;
  goeSpacings = Join[goeSpacings, normalized],
  {nTrials}
];

Print["Generated ", Length[goeSpacings], " spacings from pure GOE"];

(* Create histograms *)
bins = {0, 3, 0.1};

(* Overlay plot *)
combined = Show[
  Histogram[allSpacings, bins, "PDF",
    PlotLabel -> "Spacing Distribution Comparison",
    ChartStyle -> Directive[Blue, Opacity[0.4]],
    ChartLegends -> {"Chebyshev+noise"}
  ],
  Histogram[goeSpacings, bins, "PDF",
    ChartStyle -> Directive[Green, Opacity[0.3]],
    ChartLegends -> {"Pure GOE (numerical)"}
  ],
  Plot[{pGOE[s], pPoisson[s]}, {s, 0, 3},
    PlotStyle -> {{Red, Thick, Dashed}, {Black, Dashed}},
    PlotLegends -> {"GOE (Wigner)", "Poisson"}
  ],
  PlotRange -> {{0, 3}, {0, 1.2}},
  AxesLabel -> {"s", "P(s)"}
];

Export["histogram_comparison.png", combined, ImageSize -> 700];
Print["Exported histogram_comparison.png"];

(* Quantitative comparison: KS test or bin-by-bin *)
Print["\n═══════════════════════════════════════════════════════════════"];
Print["BIN-BY-BIN COMPARISON"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["Bin\t\tCheby+noise\tGOE(num)\tGOE(theory)\tPoisson"];
Do[
  low = b;
  high = b + 0.2;
  chebyCount = Count[allSpacings, _?(low <= # < high &)] / Length[allSpacings];
  goeNumCount = Count[goeSpacings, _?(low <= # < high &)] / Length[goeSpacings];
  goeTheory = NIntegrate[pGOE[s], {s, low, high}];
  poissonTheory = NIntegrate[pPoisson[s], {s, low, high}];
  Print[low, "-", high, "\t\t",
    NumberForm[chebyCount, {3, 3}], "\t\t",
    NumberForm[goeNumCount, {3, 3}], "\t\t",
    NumberForm[goeTheory, {3, 3}], "\t\t",
    NumberForm[poissonTheory, {3, 3}]
  ],
  {b, 0, 2.8, 0.2}
];

(* Chi-square test *)
Print["\n═══════════════════════════════════════════════════════════════"];
Print["GOODNESS OF FIT"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* Chi-square vs GOE *)
chiSqGOE = Sum[
  Module[{low = b, high = b + 0.2, obs, exp},
    obs = Count[allSpacings, _?(low <= # < high &)] / Length[allSpacings];
    exp = NIntegrate[pGOE[s], {s, low, high}];
    If[exp > 0.001, (obs - exp)^2 / exp, 0]
  ],
  {b, 0, 2.8, 0.2}
];

chiSqPoisson = Sum[
  Module[{low = b, high = b + 0.2, obs, exp},
    obs = Count[allSpacings, _?(low <= # < high &)] / Length[allSpacings];
    exp = NIntegrate[pPoisson[s], {s, low, high}];
    If[exp > 0.001, (obs - exp)^2 / exp, 0]
  ],
  {b, 0, 2.8, 0.2}
];

Print["Chi-square (Chebyshev+noise vs GOE theory): ", chiSqGOE];
Print["Chi-square (Chebyshev+noise vs Poisson):    ", chiSqPoisson];
Print[""];
Print["Lower chi-square = better fit"];
Print["If chi-sq << 1, excellent match"];
Print["If chi-sq >> 1, poor match"];

