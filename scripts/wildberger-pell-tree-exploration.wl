#!/usr/bin/env wolframscript
(* Wildberger's Integer-Only Pell Equation Algorithm with Tree Structure Analysis *)
(* Reference: https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf *)

(* Original Wildberger algorithm *)
pellsol[d_] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c;
    If[t > 0,
      a = t; b += c; u += v; r += s,
      b += a; c = t; v += u; s += r
    ];
    Not[a == 1 && b == 0 && c == -d]
  ];
  {x -> u, y -> r}
]

(* Enhanced version: Track L/R path sequence *)
pellsolWithPath[d_] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1, path = {}},
  While[t = a + b + b + c;
    If[t > 0,
      (* Right branch *)
      AppendTo[path, "R"];
      a = t; b += c; u += v; r += s,
      (* Left branch *)
      AppendTo[path, "L"];
      b += a; c = t; v += u; s += r
    ];
    Not[a == 1 && b == 0 && c == -d]
  ];
  <|
    "solution" -> {x -> u, y -> r},
    "path" -> path,
    "length" -> Length[path],
    "palindrome" -> (path == Reverse[path])
  |>
]

(* Track full state evolution for visualization *)
(* CRITICAL: Also detect intermediate solutions (negative Pell, etc.) *)
pellsolWithStates[d_] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1,
   states = {{1, 0, -d, 1, 0, 0, 1, "Start", -d}}, path = {},
   intermediateSolutions = {}},
  While[t = a + b + b + c;
    If[t > 0,
      (* Right branch *)
      AppendTo[path, "R"];
      a = t; b += c; u += v; r += s,
      (* Left branch *)
      AppendTo[path, "L"];
      b += a; c = t; v += u; s += r
    ];

    (* Check invariant: a*c - b^2 should equal ±d *)
    Module[{norm = a*c - b^2},
      AppendTo[states, {a, b, c, u, v, r, s, path[[-1]], norm}];

      (* Detect intermediate solutions: *)
      (* When a=1, b=0, we have potential solution depending on c *)
      If[a == 1 && b == 0,
        If[c == d,
          (* Negative Pell: x² - d*y² = -1 *)
          AppendTo[intermediateSolutions, <|
            "type" -> "NegativePell",
            "solution" -> {x -> u, y -> r},
            "check" -> u^2 - d*r^2,
            "depth" -> Length[path],
            "path" -> path
          |>],
          If[c == -d,
            (* Back to start - this is the fundamental solution *)
            AppendTo[intermediateSolutions, <|
              "type" -> "Fundamental",
              "solution" -> {x -> u, y -> r},
              "check" -> u^2 - d*r^2,
              "depth" -> Length[path],
              "path" -> path
            |>]
          ]
        ]
      ];
    ];

    Not[a == 1 && b == 0 && c == -d]
  ];
  <|
    "solution" -> {x -> u, y -> r},
    "path" -> path,
    "states" -> states,
    "intermediateSolutions" -> intermediateSolutions,
    "invariant" -> (a*c - b^2 == -d) (* Should be true at each step *)
  |>
]

(* ======================================================================= *)
(* EXPLORATION: Connection to Primal Forest                               *)
(* ======================================================================= *)

(* Analyze path properties for range of d values *)
analyzePellPaths[dMax_] := Module[{results = {}},
  Do[
    If[!IntegerQ[Sqrt[d]], (* Skip perfect squares *)
      Module[{data = pellsolWithPath[d]},
        AppendTo[results, {
          d,
          x /. data["solution"],
          y /. data["solution"],
          data["length"],
          data["path"],
          data["palindrome"]
        }]
      ]
    ],
    {d, 2, dMax}
  ];
  results
]

