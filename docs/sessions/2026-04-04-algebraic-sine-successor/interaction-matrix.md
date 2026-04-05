# The Interaction Matrix: Where Zeros Meet Primes

**Date:** 2026-04-05
**Status:** 🤔 EXPLORATORY

## Definition

The interaction matrix $M$ has entries:

$$M_{np} = \cos(\gamma_n \ln p) = \mathrm{Re}(p^{i\gamma_n})$$

indexed by zeros $\rho_n$ (rows) and primes $p$ (columns).

This is the meeting point of both dualities:

$$M_{np} = T_k\!\left(\cos\frac{\gamma_n\ln p}{k}\right) \qquad \text{for any integer } k$$

The "mixed seed" $c_{np}^{(k)} = \cos(\gamma_n\ln p/k)$ lives in the product
of the two orbit spaces.

## Both Dualities Read the Same Matrix

**Row sums** (fix prime $p$, sum over zeros):

$$\sum_n \frac{M_{np}}{|\rho_n|^2} \;\propto\; \text{correction to } \psi'(p)$$

Large negative row sum at $p$ → $\psi$ has a jump → $p$ is a prime power.

**Column sums** (fix zero $n$, sum over primes):

$$\sum_p \frac{M_{np}\ln p}{\sqrt{p}} \;\propto\; S'(\gamma_n)$$

Large column sum at $\gamma_n$ → $N(T)$ has a jump → $\gamma_n$ is a zero height.

## Numerical: The Matrix for First 8 Zeros × 8 Primes

```
          p=2    p=3    p=5    p=7    p=11   p=13   p=17   p=19
ρ_1:     -0.93  -0.98  -0.73  -0.72  -0.79   0.13  -0.70  -0.71
ρ_2:     -0.42  -0.45  -0.75  -1.00   0.99  -0.87  -0.99   0.59
ρ_3:      0.06  -0.70  -0.83  -0.03  -0.96   0.25  -0.17  -0.18
ρ_4:     -0.62  -0.42   0.27  -0.88  -0.77  -0.88  -0.19  -0.05
ρ_5:     -0.67   0.05  -0.92   0.31  -0.91  -0.94   0.59  -0.92
ρ_6:      0.61  -0.90  -0.70  -0.64  -0.56  -0.55   0.95  -0.76
ρ_7:     -1.00   0.56  -0.99  -0.47  -0.75  -0.28  -0.95   0.45
ρ_8:      0.19  -0.89   0.82  -0.87  -0.98  -0.38  -0.97  -0.33
```

Row sums (all columns are primes, so all row sums are negative — correct):
$p = 2: -2.79$, $p = 7: -4.29$, $p = 19: -1.90$.

## The Collapse Question

The matrix $M_{np}$ encodes the FULL information about the prime-zero duality.
If we could find a transformation that diagonalizes or simplifies $M$,
it would "collapse both planes" — relating zeros directly to primes
without going through $\zeta$.

### What we know

1. $M_{np} = T_k(c_{np}^{(k)})$ for any $k$ — Chebyshev factorization
2. Row sums detect primes, column sums detect zeros
3. The matrix is "complete": knowing all rows determines all columns (and vice versa)
4. SVD of $M$ would give principal modes of the prime-zero interaction

### The mixed seed $c_{np}^{(k)} = \cos(\gamma_n\ln p/k)$

For specific $(n, p, k)$ triples, the mixed seed approaches algebraic values.
Best approximations to $1/2$ found:

| Zero | Prime | $k$ | Seed | Error from $1/2$ |
|------|-------|-----|------|-------------------|
| $\rho_2$ | $7$ | $39$ | $0.4985$ | $1.5 \times 10^{-3}$ |
| $\rho_7$ | $3$ | $43$ | $0.5015$ | $1.5 \times 10^{-3}$ |
| $\rho_2$ | $3$ | $22$ | $0.4978$ | $2.2 \times 10^{-3}$ |

An exact algebraic mixed seed ($c_{np} \in \overline{\mathbb{Q}}$) would
require $\gamma_n\ln p/\pi \in \mathbb{Q}$ — a deep algebraic relation
between a zero and a prime. Unknown whether this ever occurs.

## The Vision: Collapsing Both Planes

The primal formula: $\psi'(x) = 1 - \frac{2}{\sqrt{x}}\sum_n M_{n,\lfloor x\rfloor}$
(morally — using the matrix row).

The dual formula: $S'(T) = -\frac{1}{\pi}\sum_p \frac{\ln p}{\sqrt{p}} M_{\lceil T\rceil, p}$
(morally — using the matrix column).

If both are simultaneously satisfied: the matrix $M$ is constrained by
BOTH row conditions (detecting primes) and column conditions (detecting zeros).
These are dual constraints on the same object.

A proof of RH would need to show: the row constraints (all primes detected correctly)
FORCE the column constraints (all zeros on the critical line) — or vice versa.
The matrix $M$ is the battlefield where this fight plays out.
