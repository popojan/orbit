# Egyptian Fractions: Telescoping Revisited

**Date:** 2026-04-01
**Status:** ✅ PROVEN (all identities algebraic)
**Origin:** Offshoot from [prime interference moire session](../2026-02-19-prime-interference-moire/algebraic-exploitation.md), inspired by the structural similarity between $1/((ij)^s(i+j)^w)$ and the Egyptian fraction term $1/((u+vk)(u+v(k-1)))$.

---

## Context

The Orbit paclet's `EgyptianFractions[q, Method -> "Raw"]` returns a unique
canonical decomposition of a rational $q$ into **raw tuples** $\{u, v, i, j\}$,
each representing a truncated telescoping sum:

$$\sum_{k=i}^{j} \frac{1}{(u+vk)(u+v(k-1))} = \frac{j-i+1}{(u+v(i-1))(u+vj)}$$

The number of raw tuples equals the number of paired convergent differences
and corresponds to the continued fraction structure of $q$.

---

## Result 1: Infinite Sum Depends Only on the Product

The infinite extension of each telescoping family is:

$$\sum_{k=1}^{\infty} \frac{1}{(u+vk)(u+v(k-1))} = \frac{1}{uv}$$

**This depends only on the product $n = uv$, not on how $n$ is factored into $(u, v)$.**

Different factorizations of the same $n$ give different series of unit fractions
(different terms, different convergence rates) but the same limit $1/n$.

### Proof

Partial fractions give a telescoping sum:

$$\frac{1}{(u+vk)(u+v(k-1))} = \frac{1}{v}\left[\frac{1}{u+v(k-1)} - \frac{1}{u+vk}\right]$$

Summing from $k = 1$ to $m$:

$$S_m = \frac{1}{v}\left[\frac{1}{u} - \frac{1}{u+vm}\right] = \frac{m}{u(u+vm)}$$

Taking $m \to \infty$:

$$S_\infty = \lim_{m \to \infty} \frac{m}{u(u+vm)} = \frac{1}{uv} \qquad \square$$

### Example: Four paths to $1/6$

| $\{u, v\}$ | First terms | $S_{10}$ | Limit |
|:-----------:|:------------|:--------:|:-----:|
| $\{1, 6\}$ | $\frac{1}{7}, \frac{1}{91}, \frac{1}{247}, \ldots$ | 0.1639 | $1/6$ |
| $\{2, 3\}$ | $\frac{1}{10}, \frac{1}{40}, \frac{1}{88}, \ldots$ | 0.1563 | $1/6$ |
| $\{3, 2\}$ | $\frac{1}{15}, \frac{1}{35}, \frac{1}{63}, \ldots$ | 0.1449 | $1/6$ |
| $\{6, 1\}$ | $\frac{1}{42}, \frac{1}{56}, \frac{1}{72}, \ldots$ | 0.1042 | $1/6$ |

---

## Result 2: Split into Two Unit Fractions

Every raw tuple $\{u, v, i, j\}$ decomposes as a **difference of two
unit fractions**:

$$\frac{j-i+1}{(u+v(i-1))(u+vj)} = \frac{1}{v \cdot \text{start}} - \frac{1}{v \cdot \text{end}}$$

where $\text{start} = u + v(i-1)$ and $\text{end} = u + vj$.

Equivalently, the **infinite sum** and the **tail** are both unit fractions:

$$\underbrace{\frac{1}{v \cdot \text{start}}}_{\text{infinite sum from } i} = \underbrace{\frac{j-i+1}{(\text{start})(\text{end})}}_{\text{truncated sum}} + \underbrace{\frac{1}{v \cdot \text{end}}}_{\text{tail from } j+1}$$

### Consequence for rational decomposition

Every rational $q$ decomposes as:

$$q = \sum_{k} \left[\frac{1}{v_k \cdot \text{start}_k} - \frac{1}{v_k \cdot \text{end}_k}\right]$$

where every term inside the brackets is a unit fraction. This is a
**signed unit fraction decomposition**, canonical and unique (from the CF).

---

## Result 3: Connection to CF Convergent Differences

For a rational $q$ with convergents $c_0, c_1, c_2, \ldots$ and
differences $d_n = c_n - c_{n-1}$ (alternating in sign):

