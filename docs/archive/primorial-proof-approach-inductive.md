# Primorial Conjecture: Inductive Proof Approach

**Date:** 2025-11-13
**Status:** Active investigation

## Conjecture Statement

For the primorial sum formula:
```
S_m = (1/2) * Σ_{k=1}^{⌊(m-1)/2⌋} [(-1)^k * k! / (2k+1)]
```

Writing S_m = N_m / D_m in **unreduced** form (not in lowest terms), for all primes p ≤ m:
```
ν_p(D_m) - ν_p(N_m) = 1
```

where ν_p(n) denotes the p-adic valuation (exponent of p in prime factorization).

## Computational Verification

**Verified for:**
- Primes p ∈ {3, 5, 7, 11}
- Up to k = 1000 terms
- Total jumps analyzed: 769 across all primes
- **Result:** ALL jumps maintain Diff = ν_p(D) - ν_p(N) = 1 ✓

**Data files:**
- `reports/hybrid_jumps_p3.csv` (334 jumps)
- `reports/hybrid_jumps_p5.csv` (200 jumps)
- `reports/hybrid_jumps_p7.csv` (144 jumps)
- `reports/hybrid_jumps_p11.csv` (91 jumps)

## Key Insight: Synchronized vs. Unsynchronized Jumps

### Observation

When adding the k-th term to the partial sum, one of two things happens:

1. **Unsynchronized jump** (p enters for first time): ν_p(D) increases but ν_p(N) stays at 0
   - This occurs **if and only if** p = 2k+1
   - Establishes the initial difference: ν_p(D) = 1, ν_p(N) = 0

2. **Synchronized jump** (p already present): Both ν_p(D) and ν_p(N) increase by the same amount Δ
   - This occurs when p | (2k+1) but p ≠ 2k+1
   - Maintains the difference: ν_p(D) - ν_p(N) = 1

**Reformulation:** To prove the conjecture, show that adding term k produces an unsynchronized jump iff p = 2k+1, otherwise jumps are synchronized.

## The Recurrence Structure

### Unreduced Recurrence Formulas

From the partial sum S_k = S_{k-1} + (-1)^k * k! / (2k+1), we have:

**Denominator (simple):**
```
D_k = D_{k-1} * (2k+1)
```

**Numerator (more complex):**
```
N_k = N_{k-1} * (2k+1) + (-1)^k * k! * D_{k-1}
```

### P-adic Valuation Analysis

**Denominator valuation:**
```
ν_p(D_k) = ν_p(D_{k-1}) + ν_p(2k+1)
```
This is straightforward - the jump size Δ_D = ν_p(2k+1).

**Numerator valuation (the subtle part):**
```
ν_p(N_k) = ν_p(N_{k-1} * (2k+1) + (-1)^k * k! * D_{k-1})
```

The numerator is a **sum of two terms**:
- **Term 1:** N_{k-1} * (2k+1) with valuation ν_p(N_{k-1}) + ν_p(2k+1)
- **Term 2:** (-1)^k * k! * D_{k-1} with valuation ν_p(k!) + ν_p(D_{k-1})

For valuation of sums: ν_p(A + B) ≥ min(ν_p(A), ν_p(B)), with equality when ν_p(A) ≠ ν_p(B).

## Proof Strategy

### Base Case: Prime Entry (p = 2k+1)

When prime p enters the denominator for the first time at k = (p-1)/2:

**Given:**
- p = 2k+1 (prime)
- ν_p(D_{k-1}) = 0 (p not yet in denominator)
- ν_p(N_{k-1}) = 0 (p not yet in numerator)
- k < p, so k! contains no factors of p, thus ν_p(k!) = 0

**Analysis:**
```
ν_p(D_k) = 0 + ν_p(p) = 1

Term 1: ν_p(N_{k-1} * (2k+1)) = 0 + 1 = 1
Term 2: ν_p(k! * D_{k-1}) = 0 + 0 = 0
```

Since Term 1 and Term 2 have different valuations (1 vs. 0):
```
ν_p(N_k) = min(1, 0) = 0
```

