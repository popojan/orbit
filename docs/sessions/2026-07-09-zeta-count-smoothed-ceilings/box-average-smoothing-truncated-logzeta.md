# Box-averaging the truncated critical-line log sum: a surprisingly good, closed-form smoothing

**Date:** 2026-07-09
**Follow-up to:** [README.md](README.md) §4.2, [broken-sigma-dial-beurling-weight.md](broken-sigma-dial-beurling-weight.md)

**One-line result:** simply box-averaging (moving-average) the `m=50`-prime
truncated critical-line sum over a small window `w` gives a clean dilogarithm
closed form and a *real* ~4× error reduction against true `\log\zeta(1/2+it)`
away from the zeros — and, once tested with the right metric, ties-or-beats
the unsmoothed sum at *locating* the zeros too. Jan's heuristic `w=1/2` sits
within 5% of the true optimum (`w≈0.52–0.54`). Varying the window per prime
is legal but empirically worse; varying it with `t` — untested here — was
confirmed at first order in zzz's `--loop` on 2026-07-10 (§5 update below).

---

## 1. The closed form

$$\frac{1}{2w}\int_{t-w}^{t+w}\Big(-\sum_{p\le p_m}\log\big(1-p^{-1/2-ix}\big)\Big)dx
= \sum_{p\le p_m}\frac{i}{2w\ln p}\Big[\operatorname{Li}_2\big(p^{-1/2-i(t+w)}\big)-\operatorname{Li}_2\big(p^{-1/2-i(t-w)}\big)\Big]$$

```mathematica
closedFormTerm[p_?NumericQ, t_?NumericQ, w_?NumericQ] := (1/(2 w)) (I/Log[p]) (
    PolyLog[2, p^(-1/2 - I t - I w)] - PolyLog[2, p^(-1/2 - I t + I w)]);
boxSmoothed[t_?NumericQ, w_?NumericQ, m_] := Sum[closedFormTerm[p, t, w], {p, Prime /@ Range[m]}];
```

Sign convention matters here: `\log\zeta_{trunc}(s)=-\sum_p\log(1-p^{-s})`, so
it's the `+i` prefactor (not `-i`) that correctly integrates the *log-zeta*
term — verified directly against `-NIntegrate[Log[1-p^{-1/2}p^{-ix}],\dots]`
to `4\times10^{-16}`.

## 2. Does it actually help?

**Away from the zeros** (`>0.5` from any true `γ`, `m=50` primes, `w=1/2`,
against a 400-point grid on `t\in(13,33)`):

| | box-smoothed | unsmoothed |
|---|---|---|
| median `|diff|` vs true `\log\zeta(1/2+it)` | **0.037** | 0.155 |

A real ~4× reduction, not an artifact.

**Near the zeros — corrected metric.** Amplitude comparison against a
*divergent* target is meaningless (neither a finite window-average nor a
finite truncated Euler product can reach `-\infty`); the right test is
whether the approximation's own local minimum sits at the true zero:

| `γ` | box-smoothed dist. | unsmoothed dist. |
|---|---|---|
| 14.13 | **0.020** | 0.040 |
| 21.02 | **0.010** | 0.020 |
| 25.01 | **0.010** | 0.040 |
| 30.42 | 0.030 | 0.030 |
| 32.94 | 0.030 | 0.030 |

Box-smoothing ties or beats unsmoothed at every zero tested — it improves
zero-*location*, not just the smooth carrier between zeros. (An earlier pass
measured this the wrong way — amplitude diff at a fixed offset from `γ` — and
concluded "neutral to worse"; that was a measurement bug, not a property of
the method.)

## 3. Where does `w` actually bottom out?

```mathematica
Do[Print["w=", w, "  median|diff|: ",
   N[Median[Abs[(boxSmoothed[#, w, 50] & /@ awayGrid) - awayTrue]], 5]],
  {w, {0.3, 0.4, 0.44, 0.46, 0.48, 0.5, 0.52, 0.54, 0.56, 0.6, 0.8, 1., 1.5, 2., 3.}}]
```

Minimum at `w≈0.52–0.54` (`0.0352`) vs. `w=1/2`'s `0.0368` — under 5% further
gain. The heuristic `1/2` was already essentially optimal.

## 4. Varying `w` per prime — legal, elegant, but worse

"We're dividing by a single `1/(2w)`" does *not* block per-prime windows:
integration and summation commute, so `1/(2w)` outside the sum can become
`1/(2w_p)` inside it term-by-term.

