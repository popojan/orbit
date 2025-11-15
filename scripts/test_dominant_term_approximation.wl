#!/usr/bin/env wolframscript
(* Test: Dominant-term approximation vs full double sum *)

Print["================================================================"];
Print["DOMINANT-TERM APPROXIMATION TEST"];
Print["================================================================"];
Print[""];
Print["Hypothesis: Each (n,d) pair has ONE dominant k that captures"];
Print["           most of the inner sum contribution."];
Print[""];
Print["Formula: k*(n,d) = Floor[(n - d²)/d]"];
Print[""];

(* ============================================================================ *)
(* DISTANCE FUNCTION                                                          *)
(* ============================================================================ *)

Dist[n_, k_, d_, eps_: 1.0] := (n - k*d - d^2)^2 + eps

(* ============================================================================ *)
(* DOMINANT K FORMULA                                                         *)
(* ============================================================================ *)

DominantK[n_, d_] := Floor[(n - d^2)/d]

(* ============================================================================ *)
(* FULL vs DOMINANT COMPARISON                                                *)
(* ============================================================================ *)

(* Full: sum over k=0..100 *)
FnFull[n_, alpha_, eps_, dMax_: 50] := Module[{d, k, innerSum, outerSum},
  outerSum = 0;
  For[d = 2, d <= Min[dMax, 2*n], d++,
    innerSum = Sum[Dist[n, k, d, eps]^(-alpha), {k, 0, 100}];
    outerSum += innerSum;
  ];
  outerSum
]

(* Dominant: only k* per d *)
FnDominant[n_, alpha_, eps_, dMax_: 50] := Module[{d, kStar, dist, sum},
  sum = 0;
  For[d = 2, d <= Min[dMax, 2*n], d++,
    kStar = DominantK[n, d];
    If[kStar >= 0,
      dist = Dist[n, kStar, d, eps];
      sum += dist^(-alpha);
    ];
  ];
  sum
]

Print["[1/4] Testing dominant-term approximation for n=2..30"];
Print[""];

results = Table[
  Module[{fFull, fDom, ratio},
    fFull = FnFull[n, 3.0, 1.0, 50];
    fDom = FnDominant[n, 3.0, 1.0, 50];
    ratio = fDom / fFull;
    {n, N[fFull, 6], N[fDom, 6], N[ratio, 4], PrimeQ[n]}
  ],
  {n, 2, 30}
];

Print["n\tF_full\t\tF_dom\t\tRatio\t\tPrime?"];
Print[StringRepeat["-", 70]];
Do[
  Print[results[[i, 1]], "\t", results[[i, 2]], "\t", results[[i, 3]], "\t",
    results[[i, 4]], "\t", If[results[[i, 5]], "PRIME", "comp"]],
  {i, 1, Length[results]}
];
Print[""];

avgRatio = Mean[results[[All, 4]]];
Print["Average ratio (Dominant/Full): ", N[avgRatio, 4]];
Print[""];

(* ============================================================================ *)
(* STRATIFICATION TEST                                                        *)
(* ============================================================================ *)

Print["[2/4] Stratification: Does dominant-term preserve prime/composite?"];
Print[""];

testRange = Range[2, 50];
dataFull = Table[{n, FnFull[n, 3.0, 1.0, 50], PrimeQ[n]}, {n, testRange}];
dataDom = Table[{n, FnDominant[n, 3.0, 1.0, 50], PrimeQ[n]}, {n, testRange}];

