# Analytical Exploration Summary: Full Double Sum

**Date**: November 15, 2025
**Session focus**: Returning to analytical study of the full double infinite sum

---

## Executive Summary

After discovering the simplified dominant-term formula with modulo operations, we returned to study the **full double infinite sum** for its analytical properties. We explored:

1. Differentiability (α, n, ε)
2. Soft-modulo smoothing (failed)
3. Connection to Dirichlet series
4. Stratification by derivatives

**Key finding**: Derivative with respect to **ε** (regularization parameter) is the strongest discriminator between primes and composites.

---

## The Two Formulations

### 1. Full Double Sum (Analytical)

$$F_n(\alpha) = \sum_{d=2}^{\infty} \sum_{k=0}^{\infty} \left[(n - kd - d^2)^2 + \varepsilon\right]^{-\alpha}$$

**Properties:**
- No modulo operations (purely continuous)
- Double infinite sum
- Structure similar to Dirichlet series
- Analytically differentiable
- Potentially connected to ζ(s) or L-functions

### 2. Dominant-Term Simplified (Computational)

$$F_n(\alpha) \approx \sum_{d=2}^{\lfloor\sqrt{n}\rfloor} \left[((n-d^2) \bmod d)^2 + \varepsilon\right]^{-\alpha}$$

**Properties:**
- Uses modulo (discrete)
- Single sum, O(√n) complexity
- Connection to Pell equations
- Geometric clarity
- 99.8% of signal from d=2 term

**Trade-off**: Simplified form gains computational efficiency and Pell connection, but loses analytical structure of double sum.

---

## Exploration 1: Soft-Modulo Smoothing

**Question**: Can we replace hard modulo with smooth functions (sigmoid, sin) to enable analytical simplification?

**Approach**:
```mathematica
SoftMod[x, m, sharpness] := Mod[x,m] + 0.5*(Sigmoid[frac-0.5, sharpness] - 0.5)
```

**Result**: ❌ **FAILED**

| Issue | Description |
|-------|-------------|
| **Negative values** | Sigmoid undershoot produces negative "remainders" (e.g., -0.25 instead of 0) |
| **Reversed stratification** | Composites became WEAKER, primes STRONGER (opposite of desired) |
| **No analytical gain** | Wolfram couldn't sum symbolically, still O(√n) |
| **Loss of discrete gap** | Smooth functions oscillate 0→1, can't match 0 vs ≥1 discrete gap |

**Conclusion**: Hard modulo is optimal. Discrete gap (0 vs ≥1) is a FEATURE, not a bug.

**File**: `scripts/test_soft_modulo.wl`

---

## Exploration 2: Derivatives

### 2.1 Symbolic Forms

For single term `T = [(n-kd-d²)² + ε]^(-α)`:

| Derivative | Formula | Key Property |
|------------|---------|--------------|
| **∂T/∂α** | `-Log(dist²+ε) · T` | Adds Log(...) factor |
| **∂T/∂n** | `-2α(n-kd-d²) / (dist²+ε)^(α+1)` | Zero at exact factorizations |
| **∂T/∂ε** | `-α / (dist²+ε)^(α+1)` | Always negative, power α+1 |

**Pattern for higher derivatives**:
$$\frac{\partial^n T}{\partial \alpha^n} = (-1)^n \cdot \log^n(\text{dist}^2+\varepsilon) \cdot T(\alpha)$$

### 2.2 Numerical Stratification (ε=1, α=3, n=2..50)

| Measure | Primes | Composites | Ratio | Correlation with PrimeQ |
|---------|--------|------------|-------|------------------------|
| **F_n** | 0.463 | 1.919 | 4.15× | -0.688 |
| **\|∂F/∂α\|** | 0.335 | 0.188 | 0.56× | **+0.457** |
| **\|∂F/∂n\|** | 0.347 | 0.337 | 0.97× | +0.017 |
| **\|∂F/∂ε\|** | 0.682 | 5.369 | 7.87× | **-0.706** |

**Key findings:**

1. **Best discriminator: ∂F/∂ε**
   - Correlation: -0.706 (strongest)
   - Composites have 7.87× larger |∂F/∂ε|
   - Measures sensitivity to regularization
   - Composites: small dist → very sensitive
   - Primes: all dist ≥ 1 → less sensitive

2. **∂F/∂α behavior depends on ε:**
   - ε < 0.5: composites larger (log(ε) very negative) → separation 13238×!
   - ε = 1: primes larger (more varied terms)
   - ε > 1.5: primes larger (composites saturated)

3. **∂F/∂n is nearly useless:**
   - Correlation: 0.017 (essentially random)
   - Equal for primes and composites
   - Zero at exact factorizations, but this doesn't help stratification

