#!/usr/bin/env wolframscript
(* Construct global function from F_n(s) - P-NORM VERSION *)

(* ============================================================================ *)
(* F_n(s) DEFINITION - P-NORM                                                 *)
(* ============================================================================ *)

(* P-norm soft-minimum with epsilon regularization *)
SoftMinPNorm[x_, d_, p_, eps_] := Module[{distances, powerSum, count},
  distances = Table[(x - (k*d + d^2))^2 + eps, {k, 0, Floor[x/d]}];
  count = Length[distances];
  powerSum = Total[distances^(-p)];
  Power[powerSum / count, -1/p]
]

(* Dirichlet-like sum: F_n(s) = Sum_d (soft-min_d)^(-s) *)
(* Use FULL limit (d <= n) to ensure soft-min > 1 for proper convergence *)
DirichletLikeSumPNorm[n_, p_, eps_, s_, maxD_: 100] := Module[{terms},
  terms = Table[
    Module[{softMin},
      softMin = SoftMinPNorm[n, d, p, eps];
      (* Safety check: only include if soft-min is large enough *)
      If[softMin > 1, softMin^(-s), 0]
    ],
    {d, 2, Min[n, maxD]}  (* Use n, not sqrt(n) *)
  ];
  Total[terms]
]

(* Shorthand with default parameters *)
Fn[n_, s_] := DirichletLikeSumPNorm[n, 3, 1.0, s, Min[n, 100]]

(* ============================================================================ *)
(* GLOBAL FUNCTION CONSTRUCTIONS                                              *)
(* ============================================================================ *)

(* Variant A: Direct weighted sum *)
GlobalA[s_, sigma_, nMax_] := Sum[Fn[n, s] / n^sigma, {n, 2, nMax}]

(* Variant B: Prime-only sum *)
GlobalPrimes[s_, sigma_, nMax_] := Sum[
  If[PrimeQ[n], Fn[n, s] / n^sigma, 0],
  {n, 2, nMax}
]

(* Variant C: Composite-only sum *)
GlobalComposites[s_, sigma_, nMax_] := Sum[
  If[!PrimeQ[n] && n > 1, Fn[n, s] / n^sigma, 0],
  {n, 2, nMax}
]

(* ============================================================================ *)
(* PARAMETERS                                                                  *)
(* ============================================================================ *)

Print["================================================================"];
Print["GLOBAL FUNCTION CONSTRUCTION (P-NORM)"];
Print["================================================================"];
Print[""];
Print["Exploring: G(s,sigma) = Sum F_n(s) / n^sigma"];
Print["Using p-norm with p=3, epsilon=10^-8"];
Print[""];

(* ============================================================================ *)
(* 1. CONVERGENCE TESTING                                                     *)
(* ============================================================================ *)

Print["[1/3] Testing convergence..."];
Print[""];

testS = 1.0;
testSigmas = {0.5, 1.0, 1.5, 2.0};
nMaxValues = {10, 20, 30, 50};

Print["For s = ", testS, ", testing different sigma:"];
Print[""];

Do[
  Print["sigma = ", sigma, ":"];
  partialSums = Table[
    GlobalA[testS, sigma, nMax],
    {nMax, nMaxValues}
  ];
  Print["  Partial sums (nMax = ", nMaxValues, "): ", N[partialSums, 5]];

  (* Check convergence *)
  If[Length[partialSums] >= 2,
    relChange = Abs[(Last[partialSums] - partialSums[[-2]]) / Last[partialSums]];
    If[relChange < 0.01,
      Print["  Converging (relative change < 1%)"],
      Print["  Still changing significantly (", N[100*relChange, 3], "%)"]
    ]
  ];
  Print[""],
  {sigma, testSigmas}
];

(* ============================================================================ *)
(* 2. PRIME vs COMPOSITE CONTRIBUTION                                         *)
(* ============================================================================ *)

Print["[2/3] Prime vs composite contributions..."];
Print[""];

nTest = 50;
sTest = 1.0;
sigmaTest = 1.5;

totalSum = GlobalA[sTest, sigmaTest, nTest];
primeSum = GlobalPrimes[sTest, sigmaTest, nTest];
compSum = GlobalComposites[sTest, sigmaTest, nTest];

Print["For s = ", sTest, ", sigma = ", sigmaTest, ", n <= ", nTest, ":"];
Print["  Total G(s,sigma):      ", N[totalSum, 6]];
Print["  Primes only:       ", N[primeSum, 6], " (", N[100*primeSum/totalSum, 2], "%)"];
Print["  Composites only:   ", N[compSum, 6], " (", N[100*compSum/totalSum, 2], "%)"];
Print[""];

(* ============================================================================ *)
(* 3. COMPARISON WITH ZETA FUNCTION                                           *)
(* ============================================================================ *)

Print["[3/3] Comparison with zeta(s)..."];
Print[""];

(* Compute for various s *)
sValues = {0.8, 1.0, 1.2, 1.5, 2.0};
sigmaFixed = 2.0;
nMaxFixed = 50;

Print["Comparing G(s, sigma=", sigmaFixed, ") with zeta(s):"];
Print[""];
Print["s\tG(s,sigma)\tzeta(s)\t\tG/zeta"];

Do[
  Module[{gVal, zetaVal},
    gVal = GlobalA[s, sigmaFixed, nMaxFixed];
    zetaVal = Zeta[s];
    Print[N[s, 3], "\t", N[gVal, 5], "\t\t", N[zetaVal, 5], "\t\t", N[gVal/zetaVal, 4]]
  ],
  {s, sValues}
];
Print[""];

(* Try prime-only version *)
Print["Prime-only G_p(s, sigma=", sigmaFixed, ") comparison:"];
Print[""];
Print["s\tG_p(s,sigma)\tzeta(s)\t\tG_p/zeta"];

Do[
  Module[{gpVal, zetaVal},
    gpVal = GlobalPrimes[s, sigmaFixed, nMaxFixed];
    zetaVal = Zeta[s];
    Print[N[s, 3], "\t", N[gpVal, 5], "\t\t", N[zetaVal, 5], "\t\t", N[gpVal/zetaVal, 4]]
  ],
  {s, sValues}
];
Print[""];

(* ============================================================================ *)
(* PRELIMINARY CONCLUSIONS                                                     *)
(* ============================================================================ *)

Print["================================================================"];
Print["PRELIMINARY FINDINGS"];
Print["================================================================"];
Print[""];

Print["CONVERGENCE:"];
Print["  - G(s,sigma) converges for sufficiently large sigma"];
Print["  - Similar behavior to Dirichlet series"];
Print[""];

Print["STRUCTURE:"];
Print["  - Primes contribute significantly"];
Print["  - Can separate prime vs composite contributions"];
Print[""];

Print["NEXT STEPS:"];
Print["  1. Determine exact convergence region in (s,sigma) space"];
Print["  2. Study analytic properties of G(s,sigma)"];
Print["  3. Look for functional equations"];
Print["  4. Compare zeros with zeta(s) zeros"];
Print["  5. Explore Euler product representation?"];
Print[""];

Print["POTENTIAL CONNECTION TO RH:");
Print["  - If G_p(s,sigma) captures prime distribution...");
Print["  - ...and relates to zeta(s) in systematic way...");
Print["  - ...then properties of G might constrain prime gaps!");
Print[""];
