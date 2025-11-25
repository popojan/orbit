(* Generate b&w figure for arXiv paper *)
(* The 1/π Invariant in Chebyshev Polynomial Geometry *)

subnrefu[x_, k_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x]

(* k-gon vertices on unit circle, rotated by -π/(2k) *)
kgonVertices[k_] := Table[
  {Cos[-(Pi/(2 k)) + 2 Pi j/k], Sin[-(Pi/(2 k)) + 2 Pi j/k]},
  {j, 0, k - 1}
]

(* Tick mark in radial direction (crossing the circle) *)
tickMark[{x_, y_}, len_:0.06] := Module[{},
  (* radial direction *)
  Line[{{(1 - len) x, (1 - len) y}, {(1 + len) x, (1 + len) y}}]
]

(* Single panel for given k - using Plot with Prolog/Epilog *)
panel[k_] := Plot[subnrefu[x, k], {x, -1, 1},
  PlotStyle -> {Black, Thickness[0.004]},
  Filling -> Axis,
  FillingStyle -> GrayLevel[0.85],
  PlotRange -> {{-1.25, 1.25}, {-1.5, 1.25}},
  AspectRatio -> Automatic,
  Axes -> False,
  Frame -> False,
  ImageSize -> 200,
  Prolog -> {
    (* Unit circle *)
    Black, Thickness[0.003], Circle[]
  },
  Epilog -> {
    (* Axes on top of fill *)
    GrayLevel[0.4], Thickness[0.001],
    Line[{{-1.15, 0}, {1.15, 0}}],
    Line[{{0, -1.15}, {0, 1.15}}],
    (* k-gon vertices as radial tick marks crossing the circle *)
    Black, Thickness[0.003],
    tickMark /@ kgonVertices[k],
    (* Label *)
    Text[Style[Row[{"k = ", k}], 16, FontFamily -> "Times", Bold, Black], {0, -1.35}]
  }
]

(* Export 4 separate PDFs *)
Export["chebyshev-k2.pdf", panel[2]];
Export["chebyshev-k3.pdf", panel[3]];
Export["chebyshev-k17.pdf", panel[17]];
Export["chebyshev-k31.pdf", panel[31]];

Print["Exported with radial tick marks"]
