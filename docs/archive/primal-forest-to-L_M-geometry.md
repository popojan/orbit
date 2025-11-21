# From Primal Forest to L_M(s): Geometric Journey

**Date:** November 17, 2025
**Goal:** Clean connection from primal forest visualization to L_M(s) Dirichlet series
**Approach:** Geometry first, then algebra

---

## Part 1: Primal Forest Geometry (The Foundation)

### The Forest View

**From:** `docs/papers/primal-forest-paper-cs.tex`

**Metaphor:** You stand at the southern edge of a forest (y=0) and can walk east-west along x-axis. At each position x=n, you look directly north (up the y-axis) into the forest.

**Trees:** For each composite number n = p(p+k) with p ≥ 2, we plant a tree at position:
```
(x, y) = (kp + p², kp + 1)
```

**Key observations:**
- **x-coordinate = n itself** (the number being tested)
- **y-coordinate = depth in forest** (kp+1 increases with k)
- **Each divisor p of n** (with 2 ≤ p ≤ √n) plants ONE tree on vertical line x=n

---

### Counting Trees = M(n)

**Definition:**
```
M(n) = number of trees on vertical line x=n
     = number of divisors p with 2 ≤ p ≤ √n
     = #{p : p|n, 2 ≤ p ≤ √n}
```

**Examples:**
- n=13 (prime): **0 trees** → clear view → prime
- n=18=2×9=3×6: divisors {2,3} → **2 trees** → composite
- n=16=2×8=4×4: divisors {2,4} → **2 trees** → composite

**Visual:** Walking east (increasing n), you see:
- **Primes:** Clear views (no trees blocking)
- **Composites:** Trees at various depths y blocking your view

---

### The Discrete Boundary: ⌊√n⌋

**Critical observation:** Only divisors p with **p ≤ √n** create trees!

**Why?** If n = p×q with p ≤ q, then:
- p ≤ √n (always plants tree)
- q ≥ √n (too large, excluded)

**The floor function ⌊√n⌋** creates natural boundary:
- **Region d ≤ √n:** Divisor region (finite, discrete)
- **Region d > √n:** Non-divisor region (excluded)

**This is where the floor structure enters!**

---

## Part 2: From M(n) to L_M(s)

### Globalizing: Dirichlet Series

**Idea:** Instead of one number n, study ALL numbers via Dirichlet series:

```
L_M(s) = Σ_{n=2}^∞ M(n)/n^s
```

**Interpretation:** Weighted sum of tree counts:
- Each position n contributes M(n) (its tree count)
- Weighted by 1/n^s (exponential decay)
- Sum over all positions n ≥ 2

**Geometric meaning:** We're aggregating information from the ENTIRE forest (all x-positions) into a single analytic function L_M(s).

---

### Double Sum Representation

**Expand M(n) definition:**
```
L_M(s) = Σ_{n=2}^∞ [Σ_{p: p|n, 2≤p≤√n} 1]/n^s
```

**Interchange summation order:**

Instead of "for each n, count its divisors", do "for each divisor p, count where it appears".

For divisor p to appear in n, we need n = p×m with m ≥ p (so that p ≤ √n).

Writing m = p+k gives n = p(p+k) with k ≥ 0.

**Therefore:**
```
L_M(s) = Σ_{p=2}^∞ Σ_{k=0}^∞ 1/[p(p+k)]^s
       = Σ_{p=2}^∞ Σ_{k=0}^∞ 1/(p^s · (p+k)^s)
       = Σ_{p=2}^∞ p^{-s} [Σ_{k=0}^∞ (p+k)^{-s}]
```

**Inner sum:** Σ_{k=0}^∞ (p+k)^{-s} = Σ_{m=p}^∞ m^{-s} = ζ(s) - H_{p-1}(s)

where H_j(s) = Σ_{i=1}^j i^{-s} is **partial zeta sum** (discrete truncation at j).

**Result:**
```
L_M(s) = Σ_{p=2}^∞ p^{-s} [ζ(s) - H_{p-1}(s)]
       = ζ(s) Σ_{p=2}^∞ p^{-s} - Σ_{p=2}^∞ H_{p-1}(s)/p^s
       = ζ(s)[ζ(s) - 1] - C(s)
```

**Closed form!**

---

## Part 3: What is C(s)?

### Definition

```
C(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s
```

where H_j(s) = Σ_{k=1}^j k^{-s} = "partial zeta sum up to j".

---

### Geometric Interpretation

**In primal forest:**
- Boundary at ⌊√n⌋ separates divisors (≤√n) from non-divisors (>√n)
- This is DISCRETE truncation

**In L_M(s) derivation:**
- We split ζ(s) into H_{j-1}(s) + tail
- H_{j-1}(s) = discrete partial sum (like truncating at ⌊√n⌋)
- ζ(s) = full infinite sum (like continuous limit)

**C(s) = correction term** encoding the difference between:
1. Using full ζ(s) (continuous)
2. Using partial sums H_j (discrete)

