# Mathematical Explorations - Status Tracker

**Repository:** popojan/orbit
**Last Updated:** December 14, 2025

---

## December 14, 2025: Prvoles — Geometric Sieve Visualization

### Status

📖 **PEDAGOGICAL** — Original visualization, educational contribution

### Summary

**Prvoles** (Primal Forest) transforms the Eratosthenes sieve from 1D to 2D:

```
n = p(p+k)  →  tree at (kp + p², kp + 1)
```

**Key insight:** Each divisor p generates a 45° diagonal with spacing p:
- p=2: diagonal (4,1), (6,3), (8,5), ... spacing (2,2)
- p=3: diagonal (9,1), (12,4), (15,7), ... spacing (3,3)
- p=5: diagonal (25,1), (30,6), (35,11), ... spacing (5,5)

**Primes = clearings** — positions with no trees blocking the view north.

### Why the y-coordinate matters

The y-coordinate is **load-bearing for visualization** (not computation):

| Purpose | Essential? | Reason |
|---------|------------|--------|
| Visual | ✅ YES | Creates 45° diagonals, forest metaphor |
| Algorithmic | ❌ NO | Still O(√n) trial division |
| Insight | ✅ YES | "Paradox of regularity" — regular inputs → irregular outputs |

**ML analogy:** Adding dimension enables *visual* linearity (diagonals instead of irregular intervals), similar to kernel trick enabling linear separability.

### Novelty

Despite extensive search, no prior publication of this specific visualization found:
- Different from Ulam spiral (spiral arrangement, diagonal clusters)
- Different from Sacks spiral (Archimedean spiral)
- Original forest/clearing metaphor

### Documentation

- Paper: `docs/papers/prvoles.tex` (Czech, pedagogical)
- PDF: `docs/papers/prvoles.pdf` (7 pages)
- Visualization: `docs/papers/visualizations/primal-forest-100-parabola.pdf`

---

## December 14, 2025: MoebiusInvolutions Module + Orbit Structure

### Status

✅ **PROVEN** — Complete orbit characterization with signature invariant

### Summary

Added `MoebiusInvolutions.wl` module with three involutions σ, κ, ι and orbit structure analysis.

**Key theorem (corrected):** Orbit signature {A, B} is the complete invariant:
- A = odd(p), B = odd(q-p), with gcd(A,B) = 1
- For composite I with k prime factors: 2^(k-1) distinct orbits
- Canonical form: A/(A+B) where A ≤ B

### Documentation

- Paper: `docs/papers/involution-decomposition.tex` (corrected theorem)
- Module: `Orbit/Kernel/MoebiusInvolutions.wl`
- Session: `docs/sessions/2025-12-14-orbit-applications/README.md`

---

## December 10, 2025: γ-Egypt Simplification Phenomenon

### Discovery

✅ **PROVEN** — Complete characterization of γ-reducible rationals

**Main Theorems:**

1. **G₁ Characterization:** $q = ((a-1)b+1)/((a+1)b+1) \Leftrightarrow \gamma(q)$ has 1 Egypt tuple
   - Special cases: 7/11 (Cheops), 5/8 (Chephren), 5/7 (Bent) all satisfy this!

2. **Fibonacci Compression:** For $F_k/F_{k+1} = [0; 1^k]$:
   - $\gamma$ maps to $[0; 4^m, \text{tail}]$ with $m = \lfloor(k-2)/3\rfloor$
   - **Compression ratio: 3:1** (k ones → ~k/3 fours)

3. **γ-Ladder Decomposition:** Every complex rational analyzed via convergent sequence
   - $\#\text{Egypt}(\gamma(c_k)) \leq \lceil(k-1)/3\rceil + 1$
   - Recursive divide-and-conquer approach to Egypt decomposition

**Golden-Silver Dichotomy:**
- Giza pyramids (golden family): γ-compressible → simplify to 1 tuple
- Bent pyramid (silver family): σ = √2-1 is γ fixed point → no change

### Documentation

- Session: `docs/sessions/2025-12-10-cf-egypt-equivalence/gamma-egypt-simplification.md`

---

## December 10, 2025: CF ↔ Egypt Tuple Equivalence

### Discovery

✅ **PROVEN** — Rigorous algebraic proof via leapfrog identity