The natural choice tied to this session's per-prime phase variable
`x_p=t\ln p/2\pi` is `w_p=c/\ln p` — a *constant window in phase*. This
makes every prime's `k`-th harmonic get the **same** weight `\operatorname{sinc}(kc)`,
independent of `p` (verified exactly, `1.6\times10^{-15}`) — a clean ladder
structure parallel to [README.md §4.2.3](README.md)'s necklace ladder, with
`sinc` playing `M_k(r)`'s role:

```mathematica
perPrimeTerm[p_?NumericQ, t_?NumericQ, c_?NumericQ] := Module[{wp = c/Log[p]},
   (1/(2 wp)) (I/Log[p]) (
     PolyLog[2, p^(-1/2 - I t - I wp)] - PolyLog[2, p^(-1/2 - I t + I wp)])];
```

Structurally elegant, empirically worse: best case `c=0.3` gives median
`0.162` — over 4× worse than constant-`w`'s `0.035`. Reason: `w_p=c/\ln p`
damps *every* prime's fundamental by the same relative amount, including the
small primes (`p=2,3,5,\dots`) that carry almost all the real signal.
Constant `w` instead barely touches small primes (`w\ln p` small ⟹
`\operatorname{sinc}\approx1`) while aggressively damping large, low-amplitude,
noisy primes — precisely the right asymmetry. Considered and rejected, for a
concrete, verified reason.

## 5. Varying `w` with `t` — open, not closed

Tried `w(t)=c/\log(t/2\pi)`, matched to the Riemann–von Mangoldt zero density
(`\sim1/\log t`). Best on `t\in(13,33)` is `c\approx0.8` at `0.045` — still
worse than constant-`w`'s `0.035`. `\log(t/2\pi)` only ranges `0.73\to1.66`
on this window (implied `w` swings `\approx1.1\to0.48`, and `w\approx1.1` is
already well past the constant-`w` optimum) — too little dynamic range for
the idea to prove itself. Untested at heights where `\log t` genuinely
varies (`t` in the hundreds or thousands); not concluded either way.

**Update (2026-07-10): concluded at first order, positively.** Tested at scale
inside zzz's `--loop` forward step (zzz commit `ef99388f`,
`doc/notes/box-forward-step.md`), where the box average is a per-term
`sinc(m·w·ln p)` weight: `w(t) = 2\pi c/\log(t/2\pi)` at fixed `c = 0.375` keeps
gap-unit zero-location errors flat-to-improving from `t≈124` to `t≈4.6×10⁴`
(per-band median `0.017→0.012`; `\log(t/2\pi)` varying 3×). The
`1/\log(t/2\pi)` scaling is correct at first order — the low-`t` failure above
was the window's lack of dynamic range, as suspected. Still open: the mild
drift of the optimal `c` with `κ = gap·log X` (`0.5→0.25` over `1.5π→3π`).
See README §9.1 for the polylog↔ζ circularity verdict attached to the same
addendum.

## 6. The untruncated closure (Jan's follow-up, 2026-07-10)

*Does the box smoothing of the **whole** (untruncated) `\log\zeta`, with the
`t`-varying window, still close?* Yes — exactly, but on the ζ/σ side of the
duality, not the prime side
([`scripts/20-untruncated-box-closure.wl`](scripts/20-untruncated-box-closure.wl),
hypotheses stated first, all 🔬):

- **FTC structure.** A box average is an endpoint difference of the
  antiderivative, so *any* window law — including `w(t)=c\cdot\mathrm{gap}(t)` —
  closes the moment the antiderivative does; a varying width only moves the two
  endpoints `t\pm w(t)`.
