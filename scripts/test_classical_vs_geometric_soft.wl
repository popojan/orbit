#!/usr/bin/env wolframscript
(* Compare classical vs geometric soft distance product *)

(* Geometric version - from Primal Forest *)
GeometricSoft[x_, β_: 1/7] :=
  Product[
    -β * Log @ Sum[
      Exp[-Abs[x - (k*p + p^2)]/β],
      {k, 0, Floor[x/p]}
    ],
    {p, 2, x}
  ]

(* Classical version - direct modular distance *)
ClassicalSoft[x_, β_: 1/7] :=
  Product[
    -β * Log[Exp[-Mod[x, p]/β] + Exp[-(p - Mod[x, p])/β]],
    {p, 2, x}
  ]

Print["Comparing Geometric vs Classical soft distance product:"];
Print[""];
Print["n | Geometric | Classical | Prime?"];
Print[StringRepeat["-", 60]];

Do[
  Print[n, " | ",
    N[Log[1 + GeometricSoft[n, 1/7]], 6], " | ",
    N[Log[1 + ClassicalSoft[n, 1/7]], 6], " | ",
    If[PrimeQ[n], "YES", "no"]
  ],
  {n, 2, 20}
];

Print[""];
Print["Testing if they produce same envelope..."];

geomData = Table[{k, Log[1 + GeometricSoft[k, 1/7]]}, {k, 2, 60}];
classData = Table[{k, Log[1 + ClassicalSoft[k, 1/7]]}, {k, 2, 60}];

comparison = ListLinePlot[{
  GatherBy[geomData, PrimeQ@*First],
  GatherBy[classData, PrimeQ@*First]
},
  PlotMarkers -> {Automatic, Automatic},
  PlotStyle -> {{}, {Dashed, Dashed}},
  PlotLegends -> {"Geometric (solid)", "Classical (dashed)"},
  Frame -> True,
  PlotLabel -> "Geometric vs Classical Soft Distance Product",
  ImageSize -> Large
];

Export["visualizations/geometric-vs-classical-comparison.png", comparison];
Print["Comparison plot saved!"];
