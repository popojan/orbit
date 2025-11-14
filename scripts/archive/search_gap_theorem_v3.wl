#!/usr/bin/env wolframscript

(* VERIFIED approach: Match the exact logic that works for primes *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== GAP THEOREM SEARCH (v3 - ORBIT COUNTING) ==="];
Print[""];
Print["Using VERIFIED approach: count orbits containing element"];
Print[""];

(* ===== Abstract Implementation Matching Verified Logic ===== *)

(* Greedy decomposition using sequence elements *)
AbstractSparse[n_Integer, seq_List] := Module[{r = n, result = {}, s},
  While[r >= First[seq],
    s = SelectFirst[Reverse[seq], # <= r &, None];
    If[s === None, Break[]];
    AppendTo[result, s];
    r -= s
  ];
  Append[result, r]
]

(* Orbit via recursive decomposition *)
AbstractOrbit[n_Integer, seq_List] := Module[{orbit = {}, queue = {n}, current, sparse, elems},
  While[queue != {},
    current = First[queue];
    queue = Rest[queue];
    If[current >= First[seq] && !MemberQ[orbit, current],
      sparse = AbstractSparse[current, seq];
      elems = Select[Most[sparse], MemberQ[seq, #] &];
      orbit = Union[orbit, elems];
      (* Add INDICES of these elements to queue for recursion *)
      queue = Join[queue, FirstPosition[seq, #, {0}][[1]] & /@ elems];
    ];
  ];
  Sort[orbit]
]

(* Index function *)
AbstractIndex[s_, seq_List] := FirstPosition[seq, s, {0}][[1]]

(* VERIFIED GAP THEOREM: Count orbits containing element *)
VerifyAbstractGapTheorem[seq_List] := Module[{results},
  results = Table[
    Module[{idx, gap, nextElem, gapChildren, count},
      idx = AbstractIndex[s, seq];
      nextElem = SelectFirst[seq, # > s &, None];

      If[nextElem === None || idx == 0,
        Nothing,  (* Skip if no next element or not in sequence *)

        gap = nextElem - s;

        (* Get gap-children: elements at indices [idx, idx + gap - 1] *)
        gapChildren = Table[
          If[i <= Length[seq], seq[[i]], Nothing],
          {i, idx, idx + gap - 1}
        ];

        (* Count how many have s as second-to-last in their orbit *)
        count = Length@Select[
          AbstractOrbit[#, seq] & /@ gapChildren,
          Length[#] >= 2 && #[[Length[#] - 1]] == s &
        ];

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
  "Primes (sanity)" -> Select[Range[2, 50], PrimeQ],
  "Semiprimes" -> Select[Range[4, 50], PrimeOmega[#] == 2 &],
  "Odd numbers" -> Range[3, 49, 2],  (* Start at 3 to match primes *)
  "Powers of 2" -> 2^Range[1, 5],
  "Triangular" -> Table[n(n+1)/2, {n, 2, 10}]  (* Start at 2 to avoid 1 *)
|>;

results = KeyValueMap[
  Function[{name, seq},
    Print["Testing: ", name, " (", Length[seq], " elements)"];

    allResults = VerifyAbstractGapTheorem[seq];
    violations = Select[allResults, !Last[#] &];
    tested = Length[allResults];
    passed = tested - Length[violations];

    Print["  Tested: ", tested];
    Print["  Passed: ", passed];
    If[tested > 0,
      Print["  Success: ", N[100 * passed / tested], "%"];
    ];
    If[Length[violations] > 0,
      Print["  Violations (first 5): "];
      Do[Print["    ", v], {v, Take[violations, UpTo[5]]}];
    ];
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

Print["=== SUMMARY ==="];
Print[""];
Print[Dataset[results]];
Print[""];

successful = Select[results, #["Gap Theorem?"] &];
If[Length[successful] > 0,
  Print["GAP THEOREM HOLDS FOR:"];
  Do[Print["  ", s["Name"]], {s, successful}];
,
  Print["Gap Theorem fails for all non-prime sequences tested."];
];

Print[""];
Print["=== COMPLETE ==="];
