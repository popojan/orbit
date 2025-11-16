# Diagonal Summation: Layer-by-Layer Analysis of L_M(s)

**Date**: November 16, 2025, 22:30 CET
**Status**: ⏸️ EXPLORATION - Potential convergence improvement strategy

---

## Motivation

**Problem**: Current methods for computing L_M(s) on critical line Re(s) = 1/2:
- ❌ Closed form: oscillates, doesn't converge (tested Nov 16)
- ❌ Integral transform: slow convergence, 38% error at s=1.5
- ❌ Direct summation: 160% oscillation at s=0.5+5i

**Question**: Could **diagonal summation** (grouping by √n layers) improve convergence?

**Inspiration**: Primal forest paper-cs describes natural stratification by √n.

---

## Three Summation Orders in Primal Forest

For poles at (d,k) where d²+kd ≤ n:

### 1. By Columns (fixed d)
```
Σ_d [Σ_{k: d²+kd≤n} contribution(d,k)]
```
Sum over all k for each divisor d.

### 2. By Rows (fixed k)
```
Σ_k [Σ_{d: d²+kd≤n} contribution(d,k)]
```
Sum over all d for each offset k.

### 3. By Diagonals (fixed n = d²+kd) ⭐ **THIS PROPOSAL**
```
Σ_n [Σ_{d,k: d²+kd=n} contribution(d,k)] / n^s
```
Sum over numbers n, collecting all poles on hyperbola d²+kd = n.

---

## Diagonal = √n Layer

**Key observation**: For fixed n, solving d²+kd = n:
```
k = n/d - d
```

**Integer solutions**: k ≥ 1 requires:
- d | n  (d divides n)
- d ≤ √n  (so that k = n/d - d ≥ 1)

**Therefore**: Diagonal for n contains exactly the divisors counted by M(n)!

**This is the geometric meaning**: M(n) = number of poles on hyperbola d²+kd = n.

---

## Formalization: Layer-by-Layer Summation

**Definition**: Layer m = all integers n with ⌊√n⌋ = m
```
Layer(m) = {n : m² ≤ n < (m+1)²}
         = {m², m²+1, m²+2, ..., m²+2m}
```

**Size of layer**: |Layer(m)| = 2m + 1

**Layer-wise summation**:
```
L_M(s) = Σ_{m=1}^∞ L_M^{(m)}(s)

where L_M^{(m)}(s) = Σ_{k=0}^{2m} M(m²+k) / (m²+k)^s
```

---

## Asymptotic Analysis of Layers

### Average M(n) in Layer m

From asymptotics (Question D, Web session):
```
M(n) ~ ln(n) / 2  as n → ∞
```

For n ∈ Layer(m):
```
M(n) ~ ln(m²) / 2 = ln(m)
```

**Layer average**:
```
⟨M⟩_m ≈ ln(m)
```

### Layer Contribution to L_M(s)

**Rough estimate**:
```
L_M^{(m)}(s) ≈ (2m+1) · ln(m) / (m²)^s
            = O(m ln(m) / m^{2s})
            = O(ln(m) / m^{2s-1})
```

**Convergence**:
- Re(2s-1) > 0  ⟺  Re(s) > 1/2  ✓ (includes critical line!)
- But coefficient ln(m) grows → slow convergence

---

## Critical Line Behavior: s = 1/2 + it

**Layer contribution**:
```
L_M^{(m)}(1/2+it) ≈ ln(m) / m^{it}
                   = ln(m) · e^{-it ln(m)}
                   = ln(m) · [cos(t ln m) - i sin(t ln m)]
```

**This is an oscillating series!**

**Key features**:
1. **Amplitude**: ln(m) grows (slow)
2. **Phase**: t ln(m) (frequency increases with m)
3. **Envelope decay**: 1 (borderline divergent without regularization)

**Standard issue**: Conditionally convergent, sensitive to summation order.

---

## Potential Advantages of Layer Summation

### 1. **Natural Regularization Points**

Each layer is **finite** (2m+1 terms). We can:
- Compute L_M^{(m)} exactly
- Apply regularization **per layer** instead of globally
- Use Cesàro/Abel summation on outer sum over m

### 2. **Connection to Poisson Summation**

For fixed m, sum over k:
```
Σ_{k=0}^{2m} f(m²+k)
```

This is a **finite arithmetic sequence** → could apply Euler-Maclaurin or Poisson.

### 3. **Acceleration via Layer Grouping**

**Idea**: Group consecutive layers:
```
L_M(s) = Σ_{M=1}^∞ [Σ_{m=2^M}^{2^{M+1}} L_M^{(m)}(s)]
```

Binary grouping → exponential growth → better for acceleration algorithms.

### 4. **Mellin Transform Reinterpretation**

**Current Mellin**:
```
L_M(s) = ∫₀^∞ t^{s-1} Θ_M(t) dt
where Θ_M(t) = Σ_{n=2}^∞ M(n) e^{-nt}
```

