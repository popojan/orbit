#!/usr/bin/env wolframscript

(* CORRECTED: Search for sequences where Gap Theorem holds *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== GAP THEOREM SEQUENCE SEARCH (v2 - CORRECTED) ==="];
Print[""];

(* ===== CORRECTED Abstract Implementation ===== *)

(* Key insight: Decompose in INDEX space, not element space! *)

(* Greedy decomposition using INDICES (integers 1,2,3,...) *)
IndexSparse[n_Integer] := Module[{r = n, result = {}},
  While[r >= 1,
    AppendTo[result, r];
    r -= r;  (* Greedy: take largest available, which is r itself *)
  ];
  Append[result, r]  (* Remainder (always 0 for integers) *)
]

(* Wait, that's wrong too. For abstract sequences, the "prime-like" decomposition *)
(* should use the INDICES as the "primes". So for sequence at positions 1,2,3,4,... *)
(* we decompose n using largest k <= n where k is a valid index. *)

(* Actually, for TRUE generality: decompose index n using sequence ELEMENTS at indices <= n *)
AbstractSparse[n_Integer, seq_List] := Module[{r = n, result = {}, maxIdx},
  While[r >= 1,
    (* Find largest index i <= r where seq[[i]] exists *)
    maxIdx = Min[r, Length[seq]];
    If[maxIdx < 1, Break[]];
    AppendTo[result, seq[[maxIdx]]];  (* Use ELEMENT at that index *)
    r -= seq[[maxIdx]];
  ];
  Append[result, r]
]

(* Index function *)
AbstractIndex[s_, seq_List] := FirstPosition[seq, s, {0}][[1]]

(* Build DAG *)
AbstractDirectDag[seq_List] := Module[{edges},
  edges = Flatten[Table[
    Module[{idx, sparse, immediatePred},
      idx = AbstractIndex[s, seq];
      If[idx == 0, {},  (* Not in sequence *)
        sparse = AbstractSparse[idx, seq];
        immediatePred = SelectFirst[Most[sparse], MemberQ[seq, #] &, None];
        If[immediatePred =!= None && immediatePred != s,
          {s -> immediatePred},
          {}
        ]
      ]
    ],
    {s, seq}
  ]];
  Graph[DeleteDuplicates[edges]]
]

(* Verify Gap Theorem *)
VerifyAbstractGapTheorem[seq_List] := Module[{results},
  results = Table[
    Module[{gap, dag, inDeg, nextElem},
      nextElem = SelectFirst[seq, # > s &, None];
      If[nextElem === None,
        Nothing,  (* Skip last element *)
        gap = nextElem - s;
        dag = AbstractDirectDag[seq];
        inDeg = If[VertexQ[dag, s], VertexInDegree[dag, s], 0];
        {s, gap, inDeg, gap == inDeg}
      ]
    ],
    {s, seq}
  ];
  DeleteCases[results, Nothing]
]

(* ===== Test Known Sequences ===== *)

Print["STRATEGY 1: Testing known mathematical sequences"];
Print[""];

testSeqs = <|
  "Primes (sanity check)" -> Select[Range[2, 100], PrimeQ],
  "Semiprimes" -> Select[Range[4, 100], PrimeOmega[#] == 2 &],
  "Odd numbers" -> Range[1, 99, 2],
  "Even numbers" -> Range[2, 100, 2],
  "Powers of 2" -> 2^Range[1, 6],
  "Triangular" -> Table[n(n+1)/2, {n, 1, 13}]
|>;

results = KeyValueMap[
  Function[{name, seq},
    Print["Testing: ", name];

    (* Run verification *)
    allResults = VerifyAbstractGapTheorem[seq];
    violations = Select[allResults, !Last[#] &];
    tested = Length[allResults];
    passed = tested - Length[violations];

    Print["  Elements tested: ", tested];
    Print["  Passed: ", passed, " / ", tested];
    If[tested > 0,
      Print["  Success rate: ", N[100 * passed / tested], "%"];
    ];
    If[Length[violations] > 0 && Length[violations] <= 5,
      Print["  ALL violations: ", violations];
    ,
      If[Length[violations] > 0,
        Print["  Sample violations (first 3): ", Take[violations, UpTo[3]]];
      ];
    ];
    Print[""];

    <|
      "Name" -> name,
      "Length" -> Length[seq],
      "Max" -> Max[seq],
      "Tested" -> tested,
      "Passed" -> passed,
      "Success %" -> If[tested > 0, N[100 * passed / tested], 0],
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

(* Find successful sequences *)
successful = Select[results, #["Gap Theorem?"] &];

If[Length[successful] > 0,
  Print["SUCCESS! Gap Theorem holds for:"];
  Do[Print["  - ", s["Name"]], {s, successful}];
,
  Print["Gap Theorem does NOT hold for any tested non-prime sequence."];
  Print["This strongly suggests the theorem is PRIME-SPECIFIC.");
];

Print[""];
Print["=== COMPLETE ==="];
