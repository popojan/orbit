#!/usr/bin/env wolframscript
(* Construct global function from F_n(s) - UNWEIGHTED P-NORM VERSION *)

(* ============================================================================ *)
(* F_n(s) DEFINITION - UNWEIGHTED P-NORM                                      *)
(* ============================================================================ *)

(* UNWEIGHTED P-norm soft-minimum with epsilon regularization *)
(* Key difference: NO division by count - emphasizes small d structure *)
SoftMinPNormUnweighted[x_, d_, p_, eps_] := Module[{distances, powerSum},
  distances = Table[(x - (k*d + d^2))^2 + eps, {k, 0, Floor[x/d]}];
  powerSum = Total[distances^(-p)];
  Power[powerSum, -1/p]  (* NO division by Length[distances] *)
]

(* Dirichlet-like sum: F_n(s) = Sum_d (soft-min_d)^(-s) *)
(* UNWEIGHTED: Small d (many k) dominate, large d (few k) vanish faster *)
DirichletLikeSumPNormUnweighted[n_, p_, eps_, s_, maxD_: 200] := Module[{terms},
  terms = Table[
    Module[{softMin},
      softMin = SoftMinPNormUnweighted[n, d, p, eps];
      (* Safety check: only include if soft-min is large enough *)
      If[softMin > 1, softMin^(-s), 0]
    ],
    {d, 2, Min[n, maxD]}
  ];
  Total[terms]
]

(* Shorthand with default parameters *)
FnUnweighted[n_, s_] := DirichletLikeSumPNormUnweighted[n, 3, 1.0, s, Min[n, 200]]

(* ============================================================================ *)
(* GLOBAL FUNCTION CONSTRUCTIONS                                              *)
(* ============================================================================ *)

(* Variant A: Direct weighted sum *)
GlobalAUnweighted[s_, sigma_, nMax_] := Sum[FnUnweighted[n, s] / n^sigma, {n, 2, nMax}]

(* Variant B: Prime-only sum *)
GlobalPrimesUnweighted[s_, sigma_, nMax_] := Sum[
  If[PrimeQ[n], FnUnweighted[n, s] / n^sigma, 0],
  {n, 2, nMax}
]

(* Variant C: Composite-only sum *)
GlobalCompositesUnweighted[s_, sigma_, nMax_] := Sum[
  If[!PrimeQ[n] && n > 1, FnUnweighted[n, s] / n^sigma, 0],
  {n, 2, nMax}
]

(* Inverse form: G_inv(s,sigma) = Sum 1/(F_n(s) * n^sigma) *)
GlobalInverseUnweighted[s_, sigma_, nMax_] := Sum[
  1.0 / (FnUnweighted[n, s] * n^sigma),
  {n, 2, nMax}
]

GlobalInversePrimesUnweighted[s_, sigma_, nMax_] := Sum[
  If[PrimeQ[n], 1.0 / (FnUnweighted[n, s] * n^sigma), 0],
  {n, 2, nMax}
]

GlobalInverseCompositesUnweighted[s_, sigma_, nMax_] := Sum[
  If[!PrimeQ[n] && n > 1, 1.0 / (FnUnweighted[n, s] * n^sigma), 0],
  {n, 2, nMax}
]

(* ============================================================================ *)
(* PARAMETERS                                                                  *)
(* ============================================================================ *)

Print["================================================================"];
Print["GLOBAL FUNCTION CONSTRUCTION - UNWEIGHTED P-NORM"];
Print["================================================================"];
Print[""];
Print["Exploring: G(s,sigma) = Sum F_n(s) / n^sigma"];
Print["Using UNWEIGHTED p-norm: p=3, epsilon=1.0"];
Print["Hypothesis: Better convergence + stronger prime separation"];
Print[""];

(* ============================================================================ *)
(* 1. CONVERGENCE TESTING                                                     *)
(* ============================================================================ *)

Print["[1/4] Testing convergence..."];
Print[""];

testS = 1.0;
testSigmas = {0.5, 1.0, 1.5, 2.0};
nMaxValues = {10, 20, 30, 50};

Print["For s = ", testS, ", testing different sigma:"];
Print[""];

Do[
  Print["sigma = ", sigma, ":"];
  partialSums = Table[
    GlobalAUnweighted[testS, sigma, nMax],
    {nMax, nMaxValues}
  ];
  Print["  Partial sums (nMax = ", nMaxValues, "): ", N[partialSums, 5]];

  (* Check convergence *)
  If[Length[partialSums] >= 2,
    relChange = Abs[(Last[partialSums] - partialSums[[-2]]) / Last[partialSums]];
    If[relChange < 0.01,
      Print["  ✓ Converging (relative change < 1%)"],
      Print["  Still changing (", N[100*relChange, 3], "%)"]
    ]
  ];
  Print[""],
  {sigma, testSigmas}
];