**Theorem (CF-Egypt Bijection):** For $q = a/b$ with CF $[0; a_1, a_2, \ldots, a_n]$ and convergent denominators $\{q_0=1, q_1, \ldots, q_n=b\}$:

| Case | $u_k$ | $v_k$ | $j_k$ |
|------|-------|-------|-------|
| Regular ($k < ⌈n/2⌉$ or $n$ even) | $q_{2k-2}$ | $q_{2k-1}$ | $a_{2k}$ |
| Last tuple, odd CF | $q_{n-1}$ | $q_n - q_{n-1}$ | 1 |

**Key Results:**

1. **Bezout-Convergent Theorem:** The Extended GCD coefficient |s| = q_{n-1} (penultimate convergent denominator)
2. **Full bijection:** CF ↔ Egypt is bidirectional; can recover CF from tuples
3. **Prefix stability:** For irrationals, first k tuples depend only on first 2k CF coefficients
4. **Lochs' Theorem (1964):** K decimal digits → ~0.97K reliable CF terms → ~K/2 stable tuples
5. **XGCD = CF:** Extended GCD quotients ARE continued fraction coefficients

**Verification:** Tested on 7/19, 219/344, 5/13, 11/29, 3/8, 3/7, 17/41, 1/3, 2/5

### Algorithmic Insight

Single XGCD call suffices for Egyptian fraction decomposition:
1. XGCD(a, b) → all CF coefficients (quotients)
2. Apply bijection formula → tuples directly

This is more efficient than naïve ModInv iteration (which calls PowerMod = XGCD internally at each step).

### Documentation

- Session: `docs/sessions/2025-12-10-cf-egypt-equivalence/README.md`
- Paper: `docs/papers/egyptian-fractions-telescoping.tex` (extended with §6-8)
- Reference: Lochs, G. (1964). *Abh. Math. Sem. Univ. Hamburg* 27:142-144

---

## December 10, 2025: Convergent Bifurcation — √φ/2 vs 2/π

### Discovery

🤔 **HYPOTHESIS** — compelling evidence for both interpretations

**Finding:** The pyramid ratio 7/11 is the **last common convergent** of two nearly-equal constants:

| Constant | Value | Difference from 7/11 |
|----------|-------|---------------------|
| √φ/2 | 0.63600982... | 0.00035 |
| 2/π | 0.63661977... | 0.00026 |

After 7/11, the convergent sequences **bifurcate**:
- √φ/2 → 159/250, 166/261, ...
- 2/π → 219/344, 226/355, ...

### Arguments FOR √φ/2

1. **King's Chamber height = 5√5 cubits** — explicit √5 in construction
2. **γ framework:** φ = 2γ[-11/20], 1/φ = 2γ[-7/20]; ratio of numerators = 7/11
3. **Chephren uses 5/8** — this is a convergent of √φ/2 but NOT of 2/π (decisive)
4. All Giza pyramids use consecutive √φ/2 convergents: 2/3, 5/8, 7/11

### Arguments FOR 2/π

1. **Perimeter/height = 22/7 ≈ π** — famous "π pyramid" relationship
2. **Queen's shaft ≈ 113 cubits** — 113 is denominator of 355/113 ≈ π
3. **Algebraic consistency:** h/b = 2/π ⟹ perimeter/(2h) = π
4. **Elegant Egyptian fraction:** 219/344 = 1/2 + 1/8 + 1/86 (3 terms vs 4 for √φ/2 branch)

### Higher Convergents on Giza Plateau (Weak Evidence)

| Number | Found? | Strength | Problem |
|--------|--------|----------|---------|
| 113 | Queen's shaft | ⚠️ MEDIUM | Obscure dimension, ~113.4 not exact |
| 226 | 2 × shaft | ❌ WEAK | Dependent on 113 |
| 250 | 2 × Menkaure height | ❌ WEAK | Doubling is trivial |
| ~159 | Cheops base−height | ❌ WEAK | =160, not 159 |

**Adversarial check:** Expected ~1.8 random matches from 210 combinations; found 4.
Multiple testing problem makes these less significant than they appear.

### Conclusion

**Chephren's 5/8 ratio is the key evidence for √φ/2** — it is NOT a convergent of 2/π.

The Queen's shaft ≈ 113 cubits is intriguing but the evidence for "both branches encoded" is weak after adversarial analysis.

### Documentation

- Primary: `docs/sessions/2025-12-08-gamma-framework/golden-ratio-pyramid.md` (section "Convergent Bifurcation")

