# Zeta-zero counting as a sum of smoothed ceilings

**Date:** 2026-07-09
**Follow-up to:** [2026-07-06-rank-variance-denominators](../2026-07-06-rank-variance-denominators/README.md)
§8.9–8.10 (the Abel/Poisson smoothed ceiling `ceilSmooth`, and the *rejected* zzz bridge §8.10.1) and
[2026-06-28 the snap-to-ℤ atom](../2026-06-28-cyclotomic-residue-ap-kernels/the-snap-to-Z-atom.md).

**One-line result:** the truncated Riemann–von Mangoldt zero counter
`zetaZeroCount = nt7 + Σ_p waveXX[t, p, 1/√p]` is *exactly* a sum of Abel-smoothed ceiling
staircases — one per prime, at frequency `ln p/2π`, with hardness dial `r = 1/√p` strictly
below the sharp value `r = 1` — plus a linear term whose slope is `log(primorial)/2π`
(Chebyshev `θ`). The sharp ceiling atom (`ceilBook`) is the `r = 1` member of the same family
and is never attained at any finite prime; the integrality of `N(t)` is emergent in the
infinite sum only. §6 answers the converse question — *unsmoothing* to `r = 1` snaps each
prime onto its own local-factor lattice on `σ = 0` and collapses the counter into
`√m`-growing noise: the blur `r = p^{-1/2}` is load-bearing, being the critical-line
coordinate itself.

All identities ✅ PROVEN (symbolic, `Simplify → 0`); numerics 🔬 VERIFIED against
`ZetaZero[k]`, `k ≤ 300`. **No new accuracy is claimed** — the prime correction is the
textbook explicit-formula channel for `S(t)`, the same channel the §8.10.1 gate check
already validated (and distinguished from the *rejected* `ceilSmooth∘nt7` wrapper).

---

## 1. Warm-up: the maximum of the single-prime wave, symbolically

The session started as a Mathematica technique question: `Maximize` chokes on

```mathematica
waveX[p_, t_] := -(I/Pi) Log[1 - p^(-(1/2) + I t)] // Re
```

because `Re[Log[...]]` has no clean symbolic derivative. **The fix is that `Re` is not
needed at all:** from `Log[w] = Log[Abs[w]] + I Arg[w]`,

$$-\frac{i}{\pi}\log(1-z)\;\xrightarrow{\ \mathrm{Re}\ }\;\frac1\pi\operatorname{Arg}(1-z),$$

and with `z = p^{-1/2}e^{it\ln p}` we have `Re(1 - z) ≥ 1 - p^{-1/2} > 0`, so `Arg` stays on
the principal branch and is real-analytic. Converting `Arg` to the two-argument
`ArcTan[Re, Im]` form makes `D` + `Solve` work normally:

```mathematica
waveX[p_, t_] := ArcTan[1 - p^(-1/2) Cos[t Log[p]], -p^(-1/2) Sin[t Log[p]]]/Pi
```

**Result** (✅ symbolic via `Solve`, 🔬 cross-checked against `NMaximize` at `p = 2, 3, 7, 50`):
period `T = 2π/ln p`, and

$$\max_t \text{waveX}(p,t) = \frac{\arcsin(p^{-1/2})}{\pi}
\qquad\text{at}\qquad
t^* \equiv -\frac{\arccos(p^{-1/2})}{\ln p} \pmod{\tfrac{2\pi}{\ln p}}.$$

**Geometry:** as `t` varies, `1 - z` traces the circle of radius `r = p^{-1/2}` centered at
`1`; the extreme arguments seen from the origin are the two tangent lines to that circle —
"tangent from an external point", angle `±arcsin(r/1)`. The critical-point equation
`cos θ = r` returned by `Solve` is the tangency condition.

Script: [`scripts/01-wavex-max.wl`](scripts/01-wavex-max.wl).

## 2. `waveXX`: same object, modulus and frequency decoupled

```mathematica
waveXX[x_, p_, r_] := 1/Pi ArcCot[Cot[x Log[p]] - Csc[x Log[p]]/r]
```

The identity `cot θ − csc θ/r = (r cos θ − 1)/(r sin θ)` collapses this to the same
"argument of `1 − z`" object:

$$\text{waveXX}(x,p,r) = \frac1\pi\operatorname{Arg}\!\big(1 - r\,e^{ix\ln p}\big),$$

now with modulus `r` and phase-rate `ln p` **independent** (in `waveX` they are locked:
`r = p^{-1/2}`). Hence `max = arcsin(r)/π` at `x* = −arccos(r)/ln p` (mod period), `0 < r < 1`.

**Alignment question (answered):** the argmax location depends on `r` only through
`arccos(r)` (injective), so `waveXX`'s maximum aligns with `waveX`'s **iff `r = 1/√p`** —
unique, no freedom; a positive multiplicative constant never moves an argmax. Stronger:
with `r = 1/√p` the two functions are *identical for all* `x`:
`waveXX[x, p, 1/√p] ≡ waveX[p, x]` (🔬 numeric, several `p`, random `x`).

Script: [`scripts/02-wavexx-max-alignment.wl`](scripts/02-wavexx-max-alignment.wl)
(note: script 02 uses the un-normalized `ArcCot` form, max `= arcsin r`; the `1/π`
normalization used everywhere else divides through).

## 3. One arctan resums the whole prime-power tower

Expanding `Arg(1 − re^{iθ}) = −Σ_{j≥1} r^j sin(jθ)/j` with `r = p^{-1/2}`, `θ = t ln p`:

$$\text{waveXX}\big(t,p,\tfrac1{\sqrt p}\big)
= -\frac1\pi\sum_{j\ge1}\frac{\Lambda(p^j)}{\ln p^j}\cdot\frac{\sin(t\ln p^j)}{p^{j/2}}$$

— the **entire `Λ`-weighted contribution of `p` and all its powers** to the explicit
formula for `S(t)`, resummed in closed form (🔬 verified against the truncated series to
`10^{-11}`). So `zetaZeroCount` truncates the explicit formula *by prime, keeping full
towers* — a different truncation shape than the previous session's `sPrimes[t, X]`
(all `n ≤ X`), with the same asymptotic floor (towers `j ≥ 2` are tiny):

```mathematica
nt7[t_] := t/(2 Pi) Log[t/(2 Pi E)] + 7/8;
zetaZeroCount[t_, m_] := nt7[t] + Sum[waveXX[t, Prime[k], 1/Sqrt[Prime[k]]], {k, 1, m}];
```

🔬 Against true zeros (`k ≤ 300`, target `k − 1/2` at `t = γ_k`; hypothesis stated before
running: RMS shrinks with `m`, never reaches 0 at finite truncation):

| `m` (primes) | up to `p_m` | RMS | max abs err | `Ceiling` successes |
|---|---|---|---|---|
| 0 (`nt7` alone) | – | 0.239 | 0.645 | 293/300 |
| 5 | 11 | 0.089 | 0.338 | 300/300 |
| 20 | 71 | 0.068 | 0.182 | 300/300 |
| 50 | 229 | 0.054 | 0.160 | 300/300 |
| 100 | 541 | 0.050 | 0.151 | 300/300 |
| 168 | 997 | **0.047** | 0.127 | 300/300 |

Cross-check with the 2026-07-06 gate check (same `γ_k`, `k ≤ 300`): `sPrimes` at `X = 1000`
gave RMS `0.045` — the tower-complete truncation at `p ≤ 997` lands at `0.047`.
**Same channel, same floor; the towers buy tidiness, not accuracy.**

Script: [`scripts/03-zeta-count-tower-resummation.wl`](scripts/03-zeta-count-tower-resummation.wl).

## 4. The requested rewrite: `zetaZeroCount` in `ceilSmoothS` form

The smoothed ceiling from §8.9 of the previous session (sign variant):

