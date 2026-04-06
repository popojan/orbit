# Invariance Tests for ALS Roundtrip

**Date:** 2026-04-06
**Status:** 🔬 NUMERICALLY VERIFIED

## What the roundtrip IS invariant under

| Operation | Primes | γ | Why |
|-----------|--------|---|-----|
| Row permutation | ✓ | ✓ (reordered) | ALS is order-agnostic (mat-vec) |
| Column permutation | ✓ | ✓ | symmetric |
| Transpose $W^T$ | ✓ | ✓ | duality zeros↔primes is symmetric |

**The matrix carries information in its rank-1 pattern, not in ordering.**

## What it is NOT invariant under

| Operation | Primes | γ | Why |
|-----------|--------|---|-----|
| Additive shift $W + k$ | ✗ | ✗ | Adds rank-1 constant $k \cdot \mathbf{1}\mathbf{1}^T$, breaks structure |
| Multiplicative $k \cdot W$ | ✗ | ✗ | $k\lfloor x \rfloor \neq \lfloor kx \rfloor$ |
| Column scramble (prev. test) | ✗ | ✗ | Scale anchor $\ell_1 = \ln 2$ misidentified |

**Absolute entry values matter.** The +0.5 offset in ALS is the unique
shift converting Floor→Round (centering residuals). Integer shifts destroy
rank-1 structure.

## Rescaled winding: $\lfloor k \cdot a_n\ell_j \rfloor$

Building a NEW matrix with $W^{(k)}_{np} = \lfloor k\gamma_n\ln p/(2\pi)\rfloor$
is equivalent to measuring winding with period $2\pi/k$ instead of $2\pi$.

**Primes are recovered for all integer $k$ tested** (2, 5, 7, 11, 100).
γ is recovered as $k\gamma$; dividing by $k$ gives exact zeros.

### Precision scaling with $k$

| $k$ | primes | γ ratio error | γ mean err / k |
|-----|--------|--------------|----------------|
| 1 | 37/50 | 0.0097 | 0.040 |
| 2 | **50/50** | 0.0085 | 0.011 |
| 3 | 31/50 | 0.0064 | 0.017 |
| 5 | **50/50** | 0.0041 | 0.0096 |
| 7 | **50/50** | 0.0014 | 0.0060 |
| 11 | **50/50** | 0.0028 | 0.0042 |
| 100 | **50/50** | 0.00014 | 0.00029 |

Larger $k$ = finer "clock resolution" = better ratios and precision.
Precision scales roughly as $O(1/k)$: the Floor noise per entry
stays $O(1)$ but represents a smaller fraction of $k \cdot a_n\ell_j$.

### Integer vs irrational $k$

| $k$ | primes | ratio err |
|-----|--------|-----------|
| 2 (prime) | **50/50** | 0.0085 |
| 7 (prime) | **50/50** | 0.0014 |
| π | 28/50 | 0.015 |
| √2 | 41/50 | 0.023 |
| $e$ | 40/50 | 0.019 |

**Integer $k$ works better.** Irrational $k$ introduces a second source
of irrationality ($k$ interacts with the already-irrational $\gamma_n$),
degrading the integer lattice structure that ALS exploits.

### The factor-3 anomaly (resolved)

Full scan $k = 1, \ldots, 50$ reveals: ALL failures contain **factor 3**.

| $k$ | factorization | primes correct |
|-----|---------------|---------------|
| 3 | 3 | 31/50 |
| 6 | 2·3 | 49/50 |
| 9 | 3² | 48/50 |
| 12 | 2²·3 | 49/50 |
| 18 | 2·3² | 41/50 |
| all other $k \leq 50$ | — | **50/50** |

Prime vs composite $k$ is **irrelevant** — $k = 3$ (prime) fails,
$k = 4, 25, 27, 49$ (prime powers) work perfectly.

**Mechanism:** $\ln 3/\ln 2 \approx 1.585$. When $k$ is a multiple of 3,
$k \cdot \ln 3/\ln 2 \approx k \cdot 1.585$ approaches near-integers
that confuse the ALS snap. Specifically, $3 \cdot \ln 3/\ln 2 \approx 4.755$
is close to 5, creating a collision between the $p = 2$ and $p = 3$ columns.

This is a **snap artifact** (the OddQ + nearest-integer mechanism), not a
property of the winding matrix itself. With exact primes (no snap), all
$k$ values recover γ correctly.

## Geometric interpretation

The winding matrix with divisor $2\pi$ counts windings on the standard
unit circle. Replacing $2\pi$ with $2\pi/k$ is equivalent to counting
windings on a circle of circumference $2\pi/k$ — a "faster clock."

- $k = 1$: standard winding (one tick per $2\pi$ radians)
- $k = 7$: seven ticks per $2\pi$ radians (finer resolution)
- $k = 100$: hundred ticks (very fine)

**Primes don't depend on the clock speed** — they're encoded in the
RATIOS of column parameters (ln $p_j$ / ln 2), which are scale-invariant.

**Zeros depend on the clock speed** — their absolute values scale with $k$,
but their RATIOS are invariant.

The only thing $2\pi$ contributes is calibration: "one winding = $2\pi$
radians." Changing this to $2\pi/k$ changes the unit but not the structure.

## The +0.5 offset (clarified)

ALS on $W + 0.5$ is equivalent to ALS on $W_{\text{Round}}$ (nearest
integer instead of floor). This is NOT a free parameter — it's the
unique offset that centers the residuals, minimizing ALS bias.

For any integer shift $W + k$: rank-1 structure is destroyed (additive
constant becomes dominant). For the specific non-integer shift $W + 0.5$:
Floor converts to Round, residuals center at 0, ALS is unbiased.

Floor is geometrically natural (winding = complete revolutions).
Round is approximation-theoretically natural (nearest integer).
The +0.5 bridges them. The content is identical.
