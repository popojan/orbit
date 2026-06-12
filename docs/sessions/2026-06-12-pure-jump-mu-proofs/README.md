# Pure-Jump Theorem, Exact Decay Rate μ(α), and the Finite-Size Constant

**Date:** 2026-06-12
**Status:** all three remaining open items of the 2026-06-11 session closed
**Origin:** continuation of [2026-06-11-tv-map-c-alpha-kinks](../2026-06-11-tv-map-c-alpha-kinks/README.md); Jan approved the proof strategy and the order 1 → 2 → 3.

All formal results live in `docs/papers/c-alpha-one-sided-regularity.tex`
(now 8 pp, compiles clean).

## 1. Theorem D — C is a pure jump function ✅ PROVEN

$$C(\beta) - C(\alpha) = \sum_{r \in (\alpha,\beta] \cap \mathbb{Q}} J(r),
\qquad C' = 0 \text{ a.e.}$$

Proof: **Dirichlet covering + uniform two-sided exponential flatness.**
The decisive cancellation (gate-checked by Jan): at scale
$\delta = 1/(qQ)$ the flatness exponent is $1/(q\delta) = Q$,
*independently of q* — so each of the $\sim Q^2$ covering intervals
contributes $\leq 2A\lambda^Q$ and $Q^2 \lambda^Q \to 0$.
Required a new **uniform-constants lemma** (single Chernoff tilt for a
compact slope interval; small-$M$ cases absorbed into $A$).
Note: flatness alone does NOT suffice (Minkowski's ? is flat at rationals
yet continuous) — the quantitative uniform rate is what powers the
covering. C is thus the distribution function of a purely atomic measure
with algebraic weights on the Farey fractions — the strictly increasing
sibling of TV's purely atomic variation, completing the arc that began
with the TV ↔ C(α) analogy.

## 2. Theorem E — exact exponential decay rate ✅ PROVEN (exponential order)

For the contact events $K_m$ (gap ≤ c₀ in column m):

$$\lim_m \tfrac1m \log P(K_m \cap \text{surv}) = \log \mu(\alpha),
\qquad \mu(\alpha) = \frac{(\alpha+1)^{\alpha+1}}{2^{\alpha+1}\alpha^\alpha}$$

- **Upper bound:** Chernoff via negative binomial — up-steps between
  right-steps are iid Geom(1/2), $E e^{\theta G} = 1/(2-e^\theta)$;
  contact in column $m$ forces $U_{m+1} \geq \alpha(m+1) - 1 - c_0$.
  Half-page, exact, works for ALL real α > 1.
- **Lower bound:** Cramér tilt to Geom with mean α (= the θ*-tilt) +
  explicit scenario (lift $\asymp\sqrt m$, Kolmogorov middle, forced dive)
  costing only $e^{-c\sqrt m}$ — subexponential, enough for the rate.
- **Corollary (jump decay):** via the renewal formula,
  $c_1 e^{-c\sqrt q}\mu^q \leq J(p/q) \leq c_2 \mu^q$, i.e.
  $J(p/q) = \mu(p/q)^{q(1+o(1))}$ — rigorous for every rational, no
  family-uniformity needed (H₀ is a fixed-chain quantity).
  Geometric summability of the jump series follows.

**Independent numerical confirmation #2 (pre-registered H-T1 ✅):**
golden-ratio convergents $F_{k+1}/F_k$, $q = 5..89$, exact J via the
sharpened-barrier system (`scripts/19_fib_family_rate.wl`):
per-column rates ($q^{-3/2}$-corrected) climb 0.8885 → 0.9166 → 0.9186 →
0.9260 → 0.9278 → **0.928947** vs theory $\mu(\varphi) = 0.929004$ —
agreement $5 \times 10^{-5}$ at the deep end. (√2 family gave
$2.7 \times 10^{-4}$ yesterday.) The sharp $q^{-3/2}$ prefactor remains
open (stated as such in the note).

## 3. The finite-size constant c₁ ✅ DERIVED + verified (closed form open)

First-order RN expansion of the prefix weight (mean-zero check passes):

$$c_1(\alpha) = \tfrac12 \lim_T E\bigl[\mathbf 1_{\text{surv}\leq T}
(\tfrac T2 - D_T - \tfrac{D_T^2}2)\bigr]
= \tfrac12 E\bigl[D_R + \tfrac{D_R^2 - R}{2};\ \text{ruin}\bigr]$$

(second form by optional stopping at the ruin time; UI from exponential
ruin tails). Exact DP at α = 3/2 (`scripts/20_finite_size_constant.wl`,
T ≤ 600, survival cross-check matches σ to 8 digits):

| T | 100 | 200 | 300 | 400 | 500 | 600 |
|---|---|---|---|---|---|---|
| L_T/2 | 0.2845 | 0.5600 | 0.6122 | 0.6207 | 0.62203 | 0.62222 |

→ **c₁(3/2) = 0.622225...**, matching the independently measured
n·err → 0.6219 (extrapolated ≈ 0.6223) from script 15. Pre-registered
H-T2 ✅. Closed form would follow from the joint ruin-time/position
generating function — left open (noted in the paper remark).

## Files

- `scripts/19_fib_family_rate.wl` — Fibonacci-family μ confirmation
- `scripts/20_finite_size_constant.wl` — c₁ DP + survival cross-check
- `../../papers/c-alpha-one-sided-regularity.tex` — Theorems D, E,
  Corollary (jump decay), uniform-constants lemma, finite-size remark

## Remaining open (gate-checked)

1. Sharp polynomial prefactor in Theorem E (empirically $q^{-3/2}$) —
   local CLT for the tilted killed chain; needed only for aesthetics.
2. Closed form for $c_1(\alpha)$ via the ruin-time GF (the OST reduction
   makes it a finite algebra problem for small q).
3. Publication shape (Jan): the note now carries Theorem 0,
   nonsingularity, A–C, closed-form jumps, pure-jump Theorem D,
   rate Theorem E + corollary, and the c₁ derivation.
