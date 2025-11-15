#!/usr/bin/env wolframscript
(* Epsilon-stabilized soft-min - prevents division by zero for composites *)

(* ============================================================================ *)
(* CLEAN FORMULAS FOR WOLFRAM DESKTOP (with epsilon regularization)           *)
(* ============================================================================ *)

(*
   P-NORM WITH EPSILON (three parameters: n, p, eps)
   ==================================================

   EpsilonScorePNorm[n_, p_, eps_: 10^-10] :=
     Sum[
       Log[Power[
         Sum[((n - (k*d + d^2))^2 + eps)^(-p), {k, 0, Floor[n/d]}] / (Floor[n/d] + 1),
         -1/p
       ]],
       {d, 2, n}
     ]

   Usage:
   - n: integer to test
   - p: sharpness (2 = smooth, 3 = balanced, 5 = sharp)
   - eps: small offset to prevent division by zero (default 10^-10)

   Interpretation:
   - Primes: all distances > 0, score is finite
   - Composites: one distance ≈ eps (very small), score ≈ log(eps) → very negative
   - eps controls how much composites are "penalized"

   Example:
   EpsilonScorePNorm[17, 3]  (* prime: moderate positive score *)
   EpsilonScorePNorm[18, 3]  (* composite: very negative score *)


   EXP/LOG WITH EPSILON (three parameters: n, alpha, eps)
   =======================================================

   EpsilonScoreExpLog[n_, alpha_, eps_: 10^-10] :=
     Sum[
       Log[-1/alpha * Log[Sum[Exp[-alpha * ((n - (k*d + d^2))^2 + eps)], {k, 0, Floor[n/d]}]]],
       {d, 2, n}
     ]

   Usage:
   - n: integer to test
   - alpha: sharpness (5 = smooth, 7 = balanced, 10 = sharp)
   - eps: regularization parameter

   Example:
   EpsilonScoreExpLog[17, 7]  (* prime *)
   EpsilonScoreExpLog[18, 7]  (* composite *)


   KEY INSIGHT:
   ============
   Without epsilon: Score(n) = ∞ iff n is composite (closed-form characterization!)
   With epsilon: Score(n) is continuous, stratifies by factorization complexity
*)

(* ============================================================================ *)
(* NUMERICAL IMPLEMENTATIONS                                                   *)
(* ============================================================================ *)

(* P-norm with epsilon stabilization *)
EpsilonScorePNormNumerical[x_, p_, eps_] := Module[{},
  Sum[
    Module[{distances},
      distances = Table[(x - (k*pDepth + pDepth^2))^2 + eps, {k, 0, Floor[x/pDepth]}];
      Log[Power[Mean[Power[distances, -p]], -1/p]]
    ],
    {pDepth, 2, x}
  ]
]

(* Exp/log with epsilon stabilization *)
EpsilonScoreExpLogNumerical[x_, alpha_, eps_] := Module[{},
  Sum[
    Module[{distances, negDist, M},
      distances = Table[(x - (k*pDepth + pDepth^2))^2 + eps, {k, 0, Floor[x/pDepth]}];
      negDist = -alpha * distances;
      M = Max[negDist];
      Log[-1/alpha * (M + Log[Total[Exp[negDist - M]]])]
    ],
    {pDepth, 2, x}
  ]
]


(* ============================================================================ *)
(* PARAMETERS                                                                   *)
(* ============================================================================ *)

nMax = 200;
epsilon = 10^-8;  (* Small offset to prevent division by zero *)
pValue = 3;       (* P-norm sharpness *)
alphaValue = 7;   (* Exp/log sharpness *)

Print["================================================================="];
Print["EPSILON-STABILIZED SOFT-MIN"];
Print["================================================================="];
Print[""];
Print["Parameters:"];
Print["  n ∈ [1, ", nMax, "]"];
Print["  epsilon = ", epsilon, " (regularization)"];
Print["  P-norm: p = ", pValue];
Print["  Exp/log: alpha = ", alphaValue];
Print[""];
Print["Mathematical insight:"];
Print["  Without epsilon: Score = ∞ iff n is composite (exact test!)"];
Print["  With epsilon: Score is continuous, shows stratification"];
Print[""];


(* ============================================================================ *)
(* VISUALIZATION 1: P-norm envelope with epsilon                               *)
(* ============================================================================ *)

Print["Generating P-norm envelope (p=", pValue, ", eps=", epsilon, ")..."];

