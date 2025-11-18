# Analytical Properties of Exp/Log Soft-Min Formulation

**Date:** November 18, 2025
**Context:** Understanding mathematical structure before deciding if this is the right tool

## Definition

**Exp/log soft-min:**
```
soft_min_d(n, α) = -log(Σ_{k=0}^{⌊n/d⌋} exp(-α · dist_k²)) / α
```

where:
```
dist_k² = (n - (k·d + d²))² + ε
```

**Dirichlet-like series:**
```
F_n(s, α) = Σ_{d=2}^{∞} [soft_min_d(n, α)]^(-s)
```

## 1. Limiting Behavior

### α → 0 (No Weighting)

**Log-sum-exp limit:**
```
-log(Σ exp(-α·x_i)) / α → -log(N) / α   as α → 0
```
where N = number of terms.

**For our case:**
```
lim_{α→0} soft_min_d(n, α) = -log(⌊n/d⌋ + 1) / α → ∞
```

**Interpretation:** All distances weighted equally → arithmetic mean of exp(-α·dist²) → exp(-α·mean(dist²))

**Taking α → 0:**
```
soft_min ≈ -log((⌊n/d⌋ + 1) · exp(-α·mean(dist²))) / α
         = -log(⌊n/d⌋ + 1)/α + mean(dist²)
         → ∞ (first term dominates)
```

**Conclusion:** α → 0 is **degenerate** (diverges).

---

### α → ∞ (Maximum Weighting)

**Log-sum-exp limit:**
```
-log(Σ exp(-α·x_i)) / α → min(x_i)   as α → ∞
```

**For our case:**
```
lim_{α→∞} soft_min_d(n, α) = min_{k} dist_k²
```

**Interpretation:** Exponential weights → only smallest distance contributes.

**Exact recovery:**
```
soft_min_d(n, ∞) = min_{k=0,1,...,⌊n/d⌋} [(n - (k·d + d²))² + ε]
```

**Conclusion:** α → ∞ recovers **actual minimum distance**.

---

### α = 7.0 (Current Choice)

**Question:** Why α = 7?

**Heuristic balance:**
- Large enough: emphasizes nearest point
- Small enough: tail contributions don't vanish entirely
- **No rigorous justification documented**

**Sensitivity analysis needed:** How do results change for α ∈ [1, 20]?

---

## 2. Differentiability

### Smoothness in n

**Soft-min as function of n:**
```
f(n) = -log(Σ_k exp(-α·(n - (k·d + d²))²)) / α
```

**Inner function:**
```
g(n) = Σ_k exp(-α·(n - p_k)²)   where p_k = k·d + d²
```

**Derivative:**
```
dg/dn = Σ_k exp(-α·(n - p_k)²) · (-2α(n - p_k))
      = -2α Σ_k (n - p_k) · exp(-α·(n - p_k)²)
```

**Soft-min derivative:**
```
df/dn = -(1/α) · (1/g) · (dg/dn)
      = (2/g) Σ_k (n - p_k) · exp(-α·(n - p_k)²)
```

**Weighted average form:**
```
df/dn = 2 Σ_k (n - p_k) · w_k
where w_k = exp(-α·(n - p_k)²) / Σ_j exp(-α·(n - p_j)²)
```

**Properties:**
- ✅ **Infinitely differentiable** in n (smooth)
- ✅ **Continuous** everywhere
- ✅ **No singularities** (unlike actual min)

**Contrast with actual min:**
- Actual min has **kinks** when n crosses p_k
- Soft-min is **smooth everywhere**

---

### Smoothness in α

**Soft-min as function of α:**
```
f(α) = -log(Σ_k exp(-α·dist_k²)) / α
```

**Define:**
```
L(α) = log(Σ_k exp(-α·dist_k²))
f(α) = -L(α)/α
```

**Derivative:**
```
df/dα = -(α·L' - L) / α²
      = (L - α·L') / α²
```

**Where:**
```
L'(α) = dL/dα = (Σ_k dist_k² · exp(-α·dist_k²)) / (Σ_k exp(-α·dist_k²))
      = ⟨dist²⟩   (weighted average)
```

**Therefore:**
```
df/dα = (L - α·⟨dist²⟩) / α²
```

**Properties:**
- ✅ **Smooth** in α for α > 0
- ✅ **Monotonically increasing** if L < α·⟨dist²⟩ (typically true)
- ❓ **Behavior at α = 0** singular (limit analysis needed)

---

## 3. Convergence of Inner Sum

