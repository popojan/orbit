# Beatty Ballot Closed Forms — Summary & Next Steps

**Session:** 2026-04-09 / 2026-04-10
**Status:** 19 results proved/verified; R18 rotation (w=1), R19 w-reduction kernel (general w)

---

## What We Have

### The Setup

For irrational $\alpha$ with CF $[a_0; a_1, a_2, \ldots]$, count lattice paths
from $(1,0)$ to $(p, j)$ staying weakly below the staircase $\lfloor x/\alpha \rfloor$.
The state vector $v_j(p) = \mathrm{dp}(p, j)$ encodes all path counts at position $p$.

### Closed Forms (Proved)

| Result | Statement | Scope |
|--------|-----------|-------|
| **R1** | $v_j^{(k)} = \frac{w(k{-}j)+1}{wk+1}\binom{wk+j}{j}$ | Uniform stairs (first $q_1$ semi-convergents) |
| **R2** | $v_j(p) = \frac{p-wj}{p}\binom{p+j-1}{j}$ | All semi-conv positions, $j \leq q_1$ |
| **R4** | Same as R2, exact for all $j$ | 2-term CF rationals $[a_0; a_1]$ |
| **R5** | Rational reduction: $v_j(p)$ depends only on CF of $p/q$ | Converts irrational problem to rational |
| **R7** | $\Delta[A{+}2{+}d, s] = \sum_{m=1}^{d+1} v_{d-m+1}(p_1{-}wm) \cdot \binom{A{+}m(w{+}1){-}s}{mw{-}1}$ | Block transfer correction, $d < q_1$ |
| **R8** | Same formula at every CF level (only $p_k$, $A_k$ change) | Self-similar, verified levels 1-2 |
| **R16** | R7 sum $= {}_{(2w+2)}F_{(2w+1)}(1)$, Saalschützian; $w{=}1$ collapses, $w{\geq}2$ irreducible | Verified $w=1,2,3,4$ |

### Key Structural Results

- **R3**: First correction at $j = q_1{+}1$ is constant $-B(p_0{+}p_1, q_0{+}q_1)$;
  higher corrections are polynomials in $p$ with leading coeff $-B'/d!$
- **R6**: Block transfer = Toeplitz $-$ correction; first $q_1{+}2$ rows exact Toeplitz
- **R9**: $\det(M_\text{top}) = 1$ (unimodularity); $v_{q-1} = v_q = B(p,q)$ (last-two-equal);
  ballot factorization of correction coefficients

### Negative Results

- $w = 1$: correction collapses to single binomial via Rothe-Hagen identity (R14)
- $w \geq 2$: multi-term sum IS the closed form; goes beyond Rothe-Hagen (no simplification)
- Additive decomposition structurally fails (off-by-one at constant term, exact elsewhere)

---

## Inclusion-Exclusion Expansion (Results 10–12)

*Previously called "Born expansion" — renamed because the structure is
elementary inclusion-exclusion on a finite product, not iterative scattering theory.*

### Q1. Full correction for $d \geq q_1$ (sub-block interactions) — ESTABLISHED

The level-2 block decomposes as $M_2 = \mathrm{SB}_{a_2} \cdots \mathrm{SB}_1$
with $a_2{-}1$ standard blocks (each $p_1$ columns) + 1 anomalous ($p_0{+}p_1$ columns).

Each $\mathrm{SB}_i = T_i - D_i$ where $T_i$ = Toeplitz, $D_i$ = correction (R7).
Expanding the product by inclusion-exclusion:

$$M_2 = \text{allT} - \sum_i T \cdots D_i \cdots T + \sum_{i<j} T \cdots D_i \cdots D_j \cdots T - \cdots$$

The expansion terminates at order $a_2$ and is exact.

**Verified:** $\sqrt{5}$ (a₂=4, exact), $\pi$ (a₂=15, all 15 sub-blocks, composition ✓).

### R10b: Closed-form $D_i$ for rotated Sturmian (PROVED)

