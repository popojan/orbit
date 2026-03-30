(* pell-families.wl — Study Pell regulator families grouped by distance functions
 *
 * Usage:
 *   reg = loadRegulators["~/github/zzz/build/reg100k.csv", 100000];
 *   families = pellFamilies[reg, # - nearestEvenSquare[#] &];
 *   plotFamilies[families, 9]
 *   exportFamilies[families, "/tmp/pell_d16.csv", {16}]
 *)

(* === Load regulator CSV === *)
loadRegulators[path_, limit_: All] := Module[{raw},
  raw = Flatten@Import[path, "Data"];
  If[limit === All, raw, Take[raw, Min[limit, Length@raw]]]
]

(* === Distance helper: nearest even integer to ceil(sqrt(n)) === *)
nearestEvenSquare[n_] := Module[{m = Ceiling[Sqrt[n]]},
  If[OddQ[m], m - 1, m];
  m = If[OddQ[m], m - 1, m];
  m^2
]

(* === Core: group n values by distance function, extract Pell data === *)
(* distFn: n -> integer distance label
 * Returns Association: distance -> list of {n, R, L, x, y, m, R/log(n)} *)
pellFamilies[reg_, distFn_, opts___] := Module[
  {limit, minR, pairs, grouped, result},

  limit = "Limit" /. {opts} /. "Limit" -> Length[reg];
  minR = "MinR" /. {opts} /. "MinR" -> 0.01;

  (* Collect {n, R, distance} for non-square n *)
  pairs = Table[
    If[reg[[n]] > minR, {n, reg[[n]], distFn[n]}, Nothing],
    {n, 2, Min[limit, Length[reg]]}
  ];

  (* Group by distance *)
  grouped = GroupBy[pairs, #[[3]] &];

  (* For each group, compute Pell properties *)
  result = Association@KeyValueMap[
    Function[{dist, entries},
      dist -> Map[
        Function[{entry},
          Module[{n = entry[[1]], R = entry[[2]], cf, period, x, y, m},
            m = Ceiling[Sqrt[n]];
            If[OddQ[m], m = m - 1];  (* nearest even *)

            (* CF period *)
            cf = Quiet@ContinuedFraction[Sqrt[n]];
            period = If[Length[cf] > 1, Length[cf[[2]]], 0];

            (* Pell solution from R *)
            {x, y} = With[{prec = Max[50, Ceiling[R / Log[10]] + 20]},
              Module[{Rp = SetPrecision[R, prec], xr, yr},
                xr = Round[Cosh[Rp]];
                yr = Round[Sinh[Rp] / Sqrt[n]];
                {xr, yr}
              ]
            ];

            <|
              "n" -> n,
              "R" -> R,
              "L" -> period,
              "x" -> x,
              "y" -> y,
              "m" -> m,
              "d" -> n - m^2,
              "mMod4" -> Mod[m, 4],
              "mMod8" -> Mod[m, 8],
              "ROverLogN" -> If[n > 1, R / Log[n], 0]
            |>
          ]
        ],
        entries
      ]
    ],
    grouped
  ];

  (* Sort keys numerically *)
  KeySort[result]
]

(* === Summary table for a family === *)
familySummary[families_, dist_] := Module[{fam, byMod8},
  fam = families[dist];
  If[MissingQ[fam], Return["No data for d=" <> ToString[dist]]];

  byMod8 = GroupBy[fam, #["mMod8"] &];

  Print["d = ", dist, "  (", Length[fam], " entries)"];
  Print["-----------------------------------------"];
  KeyValueMap[
    Function[{mod8, entries},
      Module[{large, ratios, periods},
        large = Select[entries, #["n"] > 1000 &];
        ratios = #["ROverLogN"] & /@ large;
        periods = #["L"] & /@ entries // DeleteDuplicates // Sort;
        Print["  m mod 8 = ", mod8,
          "  L = ", periods,
          "  R/log(n) -> ", If[Length@ratios > 0, Round[Mean@ratios, 0.001], "?"],
          "  (", Length@entries, " entries)"];
      ]
    ],
    KeySort[byMod8]
  ];
  Print[];
]

(* === Plot families: R vs n colored by m mod 8 === *)
plotFamily[families_, dist_, opts___] := Module[{fam, byMod8, colors, plots},
  fam = families[dist];
  If[MissingQ[fam], Return[Graphics[Text["No data for d=" <> ToString[dist]]]]];

  byMod8 = GroupBy[fam, #["mMod8"] &] // KeySort;
  colors = {Red, Blue, Darker@Green, Orange, Purple, Cyan, Brown, Magenta};

  plots = KeyValueMap[
    Function[{mod8, entries},
      ListPlot[
        Tooltip[{#["n"], #["R"]}, Column@{
          "n=" <> ToString[#["n"]],
          "m=" <> ToString[#["m"]],
          "L=" <> ToString[#["L"]],
          "R/logn=" <> ToString[Round[#["ROverLogN"], 0.001]]
        }] & /@ entries,
        PlotStyle -> colors[[Mod[mod8, 8] + 1]],
        PlotLegends -> {"m%" <> ToString[mod8] <> " (8)"}
      ]
    ],
    byMod8
  ];

  Show[plots,
    PlotLabel -> "d = " <> ToString[dist],
    AxesLabel -> {"n", "R"},
    PlotRange -> All,
    ImageSize -> 600,
    Sequence @@ FilterRules[{opts}, Options[ListPlot]]
  ]
]

(* === Plot R/log(n) to see convergence of branches === *)
plotFamilyRatio[families_, dist_, opts___] := Module[{fam, byMod8, colors, plots},
  fam = families[dist];
  If[MissingQ[fam], Return[Graphics[Text["No data"]]]];

  byMod8 = GroupBy[fam, #["mMod8"] &] // KeySort;
  colors = {Red, Blue, Darker@Green, Orange, Purple, Cyan, Brown, Magenta};

  plots = KeyValueMap[
    Function[{mod8, entries},
      ListPlot[
        Tooltip[{#["n"], #["ROverLogN"]},
          "m=" <> ToString[#["m"]] <> " L=" <> ToString[#["L"]]] & /@
          Select[entries, #["n"] > 10 &],
        PlotStyle -> colors[[Mod[mod8, 8] + 1]],
        PlotLegends -> {"m%" <> ToString[mod8] <> "(8)"}
      ]
    ],
    byMod8
  ];

  Show[plots,
    PlotLabel -> "d = " <> ToString[dist] <> ": R/log(n)",
    AxesLabel -> {"n", "R/log(n)"},
    PlotRange -> All,
    ImageSize -> 600,
    Sequence @@ FilterRules[{opts}, Options[ListPlot]]
  ]
]

(* === Plot grid for range of distances === *)
plotFamilies[families_, maxPow_: 4] := Module[{dists, plots},
  dists = Join[-Reverse@(2^Range[0, maxPow]), 2^Range[0, maxPow]];
  plots = plotFamily[families, #] & /@ dists;
  GraphicsGrid[Partition[plots, 2, 2, 1, {}], ImageSize -> 1200]
]

plotFamiliesRatio[families_, maxPow_: 4] := Module[{dists, plots},
  dists = Join[-Reverse@(2^Range[0, maxPow]), 2^Range[0, maxPow]];
  plots = plotFamilyRatio[families, #] & /@ dists;
  GraphicsGrid[Partition[plots, 2, 2, 1, {}], ImageSize -> 1200]
]

(* === Export family data to CSV === *)
exportFamilies[families_, path_, dists_: All] := Module[{keys, rows},
  keys = If[dists === All, Keys[families], dists];
  rows = Join[
    {{"d", "n", "m", "mMod8", "R", "L", "ROverLogN",
      "xDigits", "yDigits"}},
    Flatten[
      Table[
        Module[{fam = families[d]},
          If[MissingQ[fam], {},
            {d, #["n"], #["m"], #["mMod8"],
             #["R"], #["L"], #["ROverLogN"],
             IntegerLength[#["x"]], IntegerLength[#["y"]]} & /@ fam
          ]
        ],
      {d, keys}],
    1]
  ];
  Export[path, rows, "CSV"];
  Print["Exported ", Length[rows] - 1, " rows to ", path];
]

(* === Quick analysis runner === *)
analyzePowerOf2Distances[reg_, maxPow_: 4] := Module[{families},
  families = pellFamilies[reg,
    Module[{m = Ceiling[Sqrt[#]]},
      m = If[OddQ[m], m - 1, m];
      # - m^2] &
  ];

  Print["========================================"];
  Print["  Pell regulator families: d = n - m^2"];
  Print["  (m = nearest even integer >= sqrt(n))"];
  Print["========================================"];
  Print[];

  Do[
    familySummary[families, d],
    {d, Join[-Reverse@(2^Range[0, maxPow]), {0}, 2^Range[0, maxPow]]}
  ];

  families
]

Print["pell-families.wl loaded."];
Print[""];
Print["Quick start:"];
Print["  reg = loadRegulators[\"~/github/zzz/build/reg100k.csv\"];"];
Print["  families = analyzePowerOf2Distances[reg, 4];"];
Print["  plotFamilies[families]"];
Print["  plotFamiliesRatio[families]"];