(* Question 1: Is path length correlated with primality? *)
comparePathLengthPrimalityDistribution[dMax_] := Module[
  {data, primes, composites},
  data = analyzePellPaths[dMax];

  primes = Select[data, PrimeQ[#[[1]]] &];
  composites = Select[data, CompositeQ[#[[1]]] &];

  Print["=== Path Length vs. Primality ==="];
  Print["Prime d: mean path length = ", N[Mean[primes[[All, 4]]]]];
  Print["Composite d: mean path length = ", N[Mean[composites[[All, 4]]]]];
  Print[];

  Histogram[{primes[[All, 4]], composites[[All, 4]]},
    ChartLabels -> {"Prime d", "Composite d"},
    PlotLabel -> "Wildberger Path Length Distribution",
    ChartStyle -> {Blue, Orange}
  ]
]

(* Question 2: Relation to continued fraction period length *)
cfPeriodLength[d_] := Module[{cf},
  If[IntegerQ[Sqrt[d]], Return[0]];
  cf = ContinuedFraction[Sqrt[d], 1000];
  (* Find period in periodic part *)
  Length[cf[[2]]]
]

comparePathVsCFPeriod[dMax_] := Module[{data, cf, comparison},
  data = Select[analyzePellPaths[dMax], !IntegerQ[Sqrt[#[[1]]]] &];

  comparison = Table[
    {d, pellData[[4]], cfPeriodLength[d]},
    {d, data[[All, 1]]}, {pellData, Select[data, #[[1]] == d &]}
  ] // Flatten[#, 1] &;

  Print["=== Wildberger Path vs. CF Period ==="];
  Print["Correlation: ",
    Correlation[comparison[[All, 2]], comparison[[All, 3]]] // N];
  Print[];

  ListPlot[comparison[[All, {2, 3}]],
    AxesLabel -> {"Wildberger Path Length", "CF Period Length"},
    PlotLabel -> "Path Length vs. Continued Fraction Period",
    PlotStyle -> Red
  ]
]

(* Question 3: Analyze L/R pattern structure *)
analyzePathPatterns[dMax_] := Module[{data, patterns},
  data = analyzePellPaths[dMax];
  patterns = Tally[data[[All, 5]]]; (* Group by path sequence *)

  Print["=== Path Pattern Analysis ==="];
  Print["Total unique paths for d ∈ [2,", dMax, "]: ", Length[patterns]];
  Print["Most common paths:"];
  Print[Grid[Take[SortBy[patterns, -#[[2]] &], UpTo[10]],
    Frame -> All, Alignment -> Left]];
  Print[];

  (* Check palindrome property *)
  palindromeCount = Count[data[[All, 6]], True];
  Print["Palindromic paths: ", palindromeCount, " / ", Length[data],
    " (", N[100*palindromeCount/Length[data]], "%)"];
]

(* ======================================================================= *)
(* VISUALIZATION: Tree Structure                                          *)
(* ======================================================================= *)

(* Generate tree for specific d *)
pellTree[d_, maxDepth_: 10] := Module[
  {data = pellsolWithStates[d], edges = {}, labels = <||>, pos = <||>},

  Module[{states = data["states"], path = data["path"], depth = 0, nodeID = 1},
    (* Root node *)
    labels[1] = "Start\n(1,0," <> ToString[-d] <> ")";
    pos[1] = {0, 0};

    (* Build tree from path *)
    Do[
      Module[{parent = nodeID, child = nodeID + 1, branch = path[[i]]},
        AppendTo[edges, parent -> child];
        labels[child] = branch <> "\n" <>
          ToString[states[[i+1, {1,2,3}]]];

        (* Position: L goes left, R goes right *)
        pos[child] = pos[parent] + If[branch == "L", {-1, -1}, {1, -1}];
      ];
      nodeID++,
      {i, Min[Length[path], maxDepth]}
    ];
  ];

  Graph[edges,
    VertexLabels -> labels,
    VertexCoordinates -> Values[pos],
    PlotLabel -> "Wildberger Pell Tree for d=" <> ToString[d],
    ImageSize -> Large
  ]
]

(* ======================================================================= *)
(* CONNECTION TO PRIMAL FOREST: M(n) function                             *)
(* ======================================================================= *)

(* M(n) from primal forest: count of divisors in [2, √n] *)
MFunction[n_] := Count[Divisors[n], d_ /; 2 <= d <= Sqrt[n]]

(* Hypothesis: Is there relation between M(d) and Pell path length? *)
exploreMFunctionConnection[dMax_] := Module[{data, comparison},
  data = analyzePellPaths[dMax];

  comparison = Table[
    {d, MFunction[d], pellData[[4]]},
    {d, data[[All, 1]]}, {pellData, Select[data, #[[1]] == d &]}
  ] // Flatten[#, 1] &;

  Print["=== M(d) vs. Wildberger Path Length ==="];
  Print["M(d) = count of divisors in [2,√d]"];
  Print["Correlation: ",
    Correlation[comparison[[All, 2]], comparison[[All, 3]]] // N];
  Print[];

  ListPlot[comparison[[All, {2, 3}]],
    AxesLabel -> {"M(d)", "Path Length"},
    PlotLabel -> "Primal Forest M(d) vs. Pell Path Length",
    PlotStyle -> Green
  ]
]

(* ======================================================================= *)
(* INTERMEDIATE SOLUTIONS: Negative Pell and Tree Structure               *)
(* ======================================================================= *)

(* Analyze intermediate solutions (x² - d*y² = -1) *)
analyzeIntermediateSolutions[dMax_] := Module[
  {results = {}, hasNegPell = {}, noNegPell = {}},

  Do[
    If[!IntegerQ[Sqrt[d]],
      Module[{data = pellsolWithStates[d], intermed = <||>},
        intermed["d"] = d;
        intermed["fundamental"] = SelectFirst[
          data["intermediateSolutions"],
          #["type"] == "Fundamental" &,
          Missing[]
        ];
        intermed["negativePell"] = Select[
          data["intermediateSolutions"],
          #["type"] == "NegativePell" &
        ];

        If[Length[intermed["negativePell"]] > 0,
          AppendTo[hasNegPell, intermed],
          AppendTo[noNegPell, intermed]
        ];
        AppendTo[results, intermed]
      ]
    ],
    {d, 2, dMax}
  ];

  Print["=== Intermediate Solutions Analysis ==="];
  Print["d values with negative Pell solution: ", Length[hasNegPell],
    " / ", Length[results]];
  Print["d values WITHOUT negative Pell: ", Length[noNegPell]];
  Print[];

  (* Show examples *)
  Print["Examples with negative Pell (x² - d*y² = -1):"];
  Do[
    Module[{d = item["d"], negSol = First[item["negativePell"]],
            fundSol = item["fundamental"]},
      Print["  d=", d, ": "];
      Print["    Negative Pell at depth ", negSol["depth"], ": ",
        negSol["solution"], " (check: ", negSol["check"], ")"];
      Print["    Fundamental at depth ", fundSol["depth"], ": ",
        fundSol["solution"], " (check: ", fundSol["check"], ")"];
      Print["    Depth ratio: ", N[fundSol["depth"] / negSol["depth"]]]
    ],
    {item, Take[hasNegPell, UpTo[5]]}
  ];
  Print[];

  (* Key question: Is fundamental path exactly 2x negative Pell path? *)
  If[Length[hasNegPell] > 0,
    Module[{ratios},
      ratios = Table[
        item["fundamental"]["depth"] / First[item["negativePell"]]["depth"],
        {item, hasNegPell}
      ];
      Print["Depth ratio (Fundamental / NegativePell):"];
      Print["  Mean: ", N[Mean[ratios]]];
      Print["  All equal to 2? ", AllTrue[ratios, # == 2 &]];
      Print[]
    ]
  ];

  (* Distribution of d with/without negative Pell *)
  Print["Pattern in d values with negative Pell:"];
  Print["  ", hasNegPell[[All, "d"]] // Take[#, UpTo[30]] &];
  Print["Pattern in d values WITHOUT negative Pell:"];
  Print["  ", noNegPell[[All, "d"]] // Take[#, UpTo[30]] &];
  Print[];

  results
]

(* Visualize tree with intermediate solutions marked *)
pellTreeWithIntermediate[d_] := Module[
  {data = pellsolWithStates[d], edges = {}, labels = <||>,
   pos = <||>, colors = <||>},

  Module[{states = data["states"], path = data["path"], depth = 0, nodeID = 1,
          intermed = data["intermediateSolutions"]},

    (* Root node *)
    labels[1] = "Start\n(1,0," <> ToString[-d] <> ")";
    pos[1] = {0, 0};
    colors[1] = White;

    (* Build tree from path *)
    Do[
      Module[{parent = nodeID, child = nodeID + 1, branch = path[[i]],
              state = states[[i+1]], norm = state[[9]]},
        AppendTo[edges, parent -> child];

        (* Check if this is an intermediate solution *)
        Module[{isSpecial = False, specialType = ""},
          Do[
            If[sol["depth"] == i,
              isSpecial = True;
              specialType = sol["type"]
            ],
            {sol, intermed}
          ];

          labels[child] = branch <> "\n" <>
            ToString[state[[{1,2,3}]]] <> "\n" <>
            "norm=" <> ToString[norm] <>
            If[isSpecial, "\n★ " <> specialType, ""];

          colors[child] = If[isSpecial,
            If[specialType == "NegativePell", Yellow, Green],
            White
          ];
        ];

        (* Position: L goes left, R goes right *)
        pos[child] = pos[parent] + If[branch == "L", {-1, -1}, {1, -1}];
      ];
      nodeID++,
      {i, Length[path]}
    ];
  ];

  Graph[edges,
    VertexLabels -> labels,
    VertexCoordinates -> Values[pos],
    VertexStyle -> Thread[Keys[colors] -> Values[colors]],
    PlotLabel -> "Wildberger Tree d=" <> ToString[d] <>
      " (Yellow=NegPell, Green=Fundamental)",
    ImageSize -> Large
  ]
]

(* ======================================================================= *)
(* MAIN EXECUTION                                                          *)
(* ======================================================================= *)

Print["╔═══════════════════════════════════════════════════════════════╗"];
Print["║  Wildberger Pell Algorithm: Tree Structure Exploration       ║"];
Print["╚═══════════════════════════════════════════════════════════════╝"];
Print[];

(* Test original algorithm *)
Print["=== Testing Original Algorithm ==="];
Do[
  If[!IntegerQ[Sqrt[d]],
    Module[{sol = pellsol[d], x, y},
      x = x /. sol;
      y = y /. sol;
      Print["d=", d, ": (x,y) = (", x, ",", y, "), check: ",
        x^2 - d*y^2 == 1]
    ]
  ],
  {d, 2, 15}
];
Print[];

(* Analyze path structure *)
Print["=== Path Structure Analysis ==="];
sampleData = Table[
  If[!IntegerQ[Sqrt[d]], pellsolWithPath[d], Nothing],
  {d, 2, 20}
];

Print[Grid[
  Prepend[
    Table[{
      data["solution"][[1, 2]],
      data["solution"][[2, 2]],
      data["length"],
      StringJoin[data["path"]],
      data["palindrome"]
    }, {data, sampleData}],
    {"d", "x", "y", "Path Len", "L/R Sequence", "Palindrome?"}
  ],
  Frame -> All, Alignment -> Left
]];
Print[];

(* Run explorations *)
dMax = 100;
Print["Running explorations for d ≤ ", dMax, "..."];
Print[];

analyzePathPatterns[dMax];
Print[];

comparePathLengthPrimalityDistribution[dMax] // Print;
Print[];

comparePathVsCFPeriod[dMax] // Print;
Print[];

exploreMFunctionConnection[dMax] // Print;
Print[];

(* CRITICAL: Analyze intermediate solutions (negative Pell) *)
Print["=== INTERMEDIATE SOLUTIONS (Negative Pell x²-dy²=-1) ==="];
intermResults = analyzeIntermediateSolutions[dMax];
Print[];

(* Visualize specific examples with intermediate solutions *)
Print["=== Tree Visualizations (with intermediate solutions marked) ==="];
Print["Generating trees for d = 2, 5, 13 (examples with/without neg Pell)..."];
pellTreeWithIntermediate[2] // Print;
pellTreeWithIntermediate[5] // Print;
pellTreeWithIntermediate[13] // Print;

Print[];
Print["Analysis complete!"];
