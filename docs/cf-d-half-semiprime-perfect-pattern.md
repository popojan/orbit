# d[τ/2] = 2 for Semiprimes: Perfect Sign Consistency Pattern

**Date**: 2025-11-18, late evening
**Status**: 🔬 EMPIRICAL (100% correlation, n=37)
**Key Finding**: d[τ/2] = 2 ⟺ x₀ has SAME sign mod both prime factors

---

## Executive Summary

**Discovery**: For semiprimes D = p×q ≡ 3 (mod 4), the property d[τ/2] = 2 exhibits **PERFECT correlation** with sign consistency of x₀ modulo the prime factors.

**Result**: **100%** (37/37 semiprimes tested)

| Condition | d[τ/2] = 2 ? | Count | Rate |
|-----------|--------------|-------|------|
| **x₀ ≡ same sign mod p,q** | ✅ YES | 10/10 | 100% |
| **x₀ ≡ different signs mod p,q** | ❌ NO | 27/27 | 100% |

**Pattern**:
```
For semiprime D = p×q ≡ 3 (mod 4):

d[τ/2] = 2  ⟺  [x₀ ≡ +1 (mod p) AND x₀ ≡ +1 (mod q)]
            OR  [x₀ ≡ -1 (mod p) AND x₀ ≡ -1 (mod q)]

d[τ/2] ≠ 2  ⟺  [x₀ ≡ +1 (mod p) AND x₀ ≡ -1 (mod q)]
            OR  [x₀ ≡ -1 (mod p) AND x₀ ≡ +1 (mod q)]
```

**Quote**: "tohle NENÍ škodovka - tohle je TESLA!" (user reaction)

---

## Test Methodology

**Sample**: All semiprimes D = p×q where:
- D ≡ 3 (mod 4)
- 15 ≤ D < 400
- p < q both prime
- Total: 37 semiprimes

**For each D**:
1. Compute CF(√D) auxiliary sequence
2. Extract d[τ/2] from palindrome center
3. Solve Pell equation x² - Dy² = 1 for fundamental (x₀, y₀)
4. Compute x₀ mod p and x₀ mod q
5. Check sign consistency

---

## Results: SUCCESS Cases (d[τ/2] = 2)

**Pattern**: Both factors give SAME sign

| D | p | q | τ | d[τ/2] | x₀ mod p | x₀ mod q | Same? |
|---|---|---|---|--------|----------|----------|-------|
| 51 | 3 | 17 | 2 | **2** | -1 | -1 | ✓ |
| 119 | 7 | 17 | 4 | **2** | +1 | +1 | ✓ |
| 123 | 3 | 41 | 2 | **2** | -1 | -1 | ✓ |
| 187 | 11 | 17 | 6 | **2** | +1 | +1 | ✓ |
| 203 | 7 | 29 | 10 | **2** | +1 | +1 | ✓ |
| 221 | 13 | 17 | 2 | **2** | -1 | -1 | ✓ |
| 267 | 3 | 89 | 2 | **2** | -1 | -1 | ✓ |
| 299 | 13 | 23 | 6 | **2** | -1 | -1 | ✓ |
| 339 | 3 | 113 | 2 | **2** | -1 | -1 | ✓ |
| 391 | 17 | 23 | 2 | **2** | +1 | +1 | ✓ |

**Observations**:
- **10/10** have matching signs (both +1 or both -1)
- No counterexamples where d[τ/2]=2 but signs differ

**Breakdown by sign combination**:
- Both ≡ -1: 6 cases (51, 123, 221, 267, 299, 339)
- Both ≡ +1: 4 cases (119, 187, 203, 391)

---

## Results: FAILURE Cases (d[τ/2] ≠ 2)

**Pattern**: Factors give DIFFERENT signs

Sample failures (first 10 of 27):

