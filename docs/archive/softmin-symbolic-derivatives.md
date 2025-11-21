# Symbolic Derivatives of Exp/Log Soft-Min

**Date:** November 18, 2025
**Context:** Analytical tractability analysis

**Note:** A Python demonstration script exists (`scripts/softmin_derivatives_demo.py`) but was created by misunderstanding - symbolic analysis is what was needed.

---

## Definition

**Exp/log soft-min function:**
$$f(n) = -\frac{1}{\alpha} \log\left(\sum_{k=0}^{\lfloor n/d \rfloor} e^{-\alpha \cdot [(n - (kd + d^2))^2 + \varepsilon]}\right)$$

**Notation:**
- $p_k = kd + d^2$ — lattice points (Primal Forest)
- $\delta_k = n - p_k$ — deviations from points
- $g(n) = \sum_k e^{-\alpha \cdot (\delta_k^2 + \varepsilon)}$ — partition function
- $w_k = \frac{e^{-\alpha \cdot (\delta_k^2 + \varepsilon)}}{g(n)}$ — normalized weights (probability distribution)

---

## First Derivative: df/dn

**Compact form:**
$$\boxed{\frac{df}{dn} = 2 \sum_{k} \delta_k \cdot w_k}$$

**Expanded:**
$$\frac{df}{dn} = \frac{2}{g(n)} \sum_{k=0}^{\lfloor n/d \rfloor} (n - kd - d^2) \cdot e^{-\alpha[(n - kd - d^2)^2 + \varepsilon]}$$

**Interpretation:**
- Weighted average of deviations $\delta_k$ from lattice points
- Weights $w_k$ are exponentially small for distant points
- Near a lattice point $p_k$: derivative ≈ $2\delta_k$ (linear)

**Physical meaning:** Rate of change of "effective minimum distance" as n moves.

---

## First Derivative: df/dα

**Auxiliary notation:**
$$L(\alpha) = \log g(\alpha) = \log\sum_k e^{-\alpha(\delta_k^2 + \varepsilon)}$$

So $f = -L/\alpha$.