**For paired differences** ($d_{2k-1} > 0$ and $d_{2k} < 0$):

$$d_{2k-1} = \frac{1}{u_k v_k} \qquad \text{(infinite sum of family } k\text{)}$$

$$|d_{2k}| = \text{tail}_k = \frac{1}{v_k \cdot \text{end}_k}$$

$$d_{2k-1} + d_{2k} = \text{truncated sum}_k = \text{raw fraction value}$$

**For an unpaired final difference** (when the CF has odd length past the
leading 0): the last odd difference equals the truncated sum directly
(single-term or short sum), not the infinite sum $1/(u_k v_k)$.

### Status

✅ Verified on $q = 2/3, 5/8, 7/11, 3/7, 11/17, 13/21$ (all paired).
Partial match on $q = 8/13$ (unpaired final difference — last tuple matches
as truncated sum, not as $1/(uv)$).

---

## Result 4: Equivalence of Splits Across Factorizations

For any factorization $n = uv$, the "split" of the telescoping sum
into (infinite sum, tail) at $m$ terms is:

$$\text{split}[\{u, v\}, m] = \left\{\frac{1}{uv},\; \frac{1}{v(u+vm)}\right\}$$

Two factorizations of the same $n$ give the same split when:

$$\text{split}[\{n, 1\}, m_1] = \text{split}[\{u, v\}, m_2] \quad \iff \quad m_2 = \frac{m_1}{v^2}$$

### Proof

Equating tails: $\frac{1}{n + m_1} = \frac{1}{v(u + vm_2)}$, hence
$uv + m_1 = vu + v^2 m_2$, giving $m_1 = v^2 m_2$. $\square$

### Interpretation

- Family $\{u, v\}$ with step $v$ converges $v^2$ times faster than
  family $\{n, 1\}$ with step 1.
- One term of $\{7, 11\}$ covers the same ground as $121$ terms of $\{77, 1\}$.
- **Constraint:** $m_2 = m_1/v^2$ must be a positive integer, so only
  $m_1 \in \{v^2, 2v^2, 3v^2, \ldots\}$ have integer counterparts.
- Each factorization $n = uv$ defines a **lattice** of compatible splits
  with spacing $v^2$.

---

## Summary

| Result | Statement | Depends on factorization? |
|:-------|:----------|:-------------------------:|
| Infinite sum | $\sum_{k=1}^{\infty} = 1/(uv)$ | **No** — product only |
| Tail at $m$ terms | $1/(v(u+vm))$ | **Yes** — individual $u, v$ |
| Convergence rate | Error $\sim u/(v^2 m)$ | **Yes** — faster for large $v$ |
| Split equivalence | $m_2 = m_1/v^2$ | Relates different factorizations |
| Odd CF diffs | $d_{2k-1} = 1/(u_k v_k)$ | **No** — product only |

The telescoping structure creates a clean separation:
- The **limit** (multiplicative information) forgets the factorization.
- The **path** (which unit fractions, how fast) remembers it.

This mirrors the additive–multiplicative duality from the prime interference
analysis: the product $uv$ is the "radial" (multiplicative) coordinate,
while the specific $(u, v)$ factorization is the "angular" (structural) one.

---

## Result 5: Universal Parameter $M = v^2 m$

The tail depends only on $n = uv$ and a **factorization-independent** parameter $M$:

$$\text{tail}[\{u,v\}, m] = \frac{1}{v(u+vm)} = \frac{1}{n + v^2 m} = \frac{1}{n + M}$$

where $M = v^2 m$. Two factorizations $\{u_1, v_1\}$ and $\{u_2, v_2\}$ of the
same $n$ give the **same split** when:

$$m_1 v_1^2 = m_2 v_2^2 = M$$

The "speed" of convergence is $v^2$: family $\{u, v\}$ needs $v^2$ times fewer
terms than $\{n, 1\}$ to reach the same tail.

### Example: $n = 12$, all factorizations at $M = 144$

| $\{u, v\}$ | speed $v^2$ | $m = M/v^2$ | tail |
|:-----------:|:-----------:|:-----------:|:----:|
| $\{1, 12\}$ | 144 | 1 | $1/156$ |
| $\{2, 6\}$ | 36 | 4 | $1/156$ |
| $\{3, 4\}$ | 16 | 9 | $1/156$ |
| $\{4, 3\}$ | 9 | 16 | $1/156$ |
| $\{6, 2\}$ | 4 | 36 | $1/156$ |
| $\{12, 1\}$ | 1 | 144 | $1/156$ |

