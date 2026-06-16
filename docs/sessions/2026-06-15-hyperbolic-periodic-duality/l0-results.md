# L0 — the prime frequencies in the operator's data

**Date:** 2026-06-15
**Status:** (i) ✅ clean; (ii) ⚠️ partial (numerically unstable, conceptually
the wrong place to look).
**Script:** [`scripts/l0-prime-cocycle.wl`](scripts/l0-prime-cocycle.wl)

Tests the cocycle-frequency hint from [`finding-the-operator.md`](finding-the-operator.md):
*is the operator a $\{\log p\}$-driven object?* Two probes on the first 150 zeros.

## (i) Prime spectrum of the zeros — clean

$D(\omega)=\bigl|\sum_n e^{i\omega\gamma_n}\bigr|$ (conjugate to height $\gamma$,
so no index-drift) peaks at $\omega=\log p^m$, to 3–4 digits:

| peak $\omega$ | $\log p^m$ | $p^m$ | height |
|---|---|---|---|
| 0.694 | 0.6931 | 2 | 23.3 |
| 1.098 | 1.0986 | 3 | 31.5 |
| 1.387 | 1.3863 | $2^2$ | 17.3 |
| 1.609 | 1.6094 | 5 | 36.0 |
| 1.946 | 1.9459 | 7 | 35.8 |
| 2.080 | 2.0794 | $2^3$ | 10.5 |
| 2.198 | 2.1972 | $3^2$ | 17.2 |
| 2.398 | 2.3979 | 11 | 35.6 |
| 2.565 | 2.5649 | 13 | 34.1 |
| 2.834 | 2.8332 | 17 | 32.5 |
| 3.135 | 3.1355 | 23 | 31.2 |
| 3.219 | 3.2189 | $5^2$ | 14.4 |

Every dominant peak lands on $\log$ of a **prime power** (von Mangoldt support),
heights decaying with $p$ (the $\Lambda(n)/\sqrt p$ weighting). The zero-signal
**is a $\{\log p\}$ quasiperiodic superposition** — this is the explicit-formula
dual made visible, and it is the concrete empirical basis for "the operator is a
$\log p$-driven cocycle." (Known result; here it grounds the hint in data.)

## (ii) The Jacobi off-diagonal — partial

Reconstructing $b_k$ from the (folded) zeros by Lanczos: the first coefficients
are clean and **decrease toward $1/2$** (the free Jacobi value):

```
b_k:  0.548, 0.517, 0.513, 0.511, 0.510, 0.509, 0.507, 0.506, ... -> 1/2
```

— consistent with the **free-Jacobi baseline $+$ arithmetic perturbation**
picture (the operator approaches the free "$+1$" coupling, with deviations
carrying the arithmetic). But two honest limits:

1. **Numerically unstable.** Full reorthogonalized Lanczos breaks down
   (`0/0`) past $k\sim8$ for this discrete near-unbounded measure — the inverse
   spectral problem is ill-conditioned (as flagged in the earlier near-miss).
2. **Wrong place to look anyway.** The index $k\leftrightarrow$ height map drifts
   (the mean gap shrinks with height), so the $\{\log p\}$ frequencies are
   **chirped** in $b_k(k)$ — they do not appear as clean peaks. The clean,
   drift-free probe is (i), conjugate directly to $\gamma$.

## Net

The $\{\log p\}$ frequencies are **confirmed in the data** (i); the operator's
off-diagonal approaches the free baseline with an arithmetic perturbation (ii,
qualitatively). Both are consistent with the operator-as-$\log p$-cocycle
picture. Sharply isolating $\{\log p\}$ in the operator's *entries* would need a
narrow-height window (constant gap) and a stable inverse-spectral method — a
follow-up. The clean operator-frequency evidence is the spectral side (i).

Speculative follow-up worth trying: the integrality $\leftrightarrow$ Avila
acceleration-quantization angle (the Lyapunov exponent's acceleration under an
imaginary frequency shift is integer-quantized — possibly where "primes are
integers" forces spectral reality, intuition.txt suspect 1).