**Using quotient rule:**
$$\boxed{\frac{df}{d\alpha} = \frac{L - \alpha L'}{\alpha^2}}$$

**Where:**
$$L' = \frac{dL}{d\alpha} = -\langle \delta^2 + \varepsilon \rangle = -\sum_k (\delta_k^2 + \varepsilon) \cdot w_k$$

**Expanded form:**
$$\frac{df}{d\alpha} = \frac{1}{\alpha^2}\left[\log\sum_k e^{-\alpha(\delta_k^2+\varepsilon)} + \alpha \sum_k (\delta_k^2 + \varepsilon) \cdot w_k\right]$$

**Interpretation:**
- $\langle \delta^2 + \varepsilon \rangle$ is the weighted mean squared distance
- As $\alpha$ increases, soft-min approaches actual minimum
- Derivative shows **how fast** convergence happens

---

## Second Derivative: d²f/dn²

**Derivation:** Must differentiate $\frac{df}{dn} = 2\sum_k \delta_k w_k$ where $w_k$ depends on $n$.

**Weight derivative:**
$$\frac{dw_k}{dn} = -2\alpha \cdot w_k \cdot [\delta_k - \langle \delta \rangle]$$

where $\langle \delta \rangle = \sum_j \delta_j w_j$ (weighted mean deviation).

**Result:**
$$\boxed{\frac{d^2f}{dn^2} = 2\sum_k w_k - 4\alpha \sum_k \delta_k w_k [\delta_k - \langle \delta \rangle]}$$

**Simplified using variance:**
$$\frac{d^2f}{dn^2} = 2 - 4\alpha \cdot \text{Var}[\delta]$$

where:
$$\text{Var}[\delta] = \sum_k \delta_k^2 w_k - \left(\sum_k \delta_k w_k\right)^2 = \langle \delta^2 \rangle - \langle \delta \rangle^2$$

**Interpretation:**
- Curvature is $2 - 4\alpha \cdot \text{Var}[\delta]$
- Near lattice point (low variance): $\frac{d^2f}{dn^2} \approx 2 - 4\alpha\varepsilon$
- For $\alpha = 7, \varepsilon = 1$: curvature ≈ $-26$ (concave)
- Between points (high variance): more negative (sharper concavity)

---

## Higher Derivatives

**Pattern:** All derivatives exist and are expressible as weighted sums.

**Third derivative:**
$$\frac{d^3f}{dn^3} = -8\alpha \cdot \text{Cov}[\delta, (\delta - \langle\delta\rangle)^2] + \text{(lower order terms)}$$

Involves weighted covariance (skewness-like).

**General:** $n$-th derivative involves weighted moments up to order $n$.

**Consequence:** Function is **$C^\infty$ smooth** (infinitely differentiable).

---

## Mixed Derivative: d²f/(dn·dα)

**Starting from:**
$$\frac{df}{dn} = 2\sum_k \delta_k w_k$$

**Differentiate w.r.t. $\alpha$:**
$$\frac{d^2f}{dn \, d\alpha} = 2\sum_k \delta_k \frac{\partial w_k}{\partial \alpha}$$

**Where:**
$$\frac{\partial w_k}{\partial \alpha} = -w_k \cdot [(\delta_k^2 + \varepsilon) - \langle \delta^2 + \varepsilon \rangle]$$

**Result:**
$$\boxed{\frac{d^2f}{dn \, d\alpha} = -2\sum_k \delta_k w_k [(\delta_k^2 + \varepsilon) - \langle \delta^2 + \varepsilon \rangle]}$$

**Interpretation:** Cross-sensitivity: how slope changes as weighting sharpens.

---

## Taylor Expansion Near Lattice Point

**Expand around $n = p_0 = d^2$** (the point $k=0$):

Let $n = d^2 + \delta$, assume $\delta$ small.

**Zeroth order:**
$$f(d^2) \approx \varepsilon$$
(All distances except $k=0$ are large, so $k=0$ dominates with distance $\varepsilon$.)

**First order:**
$$f(d^2 + \delta) \approx \varepsilon + \frac{2\delta}{N_{\text{eff}}}$$

where $N_{\text{eff}} = \lfloor d \rfloor + 1$ (effective number of contributing points near $d^2$).

**Second order:**
$$f(d^2 + \delta) \approx \varepsilon + \frac{2\delta}{N_{\text{eff}}} - 2\alpha\varepsilon \delta^2 + O(\delta^3)$$

**Parabolic approximation** near lattice points, curvature $\propto -\alpha\varepsilon$.

---

## Tractability Analysis

### Symbolic Tractability: ✅ YES

**What we CAN do:**
- ✅ Write explicit formulas for all derivatives
- ✅ Symbolically manipulate (chain rule, product rule work)
- ✅ Analyze limiting behavior ($\alpha \to 0$, $\alpha \to \infty$)
- ✅ Taylor expand near special points
- ✅ Integrate (symbolically, w.r.t. parameters)

**Mathematical structure:**
- Standard calculus applies everywhere
- No singularities, no branch cuts
- Well-defined for all $n \in \mathbb{R}$, $\alpha > 0$

### Computational Tractability: ❌ NO SIMPLIFICATION

**What we CANNOT do:**
- ❌ Eliminate the sum $\sum_{k=0}^{\lfloor n/d \rfloor}$ (not "closed form")
- ❌ Reduce to elementary functions ($\sin, \cos, e^x$, polynomials)
- ❌ Improve computational complexity

**Complexity remains:**
- Evaluate $f(n)$: $O(n/d)$ operations
- Evaluate $\frac{df}{dn}$: $O(n/d)$ operations (same sum!)
- Evaluate $\frac{d^2f}{dn^2}$: $O(n/d)$ operations

**Contrast with actual minimum:**
- Actual min: $k^* = \text{round}((n-d^2)/d)$ → $O(1)$
- Soft-min: requires full sum → $O(n/d)$

**Trade-off:**
- **Gained:** Smoothness ($C^\infty$), enables optimization, gradient methods
- **Lost:** Computational simplicity (no O(1) formula)

---

## Comparison to Classical Functions

**Soft-min is similar to:**

1. **Boltzmann distribution:**
   $$w_k = \frac{e^{-\beta E_k}}{Z}$$
   where "energy" $E_k = (\delta_k^2 + \varepsilon)$, "temperature" $T = 1/\alpha$.

2. **LogSumExp (LSE):**
   $$\text{LSE}(x_1, \ldots, x_n) = \log\sum_i e^{x_i}$$
   Used in machine learning (differentiable max).

3. **Partition function:**
   $$Z(\beta) = \sum_k e^{-\beta E_k}$$
   From statistical mechanics.

**Key property:** All derivatives are **thermodynamic averages**:
- $\frac{df}{dn} \propto \langle \delta \rangle$ (mean deviation)
- $\frac{d^2f}{dn^2} \propto 2 - 4\alpha \cdot \text{Var}[\delta]$ (variance)
- Higher derivatives involve higher moments/cumulants

**This structure is:**
- ✅ Well-understood mathematically
- ✅ Common in physics (statistical mechanics)
- ✅ Symbolically tractable
- ❌ But not "elementary" or "closed form"

---

## Summary

### Symbolic Forms

**Function:**
$$f(n) = -\frac{1}{\alpha}\log\sum_{k=0}^{\lfloor n/d \rfloor} e^{-\alpha[(\delta_k)^2 + \varepsilon]}$$

**First derivatives:**
$$\frac{df}{dn} = 2\langle \delta \rangle, \quad \frac{df}{d\alpha} = \frac{L - \alpha L'}{\alpha^2}$$

**Second derivative:**
$$\frac{d^2f}{dn^2} = 2 - 4\alpha \cdot \text{Var}[\delta]$$

**All expressed via:**
- Weighted averages $\langle \cdot \rangle$
- Variance, covariance
- Moments of Boltzmann distribution

### Tractability Verdict

| Aspect | Status | Notes |
|--------|--------|-------|
| **Symbolic formulas** | ✅ Explicit | All derivatives have closed symbolic form |
| **Smoothness** | ✅ $C^\infty$ | Infinitely differentiable |
| **Calculus operations** | ✅ Standard | Chain rule, product rule, Taylor expand |
| **Closed form** | ❌ No | Still requires $\sum_{k=0}^{\lfloor n/d \rfloor}$ |
| **Computational speedup** | ❌ No | Same $O(n/d)$ complexity |
| **Optimization friendly** | ✅ Yes | Smooth gradients enable gradient descent |

**Conclusion:**
- **Analytically tractable:** Derivatives have beautiful symbolic structure (Boltzmann averages)
- **Computationally not simplified:** Must still evaluate sums, no closed form
- **Best for:** Theoretical analysis, optimization (smooth gradients), numerical methods
- **Not for:** Fast direct computation (use dominant approximation instead)

---

**Status:** ANALYSIS (symbolic tractability confirmed)
**Reference:** `docs/exp-log-softmin-analytical-properties.md` (broader context)