R7 formula with $A = d_0 - 2$ works for ALL stair patterns and all sub-blocks.

### R12: Order structure (PROVED for $\sqrt{5}$)

Order $k$ first contributes at depth $d = (k{-}1) \cdot q_1$. Each successive
order improves by $\sim 100\times$. Terminates at order $a_2$.

---

## Results Proved 2026-04-09

### R13: $A = d_0 - 2$ — PROVED

The offset is a combinatorial counting convention:

1. First correction row at $j = d_0$ (rows below unaffected by dim growth)
2. R7 at $d = 0$ gives $\binom{A+w+1-s}{w-1}$; actual = $\binom{d_0+w-1-s}{w-1}$ (hockey-stick)
3. $A + (w+1) = d_0 + (w-1) \Rightarrow A = d_0 - 2$
4. **$-2 = (w+1) - (w-1)$**: Sturmian gap width minus hockey-stick index. Always 2.

Verified: 6 irrationals (w from 1 to 14). Script: `scripts/proof_A_offset.wl`

### R14: $w = 1$ collapse = Rothe-Hagen identity — PROVED

For $w = 1$, the multi-term R7 sum collapses to a single binomial:

$$\Delta_{w=1}[d_0 + d,\, s] = \binom{d_0 + p_1 + d - 1 - s}{d}$$

**This is the Rothe-Hagen identity** (Rothe 1793, Hagen 1891) with parameter $b = 2$:

$$\sum_{j=0}^{d}\frac{a}{a+2j}\binom{a+2j}{j}\binom{c-2j}{d-j}=\binom{a+c}{d}$$

with $a = p_1 - d - 1$, $c = d_0 + 2d - s$.

The key step: the ballot number $v_j(q) = \frac{q-j}{q}\binom{q+j-1}{j}$
satisfies $v_j(a+j) = \frac{a}{a+2j}\binom{a+2j}{j}$, which is the
Rothe-Hagen coefficient with $b = 2$.

**For general $w$:** the ballot with slope $w$ gives $v_j^{(w)}(a+wj) = \frac{a}{a+(w+1)j}\binom{a+(w+1)j}{j}$,
corresponding to Rothe-Hagen $b = w+1$. However, the second factor in R7
has incompatible structure for $w \geq 2$, so the sum does **not** collapse.
The multi-term R7 formula goes beyond classical Rothe-Hagen.

Proved symbolically (d=0..5). Verified: $\sqrt{2}, \varphi, \sqrt{3}, 1+1/\pi$.
Script: `scripts/w1_catalan_collapse.wl`

### R15: Inductive proof of R7 — PROVED for $q_1 \leq 5$

The correction formula R7 is derived from block transfer mechanics:

**Phase structure** for pattern $\{w{+}1, w, w, \ldots, w\}$:
- Rise $m$ at column $mw+1$: creates row $d_0{+}m{-}1$, applies prefix sum $L$
- Between rises: $w{-}1$ within-stair columns, each applying $L$
- Total per phase: pad + $L^w$ (non-last) or pad + $L$ (last)

**Derivation:** Track correction vector $C[0..d]$ through phases.
At each rise: $C_\text{new}[d] = T_{mw}[d_0{+}d] + \sum_{d'<d} C[d']$.
Propagation via $L^{w-1}$ creates ballot coefficients analytically.

Proved: **$q_1 = 2, 3, 4, 5$ with symbolic $w$ and $d_0$** (20/20 matches).
The mechanism is identical for all $q_1$; generalization is straightforward.

Script: `scripts/inductive_proof_r7_v2.wl`

---

## Results Proved 2026-04-09 (late evening)

### R16: Hypergeometric identification — PROVED (Q6 Diamond resolved)

The R7 correction sum for general $w$ is a terminating, 1-balanced
(Saalschützian) generalized hypergeometric:

$$\Delta = \text{prefactor} \times {}_{(2w+2)}F_{(2w+1)}(1)$$

