# TV Map Regularity and the C(α) Bridge: Left Jumps at Rationals

**Date:** 2026-06-11
**Status:** TV side ✅ PROVEN (4 theorems + exhaustive verification); C side 🔬 NUMERICALLY VERIFIED (left discontinuity, DP-validated)
**Origin:** Open question #1 of the [Egyptian telescoping session review](../2026-04-01-egyptian-telescoping-revisited/README.md) (the TV map), plus Jan's intuition that the TV map's singular character "somewhat resembles C(α)" from the Beatty/ballot setting.

---

## Setup

For α with CF convergents $c_n = p_n/q_n$ (even-length convention at rationals):

$$\mathrm{TV}(\alpha) = \sum_{n \geq 1} |c_n - c_{n-1}| = \sum_{n \geq 1} \frac{1}{q_{n-1} q_n},
\qquad
\Sigma_\infty = \frac{\mathrm{TV} + \mathrm{frac}(\alpha)}{2}, \quad
\Sigma_{\text{tail}} = \frac{\mathrm{TV} - \mathrm{frac}(\alpha)}{2}.$$

**New identity (consecutive convergents straddle α):**

$$\Sigma_{\text{tail}}(\alpha) = \sum_{n \geq 1} \Big|\alpha - \frac{p_n}{q_n}\Big|
\qquad\Longleftrightarrow\qquad
\mathrm{TV}(\alpha) = \mathrm{frac}(\alpha) + 2\sum_{n \geq 1} \Big|\alpha - \frac{p_n}{q_n}\Big|.$$

The tail sum of the Egyptian split is exactly the **total approximation error of
the convergents**. (Check: 5/8 → 3/8 + 1/8 + 1/24 = 13/24 ✓ matches the
session table.)

## Literature: the error-sum function family (RESOLVED)

The question "is TV a known quantity?" resolves as follows (verified 2026-06-11):

- **Ridley & Petruska, "The error-sum function of continued fractions",
  *Indag. Math.* 11(2):273–282 (2000)** introduced
  $\mathcal{E}(\alpha) = \sum_n |q_n\alpha - p_n|$ (and the signed variant),
  expressed via partial quotients. Follow-up literature by Elsner and
  coauthors (value distributions, special values — 17 OEIS hits for
  "error sum"; analogues for Pierce/Lüroth expansions).
- **Baruchel & Elsner, arXiv:1602.06445** generalize to *split denominators*:
  $\sum_m \varepsilon_m (b_m\alpha - a_m/c_m)$. Our $\Sigma_{\text{tail}}$ is the
  member $b_m = 1$, $a_m/c_m = p_m/q_m$ — i.e., the **unweighted error sum**,
  while the "ordinary" theory uses weights $b_m = q_m$.
- Under the name "total variation of the convergent sequence" we found
  nothing; TV is an affine transform of a member of the studied family.
- Special value: $\mathrm{TV}(\varphi - 1) = H_F = \sum 1/(F_nF_{n+1})$ =
  **OEIS A290565**. The Pell analogue $H_P = \sum 1/(P_nP_{n+1}) =
  0.62013487806824872\ldots$ is **not in OEIS**.

---

## Part 1: TV regularity — all pre-registered hypotheses settled

Hypotheses were pre-registered in the Egyptian session README (2026-06-11,
morning) before any of today's computations.

### T1 (jump law) ✅ PROVEN
At rational $p/q \in (0,1)$ with canonical CF $[0; a_1..a_n]$, $a_n \geq 2$,
and $q^* = q_{n-1}$: subdividing the last convergent step under
$[\ldots,a_n] \to [\ldots,a_n{-}1,1]$ replaces $1/(q^*q)$ by
$1/(q^*(q-q^*)) + 1/((q-q^*)q)$, so

$$\mathrm{TV}_{\text{long}} - \mathrm{TV}_{\text{short}} = \frac{2}{(q-q^*)\,q}.$$

