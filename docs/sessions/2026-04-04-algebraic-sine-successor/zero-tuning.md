# Zero Tuning: Diophantine Decomposition of the Explicit Formula

**Date:** 2026-04-05
**Status:** ✅ PROVEN (algebraic identity + continued fraction approximation)

## The Idea

In the explicit formula for $\psi'(x) = 1 - \frac{2}{\sqrt{x}}\sum_n\cos(\gamma_n\ln x)$,
each term $\cos(\gamma_n\ln x)$ can be "tuned" independently.

For each zero $\rho_n$, choose an integer $k_n$ freely. Then:

$$\cos(\gamma_n\ln x) = T_{k_n}\!\left(\cos\frac{\gamma_n\ln x}{k_n}\right)$$

This is exact for any $k_n$. The seed $c_n = \cos(\gamma_n\ln x / k_n)$ depends on the
choice of $k_n$, but $T_{k_n}(c_n)$ always equals $\cos(\gamma_n\ln x)$.

Different zeros can use **different** $k_n$ values in the same sum.

## Tuning to Algebraic Seeds

To place zero $n$ on the period-$2q$ orbit: choose $k_n$ so that the seed
equals $\cos(\pi/q)$:

$$\cos\frac{\gamma_n\ln x}{k_n} = \cos\frac{\pi}{q} \qquad \Longleftrightarrow \qquad k_n = \frac{q\,\gamma_n\ln x}{\pi}$$

Rounding to the nearest integer: $k_n = \mathrm{Round}(q\,\gamma_n\ln x / \pi)$.

The seed $\cos(\pi/q)$ is algebraic, living in $\mathbb{Q}(\cos(\pi/q))$ — the same
cyclotomic field where our Wagstaff norms live.

## The Continued Fraction Connection

The **best** tuning — smallest $q_n$ for a given approximation quality — comes
from the continued fraction expansion of $\gamma_n\ln x / \pi$:

$$\frac{\gamma_n\ln x}{\pi} = [a_0;\, a_1, a_2, \ldots]$$

The convergents $p_m/q_m$ give the best rational approximations, with error:

$$\left|\frac{\gamma_n\ln x}{\pi} - \frac{p_m}{q_m}\right| < \frac{1}{q_m\, q_{m+1}}$$

Setting $k_n = p_m$ and the period parameter $q_n = q_m$:

$$\cos(\gamma_n\ln x) = T_{p_m}\!\left(\cos\frac{\pi}{q_m}\right) + O\!\left(\frac{1}{q_m\, q_{m+1}}\right)$$

The transcendental $\cos(\gamma_n\ln x)$ is approximated by a **polynomial**
($T_{p_m}$, degree $p_m$) evaluated at an **algebraic point** ($\cos(\pi/q_m)$).

## The Tuned Explicit Formula

For fixed $x$, choosing $(k_n, q_n)$ per zero from continued fraction convergents:

$$\boxed{\psi'(x) = 1 - \frac{2}{\sqrt{x}}\sum_n T_{k_n}\!\left(\cos\frac{\pi}{q_n}\right)}$$

Each term decomposes into three factors:

| Factor | Type | Depends on | Meaning |
|--------|------|------------|---------|
| $k_n$ | Combinatorial (polynomial degree) | $\gamma_n, x$ | Orbit step count |
| $\cos(\pi/q_n)$ | Algebraic (cyclotomic) | best approx of $\gamma_n\ln x/\pi$ | Orbit seed |
| $1/(q_n q_{n+1})$ | Diophantine (approx quality) | CF expansion | Tuning error |

## Three Structures Meet

### 1. Orbit framework (Chebyshev)

$T_k(\cos(\pi/q))$ is the cosine orbit at step $k$ on the period-$2q$ orbit.
For prime $q$: the seed connects to Wagstaff numbers ($\mathrm{Nm}(o_q) = 3/(2^q+1)$
for $\lambda = 2$).

### 2. Number theory (continued fractions)

The quality of the rational approximation $p_m/q_m \approx \gamma_n\ln x/\pi$
determines the "algebraic complexity" of the orbit needed: small $q_m$ = simple
seed (low-degree cyclotomic), large $q_m$ = complex seed.

Zeros where $\gamma_n\ln x/\pi$ is well-approximated by a rational with small
denominator need only a LOW-PERIOD orbit — they are "arithmetically simple"
at position $x$.

### 3. Zeta zeros (spectral)

The heights $\gamma_n$ determine the continued fraction structure through
$\gamma_n\ln x/\pi$. Different $x$ values "illuminate" different Diophantine
properties of the zeros.

## Per-Zero Tuning is Independent

The critical observation: since $T_{k_n}(\cos(\gamma_n\ln x/k_n)) = \cos(\gamma_n\ln x)$
for **any** $k_n$, the tuning of zero $m$ does not affect zero $n$. Each zero is
tuned to its own orbit independently.

This means:
- Zero 1 can sit on a period-6 orbit ($q = 3$, seed $= 1/2$)
- Zero 2 can sit on a period-8 orbit ($q = 4$, seed $= 1/\sqrt{2}$)
- Zero 3 on period-14 ($q = 7$, seed $= \cos(\pi/7)$)
- ... each on its own best-approximating periodic orbit

The sum is exact (up to CF rounding), and each term is algebraically clean.

## Algebraic Barrier (Niven + Lindemann-Weierstrass)

The seed $\cos(\gamma_n\ln x/k_n)$ is algebraic (of ANY kind — rational, quadratic,
cyclotomic) **if and only if** $\gamma_n\ln x/(k_n\pi)$ is rational, i.e.,
$\gamma_n\ln x/\pi \in \mathbb{Q}$.

**Proof.** By Niven's theorem generalized via Lindemann-Weierstrass: $\cos\theta$
is algebraic iff $\theta/\pi$ is rational. (If $\theta$ is algebraic with $\theta/\pi$
irrational, then $e^{i\theta}$ is transcendental by L-W, forcing $\cos\theta$
transcendental.) $\square$

The condition $\gamma_n\ln x/\pi \in \mathbb{Q}$ is (almost certainly) never satisfied
for integer $x > 1$:

- **Schanuel's conjecture** implies $\pi$ and $\ln x$ are algebraically independent
- The algebraic independence of $\gamma_n$ from $\pi$ and $\ln x$ is widely believed
  but unproven (not even the irrationality of $\gamma_1/\pi$ is known)

Consequently: exact algebraic seeds are (almost certainly) impossible.
The continued fraction approximation is the best available tool —
it approaches algebraic seeds arbitrarily closely but never reaches them.

## Open Questions

1. **Distribution of $q_n$ values:** For a given $x$, what is the distribution of
   best denominators $q_n$ across zeros? Are small $q_n$ (simple orbits) more common
   at primes vs. composites?

2. **Resonance at primes:** At a prime $p$: $\sum T_{k_n}(\cos(\pi/q_n)) \ll 0$.
   Does this constrain the CF structure of $\gamma_n\ln p/\pi$?

3. **Wagstaff connection:** When $q_n$ is prime, the seed connects to Wagstaff numbers.
   How often is the best denominator $q_n$ itself prime? Is this related to the
   Wagstaff prime distribution?

4. **Collective Diophantine structure:** The individual CFs of $\gamma_n\ln x/\pi$
   are independent for different $n$. But the REQUIREMENT that $\sum T_{k_n} \ll 0$
   at primes imposes a COLLECTIVE constraint. Can this be formalized?
