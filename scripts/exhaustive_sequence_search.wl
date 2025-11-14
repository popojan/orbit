#!/usr/bin/env wolframscript

(* Exhaustive search for short sequences satisfying Gap Theorem *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== EXHAUSTIVE SEQUENCE SEARCH ==="];
Print[""];
Print["STRATEGY 2: Search all subsequences up to small bounds"];
Print[""];

(* Load abstract implementation from search script *)
AbstractSparse[n_Integer, seq_List] := Module[{r = n, result = {}, s},
  While[r >= First[seq],
    s = SelectFirst[Reverse[seq], # <= r &, None];
    If[s === None, Break[]];
    AppendTo[result, s];
    r -= s
  ];
  Append[result, r]
]

AbstractIndex[s_, seq_List] := FirstPosition[seq, s, {0}][[1]]

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

VerifyAbstractGapTheorem[smax_Integer, seq_List] := Module[{elems, results, nextElem},
  elems = Select[seq, # < smax &];
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

(* ===== Exhaustive Search Configuration ===== *)

maxValue = 50;      (* Search sequences with elements up to this value *)
minLength = 5;      (* Minimum sequence length *)
maxLength = 10;     (* Maximum sequence length *)
maxTest = 10000;    (* Maximum sequences to test (to avoid explosion) *)

Print["Configuration:"];
Print["  Max value: ", maxValue];
Print["  Sequence length: ", minLength, "-", maxLength];
Print["  Max sequences to test: ", maxTest];
Print[""];

(* Generate candidate subsequences *)
Print["Generating candidate sequences..."];

allInts = Range[2, maxValue];  (* Start from 2, like primes *)
candidateCount = Sum[Binomial[Length[allInts], k], {k, minLength, maxLength}];

Print["  Total possible: ", candidateCount];
If[candidateCount > maxTest,
  Print["  (Will sample ", maxTest, " random sequences)"];
];
Print[""];

(* Sample or enumerate *)
candidates = If[candidateCount <= maxTest,
  Flatten[Table[Subsets[allInts, {k}], {k, minLength, maxLength}], 1],
  RandomSample[Flatten[Table[Subsets[allInts, {k}], {k, minLength, maxLength}], 1], maxTest]
];

Print["Testing ", Length[candidates], " sequences..."];
Print[""];

(* Test each candidate *)
successfulSeqs = {};
tested = 0;

Do[
  tested++;
  If[Mod[tested, 1000] == 0, Print["  Progress: ", tested, "/", Length[candidates]]];

  violations = Quiet[VerifyAbstractGapTheorem[maxValue + 10, seq]];
  If[Length[violations] == 0 && Length[seq] >= minLength,
    AppendTo[successfulSeqs, seq];
    Print["  FOUND: ", seq];
  ],

  {seq, candidates}
];

Print[""];
Print["=== RESULTS ==="];
Print[""];
Print["Tested: ", tested, " sequences"];
Print["Found: ", Length[successfulSeqs], " satisfying Gap Theorem"];
Print[""];

If[Length[successfulSeqs] > 0,
  Print["Successful sequences:"];
  Do[
    Print["  ", i, ". ", seq];
    Print["     Length: ", Length[seq], ", Max: ", Max[seq]];
  ,
    {i, Length[successfulSeqs]},
    {seq, successfulSeqs}
  ];
  Print[""];

  (* Check if any are NOT primes *)
  nonPrime = Select[successfulSeqs, !AllTrue[#, PrimeQ] &];
  If[Length[nonPrime] > 0,
    Print["NON-PRIME SEQUENCES FOUND:"];
    Print[nonPrime];
    Print[""];
    Print["BREAKTHROUGH! Gap Theorem holds for non-prime sequence!"];
  ,
    Print["All successful sequences consist entirely of primes."];
    Print["Gap Theorem appears to be PRIME-SPECIFIC within tested bounds."];
  ];
,
  Print["No sequences found satisfying Gap Theorem."];
  Print["(This might indicate the bounds are too small or algorithm issues)"];
];

Print[""];
Print["=== EXHAUSTIVE SEARCH COMPLETE ==="];
