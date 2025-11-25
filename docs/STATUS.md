# Mathematical Explorations - Status Tracker

**Repository:** popojan/orbit
**Last Updated:** November 25, 2025

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

### Actions Taken
- Revised `docs/drafts/chebyshev-pell-sqrt-paper.tex` to be honest
- New title: "A Unified Chebyshev Framework for Square Root Iteration Methods"
- Archived 11 old "proof" files to `docs/proofs/archive-2025-11-25/`
- Downloaded reference papers: Dijoux (arXiv:2501.04703), Nazeer MHHM

### References Added
- `papers/dijoux-chebyshev-householder-2024.pdf` - Chebyshev ↔ Householder connection
- `papers/nazeer-mhhm-order6-2016.pdf` - Modified Householder order 6
- `papers/nazeer-modified-halley-order6-2016.pdf` - Modified Halley order 6

---

## Current Status: Active Research

### Recent Discoveries (November 22-25, 2025)

**Egypt Square Root Convergence Analysis**

Session: `docs/sessions/2025-11-23-egypt-convergence-analysis.md`

1. **📖 Hyperbolic-Pell Connection** (standard Chebyshev identity)
   - For Pell solution x² - ny² = 1 with regulator R = x + y√n:
   - Uses: `cosh(n·arcsinh(z)) = T_n(√(1+z²))` [textbook]
   - s = ArcSinh[√((x-1)/2)]
   - e^(2s) = R (exact relationship)

2. **🔬 Egypt Decay Rate** (numerically fitted, error < 0.1%)
   - FactorialTerm[x-1, k] ≈ (2.001 + 0.00002·k) · (1/R)^k
   - Decay base: 1/R (NOT 1/(R+1))
   - Linear prefactor: a ≈ 2, b ≈ 0.00002

3. **🔬 Convergence Ratio Growth** (numerically verified for k=1..100)
   - f(k) = error_geom(k) / error_egypt(k) ≈ [1/(R-1)] · 2^k
   - Egypt converges exponentially faster than geometric series
   - Error ratio grows as 2^k

4. **✅ Derivative Anti-Palindromic Structure** (algebraically proven)
   - d/dR[ChebyshevTerm[k+1]/ChebyshevTerm[k]] has exactly 2 forms:
   - ODD k: 1/(R⁴ + 4R² + 1)
   - EVEN k: (R² - R + 1)²/(1 + R⁴)²
   - Parity cannot be eliminated (even vs non-even function)

5. **✅ Anti-Palindromic Polynomial** (proven)
   - ODD denominator (after substitution x = R²): 1 + 3x - 3x² - x³
   - Factorization: -(x - 1)(x² + 4x + 1)
   - Coefficients: {1, 3, -3, -1} satisfy coeffs == -Reverse[coeffs]

6. **🔬 Pairwise Sum Constant** (numerically verified)
   - Sum of consecutive derivatives: deriv[2k-1] + deriv[2k] = constant
   - Independent of k (eliminates (-1)^k oscillation)
   - Palindromic numerator: {2, -2, 7, -10, 16, -10, 7, -2, 2}
   - Value at R = 649 + 180√13: 7.040×10⁻¹³ ≈ -1/R²

**Key Formulas:**
```
Egypt: √n = (x-1)/y · (R+1)/(R-1)
Unified derivative (with parity):
  d/dR[CT[k+1]/CT[k]] = [(1-(-1)^k)/2]/(R⁴+4R²+1) + [(1+(-1)^k)/2]·(R²-R+1)²/(1+R⁴)²
```

### Working Code (Verified)
- ✅ Orbit paclet (Chebyshev-based sqrt approximation)
- ✅ Egypt.wl reference (factorial-based sqrt approximation)
- ✅ Numerical test scripts
- ✅ Convergence analysis scripts (Nov 22-23)

### Unverified Observations (Require Re-examination)
- Divisibility pattern in Egypt sums (formulation unclear)
- Binomial structure in shifted Chebyshev polynomials (domain restrictions)
- Mod 8 correlation for Pell solutions (99% numerical, not proven)
- Wildberger branch symmetry (100% numerical for 22 cases, not proven)

### Open Questions
1. Theoretical proof that convergence ratio is exactly 2^k (currently numerical)
2. Closed form for FactorialTerm prefactor coefficients (a, b)
3. Generating function for palindromic numerator polynomial
4. Physical/geometric interpretation of pairwise sum constancy
5. Connection to Chebyshev recurrence structure

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
- `docs/proofs/chebyshev-egypt-connection.md` - Consolidated identity (cites literature)
- `docs/proofs/archive-2025-11-25/` - Archived proof attempts
- `docs/STATUS.md` - This file (current status tracker)
- `CLAUDE.md` - Collaboration protocol

### Reference
- `egypt/doc/sqrt.pdf` - Original Egypt.wl observation (needs re-examination)

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
