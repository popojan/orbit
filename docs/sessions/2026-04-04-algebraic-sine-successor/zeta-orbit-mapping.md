# The Zeta–Orbit Mapping

**Date:** 2026-04-04
**Status:** 🤔 INTERPRETIVE (structural analogy with precise formulation)

## The Observation

The degenerate point of the successor orbit ($c = 1$, naturals) sits at the
boundary between oscillatory and hyperbolic regimes. The critical line of the
Riemann zeta function ($\sigma = 1/2$) sits at the boundary between convergence
and divergence. Both are "phase transitions" with deep arithmetic content.

This is not just analogy — there is a precise mapping.

## The Explicit Formula as Orbit Superposition

The prime counting function $\psi(x) = \sum_{n \leq x} \Lambda(n)$ has the
explicit formula:

$$\psi(x) = \underbrace{x}_{\text{pole at } s=1} - \sum_{\rho} \frac{x^{\rho}}{\rho} - \ln(2\pi) - \ldots$$

In logarithmic coordinates $t = \ln x$, each zero $\rho = \sigma + i\gamma$ contributes:

$$-\frac{e^{\rho t}}{\rho} = -\frac{e^{\sigma t}}{\left|\rho\right|} \cos(\gamma t + \phi_\rho)$$

This is **exactly** our orbit structure: an amplitude $e^{\sigma t}$ times an
oscillation $\cos(\gamma t)$.

## The Dictionary

| Zeta function | Successor orbit |
|---|---|
| Zero $\rho = \sigma + i\gamma$ | Transfer matrix $M$ with eigenvalue $e^{\sigma + i\gamma}$ |
| Imaginary part $\gamma$ | Chebyshev parameter $c = \cos\gamma$ (frequency) |
| Real part $\sigma$ | $\sqrt{\det M} = e^{\sigma}$ (growth rate) |
| **Pole at $s = 1$** ($\gamma = 0$) | **Degenerate case $c = 1$** (naturals) |
| Zero with $\gamma > 0$ | Oscillatory regime $\|c\| < 1$ |

### The three columns

| Feature | Explicit formula | Orbit framework |
|---|---|---|
| Main term | $x$ (from pole at $s = 1$) | $f_k = k+1$ (naturals, $c = 1$) |
| Corrections | $-x^{\rho}/\rho$ (from zeros) | $U_k(\cos\gamma)$ scaled by $e^{\sigma k}$ |
| Normalization | Divide by $\sqrt{x}$ | Divide by $\sqrt{\det M}$ per step |

## What RH Says in Orbit Language

The Riemann Hypothesis: all nontrivial zeros have $\sigma = 1/2$.

In orbit language:

> **RH: all oscillatory corrections to "counting" have the same amplitude growth rate
> ($\det M = e$, i.e., $\sqrt{x}$ per step in log-coordinates).**

After normalization by $\sqrt{\det M} = e^{1/2}$ per step (dividing by $\sqrt{x}$),
**all corrections live on the same algebraic circle** — the norm-1 subgroup.

A violation of RH would mean some correction lives on a **larger circle** (bigger
$\det M$, faster growth). In the orbit language: one of the "frequencies" has a
louder amplitude than the $\sqrt{x}$ envelope.

This is precisely the statement that $\psi(x) - x = O(x^{1/2 + \epsilon})$ for
all $\epsilon > 0$ (equivalent to RH).

## The Chebyshev Parameters of Zeta Zeros

Each zeta zero $\rho_n = 1/2 + i\gamma_n$ maps to a Chebyshev parameter $c_n = \cos\gamma_n$:

| $n$ | $\gamma_n$ | $c_n = \cos\gamma_n$ | Regime |
|---|---|---|---|
| (pole) | $0$ | $1$ | **Degenerate** (naturals) |
| 1 | $14.1347\ldots$ | $0.0025$ | Oscillatory (nearly degenerate!) |
| 2 | $21.0220\ldots$ | $-0.5660$ | Oscillatory |
| 3 | $25.0109\ldots$ | $0.9926$ | Oscillatory (nearly degenerate!) |
| 4 | $30.4249\ldots$ | $0.5478$ | Oscillatory |
| 5 | $32.9351\ldots$ | $0.0516$ | Oscillatory |
| 6 | $37.5862\ldots$ | $0.9936$ | Oscillatory (nearly degenerate!) |

Note: several zeros have $c \approx 1$ — they are **near-degenerate**, meaning their
contribution to $\psi(x)$ looks like "almost counting" for a long stretch before
oscillating away. This happens when $\gamma$ is close to a multiple of $2\pi$:
$\gamma_3 \approx 8\pi$, $\gamma_6 \approx 12\pi$.

## What This Construction Adds

The mapping reformulates the explicit formula in orbit language. This is NOT new
mathematics — it is a restatement of the spectral decomposition of $\psi(x)$.
The underlying connection (between $\mathrm{GL}_2$ structures and $L$-functions)
is the subject of the Langlands program.

What the orbit framework provides:

1. **Geometric interpretation of RH**: all corrections on the same circle after normalization
2. **The degenerate point as the pole**: the naturals ($c = 1$) correspond to the simple
   pole of $\zeta(s)$ at $s = 1$, which gives the main term $x$ in $\psi(x)$
3. **Near-degenerate zeros**: zeros with $c \approx 1$ are "almost counting" — they
   contribute long stretches of near-linear growth before oscillating away
4. **Unified vocabulary**: the same triptych (oscillatory / degenerate / hyperbolic)
   describes both the orbit regimes and the zeta zero structure

### Honest assessment

| Claim | Status |
|---|---|
| The mapping exists and is precise | ✅ (reformulation of explicit formula) |
| The pole at $s=1$ = degenerate case | ✅ (both give "counting") |
| RH = all corrections on same circle | ✅ (restatement in geometric language) |
| This gives new tools for proving RH | ❌ (no mechanism, no new inequality) |
| This is new mathematics | ❌ (it is a new presentation of known structure) |
| This is a useful perspective | 🤔 (possibly — connects orbit theory to analytic NT) |
