#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Convergence Relationship Analysis for Sqrt Methods *)

Print["=== SQRT METHODS CONVERGENCE RELATIONSHIP ANALYSIS ===\n"];

(* Load Orbit paclet *)
<< Orbit`

(* ===================================================================
   HELPER FUNCTIONS
   =================================================================== *)

(* Extract single approximation from Interval or Rational *)
ExtractApprox[result_Interval] := Mean[Normal[result]]
ExtractApprox[result_] := result

(* Measure log10 quadratic error *)
LogQuadraticError[target_, approx_] := Module[{err},
  err = Abs[target - approx^2];
  If[err == 0, -Infinity, Log10[N[err]]]
]

(* ===================================================================
   METHOD WRAPPERS - Unified interface
   =================================================================== *)

(* Babylonian - REFERENCE METHOD *)
RunBabylonian[n_, k_] := Module[{result},
  result = BabylonianSqrt[n, Floor[Sqrt[N[n]]], k];
  ExtractApprox[result]
]

(* Binet *)
RunBinet[n_, k_] := Module[{result},
  result = BinetSqrt[n, Floor[Sqrt[N[n]]], k];
  ExtractApprox[result]
]

(* Egypt - requires Pell solution *)
RunEgypt[n_, k_] := Module[{result, pell},
  pell = PellSolution[n];
  result = EgyptSqrt[n, {x, y} /. pell, k];
  ExtractApprox[result]
]

(* Nested Chebyshev - using m1=3 (consistent order) *)
RunNestedCheb[n_, m2_] := Module[{result},
  result = NestedChebyshevSqrt[n, {3, m2}, StartingPoint -> "Pell"];
  ExtractApprox[result]
]

(* SqrtRationalization - original Pell+Chebyshev *)
RunSqrtRat[n_, k_] := Module[{result},
  result = SqrtRationalization[n, Method -> "Rational", Accuracy -> k];
  ExtractApprox[result]
]

(* ===================================================================
   CONVERGENCE PROFILING
   =================================================================== *)

ProfileMethod[methodName_, runFunc_, n_, kValues_] := Module[{results},
  results = Table[
    {k, LogQuadraticError[n, runFunc[n, k]]},
    {k, kValues}
  ];
  {methodName, results}
]

(* ===================================================================
   RELATIONSHIP FINDER
   =================================================================== *)

(* Find k_method that gives same precision as k_babylon_ref *)
FindEquivalentK[n_, k_babylon_ref_, methodFunc_, kRange_] := Module[
  {targetError, errors, closest},

  (* Get target error from Babylon *)
  targetError = LogQuadraticError[n, RunBabylonian[n, k_babylon_ref]];

  (* Compute errors for method across range *)
  errors = Table[
    {k, LogQuadraticError[n, methodFunc[n, k]]},
    {k, kRange}
  ];

  (* Find closest match *)
  closest = First[SortBy[errors, Abs[#[[2]] - targetError] &]];

  {k_babylon_ref, closest[[1]], closest[[2]], targetError}
]

(* ===================================================================
   MAIN ANALYSIS
   =================================================================== *)

AnalyzeConvergenceRelationships[n_] := Module[{},
  Print[StringRepeat["=", 70]];
  Print["Target: √", n, " = ", N[Sqrt[n], 20]];
  Print[StringRepeat["=", 70], "\n"];

  (* 1. PROFILE ALL METHODS *)
  Print["=== CONVERGENCE PROFILES ===\n"];

  Print["Babylonian (REFERENCE):"];
  Print["k\tLog10 Quadratic Error"];
  Print[StringRepeat["-", 40]];
  Do[
    Print[k, "\t", LogQuadraticError[n, RunBabylonian[n, k]]],
    {k, 1, 10}
  ];
  Print[];

  Print["Binet:"];
  Print["k\tLog10 Quadratic Error"];
  Print[StringRepeat["-", 40]];
  Do[
    Print[k, "\t", LogQuadraticError[n, RunBinet[n, k]]],
    {k, 1, 10}
  ];
  Print[];

  Print["Egypt:"];
  Print["k\tLog10 Quadratic Error"];
  Print[StringRepeat["-", 40]];
  Do[
    Print[k, "\t", LogQuadraticError[n, RunEgypt[n, k]]],
    {k, 1, 10}
  ];
  Print[];

  Print["NestedChebyshev (m1=3):"];
  Print["m2\tLog10 Quadratic Error"];
  Print[StringRepeat["-", 40]];
  Do[
    Print[m2, "\t", LogQuadraticError[n, RunNestedCheb[n, m2]]],
    {m2, 0, 5}
  ];
  Print[];

  Print["SqrtRationalization (Pell+Chebyshev):"];
  Print["k\tLog10 Quadratic Error"];
  Print[StringRepeat["-", 40]];
  Do[
    Print[k, "\t", LogQuadraticError[n, RunSqrtRat[n, k]]],
    {k, 1, 10}
  ];
  Print["\n"];

  (* 2. FIND EQUIVALENT k VALUES *)
  Print["=== RELATIONSHIP TABLE ===\n"];
  Print["For each k_babylon, find equivalent k for other methods:\n"];
  Print["k_babylon\tk_binet\tk_egypt\tk_sqrtrat\tm2_nested\tPrecision (log10 err)"];
  Print[StringRepeat["-", 80]];

  Do[
    Module[{kBinet, kEgypt, kSqrtRat, m2Nested},
      (* Find equivalent k values *)
      kBinet = FindEquivalentK[n, kBab, RunBinet, Range[1, 20]][[2]];
      kEgypt = FindEquivalentK[n, kBab, RunEgypt, Range[1, 20]][[2]];
      kSqrtRat = FindEquivalentK[n, kBab, RunSqrtRat, Range[1, 20]][[2]];
      m2Nested = FindEquivalentK[n, kBab, RunNestedCheb, Range[0, 10]][[2]];

      Print[kBab, "\t\t", kBinet, "\t", kEgypt, "\t", kSqrtRat, "\t\t", m2Nested,
            "\t\t", LogQuadraticError[n, RunBabylonian[n, kBab]]];
    ],
    {kBab, {1, 2, 3, 5, 8}}
  ];
  Print["\n"];
]

(* ===================================================================
   FITTING ANALYSIS
   =================================================================== *)

FitRelationships[n_] := Module[{dataPoints, fit},
  Print["=== RELATIONSHIP FITTING ===\n"];
  Print["Fitting k_method = f(k_babylon) relationships...\n"];

  (* Collect data points for fitting *)
  dataPoints = Table[
    Module[{kBinet, kEgypt, kSqrtRat},
      kBinet = FindEquivalentK[n, kBab, RunBinet, Range[1, 30]][[2]];
      kEgypt = FindEquivalentK[n, kBab, RunEgypt, Range[1, 30]][[2]];
      kSqrtRat = FindEquivalentK[n, kBab, RunSqrtRat, Range[1, 30]][[2]];
      {kBab, kBinet, kEgypt, kSqrtRat}
    ],
    {kBab, Range[1, 10]}
  ];

  Print["Data points (k_babylon, k_binet, k_egypt, k_sqrtrat):"];
  Print[Grid[Prepend[dataPoints, {"k_bab", "k_binet", "k_egypt", "k_sqrtrat"}]]];
  Print[];

  (* Try linear fits *)
  Print["Linear fits (k_method ≈ a*k_babylon + b):\n"];

  Module[{binetData, egyptData, sqrtratData, binetFit, egyptFit, sqrtratFit},
    binetData = {#[[1]], #[[2]]} & /@ dataPoints;
    egyptData = {#[[1]], #[[3]]} & /@ dataPoints;
    sqrtratData = {#[[1]], #[[4]]} & /@ dataPoints;

    binetFit = Fit[binetData, {1, x}, x];
    egyptFit = Fit[egyptData, {1, x}, x];
    sqrtratFit = Fit[sqrtratData, {1, x}, x];

    Print["k_binet    ≈ ", binetFit];
    Print["k_egypt    ≈ ", egyptFit];
    Print["k_sqrtrat  ≈ ", sqrtratFit];
  ];
  Print[];
]

(* ===================================================================
   RUN ANALYSIS
   =================================================================== *)

(* Test for multiple values *)
Do[
  AnalyzeConvergenceRelationships[n];
  FitRelationships[n];
  Print[StringRepeat["=", 70], "\n\n"];
  ,
  {n, {2, 5, 13}}
]

Print["=== RECOMMENDATIONS ===\n"];
Print["Based on fitted relationships, use these conversion rules:"];
Print["  k_binet    = f_binet(k_babylon)    (see fits above)"];
Print["  k_egypt    = f_egypt(k_babylon)    (see fits above)"];
Print["  k_sqrtrat  = f_sqrtrat(k_babylon)  (see fits above)"];
Print["  m2_nested  = f_nested(k_babylon)   (fit separately)"];
Print[];
Print["These relationships allow comparing methods at equivalent precision levels."];
Print[];
Print["=== ANALYSIS COMPLETE ==="];
