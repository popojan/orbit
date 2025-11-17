# CF Center Convergent Pattern: Norm ±2

**Date**: 2025-11-17
**Status**: 🔬 NUMERICAL (15 primes tested)
**Novelty**: ⚠️ UNKNOWN (needs literature check)

---

## Pattern

**Convergent at period/2 ALWAYS has norm ±2:**

```
p ≡ 7 (mod 8): norm = +2  (7/7 tested)
p ≡ 3 (mod 8): norm = -2  (8/8 tested)
```

**Sample:** 15 primes {3,7,11,19,23,31,43,47,59,67,71,79,83,103,107}

---

## Known vs Novel

### KNOWN (classical):
1. CF(√p) is palindromic [Lagrange, 1770]
2. (2/p) depends on p mod 8 [Gauss, quadratic reciprocity]
3. Pell ±1 from CF convergents [standard theory]

### POTENTIALLY NOVEL:
- **Exact norm ±2** at center (not "approximately", but EXACTLY)
- **Sign determined by p mod 8** (systematic pattern)
- **Computational implication:** Can detect half-period early

---

## Why This Might Be Known

**If standard theory says:**
- "Convergents approach √p from alternating sides"
- "Norms alternate in sign and decrease"
- "Center convergent minimizes |norm|"

**Then:** Norm ±2 might follow automatically from palindrome + convergence theory.

**Literature check needed:**
- Perron: "Die Lehre von den Kettenbrüchen" (1929)
- Barbeau: "Pell's Equation" (2003)
- Mordell: "Diophantine Equations" (1969)

---

## Computational Implications (if novel)

### 1. Early Period Detection
```
Instead of:  Compute CF until x²-py²=1 found
Do:          Compute CF until x²-py²=±2 found
             → period = 2 × current_index
```

**Efficiency:** 2× faster period detection.

### 2. Determine p mod 8 from CF
```
If find norm = +2 first → p ≡ 7 (mod 8)
If find norm = -2 first → p ≡ 3 (mod 8)
```

### 3. Recursive Structure?
```
Period divisible by 4 → quarter-period has pattern?
Period divisible by 8 → eighth-period has pattern?
```

**Binary decomposition of CF expansion?**

---

## Adversarial Questions

**Q1:** Is this in standard Pell equation textbooks?
- **Check:** Barbeau Chapter 3 (CF properties)
- **Check:** Mordell Chapter 8 (Pell solutions)

**Q2:** Does this follow trivially from palindrome property?
- Palindrome → symmetry → center minimizes norm
- But WHY exactly ±2? Not ±4, ±3, etc.?

**Q3:** Is this specific to PRIMES p ≡ 3,7 (mod 8)?
- What about p ≡ 1,5 (mod 8)? (not tested systematically)
- What about composite D?

**Q4:** Connection to genus theory?
- Rédei symbols determine 2-rank of class group
- Does that predict norm ±2 at center?

---

## Status Assessment

**Conservative stance:**
- Pattern is OBSERVED (15/15 primes)
- Mechanism is UNDERSTOOD (palindrome + p mod 8)
- Novelty is UNCLEAR (needs literature check)

**If known:** Document as "computational observation of classical result"
**If novel:** Surprising connection between CF geometry and modular arithmetic

**Next:** Web Claude literature search or MathOverflow query.

---

**Reference:** `scripts/analyze_cf_palindrome.wl`
**Sample size:** 15 primes, 0 exceptions
**Confidence:** Pattern robust, novelty uncertain