(* Separate primes and composites *)
fullPrimes = Select[dataFull, #[[3]] &];
fullComps = Select[dataFull, !#[[3]] &];
domPrimes = Select[dataDom, #[[3]] &];
domComps = Select[dataDom, !#[[3]] &];

(* Means *)
meanFullPrime = Mean[fullPrimes[[All, 2]]];
meanFullComp = Mean[fullComps[[All, 2]]];
meanDomPrime = Mean[domPrimes[[All, 2]]];
meanDomComp = Mean[domComps[[All, 2]]];

Print["FULL double sum:"];
Print["  Primes:     ", N[meanFullPrime, 5]];
Print["  Composites: ", N[meanFullComp, 5]];
Print["  Separation: ", N[meanFullComp/meanFullPrime, 3], "×"];
Print[""];

Print["DOMINANT-term only:"];
Print["  Primes:     ", N[meanDomPrime, 5]];
Print["  Composites: ", N[meanDomComp, 5]];
Print["  Separation: ", N[meanDomComp/meanDomPrime, 3], "×"];
Print[""];

(* Correlations *)
corrFull = Correlation[dataFull[[All, 2]], Boole[dataFull[[All, 3]]]];
corrDom = Correlation[dataDom[[All, 2]], Boole[dataDom[[All, 3]]]];

Print["Correlation with PrimeQ:"];
Print["  Full:     ", N[corrFull, 4]];
Print["  Dominant: ", N[corrDom, 4]];
Print[""];

If[Abs[corrDom] > 0.5 * Abs[corrFull],
  Print["✓ Dominant-term preserves at least 50% of stratification signal"],
  Print["✗ Dominant-term loses too much stratification"]
];
Print[""];

(* ============================================================================ *)
(* EXAMPLE: Detailed breakdown for specific n                                 *)
(* ============================================================================ *)

Print["[3/4] Detailed example: n=20 (composite)"];
Print[""];

n = 20;
alpha = 3.0;
eps = 1.0;

Print["For each d, compare dominant k* vs full inner sum:"];
Print[""];
Print["d\tk*\tdist(k*)\tTerm(k*)\tFull inner\tRatio"];
Print[StringRepeat["-", 70]];

Do[
  Module[{kStar, distStar, termStar, fullInner, ratio},
    kStar = DominantK[n, d];
    If[kStar >= 0,
      distStar = Dist[n, kStar, d, eps];
      termStar = distStar^(-alpha);
      fullInner = Sum[Dist[n, k, d, eps]^(-alpha), {k, 0, 50}];
      ratio = termStar / fullInner;
      Print[d, "\t", kStar, "\t", distStar, "\t", N[termStar, 5], "\t\t",
        N[fullInner, 5], "\t\t", N[ratio, 4]];
    ];
  ],
  {d, 2, 10}
];
Print[""];

(* ============================================================================ *)
(* ALGEBRAIC SIMPLIFICATION                                                   *)
(* ============================================================================ *)

Print["[4/4] Algebraic structure of dominant-term formula"];
Print[""];

Print["FULL formula:"];
Print["  F_n(α) = Σ_{d=2}^∞ Σ_{k=0}^∞ [(n - kd - d²)² + ε]^{-α}"];
Print["  - Double infinite sum"];
Print["  - Convergence: α > 1"];
Print[""];

Print["DOMINANT-term formula:"];
Print["  F_n^dom(α) = Σ_{d=2}^∞ [(n - k*(n,d)d - d²)² + ε]^{-α}"];
Print["  where k*(n,d) = Floor[(n - d²)/d]"];
Print[""];
Print["  - SINGLE infinite sum (over d only)"];
Print["  - Explicit k for each d (no inner sum!)"];
Print["  - Convergence: α > 1/2 (same as outer sum)"];
Print[""];

Print["Computational complexity:"];
Print["  Full:     O(d_max × k_max) evaluations"];
Print["  Dominant: O(d_max) evaluations"];
Print["  Speedup:  ~k_max× faster (typically 10-100×)"];
Print[""];

(* ============================================================================ *)
(* GEOMETRIC INTERPRETATION                                                    *)
(* ============================================================================ *)

Print["================================================================"];
Print["GEOMETRIC INTERPRETATION"];
Print["================================================================"];
Print[""];

Print["For each divisor d, we ask:");
Print["  'Which lattice point (kd+d², k) is closest to n?'"];
Print[""];
Print["The answer: k* = Floor[(n-d²)/d]"];
Print[""];
Print["This gives distance:");
Print["  d_min(n,d) = |n - k*d - d²|");
Print[""];
Print["For PRIMES:");
Print["  - No exact factorization n = r×s");
Print["  - All lattice points far from n");
Print["  - F_n^dom remains small");
Print[""];
Print["For COMPOSITES:");
Print["  - Factorization n = r×s exists");
Print["  - Lattice point (rs, r-s) is EXACT (distance = 0 + ε)");
Print["  - Dominant term explodes: dist^{-α} = ε^{-α} (huge!)");
Print[""];

(* ============================================================================ *)
(* CONCLUSION                                                                  *)
(* ============================================================================ *)

Print["================================================================"];
Print["CONCLUSION"];
Print["================================================================"];
Print[""];

Print["Average approximation quality: ", N[100*avgRatio, 2], "%"];
Print["Correlation preservation:       ", N[100*Abs[corrDom]/Abs[corrFull], 2], "%"];
Print[""];

If[avgRatio > 0.7 && Abs[corrDom] > 0.5*Abs[corrFull],
  Print["✓✓ DOMINANT-TERM IS EXCELLENT APPROXIMATION!"];
  Print[""];
  Print["CANONICAL SIMPLIFIED FORMULA:"];
  Print[""];
  Print["  F_n(α) ≈ Σ_{d=2}^∞ [(n - k*d - d²)² + ε]^{-α}"];
  Print[""];
  Print["  where k* = Floor[(n - d²)/d]"];
  Print[""];
  Print["This reduces double infinite sum → single infinite sum!"];
  ,
  If[avgRatio > 0.5,
    Print["~ DOMINANT-TERM IS REASONABLE APPROXIMATION"],
    Print["✗ DOMINANT-TERM LOSES TOO MUCH"]
  ]
];
Print[""];