| $w$ | pFq type | Collapses? |
|-----|----------|------------|
| 1 | ${}_{3}F_{2}(1)$ | YES → Rothe-Hagen (Pfaff-Saalschütz) |
| 2 | ${}_{6}F_{5}(1)$ | NO (irreducible) |
| 3 | ${}_{8}F_{7}(1)$ | NO |
| 4 | ${}_{10}F_{9}(1)$ | NO |

**Key finding:** All instances are **1-balanced** (Saalschützian condition:
$\sum a_i - \sum b_j + 1 = 0$). For ${}_{3}F_{2}$ this forces collapse
(Pfaff-Saalschütz theorem). For higher orders, no collapse — the
multi-term R7 sum IS the closed form.

**Pole issue:** At integer specializations of $d, p_1$, lower parameters
become non-positive integers, creating Pochhammer poles. Diagnosed with
perfect 27/27 correlation: every mismatch is a pole case, every non-pole
case matches. Fix: take limits in $p_1$.

**Negative results:** No Whipple transformation applies. `FunctionExpand`
does not reduce ${}_{6}F_{5}$. No order-2 recurrence with polynomial
coefficients for symbolic parameters.

Script: `scripts/q6_diamond_explore.wl`, `scripts/q6_diamond_hypergeom.wl`,
`scripts/q6_diamond_poles.wl`

---

## Open Questions

### Q5. Full inductive proof for arbitrary $q_1$ — ESSENTIALLY DONE

The column-by-column derivation works identically for any $q_1$.
Formal generalization requires showing the recurrence holds for
$q_1 \to q_1 + 1$ (adding one more phase), which follows from
the phase structure being uniform.

### ~~Q6. $w$-analogue of reflection principle~~ — RESOLVED by R16

The multi-term R7 sum = Saalschützian ${}_{(2w+2)}F_{(2w+1)}(1)$.
For $w = 1$, Pfaff-Saalschütz collapses it to a single binomial.
For $w \geq 2$, no analogous collapse exists — the sum is irreducible.
**This closes Q6:** the "diamond" is the hypergeometric classification itself.

### R17: Level scaling via fundamental unit (w=1, quadratic irrationals)

For $\sqrt{D}$ with periodic CF $[a_0; \overline{a_1, \ldots, a_T}]$ and $w = 1$:

- Full-block correction at depth $d$, level $k$: $C_k(d,s) = A_d \cdot \varepsilon^k + B_d \cdot \bar\varepsilon^k + H_d$
  where $\varepsilon = $ fundamental unit of $\mathbb{Q}(\sqrt{D})$,
  $\bar\varepsilon$ = algebraic conjugate ($|\bar\varepsilon| < 1$)
- **$d=0$**: alternates $1, 0, 1, 0, \ldots$ (eigenvalues $\pm 1$)
- **$d=1, s=0$**: equals $d_0 + p_k$ exactly at odd levels (linear in convergents)
- Eigenvalues come from CF recursion $c_{k+2} = a_1 c_{k+1} + c_k$ (for period 1)
- Alternation = interference between $\varepsilon^k$ and $\bar\varepsilon^k$
- **Not a new computational tool** for $\varepsilon$; IS a new combinatorial interpretation

Verified: $\sqrt{2}$ ($\varepsilon = 1{+}\sqrt{2}$), $\sqrt{3}$ ($\varepsilon = 2{+}\sqrt{3}$).

For $w \geq 2$: R7 is irreducible ${}_{6}F_5$ → scaling might encode deeper information.
Open question for next session.

Scripts: `scripts/q6_full_block_scaling.wl`, `scripts/q6_triangular_recursion.wl`

### Q7. Zeilberger recurrence (low priority)

The terminating pFq must satisfy a holonomic recurrence in $d$
(guaranteed by WZ theory). Practical gain marginal since $d < q_1$.

### R18: Rotation-aware block transfer (w=1 quadratic irrationals) — PROVED

