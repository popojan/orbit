#!/usr/bin/env wolframscript
(* Derivative with respect to n *)

Print["================================================================"];
Print["DERIVATIVE WITH RESPECT TO n: dF_n/dn"];
Print["================================================================"];
Print[""];

(* ============================================================================ *)
(* SYMBOLIC DERIVATIVE                                                        *)
(* ============================================================================ *)

Print["[1/3] Symbolic derivative of single term"];
Print[""];

Print["Term: T(n) = [(n - k*d - d^2)^2 + eps]^(-alpha)"];
Print[""];

term = ((n - k*d - d^2)^2 + eps)^(-alpha);

Print["Computing D[T, n]..."];
deriv = D[term, n];
Print[""];
Print["Result:"];
Print[deriv];
Print[""];

simplified = Simplify[deriv];
Print["Simplified:"];
Print[simplified];
Print[""];

(* Factor structure *)
Print["Rewrite as:");
Print["dT/dn = -2*alpha*(n-k*d-d^2) / [(n-k*d-d^2)^2 + eps]^(alpha+1)"];
Print[""];

Print["Or in terms of original T:"];
Print["dT/dn = -2*alpha*(n-k*d-d^2) * [(n-k*d-d^2)^2 + eps]^(-1) * T(n)"];
Print[""];

(* ============================================================================ *)
(* STRUCTURE OF DERIVATIVE                                                    *)
(* ============================================================================ *)

Print["[2/3] Structure analysis"];
Print[""];

Print["Original sum:"];
Print["  F_n = Sum_d Sum_k [(n-k*d-d^2)^2 + eps]^(-alpha)"];
Print[""];

Print["Derivative:"];
Print["  dF/dn = Sum_d Sum_k -2*alpha*(n-k*d-d^2) / [(n-k*d-d^2)^2+eps]^(alpha+1)"];
Print[""];

Print["Key observations:"];
Print["  1. Factor (n-k*d-d^2) appears in numerator"];
Print["  2. Power increases: alpha -> alpha+1"];
Print["  3. Sign depends on sign of (n-k*d-d^2)"];
Print[""];

Print["For terms where n-k*d-d^2 = 0 (exact factorization):"];
Print["  - Original term: (0+eps)^(-alpha) = LARGE"];
Print["  - Derivative: 0 / (eps)^(alpha+1) = 0"];
Print[""];

Print["Interpretation: Derivative is ZERO at exact factorizations!"];
Print["  - Composites have zero derivative contribution from dominant term"];
Print["  - Primes have non-zero derivatives from all terms"];
Print[""];

(* ============================================================================ *)
(* NUMERICAL TEST                                                             *)
(* ============================================================================ *)

Print["[3/3] Numerical verification"];
Print[""];

