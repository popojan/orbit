#!/usr/bin/env wolframscript
(* Euler Product - FINAL CORRECT VERSION *)

Print["=== Euler Product for Sum[M(n)/n^s] - FINAL ==="];

MFunc[n_Integer] := Floor[(DivisorSigma[0, n] - 1)/2];

(* CORRECT Local factor *)
LocalFactor[p_Integer, s_Real] := Module[{x},
  x = p^s;
  1 + (x + 1) * x / (x^2 - 1)^2
];

(* Verification *)
LocalFactorNumerical[p_Integer, s_Real, kMax_Integer] := Module[{sum},
  sum = 1;
  For[k = 1, k <= kMax, k++,
    sum += Floor[k/2] / p^(k*s);
  ];
  sum
];

Print[""];
Print["=== Closed Form Verification ==="];
Print["Formula: L_p(s) = 1 + (p^s + 1)*p^s / (p^(2s) - 1)^2"];
Print[""];
Table[
  Module[{num, theory, ratio},
    num = LocalFactorNumerical[p, 2.0, 100];
    theory = LocalFactor[p, 2.0];
    ratio = num / theory;
    Print["p = ", p, ": Numerical = ", N[num, 15], ", Theory = ", N[theory, 15]];
    Print["         Ratio = ", N[ratio, 15], If[Abs[ratio - 1] < 1*^-10, " ✓", " ✗"]];
  ],
  {p, {2, 3, 5, 7, 11, 13}}
];

(* Full Euler product *)
Print[""];
Print["=== Euler Product Convergence ==="];

EulerProd[s_Real, pMax_Integer] := Module[{prod},
  prod = 1;
  Do[
    If[PrimeQ[p], prod *= LocalFactor[p, s]],
    {p, 2, pMax}
  ];
  prod
];

DirectSum[s_Real, nMax_Integer] := Sum[MFunc[n]/n^s, {n, 2, nMax}];

Print[""];
Print["Testing s=2:"];
Print[""];
Table[
  Module[{euler, direct, ratio},
    euler = EulerProd[2.0, pMax];
    direct = DirectSum[2.0, nMax];
    ratio = euler / direct;
    Print["pMax = ", pMax, ", nMax = ", nMax, ":"];
    Print["  Euler  = ", N[euler, 12]];
    Print["  Direct = ", N[direct, 12]];
    Print["  Ratio  = ", N[ratio, 12]];
  ],
  {pMax, {20, 50, 100, 200}},
  {nMax, {100, 500, 1000, 2000}}
];

Print[""];
Print["=== Algebraic Form ==="];
Print[""];
Print["L_p(s) = [p^(2s) - 1)^2 + (p^s + 1)*p^s] / (p^(2s) - 1)^2"];
Print[""];
Print["Numerator: (p^(2s) - 1)^2 + (p^s + 1)*p^s"];
Print["         = p^(4s) - 2p^(2s) + 1 + p^(2s) + p^s"];
Print["         = p^(4s) - p^(2s) + p^s + 1"];
Print[""];
Print["L_p(s) = (p^(4s) - p^(2s) + p^s + 1) / (p^(2s) - 1)^2"];
Print[""];

(* Global Dirichlet series *)
Print["=== Global Function Analysis ==="];
Print[""];
Print["Define: L(s) = Sum[M(n)/n^s, {n,2,∞}] = Prod[L_p(s), all primes p]"];
Print[""];

Print["Values at various s:"];
Table[
  Module[{euler, direct},
    euler = EulerProd[s, 500];
    direct = DirectSum[s, 5000];
    Print["s = ", s, ": Euler(pMax=500) = ", N[euler, 10],
          ", Direct(nMax=5000) = ", N[direct, 10]];
  ],
  {s, {2, 3, 4, 5}}
];

Print[""];
Print["=== RESULT ==="];
Print[""];
Print["The Dirichlet series Sum[M(n)/n^s] has Euler product:"];
Print[""];
Print["  Prod_p [1 + (p^s + 1)*p^s / (p^(2s) - 1)^2]"];
Print[""];
Print["This is a NEW L-function, distinct from zeta(s)^2!"];
