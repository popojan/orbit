(* Search for deformations that achieve GUE-like statistics *)

getXProjections[deformFunc_, nPoints_: 1000] := Module[{angles, points},
  angles = Range[0, 2 Pi - 2 Pi/nPoints, 2 Pi/nPoints];
  points = Table[deformFunc[t] {Cos[t], Sin[t]}, {t, angles}];
  Sort[First /@ points]
];

spacingStats[xVals_] := Module[{sorted, spacings, mean, normalized},
  sorted = Sort[xVals];
  spacings = Differences[sorted];
  mean = Mean[spacings];
  normalized = spacings / mean;
  N[Count[normalized, _?(# < 0.2 &)] / Length[normalized]]
];

nPoints = 1000;

Print["═══════════════════════════════════════════════════════════════"];
Print["EXTENSIVE SEARCH: Find deformation → GUE-like P(s<0.2) ≈ 0.03"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* Power law with wider parameter range *)
Print["─── Power Law: r = 1 + c|cos θ|^p (wider range) ───"];
results = {};
Table[
  xVals = getXProjections[Function[t, 1 + c Abs[Cos[t]]^p], nPoints];
  ps = spacingStats[xVals];
  AppendTo[results, {c, p, ps}];
  If[ps < 0.2, Print["*** c=", c, ", p=", p, ": P(s<0.2) = ", ps, " ***"]],
  {c, {0.5, 1, 2, 3, 5, 10}}, {p, {1, 2, 4, 8, 16}}
];
Print["Best power law: ", First[SortBy[results, Last]]];
Print[""];

(* What if we SHRINK at poles instead of expand? *)
Print["─── Inverted: r = 1 - c|cos θ|^p (shrink at poles) ───"];
results2 = {};
Table[
  If[c < 1,  (* must keep r > 0 *)
    xVals = getXProjections[Function[t, 1 - c Abs[Cos[t]]^p], nPoints];
    ps = spacingStats[xVals];
    AppendTo[results2, {c, p, ps}];
    If[ps < 0.2, Print["*** c=", c, ", p=", p, ": P(s<0.2) = ", ps, " ***"]]
  ],
  {c, {0.1, 0.3, 0.5, 0.7, 0.9}}, {p, {1, 2, 4, 8}}
];
If[Length[results2] > 0, Print["Best inverted: ", First[SortBy[results2, Last]]]];
Print[""];

(* Extreme deformations *)
Print["─── Extreme power law c=10,20,50 ───"];
Table[
  xVals = getXProjections[Function[t, 1 + c Abs[Cos[t]]^p], nPoints];
  ps = spacingStats[xVals];
  Print["c=", c, ", p=", p, ": P(s<0.2) = ", ps],
  {c, {10, 20, 50}}, {p, {4, 8}}
];
Print[""];

(* What's the theoretical minimum achievable? *)
Print["═══════════════════════════════════════════════════════════════"];
Print["THEORETICAL CHECK: What distribution gives P(s<0.2) ≈ 0.03?"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* Uniform spacing (all equal) would give P(s<0.2) = 0 *)
uniformX = Range[-1, 1, 2/(nPoints-1)];
Print["Uniform spacing: P(s<0.2) = ", spacingStats[uniformX]];

(* Semi-circle (Wigner) distribution *)
(* For semicircle: ρ(x) = (2/π)√(1-x²), CDF = (1/2) + (x√(1-x²) + arcsin(x))/π *)
semiCircleCDF[x_] := (1/2) + (x Sqrt[1 - x^2] + ArcSin[x])/Pi;
semiCircleX = Table[x /. FindRoot[semiCircleCDF[x] == k/nPoints, {x, 0}], {k, 1, nPoints - 1}];
Print["Semicircle (Wigner) distribution: P(s<0.2) = ", spacingStats[semiCircleX]];

