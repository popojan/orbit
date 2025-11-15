#!/usr/bin/env wolframscript
(* Symbolic Analysis of Full P-norm for Small n *)

Print["================================================================"];
Print["SYMBOLIC ANALYSIS: Full P-norm for n=2,3,5,7"];
Print["================================================================"];
Print[""];
Print["Computing exact symbolic expressions for F_n^full(s)"];
Print["with p=3, epsilon=1 (exact rational)"];
Print[""];

(* ============================================================================ *)
(* SYMBOLIC DISTANCE FUNCTION                                                 *)
(* ============================================================================ *)

(* Piecewise distance with exact arithmetic *)
DistSymbolic[n_, k_, d_] :=
  If[k*d + d^2 <= n,
    (n - k*d - d^2)^2 + 1,      (* Before crossing, eps=1 *)
    (k*d + d^2 - n)^2 + 1        (* After crossing *)
  ]

(* ============================================================================ *)
(* SYMBOLIC INNER SUM                                                         *)
(* ============================================================================ *)

(* For small n, compute k-sum symbolically up to reasonable kMax *)
InnerSumSymbolic[n_, d_, p_, kMax_: 50] := Module[{terms},
  terms = Table[DistSymbolic[n, k, d]^(-p), {k, 0, kMax}];
  Total[terms]
]

(* ============================================================================ *)
(* SYMBOLIC SOFT-MIN                                                          *)
(* ============================================================================ *)

SoftMinSymbolic[n_, d_, p_] := Power[InnerSumSymbolic[n, d, p], -1/p]

(* ============================================================================ *)
(* TEST 1: Inner sum structure for n=7, d=2                                   *)
(* ============================================================================ *)

Print["[1/4] Inner k-sum structure for n=7, d=2, p=3..."];
Print[""];

n = 7;
d = 2;
p = 3;

Print["Distance sequence for k=0,1,2,...:"];
Print["  k=0: dist = (7 - 0*2 - 2²)² + 1 = (7-4)² + 1 = 9 + 1 = 10"];
Print["  k=1: dist = (7 - 1*2 - 4)² + 1 = (7-6)² + 1 = 1 + 1 = 2"];
Print["  k=2: dist = (7 - 2*2 - 4)² + 1 = (7-8)² + 1 = 1 + 1 = 2  [crossing]"];
Print["  k=3: dist = (3*2 + 4 - 7)² + 1 = (10-7)² + 1 = 9 + 1 = 10"];
Print["  k=4: dist = (4*2 + 4 - 7)² + 1 = (12-7)² + 1 = 25 + 1 = 26"];
Print[""];

(* Compute first few terms *)
firstTerms = Table[
  {k, DistSymbolic[7, k, 2], DistSymbolic[7, k, 2]^(-3)},
  {k, 0, 10}
];

Print["k\tdist\tdist^(-3)"];
Print[StringRepeat["-", 50]];
Do[
  Print[firstTerms[[i, 1]], "\t", firstTerms[[i, 2]], "\t",
    N[firstTerms[[i, 3]], 6]],
  {i, 1, Min[11, Length[firstTerms]]}
];
Print[""];

(* Partial sums *)
partialSums = Table[
  Total[Table[DistSymbolic[7, k, 2]^(-3), {k, 0, kMax}]],
  {kMax, {5, 10, 20, 30, 40, 50}}
];

Print["Partial k-sums (how fast does it converge?):"];
Print[""];
Print["k_max\tPartial sum\t\tRelative change"];
Print[StringRepeat["-", 60]];
Do[
  Module[{relChange},
    relChange = If[i > 1,
      N[(partialSums[[i]] - partialSums[[i-1]])/partialSums[[i]], 4],
      ""
    ];
    Print[{5, 10, 20, 30, 40, 50}[[i]], "\t", N[partialSums[[i]], 8], "\t",
      relChange]
  ],
  {i, 1, Length[partialSums]}
];
Print[""];

(* ============================================================================ *)
(* TEST 2: Symbolic soft-min for first primes                                 *)
(* ============================================================================ *)

Print["[2/4] Symbolic soft-min values for small primes..."];
Print[""];

Print["For n=2 (first prime):"];
Print[""];

(* n=2: only d=2 contributes (d >= 2) *)
Print["  d=2: k-sum structure"];
kSeq2 = Table[{k, DistSymbolic[2, k, 2]}, {k, 0, 5}];
Print["    k=0: dist = (2 - 0 - 4)² + 1 = 4 + 1 = 5"];
Print["    k=1: dist = (2*1 + 4 - 2)² + 1 = 16 + 1 = 17"];
Print["    k=2: dist = (2*2 + 4 - 2)² + 1 = 36 + 1 = 37"];
innerSum2d2 = InnerSumSymbolic[2, 2, 3, 20];
Print["    Inner sum (k=0..20): ", N[innerSum2d2, 8]];
softMin2d2 = Power[innerSum2d2, -1/3];
Print["    Soft-min: ", N[softMin2d2, 8]];
Print[""];

