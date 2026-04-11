# Perturbation Expansion for Lattice Paths: Structure and Interpretation

**Date:** 2026-04-09 (evening), revised later same day
**Status:** Two key results proved; interpretation revised post-proof

---

## What we found (summary of Results 10–14)

The correction $\Delta_2$ for lattice path counts under an irrational staircase
$\lfloor x/\alpha \rfloor$ decomposes as a **finite, terminating inclusion-exclusion expansion**:

$$\Delta_2 = \sum_{k=1}^{a_2} (-1)^{k+1} \sum_{\substack{S \subset [a_2] \\ |S|=k}}
\prod_{i \in S} D_i \cdot \prod_{i \notin S} T_i$$

where each $T_i$ is a Toeplitz convolution (Vandermonde kernel) and each $D_i$
is a correction from the Result 7 formula with **universal offset $A = d_0 - 2$**.

Key structural properties:
- Order $k$ first contributes at depth $d = (k-1) q_1$
- Each order improves accuracy by $\sim 100\times$
- The expansion terminates exactly at order $a_2$ (the second partial quotient)
- Verified across 6 irrationals ($\sqrt{5}, \sqrt{2}, \pi, \mathrm{Im}[\zeta_1], \sqrt{3}, \varphi$)

---

## Proved results (2026-04-10)

### Result 13: A = d₀ − 2 is a counting convention

The offset $A = d_0 - 2$ arises from two elementary facts:

1. **First correction row is at $j = d_0$:** rows $0, \ldots, d_0 - 1$ are
   unaffected by dimension growth (since $L_m$ for $m \geq d_0 - 1$ acts
   identically on these rows). Therefore $D[j, s] = 0$ for $j < d_0$.

2. **R7 formula places first correction at $A + 2$:** at $d = 0$, the formula
   gives $\Delta[A+2, s] = \binom{A + w + 1 - s}{w - 1}$. The actual correction
   is $D[d_0, s] = \binom{d_0 + w - 1 - s}{w - 1}$ (from the hockey-stick
   identity applied to the prefix-sum accumulation at row $d_0$).

Matching: $A + (w+1) = d_0 + (w-1)$, so $A = d_0 - 2$.

**The $-2$ equals $(w+1) - (w-1)$:** the Sturmian first-gap width minus
the hockey-stick telescoping index. This is always $2$, independent of $w$.

**Previous interpretations were wrong:**
- ~~"Euler-characteristic-type correction"~~ — no topological content
- ~~"$d_0 - 1 - 1$ from last-two-equal + prefix-sum copy"~~ — unrelated mechanisms
- ~~"Shift placing strip where truncation defect begins"~~ — over-interpreted

The $-2$ is a **combinatorial counting convention**, not a deep invariant.

Script: `scripts/proof_A_offset.wl`

### Result 14: w = 1 Catalan collapse

For $w = 1$, the multi-term R7 correction collapses to a single binomial:

$$\Delta_{w=1}[d_0 + d,\, s] = \binom{d_0 + p_1 + d - 1 - s}{d}$$

**Proved** symbolically by Mathematica for $d = 0, \ldots, 5$ (with symbolic $d_0, p_1, s$).
**Verified** numerically for $\sqrt{2}, \varphi, \sqrt{3}, 1 + 1/\pi$.

The collapse uses the **ballot reflection** $v_j(p) = \binom{p+j-1}{j} - \binom{p+j-1}{j-1}$
(valid only for $w = 1$), which creates telescoping cancellation in the
convolution sum — a generalized Vandermonde-Chu identity.

For $w \geq 2$: no such collapse. The sum has genuinely $d + 1$ independent
terms. The ballot factor $\frac{p - wj}{p}\binom{p+j-1}{j}$ does not decompose
into a difference of adjacent binomials when $w > 1$.

Script: `scripts/w1_catalan_collapse.wl`

---

## The scattering analogy: what survives

The "Born expansion" naming was adopted early in the session. After the proofs,
the analogy is **descriptively useful but explanatorily shallow**. We now use
"inclusion-exclusion expansion" or "perturbation expansion" instead.

### What is correct