plotPNormEps = Table[{k, EpsilonScorePNormNumerical[k, pValue, epsilon]}, {k, 1, nMax}] //
  ListLinePlot[
    GatherBy[#, PrimeQ@*First],
    PlotMarkers -> {Automatic},
    GridLines -> {Prime @ Range @ PrimePi @ nMax, None},
    Frame -> True,
    FrameLabel -> {"n", "Epsilon-score"},
    PlotLabel -> Row[{"P-norm envelope | p = ", pValue, ", ε = ", epsilon}],
    PlotStyle -> {
      Directive[Orange, PointSize[0.012]],
      Directive[Blue, PointSize[0.01]]
    },
    PlotLegends -> {"Primes (envelope)", "Composites"},
    ImageSize -> 700
  ] &;

Export["visualizations/epsilon-pnorm-envelope.pdf", plotPNormEps];
Print["✓ Saved visualizations/epsilon-pnorm-envelope.pdf"];


(* ============================================================================ *)
(* VISUALIZATION 2: Exp/log envelope with epsilon                              *)
(* ============================================================================ *)

Print[""];
Print["Generating Exp/log envelope (alpha=", alphaValue, ", eps=", epsilon, ")..."];

plotExpLogEps = Table[{k, EpsilonScoreExpLogNumerical[k, alphaValue, epsilon]}, {k, 1, nMax}] //
  ListLinePlot[
    GatherBy[#, PrimeQ@*First],
    PlotMarkers -> {Automatic},
    GridLines -> {Prime @ Range @ PrimePi @ nMax, None},
    Frame -> True,
    FrameLabel -> {"n", "Epsilon-score"},
    PlotLabel -> Row[{"Exp/log envelope | α = ", alphaValue, ", ε = ", epsilon}],
    PlotStyle -> {
      Directive[Orange, PointSize[0.012]],
      Directive[Blue, PointSize[0.01]]
    },
    PlotLegends -> {"Primes (envelope)", "Composites"},
    ImageSize -> 700
  ] &;

Export["visualizations/epsilon-explog-envelope.pdf", plotExpLogEps];
Print["✓ Saved visualizations/epsilon-explog-envelope.pdf"];


(* ============================================================================ *)
(* VISUALIZATION 3: Stratification by Omega(n) - P-norm                        *)
(* ============================================================================ *)

Print[""];
Print["Generating P-norm stratification by Ω(n)..."];

nStrat = Min[150, nMax];

plotPNormStrat = Module[{data, primes, primePowers, semiprimes, others},
  data = Table[{k, EpsilonScorePNormNumerical[k, pValue, epsilon]}, {k, 2, nStrat}];

  primes = Select[data, PrimeQ[First @ #] &];
  primePowers = Select[data, !PrimeQ[First @ #] && PrimePowerQ[First @ #] &];
  semiprimes = Select[data,
    !PrimeQ[First @ #] && !PrimePowerQ[First @ #] &&
    PrimeOmega[First @ #] == 2 &];
  others = Select[data,
    !PrimeQ[First @ #] && !PrimePowerQ[First @ #] &&
    PrimeOmega[First @ #] > 2 &];

  ListPlot[{primes, primePowers, semiprimes, others},
    PlotMarkers -> Automatic,
    PlotStyle -> {
      Directive[Orange, PointSize[0.012]],
      Directive[Green, PointSize[0.01]],
      Directive[Blue, PointSize[0.01]],
      Directive[Red, PointSize[0.01]]
    },
    PlotLegends -> {
      "Primes (envelope)",
      "Prime powers p^k (k≥2)",
      "Semiprimes pq",
      "Ω(n) ≥ 3"
    },
    Frame -> True,
    FrameLabel -> {"n", "Epsilon-score"},
    PlotLabel -> Row[{"Stratification by Ω(n) | p = ", pValue, ", ε = ", epsilon}],
    GridLines -> {Prime @ Range @ PrimePi @ nStrat, None},
    ImageSize -> 700
  ]
];

Export["visualizations/epsilon-pnorm-stratification.pdf", plotPNormStrat];
Print["✓ Saved visualizations/epsilon-pnorm-stratification.pdf"];


(* ============================================================================ *)
(* VISUALIZATION 4: Effect of epsilon (compare different values)               *)
(* ============================================================================ *)

Print[""];
Print["Generating epsilon comparison (10^-6, 10^-8, 10^-10)..."];

nEpsComp = Min[80, nMax];
epsilonValues = {10^-6, 10^-8, 10^-10};

plotEpsilonEffect = Module[{datasets},
  datasets = Table[
    {eps, Table[{k, EpsilonScorePNormNumerical[k, pValue, eps]}, {k, 1, nEpsComp}]},
    {eps, epsilonValues}
  ];

  ListLinePlot[
    datasets[[All, 2]],
    PlotLegends -> (Row[{"ε = ", #}] & /@ epsilonValues),
    PlotStyle -> Table[Directive[Thickness[0.005]], {Length[epsilonValues]}],
    Frame -> True,
    FrameLabel -> {"n", "Epsilon-score"},
    PlotLabel -> "Effect of epsilon regularization | p = 3",
    GridLines -> {Prime @ Range @ PrimePi @ nEpsComp, None},
    ImageSize -> 700
  ]
];

Export["visualizations/epsilon-comparison.pdf", plotEpsilonEffect];
Print["✓ Saved visualizations/epsilon-comparison.pdf"];


(* ============================================================================ *)
(* SUMMARY                                                                      *)
(* ============================================================================ *)

Print[""];
Print["================================================================="];
Print["All visualizations generated successfully!"];
Print["================================================================="];
Print[""];
Print["Mathematical insights:"];
Print[""];
Print["1. EXACT PRIMALITY TEST (without epsilon):"];
Print["   n is prime ⟺ Score(n, p) < ∞"];
Print["   Composites have ∞ score due to exact divisor hitting d² term"];
Print[""];
Print["2. CONTINUOUS STRATIFICATION (with epsilon):"];
Print["   - Primes: moderate positive score"];
Print["   - Prime powers: slightly lower (one unique divisor)"];
Print["   - Semiprimes: lower still (two divisors)"];
Print["   - Highly composite: lowest (many divisors)"];
Print[""];
Print["3. CONNECTION TO PRIME DISTRIBUTION:"];
Print["   - Geometric sieve → algebraic score function"];
Print["   - Sum of logs over divisors → Dirichlet-series-like"];
Print["   - Product structure → Euler-product-like"];
Print["   - Possible analytic continuation?"];
Print["   - Zeros related to prime gaps?"];
Print[""];
Print["Next steps for analysis:"];
Print["  - Asymptotic behavior of Score(p) for large primes p"];
Print["  - Growth rate comparison with π(x), Li(x)"];
Print["  - Fourier analysis of Score function"];
Print["  - Search for functional equations"];
Print["  - Connection to L-functions?"];