**Analogy:**
```
Primal forest:       L_M(s):
├─ d ≤ ⌊√n⌋ (finite) ←→ H_j(s) (partial sum to j)
└─ d > √n (excluded) ←→ tail ζ(s) - H_j(s)
```

**C(s) encodes the FLOOR STRUCTURE from the original geometry!**

---

### Double Sum Expansion

```
C(s) = Σ_{j=2}^∞ [Σ_{k=1}^{j-1} k^{-s}]/j^s
     = Σ_{j=2}^∞ Σ_{k=1}^{j-1} k^{-s} · j^{-s}
```

**Lattice interpretation:** Sum over region {(k,j) : j≥2, 1≤k<j}

Visualize as grid:
```
    j=1 j=2 j=3 j=4 j=5 ...
k=1  -   ●   ●   ●   ●
k=2  -   -   ●   ●   ●
k=3  -   -   -   ●   ●
k=4  -   -   -   -   ●
k=5  -   -   -   -   -
...
```

**Region:** Lower triangle (strict inequality k < j), excluding column j=1.

---

### Complementarity with L_M

**L_M(s) lattice region:**
```
L_M(s) = Σ_{d=2}^∞ Σ_{m=d}^∞ d^{-s} · m^{-s}
```

Region: {(d,m) : d≥2, m≥d}

```
    m=1 m=2 m=3 m=4 m=5 ...
d=1  -   -   -   -   -
d=2  -   ○   ○   ○   ○
d=3  -   -   ○   ○   ○
d=4  -   -   -   ○   ○
d=5  -   -   -   -   ○
...
```

**Region:** Upper triangle (including diagonal), excluding row d=1.

**Combined C ∪ L_M:**
```
    j/m=1 2   3   4   5 ...
1     -   -   -   -   -
2     ●   ○   ○   ○   ○
3     ●   ●   ○   ○   ○
4     ●   ●   ●   ○   ○
5     ●   ●   ●   ●   ○
...
```

Covers: {(i,j) : i,j ≥ 2, i≠j} ∪ {(d,d) : d≥2}

**What's excluded:** First row and first column (corresponding to index 1).

---

## Part 4: Connection to Floor Function

### The Key Insight

**In primal forest:**
- M(n) counts divisors up to ⌊√n⌋
- Floor creates discrete boundary
- Separates "factorization region" from "excluded region"

**In C(s):**
- H_j(s) is discrete partial sum (truncated at j)
- Like taking ⌊∞⌋ = j
- C(s) = Σ [partial sums]/j^s weights these truncations

**Floor function ⌊√n⌋ in geometry** ↔ **Partial sums H_j in algebra**

Both encode discrete vs continuous structure!

---

### Why C(s) is Hard to Bound Analytically

**Problem:** H_j(s) ≈ ln j + γ for s near 1.

So:
```
C(1+ε) ≈ Σ_{j=2}^∞ (ln j + γ)/j^{1+ε}
```

**Naive approach:** Bound term-by-term → diverges as 1/ε²

**Reality:** Subtle cancellations exist between:
- ζ²(s) terms (from ζ(s)[ζ(s)-1])
- Σ H_j/j^s terms (from C(s))

These cancellations are encoded in the **geometry of the lattice regions**!

The floor structure creates dependencies between terms that naive bounds miss.

---

## Part 5: What We Learned

### Confirmed

1. ✅ **Closed form is geometrically motivated:**
   ```
   L_M(s) = ζ(s)[ζ(s)-1] - C(s)
   ```
   comes from splitting divisor sum at √n boundary

2. ✅ **C(s) encodes floor structure:**
   - Partial sums H_j ↔ discrete truncations
   - Like ⌊√n⌋ in primal forest

3. ✅ **Lattice regions are complementary:**
   - C(s) = lower triangle
   - L_M(s) = upper triangle
   - Together cover {(i,j) : i,j≥2} (minus row/col 1)

---

### Why A=1 Bound is Hard

**Floor creates discrete structure** that:
- Prevents naive analytical bounds
- Creates subtle cancellations in sums
- Requires understanding lattice geometry, not just term-by-term estimates

**Numerical evidence** C(1+ε) ≈ 22 is strong, but analytical proof requires:
- Careful asymptotic analysis of partial sums
- Understanding cancellations in ζ²-ζ - C decomposition
- Possibly techniques from Diophantine approximation (how well H_j approximates ζ?)

**This is genuinely difficult!**

---

## Conclusion

**Journey:**
```
Primal Forest (geometric)
  → M(n) (combinatorial)
  → L_M(s) (analytic)
  → C(s) = floor correction
```

**Floor function appears in:**
1. Primal forest: ⌊√n⌋ boundary
2. M(n) definition: ⌊(τ(n)-1)/2⌋ formula
3. C(s) structure: partial sums H_j (discrete truncations)

**Connection preserved!** Even if analytical bound on C(s) eludes us, we understand its geometric origin.

**Value:** Future work on L_M(s) can use primal forest intuition, not just abstract algebra.

---

**Maison verre:** This clean version replaces the confused `C-series-primal-forest-connection.md`. Geometry → Algebra → Interpretation, no symbol confusion.