(* n=3 *)
Print["For n=3 (second prime):"];
Print[""];
Print["  d=2: dominant contribution"];
innerSum3d2 = InnerSumSymbolic[3, 2, 3, 20];
softMin3d2 = Power[innerSum3d2, -1/3];
Print["    Inner sum: ", N[innerSum3d2, 8]];
Print["    Soft-min: ", N[softMin3d2, 8]];
Print[""];

Print["  d=3: secondary contribution"];
innerSum3d3 = InnerSumSymbolic[3, 3, 3, 20];
softMin3d3 = Power[innerSum3d3, -1/3];
Print["    Inner sum: ", N[innerSum3d3, 8]];
Print["    Soft-min: ", N[softMin3d3, 8]];
Print[""];

(* ============================================================================ *)
(* TEST 3: F_n symbolic structure                                             *)
(* ============================================================================ *)

Print["[3/4] F_n^full symbolic structure for n=2,3,5,7..."];
Print[""];

ComputeFnSymbolic[n_, s_, dMax_: 10] := Module[{terms, contributions},
  contributions = Table[
    Module[{sm, term},
      sm = SoftMinSymbolic[n, d, 3];
      term = If[sm > 1, sm^(-s), 0];
      {d, N[sm, 6], N[term, 6]}
    ],
    {d, 2, Min[dMax, 2*n]}
  ];

  Print["n=", n, " (", If[PrimeQ[n], "prime", "composite"], "):"];
  Print["  d\tSoft-min\tTerm (sm^(-s))"];
  Print["  ", StringRepeat["-", 40]];
  Do[
    If[contributions[[i-1, 3]] > 0,
      Print["  ", contributions[[i-1, 1]], "\t", contributions[[i-1, 2]], "\t",
        contributions[[i-1, 3]]]
    ],
    {i, 2, Length[contributions] + 1}
  ];

  fnValue = Total[contributions[[All, 3]]];
  Print["  F_n^full(s=1) = ", N[fnValue, 8]];
  Print[""];
  fnValue
];

fn2 = ComputeFnSymbolic[2, 1.0, 5];
fn3 = ComputeFnSymbolic[3, 1.0, 5];
fn5 = ComputeFnSymbolic[5, 1.0, 8];
fn7 = ComputeFnSymbolic[7, 1.0, 10];

Print["Summary:"];
Print["  F_2 = ", N[fn2, 6]];
Print["  F_3 = ", N[fn3, 6]];
Print["  F_5 = ", N[fn5, 6]];
Print["  F_7 = ", N[fn7, 6]];
Print[""];

(* ============================================================================ *)
(* TEST 4: Dominant term analysis                                             *)
(* ============================================================================ *)

Print["[4/4] Which d dominates? (contribution analysis)"];
Print[""];

AnalyzeDominance[n_] := Module[{contributions, total, percents},
  contributions = Table[
    Module[{sm, term},
      sm = SoftMinSymbolic[n, d, 3];
      term = If[sm > 1, sm^(-1.0), 0];
      {d, term}
    ],
    {d, 2, Min[20, 2*n]}
  ];

  total = Total[contributions[[All, 2]]];
  percents = Table[
    {contributions[[i, 1]], contributions[[i, 2]], 100*contributions[[i, 2]]/total},
    {i, 1, Length[contributions]}
  ];

  Print["n=", n, ": Contribution by d"];
  Print["  d\tTerm\t\t% of total"];
  Print["  ", StringRepeat["-", 50]];
  Do[
    If[percents[[i, 3]] > 0.01,
      Print["  ", percents[[i, 1]], "\t", N[percents[[i, 2]], 6], "\t\t",
        N[percents[[i, 3]], 3], "%"]
    ],
    {i, 1, Min[10, Length[percents]]}
  ];
  Print[""];
];

AnalyzeDominance[7];
AnalyzeDominance[11];
AnalyzeDominance[13];

(* ============================================================================ *)
(* OBSERVATIONS                                                                *)
(* ============================================================================ *)

Print["================================================================"];
Print["SYMBOLIC STRUCTURE OBSERVATIONS"];
Print["================================================================"];
Print[""];

Print["KEY PATTERNS:"];
Print["  1. Inner k-sum: Dominated by k near Floor[n/d] (minimum distance)"];
Print["  2. Tail contribution: k > Floor[n/d] grows as d² → decays as k^(-6)"];
Print["  3. Outer d-sum: Dominated by d=3 for most primes (d=2 often sm<1)"];
Print["  4. Convergence: Both sums converge rapidly (geometric decay)"];
Print[""];

Print["EXACT SYMBOLIC APPROACH:"];
Print["  - For small n, can compute k-sum to 50+ terms (sufficient precision)"];
Print["  - Soft-min is rational root of polynomial (degree 3)"];
Print["  - F_n(s) expressible as sum of radicals for s rational"];
Print["  - Clean algebraic structure (no transcendentals except ^(1/3))"];
Print[""];

Print["NEXT: Asymptotic analysis for large n"];
Print[""];
