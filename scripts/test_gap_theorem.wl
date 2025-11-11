#!/usr/bin/env wolframscript
(* -*- mode: mathematica -*- *)

(* Parameterized Gap Theorem tester *)
(* Usage: wolframscript test_gap_theorem.wl <nmax> <testUpTo> *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

(* Parse command-line arguments *)
args = Rest[$ScriptCommandLine];
If[Length[args] < 2,
  Print["Usage: wolframscript test_gap_theorem.wl <nmax> <testUpTo> [outputFile]"];
  Print["  nmax: Generate sequences up to this value"];
  Print["  testUpTo: Test Gap Theorem for elements with value up to this"];
  Print["  outputFile: (optional) Output JSON file path"];
  Print[""];
  Print["Example: wolframscript test_gap_theorem.wl 100000 10000"];
  Print["Example: wolframscript test_gap_theorem.wl 100000 10000 results.json"];
  Exit[1];
];

nmax = ToExpression[args[[1]]];
testUpTo = ToExpression[args[[2]]];
outputFile = If[Length[args] >= 3,
  args[[3]],
  "reports/gap_test_" <> ToString[nmax] <> "_" <> ToString[testUpTo] <> ".json"
];

Print["=== GAP THEOREM TEST ==="];
Print[""];
Print["Configuration:"];
Print["  Generate sequences: up to ", nmax];
Print["  Test elements: with value ≤ ", testUpTo];
Print[""];

(* Abstract implementation *)
AbstractSparse[n_Integer, seq_List] := Module[{r = n, result = {}, s},
  While[r >= First[seq],
    s = SelectFirst[Reverse[seq], # <= r &, None];
    If[s === None, Break[]];
    AppendTo[result, s];
    r -= s
  ];
  Append[result, r]
]

AbstractOrbit[n_Integer, seq_List] := Module[{orbit = {}, queue = {n}, current, sparse, elems},
  While[queue != {},
    current = First[queue];
    queue = Rest[queue];
    If[current >= First[seq] && !MemberQ[orbit, current],
      sparse = AbstractSparse[current, seq];
      elems = Select[Most[sparse], MemberQ[seq, #] &];
      orbit = Union[orbit, elems];
      queue = Join[queue, FirstPosition[seq, #, {0}][[1]] & /@ elems];
    ];
  ];
  Sort[orbit]
]

(* Verify with progress *)
VerifyWithProgress[name_, seq_, maxTest_] := Module[{results, tested = 0, lastReport = 0, startTime, toTest},
  toTest = Count[seq, x_ /; x <= maxTest];
  startTime = AbsoluteTime[];

  Print["Testing ", name, " (", toTest, " elements)..."];

  results = Table[
    Module[{gap, nextElem, indices, checkElements, orbits, count},
      tested++;
      If[tested - lastReport >= 100,
        lastReport = tested;
        Print["  Progress: ", tested, "/", toTest, " (",
          Round[N[100 * tested / toTest]], "%)"];
      ];

      nextElem = SelectFirst[seq, # > s &, None];
      If[nextElem === None || s > maxTest,
        Nothing,
        gap = nextElem - s;
        indices = Range[s, s + gap];
        If[Max[indices] > Length[seq],
          Nothing,
          checkElements = seq[[#]] & /@ indices;
          orbits = AbstractOrbit[#, seq] & /@ checkElements;
          count = Length@Select[orbits, Length[#] >= 2 && #[[Length[#] - 1]] == s &];
          {s, gap, count, gap == count}
        ]
      ]
    ],
    {s, Select[seq, # <= maxTest &]}
  ];

  results = DeleteCases[results, Nothing];
  elapsed = AbsoluteTime[] - startTime;

  Print["  Completed: ", tested, " elements in ", Round[elapsed], "s"];
  Print["  Rate: ", Round[tested / elapsed], " elem/s"];
  Print[""];

  results
]

(* Generate sequences *)
Print["Generating sequences..."];

Print["  Primes..."];
primes = Select[Range[2, nmax], PrimeQ];
Print["    ", Length[primes], " elements, will test ", Count[primes, x_ /; x <= testUpTo]];

Print["  Semiprimes..."];
semiprimes = Select[Range[4, nmax], PrimeOmega[#] == 2 &];
Print["    ", Length[semiprimes], " elements, will test ", Count[semiprimes, x_ /; x <= testUpTo]];

Print["  3-almost primes..."];
almostPrimes3 = Select[Range[8, nmax], PrimeOmega[#] == 3 &];
Print["    ", Length[almostPrimes3], " elements, will test ", Count[almostPrimes3, x_ /; x <= testUpTo]];

Print["  4-almost primes..."];
almostPrimes4 = Select[Range[16, nmax], PrimeOmega[#] == 4 &];
Print["    ", Length[almostPrimes4], " elements, will test ", Count[almostPrimes4, x_ /; x <= testUpTo]];

Print[""];
Print["=== TESTING ==="];
Print[""];

(* Test *)
resultsPrimes = VerifyWithProgress["Primes", primes, testUpTo];
resultsSemi = VerifyWithProgress["Semiprimes", semiprimes, testUpTo];
resultsAlmost3 = VerifyWithProgress["3-almost primes", almostPrimes3, testUpTo];
resultsAlmost4 = VerifyWithProgress["4-almost primes", almostPrimes4, testUpTo];

(* Analyze *)
Print["=== RESULTS ==="];
Print[""];

AnalyzeResults[name_, results_] := Module[{violations, tested, passed},
  violations = Select[results, !Last[#] &];
  tested = Length[results];
  passed = tested - Length[violations];

  Print[name, ":"];
  Print["  Tested: ", tested];
  Print["  Passed: ", passed];
  Print["  Success: ", If[tested > 0, N[100 * passed / tested], 0], "%"];

  If[Length[violations] > 0,
    Print["  VIOLATIONS: ", Length[violations]];
    Print["  First 5:"];
    Do[Print["    ", v], {v, Take[violations, UpTo[5]]}];
  ,
    Print["  ✓ Gap Theorem holds 100%"];
  ];
  Print[""];

  <|
    "Name" -> name,
    "Generated" -> Length[Select[Range[2, nmax], Switch[name,
      "Primes", PrimeQ[#] &,
      "Semiprimes", PrimeOmega[#] == 2 &,
      "3-almost primes", PrimeOmega[#] == 3 &,
      "4-almost primes", PrimeOmega[#] == 4 &,
      _, False &
    ]]],
    "Tested" -> tested,
    "Passed" -> passed,
    "Violations" -> Length[violations],
    "Success%" -> If[tested > 0, N[100 * passed / tested], 0],
    "GapTheorem?" -> Length[violations] == 0 && tested > 0
  |>
]

summaryPrimes = AnalyzeResults["Primes", resultsPrimes];
summarySemi = AnalyzeResults["Semiprimes", resultsSemi];
summaryAlmost3 = AnalyzeResults["3-almost primes", resultsAlmost3];
summaryAlmost4 = AnalyzeResults["4-almost primes", resultsAlmost4];

summary = {summaryPrimes, summarySemi, summaryAlmost3, summaryAlmost4};

Print["=== SUMMARY ==="];
Print[""];
Print[Dataset[summary]];

(* Export *)
Export[outputFile, summary];
Print[""];
Print["Exported to ", outputFile];

Print[""];
Print["=== COMPLETE ==="];