The $(u,v) \leftrightarrow (v,u)$ swap: $m' = m \cdot (u/v)^2$. The ratio of
term counts is always a perfect square ratio.

---

## Result 6: Extension to Irrationals

For a rational $q$, the CF is finite → finitely many raw tuples. For an
**irrational** $\alpha$ with infinite CF $[a_0;\, a_1, a_2, \ldots]$, the
construction extends to an **infinite sequence** of raw tuples:

$$\alpha = a_0 + \sum_{k=1}^{\infty} \left[\frac{1}{u_k v_k} - \text{tail}_k\right]$$

### Key property: stabilization

Each tuple $k$ is determined by convergents $c_{2k-1}$ and $c_{2k}$. Adding
later convergents **does not change** earlier tuples. The infinite
representation is well-defined as a limit.

✅ Verified: raw tuples for convergents of $\sqrt{2}$ stabilize — each new
even convergent adds exactly one new tuple without modifying previous ones.

### $\sqrt{2} = [1;\, 2, 2, 2, \ldots]$

Parameters $(u_k, v_k)$ are **consecutive Pell denominators**:

| $k$ | $u_k$ | $v_k$ | $u_k v_k$ | $j$ | paired sum |
|:---:|:------:|:------:|:---------:|:---:|:----------:|
| 1 | 1 | 2 | 2 | 2 | $2/5$ |
| 2 | 5 | 12 | 60 | 2 | $2/145$ |
| 3 | 29 | 70 | 2030 | 2 | $2/4901$ |
| 4 | 169 | 408 | 68952 | 2 | $2/166465$ |

All tuples have $j = 2$ (from the constant partial quotient 2). Products
$u_k v_k$ grow as $\sim (1+\sqrt{2})^{4k}$ (exponential in $k$).

$$\sqrt{2} = 1 + \frac{2}{5} + \frac{2}{145} + \frac{2}{4901} + \frac{2}{166465} + \cdots$$

### $\varphi = [1;\, 1, 1, 1, \ldots]$ (golden ratio)

Parameters $(u_k, v_k)$ are **consecutive Fibonacci pairs**:

| $k$ | $u_k$ | $v_k$ | $u_k v_k$ | paired sum |
|:---:|:------:|:------:|:---------:|:----------:|
| 1 | 1 | 1 | 1 | $1/2$ |
| 2 | 2 | 3 | 6 | $1/10$ |
| 3 | 5 | 8 | 40 | $1/65$ |
| 4 | 13 | 21 | 273 | $1/442$ |

