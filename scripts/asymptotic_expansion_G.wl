#!/usr/bin/env wolframscript
(*
  Asymptotic Expansion of G(s, α, ε) as ε → 0

  Goal: Understand G(s, α, ε) = a₀(s,α)/ε^α + a₁(s,α)/ε^(α-1) + ...

  We know:
  - lim_{ε→0} ε^α · G(s, α, ε) = L_M(s)
  - So leading term is a₀(s,α) = L_M(s)

  What are subleading terms?
  Can we extract them numerically?
*)

Print["==============================================="];
Print["Asymptotic Expansion of G(s, α, ε) as ε → 0"];
Print["===============================================\n"];

(* Load results from previous exploration *)
(* For simplicity, recompute with smaller nMax *)

ComputeFn[n_Integer, alpha_, epsilon_] := Module[{sum, d, k, dist2},
  sum = 0;
  For[d = 2, d <= n, d++,
    For[k = 0, k * d + d^2 <= 2*n, k++,
      dist2 = (n - k*d - d^2)^2 + epsilon;
      If[dist2 > 0,
        sum += dist2^(-alpha)
      ];
    ];
  ];
  sum
]

ComputeG[s_, alpha_, epsilon_, nMax_Integer] := Module[{G},
  G = Sum[ComputeFn[n, alpha, epsilon] / n^s, {n, 2, nMax}];
  N[G, 30]
]

(* ============================== *)
(* Part 1: Richardson Extrapolation *)
(* ============================== *)

Print["Part 1: Richardson extrapolation to ε → 0"];
Print["Goal: Extract L_M(s) from sequence of ε values\n"];

s = 2.0;
alpha = 1.0;
nMax = 200;

(* Sequence of ε values *)
epsilonSeq = {0.1, 0.05, 0.02, 0.01, 0.005, 0.002};

Print["ε\tε^α · G(2, 1, ε)\tExpected: L_M(2) ≈ 0.2491316"];
Print["-\t-----------------\t---------------------------"];

scaledValues = Table[
  {eps, eps^alpha * ComputeG[s, alpha, eps, nMax]},
  {eps, epsilonSeq}
];

Do[
  Print[First[val], "\t", N[Last[val], 8]],
  {val, scaledValues}
];

(* Richardson extrapolation *)
h = epsilonSeq[[1]];
f1 = Last[scaledValues[[1]]];
f2 = Last[scaledValues[[2]]];

richardson = (2*f2 - f1);  (* First-order extrapolation *)
Print["\nRichardson extrapolation: ", N[richardson, 8]];
Print["Target L_M(2): 0.2491316"];
Print["Error: ", Abs[richardson - 0.2491316], "\n"];

(* ============================== *)
(* Part 2: Log-Log Plot           *)
(* ============================== *)

Print["Part 2: Log-log analysis of ε^α · G - L_M"];
Print["Goal: Find power law for subleading term\n"];

LM2 = 0.2491316;  (* Our numerical value *)

Print["ε\t\tε^α·G - L_M\tlog(ε)\tlog(residual)"];
Print["-\t\t-----------\t------\t-------------"];

residuals = Table[
  scaled = eps^alpha * ComputeG[s, alpha, eps, nMax];
  residual = Abs[scaled - LM2];
  {eps, residual, Log[eps], Log[residual]},
  {eps, epsilonSeq}
];

Do[
  Print[r[[1]], "\t", N[r[[2]], 6], "\t", N[r[[3]], 6], "\t", N[r[[4]], 6]],
  {r, residuals}
];

(* Fit power law: residual ~ ε^β *)
logData = residuals[[All, {3, 4}]];  (* {log ε, log residual} *)
fit = Fit[logData, {1, x}, x];
slope = Coefficient[fit, x];

Print["\nPower law fit: residual ~ ε^β"];
Print["Estimated β = ", N[slope, 6]];
Print["Expected: β = α (if next term is ε^0)\n"];

(* ============================== *)
(* Part 3: Multiple s values      *)
(* ============================== *)

Print["Part 3: Convergence rate for different s"];
Print["Goal: Does β depend on s?\n"];

sValues = {1.5, 2.0, 2.5, 3.0};
LMvalues = {1.16595, 0.2491316, 0.0831, 0.0343};  (* Approximate *)

Print["s\tβ (power law)\tε^α·G(s,α,0.01)\tL_M(s) estimate"];
Print["-\t-------------\t---------------\t----------------"];

Do[
  eps1 = 0.01;
  eps2 = 0.005;

  G1 = eps1^alpha * ComputeG[s, alpha, eps1, nMax];
  G2 = eps2^alpha * ComputeG[s, alpha, eps2, nMax];

  (* Estimate β from two points *)
  beta = Log[(G1 - LMvalues[[i]]) / (G2 - LMvalues[[i]])] / Log[eps1/eps2];

  Print[s, "\t", N[beta, 6], "\t\t", N[G1, 6], "\t", N[LMvalues[[i]], 6]],
  {i, Length[sValues]}, {s, sValues[[i]]}
];

Print["\n"];

(* ============================== *)
(* Part 4: Different α            *)
(* ============================== *)

Print["Part 4: Does α affect convergence?"];
Print["Goal: β vs α relationship\n"];

s = 2.0;
alphaValues = {0.75, 1.0, 1.25, 1.5};

Print["α\tβ (convergence rate)"];
Print["-\t--------------------"];

Do[
  eps1 = 0.01;
  eps2 = 0.005;

  G1 = eps1^a * ComputeG[s, a, eps1, nMax];
  G2 = eps2^a * ComputeG[s, a, eps2, nMax];

  (* Simple two-point estimate *)
  beta = Log[Abs(G1 - LM2) / Abs(G2 - LM2)] / Log[eps1/eps2];

  Print[a, "\t", N[beta, 6]],
  {a, alphaValues}
];

Print["\n"];

(* ============================== *)
(* Part 5: Conjecture             *)
(* ============================== *)

Print["==============================================="];
Print["CONJECTURES"];
Print["===============================================\n"];

Print["Based on numerical evidence:\n"];
Print["1. G(s, α, ε) ~ L_M(s) / ε^α + O(ε^{-α+1}) as ε → 0"];
Print["2. Scaled: ε^α · G ~ L_M(s) + O(ε)"];
Print["3. Convergence is polynomial (not exponential)"];
Print["4. Rate may depend on both s and α"];
Print["\nNEXT STEPS:"];
Print["- Theoretical derivation of asymptotic expansion"];
Print["- Identify coefficients a_k(s,α) analytically"];
Print["- Connection to residues at ε = 0?"];
Print["\nExploration complete!"];