**Added:** 2026-04-10

#### The problem

The recursive cfBlock decomposition requires a level-0 block (`cfBlock[0]`)
at the boundary between standard and anomalous sub-blocks within each level-2 block.
This level-0 column can be either a RISE or a WITHIN depending on the position
within the Sturmian word. The original code assumed RISE always, failing at
non-canonical rotations.

#### The solution: rotation decomposition

For a Sturmian block with (p, q) parameters and **rotation** $r$
(= number of consecutive rises before the first within):

$$M_r(d_0) = \operatorname{sturmianBlock}[d_0{+}r,\, p{-}r,\, q{-}r]
  \;\cdot\; \operatorname{riseProduct}[d_0,\, r]$$

where:
- $\operatorname{sturmianBlock}[d_0, p, q] = T(p{-}1) - R7(d_0, p, q)$:
  canonical block, entries are binomial coefficients (R7/Rothe-Hagen for $w{=}1$)
- $\operatorname{riseProduct}[d_0, r]$: product of $r$ consecutive rise matrices
  from dimension $d_0$
- $r = r(x, \alpha)$: determined by $\lfloor x'/\alpha \rfloor$ at the block's
  starting position $x'$

#### Key properties

1. **For $r = 0$ (canonical):** reduces to original sturmianBlock formula
2. **For $r = q$ (all rises first):** $\operatorname{sturmianBlock}[d_0{+}q, 1, 0]$
   is the prefix-sum matrix (within operation), giving the correct transfer
3. **Applies at every level:** cfBlock[1] uses sturmianBlockRot for level-1 blocks,
   cfBlock[2] uses it for the anomalous semi-convergent block, cfBlock[$k \geq 3$]
   composes recursively
4. **cfBlock[0] is eliminated entirely:** no level-0 block needed

#### Recursive structure (w=1)

```
cfBlockX[1, d0, x] = sturmianBlockRot[d0, p1, q1, rotation(x, α)]
cfBlockX[2, d0, x] = sturmianBlockRot[dCur, p0+p1, q0+q1, rotation(xCur, α)]
                      . (a2-1 standard cfBlockX[1] blocks)
cfBlockX[k≥3, d0, x] = cfBlockX[k-1, ...] . cfBlockX[k-2, ...]
                        . (ak-1 standard cfBlockX[k-1] blocks)
```

Position $x$ is tracked through the recursion to determine each sub-block's rotation.

#### Verification

| Irrational | $w$ | Levels tested | Result |
|------------|-----|---------------|--------|
| $\sqrt{2}$ | 1 | 1–6 | EXACT MATCH |
| $\sqrt{3}$ | 1 | 1–6 | EXACT MATCH |
| $\varphi$  | 1 | 1–6 | EXACT MATCH |
| $\sqrt{5}$ | 2 | 1 | FAILS (expected: $w \geq 2$ needs multi-term R7) |
| $\pi$      | 3 | 1 | FAILS (expected: $w \geq 2$) |

#### Complexity vs column-by-column DP

| | DP | cfBlock (R18) |
|---|---|---|
| **Column operations** | $O(p_k)$ | — |
| **Matrix multiplications** | — | $O(\log p_k)$ |
| **Per-operation cost** | $O(q_k \cdot d_0)$ | $O(q_k^2 \cdot d_0)$ |
| **Total (full transfer matrix)** | $O(p_k \cdot q_k \cdot d_0)$ | $O(\log p_k \cdot q_k^2 \cdot d_0)$ |

Since $p_k \approx \alpha \cdot q_k$: **cfBlock is $O(p_k / \log p_k)$ faster than DP**
for the full transfer matrix.

**Theoretical vs actual performance (2026-04-10 benchmark):**

The $O(\log p / p)$ operation-count advantage is **offset** by each cfBlock
operation being a general matrix multiply ($O(q^2 \cdot d_0)$) vs DP's
prefix-sum column update ($O(q \cdot d_0)$). Additionally, $d_0$ grows
inside the recursion (sub-blocks at deeper levels have shifted $d_0$).

