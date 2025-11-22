# Theoretical Explanation: Why Egypt Converges Monotonically

**Date:** 2025-11-22
**Status:** 🔬 DERIVATION IN PROGRESS

## The Question

**Egypt method:** Monotonic convergence (bounds squeeze from both sides)
**Continued Fraction:** Alternating convergence (oscillates around √n)

**Why this difference?**

---

## Egypt Structure

### Formula
```
r_k = (x-1)/y * (1 + Sum[FactorialTerm[x-1, j], {j, 1, k}])
```

where `FactorialTerm[x, j] > 0` for all x, j.

### Interval Construction
```
Egypt returns: Interval[{r_k, n/r_k}]  (or reversed if r_k > √n)
```

**Key insight:** Both bounds constructed from **same base value** r_k using reciprocal relationship.

---

## Why r_k is Monotonically Increasing

### Observation
```
r_k = (x-1)/y * S_k

where S_k = 1 + Sum[FactorialTerm[x-1, j], {j, 1, k}]
```

### Claim: S_k is monotonically increasing in k

**Proof:**
1. FactorialTerm[x, j] > 0 for all positive x, j
2. S_{k+1} = 1 + Sum[..., {j, 1, k+1}]
         = S_k + FactorialTerm[x-1, k+1]
3. Therefore: S_{k+1} > S_k
4. Since (x-1)/y > 0, we have r_{k+1} > r_k

**QED: r_k increases monotonically** ✓

---

## Why n/r_k is Monotonically Decreasing

### Observation
If r_k increases, then n/r_k decreases (reciprocal relationship).

**Proof:**
1. r_{k+1} > r_k (proven above)
2. n/r_{k+1} < n/r_k (divide both sides by n·r_k·r_{k+1} > 0)

**QED: n/r_k decreases monotonically** ✓

---

## Why Bounds Squeeze √n

### Setup
From Pell equation: x² - ny² = 1

Implies: (x-1)/y ≈ √n when x, y are large.

### Initial Condition
For k=1:
```
r_1 = (x-1)/y * (1 + FactorialTerm[x-1, 1])
    = (x-1)/y * (1 + 1/x)    [from FactorialTerm formula]
    = (x-1)/y + (x-1)/(xy)
    = (x-1)/y * (x+1)/x
```

Need to check: r_1 < √n < n/r_1

**Testing numerically:** For n=13, x=649, y=180:
- r_1 ≈ 3.60554699...
- √13 ≈ 3.60555127...
- n/r_1 ≈ 3.60555555...

Indeed: r_1 < √13 < n/r_1 ✓

### Convergence

**Question:** Do bounds converge to √n?

**Heuristic argument:**
- As k → ∞, Sum[FactorialTerm] converges (factorial series)
- Let S_∞ = lim_{k→∞} S_k
- Then r_∞ = (x-1)/y * S_∞

If r_∞ = √n, then:
```
(x-1)/y * S_∞ = √n
S_∞ = √n * y/(x-1)
```

From Pell: x² - ny² = 1
```
√n = √((x²-1)/y²) = √((x-1)(x+1))/y
```

So:
```
S_∞ = √((x-1)(x+1))/y * y/(x-1)
    = √((x+1)/(x-1))
```

**Verification needed:** Does Sum[FactorialTerm[x-1, j], {j, 1, ∞}] = √((x+1)/(x-1)) - 1?

This is an **ALGEBRAIC IDENTITY QUESTION** about FactorialTerm series.

---

## Continued Fraction Alternation

### CF Formula
```
√n = a_0 + 1/(a_1 + 1/(a_2 + ...))
```

Convergents: p_k/q_k from recursion:
```
p_k = a_k * p_{k-1} + p_{k-2}
q_k = a_k * q_{k-1} + q_{k-2}
```

### Standard Theorem
**Theorem (CF alternation):** For √n, convergents satisfy:
```
p_0/q_0 < p_2/q_2 < p_4/q_4 < ... < √n < ... < p_5/q_5 < p_3/q_3 < p_1/q_1
```

**Proof:** Classical result from CF theory. Based on:
1. (p_k * q_{k-1} - p_{k-1} * q_k) = (-1)^{k+1}
2. Error: |√n - p_k/q_k| = 1/(q_k(q_k + q_{k+1}))
3. Alternating sign in numerator

---

## Fundamental Difference

