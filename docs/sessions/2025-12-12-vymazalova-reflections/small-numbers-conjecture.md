# Small Numbers Conjecture

**Status:** 🤔 HYPOTHESIS — philosophical intuition seeking formalization
**Date:** 2025-12-12
**Context:** Discussion following Vymazalová reading, Egyptian mathematics

---

## Core Intuition

> "Malá čísla jsou zajímavější než velká. Hon za velkými prvočísly je marný."

**Claim:** The structure of ALL natural numbers is encoded in small numbers. Large numbers are "harmonics" — combinations of fundamental small-number patterns.

---

## Evidence

### 1. Egyptian Mathematics (empirical, ~2000 BC)

- **2÷n table:** Codifies behavior of ALL odd fractions using patterns from small n
- **Eye of Horus:** 1/2 + 1/4 + ... + 1/64 = 63/64 — powers of 2 suffice
- **Pyramid ratios:** 7/11 ≈ √φ/2 ≈ 2/π — three small numbers encode φ, π, √
- **Only documented √:** Integer results (√16=4, √64=8, √100=10) — small perfect squares

### 2. Pell Equations (algebraic)

Fundamental solution (X₁, Y₁) generates ALL solutions via:
```
(Xₖ, Yₖ) = (X₁ + Y₁√n)^k
```

**Example:** For n=2, fundamental (3,2) generates:
- k=1: (3, 2)
- k=2: (17, 12)
- k=3: (99, 70)
- ...all from small seed (3,2)

### 3. Continued Fractions (analytic)

Best rational approximations determined by small quotients:
```
√2 = [1; 2, 2, 2, ...] — just 1 and 2!
√3 = [1; 1, 2, 1, 2, ...] — just 1 and 2!
φ = [1; 1, 1, 1, ...] — just 1!
π = [3; 7, 15, 1, 292, ...] — small quotients dominate
```

### 4. γ Framework (Orbit project)

Algebraic numbers at rational parameters:
```
φ = 2γ[-11/20]     — golden ratio from 11, 20
1/φ = 2γ[-7/20]    — inverse from 7, 20
√2 = γ[-1/2] + 1   — from 1, 2
```

### 5. Factorization (fundamental theorem)

Every n ∈ ℕ is uniquely:
```
n = 2^a₂ · 3^a₃ · 5^a₅ · 7^a₇ · ...
```
Small primes appear in EVERY factorization. Large primes are rare.

---

## The √2 ↔ √3 Duality

A concrete example of small-number structure:

| | √2 | √3 |
|--|----|----|
| Pell (X,Y) | (3,2) | (2,1) |
| First Egypt approx | 4/3 | 3/2 |
| Formula | n·Y/X | n·Y/X |
| Product | 4/3 × 3/2 = **2** | |

The Pell solutions are "swapped": (3,2) ↔ (2,1).

This symmetry exists ONLY for 2 and 3 — the smallest non-trivial cases.

---

## Concrete Predictions (verified)

### 1. Fermat Two-Square Theorem

**Input:** Single number **4**
**Output:** For ANY prime p, predict if p = x² + y²

**Rule:** p = x² + y² has solution ⟺ p ≡ 1 (mod 4)

```
p = 10007,   mod 4 = 3 → No solution  ✓
p = 10009,   mod 4 = 1 → Has solution ✓
p = 1000033, mod 4 = 1 → Has solution ✓
```

**The number 4 perfectly predicts a property of primes to ANY size.**

### 2. Quadratic Reciprocity

**Input:** Numbers **2, 4** (via mod 4 residues)
**Output:** For ANY primes p, q: Is x² ≡ p (mod q) solvable?

**Rule:** Legendre symbol (p|q) depends only on:
- p mod 4
- q mod 4
- (p|q)(q|p) = (-1)^((p-1)/2 · (q-1)/2)

```
Is x² ≡ 7 (mod 1000003) solvable?
7 mod 4 = 3, 1000003 mod 4 = 3
Legendre(7|1000003) = -1 → No solution
```

### 3. Pell Equation x² - ny² = -1 Solvability

**Input:** CF period parity (depends on small quotients)
**Output:** Whether negative Pell has solution for ANY n

**Rule:** x² - ny² = -1 solvable ⟺ CF period of √n is odd

```
n=2: period=1 (odd) → x²-2y²=-1 solvable (solution: 1,1)
n=3: period=2 (even) → x²-3y²=-1 has NO solution
```

### 4. Egyptian 2/n Table Structure

**Input:** Number **6** (via mod 6 residues)
**Output:** Decomposition pattern for ANY 2/n

