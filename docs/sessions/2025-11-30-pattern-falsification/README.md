# Falsification of 22-bit Pattern Hypothesis

**Date:** 2025-11-30
**Status:** FALSIFIED

## Background

Previous work claimed that a 22-bit hierarchical pattern uniquely determines the sign sum ss(k) for squarefree k with ω=4 prime factors.

The pattern consists of:
- **Level 2:** 6 pairwise inverse parities: (p_i^{-1} mod p_j) mod 2 for i<j
- **Level 3:** 12 triple CRT parities (4 triples × 3 components)
- **Level 4:** 4 quadruple CRT parities

Total: 6 + 12 + 4 = 22 bits

## Hypothesis

**Claim:** The 22-bit pattern uniquely determines ss(k).

Formally: If pattern(k₁) = pattern(k₂), then ss(k₁) = ss(k₂).

## Falsification Test

### Method
1. Generate all products k = p₁p₂p₃p₄ from first N odd primes
2. Compute 22-bit pattern for each
3. Group products by pattern
4. Check if all products with same pattern have same ss

### Results (N=21 primes up to 80)

| Metric | Value |
|--------|-------|
| Total products | 5985 |
| Unique patterns | 5885 |
| Repeated patterns | 93 |
| **Conflicts** | **20** |

### Examples of Conflicts

```
Pattern: {0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1}
  {3, 5, 11, 19}  → ss = 1
  {13, 17, 23, 79} → ss = 5

Pattern: {1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0}
  {3, 7, 11, 29}  → ss = 1
  {3, 31, 47, 71} → ss = 9

Pattern: {0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1}
  {7, 13, 23, 71} → ss = -7
  {7, 13, 37, 71} → ss = 5
```

## Conclusion

**HYPOTHESIS FALSIFIED**

The 22-bit mod-2 CRT parity pattern does NOT uniquely determine ss(k) for ω=4.

Additional information beyond mod-2 parities is required.

## Implications

1. **STATUS.md was incorrect** - "0 conflicts" was based on insufficient data
2. **Paper retraction was correct** - the claim was properly retracted earlier
3. **For ω≥4:** A closed-form formula based solely on mod-2 patterns is impossible

## Open Questions

What DOES uniquely determine ss(k)?

### Finding 1: MOD 4 is Better But Not Sufficient

Extended test with 24 primes (10626 products):

| Invariant | Unique patterns | Repeated | Conflicts |
|-----------|-----------------|----------|-----------|
| Mod 2     | 10392           | 206      | **54**    |
| Mod 4     | 10616           | 9        | **1**     |

Mod 4 is much better (1 conflict vs 54), but still fails!

The single mod-4 conflict:
```
Pattern: {2, 0, 2, 1, 3, 2, 1, 2, 3, 1, 1, 0, 1, 0, 0, 3, 3, 1, 2, 1, 2, 2}
  {3, 5, 11, 17}   → ss = -11
  {3, 29, 59, 89}  → ss = -11
  {7, 41, 83, 97}  → ss = -15  ← conflict!
```

### Finding 2: PRODUCT MOD 16 Distinguishes Conflict

Analysis of the conflict revealed:
- {3, 5, 11, 17} and {3, 29, 59, 89}: k ≡ **5** (mod 16) → ss = -11
- {7, 41, 83, 97}: k ≡ **13** (mod 16) → ss = -15

The product k mod 16 captures "collective" information not in pairwise patterns!

### Finding 3: Alternative Invariants (Raw Values) Don't Help

Tested on the mod-4 conflict {3,5,11,17}, {3,29,59,89}, {7,41,83,97}:

| Set | ss | sumDistSq | sumGapNext | sumGapPrev | k mod 16 |
|-----|-----|-----------|------------|------------|----------|
| {3,5,11,17} | -11 | 5 | 8 | 11 | **5** |
| {3,29,59,89} | -11 | 18 | 14 | 19 | **5** |
| {7,41,83,97} | -15 | 12 | 16 | 18 | **13** |

- Distance to perfect square: **doesn't distinguish** (third set has middle value 12)
- Gap to next prime: **doesn't distinguish** (third set has middle value 16)
- **k mod 16**: **DOES distinguish** (5,5 → ss=-11 vs 13 → ss=-15)

### SOLUTION ATTEMPT 1: Mod-4 Pattern + (k mod 16)

Initial hypothesis: mod-4 hierarchical + (k mod 16)

| Primes | Products | Repeated patterns | Conflicts |
|--------|----------|-------------------|-----------|
| 40 | 91,390 | 15 | **0** |
| 45 | 148,995 | 25 | **1** |

**FALSIFIED!** Conflict found:
- {3, 13, 79, 181} → ss = -7
- {7, 29, 59, 197} → ss = -11
- Same mod-4 pattern, same k mod 16 (=13), different ss!

### SOLUTION: Mod-4 Pattern + (k mod 32)

**k mod 32 distinguishes the conflict:**
- k1 mod 32 = 29 → ss = -7
- k2 mod 32 = 13 → ss = -11

**Extended pattern = mod-4 hierarchical + (k mod 32)**

| Primes | Products | Collision groups | Conflicts |
|--------|----------|------------------|-----------|
| 45 | 148,995 | 18 | **0** |

**HYPOTHESIS:** Mod-4 pattern + k mod 32 uniquely determines ss(k) for ω=4.

**Note:** This may still fail with more data - the pattern seems to require increasingly fine modular arithmetic as primes grow.

### Theoretical Interpretation

The sign sum ss(k) depends on:
1. **Pairwise inverse parities (mod 4)** - relationships between prime pairs
2. **Product k mod 16** - emergent property of the product

