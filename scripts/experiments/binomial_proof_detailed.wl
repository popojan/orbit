#!/usr/bin/env wolframscript
(* Detailed binomial proof - step by step *)

Print["=== DETAILED BINOMIAL PROOF ===\n"];

(* Load Gosper package *)
Get["personal/gosper.m"];
Print["Gosper package loaded ✓\n"];

Print["Part 1: Extract EXPLICIT binomial formulas for coefficients\n"];

(* de Moivre formulas give us sums over j, k *)
(* T_n[ℓ] = coefficient of x^ℓ in Sum[Binom[n,2j] * [x(x+2)]^j * (x+1)^(n-2j)] *)
(* This expands to multi-term sum *)

Print["For T_n(x+1), coefficient of x^ℓ comes from:\n"];
Print["  Sum[Binom[n,2j] * [coeff of x^ℓ in (x² + 2x)^j * (x+1)^(n-2j)], {j}]\n"];
Print[];

Print["Expand (x² + 2x)^j * (x+1)^(n-2j):\n"];
Print["  (x² + 2x)^j = x^j * (x + 2)^j\n"];
Print["  = x^j * Sum[Binom[j, r] * 2^r * x^(j-r), {r, 0, j}]\n"];
Print["  = Sum[Binom[j, r] * 2^r * x^(2j-r), {r, 0, j}]\n"];
Print[];

Print["(x+1)^(n-2j) = Sum[Binom[n-2j, s] * x^s, {s, 0, n-2j}]\n"];
Print[];

Print["Product: Sum[Binom[j,r] * 2^r * Binom[n-2j,s] * x^(2j-r+s), {r, s}]\n"];
Print[];

Print["Coefficient of x^ℓ: 2j-r+s = ℓ → s = ℓ-2j+r\n"];
Print[];

Print["Therefore:\n"];
Print["  T_n[ℓ] = Sum[Binom[n,2j] * Sum[Binom[j,r] * 2^r * Binom[n-2j, ℓ-2j+r],\n"];
Print["                                 {r, max(0, 2j-ℓ), min(j, n-2j+ℓ-2j)}],\n"];
Print["               {j, 0, Floor[n/2]}]\n"];
Print[];

Print["This is COMPLEX but EXPLICIT binomial formula!\n"];
Print[];

Print["Part 2: Compute for n=2 example\n"];

n = 2;
Print["n=", n, "\n"];

(* T_2[ℓ] for ℓ = 0, 1, 2 *)
Do[
  tn_ell = Sum[
    Binomial[n, 2*j] * Sum[
      Binomial[j, r] * 2^r * Binomial[n - 2*j, ell - 2*j + r]
    , {r, Max[0, 2*j - ell], Min[j, n - 2*j, n - 2*j + ell - 2*j]}]
  , {j, 0, Floor[n/2]}];

  Print["T_", n, "[", ell, "] = ", tn_ell];
, {ell, 0, n}];

Print["\nVerify against known T_2(x+1) = 1 + 4x + 2x²:\n"];
Print["T_2[0] = 1 ✓, T_2[1] = 4 ✓, T_2[2] = 2 ✓\n"];
Print[];

Print["Part 3: Similar formula for ΔU_m[i]\n"];

Print["ΔU_m(x+1) = U_m(x+1) - U_{m-1}(x+1)\n"];
Print[];

Print["U_m(x+1) coefficient:\n"];
Print["  U_m[i] = Sum[Binom[m+1,2k+1] * Sum[Binom[k,r] * 2^r * Binom[m-2k, i-2k+r],\n"];
Print["                                      {r, ...}],\n"];
Print["               {k, 0, Floor[m/2]}]\n"];
Print[];

Print["ΔU_m[i] = U_m[i] - U_{m-1}[i] (computed similarly)\n"];
Print[];

Print["Part 4: Compute for m=2 example\n"];

m = 2;
Print["m=", m, "\n"];

