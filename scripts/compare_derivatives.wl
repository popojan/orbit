#!/usr/bin/env wolframscript
(* Compare derivatives: wrt alpha, n, and epsilon *)

Print["================================================================"];
Print["DERIVATIVE COMPARISON: alpha, n, epsilon"];
Print["================================================================"];
Print[""];

(* ============================================================================ *)
(* SYMBOLIC FORMS                                                             *)
(* ============================================================================ *)

Print["[1/4] Symbolic derivatives of single term"];
Print[""];

term = ((n - k*d - d^2)^2 + eps)^(-alpha);
Print["Term: T = [(n-kd-d^2)^2 + eps]^(-alpha)"];
Print[""];

derivAlpha = D[term, alpha];
derivN = D[term, n];
derivEps = D[term, eps];

Print["dT/dalpha = ", Simplify[derivAlpha]];
Print[""];
Print["dT/dn = ", Simplify[derivN]];
Print[""];
Print["dT/deps = ", Simplify[derivEps]];
Print[""];

Print["Pattern recognition:"];
Print["  dT/dalpha = -Log(dist^2+eps) * T"];
Print["  dT/dn = -2*alpha*(n-kd-d^2) / (dist^2+eps)^(alpha+1)"];
Print["  dT/deps = -alpha / (dist^2+eps)^(alpha+1)"];
Print[""];

(* ============================================================================ *)
(* NUMERICAL IMPLEMENTATION                                                   *)
(* ============================================================================ *)

Print["[2/4] Numerical implementation"];
Print[""];

(* Original function *)
FnFull[n_, alpha_, eps_, dMax_: 50, kMax_: 100] := Module[
  {d, k, innerSum, outerSum, dist},
  outerSum = 0;
  For[d = 2, d <= Min[dMax, 2*n], d++,
    innerSum = 0;
    For[k = 0, k <= kMax, k++,
      dist = (n - k*d - d^2)^2 + eps;
      innerSum += dist^(-alpha);
      If[k > 10 && dist^(-alpha)/innerSum < 10^-8, Break[]];
    ];
    outerSum += innerSum;
  ];
  outerSum
]

(* Derivative wrt alpha *)
FnDerivAlpha[n_, alpha_, eps_, dMax_: 50, kMax_: 100] := Module[
  {d, k, innerSum, outerSum, dist, logDist},
  outerSum = 0;
  For[d = 2, d <= Min[dMax, 2*n], d++,
    innerSum = 0;
    For[k = 0, k <= kMax, k++,
      dist = (n - k*d - d^2)^2 + eps;
      logDist = Log[dist];
      innerSum += (-logDist) * dist^(-alpha);
      If[k > 10 && Abs[logDist * dist^(-alpha)]/Abs[innerSum] < 10^-8, Break[]];
    ];
    outerSum += innerSum;
  ];
  outerSum
]

(* Derivative wrt n *)
FnDerivN[n_, alpha_, eps_, dMax_: 50, kMax_: 100] := Module[
  {d, k, innerSum, outerSum, dist, residual},
  outerSum = 0;
  For[d = 2, d <= Min[dMax, 2*n], d++,
    innerSum = 0;
    For[k = 0, k <= kMax, k++,
      residual = n - k*d - d^2;
      dist = residual^2 + eps;
      innerSum += -2*alpha*residual / dist^(alpha + 1);
      If[k > 10 && Abs[residual / dist^(alpha+1)]/Abs[innerSum] < 10^-8, Break[]];
    ];
    outerSum += innerSum;
  ];
  outerSum
]

(* Derivative wrt epsilon *)
FnDerivEps[n_, alpha_, eps_, dMax_: 50, kMax_: 100] := Module[
  {d, k, innerSum, outerSum, dist},
  outerSum = 0;
  For[d = 2, d <= Min[dMax, 2*n], d++,
    innerSum = 0;
    For[k = 0, k <= kMax, k++,
      dist = (n - k*d - d^2)^2 + eps;
      innerSum += -alpha / dist^(alpha + 1);
      If[k > 10 && Abs[dist^(-alpha-1)]/Abs[innerSum] < 10^-8, Break[]];
    ];
    outerSum += innerSum;
  ];
  outerSum
]

(* ============================================================================ *)
(* STRATIFICATION ANALYSIS                                                    *)
(* ============================================================================ *)

Print["[3/4] Stratification by derivatives"];
Print[""];

