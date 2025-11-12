#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Test script for semiprime factorization *)

Print["Loading Orbit paclet..."];
PacletDirectoryLoad[FileNameJoin[{DirectoryName[$InputFileName], "..", "Orbit"}]];
Needs["Orbit`"];

Print["Testing semiprime factorization formula\n"];

(* Test basic functionality *)
Print["=== Basic Tests ==="];
testSemiprimes = {6, 10, 14, 15, 21, 22, 26, 33, 34, 35, 38, 39, 46, 51, 55, 57, 58, 62};

Print["Testing ForFacti formula and extraction:\n"];
Do[
  Module[{n = sp, resultMod, p, q, standard},
    resultMod = ForFactiMod[n];
    p = ExtractSmallerFactor[n];
    q = If[p =!= $Failed, n/p, $Failed];
    standard = Sort[First /@ FactorInteger[n]];
    Print["  n = ", n, " = ", standard[[1]], " × ", standard[[2]]];
    Print["    ForFactiMod[n] = ", resultMod, " = ", N[resultMod, 5]];
    Print["    This should be (p-1)/p = (", standard[[1]], "-1)/", standard[[1]], " = ", (standard[[1]]-1)/standard[[1]]];
    Print["    Extracted p = ", p];
    Print["    Computed factors = {", p, ", ", q, "}"];
    Print["    Standard factors = ", standard];
    Print["    Match = ", {p, q} == standard];
  ],
  {sp, Take[testSemiprimes, 5]}
];

Print["\n=== Complete Factorization Test ==="];
Print["Testing FactorizeSemiprime for all test cases:\n"];

allMatch = True;
Do[
  Module[{n = sp, computed, standard},
    computed = FactorizeSemiprime[n];
    standard = Sort[First /@ FactorInteger[n]];
    If[computed != standard,
      Print["FAILURE at n = ", n, ": computed = ", computed, ", standard = ", standard];
      allMatch = False;
    ]
  ],
  {sp, testSemiprimes}
];

If[allMatch,
  Print["SUCCESS: All ", Length[testSemiprimes], " semiprimes factored correctly"],
  Print["FAILURE: Some factorizations incorrect"]
];

Print["\n=== Batch Verification ==="];
batchResult = BatchVerifySemiprimes[testSemiprimes];
Print["Tested ", batchResult["Total tested"], " semiprimes"];
Print["All match: ", batchResult["All match"]];
If[Length[batchResult["Failures"]] > 0,
  Print["Failures: ", batchResult["Failures"]],
  Print["No failures detected"]
];

Print["\n=== Detailed Example ==="];
exampleN = 55;
Print["Detailed factorization of n = ", exampleN, " (= 5 × 11):\n"];
verification = VerifySemiprimeFactorization[exampleN];
Print["ForFacti[", exampleN, "] = ", verification["ForFacti[n]"]];
Print["Fractional part = ", verification["Fractional part"]];
Print["  (This equals (q-1)/q where q is the larger factor)"];
Print["Computed factors: ", verification["Computed"]];
Print["Standard factors: ", verification["Standard"]];
Print["Match: ", verification["Match"]];

Print["\n=== Larger Semiprimes ==="];
Print["Testing larger semiprimes:\n"];
largerSemiprimes = {77, 91, 119, 143, 221, 323, 437, 551, 667, 899};
Do[
  Module[{n = sp, factors, timing},
    {timing, factors} = AbsoluteTiming[FactorizeSemiprime[n]];
    Print["  n = ", n, ": factors = ", factors, ", time = ", Round[timing, 0.001], " s"];
  ],
  {sp, largerSemiprimes}
];

Print["\n=== Square of Primes ==="];
Print["Testing squares of primes:\n"];
primeSquares = {4, 9, 25, 49, 121, 169};
Do[
  Module[{n = sq, factors},
    factors = FactorizeSemiprime[n];
    Print["  n = ", n, ": factors = ", factors];
  ],
  {sq, primeSquares}
];

Print["\n=== Test Complete ==="];
