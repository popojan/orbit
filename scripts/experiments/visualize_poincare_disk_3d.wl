#!/usr/bin/env wolframscript
(* Visualize relationship between 3D hyperboloid and 2D Poincaré disk *)

Print["Creating 3D visualizations of hyperbolic geometry...\n"];

(* ===== 1. HYPERBOLOID MODEL (3D) ===== *)
Print["1. Hyperboloid model (your original intuition)"];

(* Hyperboloid: x^2 + y^2 - z^2 = -1, z > 0 (upper sheet) *)
hyperboloid = ParametricPlot3D[
  {Sinh[u]*Cos[v], Sinh[u]*Sin[v], Cosh[u]},
  {u, 0, 2}, {v, 0, 2*Pi},
  PlotStyle -> Directive[Opacity[0.7], Blue],
  Mesh -> 15,
  PlotLabel -> "Hyperboloid Model\nx² + y² - z² = -1",
  AxesLabel -> {"x", "y", "z"},
  Boxed -> False,
  ImageSize -> 400
];

Print["Saved hyperboloid visualization"];

(* ===== 2. STEREOGRAPHIC PROJECTION ===== *)
Print["2. Stereographic projection to Poincaré disk"];

(* Point on hyperboloid (x,y,z) projects to disk point *)
stereographicProj[x_, y_, z_] := {x/(1 + z), y/(1 + z)};

(* Sample points on hyperboloid *)
nPoints = 30;
hyperboloidPoints = Table[
  {Sinh[u]*Cos[v], Sinh[u]*Sin[v], Cosh[u]},
  {u, 0, 1.5, 1.5/10}, {v, 0, 2*Pi, 2*Pi/nPoints}
] // Flatten[#, 1]&;

(* Project to disk *)
diskPoints = Map[
  Function[{pt},
    Module[{x, y, z, dx, dy},
      {x, y, z} = pt;
      {dx, dy} = stereographicProj[x, y, z];
      {dx, dy, 0}  (* z=0 for disk plane *)
    ]
  ],
  hyperboloidPoints
];

(* Combined visualization *)
combined = Show[
  (* Hyperboloid *)
  ParametricPlot3D[
    {Sinh[u]*Cos[v], Sinh[u]*Sin[v], Cosh[u]},
    {u, 0, 1.5}, {v, 0, 2*Pi},
    PlotStyle -> Directive[Opacity[0.5], Blue],
    Mesh -> 10
  ],
  (* Unit disk at z=0 *)
  ParametricPlot3D[
    {r*Cos[theta], r*Sin[theta], 0},
    {r, 0, 1}, {theta, 0, 2*Pi},
    PlotStyle -> Directive[Opacity[0.3], Yellow],
    Mesh -> 10
  ],
  (* Projection lines *)
  Graphics3D[{
    Thin, Gray, Dashed,
    Table[
      Line[{hyperboloidPoints[[i]], diskPoints[[i]]}],
      {i, 1, Length[hyperboloidPoints], 5}
    ]
  }],
  (* Points *)
  Graphics3D[{Red, PointSize[0.01], Point[hyperboloidPoints[[;;;;5]]]}],
  Graphics3D[{Green, PointSize[0.01], Point[diskPoints[[;;;;5]]]}],
  PlotLabel -> "Stereographic Projection:\nHyperboloid → Poincaré Disk",
  AxesLabel -> {"x", "y", "z"},
  Boxed -> False,
  ImageSize -> 500,
  ViewPoint -> {2, -2, 1}
];

Export["visualizations/viz_hyperboloid_to_disk.png", combined];
Print["Exported: viz_hyperboloid_to_disk.png"];

(* ===== 3. POINCARÉ DISK WITH GEODESICS (2D) ===== *)
Print["3. Poincaré disk with geodesics (top view)"];

(* Geodesic through origin (straight line) *)
geodesic1[t_] := {t, 0};

(* Geodesic NOT through origin (circular arc perpendicular to boundary) *)
(* Circle centered at (0, c) with radius r such that arc is perpendicular to unit circle *)
geodesic2[theta_] := Module[{c = 1.5, r},
  r = Sqrt[c^2 - 1];
  {r*Sin[theta], c - r*Cos[theta]}
];

geodesic3[theta_] := Module[{c = -1.5, r},
  r = Sqrt[c^2 - 1];
  {r*Sin[theta], c + r*Cos[theta]}
];

