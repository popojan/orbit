(* Circular Transform: intersection lattice on concentric circles *)
(* Transform: (x, y) -> (2 Sqrt[x], y), then r = i + j *)

nMax = 30; (* max factor value *)

(* Generate all intersection points (i*j, i-j) for i,j >= 1 *)
pts = Flatten[
  Table[{i, j, i j, i - j}, {i, 1, nMax}, {j, 1, nMax}],
  1];

(* Transformed coordinates: (2 Sqrt[x], y) *)
transformedPts = {2 Sqrt[#3], #4} & @@@ pts;

(* Color by radius r = i+j, size by primality of x=i*j *)
coloredPts = {
    Hue[Mod[(#1 + #2), 12]/12, 0.9, 0.7],
    PointSize[If[PrimeQ[#3], 0.008, 0.005]],
    Point[{2 Sqrt[#3], #4}]
  } & @@@ pts;

(* Reference circles at integer radii *)
maxR = 30;
circles = Table[
  {Thin, Gray, Circle[{0, 0}, c]},
  {c, 2, maxR}
];

(* Mark prime circles (r = p+1) slightly thicker *)
primeCircles = Table[
  {Thin, Darker[Red, 0.3], Circle[{0, 0}, p + 1]},
  {p, Select[Range[2, maxR - 1], PrimeQ]}
];

(* Transformed vertical grid lines: x = n -> u = 2 Sqrt[n] *)
(* Composite: very faint. Prime: tinted, no interior intersections. *)
yRange = 20;
vertMax = 80;

compositeVerts = Table[
  {Directive[AbsoluteThickness[0.3], GrayLevel[0.88]],
   Line[{{2 Sqrt[n], -yRange}, {2 Sqrt[n], yRange}}]},
  {n, Select[Range[4, vertMax], ! PrimeQ[#] &]}
];

primeVerts = Table[
  {Directive[AbsoluteThickness[0.6], RGBColor[0.55, 0.75, 1.0]],
   Line[{{2 Sqrt[p], -yRange}, {2 Sqrt[p], yRange}}]},
  {p, Select[Range[2, vertMax], PrimeQ]}
];

(* Labels for a few primes *)
primeLabels = Table[
  Text[Style[p, 7, GrayLevel[0.4]],
    {2 Sqrt[p], -yRange - 1.2}, {0, 0}],
  {p, {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71}}
];

(* Plot *)
plot = Graphics[{
    (* Vertical grid: composites first (behind), then primes *)
    compositeVerts,
    primeVerts,
    (* Circles *)
    circles,
    primeCircles,
    (* Labels *)
    primeLabels,
    (* Intersection points on top *)
    coloredPts
  },
  PlotRange -> {{-0.5, 19}, {-yRange - 2, yRange + 1}},
  AspectRatio -> Automatic,
  Axes -> True,
  AxesLabel -> {"u = 2\[Sqrt]x", "y = i \[Minus] j"},
  PlotLabel -> Style["Intersection lattice: circles r = i+j,  vertical lines x = n\n\
Blue verticals = primes (no interior intersections)", 10],
  ImageSize -> 900,
  Background -> White
];

(* Export and display *)
Export["docs/sessions/2026-02-19-prime-interference-moire/figures/circular_transform.png", plot, ImageResolution -> 150];
Print["Exported to figures/circular_transform.png"];
