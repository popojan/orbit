(* Compare different deformations - is |cos θ|^p special? *)

(* Generate points on deformed curve and project to x-axis *)
getXProjections[deformFunc_, nPoints_: 1000] := Module[{angles, points},
  angles = Range[0, 2 Pi - 2 Pi/nPoints, 2 Pi/nPoints];
  points = Table[deformFunc[t] {Cos[t], Sin[t]}, {t, angles}];
  Sort[First /@ points]
];

(* Compute spacing statistics *)
spacingStats[xVals_] := Module[{sorted, spacings, mean, normalized},
  sorted = Sort[xVals];
  spacings = Differences[sorted];
  mean = Mean[spacings];
  normalized = spacings / mean;
  (* Return P(s < 0.2) - small spacing probability *)
  N[Count[normalized, _?(# < 0.2 &)] / Length[normalized]]
];

(* Different deformation families *)
nPoints = 500;

(* 1. Power law: r = 1 + c |cos θ|^p *)
powerLaw[c_, p_][t_] := 1 + c Abs[Cos[t]]^p;

(* 2. Gaussian bump at poles: r = 1 + c Exp[-((θ - nearest pole)/σ)^2] *)
gaussianPoles[c_, sigma_][t_] := Module[{dist},
  dist = Min[Abs[t], Abs[t - Pi], Abs[t - 2 Pi]];
  1 + c Exp[-(dist/sigma)^2]
];

(* 3. Cosine deformation: r = 1 + c cos(2θ) - ellipse-like *)
cosineDeform[c_][t_] := 1 + c Cos[2 t];

(* 4. Absolute sine: r = 1 + c |sin θ|^p - stretches at equator instead *)
absSine[c_, p_][t_] := 1 + c Abs[Sin[t]]^p;

(* 5. Step function: r = 1 + c if |cos θ| > threshold *)
stepDeform[c_, thresh_][t_] := If[Abs[Cos[t]] > thresh, 1 + c, 1];

Print["═══════════════════════════════════════════════════════════════"];
Print["COMPARISON OF DIFFERENT DEFORMATIONS"];
Print["Target: P(s<0.2) ≈ 0.03 (GUE-like)"];
Print["Baseline circle: P(s<0.2) ≈ 0.40 (arcsine)"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* Baseline - circle *)
circleX = getXProjections[Function[t, 1], nPoints];
Print["Circle (no deformation): P(s<0.2) = ", spacingStats[circleX]];
Print[""];

(* Power law family *)
Print["─── Power Law: r = 1 + c|cos θ|^p ───"];
Table[
  xVals = getXProjections[powerLaw[c, p], nPoints];
  Print["c=", c, ", p=", p, ": P(s<0.2) = ", spacingStats[xVals]],
  {c, {0.5, 1.0, 1.5}}, {p, {2, 4, 6}}
];
Print[""];

(* Gaussian poles *)
Print["─── Gaussian at poles: r = 1 + c·exp(-(dist/σ)²) ───"];
Table[
  xVals = getXProjections[gaussianPoles[c, sigma], nPoints];
  Print["c=", c, ", σ=", sigma, ": P(s<0.2) = ", spacingStats[xVals]],
  {c, {0.5, 1.0}}, {sigma, {0.3, 0.5, 1.0}}
];
Print[""];

(* Cosine - ellipse-like *)
Print["─── Cosine: r = 1 + c·cos(2θ) (ellipse-like) ───"];
Table[
  xVals = getXProjections[cosineDeform[c], nPoints];
  Print["c=", c, ": P(s<0.2) = ", spacingStats[xVals]],
  {c, {0.3, 0.5, 0.7}}
];
Print[""];

(* Absolute sine - wrong direction? *)
Print["─── Abs Sine: r = 1 + c|sin θ|^p (stretches equator) ───"];
Table[
  xVals = getXProjections[absSine[c, p], nPoints];
  Print["c=", c, ", p=", p, ": P(s<0.2) = ", spacingStats[xVals]],
  {c, {0.5, 1.0}}, {p, {2, 4}}
];
Print[""];

(* Step function *)
Print["─── Step: r = 1+c if |cos θ| > threshold ───"];
Table[
  xVals = getXProjections[stepDeform[c, thresh], nPoints];
  Print["c=", c, ", thresh=", thresh, ": P(s<0.2) = ", spacingStats[xVals]],
  {c, {0.5, 1.0}}, {thresh, {0.3, 0.5, 0.7}}
];

Print["\n═══════════════════════════════════════════════════════════════"];
Print["CONCLUSION: Is power law special?"];
Print["═══════════════════════════════════════════════════════════════"];
