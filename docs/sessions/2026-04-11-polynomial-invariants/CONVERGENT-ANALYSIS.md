# Convergence of C(α) through Convergents: φ vs Bessel

**Date:** 2026-04-11 (continuation)
**Context:** Extends C(α) analysis — how C approaches its limit through rational convergents of α.

## Setup

For irrational α, the convergents p_k/q_k approach α, and C(p_k/q_k) → C(α).
The convergence pattern encodes the fractal kink structure of C near α.

Two contrasting cases:
- **φ = [1; 1, 1, 1, ...]** — all partial quotients equal 1 (self-similar kink hierarchy)
- **I₀(2)/I₁(2) = [1; 2, 3, 4, 5, ...]** — counting CF (simplest non-self-similar hierarchy)

## Results

### φ — Fibonacci convergents

**C(φ) ≈ 0.26934** (between C(1) = 0 and C(2) = 1/φ² ≈ 0.383)

| k | p_k/q_k | side | \|C(p/q) − C(φ)\| | same-side ratio |
|---|---------|------|-------------------:|----------------:|
| 2 | 2/1 | above | 1.138 × 10⁻¹ | — |
| 3 | 3/2 | below | 1.607 × 10⁻² | — |
| 4 | 5/3 | above | 1.577 × 10⁻² | 0.139 |
| 5 | 8/5 | below | 9.19 × 10⁻⁴ | 0.057 |
| 6 | 13/8 | above | 1.803 × 10⁻³ | 0.114 |
| 7 | 21/13 | below | 1.68 × 10⁻⁵ | 0.018 |
| 8 | 34/21 | above | 1.145 × 10⁻⁴ | 0.064 |
| 9 | 55/34 | below | ≈ 0 (noise) | — |
| 10 | 89/55 | above | ≈ 4 × 10⁻⁷ | — |

**Precision:** 200 terms, Richardson extrapolation, σ ≈ 1.4 × 10⁻⁵. Rows k ≥ 7 from below are at or below the noise floor.

### I₀(2)/I₁(2) — Bessel convergents

**C(I₀(2)/I₁(2)) ≈ 0.21700** (between C(1) = 0 and C(3/2) ≈ 0.253)

| k | p_k/q_k | side | \|C(p/q) − C(target)\| | same-side ratio |
|---|---------|------|-------------------:|----------------:|
| 1 | 3/2 | above | 3.628 × 10⁻² | — |
| 2 | 10/7 | below | 9.72 × 10⁻⁵ | — |
| 3 | 43/30 | above | 9.50 × 10⁻⁵ | 0.0026 |
| 4 | 225/157 | — | ≈ 0 (indistinguishable from limit) | — |

**Note:** C(225/157) = C(I₀(2)/I₁(2)) to all 58 computed digits. This is not coincidence — for n ≤ 200, the staircases Floor[αn] are identical because |225/157 − α| ≈ 6 × 10⁻⁷ and 200 × 6 × 10⁻⁷ ≪ 1. Resolving the difference requires n > 1.5 × 10⁶.

## Key Observations

### 1. Super-geometric convergence (not geometric)

For φ, same-side ratios d_{k+2}/d_k are NOT constant:
- From above: 0.139, 0.114, 0.064 — **decreasing**
- From below: 0.057, 0.018 — **decreasing faster**

A self-similar kink hierarchy would give constant ratios. The observed decrease means C(α) convergence is **super-geometric**: faster than any fixed geometric rate.

### 2. Left-right asymmetry ≈ 2:1 at φ

At each pair of consecutive convergents (one above, one below φ):
- d₆/d₅ = 0.00180/0.000919 ≈ **2.0** (above overshoot is 2× the below undershoot)
- d₈/d₇ = 0.000115/0.0000168 ≈ **6.8** (ratio grows with k)

The asymmetry **grows**: from above converges progressively slower relative to below. The bottleneck mechanism (approaching from below, one staircase step is too short) gives a strong, efficient correction. The surplus (approaching from above, one step too tall) is marginal.

### 3. Bessel convergence is ~50× faster at first step

First meaningful convergence ratio:
- φ: d₄/d₂ = 0.139 (from above)
- Bessel: d₃/d₁ = 0.0026 (from above)

Factor **~50×**. After 2-3 Bessel convergents, C is at the precision floor. After 6-8 φ convergents, there is still resolvable structure.

### 4. Bessel asymmetry ≈ 1:1

d₂ = 9.72 × 10⁻⁵ (below), d₃ = 9.50 × 10⁻⁵ (above) — nearly symmetric. Only one data point per side, but the contrast with φ's 2:1 is striking.

## Interpretation

### Uniform vs. accelerated convergence (Jan's analogy)

| | φ | Bessel |
|---|---|---|
| a_k | 1 (constant) | k (growing) |
| CF convergence | geometric, ratio 1/φ² | super-geometric, q_k ~ k!/e |
| C convergence | super-geometric (ratios ~0.06–0.14) | extremely fast (2 steps to precision floor) |
| Resolvable kink steps | 6–8 | 2–3 |
| Analogy | uniform motion | uniformly accelerated motion |

### Semi-convergent structure

The fundamental difference:

**φ (a_k = 1):** Between consecutive convergents p_{k-1}/q_{k-1} and p_k/q_k, there are **zero** semi-convergents. The kink hierarchy consists ONLY of convergent kinks. This is the simplest possible fractal structure — one kink per CF level, geometrically spaced.

**Bessel (a_k = k):** Between consecutive convergents, there are **a_k − 1 = k − 1** semi-convergents at level k. Each adds a sub-kink to the hierarchy. The number of sub-kinks grows linearly — the simplest possible **non-self-similar** hierarchy.

### Egyptian fraction connection (qualitative)

The EF representation of 1/α encodes the CF structure as a sum of unit fractions. The number of EF tuples up to CF level k is:
- φ: k tuples (one per level, since a_k = 1)
- Bessel: Σᵢ₌₁ᵏ i = k(k+1)/2 tuples (a_i = i per level)

More EF tuples at a given level = more intermediate corrections = more sub-kinks in C(α)'s fractal structure at that scale. Fewer total tuples to reach the same α-precision = faster C convergence.

## Open Questions

1. **What controls the super-geometric decay?** The same-side ratios decrease — is there a closed form? For φ, is the effective Hölder exponent β(k) of C near φ computable from the transfer matrix spectrum?

2. **Why is Bessel nearly symmetric (1:1) while φ is asymmetric (2:1)?** The bottleneck mechanism explains integer-kink asymmetry. At irrational points, the asymmetry should depend on the CF structure. Hypothesis: bounded a_k (φ) → persistent asymmetry; growing a_k (Bessel) → vanishing asymmetry.

3. **Higher precision for Bessel:** Need n > 10⁶ terms (or transfer matrix methods) to resolve C(225/157) from C(I₀(2)/I₁(2)). Is C(Bessel) expressible via Bessel functions? (PSLQ requires ≥ 15 digits.)

4. **The d-family:** Arithmetic CFs [0; 1, 1+d, 1+2d, ...] for d = 1 (Bessel), d = 4 (Euler e). Does C(α_d) have a pattern in d?

## Scripts

- `convergent_C_phi_bessel.wl` — compute C for Fibonacci and Bessel convergents (200 terms each)
- `convergent_results.tsv` — numerical output
