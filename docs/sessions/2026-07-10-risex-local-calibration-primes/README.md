# `riseX`/`errf`: a smoother running average, an exact closed-form next-prime solve, and why it does *not* beat gap independence

**Date:** 2026-07-10
**Origin:** cross-repo — surfaced in a `zzz` (Riemann zeta zero counting, sibling repo) session while
looking for a smoother normalization of `Sum[n/Log[Prime[n]], {n,2,m}]/m`. The result is pure
analytic-number-theory/WL technique, unrelated to zeta zeros, hence documented here.

**One-line result:** `riseX[m] := (-1+Sum[n/Log[Prime@n],{n,2,m}])/(Log[m]LogIntegral[m])` has a second
difference `diffX[m]` that is small (✅ proven identity below) and can be computed prime-free, in closed
form (§4.1 — an exact `Li`-antiderivative eliminates the `NIntegrate` in the first pass). Its "assume
`diffX=0`, solve for `Prime[m+2]`" extrapolation (`errf`) beats the classical
global `Li⁻¹(n)` prime estimator by 10–1000×, which looks like it's beating prime-gap unpredictability —
but 🔬 it isn't: an adversarial check (§7) shows the entire advantage comes from feeding in the one
already-known prime `Prime[m+1]`, and `errf` is statistically tied with (sometimes better, sometimes
worse than) any of three naive classical estimators that use that same single datum. §8 explains *why*
the construction is so smooth (log-compression + history-localization), §9 upgrades the ansatz with the
closed-form curvature model — which lands exactly on the Cramér baseline and resolves the remaining
"occasional wins" puzzle as a median-vs-mean shift on the skewed gap distribution.

---

## 0. Setup

```mathematica
rise[m_] := Sum[n/Log[Prime@n], {n, 2, m}]/m;
diff[m_] := (rise[m + 1] + rise[m - 1])/2 - rise[m];

riseX[m_] := (-1 + Sum[n/Log[Prime@n], {n, 2, m}])/den[m];
den[m_] := Log[m] LogIntegral@m;
diffX[m_] := (riseX[m + 1] + riseX[m - 1])/2 - riseX[m];
```

`riseX` differs from `rise` only in the denominator: `Log[m]·Li[m]` instead of `m`. Since `Li[m] ~
m/Log[m]` (PNT), `den[m] ~ m` to leading order, but `Li` carries the correct *subleading* correction
too (`Li(x) = x/Log x + x/(Log x)^2 + …`), which is why `riseX` is empirically smoother than `rise` —
its second difference `diffX` is systematically smaller than `diff`'s at matched `m`.

## 1. `errf[m,p,q]` is *exactly* `diffX[m+1]` — ✅ PROVEN

For **any** smooth denominator `D(m)` (not just `Log[m]Li[m]`), write `T(m) := D(m)·riseX(m) = -1 +
Sum[a_n, {n,2,m}]` with `a_n = n/Log[Prime[n]]`, so `T(m+1) = T(m) + a_{m+1}`, `T(m-1) = T(m) - a_m`.
Substituting into `diffX(m+1)` and using `a_{m+1} = (m+1)/p`, `a_{m+2} = (m+2)/q` (`p := Log[Prime[m+1]]`,
`q := Log[Prime[m+2]]`), the `T(m+1)-a_{m+1}` term collapses back to `T(m) = D(m)·riseX(m)`, giving:

$$
\text{diffX}(m+1) = \text{riseX}(m)\Big[\tfrac12 + \tfrac{D(m)}{2D(m+2)} - \tfrac{D(m)}{D(m+1)}\Big]
 \;+\; \frac{m+1}{p}\Big[\frac{1}{2D(m+2)} - \frac1{D(m+1)}\Big] \;+\; \frac{m+2}{2q\,D(m+2)}
$$

with `D(k) = Log[k]·LogIntegral[k]`. This matches the user's `errf[m,p,q]` term-for-term (independently
re-derived by hand, and verified with sympy on the abstract sequence — the identity holds regardless of
what `D` is). 🔬 Numerically confirmed to double precision:

| m | `errf[m, Log@Prime[m+1], Log@Prime[m+2]]` | `diffX[m+1]` | match |
|---|---|---|---|
| 3 | −0.0041158410870969 | −0.0041158410870967 | ✅ |
| 10 | −0.0011785128645782 | −0.0011785128645783 | ✅ |
| 30 | 0.0001031791396025 | 0.0001031791396024 | ✅ |
| 80 | 0.0000730309661590 | 0.0000730309661581 | ✅ |

**Bonus simplification (not in the original code):** `q` appears in `errf` only through the two terms
`1/(L₂ q Li₂) + m/(2 L₂ q Li₂)`, i.e. `errf(m,p,q) = A(m,p,rX) + B(m)/q` — *linear in `1/q`*. So
`Solve[errf[...]==0, q]` is not really a numerical root-find; it's closed-form algebra:

```mathematica
D0[m_]     := Log[m] LogIntegral[m];
Bcoef[m_]  := (m + 2)/(2 D0[m + 2]);
Acoef[m_, p_, rX_] := (m + 1)/p (1/(2 D0[m + 2]) - 1/D0[m + 1]) +
                       rX (1/2 - D0[m]/D0[m + 1] + D0[m]/(2 D0[m + 2]));
qHat[m_, p_, rX_]  := -Bcoef[m]/Acoef[m, p, rX];
```

🔬 `qHat` matches `FindRoot`'s output to `~10⁻¹⁵` at every tested `m` (script 01).

Script: [`scripts/01-errf-diffx-identity.wl`](scripts/01-errf-diffx-identity.wl).

## 2. The `diffX=0` ansatz is never exact — magnitude and a numerical-precision caveat

`diffX[m]` shrinks with `m` but never hits zero, and its decay is not a clean power law — it plateaus
into what §7 identifies as prime-gap noise (same phenomenon documented for plain `rise`/`diff` in the
originating `zzz` session, not repeated here).

**The real "gets worse for large `m`" is catastrophic cancellation, not the math.** `riseX[m] ~
m/(2 Log m)` grows while `diffX[m]` shrinks, so `errf` computes a small residual from a near-total
cancellation of larger terms — the number of decimal digits eaten by that cancellation grows roughly
like `2·log₁₀(m)`. 🔬 Comparing `MachinePrecision` (~15.95 digits) against a controlled 40-digit
`WorkingPrecision`:

| m | relative discrepancy (machine vs 40-digit) |
|---|---|
| 1000 | 1.3×10⁻⁸ |
| 5000 | 1.8×10⁻⁶ |
| 20000 | 1.4×10⁻⁵ |
| 50000 | 5.4×10⁻⁵ |
| 100000 | 1.6×10⁻⁴ |

A `log₁₀(discrepancy)` vs `log₁₀(m)` fit gives slope `1.97 ≈ 2` (matching the digit-loss estimate) and
intercept extrapolating to **`m ≈ 6.8×10⁶`** for total precision loss at `MachinePrecision`. 🤔 **This
extrapolation is not verified at that scale** — it is a linear fit through `m ≤ 10⁵` data, offered as a
hypothesis, not a measurement. Practically: any `WL` session pushing this construction past `m ~ 10⁵–10⁶`
needs `WorkingPrecision` scaled with `m` (≈`2 log₁₀ m` guard digits), exactly the discipline the sibling
`zzz` repo already enforces by carrying `arb_t`/`slong PREC` everywhere instead of machine doubles.

Script: [`scripts/02-diffx-decay-and-precision.wl`](scripts/02-diffx-decay-and-precision.wl).

## 3. `LogIntegral → PrimePi` breaks it — 🔬 NUMERICALLY VERIFIED

Swapping `den[m] = Log[m] PrimePi[m]` for `Log[m] LogIntegral[m]` makes `diffXPP` (the PrimePi-based
second difference) **~1146× larger on average** over `m = 30..300` (mean `|diffXPP|`/mean `|diffX|` =
1146.29), spiking to ratios of 400–5000× at every `m` where `m−1`, `m`, or `m+1` is itself prime (e.g.
`m=31`: ratio 1510×; `m=59`: ratio 5139×).

**Why:** `LogIntegral` is real-analytic — it varies smoothly by `O(1/Log m)` per unit step. `PrimePi` is
a step function: `PrimePi[k] − PrimePi[k−1] = 1` exactly when `k` is prime, `0` otherwise. The entire
`riseX`/`errf` construction leans on the denominator's *own* curvature being negligible, so the residual
it isolates is genuine prime information; a denominator with `O(1)` jumps precisely at prime locations —
the very thing being probed — swamps that signal with its own discontinuities. Textbook illustration of
why `Li(x)` is PNT's smooth companion to `π(x)`: useful *because* it's smooth, not because it tracks
`π(x)` pointwise.

