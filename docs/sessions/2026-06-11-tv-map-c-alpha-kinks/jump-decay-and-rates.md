# The Jump Law: Renewal Formula, Cramér Rate μ(α), and the Pure-Jump Verdict

**Date:** 2026-06-11 (directions 1–3 of the continuation session)
**Status:** renewal formula ✅ exact identity; μ(α) 🔬 verified to 2.7×10⁻⁴ (derivation sketch below, rigorous LDP proof open); pure jump 🔬 confirmed to 0.03% of ΔC

---

## 1. Renewal formula for the jump (exact)

The standard and sharpened boundary systems differ in one row;
Sherman–Morrison gives, with $w = M^{-1}e_0$ (the harmonic-measure vector
of the phase-0 boundary state):

$$\boxed{\;J(p/q) \;=\; \frac{H_0(s_0, j_0)\,\bigl(1 - \rho(0,0)\bigr)}{2\,h(0,0)}\;}$$

- $H_0(s_0,j_0) = \sum_i w_i A_{j_0}^{(i)} t_i^{s_0}$ — probability that
  ruin happens **at a phase-0 column** (the columns $q \mid x$, where the
  left-perturbation dips), starting from the start state;
- $1 - \rho(0,0)$ — survival probability from the dip state;
- $h(0,0) = \sum_i w_i$ — phase-0 ruin probability from the dip state
  itself; numerically $h(0,0) = \tfrac12 + (\text{exp. small})$, since
  from $(0, 0)$ the immediate up-step (probability $\tfrac12$) is a
  phase-0 ruin.

Verified to machine precision on 10 rationals
(`18_renewal_identity.wl`); for $q = 1$ it reduces algebraically to the
proven $J(k) = \rho^k(1-\rho)/(2\rho) = (\tau_k-1)/(2\tau_k^{k+1})$.
Asymptotically $J \approx H_0 \cdot (1 - \rho(0,0))$: **all the decay
lives in $H_0$** — the probability of ruining as late as column
$q, 2q, \ldots$

## 2. The decay law and the Cramér rate

Between consecutive right-steps the up-step count is Geometric(1/2), so
per column the gap moves by $r_j - G$, $E\,e^{\theta G} = 1/(2 - e^\theta)$.
The probability of barrier contact at column $m$ decays at the tilted
(Cramér) rate, averaged over the period ($\sum r_j / q = \alpha$):

$$\mu(\alpha) \;=\; \inf_{0 < e^\theta < 2} \frac{e^{-\theta\alpha}}{2 - e^\theta}
\;=\; \frac{(\alpha+1)^{\alpha+1}}{2^{\alpha+1}\,\alpha^{\alpha}},
\qquad e^{\theta^*} = \frac{2\alpha}{\alpha+1}.$$

Hence the **asymptotic jump law** $J(p/q) \approx B(\alpha)\,
\mu(\alpha)^{\,q}\, q^{-3/2}$ — exponential in $q$, not polynomial.
The observed $c/q^2$ plateau is the pre-asymptotic diffusive regime; the
crossover sits at $q^* \sim (\alpha-1)^{-2}$ (drift must beat diffusion
at the first dip column $x = q$), which retro-explains the unimodal
$q^2 J$ profile of the $q = 13$ row and the onset at $q \approx 15$–$20$
for $\alpha \approx 1.4$.

### Three independent confirmations of μ(α)

| observable | slope | measured | $\mu(\alpha)$ theory | agreement |
|---|---|---|---|---|
| jump decay, √2 convergents $q: 70 \to 169$ | √2 | 0.96466 | 0.964920 | **2.7×10⁻⁴** |
| right-flatness ladder (q^{-3/2}-corrected) | 3/2 | 0.9532 | 0.95090 | 0.24% |
| right-flatness ladder | 5/3 | 0.9212 | 0.91914 | 0.22% |
| right-flatness ladder | 4/3 | 0.97878 | 0.97640 | 0.24% |
| sum-rule tail model (q = 40..60, B-spread) | ~1.4 | consistent | 0.96707 | ~9% spread |

The √2-family data (`17_sqrt2_family_decay.wl`):
$J(17/12) = 9.717{\times}10^{-4}$, $J(41/29) = 1.1963{\times}10^{-4}$,
$J(99/70) = 6.5613{\times}10^{-6}$, $J(239/169) = 4.9625{\times}10^{-8}$
($q^2 J$: 0.140, 0.101, 0.032, 0.0014 — the "constant" collapses past
the crossover).
The 0.2% offsets on the ladder observables are consistent with
higher-order prefactor corrections; the deep two-point jump fit is the
cleanest.

## 3. Exact sum rule and the pure-jump verdict

All jumps with $q \leq 60$ in $(27/20, 29/20]$, computed exactly
(`16_exact_sum_rule.wl`, 52 contributing denominators):

$$\sum_{q \leq 60} M(q) = 0.0250239 \;=\; 95.10\%\ \text{of}\
\Delta C = 0.0263142, \qquad S(60) = 1.2903{\times}10^{-3}.$$

Tail extrapolation with the **theoretical** μ (one fitted constant $B$,
relative spread 9% over $q = 40..60$; spot checks within ~10%):

$$\sum_{q = 61}^{600} M(q)\big|_{\text{model}} = 1.2837{\times}10^{-3}
\qquad\Longrightarrow\qquad
\text{continuous part} \;=\; 6.6{\times}10^{-6} \;\approx\; 0.03\%\ \text{of}\ \Delta C,$$

zero within the fit uncertainty (±1.2×10⁻⁴).

**Verdict (🔬):** on the tested interval, C is a **pure jump function**:

$$C(\beta) - C(\alpha) \;=\; \sum_{r \in (\alpha, \beta] \cap \mathbb{Q}} J(r),$$

the strictly increasing, dense-jump sibling of TV's purely atomic
variation. (Not implied by right-flatness — Minkowski's ? is flat at
rationals yet continuous — so this is a genuinely new structural
statement; an analytic proof would amount to summing the renewal jump
law exactly and is open.)

## Pre-registration scorecard

- **H-S1** (sum rule ≥85%, exponential per-q decay, zero continuous
  part within error) ✅ — 95.1% + tail, continuous part 0.03% ± 0.5%.
- **H-S2** (√2-family follows $\mu^q q^{-3/2}$, J(99/70) ≈ 7×10⁻⁶ not
  2×10⁻⁵) ✅ — measured 6.56×10⁻⁶; the q = 169 point decisive
  (4.96×10⁻⁸ vs 3.5×10⁻⁶ for the 1/q² law).
- **H-S3** (renewal identity) ✅ — machine precision, 10 rationals.

## Remaining open

1. **Prove** the pure-jump identity (analytic summation of the jump law).
2. **Prove** $\mu(\alpha)$ rigorously (local large-deviation theory for
   the killed periodic column chain; the formula is the standard Cramér
   tilt, machinery exists).
3. The Theorem 0 finite-size constant ($n \cdot \text{err} \to 0.622$ at
   $3/2$) — same spectral circle, underived.

## Files

- `scripts/16_exact_sum_rule.wl` — exact jumps q ≤ 60 on (1.35, 1.45]
- `scripts/17_sqrt2_family_decay.wl` — J along √2 convergents to q = 169
- `scripts/18_renewal_identity.wl` — Sherman–Morrison renewal formula check
