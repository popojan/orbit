(* Fast visualization of ALL lobes using sampled points and filling *)

subnrefu[x_, k_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x];

(* Radial transformation *)
radialTransform[c_, p_][{x_, y_}] := Module[{r, theta, rNew},
  r = Sqrt[x^2 + y^2];
  If[r == 0, Return[{0, 0}]];
  theta = ArcTan[x, y];
  rNew = r (1 + c Abs[Cos[theta]]^p);
  {rNew Cos[theta], rNew Sin[theta]}
];

(* Parameters *)
k = 7;
c = 1;
p = 4;

(* Sample the polynomial curve - both positive and negative y *)
xVals = Range[-1, 1, 0.01];
polyPoints = Table[{x, subnrefu[x, k]}, {x, xVals}];

(* Transform polynomial curve *)
transformedPolyPoints = radialTransform[c, p] /@ polyPoints;

(* Circle and deformed boundary *)
tVals = Range[0, 2 Pi, 0.01];
circlePoints = Table[{Cos[t], Sin[t]}, {t, tVals}];
deformedPoints = Table[(1 + c Abs[Cos[t]]^p) {Cos[t], Sin[t]}, {t, tVals}];

(* X-axis for filling reference *)
xAxisPoints = Table[{x, 0}, {x, xVals}];
transformedXAxis = radialTransform[c, p] /@ xAxisPoints;

(* Create filling regions - positive and negative lobes *)
originalPlot = Show[
  (* Fill between polynomial and x-axis *)
  ListLinePlot[{polyPoints, xAxisPoints},
    Filling -> {1 -> {2}},
    FillingStyle -> Directive[Blue, Opacity[0.4]],
    PlotStyle -> {Blue, None}
  ],
  (* Circle boundary *)
  ListLinePlot[circlePoints, PlotStyle -> {Black, Thick}],
  (* Polynomial curve *)
  ListLinePlot[polyPoints, PlotStyle -> {Blue, Thick}],
  PlotRange -> {{-1.5, 1.5}, {-1.2, 1.2}},
  AspectRatio -> Automatic,
  PlotLabel -> Style["Original (circle, k=7)", 14],
  Axes -> True
];

transformedPlot = Show[
  (* Fill between transformed polynomial and transformed x-axis *)
  ListLinePlot[{transformedPolyPoints, transformedXAxis},
    Filling -> {1 -> {2}},
    FillingStyle -> Directive[Red, Opacity[0.4]],
    PlotStyle -> {Red, None}
  ],
  (* Deformed boundary *)
  ListLinePlot[deformedPoints, PlotStyle -> {Black, Thick}],
  (* Transformed polynomial curve *)
  ListLinePlot[transformedPolyPoints, PlotStyle -> {Red, Thick}],
  PlotRange -> {{-2.2, 2.2}, {-2, 2}},
  AspectRatio -> Automatic,
  PlotLabel -> Style["Transformed (p=4, c=1)", 14],
  Axes -> True
];

combined = GraphicsRow[{originalPlot, transformedPlot}, ImageSize -> 1000];

Export["lobes_all_fast.png", combined];
Print["Exported lobes_all_fast.png"];

"Done"
