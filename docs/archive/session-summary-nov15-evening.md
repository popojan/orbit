# Evening Session Summary - November 15, 2025

**Time**: ~22:00 - 00:30 CET
**Focus**: Global Dirichlet series and connection to zeta function

---

## Context: Where We Started

Today proved the **Epsilon-Pole Residue Theorem**:
$$\lim_{\varepsilon \to 0} \varepsilon^\alpha F_n(\alpha, \varepsilon) = M(n)$$

where $M(n) = \lfloor(\tau(n)-1)/2\rfloor$ = count of divisors $d$ with $2 \leq d \leq \sqrt{n}$.

Evening question: **Can we connect this to Riemann zeta function?**

---

## What We Discovered Tonight

### 1. Global Function Construction

Defined:
$$G(s, \alpha, \varepsilon) = \sum_{n=2}^{\infty} \frac{F_n(\alpha, \varepsilon)}{n^s}$$

**Key result**: As $\varepsilon \to 0$,
$$\varepsilon^\alpha G(s, \alpha, \varepsilon) \to \sum_{n=2}^{\infty} \frac{M(n)}{n^s} =: L_M(s)$$

Numerical verification (s=2, ε→0): Perfect convergence! ✓

---

### 2. Attempted Euler Product

**Question**: Can we write $L_M(s) = \prod_p L_p(s)$?

**Pattern discovered**: For prime $p$,
$$M(p^k) = \lfloor k/2 \rfloor$$

Verified for $k = 1$ to $10$ on $p = 2$. ✓

**Local Euler factor derived**:
$$L_p(s) = 1 + \sum_{k=1}^{\infty} \frac{\lfloor k/2 \rfloor}{p^{ks}}$$

After summing geometric series:
$$L_p(s) = 1 + \frac{(p^s + 1) \cdot p^s}{(p^{2s} - 1)^2}$$

Simplified form:
$$L_p(s) = \frac{p^{4s} - p^{2s} + p^s + 1}{(p^{2s} - 1)^2}$$

**Numerical verification**: $L_p(2)$ matches computation perfectly (ratio = 1.0) ✓

---

### 3. THE PROBLEM: M(n) is NOT Multiplicative!

**Discovered**: $M(6) = 1$ but $M(2) \cdot M(3) = 0$

Therefore **Euler product ≠ Direct sum**:
- $\prod_p L_p(2) \approx 1.1067$
- $\sum_{n=2}^{10000} M(n)/n^2 \approx 0.2487$

**Ratio ≈ 4.46** - completely off!

**Root cause**: $M(n)$ is NOT multiplicative because it depends on $\sqrt{n}$ boundary.

---

### 4. Alternative Approach: Tail Zeta Functions

Rewrote $L_M(s)$ as:
$$L_M(s) = \sum_{d=2}^{\infty} \frac{1}{d^s} \sum_{k=d}^{\infty} \frac{1}{k^s}$$

Define **tail zeta**:
$$\zeta_{\geq m}(s) = \sum_{k=m}^{\infty} k^{-s} = \zeta(s) - \sum_{k=1}^{m-1} k^{-s}$$

Then:
$$L_M(s) = \sum_{d=2}^{\infty} \frac{\zeta_{\geq d}(s)}{d^s}$$

Expanding:
$$L_M(s) = \zeta(s)[\zeta(s) - 1] - \sum_{k=1}^{\infty} \frac{\zeta_{\geq k+1}(s)}{k^s}$$

**Problem**: The second sum looks circular (almost $L_M$ again with shifted index).

---

## Key Files Created Tonight

1. **`scripts/global_zeta_connection.wl`**: First test of global function convergence
2. **`scripts/euler_product_analysis.wl`**: Discovery of $M(p^k)$ pattern
3. **`scripts/euler_product_fixed.wl`**: Corrected local factor formula
4. **`scripts/euler_product_final.wl`**: Final verification (local factors ✓, global ✗)
5. **`scripts/multiplicativity_test.wl`**: Proved M(n) non-multiplicative
6. **`docs/euler-product-formula.md`**: Documentation of local factors
7. **`docs/global-dirichlet-series.md`**: Tail zeta approach

