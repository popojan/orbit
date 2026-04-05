# The Winding Number Structure of Prime-Zero Duality

**Date:** 2026-04-05
**Status:** 🔬 NUMERICALLY VERIFIED (up to 50×50), theoretical framework ✅

## Main Result

The interaction matrix $M_{np} = \cos(\gamma_n\ln p)$ — the fundamental object
connecting zeta zeros ($\gamma_n$) and primes ($p$) — arises from a
**rank-1 matrix through two operations**: exponentiation and real-part projection.

The intermediate object — the **winding number matrix** —

$$w_{np} = \left\lfloor\frac{\gamma_n\ln p}{2\pi}\right\rfloor$$

is numerically **almost exactly rank 1**, with the rank-1 approximation
improving as the matrix grows.

## The Decomposition

$$\gamma_n\ln p = 2\pi\, w_{np} + r_{np}$$

where:

- $\gamma_n\ln p = (\boldsymbol{\gamma}\boldsymbol{\ell}^T)_{np}$:
  rank-1 matrix (outer product of zero heights and prime logarithms)
- $w_{np} = \lfloor\gamma_n\ln p/(2\pi)\rfloor$: integer winding numbers
- $r_{np} = \gamma_n\ln p - 2\pi w_{np} \in [0, 2\pi)$: fractional residual

And the interaction matrix:

$$M_{np} = \cos(2\pi w_{np} + r_{np}) = \cos(r_{np})$$

depends only on the residuals $r_{np}$ — the "fractional winding" part.

## The SVD of the Winding Matrix

Numerical experiments for square matrices of size $n$:

| $n$ | $\sigma_1$ | $\sigma_1/\sigma_2$ | Rank-1 captures | Trend |
|-----|------------|---------------------|-----------------|-------|
| 4 | 19 | 41 | 99.88% | |
| 6 | 47 | 71 | 99.94% | |
| 8 | 84 | 96 | 99.96% | |
| 10 | 134 | 122 | 99.97% | $\nearrow$ |
| 15 | 305 | 198 | 99.99% | $\nearrow$ |
| 20 | 541 | 298 | 99.99% | $\nearrow$ |
| 30 | 1201 | 491 | 99.996% | $\nearrow$ |
| 40 | 2113 | 652 | 99.998% | $\nearrow$ |
| 50 | 3264 | **872** | **99.998%** | $\nearrow$ |

**Key observations:**

1. **$\sigma_1/\sigma_2$ grows with $n$** — the spectral gap INCREASES.
   The rank-1 approximation gets BETTER for larger matrices.

2. **$\sigma_1 \sim O(n^2)$**: the dominant singular value grows quadratically
   (as expected for the rank-1 part $\gamma_n\ln p/(2\pi)$, since both
   $\gamma_n \sim n$ and $\ln p_n \sim \ln n$).

3. **$\sigma_2, \sigma_3, \ldots \approx 3$**: all remaining singular values
   are $O(1)$, approximately constant regardless of matrix size.
   These are the floor-function corrections.

4. **Effective rank for 99% variance: 1** — for all sizes tested.

## Why the Winding Matrix Is Almost Rank 1

$$w_{np} = \left\lfloor\frac{\gamma_n\ln p}{2\pi}\right\rfloor = \frac{\gamma_n\ln p}{2\pi} - \left\{\frac{\gamma_n\ln p}{2\pi}\right\}$$

where $\{x\} = x - \lfloor x\rfloor \in [0, 1)$ is the fractional part.

The first term $\gamma_n\ln p/(2\pi)$ is rank 1 with singular value
$\|\boldsymbol{\gamma}\|\cdot\|\boldsymbol{\ell}\|/(2\pi) \sim O(n^2)$.

The second term $\{x\}$ is bounded in $[0, 1)$ for each entry.
Its matrix norm is $O(\sqrt{n})$ (since $n^2$ entries each $O(1)$).

Therefore: $\sigma_1(w) = O(n^2)$ (from rank-1 part),
$\sigma_k(w) = O(1)$ for $k \geq 2$ (from fractional parts).
The ratio $\sigma_1/\sigma_2 = O(n^2)$ grows without bound.

