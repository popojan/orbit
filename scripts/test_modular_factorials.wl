#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Test script for modular factorial computation *)

Print["Loading Orbit paclet..."];
PacletDirectoryLoad[FileNameJoin[{DirectoryName[$InputFileName], "..", "Orbit"}]];
Needs["Orbit`"];

Print["Testing efficient modular factorial computation\n"];

(* Test SqrtMod *)
Print["=== Testing SqrtMod (sqrt(-1) mod p) ==="];
testPrimes = {3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47};

Print["Prime   Mod 4   sqrt(-1) exists?   Values"];
Print[StringRepeat["-", 60]];
Do[
  Module[{p = prime, mod4, sqrtResult},
    mod4 = Mod[p, 4];
    sqrtResult = SqrtMod[p];
    Print[p, "\t", mod4, "\t", sqrtResult[[1]], "\t\t", sqrtResult[[2]]];
  ],
  {prime, testPrimes}
];

Print["\n=== Half-Factorial Values ==="];
Print["Testing ((p-1)/2)! mod p for primes:\n"];
Do[
  Module[{p = prime, halfFact, sqrtResult, mod4},
    halfFact = HalfFactorialMod[p];
    sqrtResult = SqrtMod[p];
    mod4 = Mod[p, 4];
    Print["p = ", p, " (mod 4: ", mod4, ")"];
    Print["  ((", p, "-1)/2)! = ((", (p-1)/2, ")! == ", halfFact, " (mod ", p, ")"];
    Print["  Expected values: ", sqrtResult[[2]]];
    Print["  Match: ", MemberQ[sqrtResult[[2]], halfFact]];
    Print[""];
  ],
  {prime, Take[testPrimes, 6]}
];

Print["\n=== Verification Against Naive Computation ==="];
Print["Testing FactorialMod vs Mod[n!, p]:\n"];

(* Test for p=13 *)
testP = 13;
testN = Range[7, 12];  (* (p-1)/2 = 6, so test from 7 to 12 *)

Print["For p = ", testP, ", testing n from ", Min[testN], " to ", Max[testN], ":\n"];
allMatch = True;
Do[
  Module[{result, naive, match},
    result = FactorialMod[n, testP];
    naive = Mod[n!, testP];
    match = (result === naive);
    If[!match, allMatch = False];
    Print["  n = ", n, ": FactorialMod = ", result, ", Naive = ", naive,
      ", Match = ", match];
  ],
  {n, testN}
];

If[allMatch,
  Print["\nSUCCESS: All computations match!"],
  Print["\nFAILURE: Some mismatches detected"]
];

Print["\n=== Batch Verification ==="];
batchP = 17;
batchN = Range[9, 16];
Print["Testing p = ", batchP, " with n = ", batchN, "\n"];
batchResult = BatchVerifyFactorialMod[batchN, batchP];
Print["Total tested: ", batchResult["Total tested"]];
Print["All match: ", batchResult["All match"]];
If[Length[batchResult["Failures"]] > 0,
  Print["Failures: ", batchResult["Failures"]],
  Print["No failures detected"]
];

Print["\n=== Prime Classification ==="];
Print["Classifying primes up to 50 by half-factorial structure:\n"];
classification = ClassifyPrimesByHalfFactorial[50];

Print["Primes == 1 (mod 4) [have sqrt(-1)]:"];
Do[
  Print["  p = ", p[[1]], ", ((p-1)/2)! == ", p[[4]], " (mod p)"],
  {p, Take[classification["p==1(mod 4)"], UpTo[5]]}
];

Print["\nPrimes == 3 (mod 4) [no sqrt(-1)]:"];
Do[
  Print["  p = ", p[[1]], ", ((p-1)/2)! == ", p[[4]], " (mod p)"],
  {p, Take[classification["p==3(mod 4)"], UpTo[5]]}
];

Print["\n=== Performance Comparison ==="];
Print["Comparing efficient vs naive computation:\n"];

performanceTests = {
  {50, 101},
  {100, 199},
  {200, 401},
  {500, 997}
};

Do[
  Module[{n = test[[1]], p = test[[2]], perf},
    perf = ComparePerformance[n, p];
    Print["n = ", n, ", p = ", p];
    Print["  Efficient: ", Round[perf["Efficient time"], 0.0001], " s"];
    Print["  Naive:     ", Round[perf["Naive time"], 0.0001], " s"];
    Print["  Speedup:   ", Round[perf["Speedup"], 0.1], "x"];
    Print["  Match:     ", perf["Results match"]];
    Print[""];
  ],
  {test, performanceTests}
];

Print["=== Test Complete ==="];