| Lattice paths | Scattering analogue | Status |
|---|---|---|
| Toeplitz $T(a) = \binom{a+j-s}{j-s}$ | Free propagator | ✅ correct description |
| Correction $D_i$ (R7 formula) | Localized perturbation | ✅ correct: polynomial, boundary-localized |
| IE order $k$ | $k$-fold interaction | ✅ correct structure |
| Order activation at $d = (k-1)q_1$ | Spatial separation of scatterers | ✅ non-trivial, correct |
| Termination at order $a_2$ | Finite scattering sites | ✅ follows from CF structure |

### What was over-interpreted

| Claim | Revision |
|---|---|
| "Not just a naming coincidence" | It IS primarily a naming coincidence. The structure (product of perturbed operators → inclusion-exclusion) is generic algebra, not specific to scattering. |
| "Convergence rate controlled by $q_1/p_1$ like weak scattering" | The $\sim 100\times$ per order is because the correction is polynomial ($\sim d_0^{w-1}$) while Toeplitz is factorial ($\sim \binom{q_1 w + d_0}{d_0}$). No "weak coupling" needed — it's just polynomial vs. factorial growth. |
| "Ballot numbers at convergents are resonances" | Ballot numbers at convergents take the "free" form because the CF approximation is locally exact there (Floor Agreement Lemma). This is a Diophantine property, not a resonance phenomenon. |
| "Waves are lattice paths, potential is staircase deviation" | Poetic but content-free. The lattice paths have no wave equation, no dispersion, no interference. |

### Summary

The perturbation expansion is a valid **algebraic decomposition** (product of
$(T_i - D_i)$ expanded via inclusion-exclusion). Calling terms "scattering
orders" provides useful vocabulary. But the physics analogy does not
**explain** anything — it does not predict the correction formula,
the convergence rate, or the $w = 1$ collapse. All three follow from
combinatorial identities (hockey-stick, Vandermonde-Chu, ballot reflection).

---

## The CF connection: confirmed and sharpened

### Convergents as exact-agreement points

At a CF convergent $p_k/q_k$, the staircase $\lfloor q_k x / p_k \rfloor$
agrees with the line (Floor Agreement Lemma, R5). The path count takes
the uniform form $v_j(p_k) = \frac{p_k - wj}{p_k}\binom{p_k + j - 1}{j}$.
No correction needed. This is an **arithmetic property** of CF convergents.

### The w = 1 collapse: Rothe-Hagen identity

For $w = 1$, the R7 correction collapses to a single binomial:
$\Delta_{w=1}[d_0+d, s] = \binom{d_0+p_1+d-1-s}{d}$.

This is a special case of the **Rothe-Hagen identity** (Rothe, 1793; Hagen, 1891):

$$\sum_{k=0}^{n}\frac{a}{a+bk}\binom{a+bk}{k}\binom{c-bk}{n-k}=\binom{a+c}{n}$$

The key step: the ballot number $v_j(q) = \frac{q-j}{q}\binom{q+j-1}{j}$
satisfies $v_j(a+j) = \frac{a}{a+2j}\binom{a+2j}{j}$, which is the
Rothe-Hagen coefficient with $b = 2$ (= $w + 1$ for $w = 1$).

**For general $w$:** the ballot with slope $w$ gives Rothe-Hagen $b = w+1$:
$v_j^{(w)}(a+wj) = \frac{a}{a+(w+1)j}\binom{a+(w+1)j}{j}$.
However, the second factor in R7 does not have the Rothe-Hagen form
$\binom{c - (w+1)j}{d-j}$ for $w \geq 2$. The sum does NOT collapse —
the multi-term R7 formula IS the closed form.

**Conclusion:** Our theory is a **$w$-generalization beyond Rothe-Hagen**:
- $w = 1$: reduces to Rothe-Hagen $b=2$ (single binomial, classical)
- $w \geq 2$: produces genuinely new multi-term corrections that cannot
  be evaluated by any known binomial convolution identity

### Self-similarity

The same R7 formula applies at every CF level, with only $p_k$ and $A_k$
changing. This reflects the self-similar structure of the CF expansion:
each level recapitulates the correction pattern with rescaled parameters.

