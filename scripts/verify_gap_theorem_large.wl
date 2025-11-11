#!/usr/bin/env wolframscript
(* ::Package:: *)

(*
  Verify Gap Theorem for Large Range with Progress Monitoring
  Tests all primes up to 1,000,000
*)

(* Load the local Orbit paclet *)
PacletDirectoryLoad["/home/jan/github/orbit/Orbit"];
Needs["Orbit`"];

(* Configuration *)
pmax = 1000000;
reportFile = "reports/gap_theorem_large_verification.md";

(* Get all primes to test *)
Print["Collecting primes up to ", pmax, "..."];
primes = Select[Range[2, pmax], PrimeQ];
totalPrimes = Length[primes];
Print["Testing ", totalPrimes, " primes\n"];

(* Verify with progress *)
startTime = AbsoluteTime[];
violations = {};
progressInterval = Max[1, Floor[totalPrimes / 100]]; (* Update every 1% *)

Print["Progress: [", StringRepeat[".", 50], "]"];
Print["          [", StringRepeat[" ", 50], "]"];

Do[
  Module[{prime, idx, gap, count, orbits},
    prime = primes[[i]];
    idx = PrimePi[prime];
    gap = NextPrime[prime] - prime;
    orbits = PrimeOrbit /@ Prime @ Range[prime, prime + gap];
    count = Length@Select[orbits, Length[#] >= 2 && #[[Length[#] - 1]] == prime &];

    If[gap != count,
      AppendTo[violations, {prime, gap, count, False}]
    ];

    (* Progress bar *)
    If[Mod[i, progressInterval] == 0 || i == totalPrimes,
      progress = N[i / totalPrimes];
      filled = Floor[progress * 50];
      elapsed = AbsoluteTime[] - startTime;
      rate = i / elapsed;
      remaining = (totalPrimes - i) / rate;

      (* Move cursor up 1 line and overwrite *)
      WriteString["stdout", "\r\033[1A"];
      WriteString["stdout", "          [" <>
        StringRepeat["#", filled] <>
        StringRepeat[" ", 50 - filled] <>
        "] " <> ToString[Round[progress * 100]] <> "% " <>
        "(" <> ToString[i] <> "/" <> ToString[totalPrimes] <> ") " <>
        "ETA: " <> ToString[Round[remaining]] <> "s\n"];
    ];
  ],
  {i, totalPrimes}
];

elapsed = AbsoluteTime[] - startTime;

Print["\n"];
Print["Completed in ", Round[elapsed, 0.1], " seconds (", Round[elapsed/60, 0.1], " minutes)"];
Print["Rate: ", Round[totalPrimes/elapsed], " primes/second\n"];

(* Generate report *)
report = StringJoin[
  "# Gap Theorem Verification (Large Scale)\n\n",
  "**Date:** ", DateString[], "\n",
  "**Range:** Primes up to ", ToString[pmax], "\n",
  "**Total primes tested:** ", ToString[totalPrimes], "\n",
  "**Time:** ", ToString[Round[elapsed, 0.1]], " seconds (",
    ToString[Round[elapsed/60, 0.1]], " minutes)\n",
  "**Rate:** ", ToString[Round[totalPrimes/elapsed]], " primes/second\n\n",
  "## Results\n\n",
  If[Length[violations] == 0,
    "✓ **Gap Theorem verified for all primes in range.**\n\n" <>
    "No violations found. Every prime p has exactly (NextPrime[p] - p) primes with p as second-to-last in their orbit.\n",
    "✗ **Violations found:**\n\n" <>
    "| Prime | Gap | Count | Match |\n" <>
    "|-------|-----|-------|-------|\n" <>
    StringRiffle[
      Table["| " <> ToString[v[[1]]] <> " | " <> ToString[v[[2]]] <>
            " | " <> ToString[v[[3]]] <> " | " <> ToString[v[[4]]] <> " |",
        {v, violations}],
      "\n"
    ] <> "\n"
  ],
  "\n## Summary\n\n",
  "- Total primes: ", ToString[totalPrimes], "\n",
  "- Violations: ", ToString[Length[violations]], "\n",
  "- Success rate: ", ToString[NumberForm[100 * (1 - Length[violations]/totalPrimes), {10, 6}]], "%\n"
];

(* Export report *)
Export[reportFile, report, "Text"];
Print["Report exported to: ", reportFile];
Print["\nResult: ", If[Length[violations] == 0, "✓ PASSED", "✗ FAILED"]];
