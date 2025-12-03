(* B-value spacing statistics - where do they fall? *)

(* B-values using explicit formula *)
beta[n_] := If[OddQ[n], 1/n, 2 Cot[Pi/(2n)]/(n Pi)];
Bvalue[n_, k_] := (1/n) (1 + beta[n] Cos[(2k - 1) Pi/n]);

Print["═══════════════════════════════════════════════════════════════"];
Print["B-VALUE SPACING STATISTICS"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* Collect B-values for various n *)
allBspacings = {};

Do[
  bVals = Table[Bvalue[n, k], {k, 1, n}];
  sorted = Sort[N[bVals]];
  spacings = Differences[sorted];
  If[Length[spacings] > 0,
    meanS = Mean[spacings];
    If[meanS > 0,
      normalized = spacings / meanS;
      allBspacings = Join[allBspacings, normalized]
    ]
  ],
  {n, 3, 200}
];

Print["Collected ", Length[allBspacings], " normalized B-value spacings"];
Print["From n = 3 to n = 200"];
Print[""];

(* Compute P(s < threshold) *)
ps02 = N[Count[allBspacings, _?(# < 0.2 &)] / Length[allBspacings]];
ps05 = N[Count[allBspacings, _?(# < 0.5 &)] / Length[allBspacings]];

Print["B-value spacing statistics:"];
Print["  P(s < 0.2) = ", ps02];
Print["  P(s < 0.5) = ", ps05];
Print[""];

Print["═══════════════════════════════════════════════════════════════"];
Print["COMPARISON WITH RMT"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["           P(s<0.2)    P(s<0.5)"];
Print["Poisson:   0.181       0.393"];
Print["GOE:       0.031       0.178"];
Print["GUE:       0.008       0.112"];
Print["GSE:       0.0007      0.049"];
Print[""];
Print["B-values:  ", ps02, "       ", ps05];

(* Fit effective β *)
(* If P(s) ~ s^β near 0, then P(s<ε) ~ ε^(β+1)/(β+1) for small ε *)
(* P(s<0.2) = 0.031 for GOE (β=1) *)
(* P(s<0.2) = 0.008 for GUE (β=2) *)

Print["\n═══════════════════════════════════════════════════════════════"];
Print["HISTOGRAM of B-value spacings"];
Print["═══════════════════════════════════════════════════════════════"];

(* Create histogram *)
hist = Histogram[allBspacings, {0, 4, 0.1}, "PDF",
  PlotLabel -> "B-value spacing distribution",
  AxesLabel -> {"s", "P(s)"},
  PlotRange -> {{0, 3}, {0, 1.2}}
];

(* Overlay Wigner surmises *)
pGOE[s_] := (Pi/2) s Exp[-Pi s^2/4];
pGUE[s_] := (32/Pi^2) s^2 Exp[-4 s^2/Pi];
pPoisson[s_] := Exp[-s];

combined = Show[hist,
  Plot[{pPoisson[s], pGOE[s], pGUE[s]}, {s, 0, 3},
    PlotStyle -> {{Black, Dashed}, {Blue, Thick}, {Red, Thick}},
    PlotLegends -> {"Poisson", "GOE", "GUE"}
  ]
];

Export["b_spacing_histogram.png", combined, ImageSize -> 700];
Print["\nExported b_spacing_histogram.png"];

