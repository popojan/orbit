#!/usr/bin/env wolframscript
(*
Compute fractal dimension of (n,d) space for pellc rational solutions
Question: Does D(N) ~ N^α for nd² - 1 = perfect square?
*)

Print[StringRepeat["=", 70]];
Print["FRACTAL DIMENSION: pellc Rational Solutions"];
Print[StringRepeat["=", 70]];
Print[];

(* Generate all rationals with denominator ≤ maxDenom *)
GenerateRationals[maxDenom_] := Module[{rats = {}},
  Do[
    Do[
      If[GCD[num, den] == 1 && num > 0,
        AppendTo[rats, num/den]
      ],
      {num, 1, 10 * den}  (* generous range for numerators *)
    ],
    {den, 1, maxDenom}
  ];
  DeleteDuplicates[rats]
]

(* Check if nd² - 1 is a perfect square *)
IsPerfectSquareDiscriminant[n_, d_] := Module[{disc, sqrtDisc},
  disc = n * d^2 - 1;
  If[disc < 0, Return[False]];
  sqrtDisc = Sqrt[disc];
  (IntegerQ[sqrtDisc] || Head[sqrtDisc] === Rational) && disc >= 0
]

(* Count pairs (n,d) with perfect square discriminant *)
CountPerfectSquarePairs[maxDenom_] := Module[{
    nVals, dVals, count = 0, pairs = {}
  },
  Print["Generating rationals with denom ≤ ", maxDenom, "..."];
  nVals = GenerateRationals[maxDenom];
  dVals = GenerateRationals[maxDenom];

  Print["Testing ", Length[nVals], " × ", Length[dVals], " = ",
    Length[nVals] * Length[dVals], " pairs..."];

  Do[
    Do[
      If[IsPerfectSquareDiscriminant[n, d],
        count++;
        If[maxDenom <= 20,  (* Only store for small N *)
          AppendTo[pairs, {n, d, n*d^2 - 1}]
        ];
      ],
      {d, dVals}
    ],
    {n, nVals}
  ];

  {count, pairs}
]

(* Main computation *)
Print["=== SMALL SCALE TEST (N ≤ 20) ==="];
Print[];

{count20, pairs20} = CountPerfectSquarePairs[20];

Print["Found ", count20, " pairs with perfect square discriminant"];
Print[];

If[Length[pairs20] > 0 && Length[pairs20] <= 100,
  Print["Example pairs (n, d, nd²-1):"];
  Print[StringRepeat["-", 70]];
  Do[
    {n, d, disc} = pair;
    Print["  (", n, ", ", d, ") → disc = ", disc, " = ", Sqrt[disc]^2];
    ,
    {pair, Take[pairs20, Min[30, Length[pairs20]]]}
  ];
  Print[];
];

Print[StringRepeat["=", 70]];
Print["=== SCALING ANALYSIS ==="];
Print[];

(* Test multiple scales *)
testSizes = {5, 7, 10, 12, 15, 18, 20, 25, 30};

Print["Computing D(N) for various N..."];
Print[];

scalingData = Table[
  Module[{count},
    Print["  N = ", N, "... "];
    {count, _} = CountPerfectSquarePairs[N];
    Print["D(", N, ") = ", count];
    {N, count}
  ],
  {N, testSizes}
];

Print[];
Print["Scaling data:"];
Print["N\tD(N)\tlog(N)\tlog(D(N))"];
Print[StringRepeat["-", 70]];

Do[
  {N, D} = data;
  If[D > 0,
    Print[N, "\t", D, "\t", N[Log[N], 6], "\t", N[Log[D], 6]]
  ],
  {data, scalingData}
];

Print[];

(* Fit power law *)
validData = Select[scalingData, Last[#] > 0 &];

If[Length[validData] >= 3,
  Module[{logData, fit, alpha, r2},
    logData = {Log[#[[1]]], Log[#[[2]]]} & /@ validData;
    fit = Fit[logData, {1, x}, x];
    alpha = Coefficient[fit, x];

    (* R² calculation *)
    Module[{yMean, ssTot, ssRes, predictions},
      yMean = Mean[logData[[All, 2]]];
      predictions = (fit /. x -> #) & /@ logData[[All, 1]];
      ssTot = Total[(# - yMean)^2 & /@ logData[[All, 2]]];
      ssRes = Total[(logData[[i, 2]] - predictions[[i]])^2, {i, Length[logData]}];
      r2 = 1 - ssRes/ssTot;

      Print[StringRepeat["=", 70]];
      Print["=== POWER LAW FIT ==="];
      Print[];
      Print["Model: D(N) ~ N^α"];
      Print[];
      Print["Fitted exponent α = ", N[alpha, 6]];
      Print["R² = ", N[r2, 6]];
      Print[];

      Print["Interpretation:"];
      Which[
        Abs[alpha - 2] < 0.1,
          Print["  α ≈ 2 → Dense in plane (trivial, full 2D measure)"],
        Abs[alpha - 1] < 0.1,
          Print["  α ≈ 1 → Curve-like structure (1D measure in 2D)"],
        1 < alpha < 2,
          Print["  α ∈ (1,2) → FRACTAL STRUCTURE! Hausdorff dim = ", N[alpha, 6]],
        alpha < 1,
          Print["  α < 1 → Sparse discrete set"],
        True,
          Print["  α = ", N[alpha, 6], " (unexpected value)"]
      ];

      Print[];

      (* Check for special values *)
      specialValues = {
        {1, "1 (curve)"},
        {N[GoldenRatio], "φ (golden ratio)"},
        {N[Sqrt[2]], "√2"},
        {N[E], "e"},
        {N[Pi/2], "π/2"},
        {3/2, "3/2"},
        {2, "2 (plane)"}
      };

      Print["Distance to special values:"];
      Do[
        {val, name} = spec;
        dist = Abs[alpha - val];
        If[dist < 0.05,
          Print["  ⭐ ", name, ": ", N[val, 6], " (Δ = ", N[dist, 4], ")"]
        ],
        {spec, specialValues}
      ];
    ];
  ],
  Print["Not enough data points for fitting."];
];

Print[];
Print[StringRepeat["=", 70]];
Print["=== CONCLUSIONS ==="];
Print[];

Print["1. Enumerated (n,d) pairs with nd²-1 = perfect square"];
Print["2. Counted D(N) = number of pairs with denom ≤ N"];
Print["3. Fitted power law D(N) ~ N^α"];
Print[];

If[Length[validData] >= 3,
  Module[{alpha},
    alpha = Coefficient[Fit[{Log[#[[1]]], Log[#[[2]]]} & /@ validData, {1, x}, x], x];

    Print["Next steps:"];
    If[1 < alpha < 2,
      Print["  ✓ FRACTAL DIMENSION DETECTED: α = ", N[alpha, 6]];
      Print["  → Compute larger N (50, 100) for precision"];
      Print["  → Separate primes vs composites"];
      Print["  → Theoretical explanation of fractal structure"];
      Print["  → Connection to Pell equation theory"];
    ];
    If[Abs[alpha - 1] < 0.15,
      Print["  ⚠ Nearly 1D structure (α ≈ 1)"];
      Print["  → Pairs lie approximately on curve");
      Print["  → Analyze which hyperbola nd² = k²+1 they follow"];
    ];
    If[Abs[alpha - 2] < 0.15,
      Print["  ⚠ Nearly dense (α ≈ 2)"];
      Print["  → May be trivial (all rationals work?)"];
      Print["  → Check discriminant distribution"];
    ];
  ]
];

Print[];
Print["Computation complete."];
Print[StringRepeat["=", 70]];
