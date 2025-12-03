(* What ARE GUE spacing statistics? *)

Print["═══════════════════════════════════════════════════════════════"];
Print["GUE SPACING STATISTICS - Wigner Surmise"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* GUE local spacing follows Wigner surmise: P(s) = (32/π²) s² exp(-4s²/π) *)
wignerGUE[s_] := (32/Pi^2) s^2 Exp[-4 s^2/Pi];

(* For comparison: Poisson (uncorrelated) P(s) = exp(-s) *)
poisson[s_] := Exp[-s];

(* Arcsine-derived spacing (what we get from circle projection) *)
(* This is more complex... *)

Print["Wigner surmise for GUE: P(s) = (32/π²) s² exp(-4s²/π)"];
Print[""];
Print["P(s < 0.2) for GUE = ", N[NIntegrate[wignerGUE[s], {s, 0, 0.2}]]];
Print["P(s < 0.5) for GUE = ", N[NIntegrate[wignerGUE[s], {s, 0, 0.5}]]];
Print[""];
Print["P(s < 0.2) for Poisson = ", N[NIntegrate[poisson[s], {s, 0, 0.2}]]];
Print["P(s < 0.5) for Poisson = ", N[NIntegrate[poisson[s], {s, 0, 0.5}]]];

Print["\n═══════════════════════════════════════════════════════════════"];
Print["KEY INSIGHT: GUE repulsion vs smooth distributions"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["GUE has LEVEL REPULSION: P(s) ~ s² near s=0"];
Print["This comes from CORRELATIONS between eigenvalues (matrix structure)"];
Print["NOT from any smooth probability distribution!"];
Print[""];
Print["Smooth distributions (semicircle, uniform, arcsine) → no repulsion"];
Print["Random matrix eigenvalues → correlated → repulsion"];

Print["\n═══════════════════════════════════════════════════════════════"];
Print["GENERATE ACTUAL GUE MATRICES"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* Generate GUE matrix and compute spacing statistics *)
gueMatrix[n_] := Module[{m},
  m = RandomVariate[NormalDistribution[], {n, n}] + 
      I RandomVariate[NormalDistribution[], {n, n}];
  (m + ConjugateTranspose[m])/(2 Sqrt[2 n])
];

(* Generate many GUE samples and collect spacings *)
nMatrix = 100;
matSize = 50;
allSpacings = {};

Do[
  eigs = Sort[Re[Eigenvalues[gueMatrix[matSize]]]];
  (* Unfold: normalize to local mean spacing = 1 *)
  spacings = Differences[eigs];
  meanSpacing = Mean[spacings];
  normalized = spacings / meanSpacing;
  allSpacings = Join[allSpacings, normalized],
  {nMatrix}
];

Print["Generated ", nMatrix, " GUE matrices of size ", matSize];
Print["Total spacings collected: ", Length[allSpacings]];
Print[""];
Print["Empirical GUE: P(s<0.2) = ", N[Count[allSpacings, _?(# < 0.2 &)] / Length[allSpacings]]];
Print["Empirical GUE: P(s<0.5) = ", N[Count[allSpacings, _?(# < 0.5 &)] / Length[allSpacings]]];
Print["Theoretical:   P(s<0.2) = ", N[NIntegrate[wignerGUE[s], {s, 0, 0.2}]]];

