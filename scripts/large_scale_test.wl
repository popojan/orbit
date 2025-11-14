#!/usr/bin/env wolframscript

(* LARGE SCALE GAP THEOREM TEST - n=100,000 *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== LARGE SCALE GAP THEOREM TEST (n=100,000) ==="];
Print[""];

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

VerifyAbstractGapTheorem[seq_List, maxTest_] := Module[{results, tested = 0},
  results = Table[
    Module[{gap, nextElem, indices, checkElements, orbits, count},
      tested++;
      If[Mod[tested, 100] == 0, Print["  Progress: ", tested, " elements tested"]];

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
  DeleteCases[results, Nothing]
]

(* Generate sequences up to 100,000 *)
nmax = 100000;
testUpTo = 1000;  (* Test elements with value ≤ 1000 *)

Print["Generating sequences up to n=", nmax, "..."];
Print["Will test Gap Theorem for elements with value ≤ ", testUpTo];
Print[""];

(* Use prime counting for sizing *)
Print["Generating primes..."];
primes = Select[Range[2, nmax], PrimeQ];
Print["  Primes: ", Length[primes], " elements"];

Print["Generating semiprimes..."];
semiprimes = Select[Range[4, nmax], PrimeOmega[#] == 2 &];
Print["  Semiprimes: ", Length[semiprimes], " elements"];

Print["Generating 3-almost primes..."];
almostPrimes3 = Select[Range[8, nmax], PrimeOmega[#] == 3 &];
Print["  3-almost primes: ", Length[almostPrimes3], " elements"];

Print["Generating 4-almost primes..."];
almostPrimes4 = Select[Range[16, nmax], PrimeOmega[#] == 4 &];
Print["  4-almost primes: ", Length[almostPrimes4], " elements"];

Print[""];

(* Compute and plot densities *)
Print["=== DENSITY ANALYSIS ==="];
Print[""];

checkpoints = {100, 500, 1000, 5000, 10000, 50000, 100000};

ComputeDensities[seq_, name_] := Module[{densities},
  densities = Table[
    {n, N[Count[seq, x_ /; x <= n] / n]},
    {n, checkpoints}
  ];
  Print[name, ":"];
  Do[Print["  n=", d[[1]], ": ", d[[2]]], {d, densities}];
  Print[""];
  densities
]

densPrimes = ComputeDensities[primes, "Primes"];
densSemi = ComputeDensities[semiprimes, "Semiprimes"];
densAlmost3 = ComputeDensities[almostPrimes3, "3-almost"];
densAlmost4 = ComputeDensities[almostPrimes4, "4-almost"];

(* Export density plot data *)
densityData = <|
  "Primes" -> densPrimes,
  "Semiprimes" -> densSemi,
  "3-almost" -> densAlmost3,
  "4-almost" -> densAlmost4
|>;

Export["reports/density_curves.json", densityData];
Print["Exported density data to reports/density_curves.json"];
Print[""];

(* Test Gap Theorem *)
Print["=== GAP THEOREM VERIFICATION ==="];
Print[""];

testSeqs = <|
  "Primes" -> primes,
  "Semiprimes" -> semiprimes,
  "3-almost primes" -> almostPrimes3,
  "4-almost primes" -> almostPrimes4
|>;

results = KeyValueMap[
  Function[{name, seq},
    Print["Testing: ", name, " (", Length[seq], " elements)"];
    allResults = VerifyAbstractGapTheorem[seq, testUpTo];
    violations = Select[allResults, !Last[#] &];
    tested = Length[allResults];
    passed = tested - Length[violations];

    Print["  Tested: ", tested, " elements"];
    Print["  Passed: ", passed];
    Print["  Success: ", If[tested > 0, N[100 * passed / tested], 0], "%"];
    If[Length[violations] > 0,
      Print["  Violations (first 5): "];
      Do[Print["    ", v], {v, Take[violations, UpTo[5]]}];
    ];
    Print[""];

    <|
      "Name" -> name,
      "SeqLength" -> Length[seq],
      "Tested" -> tested,
      "Passed" -> passed,
      "Violations" -> Length[violations],
      "GapTheorem?" -> Length[violations] == 0 && tested > 0
    |>
  ],
  testSeqs
];

Print["=== SUMMARY ==="];
Print[Dataset[results]];

(* Export results *)
Export["reports/large_scale_results.json", results];
Print[""];
Print["Exported results to reports/large_scale_results.json"];

Print[""];
Print["=== COMPLETE ==="];
