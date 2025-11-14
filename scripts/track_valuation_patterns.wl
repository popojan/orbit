#!/usr/bin/env wolframscript
(* Valuation tracking for primorial conjecture - pattern discovery *)

(* Track p-adic valuation through partial sums *)
TrackValuation[m_, p_] := Module[{kMax, vals},
  kMax = Floor[(m-1)/2];
  vals = Table[
    Module[{partialSum, num, den},
      partialSum = 1/2 * Sum[(-1)^j * j! / (2j+1), {j, 1, k}];
      num = Numerator[partialSum];
      den = Denominator[partialSum];
      {k,
       IntegerExponent[den, p],
       IntegerExponent[num, p],
       IntegerExponent[den, p] - IntegerExponent[num, p],
       2*k+1  (* Include the denominator term for this k *)
      }
    ],
    {k, 1, kMax}
  ];
  vals
]

(* Extract just the jump points where ν_p(D_k) increases *)
ExtractJumpPoints[valuationData_] := Module[{jumps},
  jumps = Select[
    Table[
      If[i == 1 || valuationData[[i, 2]] > valuationData[[i-1, 2]],
        valuationData[[i]],
        Nothing
      ],
      {i, 1, Length[valuationData]}
    ],
    True &
  ];
  jumps
]

(* Find k-values where 2k+1 = p^j for j=1,2,3,... *)
PowerJumpIndices[p_, maxK_] := Module[{jumps},
  jumps = Table[
    Module[{k = (p^j - 1)/2},
      If[k <= maxK && IntegerQ[k], {k, j, p^j}, Nothing]
    ],
    {j, 1, Floor[Log[p, 2*maxK + 1]]}
  ];
  jumps
]

(* Comprehensive analysis for a prime across many terms *)
AnalyzePrimePattern[p_, maxM_] := Module[{data, jumps, kMax, powerJumps},
  kMax = Floor[(maxM - 1)/2];

  Print["Tracking prime p = ", p, " up to m = ", maxM, " (k_max = ", kMax, ")"];

  (* Full valuation tracking *)
  data = TrackValuation[maxM, p];

  (* Extract jump points *)
  jumps = ExtractJumpPoints[data];

  (* Find theoretical power jumps *)
  powerJumps = PowerJumpIndices[p, kMax];

  Print["Total terms tracked: ", Length[data]];
  Print["Number of jumps in ν_p(D_k): ", Length[jumps]];
  Print["Theoretical power jumps (2k+1 = p^j): ", Length[powerJumps]];
  Print[];

  <|
    "Prime" -> p,
    "MaxM" -> maxM,
    "MaxK" -> kMax,
    "FullData" -> data,
    "JumpPoints" -> jumps,
    "PowerJumps" -> powerJumps
  |>
]

(* Extract sequences for pattern finding *)
ExtractSequences[analysis_] := Module[{jumps, kSeq, nuDSeq, nuNSeq, diffSeq},
  jumps = analysis["JumpPoints"];
  kSeq = jumps[[All, 1]];
  nuDSeq = jumps[[All, 2]];
  nuNSeq = jumps[[All, 3]];
  diffSeq = jumps[[All, 4]];

  <|
    "k_values" -> kSeq,
    "nu_p(D_k)" -> nuDSeq,
    "nu_p(N_k)" -> nuNSeq,
    "Difference" -> diffSeq
  |>
]

(* Try to find patterns using Wolfram tools *)
FindPatterns[sequences_] := Module[{results},
  results = <||>;

  (* Try FindSequenceFunction on k-values of jumps *)
  If[Length[sequences["k_values"]] >= 3,
    results["k_sequence_formula"] =
      Quiet[FindSequenceFunction[sequences["k_values"], n]];
  ];

  (* Try FindLinearRecurrence on ν_p(D_k) at jumps *)
  If[Length[sequences["nu_p(D_k)"]] >= 4,
    results["nu_D_recurrence"] =
      Quiet[FindLinearRecurrence[sequences["nu_p(D_k)"]]];
  ];

  (* Try FindLinearRecurrence on ν_p(N_k) at jumps *)
  If[Length[sequences["nu_p(N_k)"]] >= 4,
    results["nu_N_recurrence"] =
      Quiet[FindLinearRecurrence[sequences["nu_p(N_k)"]]];
  ];

  (* Check if differences are constant *)
  results["differences_constant"] =
    Length[DeleteDuplicates[sequences["Difference"]]] == 1;

  results
]

