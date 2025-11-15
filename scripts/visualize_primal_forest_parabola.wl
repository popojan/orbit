#!/usr/bin/env wolframscript
(* Vizualizace Prvolesu s vybarvenou parabolickou vrstvou k=1 *)

(* Generate all composite points up to n *)
comp1[m_, n_] :=
 Join @@ Table[{k*p + p^2, k*p + 1}, {k, 0, n}, {p,
    Max[1, Ceiling[1/2 (-k + Sqrt[k^2 + 4*m])]],
    Floor[1/2 (-k + Sqrt[k^2 + 4*n])]}]

(* Generate points with k value for filtering *)
comp1WithK[m_, n_] :=
 Join @@ Table[{k*p + p^2, k*p + 1, k}, {k, 0, n}, {p,
    Max[1, Ceiling[1/2 (-k + Sqrt[k^2 + 4*m])]],
    Floor[1/2 (-k + Sqrt[k^2 + 4*n])]}]

(* Visualize the forest with diagonal layer highlighted *)
lplParabola[hi_] := Module[{allFiltered, sqrtCurve, primes},
  (* All valid composite points (for plotting as black dots) *)
  allFiltered = Select[comp1[1, hi], #[[1]] > #[[2]] &];

  (* Get primes for vertical clearings *)
  primes = Select[comp1[1, hi], PrimeQ@*First];

  (* Continuous sqrt function *)
  sqrtCurve = Plot[(1 + Sqrt[1 + 4*x])/2, {x, 0, hi},
    PlotStyle -> Directive[GrayLevel[0.5], Thin]];

  (* Combine with ListPlot (ListPlot first so its options take precedence) *)
  Show[
    ListPlot[allFiltered,
      PlotRange -> {{0, hi}, {0, hi}},
      AxesOrigin -> {0, 0},
      AspectRatio -> 1,
      PlotMarkers -> {Automatic, 10},
      Frame -> True,
      GridLines -> {Table[i - 0.5, {i, 1, hi}], Table[j - 0.5, {j, 1, hi}]},
      GridLinesStyle -> Directive[GrayLevel[0.85], Thin],
      FrameTicks -> {{Range[0, hi], None}, {Range[0, hi], None}},
      PlotStyle -> Black,
      ImageSize -> {480, 480},
      Epilog -> {
        Directive[GrayLevel[0.3], Arrowheads[0.03]],
        Arrow[{{First@#, 0}, {First@#, First@#}}] & /@ primes
      }
    ],
    sqrtCurve
  ]
]

(* Generate the plot *)
Print["Generuji vizualizaci s vybarvenou vrstvou k=1..."];
plot = lplParabola[32];

(* Export *)
Export["docs/papers/visualizations/primal-forest-100-parabola.pdf", plot];
Print["✓ Vytvořeno: docs/papers/visualizations/primal-forest-100-parabola.pdf"];