(* ============================================================================ *)
(* 2. PRIME vs COMPOSITE CONTRIBUTION (DIRECT FORM)                           *)
(* ============================================================================ *)

Print["[2/4] Direct form: Prime vs composite contributions..."];
Print[""];

nTest = 50;
sTest = 1.0;
sigmaTest = 1.5;

totalSum = GlobalAUnweighted[sTest, sigmaTest, nTest];
primeSum = GlobalPrimesUnweighted[sTest, sigmaTest, nTest];
compSum = GlobalCompositesUnweighted[sTest, sigmaTest, nTest];

Print["For s = ", sTest, ", sigma = ", sigmaTest, ", n <= ", nTest, ":"];
Print["  Total G(s,sigma):      ", N[totalSum, 6]];
Print["  Primes only:       ", N[primeSum, 6], " (", N[100*primeSum/totalSum, 2], "%)"];
Print["  Composites only:   ", N[compSum, 6], " (", N[100*compSum/totalSum, 2], "%)"];
Print[""];

(* ============================================================================ *)
(* 3. INVERSE FORM - PRIME AMPLIFICATION TEST                                 *)
(* ============================================================================ *)

Print["[3/4] INVERSE form: Testing prime amplification hypothesis..."];
Print[""];

totalInv = GlobalInverseUnweighted[sTest, sigmaTest, nTest];
primeInv = GlobalInversePrimesUnweighted[sTest, sigmaTest, nTest];
compInv = GlobalInverseCompositesUnweighted[sTest, sigmaTest, nTest];

Print["G_inv(s,sigma) = Sum 1/(F_n(s) * n^sigma):"];
Print["  Total:             ", N[totalInv, 6]];
Print["  Primes only:       ", N[primeInv, 6], " (", N[100*primeInv/totalInv, 2], "%)"];
Print["  Composites only:   ", N[compInv, 6], " (", N[100*compInv/totalInv, 2], "%)"];
Print[""];

Print["HYPOTHESIS TEST: Unweighted should show >84% prime contribution"];
If[100*primeInv/totalInv > 84,
  Print["  ✓ CONFIRMED: Prime dominance = ", N[100*primeInv/totalInv, 3], "%"],
  Print["  ✗ Not confirmed: Prime % = ", N[100*primeInv/totalInv, 3], "%"]
];
Print[""];

(* ============================================================================ *)
(* 4. COMPARISON WITH ZETA FUNCTION                                           *)
(* ============================================================================ *)

Print["[4/4] Comparison with zeta(s)..."];
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
    gVal = GlobalAUnweighted[s, sigmaFixed, nMaxFixed];
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
    gpVal = GlobalPrimesUnweighted[s, sigmaFixed, nMaxFixed];
    zetaVal = Zeta[s];
    Print[N[s, 3], "\t", N[gpVal, 5], "\t\t", N[zetaVal, 5], "\t\t", N[gpVal/zetaVal, 4]]
  ],
  {s, sValues}
];
Print[""];

(* ============================================================================ *)
(* SAMPLE F_n VALUES FOR INSPECTION                                           *)
(* ============================================================================ *)

Print["Sample F_n(s=1.0) values (first 20 integers):"];
Print[""];
Print["n\tF_n(1.0)\tPrime?"];

Do[
  Print[n, "\t", N[FnUnweighted[n, 1.0], 5], "\t\t", If[PrimeQ[n], "PRIME", "comp"]],
  {n, 2, 21}
];
Print[""];

(* ============================================================================ *)
(* PRELIMINARY CONCLUSIONS                                                     *)
(* ============================================================================ *)

Print["================================================================"];
Print["PRELIMINARY FINDINGS - UNWEIGHTED VERSION"];
Print["================================================================"];
Print[""];

Print["KEY HYPOTHESIS TESTS:"];
Print["  1. Convergence: Expected FASTER than weighted (tail decays faster)"];
Print["  2. Prime separation: Expected >90% in inverse form"];
Print["  3. Zeta connection: Expected CLEANER ratio (no count dilution)"];
Print[""];

Print["STRUCTURAL IMPLICATIONS:");
Print["  - Small d (many k-points) now dominate → divisor structure emphasized");
Print["  - Large d >√n (single k=0) vanish faster → natural √n cutoff emerges");
Print["  - Composites: divisor hit amplified (not averaged) → F_c larger");
Print["  - Primes: all distances similar → F_p grows uniformly");
Print[""];

Print["NEXT STEPS:");
Print["  1. Compare directly with weighted version");
Print["  2. Test convergence threshold (s > 0? instead of s > 0.5?)");
Print["  3. Check symbolic structure for n=2,3,5,7");
Print["  4. Asymptotic formula analysis");
Print["  5. Zero search in complex plane"];
Print[""];