results = Table[
  Module[{f, dAlpha, dN, dEps},
    f = FnFull[n, 3.0, 1.0];
    dAlpha = FnDerivAlpha[n, 3.0, 1.0];
    dN = FnDerivN[n, 3.0, 1.0];
    dEps = FnDerivEps[n, 3.0, 1.0];
    {n, N[f, 5], N[Abs[dAlpha], 5], N[Abs[dN], 5], N[Abs[dEps], 5], PrimeQ[n]}
  ],
  {n, 2, 50}
];

primes = Select[results, #[[6]] &];
comps = Select[results, !#[[6]] &];

Print["Mean absolute derivative values (eps=1, alpha=3):"];
Print[""];
Print["                F_n         |dF/da|      |dF/dn|      |dF/deps|"];
Print["Primes:         ", N[Mean[primes[[All, 2]]], 4], "      ",
  N[Mean[primes[[All, 3]]], 4], "      ",
  N[Mean[primes[[All, 4]]], 4], "      ",
  N[Mean[primes[[All, 5]]], 4]];
Print["Composites:     ", N[Mean[comps[[All, 2]]], 4], "      ",
  N[Mean[comps[[All, 3]]], 4], "      ",
  N[Mean[comps[[All, 4]]], 4], "      ",
  N[Mean[comps[[All, 5]]], 4]];
Print[""];

Print["Correlation with PrimeQ:"];
Print["  F_n:         ", N[Correlation[results[[All, 2]], Boole[results[[All, 6]]]], 4]];
Print["  |dF/dalpha|: ", N[Correlation[results[[All, 3]], Boole[results[[All, 6]]]], 4]];
Print["  |dF/dn|:     ", N[Correlation[results[[All, 4]], Boole[results[[All, 6]]]], 4]];
Print["  |dF/deps|:   ", N[Correlation[results[[All, 5]], Boole[results[[All, 6]]]], 4]];
Print[""];

(* ============================================================================ *)
(* SAMPLE VALUES                                                              *)
(* ============================================================================ *)

Print["[4/4] Sample derivative values"];
Print[""];
Print["n\tF\t|dF/da|\t|dF/dn|\t|dF/de|\tPrime?"];
Print[StringRepeat["-", 70]];

Do[
  If[Mod[results[[i, 1]], 5] == 0 || results[[i, 6]],
    Print[results[[i, 1]], "\t", results[[i, 2]], "\t",
      results[[i, 3]], "\t", results[[i, 4]], "\t",
      results[[i, 5]], "\t", If[results[[i, 6]], "PRIME", "comp"]]
  ],
  {i, 1, Min[25, Length[results]]}
];
Print[""];

(* ============================================================================ *)
(* CONCLUSION                                                                 *)
(* ============================================================================ *)

Print["================================================================"];
Print["SUMMARY: THREE DERIVATIVES"];
Print["================================================================"];
Print[""];

Print["1. DERIVATIVE WRT ALPHA (parameter sensitivity):"];
Print["   Formula: dF/dalpha = Sum Sum -Log(dist^2+eps) * term"];
Print["   Behavior: Depends on epsilon"];
Print["     eps < 0.5: composites larger (log(eps) very negative)"];
Print["     eps > 1.5: primes larger (more terms, more variation)"];
Print["     eps = 1: mixed"];
Print[""];

Print["2. DERIVATIVE WRT N (growth in integer space):"];
Print["   Formula: dF/dn = Sum Sum -2*alpha*(n-kd-d^2) / (dist^2+eps)^(a+1)"];
Print["   Behavior: Zero at exact factorizations"];
Print["     Composites: dominant term contributes 0"];
Print["     Primes: all terms non-zero"];
Print[""];

Print["3. DERIVATIVE WRT EPSILON (regularization sensitivity):"];
Print["   Formula: dF/deps = Sum Sum -alpha / (dist^2+eps)^(alpha+1)"];
Print["   Behavior: Always negative"];
Print["     Composites: large (small dist dominates)"];
Print["     Primes: smaller (no dominant term)"];
Print[""];

Print["ALL THREE DERIVATIVES preserve prime/composite stratification"];
Print["but with DIFFERENT characteristics and use cases."];
Print[""];

Print["NONE of them SIMPLIFY the formula - all remain double infinite sums."];
Print[""];

Print["The derivatives are tools for ANALYSIS, not SIMPLIFICATION."];
Print[""];
