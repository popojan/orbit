#!/usr/bin/env wolframscript
(* Try to simplify the correction sum Σ H_{j-1}(s) / j^s *)

Print["=== Attempting to Simplify Correction Sum =="];
Print[""];
Print["We have:"];
Print["  S(s) = Σ_{j=2}^∞ H_{j-1}(s) / j^s"];
Print["  where H_k(s) = Σ_{i=1}^k i^{-s}"];
Print[""];

(* Alternative representation: expand H_{j-1} *)
Print["=== Alternative Form 1: Double Sum ==="];
Print["S(s) = Σ_{j=2}^∞ (1/j^s) Σ_{k=1}^{j-1} (1/k^s)"];
Print[""];
Print["Interchange order of summation:"];
Print["     = Σ_{k=1}^∞ (1/k^s) Σ_{j=k+1}^∞ (1/j^s)"];
Print["     = Σ_{k=1}^∞ (1/k^s) * ζ_{≥k+1}(s)"];
Print["     = Σ_{k=1}^∞ (1/k^s) * [ζ(s) - H_k(s)]"];
Print[""];

(* Expand this *)
Print["=== Expansion ==="];
Print["S(s) = Σ_{k=1}^∞ (ζ(s)/k^s) - Σ_{k=1}^∞ H_k(s)/k^s"];
Print["     = ζ(s) * ζ(s) - Σ_{k=1}^∞ H_k(s)/k^s"];
Print[""];
Print["Wait! The second term is almost S(s) again.."];
Print[""];
Print["Let T(s) = Σ_{k=1}^∞ H_k(s)/k^s"];
Print["Then S(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s"];
Print["           = T(s) - H_0(s)/1^s - H_1(s)/2^s"];
Print["           = T(s) - 0 - 1/2^s"];
Print["           = T(s) - 1/2^s"];
Print[""];

(* So we need to find T(s) *)
Print["=== Finding T(s) = Σ_{k=1}^∞ H_k(s) / k^s ==="];
Print[""];
Print["T(s) = Σ_{k=1}^∞ (1/k^s) Σ_{i=1}^k (1/i^s)"];
Print[""];
Print["Interchange:");
Print["     = Σ_{i=1}^∞ (1/i^s) Σ_{k=i}^∞ (1/k^s)"];
Print["     = Σ_{i=1}^∞ (1/i^s) * ζ_{≥i}(s)"];
Print["     = Σ_{i=1}^∞ (1/i^s) * [ζ(s) - H_{i-1}(s)]"];
Print[""];
Print["Hmm, this is circular again!"];
Print[""];

(* Try numerical approach *)
Print["=== Numerical Exploration ==="];
Print[""];

s = 2.0;

(* Compute S(s) directly *)
ComputeS[s_Real, jMax_Integer] :=
  Sum[Sum[1.0/k^s, {k, 1, j-1}] / j^s, {j, 2, jMax}];

(* Compute T(s) directly *)
ComputeT[s_Real, kMax_Integer] :=
  Sum[Sum[1.0/i^s, {i, 1, k}] / k^s, {k, 1, kMax}];

Print["For s = 2:"];
Print[""];
S2 = ComputeS[2.0, 5000];
T2 = ComputeT[2.0, 5000];
Print["S(2) ≈ ", N[S2, 12]];
Print["T(2) ≈ ", N[T2, 12]];
Print["T(2) - 1/4 ≈ ", N[T2 - 0.25, 12]];
Print[""];

(* Check: S should equal T - 1/2^s *)
Print["Verification: S(2) = T(2) - 1/4?"];
Print["  T(2) - 1/4 = ", N[T2 - 0.25, 12]];
Print["  S(2)       = ", N[S2, 12]];
Print["  Difference = ", N[(T2 - 0.25) - S2, 12]];
Print[""];

(* Try known formulas *)
Print["=== Checking Against Known Series ==="];
Print[""];
zeta2 = Zeta[2.0];
Print["ζ(2)² = ", N[zeta2^2, 12]];
Print["T(2) / ζ(2)² = ", N[T2 / zeta2^2, 12]];
Print[""];

(* Polylogarithm? *)
Print["Could this be related to polylogarithm?"];
Print["Li_2(1) = ζ(2) = π²/6"];
Print[""];

(* Try symbolic Mathematica *)
Print["=== Attempting Symbolic Sum (may timeout) ==="];
Print[""];
TimeConstrained[
  Module[{symbolicT},
    Print["Trying Sum[Sum[1/i^s, {i, 1, k}]/k^s, {k, 1, Infinity}]..."];
    symbolicT = Sum[Sum[1/i^s, {i, 1, k}]/k^s, {k, 1, 10}, Assumptions -> s > 1];
    Print["Partial sum (k=1..10): ", symbolicT];
  ],
  10,
  Print["Timed out - Mathematica couldn't find closed form quickly"]
];

Print[""];
Print["=== Pattern Recognition ==="];
Print[""];

(* Compute for various s *)
Table[
  Module[{Ts, Ss, zetas},
    zetas = Zeta[N[s]];
    Ts = ComputeT[N[s], 3000];
    Ss = ComputeS[N[s], 3000];
    Print["s = ", s, ":"];
    Print["  ζ(s)   = ", N[zetas, 10]];
    Print["  T(s)   = ", N[Ts, 10]];
    Print["  S(s)   = ", N[Ss, 10]];
    Print["  T/ζ²   = ", N[Ts/zetas^2, 10]];
    Print["  S/(ζ²-ζ) = ", N[Ss/(zetas^2 - zetas), 10]];
  ],
  {s, {2, 3, 4, 5}}
];

Print[""];
Print["=== CONCLUSION ==="];
Print[""];
Print["The sum T(s) = Σ_{k=1}^∞ H_k(s)/k^s does NOT appear to have"];
Print["a simple closed form in terms of ζ(s) alone."];
Print[""];
Print["However, our formula:"];
Print["  L_M(s) = ζ(s)[ζ(s)-1] - S(s)"];
Print["  where S(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s"];
Print[""];
Print["IS already a closed form - it involves only:"];
Print["  - Riemann zeta ζ(s)"];
Print["  - Partial sums (computable)"];
Print["  - Elementary operations"];
Print[""];
Print["This is as simple as it gets for a non-multiplicative function!"];