---

## December 9, 2025: Chronological Convergent Pattern in Egyptian Pyramids

### Discovery

🔬 **NUMERICALLY VERIFIED** (4 pyramids, exact seked values match convergents)

**Finding:** 4th Dynasty pyramids form a chronological sequence of convergents:

| # | Pyramid | Pharaoh | ~Date | Irrational | Convergent | Seked |
|---|---------|---------|-------|------------|------------|-------|
| 1 | **Bent (lower)** | Sneferu | 2600 BC | √2 | 7/5 (3rd) | 5 |
| 2 | **Cheops** | Khufu | 2560 BC | √φ/2 | 7/11 (6th) | 5½ |
| 3 | **Chefren** | Khafre | 2530 BC | √φ/2 | 5/8 (5th) | ~5.25 |
| 4 | **Menkaure** | Menkaure | 2510 BC | √φ/2 | 2/3 (4th) | ~5 |

**Key observations:**
1. **Sneferu** (dynasty founder) used √2 geometry at Dahshur
2. **Khufu** introduced √φ/2 with highest convergent (6th)
3. **Successors** used decreasing convergents: 6th → 5th → 4th

### Supporting Evidence

- Bent Pyramid seked = exactly 5 palms (documented, tan ≈ √2)
- All three Giza ratios are consecutive convergents of √φ/2
- Independent verification via preserved cubit sticks (~52.4 cm)
- Modern GPS/laser confirms Petrie's measurements (<0.05% error)

### Adversarial Check

**Strengths:** ✅ Mathematically exact pattern, chronologically consistent
**Weaknesses:** ⚠️ Only 4 data points, no direct textual evidence of intent

**Status:** Pattern is real. Intentionality unproven but culturally plausible.

### Additional Findings (Dec 9)

- **Shaft dimensions:** 21×21 cm ≈ 2/5 royal cubit ≈ 11 digits
- **Astronomical alignments:** All 4 shafts point to stars of epoch ~2450 BC ± 25 years (disputed)
- **Petrie methodology:** Validated by cubit sticks, interior chambers, modern GPS

### Documentation

- Primary: `docs/sessions/2025-12-08-gamma-framework/pyramid-internal-geometry.md`
- HSM question: https://hsm.stackexchange.com/questions/17717

---

## December 1, 2025: Multiplicative Decomposition of Chebyshev Lobe Areas

### Discovery

✅ **PROVEN** (algebraic proof via roots of unity cancellation)

**Theorem (Multiplicative Decomposition):** For composite n = md with m, d ≥ 2 and n > 2:

$$\sum_{k \equiv r \pmod{m}} A(n, k) = \frac{1}{m} \quad \text{for all } r \in \{1, \ldots, m\}$$

where A(n,k) is the normalized lobe area of the k-th lobe of the n-gon Chebyshev polygon function.

**Equivalently:** Σ B(n, k≡r mod m) = d, where B(n,k) = n·A(n,k).

### Proof Sketch

1. Lobe area decomposes as: A(n,k) = 1/n + oscillatory term with cos(2πk/n)
2. Sum over arithmetic progression k = r, r+m, ..., r+(d-1)m:
   - Constant: d · (1/n) = d · (1/md) = 1/m
   - Oscillatory: Σ exp(2πi(r+jm)/(md)) = exp(2πir/(md)) · Σ exp(2πij/d) = 0
3. Sum of d-th roots of unity vanishes → oscillatory term cancels

### Significance

- **Geometric analogue of divisor decomposition**: Lobe areas "factor" according to factorization of n
- mn-gon can be viewed as m copies of n-gon structure (each with 1/m area)
- Connects Chebyshev composition property Tₘ(Tₙ(x)) = Tₘₙ(x) to geometric areas

### Documentation

- LaTeX: `docs/drafts/lobe-area-kernel.tex` Section 11
- Session: `docs/sessions/2025-12-01-multiplicative-decomposition/README.md`

---

## November 25, 2025: Complete Demystification + Genuine Discovery

### Part 1: Literature Consolidation (morning)

**Finding:** The Factorial ↔ Chebyshev ↔ Hyperbolic identity is **standard Chebyshev theory**.

```
cosh(n·arcsinh(z)) = T_n(√(1+z²))    [textbook identity]
```

