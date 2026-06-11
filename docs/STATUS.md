# Mathematical Explorations - Status Tracker

**Repository:** popojan/orbit
**Last Updated:** June 11, 2026

---

## June 11, 2026: C(α) has LEFT JUMPS at rationals (not kinks); TV map fully resolved

### Status
TV side ✅ PROVEN; C side 🔬 NUMERICALLY VERIFIED (DP-validated to ~6 digits) — **falsifies the continuity claim in `ruin-multinacci-bridge.tex` (~line 354), erratum needed.**

### Summary
Follow-up on the Egyptian-telescoping TV map (Σ_∞ = (TV+frac)/2) and Jan's intuition that its singular character resembles C(α):

1. **TV theorems (all pre-registered hypotheses settled):** right-continuous; left jump at every rational of exact magnitude 2/((q−q*)q), sign (−1)^n; continuous at irrationals; nowhere monotone; unique max H_F = A290565 at noble numbers; unbounded variation. New identity: Σ_tail = Σ|α − p_n/q_n| (total convergent approximation error).
2. **Literature resolved:** TV is an affine transform of the *unweighted* error-sum function — family introduced by Ridley & Petruska (Indag. Math. 11(2):273–282, 2000), split-denominator generalization Baruchel–Elsner arXiv:1602.06445. H_P = Σ1/(P_nP_{n+1}) not in OEIS (submission candidate).
3. **C(α) discovery:** at every rational tested (3/2, 4/3, 5/3, 6/5, 7/5, 8/5, 10/7), C is **right-continuous with a left jump** J ≈ (0.11–0.14)/q²; right-derivative ≈ 0. E.g. lim_{x→3/2⁻} C = 0.224566 vs C(3/2) = 0.251848. Validated against BeattyBallotCount DP (no phase artifact). Jump law depends on the full Sturmian word: J(7/5) ≠ J(8/5) at identical (q, q*).
4. **Summability paradox (open):** monotone bounded C forces ΣJ < ∞, but measured c = q²J does not decay through q ≤ 7 — decay must set in for deeper words; discriminating q=13 row experiment designed.
5. **Bridge verdict:** TV and C share the regularity class (right-continuous, left anomalies at ℚ graded by denominator, same two-CF-representation mechanism) but admit **no functional relation** (jump-ratio mismatch; word- vs (q,q*)-dependence).

### Afternoon continuation (same day)
6. **Paper corrected:** `ruin-multinacci-bridge.tex` — continuity claim replaced by right-continuity + left-jump hierarchy; new subsection "Left jumps at rationals" with measured table, summability constraint, right-flatness; compiles clean (19 pp).
7. **Integer closed form (NEW):** 🔬 C⁻(k) = (τ_k−1)/2, i.e. J(k) = (τ_k−1)/(2τ_k^{k+1}), equivalently 1−2C⁻(k) = ρ_k^k (k-th POWER of the ruin probability) — machine precision at k=3,4; J(k) ~ 2^{−(k+2)}. Phase-rotation closed form for C⁻(p/q) falsified (all rotations ≥ C; natural phase j₀ = min).
8. **q=13 row + methodological fix:** Aitken on non-uniform K-ladders is invalid (caught via an increasing sequence "converging" below itself); re-extraction gives smooth unimodal c(α) = q²J profile (peak ≈ 0.18 at α ≈ 1.2), mild word fine structure, NO strong word dependence (H-E1 was an artifact).
9. **Summability resolved in principle:** local sum rule on (27/20, 29/20]: eight measured jumps = 60.1% of ΔC = 0.0263; budget forces decay of c by q ≈ 46. Measured: c(q=20) = 0.108, c(q=29) = 0.1006 vs plateau 0.136–0.148 (q ≤ 13, same CF family) — decay onset q ≈ 15–20, local exponent J ~ q^{−2.3} ⟹ jump mass summable. Precise decay law open.

### Evening continuation: GENERAL CLOSED FORM for C⁻(p/q)
10. **The left-jump hierarchy is algebraic.** Column-drop analysis (⌊xm⌋ drops exactly at q | m as x → p/q⁻) identifies the left limit as the same periodic Sturmian walk with a **sharpened barrier** (absorbing level 0 at phase 0): C⁻(p/q) = (1 − ρ̃(s₀,j₀))/2, J(p/q) = (ρ̃ − ρ)/2 — one boundary row changes, roots/amplitudes shared. 🔬 Verified 25/25 measured left limits, best agreement 6×10⁻¹¹ (8/5); integer case collapses to ρ̃(s) = ρ^s ⟹ ρ⁻ = ρ_k^k. Coupling proof strategy (monotone + Chernoff) recorded in `left-limit-closed-form.md`. Exact example: J(3/2) has minpoly 64x⁶−896x⁵+4336x⁴−7688x³+2100x²−528x+13.
11. **Paper erratum #2 fixed:** the reduced quartic for slope 3/2 is t⁴+t³+t²−3t+1 with both sub-unit roots real (displayed t⁴+2t³−2t²−2t+1 vanished at t=1, unrelated to the master equation). Closed form added to the paper subsection; compiles clean.

### Late evening: right flatness + formal proofs (TeX note)
12. **Right side resolved + proofs formalized:** new 4pp note `docs/papers/c-alpha-one-sided-regularity.tex` — column-gain lemma (right perturbation recedes to infinity: first change at m ≥ 1/(qε)) + Chernoff late-contact lemma ⟹ **Theorem A** (left limit = sharpened-barrier constant, exponential approach), **Theorem B** (0 ≤ C(p/q+ε)−C(p/q) ≤ Ae^{−κ/ε}: flat to infinite order from the right), **Theorem C** (continuity at every irrational, stretched-exponential modulus by Diophantine type). Rigorous at survival level; transfer to C inherits the paper's C = σ/2 identification (verified 20+ digits, not yet proven — flagged in the note). H-R1 ✅: measured per-column rates 0.93/0.90/0.96 (3/2, 5/3, 4/3) below Chernoff bounds. Bridge paper bullets updated to cite the proven bounds.