Script: [`scripts/03-primepi-break.wl`](scripts/03-primepi-break.wl).

## 4. `riseX[m]` itself can be made prime-free — ✅ derivation exact; 🔬 error <0.1% by m=20000

`riseX[m]` currently needs the *entire* prime table `2..m` (via `Sum[n/Log[Prime[n]]]`). Substitute
`t = Li(x)` (so `x = Li⁻¹(t)`, `dt = dx/Log(x)`) into the continuum version of the sum:

$$
\text{Sum}_{n=2}^{m}\frac{n}{\log(\text{Prime}[n])}\;\approx\;\int_2^m \frac{t}{\log(\text{Li}^{-1}(t))}\,dt
\;=\;\int_{x_0}^{\text{Li}^{-1}(m)} \frac{\text{Li}(x)}{(\log x)^2}\,dx, \qquad x_0 := \text{Li}^{-1}(2)
$$

```mathematica
liInv[n_] := x /. FindRoot[LogIntegral[x] == n, {x, Max[4, n (Log[n]+Log[Log[n]])]}];
x0 = liInv[2];  (* = 2.8251871520058267 *)
SmApprox[m_] := NIntegrate[LogIntegral[x]/Log[x]^2, {x, x0, liInv[m]}];
riseXApprox[m_] := (-1 + SmApprox[m])/(Log[m] LogIntegral[m]);
```

⚠️ **Methodological trap, documented so it doesn't bite again:** the textbook Newton seed
`n(Log n + Log Log n)` sends `FindRoot` to a *spurious* root at `x ≈ 1.006` for small `n` (e.g. `n=2`),
right at `LogIntegral`'s singularity at `x=1` — `NIntegrate` then reports garbage (including a nonzero
imaginary part) with no visible error beyond a `ncvb`/`slwcon` warning. Clamping the guess to `Max[4, …]`
fixes it. First pass at this session got `riseXApprox` wrong for every `m` below 5000 this way (relative
"error" as large as −2555×) before the bug was found.

With the fix, `riseXApprox[m]` tracks the true `riseX[m]` closely and improves with `m`:

| m | riseX | riseXApprox | rel. err |
|---|---|---|---|
| 10 | 1.4223 | 1.4222 | −0.0092% |
| 50 | 3.7657 | 3.8651 | 2.64% |
| 200 | 11.7512 | 11.8685 | 1.00% |
| 1000 | 48.8475 | 48.9918 | 0.30% |
| 5000 | 210.4475 | 210.6419 | 0.092% |
| 20000 | 751.5430 | 751.8093 | 0.035% |

Script: [`scripts/04-risex-prime-free-approx.wl`](scripts/04-risex-prime-free-approx.wl) (also produces
the §5 table below).

### 4.1 Closing the gap: `NIntegrate` is provably unnecessary — ✅ exact antiderivative

