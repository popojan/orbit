(* Closed-form spacing distributions *)

Print["═══════════════════════════════════════════════════════════════"];
Print["SPACING DISTRIBUTIONS - Closed Form PDFs"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* Wigner surmise for different symmetry classes *)
(* GOE (β=1): P(s) = (π/2) s exp(-πs²/4) *)
pGOE[s_] := (Pi/2) s Exp[-Pi s^2/4];

(* GUE (β=2): P(s) = (32/π²) s² exp(-4s²/π) *)
pGUE[s_] := (32/Pi^2) s^2 Exp[-4 s^2/Pi];

(* GSE (β=4): P(s) = (2^18/(3^6 π³)) s^4 exp(-64s²/(9π)) *)
pGSE[s_] := (2^18/(3^6 Pi^3)) s^4 Exp[-64 s^2/(9 Pi)];

(* Poisson (uncorrelated): P(s) = exp(-s) *)
pPoisson[s_] := Exp[-s];

(* Verify normalization *)
Print["Normalization check (should be 1):"];
Print["  GOE: ", N[Integrate[pGOE[s], {s, 0, Infinity}]]];
Print["  GUE: ", N[Integrate[pGUE[s], {s, 0, Infinity}]]];
Print["  GSE: ", N[Integrate[pGSE[s], {s, 0, Infinity}]]];
Print["  Poisson: ", N[Integrate[pPoisson[s], {s, 0, Infinity}]]];

Print["\n═══════════════════════════════════════════════════════════════"];
Print["P(s < threshold) - Analytical"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* CDFs *)
cdfGOE[x_] := Integrate[pGOE[s], {s, 0, x}];
cdfGUE[x_] := Integrate[pGUE[s], {s, 0, x}];
cdfGSE[x_] := Integrate[pGSE[s], {s, 0, x}];
cdfPoisson[x_] := 1 - Exp[-x];

Print["P(s < 0.2):"];
Print["  GOE:     ", N[cdfGOE[0.2], 6]];
Print["  GUE:     ", N[cdfGUE[0.2], 6]];
Print["  GSE:     ", N[cdfGSE[0.2], 6]];
Print["  Poisson: ", N[cdfPoisson[0.2], 6]];

Print["\nP(s < 0.5):"];
Print["  GOE:     ", N[cdfGOE[0.5], 6]];
Print["  GUE:     ", N[cdfGUE[0.5], 6]];
Print["  GSE:     ", N[cdfGSE[0.5], 6]];
Print["  Poisson: ", N[cdfPoisson[0.5], 6]];

Print["\n═══════════════════════════════════════════════════════════════"];
Print["Small-s behavior (level repulsion)"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["Near s=0:"];
Print["  GOE:  P(s) ~ s^1  (linear repulsion, β=1)"];
Print["  GUE:  P(s) ~ s^2  (quadratic repulsion, β=2)"];
Print["  GSE:  P(s) ~ s^4  (quartic repulsion, β=4)"];
Print["  Poisson: P(s) ~ 1 (no repulsion)"];

Print["\nGeneral formula: P(s) ~ s^β for small s"];
Print["β = Dyson index (1=orthogonal, 2=unitary, 4=symplectic)"];

(* Plot all distributions *)
plot = Plot[{pPoisson[s], pGOE[s], pGUE[s], pGSE[s]}, {s, 0, 3},
  PlotStyle -> {Black, Blue, Red, Orange},
  PlotLegends -> {"Poisson", "GOE (β=1)", "GUE (β=2)", "GSE (β=4)"},
  AxesLabel -> {"s", "P(s)"},
  PlotLabel -> "Nearest-neighbor spacing distributions",
  PlotRange -> {0, 1.2}
];

Export["spacing_distributions.png", plot, ImageSize -> 600];
Print["\nExported spacing_distributions.png"];

