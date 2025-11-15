#!/usr/bin/env wolframscript
(* Test: Can we simplify further by removing P-norm structure? *)

Print["================================================================"];
Print["PURE DOUBLE SUM vs P-NORM COMPARISON"];
Print["================================================================"];
Print[""];
Print["Testing whether F_n can be simplified to pure double sum"];
Print[""];

(* ============================================================================ *)
(* DISTANCE FUNCTION                                                          *)
(* ============================================================================ *)

Dist[n_, k_, d_, eps_: 1.0] :=
  If[k*d + d^2 <= n,
    (n - k*d - d^2)^2 + eps,
    (k*d + d^2 - n)^2 + eps
  ]

(* ============================================================================ *)
(* VARIANT 1: P-norm soft-minimum (current approach)                         *)
(* ============================================================================ *)

InnerSumPNorm[n_, d_, p_, eps_] := Module[{k, dist, term, sum},
  sum = 0; k = 0;
  While[k < 1000,
    dist = Dist[n, k, d, eps];
    term = dist^(-p);
    sum += term;
    If[k > Floor[n/d] + 10 && term/sum < 10^-6, Break[]];
    k++;
  ];
  sum
]

FnPNorm[n_, s_, p_: 3, eps_: 1.0] := Module[{d, sm, term, sum},
  sum = 0;
  For[d = 2, d <= Min[500, 2*n], d++,
    sm = Power[InnerSumPNorm[n, d, p, eps], -1/p];
    term = If[sm > 1, sm^(-s), 0];
    sum += term;
    If[d > Sqrt[n] + 10 && term/sum < 10^-6, Break[]];
  ];
  sum
]

(* ============================================================================ *)
(* VARIANT 2: Pure double sum (simplified)                                    *)
(* ============================================================================ *)

FnPureSum[n_, alpha_, eps_: 1.0, kMaxAbs_: 1000, dMaxAbs_: 500] := Module[
  {d, k, dist, term, innerSum, outerSum},

  outerSum = 0;

  For[d = 2, d <= Min[dMaxAbs, 2*n], d++,
    innerSum = 0;
    k = 0;

    While[k < kMaxAbs,
      dist = Dist[n, k, d, eps];
      term = dist^(-alpha);
      innerSum += term;

      (* Stop k-sum when contribution negligible *)
      If[k > Floor[n/d] + 10 && term/innerSum < 10^-6, Break[]];
      k++;
    ];

    outerSum += innerSum;

    (* Stop d-sum when contribution negligible *)
    If[d > Sqrt[n] + 10 && innerSum/outerSum < 10^-6, Break[]];
  ];

  outerSum
]

(* ============================================================================ *)
(* TEST 1: Convergence comparison                                            *)
(* ============================================================================ *)

Print["[1/4] Convergence properties..."];
Print[""];

Print["Testing convergence for different alpha values:"];
Print[""];

testN = 20;

(* Test pure sum with various alpha *)
alphaValues = {1.5, 2.0, 2.5, 3.0, 4.0};

Print["Pure sum convergence (n=20):"];
Print["alpha\tF_n^pure\tTime"];
Print[StringRepeat["-", 50]];

Do[
  Module[{result, time},
    {time, result} = AbsoluteTiming[FnPureSum[testN, alpha]];
    Print[alpha, "\t", N[result, 6], "\t", N[time, 3], "s"]
  ],
  {alpha, alphaValues}
];
Print[""];

(* P-norm for comparison *)
pNormResult = FnPNorm[testN, 1.0, 3];
Print["P-norm (p=3, s=1.0): ", N[pNormResult, 6]];
Print[""];

(* ============================================================================ *)
(* TEST 2: Stratification preservation                                        *)
(* ============================================================================ *)

Print["[2/4] Testing prime/composite stratification..."];
Print[""];

(* Use alpha=3 to match p=3 in P-norm *)
testAlpha = 3.0;

Print["Computing F_n for n=2..30 with both methods:"];
Print[""];
Print["n\tF_pure(α=3)\tF_pnorm(p=3)\tRatio\t\tPrime?"];
Print[StringRepeat["-", 70]];

Do[
  Module[{fPure, fPNorm, ratio},
    fPure = FnPureSum[n, testAlpha];
    fPNorm = FnPNorm[n, 1.0, 3];
    ratio = fPure / fPNorm;
    Print[n, "\t", N[fPure, 5], "\t\t", N[fPNorm, 5], "\t\t",
      N[ratio, 4], "\t\t", If[PrimeQ[n], "PRIME", "comp"]]
  ],
  {n, 2, 30}
];
Print[""];

(* ============================================================================ *)
(* TEST 3: Prime vs composite means                                           *)
(* ============================================================================ *)

Print["[3/4] Prime vs composite means (stratification test)..."];
Print[""];

