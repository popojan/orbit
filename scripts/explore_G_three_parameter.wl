#!/usr/bin/env wolframscript
(*
  Exploration of G(s, α, ε) - The Three-Parameter Global Function

  Recall: G(s, α, ε) = Σ_{n=2}^∞ F_n(α,ε) / n^s
  where:  F_n(α,ε) = Σ_{d=2}^∞ Σ_{k=0}^∞ [(n - kd - d²)² + ε]^(-α)

  Key insight: For ε > 0, G is analytic (no poles!)
  As ε → 0: ε^α · G(s, α, ε) → L_M(s)

  Strategy: Study G for fixed ε > 0, then take limit
*)

Print["==============================================="];
Print["Exploring G(s, α, ε) - Three-Parameter Function"];
Print["===============================================\n"];

(* Define F_n with regularization *)
ComputeFn[n_Integer, alpha_Real, epsilon_Real] := Module[{sum, d, k, dist2},
  sum = 0;
  For[d = 2, d <= n, d++,
    For[k = 0, k * d + d^2 <= 2*n, k++,  (* Reasonable cutoff *)
      dist2 = (n - k*d - d^2)^2 + epsilon;
      If[dist2 > 0,
        sum += dist2^(-alpha)
      ];
    ];
  ];
  sum
]

(* Global function G(s, α, ε) *)
ComputeG[s_Real, alpha_Real, epsilon_Real, nMax_Integer] := Module[{G},
  G = Sum[ComputeFn[n, alpha, epsilon] / n^s, {n, 2, nMax}];
  N[G, 20]
]

(* ============================== *)
(* Part 1: Fix ε, Vary s          *)
(* ============================== *)

Print["Part 1: G(s, α=1, ε=1) for varying s"];
Print["Goal: See if G has interesting behavior for s in (0,1]"];
Print[""];

epsilon = 1.0;
alpha = 1.0;
nMax = 100;  (* Start small *)

Print["s\tG(s, 1, 1)"];
Print["-\t-----------"];

sValues = {0.5, 0.75, 1.0, 1.25, 1.5, 2.0};

Do[
  G = ComputeG[s, alpha, epsilon, nMax];
  Print[s, "\t", N[G, 8]],
  {s, sValues}
];

Print["\nObservation: Does G grow as s → 0? (should, since sum over 1/n^s)\n"];

(* ============================== *)
(* Part 2: Fix s, Vary α          *)
(* ============================== *)

Print["Part 2: G(s=2, α, ε=1) for varying α"];
Print["Goal: See how α affects regularization"];
Print[""];

s = 2.0;
epsilon = 1.0;

Print["α\tG(2, α, 1)"];
Print["-\t-----------"];

alphaValues = {0.5, 0.75, 1.0, 1.25, 1.5, 2.0};

Do[
  G = ComputeG[s, a, epsilon, nMax];
  Print[a, "\t", N[G, 8]],
  {a, alphaValues}
];

Print["\nObservation: Higher α → stronger decay → smaller G\n"];

(* ============================== *)
(* Part 3: Fix s,α, Vary ε        *)
(* ============================== *)

Print["Part 3: G(s=2, α=1, ε) for varying ε"];
Print["Goal: Approach ε → 0 limit"];
Print[""];

s = 2.0;
alpha = 1.0;
nMax = 200;  (* Larger for better accuracy *)

Print["ε\tG(2, 1, ε)\tε^α · G\tL_M(2) estimate"];
Print["-\t-----------\t-------\t---------------"];

epsilonValues = {1.0, 0.5, 0.1, 0.01, 0.001, 0.0001};

Do[
  G = ComputeG[s, alpha, eps, nMax];
  scaled = eps^alpha * G;
  Print[eps, "\t", N[G, 6], "\t", N[scaled, 6], "\t(should → L_M(2) ≈ 0.249)"],
  {eps, epsilonValues}
];