**Inner sum:**
```
S_d(n, α) = Σ_{k=0}^{⌊n/d⌋} exp(-α·dist_k²)
```

**For k far from optimal:**
```
dist_k² ≈ (k·d)² - 2kd(d² + d² - n) + ...
        ≈ k²d²  for large k
```

**Exponential decay:**
```
exp(-α·k²d²) → 0 very rapidly
```

**Effective cutoff:**
```
k_eff ≈ sqrt(1/(α·d²))
```

For α = 7, d = 10: k_eff ≈ 0.04 → **only k ≈ 0 contributes significantly**

**Numerical consequence:**
- Most terms contribute negligibly
- Sum is **effectively finite** (rapid convergence)
- Truncation at k_max = ⌊n/d⌋ is **safe** (tail negligible)

---

## 4. Convergence of Outer Sum

**Outer sum:**
```
F_n(s, α) = Σ_{d=2}^{∞} [soft_min_d(n, α)]^(-s)
```

**For large d:**
- Only k = 0 contributes: dist_0² = (n - d²)² + ε
- For d > √n: dist_0² ≈ d⁴
- soft_min_d ≈ d⁴

**Tail behavior:**
```
[soft_min_d]^(-s) ≈ d^(-4s)
```

**Convergence:**
```
Σ_{d=√n}^{∞} d^(-4s)
```

Converges for s > 1/4.

**Practical range s ∈ [0.5, 5.0]:**
- s ≥ 0.5 → tail converges as Σ d^(-2)
- Truncation at d = 500 or 10n is **safe**

---

## 5. Relationship to Actual Minimum

**Actual minimum:**
```
m_d(n) = min_{k} [(n - (k·d + d²))²]
```

**Closed formula:**
```
k* = round((n - d²)/d)
m_d(n) = [(n - k*·d - d²)²] + ε
       = [((n - d²) mod d)²] + ε  (approximately)
```

**Soft-min approximation:**
```
soft_min_d(n, α) ≈ m_d(n)  for large α
```

**Error bound:**
```
|soft_min_d - m_d| = O(exp(-α·Δ²))
```
where Δ² = (second smallest distance) - (smallest distance)

**When is approximation good?**
- Large α: excellent (exponential convergence)
- Well-separated minima: excellent (Δ² large)
- Near-degenerate minima: poor (Δ² ≈ 0)

**Near-degeneracy occurs when:**
- n ≈ k·d + d² for multiple k
- Example: n = d² → k=0 gives distance 0, k=1 gives distance (d+d²)² ≈ d⁴ → well-separated ✓

---

## 6. Non-Multiplicativity

**Question:** Is soft_min_d(mn, α) related to soft_min_d(m, α) · soft_min_d(n, α)?

**Test:** n = 6 = 2 × 3

**For d = 2:**
- Points: 6, 10, 14, 18, ... (sequence 2k + 4)
- Distances from 6: 0, 16, 64, 144, ...
- soft_min ≈ ε (since one distance is zero)

**For d = 3:**
- Points: 12, 21, 30, ... (sequence 3k + 9)
- Distances from 6: 36, 225, 576, ...
- soft_min ≈ 36 + ε

**There's no obvious multiplicative structure.**

**Conclusion:** F_n(s, α) is **NOT multiplicative** → no Euler product.

---

## 7. Symmetry and Reflection

**Reflection about d²:**
```
soft_min_d(d² + δ, α) vs soft_min_d(d² - δ, α)
```

**For small δ:**
- d² + δ: closest point is (d², 0), distance = δ²
- d² - δ: closest point is (d², 0), distance = δ²

**Approximate symmetry:**
```
soft_min_d(d² + δ, α) ≈ soft_min_d(d² - δ, α)
```

**But NOT exact** because:
- Number of points k ≤ ⌊n/d⌋ differs
- For d² + δ: more points in sum
- For d² - δ: fewer points

**Consequence:** F_n(s) has **approximate local symmetry** around n = d² points, but not global.

---

## 8. Special Values

### n = d²

**Points:** (d², 0), (2d+d², 1), (3d+d², 2), ...

**Distances:** 0 + ε, (2d)², (3d)², ...

**Soft-min:**
```
soft_min_d(d², α) = -log(exp(-α·ε) + exp(-α·4d²) + ...) / α
                  ≈ -log(exp(-α·ε)) / α
                  = ε
```

**Exact at large α:** soft_min = ε

---

### n = prime p

**For d > p:** k_max = 0, only one point (d², 0)

**For d ≤ p:** multiple points tested

