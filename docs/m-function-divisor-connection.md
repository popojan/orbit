# M(n) Function: Connection to Divisor Function τ(n)

**Date**: November 15, 2025
**Status**: **THEOREM** - Rigorously proven with closed form

---

## Executive Summary

We establish an exact closed-form relationship between the factorization count M(n) and the classical divisor function τ(n):

**Theorem (M-τ Connection)**:
$$M(n) = \#\{d : d \mid n, \, 2 \leq d \leq \sqrt{n}\}$$

This counts non-trivial divisors up to √n, directly connecting M(n) to classical number theory.

**Numerical Verification**: 100% success on 1000 random numbers from [13, 4996]

---

## Definitions

### M(n) - Primal Forest Factorization Count

$$M(n) = \#\{(d,k) : n = kd + d^2, \, d \geq 2, \, k \geq 0, \, d,k \in \mathbb{Z}\}$$

**Interpretation**: Number of ways to write n in the form kd + d² with constraints d≥2, k≥0.

### τ(n) - Divisor Function

$$\tau(n) = \#\{d : d \mid n, \, d \geq 1\}$$

**Interpretation**: Total number of positive divisors of n.

**Examples**:
- τ(12) = 6, divisors: {1, 2, 3, 4, 6, 12}
- τ(35) = 4, divisors: {1, 5, 7, 35}
- τ(36) = 9, divisors: {1, 2, 3, 4, 6, 9, 12, 18, 36}

---

## Main Theorem: Closed Form for M(n)

### Theorem 1 (Bijection with Divisors)

**Statement**: There exists a bijection between:
1. Factorizations (d, k) with n = kd + d², d≥2, k≥0
2. Divisors d of n with 2 ≤ d ≤ √n

**Consequence**:
$$M(n) = \#\{d : d \mid n, \, 2 \leq d \leq \sqrt{n}\}$$

---

### Proof

**Direction 1**: Factorization ⇒ Divisor

Let (d, k) be a factorization: n = kd + d².

Then:
$$n = kd + d^2 = d(k + d)$$

Thus d divides n.

Moreover, since k ≥ 0, we have k + d ≥ d, so:
$$\frac{n}{d} = k + d \geq d$$

Therefore:
$$d^2 \leq n \quad \Rightarrow \quad d \leq \sqrt{n}$$

Since d ≥ 2 by definition, we have **2 ≤ d ≤ √n** and **d | n**.

---

**Direction 2**: Divisor ⇒ Factorization

Let d be a divisor of n with 2 ≤ d ≤ √n.

Define:
$$k = \frac{n}{d} - d$$

Then:
$$kd + d^2 = d\left(\frac{n}{d} - d\right) + d^2 = n - d^2 + d^2 = n \quad \checkmark$$

We need to verify k ≥ 0:
$$k = \frac{n}{d} - d \geq d - d = 0$$

(using n/d ≥ d, which follows from d² ≤ n).

Also, k is an integer since both n/d and d are integers.

Thus (d, k) is a valid factorization.

---

**Bijection**:

The maps φ: (d,k) ↦ d and ψ: d ↦ (d, n/d - d) are inverses:
- ψ(φ(d,k)) = ψ(d) = (d, n/d - d) = (d, k) ✓
- φ(ψ(d)) = φ(d, n/d - d) = d ✓

Therefore, M(n) = #{d : d|n, 2 ≤ d ≤ √n}. ∎

---

## Closed Form via τ(n)

### Theorem 2 (Explicit Formula)

$$M(n) = \begin{cases}
\left\lfloor \frac{\tau(n)}{2} \right\rfloor & \text{if } n \text{ is a perfect square} \\[0.5em]
\left\lfloor \frac{\tau(n)}{2} \right\rfloor - 1 & \text{otherwise}
\end{cases}$$

Or equivalently:
$$M(n) = \left\lfloor \frac{\tau(n) - 1}{2} \right\rfloor$$

---

### Proof

**Case 1: n is NOT a perfect square**

Divisors come in pairs (d, n/d) where d < n/d (strict inequality).

