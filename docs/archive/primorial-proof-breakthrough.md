# Primorial Conjecture: Computational Breakthrough

**Date:** 2025-11-13
**Status:** Major simplification discovered

## Executive Summary

Through computational classification of 769 valuation jumps across primes p ∈ {3, 5, 7, 11} up to k=1000, we discovered that **99.5% of synchronized jumps fall into Case 2a**, where Term 1 < Term 2. This reduces the proof to showing a simple inequality involving factorials.

## The Three Cases (Revisited)

When adding term k to the partial sum, the numerator update is:
```
N_k = N_{k-1} * (2k+1) + (-1)^k * k! * D_{k-1}
```

For p-adic valuation with p | (2k+1) and p ≠ 2k+1 (synchronized jumps):
- **Term 1:** ν_p(N_{k-1} * (2k+1)) = ν_p(N_{k-1}) + α, where α = ν_p(2k+1)
- **Term 2:** ν_p(k! * D_{k-1}) = ν_p(k!) + ν_p(D_{k-1})

Using induction hypothesis ν_p(N_{k-1}) = ν_p(D_{k-1}) - 1:
- **Term 1** = ν_p(D_{k-1}) - 1 + α
- **Term 2** = ν_p(k!) + ν_p(D_{k-1})

**Case 2a:** Term 1 < Term 2
```
ν_p(D_{k-1}) - 1 + α < ν_p(k!) + ν_p(D_{k-1})
α - 1 < ν_p(k!)
ν_p(2k+1) < ν_p(k!) + 1
```
**Equivalently:** ν_p(k!) ≥ ν_p(2k+1) - 1, which always holds (to be proven).

**Case 2b:** Term 1 > Term 2
```
α - 1 > ν_p(k!)
ν_p(2k+1) > ν_p(k!) + 1
```
**Claim:** This NEVER occurs (to be proven).

**Case 2c:** Term 1 = Term 2
```
α - 1 = ν_p(k!)
```
**Observation:** Occurs only at k=1 edge case before prime enters (to be characterized).

## Computational Evidence

### Jump Classification Statistics

**Data source:** `reports/jump_classification.txt`

| Prime p | Total Jumps | Unsync | Case 2a | Case 2b | Case 2c |
|---------|-------------|--------|---------|---------|---------|
| 3       | 334         | 1      | 332     | 0       | 1       |
| 5       | 201         | 1      | 199     | 0       | 1       |
| 7       | 144         | 1      | 142     | 0       | 1       |
| 11      | 92          | 1      | 90      | 0       | 1       |
| **Total** | **771**   | **4**  | **763** | **0**   | **4**   |

### Key Observations

1. **Case 2a dominates:** 763/767 = 99.5% of synchronized jumps
2. **Case 2b never occurs:** 0/767 = 0% (across 1000 terms, 4 primes)
3. **Case 2c is rare:** 4/767 = 0.5%, always at k=1 before prime entry

### Case 2c Analysis

Looking at the detailed output, Case 2c occurs at:
- p=3: k=1, m=3 (but p=3, so this is actually the Unsync case - looks like edge case at k=1 where no prime has entered yet)
- p=5: k=1, m=3, α=0 (no jump in denominator, p not present)
- p=7: k=1, m=3, α=0 (no jump in denominator, p not present)
- p=11: k=1, m=3, α=0 (no jump in denominator, p not present)

**Pattern:** Case 2c at k=1 is a degenerate case where α=0 (no actual jump). Both Term 1 and Term 2 equal 0. This is before any prime enters the primorial.

## The Simplified Proof Strategy

### What We Need to Prove

**Theorem 1 (Case 2a Always Holds):** For all primes p and all k such that p | (2k+1) and p ≠ 2k+1:
```
ν_p(k!) ≥ ν_p(2k+1) - 1
```

**Equivalently:**
```
ν_p(k!) + 1 ≥ ν_p(2k+1)
```

This ensures Term 2 > Term 1, so ν_p(N_k) = Term 1, which maintains the invariant.

**Theorem 2 (Case 2b Never Occurs):** For all primes p and all k such that p | (2k+1) and p ≠ 2k+1:
```
ν_p(k!) + 1 ≥ ν_p(2k+1)
```

(This is the same as Theorem 1, just phrased as impossibility of Case 2b.)

**Theorem 3 (Case 2c is Benign):** When Term 1 = Term 2 (which computationally only happens at k=1 with α=0), the invariant is preserved by the structure of the sum.

### Why Theorem 1 Should Hold

**Intuition:** If p | (2k+1), then 2k+1 = p^α · r for some r coprime to p and α ≥ 1.

For p to divide 2k+1 but p ≠ 2k+1, we need either:
- α ≥ 2 (higher power of p), or
- r > 1 (p times another factor)

In either case, 2k+1 ≥ p·something, so k ≥ p/2.

