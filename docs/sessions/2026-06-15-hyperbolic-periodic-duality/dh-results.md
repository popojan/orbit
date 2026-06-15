# DH emergent gate — results

**Date:** 2026-06-15
**Status:** ✅ EMERGENT GATE PASSED (the lens detects an arithmetic RH violation)
**Scripts:** [`scripts/exp0b-dh-setup.wl`](scripts/exp0b-dh-setup.wl),
[`exp0b-dh-search.wl`](scripts/exp0b-dh-search.wl),
[`exp0c-dh-weil.wl`](scripts/exp0c-dh-weil.wl),
[`exp0d-dh-detect.wl`](scripts/exp0d-dh-detect.wl),
[`exp0e-dh-sweep.wl`](scripts/exp0e-dh-sweep.wl)

Upgrades [`exp0-results.md`](exp0-results.md) from the *mechanism* gate (planted
quartet) to the *emergent* gate: a real arithmetic object — the
Davenport–Heilbronn function (functional equation, **no Euler product**) — has
zeros off the critical line, and the Weil/Cassini positivity form built from its
**arithmetic data alone** (the `−f'/f` coefficients `Λ_f` + the archimedean term,
zeros never consulted) goes strongly indefinite precisely at those off-line
heights.

## 1. The function, self-validated (no memorized constants)

`χ` = primitive character mod 5 with `χ(2)=i` (order 4, odd). The DH function in
Hurwitz form (bypasses character indexing):

```
f(s) = 5^{-s}[ ζ_H(s,1/5) + κ ζ_H(s,2/5) − κ ζ_H(s,3/5) − ζ_H(s,4/5) ],
```

coefficients `c(n)` periodic mod 5 = `[1, κ, −κ, −1, 0]`. The self-dual constant
`κ` is **derived** from the Gauss sum (`κ = tan(arg ε /2)`, `ε = τ(χ)/(i√5)`):

```
κ = 0.28407904384041229602829183239312616909
closed form (√(10−2√5)−2)/(√5−1) = 0.28407904384041229602829183239312616909   ✓ (20 digits)
```

Functional equation `Φ(s)=Φ(1−s)`, `Φ(s)=(5/π)^{(s+1)/2}Γ((s+1)/2)f(s)`, verified
directly: `|Φ(s)−Φ(1−s)| ~ 10⁻¹⁵…10⁻²³` at five test points.

## 2. Off-line zeros found directly (the RH violation)

By 2-D root search (`Re f = Im f = 0`), refined to 28-digit `|f|`:

| zero `s = σ + i t` | `δ = σ − 1/2` |
|---|---|
| `0.80851718245663739 + 85.69934848537759 i` | **0.3085** |
| `0.65083008060973708 + 114.16334273075698 i` | **0.1508** |
| `0.34916991939026292 + 114.16334273075698 i` | **−0.1508** (FE partner of the above) |

The pair at `t=114.163` is exactly an FE `σ↔1−σ` quartet `±γ₀ ± iδ` off the line —
the same shape as Exp 0's planted quartet, now arithmetic, not planted.

## 3. Arithmetic-side Weil machinery, validated to 25 digits

`Λ_f(n)` from `−f'/f = Σ Λ_f(n) n^{-s}` via `c(n)log n = Σ_{d|n} Λ_f(d) c(n/d)`;
archimedean term `(1/2π)∫ h[Re ψ(3/4+ir/2) + log(5/π)] dr` (conductor 5, odd Γ).
At a low-`t` basis (centers `{12,14,16,18}`), where all DH zeros are on the line
and enumerable, the arithmetic side matches the zero side to `reldiff ~10⁻²⁵` —
`Λ_f`, the archimedean constant `log(5/π)`, and all signs are correct.

## 4. Detection is resolution-gated (band-saturation in the positivity channel)

The decisive finding, in two steps:

**Coarse resolution → no detection.** With the Exp-0 basis (`w=1/2`, std in `r`
≈ 2, coarser than the on-line zero spacing ≈ 0.85 at `t≈114`), the arithmetic-side
form near `t=114` is **PSD** (`min eig = +7.5×10⁻⁵`). The off-line zero is in the
*null space* of the coarse band — its effect is amplified only by
`exp(w²δ²) ≈ 1.006`. This is band-saturation, in the positivity channel.

**Finer resolution → strong detection, δ-ordered.** Sweeping the min-eigenvalue
of the arithmetic-side Weil form versus the basis center `t` (basis `w=3/2`,
5 functions, spacing 0.4; `exp0e`):

| center `t` | `δ` there | min eig |
|---|---|---|
| on-line stretch `[42, 80]` | 0 | `~ −10⁻³` (basis/trunc noise band) |
| **85–86** (zero at 85.699) | 0.31 | **−3.9 … −6.4** |
| **113–116** (pair at 114.163) | 0.15 | **−1.1** |

The off-line zeros appear as **localized negative spikes 100–600× above the
on-line noise band**, at exactly the heights found independently in §2, and
**ordered by `δ`** (the larger displacement `δ=0.31` gives the larger spike). A
tightly-localized basis (`exp0d`, `w=2.2`) drives the spikes to `−2.4` (`t=114`)
and `−14.8` (`t=85.7`).

## 5. Verdict

- ✅ **Emergent gate passed.** The orbit–Cassini = Weil positivity form, computed
  from DH's arithmetic alone, is indefinite exactly where DH's off-line zeros
  are. The lens detects a genuine, non-planted RH violation. Combined with Exp 0
  (genuine ζ → PSD) the signature **separates ζ from DH**.
- ✅ **Resolution threshold is real and central.** Detection switches on only
  above a resolution finer than the off-line displacement `δ` — coarse bands see
  PSD, fine bands see the violation. This is the same band-saturation wall the
  `zzz` project found in the *resolution* channel, now exhibited in the
  *positivity* channel. It is the concrete empirical hook for **H1**: measure the
  critical `κ` at which σ-pinning / positivity-rigidity switches on, and compare
  it to the `κ=π` onset of level repulsion.
- ⚠️ **Honest numerical caveats.** The on-line baseline in the sweep is not
  exactly PSD (`~ −10⁻³`): residual from a moderately-conditioned (overlapping)
  basis plus prime-sum truncation at `N=4000` and 30-digit solves — *numerical*,
  not a positivity violation, and 100–600× below the off-line signal. A
  better-conditioned basis + higher precision would clean it but does not change
  the conclusion. The `δ²` leading scaling of the deficit (Exp 0 §4) remains
  generic-analytic, not a unique confirmation of `sinh²`.