(* Visualize the step function *)
PlotValuationEvolution[analysis_] := Module[{data, p},
  data = analysis["FullData"];
  p = analysis["Prime"];

  Grid[{
    {ListLinePlot[data[[All, {1, 2}]],
      PlotLabel -> "ν_" <> ToString[p] <> "(D_k)",
      AxesLabel -> {"k", "ν_p(D)"},
      PlotStyle -> Blue,
      Filling -> Axis]},
    {ListLinePlot[data[[All, {1, 3}]],
      PlotLabel -> "ν_" <> ToString[p] <> "(N_k)",
      AxesLabel -> {"k", "ν_p(N)"},
      PlotStyle -> Red,
      Filling -> Axis]},
    {ListLinePlot[data[[All, {1, 4}]],
      PlotLabel -> "ν_" <> ToString[p] <> "(D_k) - ν_" <> ToString[p] <> "(N_k)",
      AxesLabel -> {"k", "Difference"},
      PlotStyle -> Green,
      GridLines -> {None, {1}}]}
  }]
]

(* Main analysis function *)
AnalyzePrimeWithPatternDetection[p_, maxM_] := Module[{analysis, sequences, patterns},
  analysis = AnalyzePrimePattern[p, maxM];
  sequences = ExtractSequences[analysis];

  Print["Jump point k-values: ", sequences["k_values"]];
  Print["ν_p(D_k) at jumps: ", sequences["nu_p(D_k)"]];
  Print["ν_p(N_k) at jumps: ", sequences["nu_p(N_k)"]];
  Print["Differences: ", sequences["Difference"]];
  Print[];

  patterns = FindPatterns[sequences];

  Print["=== Pattern Detection Results ==="];
  Print["All differences equal 1? ", patterns["differences_constant"]];

  If[KeyExistsQ[patterns, "k_sequence_formula"],
    Print["k-value formula: ", patterns["k_sequence_formula"]];
  ];

  If[KeyExistsQ[patterns, "nu_D_recurrence"],
    Print["ν_p(D) recurrence: ", patterns["nu_D_recurrence"]];
  ];

  If[KeyExistsQ[patterns, "nu_N_recurrence"],
    Print["ν_p(N) recurrence: ", patterns["nu_N_recurrence"]];
  ];

  <|
    "Analysis" -> analysis,
    "Sequences" -> sequences,
    "Patterns" -> patterns
  |>
]

(* Example usage with enough data for pattern detection *)
(* For p=3, jumps at 2k+1 = 3^j means k = (3^j - 1)/2
   = 1, 4, 13, 40, 121, 364, 1093, 3280, ...
   To get ~10 jumps, need m > 6560 *)

Print["=== Prime p=3 (aim for ~10 jumps) ==="];
result3 = AnalyzePrimeWithPatternDetection[3, 20000];

Print["\n=== Prime p=5 (aim for ~8 jumps) ==="];
result5 = AnalyzePrimeWithPatternDetection[5, 20000];

Print["\n=== Prime p=7 (aim for ~7 jumps) ==="];
result7 = AnalyzePrimeWithPatternDetection[7, 20000];

(* Compare k-values where jumps occur across different primes *)
Print["\n=== Cross-prime comparison ==="];
Print["p=3 jumps at k: ", result3["Sequences"]["k_values"]];
Print["p=5 jumps at k: ", result5["Sequences"]["k_values"]];
Print["p=7 jumps at k: ", result7["Sequences"]["k_values"]];
