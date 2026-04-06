# Do Zeta Zeros "Know" About π?

**Date:** 2026-04-06
**Status:** ❌ FALSIFIED — {γ_n/π} is equidistributed, no special structure

## The Question

Several γ_n/π values lie close to integers:
- γ₃₇/π ≈ 37.00 (dist 0.004)
- γ₇₀/π ≈ 58.00 (dist 0.002)
- γ₉₆/π ≈ 73.00 (dist 0.0004)

Since the functional equation of ζ involves π explicitly (through
Γ(s/2) and π^{-s/2}), and the winding matrix divides by 2π, the
question arises: do the zeros have a special arithmetic relationship
with π, beyond what random real numbers would show?

## Hypothesis

**H₀ (null):** {γ_n/π} mod 1 is equidistributed on [0,1).
Near-integer values occur at the rate expected for uniform random values.

**H₁ (alternative):** {γ_n/π} clusters near 0 and 1 (i.e., γ_n/π
is closer to integers than random), indicating a structural
π-awareness in the zeros.

## Tests (N = 1000 zeros)

### Kolmogorov-Smirnov vs Uniform

| Statistic | Value | Critical (5%) | Result |
|-----------|-------|---------------|--------|
| KS for {γ_n/π} | 0.0108 | 0.0430 | **cannot reject H₀** |
| KS for {γ_n/e} | 0.0153 | 0.0430 | cannot reject |
| KS for {γ_n/√2} | 0.0149 | 0.0430 | cannot reject |
| KS for {γ_n/ln 2} | 0.0165 | 0.0430 | cannot reject |

All four constants give equidistributed fractional parts.
π is not special — in fact it has the SMALLEST KS statistic
(most uniform), though the differences are not significant.

### Closest approach to integer

| Constant | Best n | Distance | Expected min |
|----------|--------|----------|-------------|
| π | γ₉₆/π ≈ 73 | 0.000366 | 0.000500 |
| e | γ₉₅₃/e | 0.000329 | 0.000500 |
| √2 | γ₅₈₃/√2 | 0.000548 | 0.000500 |
| ln 2 | γ₉₂₈/ln 2 | 0.000516 | 0.000500 |

Observed/expected ratio for π: 0.73 — within normal range.
The γ₉₆/π ≈ 73 coincidence is NOT unusually close.

### χ² test (10 bins)

χ² = 5.92, critical value (df=9, 5%) = 16.9. **Cannot reject uniform.**

## Conclusion

**Zeta zeros do not "know" about π** any more than they "know" about
e, √2, or ln 2. The fractional parts {γ_n/π} are equidistributed,
consistent with the Grand Simplicity Hypothesis (that the γ_n are
linearly independent over ℚ).

The near-integer values (γ₉₆/π ≈ 73, etc.) that prompted this
investigation are statistical flukes — they occur at exactly the
rate expected for 1000 random values.

### What this means for the winding matrix

The 7-divisibility trace in the Smith form (det mod 7 = 0 at n=22,
26–30, 37, ...) is NOT caused by a special γ_n/π structure. It is
a Floor artifact: the approximation π ≈ 22/7 creates near-integer
entries at n ≈ 22, but this is a property of the CONSTANT (π has
22/7 as a convergent), not of the ZEROS (which are equidistributed
mod π).

### Note on methodology

The test does not compensate for zero density (γ_n ~ 2πn/ln n)
because the KS test operates on fractional parts mod 1, which are
independent of the spacing between consecutive γ_n. Equidistribution
of {αγ_n} for irrational α follows from Weyl's theorem if the γ_n
are sufficiently "generic" — and numerically, they are.