Let D(n) = set of all divisors.

Since divisors pair up and d=1 is the smallest:
$$\#\{d : d \mid n, \, d < \sqrt{n}\} = \frac{\tau(n) - 1}{2}$$

(We exclude d=1 and count half the remaining divisors)

But we need 2 ≤ d ≤ √n, which excludes d=1:
$$M(n) = \#\{d : 2 \leq d < \sqrt{n}\} = \frac{\tau(n) - 1}{2} - 1 = \frac{\tau(n) - 2}{2}$$

Wait, let me reconsider...

Actually, for non-square n, divisors split into:
- Lower half: d < √n (count = τ(n)/2)
- Upper half: d > √n (count = τ(n)/2)

Among lower half, we exclude d=1:
$$M(n) = \frac{\tau(n)}{2} - 1 = \left\lfloor \frac{\tau(n)}{2} \right\rfloor - 1$$

---

**Case 2: n = m² is a perfect square**

Divisors come in pairs (d, n/d), plus the middle divisor d = √n = m.

- Lower half: d < √n (count = (τ(n)-1)/2)
- Middle: d = √n (count = 1)
- Upper half: d > √n (count = (τ(n)-1)/2)

We need 2 ≤ d ≤ √n, which includes √n but excludes d=1:

If √n ≥ 2 (i.e., n ≥ 4):
$$M(n) = \frac{\tau(n) - 1}{2} = \left\lfloor \frac{\tau(n)}{2} \right\rfloor$$

For n=1: M(1)=0 (no divisors ≥2), τ(1)=1, formula gives ⌊1/2⌋ = 0 ✓

---

**Unified Formula**:

$$M(n) = \left\lfloor \frac{\tau(n) - 1}{2} \right\rfloor$$

This works for both cases:
- Non-square: ⌊(τ-1)/2⌋ = τ/2 - 1 ✓
- Square: ⌊(τ-1)/2⌋ = (τ-1)/2 ✓

∎

---

## Verification Examples

### Example 1: n = 60 (non-square)

**Divisors**: {1, 2, 3, 4, 5, 6, 10, 12, 15, 20, 30, 60}
- τ(60) = 12

**Divisors with 2 ≤ d ≤ √60 ≈ 7.75**:
- {2, 3, 4, 5, 6, 7}
- Wait, 7 ∤ 60, so: {2, 3, 4, 5, 6}
- M(60) = 5

**Formula**:
$$M(60) = \left\lfloor \frac{12 - 1}{2} \right\rfloor = \left\lfloor \frac{11}{2} \right\rfloor = 5 \quad \checkmark$$

---

### Example 2: n = 36 (perfect square, √36 = 6)

**Divisors**: {1, 2, 3, 4, 6, 9, 12, 18, 36}
- τ(36) = 9

**Divisors with 2 ≤ d ≤ 6**:
- {2, 3, 4, 6}
- M(36) = 4

**Formula**:
$$M(36) = \left\lfloor \frac{9 - 1}{2} \right\rfloor = \left\lfloor \frac{8}{2} \right\rfloor = 4 \quad \checkmark$$

---

### Example 3: n = 35 (non-square)

**Divisors**: {1, 5, 7, 35}
- τ(35) = 4

**Divisors with 2 ≤ d ≤ √35 ≈ 5.92**:
- {5}
- M(35) = 1

**Formula**:
$$M(35) = \left\lfloor \frac{4 - 1}{2} \right\rfloor = \left\lfloor \frac{3}{2} \right\rfloor = 1 \quad \checkmark$$

---

### Example 4: n = 9 (perfect square, √9 = 3)

**Divisors**: {1, 3, 9}
- τ(9) = 3

**Divisors with 2 ≤ d ≤ 3**:
- {3}
- M(9) = 1

**Formula**:
$$M(9) = \left\lfloor \frac{3 - 1}{2} \right\rfloor = \left\lfloor \frac{2}{2} \right\rfloor = 1 \quad \checkmark$$

---