```mathematica
ceilSmoothS[x_, r_] := 1/2 + x - ArcCot[Cot[2 Pi x] - Csc[2 Pi x]/r]/Pi
```

Substituting `2πx = t ln p` gives the exact reparametrization (✅ `Simplify → 0`):

$$\text{waveXX}(t,p,r) = \frac{t\ln p}{2\pi} + \frac12 - \text{ceilSmoothS}\!\Big[\frac{t\ln p}{2\pi},\,r\Big],$$

and summing over the first `m` primes, with `θ(p_m) = Σ_{k≤m} ln p_k = log(p_m\#)`
(Chebyshev theta = log primorial):

```mathematica
zetaZeroCountS[t_, m_] := nt7[t] + m/2 + t Sum[Log[Prime[k]], {k, 1, m}]/(2 Pi) -
   Sum[ceilSmoothS[t Log[Prime[k]]/(2 Pi), 1/Sqrt[Prime[k]]], {k, 1, m}];
```

$$\boxed{\;\text{zetaZeroCount}(t,m) \;=\; nt_7(t) \;+\; \frac m2 \;+\; \frac{\theta(p_m)}{2\pi}\,t
\;-\; \sum_{k=1}^{m}\text{ceilSmoothS}\!\Big[\frac{t\ln p_k}{2\pi},\,\frac1{\sqrt{p_k}}\Big]\;}$$

✅ symbolic identity; 🔬 both forms agree to `6×10^{-12}` on random `(t, m)`. Reading: the
prime correction is a superposition of **smoothed sawtooths** (linear ramp minus smoothed
ceiling), one per prime, amplitude `arcsin(1/√p_k)/π` (§1–2), riser/tread slopes
`(1+r)/(1−r)` and `(1−r)/(1+r)` from §8.9 with `r = 1/√p_k`. The primorial slope
`θ(p_m)/2π` is exactly the sum of the ramps — the same Chebyshev `θ` whose `√x` Eudoxus
defect the snap-to-ℤ document identifies as the obstruction to elementary rounding room.

Script: [`scripts/04-zeta-count-ceiling-form.wl`](scripts/04-zeta-count-ceiling-form.wl).

### 4.1 The two pieces separately (Jan's questions)

**Is the linear term `t·θ(p_m)/2π` standard?** Yes — it is the Riemann–von Mangoldt main
term *of the truncated Euler product itself*. `Π_{k≤m}(1 − p_k^{-s})` vanishes exactly on
the line `σ = 0`, at the AP union `t ∈ ∪_k (2π/ln p_k)ℤ` (§6), so its zero count in
`(0, T]` is `Σ_k ⌊T ln p_k/2π⌋ = T·θ(p_m)/2π + O(m)` (🔬 verified; deviation bounded by
`m`). Equivalently, expanded as the Dirichlet polynomial `Σ_{d | p_m#} μ(d) d^{-s}`, its
top frequency is the **primorial**, and `(T/2π)·log(top frequency)` is the standard
zero-counting law for Dirichlet polynomials (Bohr/Jessen–Tornehave mean-motion territory —
attribution recalled from general knowledge, not re-verified). Two exact consequences
(✅ symbolic):

- `nt7'(t) = log(t/2π)/2π`, so the truncated counter's constant zero-density
  `θ(p_m)/2π` equals ζ's local zero density **exactly at `t = 2π·p_m#`** — the smooth
  staircase of the first `m` primes runs at ζ's pace precisely at 2π × primorial
  (`t* ≈ 188.5, 14514, 6.1×10⁷` for `m = 3, 5, 8`).
- Via `θ(x) ~ x` this is the familiar "primes up to `log T` model the zeros at height `T`"
  crossover of the hybrid Euler–Hadamard product literature (Gonek–Hughes–Keating;
  attribution recalled, not re-verified).

**Why does the bare ceiling sum look discontinuous?** It isn't — ✅ provably real-analytic
in `t`. The `ArcCot[Cot − Csc/r]` *representation* is `Indeterminate` at every half-period
point `x = k/2` (i.e. `t ln p ∈ πℤ`: both `Cot` and `Csc` pole there), and plotting it makes
`Plot` drop failed samples / auto-exclude the `Cot`/`Csc` poles — visual breaks twice per
period per prime, at the riser midpoints *and* tread midpoints. Both are removable
(side limits agree, ✅), and the `ArcCot` argument never crosses `0` for `r < 1`
(`Reduce → False`), so there is no genuine branch jump anywhere. For plotting, use the
pole-free §8.9 form — identical function (✅ piecewise symbolic + sweep to `9×10^{-16}`;
`ceilSmoothS` *is* §8.9's `ceilSmooth` in `ArcCot` clothing):

```mathematica
ceilSmooth[x_, r_] := x + 1/2 + ArcTan[r Sin[2 Pi x]/(1 - r Cos[2 Pi x])]/Pi
(* denominator 1 - r Cos[2 Pi x] >= 1 - r > 0: no poles, no exclusions, plots cleanly *)
```

Script: [`scripts/07-linear-term-and-plotting-form.wl`](scripts/07-linear-term-and-plotting-form.wl).

### 4.2 Ramp vs staircase — and ζ itself from a complexified ceiling (Jan's questions)

**The decomposition reading (confirmed).** Writing the counter as `nt7[t] +` the difference
of `A = t·θ(p_m)/2π` (ramp) and `B = −m/2 + Σ_k ceilSmooth[t ln p_k/2π, 1/√p_k]`: each
`ceilSmooth[x, r] = x + 1/2 + (mean-zero periodic wobble)`, so the `−m/2` exactly cancels
the `m` half-unit offsets and `B` oscillates *around* `A` with time-average zero. The
difference is exactly the prime sum of §3: `A − B = Σ_k waveXX[t, p_k, 1/√p_k]` — the
truncated `S(t)`. So yes: the oscillation of the staircase sum around its own ramp **is the
fluctuation half of the counting** — the part that localizes individual zeros (nudging the
value across half-integers at the right places); the *bulk* of the count (average density)
is carried by `nt7`, and the shared ramp cancels out of the difference entirely.

**ζ itself in ceiling terms — complexify.** The smoothed ceiling carries only the *phase*
half of each Euler factor. Its harmonic-conjugate completion
([`scripts/08`](scripts/08-zeta-from-complex-ceiling.wl), all ✅/🔬):

```mathematica
ceilC[x_, r_] := x + 1/2 + (I/Pi) Log[1 - r Exp[2 Pi I x]]
```

- `Re ceilC = ceilSmooth` (✅ sweep to `4×10^{-16}`; `Arg → ArcTan` valid since
  `Re(1−re^{2πix}) ≥ 1−r > 0`); `Im ceilC = (1/π) ln|1−re^{2πix}|` (✅ symbolic) — the
  modulus half. Its `r → 1` limit is `(1/π) log(2 sin πx)` (✅): the sharp partner of
  `ceilBook`'s staircase is the **log-sin kernel**, with `−∞` spikes on the same lattice
  where the staircase jumps — at `σ = 0` the phase crystallizes into unit steps *and* the
  modulus develops logarithmic zeros, both at the local factor's zero lattice.
- Derivative pair (✅): `d/dx Re ceilC = P_r(2πx)` (Poisson kernel, §8.9) and
  `d/dx Im ceilC = Q_r(2πx) = 2r sin(2πx)/(1−2r\cos 2πx+r²)` (conjugate Poisson kernel).
- **The modulus half is the `r`-ray integral of the phase half's slope** (✅ symbolic +
  numeric): `ln|1−r₀e^{iθ}| = −∫_0^{r₀} (P_r(θ)−1)\,dr/(2r)`, i.e. Cauchy–Riemann in
  `(σ, t)` = (log-radial, angular) coordinates per prime circle (✅ `D[u,σ] = D[v,t]`).
  So "varying `r`" is not a spare knob to project in — the `r`-ray of the ceiling family
  *already is* the missing modulus information.