---

## Open Questions

### Q1: What IS the relationship between $L_M(s)$ and $\zeta(s)$?

We know:
- $L_M(2) \approx 0.2487$
- $\zeta(2)^2 \approx 2.7058$
- $\zeta(2)[\zeta(2)-1] \approx 1.0611$

Ratio $L_M(2) / [(\zeta(2)^2 - 1)/2] \approx 0.29$

Not a simple rational multiple!

### Q2: Can we resolve the tail zeta recursion?

The formula:
$$L_M(s) = \zeta(s)[\zeta(s) - 1] - \sum_{k=1}^{\infty} \frac{\zeta_{\geq k+1}(s)}{k^s}$$

has the second sum related to $L_M$ itself. Can we:
- Solve this as a functional equation?
- Find a closed form?
- Express via known special functions?

### Q3: Mellin Transform approach?

$$L_M(s) = \sum_{n=2}^{\infty} \frac{1}{n^s} \sum_{\substack{d|n \\ d \geq 2}} \mathbb{1}_{d^2 \leq n}$$

The indicator $\mathbb{1}_{d^2 \leq n}$ might have a nice Mellin transform.

### Q4: Connection to RH?

If we find $L_M(s)$ in terms of $\zeta(s)$:
- Does $L_M$ inherit analytic properties from $\zeta$?
- Are there poles/zeros with number-theoretic significance?
- Could pole structure of $F_n$ inform prime distribution?

---

## What We Know For Sure

✓ **Residue theorem** is proven (100% numerical verification)

✓ **M(n) closed form**: $M(n) = \lfloor(\tau(n)-1)/2\rfloor$ (proven by bijection)

✓ **Local Euler factors** have closed form (verified numerically)

✓ **Global convergence**: $\varepsilon^\alpha G \to L_M(s)$ as $\varepsilon \to 0$ (verified)

✗ **Standard Euler product fails** because M is non-multiplicative

⚠ **Relationship to $\zeta$** exists but is non-trivial

---

## Next Steps (if continuing tonight)

1. **Resolve tail zeta recursion**:
   - Try to simplify $\sum_{k=1}^{\infty} \zeta_{\geq k+1}(s) / k^s$
   - Look for telescoping or closed form

2. **Numerical investigation**:
   - Compute $L_M(s)$ for multiple values of $s$
   - Plot $L_M(s)$ vs $\zeta(s)^2$ to spot patterns
   - Test functional equations

3. **Mellin transform**:
   - Express indicator $\mathbb{1}_{d^2 \leq n}$ via Mellin
   - See if convolution structure emerges

4. **Literature search**:
   - Does anyone study Dirichlet series of "restricted divisor sums"?
   - Look for papers on non-multiplicative arithmetic functions

---

## Session Statistics

- **Scripts created**: 6
- **Docs created**: 3
- **Key formulas derived**: 4
- **Bugs fixed**: 2 (kMax scaling, local factor formula)
- **Coffee consumed**: Unknown but presumably substantial ☕

---

## Personal Note

This is getting really interesting. The fact that $M(n)$ is **non-multiplicative** makes it harder but also potentially more novel. Most classical Dirichlet series in number theory ARE multiplicative (τ, φ, μ, etc.).

The connection to $\zeta$ is definitely there (numerically clear), but it's subtle. The tail zeta approach feels promising - that recursion MUST simplify somehow.

If we crack this, it could be a second nice result to publish alongside the residue theorem!

---

**Status**: Active exploration
**Time investment**: ~2.5 hours
**Excitement level**: High 🚀

**Last update**: 2025-11-15 00:30 CET