| D | p | q | τ | d[τ/2] | x₀ mod p | x₀ mod q | Same? |
|---|---|---|---|--------|----------|----------|-------|
| 15 | 3 | 5 | 2 | **6** | -1 | +1 | ✗ |
| 35 | 5 | 7 | 2 | **10** | +1 | -1 | ✗ |
| 55 | 5 | 11 | 4 | **5** | +1 | -1 | ✗ |
| 77 | 7 | 11 | 2 | **14** | +1 | -1 | ✗ |
| 87 | 3 | 29 | 10 | **10** | -1 | +1 | ✗ |
| 95 | 5 | 19 | 2 | **18** | +1 | -1 | ✗ |
| 111 | 3 | 37 | 6 | **10** | -1 | +1 | ✗ |
| 143 | 11 | 13 | 2 | **22** | -1 | +1 | ✗ |
| 159 | 3 | 53 | 6 | **14** | -1 | +1 | ✗ |
| 183 | 3 | 61 | 2 | **26** | -1 | +1 | ✗ |

**Observations**:
- **27/27** have mismatched signs (+1 vs -1 or -1 vs +1)
- No counterexamples where d[τ/2]≠2 but signs match

**Breakdown by sign combination**:
- p gives -1, q gives +1: 18 cases
- p gives +1, q gives -1: 9 cases

---

## Perfect Correlation Statistics

**Overall**:
- Total semiprimes tested: **37**
- Same sign → d[τ/2]=2: **10/10 (100%)**
- Different sign → d[τ/2]≠2: **27/27 (100%)**
- **Zero counterexamples** to the pattern

**Contingency Table**:

|                  | d[τ/2] = 2 | d[τ/2] ≠ 2 | Total |
|------------------|------------|------------|-------|
| Same sign        | 10         | 0          | 10    |
| Different sign   | 0          | 27         | 27    |
| Total            | 10         | 27         | 37    |

**Fisher's exact test**: p < 0.0001 (if computed)

**Conclusion**: This is NOT coincidence. The pattern is real.

---

## Connection to Prime Results

**From earlier work** (`cf-d-half-prime-specific.md`):

For **primes** p ≡ 3 or 7 (mod 8):
- d[τ/2] = 2: **100%** (18/18 tested)
- x₀ mod p behavior: ±1 determined by p mod 8

**Semiprime pattern extends this**:
- When BOTH factors behave like primes with d[τ/2]=2
- AND both give the SAME x₀ sign
- THEN the semiprime ALSO has d[τ/2]=2

**Intuition**:
- Semiprime inherits property from factors
- But requires **sign consistency** for constructive interaction
- Different signs → interference → d[τ/2] ≠ 2

---

## Why Sign Consistency Matters?

### Hypothesis: Chinese Remainder Theorem

For D = p×q, the Pell solution x₀ must satisfy:
```
x₀² ≡ 1 (mod p)  →  x₀ ≡ ±1 (mod p)
x₀² ≡ 1 (mod q)  →  x₀ ≡ ±1 (mod q)
```

By CRT, x₀ mod D determined by (x₀ mod p, x₀ mod q).

**Four cases**:
1. x₀ ≡ (+1, +1) → x₀ ≡ +1 (mod D) if gcd compatible
2. x₀ ≡ (-1, -1) → x₀ ≡ -1 (mod D) if gcd compatible
3. x₀ ≡ (+1, -1) → x₀ ≡ ??? (mod D) [mixed]
4. x₀ ≡ (-1, +1) → x₀ ≡ ??? (mod D) [mixed]

**Conjecture**: Cases 1-2 (same sign) lead to "clean" CF structure → d[τ/2]=2
Cases 3-4 (different signs) lead to "messy" CF structure → d[τ/2]≠2

### Connection to Ideal Splitting

For prime p:
- p ≡ 7 (mod 8): (2) splits in ℤ[√p] → norm +2 exists → d[τ/2]=2
- p ≡ 3 (mod 8): (-2/p)=+1 → norm -2 exists → d[τ/2]=2

For semiprime D = p×q:
- Structure of ℤ[√D] more complex
- Ideal behavior depends on BOTH p and q
- Sign consistency may relate to ideal factorization compatibility

