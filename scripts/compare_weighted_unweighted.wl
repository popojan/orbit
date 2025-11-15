#!/usr/bin/env wolframscript
(* Direct comparison: Weighted vs Unweighted P-norm *)

Print["================================================================"];
Print["WEIGHTED vs UNWEIGHTED P-NORM COMPARISON"];
Print["================================================================"];
Print[""];
Print["Both using: p=3, epsilon=1.0, s=1.0, sigma=1.5"];
Print[""];

(* ============================================================================ *)
(* WEIGHTED VERSION                                                            *)
(* ============================================================================ *)

SoftMinWeighted[x_, d_, p_, eps_] := Module[{distances, powerSum, count},
  distances = Table[(x - (k*d + d^2))^2 + eps, {k, 0, Floor[x/d]}];
  count = Length[distances];
  powerSum = Total[distances^(-p)];
  Power[powerSum / count, -1/p]  (* Division by count *)
]

FnWeighted[n_, s_] := Module[{terms},
  terms = Table[
    Module[{sm}, sm = SoftMinWeighted[n, d, 3, 1.0]; If[sm > 1, sm^(-s), 0]],
    {d, 2, Min[n, 100]}
  ];
  Total[terms]
]

(* ============================================================================ *)
(* UNWEIGHTED VERSION                                                          *)
(* ============================================================================ *)

SoftMinUnweighted[x_, d_, p_, eps_] := Module[{distances, powerSum},
  distances = Table[(x - (k*d + d^2))^2 + eps, {k, 0, Floor[x/d]}];
  powerSum = Total[distances^(-p)];
  Power[powerSum, -1/p]  (* NO division by count *)
]

FnUnweighted[n_, s_] := Module[{terms},
  terms = Table[
    Module[{sm}, sm = SoftMinUnweighted[n, d, 3, 1.0]; If[sm > 1, sm^(-s), 0]],
    {d, 2, Min[n, 100]}
  ];
  Total[terms]
]

(* ============================================================================ *)
(* 1. COMPARE F_n(s) VALUES                                                   *)
(* ============================================================================ *)

Print["[1/3] Comparing F_n(s=1.0) for n=2..30:"];
Print[""];
Print["n\tWeighted\tUnweighted\tRatio\t\tPrime?"];
Print["-----------------------------------------------------------------"];

Do[
  Module[{fw, fu, ratio},
    fw = FnWeighted[n, 1.0];
    fu = FnUnweighted[n, 1.0];
    ratio = fu / fw;
    Print[n, "\t", N[fw, 5], "\t\t", N[fu, 5], "\t\t", N[ratio, 4], "\t\t",
      If[PrimeQ[n], "PRIME", "comp"]]
  ],
  {n, 2, 30}
];
Print[""];

(* ============================================================================ *)
(* 2. INVERSE FORM - PRIME SEPARATION                                         *)
(* ============================================================================ *)

Print["[2/3] Inverse form prime separation (n <= 50):"];
Print[""];

s = 1.0;
sigma = 1.5;
nMax = 50;

(* Weighted inverse *)
totalInvW = Sum[1.0/(FnWeighted[n, s] * n^sigma), {n, 2, nMax}];
primeInvW = Sum[If[PrimeQ[n], 1.0/(FnWeighted[n, s] * n^sigma), 0], {n, 2, nMax}];
compInvW = Sum[If[!PrimeQ[n] && n > 1, 1.0/(FnWeighted[n, s] * n^sigma), 0], {n, 2, nMax}];

(* Unweighted inverse *)
totalInvU = Sum[1.0/(FnUnweighted[n, s] * n^sigma), {n, 2, nMax}];
primeInvU = Sum[If[PrimeQ[n], 1.0/(FnUnweighted[n, s] * n^sigma), 0], {n, 2, nMax}];
compInvU = Sum[If[!PrimeQ[n] && n > 1, 1.0/(FnUnweighted[n, s] * n^sigma), 0], {n, 2, nMax}];

