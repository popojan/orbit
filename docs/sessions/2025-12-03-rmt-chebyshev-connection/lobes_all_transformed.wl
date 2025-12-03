(* Visualize ALL lobes (positive and negative) with radial transformation *)

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
k = 7;  (* Higher k = more lobes *)
c = 1;
p = 4;

(* All lobes: region between polynomial curve and x-axis *)
(* Condition: y and subnrefu[x,k] have same sign, |y| <= |subnrefu[x,k]| *)
allLobesRegion = ImplicitRegion[
  x^2 + y^2 <= 1 &&
  y * subnrefu[x, k] >= 0 &&
  Abs[y] <= Abs[subnrefu[x, k]],
  {x, y}
];

(* Transformed region *)
transformedAllLobes = TransformedRegion[allLobesRegion, radialTransform[c, p]];

(* Deformed boundary curve *)
deformedBoundary = ParametricPlot[
  (1 + c Abs[Cos[t]]^p) {Cos[t], Sin[t]},
  {t, 0, 2 Pi},
  PlotStyle -> {Black, Thick}
];

(* Original circle *)
circleBoundary = ParametricPlot[
  {Cos[t], Sin[t]},
  {t, 0, 2 Pi},
  PlotStyle -> {Black, Thick}
];

(* Plot original *)
originalPlot = Show[
  RegionPlot[allLobesRegion,
    PlotStyle -> Directive[Blue, Opacity[0.5]],
    BoundaryStyle -> Directive[Blue, Thick],
    PlotRange -> {{-1.5, 1.5}, {-1.5, 1.5}},
    AspectRatio -> Automatic
  ],
  circleBoundary,
  PlotLabel -> "Original (circle, k=" <> ToString[k] <> ")"
];

(* Plot transformed *)
transformedPlot = Show[
  RegionPlot[transformedAllLobes,
    PlotStyle -> Directive[Red, Opacity[0.5]],
    BoundaryStyle -> Directive[Red, Thick],
    PlotRange -> {{-2, 2}, {-2, 2}},
    AspectRatio -> Automatic
  ],
  deformedBoundary,
  PlotLabel -> "Transformed (p=" <> ToString[p] <> ", c=" <> ToString[c] <> ")"
];

(* Combined *)
combined = GraphicsRow[{originalPlot, transformedPlot}, ImageSize -> 900];

Export["lobes_all_transformed.png", combined];

(* Compute areas *)
originalArea = RegionMeasure[allLobesRegion];
transformedArea = RegionMeasure[transformedAllLobes];

Print["Original all lobes area: ", N[originalArea, 4]];
Print["Transformed all lobes area: ", N[transformedArea, 4]];
Print["Ratio: ", N[transformedArea/originalArea, 4]];

"Done"
