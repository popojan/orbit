#!/usr/bin/env wolframscript

(* Gap Theorem via DAG in-degree (universal formulation) *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== GAP THEOREM VIA IN-DEGREE (UNIVERSAL) ==="];
Print[""];

(* Abstract sparse/orbit *)
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

(* Build DAG and count in-degrees *)
BuildAbstractDag[seq_List] := Module[{edges, immediatePreds},
  (* For each element, find its immediate predecessor *)
  immediatePreds = Table[
    Module[{idx, sparse, pred},
      idx = AbstractIndex[s, seq];
      If[idx == 0, None -> s,  (* Not in sequence *)
        sparse = AbstractSparse[idx, seq];
        pred = SelectFirst[Most[sparse], MemberQ[seq, #] &, None];
        If[pred === None || pred == s, None -> s, pred -> s]
      ]
    ],
    {s, seq}
  ];
  (* Filter out None and build graph *)
  edges = DeleteCases[immediatePreds, None -> _];
  If[Length[edges] == 0,
    Graph[{}],
    Graph[edges]
  ]
]

(* Verify via in-degree *)
VerifyViaInDegree[seq_List] := Module[{dag, results},
  dag = BuildAbstractDag[seq];
  results = Table[
    Module[{gap, nextElem, inDeg},
      nextElem = SelectFirst[seq, # > s &, None];
      If[nextElem === None,
        Nothing,
        gap = nextElem - s;
        inDeg = If[VertexQ[dag, s], VertexInDegree[dag, s], 0];
        {s, gap, inDeg, gap == inDeg}
      ]
    ],
    {s, seq}
  ];
  DeleteCases[results, Nothing]
]

(* Test *)
Print["Testing Primes (sanity check):"];
primes = Select[Range[2, 50], PrimeQ];
Print["  Sequence: ", primes];
results = VerifyViaInDegree[primes];
violations = Select[results, !Last[#] &];
Print["  Tested: ", Length[results]];
Print["  Violations: ", Length[violations]];
If[Length[violations] > 0, Print["  Sample: ", Take[violations, UpTo[5]]]];
Print[""];

Print["Testing Integers:"];
ints = Range[2, 30];
results = VerifyViaInDegree[ints];
violations = Select[results, !Last[#] &];
Print["  Tested: ", Length[results]];
Print["  Violations: ", Length[violations]];
If[Length[violations] > 0, Print["  Sample: ", Take[violations, UpTo[5]]]];
Print[""];

Print["Testing Semiprimes:"];
semiprimes = Select[Range[4, 50], PrimeOmega[#] == 2 &];
results = VerifyViaInDegree[semiprimes];
violations = Select[results, !Last[#] &];
Print["  Tested: ", Length[results]];
Print["  Violations: ", Length[violations]];
If[Length[violations] > 0, Print["  Sample: ", Take[violations, UpTo[5]]]];
Print[""];

Print["Testing Powers of 2:"];
powers = 2^Range[1, 8];
results = VerifyViaInDegree[powers];
violations = Select[results, !Last[#] &];
Print["  Tested: ", Length[results]];
Print["  Violations: ", Length[violations]];
If[Length[violations] > 0, Print["  Sample: ", Take[violations, UpTo[5]]]];
Print[""];

Print["=== COMPLETE ==="];