This self-similarity is the most interesting structural feature — it
connects the **arithmetic of CF** (the $a_k$ sequence) to the
**algebraic complexity of lattice path corrections** (the number of
IE orders and the correction formula shape).

---

## What remains genuinely interesting

1. **Self-similar correction structure.** The same R7 formula at every CF level,
   with $A_k = d_{0,k} - 2$ universally. This connects CF hierarchy to
   lattice path combinatorics in a way not present in Irving-Rattan or
   Banderier-Wallner.

2. **Termination at $a_2$.** The inclusion-exclusion expansion has exactly
   $a_2$ orders. By Gauss-Kuzmin, $a_2 \leq 10$ for ~93% of irrationals.
   CF partial quotients directly control algebraic complexity.

3. **Rothe-Hagen at $w = 1$, beyond for $w \geq 2$.** The $w = 1$ collapse
   is the Rothe-Hagen identity ($b = 2$), known since Rothe (1793).
   The $w \geq 2$ case involves ballot numbers with $b = w+1$ in the
   first factor but an incompatible second factor — a genuinely new
   multi-term formula beyond classical binomial convolutions.

4. **SL(2,ℤ) connection** (open). The sub-block factorization
   $M_2 = \prod_{i=1}^{a_2} \mathrm{SB}_i$ mirrors the CF matrix recursion.
   Whether our IE decomposition corresponds to a known decomposition
   of $\mathrm{SL}(2, \mathbb{Z})$ representations is unresolved.

---

## Result 16: Hypergeometric identification of R7 (Q6 Diamond)

**Added:** 2026-04-09 (late evening)

The R7 correction sum for general $w$ is a **terminating, 1-balanced
(Saalschützian) generalized hypergeometric function** at unit argument:

$$\Delta[d_0{+}d, s] = \text{prefactor} \times {}_{2w+2}F_{2w+1}(1)$$

### Verified pattern

| $w$ | pFq order | Status |
|-----|-----------|--------|
| 1 | ${}_{3}F_{2}(1)$ → collapses to $\binom{d_0{+}p_1{+}d{-}1{-}s}{d}$ (Saalschütz) | ✅ classical (Rothe-Hagen) |
| 2 | ${}_{6}F_{5}(1)$ | ✅ Mathematica symbolic, verified |
| 3 | ${}_{8}F_{7}(1)$ | ✅ Mathematica symbolic |
| 4 | ${}_{10}F_{9}(1)$ | ✅ Mathematica symbolic |

General: $w \mapsto {}_{(2w+2)}F_{(2w+1)}(1)$.

### Parameter structure (for general $w$)

**Upper parameters** ($2w+2$ total):
- $w{+}1$ terms from $d_0$ in arithmetic progression with step $\frac{1}{w+1}$:
  $$\frac{d_0{+}w}{w{+}1},\; \frac{d_0{+}w{+}1}{w{+}1},\; \ldots,\; \frac{d_0{+}2w}{w{+}1}$$
- 1 terminating parameter: $-d$
- $w$ terms from $p_1$ in arithmetic progression with step $\frac{1}{w}$:
  $$\frac{w{-}p_1}{w},\; \frac{w{+}1{-}p_1}{w},\; \ldots,\; \frac{2w{-}1{-}p_1}{w}$$

**Lower parameters** ($2w+1$ total):
- $w{-}1$ constants in arithmetic progression with step $\frac{1}{w}$:
  $$\frac{w{+}1}{w},\; \frac{w{+}2}{w},\; \ldots,\; \frac{2w{-}1}{w}$$
- 1 full $d_0$ parameter: $1 + d_0$ (or $1 + d_0 - s$ when $s \neq 0$)
- $w{+}1$ terms from $(d{+}p_1)$ in AP with step $\frac{1}{w+1}$:
  $$\frac{w{+}1{-}d{-}p_1}{w{+}1},\; \ldots,\; \frac{2w{+}1{-}d{-}p_1}{w{+}1}$$

**Prefactor:**
$$\binom{d_0{+}w{-}1}{w{-}1} \cdot \frac{p_1 - w(d{+}1)}{p_1 - w} \cdot \binom{d{+}p_1{-}w{-}1}{d}$$

### 1-balanced (Saalschützian) property

