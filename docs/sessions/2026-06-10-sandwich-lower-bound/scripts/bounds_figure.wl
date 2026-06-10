(* Illustrative figure: proven sandwich bounds vs conjectural envelope
   vs exact C(p/q) data.
   Proven:      g(a) = 1/2 - 2^-a  (lower),
                L(a) = (1 - Exp[-4a(a-1)/(a+1)^2])/2  (lower, Lundberg),
                U(a) = (1 - rho0^(a+2))/2  (upper, coupling).
   Conjectural: Csm(a) = 1 - rho0(a)  (upper, smooth envelope).
   Data:        exact C(p/q), coprime q <= 9, 1 < p/q <= 4. *)

prec = 30;

cExact[p_, q_] := Module[{rise, poly, roots, sub, amps, mat, cs, s0, j0},
  rise = Table[Floor[p (j + 1)/q] - Floor[p j/q], {j, 0, q - 1}];
  poly = Expand[(2 t - 1)^q - t^(p + q)];
  roots = t /. NSolve[poly == 0, t, WorkingPrecision -> prec];
  sub = Select[roots, Abs[#] < 1 - 10^-8 &];
  amps = Table[Product[(2 ti - 1)/ti^(rise[[m + 1]] + 1), {m, 0, j - 1}],
    {ti, sub}, {j, 0, q - 1}];
  mat = Table[amps[[i, j + 1]]/sub[[i]], {j, 0, q - 1}, {i, q}];
  cs = LinearSolve[mat, Table[1, {q}]];
  s0 = Floor[p/q]; j0 = Mod[1, q];
  Re[Chop[(1 - Sum[cs[[i]] amps[[i, j0 + 1]] sub[[i]]^s0, {i, q}])/2,
    10^-15]]]

rho0N[alpha_?NumericQ] := rho /. FindRoot[rho^(alpha + 1) - 2 rho + 1,
  {rho, 0.7, 0.5 + 10^-9, 1 - 10^-9}, WorkingPrecision -> 25]

gLow[a_] := 1/2 - 2^-a
lLow[a_?NumericQ] := (1 - Exp[-4 a (a - 1)/(a + 1)^2])/2
uUp[a_?NumericQ] := (1 - rho0N[a]^(a + 2))/2
cSm[a_?NumericQ] := 1 - rho0N[a]

Print["computing exact C data..."];
data = Reap[Do[Do[
  If[GCD[p, q] == 1 && p/q > 1 && p/q <= 4,
    Sow[{N[p/q], cExact[p, q]}]],
  {p, q + 1, 4 q}], {q, 1, 9}]][[2, 1]];
Print["  ", Length[data], " slopes"];

intData = Select[data, Abs[#[[1]] - Round[#[[1]]]] < 10^-9 &];

fig = Show[
  Plot[{gLow[a], lLow[a], uUp[a], cSm[a]}, {a, 1, 4},
    PlotRange -> {{1, 4.05}, {0, 0.52}},
    PlotStyle -> {
      Directive[Darker[Green, 0.3], Thickness[0.004]],
      Directive[Darker[Green, 0.3], Thickness[0.004], Dashed],
      Directive[Darker[Red, 0.25], Thickness[0.004]],
      Directive[Darker[Red, 0.25], Thickness[0.004], Dashed]},
    Frame -> True,
    FrameLabel -> {"slope \[Alpha]", "C(\[Alpha])"},
    GridLines -> {Range[1, 4, 0.5], Range[0, 0.5, 0.1]},
    GridLinesStyle -> GrayLevel[0.88],
    PlotPoints -> 120,
    ImageSize -> 640],
  Graphics[{GrayLevel[0.5], Dashing[{0.005, 0.005}],
    Line[{{1, 0.5}, {4.05, 0.5}}]}],
  ListPlot[data, PlotStyle -> Directive[Blue, PointSize[0.005]]],
  ListPlot[intData, PlotStyle -> Directive[Blue, PointSize[0.012]]],
  Graphics[{
    Text[Style["U (proven upper)", Darker[Red, 0.25], 11], {2.1, 0.475}],
    Text[Style["\!\(\*SubscriptBox[\(C\), \(smooth\)]\) (conjectured)",
      Darker[Red, 0.25], 11], {3.25, 0.435}],
    Text[Style["exact C(p/q)", Blue, 11], {2.85, 0.387}],
    Text[Style["L (proven lower)", Darker[Green, 0.3], 11], {3.0, 0.345}],
    Text[Style["1/2 - \!\(\*SuperscriptBox[\(2\), \(-\[Alpha]\)]\) \
(proven lower)", Darker[Green, 0.3], 11], {3.3, 0.245}]}]
];

SetDirectory[DirectoryName[$InputFileName]];
figDir = FileNameJoin[{ParentDirectory[], "figures"}];
If[!DirectoryQ[figDir], CreateDirectory[figDir]];
Export[FileNameJoin[{figDir, "sandwich-bounds.pdf"}], fig];
Export[FileNameJoin[{figDir, "sandwich-bounds.png"}], fig,
  ImageResolution -> 160];
Print["exported to ", figDir];
Print["===== DONE ====="];
