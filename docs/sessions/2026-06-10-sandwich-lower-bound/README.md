# Sandwich Bounds for C(α) — Lundberg Route (P2)

**Date:** 2026-06-10
**Goal:** Close the lower-bound gap α ∈ (1, 3/2) of
`ruin-multinacci-bridge.tex` (Prop 6.2 + "conjectured extension" Remark),
and attack the upper-bound conjecture.

## Key idea (derived before verification)

Work directly with the ruin walk that *defines* C(p/q): fair coin; a
right-step adds the Sturmian rise (phase advances), an up-step adds −1;
start s₀ = ⌊α⌋, phase j₀ = 1; C = (1 − ρ)/2. The gap after τ right-steps
and u up-steps is **exactly**

```
s_t = ⌊α(τ_t + 1)⌋ − u_t          (α = p/q)
```

(prefix sums of the rise sequence from phase 1 telescope to a single floor).
Two elementary bounds on the floor give everything:

### Lemma L (Lundberg lower bound) — 🤔 HYPOTHESIS → derivation below

Using ⌊x⌋ ≥ x − 1 and X_t = τ_t − u_t (simple ±1 walk), ruin (s ≤ −1)
forces Y_t := X_t + εt ≤ −a with

```
ε = (α−1)/(α+1),    a = 2α/(α+1).
```

M_t = exp(−θY_t) is a supermartingale whenever ln cosh θ ≤ θε; since
ln cosh θ ≤ θ²/2, θ = 2ε is admissible. Optional stopping ⟹

```
ρ(α) ≤ exp(−2εa) = exp(−4α(α−1)/(α+1)²)        for ALL real α > 1
⟹  C(α) ≥ L(α) := (1 − exp(−4α(α−1)/(α+1)²))/2.
```

### Closing the gap (1, 3/2)

L(α) ≥ g(α) := 1/2 − 2^{−α}  ⟺  4α(α−1)/(α+1)² ≥ (α−1)ln2
⟺  h(α) := 4α − ln2·(α+1)² ≥ 0.
h is concave; h(1) = 4 − 4ln2 > 0, h(3/2) = 6 − 6.25·ln2 > 0
⟹ h > 0 on [1, 3/2] (in fact up to α ≈ 3.48).
**No partition, no anchors, no monotonicity, no DFT limit needed.**
Combined with the existing proof for α ≥ 3/2, the paper's
"conjectured extension to all α > 1" becomes a proposition.

### Lemma U (coupling upper bound) — 🤔 HYPOTHESIS → derivation below

Let σ_t := α(τ_t+1) − u_t (smooth gap). Then s_t ≤ σ_t pointwise
(⌊x⌋ ≤ x), so {σ hits ≤ −1} ⊆ {s hits ≤ −1} and ρ(α) ≥ ψ(α) :=
P(σ ever ≤ −1). The function ρ₀^{σ_t} is an **exact martingale** for the
smooth walk (ρ₀^α + ρ₀^{−1} = 2 ⟺ ρ₀^{α+1} = 2ρ₀ − 1), and at ruin
σ_T ∈ (−2, −1], so optional stopping gives ψ(α) ≥ ρ₀^{α+2}. Hence

```
C(α) ≤ U(α) := (1 − ρ₀(α)^{α+2})/2        unconditionally.
```

This is weaker than the conjectured C_smooth = 1 − ρ₀ (the overshoot
slack ρ₀ in the exponent is the price), but it is *proven* — the
sandwich becomes unconditional:  L(α) ≤ C(α) ≤ U(α).

Note: the *same* coupling in the other direction (σ < s + 1) shows
ρ ≤ P(σ ever < 0) — the naive route to the C_smooth upper bound fails
exactly because of overshoot; consistent with the conjecture being
genuinely open. The gap U − C_smooth = (overshoot factor) is real.

### Byproduct: monotonicity lemma

s_t(α) = ⌊α(τ_t+1)⌋ − u_t is pointwise nondecreasing in α under the
coin-flip coupling ⟹ ρ nonincreasing, C nondecreasing in α (on
rationals, where C is defined via the walk). This retroactively makes
the monotonicity steps in the existing Prop 6.2 (Cases 1–2) rigorous.

## What would confirm / falsify (before running)

- **Confirm:** numerically, L(α) ≤ C_exact(p/q) ≤ U(α) for all tested
  rationals (any violation of L ≤ C falsifies Lemma L's derivation;
  C ≤ U falsifies Lemma U); L(α) ≥ g(α) on (1, 3/2]; exact-C
  implementation reproduces the paper's table (3/2 → 0.251848…,
  5/3 → 0.284123…, 4/3 → 0.190859…).
- **Falsify:** any rational slope with C_exact < L or C_exact > U.

## ✅ CONFIRMED (scripts/sandwich_verification.wl)

- Exact-C implementation reproduces paper table 6/6 (C(3/2), C(5/2),
  C(5/3), C(7/3), C(4/3), C(7/4)) and C(k) = 1 − 1/τ_k for k = 2..5.
- Sandwich sweep: 66 coprime slopes (q ≤ 8, 1 < p/q ≤ 4),
  **0 violations**; min slack C − L = 0.031, U − C = 0.009.
- h(1) = 4 − 4ln2 > 0, h(3/2) = 6 − (25/4)ln2 > 0, h concave ⟹
  L ≥ g on (1, 3/2]; h-roots at 0.287 and **3.4837** (so the Lundberg
  bound alone actually covers (1, 3.48], comfortably overlapping the
  existing α ≥ 3/2 proof).
- Snapshot confirms U is strictly between C and 1/2 and weaker than
  C_smooth, as predicted by the overshoot analysis:
  U = (1 − ρ₀^{α+2})/2 vs C_smooth = (1 − ρ₀^{α+1})/2 — exactly one
  factor ρ₀ apart. Closing that factor IS the upper-bound conjecture.

## Outcome

1. **Lower bound C(α) ≥ 1/2 − 2^{−α} proven for ALL α > 1** —
   the paper's "Conjectured extension" Remark upgrades to part of the
   Proposition. The planned DFT/Vandermonde rigor program
   (memory: lower-bound proof strategy) is BYPASSED — no partition,
   no anchors, no q·C → 1 limit needed.
2. **New unconditional upper bound** C(α) ≤ U(α) = (1 − ρ₀^{α+2})/2.
   The sandwich is now a theorem; the smooth bound C_smooth remains
   conjectural as the tight version (overshoot factor ρ₀).
3. **Monotonicity lemma** (coupling): retroactively makes the
   monotonicity steps in the existing Prop 6.2 rigorous.
4. Paper errata: §5.1–5.2 had transposed-staircase confusion
   (S(x) = ⌊qx/p⌋ stated, but r_j formula/values/examples all use
   ⌊px/q⌋); fixed minimally, and the telescoped gap identity
   s = ⌊α(τ+1)⌋ − u added as the basis of all bounds.