- **The antiderivative closes across the line (Littlewood).** With
  `G(\tau)=\int_{1/2}^{\infty}\mathrm{Log}\,\zeta(\sigma+i\tau)\,d\sigma`:

  $$\frac{1}{2w}\int_{t-w}^{t+w}\mathrm{Log}\,\zeta(\tfrac12+ix)\,dx
  \;=\;\frac{i}{2w}\,\big[G(t+w)-G(t-w)\big]$$

  🔬 verified to `9\times10^{-13}` (the residual is the `\sigma=40` tail cutoff
  of `G`) — both for a zero-free window (`t=20,w=1/2`) and for a window
  **containing** `\gamma_2` (`t=21,w=1/2`; both sides finite, the log
  singularity is integrable). The Im half is the classical
  `S_1(t)=\int_0^t S` and Littlewood's
  `S_1 = \frac1\pi\int_{1/2}^\infty\log|\zeta|\,d\sigma + C`; the constant cancels
  in the difference, which is all the box average needs. The underlying
  **Littlewood lemma**: for `f` analytic on the rectangle `R=[\sigma_0,\sigma_1]\times[t_0,t_1]`,
  nonzero on the right edge, with `\log f` continued from the right edge along
  horizontal cuts to the left edge,
  `\frac{1}{2\pi i}\oint_{\partial R}\log f\,ds = -\sum_{\rho\in R}(\beta-\sigma_0)`
  (counterclockwise; zeros weighted by distance to the left edge). Our identity
  is the `\sigma_1\to\infty` instance for `\zeta`: on-line zeros sit on the left
  edge with `\beta-\sigma_0=0`, so the sum vanishes and pure Cauchy remains.
  *(References — attribution recalled, not re-verified: J. E. Littlewood, "On
  the zeros of the Riemann zeta-function", Proc. Camb. Phil. Soc. **22** (1924)
  295–318; Titchmarsh, 2nd ed., §9.9; for `S_1`: Selberg 1946, and
  Karatsuba–Korolev, Russian Math. Surveys **60** (2005).)* Wrap-free principal
  branch checked by sampling (same measure-zero caveat as §4.2.6 of the README).
- **Third member of the Cauchy–Riemann family.** Per-prime `ceilC` (README
  §4.2: modulus = `r`-ray integral of the phase slope), global `ZeroCountX`
  (§4.2.6), and now the box average: *smoothing along the line closes as
  evaluation across the line.* The `t`-window of the phase/counting half is
  paid for by a `\sigma`-ray of the modulus half at the two window edges.
- **At a zero it closes locally too:** the `-\infty` spike becomes a finite dip
  of computable depth,

  $$\frac{1}{2w}\int_{\gamma-w}^{\gamma+w}\log|\zeta(\tfrac12+ix)|\,dx
  = \log|\zeta'(\rho)| + \log w - 1 + O(w^2),$$

  🔬 verified at `\gamma_1` with *exact* `w^2` error scaling
  (`-3.9\times10^{-4}\to-2.5\times10^{-5}` as `w: 0.2\to0.05`). With
  `w=c\cdot\mathrm{gap}(t)` the dip depth drifts like
  `\log\mathrm{gap}(t)\approx-\log\log(t/2\pi)`: zeros stay visible as finite
  dips at all heights, shallowing only doubly-logarithmically. **Plot reading
  (Jan, 2026-07-10):** plotting `(1/2w)[G(t+w)-G(t-w)]` *without* the `i`
  factor shows this with the halves swapped — Im of the plot is `-`(smoothed
  `\log|\zeta|`), so every zero survives as a finite **peak** of height
  `\approx 1-\log w-\log|\zeta'(\rho)|` on the `\gamma` gridlines (encoding
  `1/|\zeta'(\rho)|`, the Hughes–Keating–O'Connell quantity; attribution
  recalled), while Re is `\pi\times` the smoothed `S(t)`. Expected: a linear
  average of an integrable log singularity blunts the spikes but can never
  erase them.
- **The prime side does *not* close.** The all-primes dilog/sinc series
  inherits the divergence of `\log\zeta`'s Dirichlet series on the line: after
  `x=e^v` the terms go like `e^{v/2}/(wv^2)` — the pole-driven `e^{v/2}` beats
  the algebraic `\operatorname{sinc}` damping (box smoothing damps by
  `1/\text{frequency}`, not exponentially). The `\sigma`-ray integral **is**
  the regularized value of `\sum_p \operatorname{Li}_2(p^{-1/2-i\tau})/\ln p` —
  §4.2.5's verdict once more: the honest closed form lives on the ζ side of
  the explicit-formula duality.
- **Hadamard reading (recalled, qualitative, not re-verified):** through `\xi`,
  the antiderivative's smooth part closes in Barnes-`G`
  (`\int\log\Gamma` = Alexeiewsky), and each zero contributes an
  `(s-\rho)\log(s-\rho)-(s-\rho)` atom — the box-smoothed staircase riser is
  literally the integrated log singularity, an "`x\log x`" kernel per zero.
- **Why the `t`-law is the natural one (unfolding).** `w(t)=c\cdot\mathrm{gap}(t)`
  is, to `O(w^2 N_0'')`, a **constant-width-`c` box in the unfolded time**
  `\tau=N_0(t)` — the window matched to the *output* (zero) lattice. Its
  rejected mirror image, `w_p=c/\ln p` (§4), was the window matched to the
  *input* (prime) lattice. Same construction, opposite side of the duality,
  opposite verdict.

