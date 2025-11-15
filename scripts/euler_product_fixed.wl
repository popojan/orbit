#!/usr/bin/env wolframscript
(* Euler Product - FIXED VERSION *)

Print["=== Euler Product Analysis - CORRECTED ==="];

(* M(n) exact *)
MFunc[n_Integer] := Floor[(DivisorSigma[0, n] - 1)/2];

(* CORRECTED Pattern: M(p^k) = Floor[k/2] *)
Print[""];
Print["CORRECTED Pattern: M(p^k) = Floor[k/2]"];
Print["Verification:"];
For[k = 1, k <= 10, k++,
  Module[{theoretical, actual},
    theoretical = Floor[k/2];
    actual = MFunc[2^k];
    Print["k = ", k, ": M(2^", k, ") = ", actual, ", Floor[k/2] = ", theoretical,
      If[actual == theoretical, " ✓", " ✗"]];
  ];
];

(* CORRECTED Local factor *)
LocalFactorCorrected[p_Integer, s_Real, kMax_Integer] := Module[{sum},
  sum = 1;
  For[k = 1, k <= kMax, k++,
    sum += Floor[k/2] / p^(k*s);
  ];
  sum
];

Print[""];
Print["=== Deriving Closed Form ==="];
Print["M(p^k) = Floor[k/2]"];
Print["  k=1: M=0, k=2: M=1, k=3: M=1, k=4: M=2, k=5: M=2, ..."];
Print[""];
Print["L_p(s) = 1 + Sum[Floor[k/2]/p^(ks), {k,1,∞}]"];
Print["       = 1 + 0/p^s + 1/p^(2s) + 1/p^(3s) + 2/p^(4s) + 2/p^(5s) + ..."];
Print[""];
Print["Split into pairs (2m, 2m+1):"];
Print["  Terms for k=2m:   m/p^(2ms)"];
Print["  Terms for k=2m+1: m/p^((2m+1)s)"];
Print[""];
Print["L_p(s) = 1 + Sum[m/p^(2ms), {m,1,∞}] + Sum[m/p^((2m+1)s), {m,1,∞}]"];
Print["       = 1 + Sum[m/p^(2ms), {m,1,∞}] + (1/p^s)*Sum[m/p^(2ms), {m,1,∞}]"];
Print["       = 1 + (1 + 1/p^s) * Sum[m/p^(2ms), {m,1,∞}]"];
Print[""];
Print["Geometric series: Sum[m*x^m, m=1..∞] = x/(1-x)^2"];
Print["With x = p^(-2s):"];
Print["  Sum[m/p^(2ms), {m,1,∞}] = (1/p^(2s)) / (1 - 1/p^(2s))^2"];
Print["                           = p^(2s) / (p^(2s) - 1)^2"];
Print[""];
Print["L_p(s) = 1 + (1 + 1/p^s) * p^(2s) / (p^(2s) - 1)^2"];
Print["       = 1 + (p^s + 1) / [p^s * (p^(2s) - 1)^2]"];

(* Simplify *)
Print[""];
Print["Simplifying:"];
Print["L_p(s) = [p^s(p^(2s)-1)^2 + (p^s+1)] / [p^s(p^(2s)-1)^2]"];

LocalFactorTheory[p_Integer, s_Real] := Module[{x},
  x = p^s;
  1 + (x + 1) / (x * (x^2 - 1)^2)
];

Print[""];
Print["Verification of closed form:"];
Table[
  Module[{numerical, theoretical, ratio},
    numerical = LocalFactorCorrected[p, 2.0, 50];
    theoretical = LocalFactorTheory[p, 2.0];
    ratio = numerical / theoretical;
    Print["p = ", p, ": Numerical = ", N[numerical, 12], ", Theory = ", N[theoretical, 12],
      ", Ratio = ", N[ratio, 12]];
  ],
  {p, {2, 3, 5, 7, 11}}
];

(* Full Euler product *)
Print[""];
Print["=== Full Euler Product ==="];

EulerProduct[s_Real, pMax_Integer] := Module[{product},
  product = 1;
  Do[
    If[PrimeQ[p],
      product *= LocalFactorTheory[p, s];
    ],
    {p, 2, pMax}
  ];
  product
];

Print[""];
Print["Comparison (s=2, nMax=100):"];
Table[
  Module[{euler, direct},
    euler = EulerProduct[2.0, pMax];
    direct = Sum[MFunc[n]/n^2, {n, 2, 100}];
    Print["pMax = ", pMax, ": Euler = ", N[euler, 10], ", Direct = ", N[direct, 10],
      ", Ratio = ", N[euler/direct, 10]];
  ],
  {pMax, {10, 20, 30, 50, 100}}
];

(* Try factoring numerator *)
Print[""];
Print["=== Algebraic Structure ==="];
Print[""];
Print["Numerator analysis: x(x^2-1)^2 + (x+1)"];
Print["  = x(x-1)^2(x+1)^2 + (x+1)"];
Print["  = (x+1)[x(x-1)^2(x+1) + 1]"];
Print["  = (x+1)[x(x^2-1)(x-1) + 1]"];
Print["  = (x+1)[x(x^3 - x^2 - x + 1) + 1]"];
Print["  = (x+1)[x^4 - x^3 - x^2 + x + 1]"];
Print[""];
Print["So: L_p(s) = (x+1)[x^4 - x^3 - x^2 + x + 1] / [x(x^2-1)^2]"];
Print["           = (x+1)[x^4 - x^3 - x^2 + x + 1] / [x(x-1)^2(x+1)^2]"];
Print["           = [x^4 - x^3 - x^2 + x + 1] / [x(x-1)^2(x+1)]"];

(* Numerical check *)
Print[""];
Print["Numerical verification of algebraic form (p=2, s=2):"];
x = 2^2;
form1 = 1 + (x + 1) / (x * (x^2 - 1)^2);
form2 = (x^4 - x^3 - x^2 + x + 1) / (x * (x - 1)^2 * (x + 1));
Print["Form 1: ", N[form1, 15]];
Print["Form 2: ", N[form2, 15]];
Print["Match: ", N[form1 - form2, 15]];

Print[""];
Print["=== Summary ==="];
Print["Local factor: L_p(s) = [p^(4s) - p^(3s) - p^(2s) + p^s + 1] / [p^s(p^s-1)^2(p^s+1)]"];
Print[""];
Print["This does NOT factor into simple zeta functions!"];
Print["The Dirichlet series Sum[M(n)/n^s] has its own unique Euler product."];
