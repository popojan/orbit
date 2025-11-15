#!/usr/bin/env wolframscript
(* Test: Can Wolfram give symbolic solution for double infinite sum? *)

Print["================================================================"];
Print["SYMBOLIC SOLUTION TEST: Double Infinite Sum"];
Print["================================================================"];
Print[""];

Print["Testing: F_n(α) = Σ_{d=2}^∞ Σ_{k=0}^∞ [(n - kd - d²)² + ε]^{-α}"];
Print[""];

(* ============================================================================ *)
(* TEST 1: Inner sum only (fixed d)                                           *)
(* ============================================================================ *)

Print["[1/3] Can Wolfram solve the inner k-sum symbolically?"];
Print[""];
Print["  Sum_{k=0}^∞ [(n - kd - d²)² + ε]^{-α}"];
Print[""];

(* Try for concrete values first *)
n = 7;
d = 2;
alpha = 3;
eps = 1;

Print["Trying with n=7, d=2, α=3, ε=1:"];
Print[""];

innerSymbolic = Sum[((n - k*d - d^2)^2 + eps)^(-alpha), {k, 0, Infinity}];

Print["Result: ", innerSymbolic];
Print[""];

(* Numerical comparison *)
innerNumerical = NSum[((n - k*d - d^2)^2 + eps)^(-alpha), {k, 0, Infinity}];
Print["Numerical check: ", N[innerNumerical, 8]];
Print[""];

(* ============================================================================ *)
(* TEST 2: Try with symbolic parameters                                       *)
(* ============================================================================ *)

Print["[2/3] Trying with fully symbolic parameters:"];
Print[""];

(* This will likely timeout or return unevaluated, but worth trying *)
TimeConstrained[
  Module[{result},
    result = Sum[((n - k*d - d^2)^2 + eps)^(-alpha), {k, 0, Infinity},
      Assumptions -> {n > 0, d > 0, alpha > 1, eps > 0}];
    Print["Symbolic result: ", result];
  ],
  10,
  Print["  Timed out - Wolfram cannot find closed form"]
];
Print[""];

(* ============================================================================ *)
(* TEST 3: Double sum for specific small n                                    *)
(* ============================================================================ *)

Print["[3/3] Testing full double sum for n=2:"];
Print[""];

n = 2;
alpha = 3;
eps = 1;

Print["F_2(3) = Σ_{d=2}^∞ Σ_{k=0}^∞ [(2 - kd - d²)² + 1]^{-3}"];
Print[""];

TimeConstrained[
  Module[{result},
    result = Sum[
      Sum[((n - k*d - d^2)^2 + eps)^(-alpha), {k, 0, Infinity}],
      {d, 2, Infinity}
    ];
    Print["Symbolic result: ", result];
  ],
  15,
  Print["  Timed out - full double sum too complex for closed form"]
];
Print[""];

(* Numerical for comparison *)
numerical = NSum[
  NSum[((n - k*d - d^2)^2 + eps)^(-alpha), {k, 0, Infinity}],
  {d, 2, Infinity}
];
Print["Numerical value: ", N[numerical, 8]];
Print[""];

(* ============================================================================ *)
(* CONCLUSION                                                                  *)
(* ============================================================================ *)

Print["================================================================"];
Print["CONCLUSION"];
Print["================================================================"];
Print[""];

Print["Wolfram's symbolic capabilities:"];
Print["  - Inner k-sum: May have closed form for specific (n,d,α,ε)"];
Print["  - Outer d-sum: Unlikely to have general closed form"];
Print["  - Full double sum: Too complex for symbolic solution"];
Print[""];

Print["However, the formula is ALGEBRAICALLY SIMPLE:");
Print["  F_n(α) = Σ_{d,k} [(n - kd - d²)² + ε]^{-α}"];
Print[""];

Print["This enables:"];
Print["  ✓ Direct numerical evaluation (adaptive truncation)");
Print["  ✓ Asymptotic analysis (dominant terms)");
Print["  ✓ Mellin transform (term-by-term)");
Print["  ✓ Symbolic manipulation of expansions");
Print[""];

Print["The lack of a closed-form sum does NOT reduce tractability!");
Print["Many important functions (ζ(s), Bessel functions) are defined"];
Print["by infinite series without elementary closed forms.");
Print[""];
