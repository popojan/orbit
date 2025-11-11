#!/usr/bin/env wolframscript

(* Test DAG implementation matches Gap Theorem semantics
   WITHOUT changing the verified Gap Theorem implementation *)

(* Load local Orbit paclet *)
SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

(* Configuration *)
pmax = 500;

Print["Testing DAG Implementation"];
Print["Prime range: 2 to ", pmax];
Print[""];

(* Build DAG *)
Print["Building DAG with immediate predecessor edges..."];
dag = DirectPrimeDag[pmax];
primes = Select[Range[2, pmax], PrimeQ];
Print["✓ DAG constructed"];
Print["  Vertices: ", VertexCount[dag]];
Print["  Edges: ", EdgeCount[dag]];
Print[""];

(* Test 1: Edge structure - each prime has at most one outgoing edge *)
Print["Test 1: DAG has tree structure (at most one outgoing edge per vertex)"];
outDegrees = VertexOutDegree[dag];
maxOutDegree = Max[outDegrees];

If[maxOutDegree <= 1,
  Print["✓ PASS: All vertices have out-degree ≤ 1 (max = ", maxOutDegree, ")"],
  Print["✗ FAIL: Found vertices with out-degree > 1 (max = ", maxOutDegree, ")"]
];
Print[""];

(* Test 2: Each edge goes to immediate predecessor *)
Print["Test 2: Each edge p->q has q = max(Sparse(π(p)))"];
edgeViolations = {};
Do[
  Module[{idx, sparse, immediatePred, outEdges, target},
    idx = PrimePi[p];
    sparse = PrimeRepSparse[idx];
    immediatePred = SelectFirst[sparse, PrimeQ, None];
    outEdges = EdgeList[dag, DirectedEdge[p, _]];

    If[Length[outEdges] > 0,
      target = outEdges[[1, 2]];
      If[immediatePred === None || target != immediatePred,
        AppendTo[edgeViolations, {p, immediatePred, target}]
      ]
    ]
  ],
  {p, primes}
];

If[Length[edgeViolations] == 0,
  Print["✓ PASS: All edges match immediate predecessor definition"],
  Print["✗ FAIL: Found ", Length[edgeViolations], " edge violations"];
  Print[Take[edgeViolations, Min[5, Length[edgeViolations]]]]
];
Print[""];

(* Test 3: DAG is acyclic (no cycles) *)
Print["Test 3: DAG is acyclic"];
hasCycle = !AcyclicGraphQ[dag];

If[!hasCycle,
  Print["✓ PASS: DAG is acyclic"],
  Print["✗ FAIL: DAG contains cycles"]
];
Print[""];

(* Test 4: Prime 2 is a sink (no outgoing edges) *)
Print["Test 4: Prime 2 is a sink (attractor)"];
outDegree2 = VertexOutDegree[dag, 2];

If[outDegree2 == 0,
  Print["✓ PASS: Prime 2 has out-degree 0"],
  Print["✗ FAIL: Prime 2 has out-degree ", outDegree2]
];
Print[""];

(* Test 5: In-degree matches gap for sample primes *)
Print["Test 5: In-degree matches gap for sample hub primes"];
inDegrees = Association[Thread[VertexList[dag] -> VertexInDegree[dag]]];
samplePrimes = {2, 3, 5, 7, 11, 13, 23, 89, 113};
samplePrimes = Select[samplePrimes, # <= pmax &];

sampleResults = Table[
  Module[{gap, inDeg},
    gap = NextPrime[p] - p;
    inDeg = Lookup[inDegrees, p, 0];
    {p, gap, inDeg, gap == inDeg}
  ],
  {p, samplePrimes}
];

allMatch = AllTrue[sampleResults, Last];

If[allMatch,
  Print["✓ PASS: In-degree matches gap for all sample primes"];
  Print[TableForm[sampleResults, TableHeadings -> {None, {"Prime", "Gap", "In-deg", "Match"}}]],
  Print["✗ FAIL: Some samples don't match"];
  Print[TableForm[sampleResults, TableHeadings -> {None, {"Prime", "Gap", "In-deg", "Match"}}]]
];
Print[""];

(* Summary *)
Print["=== SUMMARY ==="];
allTests = {
  maxOutDegree <= 1,
  Length[edgeViolations] == 0,
  !hasCycle,
  outDegree2 == 0,
  allMatch
};
allPass = AllTrue[allTests, # === True &];

If[allPass,
  Print["✓ ALL TESTS PASSED"];
  Print[""];
  Print["DAG implementation is structurally correct:"];
  Print["  - Tree structure (single outgoing edge per node)"];
  Print["  - Edges are immediate predecessor relationships"];
  Print["  - Acyclic (proper DAG)"];
  Print["  - Prime 2 is attractor"];
  Print["  - In-degrees match gaps (sampled)"],

  Print["✗ SOME TESTS FAILED"];
  Print["  Tree structure: ", If[allTests[[1]], "PASS", "FAIL"]];
  Print["  Edge correctness: ", If[allTests[[2]], "PASS", "FAIL"]];
  Print["  Acyclic: ", If[allTests[[3]], "PASS", "FAIL"]];
  Print["  Prime 2 sink: ", If[allTests[[4]], "PASS", "FAIL"]];
  Print["  In-degree sample: ", If[allTests[[5]], "PASS", "FAIL"]]
];

(* Export *)
Export["reports/dag_implementation_test.txt",
  StringJoin[{
    "DAG Implementation Test\n",
    "======================\n\n",
    "Overall: ", If[allPass, "PASS", "FAIL"], "\n"
  }],
  "Text"
];

Print[""];
Print["✓ Results exported to reports/dag_implementation_test.txt"];
