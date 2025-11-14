#!/usr/bin/env wolframscript

(* Debug why abstract version fails for primes *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== DEBUGGING ABSTRACT GAP THEOREM ==="];
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

AbstractIndex[s_, seq_List] := FirstPosition[seq, s, {0}][[1]]

(* Test with small prime sequence *)
testPrimes = {2, 3, 5, 7, 11, 13, 17, 19, 23};
Print["Test sequence: ", testPrimes];
Print[""];

(* Check prime 7 *)
Print["Testing prime 7:"];
Print["  Position in sequence: ", AbstractIndex[7, testPrimes]]; (* Should be 4 *)
idx = AbstractIndex[7, testPrimes];
Print["  Decompose index ", idx, ":"];
sparse = AbstractSparse[idx, testPrimes];
Print["    Sparse(", idx, ") = ", sparse];
immediatePred = SelectFirst[sparse, MemberQ[testPrimes, #] &, None];
Print["    Immediate predecessor: ", immediatePred];
Print[""];

(* The problem: AbstractSparse is decomposing the INDEX using the SEQUENCE *)
(* But indices are integers 1,2,3,4,... not sequence elements! *)
(* This is the BUG! *)

Print["THE BUG:");
Print["  We're decomposing index=4 using sequence {2,3,5,7,...}"];
Print["  But we should decompose index=4 using INDICES {1,2,3,4,...}"];
Print["  OR we should map index -> element, decompose, map back"];
Print[""];

Print["CORRECT approach for primes:"];
Print["  π(7) = 4"];
Print["  Sparse(4) using primes: ", Most[PrimeRepSparse[4]]]; (* {3, 1} *)
Print["  First prime in sparse: ", SelectFirst[Most[PrimeRepSparse[4]], PrimeQ]]; (* 3 *)
Print["  So edge should be: 7 -> 3"];
Print[""];

Print["=== ROOT CAUSE ==="];
Print["The abstract version needs to decompose INDICES, not sequence elements!");
Print["For primes: index space = position (1,2,3,...) ");
Print["           element space = primes (2,3,5,7,...)");
Print["We must decompose in INDEX space, then map to elements!");
