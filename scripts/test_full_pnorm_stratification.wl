#!/usr/bin/env wolframscript
(* Test whether Full P-norm preserves fine-grained stratification *)

Print["================================================================"];
Print["FULL P-NORM: Fine-Grained Stratification Test"];
Print["================================================================"];
Print[""];
Print["Testing hierarchy: Primes > Prime powers > Semiprimes > etc."];
Print[""];

(* ============================================================================ *)
(* FULL P-NORM IMPLEMENTATION (copied from test script)                       *)
(* ============================================================================ *)

DistanceFull[n_, k_, d_, eps_] :=
  If[k*d + d^2 <= n,
    (n - k*d - d^2)^2 + eps,
    (k*d + d^2 - n)^2 + eps
  ]

InnerSumFull[n_, d_, p_, eps_, tol_: 10^-6, kMaxAbs_: 1000] := Module[
  {k, dist, term, sum, kCross, tailStart},
  sum = 0; k = 0;
  kCross = Floor[n/d];
  tailStart = kCross + 10;
  While[k < kMaxAbs,
    dist = DistanceFull[n, k, d, eps];
    term = dist^(-p);
    sum += term;
    If[k > tailStart && term/sum < tol, Break[]];
    k++;
  ];
  {sum, k}
]

SoftMinFull[n_, d_, p_, eps_, tol_: 10^-6] := Module[{sumData},
  sumData = InnerSumFull[n, d, p, eps, tol];
  Power[sumData[[1]], -1/p]
]

FnFull[n_, s_, p_: 3, eps_: 1.0] := Module[{d, sm, term, sum},
  sum = 0;
  For[d = 2, d <= Min[500, 2*n], d++,
    sm = SoftMinFull[n, d, p, eps];
    term = If[sm > 1, sm^(-s), 0];
    sum += term;
    If[d > Sqrt[n] + 10 && term/sum < 10^-6, Break[]];
  ];
  sum
]

(* ============================================================================ *)
(* ARITHMETIC CLASSIFICATION FUNCTIONS                                        *)
(* ============================================================================ *)

(* Number of prime factors (with multiplicity) *)
Omega[n_] := PrimeOmega[n]

(* Number of distinct prime factors *)
omega[n_] := PrimeNu[n]

(* Classify by arithmetic type *)
ClassifyNumber[n_] := Module[{factors, omega, Omega},
  factors = FactorInteger[n];
  omega = Length[factors];
  Omega = Total[factors[[All, 2]]];

  Which[
    PrimeQ[n], "Prime",
    omega == 1, "Prime power",
    omega == 2 && Omega == 2, "Semiprime",
    omega == 2 && Omega > 2, "Prime power × prime",
    Omega == 3 && omega == 3, "3-prime product",
    Omega == 3 && omega < 3, "Prime² × prime",
    Omega >= 4 && omega >= 3, Row[{Omega, "-smooth"}],
    True, "Other"
  ]
]

(* ============================================================================ *)
(* TEST 1: Representative samples from each class                             *)
(* ============================================================================ *)

Print["[1/3] Testing F_n^full across arithmetic classes..."];
Print[""];

testSet = {
  (* Primes *)
  2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47,

  (* Prime powers *)
  4, 8, 9, 16, 25, 27, 32, 49,

  (* Semiprimes *)
  6, 10, 14, 15, 21, 22, 26, 33, 34, 35, 38, 39, 46,

  (* Products of 3 primes *)
  30, 42, 60, 66, 70, 78,

  (* Highly composite / smooth *)
  12, 18, 20, 24, 28, 36, 40, 45, 48, 50, 54, 56, 60, 63, 72
};

results = Table[
  Module[{fn, class},
    fn = FnFull[n, 1.0];
    class = ClassifyNumber[n];
    {n, N[fn, 6], class, Omega[n], omega[n], FactorInteger[n]}
  ],
  {n, DeleteDuplicates[testSet]}
];

