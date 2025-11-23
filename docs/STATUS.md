# Mathematical Explorations - Status Tracker

**Repository:** popojan/orbit
**Last Updated:** November 23, 2025

---

## ⚠️ RETRACTION NOTICE

**All "proven theorems" from November 19, 2025 have been RETRACTED.**

See: `docs/RETRACTION-2025-11-19.md` for full details.

**Reason:** Fatal errors discovered:
- Egypt-Chebyshev: Proof has domain restriction gap
- TOTAL-EVEN: Wrong formulation, counterexamples exist

**Archived:** `docs/archive/2025-11-19-retracted/`

---

## Current Status: Active Research

### Recent Discoveries (November 22-23, 2025)

**Egypt Square Root Convergence Analysis**

Session: `docs/sessions/2025-11-23-egypt-convergence-analysis.md`

1. **✅ Hyperbolic-Pell Connection** (algebraically proven)
   - For Pell solution x² - ny² = 1 with regulator R = x + y√n:
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
- `docs/RETRACTION-2025-11-19.md` - Brutal honesty about failures
- `docs/archive/` - Retracted materials (learning from mistakes)
- `docs/STATUS.md` - This file (current status tracker)
- `CLAUDE.md` - Collaboration protocol (needs strict adherence!)

### Reference
- `egypt/doc/sqrt.pdf` - Original Egypt.wl observation (needs re-examination)

---

## Lessons Learned (November 19, 2025)

### What Went Wrong
1. Proved theorem without testing against working code
2. Trigonometric proof had domain restriction (not checked)
3. Wrong formulation (n vs x+1 divisibility)
4. Documentation before verification
5. Overused "BREAKTHROUGH", "Tier-1", "95% confidence"
6. Ignored CLAUDE.md self-adversarial discipline

### Process Improvements
1. **Test boundaries FIRST** before claiming "for all x"
2. **Verify against code** before formulating theorems
3. **Adversarial discipline EARLY** (kill bad ideas in 10 min)
4. **Mandatory checkpoints** before elaborate documentation
5. **Proper confidence calibration** (algebraic = "proven (not peer-reviewed)", numerical = "X% of N cases")

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
