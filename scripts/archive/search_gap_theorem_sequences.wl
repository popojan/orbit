#!/usr/bin/env wolframscript

(* Search for sequences where Gap Theorem holds *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== GAP THEOREM SEQUENCE SEARCH ==="];
Print[""];

(* ===== Abstract Implementation ===== *)

(* Greedy decomposition for arbitrary sequence *)
AbstractSparse[n_Integer, seq_List] := Module[{r = n, result = {}, s},
  While[r >= First[seq],
    s = SelectFirst[Reverse[seq], # <= r &, None];
    If[s === None, Break[]];
    AppendTo[result, s];
    r -= s
  ];
  Append[result, r]
]

(* Index function for sequence *)
AbstractIndex[s_, seq_List] := FirstPosition[seq, s, {0}][[1]]

(* Orbit for arbitrary sequence *)
AbstractOrbit[n_Integer, seq_List] := Module[{orbit = {}, queue = {n}, current, rep, elems},
  While[queue != {},
    current = First[queue];
    queue = Rest[queue];
    If[current >= First[seq] && !MemberQ[orbit, current],
      rep = AbstractSparse[current, seq];
      elems = Select[Most[rep], MemberQ[seq, #] &];
      orbit = Union[orbit, elems];
      queue = Join[queue, AbstractIndex[#, seq] & /@ elems];
    ];
  ];
  Sort[orbit]
]

(* Build DAG for arbitrary sequence *)
AbstractDirectDag[smax_Integer, seq_List] := Module[{elems, edges},
  elems = Select[seq, # <= smax &];
  edges = Flatten[Table[
    Module[{sparse, immediatePred},
      sparse = AbstractSparse[AbstractIndex[s, seq], seq];
      immediatePred = SelectFirst[sparse, MemberQ[seq, #] &, None];
      If[immediatePred =!= None && immediatePred != s, {s -> immediatePred}, {}]
    ],
    {s, elems}
  ]];
  Graph[DeleteDuplicates[edges]]
]

(* Verify Gap Theorem for arbitrary sequence *)
VerifyAbstractGapTheorem[smax_Integer, seq_List] := Module[{elems, results, nextElem},
  elems = Select[seq, # < smax &];  (* Only test elements with defined gap *)
  results = Table[
    Module[{idx, gap, dag, inDeg},
      idx = AbstractIndex[s, seq];
      nextElem = SelectFirst[seq, # > s &, None];
      If[nextElem === None,
        {s, -1, -1, "No next element"},
        gap = nextElem - s;
        dag = AbstractDirectDag[smax, seq];
        inDeg = If[VertexQ[dag, s], VertexInDegree[dag, s], 0];
        {s, gap, inDeg, gap == inDeg}
      ]
    ],
    {s, elems}
  ];
  Select[results, !TrueQ[Last[#]] &]
]

(* ===== Test Known Sequences ===== *)

Print["STRATEGY 1: Testing known mathematical sequences"];
Print[""];

(* Generate test sequences *)
testSeqs = <|
  "Primes (sanity check)" -> Select[Range[2, 200], PrimeQ],
  "Semiprimes" -> Select[Range[4, 200], PrimeOmega[#] == 2 &],
  "3-almost primes" -> Select[Range[8, 200], PrimeOmega[#] == 3 &],
  "Odd numbers" -> Range[1, 199, 2],
  "Even numbers" -> Range[2, 200, 2],
  "Powers of 2" -> 2^Range[1, 7],  (* {2,4,8,16,32,64,128} *)
  "Fibonacci" -> Table[Fibonacci[n], {n, 2, 12}],  (* Skip F[1]=1 duplicate *)
  "Squares" -> Range[1, 14]^2,
  "Triangular" -> Table[n(n+1)/2, {n, 1, 19}],
  "Abundant" -> Select[Range[12, 200], DivisorSigma[1, #] > 2# &],
  "Deficient" -> Select[Range[2, 200], DivisorSigma[1, #] < 2# &],
  "Composite" -> Select[Range[4, 200], !PrimeQ[#] &]
|>;

results = KeyValueMap[
  Function[{name, seq},
    Print["Testing: ", name];

    (* Run verification once and analyze results *)
    allResults = VerifyAbstractGapTheorem[Max[seq] + 50, seq];

    (* Count actual boolean results (not strings like "No next element") *)
    booleanResults = Cases[allResults, {_, _, _, True | False}];
    tested = Length[booleanResults];
    violations = Select[booleanResults, !Last[#] &];
    passed = tested - Length[violations];

    Print["  Elements tested: ", tested];
    Print["  Passed: ", passed, " / ", tested];
    If[tested > 0,
      Print["  Success rate: ", N[100 * passed / tested], "%"];
    ,
      Print["  Success rate: N/A (no testable elements)"];
    ];
    If[Length[violations] > 0,
      Print["  Sample violations (first 3): ", Take[violations, UpTo[3]]];
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

(* Find sequences where Gap Theorem holds *)
successful = Select[results, #["Gap Theorem?"] &];

If[Length[successful] > 0,
  Print["SUCCESS! Gap Theorem holds for:"];
  Print[Dataset[successful]];
  Print[""];
  Print["These sequences satisfy the Gap Theorem!"];
  Print["Further analysis needed to characterize why."];
,
  Print["Gap Theorem does NOT hold for any tested sequence except primes."];
  Print["This suggests the theorem is genuinely PRIME-SPECIFIC."];
];

Print[""];
Print["=== STRATEGY 1 COMPLETE ==="];
