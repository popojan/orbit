# Polynomial Structure of Beatty Ballot Rows

**Date:** 2026-04-11

## Motivation

Observation: `BeattyBallotCount[α, All, {p_k, q_{k-1}}]` — the row at height q_{k-1} between consecutive convergent numerators — is exactly a polynomial in position n.

Starting question: Is this polynomial form cleaner than the existing symbolic closed forms (Results 2, 3, 7)?

## Key Findings

### 1. Row at height j is always a degree-j polynomial

For any irrational α and any height j, the lattice path count at fixed height j is a polynomial of degree j in the position n. Verified for √2 up to degree 2378 (k=11).

### 2. Equivalence with Result 2 (uniform zone)

For j ≤ q₁, the polynomial is exactly the universal low-height formula in shifted coordinates:

```
P_j(n) = (n - wj)(n+1)(n+2)···(n+j-1) / j!
```

The Newton form (InterpolatingPolynomial output) is just the divided-difference representation of this known factored form. No new information.

### 3. Universality (window-independence)

P_j(n; α) is the same polynomial regardless of which convergent window [p_{k-1}, p_k] it is computed from. This makes it a well-defined canonical object attached to (α, j).

### 4. NOT an independent invariant

P_{q_k}(n; α) is uniquely determined by the partial quotients [a₀; a₁, ..., a_k], and conversely. But q_k + 1 coefficients encode only k numbers — it's a redundant (polynomial) encoding of the CF expansion to depth k. No compression, no new information beyond CF.

### 5. Zero/Ballot alternation at convergent points

P_{q_j}(p_j) equals:
- **B(p_j, q_j)** (ballot number) when p_j/q_j > α (convergent above)
- **0** when p_j/q_j < α (convergent below)

Forced by geometry: when the convergent undershoots α, the staircase hasn't reached height q_j at position p_j.

### 6. Factorization and root structure

- **j ≤ q₁:** all roots are integers (complete factorization over ℤ)
- **j > q₁:** one integer root at n = ⌈jα⌉ − 1 survives; remaining factor is generically irreducible with complex/irrational roots
- Exception: some (α, j) pairs retain all-integer roots beyond q₁ (e.g., √3 at j = q₂ = 3)

### 7. All-integer-root boundary

Empirical rule (verified for 8 irrationals):

**All roots of P_j(n; α) are integers iff j ≤ q₁ (when a₁ ≥ 2) or j ≤ q₂ (when a₁ = 1).**

| α | a₁ | Boundary | Integer-root heights |
|---|---|---|---|
| π | 7 | q₁ = 7 | {1, ..., 7} |
| √5 | 4 | q₁ = 4 | {1, ..., 4} |
| √2 | 2 | q₁ = 2 | {1, 2} |
| φ | 1 | q₂ = 2 | {1, 2} |
| √3 | 1 | q₂ = 3 | {1, 2, 3} |
| e | 1 | q₂ = 3 | {1, 2, 3} |

Algebraic proof for the a₁ = 1 extension at j = 2: discriminant = (2w+3)², always a perfect square. Proof for j up to q₂ is empirical.

### 8. Correction factorization between rational approximants

Comparing P_j(n; α) for two rationals [w; a₁, a₂] and [w; a₁, b₂] sharing a CF prefix:

**At j ≤ q₁: identical.** At j = q₁ + 1 + d, the correction factors completely into linear terms:

For [3;7,1] = 25/8 vs π (w=3, q₁=7, B₀ = B(25,8) = 420732):

| j | d | Correction = P_j(π) − P_j(25/8) |
|---|---|---|
| 8 | 0 | −B₀ |
| 9 | 1 | −B₀ · (n − 28) |
| 10 | 2 | −B₀/2 · (n − 31)(n − 24) |
| 11 | 3 | −B₀/6 · (n − 34)(n − 24)(n − 23) |
| 12 | 4 | −B₀/24 · (n − 37)(n − 24)(n − 23)(n − 22) |
| 13 | 5 | −B₀/120 · (n − 40)(n − 24)(n − 23)(n − 22)(n − 21) |
| 14 | 6 | −B₀/720 · (n − 43)(n − 24)(n − 23)(n − 22)(n − 21)(n − 20) |

Structure:
- **Leading coefficient:** −B(p₀+p₁, q₀+q₁) / d! (extends Result 3)
- **Moving root:** wj + 1, shifts by w with each step
- **Static roots:** −(p₁+2), −(p₁+1), −p₁, −(p₁−1), ... accumulate one per step

The complete factorization into linear terms goes beyond Result 3 (which only gave the leading coefficient and correction degree). Confirmed for [3;7,2] = 47/15 vs π: identical through j = 14, corrections begin at j = q₂ = 15 with the same hierarchical pattern.

### 9. Divergence structure across α

At height j, P_j distinguishes two irrationals iff their CFs differ within depth where q_k ≥ j:

```
j=1: φ == √2 == √3       (only w visible)
j=2: φ == √3 ≠ √2        (a₁ visible: φ,√3 have q₁=1; √2 has q₁=2)  
j=3: φ ≠ √3 ≠ √2         (a₂ visible: all three differ)
```

Each height peels off one more CF layer.

### 10. Diagonal lattice path family: paths under y ≤ kx

Using BeattyBallotCount[1/k, {n, n}] counts lattice paths from (1,0) to (n,n) staying under the staircase y = kx. This gives a family of integer sequences parametrized by k:

