# The Index Matrix: Polynomial Complexity of the Interaction

**Date:** 2026-04-05
**Status:** 🤔 EXPLORATORY

## Definition

The interaction matrix $M_{np} = \cos(\gamma_n\ln p)$ factors as $T_{K_{np}}(c_{np})$
where $K_{np} = k_1^{(p)} \cdot k_2^{(n)}$ are the minimal Chebyshev degrees
and $c_{np} = \cos(\gamma_n\ln p/K_{np})$ are the seeds.

The **index matrix** is:

$$K_{np} = k_2^{(n)} \cdot k_1^{(p)}$$

This is **exactly rank 1** — an outer product of two integer vectors.

## What the Indices Encode

$k_2^{(n)}$: the "polynomial cost" of zero $n$ — how high a degree Chebyshev
polynomial is needed to resolve zero $n$ from the degenerate point.

$k_1^{(p)}$: the "polynomial cost" of prime $p$ — similarly.

| Zero | $\|\cos\gamma_n\|$ | $k_2$ | Meaning |
|------|---------------------|--------|---------|
| $\rho_2, \rho_4$ | $0.55, 0.55$ | 1 | Already well-separated; $T_1 = c$ suffices |
| $\rho_1, \rho_5$ | $0.003, 0.05$ | 2 | Near $c = 0$; need $T_2 = 2c^2-1$ |
| $\rho_3$ | $0.993$ | 3 | Near-degenerate; need $T_3 = 4c^3-3c$ |
| $\rho_6$ | $0.994$ | 5 | Very near-degenerate; need degree 5 |

**Near-degenerate zeros require higher polynomial degree.**
And these are the most common type (arccosine distribution).

## Separation of Complexity

Because $K = \mathbf{k_2} \cdot \mathbf{k_1}^T$ is rank 1:

$$\text{polynomial cost of (zero, prime) pair} = \text{zero cost} \times \text{prime cost}$$

The costs are **multiplicatively separable**. Zero $n$'s difficulty
doesn't depend on which prime it's paired with (and vice versa).

## The Full Matrix via Index Matrix

$$M_{np} = T_{K_{np}}(c_{np}), \qquad c_{np} = \cos\frac{\gamma_n\ln p}{K_{np}}$$

The seed is determined by the index:

| Known | Status |
|-------|--------|
| Index matrix $K$ | Rank 1, small integers, computable |
| Seeds $c_{np}$ | Determined by $K$ and $\gamma_n\ln p$ |
| Full matrix $M$ | $= T_K(c)$, determined by above |

If we could ignore the seeds (set them all equal): $M$ would be rank 1.
The seeds are what inflate rank 1 to full rank.

**The seeds carry all the transcendental complexity.**
The index matrix carries only the polynomial/combinatorial structure.

## Connection to Diophantine Approximation

$k_2^{(n)}$ is related to the continued fraction of $\gamma_n/\pi$:

- Small $k_2$: $\cos(\gamma_n/k_2)$ well-behaved → $\gamma_n/\pi$ has good
  rational approximation with small denominator
- Large $k_2$: $\cos\gamma_n \approx \pm 1$ (near-degenerate) → $\gamma_n/\pi$
  is close to a half-integer → needs higher polynomial to resolve

Similarly, $k_1^{(p)}$ relates to $\ln p/\pi$.

The index matrix encodes the **Diophantine complexity** of the prime-zero
interaction in a compact, rank-1, integer-valued form.
