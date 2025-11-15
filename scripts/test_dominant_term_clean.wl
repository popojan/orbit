#!/usr/bin/env wolframscript
(* Dominant-term approximation with clean two-sum formulation *)

Print["================================================================"];
Print["DOMINANT-TERM: CLEAN TWO-SUM FORMULATION"];
Print["================================================================"];
Print[""];

(* ============================================================================ *)
(* CLEAN FORMULATION                                                          *)
(* ============================================================================ *)

Print["Canonical formula:"];
Print[""];
Print["F_n^dom(α) = SUM[d=2 to Floor[√n]] + SUM[d=Floor[√n]+1 to ∞]"];
Print[""];
Print["First sum (d ≤ √n):"];
Print["  Term(d) = [(n - k*d - d²)² + ε]^(-α)"];
Print["  where k* = Floor[(n - d²)/d]"];
Print[""];
Print["Second sum (d > √n):"];
Print["  Term(d) = [(d² - n)² + ε]^(-α)"];
Print["  (automatically k=0 since n < d²)"];
Print[""];

(* ============================================================================ *)
(* IMPLEMENTATION                                                             *)
(* ============================================================================ *)

FnDominantClean[n_, alpha_, eps_: 1.0, dMaxAbs_: 100] := Module[
  {sqrtN, sum1, sum2, d, kStar, dist},

  sqrtN = Floor[Sqrt[n]];

  (* First sum: d ≤ √n, use k* formula *)
  sum1 = 0;
  For[d = 2, d <= sqrtN, d++,
    kStar = Floor[(n - d^2)/d];
    dist = (n - kStar*d - d^2)^2 + eps;
    sum1 += dist^(-alpha);
  ];

  (* Second sum: d > √n, use k=0 (direct distance) *)
  sum2 = 0;
  For[d = sqrtN + 1, d <= Min[dMaxAbs, 2*n], d++,
    dist = (d^2 - n)^2 + eps;
    sum2 += dist^(-alpha);
    (* Early termination if contribution negligible *)
    If[d > sqrtN + 10 && dist^(-alpha)/sum2 < 10^-6, Break[]];
  ];

  sum1 + sum2
]

(* Full version for comparison *)
FnFull[n_, alpha_, eps_: 1.0, dMax_: 50] := Module[{d, k, innerSum, outerSum},
  outerSum = 0;
  For[d = 2, d <= Min[dMax, 2*n], d++,
    innerSum = Sum[((n - k*d - d^2)^2 + eps)^(-alpha), {k, 0, 100}];
    outerSum += innerSum;
  ];
  outerSum
]

(* ============================================================================ *)
(* TEST 1: Approximation quality                                             *)
(* ============================================================================ *)

Print["[1/3] Testing approximation quality for n=2..50"];
Print[""];

results = Table[
  Module[{fFull, fDom, ratio},
    fFull = FnFull[n, 3.0, 1.0, 50];
    fDom = FnDominantClean[n, 3.0, 1.0, 100];
    ratio = If[fFull > 0, fDom / fFull, 0];
    {n, N[fFull, 5], N[fDom, 5], N[ratio, 4], PrimeQ[n]}
  ],
  {n, 2, 50}
];

Print["n\tF_full\t\tF_dom\t\tRatio\tPrime?"];
Print[StringRepeat["-", 70]];
Do[
  If[Mod[results[[i, 1]], 5] == 0 || results[[i, 5]],  (* Show every 5th or primes *)
    Print[results[[i, 1]], "\t", results[[i, 2]], "\t", results[[i, 3]], "\t",
      results[[i, 4]], "\t", If[results[[i, 5]], "PRIME", ""]]
  ],
  {i, 1, Length[results]}
];
Print[""];