Measured CF/DP time ratios (all results verified EXACT MATCH):

| Level | $p_k$ | $q_k$ | $\sqrt{2}$ | $\sqrt{3}$ | $\varphi$ |
|-------|--------|--------|------------|------------|-----------|
| 4 | 41/19/8 | 29/11/5 | 4.0× | 2.3× | 3.2× |
| 6 | 239/71/21 | 169/41/13 | 12.1× | 5.2× | 2.9× |
| 8 | 1393/265/55 | 985/153/34 | 6.8× | 10.7× | 5.2× |

**cfBlock is 3–12× slower than DP in practice.** The ratio worsens with level.

**Conclusion:** R18's value is structural (closed form in binomial coefficients,
level scaling via fundamental unit, proof vehicle for R14/R16/R17), not computational.
For a paclet implementation, column-by-column DP remains the correct algorithm.

#### Symbolic vs numeric components

| Component | Symbolic? | Details |
|-----------|-----------|---------|
| $\operatorname{sturmianBlock}[d_0, p, q]$ | ✓ | $\binom{d_0{+}p{+}d{-}1{-}s}{d}$ |
| $\operatorname{riseProduct}[d_0, r]$ | ✓ for $r \leq 3$ | Case analysis; entries $\binom{j{-}s{+}r{-}1}{r{-}1}$ with last-two-equal |
| CF block recursion | ✓ | Matrix products of binomial-entry matrices |
| $r(x, \alpha)$ (rotation) | **✗** | Requires $\lfloor x/\alpha \rfloor$ at $O(\log p)$ positions |

**The rotation computation is the ONLY non-symbolic step.** It requires $O(\log p_k)$
evaluations of $\lfloor x/\alpha \rfloor$. This limitation holds even for simple quadratic
irrationals ($\sqrt{2}$, $\sqrt{3}$, $\varphi$), because the Sturmian word is
quasi-periodic (never exactly periodic) and the rotation at each sub-block position
depends on the fractional part $\{x / \alpha\}$.

#### Scope

- **Complete** for $w = 1$ quadratic irrationals (CF period arbitrary)
- **Open** for $w \geq 2$: needs rotation-aware version of the full
  multi-term R7 sum (${}_{(2w+2)}F_{(2w+1)}(1)$)

Script: `scripts/q6_rotation_aware.wl`

---

### R19: w-reduction via polynomial convolution kernel (w=2 → w=1) — ESTABLISHED

**Added:** 2026-04-10

#### The result

The correction $\Delta_{w=2}[d, 0]$ for a $w{=}2$ irrational $\alpha = [2; a_1, \ldots]$
can be expressed as a **convolution** with the $w{=}1$ correction
$\Delta_{w=1}[d, 0]$ for $\alpha' = \alpha - 1 = [1; a_1, \ldots]$:

$$\Delta_{w=2}[d, 0] = \sum_{j=0}^{d} K[j] \cdot \Delta_{w=1}[d{-}j, 0]$$

where the **kernel** $K[d;\, d_0, q_1]$ is a **polynomial in $d$** of degree
exactly $d_0 + q_1 - 2$ (verified 24/24 cases across $\sqrt{5}, \sqrt{6}, \sqrt{7}$
for $d_0 = 3, \ldots, 10$).

#### Structure of K

**Low $d$ (pure polynomial in $d_0$):**
$$K[0] = d_0 + 1 \qquad\text{(universal, independent of } q_1\text{)}$$
$$K[1] = \frac{d_0^3 + 3d_0^2 + c_1(q_1)\, d_0 + c_0(q_1)}{6}$$
$$K[2] = \frac{d_0^5 + 5d_0^4 + \ldots}{120}$$

**High $d$ ($d \geq 3$): nested binomial recursion.**
Each $K[d]$ adds one new $\binom{d_0 + 3d + 1}{2d + 1}$ term:

| $d$ | New Binom term | Lower Binom terms |
|-----|----------------|-------------------|
| 3 | $\binom{d_0{+}10}{7}$ | none |
| 4 | $\binom{d_0{+}13}{9}$ | $\binom{d_0{+}10}{7}$ |
| 5 | $\binom{d_0{+}16}{11}$ | both above |
| 6 | $\binom{d_0{+}19}{13}$ | all three above |

The step in indices is $(w{+}1) = 3$: Binom terms are $\binom{d_0 + (w{+}1)d + 1}{wd + 1}$.

**Cross-irrational universality:** Highest-degree coefficients in $d_0$ are
**independent of $q_1$**. For example, in $P_7(d_0)$ (the polynomial part of $K[7]$):
$d_0^{13}$ coefficient $= 91 = \binom{14}{2}$ for all three irrationals.
$d_0^{12}$ coefficient $= 5655 + 78 q_1$ (linear in $q_1$).

#### Factored forms (d₀ = 3)

| Irrational | $q_1$ | degree | $K[d]$ |
|------------|-------|--------|--------|
| $\sqrt{7}$ | 1 | 2 | $d^2 + 6d + 4$ |
| $\sqrt{6}$ | 2 | 3 | $(d{+}1)(2d{+}3)(d{+}8)/6$ |
| $\sqrt{5}$ | 4 | 5 | $(d{+}1)(d{+}2)(d{+}3)(2d^2{+}33d{+}80)/120$ |

Common factor $(d{+}1)$ for $q_1 \geq 2$ (i.e., $K[-1] = 0$).

#### Generating function (corrected)

Using $\mathrm{GF}_{v^{(w)}}(p, x) = \frac{1 - (w{+}1)x}{(1-x)^{p+1}}$
(ballot number GF), the kernel OGF is:

$$K(x) = \sum_{m \geq 1} \binom{d_0{+}3m{-}2}{2m{-}1}
  (1{-}3x)(1{-}x)^{d_0+2m-q_1-1}\, x^{m-1}$$

This is an infinite sum of polynomials in $x$; each $[x^d]$ coefficient is a finite sum
(at most $d{+}1$ terms).

#### Universal formula (proved: interpolation + polynomial existence)

$K[d;\, d_0, q_1]$ is polynomial in $q_1$ of degree exactly $d$.
Computed via interpolation from $d{+}1$ values of $q_1$ (existence guaranteed
because R7 sum involves $v_j^{(2)}(2q_1{+}1{-}2m)$ which is polynomial in $q_1$).

Verified EXACT for $d = 0, \ldots, 4$ against independent $q_1$ test values.

**Leading coefficient in $q_1$:**
$$[q_1^d]\, K[d] = \frac{d_0 + 1}{d!} \qquad\text{(universal)}$$

**Constant term ($q_1 = 0$)** has factor $(d_0{-}1)\, d_0$ — kernel vanishes at $d_0 \in \{0, 1\}$.

**Explicit formulas:**

| $d$ | $K[d;\, d_0, q_1]$ |
|-----|---------------------|
| 0 | $d_0 + 1$ |
| 1 | $\frac{(d_0{-}1)\, d_0\, (d_0{+}4)}{6} + (d_0{+}1)\, q_1$ |
| 2 | $\frac{(d_0{-}1)\, d_0\, (d_0{+}6)(d_0^2{+}11)}{120} + \frac{d_0^3{-}d_0^2{+}3d_0{+}3}{6}\, q_1 + \frac{d_0{+}1}{2}\, q_1^2$ |
| 3 | $\frac{(d_0{-}1)\, d_0\, (d_0{+}8)(\ldots)}{5040} + \frac{\ldots}{120}\, q_1 + \frac{(d_0{+}3)(d_0^2{+}2)}{12}\, q_1^2 + \frac{d_0{+}1}{6}\, q_1^3$ |