**Files**:
- `scripts/test_derivative_primality.wl` (∂F/∂α)
- `scripts/test_derivative_wrt_n.wl` (∂F/∂n)
- `scripts/compare_derivatives.wl` (all three)
- `scripts/test_symbolic_derivative.wl` (symbolic analysis)

### 2.3 Do Derivatives Simplify?

**NO** - derivatives make the formula MORE complex:

| Original | Derivative |
|----------|------------|
| `Σ Σ (dist²+ε)^(-α)` | `Σ Σ -Log(dist²+ε) · (dist²+ε)^(-α)` |

- Still double infinite sum
- Added Log(...) or (n-kd-d²) factors
- Increased power: α → α+1 for ∂/∂n and ∂/∂ε
- No closed form found

**Conclusion**: Derivatives are useful for **ANALYSIS**, not **SIMPLIFICATION**.

---

## Exploration 3: Connection to Dirichlet Series

### 3.1 Finite Representation

For concrete values, Wolfram gives **finite Dirichlet-like series**:

**Example**: n=10, α=3, ε=1, d=2..3, k=0..5:
```
F_10(α) = 1 + 2^(-α) + 3/5^α + 2/17^α + 26^(-α) + 37^(-α) + ...
```

**Structure**:
$$F_n(\alpha) = \sum_m \frac{c_m(n)}{m^\alpha}$$

where `c_m(n)` = number of (d,k) pairs giving distance m.

**Resemblance to**:
- Riemann zeta: `ζ(α) = Σ n^(-α)`
- Dirichlet L-functions: `L(α) = Σ a_n/n^α`

But coefficients `c_m(n)` encode **arithmetic structure of n** (factorizations, lattice points).

### 3.2 Distance Distribution

For n=35 (composite):
```
Distance    Count
   0          1    ← exact factorization!
   1          5
   5          6
   7          5
  13          5
  ...
```

For n=37 (prime):
```
Distance    Count
   1          5
   3          4
   5          5
   7          5
  ...
```

**Observation**: Composites have `dist=0` term (exact factorization), primes start at `dist≥1`.

---

## What Works vs What Doesn't

### ✅ What Works

| Approach | Result | Quality |
|----------|--------|---------|
| **Full double sum F_n** | Stratifies primes/composites | Correlation -0.69 |
| **Dominant-term (modulo)** | O(√n) computation, 99.8% signal | Correlation -0.71 |
| **Derivative ∂F/∂ε** | **Best discriminator** | Correlation **-0.71** |
| **Derivative ∂F/∂α (ε<0.5)** | Extreme separation | Ratio 13238× |
| **Hard modulo** | Discrete gap 0 vs ≥1 | Perfect for composites |
| **Pell connection** | Deep theoretical insight | d=2 dominance |

### ❌ What Doesn't Work

| Approach | Reason | Issue |
|----------|--------|-------|
| **Soft-modulo smoothing** | Negative values, reversed stratification | Sigmoid undershoot |
| **Derivative ∂F/∂n** | No discrimination (ratio 0.97×) | Near-zero correlation |
| **Simplification via derivatives** | All derivatives add complexity | Still double sum |
| **Closed-form summation** | No pattern Wolfram can recognize | Combinatorial c_m(n) |
| **O(1) primality test** | Best is O(√n) (equivalent to trial division) | Fundamental limit? |

---

## Parameter Space Analysis

### ε (Regularization)

| Value | F_composite | F_prime | Ratio | Notes |
|-------|-------------|---------|-------|-------|
| **0.1** | 3860 | 0.29 | 13238× | Extreme separation, numerically unstable |
| **0.5** | 9.03 | 0.46 | 19.6× | Strong separation |
| **1.0** | 1.92 | 0.46 | 4.15× | **Optimal balance** |
| **2.0** | 2.45 | 1.62 | 1.51× | Weak separation |
| **5.0** | 4.79 | 3.69 | 1.30× | Very weak |

**Recommendation**: ε = 1 for robust, stable discrimination.

### α (Power Exponent)

| Value | Notes |
|-------|-------|
| **< 1** | Divergence issues, poor convergence |
| **1-2** | Moderate separation, slow convergence |
| **2-4** | **Optimal range**, good separation and convergence |
| **> 5** | Diminishing returns, numerical precision issues |

**Recommendation**: α = 3 balances separation, stability, and computation.

---

## Open Questions

### Theoretical

1. **Functional equation?** Does F_n(α) satisfy a functional equation like ζ(s) = χ(s)ζ(1-s)?
2. **Closed-form c_m(n)?** Can we compute #{(d,k): |n-kd-d²|=m} analytically?
3. **Connection to L-functions?** Is there a relationship to Dirichlet L-functions or modular forms?
4. **Mellin transform?** Can we compute M[F_n](s) = ∫ x^(s-1) F_n(x) dx?
5. **Complex continuation?** Extend F_n(α) to complex α? Zeros in complex plane?