## 7. Imaginary window: the box rotated onto the σ-axis (Jan: "w = i/2 simplifies nicely", 2026-07-10)

*What if the box window is purely imaginary?* Continuing `A_w(t)` in `w`, the
endpoints `t \pm iv` become `\sigma = 1/2 \mp v` at fixed height: **an imaginary
`t`-window is a real `σ`-window** — the box lands on the horizontal segment
`\sigma\in(1/2-v,\,1/2+v)`, and Jan's `w=i/2` spans the whole critical strip:
`A_{i/2}(t)=\int_0^1\mathrm{Log}\,\zeta(\sigma+it)\,d\sigma`. It does simplify
nicely — more than nicely
([`scripts/21-imaginary-window-rotation.wl`](scripts/21-imaginary-window-rotation.wl),
hypotheses first, all 🔬):

- **Exact FE split.** On the symmetric window the functional equation pairing
  `\sigma\leftrightarrow1-\sigma` (`\zeta(1-s)=\zeta(s)/\chi(s)`, and
  `\log|\chi(s)|+\log|\chi(1-\bar s)|=0` exactly — 🔬 `10^{-15}`) gives, exactly:

  $$A_{iv}(t)\;=\;\big\langle\log|\zeta(\sigma+it)|\big\rangle_\sigma
  \;+\;\frac{i}{2}\big\langle\arg\chi(\sigma+it)\big\rangle_\sigma\;(+\,i\pi\,\text{staircase, below}).$$

  🔬 Integral form exact at `t=20` (diff `0.` at `v=0.3, 0.5`); pointwise and at
  higher `t` the identity holds mod `2\pi` (principal-branch offsets of `8\pi,
  18\pi` observed at `t=33.7, 50.1` — branch bookkeeping, not error).
- **The Im channel keeps only topology.** The smooth part is *explicit*:
  `\tfrac12\langle\arg\chi\rangle = -\theta(t)+O(v^2/t)` (🔬 diff `1.0\times10^{-3}`
  at `t=20`, `2.1\times10^{-4}` at `t=100` — clean `1/t`). On top of it, branch-tracked
  (arg unwrapped along the segment): a jump of **exactly `\pi`** at each zero —
  🔬 measured `3.141592642` across `\gamma_1` — and **zero fluctuation between
  zeros**: the residual `\langle\arg\zeta\rangle-\tfrac12\langle\arg\chi\rangle`
  is constant to `5\times10^{-8}` over `t\in(15.5,20)` while `S(t)` itself varies
  by `\sim0.2` there. The FE symmetrization annihilates `S(t)` *analytically*;
  what survives is the winding number — `\pi` per zero, the integer content and
  nothing else. `\mathrm{Im}\,A_{iv}+\theta(t)` is a **de-fluctuated counting
  staircase**: exact jump locations, no `S` wobble. (The `\pm0.01`
  principal-branch numbers near `\gamma_1` in the script's H2 block are cut
  artifacts, superseded by the unwrapped H2b check.)
- **The Re channel keeps the analytic record**: `\sigma`-window modulus average,
  zeros as finite log-wells with the same dip law as §6, now sideways:
  depth `\log v-1+\log|\zeta'(\rho)|` (🔬 `8.8\times10^{-4}` at `\gamma_1, v=0.3`).
- **Closed form of the smooth part:** `\int\log\chi\,d\sigma` with
  `\chi=2^s\pi^{s-1}\sin(\pi s/2)\Gamma(1-s)` closes in **Clausen `Cl_2` +
  Barnes-G** (`\int\log\sin` = Lobachevsky/Clausen, `\int\log\Gamma` =
  Alexeiewsky; attribution recalled) — `Cl_2(\theta)=\mathrm{Im}\,\mathrm{Li}_2(e^{i\theta})`:
  the dilog again, on the unit circle for the `\Gamma`-side exactly where §1 has
  `\mathrm{Li}_2` inside the disk for the prime side.
- **Prime side: sinc rotates to sinh.** Averaging `p^{-s}` over the
  `\sigma`-window weights the `p^m` term by `\sinh(mv\ln p)/(mv\ln p)\ge1`
  (✅ symbolic; `=2.77` at `p=229, v=1/2`) — the imaginary window **amplifies**
  the noisy band edge (it is dominated by the divergence-ward endpoint
  `\sigma=1/2-v`). So for the zzz forward step this is the anti-lever: the
  real window damps (sinc, §9.1 zzz adoption), the imaginary window anti-damps,
  and the counting channel it would feed is exactly the one it erases.

