#!/usr/bin/env wolframscript

(* Test that corrected DAG structure matches Gap Theorem:
   For each prime p, in-degree(p) should equal gap after p *)

(* Load local Orbit paclet *)
SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

(* Configuration *)
pmax = 1000;

Print["Testing DAG structure against Gap Theorem"];
Print["Prime range: 2 to ", pmax];
Print[""];

(* Build DAG *)
Print["Building DAG with immediate predecessor edges..."];
dag = DirectPrimeDag[pmax];
Print["✓ DAG constructed"];
Print["  Vertices: ", VertexCount[dag]];
Print["  Edges: ", EdgeCount[dag]];
Print[""];

(* Get all primes in range *)
primes = Select[Range[2, pmax], PrimeQ];

(* Test 1: Gap Theorem verification via orbit check *)
Print["Test 1: Gap Theorem (orbit-based verification)"];
Print["Checking that gap = count of primes with p as immediate predecessor"];
Print[""];

gapViolations = Table[
  Module[{idx, gap, count},
    idx = PrimePi[p];
    gap = NextPrime[p] - p;
    count = Length @ Select[
      PrimeOrbit /@ Prime @ Range[idx, idx + gap],
      Length[#] >= 2 && #[[Length[#] - 1]] == p &
    ];
    If[gap != count, {p, gap, count}, Nothing]
  ],
  {p, primes}
];

If[Length[gapViolations] == 0,
  Print["✓ PASS: Gap Theorem holds for all ", Length[primes], " primes"],
  Print["✗ FAIL: Found ", Length[gapViolations], " violations:"];
  Print[TableForm[gapViolations, TableHeadings -> {None, {"Prime", "Gap", "Count"}}]]
];
Print[""];

(* Test 2: In-degree equals gap *)
Print["Test 2: DAG in-degree property"];
Print["Checking that in-degree(p) = gap after p for all primes"];
Print[""];

(* Compute in-degrees *)
inDegrees = Association[Thread[VertexList[dag] -> VertexInDegree[dag]]];

(* Check correspondence *)
dagViolations = Table[
  Module[{gap, inDeg},
    gap = NextPrime[p] - p;
    inDeg = Lookup[inDegrees, p, 0];
    If[gap != inDeg, {p, gap, inDeg}, Nothing]
  ],
  {p, primes}
];

If[Length[dagViolations] == 0,
  Print["✓ PASS: In-degree equals gap for all ", Length[primes], " primes"],
  Print["✗ FAIL: Found ", Length[dagViolations], " violations:"];
  Print[TableForm[dagViolations, TableHeadings -> {None, {"Prime", "Gap", "In-degree"}}]]
];
Print[""];

(* Test 3: Immediate predecessor structure *)
Print["Test 3: Immediate predecessor verification"];
Print["Checking that edges match immediate predecessor definition"];
Print[""];

(* For each edge p -> q, verify q = max(Sparse(π(p))) *)
edgeViolations = Table[
  Module[{idx, sparse, immediatePred, neighbors},
    idx = PrimePi[p];
    sparse = PrimeRepSparse[idx];
    immediatePred = SelectFirst[sparse, PrimeQ, None];
    neighbors = VertexOutComponent[dag, p, 1];
    neighbors = DeleteCases[neighbors, p];  (* Remove self *)

    (* Should have exactly one outgoing edge to immediate predecessor *)
    If[immediatePred === None,
      (* No predecessor - should have no outgoing edges *)
      If[Length[neighbors] == 0, Nothing, {p, "None", neighbors}],
      (* Has predecessor - should have exactly one edge to it *)
      If[Length[neighbors] == 1 && neighbors[[1]] == immediatePred,
        Nothing,
        {p, immediatePred, neighbors}
      ]
    ]
  ],
  {p, primes}
];

If[Length[edgeViolations] == 0,
  Print["✓ PASS: All edges match immediate predecessor definition"],
  Print["✗ FAIL: Found ", Length[edgeViolations], " edge violations:"];
  Print[TableForm[edgeViolations, TableHeadings -> {None, {"Prime", "Expected", "Actual neighbors"}}]]
];
Print[""];

(* Summary *)
Print["=== SUMMARY ==="];
allPass = Length[gapViolations] == 0 && Length[dagViolations] == 0 && Length[edgeViolations] == 0;

If[allPass,
  Print["✓ ALL TESTS PASSED"];
  Print[""];
  Print["The corrected DAG structure correctly implements the Gap Theorem:"];
  Print["  - Each prime p has exactly gap(p) primes with p as immediate predecessor"];
  Print["  - In-degree(p) = gap(p) for all primes"];
  Print["  - Edges correspond to immediate predecessor relationships"],

  Print["✗ SOME TESTS FAILED"];
  Print["  Gap Theorem violations: ", Length[gapViolations]];
  Print["  In-degree violations: ", Length[dagViolations]];
  Print["  Edge structure violations: ", Length[edgeViolations]]
];

(* Export summary *)
Export["reports/dag_gap_theorem_test.txt",
  StringJoin[{
    "DAG Gap Theorem Test Results\n",
    "============================\n\n",
    "Prime range: 2 to ", ToString[pmax], "\n",
    "Total primes: ", ToString[Length[primes]], "\n\n",
    "Test 1 (Gap Theorem): ", If[Length[gapViolations] == 0, "PASS", "FAIL"], "\n",
    "Test 2 (In-degree = Gap): ", If[Length[dagViolations] == 0, "PASS", "FAIL"], "\n",
    "Test 3 (Edge structure): ", If[Length[edgeViolations] == 0, "PASS", "FAIL"], "\n\n",
    "Overall: ", If[allPass, "ALL TESTS PASSED", "SOME TESTS FAILED"], "\n"
  }],
  "Text"
];

Print[""];
Print["✓ Summary exported to reports/dag_gap_theorem_test.txt"];
