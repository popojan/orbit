#!/usr/bin/env wolframscript
(*
Optimized fractal dimension computation using FareySequence
Much more efficient than naive rational generation
*)

Print[StringRepeat["=", 70]];
Print["FRACTAL DIMENSION: pellc (OPTIMIZED with FareySequence)"];
Print[StringRepeat["=", 70]];
Print[];

(* Check if nd² - 1 is a perfect square *)
IsPerfectSquare[disc_] := Module[{sqrtDisc},
  If[disc < 0, Return[False]];
  sqrtDisc = Sqrt[disc];
  (IntegerQ[sqrtDisc] || Head[sqrtDisc] === Rational) && disc >= 0
]

(* Count pairs using Farey sequence *)
CountPairsViaFarey[maxDenom_] := Module[{
    nVals, dVals, count = 0, pairs = {}, disc
  },
  (* Generate all rationals with denom ≤ maxDenom *)
  (* FareySequence gives 0..1, we need to extend *)

  nVals = Join[
    FareySequence[maxDenom],
    1 + FareySequence[maxDenom],
    2 + FareySequence[maxDenom],
    3 + FareySequence[maxDenom],
    4 + FareySequence[maxDenom],
    5 + FareySequence[maxDenom]
  ];
  nVals = DeleteDuplicates[Select[nVals, # > 0 &]];

  dVals = nVals;  (* Same set for d *)

  Print["Testing ", Length[nVals], " × ", Length[dVals], " pairs..."];

  Do[
    Do[
      disc = n * d^2 - 1;
      If[IsPerfectSquare[disc],
        count++;
        If[maxDenom <= 15 && Length[pairs] < 50,
          AppendTo[pairs, {n, d, disc}]
        ];
      ],
      {d, dVals}
    ],
    {n, nVals}
  ];

  {count, pairs}
]

(* Test small scale *)
Print["=== SMALL SCALE VERIFICATION ==="];
Print[];

{count10, pairs10} = CountPairsViaFarey[10];

Print["Found ", count10, " pairs with denom ≤ 10"];
Print[];

If[Length[pairs10] > 0,
  Print["Example pairs (first 20):"];
  Print["n\td\tnd²-1\t√(nd²-1)"];
  Print[StringRepeat["-", 60]];
  Do[
    {n, d, disc} = pair;
    Print[n, "\t", d, "\t", disc, "\t", Sqrt[disc]];
    ,
    {pair, Take[pairs10, Min[20, Length[pairs10]]]}
  ];
  Print[];
];

(* Scaling analysis *)
Print[StringRepeat["=", 70]];
Print["=== SCALING ANALYSIS ==="];
Print[];

testSizes = {5, 7, 10, 12, 15, 20, 25, 30, 35, 40};

scalingData = Table[
  Module[{count, time},
    Print["Computing D(", N, ")..."];
    time = AbsoluteTiming[
      {count, _} = CountPairsViaFarey[N];
    ][[1]];
    Print["  D(", N, ") = ", count, " (", N[time, 2], " sec)"];
    {N, count}
  ],
  {N, testSizes}
];

Print[];
Print["Results:"];
Print["N\tD(N)\tlog(N)\tlog(D(N))\tD(N)/N²"];
Print[StringRepeat["-", 70]];

Do[
  {N, D} = data;
  If[D > 0,
    Print[N, "\t", D, "\t", N[Log[N], 5], "\t", N[Log[D], 5], "\t", N[D/N^2, 5]]
  ],
  {data, scalingData}
];

Print[];

(* Power law fit *)
validData = Select[scalingData, Last[#] > 0 &];

If[Length[validData] >= 4,
  Module[{logData, fit, alpha, intercept, r2},
    logData = {Log[#[[1]]], Log[#[[2]]]} & /@ validData;
    fit = Fit[logData, {1, x}, x];
    alpha = Coefficient[fit, x];
    intercept = Coefficient[fit, x, 0];

    (* R² *)
    Module[{yMean, predictions, ssTot, ssRes},
      yMean = Mean[logData[[All, 2]]];
      predictions = (fit /. x -> #) & /@ logData[[All, 1]];
      ssTot = Total[(# - yMean)^2 & /@ logData[[All, 2]]];
      ssRes = Total[(logData[[i, 2]] - predictions[[i]])^2, {i, Length[logData]}];
      r2 = 1 - ssRes/ssTot;

      Print[StringRepeat["=", 70]];
      Print["=== POWER LAW FIT: D(N) ~ C·N^α ==="];
      Print[];
      Print["Fitted exponent: α = ", N[alpha, 8]];
      Print["Constant: C = ", N[Exp[intercept], 6]];
      Print["R² = ", N[r2, 8]];
      Print[];

      (* Also try D(N) ~ N² with constant *)
      Module[{ratios, meanRatio, stdRatio},
        ratios = (#[[2]]/#[[1]]^2) & /@ validData;
        meanRatio = Mean[ratios];
        stdRatio = StandardDeviation[ratios];

        Print["Alternative: D(N) ~ k·N²"];
        Print["  Mean k = ", N[meanRatio, 6]];
        Print["  Std dev = ", N[stdRatio, 6]];
        Print["  Coefficient of variation = ", N[stdRatio/meanRatio, 4]];

        If[stdRatio/meanRatio < 0.2,
          Print["  → Good N² scaling! (CV < 20%)"];
        ];
      ];

      Print[];
      Print["Interpretation:"];
      Which[
        Abs[alpha - 2] < 0.05,
          Print["  α ≈ 2.00 → QUADRATIC GROWTH (fills 2D space)"],
        2 < alpha < 2.5,
          Print["  α > 2 → Super-quadratic (possible log correction?)"],
        1.5 < alpha < 2,
          Print["  1.5 < α < 2 → FRACTAL STRUCTURE ⭐"],
        Abs[alpha - 1] < 0.1,
          Print["  α ≈ 1 → Linear (curve-like)"],
        True,
          Print["  α = ", N[alpha, 6], " (unexpected)"]
      ];

      Print[];
      Print["Special value distances:"];
      specialVals = {
        {2.0, "2 (plane)"},
        {N[GoldenRatio], "φ"},
        {N[Sqrt[3]], "√3"},
        {N[Sqrt[2]], "√2"},
        {1.5, "3/2"}
      };
      Do[
        {val, name} = spec;
        dist = Abs[alpha - val];
        If[dist < 0.1,
          Print["  ", name, ": Δ = ", N[dist, 5]]
        ],
        {spec, specialVals}
      ];
    ];
  ]
];

Print[];
Print[StringRepeat["=", 70]];
Print["COMPUTATION COMPLETE"];
Print[StringRepeat["=", 70]];