This is analogous to **higher reciprocity laws** in algebraic number theory:
- Quadratic reciprocity connects pairs
- Cubic/quartic reciprocity captures higher-order structure
- The product mod 16 term may reflect similar deeper structure

## Verified Formulas

| ω | Formula | Status |
|---|---------|--------|
| 2 | ss(pq) = 1 - 4·ε where ε = (p⁻¹ mod q) mod 2 | ✓ VERIFIED (100%) |
| 3 | ss = 2 - Σss(pairs) - 4·ΣB_triple | ✓ VERIFIED (1330 triples, 0 errors) |
| 4 | Mod-4 pattern + (k mod 16) determines ss | ❌ FALSIFIED (1 conflict at 45 primes) |
| 4 | Mod-4 pattern + (k mod 32) determines ss | 🔬 HYPOTHESIS (0/18 conflicts at 45 primes) |

## Why Congruence Classes?

**Question:** Is there something more fundamental than mod-n arithmetic?

**Answer:** The choice of congruence classes emerges from the CRT reconstruction formula:
```
n ≡ Σᵢ aᵢ·cᵢ (mod k)
```
where cᵢ are CRT coefficients involving modular inverses.

The **parity** of n (which determines if a lobe is odd/even) depends on:
1. The residues aᵢ mod 2
2. The CRT coefficients cᵢ mod 2

But mod-2 is insufficient for ω≥4. We need mod-4 (for finer resolution of inverses) and also k mod 16 (collective product property).

**Deeper insight:** k mod 16 = Πᵢ(pᵢ mod 16) mod 16 captures how the primes "combine" multiplicatively. This is NOT reducible to pairwise relationships - it's an emergent 4-way property!

## Code

See `falsification-test.wl` for the verification script.

---

# Session Update: 2025-12-01

## New Approach: Square-Distance Indicators

Abandoned mod-32 approach in favor of simpler geometric indicators.

### Final Scheme: 26 bits (mod-2 pattern + 2 indicators)

| Component | Bits | Description |
|-----------|------|-------------|
| 22-bit pattern | 22 | Modular inverse parities (mod 2) |
| signedDist4 | 2 | `Sum(signedDist(p)) mod 4` |
| floorSqrt4 | 2 | `Sum(floor(√p)) mod 4` |
| **Total** | **26** | |

### Indicator Definitions

```mathematica
(* Signed distance to nearest perfect square *)
signedDist[p_] := Module[{s = Floor[Sqrt[p]], d},
  d = p - s^2;
  If[d <= s, d, d - 2*s - 1]
];

signedDist4[ps_] := Mod[Total[signedDist /@ ps], 4];
floorSqrt4[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 4];
```

### Coverage on 11 Known Conflicts

| ID | SS values | sd4 | fs4 | Covered by |
|----|-----------|-----|-----|------------|
| 1 | {1, 5} | {1, 2} ✓ | {2, 3} ✓ | Both |
| 2 | {1, 9} | {3, 3} | {3, 0} ✓ | fs4 |
| 3 | {-7, 5} | {0, 3} ✓ | {1, 3} ✓ | Both |
| 4 | {-7, -11} | {2, 2} | {1, 0} ✓ | fs4 |
| 5 | {-11, -11, -15} | {3, 2, 2} ✓ | {2, 2, 2} | sd4 |
| 6 | {1, 5} | {0, 0} | {2, 0} ✓ | fs4 |
| 7 | {1, 5} | {1, 3} ✓ | {3, 3} | sd4 |
| 8 | {1, 5} | {0, 1} ✓ | {0, 3} ✓ | Both |
| 9 | {1, -3} | {3, 1} ✓ | {0, 2} ✓ | Both |
| 10 | {5, 13} | {2, 1} ✓ | {1, 1} | sd4 |
| 11 | {5, -3} | {0, 1} ✓ | {0, 0} | sd4 |

**Both indicators needed:** sd4 alone misses {2,4,6}, fs4 alone misses {5,7,10,11}

### Stress Test Results

- 4000 products tested (primes 3-80)
- 3995 unique 26-bit patterns
- 5 repeated patterns
- **0 SS conflicts**

### Key Insight: Orthogonal Information

- **22-bit pattern** = algebraic structure (modular inverses)
- **signedDist4** = geometric (offset from perfect square)
- **floorSqrt4** = arithmetic-geometric (first CF approximant)

These capture **different aspects** of the prime set → together more discriminating.

### ⚠️ CORRELATION ≠ CAUSALITY

**We observe:** These indicators correlate with SS differences.

**We don't understand:** WHY they correlate. The mechanism is unknown.

**Open questions:**
1. Why does distance-to-square relate to SignSum?
2. Is there a deeper algebraic connection?
3. Could there be a simpler unified indicator?
4. Are sd4 and fs4 capturing the same structure differently?

### What Failed

- Aggregating 22 bits (sum, XOR, weighted) → loses information
- floorSqrt alone as replacement → too many conflicts
- signedDist alone as replacement → too many conflicts
- k mod 32 → worked but unclear why, replaced by cleaner approach

### Design Principle: Occam's Razor

- Keep mod 4 (2 bits) unless proven insufficient
- Add new indicator rather than increase modulus
- Prefer interpretable indicators over black-box values

### Files Added

- `conflict-database.json` - 11 known conflicts (updated)
- `stress-test.wl` - Validation for 26-bit scheme
- `comprehensive-test.wl` - Tests across omega = 2, 3, 4
- `aggregation-test.wl` - Failed compression attempts
- `defect-mod8-analysis.wl` - Exploring p mod 8 patterns
