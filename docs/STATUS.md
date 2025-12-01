# Mathematical Explorations - Status Tracker

**Repository:** popojan/orbit
**Last Updated:** December 1, 2025

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
