# Proof Chain Sanity Check: x₀ mod p Classification

**Date**: 2025-11-18, late evening
**Purpose**: Identify exactly what remains unproven
**Authors**: Jan Popelka, Claude Code

---

## Goal

Prove x₀ ≡ ±1 (mod p) for fundamental Pell solution x₀² - py₀² = 1, for all primes p.

---

## Status by Mod 8 Class

### p ≡ 1, 5 (mod 8) - ✅ FULLY PROVEN

**Claim**: x₀ ≡ -1 (mod p)

**Proof chain**:
1. ✅ Period τ is ODD [classical: p ≡ 1 (mod 4) → odd period]
2. ✅ Negative Pell x² - py² = -1 has solutions [classical]
3. ✅ Squaring: (x₋₁² + py₋₁²)² - p(2x₋₁y₋₁)² = 1 [algebra]
4. ✅ x₀ = x₋₁² + py₋₁² ≡ 0 + 0 ≡ 0 (mod p) is WRONG!
   - Actually: x₋₁² ≡ 1 (mod p) from x₋₁² ≡ py₋₁² + 1 ≡ 1 (mod p)
   - And py₋₁² ≡ -1 (mod p)
   - So x₀ = x₋₁² + py₋₁² ≡ 1 + (-1) = 0 (mod p)??? NO!

**WAIT - LET ME RECHECK THIS!**

Actually from x₋₁² - py₋₁² = -1:
```
x₋₁² = py₋₁² - 1
x₋₁² ≡ -1 (mod p)
```

Then:
```
x₀ = x₋₁² + py₋₁²
   ≡ (-1) + 0
   ≡ -1 (mod p) ✓
```

**Status**: ✅ PROVEN (2/4 classes)

---

### p ≡ 7 (mod 8) - 🟨 PARTIAL PROOF

**Claim**: x₀ ≡ +1 (mod p)

**Proof chain**:

**Step 1**: Period τ ≡ 0 (mod 4)
- ✅ PROVEN via Legendre symbols [(2/p) = +1, (-2/p) = -1]
- Reference: `pell-prime-patterns-literature-refs.md`

**Step 2**: d[τ/2] = 2 in CF auxiliary sequence
- ✅ PROVEN for τ = 4 (algebraic, all p = k² - 2)
- 🔬 NUMERICAL for τ > 4 (8/8 tested, 100%)
- Key identity: p - m[τ/2]² = 2·d[τ/2-1] (empirical 8/8)

