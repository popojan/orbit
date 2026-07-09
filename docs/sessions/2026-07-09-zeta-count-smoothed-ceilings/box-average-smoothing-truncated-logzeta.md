# Box-averaging the truncated critical-line log sum: a surprisingly good, closed-form smoothing

**Date:** 2026-07-09
**Follow-up to:** [README.md](README.md) §4.2, [broken-sigma-dial-beurling-weight.md](broken-sigma-dial-beurling-weight.md)

**One-line result:** simply box-averaging (moving-average) the `m=50`-prime
truncated critical-line sum over a small window `w` gives a clean dilogarithm
closed form and a *real* ~4× error reduction against true `\log\zeta(1/2+it)`
away from the zeros — and, once tested with the right metric, ties-or-beats
the unsmoothed sum at *locating* the zeros too. Jan's heuristic `w=1/2` sits
within 5% of the true optimum (`w≈0.52–0.54`). Varying the window per prime
is legal but empirically worse; varying it with `t` is untested at heights
where it would matter.

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
[`scripts/19-box-smoothing-per-prime-and-t-dependent-w.wl`](scripts/19-box-smoothing-per-prime-and-t-dependent-w.wl).
