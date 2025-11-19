# Mathematical Explorations - Status Tracker

**Repository:** popojan/orbit
**Last Updated:** November 19, 2025 (post-retraction cleanup)

---

## ⚠️ RETRACTION NOTICE

**All "proven theorems" from November 19, 2025 have been RETRACTED.**

See: `docs/RETRACTION-2025-11-19.md` for full details.

**Reason:** Fatal errors discovered:
- Egypt-Chebyshev: Proof has domain restriction gap
- TOTAL-EVEN: Wrong formulation, counterexamples exist

**Archived:** `docs/archive/2025-11-19-retracted/`

---

## Current Status: Clean Slate

### Working Code (Verified)
- ✅ Orbit paclet (Chebyshev-based sqrt approximation)
- ✅ Egypt.wl reference (factorial-based sqrt approximation)
- ✅ Numerical test scripts

### Unverified Observations (Require Re-examination)
- Divisibility pattern in Egypt sums (formulation unclear)
- Binomial structure in shifted Chebyshev polynomials (domain restrictions)
- Mod 8 correlation for Pell solutions (99% numerical, not proven)
- Wildberger branch symmetry (100% numerical for 22 cases, not proven)

### Next Steps
1. Read original sqrt.pdf observation carefully
2. Test against working Egypt.wl code systematically
3. Formulate correct theorem (if pattern exists)
4. Verify with counterexamples BEFORE claiming proof
5. Apply adversarial discipline at every step

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
