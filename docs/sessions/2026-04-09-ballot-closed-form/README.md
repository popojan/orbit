# Closed-Form State Vectors for Beatty Ballot Paths

**Date:** 2026-04-09
**Status:** Active session
**Continues:** [2026-04-07 Chebyshev-Wigner session](../2026-04-07-chebyshev-wigner-semicircle/transfer-matrix-dp.md)

## Context

The Beatty Ballot Theorem shows $\mathrm{DP}(p) = B(p,q)$ at convergent/semi-convergent
numerators. Between convergents, $\mathrm{DP}(x)$ decomposes as a product of transfer
matrices $L_m$ (lower-triangular all-ones) along the Sturmian word of stair widths.

**Goal:** Replace the transfer matrix product with explicit binomial formulas.

---

## Result 1: Uniform Stair Width Closed Form

**Status:** $\checkmark$ Proved and numerically verified

### Setup (uniform case)

For staircase $S(x) = \lfloor x/\alpha \rfloor$ with uniform stair width $w = \lfloor\alpha\rfloor$
(valid between $p_0$ and $p_1$), the state vector at the $k$-th semi-convergent position has
entries $v_j^{(k)} = \mathrm{dp}(\text{position}, j)$ for $j = 0, \ldots, k$.

### Recurrence

Combined "stair + rise" operation gives a convolution:

$$v_j^{(k+1)} = \sum_{s=0}^{j} \binom{j - s + w - 1}{w - 1} \, v_s^{(k)}, \qquad j = 0, \ldots, k$$

with $v_{k+1}^{(k+1)} = v_k^{(k+1)}$ (last two entries equal after rise).

**Derivation:** Within a stair of height $m$ and width $w$, the transfer is $L_m^{w-1}$
with entries $\binom{r-s+w-2}{w-2}$. After extending by $0$ and multiplying by $L_{m+1}$
(prefix sums), the hockey-stick identity $\sum_{t=0}^{n} \binom{t+r}{r} = \binom{n+r+1}{r+1}$
collapses the double sum into a single convolution.

### Closed form

$$\boxed{v_j^{(k)} = \frac{w(k-j)+1}{wk+1} \binom{wk+j}{j}}$$

### Proof (induction via Vandermonde--Chu)

**Base case:** $v_0^{(0)} = 1$. Formula gives $\frac{1}{1}\binom{0}{0} = 1$. $\checkmark$

**Inductive step:** Substitute into the recurrence:

$$v_j^{(k+1)} = \frac{1}{wk+1} \sum_{s=0}^{j} \binom{j-s+w-1}{w-1} \binom{wk+s}{s} \bigl(w(k-s)+1\bigr)$$

Split $(w(k-s)+1) = (wk+1) - ws$ and handle each part:

**Part A** (constant term):

$$\sum_{s=0}^{j} \binom{j-s+w-1}{w-1} \binom{wk+s}{s} = \binom{w(k+1)+j}{j}$$

by the Vandermonde--Chu identity $\sum_{s} \binom{a+s}{s}\binom{b+n-s}{n-s} = \binom{a+b+n+1}{n}$.

**Part B** (weighted term): Using $s \cdot \binom{wk+s}{s} = (wk+1)\binom{wk+s}{s-1}$ and shifting index:

$$\sum_{s=0}^{j} s \cdot \binom{j-s+w-1}{w-1}\binom{wk+s}{s} = (wk+1)\binom{w(k+1)+j-1}{j-1}$$

again by Vandermonde--Chu.

**Combining:** $v_j^{(k+1)} = \binom{w(k+1)+j}{j} - w \cdot \binom{w(k+1)+j-1}{j-1}$

This equals $\frac{w(k+1-j)+1}{w(k+1)+1}\binom{w(k+1)+j}{j}$ by the elementary identity
$j\binom{N+j}{j} = (N+j)\binom{N+j-1}{j-1}$. $\square$

### Special cases

| Entry | Formula | Name |
|-------|---------|------|
| $j = 0$ | $1$ | trivial |
| $j = 1$ | $wk - (w-1)$ | arithmetic |
| $j = k$ | $\frac{1}{wk+1}\binom{(w+1)k}{k}$ | Fuss--Catalan $A_k^{(w+1)}$ |
| $j = k-1$ | $= v_k^{(k)}$ | last two equal |
| $w = 1$ | $\frac{k-j+1}{k+1}\binom{k+j}{j}$ | Catalan triangle |

### Geometric interpretation

$v_j^{(k)}$ counts lattice paths from $(0,0)$ to $(wk, j)$ staying weakly below $y = x/w$.
This is the generalized ballot count with slope $1/w$.

### Numerical verification

Verified for $w \in \{1, 2, 3, 4, 5, 7, 10\}$, $k = 1, \ldots, 8$. Cross-checked
against `BeattyBallotCount[Pi, x]` for all 8 semi-convergent positions $x \in \{3, 4, 7, 10, 13, 16, 19, 22\}$.