**Reading:** the imaginary window is a projection that separates the counting
channel's *analytic* content from its *topological* content. `S(t)` — the very
thing every truncated/smoothed method chases — is gauge: exactly removable by a
symmetry. The unit jumps are winding numbers: no smoothing or cancellation
touches them. This is the snap-to-ℤ atom in its purest form yet, and the
`\sigma`-averaged sibling of §4.2.6's `ZeroCountX` (exact staircase there *with*
`S` riding on it; exact jump locations here with `S` stripped away). No zzz
lunch: evaluating `A_{iv}` needs `\zeta` off the line (or sinh-amplified
truncated sums — strictly worse than plain B), so band-saturation stands.

### 7.1 How the borders "know" the zeros (Jan's follow-up, 2026-07-10)

At `w=i/2` the closure `A_{i/2}=G(t+i/2)-G(t-i/2)` is a difference of two *ray
integrals* of `\log\zeta` anchored at `\sigma=0` and `\sigma=1` (the common tail
`(1,\infty)` cancels; one ray passes through the strip). Where the zeros live in
this data is now pinned exactly
([`scripts/22-borders-and-derivative-form.wl`](scripts/22-borders-and-derivative-form.wl), all 🔬):

- **Pointwise, the borders know nothing about zeros.**
  `\log|\zeta(1+it)|-\log|\zeta(it)| = -\log|\chi(it)|` exactly (🔬 `10^{-15}`), with the
  elementary closed form `|\chi(it)|=\sqrt{(t/2\pi)\tanh(\pi t/2)}` (🔬 12 digits) —
  smooth, zero-free, pure `\Gamma`-factor.
- **By Cauchy–Riemann that border difference IS the a.e. `t`-derivative of the
  strip phase average**: `\frac{d}{dt}\langle\arg\zeta\rangle_{(0,1)} =
  \log|\zeta(1+it)|-\log|\zeta(it)|` between zeros — 🔬 verified by finite
  differences to `10^{-8}`–`10^{-9}`: the derivative carries **zero** `S(t)`
  fluctuation. Hence the exact distributional identity

  $$\frac{d}{dt}\,\mathrm{Im}\,A_{i/2}(t)\;=\;\pi\sum_\gamma\delta(t-\gamma)\;-\;\frac12\log\!\Big(\frac{t}{2\pi}\tanh\frac{\pi t}{2}\Big),$$

  an RvM formula with no `S(T)` error term — the arithmetic is repackaged
  entirely into the `\pi`-jumps, i.e. into the **monodromy** of `\log\zeta`
  collected by the `t`-continuation. "Knowing the zeros" is stored in the path
  (winding around the branch points at `(1/2,\gamma)`), never in a pointwise
  border value; there is no local shortcut to the integer — you must walk past
  the zeros to collect their windings.
- **Theoretical use: this IS the classical engine** (attributions recalled,
  standard): Backlund's rigorous `N(T)` and the Riemann–von Mangoldt proof run
  on `\arg\zeta` over strip-spanning horizontal segments; Littlewood's lemma on
  border/near-border lines is the zero-density industry (mean values of
  `\log|\zeta|` on `\sigma_0` bound `\sum(\beta-\sigma_0)`); the border `\sigma=1`
  knowing the zeros *is* the PNT (de la Vallée Poussin's `3+4\cos+\cos2`
  positivity ⇒ no zeros on `\sigma=1`); and exact border/off-line RH criteria
  exist in the same genre (Volchkov; Balazard–Saias–Yor).
- **What it cannot do: see RH.** The winding is `\beta`-blind — a hypothetical
  off-line FE pair `(\beta,1-\beta)` at height `\gamma` jumps
  `2\pi\beta+2\pi(1-\beta)=2\pi`, identical to two on-line zeros; jump `=\pi\times`
  multiplicity regardless of `\beta`. The phase/counting channel is topological,
  hence insensitive to the one thing RH asserts. All `\beta`-sensitivity lives
  in the Re/modulus channel (the log-wells; `\sum(\beta-\sigma_0)` bounds) —
  exactly where the moments/mollifier/zero-density literature operates.

### 7.2 Computational shortcut? Convergence at the borders, and the window-width question (Jan's follow-up, 2026-07-10)