nRange = Range[2, 50];
pureSumData = Table[{n, FnPureSum[n, 3.0], PrimeQ[n]}, {n, nRange}];
pNormData = Table[{n, FnPNorm[n, 1.0, 3], PrimeQ[n]}, {n, nRange}];

(* Separate primes and composites *)
purePrimes = Select[pureSumData, #[[3]] &];
pureComps = Select[pureSumData, !#[[3]] &];

pNormPrimes = Select[pNormData, #[[3]] &];
pNormComps = Select[pNormData, !#[[3]] &];

(* Compute means *)
meanPurePrime = Mean[purePrimes[[All, 2]]];
meanPureComp = Mean[pureComps[[All, 2]]];
meanPNormPrime = Mean[pNormPrimes[[All, 2]]];
meanPNormComp = Mean[pNormComps[[All, 2]]];

Print["Pure double sum (α=3):"];
Print["  Mean for primes:     ", N[meanPurePrime, 5]];
Print["  Mean for composites: ", N[meanPureComp, 5]];
Print["  Separation ratio:    ", N[meanPurePrime/meanPureComp, 4], "×"];
Print[""];

Print["P-norm (p=3, s=1):"];
Print["  Mean for primes:     ", N[meanPNormPrime, 5]];
Print["  Mean for composites: ", N[meanPNormComp, 5]];
Print["  Separation ratio:    ", N[meanPNormPrime/meanPNormComp, 4], "×"];
Print[""];

(* Correlation test *)
corrPure = Correlation[
  pureSumData[[All, 2]],
  Boole[pureSumData[[All, 3]]]
];

corrPNorm = Correlation[
  pNormData[[All, 2]],
  Boole[pNormData[[All, 3]]]
];

Print["Correlation with PrimeQ:"];
Print["  Pure sum:  ", N[corrPure, 4]];
Print["  P-norm:    ", N[corrPNorm, 4]];
Print[""];

(* ============================================================================ *)
(* TEST 4: Which formulation is simpler?                                      *)
(* ============================================================================ *)

Print["[4/4] Algebraic complexity comparison..."];
Print[""];

Print["PURE DOUBLE SUM:"];
Print["  F_n(α) = Σ_{d=2}^∞ Σ_{k=0}^∞ [dist(n,k,d)]^{-α}"];
Print["  - Single parameter (α)"];
Print["  - Pure power sum (no intermediate normalization)"];
Print["  - Direct Mellin transform available"];
Print["  - Converges for α > 1"];
Print[""];

Print["P-NORM SOFT-MINIMUM:"];
Print["  F_n(s,p) = Σ_{d=2}^∞ [Σ_{k=0}^∞ dist^{-p}]^{-s/p}"];
Print["  - Two parameters (s, p)"];
Print["  - Nested power structure"];
Print["  - 'Soft-minimum' interpretation"];
Print["  - Converges for p > 1/2, s > 1/2"];
Print[""];

(* ============================================================================ *)
(* RECOMMENDATION                                                             *)
(* ============================================================================ *)

Print["================================================================"];
Print["ANALYSIS & RECOMMENDATION"];
Print["================================================================"];
Print[""];

separationImproved = meanPurePrime/meanPureComp > meanPNormPrime/meanPNormComp;
correlationBetter = Abs[corrPure] > Abs[corrPNorm];

Print["STRATIFICATION:"];
Print["  Pure sum separation:  ", N[meanPurePrime/meanPureComp, 3], "×"];
Print["  P-norm separation:    ", N[meanPNormPrime/meanPNormComp, 3], "×"];
If[separationImproved,
  Print["  ✓ Pure sum has BETTER separation"],
  Print["  ✗ P-norm has better separation"]
];
Print[""];

Print["SIMPLICITY:"];
Print["  Pure sum: ONE parameter (α), direct double sum"];
Print["  P-norm:   TWO parameters (s,p), nested structure"];
Print["  ✓ Pure sum is SIMPLER"];
Print[""];

Print["CONVERGENCE:"];
Print["  Pure sum: α > 1 (matches ζ(2α))"];
Print["  P-norm:   p > 1/2, s > 1/2 (more relaxed)"];
Print["  ≈ Similar convergence regions"];
Print[""];

If[separationImproved && correlationBetter,
  Print["RECOMMENDATION: Use PURE DOUBLE SUM"],
  If[separationImproved,
    Print["RECOMMENDATION: Tentatively favor PURE SUM (better separation)"],
    Print["RECOMMENDATION: Keep P-NORM (better stratification)")
  ]
];
Print[""];

Print["The pure sum F_n(α) = Σ_d Σ_k dist^{-α} is:"];
Print["  - Algebraically simpler (no soft-min layer)"];
Print["  - Equally tractable for symbolic analysis"];
Print["  - Direct interpretation: weighted sum over Primal Forest lattice"];
If[separationImproved,
  Print["  - Better prime/composite separation!"]
];
Print[""];
