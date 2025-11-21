# Diagonal Regularity Summation: Fourth Way to Compute L_M(s)

**Date**: November 16, 2025, 22:45 CET
**Status**: ⏸️ NEW APPROACH - Summation along regular diagonals from primal forest

---

## The Four Summation Orders

### Previously identified:
1. **Columns** (fixed d): Sum over all k for each divisor d
2. **Rows** (fixed k): Sum over all d for each offset k
3. **Hyperbolic layers** (fixed n): Sum over divisors of each n (√n layers)

### NEW (this document):
4. **Diagonal regularity lines** (fixed p): Sum along each 45° diagonal from paradox of regularity! ⭐

---

## Paradox of Regularity (from primal-forest-paper-cs)

**Key observation**: Primal forest exhibits perfectly regular diagonal patterns with slope 1.

### Diagonal for number p

**Definition**: All numbers of the form **p(p+k)** for k = 0, 1, 2, ...

**Coordinates** in primal forest (d, k):
- Start: (d=p, k=0) → number p²
- Next: (d=p, k=1) → number p² + p
- Next: (d=p, k=2) → number p² + 2p
- General: (d=p, k=k) → number p(p+k)

**In visualization coordinates** (x, y) where x=number, y=kp+1:
- Points: (p², 1), (p²+p, p+1), (p²+2p, 2p+1), ...
- **Spacing**: constant (p, p) in both directions
- **Slope**: exactly 1 (45° angle)

### Examples (from paper-cs lines 137-139):

```
p=2: diagonal (4,1), (6,3), (8,5), (10,7), ... spacing (2,2)
     Numbers: 4, 6, 8, 10, 12, 14, 16, 18, ...
     = {2·2, 2·3, 2·4, 2·5, 2·6, ...}

p=3: diagonal (9,1), (12,4), (15,7), (18,10), ... spacing (3,3)
     Numbers: 9, 12, 15, 18, 21, 24, 27, ...
     = {3·3, 3·4, 3·5, 3·6, 3·7, ...}

p=5: diagonal (25,1), (30,6), (35,11), (40,16), ... spacing (5,5)
     Numbers: 25, 30, 35, 40, 45, 50, ...
     = {5·5, 5·6, 5·7, 5·8, 5·9, ...}
```

**Pattern**: Diagonal p = multiples of p starting from p².

---

## Fourth Summation: By Diagonals

### Definition

For each p ≥ 2, define diagonal sum:
```
D_p(s) = Σ_{k=0}^∞ M(p(p+k)) / [p(p+k)]^s
       = Σ_{k=0}^∞ M(p² + kp) / (p² + kp)^s
```

Then:
```
L_M(s) = Σ_{p=2}^∞ D_p(s)
```

**But wait**: Overlaps!

### Handling Overlaps

**Problem**: Composite numbers appear on multiple diagonals.

**Example**: 12 appears on:
- Diagonal p=2: 12 = 2·6
- Diagonal p=3: 12 = 3·4
- Diagonal p=4: 12 = 4·3

**M(12) = ?**: Divisors of 12 in [2, √12] = {2, 3} → M(12) = 2

**But** in diagonal summation, we count **differently**!

### Key Insight: Diagonals count divisor pairs!

**On diagonal p**: We're looking at n = p·m where m = p+k.

**This is a factorization**: n = p × m with p ≤ m.

**M(n) vs diagonal counting**:
- M(n) counts ALL divisors d with 2 ≤ d ≤ √n
- Diagonal p counts THIS SPECIFIC divisor p (if 2 ≤ p ≤ √n)

**Therefore**: Each diagonal contributes 1 per number (not M(n))!

---

## Corrected Diagonal Summation

### Diagonal contribution

For number n = p·m on diagonal p:
- **Contribution**: 1 (this diagonal represents divisor p)
- **Not**: M(n) (that would overcount)

### Proper formula

```
D_p(s) = Σ_{k=0}^∞ 1 / [p(p+k)]^s
       = 1/p^s · Σ_{m=p}^∞ 1/m^s
       = 1/p^s · [H(s; p, ∞)]
```

where H(s; p, ∞) = Σ_{m=p}^∞ 1/m^s is **tail of Riemann zeta**.

### Explicit form

```
D_p(s) = 1/p^s · [ζ(s) - Σ_{m=1}^{p-1} 1/m^s]
       = 1/p^s · [ζ(s) - H_{p-1}(s)]
```

where H_k(s) = Σ_{j=1}^k 1/j^s (harmonic sum).

---

## Connection to L_M(s)

**Total from all diagonals**:
```
Σ_{p=2}^∞ D_p(s) = Σ_{p=2}^∞ [ζ(s) - H_{p-1}(s)] / p^s
                 = ζ(s) Σ_{p=2}^∞ 1/p^s - Σ_{p=2}^∞ H_{p-1}(s)/p^s
                 = ζ(s) [ζ(s) - 1] - Σ_{p=2}^∞ H_{p-1}(s)/p^s
```

**But wait**: This is **EXACTLY THE CLOSED FORM**!

```
L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s
```

---

## BREAKTHROUGH REALIZATION 🎯

**The closed form IS diagonal summation!**

