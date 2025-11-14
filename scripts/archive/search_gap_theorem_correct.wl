#!/usr/bin/env wolframscript

(* Gap Theorem Search - Correct generalization *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== GAP THEOREM SEARCH (CORRECT GENERALIZATION) ==="];
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

(* VERIFIED FORMULA: For element s at position idx, check positions s, s+1, ..., s+gap *)
(* Key: seq must be long enough that seq[[s+gap]] exists! *)
VerifyAbstractGapTheorem[seq_List, checkUpTo_] := Module[{results},
  results = Table[
    Module[{gap, nextElem, indices, checkElements, orbits, count},
      nextElem = SelectFirst[seq, # > s &, None];

      If[nextElem === None || s > checkUpTo,
        Nothing,

        gap = nextElem - s;
        (* Use element VALUE as position index *)
        indices = Range[s, s + gap];

        (* Check all indices are valid *)
        If[Max[indices] > Length[seq],
          Print["WARNING: Element ", s, " with gap ", gap, " requires seq[[", Max[indices], "]] but length is ", Length[seq]];
          Nothing,

          checkElements = seq[[#]] & /@ indices;
          orbits = AbstractOrbit[#, seq] & /@ checkElements;
          count = Length@Select[orbits, Length[#] >= 2 && #[[Length[#] - 1]] == s &];

          {s, gap, count, gap == count}
        ]
      ]
    ],
    {s, Select[seq, # <= checkUpTo &]}
  ];
  DeleteCases[results, Nothing]
]

(* ===== Generate Long Enough Sequences ===== *)

(* Generate sequence with at least minLength elements *)
GeneratePrimes[minLength_] := Prime[Range[minLength]];
GenerateSemiprimes[minLength_] := Module[{n = 4, result = {}},
  While[Length[result] < minLength, If[PrimeOmega[n] == 2, AppendTo[result, n]]; n++];
  result
];
Generate3AlmostPrimes[minLength_] := Module[{n = 8, result = {}},
  While[Length[result] < minLength, If[PrimeOmega[n] == 3, AppendTo[result, n]]; n++];
  result
];

(* ===== Test Sequences ===== *)

Print["Generating sequences with 500+ elements..."];
Print[""];

checkUpTo = 100;  (* Only verify elements with value <= 100 *)
seqLength = 500;  (* Generate sequences with 500 elements *)

testSeqs = <|
  "Primes" -> GeneratePrimes[seqLength],
  "Semiprimes" -> GenerateSemiprimes[seqLength],
  "3-almost primes" -> Generate3AlmostPrimes[seqLength],
  "Odd numbers" -> Range[1, 2*seqLength - 1, 2],
  "Even numbers" -> Range[2, 2*seqLength, 2],
  "Integers" -> Range[1, seqLength]
|>;

Print["Sequences generated. Testing..."];
Print[""];

results = KeyValueMap[
  Function[{name, seq},
    Print["Testing: ", name];
    Print["  Length: ", Length[seq], ", Max: ", Max[seq]];
    Print["  Checking elements up to value ", checkUpTo];

    allResults = VerifyAbstractGapTheorem[seq, checkUpTo];
    violations = Select[allResults, !Last[#] &];
    tested = Length[allResults];
    passed = tested - Length[violations];

    Print["  Tested: ", tested];
    Print["  Passed: ", passed];
    If[tested > 0,
      Print["  Success: ", N[100 * passed / tested], "%"];
    ];
    If[Length[violations] > 0 && Length[violations] <= 5,
      Print["  ALL violations: "];
      Do[Print["    ", v], {v, violations}];
    , If[Length[violations] > 0,
      Print["  Sample violations (first 5): "];
      Do[Print["    ", v], {v, Take[violations, UpTo[5]]}];
    ]];
    Print[""];

    <|
      "Name" -> name,
      "SeqLength" -> Length[seq],
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
  Print["Found non-prime sequences satisfying Gap Theorem!"];
,
  Print["Gap Theorem does NOT hold for any non-prime sequence tested."];
  Print["This strongly suggests the theorem is PRIME-SPECIFIC.");
];

Print[""];
Print["=== COMPLETE ==="];