### Night cap: Theorem 0 — foundation unconditional
13. **Path-count identification PROVEN:** a_α(n)/binom(2n−1,n−1) → σ(α) for every real α > 1, error O(log²n/n) (prefix-comparison + Hoeffding sampling-without-replacement + free Chernoff). **Nonsingularity of the boundary systems PROVEN** (martingale uniqueness). The whole chain — path counts → survival → boundary systems → left-jump closed form, right flatness, irrational continuity — is now self-contained; the 20-digit tables demote to implementation checks. Rate check at 3/2: n·err → 0.622 (clean 1/n, sharper than the bound). Note grew to 6 pp; bridge paper Definition (C-rational) upgraded to theorem status via remark.

### Verification
`docs/sessions/2026-06-11-tv-map-c-alpha-kinks/scripts/01–15` (TV exact q≤40; boundary-system one-sided ladders; DP cross-checks at n ≫ word period — n.b. script 07's K=50 DP check was invalid by design, n < period, see session README; closed form 25/25 + 6×10⁻¹¹ precision test + exact algebra for 3/2; right-flatness rates script 14; Theorem 0 rate check script 15).

### Directions 1–3 closed (same day, continuation)
14. **Renewal formula (exact):** J = H₀(s₀,j₀)(1−ρ(0,0))/(2h(0,0)) via Sherman–Morrison on the one differing boundary row; machine precision on 10 rationals; reduces to the integer formula at q=1. All decay lives in H₀ = P(ruin at a phase-0 column).
15. **Decay law + Cramér rate:** J ≈ B(α)·μ(α)^q·q^{−3/2} with **μ(α) = (α+1)^{α+1}/(2^{α+1}α^α)** (tilt of the column chain r_j − Geom(1/2)); √2-family to q=169: μ_emp = 0.96466 vs 0.96492 (2.7×10⁻⁴); same μ matches right-flatness ladders (0.2–0.3%). The c/q² plateau is pre-asymptotic; crossover q* ~ (α−1)⁻² explains the unimodal q²J profile.
16. **Pure-jump verdict 🔬:** exact sum rule on (27/20, 29/20]: q≤60 jumps = 95.10% of ΔC; tail model with theoretical μ ⟹ continuous part = 6.6×10⁻⁶ ≈ 0.03% of ΔC (zero within error). C(β)−C(α) = Σ J(r) — pure jump function, the monotone sibling of TV.

### Open
- Prove pure-jump (analytic summation of the renewal jump law); prove μ(α) via local LDP for the killed periodic column chain; derive the 0.622 constant of Theorem 0's 1/n term; publication shape (companion note vs merge into bridge survey).

---

## June 10, 2026: Sandwich bounds for C(α) — lower bound proven for ALL α > 1, unconditional upper bound

### Status
✅ **PROVEN** — the "conjectured extension to all α > 1" of the lower bound is now a theorem; new unconditional upper bound; smooth upper bound (C ≤ 1−ρ₀) remains 🤔 CONJECTURE.

### Summary
Both results flow from the telescoped **gap process** of the Sturmian ruin walk (now eq. gap-process in `ruin-multinacci-bridge.tex`): after τ right-steps and u up-steps, $s = \lfloor\alpha(\tau+1)\rfloor - u$, and $C = (1-\rho)/2$.

1. **Lemma (Lundberg):** $\rho(\alpha) \le \exp(-4\alpha(\alpha-1)/(\alpha+1)^2)$ for all real α > 1 — exponential supermartingale $e^{-\theta Y_t}$, $Y_t = X_t + \varepsilon t$, $\theta = 2\varepsilon$, using only ⌊x⌋ ≥ x−1 and ln cosh θ ≤ θ²/2.
2. **Lower bound for all α > 1:** $L(\alpha) \ge 1/2 - 2^{-\alpha}$ ⟺ $h(\alpha) = 4\alpha - \ln 2(\alpha+1)^2 \ge 0$; h concave, h(1), h(2) > 0 ⟹ covers (1,2); integer-anchor argument covers α ≥ 2. **The planned DFT/Vandermonde program (q·C → 1 rigor) is bypassed entirely** — no partition, no anchors. Old Case 2 deleted.
3. **Unconditional upper bound:** $C(\alpha) \le U(\alpha) = (1-\rho_0^{\alpha+2})/2$ via coupling s ≤ σ (smooth gap) + the exact martingale $\rho_0^{\sigma_t}$; overshoot σ_T ∈ (−2,−1] gives the exponent α+2. Since $C_{\rm smooth} = (1-\rho_0^{\alpha+1})/2$, the conjecture is exactly "remove one factor ρ₀" — the overshoot. Sandwich now unconditional.
4. **Monotonicity lemma** (coin-flip coupling): retroactively rigorizes the monotonicity steps of the old proof.
5. Errata: §5.1–5.2 transposed-staircase inconsistency (S = ⌊qx/p⌋ vs r_j of ⌊px/q⌋) fixed minimally.

### Verification
`sessions/2026-06-10-sandwich-lower-bound/scripts/sandwich_verification.wl`: exact C(p/q) solver reproduces paper table 6/6 + C(k) = 1−1/τ_k; sandwich L ≤ C ≤ U on 66 coprime slopes, 0 violations (min slack C−L = 0.031, U−C = 0.009); h-roots 0.287/3.4837.

### Open
- Tight upper bound C ≤ 1−ρ₀ (Conjecture): the remaining factor ρ₀ = overshoot of the smooth walk; a ladder-height/renewal analysis of the overshoot distribution is the natural next attack.

---

## June 10, 2026: R7 block-transfer correction formula — proven for all q₁

### Status
✅ **PROVEN** — former Open Problem 1 of `ballot-closed-form.tex` resolved; draft index errata found and fixed.

### Summary
The central correction formula (R7) of the closed-form state vector paper,

$$\Delta[d_0{+}d, s] = \sum_{m=1}^{d+1} v_{d-m+1}(p_1 - wm)\,\binom{d_0-2+m(w{+}1)-s}{mw-1},$$

previously verified symbolically only for $q_1 \leq 9$, is now **proven for all $q_1, w, d_0, s$** via a three-step linearity/self-similarity argument:

1. **Dynamics:** the correction $\delta = T - M$ evolves by prefix sums, with one scalar injection per rise — the free (Toeplitz) path count into the newly accessible row. The "mysterious" universal offset $A = d_0 - 2$ is exactly this Toeplitz entry rewritten.
2. **Linearity:** the final correction is a sum of independently propagated injections; the kernel is independent of $d_0, s$.
3. **Self-similarity:** the truncated propagation kernel is *verbatim* the within/rise DP of the residual two-term staircase $\lfloor q_{\rm res} x / P\rfloor$, $P = p_1 - wm$ — hence equals $v_{d-m+1}(p_1 - wm)$ by two-term exactness (cycle lemma). The per-phase truncation that breaks naive Vandermonde composition *is* the staircase constraint reappearing one level down. No Zeilberger certificate needed.

### Errata (draft paper, fixed)
- Theorem 4.2/intro support indices were shifted by +2 (claimed rows $j \geq d_0{+}2$, $d \leq q_1{-}2$; actual: $j \geq d_0$, $d \leq q_1{-}1$).
- Prop 4.1: correct bound is $M = T$ for $j \leq d_0 - 1$ (new one-line monotonicity proof).
- Example 4.3 (√5) had wrong rows and a wrong coefficient ($v_1(7) = 5$, not 3); corrected against the actual block transfer matrix.

### Verification
- Kernel hypothesis: 595 + 140 + 720 exact checks (w ≤ 5, q₁ ≤ 8, d₀/s sweeps).
- End-to-end on actual blocks: √2, √3, √5, √7, √37, φ, e, 1+π/10 (w ∈ {1,2,6}) — all match.

### Documentation
- [sessions/2026-06-10-r7-general-proof/README.md](sessions/2026-06-10-r7-general-proof/README.md) — hypothesis-first log, proof, errata.
- `docs/papers/ballot-closed-form.tex` — proof inserted, errata fixed, compiles clean.

---

## May 29, 2026: Square-root nomograph reads as a 2D dipole

### Status
🔬 **NUMERICALLY VERIFIED** — three algebraic identities confirmed by `FullSimplify`; closed (no follow-ups).

### Summary
The geometric picture behind the $\sqrt{}$ construction (intersection of the n-circle through $(-1,0)$ and $(n,0)$ with the |z|-circle of radius $n^m$) admits a clean electrostatic reading:

- **n-foliation = 2D electric dipole at $(-1,0)$**: $1/(n+1) = \operatorname{Re}(1/(z+1))$, harmonic (Laplacian zero) — so the n-circles are the dipole equipotentials.
- **m-field = log-ratio of two harmonic potentials**: $\log|z| = m\,\log n$, where $\log|z|$ is the origin-monopole potential.
- **Rectifying chart**: in $(\xi,\eta) = (\log|z|,\log n)$, every $m$-isoline is a straight ray through the origin and every $n$-isoline is a horizontal line.

Also clarified an in-session error: the m-isolines have no asymptotic ray of finite slope; they asymptote (for $1/2 < m < 1$) to the algebraic curve $Y^2 \sim X^{2m/(2m-1)}$, with coefficient $1$ (verified for $m = 2/3, 3/4, 4/5, 15/16$).

### Documentation
- [sessions/2026-05-29-nomograph-dipole/README.md](sessions/2026-05-29-nomograph-dipole/README.md) — full writeup with the dipole identity, rectifying chart, and figure.
- `scripts/01-verify-isolines.wl` — algebraic identity + asymptotic checks.
- `scripts/02-dipole-check.wl` — dipole equipotential identity, harmonicity, and $\log|z| = m\log n$.
- `scripts/03-figure-dipole-nomograph.wl` — Cartesian vs rectified two-panel figure.

### Scope
No new theorem; a unification of nomograph / Möbius / electrostatics viewpoints on the existing picture. Does not make non-constructible roots (odd $q$) classically constructible — the Wantzel obstruction is intrinsic to the m-coordinate.

---

## May 3, 2026: `FactorChebyshevProbe` — Lucas-V on the divisor hyperbola

### Status
🔬 **NUMERICALLY VERIFIED** — 7/7 identity tests pass; 313/313 across the suite.

### Summary
Bridge function added to `Orbit/Kernel/SquareRootRationalizations.wl`:

```mathematica
FactorChebyshevProbe[j_, n_, k_] := ChebyshevT[k, (j + n/j)/(2 Sqrt[n])]
```

This is the algebraic shadow of the Lucas-V sequence $V_k(j) = j^k + (n/j)^k$
on the divisor hyperbola $xy = n$, expressed via the existing Chebyshev kernel.

Three load-bearing identities (all tested in `Tests/SquareRootRationalizations.wlt`):

1. **Factor symmetry:** `FactorChebyshevProbe[p, n, k] == FactorChebyshevProbe[q, n, k]` for any divisor pair $n = pq$ and any $k$.
2. **Hyperbolic factor angle at $k=1$:** reduces to $\cosh(\frac12 \log(q/p))$ — analogue of Pell's regulator on the divisor hyperbola.
3. **Pell recovery:** at $j = x_1 + y_1 \sqrt{d}$ on $x^2 - dy^2 = 1$ with $n=1$, recovers $x_k = T_k(x_1)$.

### Context
Crystallized from a discussion of why the original $\rho$-based factor probe
detects $n = pq$. Two structural observations: (i) stripped of $\sin(\pi\cdot)$,
$\rho$ is cosmetic — the detection lives entirely in the involution $j \leftrightarrow n/j$
and the identity $j(c-j) = n$; (ii) the Hartley constant $7/4$ in `CircFunctions`
and the constant in $\rho$ are the same self-dual centering. The probe is the
multiplicative-line counterpart of the additive-circle `Circ` machinery, sharing
the same Chebyshev kernel as Pell.

### Documentation
- [sessions/2026-05-03-factor-chebyshev-probe/README.md](sessions/2026-05-03-factor-chebyshev-probe/README.md) — motivation, identities, open directions.

### Open directions (from session README)
- ~~Lucas reformulation of `ForFactiMod`~~ → **Resolved 2026-05-04**: running-product gives `~28×` speedup at 8-digit n (`~3.16×/decade`, consistent with `O(n)→O(√n)`); "Lucas" framing falsified — it's a first-order multiplicative recurrence, not Lucas-V. See `D1-running-product-forFactiMod.md`. Paclet integration deferred pending user decision.
- ~~Egyptian decomposition characterization at $c = p+q$~~ → **Falsified 2026-05-04**: CF↔EF equivalence and single-tuple criterion (`(p+q) | (pq-1)` iff `q² ≡ -1 mod p+q`) rule out factor recovery. Two independent theoretical reasons, 20 empirical cases. EF probes value, not factorization. See `D2-egyptian-decomposition.md`.
- ~~Dirichlet-character probe analogue~~ → **Killed by gate 2026-05-04**: $\chi \bmod n$ vanishes on divisors of $n$ by definition of $(\mathbb{Z}/n\mathbb{Z})^*$. Channel-mismatch — no compute needed. See `D3-D4-gate-keeping.md`.
- ~~Explicit `Circ`-bridge accessor~~ → **Killed by gate 2026-05-04**: bridge requires $\log j$ (transcendental on integers), breaking both exact channels. Verbal observation is the right form. See `D3-D4-gate-keeping.md`.

### Protocol updates (2026-05-04)

**First tightening:** extended trigger to cover follow-up on previously-listed open directions; added check #5 **Channel match**. Trial run on session §§4–5 caught both dead ends in <10 minutes via check #5 alone.

**Second tightening (pre-write):** apply gate at *drafting time* — every candidate must pass all 5 checks before entering an Open Directions list. Killed candidates go to a "Considered and rejected" subsection with one-sentence reason. When check #5 kills a direction, optionally extract the *deeper question* the original intent was gesturing at. Empty active list is a valid outcome — better than padding. Cost moves from follow-up to drafting; user reads a shorter, higher-signal list.

**Retrospective on this session:** of 6 originally-listed open directions, 1 confirmed (D1, with retraction of "Lucas" framing), 1 trivially confirmed (D3, collapses to existing function), 1 falsified (D2), 2 killed by gate (D4, D5), 1 parked vague (D6). Three of six (D2, D4, D5) would have been caught by Channel Match at write time — exactly the pre-write tightening's target. Session retained as cautionary example of un-gated speculation.

---

## May 1, 2026: $L_{\mathrm{Eis}}(s)$ — Pole structure verified, direction closed

### Status

✅ **NUMERICALLY VERIFIED** — Closes direction 5.4 from `2026-05-01-LM-cheatsheet-review/A_n_definition_and_geometry.md`.

### Summary

Continuation of Primal Forest / cheatsheet review. The Eisenstein-like cosecant sum
$$\mathrm{Eis}(n) = \sum_{\substack{d=2\\ d\nmid n}}^{\lfloor\sqrt n\rfloor}\frac{\pi^2}{d^2\sin^2(\pi r_d/d)}$$
has Dirichlet series $L_{\mathrm{Eis}}(s) := \sum \mathrm{Eis}(n)/n^s$.

**Established (numerically verified to ≥ 4 digits):**
- Absolute convergence for $\Re(s) > 1$.
- Exact swap-of-sums formula: $L_{\mathrm{Eis}}(s) = \pi^2\sum_{d\ge 2} d^{-s-2}\sum_{r=1}^{d-1}\csc^2(\pi r/d)\,\zeta(s, d+r/d)$.
- **Double pole at $s=1$ with coefficient $\pi^2/6$**.
- **Simple pole coefficient $\pi^2(\gamma-\zeta(3))/3 \approx -2.056$**.
- Tauberian: $\sum_{n\le m}\mathrm{Eis}(n)/n \sim (\pi^2/12)\log^2 m + c_1 \log m + K + o(1)$ with empirical $K \approx 1.768$ (regular part, not pursued analytically).
- $L_{\mathrm{Eis}}(s)$ is **not** a multiple of $\zeta^2(s)$: same double-pole strength but the simple-pole coefficient encodes $\zeta(3)$-data structurally distinct from $(\pi^2/6)\gamma_1$.

**Not pursued (per Trinity protocol):**
- Riemann-style functional equation — same failure mode as retracted $L_M$ FE (no Euler product, no machinery).
- Closed form for $K \approx 1.768$.
- Modular interpretation, prime-side asymptotic for $\mathrm{Eis}(p)$ — separate open questions.

### Follow-up: $L_{\rm EOP}(s, M)$ and $\sigma$-family

Continued the same evening. The bounded smoothing $\mathrm{EOP}(n, M) = \sum_d 1/(1+Md^2\sin^2(\pi n/d))$ (the $e$-outside form of `consolidated_summary.md` §3.2) interpolates between $\lfloor\sqrt n\rfloor-1$ ($M=0$) and $M(n)$ ($M=\infty$).

- **Closed form** $c_2(M) = \coth(1/\sqrt M)/(2\sqrt M)$ for double pole of $L_{\rm EOP}(s, M)$ at $s=1$. Verified numerically to 99.8% across $M \in \{1, 4, 16, 100, 1000\}$. Limits: $c_2(\infty) = 1/2$ matches $L_M$.
- **Mellin in $M$** gives one-parameter family $L_\sigma(s)$ for $\sigma \in (0, 1)$ via $\widetilde{\mathrm{EOP}}(n, \sigma) = \int M^{\sigma-1}\mathrm{EOP}\,dM$.
- **Phase transition at $\sigma=1/2$**: pole order at $s=1$ jumps from double ($\sigma > 1/2$) to **TRIPLE** ($\sigma = 1/2$) and back to simple+separated ($\sigma < 1/2$). The triple pole at $\sigma = 1/2$ has coefficient $1/2$. Qualitative match to weight-1 Eisenstein obstruction (log-divergence in pole order, not coefficients).

Documentation: [sessions/2026-05-01-LM-cheatsheet-review/L_EOP_pole_structure.md](sessions/2026-05-01-LM-cheatsheet-review/L_EOP_pole_structure.md)

### Documentation

- [sessions/2026-05-01-LM-cheatsheet-review/Le_convergence_results.md](sessions/2026-05-01-LM-cheatsheet-review/Le_convergence_results.md) — $L_{\rm Eis}(s)$ pole structure, double pole verified.
- [sessions/2026-05-01-LM-cheatsheet-review/L_EOP_pole_structure.md](sessions/2026-05-01-LM-cheatsheet-review/L_EOP_pole_structure.md) — $L_{\rm EOP}$ closed form $c_2(M)$ + $\sigma$-family phase transition.
- [sessions/2026-05-01-LM-cheatsheet-review/Le_convergence_test.wl](sessions/2026-05-01-LM-cheatsheet-review/Le_convergence_test.wl), `eop_pole_structure.wl` — verification scripts.

### Off-topic (recorded, not pursued)

User asked whether $\sin(\pi q n / d)$ with relatively prime $q$ could remove the $d \mid n$ prefilter. **No** — for any integer $q$, $d \mid n \Rightarrow d \mid qn$, so the singularity persists. Half-integer or rational $1/q$ shifts avoid the singularity but produce different objects (lose residue structure and chord-length geometry).

---

## April 22, 2026: Primorial Formula — Fractional Recurrence Optimization

### Status

✅ **DELIVERED** — Post-hoc optimization of paper's existing k! algorithm. Paper itself unchanged.

### Summary

Started from Jan's empirical `30030 · den(Σ(-1)^k ⌊6√k⌋!/(2k+1)) = m#` (m ≥ 13). Explored whether sqrt-factorial weights could replace paper's k!. After deep investigation and careful empirical testing:

- **`(c√k)!` family FALSIFIED** as uniform replacement: c=5 fails at m=745 (=5·149, boundary cancellation at k=372); c=6 fails at m=26351 (=13·2027). Larger c delays failure but never eliminates it.
- **Paper's k! weight remains rigorously proven** — theorem unchanged.
- **Net deliverable: fractional-reduction + running-factorial recurrence**. Maintains state in primorial-size (`O(m)` bits) instead of factorial-size (`O(m·log m)` bits), with `log m` factor speedup and **20-70× empirical speedup** over paper's original rational-bignum recurrence.

### Fractional Recurrence (the actual new result)

Two optimizations combined:

1. **Fractional reduction**: at each step, reduce partial sum `S_k` mod 1. Since `den(frac(S_k)) = den(S_k)` for non-integer `S_k`, this preserves the primorial identity while bounding the numerator.

2. **Running factorial mod L**: maintain `F_k = k! mod L` where `L = lcm(1..m)`. One multiplication per step (vs k multiplications in the naive `factMod from scratch` approach).

### Structural insights (retained)

- **Type I / Type II prime dichotomy**: primes p with ν_p(2k+1) ≥ 2 are automatically ≤ √(2k+1). Weight only needs to cancel these "small-big" primes.
- **Freezing (paper Prop 4.7)**: during composite 2k+1 runs, both num and den of `frac(S_k)` are exactly unchanged — state is literally frozen between prime entries.
- **Logarithmic vs polynomial p-adic density**: factorials grow p-adically like `N/(p-1)` (polynomial in N); lcms like `log_p N` (logarithmic). Factorials can match arbitrarily high `α` with `√k`-size weight; lcms cannot — this explains why factorial-of-sqrt family is the only viable sublinear-weight candidate.

### Lessons learned (epistemic)

- "Verified to m=301" was naive. Pattern-matching small m doesn't establish conjecture for all m.
- Boundary cancellations at squarefree composites are **real phenomena** with probabilistic-looking firing rate ~1/p.

### Documentation

- [sessions/2026-04-22-primorial-minimal-weights/README.md](sessions/2026-04-22-primorial-minimal-weights/README.md) — master document with full history (including falsified explorations)
- [sessions/2026-04-22-primorial-minimal-weights/scripts/recurrence_kfact_frac.wl](sessions/2026-04-22-primorial-minimal-weights/scripts/recurrence_kfact_frac.wl) — **primary deliverable**: optimized recurrence for paper's k! algorithm

### Possible future work

- Consider adding fractional recurrence as an appendix / remark to the existing paper (post-hoc optimization note).
- Investigate whether `lcm(1..k)²` variant (strict inequality, no boundary) admits a clean proof — might be a separate minor note.

---

## Papers for Submission

Based on external review (Dec 16, 2025):

| Paper | Source | Release | Venue | Status |
|-------|--------|---------|-------|--------|
| Primorial Formula | [tex](papers/primorial-formula.tex) | [v0.1.0](https://github.com/popojan/orbit/releases/tag/v0.1.0-primorial)* | Monthly, Integers | Ready |
| Chebyshev Integral Identity | [tex](papers/chebyshev-integral-identity.tex) | [v0.1.0](https://github.com/popojan/orbit/releases/tag/v0.1.0-chebyshev-integral)* | Math Magazine | Ready |
| Egyptian Fractions Telescoping | [tex](papers/egyptian-fractions-telescoping.tex) | [v0.1.0](https://github.com/popojan/orbit/releases/tag/v0.1.0-egyptian-fractions)* | Fibonacci Q. | Ready |
| Sign-Cosine Identity | [tex](papers/sign-cosine-identity.tex) | — | Monthly (if reframed) | Needs work |
| Fibonacci Fractions | [tex](papers/fibonacci-fractions.tex) | — | Fibonacci Q. | Good |
| Chebyshev Sqrt Iteration | [tex](papers/chebyshev-sqrt-iteration.tex) | — | SIAM Review | Expository |
| Involution Decomposition | [tex](papers/involution-decomposition.tex) | — | arXiv, CMJ | Expository |

*Release PDF outdated — source has newer changes since tag.

---

## December 14, 2025: Prvoles — Geometric Sieve Visualization

### Status

📖 **PEDAGOGICAL** — Original visualization, educational contribution

### Summary

**Prvoles** (Primal Forest) transforms the Eratosthenes sieve from 1D to 2D:

```
n = p(p+k)  →  tree at (kp + p², kp + 1)
```

**Key insight:** Each divisor p generates a 45° diagonal with spacing p:
- p=2: diagonal (4,1), (6,3), (8,5), ... spacing (2,2)
- p=3: diagonal (9,1), (12,4), (15,7), ... spacing (3,3)
- p=5: diagonal (25,1), (30,6), (35,11), ... spacing (5,5)

**Primes = clearings** — positions with no trees blocking the view north.

### Why the y-coordinate matters

The y-coordinate is **load-bearing for visualization** (not computation):

| Purpose | Essential? | Reason |
|---------|------------|--------|
| Visual | ✅ YES | Creates 45° diagonals, forest metaphor |
| Algorithmic | ❌ NO | Still O(√n) trial division |
| Insight | ✅ YES | "Paradox of regularity" — regular inputs → irregular outputs |

**ML analogy:** Adding dimension enables *visual* linearity (diagonals instead of irregular intervals), similar to kernel trick enabling linear separability.

### Novelty

Despite extensive search, no prior publication of this specific visualization found:
- Different from Ulam spiral (spiral arrangement, diagonal clusters)
- Different from Sacks spiral (Archimedean spiral)
- Original forest/clearing metaphor

### Documentation

- Paper: `docs/papers/prvoles.tex` (Czech, pedagogical)
- PDF: `docs/papers/prvoles.pdf` (7 pages)
- Visualization: `docs/papers/visualizations/primal-forest-100-parabola.pdf`

---

## December 14, 2025: MoebiusInvolutions Module + Orbit Structure

### Status

✅ **PROVEN** — Complete orbit characterization with signature invariant

### Summary

Added `MoebiusInvolutions.wl` module with three involutions σ, κ, ι and orbit structure analysis.

**Key theorem (corrected):** Orbit signature {A, B} is the complete invariant:
- A = odd(p), B = odd(q-p), with gcd(A,B) = 1
- For composite I with k prime factors: 2^(k-1) distinct orbits
- Canonical form: A/(A+B) where A ≤ B

### Documentation

- Paper: `docs/papers/involution-decomposition.tex` (corrected theorem)
- Module: `Orbit/Kernel/MoebiusInvolutions.wl`
- Session: `docs/sessions/2025-12-14-orbit-applications/README.md`

---

## December 10, 2025: γ-Egypt Simplification Phenomenon

### Discovery

✅ **PROVEN** — Complete characterization of γ-reducible rationals

**Main Theorems:**

1. **G₁ Characterization:** $q = ((a-1)b+1)/((a+1)b+1) \Leftrightarrow \gamma(q)$ has 1 Egypt tuple
   - Special cases: 7/11 (Cheops), 5/8 (Chephren), 5/7 (Bent) all satisfy this!

2. **Fibonacci Compression:** For $F_k/F_{k+1} = [0; 1^k]$:
   - $\gamma$ maps to $[0; 4^m, \text{tail}]$ with $m = \lfloor(k-2)/3\rfloor$
   - **Compression ratio: 3:1** (k ones → ~k/3 fours)

3. **γ-Ladder Decomposition:** Every complex rational analyzed via convergent sequence
   - $\#\text{Egypt}(\gamma(c_k)) \leq \lceil(k-1)/3\rceil + 1$
   - Recursive divide-and-conquer approach to Egypt decomposition

**Golden-Silver Dichotomy:**
- Giza pyramids (golden family): γ-compressible → simplify to 1 tuple
- Bent pyramid (silver family): σ = √2-1 is γ fixed point → no change

### Documentation

- Session: `docs/sessions/2025-12-10-cf-egypt-equivalence/gamma-egypt-simplification.md`

---

## December 10, 2025: CF ↔ Egypt Tuple Equivalence

### Discovery

✅ **PROVEN** — Rigorous algebraic proof via leapfrog identity

**Theorem (CF-Egypt Bijection):** For $q = a/b$ with CF $[0; a_1, a_2, \ldots, a_n]$ and convergent denominators $\{q_0=1, q_1, \ldots, q_n=b\}$:

| Case | $u_k$ | $v_k$ | $j_k$ |
|------|-------|-------|-------|
| Regular ($k < ⌈n/2⌉$ or $n$ even) | $q_{2k-2}$ | $q_{2k-1}$ | $a_{2k}$ |
| Last tuple, odd CF | $q_{n-1}$ | $q_n - q_{n-1}$ | 1 |

**Key Results:**

1. **Bezout-Convergent Theorem:** The Extended GCD coefficient |s| = q_{n-1} (penultimate convergent denominator)
2. **Full bijection:** CF ↔ Egypt is bidirectional; can recover CF from tuples
3. **Prefix stability:** For irrationals, first k tuples depend only on first 2k CF coefficients
4. **Lochs' Theorem (1964):** K decimal digits → ~0.97K reliable CF terms → ~K/2 stable tuples
5. **XGCD = CF:** Extended GCD quotients ARE continued fraction coefficients

**Verification:** Tested on 7/19, 219/344, 5/13, 11/29, 3/8, 3/7, 17/41, 1/3, 2/5

### Algorithmic Insight

Single XGCD call suffices for Egyptian fraction decomposition:
1. XGCD(a, b) → all CF coefficients (quotients)
2. Apply bijection formula → tuples directly

This is more efficient than naïve ModInv iteration (which calls PowerMod = XGCD internally at each step).

### Documentation

- Session: `docs/sessions/2025-12-10-cf-egypt-equivalence/README.md`
- Paper: `docs/papers/egyptian-fractions-telescoping.tex` (extended with §6-8)
- Reference: Lochs, G. (1964). *Abh. Math. Sem. Univ. Hamburg* 27:142-144

---

## December 10, 2025: Convergent Bifurcation — √φ/2 vs 2/π

### Discovery

🤔 **HYPOTHESIS** — compelling evidence for both interpretations

**Finding:** The pyramid ratio 7/11 is the **last common convergent** of two nearly-equal constants:

| Constant | Value | Difference from 7/11 |
|----------|-------|---------------------|
| √φ/2 | 0.63600982... | 0.00035 |
| 2/π | 0.63661977... | 0.00026 |

After 7/11, the convergent sequences **bifurcate**:
- √φ/2 → 159/250, 166/261, ...
- 2/π → 219/344, 226/355, ...

### Arguments FOR √φ/2

1. **King's Chamber height = 5√5 cubits** — explicit √5 in construction
2. **γ framework:** φ = 2γ[-11/20], 1/φ = 2γ[-7/20]; ratio of numerators = 7/11
3. **Chephren uses 5/8** — this is a convergent of √φ/2 but NOT of 2/π (decisive)
4. All Giza pyramids use consecutive √φ/2 convergents: 2/3, 5/8, 7/11

### Arguments FOR 2/π

1. **Perimeter/height = 22/7 ≈ π** — famous "π pyramid" relationship
2. **Queen's shaft ≈ 113 cubits** — 113 is denominator of 355/113 ≈ π
3. **Algebraic consistency:** h/b = 2/π ⟹ perimeter/(2h) = π
4. **Elegant Egyptian fraction:** 219/344 = 1/2 + 1/8 + 1/86 (3 terms vs 4 for √φ/2 branch)

### Higher Convergents on Giza Plateau (Weak Evidence)

| Number | Found? | Strength | Problem |
|--------|--------|----------|---------|
| 113 | Queen's shaft | ⚠️ MEDIUM | Obscure dimension, ~113.4 not exact |
| 226 | 2 × shaft | ❌ WEAK | Dependent on 113 |
| 250 | 2 × Menkaure height | ❌ WEAK | Doubling is trivial |
| ~159 | Cheops base−height | ❌ WEAK | =160, not 159 |

**Adversarial check:** Expected ~1.8 random matches from 210 combinations; found 4.
Multiple testing problem makes these less significant than they appear.

### Conclusion

**Chephren's 5/8 ratio is the key evidence for √φ/2** — it is NOT a convergent of 2/π.

The Queen's shaft ≈ 113 cubits is intriguing but the evidence for "both branches encoded" is weak after adversarial analysis.

### Documentation

- Primary: `docs/sessions/2025-12-08-gamma-framework/golden-ratio-pyramid.md` (section "Convergent Bifurcation")

---

## December 9, 2025: Chronological Convergent Pattern in Egyptian Pyramids

### Discovery

🔬 **NUMERICALLY VERIFIED** (4 pyramids, exact seked values match convergents)

**Finding:** 4th Dynasty pyramids form a chronological sequence of convergents:

| # | Pyramid | Pharaoh | ~Date | Irrational | Convergent | Seked |
|---|---------|---------|-------|------------|------------|-------|
| 1 | **Bent (lower)** | Sneferu | 2600 BC | √2 | 7/5 (3rd) | 5 |
| 2 | **Cheops** | Khufu | 2560 BC | √φ/2 | 7/11 (6th) | 5½ |
| 3 | **Chefren** | Khafre | 2530 BC | √φ/2 | 5/8 (5th) | ~5.25 |
| 4 | **Menkaure** | Menkaure | 2510 BC | √φ/2 | 2/3 (4th) | ~5 |

**Key observations:**
1. **Sneferu** (dynasty founder) used √2 geometry at Dahshur
2. **Khufu** introduced √φ/2 with highest convergent (6th)
3. **Successors** used decreasing convergents: 6th → 5th → 4th

### Supporting Evidence

- Bent Pyramid seked = exactly 5 palms (documented, tan ≈ √2)
- All three Giza ratios are consecutive convergents of √φ/2
- Independent verification via preserved cubit sticks (~52.4 cm)
- Modern GPS/laser confirms Petrie's measurements (<0.05% error)

### Adversarial Check

**Strengths:** ✅ Mathematically exact pattern, chronologically consistent
**Weaknesses:** ⚠️ Only 4 data points, no direct textual evidence of intent

**Status:** Pattern is real. Intentionality unproven but culturally plausible.

### Additional Findings (Dec 9)

- **Shaft dimensions:** 21×21 cm ≈ 2/5 royal cubit ≈ 11 digits
- **Astronomical alignments:** All 4 shafts point to stars of epoch ~2450 BC ± 25 years (disputed)
- **Petrie methodology:** Validated by cubit sticks, interior chambers, modern GPS

### Documentation

- Primary: `docs/sessions/2025-12-08-gamma-framework/pyramid-internal-geometry.md`
- HSM question: https://hsm.stackexchange.com/questions/17717

---

## December 1, 2025: Multiplicative Decomposition of Chebyshev Lobe Areas

### Discovery

✅ **PROVEN** (algebraic proof via roots of unity cancellation)

**Theorem (Multiplicative Decomposition):** For composite n = md with m, d ≥ 2 and n > 2:

$$\sum_{k \equiv r \pmod{m}} A(n, k) = \frac{1}{m} \quad \text{for all } r \in \{1, \ldots, m\}$$

where A(n,k) is the normalized lobe area of the k-th lobe of the n-gon Chebyshev polygon function.

**Equivalently:** Σ B(n, k≡r mod m) = d, where B(n,k) = n·A(n,k).

### Proof Sketch

1. Lobe area decomposes as: A(n,k) = 1/n + oscillatory term with cos(2πk/n)
2. Sum over arithmetic progression k = r, r+m, ..., r+(d-1)m:
   - Constant: d · (1/n) = d · (1/md) = 1/m
   - Oscillatory: Σ exp(2πi(r+jm)/(md)) = exp(2πir/(md)) · Σ exp(2πij/d) = 0
3. Sum of d-th roots of unity vanishes → oscillatory term cancels

### Significance

- **Geometric analogue of divisor decomposition**: Lobe areas "factor" according to factorization of n
- mn-gon can be viewed as m copies of n-gon structure (each with 1/m area)
- Connects Chebyshev composition property Tₘ(Tₙ(x)) = Tₘₙ(x) to geometric areas

### Documentation

- LaTeX: `docs/drafts/lobe-area-kernel.tex` Section 11
- Session: `docs/sessions/2025-12-01-multiplicative-decomposition/README.md`

---

## November 25, 2025: Complete Demystification + Genuine Discovery

### Part 1: Literature Consolidation (morning)

**Finding:** The Factorial ↔ Chebyshev ↔ Hyperbolic identity is **standard Chebyshev theory**.

```
cosh(n·arcsinh(z)) = T_n(√(1+z²))    [textbook identity]
```

**Clarified (NOT novel):**
1. ~~Egypt construction~~ → equals Pell powers shifted by 1: `Egypt[k] = Pell[k+1]`
2. ~~Monotonic convergence~~ → standard Pell theory
3. ~~"Sextic via cancellation"~~ → just Newton∘Halley composition (order 2×3=6)

### Part 2: Demystification of NestedChebyshevSqrt (evening)

**Key realizations:**
- τ₁ = (σ₁ + d/σ₁)/2 = Newton(Halley(n)) — standard composition
- τ₂ = Newton³ — nothing novel
- 2×Halley = order 9, which is MORE efficient than τ₁ = order 6

### Part 3: GENUINE Discovery

**✅ The Chebyshev framework gives access to ALL integer orders ≥ 3:**

```
σ_m has convergence order m+2 (numerically verified)

Newton/Halley compositions can only achieve: 2, 3, 4, 6, 8, 9, 12, 16, 18...
(products of 2s and 3s = 3-smooth numbers)

Chebyshev σ_m achieves: 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13...
(ALL integers)

INACCESSIBLE by composition: 5, 7, 10, 11, 13, 14, 15, 17, 19...
```

**This IS genuinely novel:** A single parameterized formula family covering all integer orders, including primes > 3.

### References
- `papers/dijoux-chebyshev-householder-2024.pdf` - Chebyshev ↔ Householder connection
- `papers/nazeer-mhhm-order6-2016.pdf` - Modified Householder order 6
- `papers/nazeer-modified-halley-order6-2016.pdf` - Modified Halley order 6

---

## Current Status: Active Research

### Working Code
- ✅ Orbit paclet: `SquareRootRationalizations.wl` (Egypt + Chebyshev methods)
- ✅ All paclet modules functional (see CLAUDE.md for details)

### Key Results
- 📖 Egypt[k] = Pell[k+1] exactly (standard Pell theory)
- 📖 Factorial ↔ Chebyshev ↔ Hyperbolic via `cosh(n·arcsinh(z)) = T_n(√(1+z²))` [textbook]
- 🔬 σ_m convergence order m+2 (numerically verified for m=1..6)

---

## Epistemological Standards

Going forward, strict adherence to:

- ✅ **PROVEN** = Rigorous algebraic proof, peer-reviewed OR publicly documented with verification
- 🔬 **NUMERICALLY VERIFIED** = X% of N test cases (explicit numbers)
- 🤔 **HYPOTHESIS** = Conjecture requiring verification
- ❌ **FALSIFIED** = Tested and found false
- ⏸️ **OPEN QUESTION** = Unknown, under investigation
- 🔙 **RETRACTED** = Previously claimed, now withdrawn due to errors

**No more:**
- "Tier-1" labels without peer review
- "95% confidence" for algebraic proofs
- "BREAKTHROUGH" for incremental findings
- Documentation before verification

---

## Repository Structure

### Code (Verified)
- `Orbit/Kernel/` - Paclet implementations
  - `Primorials.wl`
  - `SemiprimeFactorization.wl`
  - `ModularFactorials.wl`
  - `SquareRootRationalizations.wl` ✅ Working Egypt + Chebyshev methods

### Documentation
- `docs/proofs/chebyshev-egypt-connection.md` - Consolidated proof
- `docs/drafts/chebyshev-pell-sqrt-paper.tex` - Paper draft (honest revision)
- `docs/STATUS.md` - This file
- `CLAUDE.md` - Development protocols

---

## Lessons Learned

### Process Improvements
1. **Check literature FIRST** before claiming novel results
2. **Test boundaries** before claiming "for all x"
3. **Verify against code** before formulating theorems
4. **Adversarial discipline EARLY** (kill bad ideas in 10 min)
5. **Cite sources** - use 📖 for standard results, distinguish from novel work

---

## Orbit Paclet Modules (13 modules)

1. **Primorials** - Rational sum formula for primorials
2. **SemiprimeFactorization** - Closed-form via Pochhammer
3. **ModularFactorials** - Efficient n! mod p
4. **SquareRootRationalizations** - Egypt + Chebyshev sqrt methods
5. **EgyptianFractions** - CF-Egypt bijection, telescoping tuples
6. **ChebyshevIntegralTheorem** - 1/π invariant identity
7. **CircFunctions** - Circular/Hartley transform functions
8. **CunninghamRepresentation** - Cunningham number tools
9. **CyclotomicFFT** - Cyclotomic FFT implementations
10. **MoebiusInvolutions** - Calkin-Wilf involution decomposition
11. **FibonacciFractions** - Fibonacci rational representation
12. **LegacyPolynomials** - Legacy polynomial utilities
13. **SignCosineIdentities** - Sign-cosine sums A(p), W(p) and class number connection

---

**Status:** Clean slate. Ready to restart with proper discipline.

**Authors:** Jan Popelka, Claude (Anthropic)
**Repository:** [popojan/orbit](https://github.com/popojan/orbit) (public)
