(* Generate figure for Chebyshev lobe visualization *)
(* Copied from 2025-11-23-chebyshev-integral-identity/generate-figure.wl *)
(* Added: Highlighting of "fair" lobes where B = 1 *)

subnrefu[x_, n_] := ChebyshevT[n + 1, x] - x ChebyshevT[n, x]

(* n-gon vertices on unit circle, rotated by -π/(2n) *)
ngonVertices[n_] := Table[
  {Cos[-(Pi/(2 n)) + 2 Pi j/n], Sin[-(Pi/(2 n)) + 2 Pi j/n]},
  {j, 0, n - 1}
]

(* Tick mark in radial direction *)
tickMark[{x_, y_}, len_:0.08] := Line[{{x, y}, {(1 + len) x, (1 + len) y}}]

(* For n ≡ 2 (mod 4), fair lobes exist at k₁ = (n+2)/4, k₂ = (3n+2)/4 *)
(* These lobes are at x = 0 on the curve *)
fairLobeX = 0;

(* Find roots of the polynomial to identify lobe boundaries *)
lobeRoots[n_] := Sort[x /. NSolve[subnrefu[x, n] == 0, x, Reals]]

(* Shade a specific lobe (region between two roots) with thick colored border *)
shadeLobe[n_, leftRoot_, rightRoot_, color_] := Module[{pts, step},
  step = (rightRoot - leftRoot)/100;
  pts = Table[{x, subnrefu[x, n]}, {x, leftRoot, rightRoot, step}];
  {
    (* Filled region *)
    color, Opacity[0.4],
    Polygon[Join[pts, {{rightRoot, 0}, {leftRoot, 0}}]],
    (* Thick colored border on the curve *)
    color, Opacity[1], Thickness[0.008],
    Line[pts]
  }
]

(* Panel with fair lobes highlighted *)
(* x = 0 is a ROOT (boundary), so we highlight the TWO lobes adjacent to it *)
panelWithFairLobes[n_] := Module[{roots, fairLobeShading, leftOfZero, rightOfZero,
    nearestLeftRoot, nearestRightRoot, secondLeftRoot, secondRightRoot},
  roots = lobeRoots[n];

  (* Find roots around x = 0 *)
  leftOfZero = Sort[Select[roots, # < 0 &]];
  rightOfZero = Sort[Select[roots, # > 0 &]];

  fairLobeShading = {};
  If[Mod[n, 4] == 2,
    (* For n ≡ 2 (mod 4), x = 0 is a root - highlight TWO adjacent lobes *)
    leftOfZeroFiltered = Select[leftOfZero, # < -0.001 &];
    rightOfZeroFiltered = Select[rightOfZero, # > 0.001 &];

    nearestLeftRoot = If[Length[leftOfZeroFiltered] >= 1, Last[leftOfZeroFiltered], -0.3];
    nearestRightRoot = If[Length[rightOfZeroFiltered] >= 1, First[rightOfZeroFiltered], 0.3];

    (* Two lobes adjacent to x = 0 *)
    fairLobeShading = {
      shadeLobe[n, nearestLeftRoot, 0, Red],
      shadeLobe[n, 0, nearestRightRoot, Red]
    };
  ];

  Plot[subnrefu[x, n], {x, -1, 1},
    PlotStyle -> {Black, Thickness[0.004]},
    Filling -> Axis,
    FillingStyle -> GrayLevel[0.85],
    PlotRange -> {{-1.35, 1.35}, {-1.6, 1.35}},
    AspectRatio -> Automatic,
    Axes -> False,
    Frame -> False,
    ImageSize -> 400,
    Prolog -> {
      (* Unit circle *)
      Black, Thickness[0.003], Circle[],
      (* Fair lobe highlighting - TWO lobes adjacent to x=0 *)
      fairLobeShading
    },
    Epilog -> {
      (* Axes *)
      GrayLevel[0.4], Thickness[0.001],
      Line[{{-1.25, 0}, {1.25, 0}}],
      Line[{{0, -1.25}, {0, 1.25}}],
      (* n-gon vertices as tick marks *)
      Black, Thickness[0.003],
      tickMark /@ ngonVertices[n],
      (* Red dot at x = 0 (the boundary point) *)
      Red, PointSize[0.025],
      Point[{0, 0}],
      (* Labels *)
      Text[Style[Row[{"n = ", n}], 18, FontFamily -> "Times", Bold, Black], {0, -1.45}],
      If[Mod[n, 4] == 2,
        Text[Style["x = 0\n(B = 1)", 11, FontFamily -> "Times", Red], {0.18, 0.12}],
        {}
      ]
    }
  ]
]

(* Generate for n = 14 (has fair lobes) and n = 7 (no fair lobes) *)
Print["Generating figures..."];
Export["chebyshev-n14-fair.png", panelWithFairLobes[14]];
Export["chebyshev-n10-fair.png", panelWithFairLobes[10]];
Export["chebyshev-n6-fair.png", panelWithFairLobes[6]];
Print["Done."];
