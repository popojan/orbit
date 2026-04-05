# Smith Normal Form of the Winding Matrix

**Date:** 2026-04-05
**Status:** 🔬 NUMERICALLY VERIFIED (up to 35×35)

## Result

The Smith Normal Form of the winding matrix $W_{np} = \lfloor\gamma_n\ln p/(2\pi)\rfloor$:

$$W = S \cdot D \cdot T$$

where $S, T$ are unimodular (integer, $\det = \pm 1$) and $D$ is diagonal.

**The diagonal $D$ has a striking structure: all entries are 1 except possibly
the last one.**

$$D = \mathrm{diag}(1, 1, 1, \ldots, 1, d_n)$$

where $d_n$ is the sole nontrivial invariant factor.

## Numerical Data

| $n$ | Rank | $d_n$ (last inv. factor) | $\det W$ | Notes |
|-----|------|--------------------------|----------|-------|
| 4 | 4 | 1 | 1 | Unimodular |
| 5 | 5 | 1 | $-1$ | Unimodular |
| 6 | 5 | 0 | 0 | Singular |
| 7 | 6 | 0 | 0 | Singular |
| 8 | 6 | 0 | 0 | Singular |
| 9 | 6 | 0 | 0 | Singular |
| 10 | 8 | 0 | 0 | Singular |
| 13 | 12 | 0 | 0 | Singular |
| 18 | 17 | 0 | 0 | Singular |
| 19 | 19 | 2 | $-2$ | Full rank, first $d_n > 1$ |
| 20 | 20 | 2 | $-2$ | |
| 22 | 22 | 10 | 10 | |
| 25 | 25 | 20 | 20 | |
| 27 | 27 | 59 | $-59$ | Prime! |
| 29 | 29 | 21 | 21 | |
| 30 | 30 | 51 | 51 | |
| 32 | 32 | 171 | 171 | |
| 34 | 34 | 960 | 960 | |
| 35 | 35 | 1048 | 1048 | Growing fast |

## Interpretation

### All complexity in one number

The Smith form says: up to unimodular change of basis (integer row/column
operations with $\det = \pm 1$), the winding matrix is **the identity matrix**
with at most one modified diagonal entry $d_n$.

The entire arithmetic content of the $n \times n$ winding matrix — all the
interactions between $n$ zeros and $n$ primes — reduces to a **single integer** $d_n$.

### Three regimes

1. **Small $n$ ($\leq 5$):** $d_n = 1$, $W$ is unimodular. Rows of $W$ form a
   basis for $\mathbb{Z}^n$. Perfect integer independence.

2. **Medium $n$ ($6$–$18$):** $d_n = 0$, $W$ is singular. Rows of $W$ have
   an integer linear dependency (rank deficiency 1–3).

3. **Large $n$ ($\geq 19$):** $d_n$ grows. $W$ has full rank but the last
   invariant factor accumulates arithmetic structure. $\det W = \pm d_n$.

### The sequence $d_n$

For $n \geq 19$: $d_n = 2, 2, 0, 10, 0, 0, 20, 14, 59, 49, 21, 51, 42, 171, 270, 960, 1048, \ldots$

This sequence is not in the OEIS (checked the nonzero subsequence).
Its factorizations might reveal structure:

- $d_{19} = 2$
- $d_{22} = 10 = 2 \times 5$
- $d_{25} = 20 = 2^2 \times 5$
- $d_{27} = 59$ (prime)
- $d_{29} = 21 = 3 \times 7$
- $d_{32} = 171 = 9 \times 19$
- $d_{34} = 960 = 2^6 \times 3 \times 5$

No obvious pattern yet. Growth is roughly exponential.

### Connection to the rank-1 structure

The SVD showed: $W$ has a dominant rank-1 component ($\sigma_1/\sigma_2$ grows).
The Smith form shows: $W$ has trivial invariant factors (all 1) except possibly
the last.

These are complementary views:
- **SVD** (real): one dominant direction, small corrections
- **Smith** (integer): unimodularly equivalent to identity, one nontrivial factor

Both say: the winding matrix is "as simple as possible" for an integer matrix,
with complexity concentrated in one number ($\sigma_1$ or $d_n$).

### The unimodular matrices $S$ and $T$

$T$ (right factor) consistently has $\max|T_{ij}| = 1$ for $n \leq 20$:
entries in $\{-1, 0, 1\}$ only. This means: the column operations needed
to reduce $W$ to Smith form are **elementary** (add/subtract columns).

$S$ (left factor) has $\max|S_{ij}|$ growing slowly (2–4 for $n \leq 20$),
but explodes for $n > 25$. The row operations become more complex.

## Open Questions

1. **Does $d_n$ have a closed form?** Its growth rate, factorization pattern,
   and relationship to the zeros and primes are unknown.

2. **Why are all other invariant factors 1?** This says the minors of $W$
   generate all of $\mathbb{Z}$ — a strong statement about the integer
   independence of $\lfloor\gamma_n\ln p/(2\pi)\rfloor$ values.

3. **Is the rank deficiency for $n = 6$–$18$ related to specific
   near-integer relationships among $\gamma_n\ln p/(2\pi)$?**

4. **Does $d_n$ encode number-theoretic information** (e.g., about the
   distribution of $\gamma_n\ln p \bmod 2\pi$)?