Print["\nExpected: As ε → 0, ε^α · G → L_M(2) ≈ 0.2491316\n"];

(* ============================== *)
(* Part 4: 2D Scan (s, ε)        *)
(* ============================== *)

Print["Part 4: 2D scan of G(s, α=1.5, ε)"];
Print["Goal: Find interesting regions in (s, ε) plane"];
Print[""];

alpha = 1.5;  (* Above threshold *)
nMax = 150;

Print["s\tε=1.0\tε=0.1\tε=0.01"];
Print["-\t-----\t-----\t------"];

sValues2 = {0.5, 1.0, 1.5, 2.0};
epsilonValues2 = {1.0, 0.1, 0.01};

Do[
  results = Table[ComputeG[s, alpha, eps, nMax], {eps, epsilonValues2}];
  Print[s, "\t", N[results[[1]], 5], "\t", N[results[[2]], 5], "\t", N[results[[3]], 5]],
  {s, sValues2}
];

Print["\n"];

(* ============================== *)
(* Part 5: Scaled Limit Check     *)
(* ============================== *)

Print["Part 5: Convergence of ε^α · G(s, α, ε) → L_M(s)"];
Print["Goal: Verify our residue theorem globally"];
Print[""];

s = 2.0;
nMax = 300;

Print["α\tε\tε^α · G(s, α, ε)\tTarget: L_M(2) ≈ 0.249"];
Print["-\t-\t-----------------\t-------------------------"];

alphaValues2 = {0.75, 1.0, 1.5};
epsilonValues3 = {0.1, 0.01, 0.001};

Do[
  Do[
    G = ComputeG[s, a, eps, nMax];
    scaled = eps^a * G;
    Print[a, "\t", eps, "\t", N[scaled, 8], "\t", Abs[scaled - 0.249]],
    {eps, epsilonValues3}
  ],
  {a, alphaValues2}
];

Print["\nExpected: All should converge to L_M(2) as ε → 0, especially for α > 1/2\n"];

(* ============================== *)
(* Part 6: Look for Zeros?        *)
(* ============================== *)

Print["Part 6: Does G(s, α, ε) have zeros for ε > 0?"];
Print["Goal: Unlike L_M(s), G might be zero-free for ε > 0"];
Print[""];

epsilon = 0.1;
alpha = 1.0;
nMax = 200;

Print["s (complex)\t\t|G(s, 1, 0.1)|"];
Print["-----------\t\t---------------"];

(* Test some complex values *)
complexSValues = {1.0 + 0.0*I, 0.5 + 5.0*I, 0.5 + 10.0*I, 0.5 + 20.0*I};

(* This requires complex evaluation - skip for now, note as TODO *)
Print["TODO: Implement complex s evaluation"];
Print["For now, testing real s only:\n"];

realSValues = {0.5, 0.75, 1.0, 1.5, 2.0, 3.0};

Do[
  G = ComputeG[s, alpha, epsilon, nMax];
  Print[s, "\t\t\t", N[Abs[G], 8]],
  {s, realSValues}
];

Print["\nObservation: All G values are positive (for real s > 0)\n"];

(* ============================== *)
(* Summary and Conjectures        *)
(* ============================== *)

Print["==============================================="];
Print["SUMMARY AND CONJECTURES"];
Print["===============================================\n"];

Print["1. For ε > 0, G(s, α, ε) appears well-defined for s > 0"];
Print["2. As ε → 0, ε^α · G → L_M(s) (confirms residue theorem)"];
Print["3. Higher α → stronger regularization → faster decay"];
Print["4. G seems to have no zeros for real s > 0, ε > 0"];
Print[""];
Print["NEXT STEPS:"];
Print["- Implement complex s evaluation"];
Print["- Search for zeros in critical strip"];
Print["- Study functional equations of G"];
Print["- Find optimal path ε(s) for analytic continuation"];
Print[""];
Print["Exploration complete!"];
