#!/usr/bin/env wolframscript
(* Animation showing Chebyshev curves inscribed in unit circle *)
(* Creates n-star patterns by connecting contact points *)

subnref[x_, k_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x]

(* Find points where curve touches unit circle: x^2 + subnref[x,k]^2 = 1 *)
solp[k_] := {#, subnref[#, k]} & /@
  Select[SolveValues[x^2 + subnref[x, k]^2 == 1, x], Abs@# < 1 &]

(* Find symmetric contact points *)
circp[k_] := Module[{xp},
  xp = solp[k];
  Intersection[xp, Transpose /@ xp]
]

(* Plot single frame with k-star pattern *)
showPlot[k_] := Module[{
   p = SortBy[circp[k], N@{Sign[Last@#], -Sign[Last@#] First@#} &]
  },
  Plot[
   {subnref[x, k]}, {x, -1, 1},
   Epilog -> {PointSize@Medium, Black, Point@p},
   Frame -> True,
   PlotLabel -> Row[{"k = ", k}],
   ImageSize -> Medium,
   GridLines -> None,
   PlotRange -> 1.1 {{-1, 1}, {-1, 1}},
   Filling -> Axis,
   AspectRatio -> 1,
   PlotStyle -> Directive[{}],
   Prolog -> {
     Thin, Black, Circle[],
     EdgeForm[Directive[{Opacity@0.5, Orange}]],
     FaceForm[Directive[{Orange, Opacity@0.3}]],
     (* Create star by alternating between outer and inner (scaled) points *)
     Polygon[Join @@ Transpose[{p[[;; ;; 2]], 1/2 p[[2 ;; ;; 2]]}]]
   }
  ]
]

(* Generate animation frames *)
anim = Table[showPlot[k], {k, Range[3, 17]}];

(* Export as animated GIF *)
Export["chebyshev_star_animation.gif", anim, "DisplayDurations" -> 0.5]

Print["Animation exported to: chebyshev_star_animation.gif"];
Print["Frames: k = 3 to 17"];
Print["Each frame shows the curve touching the unit circle at k+1 points"];