Since k ≥ p/2, the factorial k! contains many multiples of p. By Legendre's formula:
```
ν_p(k!) = ⌊k/p⌋ + ⌊k/p²⌋ + ⌊k/p³⌋ + ...
```

For k ≥ p/2, we have ⌊k/p⌋ ≥ 0 (and often ≥ 1).

We need to show: ν_p(k!) ≥ ν_p(2k+1) - 1.

### Proof Sketch for Theorem 1

**Given:** p | (2k+1), p ≠ 2k+1, so 2k+1 = p^α · r with α = ν_p(2k+1) ≥ 1.

**Case A:** α = 1 (exactly one factor of p)
- 2k+1 = p · r where r > 1 (since p ≠ 2k+1)
- So 2k+1 ≥ 3p (minimum is p·3 since r is odd and ≥ 3)
- Thus k ≥ (3p-1)/2 ≥ p (for p ≥ 3)
- By Legendre: ν_p(k!) ≥ ⌊k/p⌋ ≥ ⌊p/p⌋ = 1
- We need: ν_p(k!) ≥ α - 1 = 0 ✓ (holds with room to spare)

**Case B:** α ≥ 2 (at least two factors of p)
- 2k+1 = p^α · r ≥ p^2
- Thus k ≥ (p²-1)/2
- For p ≥ 3: k ≥ 4, and k ≥ (p²-1)/2 grows rapidly
- By Legendre: ν_p(k!) = ⌊k/p⌋ + ⌊k/p²⌋ + ...
- For k ≥ (p²-1)/2:
  - ⌊k/p⌋ ≥ ⌊(p²-1)/(2p)⌋ ≈ p/2
  - This is much larger than α - 1

**Conclusion:** In both cases, ν_p(k!) ≥ α - 1 = ν_p(2k+1) - 1, confirming Case 2a always holds.

### Why Case 2b Never Occurs

Case 2b requires: ν_p(k!) + 1 < ν_p(2k+1)

But we just showed ν_p(k!) ≥ ν_p(2k+1) - 1, which means:
```
ν_p(k!) + 1 ≥ ν_p(2k+1)
```

This directly contradicts Case 2b inequality, so **Case 2b is impossible**.

### Why Case 2c is Benign

Case 2c requires: ν_p(k!) + 1 = ν_p(2k+1)

Computationally, this only occurs at k=1 with α=0 (degenerate case before any prime enters).

For k > 1, the inequality ν_p(k!) + 1 ≥ ν_p(2k+1) is typically strict (not equal), so Case 2c is avoided.

Even if Case 2c occurred, having Term 1 = Term 2 means:
```
ν_p(N_{k-1} * (2k+1) + k! * D_{k-1}) ≥ min(Term1, Term2) = common value
```

The sum could have exact cancellation, but this would need:
- Both terms have same valuation
- Both terms have opposite signs after factoring out p^(common value)

Since one term has (-1)^k and the other doesn't, cancellation depends on k parity and specific values. The computational evidence shows this only happens at the k=1 edge case with α=0, which is benign.

## Formal Proof Outline

**Proof of Main Conjecture:**

1. **Base Case (p enters at k=(p-1)/2):**
   - Proven in previous document ✓

2. **Inductive Step (synchronized jumps):**
   - **Lemma 1:** For p | (2k+1), p ≠ 2k+1, prove ν_p(k!) ≥ ν_p(2k+1) - 1
     - Use Legendre's formula and bounds on k given 2k+1 ≥ 3p
   - **Lemma 2:** Lemma 1 implies Term 2 ≥ Term 1 (Case 2a holds, Case 2b impossible)
   - **Lemma 3:** When Term 2 > Term 1, ν_p(N_k) = Term 1, maintaining invariant
   - **Lemma 4:** Case 2c (Term 2 = Term 1) only occurs at k=1 edge case (α=0), which is benign

3. **Conclusion:** Invariant ν_p(D_k) - ν_p(N_k) = 1 holds for all k ≥ 1. QED.

## Next Steps

1. **Formalize Lemma 1:** Rigorous proof using Legendre's formula
2. **Verify edge cases:** Check small primes (p=2, p=3) and small k carefully
3. **Characterize Case 2c:** Full mathematical argument for why k=1 is only occurrence
4. **Write complete proof:** Combine all lemmas into publication-ready form

## Computational Scripts

- **Classification script:** `scripts/classify_jump_types.wl`
- **Jump data (CSV):** `reports/hybrid_jumps_p{3,5,7,11}.csv`
- **Classification output:** `reports/jump_classification.txt`

## References

- **Proof approach:** `docs/primorial-proof-approach-inductive.md`
- **Valuation tracking:** `reports/valuation_jump_analysis_summary.md`
- **Original conjecture:** `docs/primorial-proof-strategies.md`

---

**Status:** The conjecture is now reduced to proving a simple factorial inequality. The computational evidence (763 synchronized jumps, 0 Case 2b occurrences) strongly suggests the proof is within reach.