The point of the original `riseX`/`errf` construction was that everything was closed-form algebra (§1
Bonus). `NIntegrate` breaks that — it's a black box, it's what the §4 singularity trap hid inside, and
(as just shown) it's fragile near `x=1`. It turns out to be avoidable entirely: `Integrate[Li(x)/(Log
x)^2, x]` has an **exact elementary+`Li` antiderivative** that WL's `Integrate` does not find on its own,
via two integrations by parts (`Integrate[1/(Log x)^2, x] = Li(x) - x/Log(x)` and `Integrate[x/Log(x),
x] = Li(x^2)`, both standard):

$$
G(x) := \frac{\text{Li}(x)^2}{2} - \frac{x\,\text{Li}(x)}{\log x} + 2\,\text{Li}(x^2) - \frac{x^2}{\log x}
\qquad\Longrightarrow\qquad G'(x) = \frac{\text{Li}(x)}{(\log x)^2}
$$

(✅ verified: `D[G[x],x] - LogIntegral[x]/Log[x]^2` numerically zero to 20 digits at `x = 5, 50, 1000,
10⁶`; symbolically zero once `Log[x²]→2Log[x]` is applied). So `SmApprox(m) = G(y) - G(x0)` **exactly**,
`y := Li⁻¹(m)`, `x0 := Li⁻¹(2)` a fixed constant computed once. Using `Li(y) = m` by definition of `y`
simplifies `G(y)`, giving a formula with no integral of any kind left in it:

```mathematica
G[x_] := LogIntegral[x]^2/2 - x LogIntegral[x]/Log[x] + 2 LogIntegral[x^2] - x^2/Log[x];
x0 = liInv[2];  Gx0 = G[x0];  (* fixed constant *)
SmClosed[m_] := Module[{y = liInv[m]}, m^2/2 - y m/Log[y] + 2 LogIntegral[y^2] - y^2/Log[y] - Gx0];
riseXClosed[m_] := (-1 + SmClosed[m])/(Log[m] LogIntegral[m]);
```

🔬 Matches the old `NIntegrate`-based `riseXApprox` to `10⁻¹⁰`–`10⁻¹⁵` at every tested `m` (pure numerical
noise, not a systematic difference) — same accuracy table as §4, unchanged — while being **~50–80×
faster** (0.0005–0.0007s vs 0.04s per call at `m=5000`, this session's two independent timing runs) and,
more importantly, no longer touches an adaptive-quadrature routine at all. The *only* remaining numerical
step is one `FindRoot` for `Li⁻¹(m)` — a single well-conditioned monotone equation, nothing like
`NIntegrate`'s multi-point adaptive search that failed near `x=1`. That FindRoot is exact (not an
approximation) up to solver tolerance, in the same sense that WL's internal evaluation of `LogIntegral`
itself is exact-up-to-tolerance; it is not a numerically fragile ingredient the way `NIntegrate` was, and
should **not** be further replaced by a truncated asymptotic series for `Li⁻¹` (e.g. a Cipolla-style
expansion) — that would trade the one remaining exact numeric step for a genuinely lossy approximation,
reintroducing the 1–3%-level error the whole point of using `Li⁻¹` was to avoid (§6, column D vs A/B).

Script: [`scripts/06-risex-closed-form.wl`](scripts/06-risex-closed-form.wl).

## 5. The requested formulas: `errf(approx riseX, true p)`

This is pipeline **B** below — `riseX[m]` replaced by the prime-free, now fully closed-form
`riseXClosed[m]` of §4.1 (superseding the `NIntegrate`-based `riseXApprox` of §4), while the one exact
known prime `p = Log[Prime[m+1]]` is still supplied:

$$
\boxed{\;\widehat{q} = q\text{HatB}(m) := -\dfrac{B(m)}{A\big(m,\ \log(\text{Prime}[m{+}1]),\ \text{riseXClosed}(m)\big)}\;,\qquad \widehat{\text{Prime}[m{+}2]} = e^{\widehat q}\;}
$$

using the exact `A`, `B` from §1 Bonus with `rX := riseXClosed(m)` (§4.1's closed-form antiderivative —
no prime table, no `NIntegrate`) and `p` the one true known prime. Equivalently, verbatim in the user's
original notation:

```mathematica
Exp @ q /. Solve[errf[m, Log@Prime[m+1], q] == 0, q] /. riseX[m] -> riseXClosed[m]
```

(concretely: substitute `riseXClosed[m]` for the `riseX[m]` term inside `errf`'s definition — the formula
shape is untouched, only that one input switches from an exact sum to the §4.1 closed form.) 🔬 End-to-end
verified: predictions from `riseXClosed` match the `riseXApprox`/`NIntegrate` pipeline's B-column
predictions in §6 to displayed precision at every tested `m`.

## 6. Four pipelines, compared — 🔬 NUMERICALLY VERIFIED

**A** = errf(true riseX, true p) · **B** = errf(approx riseX, true p, §5) · **C** = errf(approx riseX,
approx `p = Log[liInv[m+1]]`) · **D** = classical `liInv[m+2]` (no local information at all):

| m | true `Prime[m+2]` | A rel.err | B rel.err | C rel.err | D rel.err |
|---|---|---|---|---|---|
| 10 | 37 | −4.31% | −4.31% | −31.34% | −28.15% |
| 50 | 239 | −0.489% | −0.187% | −12.78% | −12.29% |
| 200 | 1231 | 0.272% | 0.307% | −5.08% | −4.92% |
| 1000 | 7933 | 0.00061% | 0.0033% | −1.955% | −1.917% |
| 5000 | 48623 | 0.00586% | 0.00606% | −0.832% | −0.823% |
| 20000 | 224759 | −0.00377% | −0.00375% | −0.291% | −0.289% |

**Reading:**
- **A ≈ B at every `m`** (agreeing to 4–5 significant figures throughout): swapping in the prime-free
  `riseXApprox` for the exact prime-table sum costs almost nothing, *as long as the one exact prime `p`
  is still supplied*. `errf` is only mildly sensitive to `riseX(m)`'s precise value — its coefficient is
  a bounded `O(1)` quantity (§1), so an approximate `riseX` just adds a small, non-accumulating bias.
- **C ≈ D at every `m`** (agreeing to 3–4 significant figures): strip out the one exact prime too, and
  `errf` collapses onto the classical `Li⁻¹` estimator — it cannot beat it, because with no exact datum
  left there is no information source beyond what `Li`/PNT asymptotics already encode.

## 7. The adversarial check — does `errf` really beat gap independence? 🔬 verified, hypothesis rejected

**The question this session started from:** classically, once `Prime[m+1]` is known, the gap to the next
prime is (heuristically, Cramér-model) close to independent of the earlier prime history — so how does
`errf` (pipeline A) land 10–1000× closer to `Prime[m+2]` than the classical `liInv[m+2]` estimator (D)?

**Self-adversarial check (per this repo's protocol — "can I use this WITHOUT computing the target
variable", "am I measuring the right thing"):** pipeline D is the *wrong baseline*. It uses **zero**
local information — no prime near `m` at all. Of course a scheme fed the exact value of `Prime[m+1]`
beats a scheme fed nothing. The fair test is against classical estimators that *also* get exactly one
known prime, `p = Prime[m+1]`, and nothing else:

- `recalibrated[m] := Prime[m+1] + (liInv[m+2] - liInv[m+1])` — known prime + the global `Li⁻¹` curve's
  local step.
- `localLiStep[m]` — known prime + integrate the Li-density `1/Log(x)` until exactly 1 expected prime
  has accumulated (the literal Cramér/Poisson-process step from the known point).
- `naiveGap[m] := Prime[m+1] + Log[Prime[m+1]]` — known prime + the textbook average gap, no integral.

🔬 **Result** (relative error vs. truth; A = errf(true riseX, true p)):

| m | A (errf) | recalibrated | localLiStep | naiveGap | D classical |
|---|---|---|---|---|---|
| 10 | −4.31% | −7.52% | −6.79% | −6.94% | −28.15% |
| 50 | −0.489% | −0.279% | −0.225% | −0.230% | −12.29% |
| 200 | 0.272% | 0.411% | 0.416% | 0.415% | −4.92% |
| 1000 | 0.00061% | 0.0373% | 0.0375% | 0.0375% | −1.917% |
| 5000 | 0.00586% | 0.0140% | 0.0140% | 0.0140% | −0.823% |
| 20000 | −0.00377% | −0.00164% | −0.00164% | −0.00164% | −0.289% |

Two things settle it:

1. **The three classical local-calibration competitors are nearly indistinguishable from each other**
   (agreeing to 4+ significant figures at every `m`) — they are, unsurprisingly, the same idea in three
   notations: "known prime + local density."
2. **`errf` is *not* uniformly better than them.** It wins clearly at `m=10,1000,5000` (up to ~60× smaller
   error at `m=1000`), but *loses* at `m=50` and `m=20000` (by ~2×). No consistent direction, magnitude
   fluctuating over roughly the same range in both directions.

**❌ Hypothesis rejected: `errf` shows no evidence of beating local-density (Cramér-model) prediction.**
The apparent 10–1000× "magic" over `liInv[m+2]` (§6, column D) is entirely the value of the one exact
known prime, which any reasonable local-density argument captures equally well. `riseX`'s smoothness
matters only in that it makes the `diffX=0` ansatz well-posed (a small, controlled bias term in `A(m,p,
rX)`, §1) — it does not smuggle in extra predictive content about `Prime[m+2]` beyond what the immediate
neighbor already gives for free. This is consistent with — not a violation of — prime-gap
unpredictability: once the fair baseline is used, the residual scatter of all four estimators sits in
the same noise band, exactly where Cramér-type heuristics put it.

Script: [`scripts/05-adversarial-local-calibration.wl`](scripts/05-adversarial-local-calibration.wl).

**Update (same day):** the "occasional wins" left open below are now fully explained — see §9: they are a
deterministic median-vs-mean loss trade on the skewed gap distribution, not prime information.

## 8. Why *is* `riseX` so predictable, despite summing over all primes? — 🔬 mechanism verified

Three layers, each tested in [`scripts/07-why-smooth-decomposition.wl`](scripts/07-why-smooth-decomposition.wl):

**(a) Log-compression at the term level.** Each summand `a_n = n/Log[Prime[n]]` feels its prime only
through a logarithm: shifting `p_n` by a whole average gap (`g ≈ log p`) changes `a_n` by relative
`(g/p)/log p ≈ 1/p` — `1.3×10⁻⁴` at `n=1000`, `9.5×10⁻⁶` at `n=10000`. The terms are already 99.99%
smooth *before* any summation.

**(b) Second-differencing a ratio localizes the history.** From the exact §1 identity, the accumulated
sum enters `diffX` only through `R(m)·B_R` with

$$B_R = \tfrac12 + \frac{D(m)}{2D(m+2)} - \frac{D(m)}{D(m+1)} \;\approx\; \Big(\frac{D'}{D}\Big)^2 - \frac{D''}{2D},$$

a pure *curvature statistic of the denominator*. For `D = Log·Li`: `B_R = 9.3×10⁻⁷` at `m=1000`,
falling like `~1/m²`. The **smooth** part of the history (`R·B_R ≈ 4.6×10⁻⁵` at `m=1000`) participates in
a large designed cancellation against the smooth local terms (net `diffX ~ 10⁻⁶` — this cancellation is
exactly what the closed-form model reproduces); the **fluctuating** part of the history enters only as
`δR·B_R ~ 10⁻⁸` — negligible. So "accumulating all primes" is a feature: the sum's history acts as a
slowly-varying calibration, not as noise. This also *quantitatively* explains the §3 PrimePi break: with
`D = Log·PrimePi`, the same bracket jumps to `B_R^{PP} ≈ 0.04` at prime-adjacent `m`, and `R·B_R^{PP} ≈
0.11–0.12` — matching the observed `diffXPP ≈ 0.15` spikes.

**(c) What's left is 2/3 boundary gap noise, 1/3 smooth curvature.** Replacing every `Prime[n]` by its
smooth Cramér position `Li⁻¹(n)` gives a fully smooth discrete model whose second difference `dXm`
isolates the systematic part; the residual `dX − dXm` is pure prime noise, sourced *only* by the two
newest terms. Windowed statistics (`m₀±100`):

| m₀ | mean systematic `dXm` | stdev of noise | ratio noise:systematic |
|---|---|---|---|
| 1000 | −1.92×10⁻⁶ | 4.14×10⁻⁶ | 2.2 |
| 5000 | −3.03×10⁻⁷ | 6.18×10⁻⁷ | 2.0 |
| 10000 | −1.37×10⁻⁷ | 2.83×10⁻⁷ | 2.1 |

The noise residual is **identical for `den=m` and `den=Log·Li`** (correlation 0.999997, sizes matching
after normalization): the denominator choice shapes only the smooth part (Li's systematic is ~1.5×
smaller than `m`'s at matched `m`). And the closed-form model `dXcf` (from §4.1's `G`, plus the
Euler–Maclaurin half-term `a(m)/2`) matches the discrete smooth model to ~0.1% — **the systematic part of
`diffX` is available in closed form.** Empirically `dXcf ≈ −c/(p_m·log p_m)` with `c` drifting
`0.10 → 0.17` over `m = 200..10000` (see §9 for why this constant is interesting).

## 9. Using it better: the model-corrected ansatz, and the resolution of the A-vs-Cramér puzzle — 🔬

Since the systematic part of `diffX` is in closed form, the obvious upgrade to "assume `diffX = 0`" is
"assume `diffX = dXcf`" — still closed-form, one extra term in the §1 solve:

$$\widehat q_{A1} = \frac{B(m)}{\text{dXcf}(m{+}1) - A(m,p,r_X)}.$$

Hypotheses stated before running ([`scripts/08`](scripts/08-model-corrected-estimators-scan.wl)): (H1)
noise dominates 2:1, so ≤20% RMS gain; (H2) once model-corrected, the denominator choice is irrelevant;
(H3) nobody beats the boundary-gap noise floor. Systematic scan, `m = 500..5000` step 25 (181 values),
all estimators given primes ≤ `Prime[m+1]`:

| estimator | median \|rel err\| | RMS rel err | median \|err\|/gap | signed median |
|---|---|---|---|---|
| A0: `errf=0` (original) | **1.42×10⁻⁴** | 4.75×10⁻⁴ | **0.454** | −2.9×10⁻⁵ |
| A1: `errf=dXcf` | 1.81×10⁻⁴ | 4.61×10⁻⁴ | 0.584 | +6.3×10⁻⁵ |
| A1m: same, `den=m` | 1.81×10⁻⁴ | 4.61×10⁻⁴ | 0.584 | +6.2×10⁻⁵ |
| A3: third difference = 0 | 2.59×10⁻⁴ | 8.00×10⁻⁴ | 0.668 | +1.3×10⁻⁴ |
| L: localLiStep (Cramér) | 1.80×10⁻⁴ | **4.59×10⁻⁴** | 0.567 | +1.1×10⁻⁴ |
| Ng: naiveGap `p+log p` | 1.80×10⁻⁴ | 4.59×10⁻⁴ | 0.567 | +1.1×10⁻⁴ |

Findings:

1. **A1 collapses exactly onto the Cramér baseline** (all metrics equal to L within noise), and A1m ≡ A1
   to `10⁻⁷` (H2 ✅ — with the model correction explicit, `den=Log·Li` is not special; any smooth
   denominator gives the *same* estimator). Reading: the model-corrected `errf` **is** the local-density
   step, derived through the `riseX` machinery — one closed formula, no integral, no root-find except
   `Li⁻¹`.
2. **A0's median advantage over L is real (21%) but is a loss-function artifact, not information**
   ([`scripts/09`](scripts/09-median-shift-mechanism.wl)): the gap distribution is right-skewed
   (median/mean gap = 0.66 ≈ `ln 2` — near-exponential), L targets the *mean* gap (signed median error
   +1.1×10⁻⁴), so any downward shift improves the median. A0 = A1 minus the deterministic shift
   `s = 2pq·|dXcf|·D₀(m+2)/(m+2) ≈ 0.30–0.37` gap-units in the scan range (script 09's printed spot
   values, 0.24–0.32, omitted the `D₀/m ≈ 1.13–1.24` factor — corrected in §10) — passing through the
   exponential-gaps optimum `1−ln 2 = 0.307` near the low end of the scan, and near the empirical
   optimum `s* = 0.22` (which takes L's median to 1.33×10⁻⁴, *better* than A0's 1.42×10⁻⁴).
   **This resolves §7's open question**: A0's scattered wins/losses against the local competitors were
   this fixed median-shift interacting with the skew — deterministic, explainable, and dominated by an
   explicit shift.
3. **Nobody resolves the next gap** (H3 ✅): median |err|/gap is 0.45–0.67 for every estimator — all of
   them predict the *position scale*, none the actual gap.
4. A3 (third difference: kills the smooth part with no model, like Richardson) pays ~2× noise
   amplification — strictly worse. H1 ✅ in refined form: the RMS gain of A1 over A0 is 3% (noise
   dominates); the *median* differences are all shift effects.

**Practical upshot:** for RMS loss, use A1 (= Cramér baseline, now as one closed formula); for
median/typical-case loss, use L (or A1) with an explicit downward shift `s ≈ 0.22·log p/p` — it beats
A0's implicit shift. The `riseX` construction's real deliverables are (i) the mechanism of §8, and (ii)
the closed-form systematic `dXcf`, whose asymptotics — including whether the shift tends to `1−ln 2` —
is settled in §10.

## 10. The shift constant: `s → 1/2` exactly — ✅ derived, 🔬 verified to `m = 10⁴⁰`

The question left open above: A0's built-in downward shift (in mean-gap units)

$$s(m) \;=\; 2\,p\,q\,\big|\text{dXcf}(m{+}1)\big|\cdot\frac{D_0(m{+}2)}{m{+}2},\qquad p = p_{m+1},\ q=\log p$$

drifts upward through `1−ln 2 = 0.3069` in the scan range — is that its limit (making A0 asymptotically
median-optimal for exponential-model gaps)? Because everything is closed-form, this is answerable *both*
ways, with no primes involved anywhere ([`scripts/10`](scripts/10-shift-constant-derivation.wl)):

**Numerically at absurd heights.** `s(m) = −y·u·R''(m)·D₀(m)/m` with `y = Li⁻¹(m)`, `u = log y`, and
`R''` obtained by exact symbolic differentiation of `R = (G(y(t)) + t/(2 log y(t)) − 1)/(log t·Li(t))`
using the implicit rule `y'(t) = log y(t)` — evaluable at any `m` (60-digit working precision; the
discrete `dXcf` route agrees to 5×10⁻⁶ at `m=5000`):