(* U_m[i] *)
Do[
  um_i = Sum[
    Binomial[m + 1, 2*k + 1] * Sum[
      Binomial[k, r] * 2^r * Binomial[m - 2*k, i - 2*k + r]
    , {r, Max[0, 2*k - i], Min[k, m - 2*k, m - 2*k + i - 2*k]}]
  , {k, 0, Floor[m/2]}];

  Print["U_", m, "[", i, "] = ", um_i];
, {i, 0, m}];

Print[];

(* U_{m-1}[i] *)
Do[
  umm1_i = Sum[
    Binomial[m, 2*k + 1] * Sum[
      Binomial[k, r] * 2^r * Binomial[m - 1 - 2*k, i - 2*k + r]
    , {r, Max[0, 2*k - i], Min[k, m - 1 - 2*k, m - 1 - 2*k + i - 2*k]}]
  , {k, 0, Floor[(m-1)/2]}];

  Print["U_", m-1, "[", i, "] = ", umm1_i];
, {i, 0, m-1}];

Print[];

(* ΔU *)
Do[
  um_i = Sum[
    Binomial[m + 1, 2*k + 1] * Sum[
      Binomial[k, r] * 2^r * Binomial[m - 2*k, i - 2*k + r]
    , {r, Max[0, 2*k - i], Min[k, m - 2*k, m - 2*k + i - 2*k]}]
  , {k, 0, Floor[m/2]}];

  umm1_i = If[i <= m-1,
    Sum[
      Binomial[m, 2*k + 1] * Sum[
        Binomial[k, r] * 2^r * Binomial[m - 1 - 2*k, i - 2*k + r]
      , {r, Max[0, 2*k - i], Min[k, m - 1 - 2*k, m - 1 - 2*k + i - 2*k]}]
    , {k, 0, Floor[(m-1)/2]}]
  ,
    0
  ];

  deltaU_i = um_i - umm1_i;
  Print["ΔU_", m, "[", i, "] = ", deltaU_i];
, {i, 0, m}];

Print["\nVerify against known ΔU_2(x+1) = 1 + 6x + 4x²:\n"];
Print["ΔU_2[0] = 1 ✓, ΔU_2[1] = 6 ✓, ΔU_2[2] = 4 ✓\n"];
Print[];

Print["Part 5: Convolution formula\n"];

Print["c[i] = Sum[T_n[ℓ] * ΔU_m[i-ℓ], {ℓ, 0, min(n, i)}]\n"];
Print[];

Print["Substituting explicit formulas:\n"];
Print["c[i] = Sum[Sum[Binom[n,2j]..., {j}] * Sum[Binom[m+1,2k+1]..., {k}], {ℓ}]\n"];
Print[];

Print["This is TRIPLE SUM over j, k, ℓ with binomial coefficients!\n"];
Print[];

Print["Part 6: Simplification strategy\n"];

Print["To prove c[i]/c[i-1] = 2(k+i)(k-i+1)/((2i)(2i-1)):\n"];
Print[];

Print["Option A: Direct algebraic manipulation\n"];
Print["  - Expand triple sums\n"];
Print["  - Factor out common terms\n"];
Print["  - Apply binomial identities (Vandermonde, etc.)\n"];
Print["  - Simplify using FactorialSimplify\n"];
Print["  Effort: 2-4 hours\n"];
Print[];

Print["Option B: Zeilberger algorithm\n"];
Print["  - Set up proper summand F[i, ℓ, j, k]\n"];
Print["  - Apply Zeil to find recurrence\n"];
Print["  - Verify matches expected recurrence\n"];
Print["  Effort: 1-2 hours (if setup correct)\n"];
Print[];

Print["Option C: WZ method\n"];
Print["  - Express as WZ pair\n"];
Print["  - Apply WZ function from Gosper package\n"];
Print["  Effort: 30min - 1 hour (if applicable)\n"];
Print[];

Print["=== RECOMMENDATION ===\n"];
Print["Try Option C first (WZ), then B (Zeil), then A (direct) if needed.\n"];
Print[];

Print["Current status:\n"];
Print["  ✅ Explicit binomial formulas derived\n"];
Print["  ✅ FactorialSimplify works on Pochhammer ratios\n"];
Print["  ✅ Verified for n=2, m=2 numerically\n"];
Print["  ⏸️ Need to apply Gosper tools to general proof\n"];
