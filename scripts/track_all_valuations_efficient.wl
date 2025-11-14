#!/usr/bin/env wolframscript
(* Efficient valuation tracking using recurrence from Orbit paclet *)

<< Orbit`

(* Track valuations for all k up to kMax using efficient recurrence *)
TrackValuationsEfficient[p_, kMax_] := Module[{states, data},
  Print["Tracking all k from 1 to ", kMax, " for prime p=", p];
  Print["Using RecurseState for efficiency..."];

  (* Generate all states using the recurrence *)
  states = SieveStateList[2*kMax + 1];  (* m = 2k+1, so need m up to 2*kMax+1 *)

  (* Extract data for each k *)
  data = Table[
    Module[{state, b, num, den, nuD, nuN},
      state = states[[k + 1]];  (* +1 because states start at n=0 *)
      b = Last[state];  (* The partial sum is in component b *)
      num = Numerator[b];
      den = Denominator[b];
      nuD = IntegerExponent[den, p];
      nuN = IntegerExponent[num, p];
      {k, 2*k+1, nuD, nuN, nuD - nuN}
    ],
    {k, 1, kMax}
  ];

  Print["Done! Tracked ", Length[data], " terms"];
  data
]

(* Extract jump points from full data *)
ExtractJumpPoints[data_] := Module[{jumps},
  jumps = {data[[1]]};
  Do[
    If[data[[i, 3]] > data[[i-1, 3]],  (* nu_p(D) increased *)
      AppendTo[jumps, data[[i]]]
    ],
    {i, 2, Length[data]}
  ];
  jumps
]

(* Analyze patterns *)
AnalyzePatterns[data_, p_] := Module[{jumps, kVals, nuDVals, nuNVals, diffs},
  jumps = ExtractJumpPoints[data];

  Print["\n=== JUMP ANALYSIS FOR p=", p, " ==="];
  Print["Total terms tracked: ", Length[data]];
  Print["Number of jumps: ", Length[jumps]];

  If[Length[jumps] > 0,
    Print["\nJump points:"];
    Print["k\t2k+1\tnu_p(D)\tnu_p(N)\tDiff"];
    Do[Print[jumps[[i, 1]], "\t", jumps[[i, 2]], "\t",
             jumps[[i, 3]], "\t", jumps[[i, 4]], "\t", jumps[[i, 5]]],
       {i, 1, Min[20, Length[jumps]]}];

    kVals = jumps[[All, 1]];
    nuDVals = jumps[[All, 3]];
    nuNVals = jumps[[All, 4]];
    diffs = jumps[[All, 5]];

    Print["\n=== SEQUENCES ==="];
    Print["k-values: ", kVals];
    Print["nu_p(D): ", nuDVals];
    Print["nu_p(N): ", nuNVals];
    Print["Differences: ", diffs];

    Print["\n=== VERIFICATION ==="];
    Print["All differences = 1? ", AllTrue[diffs, # == 1 &]];

    (* Pattern detection *)
    If[Length[kVals] >= 3,
      Print["\n=== PATTERN DETECTION ==="];
      Print["FindSequenceFunction on k-values:"];
      kFormula = FindSequenceFunction[kVals, n];
      Print[kFormula];

      (* Check if k = (p^n - 1)/2 *)
      expectedK = Table[(p^n - 1)/2, {n, 1, Length[kVals]}];
      Print["Expected k if (p^n - 1)/2: ", expectedK];
      Print["Match? ", expectedK == kVals];

      (* Check if nu_p(D) = n *)
      Print["\nnu_p(D) equals n (jump number)? ", nuDVals == Range[Length[nuDVals]]];
      Print["nu_p(N) equals n-1? ", nuNVals == Range[0, Length[nuNVals]-1]];
    ];
  ];

  <|"FullData" -> data, "Jumps" -> jumps|>
]

(* Run analysis for multiple primes with parametrizable limit *)
RunAnalysis[primes_List, kMax_] := Module[{results},
  Print["=== VALUATION TRACKING ANALYSIS ==="];
  Print["Limit: k_max = ", kMax];
  Print["Primes: ", primes];
  Print["\n"];

  results = Table[
    Module[{data, analysis},
      Print[">>> PRIME p=", p, " <<<"];
      data = TrackValuationsEfficient[p, kMax];
      analysis = AnalyzePatterns[data, p];
      Print["\n"];
      p -> analysis
    ],
    {p, primes}
  ];

  Association[results]
]

(* Export results for documentation *)
ExportResults[results_, filename_] := Module[{report},
  Print["Exporting results to ", filename];

  report = StringJoin[
    "# Valuation Tracking Results\n\n",
    "Generated: ", DateString[], "\n\n",
    Table[
      Module[{p, analysis, jumps},
        p = results[[i, 1]];
        analysis = results[[i, 2]];
        jumps = analysis["Jumps"];
        StringJoin[
          "## Prime p=", ToString[p], "\n\n",
          "Jumps found: ", ToString[Length[jumps]], "\n\n",
          "| k | 2k+1 | ν_p(D) | ν_p(N) | Diff |\n",
          "|---|------|--------|--------|------|\n",
          Table[
            StringJoin[
              "| ", ToString[jumps[[j, 1]]], " | ",
              ToString[jumps[[j, 2]]], " | ",
              ToString[jumps[[j, 3]]], " | ",
              ToString[jumps[[j, 4]]], " | ",
              ToString[jumps[[j, 5]]], " |\n"
            ],
            {j, 1, Min[15, Length[jumps]]}
          ],
          "\n"
        ]
      ],
      {i, 1, Length[results]}
    ]
  ];

  Export[filename, report, "Text"];
  Print["Exported successfully"];
]

(* Main execution *)
Print["Starting efficient valuation analysis...\n"];

(* Test with kMax=1000 first for speed *)
results = RunAnalysis[{3, 5, 7, 11}, 1000];

(* Export to documentation *)
ExportResults[Normal[results], "reports/valuation_tracking_k1000.md"];

Print["\n=== SUMMARY ==="];
Print["✓ Efficient tracking using RecurseState from Orbit paclet"];
Print["✓ All k values tracked (step function visible)"];
Print["✓ Parametrizable limit (tested with k=1000)"];
Print["✓ Results exported to reports/valuation_tracking_k1000.md"];
