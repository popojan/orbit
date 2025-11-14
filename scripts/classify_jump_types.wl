#!/usr/bin/env wolframscript
(* Classify jumps into Cases 2a, 2b, 2c from the proof approach *)

(* Load local Orbit paclet *)
PacletDirectoryLoad[FileNameJoin[{DirectoryName[$InputFileName], "..", "Orbit"}]];
<< Orbit`

Print["=== JUMP TYPE CLASSIFICATION ===\n"];

(* Classify a single jump *)
ClassifyJump[jumpData_, prevNuD_, prevNuN_, p_] := Module[{
  k, m, currNuD, currNuN, diff, alpha, nuK, term1Val, term2Val, jumpType, relation},

  {k, m, currNuD, currNuN, diff} = jumpData;
  alpha = currNuD - prevNuD; (* Jump size in denominator *)
  nuK = IntegerExponent[k!, p];

  (* Calculate the two term valuations *)
  term1Val = prevNuN + alpha;  (* ν_p(N_{k-1} * (2k+1)) *)
  term2Val = nuK + prevNuD;     (* ν_p(k! * D_{k-1}) *)

  (* Classify *)
  jumpType = Which[
    p == m, "Unsync",  (* Prime entry *)
    term1Val < term2Val, "2a",
    term1Val > term2Val, "2b",
    term1Val == term2Val, "2c"
  ];

  (* Check factorial relationship for Case 2b *)
  relation = If[jumpType == "2b", nuK == (alpha - 1), Null];

  {k, m, alpha, nuK, term1Val, term2Val, currNuN, jumpType, relation}
]

(* Analyze all jumps for a prime *)
AnalyzeJumpTypes[csvPath_, p_] := Module[{data, results, prevNuD, prevNuN, classified},
  Print["Prime p=", p];
  Print["Loading: ", csvPath];

  data = Import[csvPath];
  data = Rest[data]; (* Skip header *)

  (* Initialize valuations before first jump *)
  prevNuD = 0;
  prevNuN = 0;

  (* Classify each jump *)
  classified = Table[
    Module[{result, jumpData, currNuD, currNuN},
      jumpData = data[[i]];
      {_, _, currNuD, currNuN, _} = jumpData;

      result = ClassifyJump[jumpData, prevNuD, prevNuN, p];

      (* Update for next iteration *)
      prevNuD = currNuD;
      prevNuN = currNuN;

      result
    ],
    {i, 1, Length[data]}
  ];

  (* Count by type *)
  counts = <|
    "Unsync" -> Count[classified, {_, _, _, _, _, _, _, "Unsync", _}],
    "2a" -> Count[classified, {_, _, _, _, _, _, _, "2a", _}],
    "2b" -> Count[classified, {_, _, _, _, _, _, _, "2b", _}],
    "2c" -> Count[classified, {_, _, _, _, _, _, _, "2c", _}]
  |>;

  Print["Total jumps: ", Length[classified]];
  Print["Unsynchronized (p==m): ", counts["Unsync"]];
  Print["Case 2a (T1 < T2): ", counts["2a"]];
  Print["Case 2b (T1 > T2): ", counts["2b"]];
  Print["Case 2c (T1 = T2): ", counts["2c"]];

  (* Check factorial relationship in Case 2b *)
  case2b = Select[classified, #[[8]] == "2b" &];
  If[Length[case2b] > 0,
    relationHolds = Count[case2b, {_, _, _, _, _, _, _, _, True}];
    Print["Case 2b with ν_p(k!) = α-1: ", relationHolds, "/", Length[case2b]];
  ];

  (* Show first 20 jumps *)
  Print["\nFirst 20 jumps:"];
  Print["k\tm\tα\tν(k!)\tT1\tT2\tν(N)\tType\tRel"];
  Do[
    Module[{row = classified[[i]]},
      Print[row[[1]], "\t", row[[2]], "\t", row[[3]], "\t", row[[4]], "\t",
            row[[5]], "\t", row[[6]], "\t", row[[7]], "\t", row[[8]], "\t", row[[9]]]
    ],
    {i, 1, Min[20, Length[classified]]}
  ];
  Print[];

  <|"Prime" -> p, "Classified" -> classified, "Counts" -> counts|>
]

(* Run analysis *)
primes = {3, 5, 7, 11};
results = Table[
  csvPath = FileNameJoin[{DirectoryName[$InputFileName], "..", "reports",
    "hybrid_jumps_p" <> ToString[p] <> ".csv"}];
  AnalyzeJumpTypes[csvPath, p],
  {p, primes}
] // Association;

Print["=== OVERALL SUMMARY ==="];
totalCounts = <|
  "Unsync" -> Total[#["Counts"]["Unsync"] & /@ Values[results]],
  "2a" -> Total[#["Counts"]["2a"] & /@ Values[results]],
  "2b" -> Total[#["Counts"]["2b"] & /@ Values[results]],
  "2c" -> Total[#["Counts"]["2c"] & /@ Values[results]]
|>;

Print["Total across all primes:"];
Print["  Unsynchronized: ", totalCounts["Unsync"]];
Print["  Case 2a: ", totalCounts["2a"]];
Print["  Case 2b: ", totalCounts["2b"]];
Print["  Case 2c: ", totalCounts["2c"]];

Print["\n✓ Analysis complete"];
Print["✓ This reveals which proof case dominates"];