| k | Diagonal sequence | OEIS |
|---|---|---|
| 1 | 1, 2, 5, 14, 42, 132, 429, ... | **A000108** (Catalan) |
| 2 | 1, 3, 9, 31, 108, 391, 1431, 5319, ... | **A127927** |
| 3 | 1, 3, 10, 34, 121, 441, 1628, 6077, ... | **not in OEIS** |
| 4 | 1, 3, 10, 35, 125, 456, 1688, 6315, ... | **not in OEIS** |
| 5 | 1, 3, 10, 35, 126, 461, 1709, 6399, ... | **not in OEIS** |
| k→∞ | 1, 3, 10, 35, 126, 462, 1716, 6435, ... | C(2n-1, n-1) (unconstrained) |

**Key properties of A127927 (k=2):**
- Formula: a(n) = C(2n,n) − (−1)^(n−1) Σ C(3i,i)·C(i−n−1, n−1−2i)/(2i+1)
- The sum involves **A001764** = C(3n,n)/(2n+1) — the count of ternary trees
- Asymptotic: a(n) ~ 4^n / (φ² √(πn)) where φ is the golden ratio
- Main diagonal of triangle A062745

**Universal Newton coefficients:** For any two irrationals α₁, α₂ with the same CF prefix [0; a₁, ...], the diagonal sequences share Newton divided-difference coefficients up to the divergence point. For a₁ = 2 (including 1/√5, 1/√6, 1/√7, 1/e, and the rational 1/2), the shared prefix is:

```
1, 2, 2, 2, 9/8, 17/24, 203/720, 649/5040, 533/13440, 2581/181440, ...
```

These coefficients are α-independent — they encode the universal diagonal count under any staircase with slope ≥ 2.

### 11. Asymptotic constant: closed form for all k

The asymptotic behavior a_k(n) ~ C_k · 4^n / √(πn) (for k ≥ 2) has a universal characterization:

**C_k is the smallest positive root of (1−x)^{k+1} = 1−2x.**

Equivalently, factoring out x=0: C_k is the smallest positive root of p_k(x) where

```
p_k(x) = [(1-x)^{k+1} - (1-2x)] / x
```

These polynomials satisfy the recurrence **p_{k+1}(x) = (x−1)^k − p_k(x)** with closed form:

```
p_k(x) = [(x-1)^{k+1} + (-1)^{k-1}(2x-1)] / x
```

| k | Minimal polynomial of C_k | C_k | Verified |
|---|---|---|---|
| 1 | x² = 0 (double root) | 0 | Catalan: double root ⟹ n^{-3/2} |
| 2 | x² − 3x + 1 | 1/φ² = (3−√5)/2 | OEIS A127927 ✓ |
| 3 | x³ − 4x² + 6x − 2 | ≈ 0.45631 | brute-force ✓ (residual = 0) |
| 4 | x⁴ − 5x³ + 10x² − 10x + 3 | ≈ 0.48121 | predicted from recurrence |
| k→∞ | (1−x)^∞ = 0 ⟹ 1−2x = 0 | 1/2 | unconstrained ✓ |

Coefficients of p_k follow a modified Pascal pattern: all match C(k+1, j) except the constant term, which is k−1 instead of 1.

**TL;DR:** The smallest non-negative root of (1−x)^{k+1} = 1−2x transitions from a double zero (Catalan, n^{−3/2}) through 1/φ² (golden ratio) to 1/2 (unconstrained), unifying the entire family in one equation.

**Derivation status:** Equation discovered empirically (pattern in recurrence + brute-force identification). Algebraic proof of the recurrence is complete. Rigorous derivation from the GF/kernel method is outlined but not fully worked out — natural content for a paper.

**Significance:** k=1 (Catalan) is fundamental in combinatorics. k=2 (A127927) connects to ternary trees and φ. k ≥ 3 are apparently new sequences not in OEIS. The equation (1−x)^{k+1} = 1−2x unifies the entire family with a single closed-form characterization, exhibiting a phase transition at k=1.

## Conclusion

The row polynomial viewpoint (Findings 1–9) is largely a redundant repackaging of the CF expansion. However, the diagonal perspective (Findings 10–11) reveals a new combinatorial family parametrized by staircase slope k:
- k=1: Catalan numbers (A000108), asymptotic n^{-3/2}
- k=2: A127927, asymptotic constant 1/φ²
- k≥3: new sequences, asymptotic constant = smallest root of (1−x)^{k+1} = 1−2x
- k→∞: unconstrained, constant = 1/2

This is publishable: the family, the asymptotic equation, and the OEIS submission for k=3.

## Open Threads

- **Rigorous derivation of (1−x)^{k+1} = 1−2x** from GF/kernel method (paper-ready)
- **OEIS submission** for k=3 sequence (50 terms computed, combinatorial description ready)
- Algebraic proof of all-integer-root boundary for a₁ = 1, j > 2 (up to q₂)
- Explicit formula for a_k(n) generalizing A127927's formula with Fuss-Catalan corrections

## Scripts

All in `scripts/` subfolder. Key scripts:
- `poly_check.wl` — initial verification: polynomial = Result 2
- `poly_convergent_scan.wl` — degree check up to k=11
- `poly_universal.wl` — universality test + evaluation at convergent numerators
- `poly_compare_alpha.wl` — comparison across φ, √2, √3, √5, e
- `poly_integer_roots.wl` — all-integer-root boundary scan (8 irrationals)
- `poly_rational_compare.wl` — rational convergent comparison, coefficient identity
- `poly_corrections_and_sqfree.wl` — correction factorization between CF levels
- `poly_diagonal_sweep.wl` — diagonal sequences under y ≤ kx for k=1..7
- `poly_diagonal.wl` — Newton coefficient comparison across α (universal prefix)