Then, in the Euler-product regime `σ > 1`, **all of ζ**, with `x_p = t\ln p/2π`,
`r_p = p^{-σ}`:

$$\log\zeta(\sigma+it) \;=\; -\,i\pi\sum_p \overline{\big(\text{ceilC}[x_p,\,r_p] - x_p - \tfrac12\big)}$$

🔬 verified against `Log[Zeta[σ+It]]`: `2×10^{-6}` at `σ = 2`, `1×10^{-4}` at `σ = 3/2`
(both tail-limited, `p ≤ 4000`). Real part: `ln|ζ| = −π Σ_p Im ceilC`; imaginary part:
`arg ζ = π Σ_p (x_p + 1/2 − ceilSmooth)` — §4's counter.

#### 4.2.1 Truncation error of the ceiling/Euler form: controlled by σ, not by t

Jan's follow-up: *10 primes give almost exact ζ at low heights — does the truncation error
amplify as `t` rises?* **No** — and the fast convergence is not ζ-magic but the absolute
convergence of the Euler product at `σ > 1`
([`scripts/09`](scripts/09-truncation-error-in-t.wl), hypotheses stated first):

- **Flat in `t`.** The error is the tail `−Σ_{p>p_m} Log(1−p^{-s})`; its worst case
  `Σ_{p>p_m} p^{-σ}` is `t`-independent (raising `t` only rotates phases, never grows them),
  and its typical size is the RMS `√(Σ_{p>p_m} p^{-2σ})` (decorrelated phases). 🔬 At
  `σ = 2`, `m = 10` (`p ≤ 29`): bound `0.0072`, RMS `0.0017`, measured `|err|` from `t = 10`
  to `t = 10⁶`: `0.0006–0.0018` — no trend across five decades.
- **Grows as `σ ↓ 1`** at fixed `m` (`0.0007 → 0.046` from `σ = 2` to `1.05` at `t = 13.7`),
  diverging at `σ = 1`. Bonus: at `σ = 1.05` the error at `t = 10⁴` is 10× *smaller* than at
  `t = 13.7` — low heights are the coherent-phase worst case; height *helps* via
  decorrelation.
- **Scope boundary, for contrast (not a caveat — the formula was stated for `σ > 1`).**
  If one asks the separate question "does this reach the zeros?": a finite partial Euler
  product never vanishes (finite product of nonzero factors), so at `σ = 1/2` no truncation
  reproduces a zero: 🔬 `|Π_{p≤29}(1−p^{-1/2-iγ_k})^{-1}| = 0.13, 0.28, 0.69` at
  `γ_1, γ_{10}, γ_{50}` while `|ζ| = 0` there. Same emergence theme as §5–§6: the zeros
  (like the integrality of `N(t)`) exist only in the `m → ∞` collective limit.

So within its stated regime the property is unqualified: a fixed 10-prime ceiling
expression approximates `log ζ` to `~10^{-3}` **uniformly on the whole half-plane
`σ ≥ 2`**, all heights at once — the classical Bohr almost-periodicity of Dirichlet
series in vertical half-planes of absolute convergence (attribution recalled, standard).
The critical strip is a different regime, not a defect of this one.

#### 4.2.2 On the critical line, between the zeros: the truncated sum is the smooth carrier

Jan plotted `logZeta[1/2, t, 11]` against `Log[Zeta[1/2 + I t]]` on `t ∈ (10, 30)` and
challenged the "cannot see the zeros" emphasis: the truncated curve "looks cleaner than
standard zeta log (smoothed)" — and that reading is **correct**
([`scripts/10`](scripts/10-critical-line-between-zeros.wl), hypotheses first, all 🔬):

- **Between zeros it genuinely tracks:** on a 400-point grid over `(10, 30)` at `m = 11`,
  median `|Re diff| = 0.16`, median `|Im diff| = 0.17` (90th pct `≈ 0.44/0.49`); at the
  inter-zero midpoints `|diff| = 0.15, 0.26, 0.14`. Branch-safe on the window (0 wraps).
- **At the zeros the Re-difference log-diverges:** `|Re diff| = 0.56, 2.8, 5.1` at offsets
  `0.1, 0.01, 0.001` from `γ_1, γ_2, γ_3` — increments of `ln 10 ≈ 2.3` per decade, i.e.
  exactly `−log|t−γ| + O(1)`. This is the part no truncation fixes.
- **More primes barely help between zeros:** `m = 11 → 100` (9× primes) improves the
  medians only `0.164 → 0.133` (~20%) — the series does not converge at `σ = 1/2`;
  Selberg-slow saturation, same as §3's RMS floor.

This is the hybrid Euler–Hadamard decomposition made visible (`ζ ≈ P_X · Z_X`,
Gonek–Hughes–Keating; attribution recalled, standard): the truncated ceiling sum *is*
`log P_X`, the smooth almost-periodic carrier; `log ζ` equals it plus the zero-local
spikes (`log Z_X`). The Im half of the missing spike part is precisely the `S(t)` jump
content the §3 counter chases. So the honest split of "how far off at `σ = 1/2`": ~0.16
typical between zeros (good smooth proxy), `∞` at the zeros (in Re), and the gap between
those two statements is exactly where the zeros live.

#### 4.2.3 The necklace ladder: exact sharpening of one smooth wave

Jan noticed `(1/√p)(FractionalPart[x_p(−t)] + 1/2)` closely shadows the smooth wave and
asked whether a tweak could make the sharp `FractionalPart` copy it exactly — suspecting
it impossible since "every FractionalPart's scale is different". Both halves resolve
exactly ([`scripts/11`](scripts/11-necklace-ladder.wl)):

**The tweak exists and is classical.** The cyclotomic identity
`1 − rz = Π_{k≥1}(1 − z^k)^{M_k(r)}` (Metropolis–Rota necklace algebra; attribution
recalled, standard), with the **necklace polynomials** `M_k(r) = (1/k)Σ_{d|k} μ(k/d) r^d`,
gives on `|z| = 1`:

$$\text{waveXX}(t,p,r) \;=\; \sum_{k\ge1} M_k(r)\cdot\Big(\Big\{\tfrac{k\,t\ln p}{2\pi}\Big\}-\tfrac12\Big)$$

— the smooth wave *is* an exact weighted sum of pure `FractionalPart` sawtooths at the
overtone frequencies `ln p^k`. 🔬 Ladder verified (`p = 2`, `r = 1/√2`): error `~10^{-3}`
at `K = 1000`. Jan's object is exactly the `k = 1` rung: `M_1(r) = r = 1/√p` — his
amplitude was the uniquely correct one (Möbius inversion on harmonics: the sharp saw
carries overtones `1/j`, the smooth wave needs `r^j/j`; matching forces `M_k`).

**Why it doesn't simplify the sum.** Three verified reasons:
- rungs decay like `M_k(r) ≈ μ(k)·r/k` for `k` prime (🔬 `M_101` matches to machine
  precision; smooth `k` deviate by cancellation, e.g. `M_102` tiny) — **1/k, not
  geometric**, because the fundamental saw overshoots *every* overtone by `≈ r/j` and
  rung `k` repairs only `O(r/k)`; convergence is conditional and oscillatory (the
  `K = 1000` error can exceed the `K = 100` error).
- substituted into `Σ_p`, it reintroduces sharp staircases at all prime-power frequencies
  (undoing §3's tower resummation) with `1/k`-decaying weights — asymptotically far
  heavier than the explicit formula's `Λ(n)/(√n ln n) = p^{-k/2}/k`. *(Hypothesis-first
  correction: the first-draft claim "necklace weights always larger" was **false at
  `p = 2`, small `k`** — `r² = 1/2` produces exact coincidences at `k = 3, 4` and a
  smaller rung at `k = 2`; the domination is asymptotic in `k` and immediate for larger
  `p`, e.g. 10× at `p = 101, k = 2`.)*
