# Experiment 0 — results

**Date:** 2026-06-15
**Status:** ✅ MECHANISM GATE PASSED (necessary condition for the lens)
**Scripts:** [`scripts/exp0-weil-positivity.wl`](scripts/exp0-weil-positivity.wl),
[`scripts/exp0-refine.wl`](scripts/exp0-refine.wl)

Tests the lens claim of [`README.md`](README.md) §3: *the explicit-formula
(Weil) quadratic form, built from the **geometric side** (primes + archimedean +
pole, with no reference to zero locations), is positive semidefinite for genuine
ζ and goes **indefinite** when the spectrum contains an FE-symmetric off-line
quartet of zeros.* Test functions: modulated Gaussians
`f_j(u)=e^{-u²/2w²}e^{iν_j u}`, `w=1/2`, centers `ν∈{10,14,18,22,26,30,34}`.

## What was established

**1. Harness is correct (24-digit validation).** The geometric side
`pole + arch − prime` matches the zero-side sum `Σ_ρ h(γ_ρ)` over the first 80
Riemann zeros to a relative error `~1×10⁻²⁴` on every tested matrix entry. The
Riemann–Weil formula, signs and constants are right; nothing below depends on a
memorized constant.

```
(1,1)  reldiff 6.0e-24     (3,3)  reldiff 1.3e-24     (5,5)  reldiff 1.3e-25
```

**2. Genuine ζ → PSD (the non-tautological core).** Built purely from primes +
Γ-term + pole, the 7×7 Weil form has eigenvalues

```
{1.5e-25, 1.0e-6, 0.673, 0.899, 1.615, 1.897, 2.341}     (all ≥ 0)
```

No negative eigenvalue. ζ passes Weil positivity on this test space. *(The
smallest eigenvalue being ~0 is most likely finite-basis near-degeneracy — the
highest-frequency basis combination is barely excited by the in-range zeros — not
a deep "ζ sits exactly on the positivity boundary." The load-bearing fact is the
**absence of a negative eigenvalue**, computed from arithmetic data alone.)*

**3. Off-line FE-quartet → indefinite, monotone in distance off the line.** Add a
symmetric quartet of zeros at ordinates `±γ₀ ± i(σ₀−1/2)` (the planted
RH-violation) and recompute the smallest eigenvalue (`γ₀=14`, exact arithmetic):

| `δ = σ₀ − 1/2` | minEig | verdict |
|---|---|---|
| 0      | `+4.68e-7` | PSD (on the line) |
| 0.025  | `+1.08e-7` | PSD |
| **0.05** | **`−2.16e-6`** | **INDEFINITE** |
| 0.10   | `−4.40e-4` | INDEFINITE |
| 0.20   | `−3.65e-3` | INDEFINITE |
| 0.40   | `−1.64e-2` | INDEFINITE |

The on-line configuration is strictly PSD; the form crosses into indefinite at a
**finite threshold** `δ* ≈ 0.035` and the deficit grows monotonically with `δ`.

**4. The deficit scales as `δ²` to leading order.**
`(minEig − minEig₀)/δ² → −4.9×10⁻⁴` (constant as `δ→0`):

```
δ=0.005: -4.87e-4    δ=0.01: -4.97e-4    δ=0.02: -5.40e-4    δ=0.04: -7.73e-4
```

This is **consistent with** the Cassini-discriminant law `det Q = −sinh²(σ−1/2)
≈ −δ²` from README §3. **Honest caveat:** a `δ²` leading term is *generic* — for
any analytic `h`, `h(γ₀+iδ)+h(γ₀−iδ) = 2h(γ₀) − h''(γ₀)δ² + O(δ⁴)`, so the
leading `δ²` follows from analyticity + first-order perturbation theory and does
**not** uniquely single out `sinh²`. The growth of the ratio with `δ` is
consistent with the higher-order `sinh²` terms but is entangled with the
eigenvalue's own `δ⁴` corrections; we do **not** claim `sinh²` is confirmed
beyond its leading term.

## Verdict, honestly scoped

- ✅ The lens's **necessary condition holds**: positivity of the geometric-side
  Weil form ↔ on-the-line spectrum; indefiniteness ↔ off-line. The mechanism
  ("off-line FE-pair = hyperbolic = indefinite Cassini/Weil form") is verified.
- ✅ A **finite-resolution detection threshold** `δ*` emerged unbidden: with a
  finite test space, a zero must be a *finite* distance off the line to flip the
  signature. This is a concrete, empirical bridge to **H1** (is the line's
  rigidity resolution-limited, and at what κ?). `δ*` should shrink as the test
  space / band grows — that is the H1 experiment.
- ⚠️ **What this is NOT yet.** The off-line zeros here are **planted** (a
  controlled quartet), not **emergent** from arithmetic. So this is the
  *mechanism* gate, not proof that the signature detects an *arithmetic* RH
  violation. The honest next step is **Davenport–Heilbronn** (a real Dirichlet
  series, FE but no Euler product, with off-line zeros that arise from the
  coefficients — never planted). The harness is ready; the DH archimedean factor
  (χ odd mod 5, conductor 5) and the FE-determined constant κ are the only new
  pieces, and κ will be fixed by *imposing* the FE numerically (self-validating,
  no memorized value).

## Why this is not circular

The decisive, non-tautological fact is item **2**: ζ's Weil form, assembled from
**primes and the Γ-factor only**, with the zeros never consulted, comes out
positive semidefinite — and the 24-digit identity (item 1) proves that assembly
*is* the true `Σ_ρ h(γ_ρ)`. The planted-quartet control (item 3) is a
sensitivity/mechanism check, not a self-fulfilling test; its job is to show the
signature *responds* to off-line mass in the predicted sign and scaling. The
emergent (DH) test is what upgrades "mechanism verified" to "arithmetic RH
violation detected."
