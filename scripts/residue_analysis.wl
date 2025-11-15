#!/usr/bin/env wolframscript
(* Residue at epsilon=0 for composite numbers *)

Print["================================================================"];
Print["RESIDUE ANALYSIS: Poles at epsilon=0"];
Print["================================================================"];
Print[""];

(* ============================================================================ *)
(* THEORY: Laurent expansion near eps=0                                       *)
(* ============================================================================ *)

Print["[1/3] Laurent expansion for composites"];
Print[""];

Print["For composite n with factorization n = k_0*d_0 + d_0^2:"];
Print[""];

Print["Near eps=0, the dominant term is:"];
Print["  T_{d_0,k_0} = [(n - k_0*d_0 - d_0^2)^2 + eps]^(-alpha)"];
Print["              = [0 + eps]^(-alpha)"];
Print["              = eps^(-alpha)"];
Print[""];

Print["All other terms remain FINITE as eps -> 0."];
Print[""];

Print["Therefore:"];
Print["  F_n(alpha, eps) = eps^(-alpha) + A_0 + A_1*eps + A_2*eps^2 + ..."];
Print[""];

Print["This is a Laurent series with a POLE of order alpha at eps=0"];
Print[""];

Print["Residue (for simple pole): Res = lim_{eps->0} eps * F_n(alpha, eps)"];
Print["  For our pole of order alpha:"];
Print["  Leading coefficient = lim_{eps->0} eps^alpha * F_n(alpha, eps) = 1"];
Print[""];

Print["================================================================"];
Print["[2/3] Numerical verification"];
Print["================================================================"];
Print[""];

n = 35;
alpha = 3;

Print["For n=35, alpha=3:"];
Print[""];

Print["Computing eps^alpha * F_35(alpha, eps) as eps -> 0:"];
Print[""];

epsilonValues = {1, 0.1, 0.01, 0.001, 0.0001, 0.00001};

Print["epsilon\tF_35\t\teps^3 * F_35\tShould approach 1"];
Print[StringRepeat["-", 70]];

Do[
  Module[{f35, dMax, kMax, scaled},
    dMax = 10;
    kMax = 50;

    f35 = 0;
    For[d = 2, d <= dMax, d++,
      For[k = 0, k <= kMax, k++,
        Module[{dist},
          dist = (n - k*d - d^2)^2 + eps;
          f35 += dist^(-alpha);
        ];
      ];
    ];

    scaled = eps^alpha * f35;
    Print[eps, "\t", ScientificForm[f35, 4], "\t", N[scaled, 8]];
  ],
  {eps, epsilonValues}
];

Print[""];
Print["Observation: eps^3 * F_35 -> 1 as eps -> 0"];
Print["  => Leading term is exactly eps^(-3)"];
Print[""];

Print["================================================================"];
Print["[3/3] Residue depends on NUMBER of factorizations"];
Print["================================================================"];
Print[""];

Print["Q: What if n has MULTIPLE factorizations?"];
Print[""];

Print["Example: n = 60 = 2*2*3*5"];
Print[""];

Print["Finding all factorizations 60 = kd + d^2:"];
Print[""];

n = 60;
factorizations = {};

For[d = 2, d <= Floor[Sqrt[n]], d++,
  Module[{k},
    k = (n - d^2) / d;
    If[IntegerQ[k] && k >= 0,
      Print["  d=", d, ", k=", k, ": ", k, "*", d, " + ", d, "^2 = ", k*d + d^2];
      If[k*d + d^2 == n,
        AppendTo[factorizations, {d, k}];
      ];
    ];
  ];
];

Print[""];
Print["Number of exact factorizations: ", Length[factorizations]];
Print[""];

If[Length[factorizations] > 1,
  Print["Multiple poles at eps=0!"];
  Print[""];
  Print["Laurent expansion:"];
  Print["  F_60(3, eps) = ", Length[factorizations], " * eps^(-3) + (finite terms)"];
  Print[""];
  Print["Residue coefficient = ", Length[factorizations]];
,
  Print["Only one factorization"];
];

Print[""];

(* Verify numerically *)
Print["Numerical verification for n=60:"];
Print[""];

epsilonTest = {0.1, 0.01, 0.001};
Print["epsilon\tF_60\t\teps^3 * F_60"];
Print[StringRepeat["-", 50]];

Do[
  Module[{f60, scaled},
    f60 = 0;
    For[d = 2, d <= 10, d++,
      For[k = 0, k <= 50, k++,
        Module[{dist},
          dist = (60 - k*d - d^2)^2 + eps;
          f60 += dist^(-alpha);
        ];
      ];
    ];

    scaled = eps^alpha * f60;
    Print[eps, "\t", ScientificForm[f60, 4], "\t", N[scaled, 6]];
  ],
  {eps, epsilonTest}
];

Print[""];

Print["================================================================"];
Print["IMPLICATIONS"];
Print["================================================================"];
Print[""];

Print["1. POLE STRENGTH encodes factorization COUNT"];
Print["   - Simple composite (like 35): residue ~ 1"];
Print["   - Highly composite (like 60): residue ~ M"];
Print["     where M = number of factorizations"];
Print[""];

Print["2. This gives QUANTITATIVE measure of 'compositeness'"];
Print["   - Not just prime/composite binary"];
Print["   - Degree of compositeness encoded in residue"];
Print[""];

Print["3. PRACTICAL primality test:"];
Print["   - Compute eps^alpha * F_n(alpha, eps) for small eps"];
Print["   - If result ~ 1 or more: COMPOSITE"];
Print["   - If result ~ 0: PRIME"];
Print[""];

Print["4. Connection to tau(n) (divisor function)?"];
Print["   - Number of factorizations related to divisors"];
Print["   - But not identical (geometric constraint kd+d^2=n)"];
Print[""];

Print["================================================================"];
Print["NEXT: Epsilon expansion coefficients"];
Print["================================================================"];
Print[""];

Print["For PRIMES (no pole):"];
Print["  F_p(alpha, eps) = A_0 + A_1*eps + A_2*eps^2 + ..."];
Print[""];

Print["What are the coefficients A_i?"];
Print["  A_0 = F_p(alpha, 0) (the value we computed earlier)"];
Print["  A_1 = dF_p/deps |_{eps=0}"];
Print["  A_2 = (1/2) * d^2F_p/deps^2 |_{eps=0}"];
Print[""];

Print["These derivatives might reveal additional structure!");
Print[""];