One-sided limits: extensions of the even-length representation lie above
$p/q$ (even-indexed convergents undershoot), extensions of the odd-length
below; tails vanish as the new quotient $K \to \infty$. Hence the two
one-sided limits are exactly the two representation values, the **right
limit equals the assigned (even-convention) value** — TV is
**right-continuous** — and the left jump has magnitude $2/((q-q^*)q)$ with
sign $(-1)^n$.
🔬 Verified: all 489 reduced fractions with $q \leq 40$ (exact arithmetic);
one-sided limits numerically at $K = 10^6$ (`01_tv_properties.wl`).

### T2 (continuity at irrationals) ✅ PROVEN
Prefix stability + uniform tail bound: $q_n \geq F_n$ gives
$\sum_{n>N} 1/(q_{n-1}q_n) \leq \sum_{n>N} 1/(F_{n-1}F_n) \to 0$ uniformly.

### T3 (nowhere monotone) ✅ PROVEN
Up-jumps and down-jumps are each dense (rationals with odd and even
canonical CF length are both dense), so TV is monotone on no interval.

### T4 (unique maximizer) ✅ PROVEN
Continuants are strictly increasing in every partial quotient, so all
$q_n$ are simultaneously minimized only by the all-ones CF:
$\mathrm{TV}(\alpha) \leq H_F$ with equality iff $\alpha \equiv \varphi - 1
\pmod 1$. 🔬 Spot-checked: max over 2000 random α was $1.77376 < H_F = 1.77388$.

### T5 (unbounded variation) — bonus
Total jump mass diverges: for fixed $q$, $\sum_{p} 2/((q-q^*)q) \approx
(2/q)\sum_{v \perp q} 1/(q-v) \sim 2\ln q \cdot \varphi(q)/q^2$, and
$\sum_q \ln q \cdot \varphi(q)/q^2 = \infty$. So TV is a bounded,
right-continuous function of **unbounded variation** on $(0,1)$.

### Correction to the pre-registered character hypothesis
"Minkowski-?-like singular function" was **wrong in an instructive way**:
? is continuous (purely singular-continuous, monotone); TV is a
**right-continuous jump function** with dense left jumps and unbounded
variation. Ironically, C(α) (continuous claim in the paper, monotone) was
*expected* to be the ?-like one — see Part 2 for how that inverted.

---

## Part 2: C(α) at rationals — left jumps, not kinks

### Pre-registered hypotheses (before computation)

