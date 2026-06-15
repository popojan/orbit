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
