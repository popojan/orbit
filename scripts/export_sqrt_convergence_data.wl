#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Export raw convergence data for sqrt methods *)

Print["=== EXPORTING SQRT CONVERGENCE DATA ===\n"];

<< Orbit`

(* ===================================================================
   CONFIGURATION
   =================================================================== *)

testNumbers = {2, 3, 5, 13};
kMaxBabylon = 10;
kMaxOther = 30;  (* Search range for equivalent k *)
m2MaxNested = 10;

outputFile = "sqrt_convergence_data.csv";

(* ===================================================================
   HELPER FUNCTIONS
   =================================================================== *)

ExtractApprox[result_Interval] := Mean[Normal[result]]
ExtractApprox[result_] := result

LogQuadraticError[target_, approx_] := Module[{err},
  err = Abs[target - approx^2];
  If[err == 0, -Infinity, Log10[N[err]]]
]

(* ===================================================================
   DATA COLLECTION
   =================================================================== *)

CollectConvergenceData[n_] := Module[{data, pell},
  Print["Collecting data for n=", n, "..."];
  pell = PellSolution[n];

  data = {};

  (* For each k_babylon, find equivalent k for other methods *)
  Do[
    Module[{errorBab, approxBab, kBinet, kEgypt, kSqrtRat, m2Nested},

      (* Babylonian reference *)
      approxBab = ExtractApprox[BabylonianSqrt[n, Floor[Sqrt[N[n]]], kBab]];
      errorBab = LogQuadraticError[n, approxBab];

      (* Find equivalent k for Binet *)
      kBinet = 0;
      Do[
        If[Abs[LogQuadraticError[n, ExtractApprox[BinetSqrt[n, Floor[Sqrt[N[n]]], k]]] - errorBab] < 0.5,
          kBinet = k; Break[]
        ],
        {k, 1, kMaxOther}
      ];

      (* Find equivalent k for Egypt *)
      kEgypt = 0;
      Do[
        If[Abs[LogQuadraticError[n, ExtractApprox[EgyptSqrt[n, {x, y} /. pell, k]]] - errorBab] < 0.5,
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

      (* Find equivalent m2 for NestedChebyshev *)
      m2Nested = 0;
      Do[
        If[Abs[LogQuadraticError[n, ExtractApprox[NestedChebyshevSqrt[n, {3, m2}, StartingPoint -> "Pell"]]] - errorBab] < 0.5,
          m2Nested = m2; Break[]
        ],
        {m2, 0, m2MaxNested}
      ];

      (* Append to data *)
      AppendTo[data, {n, kBab, kBinet, kEgypt, kSqrtRat, m2Nested, errorBab}];
    ],
    {kBab, 1, kMaxBabylon}
  ];

  data
]

(* ===================================================================
   MAIN EXPORT
   =================================================================== *)

allData = {};

Do[
  allData = Join[allData, CollectConvergenceData[n]],
  {n, testNumbers}
];

(* Add header *)
dataWithHeader = Prepend[allData,
  {"n", "k_babylon", "k_binet", "k_egypt", "k_sqrtrat", "m2_nested", "log10_error"}
];

(* Export to CSV *)
Export[outputFile, dataWithHeader];

Print["\nData exported to: ", outputFile];
Print["Rows: ", Length[allData]];
Print["\nSample data:"];
Print[Grid[Take[dataWithHeader, Min[10, Length[dataWithHeader]]]]];

(* ===================================================================
   QUICK ANALYSIS
   =================================================================== *)

Print["\n=== QUICK FITTING ANALYSIS ===\n"];

Do[
  Module[{subset, binetRatio, egyptRatio, sqrtratRatio, nestedRatio},
    subset = Select[allData, #[[1]] == n &];

    Print["n = ", n, ":"];

    (* Compute ratios k_method / k_babylon *)
    binetRatio = Mean[#[[3]]/#[[2]] & /@ Select[subset, #[[3]] > 0 &]];
    egyptRatio = Mean[#[[4]]/#[[2]] & /@ Select[subset, #[[4]] > 0 &]];
    sqrtratRatio = Mean[#[[5]]/#[[2]] & /@ Select[subset, #[[5]] > 0 &]];
    nestedRatio = Mean[#[[6]]/#[[2]] & /@ Select[subset, #[[6]] > 0 &]];

    Print["  k_binet / k_babylon    ≈ ", N[binetRatio, 3]];
    Print["  k_egypt / k_babylon    ≈ ", N[egyptRatio, 3]];
    Print["  k_sqrtrat / k_babylon  ≈ ", N[sqrtratRatio, 3]];
    Print["  m2_nested / k_babylon  ≈ ", N[nestedRatio, 3]];
    Print[];
  ],
  {n, testNumbers}
];

Print["=== EXPORT COMPLETE ==="];
Print["\nUse the CSV file for further analysis, plotting, or advanced fitting."];
