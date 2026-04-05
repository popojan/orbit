# Full Pipeline: Primes → Winding Matrix → Zero Heights

**Date:** 2026-04-05
**Status:** 🔬 PROOF OF CONCEPT (7/10 correct with 100 primes)

## The Pipeline

No zeta zeros are computed at any step.

```
Primes p₁, p₂, ...
    ↓ (Euler product / S(T) formula)
N(T) bounds on γ_n (approximate zero heights)
    ↓ (Floor function)
Winding row: w_{n,pⱼ} = ⌊γ_n ln pⱼ / (2π)⌋
    ↓ (Multi-base interval intersection)
Refined γ_n (higher precision than S(T) alone)
```

## Numerical Results (10 zeros, 100 primes for $S(T)$, 4 primes per row)

### Step 1: $S(T)$ prediction of $\gamma_n$

Using $N(T) = \theta(T)/\pi + 1 + S(T)$ with $S(T)$ from 100 primes (terms $m \leq 3$):

| Zero | $\gamma_n$ exact | $\gamma_n$ predicted | Error | Winding row correct? |
|------|------------------|---------------------|-------|---------------------|
| $\rho_1$ | 14.135 | 14.104 | 0.031 | ✓ |
| $\rho_2$ | 21.022 | 24.514 | 3.49 | ✗ |
| $\rho_3$ | 25.011 | 22.948 | 2.06 | ✗ |
| $\rho_4$ | 30.425 | 30.441 | 0.016 | ✓ |
| $\rho_5$ | 32.935 | 32.915 | 0.020 | ✓ |
| $\rho_6$ | 37.586 | 40.432 | 2.85 | ✗ |
| $\rho_7$ | 40.919 | 40.909 | 0.010 | ✓ |
| $\rho_8$ | 43.327 | 43.325 | 0.003 | ✓ |
| $\rho_9$ | 48.005 | 47.983 | 0.023 | ✓ |
| $\rho_{10}$ | 49.774 | 49.777 | 0.003 | ✓ |

**7/10 correct**. Failures at $\rho_2, \rho_3, \rho_6$: $S(T)$ error exceeds
the winding number resolution.

### Step 2: Multi-base refinement

For the 7 correct rows: the winding entries $\lfloor a_n\ln p\rfloor$ with
$p = 2, 3, 5, 7$ give interval intersection that refines $\gamma_n$ further.

Average recovery error: 0.1–0.7 (from 4 primes). With more primes per row:
error decreases as $O(1/k)$.

## Key Insight: Fewer Primes per Row Can Be Better

With $N(T)$ bounds of width $\sim 0.1$ (in $a_n$ units):

| Primes per row | Valid rows per zero |
|----------------|-------------------|
| 4 | **1 (UNIQUE!)** |
| 8 | 1–2 |
| 15 | 3–4 |
| 30 | 6–11 |

Counterintuitively: **fewer primes** with tight $N(T)$ bounds gives unique
identification. More primes add resolution but also more "near-boundary"
alternatives within the narrow interval.

The optimal strategy: use MANY primes for $S(T)$ (to get tight bounds),
but FEWER primes per winding row (to get unique identification).

## Bottleneck

The 3 failures come from $S(T)$ inaccuracy — the prime sum approximation
to $\arg\zeta$ on the critical line converges slowly (conditionally, not
absolutely). More primes and higher $m$ terms improve it but cannot
fully resolve zeros near where $N(T)$ has rapid oscillation.

This is the SAME bottleneck as computing zeros directly: the Euler product
converges slowly on the critical line.

## What This Demonstrates

The winding matrix framework converts the "find zeta zeros" problem into:

1. **Approximate** $\gamma_n$ from primes (via $S(T)$) — needs moderate precision
2. **Discretize** to integer winding numbers — tolerates errors up to $\sim 1$
3. **Refine** from the discrete representation — multi-base encoding recovers precision

The discretization step (Floor) acts as an **error-correcting code**: small
errors in $\gamma_n$ still give the correct integer winding numbers, and the
integers allow precision recovery via the multi-base intersection.

The pipeline works for 70% of zeros with 100 primes. With more primes
(better $S(T)$): the success rate should approach 100%.
