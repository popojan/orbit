# H1 first cut — resolution-gating of positivity on the genuine ζ spectrum

**Date:** 2026-06-15
**Status:** 🔬 FIRST CUT — resolution-gating confirmed; onset at ~Nyquist (κ~π
scale); "positivity beats resolution" NOT observed; definitive rigidity verdict
needs the along-line companion.
**Script:** [`scripts/h1-detection-threshold.wl`](scripts/h1-detection-threshold.wl)

H1 (README §6) asks: *is the critical line (a positivity property) more rigid
than the individual zero positions (a resolution property), and does σ-rigidity
switch on at the same κ=π as level repulsion?* This first cut measures, on the
**true ζ spectrum** near `T=100` (mean gap ≈ 2.27), the smallest off-line
displacement `δ*` of a planted FE quartet that the band-limited Weil form can
detect (turn indefinite), as a function of test-function resolution `w`.

## Data

Baseline = true ζ zeros (`γ∈[76,124]`), exact PSD Gram form; planted quartet at
`γ₀=100`, displacement `δ`. `δ*` = first `δ` (grid `{.01,.02,.03,.05,.08,.12,.2,.3,.4}`)
with `min eig < 0`.

| `w` | r-resolution `1/w` | κ-proxy `gap·2w` | `δ*` |
|---|---|---|---|
| 0.4 | 2.50 | 1.82 | **none ≤ 0.4** (blind) |
| 0.6 | 1.67 | 2.72 | **none ≤ 0.4** (blind) |
| 0.9 | 1.11 | 4.09 | 0.40 |
| 1.3 | 0.77 | 5.90 | 0.05 |
| 1.8 | 0.56 | 8.17 | 0.01 |
| 2.5 | 0.40 | 11.35 | 0.01 (grid floor) |
| 3.5 | 0.29 | 15.89 | 0.01 (grid floor) |

## What is robust

- **Total positivity-blindness below ~Nyquist.** For `1/w ≳ gap` (`w ≤ 0.6`,
  κ-proxy ≲ 2.7) the form does **not** detect an off-line zero at *any*
  displacement up to `δ=0.4`. Off-line violations live in the null space of a
  sub-Nyquist band — **band-saturation, in the positivity channel.**
- **Onset at ~Nyquist, then rapid sharpening.** Detection switches on between
  `w=0.6` and `w=0.9` (`1/w` between 1.67 and 1.11, vs `gap=2.27`), i.e. when the
  r-resolution reaches roughly the mean spacing; `δ*` then collapses
  `0.4 → 0.05 → 0.01` as `w` grows. The onset straddles `κ-proxy ≈ π`.
- **Same Nyquist wall as zzz.** The condition "r-resolution ≈ mean gap" *is* the
  condition defining `κ=π` (gap = band-limited kernel width). So the positivity
  /σ-detection onset and the `zzz` level-repulsion onset are the **same Nyquist
  resolution threshold** — the session's two dualities (positivity, resolution)
  meeting at one wall.

## What is NOT claimed (honest limits)

- **No "κ_c = π" to the decimal.** The κ-proxy `gap·2w` carries an arbitrary
  order-1 constant (the Gaussian `e^{-1}` width gives the "2"). Different
  conventions move the numerical onset within `[~1.4w, ~3w]·gap`. The robust
  statement is *onset-at-Nyquist*, not a decimal coincidence with π.
- **"Positivity beats resolution" was NOT observed.** The exciting H1 outcome
  (σ-pinning onset at κ *below* π — the band knowing the line even when it can't
  locate zeros) did not appear: the form is blind below Nyquist. The data support
  the **"one wall"** outcome — positivity onsets *at* the resolution wall, not
  before it, and not decoratively after.
- **Conditioning confound.** Above onset, the exact `δ*` is partly set by the
  basis's smallest-eigenvalue cushion (the baseline `min eig` is non-monotonic in
  `w`: 2e-5, 1e-3, 2e-2, 3e-3, 8e-6, …, reflecting basis collinearity, not
  physics). So the precise `δ*(w)` curve above threshold is not clean; only the
  below-Nyquist blindness and the onset location are robust.

## Verdict and the definitive next measurement

H1 first cut: **the line's positivity-rigidity is resolution-gated and switches
on at the Nyquist/κ~π wall — one wall, not "positivity beats resolution."** This
already unifies the positivity lens with band-saturation: the off-line (σ) channel
saturates at the same resolution as the position (γ) channel does in `zzz`.

The sharp "**is the line more rigid than its zeros?**" verdict needs an
apples-to-apples companion in the same harness: the **along-line detection
threshold** `ε*(w)` (smallest *on-line* displacement of a zero the form notices)
versus the off-line `δ*(w)`. If `δ* < ε*` the line is more rigid (positivity
gives extra detection power); if `δ* ≈ ε*`, one wall confirmed; if `δ* > ε*`, the
line is less rigid. Plus a conditioning-controlled basis (orthogonalized, fixed
condition number across `w`) to remove the cushion confound. That is the clean
H1.2 experiment.

---

## H1.2 — the two channels' scaling (definitive)

**Script:** [`scripts/h1b-channel-scaling.wl`](scripts/h1b-channel-scaling.wl).
**Status:** ✅ — clean verdict, no conditioning confound (a response norm, not a
sign).

Apples-to-apples: the response `‖ΔM‖_F` of the Weil/Gram form to a displacement
`d` of a conjugate zero-pair, **along the line** (`±γ₀ → ±(γ₀+d)`) versus **off
the line** (the FE+conj quartet `±γ₀ ± i d` vs its `d→0` limit), at `γ₀=100`.

| channel | `‖ΔM‖_F` vs `d` | fitted slope (w=1) | (w=2) |
|---|---|---|---|
| along-line (γ / position) | `∝ d` | **0.99998** | **1.0011** |
| off-line (σ / the line) | `∝ d²` | **2.00008** | **2.0004** |

Exponents 1 and 2 to 4 significant figures, at both resolutions.

**Verdict.** The σ-channel (off-line / positivity) is **intrinsically
second-order** — quadratically suppressed for small displacement — while the
γ-channel (along-line / position) is **first-order**. Consequences:

- The line is **NOT "more rigid"** than its zeros. The opposite: off-line
  violations are *harder* to detect (extra factor `d`), which is exactly why H1
  found off-line detection onset only *at/above* Nyquist while position
  information is available first-order.
- **"Positivity beats resolution" (the exciting κ<π outcome) is definitively
  dead**: a quadratic channel cannot out-detect a linear one. **"One wall"
  stands**, refined: the σ-channel switches on at the *same* Nyquist wall but is
  one order weaker, so it onsets at/above it, never below.
- The relative response `R_off/R_on ∝ d` grows with resolution (at `w=2` it
  reaches 0.6 by `d=0.08`, vs 0.14 at `w=1`): finer bands help the σ-channel
  more — consistent with the resolution-gating of H1.

**Cassini connection, honestly.** The off-line channel's `d²` *is* the
`det Q = −sinh²(σ−1/2) ≈ −δ²` parabolic vanishing — the periodic/hyperbolic
boundary is a quadratic (parabolic) minimum, and that quadratic-ness is what
makes the σ-channel weak. But the `d²` follows from analyticity alone (the
quartet is even in `d`); the Cassini law **correctly describes** the parabolic
boundary but does **not uniquely predict** it. Descriptive, not load-bearing —
see the note in README §7.
