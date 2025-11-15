#!/usr/bin/env wolframscript
(* Global Function G(s, alpha, epsilon) - Connection to Zeta *)

Print["=== Global Function G(s, alpha, epsilon) - Zeta Connection ==="];
Print[""];

(* Compute M(n) exactly *)
MFunc[n_Integer] := Floor[(DivisorSigma[0, n] - 1)/2];

(* Compute F_n(alpha, epsilon) efficiently *)
ComputeFn[n_Integer, alpha_Integer, epsilon_Real] := Module[{fn, dMax, kMax, d, k, dist},
  dMax = Floor[Sqrt[n]] + 20;
  kMax = n;

  fn = 0;
  For[d = 2, d <= dMax, d++,
    For[k = 0, k <= kMax, k++,
      dist = (n - k*d - d^2)^2 + epsilon;
      fn += dist^(-alpha);
    ];
  ];
  fn
];

(* Global function: G(s, alpha, epsilon) = Sum[F_n / n^s, {n, 2, nMax}] *)
ComputeGlobal[s_Real, alpha_Integer, epsilon_Real, nMax_Integer] := Module[{G, n},
  G = 0;
  Print["Computing G(s=", s, ", alpha=", alpha, ", epsilon=", epsilon, ") for n up to ", nMax];

  For[n = 2, n <= nMax, n++,
    If[Mod[n, 10] == 0, Print["  n = ", n]];
    G += ComputeFn[n, alpha, epsilon] / n^s;
  ];

  G
];

(* Compare with classical functions *)
CompareWithZeta[s_Real, alpha_Integer, epsilon_Real, nMax_Integer] := Module[{G, residueG,zetaSq, ratio},
  (* Compute G *)
  G = ComputeGlobal[s, alpha, epsilon, nMax];

  (* Compute residue: epsilon^alpha * G *)
  residueG = epsilon^alpha * G;

  (* Compare with Sum[M(n)/n^s] *)
  Print[""];
  Print["=== Comparison ==="];
  Print["epsilon^alpha * G(s=", s, ") = ", N[residueG, 10]];

  (* Compute Sum[M(n)/n^s] directly *)
  sumM = Sum[MFunc[n] / n^s, {n, 2, nMax}];
  Print["Sum[M(n)/n^s, n=2..", nMax, "] = ", N[sumM, 10]];
  Print["Difference: ", N[Abs[residueG - sumM], 10]];

  (* Compare with zeta(s)^2 / 2 - approximate for large s *)
  zetaSq = Zeta[s]^2;
  Print[""];
  Print["Zeta(", s, ")^2 = ", N[zetaSq, 10]];
  Print["(Zeta(", s, ")^2 - 1) / 2 = ", N[(zetaSq - 1)/2, 10]];
  Print["Ratio [Sum M(n)/n^s] / [(zeta^2 - 1)/2] = ", N[sumM / ((zetaSq - 1)/2), 10]];

  (* Return results *)
  {G, residueG, sumM, zetaSq}
];

(* Test for multiple values of s *)
Print[""];
Print["=== Test 1: s=2, alpha=3, epsilon=0.01, nMax=50 ==="];
results2 = CompareWithZeta[2.0, 3, 0.01, 50];

Print[""];
Print["=== Test 2: s=3, alpha=3, epsilon=0.01, nMax=50 ==="];
results3 = CompareWithZeta[3.0, 3, 0.01, 50];

Print[""];
Print["=== Test 3: s=4, alpha=3, epsilon=0.01, nMax=50 ==="];
results4 = CompareWithZeta[4.0, 3, 0.01, 50];

(* Analyze epsilon dependence for fixed s *)
Print[""];
Print["=== Epsilon Dependence (s=2, alpha=3, nMax=30) ==="];
epsilonValues = {0.1, 0.01, 0.001};
residues = Table[
  Module[{G, res},
    Print["epsilon = ", eps];
    G = ComputeGlobal[2.0, 3, eps, 30];
    res = eps^3 * G;
    Print["  epsilon^3 * G = ", N[res, 10]];
    res
  ],
  {eps, epsilonValues}
];

sumM30 = Sum[MFunc[n] / n^2, {n, 2, 30}];
Print["Target: Sum[M(n)/n^2, n=2..30] = ", N[sumM30, 10]];
Print["Convergence: ", N[residues, 10]];

Print[""];
Print["=== Analysis Complete ==="];
Print["Look for: residue → Sum[M(n)/n^s] as epsilon → 0"];
Print["Check if: Sum[M(n)/n^s] ≈ (zeta(s)^2 - corrections) / 2"];