### Example 5: n = 4 (perfect square, √4 = 2)

**Divisors**: {1, 2, 4}
- τ(4) = 3

**Divisors with 2 ≤ d ≤ 2**:
- {2}
- M(4) = 1

**Formula**:
$$M(4) = \left\lfloor \frac{3 - 1}{2} \right\rfloor = \left\lfloor \frac{2}{2} \right\rfloor = 1 \quad \checkmark$$

---

## Special Cases

### Primes

For prime p:
- τ(p) = 2 (divisors: {1, p})
- No divisors in range [2, √p] for p ≥ 3
- M(p) = 0

**Formula verification**:
$$M(p) = \left\lfloor \frac{2 - 1}{2} \right\rfloor = \left\lfloor \frac{1}{2} \right\rfloor = 0 \quad \checkmark$$

---

### Prime Powers

For n = p^k:
- Divisors: {1, p, p², ..., p^k}
- τ(p^k) = k + 1

**Divisors with 2 ≤ d ≤ √(p^k) = p^(k/2)**:
- Need p^j ≤ p^(k/2), so j ≤ k/2
- Count: ⌊k/2⌋ divisors (p, p², ..., p^⌊k/2⌋)

**Formula**:
$$M(p^k) = \left\lfloor \frac{k + 1 - 1}{2} \right\rfloor = \left\lfloor \frac{k}{2} \right\rfloor \quad \checkmark$$

---

### Highly Composite Numbers

Numbers with many divisors have large M(n).

**Example**: n = 120 = 2³ · 3 · 5
- τ(120) = 16
- M(120) = ⌊15/2⌋ = 7

**Divisors [2, √120]**: {2, 3, 4, 5, 6, 8, 10} → count = 7 ✓

---

## Connection to Residue Theorem

### Residue Conjecture (Numerically Verified)

$$\lim_{\varepsilon \to 0} \varepsilon^\alpha \cdot F_n(\alpha, \varepsilon) = M(n)$$

where:
$$F_n(\alpha, \varepsilon) = \sum_{d,k} [(n - kd - d^2)^2 + \varepsilon]^{-\alpha}$$

### Combined Result

Since M(n) = ⌊(τ(n)-1)/2⌋, the epsilon-pole residue equals:

$$\text{Residue at } \varepsilon=0 = \left\lfloor \frac{\tau(n) - 1}{2} \right\rfloor$$

This connects:
1. **Analytic structure** (pole at ε=0)
2. **Geometric factorizations** (Primal Forest)
3. **Classical number theory** (divisor function)

**Beautiful trinity!**

---

## Asymptotic Behavior

### Average Order of M(n)

Since τ(n) has average order log n:
$$\sum_{k=1}^n \tau(k) \sim n \log n$$

We have:
$$\sum_{k=1}^n M(k) \sim \sum_{k=1}^n \frac{\tau(k)}{2} \sim \frac{n \log n}{2}$$

Thus:
$$\overline{M}(n) = \frac{1}{n} \sum_{k=1}^n M(k) \sim \frac{\log n}{2}$$

**Average number of factorizations grows logarithmically.**

---

### Maximum Order

Since max τ(n) ≈ n^(log 2/log log n) (highly composite numbers):

$$\max_{k \leq n} M(k) \approx \frac{1}{2} n^{\frac{\log 2}{\log \log n}}$$

Achieved by highly composite numbers.

---

## Computational Complexity

### Computing M(n) via Factorization Count

**Method 1** (Direct):
```
For d = 2 to √n:
  k = (n - d²)/d
  If k is integer and k ≥ 0:
    count++
```
**Complexity**: O(√n)

---

### Computing M(n) via Divisor Function

**Method 2** (Via τ):
1. Compute τ(n) using factorization: O(√n)
2. Apply formula: M(n) = ⌊(τ(n)-1)/2⌋

**Complexity**: O(√n) (same as Method 1)

**No advantage**, but provides verification!

---

### Computing M(n) via Residue (Numerically)

