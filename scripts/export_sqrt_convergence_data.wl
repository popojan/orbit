#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Export raw convergence data for sqrt methods *)

Print["=== EXPORTING SQRT CONVERGENCE DATA ===\n"];

<< Orbit`

(* ===================================================================
   CONFIGURATION
   =================================================================== *)

testNumbers = {2, 3, 5, 13};
kMaxBabylon = 12;  (* Quadratic convergence: k=12 reaches ~10^-800 with 1000-digit precision *)
kMaxOther = 200;   (* Search range for equivalent k - linear methods need exponentially more *)
m1Range = Range[1, 5];  (* m1 ∈ {1, 2, 3, 4, 5} *)
m2Range = Range[0, 8];  (* m2 ∈ {0..8} - increased for better NestedChebyshev analysis *)

outputFile = "reports/sqrt_convergence/sqrt_convergence_data.csv";
outputFile2D = "reports/sqrt_convergence/sqrt_convergence_2d_nested.csv";

(* ===================================================================
   HELPER FUNCTIONS
   =================================================================== *)

workingPrecision = 1000;  (* Use 1000-digit arithmetic for ultra-precision analysis *)

ExtractApprox[result_Interval] := N[Mean[First[List @@ result]], workingPrecision]
ExtractApprox[result_?NumericQ] := N[result, workingPrecision]
ExtractApprox[result_] := N[result, workingPrecision]

LogQuadraticError[target_, approx_] := Module[{err},
  err = Abs[N[target, workingPrecision] - N[approx, workingPrecision]^2];
  If[err == 0, -Infinity, Log10[err]]
]

(* Helper: Extract Pell-based starting point (x-1)/y *)
PellStart[n_] := Module[{pell, pellValues},
  pell = PellSolution[n];
  pellValues = Values[Association @@ pell];
  N[(pellValues[[1]] - 1) / pellValues[[2]], workingPrecision]
]

(* ===================================================================
   DATA COLLECTION
   =================================================================== *)

(* Collect 1D method relationships *)
CollectConvergenceData[n_] := Module[{data, pell},
  Print["Collecting 1D method data for n=", n, "..."];
  pell = PellSolution[n];

  data = {};

  (* For each k_babylon, find equivalent k for other methods *)
  Do[
    Module[{errorBab, approxBab, kBinet, kEgypt, kSqrtRat},

      (* Babylonian reference *)
      approxBab = ExtractApprox[BabylonianSqrt[n, PellStart[n], kBab]];
      errorBab = LogQuadraticError[n, approxBab];

      (* Find equivalent k for Binet *)
      kBinet = 0;
      Do[
        If[Abs[LogQuadraticError[n, ExtractApprox[BinetSqrt[n, PellStart[n], k]]] - errorBab] < 0.5,
          kBinet = k; Break[]
        ],
        {k, 1, kMaxOther}
      ];

      (* Find equivalent k for Egypt *)
      kEgypt = 0;
      Do[
        If[Abs[LogQuadraticError[n, ExtractApprox[EgyptSqrt[n, Values[Association @@ pell], k]]] - errorBab] < 0.5,
          kEgypt = k; Break[]
        ],
        {k, 1, kMaxOther}
      ];

      (* Find equivalent k for SqrtRationalization *)
      kSqrtRat = 0;
      Do[
        If[Abs[LogQuadraticError[n, ExtractApprox[SqrtRationalization[n, Method -> "Rational", Accuracy -> k]]] - errorBab] < 0.5,
          kSqrtRat = k; Break[]
        ],
        {k, 1, kMaxOther}
      ];

      (* Append to data *)
      AppendTo[data, {n, kBab, kBinet, kEgypt, kSqrtRat, errorBab}];
    ],
    {kBab, 1, kMaxBabylon}
  ];

  data
]

(* Collect 2D NestedChebyshev parameter space *)
Collect2DNestedData[n_] := Module[{data, pell},
  Print["Collecting 2D NestedChebyshev data for n=", n, "..."];
  pell = PellSolution[n];

  data = {};

  (* For each k_babylon, find ALL equivalent {m1, m2} combinations *)
  Do[
    Module[{errorBab, approxBab, tolerance, matches, startTime},
      startTime = AbsoluteTime[];
      Print["  k_babylon=", kBab, "/", kMaxBabylon, " (testing ", Length[m1Range]*Length[m2Range], " {m1,m2} combinations)..."];

      (* Babylonian reference *)
      approxBab = ExtractApprox[BabylonianSqrt[n, PellStart[n], kBab]];
      errorBab = LogQuadraticError[n, approxBab];
      tolerance = 0.5;

      (* Search all {m1, m2} combinations *)
      matches = {};
      Do[
        Module[{errorNested, approxNested},
          approxNested = ExtractApprox[NestedChebyshevSqrt[n, {m1, m2}, StartingPoint -> "Pell"]];
          errorNested = LogQuadraticError[n, approxNested];

          If[Abs[errorNested - errorBab] < tolerance,
            AppendTo[matches, {m1, m2, errorNested, Abs[errorNested - errorBab]}]
          ];
        ],
        {m1, m1Range}, {m2, m2Range}
      ];

      (* Append all matches (one row per match) *)
      Do[
        AppendTo[data, {n, kBab, matches[[i, 1]], matches[[i, 2]], errorBab, matches[[i, 3]], matches[[i, 4]]}],
        {i, 1, Length[matches]}
      ];

      Print["    → Found ", Length[matches], " matches, time: ", Round[AbsoluteTime[] - startTime, 0.1], "s"];
    ],
    {kBab, 1, kMaxBabylon}
  ];

  data
]

(* ===================================================================
   MAIN EXPORT
   =================================================================== *)

(* Export 1: 1D methods *)
allData1D = {};
Do[
  allData1D = Join[allData1D, CollectConvergenceData[n]],
  {n, testNumbers}
];

dataWithHeader1D = Prepend[allData1D,
  {"n", "k_babylon", "k_binet", "k_egypt", "k_sqrtrat", "log10_error"}
];

Export[outputFile, dataWithHeader1D];
Print["\n1D methods data exported to: ", outputFile];
Print["Rows: ", Length[allData1D]];

(* Export 2: 2D NestedChebyshev *)
allData2D = {};
Do[
  allData2D = Join[allData2D, Collect2DNestedData[n]],
  {n, testNumbers}
];

dataWithHeader2D = Prepend[allData2D,
  {"n", "k_babylon", "m1", "m2", "babylon_log10_error", "nested_log10_error", "deviation"}
];

Export[outputFile2D, dataWithHeader2D];
Print["\n2D NestedChebyshev data exported to: ", outputFile2D];
Print["Rows: ", Length[allData2D]];

Print["\n=== SAMPLE DATA ===\n"];
Print["1D Methods (first 10 rows):"];
Print[Grid[Take[dataWithHeader1D, Min[10, Length[dataWithHeader1D]]]]];
Print["\n2D NestedChebyshev (first 10 rows):"];
Print[Grid[Take[dataWithHeader2D, Min[10, Length[dataWithHeader2D]]]]];

(* ===================================================================
   QUICK ANALYSIS
   =================================================================== *)

Print["\n=== QUICK FITTING ANALYSIS (1D Methods) ===\n"];

Do[
  Module[{subset, binetRatio, egyptRatio, sqrtratRatio},
    subset = Select[allData1D, #[[1]] == n &];

    Print["n = ", n, ":"];

    (* Compute ratios k_method / k_babylon *)
    binetRatio = Mean[#[[3]]/#[[2]] & /@ Select[subset, #[[3]] > 0 &]];
    egyptRatio = Mean[#[[4]]/#[[2]] & /@ Select[subset, #[[4]] > 0 &]];
    sqrtratRatio = Mean[#[[5]]/#[[2]] & /@ Select[subset, #[[5]] > 0 &]];

    Print["  k_binet / k_babylon    ≈ ", N[binetRatio, 3]];
    Print["  k_egypt / k_babylon    ≈ ", N[egyptRatio, 3]];
    Print["  k_sqrtrat / k_babylon  ≈ ", N[sqrtratRatio, 3]];
    Print[];
  ],
  {n, testNumbers}
];

Print["=== 2D NESTED STATISTICS ===\n"];

Do[
  Module[{subset, countByK},
    subset = Select[allData2D, #[[1]] == n &];

    Print["n = ", n, ":"];
    Print["  Total {m1, m2} matches: ", Length[subset]];

    (* Count matches per k_babylon *)
    countByK = Table[
      {kBab, Length[Select[subset, #[[2]] == kBab &]]},
      {kBab, 1, kMaxBabylon}
    ];

    Print["  Matches per k_babylon: ", countByK];
    Print[];
  ],
  {n, testNumbers}
];

Print["=== PARETO FRONTIER ANALYSIS ===\n"];

Do[
  Module[{subset, paretoData},
    subset = Select[allData2D, #[[1]] == n &];

    Print["n = ", n, ":"];
    Print["k_babylon\tOptimal {m1,m2}\tlog10_error\tAlternatives"];
    Print[StringRepeat["-", 60]];

    (* For each k_babylon, find minimum m1 (fastest) *)
    Do[
      Module[{matches, optimal},
        matches = Select[subset, #[[2]] == kBab &];

        If[Length[matches] > 0,
          (* Sort by m1 (primary), then m2 (secondary) *)
          optimal = First[SortBy[matches, {#[[3]] &, #[[4]] &}]];

          Print[kBab, "\t\t{", optimal[[3]], ",", optimal[[4]], "}\t\t",
                N[optimal[[6]], 5], "\t\t", Length[matches] - 1];
        ];
      ],
      {kBab, 1, kMaxBabylon}
    ];
    Print[];
  ],
  {n, testNumbers}
];

Print["=== EXPORT COMPLETE ==="];
Print["\nFiles generated:"];
Print["  ", outputFile, " - 1D method relationships"];
Print["  ", outputFile2D, " - 2D NestedChebyshev parameter space"];
Print["\nPareto frontier: Use 2D data to identify fastest {m1,m2} for each precision level."];
Print["Assumption: Lower m1 = faster (based on optimization notes in usage string)"];
