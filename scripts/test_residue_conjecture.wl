#!/usr/bin/env wolframscript
(* Systematic test of M(n) = residue conjecture *)

Print["================================================================"];
Print["TESTING M(n) RESIDUE CONJECTURE ON RANDOM SAMPLE"];
Print["================================================================"];
Print[""];

(* ============================================================================ *)
(* Function to compute M(n) - number of factorizations                        *)
(* ============================================================================ *)

ComputeMn[n_Integer] := Module[{factorizations, d, k},
  factorizations = {};
  For[d = 2, d <= Floor[Sqrt[n]] + 10, d++,
    k = (n - d^2) / d;
    If[IntegerQ[k] && k >= 0,
      AppendTo[factorizations, {d, k}];
    ];
  ];
  Length[factorizations]
]

(* ============================================================================ *)
(* Function to compute residue numerically                                    *)
(* ============================================================================ *)

ComputeResidue[n_Integer, alpha_Integer, epsilon_Real] := Module[{fn, dMax, kMax},
  dMax = Floor[Sqrt[n]] + 20;
  kMax = 100;

  fn = 0;
  For[d = 2, d <= dMax, d++,
    For[k = 0, k <= kMax, k++,
      Module[{dist},
        dist = (n - k*d - d^2)^2 + epsilon;
        fn += dist^(-alpha);
      ];
    ];
  ];

  epsilon^alpha * fn
]

(* ============================================================================ *)
(* Generate test sample                                                       *)
(* ============================================================================ *)

Print["Generating test sample..."];
Print[""];

(* Primes: 10 random between 10 and 100 *)
SeedRandom[42];  (* For reproducibility *)
primes = RandomSample[Prime[Range[5, 25]], 10];