| m | 5×10³ | 10⁶ | 10⁸ | 10¹² | 10²⁰ | 10³⁰ | 10⁴⁰ |
|---|---|---|---|---|---|---|---|
| `u = log p` | 10.8 | 16.6 | 21.4 | 31.0 | 49.9 | 73.4 | 96.7 |
| `s(m)` | 0.3675 | 0.4231 | 0.4433 | 0.4628 | 0.4779 | 0.4854 | 0.4891 |

Monotone toward `1/2`, decisively *past* `0.307` and never returning.

**Symbolically.** Substituting the standard `Li` asymptotic expansions (`Li(z) = (z/\log z)\sum k!/\log^k z`)
into the exact `R''` expression — the whole computation done by machine algebra after an error-prone hand
attempt got the constant right but the next coefficient wrong — gives, with `u = log p`, `ℓ = log u`:

$$\boxed{\;s(u) \;=\; \frac12 \;-\; \frac{1}{u} \;-\; \frac{\ell + \tfrac34}{u^{2}} \;+\; O\!\Big(\frac{\ell^2}{u^{3}}\Big)\;}$$

The series matches the exact values to 4 significant digits by `m = 10³⁰` (0.48543 vs 0.48544) and is
already within 3% at `m = 5000`. Equivalently, for the smooth second difference itself:
`dXcf(m) ~ −1/(4·p·log p)·(1 − 2/log p − …)` — the empirical "constant" `c` of §8, measured drifting
`0.10 → 0.17`, is `c = s/(2·D₀/m)` (= 0.168 at `m=10⁴`, matching) and tends to **1/4**.

**Verdict on the loose end:** ❌ `s → 1−ln 2` is FALSIFIED; `s → 1/2` exactly, from below, at the slow
rate `1/log p`. The transit through `0.307` happens around `m ≈ 500–1000` — precisely the scan window —
so A0's near-median-optimality in §9 was a numerical coincidence of scale, not structure.

**Interpretation (the cute part):** since A0's prediction is `L`'s prediction minus `s·ḡ`, and `L`
targets `p + ḡ` (one accumulated unit of Li-density = one mean gap), A0 asymptotically targets

$$\widehat{p}_{A0} \;\to\; p + \tfrac{\bar g}{2}$$

— **the midpoint of the expected gap interval**. The zero-second-difference ansatz is, in the limit, a
midpoint rule: it splits the difference between "the next prime is here" (`p`) and "the next prime is one
mean gap away" (`p + ḡ`). The median-optimal target for exponential-model gaps would be `p + (\ln 2)ḡ ≈
p + 0.69ḡ`; A0 crosses that target region on its way to the midpoint, which is why it briefly looked
median-optimal.

## 11. The packaged estimator — and dropping the numerical inverse entirely

**The deliverable.** Given `m` and the one known prime `p = Prime[m+1]`, predict `Prime[m+2]` with the
*unbiased* ansatz (`errf = dXcf`, §9), everything closed-form. First version
([`scripts/11`](scripts/11-final-estimator.wl)) uses `Li⁻¹` at the three integer arguments `{m, m+1, m+2}`
(the only numerics) and reproduces the Cramér-step accuracy exactly (CF-vs-L relative difference
`4×10⁻⁵ → 3×10⁻⁷` from `m=1000` to `20000`; scan medians equal).

**Do we still need the numerical inverse? No.** Two observations kill it
([`scripts/12`](scripts/12-inversion-free-estimator.wl)):

1. `Li⁻¹(m)` is needed only inside `rX` (tolerance ~1%, §6) — and the known prime `p` is itself a
   fluctuation-level sample of `Li⁻¹` right next to the target. Two *explicit* Newton steps seeded at `p`
   (forward `LogIntegral` only) give `y = Li⁻¹(m)` to `5×10⁻⁹` relative at `m=200`, `10⁻¹⁴` at `m=20000`.
2. `eps = dXcf(m+1)` — the one quantity that needed `Li⁻¹` at high precision — is exactly what §10
   derived in closed form: `eps = −s(u)·(m+2)/(2yu·D₀(m+2))` with `s(u) = 1/2 − 1/u − (log u + 3/4)/u²`.

The session eats its own tail: the asymptotic series derived out of curiosity (§10) is what removes the
last root-finder. The result is a **single explicit formula in `Log`/`LogIntegral`** — no `FindRoot`,
no `NIntegrate`, no prime tables beyond the one input prime:

```mathematica
GcfP[x_] := LogIntegral[x]^2/2 - x LogIntegral[x]/Log[x] + 2 LogIntegral[x^2] - x^2/Log[x];

