#!/usr/bin/env wolframscript
(* Vizualizace Prvolesu s vybarvenou parabolickou vrstvou *)

(* Generování bodů prvolesa *)
GenerateForestPoints[maxN_] := Module[{points = {}},
  Do[
    Do[
      AppendTo[points, {k*p + p^2, k*p + 1, p, k}],
      {k, 0, Floor[(maxN - p^2)/p]}
    ],
    {p, 2, Floor[Sqrt[maxN]]}
  ];
  points
]

(* Vytvoření vizualizace pro n <= 100 s vybarvenou parabolou *)
Print["Generuji vizualizaci s vybarvenou parabolickou vrstvou k=1..."];

maxN = 100;
allPoints = GenerateForestPoints[maxN];

(* Rozdělení bodů: parabola k=1 vs ostatní *)
parabolaK1 = Select[allPoints, #[[4]] == 1 &];  (* k=1: druhá vrstva *)
otherPoints = Select[allPoints, #[[4]] != 1 &];

(* Extrakce souřadnic *)
parabolaCoords = {#[[1]], #[[2]]} & /@ parabolaK1;
otherCoords = {#[[1]], #[[2]]} & /@ otherPoints;

(* Vytvoření grafu *)
plot = Graphics[{
  (* Ostatní body - černé *)
  Black, PointSize[0.015],
  Point[otherCoords],

  (* Parabola k=1 - zvýrazněná červenou *)
  Red, PointSize[0.018],
  Point[parabolaCoords],

  (* Popis paraboly *)
  Text[Style["Parabolická vrstva k=1", Red, FontSize -> 10, Bold],
    {28, 12}, {-1, 0}],

  (* Šipka k parabole *)
  Red, Arrowheads[0.02],
  Arrow[{{27, 12}, {18, 7}}]
},
  Frame -> True,
  FrameLabel -> {"x (číslo n)", "y (hloubka)"},
  PlotLabel -> Style["Prvoles s vybarvenou parabolickou vrstvou", Bold, FontSize -> 14],
  AspectRatio -> 0.6,
  PlotRange -> {{0, maxN + 2}, {0, Max[allPoints[[All, 2]]] + 2}},
  ImageSize -> 600,
  GridLines -> {Range[0, maxN, 5], Automatic},
  GridLinesStyle -> Directive[Gray, Dashed, Thin]
];

(* Export *)
Export["docs/papers/visualizations/primal-forest-31-parabola.pdf", plot];
Print["✓ Vytvořeno: docs/papers/visualizations/primal-forest-31-parabola.pdf"];

(* Info o parabole *)
Print[""];
Print["Parabola k=1 obsahuje body:"];
Print["  p    x=kp+p²    y=kp+1"];
Print["  ===  =========  ======="];
Do[
  Print["  ", p, "    ", 1*p + p^2, "        ", 1*p + 1],
  {p, 2, Floor[Sqrt[maxN]]}
];

Print[""];
Print["Tyto body tvoří parabolu: x = p + p² (pro k=1)"];
Print[""];