**Rule:** Pattern depends on n mod 6:
- n ≡ 1 (mod 6): specific pattern
- n ≡ 5 (mod 6): similar pattern
- n ≡ 3 (mod 6): different pattern

**Small number 6 organizes ALL Egyptian decompositions.**

### 5. Miller-Rabin Deterministic Primality Test

**Input:** Finite set of small primes as witnesses
**Output:** Primality of ANY n up to bound

| Range | Witnesses needed | Which bases |
|-------|------------------|-------------|
| n < 2,047 | **1** | 2 |
| n < 1,373,653 | **2** | 2, 3 |
| n < 3,215,031,751 | **4** | 2, 3, 5, 7 |
| n < 2^64 | **12** | 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37 |

**12 small primes suffice to test ANY 64-bit number for primality!**

Under GRH: For any composite n, there exists a witness ≤ 2(ln n)².

Source: [Miller-Rabin - Wikipedia](https://en.wikipedia.org/wiki/Miller–Rabin_primality_test), [SPRP bases records](https://miller-rabin.appspot.com/)

### 6. Bhargava-Hanke 290-Theorem (Quadratic Forms)

**Input:** 29 "critical integers" (largest = **290**)
**Output:** Whether a quadratic form represents ALL positive integers

**Theorem (Bhargava-Hanke 2005):** A positive-definite integer quadratic form is universal ⟺ it represents these 29 numbers:
```
1, 2, 3, 5, 6, 7, 10, 13, 14, 15, 17, 19, 21, 22, 23, 26,
29, 30, 31, 34, 35, 37, 42, 58, 93, 110, 145, 203, 290
```

**Stronger form (Theorem 3):** If a form represents every positive integer below 290, it represents every integer above 290.

**Result:** Exactly 6436 universal quaternary forms exist.

**This is perhaps the cleanest example:** checking 29 small numbers (max 290) determines behavior for ALL ∞ positive integers!

Source: Bhargava & Hanke, "Universal quadratic forms and the 290-Theorem" (preprint in ~/Documents/papers/primes/)

---

## Attempted Formalization

### Definition: "Small Number Basis"

Let S = {2, 3, 4, 5, 6, ...} be integers up to some bound B.

**Conjecture (weak):** For any arithmetic property P, the behavior of P on ℕ is determined by residues modulo elements of S.

**Conjecture (strong):** There exists a finite "small number basis" from which all number-theoretic structure can be derived via:
1. Residue classes (mod small numbers)
2. Quadratic forms over small numbers
3. CF quotients (which are small)

### Connection to Riemann Hypothesis

The zeta function:
```
ζ(s) = Σ n^(-s) = Π (1 - p^(-s))^(-1)
```

encodes ALL primes, but its analytic structure (zeros, functional equation) depends on behavior at small values.

**Speculation:** RH is "really" a statement about small primes, manifested in large primes.

---

## Open Questions

1. **Can we formalize "information density"?**
   - Small numbers have more structure per digit
   - How to measure this?

2. **Is there a "spectral decomposition" of ℕ?**
   - Small numbers as fundamental frequencies
   - Large numbers as harmonics

3. **Why did Egyptians succeed with small numbers?**
   - Practical necessity? Or deeper insight?
   - 4000 years later, pyramids stand; RSA keys are forgotten

4. **Connection to physics?**
   - Fine structure constant α ≈ 1/137 — small numbers
   - Why are fundamental constants "simple"?

---

## Adversarial Check

**Is this more than poetry?**

| Claim | Status |
|-------|--------|
| Factorization encodes in small primes | ✓ Trivially true |
| CF determined by small quotients | ✓ True but tautological |
| Pell generates from fundamental | ✓ Algebraically true |
| Small numbers "explain" large numbers | ? Vague — needs formalization |
| Predictive power | ? Untested |

**Weakness:** Currently descriptive, not predictive. Need concrete predictions.

**Test case:** Given only information about primes < 100, what can we deduce about primes > 10^6?

---

## Historical Note

> "God made the integers, all else is the work of man." — Kronecker

Perhaps more precisely:

> "God made the SMALL integers. Large integers are shadows."

---

## Next Steps

1. Define "small number information content" rigorously
2. Find concrete prediction that follows from small-number structure
3. Test against known results (prime distribution, CF statistics)
4. Connect to existing frameworks (RH, probabilistic number theory)

---

*"The pyramids encode √φ/2 in ratio 7/11. Four thousand years later, we're still finding structure in these small numbers."*