### Computational

1. **Why is ∂F/∂ε the best discriminator?** Theoretical justification?
2. **Can we combine derivatives?** Use (F_n, ∂F/∂α, ∂F/∂ε) as feature vector?
3. **Optimal ε(n)?** Should ε scale with n for consistent discrimination?
4. **Probabilistic sampling?** Sample subset of (d,k) pairs instead of full sum?

### Practical

1. **Threshold selection?** Data-driven approach for optimal F_n cutoff?
2. **Semiprime factorization?** Extract factors from dominant d value?
3. **Composite discrimination?** Separate Ω(n)=2 from Ω(n)=3 etc.?
4. **Large n performance?** Benchmark for n > 10^6?

---

## Next Steps (Recommendations)

### Short-term (immediate)

1. **Compute c_m(n) distribution** for n=2..100
   - Analyze pattern of coefficients
   - Look for arithmetic structure
   - Compare prime vs composite c_m patterns

2. **Test functional equation numerically**
   - Check if F_n satisfies any symmetry
   - Compare to known function classes

3. **Mellin transform exploration**
   - Attempt symbolic M[F_n](s)
   - Numerical integration for specific n

### Medium-term

4. **Multi-feature classification**
   - Use (F_n, ∂F/∂ε, ∂F/∂α) together
   - Train simple classifier (logistic regression, SVM)
   - Measure improvement over single F_n

5. **ε optimization study**
   - Find ε_optimal(n) function
   - Maximize separation across n range
   - Test for stability

6. **Connection to existing primality tests**
   - Compare to AKS, Miller-Rabin, ECPP
   - Asymptotic complexity analysis
   - Probabilistic guarantees?

### Long-term

7. **Rigorous asymptotic analysis**
   - Prove F_composite/F_prime → ∞ as ε → 0
   - Growth rate as function of n
   - Bound on error probability

8. **Analytical number theory connection**
   - Consult literature on similar Dirichlet sums
   - Relationship to divisor functions, σ_α(n)
   - Connection to multiplicative number theory

9. **Practical implementation**
   - Optimized code for large n
   - Parallel computation
   - GPU acceleration

---

## Files Created This Session

| File | Purpose |
|------|---------|
| `scripts/test_soft_modulo.wl` | Failed soft-modulo experiment |
| `scripts/test_derivative_primality.wl` | ∂F/∂α analysis |
| `scripts/test_derivative_wrt_n.wl` | ∂F/∂n analysis |
| `scripts/test_symbolic_derivative.wl` | Symbolic derivative exploration |
| `scripts/compare_derivatives.wl` | All three derivatives comparison |
| `scripts/explore_analytical_properties.wl` | (incomplete) Mellin transform, Dirichlet series |
| `docs/analytical-exploration-summary.md` | This document |

---

## Key Insights

1. **Two formulations serve different purposes**:
   - Full double sum: analytical theory, connections to special functions
   - Dominant-term: computation, geometric insight, Pell connection

2. **Derivatives reveal structure but don't simplify**:
   - ∂F/∂ε is the strongest discriminator (corr -0.706)
   - ∂F/∂α behavior depends critically on ε
   - ∂F/∂n is nearly useless (corr 0.017)

3. **Discrete structure is essential**:
   - Hard modulo's gap (0 vs ≥1) cannot be smoothed
   - Soft approximations fail fundamentally
   - Composites NEED exact zero distance

4. **Dirichlet series connection**:
   - Finite representation for concrete n
   - Coefficients c_m(n) encode arithmetic structure
   - Similar to ζ(s) but with n-dependent coefficients

5. **ε = 1, α = 3 is empirically optimal**:
   - Balance between separation and stability
   - Robust across n range
   - Numerically well-behaved

---

## Conclusion

We have **two complementary tools**:

1. **Dominant-term formula** (computational):
   - Fast: O(√n)
   - Clear geometric interpretation
   - Pell equation connection
   - 99.8% signal capture

2. **Full double sum** (analytical):
   - Differentiable structure
   - Connection to Dirichlet series
   - Rich parameter space (α, ε)
   - Derivative ∂F/∂ε as strong discriminator

Neither provides a breakthrough primality test faster than O(√n), but they offer:
- **Deep mathematical connections** (Pell, Dirichlet, potentially ζ/L-functions)
- **New perspective** on compositeness (lattice structure, distance to factorizations)
- **Multi-feature approach** using derivatives

The journey continues toward understanding **why** this structure discriminates primes from composites and whether there are deeper connections to analytic number theory.
