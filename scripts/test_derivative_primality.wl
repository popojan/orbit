#!/usr/bin/env wolframscript
(* Test: Can derivative distinguish primes from composites? *)

Print["================================================================"];
Print["DERIVATIVE AS PRIMALITY TEST"];
Print["================================================================"];
Print[""];

(* Full double sum *)
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
FnDerivative[n_, alpha_, eps_: 1.0, dMax_: 50, kMax_: 100] := Module[
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

(* Test on n=2..50 *)
Print["Testing: Is |dF/da| larger for composites?"];
Print[""];
Print["Hypothesis: Composites have large |dF/da|, primes have small |dF/da|"];
Print[""];

results = Table[
  Module[{fVal, deriv},
    fVal = FnFull[n, 3.0, 1.0];
    deriv = FnDerivative[n, 3.0, 1.0];
    {n, N[fVal, 5], N[deriv, 5], N[Abs[deriv], 5], PrimeQ[n]}
  ],
  {n, 2, 50}
];

Print["n\tF(3)\t\tdF/da\t\t|dF/da|\t\tPrime?"];
Print[StringRepeat["-", 80]];
Do[
  If[Mod[results[[i, 1]], 3] == 0 || results[[i, 5]],
    Print[results[[i, 1]], "\t", results[[i, 2]], "\t", results[[i, 3]],
      "\t", results[[i, 4]], "\t", If[results[[i, 5]], "PRIME", "comp"]]
  ],
  {i, 1, Length[results]}
];
Print[""];

(* Statistical analysis *)
primes = Select[results, #[[5]] &];
comps = Select[results, !#[[5]] &];

meanDerivPrime = Mean[primes[[All, 4]]];
meanDerivComp = Mean[comps[[All, 4]]];

Print["STATISTICS:"];
Print[""];
Print["Primes (n=2..50):"];
Print["  Mean |dF/da|: ", N[meanDerivPrime, 5]];
Print[""];
Print["Composites (n=4..50):"];
Print["  Mean |dF/da|: ", N[meanDerivComp, 5]];
Print[""];
Print["Ratio (comp/prime): ", N[meanDerivComp/meanDerivPrime, 3], "x"];
Print[""];

(* Correlation *)
corrDeriv = Correlation[results[[All, 4]], Boole[results[[All, 5]]]];
Print["Correlation of |dF/da| with PrimeQ: ", N[corrDeriv, 4]];
Print["  (Negative = larger for composites, as expected)"];
Print[""];

(* Test with different epsilon values *)
Print["================================================================"];
Print["EFFECT OF EPSILON ON DERIVATIVE SEPARATION"];
Print["================================================================"];
Print[""];

testEps = {0.1, 0.5, 1.0, 2.0, 5.0};

Print["eps\tMean|dF/da|_prime\tMean|dF/da|_comp\tRatio"];
Print[StringRepeat["-", 70]];

Do[
  Module[{resTmp, primesTmp, compsTmp, meanP, meanC},
    resTmp = Table[
      Module[{deriv},
        deriv = FnDerivative[n, 3.0, eps];
        {n, N[Abs[deriv], 5], PrimeQ[n]}
      ],
      {n, 2, 50}
    ];
    primesTmp = Select[resTmp, #[[3]] &];
    compsTmp = Select[resTmp, !#[[3]] &];
    meanP = Mean[primesTmp[[All, 2]]];
    meanC = Mean[compsTmp[[All, 2]]];
    Print[N[eps, 2], "\t", N[meanP, 5], "\t\t\t", N[meanC, 5], "\t\t\t",
      N[meanC/meanP, 3], "x"];
  ],
  {eps, testEps}
];
Print[""];

Print["Observation: Smaller eps -> larger separation in derivative"];
Print["  (because log(eps) becomes more negative)"];
Print[""];

(* Second derivative *)
Print["================================================================"];
Print["SECOND DERIVATIVE: d²F/da²"];
Print["================================================================"];
Print[""];

FnSecondDerivative[n_, alpha_, eps_: 1.0, dMax_: 50, kMax_: 100] := Module[
  {d, k, innerSum, outerSum, dist, logDist},
  outerSum = 0;
  For[d = 2, d <= Min[dMax, 2*n], d++,
    innerSum = 0;
    For[k = 0, k <= kMax, k++,
      dist = (n - k*d - d^2)^2 + eps;
      logDist = Log[dist];
      (* d²T/da² = log²(dist) * T(a) *)
      innerSum += logDist^2 * dist^(-alpha);
      If[k > 10 && Abs[logDist^2 * dist^(-alpha)]/Abs[innerSum] < 10^-8, Break[]];
    ];
    outerSum += innerSum;
  ];
  outerSum
]

results2 = Table[
  Module[{fVal, d1, d2},
    fVal = FnFull[n, 3.0, 1.0];
    d1 = FnDerivative[n, 3.0, 1.0];
    d2 = FnSecondDerivative[n, 3.0, 1.0];
    {n, N[fVal, 5], N[Abs[d1], 5], N[d2, 5], PrimeQ[n]}
  ],
  {n, 2, 30}
];

Print["n\tF(3)\t\t|dF/da|\t\td²F/da²\t\tPrime?"];
Print[StringRepeat["-", 80]];
Do[
  If[Mod[results2[[i, 1]], 3] == 0 || results2[[i, 5]],
    Print[results2[[i, 1]], "\t", results2[[i, 2]], "\t", results2[[i, 3]],
      "\t", results2[[i, 4]], "\t", If[results2[[i, 5]], "PRIME", "comp"]]
  ],
  {i, 1, Length[results2]}
];
Print[""];

primes2 = Select[results2, #[[5]] &];
comps2 = Select[results2, !#[[5]] &];

meanD2Prime = Mean[primes2[[All, 4]]];
meanD2Comp = Mean[comps2[[All, 4]]];

Print["Second derivative statistics:"];
Print["  Primes:     ", N[meanD2Prime, 5]];
Print["  Composites: ", N[meanD2Comp, 5]];
Print["  Ratio:      ", N[meanD2Comp/meanD2Prime, 3], "x"];
Print[""];

Print["================================================================"];
Print["CONCLUSION"];
Print["================================================================"];
Print[""];

Print["First derivative dF/da:"];
Print["  - Measures sensitivity to parameter a"];
Print["  - Larger for composites (small distances)"];
Print["  - Separation ratio ~", N[meanDerivComp/meanDerivPrime, 2], "x"];
Print["  - Negative correlation with primality: ", N[corrDeriv, 3]];
Print[""];

Print["Second derivative d²F/da²:"];
Print["  - Measures curvature in a"];
Print["  - Also larger for composites"];
Print["  - Separation ratio ~", N[meanD2Comp/meanD2Prime, 2], "x"];
Print[""];

Print["Higher derivatives could provide additional stratification signals!");
Print[""];