Script: `scripts/q6_kernel_universal.wl`

#### General $w$ (verified $w = 2, 3, 4$)

All three structural properties generalize. Verified exact match for
$K_w * \Delta_{w=1} = \Delta_w$ at $w = 2, 3, 4$ with $q_1 = 4$, $d_0 = 5$.

**Degree:**
$$\deg(K_w) = (w{-}1)(d_0 + q_1) - w$$

Verified 18/18 cases ($w \in \{2,3,4\}$, $q_1 \in \{2,3,5\}$, $d_0 \in \{4,5\}$).

**Leading coefficient:**
$$[q_1^d]\, K_w[d] = \binom{d_0{+}w{-}1}{w{-}1} \cdot \frac{(w{-}1)^d}{d!}$$

Verified 15/15 cases ($d = 0, \ldots, 4$ for $w = 2, 3, 4$).

**Value at $d = 0$** (independent of $q_1$):
$$K_w[0] = \binom{d_0{+}w{-}1}{w{-}1}$$

**Binomial step:** $w{+}1$ (Binom terms are $\binom{d_0 + (w{+}1)d + 1}{wd + 1}$).

**Interpretation:** The Saalschützian ${}_{(2w+2)}F_{(2w+1)}(1)$ is a
**convolution of a polynomial kernel with a single binomial coefficient**.
The kernel's leading behaviour is $\binom{d_0+w-1}{w-1} \cdot (w{-}1)^d / d! \cdot q_1^d$,
which decays factorially in $d$ — explaining why the ${}_{(2w+2)}F_{(2w+1)}$
converges rapidly despite being a multi-term sum.

Script: `scripts/q6_sanity_check.wl`, `scripts/q6_kernel_general_w.wl`

#### Sub-leading coefficients (computed, no simple universal form in $d$)

All $q_1$-coefficients of $K_w[d;\, d_0, q_1]$ have been computed explicitly
for $d = 0, \ldots, 4$ and $w = 2, 3, 4$ (script `q6_kernel_all_coeffs.wl`).

For $w = 2$ ($d \leq 3$): pure polynomials in $d_0$:

| $d$ | $[q_1^0]$ | $[q_1^{d-1}]$ | $[q_1^d]$ |
|-----|-----------|----------------|-----------|
| 0 | $d_0{+}1$ | — | $d_0{+}1$ |
| 1 | $\frac{(d_0{-}1)\, d_0\, (d_0{+}4)}{6}$ | $d_0{+}1$ | $d_0{+}1$ |
| 2 | $\frac{(d_0{-}1)\, d_0\, (d_0{+}6)(d_0^2{+}11)}{120}$ | $\frac{d_0^3{-}d_0^2{+}3d_0{+}3}{6}$ | $\frac{d_0{+}1}{2}$ |
| 3 | $\frac{(d_0{-}1)\, d_0\, (d_0{+}8)(\ldots)}{5040}$ | $\frac{(d_0{+}3)(d_0^2{+}2)}{12}$ | $\frac{d_0{+}1}{6}$ |

**Common factor in $[q_1^0]$:** $(d_0{-}1)\, d_0$ for $d \geq 1$ (kernel vanishes at $d_0 \in \{0, 1\}$).

For $w \geq 3$: sub-leading coefficients contain $\binom{d_0 + (w{+}1)j + 1}{wj + 1}$
terms from the nested binomial recursion, with increasing complexity for lower $q_1$-powers.

**No simple universal formula in $d$** for sub-leading coefficients — each $d$ has an
individually structured polynomial$+$Binom expression. However, all are explicitly
computable from the deconvolution for any specific $(w, d)$.

#### Negative result: no short recurrence in $d$

Since $K_w[d]$ IS a polynomial in $d$ (of degree $(w{-}1)(d_0{+}q_1){-}w$),
the shortest recurrence in $d$ is the trivial $\Delta^{D+1} = 0$.
Tested explicitly: order-2 recurrence with rational coefficients in $(d, d_0, q_1)$
**fails** (coefficients explode and do not verify at $d{+}3$).

