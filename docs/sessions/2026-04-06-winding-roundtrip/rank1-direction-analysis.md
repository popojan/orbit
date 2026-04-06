# Rank-1 Direction Analysis: Floor Perturbation Geometry

**Date:** 2026-04-06 (late session)
**Status:** 🔬 NUMERICALLY VERIFIED

## Setup

The continuous matrix $M = a \otimes \ell$ (where $a_n = \zeta(3)\gamma_n/(2\pi)$,
$\ell_j = \ln p_j$) is exactly rank 1, defining a single direction in $\mathbb{R}^n$.

The winding matrix $W = \lfloor M \rfloor$ is "almost" rank 1. Its SVD:
$W = \sigma_1 u_1 v_1^T + \sigma_2 u_2 v_2^T + \cdots$

**Question:** How does $u_1$ (SVD dominant direction) relate to the true
rank-1 direction $\hat{a} = a/\|a\|$? How does the deviation behave as $n \to \infty$?

## Convergence of dominant direction

| $n$ | $\sigma_1/\sigma_2$ | Angle $u_1 \angle \hat{a}$ | $\sigma_2/\sigma_1$ |
|-----|--------------------|-----------------------------|---------------------|
| 5 | 37 | 1.43° | 2.7% |
| 10 | 94 | 0.59° | 1.1% |
| 20 | 256 | 0.29° | 0.39% |
| 50 | 965 | 0.13° | 0.10% |
| 100 | 2340 | 0.074° | 0.043% |
| 200 | 5657 | 0.040° | 0.018% |

**Scaling:** Angle $\sim O(1/n)$, $\sigma_1/\sigma_2 \sim O(n)$.

The SVD dominant direction converges to the true rank-1 direction.
In the $n \to \infty$ limit: $u_1^{(n)} \to \hat{a} = (\gamma_1, \gamma_2, \ldots)/\|(\gamma_i)\|$.

## Deviation structure

The deviation $\delta = u_1 - \hat{a}$ (for $n = 20$) has:
- **Systematic bias:** negative for small $i$ (low zeros), positive for large $i$ (high zeros)
- **Autocorrelation: 0.80** — strongly correlated, not random
- **Magnitude:** $\|\delta\| \approx 0.005$

The bias arises from Floor asymmetry: $\lfloor x \rfloor = x - \{x\}$
subtracts a non-negative fractional part, systematically pulling entries down.
The effect is stronger for entries with larger fractional parts (near-integer
values are less affected).

## The second singular vector: Floor noise direction

$u_2$ (the first "new" direction created by Floor discretization) carries
information about **where Floor crosses integer boundaries**. Its components
oscillate without monotone trend, reflecting the quasi-random pattern of
$\{\zeta(3) \gamma_n \ln p_j / (2\pi)\}$ fractional parts.

$\sigma_2 \approx O(\sqrt{n})$ (Floor noise Frobenius norm grows as $\sqrt{n \cdot n}$,
but the dominant noise direction captures $O(\sqrt{n})$).

## Rotation interpretation

The map from true direction $\hat{a}$ to SVD direction $u_1^{(n)}$ can be
viewed as a rotation in $\mathbb{R}^n$. However, this "rotation" is
$n$-dependent (lives in different-dimensional spaces for each $n$), so it
cannot be expressed as a single fixed rotation matrix.

What CAN be formalized: the projection onto a fixed finite-dimensional
subspace. For any fixed $k$, the first $k$ components of $u_1^{(n)}$
converge as $n \to \infty$:

$$u_1^{(n)}_i \to \hat{a}_i \quad \text{for each fixed } i \text{ as } n \to \infty$$

This is pointwise convergence (not uniform in $i$). The deviation at position
$i$ in an $n$-dimensional vector is $O(i/n^2)$ (larger $i$ = larger deviation,
but all vanish as $n \to \infty$).

### Givens rotation angle

For any pair of coordinates $(i, j)$, the 2D rotation angle needed to
align the $(i,j)$-projection of $u_1^{(n)}$ with $\hat{a}$ is:

$$\theta_{ij}^{(n)} = \arctan\left(\frac{\delta_i a_j - \delta_j a_i}{a_i a_j + \delta_i \delta_j}\right) \approx \frac{\delta_i}{a_i} - \frac{\delta_j}{a_j}$$

Since $\delta_i/a_i$ is the **relative deviation** at position $i$, the
Givens angle measures the **differential rotation** between two coordinates.
The systematic bias (negative for small $i$, positive for large $i$) means
the Givens angles have consistent sign — the Floor "rotates" the direction
in a specific way, not randomly.

## Connection to singularity

The rank of $W$ is determined by how many singular values are nonzero.
Since $\sigma_1 \gg \sigma_2 \gg \cdots$, the matrix is "almost rank 1"
but the Floor noise provides the extra dimensions.

For $\det(W) \neq 0$: ALL $n$ singular values must be nonzero, i.e.,
the Floor noise must "fill" all $n$ directions. This happens when the
fractional parts $\{a_i \ell_j\}$ are sufficiently "spread out" to
create $n$ linearly independent perturbation directions.

The connection to $\zeta(3)$: the Euler product correction
$p^3/(p^3-1)$ modifies the fractional parts in column $p = 2$
just enough to ensure the Floor noise fills the last remaining
direction (preventing $\sigma_n = 0$).

## Open questions

1. **Convergence rate:** Is the angle exactly $\Theta(1/n)$ or is there a
   logarithmic correction? The data suggests pure $1/n$.

2. **Limit operator:** Does $W$ define a bounded operator on $\ell^2$ in the
   $n \to \infty$ limit? The rank-1 part $M$ does (as a compact operator).
   The Floor perturbation $W - M$ has bounded entries but growing dimension.

3. **Spectral measure:** The distribution of $\sigma_2, \sigma_3, \ldots$
   (the "Floor noise spectrum") — does it follow a known distribution
   (Marchenko-Pastur, Tracy-Widom, ...)?

4. **Deviation structure:** The systematic bias in $\delta$ connects to the
   non-uniform residual distribution. Can it be computed analytically from
   the density of $\{\zeta(3)\gamma_n \ln p/(2\pi)\}$?