- the two "different scales" are both load-bearing: amplitudes `1/√p` are the
  critical-line coordinate (§6), and the frequencies `ln p` are ℚ-linearly independent —
  a common `FractionalPart` scale would be a multiplicative relation among primes.

**Trade on offer:** one smooth atom per prime ⟷ sharp atoms at *all* its powers with
Möbius-weighted `1/k` tails. Sharp *and* few is not available — conservation of
difficulty. (`M_k(r)` counts aperiodic necklaces on `r` letters; here the alphabet size
is `1/√p`.)

#### 4.2.4 Quantize the wave and bin the t-axis? (Jan's question)

*If we quantize the wave shape AND discretize `t`, could the sum simplify within each
t-bin?* Gate-checked computationally ([`scripts/12`](scripts/12-quantize-and-bin.wl)); the
per-bin dream dies on an arithmetic impossibility, but a known collective version survives:

- **Freeze one prime, never two** (🔬): sampling at `t_n = 2πn/ln p` locks prime `p`'s
  binned phase (verified: constant symbol); locking `p` and `q` simultaneously needs
  `ln p/ln q ∈ ℚ`, i.e. `p^a = q^b` — impossible by unique factorization. The
  ℚ-independence of the frequencies `{ln p}` *is* the independence of the primes; no
  sampling lattice aligns two of them.
- **No compression of the joint object** (🔬): the binned, summed symbol sequence is a
  cut-and-project (model-set/quasicrystal-type) word with internal dimension `m`. Measured
  subword complexity at window length `L = 2…12`: `m = 1`: `4→24` (linear, rotation
  coding); `m = 2`: `9→528`; `m = 3`: `16→10441` — growth accelerating with `m`.
  Quantization coarsens each coordinate but cannot reduce the `m`-torus dimension; per-bin
  constancy is tautological ("piecewise-constant functions are constant on pieces") while
  *which* bin requires all `m` phases.
- **Bins shrink at the primorial rate** (🔬): quantization-boundary crossings occur at
  rate `B·θ(p_m)/2π` per unit `t` (measured `7.12` vs predicted `7.19` at `m = 10`,
  `B = 2`) — §4.1's density again.
- **The legitimate version of the dream is amortization, not per-bin collapse:** on an
  *arithmetic* `t`-grid, `e^{-it_n \ln p}` is a chirp in `n`, so the sum over primes can be
  multi-evaluated at all grid points at once by FFT — the Odlyzko–Schönhage mechanism
  (attribution recalled, standard), which is how large-scale ζ computation actually
  works. Discretizing `t` simplifies the sum *collectively* (amortized cost per bin),
  never *structurally* within one bin.
- **Per-point variant (Jan's follow-up): validity at a single `t₀` only?** Trivially yes —
  and vacuously: at one point any binning can be made exact by centering the bins on the
  `m` phases at `t₀`, so a "binned representation at `t₀`" is just finite-precision storage
  of the phase snapshot. Two quantitative facts pin down what it is and isn't worth:
  (i) the budget allocation is cheap and nonuniform — amplitudes `arcsin(p^{-1/2})/π` and
  riser slopes `≤ (1+r)/(1−r) ≤ 5.8` mean tail primes need almost no bits, total `O(m)`
  bits for a half-bin-certified snapshot — but the evaluation cost was already `O(m)`, so
  nothing is *saved*; a sub-`O(m)` single-point shortcut would contradict no theorem but
  none is known (the snap-to-ℤ "closed form ≠ shortcut" conservation, again).
  (ii) the snapshot's *validity window* is the bridge back to the domain problem: it
  survives exactly until the first quantization-boundary crossing, expected width
  `2π/(B·θ(p_m))` — the measured primorial-rate clock above. So "one point" and "whole
  domain" are the same problem measured in units of `1/θ(p_m)`; the only known discount
  for many points remains the amortized FFT route.

#### 4.2.5 The standard telescopes: trading prime enumeration for ζ-ladders

Jan's refinement of the binning idea: could the sum "telescope closed" — over primes
(obstacle: they must be enumerated) or over all naturals? Both branches are classical,
both verified ([`scripts/13`](scripts/13-telescope-ladders.wl)), and together they give
the precise verdict:

**(b) Over all naturals it genuinely telescopes.** 🔬 (to `10^{-7}`):

$$-\sum_{n\ge2}\frac1\pi\,\mathrm{Im}\,\mathrm{Log}\big(1-n^{-s}\big)
\;=\;\frac1\pi\,\mathrm{Im}\sum_{k\ge1}\frac{\zeta(ks)-1}{k}$$

— the log of the multiplicative-partitions product `Π_{n≥2}(1−n^{-s})^{-1}`; the ladder is
geometric because `ζ(ks) → 1`. *(Honest record: the first check placed a minus on the
wrong side; the identity is `−Σ_n Log(1−n^{-s}) = +Σ_k (ζ(ks)−1)/k`.)*

**(a) The prime-enumeration obstacle is removable at `σ > 1`.** The Möbius–ζ ladder

$$P(s) \;=\; \sum_{k\ge1}\frac{\mu(k)}{k}\,\log\zeta(ks)$$

computes prime-only sums **with no prime list**: ζ is an all-naturals object (prime-free
via Euler–Maclaurin). 🔬 Reproduces `PrimeZetaP[2]` to 9+ digits from 40 ζ-evaluations —
this is in fact the standard way prime-zeta values are computed.

**Structure.** Telescoping needs a *successor*: ℕ has `n → n+1`; the primes have no
algebraic successor (practically the definition of their difficulty). The Möbius ladder is
the device that borrows ℕ's successor for the primes — with the same `μ(k)/k` coefficients
as the necklace ladder of §4.2.3, in the conjugate domain (harmonic index `kθ` there,
argument ladder `ks` here): both are the Möbius shadow of unique factorization.

**Verdict: the telescope closes the enumeration, never the evaluation.** At `σ = 1/2` the
`k = 1` rung of either ladder *is* the target: 🔬 rung magnitudes at `s = 1/2 + 13.7i` are
`1.66, 0.36, 0.12, 0, 0.023, …` — the head is `|log ζ(1/2+it)|` itself; the `k ≥ 2` rungs
only strip the tower corrections. A telescope that collapsed the head per-bin would be a
sub-`√t` algorithm for `S(t₀)` — the snap-to-ℤ document's honest open question; bet on
the algorithm, not the closed form.

#### 4.2.6 `ZeroCountX`: the complex completion of the exact counter (zeros-side twin of `ceilC`)

Jan took the exact Riemann–von Mangoldt counter
`ZeroCount[t] = (1/π)Im LogGamma(1/4+it/2) − (t/2π)log π + (1/π)Im Log ζ(1/2+it) + 1`
and replaced the last term by the *complex* `(i/π)Log ζ(1/2 − it)`, asking whether the two
zeta evaluations subtract. They do — exactly, in the Re channel
([`scripts/14`](scripts/14-zerocountx-complex-completion.wl), all 🔬 machine precision):

Since `ζ(1/2−it) = conj ζ(1/2+it)`, writing `log ζ(1/2+it) = u + iv`:

$$\frac{i}{\pi}\mathrm{Log}\,\zeta(\tfrac12-it) = \frac{v}{\pi} + \frac{i}{\pi}u
= S(t) + \frac{i}{\pi}\ln\big|\zeta(\tfrac12+it)\big|,$$

so **`ZeroCountX` is the complex completion of the counting function**:

$$\text{ZeroCountX}(t) \;=\; \underbrace{N(t)}_{\text{Re: exact staircase}}
\;+\; \frac{i}{\pi}\,\underbrace{\ln|\zeta(\tfrac12+it)|}_{\text{Im: } -\infty \text{ at each zero}}$$

Verified on a 946-point grid over `(10, 45)`: `Re X − ZeroCount = 0.0` exactly;
`Im X − (1/π)ln|ζ| < 10^{-16}`; Jan's combination `Re − Im − ZeroCount ≡ −(1/π)ln|ζ|`
to `9×10^{-16}` (its plot is the pure modulus half: `+∞` spikes *at* the zeros). The Re
part is the exact staircase — values `0, 1, 2, 3` to 15 digits straddling `γ_1, γ_2, γ_3`.

This is the **zeros-side twin of §4.2's complex ceiling**: the same move exactly —
`(i/π)·Log∘conjugate` — and the same split: Re = the counting/phase half that
crystallizes into unit steps, Im = the log-modulus half that develops `−∞` spikes at the
same points. `ceilC` does it per-prime on the local lattice (`r → 1`, §4.2 log-sin
limit); `ZeroCountX` does it globally on the true zeros. The Euler side and the Hadamard
side of ζ wear the same complex-staircase uniform.

*Caveat (measure zero):* the conjugation identity fails at isolated `t` where `ζ(1/2+it)`
is negative real — both principal args read `+π` and `Re X` momentarily drops by 2. None
hit on the 946-point grid; dense plots may show one-sample glitches.

**What "varying `r`" means inside the product/sum.** Expanding each term's power tower
(§3), the weight of `n = p^j` is `r_p^j = n^{-σ}`: the Abel-damping parameter *is* the
Dirichlet weight, and varying `r` uniformly (`r_p = p^{-σ}`) is nothing but sliding the
observation line `σ` — the dial family of §6 is ζ on vertical lines. Varying `r_p`
*independently* per prime keeps an Euler product, but of the Beurling-type completely
multiplicative weight system `w_p = r_p` (a different zeta, generally no functional
equation); the slice `w_p = p^{-σ}` is exactly the one that stays in ζ's own family
`ζ(s+σ₀)` — carrying the analyticity that H4's Cauchy–Riemann pairing (and hence the
zero/Jensen/explicit-formula machinery) requires.

