(* Generate figures for Chebyshev Integral Identity session *)

subnrefu[x_, k_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x];

(* Panel showing integral region between f_n and horizontal line y=h *)
panelH[k_, h_] := Plot[{subnrefu[x, k], h}, {x, -1, 1},
  PlotStyle -> {{Black, Thickness[0.004]}, None},
  Filling -> {1 -> {2}},
  FillingStyle -> GrayLevel[0.85],
  PlotRange -> {{-1.15, 1.15}, {-1.3, 1.3}},
  AspectRatio -> Automatic,
  Axes -> False,
  Frame -> False,
  ImageSize -> 220,
  Prolog -> {
    (* Unit circle *)
    Black, Thin, Circle[],
    (* Horizontal line at h *)
    GrayLevel[0.5], Dashing[{0.02, 0.01}], Thickness[0.002],
    Line[{{-1.1, h}, {1.1, h}}]
  },
  Epilog -> {
    (* Axes *)
    GrayLevel[0.4], Thickness[0.001],
    Line[{{-1.1, 0}, {1.1, 0}}],
    Line[{{0, -1.2}, {0, 1.2}}],
    (* Bounds at y=+-1 *)
    GrayLevel[0.7], Dashing[{0.01, 0.01}],
    Line[{{-1.05, 1}, {1.05, 1}}],
    Line[{{-1.05, -1}, {1.05, -1}}],
    (* Labels *)
    Black,
    Text[Style[Row[{"n = ", k}], 14, FontFamily -> "Times", Bold], {0, -1.2}],
    Text[Style[Row[{"h = ", h}], 12, FontFamily -> "Times"], {0.85, h + 0.12}]
  }
];

(* Grid for h = -1, 0, 1 and n = 2, 3, 4 *)
grid = Grid[{
  {panelH[2, -1], panelH[3, -1], panelH[4, -1]},
  {panelH[2, 0], panelH[3, 0], panelH[4, 0]},
  {panelH[2, 1], panelH[3, 1], panelH[4, 1]}
}, Spacings -> {0.5, 0.5}];

Export["figures/chebyshev_integral_grid.png", grid, ImageResolution -> 150];
Print["Exported: figures/chebyshev_integral_grid.png"];
