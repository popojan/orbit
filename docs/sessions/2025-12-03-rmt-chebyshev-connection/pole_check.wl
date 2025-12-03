(* Check pole behavior *)

c = 1;
p = 4;

Print["Deformation: r(θ) = 1 + c|cos θ|^p with c=", c, ", p=", p];
Print[""];
Print["At θ = 0 (right pole):   r = 1 + ", c, "·|1|^", p, " = ", 1 + c];
Print["At θ = π/2 (top):        r = 1 + ", c, "·|0|^", p, " = 1"];
Print["At θ = π (left pole):    r = 1 + ", c, "·|-1|^", p, " = ", 1 + c];
Print[""];
Print["So poles are at x = ±", 1 + c, ", equator at y = ±1"];

(* Plot the deformed curve clearly *)
plot = ParametricPlot[
  (1 + c Abs[Cos[t]]^p) {Cos[t], Sin[t]},
  {t, 0, 2 Pi},
  PlotStyle -> {Red, Thick},
  PlotRange -> {{-2.5, 2.5}, {-1.5, 1.5}},
  AspectRatio -> Automatic,
  GridLines -> {{-2, -1, 0, 1, 2}, {-1, 0, 1}},
  PlotLabel -> "r(θ) = 1 + |cos θ|^4",
  Epilog -> {
    Blue, PointSize[0.02],
    Point[{2, 0}], Text["(2,0) right pole", {2, 0.15}],
    Point[{-2, 0}], Text["(-2,0) left pole", {-2, 0.15}],
    Point[{0, 1}], Text["(0,1) top", {0.3, 1}],
    Point[{0, -1}], Text["(0,-1) bottom", {0.3, -1}]
  }
];

Export["pole_check.png", plot, ImageSize -> 600];
Print["\nExported pole_check.png"];