## 5. The snap-to-ℤ reading: the atom is distributed, never sharp

- The book's exact ceiling is the `r = 1` member of the family:
  `ceilSmoothS[x, 1] ≡ ceilBook[x] = x + 1/2 + ArcTan[Cot[π x]]/π`
  (✅ `FullSimplify → 0`; both reduce to the `π/2 − t` branch identity). At `r = 1` the term
  is a genuine singular staircase — a true snap-to-ℤ atom.
- In `zetaZeroCount`, **no prime ever supplies the sharp atom**: `r = 1/√p ≤ 1/√2 ≈ 0.707`,
  monotonically `→ 0`. Every term is real-analytic; each staircase is *soft*.
- Yet the true `N(t)` **is** integer-valued with genuine jumps. On the counting side the
  discreteness is not carried by any single term sharpening to `r = 1` — it emerges only
  in the infinite prime sum (which the Euler product controls conditionally on the critical
  line, never absolutely). At finite `m` the residual is real and never zero (§3 table).
- In the language of the snap-to-ℤ atom document: the atom here is **relocated into the
  limit** — distributed across infinitely many Abel-damped copies whose damping
  `r = 1/√p` *is* the critical-line decay `p^{-1/2}`. The `r`-dial of §8.9 (an analytic
  smoothing knob) and the critical line (an arithmetic fact) meet in the same parameter.
  Consistent with §8.10.1's verdict: smoothing supplies differentiability, never the
  half-bin precision — here, visibly, each prime's staircase arrives *pre-smoothed by
  arithmetic itself*.

## 6. Unsmoothing (Jan's question): why is `r = 1/√p` load-bearing?

*What would the formula look like if we did not blur the prime contribution with `r = 1/√p`?*
Hypotheses stated before running ([`scripts/05`](scripts/05-unsmoothing-r1-and-sigma-dial.wl));
one was falsified, recorded below.

**What `r = 1` looks like.** The termwise limit is the exact sawtooth (🔬 to `2×10^{-15}`):

$$\text{waveXX}(t,p,1) = \Big\{\frac{t\ln p}{2\pi}\Big\} - \frac12
= \frac{t\ln p}{2\pi} + \frac12 - \text{ceilBook}\!\Big[\frac{t\ln p}{2\pi}\Big],$$

so the unsmoothed counter is `nt7[t] + Σ_p ({t ln p/2π} − 1/2)` — every prime now carries a
genuine unit-jump staircase, atom fully sharp. Three independent reasons this is worse, not
better:

1. **The jumps sit on the wrong lattice.** The staircase of prime `p` jumps exactly at
   `t = 2πj/ln p` — the zeros of the *local Euler factor* `1 − p^{-s}` on the line `σ = 0`
   (`|1 − p^{-it}| = 0` there, verified). These are perfect arithmetic progressions; the
   true zeros `γ_k` avoid them (nearest true zero to the `p = 2` lattice points `j = 2..5`
   is `1.3`–`2.9` away). Unsmoothing does not sharpen the approximation to `N(t)` — it
   snaps to the zero set of the wrong function.
2. **The amplitude budget explodes.** Each sharp sawtooth has amplitude `1/2` *independent
   of `p`* (variance `1/12`); the terms no longer decay, and the sum at the true zeros is
   `√m`-growing noise. 🔬 Measured residual RMS at `γ_k` (`k ≤ 300`): `0.39, 0.77, 1.37,
   2.61` at `m = 5, 20, 50, 168` — about `0.6–0.7×` the iid-uniform bound `√(m/12)`
   (`0.65, 1.29, 2.04, 3.74`; the discount is Weyl correlation between the `{γ ln p/2π}`).
   Ceiling successes collapse `232 → 148 → 93 → 36` out of 300. Compare `r = 1/√p`:
   amplitude `arcsin(p^{-1/2})/π ≈ 1/(π√p)`, per-term variance `≈ 1/(2π²p)`, total
   `≈ (1/2π²)Σ_p 1/p ∼ log log` — the Selberg-CLT scale, just barely unbounded. The blur
   is exactly what keeps the fluctuation budget at `log log` instead of `√m`.
3. **`r` is not a knob — it is the evaluation coordinate.** `r = p^{-σ}` with `σ` the real
   part of `s`: the dial family `Σ_p waveXX[t, p, p^{-σ}]` equals `(1/π) Im log ζ(σ + it)`
   where the Euler product converges (✅ verified at `σ = 2` against
   `Im[Log[Zeta[2 + I t]]]/π` to `10^{-7}`). `r = 1` means `σ = 0` — far outside the
   product's half-plane `σ > 1`, on the very line where each local factor's zeros live.
   Each term's Abel radius is the Poisson-kernel view of that `σ = 0` lattice from
   horizontal distance `σ`; the critical line `σ = 1/2` *prescribes* `r = 1/√p`.

**Snap-to-ℤ reading:** unsmoothing does not recover the atom — it *relocates it to the
wrong ℤ*. Each prime's own discreteness (its AP lattice) must be melted so that the
conditionally-convergent superposition can re-crystallize discreteness at the zeta zeros;
hard integer information at the wrong lattice is strictly worse than none.

**The σ-dial surprise (hypothesis falsified as stated).** ❌ H4 predicted the residual RMS
at the true zeros is minimized at `σ = 1/2` (matched filter). Measured (`m = 50`,
`k ≤ 300`): minimum at `σ ≈ 0.6` (RMS `0.036` vs `0.054` at `σ = 1/2`), rising again by
`σ = 0.75`. Follow-up drift check ([`scripts/06`](scripts/06-sigma-drift.wl)), hypothesis:
optimum drifts toward `1/2` as `m` grows — 🔬 weakly supported: `σ_opt = 0.65, 0.60, 0.60`
at `m = 20, 50, 168` (RMS_opt `0.031` vs `0.047` at `σ = 1/2` for `m = 168`); right
direction but sluggish, and at these truncations the best dial sits clearly *above* the
critical line. Reading: a bias–variance tradeoff — extra damping (`σ > 1/2`) suppresses
the omitted tail (variance) at the cost of approximating `Im log ζ(σ+it)` instead of
`S(t)` (bias). Honest §8.10.1-style caveat: Ceiling decisions are flat `300/300` across
the whole band `σ ∈ [0.3, 1]` at `m = 50` — the RMS gain changes no decisions, so this is
approximation theory, not a zzz-channel revival.