**No special structure** (primes don't simplify soft-min).

---

## 9. Computational Complexity

**Per d:**
- Loop over k ∈ {0, 1, ..., ⌊n/d⌋}
- Compute exp(-α·dist²) for each k
- Sum and take log

**Cost:** O(n/d) per d

**Total for F_n(s):**
```
Σ_{d=2}^{10n} O(n/d) = O(n log n)
```

**Bottleneck:** For large n (e.g., n = 10000), this is ~100k operations.

**Optimization:** Dominant approximation reduces to O(√n).

---

## 10. U-Shape Mechanism (Hypothesis)

**Observed:** F_n(s, α=7) exhibits U-shape for exp/log variant.

**Hypothesis:** Competing scales in [soft_min_d]^(-s).

**For different d:**
- Some d: n is close to a point → soft_min_d ≈ ε → [ε]^(-s) = ε^(-s)
- Other d: n is far → soft_min_d ≈ large → [large]^(-s) small

**If soft_min_d ∈ [0.1, 10] (crosses 1):**
- For soft_min < 1: [sm]^(-s) increases with s
- For soft_min > 1: [sm]^(-s) decreases with s
- **Competing trends** → U-shape

**Critical test:** Histogram of soft_min_d(n, α) values for n = 97, d ∈ [2, 500].

**Prediction:**
- Exp/log (α=7): bimodal distribution crossing 1
- Power-mean (p=3): unimodal distribution > 1

---

## 11. Parameter Sensitivity

**Key questions:**

1. **How does α affect U-shape?**
   - α small: more uniform weighting → less contrast
   - α large: sharper weighting → more contrast
   - **Hypothesis:** U-shape exists only for α ∈ [5, 10]?

2. **How does ε affect results?**
   - ε = regularization (avoids dist² = 0)
   - For n = d²: soft_min ≈ ε exactly
   - Larger ε: smooths out exact hits

3. **How does cutoff affect results?**
   - Current: min(500, 10n)
   - For s ∈ [0.5, 5]: tail d^(-4s) negligible beyond d > 100
   - **Likely irrelevant** for qualitative shape

---

## 12. Analytical Tractability

**Can we derive closed form for F_n(s, α)?**

**Obstacles:**
1. **Log-sum-exp** not algebraically closed
2. **Double sum** (over d and k)
3. **Dependence on n** through modulo arithmetic
4. **Non-multiplicative** (no Euler product)

**Verdict:** **Closed form unlikely** for general (n, s, α).

**Possible approaches:**
- **Dominant approximation** (already have)
- **Asymptotic expansion** for large n
- **Special cases** (n = 2^k, n = p, n = p²)
- **Numerical methods** only

---

## 13. Comparison to Power-Mean

**Structural differences:**

| Property | Exp/log | Power-mean |
|----------|---------|------------|
| **Weighting** | exp(-α·dist²) | dist^(-p) |
| **Emphasis** | Very sharp | Gentler |
| **Effective range** | ~1/√α | ~dist < 1 |
| **U-shape** | Yes | No |
| **Soft_min range** | [0.1, 10] (?) | [1, 100] (?) |

**Hypothesis:** Exp/log creates **bimodal distribution** of soft_min_d values → competing scales → U-shape.

---

## 14. Open Questions

1. **Why α = 7 specifically?** Is there an optimal choice?
2. **What is distribution of soft_min_d(n, α) for typical n?**
3. **Does U-shape exist for all α > 0, or only certain range?**
4. **Is U-shape robust to changes in ε?**
5. **Can we prove U-shape exists, or is it numerical artifact?**
6. **Connection to number theory?** (parity correlation suggests yes)

---

## Next Steps

**To validate exp/log as "the tool":**

1. ✅ **Smoothness**: Confirmed (infinitely differentiable)
2. ✅ **Convergence**: Confirmed (both sums converge rapidly)
3. ✅ **Approximates minimum**: Yes (for large α)
4. ❓ **U-shape mechanism**: Needs histogram analysis
5. ❓ **Parameter sensitivity**: Needs systematic α-sweep
6. ❓ **Physical interpretation**: What does soft_min_d measure?

**Recommended experiments:**
1. Histogram of soft_min_d values (exp vs power-mean)
2. Sweep α ∈ [1, 20], check U-shape persistence
3. Vary ε ∈ [0.1, 10], check robustness
4. Theoretical analysis: can we predict s*(n) from soft_min distribution?

---

**Status:** ANALYSIS (analytical properties documented)
**Confidence:** Properties are mathematically sound, but U-shape mechanism still hypothetical