### Egypt Construction
**Based on:** Additive series S_k = 1 + sum of positive terms
- Each term ADDS to previous
- Monotonic increase guaranteed
- Reciprocal gives monotonic decrease

**Geometric interpretation:**
- Building approximation by **adding** corrections
- Each step: "not there yet, add more"
- Never overshoots, always approaches from below

### CF Construction
**Based on:** Recursive fraction expansion
- Each level: p_k = a_k * p_{k-1} + p_{k-2}
- Sign alternation in error term
- Overshoots and corrects

**Geometric interpretation:**
- Building approximation by **refining** estimate
- Each step: "went too far, come back"
- Alternates above/below target

---

## Open Questions

1. **Egypt convergence rate:** Exponential? Polynomial? How does it compare to CF?

2. **Algebraic identity:** Does FactorialTerm sum have closed form?
   ```
   Sum[FactorialTerm[x, j], {j, 1, ∞}] = ?
   ```

3. **Connection to Chebyshev:** If FactorialTerm ≈ ChebyshevTerm, what does this say about monotonicity?

4. **General characterization:** Are there other sqrt methods with monotonic convergence?

---

## Hypothesis: Why FactorialTerm Series is Monotonic

### Structure
```
FactorialTerm[x, j] = 1 / (1 + Sum[2^(i-1) * x^i * (j+i)! / ((j-i)! * (2i)!), {i,1,j}])
```

All coefficients are **positive** for positive x.

### Key Property
Each term FactorialTerm[x, j] > 0, so partial sums S_k are strictly increasing.

**This is NOT true for alternating series!**

### Contrast with Alternating Series
If we had: Sum[(-1)^j * Term[j]], partial sums would oscillate.

**Egypt uses non-alternating series → monotonic**
**CF inherently alternates → oscillating**

---

## Conclusion (Tentative)

**Egypt is monotonic BECAUSE:**
1. Based on sum of positive terms (FactorialTerm[x,j] > 0)
2. Interval construction uses reciprocal: {r, n/r}
3. Monotone r → monotone decreasing n/r
4. Both converge to √n from opposite sides

**CF alternates BECAUSE:**
1. Based on recursive formula with sign alternation
2. Classical theorem: convergents oscillate
3. Error term has alternating sign

**Fundamental distinction:**
- Egypt: **Additive construction** (sum positive terms)
- CF: **Recursive refinement** (alternate corrections)

---

## Status

✓ Explained why r_k is monotonic (sum of positive terms)
✓ Explained why n/r_k is monotonic (reciprocal)
⏸️ OPEN: Rigorous proof that limits converge to √n
⏸️ OPEN: Closed form for FactorialTerm series sum
⏸️ OPEN: Connection to Chebyshev/hypergeometric

**This explanation is THEORETICAL but not fully rigorous.**

Need to verify:
- Does FactorialTerm series actually converge?
- Is the limit exactly √n?
- What is convergence rate?

---

## Addendum: GammaPalindromicSqrt Behavior

### Relationship to Egypt

`GammaPalindromicSqrt[nn, n, k]` returns:
- k odd: r_k (lower bound)
- k even: nn/r_k (upper bound)

### Convergence Pattern

**Full sequence (k=1,2,3,...):** ALTERNATES around √n
- k=1: below √n
- k=2: above √n
- k=3: below √n
- k=4: above √n

**Subsequences:**
- Odd k: {r_1, r_3, r_5, ...} → MONOTONICALLY INCREASING ↑
- Even k: {nn/r_2, nn/r_4, ...} → MONOTONICALLY DECREASING ↓

### Three-Way Comparison

| Method | Full Sequence | Structure |
|--------|---------------|-----------|
| **Egypt interval** | Both bounds simultaneously | Two monotonic bounds: {r_k ↑, nn/r_k ↓} |
| **GammaPalindromicSqrt** | Alternates | Samples alternately from two monotonic subsequences |
| **Continued Fraction** | Alternates | Single oscillating sequence |

### Key Insight

**GammaPalindromicSqrt is NOT a different method** - it's an **alternating sampler** of Egypt's two monotonic bounds.

**Egypt monotonicity preserved:** Each individual bound (r_k and nn/r_k) is monotonic.

**Alternation introduced:** By sampling them alternately, the full sequence alternates around √n.

**Practical implication:**
- Use `EgyptSqrt` for interval bounds (monotonic squeeze)
- `GammaPalindromicSqrt` provides same values but in alternating pattern
- Both numerically equivalent, different presentation
