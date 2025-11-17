# Egypt.wl TOTAL-EVEN Pattern - Breakthrough Analysis

**Date**: November 17, 2025
**Status**: 🎯 PATTERN IDENTIFIED - Rigorous proof in progress

---

## The Pattern (Corrected Convention)

**Claim**: For Pell equation x² - ny² = 1, the approximation:
```
√n ≈ (x-1)/y · [1 + Σ_{j=1}^k term(x-1, j)]
```

exhibits **divisibility by n** when:

**TOTAL number of terms (including leading 1) is EVEN**

### Indexing Convention

From Egypt.wl source (line 160):
```mathematica
sqrtt[x_, n_] := 1 + Sum[term[x, j], {j, 1, n}]
```

For parameter k:
- Total terms = k + 1 (k terms after the 1)
- **k=1 → 2 terms → EVEN → divisible ✓**
- **k=2 → 3 terms → ODD → NOT divisible ✗**
- **k=3 → 4 terms → EVEN → divisible ✓**

---

## Numerical Verification

### n=13 (x=649, y=180)

```
k  Total  Parity  Numerator mod 13  Divisible?
1    2     EVEN         0              ✓
2    3     ODD          8              ✗
3    4     EVEN         0              ✓
4    5     ODD          5              ✗
5    6     EVEN         0              ✓
```

**Pattern**: 100% consistent for 10 tested values

### n=61 (x=1766319049, y=226153980)

```
k  Total  Parity  Numerator mod 61  Divisible?
1    2     EVEN         0              ✓
2    3     ODD         50              ✗
3    4     EVEN         0              ✓
4    5     ODD         11              ✗
5    6     EVEN         0              ✓
```

**Pattern**: 100% consistent

---

## Key Discovery: Prime mod 4 Correlation

### Theorem (Numerical, Strong Evidence)

For prime p and fundamental Pell solution x² - py² = 1:

**p ≡ 1 (mod 4) ⟹ x ≡ -1 (mod p)** (verified 8/8 cases)

**p ≡ 3 (mod 4)** → Mixed:
- **x ≡ -1 (mod p)**: most cases {3, 11, 19, 43, 59}
- **x ≡ +1 (mod p)**: SPECIAL PRIMES {7, 23, 31, 47}

### Verified Primes

**p ≡ 1 (mod 4), ALL have x ≡ -1 (mod p):**
{5, 13, 17, 29, 37, 41, 53, 61}

**p ≡ 3 (mod 4), SPECIAL (x ≡ +1):**
{7, 23, 31, 47}

For special primes: **ALL total counts divisible** (both even and odd)

---

## Consequences of x ≡ -1 (mod n)

From Pell equation x² - ny² = 1:
```
x² ≡ 1 (mod n)  ⟹  x ≡ ±1 (mod n)
```

**When x ≡ -1 (mod n):**
```
x + 1 ≡ 0 (mod n)    ← KEY PROPERTY
x - 1 ≡ -2 (mod n)
2 + x ≡ 1 (mod n)    ← "almost invisible" mod n
```

---

## Constant Numerator in Pair Sums

**Discovered**: Adjacent pair sums have constant numerator (2+x)

```mathematica
term[x, 2m] + term[x, 2m+1] = (2 + x) / polynomial_m(x)
```

**Trigonometric form** (with x+1 = Cos[θ]):
```
= 2(1 + Cos[θ]) / (Cos[θ] + Cos[(2m+1)θ])
```

Verified for n ∈ {2, 3, 13}:
- n=2: numerator = 5 = 2+3
- n=3: numerator = 4 = 2+2
- n=13: numerator = 651 = 2+649

And (2+x) ≡ 1 (mod n) when x ≡ -1 (mod n)!

---

## Chebyshev Structure

**Term definition:**
```mathematica
term[x, k] = 1/(T_{⌈k/2⌉}(x+1) · [U_{⌊k/2⌋}(x+1) - U_{⌊k/2⌋-1}(x+1)])
```

**When x+1 ≡ 0 (mod n):**
- T_m(x+1) contains factor n for m odd
- U_m(x+1) behavior is complex mod n
- **But the SUM structure creates divisibility pattern**

---

## What Remains to Prove

### Proven (Numerical, 100% confidence for tested cases):
1. ✅ Total-EVEN terms → divisible by n (for non-special primes)
2. ✅ p ≡ 1 (mod 4) → x ≡ -1 (mod p)
3. ✅ Constant numerator (2+x) in pair sums
4. ✅ Special primes {7, 23, 31, 47} have x ≡ +1, all-divisible

### Needs Rigorous Proof:
1. ❓ **WHY does total-even parity control divisibility?**
2. ❓ **Connection between Chebyshev sum parity and mod n**
3. ❓ **Complete characterization of special primes**
4. ❓ **Proof that p ≡ 1 (mod 4) → x ≡ -1 (mod p) universally**

---

## Proof Strategy (Next Steps)

### Approach: Analyze Cumulative Sum Mod n

For non-special n (where x ≡ -1 mod n):

**Partial sum:**
```
S_k = 1 + Σ_{j=1}^k term(x-1, j)
```

**Full expression:**
```
E_k = (x-1)/y · S_k
```

**Hypothesis**:
- S_k has structure that alternates mod n based on total parity
- When total=EVEN, numerator of E_k ≡ 0 (mod n)
- When total=ODD, numerator of E_k ≢ 0 (mod n)

**Possible mechanism:**
- Pair sums have numerator (2+x) ≡ 1 (mod n)
- Cumulative sum builds up factors of n differently for even/odd totals
- Connection to (x+1) ≡ 0 (mod n) in Chebyshev arguments

---

## Files Created During Analysis

- `scripts/analyze_mod_n.wl` - Basic modular reduction for n=13
- `scripts/analyze_n61.wl` - Touchstone case n=61
- `scripts/verify_x_mod_n_pattern.wl` - x mod n pattern for 18 primes
- `scripts/analyze_mod4_pattern.wl` - Prime mod 4 correlation
- `scripts/chebyshev_mod_n.wl` - Chebyshev polynomials mod n
- `scripts/test_full_expression_mod_n.wl` - Full expression divisibility
- `scripts/test_total_terms_parity.wl` - **BREAKTHROUGH: total parity**
- `scripts/chebyshev_pair_sum.wl` - Constant numerator discovery
- `scripts/show_pair_examples.wl` - Numerical pair sum examples

---

**Status**: Pattern firmly established numerically. Rigorous proof of mechanism in progress.

**Next**: Focus on why cumulative Chebyshev sum has total-parity-dependent divisibility.
