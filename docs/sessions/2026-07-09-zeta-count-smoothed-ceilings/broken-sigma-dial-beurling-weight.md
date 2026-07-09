# A broken `σ`-dial that still finds the zeros

**Date:** 2026-07-09
**Follow-up to:** [README.md](README.md) §4.2 (`ceilC`)

**One-line result:** Jan's `wrong[σ,lo,hi,m]` has three bugs (`σ` unused,
constant smoothing `r=1/2` instead of `p^{-σ}`, and a 5-argument call that
doesn't even match its own 4-parameter definition), and collapses to a clean
closed form that is a genuine but *different* L-function (Beurling weight
`w_p≡1/2`, not `p^{-σ}`). Adversarially tested, not asserted: its dips do sit
above-chance close to true `ζ` zeros (✅ real effect, 🔬 `p≈0.015` vs a random
null model) — because it keeps the correct oscillation frequencies `ln p` and
only the amplitude is wrong, and the explicit-formula prime↔zero duality is
mainly a statement about frequencies, not amplitude.

---

## The bugs

```mathematica
wrong[sig_, lo_, hi_, m_] := I Pi Sum[
   ceilC[-t Log[p]/2/Pi, 1/2] + t Log[p]/2/Pi - 1/2, {p, Prime /@ Range[m]}];
```

1. **`sig` is dead code** — never referenced in the body (`FreeQ → True`).
2. **The call `wrong[2,30,53,43,1]` has 5 arguments against a 4-parameter
   pattern** — it doesn't match, `Head[wrong[2,30,53,43,1]] = wrong`; that
   exact call produces no plot at all.
3. **`r=1/2` is constant, not `p^{-σ}`.** At `σ=2` the correct amplitude
   `\arcsin(p^{-2})/\pi` should shrink from `0.080` at `p=2` to `8.7\times10^{-6}`
   at `p=191`; `wrong` uses `0.167` for *every* prime — a `19{,}101\times`
   overshoot at `p=191`.

## The correct formula (for reference)

$$\log\zeta(\sigma+it) = -i\pi\sum_{p\le p_m}\overline{\Big(\operatorname{ceilC}\big[x_p,\,p^{-\sigma}\big]-x_p-\tfrac12\Big)}, \qquad x_p=\frac{t\ln p}{2\pi}$$

```mathematica
xp[t_, p_] := -t Log@p/(2 Pi);
logZeta[sig_, t_, m_] := I Pi Sum[
   ceilC[xp[t, Prime@k], Prime[k]^-sig] - xp[t, Prime@k] - 1/2, {k, 1, m}];
```

— `r_p = p^{-\sigma}` must vary per prime, tied to `σ`, for this to be `\log\zeta`.

## What `wrong` actually computes

Simplifying (`I\pi\cdot\tfrac{I}{\pi}=-1`, verified `\sim10^{-14}`):

$$\texttt{wrong}(t,m) = -\sum_{p\le p_m}\log\!\Big(1-\tfrac12\,p^{-it}\Big)$$

```mathematica
closedForm[t_?NumericQ, m_] := -Sum[Log[1 - (1/2) p^(-I t)], {p, Prime /@ Range[m]}];
```

This *is* a genuine Euler product — just not `ζ`'s. It's the `w_p\equiv\tfrac12`
member of the Beurling-type completely multiplicative weight family already
flagged in [README.md §4.2](README.md): "independent per-prime `r`'s stay an
Euler product... but of weight system `w_p=r_p`... a different L-function,
generally no functional equation." Numerically it is nowhere near `\log\zeta`
on any line (`e.g. Re[wrong](50)=-3.13` vs. `Re[\log\zeta(2+50i)]=-0.243`).

## The observation, tested adversarially

On `t\in(30,53)` (7 true zeros in range), `Re[\texttt{wrong}]` has 32 local
minima. Mean distance from a true zero to the nearest one: `0.103`. Null
model: 200 trials of 7 random comparison points in the same window, same
"nearest local minimum" measure — mean `0.231`, and only **1.5% of random
trials did as well or better**. So this is a real, above-chance proximity,
not a look-elsewhere illusion.

**Why:** `wrong` keeps the exact correct frequencies `\{\ln p\}` and only
butchers the amplitude. The Weil/Guinand–Weil explicit-formula duality
between primes and zeros is fundamentally about matching *frequencies* to
the zero pattern; the amplitude profile mainly governs convergence, not
*where* the resonances land. A badly-weighted sum over the right frequencies
still carries partial memory of the zeros — genuinely interesting, but not
evidence this construction approximates `\zeta`.

Script: [`scripts/17-wrong-beurling-weight-and-zero-proximity.wl`](scripts/17-wrong-beurling-weight-and-zero-proximity.wl).