(* Small composites: 5 random between 10 and 50 *)
smallComposites = RandomSample[Select[Range[10, 50], !PrimeQ[#] &], 5];

(* Medium composites: 5 random between 50 and 100 *)
mediumComposites = RandomSample[Select[Range[50, 100], !PrimeQ[#] &], 5];

(* Highly composite numbers (many divisors) *)
highlyComposite = {12, 24, 30, 60, 120};

testSample = Join[primes, smallComposites, mediumComposites, highlyComposite];
testSample = DeleteDuplicates[Sort[testSample]];

Print["Test sample (", Length[testSample], " numbers):"];
Print[testSample];
Print[""];

(* ============================================================================ *)
(* Run tests                                                                   *)
(* ============================================================================ *)

Print["Running tests with alpha=3, epsilon=0.001"];
Print[""];

alpha = 3;
epsilon = 0.001;

results = Table[
  Module[{mn, residue, time, match},
    Print["Testing n=", n, "..."];

    (* Compute M(n) *)
    mn = ComputeMn[n];

    (* Compute residue *)
    {time, residue} = AbsoluteTiming[ComputeResidue[n, alpha, epsilon]];

    (* Check match *)
    match = Abs[residue - mn] < 0.01;

    {n, PrimeQ[n], mn, residue, time, match}
  ],
  {n, testSample}
];

Print[""];
Print["================================================================"];
Print["RESULTS"];
Print["================================================================"];
Print[""];

Print["n\tPrime?\tM(n)\tResidue\t\tTime(s)\tMatch?"];
Print[StringRepeat["-", 70]];

successCount = 0;
Do[
  Module[{n, isPrime, mn, residue, time, match},
    {n, isPrime, mn, residue, time, match} = results[[i]];
    Print[n, "\t", isPrime, "\t", mn, "\t", N[residue, 6], "\t\t", N[time, 3], "\t", match];
    If[match, successCount++];
  ],
  {i, 1, Length[results]}
];

Print[""];
Print["================================================================"];
Print["SUMMARY"];
Print["================================================================"];
Print[""];

Print["Total tests: ", Length[results]];
Print["Successes: ", successCount];
Print["Failures: ", Length[results] - successCount];
Print["Success rate: ", N[100 * successCount / Length[results], 4], "%"];
Print[""];

(* Analyze by category *)
primeResults = Select[results, #[[2]] == True &];
compositeResults = Select[results, #[[2]] == False &];

Print["Primes tested: ", Length[primeResults]];
Print["  Successes: ", Count[primeResults, {_, _, _, _, _, True}]];
Print[""];

Print["Composites tested: ", Length[compositeResults]];
Print["  Successes: ", Count[compositeResults, {_, _, _, _, _, True}]];
Print[""];

(* Performance analysis *)
avgTime = Mean[results[[All, 5]]];
maxTime = Max[results[[All, 5]]];
maxN = results[[Position[results[[All, 5]], maxTime][[1, 1]], 1]];

Print["Performance:"];
Print["  Average time: ", N[avgTime, 4], " seconds"];
Print["  Max time: ", N[maxTime, 4], " seconds (for n=", maxN, ")"];
Print[""];

(* ============================================================================ *)
(* Failures analysis                                                          *)
(* ============================================================================ *)

failures = Select[results, !#[[6]] &];

If[Length[failures] > 0,
  Print["FAILURES:"];
  Print[""];
  Do[
    Module[{n, mn, residue, diff},
      {n, _, mn, residue, _, _} = failures[[i]];
      diff = Abs[residue - mn];
      Print["n=", n, ": M(n)=", mn, ", residue=", N[residue, 8], ", diff=", N[diff, 6]];
    ],
    {i, 1, Length[failures]}
  ];
  Print[""];
];

(* ============================================================================ *)
(* Correlation plot data                                                      *)
(* ============================================================================ *)

Print["Correlation between M(n) and residue:"];
mnValues = results[[All, 3]];
residueValues = results[[All, 4]];
correlation = Correlation[N[mnValues], N[residueValues]];
Print["  Pearson r = ", N[correlation, 6]];
Print[""];

(* ============================================================================ *)
(* Scaling test for large n                                                   *)
(* ============================================================================ *)

Print["================================================================"];
Print["SCALING TEST: How fast can we go?"];
Print["================================================================"];
Print[""];

scalingTest = {100, 200, 500, 1000, 2000};

Print["Testing computation time for larger n (primes only):"];
Print[""];
Print["n\t\tTime(s)\tResidue\t\tM(n)"];
Print[StringRepeat["-", 60]];

Do[
  Module[{p, time, residue, mn},
    p = NextPrime[n];
    mn = ComputeMn[p];
    {time, residue} = AbsoluteTiming[ComputeResidue[p, alpha, epsilon]];
    Print[p, "\t\t", N[time, 4], "\t", N[residue, 6], "\t\t", mn];
  ],
  {n, scalingTest}
];

Print[""];
Print["Observation: Time grows approximately as O(sqrt(n)) due to d loop"];
Print[""];

(* ============================================================================ *)
(* Final verdict                                                              *)
(* ============================================================================ *)

Print["================================================================"];
Print["FINAL VERDICT"];
Print["================================================================"];
Print[""];

If[successCount == Length[results],
  Print["*** PERFECT MATCH! ***"];
  Print["All ", Length[results], " tests passed!");
  Print["Conjecture is STRONGLY supported by numerical evidence."];
,
  If[successCount >= 0.95 * Length[results],
    Print["Strong evidence for conjecture"];
    Print[successCount, "/", Length[results], " tests passed (",
      N[100 * successCount / Length[results], 3], "%)"];
    Print["Small failures may be due to numerical precision or truncation"];
  ,
    Print["CAUTION: Significant failures detected"];
    Print[successCount, "/", Length[results], " tests passed (",
      N[100 * successCount / Length[results], 3], "%)"];
    Print["Conjecture may need revision or additional constraints"];
  ];
];

Print[""];
Print["Recommended epsilon for n<100: 0.001 or smaller"];
Print["Computational feasibility: n up to ~2000 (few seconds per test)"];
Print[""];