- **H-B1** (continuity at rationals, following the paper's claim): one-sided
  limits of C both equal $C(p_0/q_0)$. *Falsified if either side differs by
  more than $10^{-6}$.*
- **H-B2** (kink): one-sided derivatives differ.
- **H-B3** (TV-template law): kink magnitude $\propto 2/((q-q^*)q)$;
  discriminator kink(6/5)/kink(7/5) ≈ 0.75 vs ≈ 1.0 for a q-only law.
- **H-B4**: C contains no additive TV-like component.
- **H-C1** (summability): jump/kink data on simple rationals cannot persist
  at the same rate for all rationals (monotone bounded C forces finite total
  anomaly mass) — predicted decay already at 10/7.
- **H-C2**: J(8/5) ≠ J(7/5) despite identical $(q, q^*) = (5, 2)$.

### Method

`exactCVal` (master equation $(2t-1)^q = t^{p+q}$ + q×q boundary system,
reused from `2026-04-13-boundary-correction/scripts/67_gap_survey.wl`, with
adaptive precision) evaluated along both CF-extension families
$[\mathrm{cf}, K]$ and $[\mathrm{cf}^-, 1, K]$, $K$ up to 30 (denominators up
to ~120); one-sided limits by Aitken/geometric extrapolation
(`02_C_kink_at_rationals.wl`, `04_jump_depth_law.wl`).

**Ground-truth validation** (`03_dp_crosscheck.wl`): `BeattyBallotCount` DP
($n \leq 350$, 1/n-fit estimator) vs boundary system:

| slope | DP | exact | agree |
|---|---|---|---|
| 34/23 (below 3/2) | 0.2237511 | 0.2237489 | ~6 digits ✓ |
| 35/23 (above 3/2) | 0.2527152 | 0.2527158 | ~6 digits ✓ |
| 3/2 | 0.2518498 | 0.2518482 | ~6 digits ✓ |

The one-sided structure is **real**, not a phase-convention artifact.

### Results: scorecard

- **H-B1 ❌ FALSIFIED from the left** (and ✅ confirmed from the right).
  C is **right-continuous with a left jump at every rational tested**:
  e.g. $\lim_{x \to 3/2^-} C(x) \approx 0.224566$ vs $C(3/2) = 0.2518482$.
  All from-above residuals were 20–1000× smaller than the left jumps and
  within extrapolation error of 0.
- **H-B2 superseded**: not a kink — a jump. The *right* derivative appears
  to be **0** (difference quotients from above decay geometrically,
  ~0.89 per K at 3/2): ?-like flatness from the right.
- **H-B3 ❌ as stated**: leading order is $J \approx c/q^2$ with
  $c \approx 0.11$–$0.14$, **not** $(q-q^*)$-shaped. Refined discriminator
  J(6/5)/J(7/5) ≈ 0.99 (TV law predicted 0.75).
- **H-B4 ✅ sharpened**: jump *ratios* of C don't match TV's
  (e.g. J(3/2)/J(4/3) ≈ 1.98 vs TV's 3.0), so $C \neq a + b\,\mathrm{TV}$
  even locally — but both functions live in the **same regularity class**.
- **H-C1 ❌ so far** (the surprise): no depth decay visible —
  $q^2 J(10/7) \approx 0.140$ is the *largest* in the sample.
  The summability tension is therefore **open and sharp** (see below).
- **H-C2 ✅**: J(8/5) = 0.00463 ≠ J(7/5) ≈ 0.00553 at identical $(q,q^*)$ —
  the jump law depends on the full Sturmian word, not on $(q, q^*)$ alone.

### Jump table (J = C(p/q) − left limit)

| $p/q$ | CF | $q^*$ | left limit | $C(p/q)$ | $J$ | $q^2 J$ |
|---|---|---|---|---|---|---|
| 3/2 | [1;2] | 1 | 0.224566 | 0.2518482 | 0.02728 | 0.109 |
| 4/3 | [1;3] | 1 | 0.177053 | 0.1908589 | 0.01381 | 0.124 |
| 5/3 | [1;1,2] | 1 | 0.272354 | 0.2841230 | 0.01177 | 0.106 |
| 6/5 | [1;5] | 1 | 0.1251298 | 0.1305095 | 0.005380 | 0.134 |
| 7/5 | [1;2,2] | 2 | 0.203800 | 0.2093269 | 0.00553 | 0.138 |
| 8/5 | [1;1,1,2] | 2 | 0.2627869 | 0.2674141 | 0.004627 | 0.116 |
| 10/7 | [1;2,3] | 3 | 0.2129092 | 0.2157644 | 0.002855 | 0.140 |

(Left limits: Aitken on K-ladders; 6/5 and 10/7 accurate to ~1e−4 and ~1e−5
respectively; others λ-fit, ±2e−4.)

### The summability paradox (sharpest open question)

C monotone bounded ⟹ $\sum_{p/q} J(p/q) < \infty$ over any interval. But
$J \approx 0.12/q^2$ for *all* coprime $p/q$ would give
$\sum_q \varphi(q) \cdot 0.12/q^2 = \infty$. Hence $J$ **must** decay for
typical (deeper-CF) rationals — yet through $q \le 7$ and depth ≤ 3 the
constant $c = q^2 J$ *grows* mildly. Resolution must lie at larger $q$ /
deeper words. **Discriminating experiment (designed, not yet run):** the
full row $J(p/13)$, $p = 17..23$ — denominators fixed, CF words varying in
depth (1 to 5) and quotient size.

### Consequence for `ruin-multinacci-bridge.tex` (erratum needed)

The claim (currently ~line 354 and §"fractal" item 4)
"*The function α ↦ C(α) is monotone increasing, continuous, and exhibits a
fractal kink hierarchy at every rational point*" is **contradicted** by
DP-validated computation: C is monotone increasing, **right-continuous**,
with a **left jump** at every rational tested (magnitude ~$0.12/q^2$ on
simple words), and right-derivative ≈ 0 at rationals. "Kink hierarchy" →
"left-jump hierarchy". Not edited in the paper (WIP review) — Jan decides.

---

## Verdict on the TV ↔ C bridge

**Jan's intuition vindicated, more strongly than predicted.** The honest
statement after today:

- **Same regularity class** (this is the hidden relation): both TV and C are
  right-continuous, continuous at irrationals (proven for TV, consistent
  for C), with a **left anomaly at every rational graded by the
  denominator**, produced by the same mechanism — the two CF representations
  of a rational = the two Sturmian phase families approaching it.
- **No functional relation** (the obvious non-relation): TV ignores $a_0$
  while C is strictly increasing; TV is nowhere monotone, C monotone;
  TV(p/q) ∈ ℚ, C(p/q) algebraic of growing degree; and the jump laws differ
  — TV's is exactly $2/((q-q^*)q)$, C's is ≈ $c/q^2$ with word-dependent
  $c$, not $(q,q^*)$-determined.
- **Synergy realized**: TV is the *exactly solvable model* of the class —
  its jump law suggested the right questions (one-sided limits, side of
  continuity, denominator grading) that exposed the C discontinuity in an
  afternoon; the error-sum literature (Ridley–Petruska, Elsner) is now
  connected to the C(α) circle of problems.

## Part 3: The jump law — q = 13 row, phase rotations, summability
(afternoon continuation; paper corrected first, see below)

### Paper correction applied

`ruin-multinacci-bridge.tex` corrected (≈line 354 claim; properties list;
subsection "Kinks at rationals" → "Left jumps at rationals" with the jump
table, DP-validation note, erratum sentence, summability constraint and
right-flatness observations; "kink hierarchy" wording downstream).
Compiles clean: 0 errors, 0 overfull, 0 undefined refs, 19 pp.

### H-D1 (phase rotation) ❌ FALSIFIED

Hypothesis: $C^-(p/q)$ equals the boundary-system constant with a rotated
Sturmian phase (would give jumps an exact algebraic closed form).
Result (`05_phase_rotation_test.wl`): **all** $q$ rotations give values
$\geq C(p/q)$ — the natural phase $j_0$ is the *minimum* of the rotation
family (side observation, all 7 targets) — and none matches $C^-$.
The left limit is a genuine limit object of growing systems.

### Methodological correction (important)

Script 06's Aitken extrapolation on the *non-uniform* ladder $\{3,4,5,7\}$
is invalid (for 14/13 it returned a limit *below* an increasing sequence).
All part-A limits were re-extracted with the explicit geometric model
$v_K = L - c\lambda^K$ fitted on uniform sub-ladders (two fits as a
bracket). Part B (α > 1.5) converges so fast that the correction is
negligible there. **Lesson: uniform K-ladders only.** Scripts 08+ use
uniform ladders.

### The q = 13 row (corrected values)

| $p/13$ | CF | α | $J \times 10^3$ | $q^2 J$ |
|---|---|---|---|---|
| 14/13 | [1;13] | 1.077 | 0.90–0.98 | 0.15–0.17 |
| 15/13 | [1;6,2] | 1.154 | 1.05 | 0.178 |
| 16/13 | [1;4,3] | 1.231 | 1.06 | 0.179 |
| 17/13 | [1;3,4] | 1.308 | 0.98 | 0.166 |
| 18/13 | [1;2,1,1,2] | 1.385 | 0.875 | 0.148 |
| 19/13 | [1;2,6] | 1.462 | 0.730 | 0.123 |
| 20/13 | [1;1,1,6] | 1.538 | 0.633 | 0.107 |
| 21/13 | [1;1,1,1,1,2] | 1.615 | 0.501 | 0.085 |
| 22/13 | [1;1,2,4] | 1.692 | 0.397 | 0.067 |
| 23/13 | [1;1,3,3] | 1.769 | 0.304 | 0.051 |
| 24/13 | [1;1,5,2] | 1.846 | 0.229 | 0.039 |
| 25/13 | [1;1,12] | 1.923 | 0.169 | 0.029 |

(Small-q revisions from the same re-extraction: $J(6/5) = 5.38\times10^{-3}$
($q^2J = 0.134$), $J(7/5) = 5.51\times10^{-3}$ (0.138); others unchanged.)

### Findings

- **H-E1 (strong word dependence at fixed q) ❌ — an Aitken artifact.**
  After correction, $c = q^2 J$ at $q = 13$ varies only mildly with the
  word and is dominated by a smooth **unimodal profile in α**: peak
  $c \approx 0.18$ near $\alpha \approx 1.2$, declining to $0.029$ at
  $\alpha = 1.92$.
- **Cross-q comparison at matched α:** slopes with the same leading
  quotient ($3/2$, $7/5$, $10/7$, $18/13$, $19/13$, all $a_1 = 2$) lie on
  one smooth curve; other CF families ($4/3$, $5/3$, $6/5$, $8/5$) sit
  off it by 25–50% — the constant $c$ has self-similar fine structure in
  α beyond the leading profile.
- **No decay through q = 13** at matched α — the summability-mandated
  decay has not set in yet. Budget analysis: jump mass spent on
  $(1,2)$ by $q \leq 13$ is ≈ 0.18 of the available
  $C(2) - C(1) = 0.382$; a uniform $c \approx 0.1$ stays consistent only
  up to $q \sim$ few hundred. The *local* sum rule on $(27/20, 29/20]$
  (scripts 08a/08b) measures the remaining headroom directly.

### Local sum rule on (27/20, 29/20] (scripts 08a/08b)

$C(29/20) - C(27/20) = 0.0263142$. Measured jumps inside (q ≤ 13 plus
the q = 20 endpoint):

| $r$ | 15/11 | 11/8 | 18/13 | 7/5 | 17/12 | 10/7 | 13/9 | 29/20 |
|---|---|---|---|---|---|---|---|---|
| $J \times 10^3$ | 1.286 | 2.364 | 0.875 | 5.505 | 0.972 | 2.854 | 1.680 | 0.271 |

Total $15.81 \times 10^{-3}$ = **60.1%** of the increase from just eight
jumps. The remaining $10.5 \times 10^{-3}$ must cover all $q \geq 14$
jumps plus any continuous part; with the plateau value
$c \approx 0.14$ persisting it would be exhausted by $q \approx 46$ —
forcing decay of $c$ in that range (or earlier, if a continuous part
exists).

### Integer slopes: closed form for the left limit (scripts 08b, 11)

$$\boxed{\;C^-(k) = \frac{\tau_k - 1}{2}, \qquad
J(k) = \frac{\tau_k - 1}{2\,\tau_k^{\,k+1}}\;}$$

🔬 Verified to **machine precision** at $k = 3$ (residual $2 \times
10^{-16}$) and $k = 4$ ($6 \times 10^{-17}$); $1.7 \times 10^{-8}$ at
$k = 2$ (slowest ladder convergence). Via the master-equation identity
$2 - \tau_k = \tau_k^{-k}$ this reads

$$1 - 2\,C^-(k) = \rho_k^{\,k}, \qquad \rho_k = 1/\tau_k$$

— the left limit is governed by the **k-th power of the ruin
probability** (the value by the first power, $C(k) = 1 - \rho_k$).
Asymptotics: $J(k) \sim 2^{-(k+2)}$. First exact anchor for the general
$C^-(p/q)$ closed-form problem. Added to the paper subsection (flagged
as numerically established).

### q = 29 discriminator: decay confirmed (script 09)

$J(41/29) = 1.196 \times 10^{-4}$, i.e. $q^2 J = 0.1006$ at
$\alpha = 1.4138$ — compared with $c \approx 0.136$–$0.148$ for the
same CF family ($a_1 = 2$) at $q = 5$–$13$ and $0.108$ at $q = 20$:

| q (family $a_1{=}2$, α ≈ 1.4) | 5 | 7 | 9 | 12 | 13 | 20 | 29 |
|---|---|---|---|---|---|---|---|
| $c = q^2 J$ | 0.138 | 0.140 | 0.136 | 0.140 | 0.148 | 0.108 | 0.101 |

**Decay onset at $q \approx 15$–$20$**; local exponent between q = 12
and q = 29 gives $J \sim q^{-2.3}$-ish — faster than $q^{-2}$, which
**restores summability** ($\sum_q \varphi(q)\, q^{-2.3} < \infty$).
The summability paradox resolves: the "constant" $c(\alpha, q)$ has a
plateau at small $q$ and decays slowly beyond $q \sim 15$. The precise
decay law (power? logarithmic? word-dependent?) is open.

### DP revalidation (script 10)

Script 07's K = 50 check was **invalid by design**: at $n = 350$ less
than the Beatty-word period (652–701), the DP reads a
parent-contaminated crossover — it returned ≈ $C(19/13)$ for 953/652, a
mirage that briefly suggested a slow second mode. Corrected check at
$n \gg$ period: DP for 149/102 (period 149) on the window
$n = 740..800$ gives $C = 0.22097496$ vs boundary-system
$0.22097476$ — agreement to $2 \times 10^{-7}$, decisively distinct
from the parent value $0.2217047$; the full $n = 1200$ run sharpens
this to $0.220974852$ (agreement $9 \times 10^{-8}$).
**The q = 13 row values stand.**
Bonus right-side check: 193/132 (initially mislabeled as a below-family
member; it lies *above* 19/13 — the below family is
$(19K{+}16)/(13K{+}11)$, not $(19K{+}3)/(13K{+}2)$) has
$C = 0.2217049$, just above $C(19/13) = 0.2217047$ — right-continuity
confirmed to $2 \times 10^{-7}$.
Lesson recorded: DP validation requires $n \gg$ word period.

## Part 4: General closed form for C⁻(p/q) (evening continuation)

**RESOLVED** — see [left-limit-closed-form.md](./left-limit-closed-form.md).
The $\varepsilon \to 0^+$ column-drop analysis ($\lfloor xm \rfloor$ drops
exactly at $q \mid m$) identifies the left limit as the **same periodic
walk with a sharpened barrier** (absorbing level 0 at phase 0):

$$C^-(p/q) = \frac{1 - \tilde\rho(s_0, j_0)}{2}, \qquad
J(p/q) = \frac{\tilde\rho(s_0,j_0) - \rho(s_0,j_0)}{2} \in \overline{\mathbb{Q}}$$

— one boundary row changes, everything else (roots, amplitudes) is shared.
🔬 Verified 25/25 measured left limits (best agreement $6 \times 10^{-11}$
at 8/5); integer case collapses to $\tilde\rho(s) = \rho^s$ ⟹
$1 - 2C^-(k) = \rho_k^k$. Coupling proof strategy (monotone + Chernoff)
recorded in the doc. Exact example: $J(3/2)$ has minimal polynomial
$64x^6-896x^5+4336x^4-7688x^3+2100x^2-528x+13$.
**Paper erratum #2 found and fixed:** the reduced quartic for slope 3/2 is
$t^4+t^3+t^2-3t+1$ with both sub-unit roots real (the displayed
$t^4+2t^3-2t^2-2t+1$ vanished at $t=1$ and was unrelated).

## Part 5: Right flatness + formal proofs (TeX note)

Both remaining regularity directions closed in one framework — see
**`docs/papers/c-alpha-one-sided-regularity.tex`** (4 pp, compiles clean):

- **Column-gain lemma (right side):** for $x = p/q + \varepsilon$ the
  allowance first changes at column $m \geq 1/(q\varepsilon)$ — the
  perturbation *recedes to infinity* (mirror of the left side, where the
  $q \mid m$ drop is immediate). Hence right-continuity, and with the
  Chernoff late-contact lemma:
  $0 \leq C(p/q+\varepsilon) - C(p/q) \leq A e^{-\kappa/\varepsilon}$ —
  **flat to infinite order from the right** (Theorem B).
- **Formalized coupling proofs**: Lemma 1 (column comparison), Lemma 2
  (late-contact Chernoff via $s_t > \alpha\tau_t - u_t + (\alpha-1)$,
  iid bound $\lambda_\theta = (e^{-\theta\alpha}+e^{\theta})/2 < 1$),
  Theorem A (left limit = sharpened-barrier constant, with exponential
  approach rate), Theorem B (right flatness), Theorem C (**continuity at
  every irrational**, stretched-exponential modulus by Diophantine type),
  Corollary (integer case $\rho^- = \rho_k^k$). Rigorous at the
  survival-probability level; the transfer to C inherits the paper's
  $C = \sigma/2$ identification.
- **H-R1 ✅ (pre-registered):** above-ladder gaps are geometric in $q_K$;
  measured per-column rates 0.929–0.934 (3/2), 0.899–0.903 (5/3),
  0.955–0.960 (4/3), all below the per-flip Chernoff bounds
  (0.980 / 0.969 / 0.990). True rate = time-direction spectral quantity,
  open. (`14_right_flatness_rate.wl`)
- Bridge paper updated: right-flatness and irrational-continuity bullets
  now cite the proven bounds (companion note added to `references.bib`).

**Local picture complete:** near each rational, C is a two-level step
function up to exponentially small corrections — value level
$C(p/q)$ on the right, level $C^-(p/q) = (1-\tilde\rho)/2$ on the left,
jump algebraic.

## Part 6: Theorem 0 — the foundation is now unconditional

The note (`c-alpha-one-sided-regularity.tex`, now 6 pp) gained the missing
base of the chain:

- **Theorem 0 (path-count identification):**
  $a_\alpha(n)/\binom{2n-1}{n-1} \to \sigma(\alpha)$ for **every** real
  $\alpha > 1$, with error $O(\log^2 n / n)$. Proof: prefix-comparison
  lemma (bridge vs free measure differs by $1 + O(T^2/n)$ on
  $T$-step prefixes — binomial ratio estimate) + bridge late-ruin lemma
  (hypergeometric $\tau_t$ + Hoeffding's sampling-without-replacement
  inequality gives $e^{-cT}$) + the free late-contact lemma. So
  $C(\alpha) = \sigma(\alpha)/2$ exists for all slopes — including
  irrationals, making Theorem C a statement about a genuine function.
- **Nonsingularity proposition:** the $q$-dim space of decaying interior
  solutions, evaluated at the boundary, is injective by a
  martingale-uniqueness argument (bounded martingale, $h \to 0$ on both
  absorption and escape) — so the (standard and sharpened) boundary
  systems are nonsingular and compute the probabilistic ruin functions.
  The last inherited assumption is gone.
- 🔬 Rate check (`15_theorem0_rate_check.wl`, α = 3/2): $n \cdot$err
  $= 0.6164, 0.6193, 0.6208, 0.6215, 0.6219$ at $n = 50..800$ — the true
  error is asymptotically $\approx 0.622/n$, consistent with (sharper
  than) the proven bound, and explains why the $1/n$-fit estimators in
  the survey scripts work.
- Bridge paper: remark added after eq. (C-rational) — the Definition is
  now a theorem; the 20-digit table is an implementation check.

**The full chain — path counts → survival → boundary systems → left-jump
closed form, right flatness, irrational continuity — is self-contained.**

## Open directions (gate-checked)

1. **Exact sum rules / pure-jump question:** $J(p/q)$ is now computable
   exactly for any rational — redo the local sum rule with exact jumps to
   large $q$ and test whether the continuous part of C is 0
   (C = pure jump function, the monotone sibling of TV).
2. **Decay law of $c(\alpha, q)$, now algebraic:** $J = (\tilde\rho - \rho)/2$
   is a one-row perturbation — Cramer's rule gives $J$ as a determinant
   ratio in the root data; derive the plateau + decay (onset
   $q \approx 15$–$20$ at $\alpha \approx 1.4$) asymptotically.
3. **Closed form for the contraction rate $\mu(\alpha)$** (time-direction
   spectral quantity behind the $e^{-\kappa/\varepsilon}$ laws; measured
   0.90–0.96 per column); same circle: the clean $1/n$-correction constant
   of Theorem 0 (≈ 0.622 at 3/2).
4. **Publication shape:** the note now carries five self-contained
   results; decide whether it stays a companion note or merges into the
   bridge survey as a proofs section.

### Considered and rejected (2026-06-11)

- **Affine/functional relation C ↔ TV**: killed by jump-ratio mismatch
  (1.98 vs 3.0) and H-C2 (word dependence vs $(q,q^*)$ dependence).
- **TV-template jump law for C** (H-B3): killed by refined discriminator
  J(6/5)/J(7/5) ≈ 0.99.
- **Phase-rotation closed form for $C^-$** (H-D1): killed by
  `05_phase_rotation_test.wl` — all rotations lie above $C(p/q)$.
- **Strong word dependence at fixed q** (H-E1): an artifact of Aitken on
  non-uniform ladders; corrected extraction shows a smooth α-profile with
  only mild word fine structure.

## Files

- `scripts/01_tv_properties.wl` — TV theorems verification (jump law q≤40, one-sided limits, maximizer)
- `scripts/02_C_kink_at_rationals.wl` — one-sided C along CF-extension families, 5 targets
- `scripts/03_dp_crosscheck.wl` — DP ground-truth validation of the discontinuity
- `scripts/04_jump_depth_law.wl` — 10/7, 8/5, 6/5 jump refinement (H-C1, H-C2)
- `scripts/05_phase_rotation_test.wl` — H-D1 falsified: C⁻ ≠ any phase rotation; j₀ = min over rotations
- `scripts/06a/06b_q13_row.wl` — full jump row J(p/13), p = 14..25 (part A re-extracted, see methodological correction)
- `scripts/07_dp_limit_validation.wl` — flawed as designed (n < word period ⟹ parent-contaminated crossover; kept as a cautionary record)
- `scripts/08a_sum_rule.wl`, `scripts/08b_endpoint_and_integers.wl` — local sum rule on (27/20, 29/20]; integer jumps J(2), J(3)
- `scripts/09_q29_discriminator.wl` — J(41/29): decay of c at q = 29 confirmed
- `scripts/10_dp_revalidation.wl` — corrected DP validation (n ≫ period) of the q=13-row family
- `scripts/11_integer_closed_form.wl` — C⁻(k) = (τ_k−1)/2 to machine precision (k = 3, 4)
- `scripts/12_general_left_limit_formula.wl` — sharpened-barrier closed form vs all 25 measured left limits
- `scripts/13_formula_precision_test.wl`, `scripts/13b_exact_J32.wl` — 10⁻¹¹ precision test; exact algebraic J(3/2)
- [`left-limit-closed-form.md`](./left-limit-closed-form.md) — derivation, proof strategy, verification, erratum #2
- Parent sessions: [Egyptian telescoping](../2026-04-01-egyptian-telescoping-revisited/README.md), [boundary correction](../2026-04-13-boundary-correction/INTERPOLATION-SCHEME.md), [polynomial invariants](../2026-04-11-polynomial-invariants/README.md)
