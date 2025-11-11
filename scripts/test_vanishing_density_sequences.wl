#!/usr/bin/env wolframscript
(* -*- mode: mathematica -*- *)

(* Test Gap Theorem on sequences with vanishing density *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];

Print["=== GAP THEOREM: VANISHING DENSITY SEQUENCES =="];
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

VerifyAbstractGapTheorem[seq_List, maxTest_] := Module[{results, tested = 0},
  results = Table[
    Module[{gap, nextElem, indices, checkElements, orbits, count},
      tested++;
      If[Mod[tested, 50] == 0, Print["  Progress: ", tested, " elements tested"]];

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

(* Generate Ulam Numbers *)
GenerateUlamNumbers[nmax_] := Module[{ulam = {1, 2}, candidate, n},
  Print["Generating Ulam numbers up to ", nmax, "..."];
  candidate = 3;
  While[Last[ulam] < nmax,
    (* Check if candidate is sum of two distinct ulam numbers in exactly one way *)
    n = Count[Subsets[ulam, {2}], s_ /; Total[s] == candidate];
    If[n == 1,
      AppendTo[ulam, candidate];
      If[Mod[Length[ulam], 100] == 0, Print["  ", Length[ulam], " elements generated"]];
    ];
    candidate++;
  ];
  Print["Generated ", Length[ulam], " Ulam numbers"];
  ulam
]

(* Generate Lucky Numbers *)
GenerateLuckyNumbers[nmax_] := Module[{numbers, sieve, step},
  Print["Generating Lucky numbers up to ", nmax, "..."];
  numbers = Range[1, nmax, 2]; (* Start with odd numbers *)
  step = 2;

  While[step < Length[numbers],
    sieve = numbers[[step]];
    If[sieve > Length[numbers], Break[]];
    numbers = Delete[numbers, Table[{i}, {i, sieve, Length[numbers], sieve}]];
    step++;
    If[Mod[step, 10] == 0, Print["  Sieve step ", step, ", ", Length[numbers], " remain"]];
  ];

  Print["Generated ", Length[numbers], " Lucky numbers"];
  numbers
]

(* Generate Twin Primes *)
GenerateTwinPrimes[nmax_] := Module[{primes, twins},
  Print["Generating Twin primes up to ", nmax, "..."];
  primes = Select[Range[2, nmax], PrimeQ];
  twins = Select[primes, PrimeQ[# + 2] &];
  (* Include both members of twin pairs *)
  twins = Union[twins, Select[primes, PrimeQ[# - 2] &]];
  Print["Generated ", Length[twins], " Twin primes"];
  twins
]

(* Generate Prime Powers *)
GeneratePrimePowers[nmax_] := Module[{powers},
  Print["Generating Prime powers up to ", nmax, "..."];
  powers = Union[Flatten[Table[
    Table[p^k, {k, 1, Floor[Log[p, nmax]]}],
    {p, Select[Range[2, nmax], PrimeQ]}
  ]]];
  Print["Generated ", Length[powers], " Prime powers"];
  powers
]

(* Generate Squarefree Numbers *)
GenerateSquarefreeNumbers[nmax_] := Module[{sqfree},
  Print["Generating Squarefree numbers up to ", nmax, "..."];
  sqfree = Select[Range[1, nmax], SquareFreeQ];
  Print["Generated ", Length[sqfree], " Squarefree numbers"];
  sqfree
]

(* Test configuration *)
nmax = 1000;
testUpTo = 200;

Print["Configuration:"];
Print["  Generate up to: ", nmax];
Print["  Test elements with value ≤ ", testUpTo];
Print[""];

(* Generate sequences *)
Print["=== GENERATING SEQUENCES ==="];
Print[""];

ulam = GenerateUlamNumbers[nmax];
lucky = GenerateLuckyNumbers[nmax];
twins = GenerateTwinPrimes[nmax];
primePowers = GeneratePrimePowers[nmax];
squarefree = GenerateSquarefreeNumbers[nmax];

Print[""];
Print["=== DENSITY ANALYSIS ==="];
Print[""];

ComputeDensity[seq_, name_] := Module[{density},
  density = N[Length[seq] / nmax];
  Print[name, ": ", Length[seq], " elements, density = ", density];
  density
]

densUlam = ComputeDensity[ulam, "Ulam numbers"];
densLucky = ComputeDensity[lucky, "Lucky numbers"];
densTwins = ComputeDensity[twins, "Twin primes"];
densPowers = ComputeDensity[primePowers, "Prime powers"];
densSquarefree = ComputeDensity[squarefree, "Squarefree"];

(* Compare with theoretical *)
Print[""];
Print["Theoretical comparisons (at n=", nmax, "):"];
Print["  Primes: ~1/ln(n) = ", N[1/Log[nmax]]];
Print["  Ulam: ~0.07-0.08"];
Print["  Squarefree: 6/π² = ", N[6/Pi^2]];

Print[""];
Print["=== TESTING GAP THEOREM ==="];
Print[""];

TestSequence[seq_, name_] := Module[{results, violations, tested, passed},
  Print["Testing: ", name];
  results = VerifyAbstractGapTheorem[seq, testUpTo];
  violations = Select[results, !Last[#] &];
  tested = Length[results];
  passed = tested - Length[violations];

  Print["  Tested: ", tested];
  Print["  Passed: ", passed];
  Print["  Success: ", If[tested > 0, N[100 * passed / tested], 0], "%"];

  If[Length[violations] > 0,
    Print["  VIOLATIONS (first 3):"];
    Do[Print["    s=", v[[1]], ", gap=", v[[2]], ", count=", v[[3]]],
      {v, Take[violations, UpTo[3]]}];
  ,
    Print["  ✓ Gap Theorem holds"];
  ];
  Print[""];

  <|
    "Name" -> name,
    "Length" -> Length[seq],
    "Density" -> N[Length[seq] / nmax],
    "Tested" -> tested,
    "Passed" -> passed,
    "Success%" -> If[tested > 0, N[100 * passed / tested], 0],
    "GapTheorem?" -> Length[violations] == 0 && tested > 0
  |>
]

resultUlam = TestSequence[ulam, "Ulam numbers"];
resultLucky = TestSequence[lucky, "Lucky numbers"];
resultTwins = TestSequence[twins, "Twin primes"];
resultPowers = TestSequence[primePowers, "Prime powers"];
resultSquarefree = TestSequence[squarefree, "Squarefree numbers"];

Print["=== SUMMARY ==="];
Print[""];
summary = {resultUlam, resultLucky, resultTwins, resultPowers, resultSquarefree};
Print[Dataset[summary]];

(* Export *)
Export["reports/vanishing_density_test.json", summary];
Print[""];
Print["Exported to reports/vanishing_density_test.json"];

Print[""];
Print["=== COMPLETE ==="];