**Clarified (NOT novel):**
1. ~~Egypt construction~~ → equals Pell powers shifted by 1: `Egypt[k] = Pell[k+1]`
2. ~~Monotonic convergence~~ → standard Pell theory
3. ~~"Sextic via cancellation"~~ → just Newton∘Halley composition (order 2×3=6)

### Part 2: Demystification of NestedChebyshevSqrt (evening)

**Key realizations:**
- τ₁ = (σ₁ + d/σ₁)/2 = Newton(Halley(n)) — standard composition
- τ₂ = Newton³ — nothing novel
- 2×Halley = order 9, which is MORE efficient than τ₁ = order 6

### Part 3: GENUINE Discovery

**✅ The Chebyshev framework gives access to ALL integer orders ≥ 3:**

```
σ_m has convergence order m+2 (numerically verified)

Newton/Halley compositions can only achieve: 2, 3, 4, 6, 8, 9, 12, 16, 18...
(products of 2s and 3s = 3-smooth numbers)

Chebyshev σ_m achieves: 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13...
(ALL integers)

INACCESSIBLE by composition: 5, 7, 10, 11, 13, 14, 15, 17, 19...
```

**This IS genuinely novel:** A single parameterized formula family covering all integer orders, including primes > 3.

### References
- `papers/dijoux-chebyshev-householder-2024.pdf` - Chebyshev ↔ Householder connection
- `papers/nazeer-mhhm-order6-2016.pdf` - Modified Householder order 6
- `papers/nazeer-modified-halley-order6-2016.pdf` - Modified Halley order 6

---

## Current Status: Active Research

### Working Code
- ✅ Orbit paclet: `SquareRootRationalizations.wl` (Egypt + Chebyshev methods)
- ✅ All paclet modules functional (see CLAUDE.md for details)

### Key Results
- 📖 Egypt[k] = Pell[k+1] exactly (standard Pell theory)
- 📖 Factorial ↔ Chebyshev ↔ Hyperbolic via `cosh(n·arcsinh(z)) = T_n(√(1+z²))` [textbook]
- 🔬 σ_m convergence order m+2 (numerically verified for m=1..6)

---

## Epistemological Standards

Going forward, strict adherence to:

- ✅ **PROVEN** = Rigorous algebraic proof, peer-reviewed OR publicly documented with verification
- 🔬 **NUMERICALLY VERIFIED** = X% of N test cases (explicit numbers)
- 🤔 **HYPOTHESIS** = Conjecture requiring verification
- ❌ **FALSIFIED** = Tested and found false
- ⏸️ **OPEN QUESTION** = Unknown, under investigation
- 🔙 **RETRACTED** = Previously claimed, now withdrawn due to errors

**No more:**
- "Tier-1" labels without peer review
- "95% confidence" for algebraic proofs
- "BREAKTHROUGH" for incremental findings
- Documentation before verification

---

## Repository Structure

### Code (Verified)
- `Orbit/Kernel/` - Paclet implementations
  - `PrimeOrbits.wl`
  - `Primorials.wl`
  - `SemiprimeFactorization.wl`
  - `ModularFactorials.wl`
  - `SquareRootRationalizations.wl` ✅ Working Egypt + Chebyshev methods

### Documentation
- `docs/proofs/chebyshev-egypt-connection.md` - Consolidated proof
- `docs/drafts/chebyshev-pell-sqrt-paper.tex` - Paper draft (honest revision)
- `docs/STATUS.md` - This file
- `CLAUDE.md` - Development protocols

---

## Lessons Learned

### Process Improvements
1. **Check literature FIRST** before claiming novel results
2. **Test boundaries** before claiming "for all x"
3. **Verify against code** before formulating theorems
4. **Adversarial discipline EARLY** (kill bad ideas in 10 min)
5. **Cite sources** - use 📖 for standard results, distinguish from novel work

---

## Orbit Paclet Modules (Status: Working)

1. **Prime Orbits** - Greedy prime decomposition DAG
2. **Primorials** - Rational sum formula
3. **Semiprime Factorization** - Closed-form via Pochhammer
4. **Modular Factorials** - Efficient n! mod p
5. **Square Root Rationalizations** - Egypt + Chebyshev methods

---

**Status:** Clean slate. Ready to restart with proper discipline.

**Authors:** Jan Popelka, Claude (Anthropic)
**Repository:** [popojan/orbit](https://github.com/popojan/orbit) (public)