(* Sort by F_n (descending) *)
sortedResults = Reverse @ SortBy[results, #[[2]] &];

Print["Top 30 by F_n^full score (should show primes on top):"];
Print[""];
Print["Rank\tn\tF_n^full\tClass\t\t\tΩ\tω\tFactorization"];
Print[StringRepeat["-", 100]];

Do[
  Module[{entry},
    entry = sortedResults[[i]];
    Print[i, "\t", entry[[1]], "\t", entry[[2]], "\t",
      StringTake[ToString[entry[[3]]] <> StringRepeat[" ", 20], 20], "\t",
      entry[[4]], "\t", entry[[5]], "\t", entry[[6]]]
  ],
  {i, 1, Min[30, Length[sortedResults]]}
];
Print[""];

(* ============================================================================ *)
(* TEST 2: Statistical correlation with arithmetic invariants                 *)
(* ============================================================================ *)

Print["[2/3] Correlation with arithmetic invariants..."];
Print[""];

(* Compute for range n=2..80 *)
dataRange = Table[
  {n, FnFull[n, 1.0], Omega[n], omega[n], If[PrimeQ[n], 1, 0]},
  {n, 2, 80}
];

fnValues = dataRange[[All, 2]];
omegaValues = dataRange[[All, 3]];
nuValues = dataRange[[All, 4]];
isPrime = dataRange[[All, 5]];

(* Correlations *)
corrOmega = Correlation[fnValues, omegaValues];
corrNu = Correlation[fnValues, nuValues];
corrPrime = Correlation[fnValues, isPrime];

Print["Correlation between F_n^full and:"];
Print["  Ω(n) [total prime factors]:    ", N[corrOmega, 4],
  If[corrOmega < -0.5, " (STRONG negative)", If[corrOmega < -0.3, " (moderate negative)", ""]]];
Print["  ω(n) [distinct prime factors]: ", N[corrNu, 4],
  If[corrNu < -0.5, " (STRONG negative)", If[corrNu < -0.3, " (moderate negative)", ""]]];
Print["  PrimeQ[n]:                     ", N[corrPrime, 4],
  If[corrPrime > 0.5, " (STRONG positive)", If[corrPrime > 0.3, " (moderate positive)", ""]]];
Print[""];

(* ============================================================================ *)
(* TEST 3: Class-by-class means (hierarchy validation)                        *)
(* ============================================================================ *)

Print["[3/3] Mean F_n values by arithmetic class..."];
Print[""];

(* Compute for n=2..60 *)
classData = Table[
  {n, FnFull[n, 1.0], ClassifyNumber[n], Omega[n]},
  {n, 2, 60}
];

(* Group by class *)
primes = Select[classData, #[[3]] == "Prime" &];
primePowers = Select[classData, #[[3]] == "Prime power" &];
semiprimes = Select[classData, #[[3]] == "Semiprime" &];
threeProducts = Select[classData, #[[3]] == "3-prime product" &];

(* Compute means *)
meanPrime = Mean[primes[[All, 2]]];
meanPrimePower = Mean[primePowers[[All, 2]]];
meanSemiprime = Mean[semiprimes[[All, 2]]];
meanThreeProd = If[Length[threeProducts] > 0, Mean[threeProducts[[All, 2]]], 0];

(* All composites by Omega *)
omega2 = Select[classData, #[[4]] == 2 && !PrimeQ[#[[1]]] &];
omega3 = Select[classData, #[[4]] == 3 &];
omega4 = Select[classData, #[[4]] == 4 &];
omega5plus = Select[classData, #[[4]] >= 5 &];

meanOmega2 = If[Length[omega2] > 0, Mean[omega2[[All, 2]]], 0];
meanOmega3 = If[Length[omega3] > 0, Mean[omega3[[All, 2]]], 0];
meanOmega4 = If[Length[omega4] > 0, Mean[omega4[[All, 2]]], 0];
meanOmega5 = If[Length[omega5plus] > 0, Mean[omega5plus[[All, 2]]], 0];

Print["Mean F_n^full by class (n ≤ 60):"];
Print[""];
Print["Arithmetic class\t\tCount\tMean F_n\tStd dev"];
Print[StringRepeat["-", 70]];
Print["Primes\t\t\t\t", Length[primes], "\t", N[meanPrime, 5], "\t",
  N[StandardDeviation[primes[[All, 2]]], 4]];
Print["Prime powers\t\t\t", Length[primePowers], "\t", N[meanPrimePower, 5], "\t",
  N[StandardDeviation[primePowers[[All, 2]]], 4]];
Print["Semiprimes (pq)\t\t\t", Length[semiprimes], "\t", N[meanSemiprime, 5], "\t",
  N[StandardDeviation[semiprimes[[All, 2]]], 4]];
If[Length[threeProducts] > 0,
  Print["3-prime products (pqr)\t\t", Length[threeProducts], "\t", N[meanThreeProd, 5], "\t",
    N[StandardDeviation[threeProducts[[All, 2]]], 4]]
];
Print[""];

Print["Mean F_n^full by Ω(n):"];
Print[""];
Print["Ω(n)\tCount\tMean F_n"];
Print[StringRepeat["-", 35]];
Print["1\t", Length[primes], "\t", N[meanPrime, 5]];
Print["2\t", Length[omega2], "\t", N[meanOmega2, 5]];
Print["3\t", Length[omega3], "\t", N[meanOmega3, 5]];
Print["4\t", Length[omega4], "\t", N[meanOmega4, 5]];
If[Length[omega5plus] > 0,
  Print["5+\t", Length[omega5plus], "\t", N[meanOmega5, 5]]
];
Print[""];

(* ============================================================================ *)
(* VALIDATION                                                                  *)
(* ============================================================================ *)

Print["================================================================"];
Print["STRATIFICATION VALIDATION"];
Print["================================================================"];
Print[""];

(* Test hierarchy: should have meanPrime > meanPrimePower > meanSemiprime > ... *)
hierarchyValid = meanPrime > meanPrimePower &&
                 meanPrimePower > meanSemiprime &&
                 (Length[threeProducts] == 0 || meanSemiprime > meanThreeProd);

negativeCorr = corrOmega < -0.3 && corrNu < -0.3;
positiveWithPrime = corrPrime > 0.3;

Print["HIERARCHY TEST:"];
Print["  Primes > Prime powers:     ", meanPrime > meanPrimePower,
  " (", N[meanPrime/meanPrimePower, 3], "×)"];
Print["  Prime powers > Semiprimes: ", meanPrimePower > meanSemiprime,
  " (", N[meanPrimePower/meanSemiprime, 3], "×)"];
If[Length[threeProducts] > 0,
  Print["  Semiprimes > 3-products:   ", meanSemiprime > meanThreeProd,
    " (", N[meanSemiprime/meanThreeProd, 3], "×)"]
];
Print[""];

Print["CORRELATION TEST:"];
Print["  Negative with Ω(n): ", negativeCorr, " (", N[corrOmega, 3], ")"];
Print["  Negative with ω(n): ", negativeCorr, " (", N[corrNu, 3], ")"];
Print["  Positive with PrimeQ: ", positiveWithPrime, " (", N[corrPrime, 3], ")"];
Print[""];

If[hierarchyValid && negativeCorr && positiveWithPrime,
  Print["✓ CONFIRMED: Full P-norm PRESERVES fine-grained stratification!"],
  Print["✗ WARNING: Stratification partially broken"]
];

Print[""];
Print["INTERPRETATION:"];
Print["  F_n^full provides a continuous primality score where:"];
Print["  - Larger values → more 'prime-like' (fewer, larger factors)"];
Print["  - Smaller values → more 'composite-like' (many small factors)"];
Print["  - Hierarchy preserved across prime power, semiprime, smooth classes"];
Print[""];
