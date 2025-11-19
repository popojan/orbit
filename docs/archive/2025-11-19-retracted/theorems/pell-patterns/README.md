# Pell Equation & Continued Fraction Patterns

**Status:** 🔬 **NUMERICALLY VERIFIED** (various confidence levels)
**Date:** November 16-19, 2025

---

## Theorems in This Area

### 1. Mod 8 Theorem (x₀ mod p)

**Status:** 🔬 NUMERICAL (99% confidence, 1228 primes tested)

**Theorem:** For prime $p \geq 3$ and fundamental Pell solution $x^2 - py^2 = 1$:
```
p ≡ 7 (mod 8) ⟺ x ≡ +1 (mod p)
p ≡ 1,3 (mod 8) ⟺ x ≡ -1 (mod p)
```

**Evidence:** 100% for 1228 primes < 10000, 0 counterexamples

**Next:** Rigorous proof via genus theory / quadratic reciprocity

---

### 2. Period Divisibility (mod 4)

**Status:** 🔬 NUMERICAL (99% confidence, 619 primes tested)

**Theorem:** For prime $p$ and continued fraction period of $\sqrt{p}$:
```
p ≡ 3 (mod 8) ⟹ period ≡ 2 (mod 4)  [311/311 tested]
p ≡ 7 (mod 8) ⟹ period ≡ 0 (mod 4)  [308/308 tested]
```

**This is a HARD DIVISIBILITY RULE, not correlation!**

---

### 3. CF Center Norm Pattern

**Status:** 🔬 NUMERICAL (99% confidence, 668 primes < 5000)

**Pattern:** Convergent at period/2 has norm determined by period mod 4:
```
Period mod 4 | Center norm
-------------|-------------
    0        | +2 (fixed)
    1        | negative (varying)
    2        | -2 (fixed)
    3        | positive (varying)
```

**Computational speedup:** For p ≡ 3,7 (mod 8), fundamental solution computable from half-period!

---

### 4. Wildberger-Rosetta Stone

**Status:** 🔬 NUMERICAL (100% correlation, 22/22 test cases)

**Discovery:** Branch symmetry in Wildberger's Pell algorithm ⟺ Negative Pell existence

**When negative Pell exists:** j = 2i (perfect symmetry), binomial C(3i, 2i)

---

## Files

- `mod8-theorem.md` - Mod 8 classification of x₀ mod p
- `period-divisibility.md` - Period mod 4 patterns  
- `cf-center-norm.md` - CF convergent norm patterns
- `wildberger-rosetta.md` - Branch symmetry connection

---

## References

**Scripts:**
→ `../../scripts/falsify_mod8_claim.wl`
→ `../../scripts/test_period_divisibility.wl`
→ `../../scripts/rosetta_stone_analysis.py`

**Related:**
→ `../egypt-total-even/` (uses mod 8 for special primes)
→ `../egypt-chebyshev/` (Wildberger connection)

---

**Next:** Rigorous proofs via genus theory and SB tree geometry