*Two evaluations at the strip borders, zeros preserved as phase jumps — how fast
do they converge, and would another imaginary width `v` improve them?* Analytic
verdict (standard asymptotics; convergence figures recalled, per-line):

- **Per-anchor truncated-prime convergence** (cutoff `X`, height `t`):
  `\sigma=2`: `\sim X^{-1}/\log X`; `\sigma=1+\varepsilon`:
  `\sim X^{-\varepsilon}/(\varepsilon\log X)`; **`\sigma=1` (the `v=1/2` border):
  `\sim 1/(t\log X)`, conditional — the slowest convergent line**;
  `\sigma\in(1/2,1)`: `\sim X^{1/2-\sigma}` oscillatory (Selberg-slow);
  `\sigma\le1/2`: divergent, FE-folds to `\sigma\ge1/2` + explicit `\chi`.
- **No `v` helps.** The FE fold splits every `A_{iv}` into (i) explicit `\chi`
  (free), (ii) a far tail over `\sigma>1` (faster with larger `v`, never the
  bottleneck), and (iii) the **irreducible near-line core**
  `\int_{1/2}^{\min(1,1/2+v)}\log|\zeta|\,d\sigma`, whose truncated error is
  `\sim1/\log X` *independently of `v`* (the `\sigma`-integral of
  `X^{1/2-\sigma}` always collects its full `1/\log X` at the line-touching
  endpoint). Larger `v` adds only easy segments (and sinh-amplified constants,
  §7); `v\to0` degenerates to the on-line object (plain-B behavior).
- **The no-go, crisply: jumps ⟺ crossing.** The `\pi`-jumps are monodromy —
  collected only by data that crosses `\sigma=1/2`. Any ray/window configuration
  avoiding the strip interior is analytic in `t`: no jumps, no zeros. So "sees
  the zeros" ⟺ "carries the slow near-line data". A truncated implementation
  smears each riser over `\sim\pi/\log X` — method B's transition class (in-band
  functional; zzz's E4c cap applies), with worse constants for `v>0`.
- **The precision route pays the same wall**: borders determine zeros via
  analytic continuation, which is exponentially ill-posed — gap-scale `t`-structure
  from distance-`d` data costs precision `\sim(T/2\pi)^{d/2}` (at the border
  `d=1/2`: `(T/2\pi)^{1/4}`, i.e. `O(\log T)` digits). The `\sqrt T` wall at a
  different toll booth.
- **Classical anchor (sobriety check):** on the line the quantization was
  always free — `\zeta(1/2+it)=e^{-i\theta(t)}Z(t)` with `Z` real, so
  `\arg\zeta\equiv-\theta(t)\ (\mathrm{mod}\ \pi)` *pointwise*; the fractional
  part is explicit and **the integer is the entire computational content**
  (Turing's method is its classical exploitation; attribution recalled). The
  imaginary window extends this mod-`\pi` explicitness from the line to
  symmetric strip averages — a lens, not a lever.
- **What survives as useful:** free exact validators for any numeric pipeline
  (`d/dt\langle\arg\zeta\rangle=-\tfrac12\log((t/2\pi)\tanh(\pi t/2))` a.e.,
  residuals in `\pi\mathbb Z`), and the integer-snap evaluation strategy — the
  target is exactly quantized, so `<\pi/2` absolute accuracy plus rounding
  always suffices (the trick zzz's bisection already lives on).

## Self-adversarial check

Is "unusually well" real? Yes — the away-from-zeros error reduction (`0.155
\to 0.037`) and the location-based zero test (ties/beats at all 5 zeros) are
both measured against ground truth (`ZetaZero`, `Log[Zeta[\cdot]]`), not
against each other or a shifted target. What it does *not* do: reach the
zeros' true divergence (structurally impossible for any finite
window-average or finite truncated product), or beat a hand-tuned constant
`w` via either of the two "natural-looking" generalizations tried so far.

Scripts:
[`scripts/18-box-average-smoothing-truncated-logzeta.wl`](scripts/18-box-average-smoothing-truncated-logzeta.wl),
[`scripts/19-box-smoothing-per-prime-and-t-dependent-w.wl`](scripts/19-box-smoothing-per-prime-and-t-dependent-w.wl),
[`scripts/20-untruncated-box-closure.wl`](scripts/20-untruncated-box-closure.wl),
[`scripts/21-imaginary-window-rotation.wl`](scripts/21-imaginary-window-rotation.wl),
[`scripts/22-borders-and-derivative-form.wl`](scripts/22-borders-and-derivative-form.wl).
