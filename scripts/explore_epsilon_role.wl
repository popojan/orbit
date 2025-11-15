#!/usr/bin/env wolframscript
(* Systematic exploration of epsilon's role *)

Print["================================================================"];
Print["EPSILON EXPLORATION: Why is it crucial?"];
Print["================================================================"];
Print[""];

(* ============================================================================ *)
(* PART 1: What happens for composites with epsilon=0?                        *)
(* ============================================================================ *)

Print["[1/5] Composite numbers at epsilon=0"];
Print[""];

Print["For composite n, there EXISTS (d,k) with n = kd + d^2"];
Print["  => dist = n - kd - d^2 = 0"];
Print["  => term = 0^(-2*alpha) = INFINITY"];
Print[""];

Print["Example: n=35 = 5*7"];
Print[""];

n = 35;

Print["Finding exact factorization:"];
For[d = 2, d <= Floor[Sqrt[n]], d++,
  Module[{k},
    k = (n - d^2) / d;
    If[IntegerQ[k] && k >= 0,
      Print["  d=", d, ", k=", k, ": ", k, "*", d, " + ", d, "^2 = ", k*d + d^2];
      If[k*d + d^2 == n,
        Print["    => EXACT MATCH! dist=0"];
      ];
    ];
  ];
];

Print[""];
Print["Without epsilon, F_35(alpha, 0) = INFINITY"];
Print[""];

Print["================================================================"];
Print["[2/5] Role of epsilon: Regularization"];
Print["================================================================"];
Print[""];

Print["Epsilon provides REGULARIZATION:"];
Print["  - Prevents division by zero"];
Print["  - Allows us to evaluate function even for composites"];
Print["  - Creates smooth interpolation"];
Print[""];

Print["For epsilon > 0:"];
Print["  [(n-kd-d^2)^2 + eps]^(-alpha) is FINITE for all (d,k)"];
Print[""];

Print["As epsilon -> 0:"];
Print["  - Primes: all dist != 0, limit exists and is FINITE"];
Print["  - Composites: some dist = 0, limit -> INFINITY"];
Print[""];

Print["This is the KEY DISCRIMINATOR!"];
Print[""];

Print["================================================================"];
Print["[3/5] Epsilon as continuation parameter"];
Print["================================================================"];
Print[""];

Print["Think of epsilon as ANALYTIC CONTINUATION:"];
Print[""];

Print["For epsilon > 0: Function is smooth, defined everywhere"];
Print["As epsilon -> 0: Singularities emerge at factorizations"];
Print[""];

Print["This is similar to:"];
Print["  - Dirac delta: lim_{eps->0} (1/pi) * eps/(x^2 + eps^2)"];
Print["  - Zeta regularization: zeta(s, eps) analytically continued"];
Print["  - Dimensional regularization in physics"];
Print[""];

Print["Our case:"];
Print["  F_n(alpha, eps) is analytic in eps for eps > 0"];
Print["  Limit eps -> 0 reveals POLES at composite n"];
Print[""];

Print["================================================================"];
Print["[4/5] Epsilon dependence: Numerical exploration"];
Print["================================================================"];
Print[""];

Print["Computing F_n(3, eps) for n=35 (composite) and n=37 (prime)"];
Print["at various epsilon values:"];
Print[""];

alpha = 3;
epsilonValues = {1, 0.1, 0.01, 0.001, 0.0001};

Print["epsilon\tF_35(3,eps)\tF_37(3,eps)\tRatio"];
Print[StringRepeat["-", 60]];

Do[
  Module[{f35, f37, ratio, dMax, kMax},
    dMax = 10;
    kMax = 50;

    (* Compute for n=35 *)
    f35 = 0;
    For[d = 2, d <= dMax, d++,
      For[k = 0, k <= kMax, k++,
        Module[{dist},
          dist = (35 - k*d - d^2)^2 + eps;
          f35 += dist^(-alpha);
        ];
      ];
    ];

    (* Compute for n=37 *)
    f37 = 0;
    For[d = 2, d <= dMax, d++,
      For[k = 0, k <= kMax, k++,
        Module[{dist},
          dist = (37 - k*d - d^2)^2 + eps;
          f37 += dist^(-alpha);
        ];
      ];
    ];

    ratio = f35 / f37;
    Print[eps, "\t", N[f35, 6], "\t", N[f37, 6], "\t", N[ratio, 6]];
  ],
  {eps, epsilonValues}
];

Print[""];
Print["Observation: As eps -> 0, F_35 EXPLODES while F_37 stays finite"];
Print[""];

Print["================================================================"];
Print["[5/5] Analytical structure: Poles and residues"];
Print["================================================================"];
Print[""];

Print["For composite n with factorization n = k_0*d_0 + d_0^2:"];
Print[""];

Print["Near epsilon = 0, the term with (d_0, k_0) dominates:"];
Print["  F_n ~ eps^(-alpha) as eps -> 0"];
Print[""];

Print["This is a POLE of order alpha at eps = 0"];
Print[""];

Print["The RESIDUE of this pole depends on:"];
Print["  - How many exact factorizations n has"];
Print["  - Multiplicity of each factorization"];
Print[""];

Print["For primes:"];
Print["  No pole at eps = 0"];
Print["  F_p(alpha, eps) has a well-defined limit"];
Print[""];

Print["================================================================"];
Print["DEEPER INSIGHT: Epsilon as 'temperature'"];
Print["================================================================"];
Print[""];

Print["Physical analogy:"];
Print["  - epsilon = temperature"];
Print["  - F_n = partition function"];
Print["  - As T -> 0 (eps -> 0): System 'freezes'"];
Print[""];

Print["For primes:"];
Print["  - Smooth cooling (second-order transition?)"];
Print["  - Finite ground state energy"];
Print[""];

Print["For composites:"];
Print["  - Singular cooling (first-order transition)"];
Print["  - Divergent ground state"];
Print["  - Exact factorization = 'crystallization point'"];
Print[""];

Print["This suggests primality testing via PHASE TRANSITIONS!"];
Print[""];

Print["================================================================"];
Print["NEXT STEPS"];
Print["================================================================"];
Print[""];

Print["1. Study the RESIDUE at eps=0 for composites"];
Print["   Res_{eps=0} F_n(alpha, eps) = ?"];
Print[""];

Print["2. Investigate CRITICAL EXPONENTS"];
Print["   F_n ~ eps^(-gamma) with gamma = alpha for composites"];
Print[""];

Print["3. Explore FINITE EPSILON behavior"];
Print["   Can we choose optimal eps for discrimination?"];
Print[""];

Print["4. Connection to ZETA ZEROS?"];
Print["   Poles of F_n vs zeros of zeta - any relationship?"];
Print[""];

Print["5. EPSILON EXPANSION"];
Print["   F_n(alpha, eps) = f_0 + f_1*eps + f_2*eps^2 + ..."];
Print["   What are the coefficients?"];
Print[""];