Products: $F_{2k-1} \times F_{2k}$. Paired sums: $1/(F_{2k-1} \cdot F_{2k+1})$
(connected to **Cassini's identity** $F_{n-1}F_{n+1} - F_n^2 = (-1)^n$).

$$\varphi = 1 + \frac{1}{2} + \frac{1}{10} + \frac{1}{65} + \frac{1}{442} + \frac{1}{3026} + \cdots$$

### Structure by CF type

| CF type | Example | $(u_k, v_k)$ pattern | Product growth |
|:--------|:--------|:---------------------|:---------------|
| Periodic, all $a_i = c$ | $\sqrt{2}$ ($c=2$) | Consecutive generalized Pell pairs | Exponential $\sim \lambda^{4k}$ |
| Periodic, all $a_i = 1$ | $\varphi$ | Fibonacci pairs $F_{2k-1}, F_{2k}$ | Exponential $\sim \varphi^{4k}$ |
| General periodic | Quadratic irrationals | Periodic pattern in $(u,v)$ | Exponential |
| Non-periodic | $\pi, e$ | Irregular | Depends on partial quotients |

### What this gives

Every real number has a canonical representation as:

$$\alpha = a_0 + \sum_{k=1}^{N} \left[\frac{1}{u_k v_k} - \frac{1}{v_k \cdot \text{end}_k}\right]$$

where $N$ is finite for rationals, infinite for irrationals. Each term is a
**difference of two unit fractions**, with parameters determined by the CF.

The representation separates:
- **Multiplicative data:** products $u_k v_k$ (= reciprocals of odd convergent
  differences, independent of factorization)
- **Structural data:** individual $u_k, v_k$ and truncation points $j_k$
  (determined by CF partial quotients)

---

## Result 7: Every Number Is a Difference of Two Infinities

### The global split

For any real $\alpha$ with raw tuples $\{u_k, v_k, i_k, j_k\}_{k=1}^{N}$
(finite $N$ for rationals, $N = \infty$ for irrationals):

$$\alpha = a_0 + \underbrace{\sum_{k=1}^{N} \frac{1}{u_k v_k}}_{\Sigma_{\infty}(\alpha)} - \underbrace{\sum_{k=1}^{N} \frac{1}{v_k \cdot \text{end}_k}}_{\Sigma_{\text{tail}}(\alpha)}$$

Each $1/(u_k v_k)$ is an **infinite** telescoping sum. Each tail is an
**infinite** telescoping remainder. Both are unit fractions.

So: **every real number is a difference of two sums of unit fractions, where
each unit fraction is itself an infinite process.**

### Verified examples

| $\alpha$ | $\Sigma_\infty$ (fulls) | $\Sigma_{\text{tail}}$ (tails) | Check |
|:--------:|:-----------------------:|:------------------------------:|:-----:|
| $2/3$ | $1$ | $1/3$ | $1 - 1/3 = 2/3$ ✓ |
| $5/8$ | $7/6$ | $13/24$ | $7/6 - 13/24 = 5/8$ ✓ |
| $7/11$ | $7/6$ | $35/66$ | $7/6 - 35/66 = 7/11$ ✓ |
| $13/21$ | $143/120$ | $481/840$ | ✓ |
| $\sqrt{2}-1$ | $0.51717\ldots$ | $0.10296\ldots$ | $= 0.41421\ldots$ ✓ |
| $\varphi - 1$ | $1.19596\ldots$ | $0.57792\ldots$ | $= 0.61803\ldots$ ✓ |

### The reduction: total variation identity (added 2026-06-11)

$\Sigma_\infty$ is the sum of the odd-indexed convergent differences and
$\Sigma_{\text{tail}}$ the sum of the absolute even-indexed ones (Result 3).
Summing and differencing the two parity classes:

$$\Sigma_\infty + \Sigma_{\text{tail}} = \sum_{n} |c_n - c_{n-1}|
= \sum_{n} \frac{1}{q_{n-1} q_n} =: \mathrm{TV}(\alpha), \qquad
\Sigma_\infty - \Sigma_{\text{tail}} = \alpha - a_0$$

$$\boxed{\;\Sigma_\infty = \frac{\mathrm{TV}(\alpha) + (\alpha - a_0)}{2},
\qquad
\Sigma_{\text{tail}} = \frac{\mathrm{TV}(\alpha) - (\alpha - a_0)}{2}\;}$$

Here $\mathrm{TV}(\alpha)$ — the **total variation of the convergent
sequence** — is taken in the even-length CF convention, which the algorithm
enforces via its odd-case tuple $(q_{n-1},\, q_n - q_{n-1},\, 1)$, i.e., the
$[\ldots, a_n - 1, 1]$ canonicalization (see
`docs/papers/egyptian-fractions-telescoping.tex`, CF–Egypt Bijection).

✅ Verified exactly against `EgyptianFractions[·, Method -> "Raw"]` for
$q = 2/3, 5/8, 7/11, 13/21, 8/13, 1/6, 4/17, 16/113$, and to ~28 digits for
$\varphi - 1$ and $\sqrt{2} - 1$ (`verify-tv-identity.wl`).

**Consequence:** the pair $(\Sigma_\infty, \Sigma_{\text{tail}})$ carries
exactly one scalar of information beyond $\alpha$ itself — $\mathrm{TV}(\alpha)$.
The "difference of two infinities" is precisely the parity split of the
convergent differences.

### Key property: CF prefix determines the fulls

$5/8$ and $7/11$ share the CF prefix $[0; 1, 1, 1, \ldots]$ and therefore
have the **same** $\Sigma_\infty = 7/6$. They differ only in their tails.
Numbers with the same CF prefix live in the same "infinite neighborhood."

### The two constants (corrected 2026-06-11: affine images of known constants)

For $\sqrt{2}$: $\;\Sigma_\infty = \sum_{k=1}^{\infty} \frac{1}{P_{2k-1} P_{2k}}$
where $P_n$ are Pell denominators $(1, 2, 5, 12, 29, 70, \ldots)$.
Converges to $\approx 0.51717\ldots$

For $\varphi$: $\;\Sigma_\infty = \sum_{k=1}^{\infty} \frac{1}{F_{2k-1} F_{2k}}$
where $F_n$ are Fibonacci numbers. Converges to $\approx 1.19596\ldots$

**Neither is new** (original claims "not a recognized constant" / "possibly a
new constant" retracted). By the TV identity above, both are affine images of
the reciprocal-products-of-consecutive-denominators constants:

$$\Sigma_\infty(\varphi) = \frac{H_F + 1/\varphi}{2}, \qquad
H_F = \sum_{n=1}^{\infty} \frac{1}{F_n F_{n+1}} = 1.7738775832851323\ldots
= \text{OEIS A290565}$$

(digit match verified 2026-06-11; A290565 "sum of reciprocal golden rectangle
numbers" lists only integral/Lambert-type formulas — no elementary closed form
is known).

$$\Sigma_\infty(\sqrt{2}) = \frac{H_P + (\sqrt{2}-1)}{2}, \qquad
H_P = \sum_{n=1}^{\infty} \frac{1}{P_n P_{n+1}} = 0.6201348780682487\ldots$$

$H_P$ is **not in OEIS** (decimal search 2026-06-11) — submission candidate.
Both identities verified to ~28 digits in `verify-tv-identity.wl`.

### The three levels of infinity

| Level | Rationals | Irrationals |
|:------|:----------|:------------|
| **Within each tuple:** terms $1/((u+vk)(u+v(k-1)))$ | infinite (but summed to unit fraction) | same |
| **Number of tuples** $N$ | finite | **infinite** |
| **Each tail** from $j_k + 1$ to $\infty$ | infinite (but = unit fraction) | same |

Rationals: finitely many pairs of infinities.
Irrationals: infinitely many pairs of infinities.

---

## Result 8: Interval Normal Form and Bit Optimality

### Interval form

Every raw tuple $\{u, v, 1, j\}$ is equivalent to a sum of $jv^2$
consecutive terms $1/(n(n+1))$ starting at $n = uv$:

$$\sum_{m=1}^{j} \frac{1}{(u+vm)(u+v(m-1))} = \sum_{n=uv}^{uv+jv^2-1} \frac{1}{n(n+1)}$$

So every rational reduces to a union of intervals $[\text{start}, \text{end}]$
of consecutive $1/(n(n+1))$ terms. The tuple $(u, v, j)$ is a **factored
encoding** of the interval $[uv,\; uv + jv^2]$.

### The CF factorization is bit-optimal

Tested: for every raw tuple produced by the algorithm, **no alternative
factorization** of $n = uv$ gives a shorter bit encoding of $(u', v', j')$.

✅ Verified across 16 test fractions (41 tuples total): 0 bits saved in
every case. The CF naturally produces balanced $(u, v)$ pairs
(with $v/u$ converging to a quadratic unit like $\varphi$ or $1+\sqrt{2}$),
which minimizes $\max(\log u, \log v)$.

Any refactorization either enlarges a factor (more bits for $u'$ or $v'$)
or inflates $j' = jv^2/{v'}^2$ (more bits for $j'$). The trade-off never
improves.

---

## Result 9: Binary Vector Representation

Every real $\alpha \in (0, 1)$ has a canonical representation as a binary
vector $(a_1, a_2, a_3, \ldots)$ with $a_n \in \{0, 1\}$:

$$\alpha = \sum_{n=1}^{\infty} \frac{a_n}{n(n+1)}$$

where $a_n = 1$ iff $n$ belongs to the union of expanded intervals
$[u_\ell v_\ell,\; u_\ell v_\ell + j_\ell v_\ell^2 - 1]$ from the CF
decomposition.

### Disjointness proof

The expanded intervals are **always disjoint**. The gap between
interval $\ell$ and interval $\ell + 1$ is:

$$\text{gap} = u_{\ell+1}(v_{\ell+1} - v_\ell) = a_{2\ell+1} \cdot u_{\ell+1}^2 \;\geq\; 1$$

**Proof:** The end of the $\ell$-th interval is $n_{\text{end}} = v_\ell \cdot u_{\ell+1} - 1$
(since $u_{\ell+1} = u_\ell + j_\ell v_\ell$ from the CF recurrence). The start
of the $(\ell+1)$-th interval is $u_{\ell+1} v_{\ell+1}$. The gap:

$$u_{\ell+1} v_{\ell+1} - v_\ell u_{\ell+1} = u_{\ell+1}(v_{\ell+1} - v_\ell) = a_{2\ell+1} \cdot u_{\ell+1}^2$$

using $v_{\ell+1} = a_{2\ell+1} u_{\ell+1} + v_\ell$ (CF denominator recurrence). $\square$

### Structure of the binary vector

The vector consists of **blocks of 1s** separated by **gaps of 0s**:

- Block $\ell$: length $j_\ell v_\ell^2$ (from the expanded tuple)
- Gap after block $\ell$: length $a_{2\ell+1} \cdot u_{\ell+1}^2$

The CF partial quotients directly encode the structure:
- Even partial quotients $a_{2\ell}$: determine block lengths (via $j_\ell$)
- Odd partial quotients $a_{2\ell+1}$: determine gap widths

This is a **non-positional binary expansion**: like binary digits but in
the basis $\{1/(n(n+1))\}$ instead of $\{1/2^n\}$. The full vector (all 1s)
sums to $\sum_{n=1}^{\infty} 1/(n(n+1)) = 1$.

---

## Result 10: Fibonacci Product Difference Identity

$$\boxed{F_{2k+1}\,F_{2k+2} - F_{2k-1}\,F_{2k} = F_{4k+1}}$$

| $k$ | $F_{2k+1} \cdot F_{2k+2}$ | $F_{2k-1} \cdot F_{2k}$ | Difference | $F_{4k+1}$ |
|:---:|:-:|:-:|:-:|:-:|
| 1 | $2 \cdot 3 = 6$ | $1 \cdot 1 = 1$ | 5 | $F_5 = 5$ |
| 2 | $5 \cdot 8 = 40$ | $2 \cdot 3 = 6$ | 34 | $F_9 = 34$ |
| 3 | $13 \cdot 21 = 273$ | $5 \cdot 8 = 40$ | 233 | $F_{13} = 233$ |
| 4 | $34 \cdot 55 = 1870$ | $13 \cdot 21 = 273$ | 1597 | $F_{17} = 1597$ |
| 5 | $89 \cdot 144 = 12816$ | $34 \cdot 55 = 1870$ | 10946 | $F_{21} = 10946$ |

The indices $5, 9, 13, 17, 21, 25, 29, \ldots$ form an arithmetic progression
with step 4. Verified for $k = 1, \ldots, 7$.

**Status:** ✅ PROVEN (upgraded 2026-06-11). Two lines: the telescoping
identity $F_i F_{i+1} - F_{i-1} F_i = F_i^2$ gives
$F_{2k+1} F_{2k+2} - F_{2k-1} F_{2k} = F_{2k}^2 + F_{2k+1}^2$, and the
classical identity $F_n^2 + F_{n+1}^2 = F_{2n+1}$ (at $n = 2k$) yields
$F_{4k+1}$. The identity is the sum-of-two-consecutive-squares identity in
disguise — classical (Vajda/Koshy family), no literature novelty.

This identity governs the **differences** of consecutive terms in the
$\varphi$-split series: $a_k - a_{k+1} = F_{4k+1} / (F_{2k-1} F_{2k} F_{2k+1} F_{2k+2})$.

---

## Open Questions

**Reviewed 2026-06-11** through the Socratic gate-keeping / channel-match
lenses (CLAUDE.md protocol). Original Q1, Q2, Q4 closed — see "Considered and
rejected" below; Q3 survives in sharpened form.

1. **The TV map** (sharpened from old Q3). By the TV identity (Result 7), the
   split map $\alpha \mapsto (\Sigma_\infty, \Sigma_{\text{tail}})$ is the
   affine graph of the single function
   $\mathrm{TV}(\alpha) = \sum_n 1/(q_{n-1} q_n)$ — all structural questions
   about the split reduce to this one function.
   Hypotheses (pre-registered before testing; **settled same day**, see
   [2026-06-11-tv-map-c-alpha-kinks](../2026-06-11-tv-map-c-alpha-kinks/README.md)):
   - continuous at every irrational — ✅ PROVEN;
   - jump discontinuity at every rational — ✅ PROVEN, exact law: right-continuous,
     left jump $2/((q-q^*)q)$ with sign $(-1)^n$ ($q^* = q_{n-1}$);
   - nowhere monotone — ✅ PROVEN (both jump signs dense);
   - maximized on $(0,1)$ uniquely at $\varphi - 1$ with value $H_F$ = A290565 — ✅ PROVEN
     (continuant monotonicity);
   - overall character: Minkowski-?-like singular function — ❌ CORRECTED:
     TV is a right-continuous **jump function of unbounded variation**
     (? is continuous); ?-like flatness instead shows up in $C(\alpha)$
     from the right.
   Bonus identities: $\Sigma_{\text{tail}} = \sum_{n\geq1}|\alpha - p_n/q_n|$
   (total convergent approximation error), placing TV in the **error-sum
   function family** (Ridley & Petruska, Indag. Math. 11(2):273–282, 2000;
   Baruchel–Elsner arXiv:1602.06445, split denominators with $b_m = 1$).
   Follow-up discovery in the same session: $C(\alpha)$ from the
   Beatty/ballot setting shares the regularity class — right-continuous with
   left jumps $\approx 0.12/q^2$ at rationals (DP-validated), falsifying the
   continuity claim in `ruin-multinacci-bridge.tex`.

### Considered and rejected (2026-06-11)

- **Closed forms for $\Sigma_\infty(\sqrt{2})$ and $\Sigma_\infty(\varphi)$**
  (old Q1, Q2): RESOLVED BY REDUCTION. The TV identity gives
  $\Sigma_\infty(\varphi) = (H_F + 1/\varphi)/2$ with $H_F$ = OEIS A290565
  (studied; no elementary closed form known) and
  $\Sigma_\infty(\sqrt{2}) = (H_P + \sqrt{2} - 1)/2$ with
  $H_P = \sum 1/(P_n P_{n+1})$ not in OEIS. A closed form is exactly as hard
  as for the classical consecutive-Fibonacci-product constant; nothing
  Egypt-specific remains. (Optional follow-up: submit $H_P$ to OEIS.)
- **Connection to $D(s,w)$** (old Q4): channel mismatch. $D(s,w)$ integrates a
  smooth symmetric kernel over the full $(i,j)$ lattice; the telescoping split
  selects CF-determined, best-approximation-sparse $(u_k, v_k)$ that no smooth
  kernel sees. The per-tuple analytic home already exists:
  $\zeta(s, 1 + u/v)$ with its classical Hurwitz integral representation
  (proven in [TAIL-EULER-PRIMORIAL.md](./TAIL-EULER-PRIMORIAL.md)).

---

## Files

- `README.md` — this document (main Egyptian fractions discoveries)
- **[`TAIL-EULER-PRIMORIAL.md`](./TAIL-EULER-PRIMORIAL.md)** — Tail power sums, Hurwitz zeta, primorial structure, splitf, ζ-optimization
- `tail_inversion_formula.wl` — Analytický výpočet partial tail sums přes Zetu
- `verify-trigamma.wl` — Ověření closed form Σ(tail_m)^s = ψ^(s-1)(1+u/v)/v^(2s)
- `verify-tv-identity.wl` — TV identita Σ_∞ = (TV+frac)/2 vs Orbit Raw tuples; non-uniqueness formátu (šest single-tuple reprezentací 1/6); redukce konstant na A290565 / H_P (2026-06-11)
- [`../2026-02-19-prime-interference-moire/algebraic-exploitation.md`](../2026-02-19-prime-interference-moire/algebraic-exploitation.md) — parent session (prime interference)

## New Discovery: Primorial Structure in Tail Euler Sums

During exploration of tail fractions from telescoping sums, discovered unexpected **primorial structure**:

- **Euler-regularized sums** $\Sigma_m \frac{1}{m^s(n+q^2m)}$ (s ≥ 1) generate **highly smooth denominators**
- **Primorial coverage**: ~85% of all prime factors come from {2,3,5,7,11}
- **Structure is invariant**: Coverage remains ~79-85% regardless of regularization parameter s
- **Three hypotheses verified** (m-dependence of prime multiplicities, stability of perturbations, robustness under s-variation)

See [`TAIL-EULER-PRIMORIAL.md`](./TAIL-EULER-PRIMORIAL.md) for complete analysis, experiments, and open questions.

Connection back to Egyptian fractions: Tails encode unit fraction decomposition structure in their prime factorization signatures.

### Inversion Formula for Partial Tail Sums

Further analysis (2026-04-01) reveals that while **individual tail values cannot be inverted** from the closed-form Zeta, **partial tail sums have an analytical formula**:

For any split at index N:
$$T_N(s) = \sum_{m=N+1}^{\infty} (\text{tail}_m)^s = \left(\frac{1}{v^2}\right)^s \left[\zeta(s, 1+u/v) - \sum_{k=1}^{N} \frac{1}{(u/v+k)^s}\right]$$

This combines the closed form (Zeta/PolyGamma) with a finite correction, enabling **analytical computation** of truncation tails without summing to infinity. Verified numerically to machine precision for s=2,3,4.

### Duality: Tail → Polygamma, Truncated → Digamma

The identity $\text{trunc}_m + \text{tail}_m = 1/n$ lifts to a duality on the level of series:

- **Tail power sum**: $\sum \text{tail}_m^s = \zeta(s, 1+u/v)/v^{2s}$ → **polygamma** ($\psi', \psi'', \ldots$)
- **Truncated Dirichlet**: $\sum \text{trunc}_m/m^2 = [\psi(1+u/v) + \gamma]/u^2$ → **digamma** + Euler $\gamma$
- **Connection**: $D_\text{trunc} + D_\text{tail} = \zeta(s)/n$

### ζ as Optimization Criterion for Recursive Splits

$\zeta(2, 1+u/v)$ perfectly ranks factorizations by quality (Spearman=1 on semiprimes ≤ 500). ζ-guided greedy-head recursion gives 8-212× improvement in max denominator over trivial splits for unit fractions.

**Limitations**: ζ degrades along recursion (head denominators lose factorizability). For $p/q$ with $p>1$, CF-based Orbit remains superior. Does not help with Erdős–Straus (#terms reduction requires merging, not splitting).

### Inductive Closed Form Egyptian Fractions (no factorization needed)

Greedy step on $p/N$ gives remainder $r < p$. By induction on $p$:
- $p=1$: trivial (unit fraction)
- $p=2$: always 2 terms: $\frac{2}{2m+1} = \frac{1}{m+1} + \frac{1}{(2m+1)(m+1)}$
- $p=3$: 2–3 terms depending on $N \bmod 6$ (explicit formulas for all cases)
- $p=k$: at most $k$ terms, building on all $r < k$

This is the greedy algorithm viewed inductively, producing **explicit closed-form formulas without factorization**. Trade-off: denominators grow doubly-exponentially vs. CF/Orbit's polynomial growth.

### Best-k: Hybrid faktorizace + greedy indukce

Key new result: instead of greedy's $k = \lceil N/p \rceil$, choose $k$ that **shares a factor with $N$**.
For $N = d \cdot e$, setting $k = \lceil N/(pd) \rceil \cdot d$ gives remainder divisible by $d$, dramatically reducing denominators.

Examples: $4/77 = 1/22 + 1/154$ (2 terms, max=154 vs Orbit's 4 terms, max=4466), $8/49 = 1/7 + 1/49$ (2 terms vs Orbit's 8 terms).

Best-k is the first method combining closed-form explicitness, small denominators, few terms, and guaranteed termination.

**Bicriterion CRT selection** (key theoretical result): for $N = \prod p_i^{a_i}$, assign each prime power to either $\gcd(k, N)$ or $\gcd(p{-}k, N)$ side. CRT solves for $k$. Search space: $2^{\omega(N)} \sim (\log N)^{0.7}$ candidates (Hardy–Ramanujan), independent of $p$. No arbitrary limits.

Prototype: `EgyptianFractions[q, Method -> "BestK"]` in Orbit paclet.

See [`TAIL-EULER-PRIMORIAL.md`](./TAIL-EULER-PRIMORIAL.md) for full analysis.
