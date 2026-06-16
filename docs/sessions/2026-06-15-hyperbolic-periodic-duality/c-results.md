# C (speculative sprint) — null: integrality is not dynamically special in the cocycle

**Date:** 2026-06-15
**Status:** ❌ NULL (pre-registered prediction held) — bounded ~1-session sprint
on the "integrality ↔ Avila acceleration / cocycle reality" bridge. Fall back to
A/B as agreed.
**Scripts:** [`scripts/c-prime-cocycle-lyapunov.wl`](scripts/c-prime-cocycle-lyapunov.wl),
[`scripts/c-ensemble-disambiguation.wl`](scripts/c-ensemble-disambiguation.wl)

## The idea (made precise)

Integrality $=$ the $\mathbb{Q}$-linear independence of $\{\log p\}$ (this *is*
unique factorization: no nontrivial $\sum a_p\log p=0$), so the cocycle's
frequency module is a **free $\mathbb{Z}$-module on the primes**, with additive
closure $\{\log n\}$. Avila's acceleration is integer-quantized; the hope:
the quantization (integrality) forces subcriticality (zero Lyapunov $=$ real
spectrum $=$ RH). **Foundational test:** is the prime-frequency structure
*dynamically special* in a quasiperiodic transfer cocycle (vs generic)? If not,
the bridge has no mechanism.

## What was run

A Schrödinger transfer cocycle $T_n(E)=\bigl(\begin{smallmatrix}E-V_n&-1\\1&0\end{smallmatrix}\bigr)$,
$V_n=\sum_{p\le113}\tfrac{\log p}{p^{\sigma}}\cos(n\log p+\phi_p)$ (explicit-formula
amplitudes, prime frequencies), Lyapunov exponent $L$ by renormalized transfer
products (compiled, $N=10^4$).

**First pass** (prime vs uniform-random control): at strong coupling ($\sigma=1/2$)
$L_{\rm prime}\approx L_{\rm gen}$ (amplitude-driven, as predicted), but at weak
coupling $L_{\rm prime}$ ran up to $2.3\times$ larger — *suggestive*. But the
uniform control had the **wrong frequency density** (the $\log p$ bunch differently
than uniform), confounding "integrality" with "density."

**Disambiguation** (the clean control): compare $L_{\rm prime}$ (exact $\log p$
lattice) to an **ensemble of broken-lattice controls** $\omega_p=\log p+
\mathrm{Unif}[-0.25,0.25]$ — *same density and magnitudes*, but the additive
lattice $\log p+\log q=\log(pq)$ is destroyed. $L$ averaged over $E\in\{0,1\}$,
20 draws:

| $\sigma$ | $L_{\rm prime}$ | $\langle L_{\rm ctrl}\rangle\pm\mathrm{std}$ | $z$ |
|---|---|---|---|
| 0.6 | 0.3117 | $0.3128\pm0.0054$ | $-0.20$ |
| 0.7 | 0.2040 | $0.2053\pm0.0076$ | $-0.17$ |
| 0.8 | 0.1274 | $0.1289\pm0.0085$ | $-0.17$ |
| 0.9 | 0.0778 | $0.0800\pm0.0100$ | $-0.22$ |
| 1.0 | 0.0450 | $0.0491\pm0.0111$ | $-0.37$ |

## Verdict — NULL

$L_{\rm prime}$ is **within the broken-lattice spread** ($|z|<0.4$ everywhere,
even slightly below the mean). So:

- the earlier apparent signal was **frequency density**, not the integer lattice;
- the **exact integrality** ($\{\log p\}$ being a free module / unique
  factorization) is **dynamically invisible** to the cocycle's Lyapunov — it sees
  only the frequency density and the amplitudes;
- therefore "integrality forces spectral reality via the cocycle" has **no
  mechanism at this level**: the optimistic version of C is dead.

## Honest scope

This tested a **toy** generic Schrödinger cocycle carrying prime frequencies, not
the true zeta operator (which we do not have). It does *not* prove integrality is
irrelevant to RH; it kills the *naive mechanism* (prime-frequencies-make-the-
cocycle-special). The full Avila-acceleration version needs the actual cocycle,
which is inaccessible. Per the agreed plan, **fall back humble to A or B** — A
(form factor / pair correlation, extending L0, tying to the $\kappa=\pi$ wall) is
the natural next computable step.

Bottom line: the speculative cocycle/acceleration bridge is, at the accessible
(toy) level, **null** — integrality is not dynamically special in a
prime-frequency cocycle.
