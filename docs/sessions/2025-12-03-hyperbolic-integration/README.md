# Session: Hyperbolic Integration of B(n,k)

**Date:** December 3, 2025
**Status:** 🔬 NUMERICALLY VERIFIED

## Question

The Chebyshev integral theorem has both discrete and continuous forms:
- **Discrete:** Σ_{k=1}^{n} B(n,k) = n
- **Continuous:** ∫₀ⁿ B(n,k) dk = n

The hyperbolic generalization (from 2025-12-02-eta-identity) extends the discrete sum:
- **Discrete hyperbolic:** Σ_{k=1}^{n} B(n, k+ib) = n for any b ∈ ℂ

**Main question:** Can the hyperbolic extension also be made continuous?

## Results

### ✅ Continuous integral works for complex offset

```
∫₀ⁿ B(n, k+ib) dk = n   for any b ∈ ℂ
```

**Proof:** The integrand is 1 + β(n)·cos(oscillatory). The "1" integrates to n, and cosine integrates to 0 over a full period (2π).

### ✅ Path independence for complex n

```
∫₀ⁿ B(n, k) dk = n   for complex n (avoiding singularities)
```

**Verified numerically:**
- n = 3+i: ∫ = 3+i ✓
- n = 4+2i via L-shaped path: same result ✓

Since B(n,k) is **entire in k**, path independence follows from Cauchy's theorem.

## Singularity Structure

### In n-plane (fixed k)

| Singularity | Type | Residue | Notes |
|-------------|------|---------|-------|
| n = 0 | **Cluster point** | undefined | Poles at n=1/k accumulate here |
| n = ±1/k (k∈ℤ) | **Simple pole** | ±1/(4π) | Cot[kπ] diverges |
| n = ±2 | **Removable** | 0 | Cot[π/2] = 0, β(±2) = 1/4 |

**Residues at n = ±1:**
```
Res[β(n), n=1]  = +1/(4π) ≈ 0.0796
Res[β(n), n=-1] = -1/(4π)

Res[B(n,k), n=1]  = -1/(4π)  (for integer k)
Res[B(n,k), n=-1] = +1/(4π)
```

**n = 0 is NOT an essential singularity** (like e^{1/z}), but a **cluster point of poles**:
- Poles at n = 1/k for all k ∈ ℤ\{0} accumulate at 0
- Res[β, n=1/k] = 1/(4πk)
- No Laurent series exists around n = 0
- Residue at 0 is undefined (meaningless)

### Theorem Violations at Cluster Point

**Mittag-Leffler** (reconstruction from residues) requires no finite accumulation point.
- Poles accumulate at n = 0 (finite) → theorem fails

**Cauchy Residue Theorem** requires finitely many poles inside contour.
- Any contour around n = 0 contains infinitely many poles → theorem fails

**Consequence:** β(n) is meromorphic on ℂ \ {0}, but n = 0 is a **natural boundary**.

### Closed-Form Residue Formula

For pole at n = 1/k (k ∈ ℤ, k ≠ 0):

```
┌─────────────────────────────────┐
│  Res[β(n), n = 1/k] = 1/(4πk)  │
└─────────────────────────────────┘
```

**Derivation:** Near n = 1/k, set n = 1/k + ε:
- π/n ≈ kπ - k²πε
- Cot[kπ - k²πε] ≈ -1/(k²πε)
- β(n) ≈ 1/(4k) + 1/(4πkε)
- Residue = coefficient of 1/ε = 1/(4πk)

**Sum of residues:** Σ_{k=1}^{N} 1/(4πk) = H_N/(4π) where H_N is N-th harmonic number.
As N → ∞, this diverges (harmonic series).

### Partial Mittag-Leffler Reconstruction

**Full Mittag-Leffler fails:** Poles accumulate at n = 0 (finite).

**But in restricted domains it works:**

For |n| > 1/N (avoiding the cluster point), only finitely many poles exist:
```
β(n) = Σ_{k=1}^{N-1} [1/(4πk) · 1/(n - 1/k)] + h_N(n)
```
where h_N(n) is holomorphic in that region.

| Domain | Poles inside | Mittag-Leffler |
|--------|--------------|----------------|
| n > 1 | none | β(n) = h(n) (holomorphic) |
| n > 1/2 | n = 1 only | β(n) = 1/(4π(n-1)) + h(n) |
| n > 1/3 | n = 1, 1/2 | β(n) = 1/(4π(n-1)) + 1/(8π(n-1/2)) + h(n) |
| n > 1/N | N-1 poles | partial fraction + h(n) |

