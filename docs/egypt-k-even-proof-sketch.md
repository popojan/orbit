# Egypt.wl k=EVEN Pattern - Proof Sketch (by Contradiction)

**Date**: November 16, 2025
**Status**: 🚧 DRAFT PROOF OUTLINE
**Method**: Proof by contradiction

---

## Theorem (Conjectured)

**Claim**: For Pell solutions (x,y) satisfying x² - n·y² = 1 with n prime and n ∤ (x-1), the modular property

```
(x-1)/y · f(x-1, k) ≡ 0 (mod n)
```

holds **if and only if k is even**, where

```
f(x-1, k) = Σ_{j=1}^k term0[x-1, j]
```

and term0 is defined via the factorial recurrence from Egypt.wl.

---

## Proof Strategy (by Contradiction)

### Setup

Given:
- n prime (or square-free non-square)
- (x,y) fundamental Pell solution: x² - n·y² = 1
- Assumption: n ∤ (x-1) [excludes special cases like n=2,7,23]

### Contradiction Approach

**Assume**: k is ODD and the property holds.

**Goal**: Derive a contradiction.

---

## Step 1: Parity Properties

### From Pell Equation

x² - n·y² = 1

**Observation 1**: x² ≡ 1 (mod n)

Proof: x² = n·y² + 1 ≡ 1 (mod n)

Thus: **x ≡ ±1 (mod n)**

**Case split**:
- If x ≡ 1 (mod n): then (x-1) ≡ 0 (mod n) → excluded by assumption
- Thus: **x ≡ -1 (mod n)** for non-special primes

**Observation 2**: x-1 ≡ -2 (mod n)

---

## Step 2: Structure of f(x-1, k)

From Egypt.wl:

```
term0[m, j] = 1 / (1 + Σ_{i=1}^j c_i(m,j))
```

where c_i involves factorials and powers of m.

### Key Property (needs verification):

**Conjecture**: term0[x-1, j] has parity structure depending on j.

Specifically, we conjecture:

```
term0[x-1, 2ℓ] + term0[x-1, 2ℓ+1] ≡ 0 (mod something)
```

(This is the gap in the proof - needs to be derived from factorial formula)

---

## Step 3: Parity of the Sum

If k is ODD, say k = 2m+1, then:

```
f(x-1, k) = Σ_{j=1}^{2m+1} term0[x-1, j]
         = Σ_{ℓ=1}^{m} [term0[x-1, 2ℓ] + term0[x-1, 2ℓ-1]] + term0[x-1, 2m+1]
```

**If pairing cancellation occurs**, the sum has different mod n properties than when k is EVEN.

---

## Step 4: The Contradiction (SKETCH)

**Assume k odd** and property holds:

```
(x-1)/y · f(x-1, k) ≡ 0 (mod n)
```

Since n is prime and n ∤ (x-1) (by assumption), we need:

```
1/y · f(x-1, k) ≡ 0 (mod n)
```

But y and n are coprime (from Pell properties), so:

```
f(x-1, k) ≡ 0 (mod n)
```

**Now**: If k is odd, the sum f(x-1,k) has an "unpaired" term.

**Hypothesis**: This unpaired term is NOT divisible by n, while paired terms cancel mod n.

Thus: f(x-1, k) ≢ 0 (mod n) when k is odd.

**CONTRADICTION!** ⚡

Therefore: **k must be EVEN**.

---

## What's Missing (TO DO)

### 1. Prove Pairing Property

Need to show rigorously that:

```
term0[x-1, 2ℓ] + term0[x-1, 2ℓ-1] ≡ α_ℓ (mod n)
```

where α_ℓ has specific structure (maybe α_ℓ ≡ 0, or forms a telescoping sum).

**Approach**:
- Expand factorial formula for term0
- Use x ≡ -1 (mod n)
- Apply Wilson's theorem: (p-1)! ≡ -1 (mod p)
- Simplify pairwise

### 2. Handle Special Cases

**Special primes** where n | (x-1):
- n = 2: x=3, x-1=2 ≡ 0 (mod 2) ✓
- n = 7: x=8, x-1=7 ≡ 0 (mod 7) ✓
- n = 23: x=24, x-1=23 ≡ 0 (mod 23) ✓

For these: property holds for ALL k (different mechanism).

**Proof needed**: Why these are the ONLY such primes?

Connection: These are primes where fundamental unit has minimal norm.

### 3. Verify Empirically for Larger k

Currently tested up to k=15. Extend to k=100 to increase confidence.

### 4. Connect to Egypt.wl Theory

**From sqrt.pdf**:
- term0 arises from Chebyshev polynomial recurrence
- Connection to √n rationalization via Egyptian fractions
- Modular property might follow from Pell group structure

**Question**: Is there a GROUP THEORETIC reason for k being even?

---

## Alternative Proof Approaches

### Approach 2: Induction on k

**Base case**: k=2 (verify empirically)

**Inductive step**: If property holds for k, does it hold for k+2?

(Skips odd k entirely)

### Approach 3: Generating Function

Define:

```
F(z) = Σ_{k=0}^∞ f(x-1, k) · z^k
```

If F(z) has specific symmetry (e.g., F(-z) = -F(z)), then odd k terms vanish.

### Approach 4: Chebyshev Connection

term0 relates to Chebyshev polynomials T_j.

**Known**: T_j(x) has parity: T_j(-x) = (-1)^j T_j(x)

Since x-1 ≈ -1 for large n (from x ≡ -1 mod n), maybe:

```
term0[x-1, j] ≈ term0[-1, j] · (correction)
```

and parity comes from (-1)^j factor.

---

## Numerical Evidence

From `scripts/egypt_modular_test.py`:

```
n=2: k ∈ {2, 4, 6, 8, ...}      (EVEN)
n=3: k ∈ {6, 12, 18, ...}       (multiples of 6)
n=5: k ∈ {10, 20, 30, ...}      (multiples of 10)
n=6: k ∈ {2, 4, 6, 8, ...}      (EVEN)
n=7: k ∈ {1, 2, 3, 4, ...}      (ALL - special case)
```

**Pattern**: k must be divisible by a certain number depending on n.

**Refined conjecture**: k ≡ 0 (mod period(n)) where period relates to Pell period?

---

## Key Insight for Proof

The PARITY (odd/even) likely comes from:

1. **Pell structure**: x ≡ -1 (mod n) introduces (-1) factors
2. **Factorial cancellations**: Wilson's theorem mod p
3. **Pairing**: Consecutive terms cancel except when k is even

**To prove rigorously**: Need to expand term0 formula explicitly and compute mod n.

---

## References

- `scripts/egypt_modular_test.py` - Empirical verification
- `docs/external/Egypt.wl` - Original Wolfram Language code
- `docs/external/sqrt.pdf` - Theoretical background
- Egypt repository (external) - Full theory

---

## Next Steps

1. **Expand term0 formula** explicitly for small j
2. **Compute mod n** using x ≡ -1 (mod n) and Wilson
3. **Find pairing pattern** in consecutive terms
4. **Complete contradiction argument**
5. **Handle special cases** (n=2,7,23)
6. **Generalize** to composite n if applicable

---

**Current Status**: Proof outline exists, key step (pairing property) needs rigorous derivation.

**Confidence**: 70% that k=EVEN is provable by this method.

**Difficulty**: Medium (requires factorial manipulations and modular arithmetic).

---

**Author**: Claude Code (based on Jan's suggestion: "důkaz sporem")
**Date**: November 16, 2025