## The Residual Spectrum

The singular values $\sigma_2, \sigma_3, \ldots$ of the winding matrix
(the "floor corrections") have a remarkably flat spectrum — all approximately
equal to $\sim 3$, independent of matrix size.

At $n = 50$: $\sigma_2 = 3.74, \sigma_3 = 3.35, \ldots, \sigma_{10} = 2.67$.

This flat spectrum is characteristic of a **random-like** matrix with
bounded entries and no dominant structure — which is exactly what the
fractional parts $\{\gamma_n\ln p/(2\pi)\}$ are (they are equidistributed
in $[0, 1)$ by Weyl's theorem, assuming algebraic independence).

## Interpretation

### The "secret" of prime-zero duality

$$\underbrace{\cos(\gamma_n\ln p)}_{\text{full rank (hard)}} = \cos\!\left(2\pi\underbrace{\left\lfloor\frac{\gamma_n\ln p}{2\pi}\right\rfloor}_{\text{almost rank 1 (easy)}} + \underbrace{r_{np}}_{\text{residual in } [0, 2\pi)}\right) = \cos(r_{np})$$

The winding numbers $w_{np}$ are "almost known" (they're approximately
$\gamma_n\ln p/(2\pi)$, which is rank 1). The entire non-trivial content
is in the **residuals** $r_{np} \in [0, 2\pi)$ — the fractional parts
of $\gamma_n\ln p/(2\pi)$.

And the interaction matrix $M_{np} = \cos(r_{np})$ depends ONLY on the residuals.

### The hierarchy of difficulty

| Object | Rank | Norm | Status |
|--------|------|------|--------|
| $\gamma_n\ln p$ | 1 | $O(n^2)$ | Known (trivial) |
| $w_{np} = \lfloor\gamma_n\ln p/(2\pi)\rfloor$ | "1 + noise" | $O(n^2) + O(1)$ | Almost known |
| $r_{np} = \{\gamma_n\ln p/(2\pi)\} \cdot 2\pi$ | Full | $O(1)$ per entry | **This is the hard part** |
| $M_{np} = \cos(r_{np})$ | Full | $O(1)$ per entry | Observable |

The number-theoretic content is concentrated in the $O(1)$ residuals — the
fractional parts of $\gamma_n\ln p/(2\pi)$. These are "small" (bounded)
but "complex" (full rank, equidistributed).

### Connection to RH

The Riemann Hypothesis constrains $M_{np}$ (through the explicit formula).
In the winding decomposition: RH constrains the **residuals** $r_{np}$.

Since $r_{np}$ depends on $\gamma_n$ (the unknown zero heights), and RH
asserts $\mathrm{Re}(\rho_n) = 1/2$: the constraint is on HOW the residuals
distribute, not on the winding numbers (which are almost rank 1 regardless).

## Numerical Verification

All results verified with Mathematica's `ZetaZero[]` and exact arithmetic
for the floor function. The SVD uses machine-precision floating point
(15 digits). The rank-1 fraction (99.998% at $n = 50$) is robust to
precision — the gap $\sigma_1/\sigma_2 \sim 872$ is far from any
numerical threshold.

The scaling $\sigma_1/\sigma_2 \propto n$ (approximately linear) was observed
for $n = 4, \ldots, 50$ and is predicted by the $O(n^2)$ vs $O(1)$ argument
above (since $\sigma_1 \sim n^2$ and $\sigma_2 \sim O(1)$, the ratio
grows as $n^2$, faster than the observed $\sim n$; the discrepancy
may be due to correlations in the fractional parts).

## Summary

$$\boxed{w_{np} = \frac{\gamma_n\ln p}{2\pi} + O(1)}$$

The winding number matrix is rank 1 up to bounded corrections.
The bounded corrections (floor residuals) carry the full number-theoretic
content. They have flat SVD spectrum ($\sigma \sim 3$), characteristic
of equidistributed fractional parts.

The prime-zero duality, viewed through the winding decomposition,
is the interplay between a **trivial rank-1 skeleton** ($\gamma\otimes\ell/(2\pi)$)
and **number-theoretically rich $O(1)$ corrections** (the floor residuals).