## 7. Sum of inverses, and the Blaschke map behind the ceiling family (Jan's questions)

Two follow-up questions, both resolved in
[`sum-of-inverses-and-blaschke-conjugation.md`](sum-of-inverses-and-blaschke-conjugation.md):

- **Does summing the *inverses* of the per-prime staircases relate to
  inverting their sum?** No — `F⁻¹` and `G = Σ_p s_p⁻¹` diverge at least
  quadratically in the prime count (✅ AM–HM argument, 🔬 measured ratio
  1 → 4.3 → 22.6 → 58.9 → 128.4 → 249.5 at `m = 1,2,4,6,8,10`). The shared
  riser-midpoint height Jan noticed (`ceilSmooth[n+1/2,r] ≡ n+1`, any `r`) is
  real (✅ exact) but doesn't bridge the two constructions.
- **Is there a conformal map of the `(t,y)` plot plane, built from those
  shared fixed heights, that simplifies the cross-prime sum?** The conformal
  map is real and verified: `ceilSmooth`'s wobble term is exactly the
  boundary angle-distortion of the Blaschke/Möbius disk automorphism
  `B_r(z)=(z-r)/(1-rz)` (✅ `1.3×10⁻¹⁵`), whose universal fixed points
  `z=±1` (✅ exact, for every `r`) are precisely *why* the shared height is
  `r`-independent — `θ=π` is the antipodal endpoint of `B_r`'s hyperbolic
  translation axis. Conjugating by `w=(1+z)/(1-z)` straightens `B_r` into
  pure scaling by `(1-r)/(1+r)` (✅ exact) — reproducing §4's riser/tread
  ratio as a cross-check. But it can't help the cross-prime sum: each
  prime's fixed point sits at a different `t` (`π/ln p`), so no shared
  conjugation silences two primes at once (`p^a=q^b` impossible) — the same
  obstruction as §4.2.4, now derived from fixed-point geometry rather than
  observed empirically.

Scripts: [`scripts/15-sum-of-inverses-vs-inverse-of-sum.wl`](scripts/15-sum-of-inverses-vs-inverse-of-sum.wl),
[`scripts/16-blaschke-conformal-map.wl`](scripts/16-blaschke-conformal-map.wl).

## 8. A broken σ-dial that still finds the zeros (Jan's `wrong[]`)