**Result:** ν_p(D_k) - ν_p(N_k) = 1 - 0 = 1 ✓

This establishes the initial difference.

### Inductive Step: Synchronized Jumps (p ≠ 2k+1)

**Induction Hypothesis:** Assume ν_p(D_{k-1}) - ν_p(N_{k-1}) = 1 for all k' < k.

**Given:**
- p | (2k+1) with ν_p(2k+1) = α ≥ 1
- p ≠ 2k+1 (so p is already in the primorial)
- By hypothesis: ν_p(N_{k-1}) = ν_p(D_{k-1}) - 1

**Goal:** Show ν_p(D_k) - ν_p(N_k) = 1.

**Analysis:**
```
ν_p(D_k) = ν_p(D_{k-1}) + α

Term 1: ν_p(N_{k-1} * (2k+1)) = ν_p(N_{k-1}) + α
                                = (ν_p(D_{k-1}) - 1) + α

Term 2: ν_p(k! * D_{k-1}) = ν_p(k!) + ν_p(D_{k-1})
```

**Key Question:** When are Term 1 and Term 2 different, ensuring ν_p(N_k) = min(Term 1, Term 2)?

**Case 2a: Term 1 < Term 2**
```
(ν_p(D_{k-1}) - 1) + α < ν_p(k!) + ν_p(D_{k-1})
α - 1 < ν_p(k!)
```

If this holds, then:
```
ν_p(N_k) = Term 1 = (ν_p(D_{k-1}) - 1) + α
ν_p(D_k) - ν_p(N_k) = [ν_p(D_{k-1}) + α] - [(ν_p(D_{k-1}) - 1) + α]
                     = 1 ✓
```

**Case 2b: Term 1 > Term 2**
```
α - 1 > ν_p(k!)
```

If this holds, then:
```
ν_p(N_k) = Term 2 = ν_p(k!) + ν_p(D_{k-1})
ν_p(D_k) - ν_p(N_k) = [ν_p(D_{k-1}) + α] - [ν_p(k!) + ν_p(D_{k-1})]
                     = α - ν_p(k!)
```

For the invariant to hold, we need: α - ν_p(k!) = 1, or **ν_p(k!) = α - 1 = ν_p(2k+1) - 1**.

**Case 2c: Term 1 = Term 2** (exact cancellation possible)
```
α - 1 = ν_p(k!)
```

This is the critical case. If the two terms have **equal** p-adic valuation, partial or complete cancellation can occur, potentially disrupting the invariant.

## Open Questions

1. **Which case dominates?** Are most synchronized jumps explained by Case 2a (Term 1 < Term 2)?

2. **Does Case 2b require ν_p(k!) = α - 1?** If so, is this relationship always satisfied?

3. **Can Case 2c (equal valuations) occur?** If so, does cancellation preserve the invariant?

4. **Connection to Legendre's formula:** Can we bound ν_p(k!) using ν_p(k!) = Σ⌊k/p^i⌋?

5. **Factorial growth vs. jump frequency:** As k increases, ν_p(k!) grows. Does this ensure Term 2 > Term 1 eventually?

## Next Computational Steps

1. **Analyze jump mechanism:** For each jump, compute Term 1 and Term 2 valuations explicitly
2. **Classify jumps:** Count how many fall into Case 2a, 2b, 2c
3. **Test factorial relationship:** Check if ν_p(k!) = ν_p(2k+1) - 1 holds when needed
4. **Boundary analysis:** Study the transition between cases as k grows

## Implementation Notes

The hybrid recurrence `{n, a, {b_num, b_den}}` efficiently tracks unreduced values:
- `a` is reduced (previous sum as rational)
- `{b_num, b_den}` keeps current sum unreduced for valuation tracking
- Verified against Orbit paclet for k ≤ 1000 ✓

**Script:** `scripts/hybrid_unreduced_recurrence.wl`

---

**Status:** The base case is proven. The inductive step requires understanding which of Cases 2a/2b/2c dominate and whether the necessary relationships (like ν_p(k!) = α - 1) always hold.