Script: `scripts/closed_form_verify.wl` (in previous session folder)

---

## Result 2: Universal Low-Height Formula

**Status:** $\checkmark$ Numerically verified across 4 irrationals

### Statement

The uniform formula extends to ALL semi-convergent positions $p$, not just the first batch,
for the first $q_1 + 1$ entries of the state vector:

$$\boxed{v_j(p) = \frac{p - wj}{p} \binom{p+j-1}{j}, \qquad j = 0, 1, \ldots, q_1}$$

where $w = \lfloor\alpha\rfloor$ and $q_1$ is the denominator of the first convergent $p_1/q_1$.

Equivalently: $v_j(p) = (p - wj) \cdot B(p, j)$ where $B(p,j) = \binom{p+j-1}{j}/p$.

### Why it works

For $j \leq q_1$, the staircase $\lfloor x/\alpha \rfloor$ has only uniform-width stairs
($w = \lfloor\alpha\rfloor$) up to height $q_1$. The first anomalous stair (width $w+1$)
appears at height $q_1$, and paths reaching heights $j \leq q_1$ never encounter the
anomaly. Hence the uniform (linear boundary) formula applies.

### Numerical verification

| $\alpha$ | $w$ | $q_1$ | Formula range | Tested positions |
|-----------|-----|-------|---------------|------------------|
| $\pi$ | 3 | 7 | $j = 0, \ldots, 7$ | 16 semi-convergents up to 179 |
| $\sqrt{5}$ | 2 | 4 | $j = 0, \ldots, 4$ | 14 positions up to 83 |
| $\sqrt{2}$ | 1 | 2 | $j = 0, \ldots, 2$ | 11 positions up to 99 |
| $\varphi$ | 1 | 1 | $j = 0, 1$ | 10 convergents up to 89 |

Script: `scripts/universal_formula_test.wl`

---

## Result 3: Hierarchical Correction Structure

**Status:** $\checkmark$ Numerically verified, partial characterization

### First correction (constant)

At $j = q_1 + 1$, the formula breaks with a **constant** correction independent of $p$:

$$v_{q_1+1}(p) = \frac{p - w(q_1+1)}{p}\binom{p+q_1}{q_1+1} - B(p_0 + p_1,\, q_0 + q_1)$$

The correction is exactly the ballot number of the **first level-2 semi-convergent**
$(p_0+p_1)/(q_0+q_1)$.

| $\alpha$ | Correction at $j = q_1+1$ | $= -B(p_0+p_1, q_0+q_1)$ |
|-----------|---------------------------|---------------------------|
| $\pi$ | $-420732$ | $-B(25, 8)$ |
| $\sqrt{5}$ | $-273$ | $-B(11, 5)$ |
| $\sqrt{2}$ | $-5$ | $-B(4, 3)$ |
| $\varphi$ | $-2$ | $-B(3, 2)$ |

Script: `scripts/correction_structure.wl`

### Higher corrections (polynomial in $p$)

For $j = q_1 + 1 + d$ with $d \geq 0$, the correction is a **polynomial of degree $d$ in $p$**.

The leading coefficient decays factorially:

$$\mathrm{corr}(p,\, q_1+1+d) = -\frac{B(p_0+p_1, q_0+q_1)}{d!}\, p^d + \text{lower order}$$

| $d$ | Degree | Leading coeff ($\pi$) | Pattern |
|-----|--------|-----------------------|---------|
| 0 | const | $-420732$ | $-B'/0!$ |
| 1 | linear | $-420732$ | $-B'/1!$ |
| 2 | quadratic | $-210366$ | $-B'/2!$ |
| 3 | cubic | $-70122$ | $-B'/3!$ |
| 4 | quartic | $-35061/2$ | $-B'/4!$ |
| $\vdots$ | | | |
| 8 | degree 8 | $-11687/1120$ | $-B'/8!$ |

where $B' = B(p_0+p_1, q_0+q_1)$.

This polynomial correction holds for $d = 0, \ldots, \sim q_1 + 1$. Beyond that,
a **second-level correction** activates (verified: Pi breaks at $d = 9$, i.e., $j = 17$;
$\sqrt{5}$ breaks at $j = 11$; $\varphi$ breaks at $j = 7$).

Script: `scripts/correction_polynomial.wl`

### Self-similar structure

Between level-2 semi-convergent positions (e.g., 25, 47, 69, ... for $\pi$), the stair
pattern is the **Sturmian word of the first convergent** $p_1/q_1$. For $\pi$:

$$\text{Block pattern} = \{3, 3, 3, 3, 3, 3, 4\} \quad (= \text{Sturmian for } 22/7)$$

This repeats identically for all blocks, confirming the self-similar CF structure.

---

## Summary: Three-Layer Formula

For the state vector entry $v_j(p)$ at a semi-convergent position $p$ of irrational $\alpha$:

**Layer 0** ($j \leq q_1$): Exact closed form
$$v_j(p) = \frac{p - wj}{p}\binom{p+j-1}{j}$$

**Layer 1** ($q_1 < j \leq 2q_1 + O(1)$): Polynomial correction
$$v_j(p) = \frac{p - wj}{p}\binom{p+j-1}{j} - \sum_{d=0}^{j-q_1-1} c_d \cdot p^d$$
where $c_d$ has leading term $B(p_0+p_1, q_0+q_1)/d!$

**Layer 2+** ($j > 2q_1 + O(1)$): Second correction from $q_2$-level structure (not yet characterized)

---

## Result 4: Exact Formula for Rational Staircases with 2-Term CF

**Status:** $\checkmark$ Numerically verified

For rational $p/q$ with $\gcd(p,q) = 1$ and continued fraction $p/q = [a_0; a_1]$
(exactly two terms), the formula

$$v_j(p, q) = \frac{p - a_0 j}{p}\binom{p+j-1}{j}$$

is **exact for ALL $j = 0, \ldots, q$**. No corrections needed.

Verified for 12 rationals: $[a_0; a_1]$ with $a_0 \in \{2,3,4\}$, $a_1 \in \{3,5,7,10\}$.

**Corollary:** For the uniform case (first batch of semi-convergents), $p/q = [w; k]$
is always a 2-term CF rational, confirming that Result 1 is a special case.

### Why it works

A 2-term CF $[a_0; a_1]$ means $p = a_0 a_1 + 1$, $q = a_1$. The staircase
$\lfloor q x / p \rfloor$ has $a_1$ stairs, all of width $a_0$ except the last (width $a_0 + 1$
at the boundary). But since $p = a_0 q + 1$, the staircase is equivalent to the uniform
staircase up to column $p$, and the formula coincides with the generalized ballot count
under a line of slope $q/p \approx 1/a_0$.

---

## Result 5: Rational Staircase Reduction

**Status:** $\checkmark$ Verified

The problem of computing $v_j(p)$ at a semi-convergent position $p$ of irrational $\alpha$
reduces to a **purely rational** problem: counting paths under $\lfloor q x / p \rfloor$
with $\gcd(p,q) = 1$.

This follows from the Floor Agreement Lemma (Lemma 3 in the paper):
$\lfloor x/\alpha \rfloor = \lfloor q x / p \rfloor$ for $x = 1, \ldots, p-1$ at
convergent/semi-convergent positions $p/q$.

**Implication:** The correction structure depends only on the CF of $p/q$ (a finite CF),
not on the irrational $\alpha$. Corrections appear if and only if $p/q$ has $\geq 3$ CF terms.

---

## Open Problem: Closed Form for Intermediate-Height Ballot Counts

### Problem statement

Let $p/q$ be a rational with $\gcd(p,q) = 1$ and CF expansion $[a_0; a_1, a_2, \ldots]$
of length $\geq 3$. Count monotonic lattice paths from $(1,0)$ to $(p, j)$ staying weakly
below the staircase $\lfloor qx/p \rfloor$, for arbitrary $j \leq q$.

**Known:** For $j \leq a_1$ (first partial quotient), the count is
$(p - a_0 j)/p \cdot \binom{p+j-1}{j}$ (our Result 2; equivalent to Irving--Rattan
Corollary 3 [1]).

**Unknown:** Closed form for $j > a_1$.

### What we know about the corrections

For semi-convergent positions $p$ of a fixed irrational $\alpha$, the correction
$\delta_j(p) := v_j(p) - \frac{p - wj}{p}\binom{p+j-1}{j}$ has the following structure:

1. **Range $j = q_1 + 1, \ldots, 2q_1 + 2$:** The correction is a polynomial in $p$
   of degree $d = j - q_1 - 1$, with leading coefficient
   $$\frac{-B(p_0 + p_1,\, q_0 + q_1)}{d!}$$
   Verified for $\pi$, $\sqrt{5}$, $\sqrt{2}$, $\varphi$ (four irrationals,
   polynomials up to degree 8).

2. **Beyond $j = 2q_1 + 2$:** The polynomial structure breaks; a second-level correction
   (from $q_2$) activates. The hierarchical structure mirrors the CF self-similarity.

3. **At $j = q_1 + 1$ only:** The correction is a **constant** $-B(p_0 + p_1, q_0 + q_1)$,
   independent of $p$.

### Where we got stuck (RESOLVED 2026-04-10 — see R18)

**Resolution:** The cfBlock[0] rise-vs-within problem was solved by the
**rotation decomposition** (R18): $M_r = \operatorname{sturmianBlock}[d_0{+}r, p{-}r, q{-}r] \cdot \operatorname{riseProduct}[d_0, r]$,
where $r = $ number of rises before first within. This eliminates cfBlock[0]
entirely and gives EXACT MATCH for $\sqrt{2}$, $\sqrt{3}$, $\varphi$ at levels 1–6.
See `SUMMARY.md` R18 for full details.