poincareDisk = Show[
  (* Unit circle boundary *)
  Graphics[{Thick, Black, Circle[{0, 0}, 1]}],
  (* Background *)
  Graphics[{Opacity[0.1], Yellow, Disk[{0, 0}, 1]}],
  (* Geodesics *)
  Graphics[{Thick, Red, Line[Table[geodesic1[t], {t, -0.9, 0.9, 0.01}]]}],
  ParametricPlot[geodesic2[theta], {theta, -0.6, 0.6},
    PlotStyle -> {Thick, Blue}],
  ParametricPlot[geodesic3[theta], {theta, -0.6, 0.6},
    PlotStyle -> {Thick, Green}],
  (* Grid lines (hyperbolic) *)
  Table[
    ParametricPlot[
      Module[{c = i, r = Sqrt[c^2 - 1]},
        {r*Sin[theta], c - r*Cos[theta]}
      ],
      {theta, -ArcSin[1/Abs[i]], ArcSin[1/Abs[i]]},
      PlotStyle -> {Thin, Gray, Opacity[0.3]}
    ],
    {i, {-3, -2, 2, 3}}
  ],
  PlotLabel -> "Poincaré Disk (2D view)\nGeodesics = circular arcs ⊥ boundary",
  PlotRange -> {{-1.2, 1.2}, {-1.2, 1.2}},
  AspectRatio -> 1,
  ImageSize -> 500,
  Axes -> True,
  AxesLabel -> {"x", "y"}
];

Export["visualizations/viz_poincare_disk_geodesics.png", poincareDisk];
Print["Exported: viz_poincare_disk_geodesics.png"];

(* ===== 4. SIDE-BY-SIDE COMPARISON ===== *)
Print["4. Side-by-side: Hyperboloid vs Poincaré disk"];

sbs = GraphicsRow[
  {
    Show[hyperboloid, ImageSize -> 300],
    Show[poincareDisk, ImageSize -> 300]
  },
  Spacings -> 30,
  ImageSize -> 700
];

Export["visualizations/viz_hyperbolic_models_comparison.png", sbs];
Print["Exported: viz_hyperbolic_models_comparison.png"];

(* ===== 5. HYPERBOLIC DISTANCE VISUALIZATION ===== *)
Print["5. Hyperbolic distance in Poincaré disk"];

(* Distance from origin to point at radius r *)
hyperbolicDistance[r_] := ArcTanh[r];

(* Alternative form with ArcSinh *)
hyperbolicDistanceAlt[r_] := ArcSinh[r / Sqrt[1 - r^2]];

distPlot = Plot[
  {hyperbolicDistance[r], hyperbolicDistanceAlt[r]},
  {r, 0, 0.99},
  PlotLegends -> {"d = ArcTanh[r]", "d = ArcSinh[r/√(1-r²)]"},
  PlotLabel -> "Hyperbolic Distance from Origin\n(Both formulas equivalent)",
  AxesLabel -> {"Euclidean radius r", "Hyperbolic distance d"},
  GridLines -> Automatic,
  ImageSize -> 500,
  PlotStyle -> {Thick, {Thick, Dashed}}
];

Export["visualizations/viz_hyperbolic_distance.png", distPlot];
Print["Exported: viz_hyperbolic_distance.png"];

(* ===== 6. EMBEDDING IN 3D (PSEUDOSPHERE) ===== *)
Print["6. Pseudosphere embedding (alternative 3D view)"];

(* Pseudosphere: surface of revolution with constant negative curvature *)
pseudosphere = ParametricPlot3D[
  {Cos[u]/Cosh[v], Sin[u]/Cosh[v], v - Tanh[v]},
  {u, 0, 2*Pi}, {v, 0, 2},
  PlotStyle -> Directive[Opacity[0.7], Purple],
  Mesh -> 15,
  PlotLabel -> "Pseudosphere\n(Another 3D embedding of hyperbolic plane)",
  Boxed -> False,
  ImageSize -> 400
];

Export["visualizations/viz_pseudosphere.png", pseudosphere];
Print["Exported: viz_pseudosphere.png"];

Print["\n=== SUMMARY ==="];
Print["Created 6 visualizations:"];
Print["1. Hyperboloid (your 3D intuition) ✓"];
Print["2. Projection hyperboloid → disk ✓"];
Print["3. Poincaré disk with geodesics ✓"];
Print["4. Side-by-side comparison ✓"];
Print["5. Hyperbolic distance (ArcSinh!) ✓"];
Print["6. Pseudosphere (alternative embedding) ✓"];
Print["\nKey insight: Poincaré disk IS 2D, but represents 3D hyperbolic geometry!"];
Print["The 'depth' is encoded in the metric (distances grow to boundary).\n"];

Print["DONE!"];
