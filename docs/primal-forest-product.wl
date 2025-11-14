(* Product of distances from vertical line at x to all composite dots *)
  (* Using ALL p from 2 to sqrt(x), including composites *)

  DistanceProduct[x_Integer] := Module[{maxP, distances},
    maxP = Floor[Sqrt[x]];

    (* For each p from 2 to sqrt(x), compute minimum distance *)
    distances = Table[
      Module[{r},
        If[x < p^2,
          (* x is before this row starts *)
          p^2 - x,
          (* x is in range, find nearest point in sequence p^2, p^2+p, p^2+2p, ... *)
          r = Mod[x - p^2, p];
          Min[r, p - r]
        ]
      ],
      {p, 2, maxP}
    ];

    (* Product of all distances *)
    Times @@ distances
  ]

  (* Test on some numbers *)
  Print["Testing product of distances:"];
  Print[""];

  testNumbers = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};

  Print["x | Product | Prime?"];
  Print[StringRepeat["-", 40]];

  Do[
    Module[{prod, isPrime},
      prod = DistanceProduct[x];
      isPrime = PrimeQ[x];

      Print[x, " | ", prod, " | ", If[isPrime, "YES", "no"]];
    ],
    {x, testNumbers}
  ];

  Print[""];
  Print["Observation: Product = 0 iff composite (distance 0 to some dot)"];
  Print["              Product > 0 iff prime (positive distance to all dots)"];
  Print[""];

  (* Show individual distances for a specific example *)
  Print[""];
  Print["Detailed breakdown for x = 12 (composite):"];
  Print[""];

  x = 12;
  maxP = Floor[Sqrt[x]];

  Print["p | Distance to nearest dot | Contribution"];
  Print[StringRepeat["-", 50]];

  Do[
    Module[{r, dist},
      If[x < p^2,
        dist = p^2 - x,
        r = Mod[x - p^2, p];
        dist = Min[r, p - r]
      ];

      Print[p, " | ", dist, " | ",
        If[dist == 0, "ZERO - composite factor!", "non-zero"]];
    ],
    {p, 2, maxP}
  ];

  Print[""];
  Print["Product = ", DistanceProduct[12], " (zero because p=2 gives distance 0)"];
  Print[""];

  (* Show for a prime *)
  Print[""];
  Print["Detailed breakdown for x = 13 (prime):"];
  Print[""];

  x = 13;
  maxP = Floor[Sqrt[x]];

  Print["p | Distance to nearest dot"];
  Print[StringRepeat["-", 40]];

  Do[
    Module[{r, dist},
      If[x < p^2,
        dist = p^2 - x,
        r = Mod[x - p^2, p];
        dist = Min[r, p - r]
      ];

      Print[p, " | ", dist];
    ],
    {p, 2, maxP}
  ];

  Print[""];
  Print["Product = ", DistanceProduct[13], " (all positive → prime)"];

  This will show you:
  1. The product for numbers 2-20
  2. Detailed breakdown for 12 (composite) showing which p gives distance 0
  3. Detailed breakdown for 13 (prime) showing all distances are positive

  The key insight: Product = 0 ⟺ composite (some distance is 0 because a factor exists)

  You can also visualize which p values contribute distance 0:

  (* Visual representation of distance contributions *)
  VisualizeDistances[x_Integer] := Module[{maxP, data},
    maxP = Floor[Sqrt[x]];

    data = Table[
      Module[{r, dist},
        If[x < p^2,
          dist = p^2 - x,
          r = Mod[x - p^2, p];
          dist = Min[r, p - r]
        ];
        {p, dist}
      ],
      {p, 2, maxP}
    ];

    BarChart[data[[All, 2]],
      ChartLabels -> data[[All, 1]],
      AxesLabel -> {"p", "Distance"},
      PlotLabel -> "Distance from x = " <> ToString[x] <> " to nearest dot (each p)",
      ColorFunction -> Function[{height}, If[height == 0, Red, Blue]]
    ]
  ]

  (* Compare a composite and a prime *)
  GraphicsRow[{
    VisualizeDistances[12],  (* composite *)
    VisualizeDistances[13]   (* prime *)
  }]