(* Implementation *)
FnFull[n_, alpha_, eps_: 1.0, dMax_: 50, kMax_: 100] := Module[
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

(* Analytical derivative *)
FnDerivativeWrtN[n_, alpha_, eps_: 1.0, dMax_: 50, kMax_: 100] := Module[
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

(* Numerical derivative via finite differences *)
FnNumericalDerivWrtN[n_, alpha_, eps_: 1.0, h_: 0.01] := Module[{},
  (FnFull[n + h, alpha, eps] - FnFull[n - h, alpha, eps]) / (2*h)
]

Print["Testing analytical vs numerical derivative:"];
Print[""];
Print["n\tF(n)\t\tdF/dn (anal)\tdF/dn (num)\tError %\tPrime?"];
Print[StringRepeat["-", 90]];

testCases = {10, 12, 13, 20, 21, 30, 31, 35, 37, 40};

Do[
  Module[{fVal, dAnalytical, dNumerical, error},
    fVal = FnFull[n, 3.0, 1.0];
    dAnalytical = FnDerivativeWrtN[n, 3.0, 1.0];
    dNumerical = FnNumericalDerivWrtN[n, 3.0, 1.0];
    error = If[Abs[dAnalytical] > 1*^-6,
      100 * Abs[dAnalytical - dNumerical] / Abs[dAnalytical],
      0
    ];
    Print[n, "\t", N[fVal, 5], "\t\t", N[dAnalytical, 5], "\t\t",
      N[dNumerical, 5], "\t\t", N[error, 3], "%\t",
      If[PrimeQ[n], "PRIME", "comp"]];
  ],
  {n, testCases}
];
Print[""];

(* ============================================================================ *)
(* STRATIFICATION BY DERIVATIVE                                               *)
(* ============================================================================ *)

Print["================================================================"];
Print["STRATIFICATION: dF/dn for primes vs composites"];
Print["================================================================"];
Print[""];

results = Table[
  Module[{fVal, deriv},
    fVal = FnFull[n, 3.0, 1.0];
    deriv = FnDerivativeWrtN[n, 3.0, 1.0];
    {n, N[fVal, 5], N[deriv, 5], N[Abs[deriv], 5], PrimeQ[n]}
  ],
  {n, 2, 50}
];

primes = Select[results, #[[5]] &];
comps = Select[results, !#[[5]] &];

meanDerivPrime = Mean[primes[[All, 4]]];
meanDerivComp = Mean[comps[[All, 4]]];

Print["Mean |dF/dn|:"];
Print["  Primes:     ", N[meanDerivPrime, 5]];
Print["  Composites: ", N[meanDerivComp, 5]];
Print["  Ratio (comp/prime): ", N[meanDerivComp/meanDerivPrime, 3], "x"];
Print[""];

corrDeriv = Correlation[results[[All, 4]], Boole[results[[All, 5]]]];
Print["Correlation of |dF/dn| with PrimeQ: ", N[corrDeriv, 4]];
Print[""];

(* Show sample values *)
Print["Sample values (n, F_n, dF/dn, Prime?):"];
Print[StringRepeat["-", 60]];
Do[
  If[Mod[results[[i, 1]], 5] == 0 || results[[i, 5]],
    Print[results[[i, 1]], "\t", results[[i, 2]], "\t",
      results[[i, 3]], "\t", If[results[[i, 5]], "PRIME", "comp"]]
  ],
  {i, 1, Min[20, Length[results]]}
];
Print[""];

(* ============================================================================ *)
(* COMPARISON: dF/dn vs dF/dalpha                                             *)
(* ============================================================================ *)

Print["================================================================"];
Print["COMPARISON: Derivatives wrt n vs alpha"];
Print["================================================================"];
Print[""];

(* Also compute dF/dalpha for comparison *)
FnDerivativeWrtAlpha[n_, alpha_, eps_: 1.0, dMax_: 50, kMax_: 100] := Module[
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

comparison = Table[
  Module[{fVal, dN, dAlpha},
    fVal = FnFull[n, 3.0, 1.0];
    dN = FnDerivativeWrtN[n, 3.0, 1.0];
    dAlpha = FnDerivativeWrtAlpha[n, 3.0, 1.0];
    {n, N[Abs[dN], 5], N[Abs[dAlpha], 5], PrimeQ[n]}
  ],
  {n, 2, 30}
];

primesComp = Select[comparison, #[[4]] &];
compsComp = Select[comparison, !#[[4]] &];

Print["Mean |dF/dn| vs |dF/dalpha|:"];
Print[""];
Print["              |dF/dn|    |dF/dalpha|"];
Print["Primes:       ", N[Mean[primesComp[[All, 2]]], 4], "     ",
  N[Mean[primesComp[[All, 3]]], 4]];
Print["Composites:   ", N[Mean[compsComp[[All, 2]]], 4], "     ",
  N[Mean[compsComp[[All, 3]]], 4]];
Print[""];

Print["Correlation with PrimeQ:"];
Print["  |dF/dn|:     ", N[Correlation[comparison[[All, 2]], Boole[comparison[[All, 4]]]], 4]];
Print["  |dF/dalpha|: ", N[Correlation[comparison[[All, 3]], Boole[comparison[[All, 4]]]], 4]];
Print[""];

(* ============================================================================ *)
(* CONCLUSION                                                                 *)
(* ============================================================================ *)

Print["================================================================"];
Print["CONCLUSION"];
Print["================================================================"];
Print[""];

Print["Derivative with respect to n:"];
Print[""];
Print["1. FORMULA:"];
Print["   dF/dn = Sum Sum -2*alpha*(n-kd-d^2) / [(n-kd-d^2)^2+eps]^(alpha+1)"];
Print[""];

Print["2. KEY PROPERTY:"];
Print["   - Derivative is ZERO at exact factorizations (n-kd-d^2=0)"];
Print["   - Composites: dominant term contributes 0 to derivative"];
Print["   - Primes: all terms contribute non-zero"];
Print[""];

Print["3. STRATIFICATION:"];
Print["   - Mean |dF/dn| for composites: ", N[meanDerivComp, 4]];
Print["   - Mean |dF/dn| for primes: ", N[meanDerivPrime, 4]];
Print["   - Ratio: ", N[meanDerivComp/meanDerivPrime, 3], "x"];
Print[""];

Print["4. COMPARISON WITH dF/dalpha:"];
Print["   - Both derivatives stratify primes vs composites"];
Print["   - dF/dn measures rate of change in integer space"];
Print["   - dF/dalpha measures sensitivity to power parameter"];
Print[""];

Print["5. DOES IT SIMPLIFY?"];
Print["   NO - derivative adds complexity:"];
Print["   - Numerator: (n-kd-d^2) factor"];
Print["   - Power increases: alpha -> alpha+1"];
Print["   - Still double infinite sum"];
Print[""];

Print["The derivative provides ANALYTICAL INSIGHT but not SIMPLIFICATION."];
Print[""];