avgRatio = Mean[Select[results[[All, 4]], # > 0 &]];
Print["Average ratio: ", N[avgRatio, 4]];
Print[""];

(* ============================================================================ *)
(* TEST 2: Stratification                                                     *)
(* ============================================================================ *)

Print["[2/3] Stratification test"];
Print[""];

primes = Select[results, #[[5]] &];
comps = Select[results, !#[[5]] &];

meanFullPrime = Mean[primes[[All, 2]]];
meanFullComp = Mean[comps[[All, 2]]];
meanDomPrime = Mean[primes[[All, 3]]];
meanDomComp = Mean[comps[[All, 3]]];

Print["FULL double sum:"];
Print["  Primes:     ", N[meanFullPrime, 5]];
Print["  Composites: ", N[meanFullComp, 5]];
Print["  Ratio:      ", N[meanFullComp/meanFullPrime, 3], "×"];
Print[""];

Print["DOMINANT-term:"];
Print["  Primes:     ", N[meanDomPrime, 5]];
Print["  Composites: ", N[meanDomComp, 5]];
Print["  Ratio:      ", N[meanDomComp/meanDomPrime, 3], "×"];
Print[""];

corrFull = Correlation[results[[All, 2]], Boole[results[[All, 5]]]];
corrDom = Correlation[results[[All, 3]], Boole[results[[All, 5]]]];

Print["Correlation with PrimeQ:"];
Print["  Full:     ", N[corrFull, 4]];
Print["  Dominant: ", N[corrDom, 4]];
Print[""];

(* ============================================================================ *)
(* TEST 3: Contribution breakdown                                             *)
(* ============================================================================ *)

Print["[3/3] Contribution breakdown for sample values"];
Print[""];

AnalyzeContributions[n_] := Module[{sqrtN, sum1, sum2, total},
  sqrtN = Floor[Sqrt[n]];
  sum1 = Sum[
    Module[{k, dist},
      k = Floor[(n - d^2)/d];
      dist = (n - k*d - d^2)^2 + 1.0;
      dist^(-3.0)
    ],
    {d, 2, sqrtN}
  ];
  sum2 = Sum[(d^2 - n)^2 + 1.0, {d, sqrtN + 1, Min[100, 2*n]}]^(-3.0);
  total = sum1 + sum2;
  {n, sqrtN, N[sum1, 5], N[sum2, 5], N[100*sum1/total, 2], PrimeQ[n]}
];

samples = {7, 11, 12, 20, 25, 30, 37, 49};
Print["n\t√n\tSum1\t\tSum2\t\tSum1%\tPrime?"];
Print[StringRepeat["-", 70]];
Do[
  Module[{res},
    res = AnalyzeContributions[n];
    Print[res[[1]], "\t", res[[2]], "\t", res[[3]], "\t\t", res[[4]], "\t\t",
      res[[5]], "%\t", If[res[[6]], "PRIME", "comp"]]
  ],
  {n, samples}
];
Print[""];

(* ============================================================================ *)
(* FINAL FORMULA                                                              *)
(* ============================================================================ *)

Print["================================================================"];
Print["CANONICAL SIMPLIFIED FORMULA"];
Print["================================================================"];
Print[""];

Print["F_n(α) ≈ Σ_{d=2}^{⌊√n⌋} [(n - k*d - d²)² + ε]^{-α}"];
Print["       + Σ_{d=⌊√n⌋+1}^{∞} [(d² - n)² + ε]^{-α}"];
Print[""];
Print["where k* = ⌊(n - d²)/d⌋"];
Print[""];

Print["Properties:"];
Print["  • SINGLE infinite sum (d-only)");
Print["  • Natural split at d = √n"];
Print["  • No conditionals in terms"];
Print["  • O(√n) finite terms + tail"];
Print[""];

Print["Complexity:"];
Print["  Full:     O(√n × n/d) ≈ O(n log n)");
Print["  Dominant: O(√n) finite + O(1/d⁴) tail ≈ O(√n)"];
Print["  Speedup:  ~√n factor!"];
Print[""];

If[avgRatio > 0.7 && Abs[corrDom] > 0.6,
  Print["✓✓ DOMINANT-TERM APPROXIMATION VALIDATED"];
  Print[""];
  Print["This is the canonical simplified form."];
  Print["Captures ~", N[100*avgRatio, 1], "% of signal with ",
    N[100*Abs[corrDom]/Abs[corrFull], 1], "% correlation preservation."];
];
Print[""];
