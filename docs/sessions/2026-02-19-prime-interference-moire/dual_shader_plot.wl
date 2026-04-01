(* Dual shader: (c, h) = (i+j, (2i-c)/c) with uniform heights *)
(* Each number n colored by d(n), primes highlighted *)

cMax = 50;

(* Generate all points *)
points = Flatten[Table[
  {i + j, (2 i - (i + j))/(i + j), i j, i, j},
  {i, 1, cMax}, {j, i, cMax}  (* j >= i to avoid duplicates, mirror later *)
], 1];

(* Color by divisor count of the product n = ij *)
colorByDivisors[n_] := Which[
  PrimeQ[n], RGBColor[1, 0.2, 0.2],           (* red = prime *)
  DivisorSigma[0, n] <= 4, RGBColor[0.3, 0.5, 0.9],  (* blue = few divisors *)
  DivisorSigma[0, n] <= 8, RGBColor[0.2, 0.7, 0.3],  (* green = moderate *)
  True, RGBColor[1, 0.8, 0]                    (* gold = highly composite *)
];

(* Build graphics: both +h and -h (symmetric) *)
pointGraphics = Table[
  With[{c = pt[[1]], h = pt[[2]], n = pt[[3]], i = pt[[4]], j = pt[[5]]},
    {colorByDivisors[n],
     PointSize[If[PrimeQ[n], 0.005, 0.003]],
     Point[{c, h}],
     If[i != j, (* mirror for j > i *)
       Point[{c, -h}],
       Nothing
     ]}
  ],
  {pt, points}
];

(* Vertical grid lines: thin for all c, highlight prime c-1 *)
verticals = Table[
  {If[PrimeQ[c - 1],
    Directive[AbsoluteThickness[0.6], RGBColor[1, 0.5, 0.5, 0.3]],
    Directive[AbsoluteThickness[0.2], GrayLevel[0.9]]],
   Line[{{c, -1}, {c, 1}}]},
  {c, 2, cMax + 1}
];

(* Trace curves for a few selected numbers *)
traceNumber[n_, color_] := Module[{divs, pts},
  divs = Select[Divisors[n], # <= Sqrt[n] &];
  pts = Table[
    With[{c = d + n/d, h = (d - n/d)/(d + n/d)},
      {c, h}
    ],
    {d, divs}
  ];
  (* Include symmetric points *)
  pts = Join[pts, {#[[1]], -#[[2]]} & /@ pts];
  pts = SortBy[pts, First];
  {color, AbsoluteThickness[1.5], Line[pts],
   color, PointSize[0.007], Point /@ pts}
];

traces = {
  traceNumber[30, Darker[Green, 0.3]],
  traceNumber[60, Darker[Blue, 0.2]],
  traceNumber[12, Orange],
  traceNumber[7, Red]
};

(* Legend *)
legend = {
  Text[Style["red dots = prime products", 8, Red], {cMax - 8, 0.95}],
  Text[Style["blue = few divisors, green = moderate, gold = highly composite", 7,
    GrayLevel[0.4]], {cMax - 8, 0.88}],
  Text[Style["pink verticals = prime c-1", 8, RGBColor[1, 0.5, 0.5]], {cMax - 8, 0.81}],
  Text[Style["curves: n=7(red) n=12(orange) n=30(green) n=60(blue)", 7,
    GrayLevel[0.3]], {cMax - 8, 0.74}]
};

plot = Graphics[{
    verticals,
    pointGraphics,
    traces,
    legend
  },
  PlotRange -> {{1.5, cMax + 1}, {-1.05, 1.05}},
  AspectRatio -> 1/2,
  Axes -> True,
  AxesLabel -> {"c = i+j", "h = (i-j)/(i+j)"},
  PlotLabel -> Style["Dual shader: uniform grid, arithmetic in horizontals\n\
Each vertical c has c-1 equally spaced points. Colors = divisor count of product.", 9],
  ImageSize -> 1000,
  Background -> White
];

Export["docs/sessions/2026-02-19-prime-interference-moire/figures/dual_shader.png",
  plot, ImageResolution -> 150];
Print["Exported to figures/dual_shader.png"];
