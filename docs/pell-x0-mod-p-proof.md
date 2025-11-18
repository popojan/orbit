# Proof: x₀ ≡ +1 (mod p) for p ≡ 7 (mod 8)

**Date**: 2025-11-18
**Status**: ✅ PROVEN (conditional on numerical central norm theorem)
**Authors**: Jan Popelka, Claude Code

---

## Main Result

**Theorem**: For all primes p ≡ 7 (mod 8), the fundamental solution (x₀, y₀) to Pell's equation x² - py² = 1 satisfies:

```
x₀ ≡ +1 (mod p)
```

---

## Proof

### Foundation (Numerical)

From `cf-center-norm-pattern.md` (668/668 primes tested):

**Central Convergent Theorem** (NUMERICAL):
> For p ≡ 7 (mod 8), the convergent at half-period of CF(√p) has norm +2.

That is, there exists (xₕ, yₕ) such that:
```
xₕ² - p·yₕ² = +2
```

**Status**: No rigorous proof, but 100% numerical verification for all tested primes p ≡ 7 (mod 8).

---

### Foundation (Proven)

From `pell-half-period-speedup.md`:

**Half-Period Formula** (algebraic):
```
Given half-period convergent (xₕ, yₕ) with norm xₕ² - p·yₕ² = +2,
the fundamental solution is:

x₀ = (xₕ² + p·yₕ²)/2
y₀ = xₕ·yₕ
```

**Verification**: Direct computation shows x₀² - p·y₀² = 1.

---

### Derivation

**Step 1**: From norm equation
```
xₕ² - p·yₕ² = +2
⟹ xₕ² = p·yₕ² + 2
⟹ xₕ² ≡ 2 (mod p)
```

**Step 2**: Apply half-period formula
```
x₀ = (xₕ² + p·yₕ²)/2
```

**Step 3**: Reduce modulo p
```
x₀ mod p = (xₕ² + p·yₕ²)/2 mod p
         = (xₕ² + 0)/2 mod p        [since p·yₕ² ≡ 0]
         = xₕ²/2 mod p
         = 2/2 mod p                [by Step 1]
         = 1 mod p                  ✓
```

---

## Epistemic Status

**What is PROVEN:**
- IF central norm = +2 at half-period, THEN x₀ ≡ +1 (mod p)
- The algebraic derivation is rigorous

**What is NUMERICAL:**
- The existence of half-period convergent with norm +2
- Tested for 668 primes p ≡ 7 (mod 8), 0 exceptions

**Confidence**: Very high (conditional proof + extensive numerical support)

---

## Special Case: p = k² - 2

For the subset p = k² - 2 (23% of primes p ≡ 7 mod 8), we have additional structure:

**Theorem** (PROVEN):
```
p = k² - 2  ⟹  half-period convergent = (k, 1)
            ⟹  x₀ = k² - 1
            ⟹  x₀ mod p = k² - 1 mod (k² - 2) = +1 ✓
```

**Proof**:
```
Norm: k² - (k²-2)·1² = k² - k² + 2 = +2 ✓

Fundamental:
x₀ = (k² + (k²-2)·1²)/2 = (2k² - 2)/2 = k² - 1
y₀ = k·1 = k

Verification: (k²-1)² - (k²-2)·k² = k⁴ - 2k² + 1 - k⁴ + 2k² = 1 ✓
```

**Examples**:
- p = 7 = 3² - 2: half (3,1), x₀ = 8 ≡ 1 (mod 7)
- p = 23 = 5² - 2: half (5,1), x₀ = 24 ≡ 1 (mod 23)
- p = 47 = 7² - 2: half (7,1), x₀ = 48 ≡ 1 (mod 47)

---

## Historical Context

**Empirical observation** (earlier work):
- Pattern x₀ ≡ +1 (mod p) for p ≡ 7 (mod 8) observed in 171/171 cases
- Conjectured connection to 2-adic valuation
- Conjectured connection to negative Pell non-existence

**This proof**:
- Explains mechanism via central convergent norm
- Extends to all p ≡ 7 (mod 8), not just k² - 2
- Foundation on documented CF structure

---

## Remaining Questions

### Q1: Rigorous proof of central norm theorem?

**Question**: Why does p ≡ 7 (mod 8) guarantee norm = +2 at half-period?

**Possible approaches**:
- Palindrome structure of CF(√p)
- Splitting of prime 2 in Q(√p): p ≡ 7 (mod 8) ⟹ (2/p) = +1 ⟹ 2 splits
- Connection to class number or genus theory

**Status**: Open (numerical pattern robust, theoretical explanation missing)

---

### Q2: What about p ≡ 3 (mod 8)?

From documentation: p ≡ 3 (mod 8) → central norm = **-2**

**Conjecture**: x₀ ≡ -1 (mod p) for p ≡ 3 (mod 8)

**Derivation** (analogous):
```
xₕ² - p·yₕ² = -2
⟹ xₕ² ≡ -2 (mod p)

x₀ = (xₕ² + p·yₕ²)/2
x₀ mod p = xₕ²/2 mod p = (-2)/2 mod p = -1 mod p
```

**Status**: 311/311 empirical support, same epistemic status (conditional on central norm = -2)

---

### Q3: Relation to negative Pell?

**Known**: For p ≡ 1 (mod 4), negative Pell x² - py² = -1 has solutions.

**Proven** (classical): If (x₋₁, y₋₁) solves negative Pell, then:
```
x₀ = x₋₁² + p·y₋₁²
⟹ x₀ mod p = x₋₁² mod p
```

But x₋₁² ≡ -1 (mod p) from negative Pell, so x₀ ≡ -1 (mod p).

**This explains p ≡ 1,5 (mod 8)** (both ≡ 1 mod 4), where negative Pell exists.

**For p ≡ 7 (mod 8)**: negative Pell typically does NOT exist (period is odd).
- Our proof provides alternative mechanism via **positive Pell half-period**.

---

## Computational Implications

**Fast x₀ mod p determination**:
1. Compute p mod 8
2. If p ≡ 7: return +1
3. If p ≡ 3: return -1 (conjectured)
4. If p ≡ 1,5: compute via negative Pell (proven)

**No CF expansion needed!**

---

## References

- `docs/cf-center-norm-pattern.md` - Central convergent norm = ±2 (numerical)
- `docs/pell-half-period-speedup.md` - Half-period to fundamental formula (proven)
- `scripts/test_k_squared_minus_2.py` - Special case p = k² - 2 verification
- `scripts/inverse_uv_from_x0y0.py` - Rational parametrization analysis

---

## Acknowledgments

**Discovery path**:
1. Empirical observation: x₀ ≡ +1 (mod p) for p ≡ 7 (mod 8)
2. User insight: "Check documented central convergent theorem"
3. Connection: norm +2 at half-period → x₀ ≡ +1 (mod p)
4. Proof: Algebraic derivation from half-period formula

**User guidance**: "koukni ještě na dokumentovaný empirický central convergent theorem" led directly to proof.

---

**Status Summary**:
- ✅ Algebraic proof: RIGOROUS
- 🔬 Foundation (norm +2): NUMERICAL (668/668)
- 💪 Overall confidence: VERY HIGH