Print["WEIGHTED (eps=1.0):"];
Print["  Total:       ", N[totalInvW, 6]];
Print["  Primes:      ", N[primeInvW, 6], " (", N[100*primeInvW/totalInvW, 2], "%)"];
Print["  Composites:  ", N[compInvW, 6], " (", N[100*compInvW/totalInvW, 2], "%)"];
Print[""];

Print["UNWEIGHTED (eps=1.0):"];
Print["  Total:       ", N[totalInvU, 6]];
Print["  Primes:      ", N[primeInvU, 6], " (", N[100*primeInvU/totalInvU, 2], "%)"];
Print["  Composites:  ", N[compInvU, 6], " (", N[100*compInvU/totalInvU, 2], "%)"];
Print[""];

Print["IMPROVEMENT:"];
primePctW = 100*primeInvW/totalInvW;
primePctU = 100*primeInvU/totalInvU;
Print["  Weighted prime %:    ", N[primePctW, 3], "%"];
Print["  Unweighted prime %:  ", N[primePctU, 3], "%"];
Print["  Delta:               +", N[primePctU - primePctW, 2], " percentage points"];

If[primePctU > primePctW,
  Print["  ✓ CONFIRMED: Unweighted amplifies primes"],
  Print["  ✗ Unexpected: Weighted performs better"]
];
Print[""];

(* ============================================================================ *)
(* 3. DIRECT FORM - PRIME CONTRIBUTION                                        *)
(* ============================================================================ *)

Print["[3/3] Direct form G(s,sigma) prime contribution:"];
Print[""];

(* Weighted direct *)
totalW = Sum[FnWeighted[n, s] / n^sigma, {n, 2, nMax}];
primeW = Sum[If[PrimeQ[n], FnWeighted[n, s] / n^sigma, 0], {n, 2, nMax}];
compW = Sum[If[!PrimeQ[n] && n > 1, FnWeighted[n, s] / n^sigma, 0], {n, 2, nMax}];

(* Unweighted direct *)
totalU = Sum[FnUnweighted[n, s] / n^sigma, {n, 2, nMax}];
primeU = Sum[If[PrimeQ[n], FnUnweighted[n, s] / n^sigma, 0], {n, 2, nMax}];
compU = Sum[If[!PrimeQ[n] && n > 1, FnUnweighted[n, s] / n^sigma, 0], {n, 2, nMax}];

Print["WEIGHTED:"];
Print["  Prime %:     ", N[100*primeW/totalW, 2], "%"];
Print["  Composite %: ", N[100*compW/totalW, 2], "%"];
Print[""];

Print["UNWEIGHTED:"];
Print["  Prime %:     ", N[100*primeU/totalU, 2], "%"];
Print["  Composite %: ", N[100*compU/totalU, 2], "%"];
Print[""];

(* ============================================================================ *)
(* SUMMARY                                                                     *)
(* ============================================================================ *)

Print["================================================================"];
Print["SUMMARY"];
Print["================================================================"];
Print[""];

Print["KEY FINDINGS:"];
Print["  1. Inverse form (better metric):"];
Print["     - Weighted:   ", N[primePctW, 2], "% primes"];
Print["     - Unweighted: ", N[primePctU, 2], "% primes"];
Print["     - Delta:      +", N[primePctU - primePctW, 2], " pp"];
Print[""];

Print["  2. F_n ratio (unweighted/weighted):"];
sampleRatios = Table[FnUnweighted[n, 1.0]/FnWeighted[n, 1.0], {n, 2, 20}];
Print["     - Mean ratio: ", N[Mean[sampleRatios], 3]];
Print["     - Min ratio:  ", N[Min[sampleRatios], 3]];
Print["     - Max ratio:  ", N[Max[sampleRatios], 3]];
Print[""];

Print["HYPOTHESIS VALIDATION:"];
If[primePctU > 90,
  Print["  ✓ STRONG: >90% prime dominance achieved!"],
  If[primePctU > primePctW,
    Print["  ✓ CONFIRMED: Unweighted improves separation"],
    Print["  ✗ FAILED: No improvement observed"]
  ]
];
Print[""];
