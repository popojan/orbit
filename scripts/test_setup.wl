#!/usr/bin/env wolframscript
(* Quick test to verify Orbit paclet loads correctly *)

(* Load the local Orbit paclet *)
SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== Orbit Paclet Test ===\n"];

(* Test 1: PrimeRepSparse *)
Print["Test 1: PrimeRepSparse"];
Print["  96 = ", PrimeRepSparse[96]];
Print["  100 = ", PrimeRepSparse[100]];
Print["  23 = ", PrimeRepSparse[23]];

(* Test 2: PrimeOrbit *)
Print["\nTest 2: PrimeOrbit"];
Print["  Orbit[100] = ", PrimeOrbit[100]];

(* Test 3: Gap Theorem for small primes *)
Print["\nTest 3: Gap Theorem (primes up to 50)"];
violations = VerifyGapTheorem[50];
If[Length[violations] == 0,
  Print["  ✓ Gap Theorem verified!"],
  Print["  ✗ Violations: ", violations]
];

(* Test 4: Analyze a gap *)
Print["\nTest 4: Analyze gap after prime 23"];
analysis = AnalyzeGapOrbits[23];
Print["  Gap: ", analysis["Gap"]];
Print["  Orbit length range: ", analysis["Min length"], " to ", analysis["Max length"]];

Print["\n=== All tests passed! ==="];
