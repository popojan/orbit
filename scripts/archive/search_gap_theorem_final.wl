#!/usr/bin/env wolframscript

(* FINAL CORRECT VERSION - Matches verified prime implementation *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== GAP THEOREM SEARCH (FINAL) ==="];
Print[""];

(* ===== Abstract Implementation ===== *)

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

AbstractIndex[s_, seq_List] := FirstPosition[seq, s, {0}][[1]]

(* VERIFIED FORMULA: For element s, check elements at positions s, s+1, ..., s+gap *)
VerifyAbstractGapTheorem[seq_List] := Module[{results},
  results = Table[
    Module[{gap, nextElem, indices, checkElements, orbits, count},
      nextElem = SelectFirst[seq, # > s &, None];

      If[nextElem === None,
        Nothing,

        gap = nextElem - s;
        (* CORRECT: Use element VALUE s as position (like Prime[] is inverse of PrimePi) *)
        (* For abstract seq, seq[[i]] is inverse of AbstractIndex *)
        indices = Range[s, Min[s + gap, Length[seq]]];
        checkElements = DeleteCases[Table[If[i <= Length[seq], seq[[i]], Nothing], {i, indices}], Nothing];
        orbits = AbstractOrbit[#, seq] & /@ checkElements;
        count = Length@Select[orbits, Length[#] >= 2 && #[[Length[#] - 1]] == s &];

        {s, gap, count, gap == count}
      ]
    ],
    {s, seq}
  ];
  DeleteCases[results, Nothing]
]

(* ===== Test Sequences ===== *)

Print["Testing sequences..."];
Print[""];

testSeqs = <|
  "Primes" -> Select[Range[2, 100], PrimeQ],
  "Semiprimes" -> Select[Range[4, 100], PrimeOmega[#] == 2 &],
  "3-almost primes" -> Select[Range[8, 100], PrimeOmega[#] == 3 &],
  "Odd numbers" -> Range[3, 99, 2],
  "Even numbers" -> Range[2, 100, 2],
  "Powers of 2" -> 2^Range[1, 6],
  "Fibonacci" -> Table[Fibonacci[n], {n, 2, 10}],
  "Squares" -> Range[2, 10]^2,
  "Triangular" -> Table[n(n+1)/2, {n, 2, 12}],
  "Integers" -> Range[2, 50]
|>;

results = KeyValueMap[
  Function[{name, seq},
    Print["Testing: ", name, " (", Length[seq], " elements, max=", Max[seq], ")"];

    allResults = VerifyAbstractGapTheorem[seq];
    violations = Select[allResults, !Last[#] &];
    tested = Length[allResults];
    passed = tested - Length[violations];

    Print["  Tested: ", tested];
    Print["  Passed: ", passed];
    If[tested > 0,
      Print["  Success: ", N[100 * passed / tested], "%"];
    ];
    If[Length[violations] > 0 && Length[violations] <= 3,
      Print["  Violations: ", violations];
    , If[Length[violations] > 0,
      Print["  Sample violations: ", Take[violations, 3]];
    ]];
    Print[""];

    <|
      "Name" -> name,
      "Tested" -> tested,
      "Passed" -> passed,
      "Gap Theorem?" -> Length[violations] == 0 && tested > 0
    |>
  ],
  testSeqs
];

Print[""];
Print["=== SUMMARY ==="];
Print[""];
Print[Dataset[results]];
Print[""];

successful = Select[results, #["Gap Theorem?"] &];
If[Length[successful] > 0,
  Print["*** BREAKTHROUGH! GAP THEOREM HOLDS FOR: ***"];
  Do[Print["  - ", s["Name"]], {s, successful}];
  Print[""];
  Print["These sequences satisfy the Gap Theorem!"];
,
  Print["Gap Theorem does NOT hold for any tested non-prime sequence."];
  Print["This strongly suggests the theorem is PRIME-SPECIFIC.");
];

Print[""];
Print["=== COMPLETE ==="];