**Interpretation**:
- Term **ζ(s)[ζ(s)-1]**: "naive" count if we sum all diagonals without correction
- Term **-Σ H_{j-1}(s)/j^s**: correction for overlaps (numbers with multiple divisors)

**Geometric meaning**:
- Each number n appears on **exactly M(n) diagonals** (one per divisor in [2,√n])
- Diagonal p contributes 1/[p·m]^s when n = p·m
- Total contribution to n from ALL its diagonals = M(n)/n^s ✓

**This is WHY the closed form works!**

---

## Numerical Convergence: Does This Help?

### Direct closed form (current)
```
L_M(s) = ζ(s)[ζ(s)-1] - Σ_{j=2}^N H_{j-1}(s)/j^s
```
**Problem**: For Re(s) ≤ 1, this oscillates (confirmed Nov 16).

### Diagonal summation (explicit)
```
L_M(s) = Σ_{p=2}^P D_p(s) where D_p = [ζ(s) - H_{p-1}(s)]/p^s
```

**Comparison**:
- Same formula, just **different grouping**!
- Truncation at P vs truncation at N

**Convergence rate**:
```
|tail| ≤ Σ_{p>P} |D_p(s)|
       ≤ Σ_{p>P} ζ(s)/p^{Re(s)}
       = ζ(s) · [ζ(Re(s)) - H_P(Re(s))]
```

For Re(s) > 1: converges (same as before)
For Re(s) ≤ 1: **still diverges** (ζ(Re(s)) pole at s=1)

**Verdict**: No convergence improvement for critical line. 😞

---

## But: Theoretical Insight!

### Advantage 1: Geometric interpretation

**Now we understand** what the closed form terms mean:
- Each p creates a **regular diagonal** in primal forest
- Diagonals have **slope 1**, spacing (p,p)
- Start at (p², 1) and extend infinitely
- Sum D_p = contribution from entire diagonal p

**The paradox of regularity** is encoded in the closed form!

### Advantage 2: Connection to Mellin puzzle?

**Diagonal structure** might explain (γ-1) vs (2γ-1):

**Summatory** (cumulative count of diagonals up to √x):
```
Σ_{n≤x} M(n) = Σ_{p≤√x} [# of points on diagonal p below x]
```

**Laurent residue** (pole structure):
```
Res[L_M, s=1] = residue of Σ_p D_p(s)
```

**Hypothesis**: Factor 2 comes from **symmetric counting** of diagonals?
- Diagonals p ≤ √n contribute "twice" (once ascending, once in overlap structure?)
- Needs formalization!

### Advantage 3: Euler product attempt

**Question**: Can we express D_p(s) using primes?

For **prime** p:
```
D_p(s) = [ζ(s) - H_{p-1}(s)] / p^s
```

**If we sum only over primes**:
```
Σ_{p prime} D_p(s) = ?
```

This doesn't give L_M directly (composites contribute too), but might give **partial product structure**?

**Speculation**: Maybe:
```
L_M(s) = [product over primes] × [correction for composites]
```

Needs investigation!

---

## Practical Value

### For numerical computation: ❌
- No convergence improvement on critical line
- Same oscillation issues as direct closed form
- Diagonal grouping doesn't help with Re(s) ≤ 1

### For theoretical understanding: ✅
- **Explains** closed form structure geometrically
- Connects to **paradox of regularity** from primal forest
- Potential link to **Mellin puzzle**
- Foundation for **future Euler product attempts**

---

## Comparison: Layer vs Diagonal Summation

**Layer summation** (my earlier proposal):
- Group by **√n shells**: Layer(m) = {n : m² ≤ n < (m+1)²}
- Each layer is **hyperbola** in (d,k) space: d²+kd = const
- Advantage: Finite sums, acceleration possible
- **Different from closed form** → new computational approach

**Diagonal summation** (this document):
- Group by **regular diagonals**: Diag(p) = {p², p²+p, p²+2p, ...}
- Each diagonal has **slope 1** in visualization
- Insight: **Reproduces closed form exactly**
- **Same as current method** → no numerical advantage

**Verdict**: Layer summation still worth testing! (Different approach)

---

## Next Steps

### Immediate
1. ✅ Document this insight (done)
2. Update STATUS.md with "diagonal summation = closed form" realization
3. **Still test layer summation** (different method, might help!)

### Medium term
4. Investigate Euler product structure via diagonal sums
5. Formalize connection to Mellin puzzle (factor 2 mystery)
6. Explore if primes-only diagonal sum has special properties

### Long term
7. Write paper section on "Geometric meaning of closed form"
8. Connect paradox of regularity to analytic properties

---

## Status

**Diagonal regularity summation**:
- ✅ **Understood**: Reproduces closed form exactly
- ❌ **Numerical benefit**: None (same convergence issues)
- ✅ **Theoretical value**: High (geometric interpretation)
- ⭐ **Key insight**: Closed form IS the diagonal summation!

**Recommendation**:
- Document this understanding
- **Layer summation still promising** (test separately!)

---

**References**:
- Primal forest paper-cs: docs/papers/primal-forest-paper-cs.tex (lines 127-152, 204-210)
- Closed form: docs/closed-form-L_M-RESULT.md
- Paradox of regularity: paper-cs § 4.2