Full note: [`broken-sigma-dial-beurling-weight.md`](broken-sigma-dial-beurling-weight.md).
Jan's `wrong[σ,lo,hi,m]` has three bugs — `σ` unused, constant smoothing
`r=1/2` instead of `p^{-σ}` (a `19{,}101×` amplitude overshoot at `p=191`),
and a 5-argument call that doesn't match its own 4-parameter definition — and
collapses exactly to `-Σ_p Log[1-(1/2)p^{-it}]`, a Beurling-type Euler
product with constant weight `w_p≡1/2` (§4.2's H6 family), not any slice of
`ζ`. Adversarially tested rather than assumed: its dips *do* sit
above-chance close to true zeros (✅ `p≈0.015` vs. a 200-trial random-target
null model, same window/measure) — because it keeps the correct frequencies
`{ln p}` and only the amplitude is wrong, and the explicit-formula
prime↔zero duality is fundamentally about frequency content, not amplitude.

Script: [`scripts/17-wrong-beurling-weight-and-zero-proximity.wl`](scripts/17-wrong-beurling-weight-and-zero-proximity.wl).

## 9. Box-averaging the truncated critical-line sum: a surprisingly good, closed-form smoothing (Jan's questions)

Full note: [`box-average-smoothing-truncated-logzeta.md`](box-average-smoothing-truncated-logzeta.md).
Simply box-averaging (moving average, window `w`) the `m=50`-prime truncated
`σ=1/2` sum gives a clean dilogarithm closed form and a real ~4× error
reduction against true `\log\zeta(1/2+it)` away from the zeros (`0.155→0.037`
median diff); measured with the *correct* metric (distance to the
approximation's own nearest local minimum, not amplitude against a divergent
target), it ties-or-beats the unsmoothed sum at locating every zero in range
too. Jan's heuristic `w=1/2` sits within 5% of the true optimum
(`w≈0.52–0.54`). Varying the window per prime (`w_p=c/\ln p`) is legal
(integration/summation commute) and structurally elegant — every prime's
`k`-th harmonic gets the identical `\operatorname{sinc}(kc)` weight, a ladder
parallel to §4.2.3's necklace ladder — but empirically **worse** (over 4×),
because it over-damps the dominant small-prime terms. Varying with `t`
(`w(t)=c/\log(t/2\pi)`, RvM-motivated) is inconclusive on this narrow window
— open, not closed.

Scripts: [`scripts/18-box-average-smoothing-truncated-logzeta.wl`](scripts/18-box-average-smoothing-truncated-logzeta.wl),
[`scripts/19-box-smoothing-per-prime-and-t-dependent-w.wl`](scripts/19-box-smoothing-per-prime-and-t-dependent-w.wl).

### 9.1 Addendum (2026-07-10): the polylog↔ζ circularity (Jan's question), and §9 adopted in zzz

Jan asked whether the ζ-values that surface in *symbolic* polylog evaluation make §9's
closed form a usable circularity. Answered by reduction to channels already closed:
summing the dilog term over **all** primes telescopes through the prime zeta into the
Möbius–ζ ladder (`Σ_j P(js)/j²` with `P(s) = Σ_k μ(k)/k·log ζ(ks)`) — the completed box
average is just `(1/2w)∫log ζ`, so §4.2.5's verdict applies verbatim: the ladder closes
the *enumeration*, never the *evaluation* (at `σ = 1/2` the head rung is the target
itself). The one fresh-looking corner — each Euler factor's own Lerch/Jonquière
functional equation `Li_s(z) + (−1)^s Li_s(1/z) = (2πi)^s ζ(1−s, x)/Γ(s)`, whose Hurwitz
values at non-positive integers degenerate to Bernoulli polynomials — is §5–§6 in
disguise: exact per-prime staircases on the *local factor's* lattice (the wrong ℤ),
blocked from crossing primes by the ℚ-independence of `{ln p}`; and the constants
`ζ(2), ζ(3), …` carry no height-`t` information. Parked with mechanisms, not priors.
Meanwhile the practical half of §9 shipped: in zzz (commit `ef99388f`,
`doc/notes/box-forward-step.md`) the box average acts as a per-term `sinc(m·w·ln p)`
weight on the forward zero counter — gate-checked at 2.5–3.5× location gain for
`κ = gap·log X ∈ (1.5π, 3π)` and **null at `κ ≤ π`** (this session's smoothing
independently confirming zzz's band-saturation theorem at its threshold), then measured
**2.25×** in the live `--loop` with primes staying sieve-exact. That run also supplies
the missing large-`t` data for §9's open `w(t)` question: with
`w = c·gap(t) = 2πc/log(t/2π)` at fixed `c = 0.375`, gap-unit errors are flat-to-improving
from `t ≈ 124` to `t ≈ 4.6×10⁴` (per-band median `0.017 → 0.012`) while `log(t/2π)`
varies 3× — the RvM-density scaling is the right first-order law, with only a mild
κ-drift of the optimal `c` on top (`0.5 → 0.25` as κ grows `1.5π → 3π`).

**And the untruncated closure** (Jan's follow-up; full detail in the
[note §6](box-average-smoothing-truncated-logzeta.md), script
[`scripts/20`](scripts/20-untruncated-box-closure.wl)): box-averaging the **whole**
`log ζ` closes exactly — but across the line, not on the prime side. Since a box
average is an endpoint difference of the antiderivative (so any `w(t)` law closes the
same way), Littlewood's lemma gives
`(1/2w)∫_{t-w}^{t+w} Log ζ(1/2+ix) dx = (i/2w)[G(t+w) − G(t-w)]` with
`G(τ) = ∫_{1/2}^∞ Log ζ(σ+iτ) dσ` — 🔬 `9×10⁻¹³`, including a window containing `γ_2`;
the Im half is the classical `S₁`. This is the **third member of the Cauchy–Riemann
family** (per-prime `ceilC` §4.2, global `ZeroCountX` §4.2.6): smoothing along the line
= evaluation across the line. At a zero the `−∞` spike closes to a finite dip
`log|ζ′(ρ)| + log w − 1 + O(w²)` (🔬 exact `w²` scaling), i.e. depth drifting like
`−log log(t/2π)` under `w = c·gap(t)`. The prime side does *not* close (the pole's
`e^{v/2}` beats sinc's algebraic damping; the σ-ray **is** the regularized
`Σ_p Li₂(p^{-1/2-iτ})/ln p` — §4.2.5 again). Unfolding reading: `w = c·gap(t)` is a
constant-width-`c` box in the unfolded time `τ = N₀(t)` — the window matched to the
*output* (zero) lattice, mirror image of the rejected input-lattice `w_p = c/ln p`.

**And the last rotation — an imaginary window** (Jan: "`w = i/2` simplifies nicely";
full detail [note §7](box-average-smoothing-truncated-logzeta.md), script
[`scripts/21`](scripts/21-imaginary-window-rotation.wl)): `w = iv` lands the box on the
`σ`-segment `(1/2−v, 1/2+v)` (`v = 1/2` = the whole strip), where the functional-equation
pairing splits it **exactly**: Re = the `σ`-window average of `log|ζ|` (zeros as
log-wells, same dip law sideways), Im = the explicit `(1/2)⟨arg χ⟩ ≈ −θ(t)` **plus a
jump of exactly π at each zero and zero fluctuation between them** (🔬 π to 8 digits
across `γ_1`; residual constant to `5×10⁻⁸` over `t ∈ (15.5, 20)` while `S(t)` varies by
~0.2). The FE symmetrization annihilates `S(t)` analytically — the counting channel's
*analytic* content is gauge; only the *topological* content (winding, π per zero)
survives — the snap-to-ℤ atom purified, and `ZeroCountX` §4.2.6's `σ`-averaged sibling.
Prime side: sinc rotates to `sinh(mv ln p)/(mv ln p) ≥ 1` — anti-damping, so the
imaginary window is the zzz anti-lever; band-saturation stands.

## Verification

All scripts run with `wolframscript -file` (hypotheses stated in headers before checks):

- [`scripts/01-wavex-max.wl`](scripts/01-wavex-max.wl) — `Re[Log]→Arg→ArcTan[x,y]`
  technique; max `arcsin(p^{-1/2})/π`, argmax `−arccos(p^{-1/2})/ln p`; `NMaximize`
  cross-check `p = 2, 3, 7, 50`.
- [`scripts/02-wavexx-max-alignment.wl`](scripts/02-wavexx-max-alignment.wl) — `ArcCot`
  form `= Arg(1−re^{iθ})`; max `arcsin r`; alignment iff `r = 1/√p`; full-function identity
  with `waveX`.
- [`scripts/03-zeta-count-tower-resummation.wl`](scripts/03-zeta-count-tower-resummation.wl)
  — tower resummation to `10^{-11}`; RMS/success table vs `ZetaZero`, `k ≤ 300`.
- [`scripts/04-zeta-count-ceiling-form.wl`](scripts/04-zeta-count-ceiling-form.wl) —
  reparametrization `Simplify → 0`; both counter forms agree to `6×10^{-12}`;
  `ceilSmoothS[·,1] ≡ ceilBook`; primorial slope.
- [`scripts/05-unsmoothing-r1-and-sigma-dial.wl`](scripts/05-unsmoothing-r1-and-sigma-dial.wl)
  — `r = 1` sawtooth/`ceilBook` identities; local-factor zero lattice; `√m` collapse table;
  σ-dial RMS sweep (H4 falsified as stated); Euler-product identity at `σ = 2`.
- [`scripts/06-sigma-drift.wl`](scripts/06-sigma-drift.wl) — `σ_opt(m)` drift check,
  `m = 20, 50, 168`.
- [`scripts/07-linear-term-and-plotting-form.wl`](scripts/07-linear-term-and-plotting-form.wl)
  — `ceilSmoothS ≡ ceilSmooth` (pole-free form); removable singularities at `x = k/2`;
  no `ArcCot` branch jump for `r < 1`; density crossover at `t = 2π·p_m#`; AP-union
  zero count vs `T·θ(p_m)/2π`.
- [`scripts/08-zeta-from-complex-ceiling.wl`](scripts/08-zeta-from-complex-ceiling.wl)
  — complex ceiling `ceilC` (Re = `ceilSmooth`, Im = log-modulus, `r→1` = log-sin kernel);
  (Poisson, conjugate-Poisson) derivative pair; modulus as `r`-ray integral of the
  Poisson kernel; Cauchy–Riemann in `(σ,t)`; `log ζ = −iπ Σ_p conj(ceilC − ramp)`
  verified at `σ = 2, 3/2`.
- [`scripts/09-truncation-error-in-t.wl`](scripts/09-truncation-error-in-t.wl) —
  truncation error flat in `t` over five decades at `σ = 2, m = 10` (bound/RMS a-priori
  vs measured); growth as `σ ↓ 1`; partial products nonvanishing at `σ = 1/2`.
- [`scripts/10-critical-line-between-zeros.wl`](scripts/10-critical-line-between-zeros.wl)
  — `σ = 1/2` tracking: median diff `0.16` between zeros at `m = 11`; `−log|t−γ|`
  divergence at zeros; 20% improvement for 9× primes; branch-safe window.
- [`scripts/11-necklace-ladder.wl`](scripts/11-necklace-ladder.wl) — cyclotomic/necklace
  identity: `waveXX = Σ_k M_k(r)·saw(k·)` exact; `M_1 = 1/√p`; `μ(k)r/k` decay; weight
  comparison vs `Λ(n)/(√n ln n)` (with the corrected `p = 2` coincidences).
- [`scripts/12-quantize-and-bin.wl`](scripts/12-quantize-and-bin.wl) — freeze one prime
  never two; cut-and-project complexity growth of the summed binned word (`m = 1, 2, 3`);
  crossing rate = `B·θ(p_m)/2π` verified.
- [`scripts/13-telescope-ladders.wl`](scripts/13-telescope-ladders.wl) — Möbius–ζ ladder
  `P(s) = Σ μ(k)/k·log ζ(ks)` (9+ digits, no prime list); all-naturals wave sum
  `= Σ_k(ζ(ks)−1)/k` (`10^{-7}`); critical-line rung magnitudes (the head is the target).
- [`scripts/14-zerocountx-complex-completion.wl`](scripts/14-zerocountx-complex-completion.wl)
  — `ZeroCountX = N(t) + (i/π)ln|ζ(1/2+it)|`: `Re X − ZeroCount = 0` exactly (946 pts);
  Jan's `Re−Im−ZeroCount ≡ −(1/π)ln|ζ|` to `10^{-15}`; staircase exact at `γ_1..γ_3`.
- [`scripts/15-sum-of-inverses-vs-inverse-of-sum.wl`](scripts/15-sum-of-inverses-vs-inverse-of-sum.wl)
  — `ceilSmooth[n+1/2,r] ≡ n+1` exact; `F⁻¹` vs `G=Σ_p s_p⁻¹` ratio table
  (1 → 249.5 at `m=1..10`) vs AM–HM lower bound.
- [`scripts/16-blaschke-conformal-map.wl`](scripts/16-blaschke-conformal-map.wl)
  — Blaschke automorphism `B_r(z)=(z-r)/(1-rz)` fixes `z=±1`; boundary angle
  map `≡` ceiling wobble (`1.3×10⁻¹⁵`); Cayley conjugation `≡` `(1-r)/(1+r)`
  scaling.
- [`scripts/17-wrong-beurling-weight-and-zero-proximity.wl`](scripts/17-wrong-beurling-weight-and-zero-proximity.wl)
  — bug diagnosis (`σ` dead, arg-count mismatch, `19,101×` amplitude
  overshoot); closed form `≡ -Σ_p Log[1-(1/2)p^{-it}]` (`~10⁻¹⁴`);
  above-chance zero proximity vs. 200-trial random-target null model
  (`p≈0.015`).
- [`scripts/18-box-average-smoothing-truncated-logzeta.wl`](scripts/18-box-average-smoothing-truncated-logzeta.wl)
  — dilog closed form (sign-verified `4×10⁻¹⁶`); away-from-zeros median diff
  `0.155→0.037` (box vs. unsmoothed); corrected location-based zero test
  (ties/beats at all 5 zeros); `w`-sweep optimum `≈0.52–0.54`.
- [`scripts/19-box-smoothing-per-prime-and-t-dependent-w.wl`](scripts/19-box-smoothing-per-prime-and-t-dependent-w.wl)
  — per-prime `w_p=c/ln p` gives uniform `sinc(kc)` ladder weight
  (`1.6×10⁻¹⁵`) but empirically worse (`0.162` best vs `0.035`);
  `t`-dependent `w(t)=c/log(t/2π)` inconclusive on this window.
- [`scripts/20-untruncated-box-closure.wl`](scripts/20-untruncated-box-closure.wl)
  — untruncated closure (§9.1): t-box of `log ζ` = `i·Δ`(σ-ray integral), `9×10⁻¹³`
  incl. a window containing `γ_2`; dip depth `log|ζ′(ρ)|+log w−1` with exact `w²`
  error scaling; prime side divergent (analytic).
- [`scripts/21-imaginary-window-rotation.wl`](scripts/21-imaginary-window-rotation.wl)
  — imaginary window `w=iv` = σ-segment average (note §7): exact FE split
  (`log|χ|` odd to `10⁻¹⁵`, integral form exact at `t=20`, mod-2π offsets logged);
  `(1/2)⟨arg χ⟩ = −θ(t)+O(v²/t)` (1/t scaling verified); unwrapped branch: jump
  `= π` to 8 digits across `γ_1`, flat to `5×10⁻⁸` between zeros; sinh weights.
- [`scripts/22-borders-and-derivative-form.wl`](scripts/22-borders-and-derivative-form.wl)
  — borders (note §7.1): `|χ(it)| = √((t/2π)tanh(πt/2))` (12 digits);
  `log|ζ(1+it)|−log|ζ(it)| = −log|χ(it)|` (`10⁻¹⁵`, borders pointwise zero-free);
  `d/dt⟨arg ζ⟩_strip` a.e. `= −log|χ(it)|` (FD, `10⁻⁸`–`10⁻⁹`) — all arithmetic in
  the π-jumps (monodromy), none in the derivative.

## Open directions

- **`t`-dependent smoothing window `w(t)` for the box-averaged sum (resolved at
  first order — §9.1).** §9 tried `w(t)=c/\log(t/2\pi)` (matched to the RvM zero
  density) and found it inconclusive on `t\in(13,33)` — too little variation in
  `\log(t/2\pi)` over that window (`0.73\to1.66`) for the idea to prove itself, and the
  implied `w` swings into the already-known-bad `w\gtrsim1` region at low
  `t`. **Update 2026-07-10:** answered at large `t` by the zzz adoption (§9.1):
  `w = c·gap(t)` at fixed `c = 0.375` holds gap-unit errors flat-to-improving over
  `t ∈ (1.2×10², 4.6×10⁴)` (`\log(t/2\pi)` varying 3×) inside the live `--loop`.
  Remaining open: only the second-order drift of `c_{opt}` with `κ = gap·log X`
  (`0.5 → 0.25` as κ grows `1.5π → 3π`).
- **The `σ_opt(m)` law (active).** §6 measured the finite-truncation optimum at
  `σ_opt ≈ 0.6 > 1/2`, drifting only sluggishly toward the critical line
  (`0.65 → 0.60 → 0.60` at `m = 20, 50, 168`). Derive it: model the residual as
  bias² + variance with bias `= (1/π)(Im log ζ(σ+it) − Im log ζ(1/2+it))` and variance
  `≈ (1/2π²) Σ_{p > p_m} p^{-2σ}` (truncated tail), predict `σ_opt(m)` and its `m → ∞`
  limit/rate, test at larger `m` and higher `k`-ranges. Gate: channel matches (this is
  Dirichlet-polynomial approximation of `S(t)` — Selberg/Goldston territory, an
  established genre); cheap; falsifiable. Caveat carried from §6: decisions are flat in
  `σ`, so this is approximation theory, not a zzz bridge.

Gate-checked and kept out of the active list:

**Considered and rejected:**
- *Tower resummation as a computational edge for zzz* — killed by §3: RMS `0.047` (towers,
  `p ≤ 997`) vs `0.045` (plain `n ≤ 1000`); the `j ≥ 2` tail is negligible, so the closed
  form is aesthetics, not reach.
- *Per-bin simplification of the quantized + t-discretized sum* (§4.2.4) — killed by the
  two-prime phase-lock impossibility (`p^a = q^b` has no solutions) plus the measured
  cut-and-project complexity growth; the per-point (`t₀`) variant is vacuous (validity
  window = the primorial clock `2π/Bθ(p_m)`). Surviving known form: amortized FFT
  multi-evaluation on arithmetic grids (Odlyzko–Schönhage).
- *Telescoping the critical-line head* (§4.2.5) — the Möbius–ζ ladders close the prime
  *enumeration* (genuine, verified) but the `k = 1` rung at `σ = 1/2` is the target
  itself; a per-bin head-collapse would be a sub-`√t` `S(t₀)` algorithm (open, bet
  against).
- *Sharpening the per-prime `r` toward 1 as a "better" counter* — killed empirically in §6:
  `r = 1/√p` is not a free smoothing knob, it is the evaluation coordinate `σ = 1/2`;
  pushing `r → 1` moves the observation line onto `σ = 0`, snaps to the local factors'
  AP lattices, and collapses the counter (`36/300` at `m = 168`).
- *Accuracy channel to zzz* — closed twice before this session (§8.10.1 gate check;
  §3's tower-vs-size comparison), and a third time by §6's flat-decision σ-sweep.
- *Per-prime box-smoothing window `w_p=c/ln p`* (§9) — structurally elegant
  (uniform `sinc(kc)` ladder weight across primes, `1.6×10⁻¹⁵`) but
  empirically over 4× worse than constant `w` (`0.162` vs `0.035`): it damps
  the dominant small-prime terms by the same relative amount as the noisy
  large-prime ones, the wrong asymmetry.
- *Conformal map of the `(t,y)` plot plane to simplify the cross-prime sum* (§7) —
  the map is real (Blaschke automorphism `B_r`, verified exactly) but its fixed
  points sit at a different `t` per prime (`π/ln p`); no shared conjugation can
  silence two primes at once (`p^a=q^b` impossible). Same ℚ-independence
  obstruction as §4.2.4, now derived from fixed-point geometry.

Speculative (unchecked, low priority): for `1/2 < σ ≤ 1` (between the dial's absolute-convergence
regime and the critical line) identify the truncated dial sum against a branch-tracked
`(1/π) arg ζ(σ + it)` directly — §6/H5 verified the identity only at `σ = 2`, and principal-branch
`Im[Log[Zeta]]` jumps make the comparison delicate lower in the strip.