nextPrimeCF2[m_, p_] := Module[{d0, q, y, u, rX, eps, A, B},
   d0[k_] := N[Log[k] LogIntegral[k]];
   q = Log[N[p]];
   y = p - (LogIntegral[N[p]] - m) q;              (* Newton for Li(y) = m, seeded at the known prime *)
   y = y - (LogIntegral[y] - m) Log[y];            (* second explicit step: y to ~1e-9 relative *)
   u = Log[y];
   rX = (GcfP[y] + m/(2 u) - 1)/d0[m];             (* smooth riseX[m], prime-free *)
   eps = -(1/2 - 1/u - (Log[u] + 3/4)/u^2) (m + 2)/(2 y u d0[m + 2]);   (* section-10 series *)
   A = (m + 1)/q (1/(2 d0[m + 2]) - 1/d0[m + 1]) +
     rX (1/2 - d0[m]/d0[m + 1] + d0[m]/(2 d0[m + 2]));
   B = (m + 2)/(2 d0[m + 2]);
   Exp[B/(eps - A)]];
```

Variants: `eps = 0` gives the raw A0 ansatz (midpoint-targeting, §10; better median in the `m ~ 10³`
window, worse RMS); subtracting `0.22 Log[p]` from the result gives the median-tuned version (§9).

🔬 Verification (script 12): CF2 vs the `Li⁻¹`-based CF agree to `3×10⁻⁵` (m=1000), `3×10⁻⁶` (m=5000),
`5×10⁻⁷` (m≥20000) — always far below the estimator's intrinsic error; against truth at `m=10⁵`:
relative error `−6.0×10⁻⁶` (CF: `−6.3×10⁻⁶`). Cost of the series truncation at the small-`m` end: scan
median (m=500..5000) `1.98×10⁻⁴` vs CF's `1.85×10⁻⁴` (+7%), converging to identical above `m ≈ 5000`.
Machine precision suffices to `m ~ 10⁶` (§2); pass higher-precision inputs beyond that.

**Honest framing:** statistically this *is* the Cramér local-density step (§9) — and that step is, to
leading order, nothing but `p + log p` (§7's `naiveGap`). Measured deviation of `nextPrimeCF2` from
`p + log p`: 0.065 mean gaps at `m=1000`, 0.014 at `m=20000`, 0.008 at `m=10⁵` — vanishing, against an
irreducible gap noise of ~1. The one member of the family that genuinely differs from `p + log p` is the
raw `errf=0` ansatz: `−0.30 → −0.40` gaps and tending to `−1/2` (the §10 midpoint theorem, i.e.
`p + log(p)/2`). The estimator's value is the explicit algebraic form and the derived structure
(`G`, `s(u)`, the `Li`-conjugacy), not extra accuracy.

## 12. What the `(m, p)` pairing knows about `Prime[]`: `Li` is the conjugacy — 🔬

The estimator's input is a point on the graph of `Prime[]`. Question: does the *pairing* itself let one
derive something about the prime function? Answer ([`scripts/13`](scripts/13-li-conjugacy-invariant.wl)):
yes — its smooth skeleton, exactly and provably nothing more.

**In the coordinate `ν = Li(p)`, the estimator family is a translation.** Measured `Li(pred) − Li(p)`:

| | m=200 | m=1000 | m=5000 | m=20000 | m=10⁵ |
|---|---|---|---|---|---|
| unbiased (CF2) | 1.167 | 1.065 | 1.030 | 1.014 | 1.008 |
| raw `errf=0` | 0.839 | 0.704 | 0.645 | 0.615 | — |
| `1 − s(u)` (§10 series) | 0.694 | 0.648 | 0.620 | 0.603 | — |

The unbiased map → **unit translation** `ν → ν+1` (the Cramér step `L` is *exactly* that, by definition;
the finite-`m` excess is precisely CF2's approximation error vs `L`, in Li-units). The raw ansatz →
translation by `1 − s(u) → 1/2`: the §10 midpoint theorem restated — **A0 is asymptotically the
half-unit translation**. Displacing the input `p` off the true prime by ±3 mean gaps changes the
translation by only ~0.2% per gap (m=1000): to leading order the map sees the pair only through `ν`.

**Conserved quantity and invariant family.** Unit translation in `ν` conserves `C := Li(p) − m`; the
invariant manifolds are the level curves `x(m) = Li⁻¹(m + C)` — a one-parameter family of "smooth
prime-like sequences", of which the machinery cannot prefer any member. Chaining the recurrence 500
steps from a true prime seed (m₀=20000): the orbit's `C` drifts by +7.1 Li-units — matching the
accumulated per-step approximation excess (0.0139 × 500 ≈ 7.0), i.e. pure finite-size bias — while the
*true* primes drifted by −11.7 Li-units over the same stretch. Neither tracks the other.

### 12.1 A low-m illusion: the mis-call `nextPrimeCF2[m, Prime[m]]` "returning `Prime[m+2]`"

Passing `Prime[m]` in the slot that expects `Prime[m+1]` appears, at `m = 25..28`, to return `Prime[m+2]`
dead-on (predictions 103.7, 107.7, 109.3, 113.3 vs true 103, 107, 109, 113). 🔬 Artifact, two ingredients
([`scripts/14`](scripts/14-miscall-low-m-artifact.wl)):

1. **Finite-size excess translation.** The map advances the input by `T(m)` Li-units with `T → 1` (§12),
   but at `m ≈ 25` the excess is large: `T ≈ 1.33–1.46` (vs 1.065 at `m=1000`, 1.014 at `m=20000`).
2. **The 97..113 dense cluster.** Local gaps there are `{4,2,4,2,4}` — mean 3.2 ≈ `0.7·ḡ` (`ḡ = log p ≈
   4.6`). So the advance `T·ḡ ≈ 1.4×4.6 ≈ 6.4` equals *exactly two local gaps* (4+2) on that stretch.

The streak breaks immediately at `m = 29, 30` (predictions 115.0, 118.9 vs `Prime[m+2]` = 127, 131 — the
gap of 14 after 113 ends the cluster). Statistics over 100 consecutive `m` at three heights: primes
actually passed by the prediction tally as `{0: 27, 1: 55, 2: 18}` at `m~25–124`, `{0: 40, 1: 51, 2: 9}`
at `m~1000`, `{0: 34, 1: 44, 2: 18, 3: 3, 4: 1}` at `m~20000` — centered on **one** prime passed, mean
exactly `T`; and the median distance to `Prime[m+1]` beats the distance to `Prime[m+2]` at every height
(0.53 vs 0.77 mean gaps at `m=20000`). The mis-call targets `Prime[m+1]`, as the §12 translation law
requires; the `+2` run at `m=25..28` is `T≈1.4` colliding with a `0.7·ḡ` cluster.

**Conclusion.** What the pairing derives about `Prime[]`: the exact smooth skeleton — the `Li` level-curve
family, the unit-translation law, and the exact constants (`1`, `1 − s(u)`, midpoint `1/2`). What remains
is the walk of `C(m) = Li(p_m) − m`, which is *literally* the PNT error term `Li − π` in disguise —
the explicit-formula/zeta-zero channel, and exactly the content §7 proved invisible to this machinery.
So the pairing yields analysis (the smooth inverse of `Li` as the unique invariant family), and the
arithmetic of `Prime[]` lives entirely in the drift the recurrence cannot see.

## 13. The Occam verdict: is the deviation from `p + log p` signal? — 🔬 anti-aligned, and it's old news

§11 noted `nextPrimeCF2` differs from plain `p + log p` by a vanishing 0.008–0.065 mean gaps. Question
(the right one to ask): is that deviation `d` *correlated with the true error* `e` of `p + log p` — in
which case it could be amplified — or is it noise, in which case Occam hands the win to `p + log p`?

Hypothesis stated before running: `corr ≈ 0` (the §7 information argument). **Wrong, twice over** —
and the resolution is a textbook lesson ([`scripts/15`](scripts/15-occam-signal-test.wl),
[`scripts/16`](scripts/16-occam-null-control.wl); `n = 2251`, `m = 500..5000`):

1. **In-sample, window-demeaned: `corr(d, e) = −0.181`** — highly significant (threshold 0.042) and
   *negative*. But `d` is essentially a deterministic function of `C = Li(p) − m` (slope ≈ +0.0023
   gaps per gap of displacement, §12 test 2; `stdev(d_resid) = 0.0025` gaps ✓), and `C` random-walks —
   **window-demeaning a walk mechanically induces negative level-vs-next-increment correlation** (the
   window mean contains the future). Null control (identical pipeline on synthetic primes with iid
   exponential gaps, zero signal by construction): `corr = −0.108`. So **60% of the effect is a
   demeaning artifact.**
2. **The genuine remainder is ≈ −0.10 and it is not ours.** Causal version (trailing-window demeaning,
   no future leakage; null gives +0.008 ✓ clean): `corr = −0.105`. Detrended single-pair channel
   `corr(e, C_fast) = −0.105`. Direct autocorrelation of consecutive normalized gaps, no machinery at
   all: **−0.095**. All three are the same thing: the known *mean-reversion of prime gaps* (a locally
   high `C` = recent large gaps → next gap slightly smaller — the rigidity of the `C`-process). Its full
   out-of-sample worth: **0.32% RMS improvement**, with fitted `λ* = −26`.
3. **The sign is against us.** `d` *increases* with `C_fast` while the conditional mean of the next gap
   *decreases* with it — the estimator's deviation from `p + log p` points in the **wrong direction**
   (hence `λ* < 0`). Exploiting the channel means flipping the sign, at which point one is just running
   a previous-gap autocorrelation regression that never needed `riseX`, `G`, or `errf`.
4. Strictly one known prime (no neighbors, no trailing window): the usable channel is `corr(e, C_raw) =
   −0.068` — marginal, and inseparable from the unpredictable slow `π−Li` wander without more data.

**Verdict: Occam holds.** For point prediction, `p + log p` (mean loss) or `p + log(p)·(1−s)` →
`p + log(p)/2` (median loss, §10) is the entire content; the deviation of the algebraic machinery from
it is deterministic, tiny, and anti-informative. The closed form's justification is §8–§12 (mechanism,
exact constants, `Li`-conjugacy) — structure, not prediction.

## 14. From scratch: the next-prime formula at great heights — the constructive answer

Given everything above, the clean five-step derivation of the next-prime estimate after a known huge
prime `P` (the Mersenne use-case), with each step's provenance
([`scripts/17`](scripts/17-next-prime-from-scratch.wl)):

1. **Density.** `λ(x) = 1/log x` (PNT). RH's role here: it controls the *smooth* count's error
   (`π = Li + O(√x log x)`), i.e. certifies the intensity — it does not localize individual primes.
2. **Point process.** Primes above `P` form (asymptotically) an inhomogeneous Poisson process with
   intensity `λ` — that is Gallagher's theorem (under the uniform Hardy–Littlewood conjecture), and §13's
   measurements bound the largest deviation from independence at accessible heights: consecutive-gap
   correlation `≈ −0.1`, worth 0.3% RMS.
3. **Survival function.** `P(no prime in (P, P+h]) = exp(−[Li(P+h) − Li(P)])` — closed form, the same
   `Li`-translation structure as §12.
4. **The estimator family** (α-quantile: solve `Li(P+h) − Li(P) = ln(1/(1−α))`; expansions with
   `q = log P`):

$$\widehat{P}'_{\text{mean}} = \text{Li}^{-1}(\text{Li}(P)+1) = P + q + \frac{q^2}{2P} + O\!\Big(\frac{q^3}{P^2}\Big),\qquad
\widehat{P}'_{\alpha} = P + q\,\ln\frac{1}{1-\alpha},$$

   so: mean `P + q`; median `P + q·ln 2 ≈ P + 0.693q`; 95%-upper `P + q·ln 20 ≈ P + 3.0q`. (§10/§12 in
   this language: the Cramér step is the mean; the raw `errf=0` ansatz targets `P + q/2`, between nothing
   and the median.) Fine structure — even gaps, Hardy–Littlewood singular-series weights, jumping
   champions (primorials) — reshapes the distribution at `O(1)`-gap scale but moves these location
   estimates negligibly.
5. **Uncertainty, honestly split.** Systematic error of the formula: `O(q²/P)` relative to the gap —
   at Mersenne heights `~10^{−41,000,000}`, i.e. *perfect in every computable digit*. Statistical error:
   `±q` (one full gap, sd of the exponential) — *irreducible* (§7/§13: no function of `P` and the index
   can shrink it; even neighboring primes buy 0.3%). RH's genuine contribution is the **hard certificate**
   `P' − P = O(√P log P)` (Cramér 1919) — a guaranteed window, but astronomically wider than the
   probabilistic one (`10^{2×10⁷}` digits of window vs `10⁸` for the record Mersenne). Cramér–Granville
   conjectured worst case: `≈ 1.12·q²`.

   *State of the art on the certificate (checked 2026-07-10):* 📖 the RH-conditional window is now
   **explicit**: under RH there is a prime in `[x, x + (22/25)√x log x]` for all `x ≥ 4`
   (Carneiro–Milinovich–Soundararajan, Comment. Math. Helv. 2019, via Fourier optimization; asymptotic
   constant since pushed to ~0.84–0.8358, arXiv:2411.05095). Adding Montgomery's pair-correlation
   conjecture to RH shaves a `√log`: `≪ √(p log p)` (Heath-Brown 1982), and `F(α)∼1` would give
   `o(√x log x)` — but the `√x` *shape* is the explicit-formula method ceiling; ninety years of work
   have moved only constants and log-powers. Unconditionally: gaps `≪ p^{0.525}`
   (Baker–Harman–Pintz 2001; a 2023–25 Harman-sieve preprint, arXiv:2308.04458, claims `0.52`), and the
   2024 Guth–Maynard large-values/zero-density breakthrough (Annals 2026) gives the PNT *asymptotic* in
   all intervals `x^{17/30+ε}` (first improvement of Huxley's `7/12` in decades) — progress on a
   different axis, still `x^{0.52+}`-scale for worst-case gaps. On the lower-bound side, gaps
   `≫ log X·log₂X·log₄X/log₃X` occur (Ford–Green–Konyagin–Maynard–Tao, J. AMS 2018). None of this
   changes the §15 picture: even the *conjectured*-best certificate (`~1.12 q² ≈ 10^{16}` for the record
   Mersenne) is `10⁸×` wider than the expected next-prime location.

🔬 High-height validation (consecutive-prime gaps sampled via `NextPrime`, decorrelated entry): at
heights `10⁹, 10¹², 10¹⁵, 10¹⁸`: `mean/log P = 0.980, 0.994, 0.976, 0.969` (se 1.5–3.9%) — consistent
with 1, and at the lower heights inconsistent with the classic confusion `log P − 1` (that's the
*cumulative* average gap up to `x`, not the local mean); `median/mean = 0.79, 0.73, 0.71, 0.75` drifting
toward `ln 2 = 0.693`; `q90/mean = 2.07–2.31` vs Poisson `ln 10 = 2.303`.

**Worked example — the record Mersenne** `P = 2^{136279841} − 1`, `q = 136279841·ln 2 = 9.446×10⁷`:
mean-optimal next prime `P + 9.45×10⁷`; median `P + 6.55×10⁷`; 95% within `P + 2.83×10⁸`; sd `±9.4×10⁷`.
Practical footnote: *verifying* the prediction would take `~q/2 ≈ 4.7×10⁷` PRP tests of 41-million-digit
numbers — the formula is not just the best statement available, it is the only one there will ever be.

## 15. Postscript: provability at the target — why no "factored" candidate can live in the window

Follow-up question: at Mersenne heights general primality *proof* is impossible (📖 ECPP ceiling
~10⁵ digits; AKS worse), so could one combine the search with numbers of known `N±1` factorization —
i.e., *construct* a factored-neighborhood candidate near the predicted location? Answer: no, and the
obstruction is quantifiable. All claims 📖 standard (Pocklington, BLS75, Konyagin–Pomerance/CHG, LLR)
plus counting arguments — no computation needed.

1. **Factorization is not translation-invariant.** `P = 2^q − 1` has fully factored `P+1 = 2^q` (that's
   why Lucas–Lehmer works), and `P−1 = 2(2^{q−1}−1)` even has rich algebraic (Cunningham) structure. All
   of it is destroyed by adding `δ`: the candidate `N = P + δ` has `N±1 = 2^q − 1 + δ ± 1`, and no factor
   of `2^q ± c` survives a shift. Knowing the neighbor's factorization buys *nothing*.
2. **Provable numbers form lattices coarser than `N^{1/3}`.** Every classical proof route needs a fully
   factored part `F ≥ N^{1/3}` of `N−1`, `N+1`, or a CRT combination (📖 BLS75; `N^{0.3}` with CHG).
   Prescribing `F | N∓1` fixes `N` on an arithmetic progression of spacing `F ≥ N^{1/3}` — for the record
   Mersenne, spacing `~10^{13,700,000}`, versus a next-prime window of width `~3×10⁸`. The chance a
   provable-form lattice point lands in the window: `~10^{−13,699,991}`. One cannot *construct* into the
   window; the constructible-provable frontier is distance `~N^{1/3}` from any prescribed target
   (equivalently: the leading ~2/3 of the digits can be matched, via CRT on `F₁ | N−1, F₂ | N+1`).
3. **The window's one structured visitor dies mod 3.** For any Mersenne `2^q − 1` (`q` an odd prime), the
   unique in-window candidate with fully factored `N−1` is `N = 2^q + 1` (`N−1 = 2^q`, Proth-perfect) —
   and `q` odd forces `3 | 2^q + 1`. The provable universe enters the gap window exactly once, and misses.
   (Primorial cousin: `p# + 1` — the rare case δ=1 *is* the next prime and then provable; Fortune's
   conjecture territory.)
4. **What is actually feasible.** Per-candidate PRP at 41M digits ≈ days (GIMPS-scale). Sieving the
   `~9.4×10⁷`-wide expected stretch to depth `10¹²` leaves `q·ln 2/(e^γ ln 10¹²) ≈ 1.9×10⁶` PRP
   candidates to the expected next prime — a decade-scale distributed project, whose prize would be a
   **forever-unprovable PRP**. Alternatively, the same `~2×10⁶`-test budget spent on the CRT-BLS lattice
   yields a **proven** prime agreeing with the target in the leading ~2/3 of its 41M digits. Pick one:
   the true neighbor you can never prove, or a provable prime that is astronomically not the neighbor.
5. **And in the provable route, the location estimate is worth exactly nothing.** The prediction
   `P + q·ln 2` is the *mean of a waiting-time distribution*, not a density bump: the Poisson intensity
   `1/log x` is flat across the whole neighborhood (indeed the waiting density `e^{−h/q}/q` is monotone
   *decreasing* — the single most likely location of the next prime is the first sieve survivor right
   after `P`). Lattice points of a provable form near the "expected location" are just generic integers
   of that size; conditioning on the estimate changes no candidate's prime probability. So a provable
   41M-digit prime is a fine prize (it would be the largest known non-Mersenne prime by ~3×, at roughly
   one GIMPS-year of compute) — but one would place the lattice wherever sieving is most convenient and
   ignore §14 entirely. The estimate's only genuine uses: *budgeting* the true-next-prime hunt (expected
   test count, stopping quantiles) and *anomaly-testing* a gap once found — order statistics, not
   targeting.