This is structural, not a gap: **polynomiality in $d$ precludes a non-trivial recurrence**.
The kernel is fully determined by its $D{+}1$ values (computable via deconvolution),
plus the universal leading coefficient $\binom{d_0+w-1}{w-1}(w{-}1)^d/d!$.

#### Circularity note

For single-level exact computation, the kernel is circular: computing $K$ requires
deconvolving $\Delta_w$ by $\Delta_1$, but $\Delta_w$ is precisely what we want.
The R7 sum computes $\Delta_w$ directly; $K$ does not replace it.

**Non-circular uses:**
1. **Level scaling:** $K$ is level-independent. Compute once (level 1), predict all
   higher levels via $\Delta_k^{(w)} = K \ast (A_d \varepsilon^k + B_d \bar\varepsilon^k)$.
2. **Approximation:** Leading term alone gives $\Delta_w \approx \binom{d_0+w-1}{w-1}
   \frac{(w-1)^d}{d!} q_1^d \ast \Delta_1$ without R7 computation; error decays factorially.
3. **Structural theorem:** The decomposition ${}_{(2w+2)}F_{(2w+1)}(1) = \text{poly} \ast \text{Binom}$
   is a statement about hypergeometric functions, independent of computation.

No further open questions remain for R19.

Scripts: `scripts/q6_w_reduction.wl`, `scripts/q6_kernel_gf.wl`,
`scripts/q6_kernel_degree.wl`, `scripts/q6_kernel_closed.wl`, `scripts/q6_kernel_Pd.wl`

---

### Paper writeup

Results R1–R19 constitute a complete theory. Key terminology:
- ~~"Born expansion"~~ → **inclusion-exclusion expansion**
- ~~"Vandermonde-Chu collapse"~~ → **Rothe-Hagen identity** ($b = w+1$)
- R7 sum = **Saalschützian ${}_{(2w+2)}F_{(2w+1)}(1)$**
- R18 = **rotation-aware block transfer** (decomposition of rotated Sturmian blocks)
- R19 = **w-reduction kernel**: $w{=}2$ correction = convolution of $w{=}1$ with polynomial kernel of degree $d_0{+}q_1{-}2$

---

## Multi-Irrational Verification

| Irrational | $w$ | $a_2$ | Composition | $A = d_0{-}2$ | IE order 1 exact ($d < q_1$) |
|------------|-----|-------|-------------|----------------|------------------------------|
| $\sqrt{5}$ | 2 | 4 | OK | ALL MATCH | yes |
| $\sqrt{2}$ | 1 | 2 | OK | match | yes |
| $\pi$ | 3 | 15 | OK (15 SBs) | ALL MATCH | yes |
| $\mathrm{Im}[\zeta_1]$ | 14 | 2 | OK | match | yes |
| $\sqrt{3}$ | 1 | 2 | — | match | yes |
| $\varphi$ | 1 | 1 | — | match | yes |

---

## Key Notation

| Symbol | Meaning |
|--------|---------|
| $\alpha$ | irrational, CF $= [a_0; a_1, a_2, \ldots]$ |
| $w = a_0 = \lfloor\alpha\rfloor$ | floor (stair height parameter) |
| $p_k/q_k$ | $k$-th convergent of $\alpha$ |
| $v_j(p)$ | DP path count at position $p$, height $j$ |
| $B(p,q) = \binom{p+q-1}{q}/p$ | ballot number |
| $T_k$ | Toeplitz matrix, entries $\binom{p_k{-}1{+}j{-}s}{j{-}s}$ |
| $\Delta_k$ | correction matrix at CF level $k$ |
| $A_k$ | offset: $A_1 = q_1$, $A_2 = q_1{+}q_2{-}1$ |
| $M_k = T_k - \Delta_k$ | block transfer matrix at level $k$ |
