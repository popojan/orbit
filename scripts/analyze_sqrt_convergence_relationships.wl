#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Convergence Relationship Analysis for Sqrt Methods *)

Print["=== SQRT METHODS CONVERGENCE RELATIONSHIP ANALYSIS ===\n"];

(* Load Orbit paclet *)
<< Orbit`

(* ===================================================================
   HELPER FUNCTIONS
   =================================================================== *)

workingPrecision = 100;  (* Use 100-digit arithmetic throughout *)

(* Extract single approximation from Interval or Rational *)
ExtractApprox[result_Interval] := N[Mean[First[List @@ result]], workingPrecision]
ExtractApprox[result_?NumericQ] := N[result, workingPrecision]
ExtractApprox[result_] := N[result, workingPrecision]

(* Measure log10 quadratic error *)
LogQuadraticError[target_, approx_] := Module[{err},
  err = Abs[N[target, workingPrecision] - N[approx, workingPrecision]^2];
  If[err == 0, -Infinity, Log10[err]]
]

(* ===================================================================
   METHOD WRAPPERS - Unified interface
   =================================================================== *)

(* Helper: Extract Pell-based starting point (x-1)/y *)
PellStart[n_] := Module[{pell, pellValues},
  pell = PellSolution[n];
  pellValues = Values[Association @@ pell];
  N[(pellValues[[1]] - 1) / pellValues[[2]], workingPrecision]
]

(* Babylonian - REFERENCE METHOD *)
RunBabylonian[n_, k_] := Module[{result},
  result = BabylonianSqrt[n, PellStart[n], k];
  ExtractApprox[result]
]

(* Binet *)
RunBinet[n_, k_] := Module[{result},
  result = BinetSqrt[n, PellStart[n], k];
  ExtractApprox[result]
]

(* Egypt - requires Pell solution *)
RunEgypt[n_, k_] := Module[{result, pell, pellValues},
  pell = PellSolution[n];
  pellValues = Values[Association @@ pell];
  result = EgyptSqrt[n, pellValues, k];
  ExtractApprox[result]
]

(* Nested Chebyshev - general 2D version *)
RunNestedCheb[n_, {m1_, m2_}] := Module[{result},
  result = NestedChebyshevSqrt[n, {m1, m2}, StartingPoint -> "Pell"];
  ExtractApprox[result]
]

(* Convenience: m1=3 variant for backward compatibility *)
RunNestedCheb3[n_, m2_] := RunNestedCheb[n, {3, m2}]

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

(* Find k_method that gives same precision as kBabylonRef *)
FindEquivalentK[n_, kBabylonRef_, methodFunc_, kRange_] := Module[
  {targetError, errors, closest},

  (* Get target error from Babylon *)
  targetError = LogQuadraticError[n, RunBabylonian[n, kBabylonRef]];

  (* Compute errors for method across range *)
  errors = Table[
    {k, LogQuadraticError[n, methodFunc[n, k]]},
    {k, kRange}
  ];

  (* Find closest match *)
  closest = First[SortBy[errors, Abs[#[[2]] - targetError] &]];

  {kBabylonRef, closest[[1]], closest[[2]], targetError}
]

(* Find ALL equivalent {m1, m2} combinations for NestedChebyshev *)
FindEquivalentNestedParams[n_, kBabylonRef_, tolerance_: 0.5] := Module[
  {targetError, m1Range, m2Range, allCombos, matches},

  (* Get target error from Babylon *)
  targetError = LogQuadraticError[n, RunBabylonian[n, kBabylonRef]];

  (* Search parameter space *)
  m1Range = Range[1, 5];  (* m1 ∈ {1, 2, 3, 4, 5} *)
  m2Range = Range[0, 5];  (* m2 ∈ {0, 1, ..., 5} - reduced for performance *)

  (* Generate all combinations and filter matches *)
  allCombos = Flatten[Table[
    Module[{error, combo},
      combo = {m1, m2};
      error = LogQuadraticError[n, RunNestedCheb[n, combo]];
      If[Abs[error - targetError] < tolerance,
        {{m1, m2, error, Abs[error - targetError]}},
        {}
      ]
    ],
    {m1, m1Range}, {m2, m2Range}
  ], 1];

  (* Sort by closeness to target *)
  matches = SortBy[allCombos, #[[4]] &];

  {kBabylonRef, targetError, matches}
]

(* ===================================================================
   MAIN ANALYSIS
   =================================================================== *)

AnalyzeConvergenceRelationships[n_] := Module[{},
  Print["\n", StringRepeat["=", 70]];
  Print["ANALYZING n = ", n];
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

  Print["NestedChebyshev (m1=3, varying m2):"];
  Print["m2\tLog10 Quadratic Error"];
  Print[StringRepeat["-", 40]];
  Do[
    Print[m2, "\t", LogQuadraticError[n, RunNestedCheb3[n, m2]]],
    {m2, 0, 5}
  ];
  Print[];

  Print["NestedChebyshev (2D parameter space sample):"];
  Print["{m1,m2}\tLog10 Quadratic Error"];
  Print[StringRepeat["-", 40]];
  Do[
    Print["{", m1, ",", m2, "}\t", LogQuadraticError[n, RunNestedCheb[n, {m1, m2}]]],
    {m1, {1, 2, 3}}, {m2, {0, 1, 2, 3}}
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

  (* 2. FIND EQUIVALENT k VALUES (1D methods) *)
  Print["=== RELATIONSHIP TABLE (1D Methods) ===\n"];
  Print["For each k_babylon, find equivalent k for other methods:\n"];
  Print["k_babylon\tk_binet\tk_egypt\tk_sqrtrat\tPrecision (log10 err)"];
  Print[StringRepeat["-", 70]];

  Do[
    Module[{kBinet, kEgypt, kSqrtRat},
      (* Find equivalent k values *)
      kBinet = FindEquivalentK[n, kBab, RunBinet, Range[1, 60]][[2]];
      kEgypt = FindEquivalentK[n, kBab, RunEgypt, Range[1, 60]][[2]];
      kSqrtRat = FindEquivalentK[n, kBab, RunSqrtRat, Range[1, 60]][[2]];

      Print[kBab, "\t\t", kBinet, "\t", kEgypt, "\t", kSqrtRat,
            "\t\t", LogQuadraticError[n, RunBabylonian[n, kBab]]];
    ],
    {kBab, Range[1, 8]}
  ];
  Print["\n"];

  (* 3. 2D PARAMETER SPACE FOR NESTED CHEBYSHEV *)
  Print["=== 2D PARAMETER SPACE: NestedChebyshev ===\n"];
  Print["For each k_babylon, find ALL equivalent {m1, m2} combinations:\n"];

  Do[
    Module[{nestedResults},
      Print["  Searching for k_babylon = ", kBab, "..."];
      nestedResults = FindEquivalentNestedParams[n, kBab, 0.5];

      Print["k_babylon = ", kBab, " (target precision: ", nestedResults[[2]], ")"];
      Print["{m1, m2}\tLog10 Error\tDeviation"];
      Print[StringRepeat["-", 50]];

      If[Length[nestedResults[[3]]] > 0,
        Do[
          Module[{match},
            match = nestedResults[[3]][[i]];
            Print["{", match[[1]], ", ", match[[2]], "}\t",
                  N[match[[3]], 5], "\t\t", N[match[[4]], 5]];
          ],
          {i, 1, Min[10, Length[nestedResults[[3]]]]}  (* Show top 10 matches *)
        ],
        Print["No matches found within tolerance"]
      ];
      Print[];
    ],
    {kBab, Range[1, 8]}
  ];
  Print["\n"];

  (* 4. PARETO FRONTIER ANALYSIS *)
  Print["=== PARETO FRONTIER: Optimal {m1, m2} for each precision ===\n"];
  Print["For each k_babylon, find FASTEST {m1, m2} combination (assumes m1=1 fastest):\n"];

  Do[
    Module[{nestedResults, allMatches, optimal},
      nestedResults = FindEquivalentNestedParams[n, kBab, 0.5];
      allMatches = nestedResults[[3]];

      If[Length[allMatches] > 0,
        (* Find minimum m1 (fastest) *)
        optimal = First[SortBy[allMatches, {#[[1]] &, #[[2]] &}]];

        Print["k_babylon = ", kBab, ":"];
        Print["  Optimal: {m1=", optimal[[1]], ", m2=", optimal[[2]],
              "}, error=", N[optimal[[3]], 5]];
        Print["  Alternative combos with same precision: ", Length[allMatches] - 1];
      ];
    ],
    {kBab, Range[1, 8]}
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
      kBinet = FindEquivalentK[n, kBab, RunBinet, Range[1, 60]][[2]];
      kEgypt = FindEquivalentK[n, kBab, RunEgypt, Range[1, 60]][[2]];
      kSqrtRat = FindEquivalentK[n, kBab, RunSqrtRat, Range[1, 60]][[2]];
      {kBab, kBinet, kEgypt, kSqrtRat}
    ],
    {kBab, Range[1, 8]}
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