## 16. Combining the α-quantile continuum with the even-gap comb — 🔬 the HL hazard does it

The quantile-normalized gap `ngap[p, α] = (NextPrime[p] − p)/(log(1/(1−α))·log p)` satisfies (Poisson
model) `P(ngap ≤ t) = 1 − (1−α)^t`, so `ngap = 1` marks the α-quantile. 🔬 Calibration at height `10⁹`
(n = 6000): fraction with `ngap ≤ 1` = **0.493, 0.752, 0.912** at α = 0.5, 0.75, 0.9 — excellent — but
**0.125 at α = 0.25**. The failure is exactly the discreteness: the model's 0.25-quantile is `0.288q ≈
5.96`, and the only gaps below it are `{2, 4}` — which are *under*-weighted teeth (`𝔖(2)=𝔖(4)=1.32` vs
average 2). The comb dominates the lower quantiles; the continuum is fine from the median up.

**The combination hierarchy** ([`scripts/18`](scripts/18-quantile-parity-combination.wl)):

1. *Parity only*: `g = 2·Geometric(2/q)` — right envelope, misses the comb structure badly (predicts
   96.5‰ at g=2 vs actual 64.7‰; 78.8‰ at g=6 vs actual 114.5‰).
2. *Aggregate divisibility* (📖 Hardy–Littlewood; the constant `C₂` and the residue-counting derivation
   of `𝔖` are written up as a standalone learning doc:
   [learning/twin-prime-constant-singular-series.md](../../learning/twin-prime-constant-singular-series.md)):
   hazard chain `P(g=h) = (𝔖(h)/q)·Π_{h'<h}(1−𝔖(h')/q)`
   with `𝔖(h) = 2C₂·Π_{r|h, r>2}(r−1)/(r−2)` — matches the comb tooth-by-tooth (g=2: 63.7‰ pred vs
   64.7‰; g=6: 111.7 vs 114.5; g=30: 46.7 vs 43.3 — the `6|g` doubling and `30|g` boost are the
   jumping-champions mechanism).
3. *Conditioning on the known `p`* — the sharpest: the residues of `p` make teeth **deterministic**.
   🔬 measured: `p ≡ 1 (mod 3)` → gaps `≡ 2 (mod 6)` occur *zero* times (n=2981); `p ≡ 2 (mod 3)` →
   gaps `≡ 4 (mod 6)` zero (n=3019). The aggregate ×2 boost at `6|g` is just the average over the two
   classes, each of which allows `6|g` but only one other residue. In general: the known prime's
   residues mod small `r` delete candidates outright; on the surviving (sieve-admissible) set the gap is
   geometric with rescaled rate — this is the per-`p` predictive object, and operationally it's just the
   sieve every gap-hunt already runs.

**The principled combiner is the probability integral transform**: push each observed gap through the
model's discrete CDF (randomized within the atom: `U = F(g−2) + V·P(g)`); the correct model makes `U`
uniform. 🔬 `χ²/dof` over 20 bins: continuous exponential **98.6** → parity-only **18.2** → HL hazard
**2.80** (residual = known finite-height corrections to the naive hazard at `q ≈ 20.7`). The upgraded
quantile function is the discrete inverse `ĝ_α = min{even g : F_HL(g) ≥ α}` — it repairs the α < 0.5
regime; at Mersenne heights the comb is irrelevant for *location* (tooth spacing 2 vs quantile scale
`10⁸`) but the conditioning-on-residues view is precisely §15's sieve, now derived rather than assumed.

## 17. Combining the gap *theorems* with the hazard model — a no-op in the bulk, a Gumbel layer at the top, and a real finite-height caveat — 🔬

Can the §14-note advances (CMS/RH ceiling, Guth–Maynard, FGKMT) be folded into the few-line hazard model?
([`scripts/19`](scripts/19-theorems-vs-hazard-gumbel.wl), [`scripts/20`](scripts/20-extreme-tail-thinning.wl))

**The theorems are a no-op on the distribution.** The hazard model's mass beyond the RH certificate
`0.88√p·log p` is `~10^{−12,086}` at `p = 10⁹`, `~10^{−3.8×10⁸}` at `10¹⁸` — truncating there (one `Min`)
changes nothing measurable, ever. Theorems and model are complementary, not combinable: certificates
police a worst-case tail the model already declares empty; the model owns the bulk. Nothing to
compensate — from *that* direction.

**The meaningful few-line combination is the extreme-value (Gumbel) layer**: `P(max gap ≤ G) = F(G)^N`
over a window's `N ≈ W/q` gaps, with `F` either exponential or the §16 HL chain. Naive medians for
`W = 10⁶` windows: 224 / 231 / 245 at heights `5×10⁸ / 10⁹ / 4×10⁹`.

**And it exposes a genuine finite-height effect.** 🔬 Observed window maxima: **204 / 176 / 232** —
systematically below the naive Gumbel medians (the `10⁹` case has nominal `p ≈ 5×10⁻⁵` under the naive
model). Tail counts settle it: observed `#(g ≥ 5q, 6q, 7q)` ≈ `{150–170, 41–53, 9–18}` versus naive
`{≈320, ≈118, ≈44}` and versus Wolf's `x/q²` correction `{≈16, ≈6, ≈2}` — the extreme tail is thinner
than exponential by a factor **2–3** (mildly `t`-dependent), of which the HL-comb survival chain already
explains ~×1.5 (second-moment of `𝔖`: `E[𝔖²] ≈ 4.5 > E[𝔖]² = 4`), while Wolf's correction overshoots by
~×7–10 in this regime. The remainder is higher-order (beyond-pairwise) candidate correlations — and 📖
Gallagher's theorem says the naive `e^{−t}` is restored as `x → ∞` at fixed `t`, so the thinning is a
*transient*, echoing this session's recurring motif (the `1−ln 2` coincidence, the `median/mean` drift):
at accessible heights, finite-size corrections are as large as the phenomena themselves. Even this
compensation stays "few lines" — a measured multiplicative tail factor.

