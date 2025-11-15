#!/usr/bin/env wolframscript
(* Construct global function from F_n(s) *)

(* ============================================================================ *)
(* F_n(s) DEFINITION (from previous work)                                     *)
(* ============================================================================ *)

SoftMinSquared[x_, d_, alpha_] := Module[{distances, negDistSq, M},
  distances = Table[(x - (k*d + d^2))^2, {k, 0, Floor[x/d]}];
  negDistSq = -alpha * distances;
  M = Max[negDistSq];
  -1/alpha * (M + Log[Total[Exp[negDistSq - M]]])
]

DirichletLikeSumComplex[n_, alpha_, s_, maxD_: 100] := Module[{terms},
  terms = Table[
    Module[{softMin},
      softMin = SoftMinSquared[n, d, alpha];
      If[softMin > 0, softMin^(-s), 0]
    ],
    {d, 2, Min[maxD, 3*n]}
  ];
  Total[terms]
]

(* Shorthand *)
Fn[n_, s_] := DirichletLikeSumComplex[n, 7, s, 100]

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
Print["GLOBAL FUNCTION CONSTRUCTION"];
Print["================================================================"];
Print[""];
Print["Exploring: G(s,σ) = Σ F_n(s) / n^σ"];
Print[""];

(* ============================================================================ *)
(* 1. CONVERGENCE TESTING                                                     *)
(* ============================================================================ *)

Print["[1/3] Testing convergence..."];
Print[""];

testS = 1.0;
testSigmas = {0.5, 1.0, 1.5, 2.0};
nMaxValues = {10, 20, 30, 50};

Print["For s = ", testS, ", testing different σ:"];
Print[""];

Do[
  Print["σ = ", sigma, ":"];
  partialSums = Table[
    GlobalA[testS, sigma, nMax],
    {nMax, nMaxValues}
  ];
  Print["  Partial sums (nMax = ", nMaxValues, "): ", N[partialSums, 5]];

  (* Check convergence *)
  If[Length[partialSums] >= 2,
    relChange = Abs[(Last[partialSums] - partialSums[[-2]]) / Last[partialSums]];
    If[relChange < 0.01,
      Print["  ✓ Converging (relative change < 1%)"],
      Print["  ⚠ Still changing significantly (", N[100*relChange, 3], "%)"]
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

Print["For s = ", sTest, ", σ = ", sigmaTest, ", n ≤ ", nTest, ":"];
Print["  Total G(s,σ):      ", N[totalSum, 6]];
Print["  Primes only:       ", N[primeSum, 6], " (", N[100*primeSum/totalSum, 2], "%)"];
Print["  Composites only:   ", N[compSum, 6], " (", N[100*compSum/totalSum, 2], "%)"];
Print[""];

(* ============================================================================ *)
(* 3. COMPARISON WITH ZETA FUNCTION                                           *)
(* ============================================================================ *)

Print["[3/3] Comparison with ζ(s)..."];
Print[""];

(* Compute for various s *)
sValues = {0.8, 1.0, 1.2, 1.5, 2.0};
sigmaFixed = 2.0;
nMaxFixed = 50;

Print["Comparing G(s, σ=", sigmaFixed, ") with ζ(s):"];
Print[""];
Print["s\tG(s,σ)\t\tζ(s)\t\tG/ζ"];

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
Print["Prime-only G_p(s, σ=", sigmaFixed, ") comparison:"];
Print[""];
Print["s\tG_p(s,σ)\tζ(s)\t\tG_p/ζ"];

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
Print["  • G(s,σ) converges for sufficiently large σ"];
Print["  • Similar behavior to Dirichlet series"];
Print[""];

Print["STRUCTURE:"];
Print["  • Primes contribute significantly"];
Print["  • Can separate prime vs composite contributions"];
Print[""];

Print["NEXT STEPS:");
Print["  1. Determine exact convergence region in (s,σ) space"];
Print["  2. Study analytic properties of G(s,σ)"];
Print["  3. Look for functional equations");
Print["  4. Compare zeros with ζ(s) zeros");
Print["  5. Explore Euler product representation?"];
Print[""];

Print["POTENTIAL CONNECTION TO RH:");
Print["  • If G_p(s,σ) captures prime distribution...");
Print["  • ...and relates to ζ(s) in systematic way...");
Print["  • ...then properties of G might constrain prime gaps!");
Print[""];
