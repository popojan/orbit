# Inductive Proof Attempt: TOTAL-EVEN Divisibility (All k)

**Date**: November 19, 2025
**Goal**: Prove $(x+1) \mid \text{Num}(S_k) \iff (k+1)$ EVEN for **all** k ≥ 1

---

## Current Status

**Proven rigorously:**
- ✅ Base case (k=1): S₁ = (x+1)/x
- ✅ Chebyshev identity: T_m(x) + T_{m+1}(x) = (x+1)·P_m(x)
- ✅ Pair sum: term(2m) + term(2m+1) = (x+1)/poly_m
- ✅ Symbolic computation for k ∈ {1,...,8}

**Not yet proven:**
- ❌ General case for all k (extrapolation from k ≤ 8)

---

## Strategy: Induction on Pairs

### Observation from Structure

For **EVEN total** (k odd, k = 2m+1):
```
S_{2m+1} = 1 + term(1) + [term(2)+term(3)] + [term(4)+term(5)] + ... + [term(2m)+term(2m+1)]
         = S_1 + ∑_{i=1}^m [term(2i) + term(2i+1)]
```

From Lemma 1: S₁ = (x+1)/x
From Lemma 3: Each pair = (x+1)/poly_i

Therefore:
```
S_{2m+1} = (x+1)/x + (x+1)/poly_1 + ... + (x+1)/poly_m
         = (x+1) · [1/x + 1/poly_1 + ... + 1/poly_m]
```

### Critical Question

**When we add fractions with (x+1) in numerator, does (x+1) remain in the numerator after reduction to lowest terms?**

Answer: **YES if and only if (x+1) does NOT divide the common denominator after reduction.**

---

## Proof Attempt 1: Direct Factorization

### Claim
For S_{2m+1} = (x+1) · [1/x + 1/poly_1 + ... + 1/poly_m], the sum in brackets does NOT have (x+1) in its denominator after reduction.

### Why this might work

From the table (k ≤ 8):
- k=1 (m=0): Num = (x+1)¹, power = 1
- k=3 (m=1): Num = 2x(x+1)¹, power = 1
- k=5 (m=2): Num = (x+1)¹(-1+2x)(1+2x), power = 1
- k=7 (m=3): Num = 4x(x+1)¹(-1+2x²), power = 1

**Pattern**: Power of (x+1) is **exactly 1** for all even totals.

This suggests that (x+1) does NOT cancel with the denominator.

### Obstacle

**Need to prove**: For all m ≥ 0, when computing
```
Q_m/R_m = 1/x + 1/poly_1(x) + ... + 1/poly_m(x)
```
in lowest terms, we have (x+1) ∤ R_m.

This requires knowing the structure of poly_i(x) for all i.

---

## Proof Attempt 2: Induction on m (Even Totals)

### Base Case (m=0, k=1)
S₁ = (x+1)/x ✓
Numerator = (x+1)¹ · 1 (exactly one factor of (x+1))

### Inductive Hypothesis
Assume for k = 2m-1:
```
Num(S_{2m-1}) = (x+1) · A_{2m-1}
```
where (x+1) ∤ A_{2m-1} (power is exactly 1).

### Inductive Step
For k = 2m+1:
```
S_{2m+1} = S_{2m-1} + [term(2m) + term(2m+1)]
         = (x+1)·A_{2m-1}/D_{2m-1} + (x+1)/poly_m
         = (x+1) · [A_{2m-1}·poly_m + D_{2m-1}] / [D_{2m-1}·poly_m]
```

**Need to show**: (x+1) ∤ [A_{2m-1}·poly_m + D_{2m-1}]

### Problem

This requires detailed knowledge of:
1. poly_m structure (depends on Chebyshev recursion)
2. Cancellation behavior between numerator and denominator

Without explicit formulas for poly_m, this is blocked.

---

## Proof Attempt 3: Induction on k (All Cases)

### Strategy
Prove two statements simultaneously:
- P(k): If (k+1) EVEN, then (x+1)¹ ∥ Num(S_k) (exactly divides once)
- Q(k): If (k+1) ODD, then (x+1) ∤ Num(S_k)

### Base Cases
- P(1): S₁ = (x+1)/x ✓
- Q(0): S₀ = 1 (no (x+1) factor) ✓

### Inductive Step
**Case 1**: k+1 EVEN (so k odd), assume Q(k-1) holds
```
S_k = S_{k-1} + term(k)
    = A/B + term(k)  [where (x+1) ∤ A by Q(k-1)]
```

Need to show: (x+1) | Num(S_k) after reduction.

**Case 2**: k+1 ODD (so k even), assume P(k-1) holds
```
S_k = S_{k-1} + term(k)
    = (x+1)·A/B + term(k)  [where (x+1) ∤ A by P(k-1)]
```

Need to show: (x+1) ∤ Num(S_k) after reduction.

### Obstacle

Both cases require understanding how term(k) interacts with S_{k-1}.

term(k) = 1 / [T_{⌈k/2⌉}(x) · ΔU_k(x)]

The Chebyshev polynomials T and ΔU have complex structure depending on k being even/odd.

**Critical missing piece**: Explicit formula for how (x+1) appears (or doesn't) in T_n(x) and ΔU_n(x).

---

## Why k ≤ 8 Works but General Proof is Hard

**Symbolic computation** for specific k:
- Wolfram can expand all terms explicitly
- Factor the numerator completely
- Count power of (x+1) exactly

**General proof** requires:
- Understanding Chebyshev polynomial structure modulo (x+1)
- Tracking (x+1) factors through all recursive additions
- Proving NO cancellation occurs in specific pattern

---

## Alternative Approaches to Consider

### Approach 4: Modular Arithmetic
Work modulo (x+1) throughout:
- Show S_k ≡ 0 (mod x+1) for even total
- Show S_k ≢ 0 (mod x+1) for odd total

This might avoid explicit factorization.

### Approach 5: Generating Functions
Define F(z) = ∑_{k≥1} S_k · z^k and look for functional equation.

### Approach 6: Chebyshev Recurrence Properties
Use known properties of T_n(-1) and U_n(-1) evaluated at x+1=0.

---

## Current Status: Blocked

**Time spent**: ~30 minutes
**Result**: No complete proof found yet

**Options**:
1. ✅ Continue attempting (try modular arithmetic approach)
2. ⚠️ Acknowledge limitation in documentation
3. 🔬 Numerical verification to higher k as evidence

**Recommendation**: Try Approach 4 (modular arithmetic) for 30 more minutes. If unsuccessful, clearly document as "PROVEN for k ≤ 8, CONJECTURED generally with strong evidence."

---

**Next**: Attempt modular arithmetic proof...