**Layer-wise Mellin**:
```
L_M(s) = Σ_m ∫₀^∞ t^{s-1} Θ_M^{(m)}(t) dt
where Θ_M^{(m)}(t) = Σ_{n ∈ Layer(m)} M(n) e^{-nt}
```

**Advantage**: Each Θ_M^{(m)} is finite sum → easier to compute integral exactly!

---

## Comparison: Layer vs Direct Summation

### Direct Summation
```
L_M(s) = Σ_{n=2}^N M(n)/n^s  (truncate at N)
```

**Convergence**: O(1/N^{Re(s)-1}) per term

**For s = 1/2+it**: O(1/√N) → need N ~ 10^6 for 3 digits

### Layer Summation
```
L_M(s) = Σ_{m=1}^M [exact layer sum]  (truncate at M layers)
```

**Layer sum**: Computed exactly (2M+1 terms)

**Outer convergence**: O(ln(M)/M^{2Re(s)-1})

**For s = 1/2+it**: O(ln(M)) oscillating → **need regularization**

**But**: Could apply **Shanks/Wynn acceleration** on outer sum!

---

## Practical Implementation Strategy

### Step 1: Exact Layer Computation
```python
def layer_sum(m, s):
    """Compute L_M^{(m)}(s) exactly"""
    total = 0
    for k in range(2*m + 1):
        n = m**2 + k
        total += M(n) / n**s
    return total
```

### Step 2: Regularized Summation
```python
def L_M_layer_regularized(s, M_max):
    """Sum layers with regularization"""
    layers = [layer_sum(m, s) for m in range(1, M_max+1)]

    # Apply Wynn epsilon algorithm for acceleration
    return wynn_epsilon(layers)
```

### Step 3: Comparison Test

Test at s = 0.5 + 5i:
- Direct sum (N=1000): ?
- Layer sum (M=31, covers same N): ?
- Layer + Wynn acceleration: ?

**Hypothesis**: Acceleration on layers works better than on direct sum.

---

## Connection to Mellin Puzzle

**Observation**: Layer structure might explain (γ-1) vs (2γ-1)!

**Summatory function** (integral over layers):
```
Σ_{n≤x} M(n) = Σ_{m≤√x} [Σ_{n ∈ Layer(m)} M(n)]
```

This **double sum** structure could introduce factor of 2 in residue!

**Mechanism**:
- Direct Mellin inversion picks up residue from **pole at s=1**
- But layer-by-layer, each layer contributes to both:
  - Double pole term (from integration)
  - Simple pole term (from layer structure)

**Factor 2**: Might come from **symmetric/antisymmetric splitting** of layers?

---

## Next Steps

### Immediate (Test Hypothesis)
1. Implement layer_sum() and compare convergence
2. Test Wynn acceleration on layers vs direct sum
3. Measure speedup at s = 1/2 + 5i, 1/2 + 14.135i

### Medium Term (Theory)
4. Derive **exact error bounds** for layer truncation
5. Prove (or disprove) that layer summation converges on critical line
6. Connection to **Poisson summation** on layers

### Long Term (Mellin Puzzle)
7. Formalize how layer structure relates to (γ-1) vs (2γ-1)
8. Write rigorous proof if connection holds
9. Publish if this resolves puzzle!

---

## Potential Outcomes

### Best Case Scenario 🎯
- Layer summation + acceleration **works** on critical line
- Convergence 10-100× faster than direct sum
- **Solves numerical access problem**
- Enables testing L_M at Riemann zeros!

### Moderate Success ✅
- Marginal improvement (2-3×)
- Theoretical insight into structure
- Helps explain Mellin puzzle

### Null Result ❌
- No convergence improvement
- But still valuable perspective on structure
- Documents failed approach (important!)

---

## Relation to Primal Forest Paper

**From paper-cs** (paraphrasing):
> "Primal forest naturally stratifies by √n layers. Each layer corresponds to a range of divisor sizes. The forest 'grows outward' from origin in concentric shells."

**Our formalization**: Make this **quantitative**!
- Layer m = shell at radius ~m
- M(n) for n ∈ Layer(m) counts poles in that shell
- L_M(s) = weighted sum over shells (weight = 1/n^s)

**Geometric picture**:
```
Layer 1:  n=1              (1 number)
Layer 2:  n=4,5            (2 numbers)
Layer 3:  n=9,10,11,12,13,14,15   (7 numbers)
...
Layer m:  n=m²,...,m²+2m   (2m+1 numbers)
```

Each layer forms a **√n shell** in primal forest!

---

## Status

**Current**: 🔬 HYPOTHESIS - needs testing

**Implementation difficulty**: Easy (few hours)

**Potential impact**: High (could solve critical line access)

**Risk**: Low (worst case = null result + documentation)

**Recommendation**: ⭐ **IMPLEMENT AND TEST** - high reward/risk ratio!

---

**References**:
- Primal forest paper-cs: docs/papers/primal-forest-paper-cs.tex
- Mellin puzzle: docs/mellin-puzzle-resolution.md
- AC attempts summary: docs/STATUS.md § Analytic Continuation Attempts