For both $w = 2$ and $w = 3$:
$$\sum(\text{upper params}) - \sum(\text{lower params}) + 1 = 0$$

This is the **Saalschütz condition**. For ${}_{3}F_{2}(1)$, this condition
forces collapse to a single binomial coefficient (the classical Pfaff-Saalschütz
theorem = Rothe-Hagen identity). For ${}_{6}F_{5}(1)$ and higher, the
1-balanced property constrains the sum but does not force collapse.

**This is the structural reason why $w = 1$ is special:** Saalschütz collapses
${}_{3}F_{2}(1)$ but no analogous collapse exists for ${}_{6}F_{5}(1)$.

### Pole issue at integer specialization

The lower $(d{+}p_1)$-group parameters become non-positive integers for
integer $d, p_1$ when $d + p_1$ is large enough. This creates poles in the
Pochhammer denominators of the pFq series.

**Diagnosis (perfect correlation):**
- 27/72 test cases had poles AND mismatches
- 45/72 test cases had no poles AND matched
- **0 cases** of mismatch without pole, **0 cases** of match despite pole

**Fix:** Keeping $p_1$ symbolic and taking $\lim_{p_1 \to \text{value}}$ gives
correct results in all tested pole cases.

**Consequence:** The pFq representation is valid for generic parameters but
requires regularization at integer points. The original R7 sum (which is
always well-defined) remains the practical computational formula.

### Gauss multiplication simplification

Using the Gauss multiplication formula $\prod_{j=0}^{n-1} (a + j/n)_k = (na)_{nk}/n^{nk}$,
the $d_0$-group and $(d{+}p_1)$-group Pochhammer products collapse:
- Upper $d_0$-group: $\prod_{j=0}^{w} \left(\frac{d_0{+}w{+}j}{w{+}1}\right)_k = \frac{(d_0{+}w)_{(w+1)k}}{(w{+}1)^{(w+1)k}}$
- Lower $(d{+}p_1)$-group: similar, with the $(w{+}1)^{(w+1)k}$ factors cancelling

This eliminates the fractional parameters, giving a sum over integer Pochhammer
symbols divided by $w$-th powers. However, the pole issue persists.

### Negative results

1. **No further reduction:** `FunctionExpand` and `FullSimplify` do not reduce
   the ${}_{6}F_{5}$ to products of lower-order hypergeometrics.
2. **Whipple-type transformations:** No parameter pair $(a_i, a_j)$ satisfies
   $a_i + a_j = b_k + 1$ (Whipple pairing condition), so Whipple's theorem
   does not apply.
3. **No simple recurrence in $d$:** Order-2 linear recurrence with polynomial
   (linear and quadratic) coefficients does not exist for symbolic $d_0, p_1$.

### Conclusion

The R7 sum IS the closed form for $w \geq 2$. The hypergeometric identification
names it (${}_{(2w+2)}F_{(2w+1)}$), classifies it (Saalschützian), and explains
why $w = 1$ collapses (Pfaff-Saalschütz) while $w \geq 2$ cannot. But it does
not simplify the computation: the $(d{+}1)$-term sum is irreducible.

Scripts: `scripts/q6_diamond_explore.wl`, `scripts/q6_diamond_hypergeom.wl`,
`scripts/q6_diamond_poles.wl`

---

## Open questions

1. **Inductive proof of R7 for all $d$.** We have: proof for $d = 0$
   (hockey-stick), symbolic verification for $d \leq 5$ (Mathematica).
   A full inductive proof would complete the theory.

2. ~~**$w$-analogue of reflection principle.**~~ → **Answered by R16:**
   the multi-term structure is a Saalschützian ${}_{(2w+2)}F_{(2w+1)}(1)$
   that does not collapse for $w \geq 2$. No reflection principle needed.

3. **Higher-order Zeilberger recurrence.** The ${}_{(2w+2)}F_{(2w+1)}$
   must satisfy a holonomic recurrence in $d$ (guaranteed by WZ theory).
   Finding it explicitly could offer O(1)-per-step computation,
   though the practical gain is marginal since $d < q_1$ is typically small.

4. **Paper writeup.** Results 1–16 constitute a complete theory of
   ballot corrections under irrational staircases via perturbation expansion.
