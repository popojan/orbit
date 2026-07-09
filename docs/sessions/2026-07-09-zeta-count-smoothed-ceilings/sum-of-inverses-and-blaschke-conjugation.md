# Sum of inverses vs. inverse of sum, and the Blaschke map hiding in the ceiling family

**Date:** 2026-07-09
**Follow-up to:** [README.md](README.md) §4.2 (`ceilC`, `ceilSmooth`)

**One-line result:** summing the *inverses* of the per-prime staircases is a
well-defined but essentially content-free construction (✅/🔬, diverges from
`F⁻¹` at least quadratically in the prime count). The reason the staircases
share a height at their riser midpoint is that `ceilSmooth` is secretly the
boundary map of a **Blaschke/Möbius disk automorphism** — a genuine conformal
map, verified exactly — but its fixed points sit at a different `t` for every
prime, so no single reparametrization of the `(t,y)` plot plane can align two
primes at once. Same ℚ-independence-of-`{ln p}` obstruction as
[§4.2.4](README.md#424-quantize-the-wave-and-bin-the-t-axis-jans-question),
now derived from the fixed-point geometry rather than observed empirically.

---

## 1. Does summing inverses relate to inverting the sum?

**Setup.** Each prime contributes a smoothed staircase in `t`:

$$s_p(t) = \operatorname{ceilSmooth}\!\Big(\frac{t\ln p}{2\pi},\,r_p\Big), \qquad
\operatorname{ceilSmooth}(x,r) = x+\tfrac12+\frac1\pi\arctan\!\frac{r\sin 2\pi x}{1-r\cos 2\pi x}$$

```mathematica
ceilSmooth[x_, r_] := x + 1/2 + ArcTan[r Sin[2 Pi x]/(1 - r Cos[2 Pi x])]/Pi;
sP[t_, p_, r_] := ceilSmooth[t Log[p]/(2 Pi), r];
```

`d/dx ceilSmooth = P_r(2\pi x)` (Poisson kernel) `> 0`, so each `s_p` is
strictly increasing — genuinely invertible. Hence **both** of the following
are well-defined competing objects:

$$F(t) = \sum_{p} s_p(t) \qquad\text{(itself invertible, sum of increasing functions)}$$
$$G(y) = \sum_{p} s_p^{-1}(y)$$

**H1 — the shared fixed height (✅ proven, exact).** At `x=n+1/2`,
`sin(2\pi x)=0` identically, so the arctan term vanishes for *any* `r`:

$$\operatorname{ceilSmooth}(n+\tfrac12,r) = n+1 \qquad \text{for all } 0<r<1$$

```mathematica
FullSimplify[ceilSmooth[n + 1/2, r] - (n + 1),
  Assumptions -> n \[Element] Integers && 0 < r < 1]
(* 0 *)
```

This is the coincidence Jan spotted visually in `schody[]`: every prime's
staircase passes through the same integer at its own riser midpoint,
regardless of `r` (hence regardless of `p` or `\sigma`).

**H3 — but `G` diverges from `F^{-1}`, provably (✅ proven asymptotically, 🔬
verified).** For large `t`, `s_p(t)\approx \frac{\ln p}{2\pi}t`, so

$$F^{-1}(y)\text{'s slope} \sim \frac{2\pi}{\sum_p \ln p} \qquad\text{(reciprocal of the frequency SUM)}$$
$$G(y)\text{'s slope} \sim 2\pi\sum_p\frac1{\ln p} \qquad\text{(SUM of the reciprocal frequencies)}$$

By Cauchy–Schwarz/AM–HM, $\big(\sum_p \ln p\big)\big(\sum_p \tfrac1{\ln p}\big)\ge m^2$
(equality only if all `ln p` were equal — never true for distinct primes), so
`G`'s slope exceeds `F⁻¹`'s by a factor growing **at least quadratically** in
the number of primes `m`. Measured (`p ≤ 29`, `y₀ = 10.3`):

| `m` | `F⁻¹(y₀)` | `G(y₀)` | ratio `G/F⁻¹` | AM–HM bound `θ·Σ(1/ln p)` |
|---|---|---|---|---|
| 1 | 90.29 | 90.29 | 1.0 | 1.0 |
| 2 | 33.84 | 147.13 | 4.3 | 4.2 |
| 4 | 9.65 | 217.80 | 22.6 | 18.7 |
| 6 | 4.55 | 267.88 | 58.9 | 44.3 |
| 8 | 2.42 | 310.81 | 128.4 | 80.2 |
| 10 | 1.40 | 348.95 | 249.5 | 126.6 |

```mathematica
primeList = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29};
sInv[y_, p_, r_] := t /. FindRoot[sP[t, p, r] == y, {t, (y - 1/2) 2 Pi/Log[p]}];
gSum[y_, m_] := Sum[sInv[y, primeList[[k]], 1/Sqrt[primeList[[k]]]], {k, 1, m}];
```

**Verdict.** `F(t)` answers "how much total phase have all primes
accumulated at one shared moment `t`" — the shared-argument structure `ζ`'s
Euler product actually lives in. `G(y)` answers "what's the sum of the very
different private crossing-times at which each prime reaches the same
numeric height `y`" — those crossing times scale as `2\pi y/\ln p`, genuinely
different per prime, so `G` is dominated by the prime-harmonic sum
`\sum 1/\ln p` with no zeta content. No useful relation beyond both being
built from the same family `{s_p}`.

Script: [`scripts/15-sum-of-inverses-vs-inverse-of-sum.wl`](scripts/15-sum-of-inverses-vs-inverse-of-sum.wl).

---

## 2. The conformal map behind the ceiling family (and why it can't help)

**Jan's question:** is there a (not-necessarily-conformal) map of the plot's
`(t,y)` plane — not the `s=\sigma+it` plane — built from the shared fixed
heights of §1, that would simplify `\sum_p s_p(t)`?

**H1 — `ceilSmooth`'s wobble *is* a Blaschke boundary map (✅ exact, `1.3\times10^{-15}`).**
Let `B_r` be the Möbius automorphism of the unit disk

$$B_r(z) = \frac{z-r}{1-rz}$$

```mathematica
blaschke[z_, r_] := (z - r)/(1 - r z);
```

Then, writing `\theta=2\pi x`:

$$\operatorname{Arg}\big[B_r(e^{i\theta})\big] - \theta \;=\; -2\operatorname{Arg}(1-re^{i\theta})
\;=\; -2\pi\Big(\operatorname{ceilSmooth}(x,r)-x-\tfrac12\Big)$$

```mathematica
argOfWobble[x_, r_] := ArcTan[1 - r Cos[2 Pi x], -r Sin[2 Pi x]];
Max@Table[
  With[{x0 = RandomReal[{-1, 1}], r0 = RandomReal[{0.01, 0.99}]},
   Mod[Arg[blaschke[Exp[2 Pi I x0], r0]] - 2 Pi x0 + Pi, 2 Pi] - Pi -
   (Mod[-2 argOfWobble[x0, r0] + Pi, 2 Pi] - Pi)] // Abs, {300}]
(* ~1.3*10^-15 *)
```

So the whole `ceilC` family is exactly the boundary angle-distortion of a
1-parameter family of disk automorphisms — for real `r`, **hyperbolic
translations of the Poincaré disk along the real diameter**.

**H2 — universal fixed points (✅ exact) explain §1's H1.**

$$B_r(1) = 1, \qquad B_r(-1) = -1 \qquad \text{for every } 0<r<1$$

```mathematica
FullSimplify[blaschke[1, r] - 1]   (* 0 *)
FullSimplify[blaschke[-1, r] + 1]  (* 0 *)
```

A hyperbolic translation fixes both endpoints of its own axis; since `r` is
real, that axis is the real diameter, endpoints `z=\pm1`, i.e.
`\theta=0,\pi`. `\theta=\pi` is exactly `x=n+\tfrac12 \bmod 1` — so §1's
"shared height" isn't a coincidence between different `r`, it's the
translation axis endpoint, which by definition never moves as you translate
along the axis.

**H3 — straightening confirms the known multiplier (✅ exact).** Conjugating
by the Cayley map `w=(1+z)/(1-z)` (sending `z=\pm1 \to \infty,0`) turns
`B_r` into pure scaling:

$$w(B_r(z(w))) = \lambda(r)\, w, \qquad \lambda(r) = \frac{1-r}{1+r}$$

```mathematica
wOf[z_] := (1 + z)/(1 - z);
zOf[ww_] := (ww - 1)/(ww + 1);
FullSimplify[wOf[blaschke[zOf[ww], r]]/ww]
(* (1-r)/(1+r) *)
```

This exactly reproduces the riser/tread ratio `(1\pm r)/(1\mp r)` already
found empirically in [README.md §4](README.md). So `r` (equivalently
`\sigma`, via `r_p=p^{-\sigma}`) was secretly a **hyperbolic distance**
parameter, and moving it is a Möbius-group translation.

**Why it still can't simplify the cross-prime sum.** The straightening
conjugation works *within one circle*. Each prime lives on its own circle at
its own rate, `\theta_p(t)=t\ln p`, so prime `p`'s fixed point sits at
`t=0` and `t=\pi/\ln p` — a different `t` for every prime. A conjugation
silencing two primes at once would need `\pi/\ln p = \pi/\ln q`, i.e.
`\ln p/\ln q\in\mathbb Q`, i.e. `p^a=q^b` — impossible by unique
factorization (same fact as
[§4.2.4](README.md#424-quantize-the-wave-and-bin-the-t-axis-jans-question)).
The one object that *does* contain every prime at once is the linear flow
`t\mapsto(t\ln p_1,\dots,t\ln p_m)\bmod 2\pi` on the `m`-torus — already the
simplest possible coordinate (a straight line). `\sum_p s_p(t)` is a
**nonlinear observable** of that flow; by Bohr/Besicovitch almost-periodic
function theory its Fourier spectrum is indexed by all of `\mathbb Z^m`, and
no reparametrization of the `(t,y)` plane collapses it, because the
obstruction is the incommensurability of the `m` rotation rates, not a
poorly-chosen coordinate.

Script: [`scripts/16-blaschke-conformal-map.wl`](scripts/16-blaschke-conformal-map.wl).

---

## Self-adversarial check

Is this new leverage, or repackaging? **Repackaging** — but a load-bearing
one. It gives the conceptual (fixed-point/hyperbolic-geometry) reason for
results the session already had empirically (necklace ladder §4.2.3,
quantize-and-bin §4.2.4), and it correctly *predicts* the known `(1-r)/(1+r)`
multiplier as a cross-check. It does not open a route to simplifying `\sum_p`
at fixed `\sigma` — it closes that door more precisely than before.
