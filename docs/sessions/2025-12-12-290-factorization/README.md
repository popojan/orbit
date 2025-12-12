# 290-Theorem: Factorization Structure Analysis

**Date:** 2025-12-12
**Status:** Research direction (unexplored in literature)
**Priority:** Exploratory — interesting patterns, unclear if deep

---

## Motivation

The 29 critical integers of the 290-theorem have interesting factorization patterns that don't appear to be systematically analyzed in published work.

---

## Known Constraints (from escalation method)

1. **All squarefree** — if form represents n, represents n×k²
2. **None ≡ 0 (mod 4)** — if form represents n, represents 4n

---

## Observed Patterns (to investigate)

### Prime Factor Frequency

| Prime | Count | Numbers |
|-------|-------|---------|
| **2** | 12/29 | 2,6,10,14,22,26,30,34,42,58,110,290 |
| **5** | 8/29 | 5,10,15,30,35,110,145,290 |
| **3** | 7/29 | 3,6,15,21,30,42,93 |
| **7** | 6/29 | 7,14,21,35,42,203 |
| **29** | 5/29 | 29,58,145,203,290 |

**Question:** Why are 2 and 5 most frequent? Connection to base 10? Or to escalator lattice structure?

### The Prime 29

Appears in 5 critical integers including 290 = 2 × 5 × 29.

**Question:** Is 29 special because it's the count of critical integers? Or because of lattice geometry?

### Fibonacci Numbers

Seven Fibonacci numbers in the set: {1, 2, 3, 5, 13, 21, 34}

**Question:** Coincidence or connection to golden ratio / lattice packing?

### Missing Structures

- No prime powers (except trivial p¹)
- No numbers ≡ 0 (mod 4)
- Gap between 42 and 58 (no 43-57)
- Large gaps: 58→93, 93→110, 145→203, 203→290

---

## Research Questions

1. **Why these specific primes?** Can we predict from escalator lattice theory which primes will appear?

2. **γ-framework connection?** Our observation: 5n-8 and 7n-8 hit 31% of critical integers. Is this meaningful?

3. **Relation to lattice dimension?** Truants appear at different escalator dimensions. Does factorization correlate with dimension?

4. **Closed formula?** Is there a generating function or characterization beyond enumeration?

---

## Approach

1. Read Bhargava-Hanke paper closely for escalator construction details
2. Correlate factorization with escalator dimension
3. Test γ-framework hypotheses computationally
4. Search for invariants that distinguish critical from non-critical squarefree numbers

---

## Related

- [290-Theorem](../../learning/290-theorem.md) — main theorem
- [290 Connection Speculation](../2025-12-12-lp-fft-exploration/290-connection-speculation.md) — γ-framework hits
- [Small Numbers Conjecture](../2025-12-12-vymazalova-reflections/small-numbers-conjecture.md) — philosophy