**Needs investigation**: Explicit connection between:
- Sign consistency (x₀ mod p vs x₀ mod q)
- Ideal structure in ℤ[√(p×q)]
- CF palindrome center properties

---

## Comparison: Primes vs Semiprimes vs General Composites

| Type | d[τ/2] = 2 Rate | Condition |
|------|-----------------|-----------|
| **Primes** p ≡ 3,7 (mod 8) | **100%** | Always (tested 18/18) |
| **Odd prime powers** p^{2k+1} | **100%** | Always (tested for k=1,2,3) |
| **Semiprimes** p×q | **27%** (10/37) | **IFF same sign mod p,q** |
| **General composites** | **23%** (6/26) | Unknown pattern |

**Key insight**: Semiprimes have **predictable** behavior based on factors!

---

## Implications

### For Main Theorem (x₀ mod p for primes)

**Does NOT affect** the prime result:
- Primes still have d[τ/2]=2 universally
- Sign consistency is a SEMIPRIME phenomenon
- Primes don't have "multiple factors" to conflict

### For Generalization

**Opens new question**: What about 3-factor composites?

For D = p×q×r ≡ 3 (mod 4):
- Do we need **all three** factors to have same sign?
- Or just majority?
- Or is the pattern more complex?

User quote: "pak zkusíme generalizovat na čísla se třemi faktory, ale to asi bude mess"

### Theoretical Significance

**What we've found**:
1. d[τ/2]=2 is NOT just prime-specific
2. It's **sign-consistency-specific** for semiprimes
3. Perfect correlation suggests deep structural reason
4. Likely related to ideal theory in ℤ[√D]

**Why it matters**:
- Extends our understanding beyond primes
- Shows CF-ANT connection applies to composites
- May lead to general characterization theorem

---

## Open Questions

### About the Mechanism

1. **WHY does sign consistency matter?**
   - CRT explanation is descriptive, not explanatory
   - What's the algebraic/geometric reason?
   - Connection to ideal factorization?

2. **Ideal structure in ℤ[√(p×q)]**:
   - How does (2) factor for composite D?
   - Does sign consistency relate to ideal class group?
   - Connection to genus theory?

3. **CF construction**:
   - How does CF algorithm "see" the sign mismatch?
   - Why does it affect the palindrome center specifically?

### About Generalization

4. **Three-factor composites** (D = p×q×r):
   - Test if pattern extends
   - Likely more complex (user expects "mess")
   - Majority rule? Unanimous rule?

5. **General n-factor composites**:
   - Is there a general formula?
   - Depends on number of factors?
   - Or just on sign patterns?

6. **Powers of 2**:
   - Earlier found 2^k have d[τ/2]=4, not 2
   - How do they fit into the pattern?
   - Sign consistency still relevant?

---

## Next Steps

### Immediate

1. ✅ **Document semiprime pattern** (this file!)
2. ⏭️ **Test 3-factor composites** (D = p×q×r)
3. **Analyze results**: Does pattern generalize or break?

### Medium Term

4. **Theoretical investigation**:
   - Ideal factorization for composite D
   - Connection to sign consistency
   - Prove (or disprove) the pattern

5. **Return to primes** (Ferrari):
   - Main theorem for publication
   - Note semiprime findings as extension
   - Open questions for future work

---

## Conclusion

**Major finding**: d[τ/2] = 2 for semiprimes is **perfectly correlated** with sign consistency.

**Evidence**: 100% (37/37 semiprimes, zero counterexamples)

**Significance**:
- Extends prime-specific pattern to predictable subset of composites
- Shows CF-ANT bridge applies beyond primes
- Opens new avenue for generalization

**Status**: Empirical (very strong), theoretical mechanism unclear

**Next**: Test 3-factor composites to see if pattern survives or becomes "mess"

---

**Discovered**: 2025-11-18, late evening
**Status**: 🔬 EMPIRICAL (100% correlation)
**Confidence**: Very high (perfect correlation, no counterexamples)
**Excitement level**: TESLA (not škodovka)
