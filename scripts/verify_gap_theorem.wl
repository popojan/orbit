#!/usr/bin/env wolframscript
(* ::Package:: *)

(*
  Verify Gap Theorem Exploration
  Verifies the Gap Theorem for primes up to a specified limit
*)

(* Load the local Orbit paclet *)
SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

(* Configuration *)
pmax = 1000; (* Verify up to this prime *)
reportFile = "reports/gap_theorem_verification.md";

(* Run verification *)
Print["Verifying Gap Theorem for primes up to ", pmax, "..."];
violations = VerifyGapTheorem[pmax];

(* Generate report *)
report = StringJoin[
  "# Gap Theorem Verification\n\n",
  "**Date:** ", DateString[], "\n",
  "**Range:** Primes up to ", ToString[pmax], "\n\n",
  "## Results\n\n",
  If[Length[violations] == 0,
    "✓ **Gap Theorem verified for all primes in range.**\n\n" <>
    "No violations found. Every prime p has exactly (NextPrime[p] - p) primes with p in their immediate orbit.\n",
    "✗ **Violations found:**\n\n" <>
    ExportString[violations, "Table"] <> "\n"
  ],
  "\n## Statistics\n\n",
  "- Total primes checked: ", ToString[Length[Select[Range[2, pmax], PrimeQ]]], "\n",
  "- Violations: ", ToString[Length[violations]], "\n"
];

(* Export report *)
Export[reportFile, report, "Text"];
Print["Report exported to: ", reportFile];
Print["\nSummary: ", If[Length[violations] == 0, "PASSED", "FAILED"]];