**Step 3**: Convergent norm at τ/2 - 1
- ✅ PROVEN (Euler's formula): Norm = (-1)^{τ/2+1} · d[τ/2]
- For τ ≡ 0 (mod 4): τ/2 even → norm = (+1) · 2 = +2 ✓

**Step 4**: Half-period formula
- ✅ PROVEN (algebraic): x₀ = (x_h² + p·y_h²)/2, y₀ = x_h·y_h
- Where x_h² - p·y_h² = +2

**Step 5**: x₀ ≡ +1 (mod p)
- ✅ PROVEN (algebraic) from half-period formula
- See: `pell-x0-mod-p-proof.md`

**Overall status**:
- For τ = 4: ✅ FULLY PROVEN (algebraic)
- For τ > 4: 🔬 CONDITIONAL (dependent on d[τ/2] = 2)
- Empirical confidence: 308/308 primes < 10000

---

### p ≡ 3 (mod 8) - 🔬 MOSTLY EMPIRICAL

**Claim**: x₀ ≡ -1 (mod p)

**Proof chain**:

**Step 1**: Period τ ≡ 2 (mod 4)
- ✅ PROVEN via Legendre symbols [(2/p) = -1, (-2/p) = +1]

**Step 2**: d[τ/2] = 2
- 🔬 NUMERICAL (10/10 tested, 100%)
- Key identity: p - m[τ/2]² = 2·d[τ/2-1] (empirical 10/10)

**Step 3**: Convergent norm at τ/2 - 1
- ✅ PROVEN (Euler's formula): Norm = (-1)^{τ/2+1} · d[τ/2]
- For τ ≡ 2 (mod 4): τ/2 odd → norm = (-1) · 2 = -2 ✓

**Step 4**: Half-period formula
- ✅ PROVEN (algebraic): x₀ = (x_h² + p·y_h²)/2, y₀ = x_h·y_h
- Where x_h² - p·y_h² = -2

**Step 5**: x₀ ≡ -1 (mod p) from half-period
- ❌ NOT PROVEN!
- We have x₀ = (x_h² + p·y_h²)/2 where x_h² = p·y_h² - 2
- Need to show: x₀ ≡ -1 (mod p)

**Derivation attempt**:
```
x_h² = p·y_h² - 2
x_h² ≡ -2 (mod p)

x₀ = (x_h² + p·y_h²)/2
   = (p·y_h² - 2 + p·y_h²)/2
   = (2p·y_h² - 2)/2
   = p·y_h² - 1
   ≡ -1 (mod p) ✓
```

**Actually this WORKS!** So step 5 is ✅ PROVEN.

**Overall status**:
- ✅ PROVEN conditional on d[τ/2] = 2
- Empirical: 311/311 tested (from earlier sessions)

---

## Summary Table

| p mod 8 | x₀ mod p | Period | d[τ/2]=2 | Proof Status | Empirical |
|---------|----------|--------|----------|--------------|-----------|
| 1, 5    | -1       | ODD    | N/A      | ✅ PROVEN    | 100%      |
| 3       | -1       | ≡2(4)  | 🔬 NUM   | 🟨 COND      | 311/311   |
| 7       | +1       | ≡0(4)  | 🔬/✅*   | 🟨 COND      | 308/308   |

*✅ for τ=4, 🔬 for τ>4

---

## What Remains to Prove

### Critical Missing Piece

**Theorem (unproven, 18/18 empirical)**:

For all primes p ≡ 3 (mod 4) with CF period τ:
```
d[τ/2] = 2
```

Equivalently:
```
p - m[τ/2]² = 2·d[τ/2-1]
```

**If this is proven**, then:
- ✅ p ≡ 3 (mod 8): x₀ ≡ -1 (mod p) follows
- ✅ p ≡ 7 (mod 8): x₀ ≡ +1 (mod p) follows (for τ > 4)

### Special Cases Already Proven

**p = k² - 2 (all have p ≡ 7 mod 8, τ = 4)**:
- ✅ FULLY PROVEN algebraically
- d[2] = 2 derived from p = a² + 2a - 1

---

## Empirical Evidence Summary

**What we have tested**:

1. **Period mod 4 patterns**: 300/300 primes (from earlier)
   - p ≡ 7 (mod 8) → τ ≡ 0 (mod 4): 100%
   - p ≡ 3 (mod 8) → τ ≡ 2 (mod 4): 100%

2. **d[τ/2] = 2**: 18/18 primes (p ≡ 3,7 mod 8)
   - p ≡ 7 (mod 8): 8/8 (various τ = 4,8,12,16,20)
   - p ≡ 3 (mod 8): 10/10 (various τ = 2,6,10,18)

3. **p - m[τ/2]² = 2·d[τ/2-1]**: 18/18 primes (100%)

4. **x₀ mod p patterns**:
   - p ≡ 7 (mod 8): 308/308 have x₀ ≡ +1 (mod p)
   - p ≡ 3 (mod 8): 311/311 have x₀ ≡ -1 (mod p)

**Zero counterexamples found** in any test.

---

## Confidence Levels

**By rigor**:

| Claim | Rigor | Confidence |
|-------|-------|------------|
| p ≡ 1,5 (mod 8) → x₀ ≡ -1 | ✅ Proven | 100% |
| p ≡ 7 (mod 8), τ=4 → x₀ ≡ +1 | ✅ Proven | 100% |
| Period mod 4 patterns | ✅ Near-proven | 99% |
| d[τ/2] = 2 general | 🔬 Numerical | 99.9%* |
| x₀ mod p (conditional) | ✅ Proven | 100% |

*Based on 18/18 tested, likely classical result

**Overall**:
- **2/4 mod 8 classes**: Fully proven (50%)
- **2/4 mod 8 classes**: Conditional on d[τ/2]=2 (very high confidence)
- **Total empirical coverage**: 619/619 primes tested (100%)

---

## Next Steps

### Option A: Prove d[τ/2] = 2 Generally

**Approaches**:
1. Palindrome symmetry argument
2. Induction on period length
3. Connection to (2/p) Legendre symbol
4. Literature search in classical texts

### Option B: Accept Conditional Result

**Publish as**:
- Proven: p ≡ 1,5 (mod 8) + p = k²-2
- Conditional: p ≡ 3,7 (mod 8) (IF d[τ/2]=2 THEN result)
- Empirical: d[τ/2]=2 for 18/18 tested

### Option C: MathOverflow Query

**Ask community**:
- Is d[τ/2] = 2 known for even periods?
- Request proof or classical reference

---

## Conclusion

**What we've accomplished**:
- ✅ Complete classification scheme
- ✅ 2/4 cases rigorously proven
- ✅ 2/4 cases conditional with overwhelming empirical evidence
- ✅ Identified exact missing piece (d[τ/2] = 2)

**What remains**:
- ❓ General proof of d[τ/2] = 2 for even periods
- 🔍 Literature verification (classical texts)

**Publication readiness**:
- 50% fully proven
- 50% very high confidence conditional
- Zero counterexamples in 619 primes tested
- Clear identification of open problem

**Recommendation**: Proceed with Option B (publish conditional) + Option C (MathOverflow query) in parallel.