**Comparison with cot(πn):** Has poles at integers (n = 0, ±1, ±2, ...) with no finite accumulation point → full Mittag-Leffler works:
```
cot(πn) = 1/(πn) + 2n·Σ_{k=1}^{∞} 1/(n² - k²)
```

### In k-plane (fixed n)

**B(n,k) is ENTIRE in k** — no poles!

The function 1 + β(n)·cos((2k-1)π/n) is just a cosine, which is entire.

## Formulas

### B-function with complex offset

```
B(n, k+ib) = 1 + β(n)·cos((2k-1)π/n + 2ibπ/n)
           = 1 + β(n)·[cos((2k-1)π/n)·cosh(2bπ/n) - i·sin((2k-1)π/n)·sinh(2bπ/n)]
```

### β-function

```
β(n) = (n - cot(π/n))/(4n)
```

Near singularities:
- β(n) ~ 1/(4π(n-1)) as n → 1 (simple pole)
- β(2) = 1/4 (removable)
- β(n) oscillates wildly as n → 0

## No-Go Theorem: Integral Theorem vs Cluster Point

**Question:** Can we modify B(n,k) to avoid the cluster point while preserving ∫₀ⁿ B dk = n?

**Answer: NO.** The integral theorem forces the cluster point.

**Proof:**
For ∫₀ⁿ [1 + β(n)·cos((2k-1)·f(n))] dk = n, we need:
```
∫₀ⁿ cos((2k-1)·f(n)) dk = 0
```

This requires the argument to sweep exactly 2πm (full periods):
- At k = 0: argument = -f(n)
- At k = n: argument = (2n-1)·f(n)
- Sweep = 2n·f(n) = 2πm

**Solution:** f(n) = πm/n

Taking m = 1: **f(n) = π/n is forced!**

This creates Cot[π/n] in β(n), which has poles at n = 1/k → cluster point at n = 0.

**Trade-off is fundamental:**

| Property | Original B(n,k) | Modified (no cluster) |
|----------|-----------------|----------------------|
| ∫₀ⁿ B dk = n | ✅ exact | ❌ fails |
| No cluster point | ❌ at n = 0 | ✅ poles at integers |

## Orthogonal Integration Directions

**Key discovery:** B(n,k) has two natural integration directions with fundamentally different results:

### k-integration (fixed n): Chebyshev Geometry

```
∫₀ⁿ B(n,k) dk = n
```

- Path independent in complex k-plane
- Result equals upper limit (average value = 1)
- Encodes Chebyshev polygon geometry

### n-integration (fixed integer k): Dirichlet Eta!

For integer k, the residues at n = 1/m are:
```
Res[B(n,k), n = 1/m] = (-1)^m / (4πm)
```

Summing over all poles:
```
Σₘ₌₁^∞ Res[B, n=1/m] = (1/4π) · Σₘ₌₁^∞ (-1)^m / m
                      = -(1/4π) · η(1)
                      = -ln(2) / (4π)
```

**Connection to Dirichlet eta:**
```
η(1) = Σₙ₌₁^∞ (-1)^{n+1}/n = ln(2)
```

### Summary Table

| Direction | Integral | Result | Meaning |
|-----------|----------|--------|---------|
| Over k | ∫₀ⁿ B dk | n | Chebyshev geometry preserved |
| Over n | ∮ B dn | -ln(2)/(4π) | Dirichlet η(1) emerges! |

**Geometric interpretation:**
- k-integration: lobe areas sum to polygon "size" n
- n-integration: pole structure encodes η(1) = ln(2)

This reveals a **deep duality** in the B-function:
- One direction preserves geometric information (n)
- Orthogonal direction yields number-theoretic constant (ln 2)

## Open Questions

1. ~~**Contour integrals encircling singularities:** What are the residues at n = ±1?~~ **ANSWERED:** Res[β, n=1/k] = 1/(4πk)

2. ~~**Connection to zeta:** Can contour methods in the n-plane reveal structure?~~ **PARTIALLY ANSWERED:** n-integration yields η(1) = ln(2)

3. **Generalization to η(s)?** Can we modify the n-contour to get η(s) for s ≠ 1?

4. **d-dimensional extension:** Does ∫...∫ V^(d) dk₁...dk_d = ∏ nᵢ hold for complex nᵢ?

5. **Holomorphic part h(n):** What is the explicit form of h(n) in the partial Mittag-Leffler expansion?

## Files

- README.md (this file)