The three approaches below were the earlier (pre-R18) attempts:

**Approach 1: Additive decomposition (and why it structurally fails)**

Tried $v_j(p,q) = v_j^{\mathrm{lin}}(p) - v_{j-(q_1+1)}(p_0{+}p_1,\, q_0{+}q_1)$
with shifted indices. Result: **off-by-one at $j = q_1 + 1$**, residual $= -(B' - 1)$.

Deeper analysis showed the residual polynomial (after subtraction) has **identical
leading coefficients** $-B'/d!$ for all degrees $d \geq 1$ — the subtraction only
affects the constant term, reducing it by $v_0(p_0{+}p_1) = 1$:

| $d$ | Orig. leading | Resid. leading | Match? |
|-----|---------------|----------------|--------|
| 0 | $-420732$ | $-420731$ | off by 1 |
| 1 | $-420732$ | $-420732$ | exact |
| 2 | $-210366$ | $-210366$ | exact |
| 3 | $-70122$ | $-70122$ | exact |
| 4 | $-35061/2$ | $-35061/2$ | exact |

**Root cause:** The correction at $j = q_1+1$ is $-B(p_0{+}p_1, q_0{+}q_1) = -420732$,
but the subtracted term gives $-v_0(p_0{+}p_1) = -1$. These differ by a factor of
$B' = 420732$, not by 1. The error is structural, not accumulated — it propagates
unchanged through the polynomial degrees because the subtraction only shifts the
constant without touching higher coefficients.

Also tested: $f(j) = \delta_j(p) / B'$ is integer only at $j = q_1 + 1$ (where $f = 1$).
For $j > q_1 + 1$, the denominator $117 = 9 \times 13$ persistently appears, suggesting
the correction involves the full transfer-matrix product (convolution of ALL state vector
entries), not a simple index shift of a single entry.

**Approach 2: Binomial basis decomposition**

Expressed correction polynomials in the basis $\binom{p - c}{k}$ for various shifts $c$
(tried $c = p_1, p_0 + p_1, p_0 + p_1 + 1$). The trailing coefficient is always
$-B(p_0 + p_1, q_0 + q_1)$ (clean), but the lower-order coefficients don't simplify
into known combinatorial quantities. For $\varphi$ (GR), the C(t-2, k) basis gave
coefficients $\{-2\}, \{-1, -2\}, \{-18, -3, -2\}, \ldots$ with no obvious pattern
beyond the trailing $-2$.

**Approach 3: Fibonacci recurrence (GR only)**

For $\alpha = \varphi$, the corrections at $j = 3$ satisfy the recurrence
$c_{k+2} = c_{k+1} + c_k - 3$ across Fibonacci positions $p = F_n$.
This is a Fibonacci-like recurrence with constant inhomogeneity. Clean for GR
but does not obviously generalize to other irrationals (where the position spacing
is arithmetic, not Fibonacci).

### What the literature says

A thorough literature search (April 2026) found **no existing closed-form formula**
for this problem. The closest results:

| Reference | What it gives | Gap |
|-----------|--------------|-----|
| Irving & Rattan [1] Corollary 3 | $(k - al + 1)/(k+1) \cdot \binom{k+l}{l}$ for paths under the **line** $x = ay$ | Only works for $j \leq a_1$ (uniform stairs) |
| Banderier & Wallner [2] Lemma 8.3 | GF for paths at each altitude via Schur polynomials of kernel roots | Algebraic GF, no binomial closed form; individual heights are "ugly" |
| Banderier & Wallner [2] Thm 8.5 | Clean binomial for **sums** of path counts over blocks of $a$ boundary shifts | Individual boundaries require Möbius inversion; "ugly + ugly = nice" phenomenon |
| Firoozi, Jedwab & Rattan [3] Thm 1.12 | $\mu_j(g) = \sum (-1)^k E_k H_{g-k}$ for paths with $k$ flaws to endpoint $(ga, gb)$ | Different problem (flaws to endpoint, not intermediate height); but correction structure is analogous |
| Bizley [4] | $\Phi_{k,t}$ for paths with $t$ contacts with boundary $my = nx$ | Only for paths to points ON the boundary |
| Nakamigawa & Tokushige [5] | Generalized cycle lemma for real slope | Behind paywall; may contain intermediate-height results |

### Result 6: Transfer matrix = Toeplitz + binomial correction (2026-04-09 late)

**Status:** $\checkmark$ Proved (closed form) and numerically verified

The block transfer matrix $M$ (mapping $v(p_{k-1})$ to $v(p_k)$ through a Sturmian block)
has the decomposition:

$$M[j, s] = \binom{p_1 - 1 + j - s}{j - s} - \Delta(j, s)$$

where the Toeplitz part $\binom{p_1-1+j-s}{j-s}$ is **exact for rows $j = 0, \ldots, q_1+1$**
(i.e., the first $q_1 + 2$ rows), and $\Delta = 0$ for $j \leq q_1 + 1$.

Script: `scripts/transfer_matrix_fixed.wl`

---

## Result 7: Complete Closed Form for the Block Transfer Correction

**Status:** $\checkmark$ Proved and verified for $w = 1, \ldots, 5$, $a_1 = 2, \ldots, 10$

### The formula

For $j = a_1 + 2 + d$ with $d = 0, \ldots, a_1 - 2$:

$$\boxed{\Delta_{a_1+2+d,\, s} = \sum_{m=1}^{d+1}
\frac{w(a_1 - d - 1) + 1}{w(a_1 - m) + 1}\,
\binom{w(a_1 - m) + d - m + 1}{d - m + 1}\;
\binom{a_1 + m(w+1) - s}{mw - 1}}$$

Equivalently, the coefficient of the $m$-th basis function is
$c_{d,m} = v_{d-m+1}\bigl(w(a_1 - m) + 1\bigr)$, where $v_j(p) = \frac{p - wj}{p}\binom{p+j-1}{j}$
is the uniform formula from Result 1. Each coefficient is the uniform formula evaluated
at a **shifted position** $p_m = w(a_1 - m) + 1$.

### Structure

| Component | Formula | Meaning |
|-----------|---------|---------|
| Coefficient $c_{d,m}$ | $v_{d-m+1}(p_m)$, $p_m = w(a_1-m)+1$ | Uniform formula at level-$m$ shift |
| Basis $B_m(s)$ | $\binom{a_1 + m(w+1) - s}{mw - 1}$ | Binomial at level $m$ |
| Number of terms | $d + 1$ | Grows linearly with correction depth |

### Special cases

| Case | Formula | Notes |
|------|---------|-------|
| $d = 0$ | $\binom{a_1 + w + 1 - s}{w - 1}$ | Single binomial |
| $w = 1$ | $\binom{2a_1 + 2 + d - s}{d}$ | Single binomial (Vandermonde collapse) |
| $m = d + 1$ (last term) | $c = 1$ always | Coefficient = $v_0(p_{d+1}) = 1$ |
| $d = a_1 - 2$ (last row) | Fuss--Catalan $A_{a_1-m}^{(w+1)}$ | $c = \frac{1}{w(a_1-m)+1}\binom{(w+1)(a_1-m)}{a_1-m}$ |

### Derivation (outline)

1. **Factorization $A = L \cdot U$:** The actual block transfer $A$ (last stair width $w+1$)
   equals a single prefix-sum $L$ applied to the uniform block transfer $U$ (all stairs width $w$).

2. **Truncation analysis:** The uniform transfer $U$ is built by $a_1$ stair operations.
   Each stair $k \geq 2$ truncates the Vandermonde convolution at the boundary of the
   initial dimension, creating a rank-1 defect: $D_k[j,s] = f_k(j) \cdot g_k(s)$.

3. **Defect accumulation:** The defects compound recursively through subsequent stairs.
   After $a_1$ stairs, the total defect decomposes into a sum of $a_1 - 1$ products of
   binomial coefficients—one for each "level" $m$ in the CF hierarchy.

4. **Identification:** The coefficients $c_{d,m}$ are recognized as the uniform formula
   $v_j(p)$ evaluated at shifted positions $p_m = w(a_1-m)+1$. This self-similar structure
   reflects the recursive nature of continued fraction approximation.

### Numerical verification

- Verified for all $w = 1, \ldots, 5$ and $a_1 = 2, \ldots, 10$ (exhaustive).
- Cross-checked against DP computation for $\pi$, $\sqrt{5}$, $\sqrt{2}$, $\varphi$.
- Block transfer $M \cdot v(25) = v(47)$ matches DP exactly for $\pi$.

Scripts: `scripts/binomial_basis.wl`, `scripts/verify_formula.wl`, `scripts/full_formula_test.wl`

### Open: Multi-block iteration

The formula gives the correction for a **single block** transfer (initial dimension $a_1+1$).
Iterating the block transfer requires generalizing to arbitrary initial dimension $d_0$.
The correction structure is the same (same Sturmian pattern), but the truncation boundary
shifts to $d_0 + 1$. This generalization is needed for computing $v(p)$ at positions
$p = p_0 + k \cdot p_1$ for $k \geq 3$.

### Multi-block iteration (resolved)

The formula for $M[j,s]$ is **independent of input dimension**: the same
$\Delta(j,s)$ applies regardless of the state vector size. Verified by
iterating the block transfer 3 times on $\pi$ ($v(25) \to v(47) \to v(69) \to v(91)$),
matching DP at every step. The key: the Toeplitz entry $\binom{p_1-1+j-s}{j-s}$
and the correction $\Delta(j,s)$ depend only on $j$, $s$, and the CF parameters
$(w, a_1)$, not on the number of input entries.

Script: `scripts/full_formula_test.wl`

---

## Result 8: Self-Similar Level-$k$ Correction Formula

**Status:** $\checkmark$ Verified for $\sqrt{5}$ and $\pi$ at levels 1 and 2

### Discovery

The block transfer correction has the **same formula at every CF level**.
At level $k$, the block transfer maps a state vector through $q_k$ rises
(the $k$-th convergent denominator). The Toeplitz part is
$T_k[j,s] = \binom{p_k - 1 + j - s}{j - s}$, and the correction is:

$$\boxed{\Delta_k[A_k + 2 + d,\, s] = \sum_{m=1}^{d+1}
v_{d-m+1}(p_k - wm)\;\binom{A_k + m(w{+}1) - s}{mw - 1}}$$

where $v_j(p) = \frac{p - wj}{p}\binom{p+j-1}{j}$ is the universal uniform
formula from Result 1.

### What changes between levels

| Parameter | Level 1 | Level 2 | General |
|-----------|---------|---------|---------|
| Convergent $p_k$ | $p_1$ | $p_2$ | $k$-th convergent numerator |
| Offset $A_k$ | $q_1$ | $q_1 + q_2 - 1$ | $\sum_{i=1}^k q_i - k + 1$ |
| First correction row | $q_1 + 2$ | $q_1 + q_2 + 1$ | $A_k + 2$ |
| Valid range | $d = 0, \ldots, q_1 - 2$ | $d = 0, \ldots, q_1 - 1$ | $d = 0, \ldots, q_1 - 1$ |
| Basis functions | same | same | $\binom{A_k + m(w{+}1) - s}{mw - 1}$ |

### What stays the same

- The uniform formula $v_j(p)$ (the coefficients)
- The basis structure $\binom{A_k + m(w{+}1) - s}{mw - 1}$
- The floor $w = \lfloor\alpha\rfloor$ (determines everything)
- The shifted positions $p_k - wm$ (same linear pattern at every level)

### Ballot factorization

The coefficients factor through **ballot numbers**:

$$v_{d-m+1}(p_k - wm) = (p_k - w(d{+}1)) \cdot B(p_k - wm,\, d - m + 1)$$

where $B(n, k) = \binom{n+k-1}{k}/n$. The linear factor $(p_k - w(d{+}1))$
is **common to all $m$**, so:

$$\Delta_k[A_k{+}2{+}d,\, s] = (p_k - w(d{+}1)) \cdot
\sum_{m=1}^{d+1} B(p_k{-}wm,\, d{-}m{+}1)\;\binom{A_k + m(w{+}1) - s}{mw - 1}$$

Each term is a product of a **ballot number** (encoding the irrational via $p_k$)
and a **binomial coefficient** (encoding the lattice combinatorics via $A_k$, $w$).

### Numerical verification

**$\sqrt{5} = [2;\, 4, 4, 4, \ldots]$, $w = 2$:**

Level 1 ($p_1 = 9$, $A_1 = 4$): all 3 correction rows match. ✓

Level 2 ($p_2 = 38$, $A_2 = 20$): first $q_1 = 4$ of 17 correction rows match. ✓

| $d$ | Coefficients $c_{d,m}$ | Matches formula? |
|-----|------------------------|:---:|
| 0 | $\{1\}$ | ✓ |
| 1 | $\{34, 1\}$ | ✓ |
| 2 | $\{592, 32, 1\}$ | ✓ |
| 3 | $\{7030, 525, 30, 1\}$ | ✓ |
| 4 | — | ✗ (sub-block corrections activate) |

**$\pi = [3;\, 7, 15, 1, \ldots]$, $w = 3$:**

Level 1 ($p_1 = 22$, $A_1 = 7$): all 6 correction rows match. ✓

Level 2 ($p_2 = 333$, $A_2 = 112$): first $q_1 = 7$ of $\sim 105$
correction rows match. ✓

### Beyond $d = q_1 - 1$: sub-block interactions

For $d \geq q_1$, the simple formula breaks. The residual comes from
**level-1 corrections within sub-blocks**, compounded through Toeplitz
propagation. Specifically, each level-2 block decomposes as
$M_2 = M_1' \cdot M_1^{a_2-1}$ ($a_2 - 1$ standard + 1 anomalous level-1 blocks),
and the level-1 corrections $\Delta_1$ within each $M_1$ create higher-order
corrections when composed.

The residual does **not** decompose into the same binomial basis, indicating
that the full correction requires additional basis functions from the
sub-block interaction structure.

### Open: convolution identity

The inner sum $\Phi_k(d, s) = \sum_m B(p_k{-}wm,\, d{-}m{+}1) \cdot \binom{A_k + m(w{+}1) - s}{mw - 1}$
is a convolution of ballot numbers with binomial coefficients. An identity
collapsing this sum would yield a direct closed form for the correction
and potentially extend to all $d$ (not just $d < q_1$).

### Observation: parallel boundaries

Shifting the staircase boundary $\lfloor x/\alpha \rfloor$ by $k$ lattice
points corresponds to counting paths at height $j + k$ vs height $j$.
The correction structure encodes exactly this shift: the coefficient
$v_j(p_k - wm)$ counts paths under a **parallel boundary** displaced by
$wm$ columns. The self-similar formula thus decomposes the staircase
correction into a sum of parallel-boundary contributions.

Scripts: `scripts/level2_correction_v2.wl`, `scripts/level2_formula_verify.wl`

---

## Result 9: Structural Properties of the Block Transfer

**Status:** $\checkmark$ Verified for $\sqrt{5}$ and $\pi$

### Unimodularity

The top $(q_1{+}1) \times (q_1{+}1)$ square submatrix of $M_k$ (the Toeplitz
region, where $\Delta = 0$) has $\det = 1$. This is the lattice-path
manifestation of the CF unimodularity condition $p_k q_{k-1} - p_{k-1} q_k = \pm 1$.

### Last-two-equal identity

At every semi-convergent position $p/q$:

$$v_{q-1}(p) = v_q(p) = B(p, q)$$

The last two entries of the state vector are always equal. This is structural:
the final rise in the staircase copies $v_{q-1}$ into $v_q$.

### Last-row ballot constraint

At the $k$-th semi-convergent $p = p_0 + k p_1$, $q = q_0 + k q_1$:

$$\delta_q(p) = v_q(p) - v_q^{\mathrm{lin}}(p) = -(k-1) \cdot B(p, q)$$

since $v_q^{\mathrm{lin}}(p) = k \cdot B(p, q)$ and $v_q(p) = B(p, q)$.

### Polynomial structure of corrections (top-down)

For fixed $j = q_1 + 1 + d$, the correction $\delta_j(p)$ across semi-convergent
positions $p = p_0 + k p_1$ ($k \geq 2$) is a polynomial in $p$ of degree $d$.

| $d$ | Leading coefficient | Sub-leading ratio $c_{d-1}/c_d$ |
|-----|--------------------|---------------------------------|
| 0 | $-B'$ | — |
| 1 | $-B'$ | $-101/13$ |
| 2 | $-B'/2$ | $-189/13$ |
| 3 | $-B'/6$ | $-264/13$ |
| $\geq q_1$ | **changes** (sub-block corrections) | different denominator |

where $B' = B(p_0{+}p_1,\, q_0{+}q_1)$ and $13 = q_0 + 3q_1$ for $\sqrt{5}$.

### Convolution identity (negative result)

For $w = 1$ (Catalan case), the correction sum collapses to a single binomial
via Vandermonde--Chu: the bottom indices sum to a constant ($m{-}1 + d{-}m{+}1 = d$).

For $w \geq 2$, this collapse is **impossible**: the bottom indices sum to
$d + m(w{-}1)$, which depends on $m$. The multi-term sum IS the closed form.

### Persistent denominator $q_0 + (a_2{-}1)q_1$

For $\sqrt{5}$: the denominator $13 = q_0 + 3q_1$ (the $q$-value at the
penultimate semi-convergent $p_0 + (a_2{-}1)p_1 = 29$) appears in:

- Sub-leading polynomial ratios: $c_{d-1}/c_d = -101/13, -189/13, -264/13$
- Combined ballot coefficient: $(M_1[2q_1, q_1{-}1] + M_1[2q_1, q_1]) / B' = B(p_1, q_1) / 13$

This is specific to $\sqrt{5}$ and the $p_1 \to p_2$ transition; for $\pi$
the analogue would be $q_0 + (a_2{-}1)q_1 = 1 + 14 \cdot 7 = 99$.
**Not yet verified** as a general pattern.

### Ballot recurrence

The block transfer last row gives an exact one-step ballot recurrence:

$$B(p{+}p_1,\, q{+}q_1) = \sum_{s=0}^{q_1} M_1[2q_1, s] \cdot v_s(p)$$

with the bottom-right entry $M_1[2q_1, q_1] = B(p_0{+}p_1,\, q_0{+}q_1)$.
Combining the last two entries (since $v_{q-1} = v_q = B(p,q)$):

$$B(p{+}p_1,\, q{+}q_1) = \sum_{s=0}^{q_1-2} M_1[2q_1, s] \cdot v_s(p)
\;+\; (M_1[2q_1, q_1{-}1] + B') \cdot B(p, q)$$

Verified for the first step ($k = 1 \to 2$) on $\sqrt{5}$ and $\pi$.
For subsequent steps ($k \geq 2$), the state vector grows beyond $q_1{+}1$
entries, requiring the full (dimension-independent) transfer formula.

At level 2: $M_2[\mathrm{last},:] \cdot v(47) = B(85, 38)$ confirmed,
but $M_2[\mathrm{last, last}] = B(p_2, q_2) = B(38, 17)$
(the convergent ballot number, not the first semi-convergent's).

Scripts: `scripts/unimodular.wl`, `scripts/topdown_polynomials.wl`,
`scripts/convolution_identity.wl`, `scripts/ballot_recurrence.wl`,
`scripts/minor_structure.wl`

---

## Open Questions

1. **Full correction for $d \geq q_1$:** Sub-block interaction terms. The residual
   doesn't decompose into the binomial basis $\binom{A_k + m(w{+}1) - s}{mw - 1}$,
   suggesting additional basis functions from level-1 corrections propagated through
   Toeplitz kernels.

2. **Matrix-level recursion:** Express $\Delta_2$ directly through $M_1$ (the level-1
   transfer matrix), not just its scalar entries. This would capture the sub-block
   interactions algebraically.

3. **Unimodularity cascade:** The CF determinant $\pm 1$ manifests as $\det(M_{\mathrm{top}}) = 1$.
   Does this propagate through levels? What is $\det(M_{2,\mathrm{top}})$?

4. **Combinatorial deficit as invariant:** The function $\delta_j(p) = v_j(p) - v_j^{\mathrm{lin}}(p)$
   is a new invariant of the irrational $\alpha$, encoding CF structure in lattice path
   corrections. Does it connect to irrationality measures?

### References

\[1\] J. Irving and A. Rattan, *The number of lattice paths below a cyclically shifting
boundary*, J. Combin. Theory Ser. A **116** (2009), 499–514.
[arXiv:0712.3213](https://arxiv.org/abs/0712.3213).
Local: `papers/irving-rattan-cyclically-shifting-2009.pdf`

\[2\] C. Banderier and M. Wallner, *The kernel method for lattice paths below a line
of rational slope*, in: Lattice Path Combinatorics and Applications, Springer (2019).
[arXiv:1606.08412](https://arxiv.org/abs/1606.08412).
Local: `papers/banderier-wallner-rational-slope-2019.pdf`

\[3\] S. Firoozi, J. Jedwab, and A. Rattan, *Combinatorial enumeration of lattice paths
by flaws with respect to a linear boundary of rational slope*,
Electron. J. Combin. **33**(1) (2026), #P3.
[EJC link](https://www.combinatorics.org/ojs/index.php/eljc/article/view/v33i1p3).
Local: `papers/firoozi-jedwab-rattan-flaws-rational-2026.pdf`

\[4\] M.T.L. Bizley, *Derivation of a new formula for the number of minimal lattice paths...*,
J. Inst. Actuar. **80** (1954), 55–62.
Local: `papers/bizley-1954-lattice-paths.pdf`

\[5\] T. Nakamigawa and N. Tokushige, *Counting lattice paths via a new cycle lemma*,
SIAM J. Discrete Math. **26** (2012), 745–754.
[DOI](https://epubs.siam.org/doi/10.1137/100796431) (paywall).

\[6\] V.Y.W. Guo and L. Wang, *A Chung–Feller theorem for lattice paths with respect
to cyclically shifting boundaries*, J. Algebr. Comb. **50** (2019), 119–126.
Local: `papers/guo-wang-chung-feller-2019.pdf`

\[7\] C. Krattenthaler, *Lattice Path Enumeration*, in: Handbook of Enumerative Combinatorics,
CRC Press (2015), 589–678. [arXiv:1503.05930](https://arxiv.org/abs/1503.05930).
Local: `papers/krattenthaler-lattice-path-survey-2015.pdf`

---

## Scripts

| File | Description |
|------|-------------|
| `../2026-04-07-chebyshev-wigner-semicircle/scripts/closed_form_verify.wl` | Verification of uniform formula |
| `scripts/universal_formula_test.wl` | Universal formula test for 4 irrationals |
| `scripts/correction_structure.wl` | First correction analysis |
| `scripts/correction_polynomial.wl` | Polynomial degree and leading coefficient analysis |
| `scripts/nonuniform_explore.wl` | Non-uniform stair structure exploration |
| `scripts/level2_state_vectors.wl` | Full state vectors at level-2 positions |
| `scripts/exact_correction.wl` | Rational staircase + 2-term CF exactness |
| `scripts/recursive_decomposition.wl` | Attempted recursive decomposition |
| `scripts/offbyone_fix.wl` | Off-by-one analysis (residuals = polynomial, same leading coeffs) |
| `scripts/transfer_matrix_fixed.wl` | **KEY:** Block transfer matrix M, Toeplitz + binomial structure |
| `scripts/level2_correction.wl` | Level-2 correction (Sturmian word — wrong stair ordering) |
| `scripts/level2_correction_v2.wl` | **KEY:** Level-2 correction with actual staircase (correct) |
| `scripts/level2_formula_verify.wl` | **KEY:** Self-similar formula verification, √5 + π, levels 1–2 |
| `scripts/level2_residual.wl` | Residual analysis at shifted positions |
| `scripts/level2_deep_residual.wl` | Sub-block decomposition of level-2 correction |
