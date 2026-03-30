Get["/home/jan/github/orbit/Orbit/Kernel/PellChebyshevSolve.wl"];

regs = ToExpression /@ ReadList["/home/jan/github/zzz/build/reg100k.csv", String];

Nmax = 10000; (* plot first 10k for clarity *)

easy = {}; hard = {};
Do[
  If[IntegerQ[Sqrt[n0]] || regs[[n0]] == 0, Continue[]];
  R = regs[[n0]];
  res = PellChebyshevSolve[n0];
  If[res =!= $Failed,
    AppendTo[easy, {n0, R}],
    AppendTo[hard, {n0, R}]],
{n0, 2, Nmax}];

Print["Easy: ", Length[easy], "  Hard: ", Length[hard]];

plot = Show[
  ListPlot[{easy, hard},
    PlotStyle -> {
      Directive[Blue, PointSize[Tiny]],
      Directive[Red, PointSize[Tiny]]},
    PlotLegends -> {"Chebyshev O(1)", "HARD (need BSGS)"},
    PlotLabel -> "Pell Regulator R(n): Chebyshev coverage n \[LessEqual] " <> ToString[Nmax],
    AxesLabel -> {"n", "R(n)"},
    Frame -> True,
    ImageSize -> 800,
    PlotRange -> All],
  Plot[Sqrt[x], {x, 2, Nmax}, PlotStyle -> {Gray, Dashed}]
];

Export["/home/jan/github/orbit/docs/sessions/2026-03-30-pell-regulator-families/chebyshev-coverage.png", plot, ImageResolution -> 150];
Print["Plot saved."];