**Packaged** ([`scripts/21`](scripts/21-user-pgap-gumbel-layer.wl)): the Gumbel layer on the user's own
`pgap` implementation is four lines (`survHL`, `tailCount`, `maxGapCDF`, `maxGapQuantile`, with the
thinning knob `κ`, default 1). 🔬 Validated: reproduces the script-19 comb-Gumbel median (222) exactly;
with a single calibrated `κ = 0.55` (fit at `t=5`) it *predicts* the `t=6,7` tail counts (47.3 vs 43,
17.9 vs 17 observed) and centers the window maxima; and at the record Mersenne it reproduces the
Cramér–Granville scale (median max gap below `P`: `8.92×10¹⁵ ≈ log²P`).

## References — state of the art on prime gaps (verified 2026-07-10)

- E. Carneiro, M. B. Milinovich, K. Soundararajan, *Fourier optimization and prime gaps*, Comment. Math.
  Helv. 94 (2019), 533–568 — under RH, a prime in `[x, x+(22/25)√x log x]` for all `x ≥ 4`.
  [arXiv:1708.04122](https://arxiv.org/abs/1708.04122), [EMS/CMH](https://ems.press/journals/cmh/articles/16497)
- Follow-up with asymptotic constant ~0.8358 and GRH extensions:
  [arXiv:2411.05095](https://arxiv.org/pdf/2411.05095)
- D. R. Heath-Brown, *Gaps between primes, and the pair correlation of zeros of the zeta-function*,
  Acta Arith. 41 (1982) — RH + pair-correlation bounds `≪ √(p log p)`; survey context in
  [Visser's large-gaps essay](https://warwick.ac.uk/fac/sci/maths/people/staff/visser/large_gaps_between_primes.pdf)
- K. Ford, B. Green, S. Konyagin, J. Maynard, T. Tao, *Long gaps between primes*, J. Amer. Math. Soc. 31
  (2018) — `G(X) ≫ log X·log₂X·log₄X/log₃X`.
  [arXiv:1412.5029](https://arxiv.org/abs/1412.5029), [JAMS](https://www.ams.org/journals/jams/2018-31-01/S0894-0347-2017-00876-2/viewer/)
- L. Guth, J. Maynard, *New large value estimates for Dirichlet polynomials*, Ann. of Math. 203 (2026) —
  zero density `N(σ,T) ≪ T^{30(1−σ)/13+o(1)}`; PNT asymptotic in all intervals `x^{17/30+ε}`.
  [arXiv:2405.20552](https://arxiv.org/abs/2405.20552), [Annals](https://annals.math.princeton.edu/2026/203-2/p06),
  [Tao's summary](https://mathstodon.xyz/@tao/112557249982780815)
- R. C. Baker, G. Harman, J. Pintz, *The difference between consecutive primes II* (2001) — gaps
  `≪ p^{0.525}` unconditionally; claimed refinement to `0.52` via Harman's sieve (preprint):
  [arXiv:2308.04458](https://arxiv.org/pdf/2308.04458)
- P. X. Gallagher, *On the distribution of primes in short intervals*, Mathematika 23 (1976) — uniform
  Hardy–Littlewood ⇒ Poisson spacings (the §14 model's foundation).
- A. Odlyzko, M. Rubinstein, M. Wolf, *Jumping champions*, Exp. Math. 8 (1999); M. Wolf's refined
  max-gap heuristics (the `x/q²` first-moment counting tested in §17).

## Status summary

| Claim | Status |
|---|---|
| `errf[m,p,q] ≡ diffX[m+1]` | ✅ PROVEN (general `D(m)`, hand + numeric) |
| `Solve[...,q]` is closed-form, not a root-find | ✅ PROVEN, 🔬 matches `FindRoot` to 1e-15 |
| `diffX[m]` decays but plateaus into gap noise | 🔬 NUMERICALLY VERIFIED (qualitative; no power-law fit claimed) |
| MachinePrecision loses ~2 digits per decade of `m` | 🔬 VERIFIED to `m=10⁵`; 🤔 extrapolation to `m≈6.8×10⁶` unverified |
| `LogIntegral → PrimePi` breaks the construction | 🔬 NUMERICALLY VERIFIED (mean ratio 1146×, `m=30..300`) |
| `riseX[m]` has a prime-free analytic approximation | ✅ derivation exact; 🔬 <0.1% error by `m=20000` |
| ...and it's fully closed-form (no `NIntegrate`) | ✅ exact antiderivative found (§4.1), 🔬 matches to 1e-10, ~50-80× faster |
| approx-`riseX` + true-`p` ≈ true-`riseX` + true-`p` | 🔬 NUMERICALLY VERIFIED, 6 values of `m` |
| approx-`riseX` + approx-`p` ≈ classical `liInv` | 🔬 NUMERICALLY VERIFIED, 6 values of `m` |
| `errf` beats naive Cramér/local-density prediction | ❌ FALSIFIED — statistically tied, wins/loses both ways |
| smoothness mechanism: log-compression + history-localization (`R·B_R`) | 🔬 VERIFIED (§8); explains PrimePi break quantitatively |
| `diffX` = smooth curvature (closed form via `G`) + boundary gap noise, ratio ~1:2 | 🔬 VERIFIED at `m₀ = 1000, 5000, 10000` (windowed stats) |
| noise residual independent of denominator choice | 🔬 VERIFIED (corr 0.999997 between `den=m` and `den=Log·Li`) |
| model-corrected ansatz `errf = dXcf` ≡ Cramér local-density step | 🔬 VERIFIED, 181-value scan; denominator provably irrelevant (A1m ≡ A1) |
| A0's median wins = median-vs-mean shift on skewed gaps, not information | 🔬 VERIFIED (§9); resolves the former open question |
| shift asymptotics: `s = 1/2 − 1/log p − (log log p + 3/4)/log²p + …` | ✅ DERIVED (standard Li asymptotics, machine algebra); 🔬 verified to `m=10⁴⁰` |
| `s → 1−ln 2` (A0 asymptotically median-optimal) | ❌ FALSIFIED — `s → 1/2`; the 0.307 transit sits in the m=500..5000 window |
| `dXcf ~ −1/(4p log p)`, i.e. `c → 1/4` | ✅ DERIVED (§10); matches measured `c = 0.168` at `m=10⁴` |
| packaged estimator `nextPrimeCF` (unbiased ansatz, `Li⁻¹` at 3 integer args) | 🔬 VERIFIED vs truth & Cramér baseline (script 11) |
| inversion-free `nextPrimeCF2` — no `FindRoot` anywhere, pure `Log`/`LogIntegral` | 🔬 VERIFIED — agrees with CF to `5×10⁻⁷` for `m ≥ 2×10⁴`; +7% median cost in the 500–5000 window (script 12) |
| `Li`-conjugacy: unbiased map = unit translation in `ν = Li(p)`; `C = Li(p)−m` conserved; A0 = `(1−s)`-translation | 🔬 VERIFIED (script 13); chained-orbit drift = accumulated approximation bias, quantified |
| CF2's deviation from `p + log p` carries next-gap signal | ❌ REFUTED — in-sample −0.18 = demeaning artifact (−0.11, null-verified) + gap mean-reversion (−0.10 ≡ direct autocorr −0.095, worth 0.32% RMS), and the deviation is *anti-aligned* with it (scripts 15–16) |
| gap theorems (CMS/RH, Guth–Maynard, FGKMT) fold into the hazard model | 🔬 no-op — model's mass beyond the RH certificate `~10^{−12,086}` at `p=10⁹` (script 19); theorems police a tail the model declares empty |
| extreme tail of the gap distribution at accessible heights | 🔬 thinner than exponential ×2–3 at `t = 5–7` (script 20); HL comb explains ~×1.5 (`E[𝔖²] ≈ 4.5`); Wolf's `x/q²` overcorrects ×7–10; 📖 Gallagher ⇒ transient |

**Open:** whether a *rigorous* (not linear-fit) bound governs the `MachinePrecision` breakdown point.
(The two other former open items — the `1−ln 2` question and the derivation of `dXcf` from the
`G`-asymptotics — are both settled in §10.)