**Method 3** (Epsilon-pole):
1. Compute F_n(α, ε) for small ε ≈ 10⁻³
2. Multiply by ε^α
3. Round to nearest integer

**Complexity**: O(√n · n) = O(n^(3/2)) (much slower!)

**Only useful for verification**, not practical computation.

---

## Numerical Verification Results

### Large-Scale Test (1000 Random Numbers)

**Test Parameters**:
- Sample size: 1000 random integers
- Range: [13, 4996]
- Method: Residue computation with α=3, ε=0.001
- Comparison: M(n) via direct divisor count

**Results**:
```
Total tests:    1000
Successes:      1000
Failures:       0
Success rate:   100.0%

Sample composition:
  Primes:       143 (14.3%)
  Composites:   857 (85.7%)

Performance:
  Total time:   893 seconds
  Per test:     0.89 seconds
  Throughput:   1.12 tests/second
```

**Conclusion**: Residue formula M(n) = ⌊(τ(n)-1)/2⌋ is **verified to 100% accuracy** on all 1000 cases.

---

### Cross-Verification with Divisor Formula

For all 1000 tested numbers, we computed:
1. M₁(n) = count of (d,k) with n = kd + d²
2. M₂(n) = count of divisors d with 2 ≤ d ≤ √n
3. M₃(n) = ⌊(τ(n)-1)/2⌋

**Result**: M₁(n) = M₂(n) = M₃(n) for all 1000 cases.

This **triple verification** confirms:
- Bijection theorem (M₁ = M₂)
- Closed form theorem (M₂ = M₃)
- Residue conjecture (numerically: all match residue)

---

## Perfect Square Degeneracy

### Why Perfect Squares Are Special

For n = m², the divisor m = √n lies exactly on the boundary.

**Non-degenerate case** (n not square):
- Divisors split cleanly: d < √n or d > √n
- No ambiguity

**Degenerate case** (n = m²):
- Divisor m = √n is self-paired: m · m = n
- Must decide: include m or not?

**Our choice**: Include √n in M(n) count (since k=0 is valid).

This gives the unified formula M(n) = ⌊(τ(n)-1)/2⌋.

---

### Connection to Pell Equation

When studying Pell-like structures n = kd + d², perfect squares cause:

**Minimal solution degeneracy**:
- For n = m², the minimal factorization is d = m, k = 0
- This gives n = 0·m + m² = m²
- The "step" k=0 is degenerate (no movement)

**Analogy to Pell equation** x² - Dy² = 1:
- For D = perfect square, Pell equation degenerates
- Fundamental solution becomes trivial
- Similar phenomenon here!

---

## Summary

### Main Results

**Theorem (M-τ Connection)**:
$$M(n) = \#\{d : d \mid n, \, 2 \leq d \leq \sqrt{n}\} = \left\lfloor \frac{\tau(n) - 1}{2} \right\rfloor$$

**Status**:
- **Rigorously proven** (bijection argument)
- **Numerically verified** (100% on 1000 cases)
- **Closed form** (via divisor function)

---

### Implications

1. **M(n) is not a new function** - it's a known divisor count
2. **But the connection to epsilon-poles is NEW**
3. **Links analytic structure to classical number theory**
4. **Provides computational verification method**

---

### Open Questions

1. **Prove residue conjecture rigorously** (currently numerical)
2. **Study extremal values**: which n maximize M(n)/τ(n)?
3. **Multiplicativity**: Is M(mn) related to M(m)·M(n)?
4. **Generating functions**: What is Σ M(n)/n^s?

---

## References

- **Divisor function**: Hardy & Wright, "An Introduction to the Theory of Numbers"
- **Residue theory**: Ahlfors, "Complex Analysis"
- **Numerical verification**: `scripts/test_residue_large_sample_fixed.wl`
- **Bug report**: `docs/bug-report-kmax-scaling.md`

---

**Next Steps**:
1. Formalize residue conjecture proof
2. Study asymptotics of M(n) distribution
3. Explore connections to other arithmetic functions
4. Publish M-τ connection as theorem (not conjecture!)
