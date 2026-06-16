# H2 — the orbit/Jacobi/moment route has no algorithmic edge (operator-existence test)

**Date:** 2026-06-15
**Status:** ❌ FALSIFICATION TARGET NOT MET — pre-registered prediction
**confirmed**: the Cassini/Chebyshev route reduces to the classical growth
criterion; no algorithmic advantage.
**Script:** [`scripts/h2-moment-toeplitz.wl`](scripts/h2-moment-toeplitz.wl)

## The setup (why this is the operator-existence test)

The orbit recurrence `f_{k+1}=2c f_k − f_{k-1}` is the three-term recurrence of a
**Jacobi matrix** (real symmetric tridiagonal). Per
[`operator-condition-exercise.md`](operator-condition-exercise.md): the
Hilbert–Pólya-style operator, if it is this Jacobi matrix, has real spectrum
automatically (real symmetric), and **"the operator meets the conditions" ⟺ its
spectral measure is a positive measure on the elliptic band `[−2,2]` ⟺ the
Chebyshev/cosine moment sequence `m_k = ∫ cos(kγ) dμ` is positive-definite**
(Carathéodory–Toeplitz). An off-line zero is a complex "frequency" whose moment
contribution grows like `cosh(kδ)` (the hyperbolic orbit growth), breaking
Toeplitz positivity at some order `K_detect`.

So H2 is not a side-probe — it is the **existence test for the operator**, and
its sharp falsifiable question is whether that test is **cheap** (an algorithmic
edge over classical RH numerics) or **expensive** (a re-description).

## Pre-registered prediction (Hypothesis-First)

`K_detect ~ C/δ` (need `k·δ ~ O(1)` for `cosh(kδ)` to beat the bounded on-line
baseline) → **expensive, no edge**. A `K_detect` that stayed **bounded** as
`δ→0` would falsify this and make the orbit/Jacobi structure algorithmically
load-bearing.

## Data (35-atom zeta window at T=100, baseline PD up to K_max=30)

Baseline no-false-positive check: `K_detect(δ=0) = ∞` ✓ (the on-line moment
Toeplitz stays positive-definite through `K_max`; detection below is the genuine
off-line signal, not rank-deficiency).

| `δ` | `K_detect` | `K_detect·δ` |
|---|---|---|
| 0.10 | 23 | 2.30 |
| 0.151 (real DH zero, T=114) | 18 | 2.72 |
| 0.20 | 16 | 3.20 |
| 0.25 | 14 | 3.50 |
| 0.308 (real DH zero, T=85.7) | 12 | 3.70 |
| 0.40 | 10 | 4.00 |
| 0.50 | 8 | 4.00 |

## Verdict

`K_detect·δ` stays `O(1)` (2.3 → 4.0, a mild sub-leading drift), so

$$K_{\rm detect}\ \sim\ \frac{2\text{–}4}{\delta}\ \xrightarrow{\ \delta\to0\ }\ \infty.$$

**Prediction confirmed.** Detecting an off-line zero at displacement `δ` costs
`~1/δ` moments. Since the `k`-th cosine moment is the explicit formula at
log-height `k` (`m_k ↔ ψ(e^k)`), needing `K_detect ~ 1/δ` moments is the same
budget as climbing to the corresponding height — exactly the classical growth
criterion. The hyperbolic `cosh(kδ)` signal is real but its extraction is **not
cheaper** than classical. The orbit/Jacobi/moment route is a **faithful
re-description, not an algorithmic lever.**

## What this settles for the session

- The [operator-condition-exercise](operator-condition-exercise.md) is **faithful
  scaffolding + a design heuristic**, not new computational power. Its one
  genuinely falsifiable claim — an algorithmic edge from the hyperbolic
  growth-cell — is now **tested and null**.
- The operator it points at is concrete (a real Jacobi matrix, off-diagonal =
  the successor/counting shift, spectrum-in-`[−2,2]` ⟺ RH), and its existence
  test is moment-positivity — but that test carries the same cost and the same
  unproven core (why the measure stays positive) as every classical route.
- Consistent with the no-go: a one-body re-parametrization (change of variables)
  cannot add information **or** a sub-classical algorithm. Confirmed empirically,
  not just argued.
