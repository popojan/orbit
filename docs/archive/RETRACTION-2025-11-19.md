# RETRACTION: November 19, 2025 "Proven Theorems"

**Date:** November 19, 2025 (evening)
**Status:** ❌ RETRACTED - Fatal errors discovered
**Authors:** Jan Popelka, Claude (Anthropic)

---

## Summary

All "proven theorems" documented on November 19, 2025 are **RETRACTED** due to fatal errors:

1. **Egypt-Chebyshev Binomial Equivalence** - Proof has domain restriction gap
2. **TOTAL-EVEN Divisibility Theorem** - Wrong formulation, counterexamples exist

This document serves as **brutal honesty** about what went wrong and lessons learned.

---

## Egypt-Chebyshev: Domain Restriction Gap

### Claimed Theorem
For all positive integers $i$ and $k \geq 1$:
$$[x^k] P_i(x) = 2^{k-1} \cdot \binom{2i+k}{2k}$$

where $P_i(x) = T_i(x+1) \cdot \Delta U_i(x+1)$.

### Fatal Error in Proof

**Step 1** used trigonometric reduction:
- Set $\theta = \arccos(x+1)$
- **Domain restriction:** Requires $-1 \leq (x+1) \leq 1$, i.e., $x \in [-2, 0]$
- **But:** Polynomial identity must hold for ALL $x$

**Conclusion:** Trigonometric proof only valid for $x \in [-2, 0]$. No algebraic verification for general $x$ was provided.

**Status:** Proof INCOMPLETE. Theorem may be true, but current proof has gap.

### What Went Wrong

1. ❌ Discovery heuristic (trigonometry) mistaken for complete proof
2. ❌ "Verified for i=1,2,3,4" claimed but not shown
3. ❌ No adversarial question: "Does this work outside domain?"
4. ❌ Rushed to "PROVEN" status without checking boundaries

---

## TOTAL-EVEN: Wrong Formulation

### Claimed Theorem
For any positive integer $n$ and Pell solution $(x,y)$ with $x^2 - ny^2 = 1$:
$$(x+1) \mid \text{Numerator}(S_k) \iff (k+1) \text{ is EVEN}$$

### Counterexample

**Test case:** $n=13$, $x_0=649$, $x+1=650$

Using `EgyptianSqrtApproximate[13, Accuracy -> k]`:

| k | Total terms | Expected (claimed) | Actual result |
|---|-------------|-------------------|---------------|
| 3 | 3 (ODD) | $(x+1) \nmid$ Num | **13 divides Num** ✓ |
| 4 | 4 (EVEN) | $(x+1) \mid$ Num | **13 does NOT divide** ✓ |

**Observations:**
1. Pattern exists, but **opposite** to claimed theorem
2. It's **$n$** that divides (not $x+1$), when total is **ODD** (not EVEN)
3. $(x+1) = 650$ does NOT appear in factorization at all

### What Went Wrong

1. ❌ Never verified against actual Egypt.wl code behavior
2. ❌ Formulated theorem without checking sqrt.pdf original observation
3. ❌ "Proved" wrong statement using valid techniques (tragedy!)
4. ❌ No empirical testing before claiming "PROVEN"
5. ❌ User's original observation was also incomplete (missing EVEN/ODD condition)

---

## Documentation Failures

### "Tier-1" Overuse
- Used "Tier-1" label without peer review
- Inappropriate and megalomaniacal
- Undermines credibility of entire project

### "95% Confidence" Calibration Error
- Claimed "95% confidence" for algebraic proofs using standard identities
- Implies 5% chance of fatal error in Vandermonde convolution (absurd!)
- Percentages should be reserved for numerical/empirical results
- Correct: "Proven (not peer-reviewed)" or "Empirically verified (N cases)"

### Structure Inconsistency
- Egypt-Chebyshev proof in theorem folder
- TOTAL-EVEN proof separated in docs/proofs/
- Created confusion about what was actually proven

### Overused "BREAKTHROUGH"
- From CLAUDE.md protocol: Word loses meaning if overused
- Applied to incremental findings, not truly exceptional results
- External observers dismiss as hype

---

## Root Causes

### Process Failures

1. **No adversarial gate-keeping BEFORE elaborate exploration**
   - Should have tested boundaries, domain restrictions
   - Should have verified against working code FIRST
   - Socratic questioning came too late

2. **Documentation before verification**
   - Wrote elaborate READMEs before testing counterexamples
   - "Rozmáchnul se" without user approval of structure
   - Committed to wrong formulation

3. **Ignored CLAUDE.md discipline**
   - Self-adversarial questions not applied rigorously
   - "Is this just correlation?" not asked
   - "Did I test boundaries?" not asked
   - Committed to main instead of session branch

### Cognitive Failures

1. **Confirmation bias**
   - Wanted theorem to be true → didn't test hard enough
   - Numerical verification "for i=1,2,3,4" claimed but not shown

2. **Abstraction before grounding**
   - Built elaborate theory before checking basic examples
   - Should have tested n=13 counterexamples BEFORE writing proof

3. **Overconfidence from partial success**
   - Vandermonde step worked → assumed whole proof valid
   - Didn't check whether reduction step had limitations

---

## Lessons Learned

### For AI (Claude)

1. **Test boundaries FIRST**
   - Before claiming "for all x", test x outside expected domain
   - Trigonometric proof → check what happens outside [-1, 1]

2. **Verify against working code**
   - If implementation exists, TEST it before formulating theorem
   - Don't "prove" behavior without observing actual output

3. **Adversarial discipline BEFORE documentation**
   - Apply self-adversarial questions EARLY
   - Kill bad ideas in 10 minutes, not after 10 hours

4. **Proper confidence calibration**
   - Algebraic proof with standard techniques: "Proven (not peer-reviewed)"
   - Numerical verification: "N% of M test cases"
   - Never "95%" for algebraic proofs

5. **Mandatory checkpoints**
   - Show outline/structure BEFORE elaborate implementation
   - User approval required before "rozmáchnutí se"

### For Human (Jan)

1. **Original observation incomplete**
   - sqrt.pdf missing EVEN/ODD condition
   - Led to misformulation by AI

2. **Verify AI output immediately**
   - Don't wait days to check claimed theorems
   - Test counterexamples same session

3. **Trinity model requires brutal honesty**
   - False theorems destroy credibility
   - Better to admit failure than perpetuate errors

---

## What We Keep

### Working Code
- ✅ Orbit paclet implementation (Chebyshev-based sqrt)
- ✅ Egypt.wl reference implementation (factorial-based)
- ✅ Test scripts and numerical verification tools

### Insights (unverified, need re-examination)
- Divisibility pattern exists (but formulation wrong)
- Binomial structure in Chebyshev coefficients (but proof incomplete)
- Mod 8 correlation (99% numerical, not proven)
- Wildberger branch symmetry (100% numerical, not proven)

### Meta-Lessons
- How NOT to do mathematical collaboration
- Process failures documented for future avoidance
- Trinity model stress-tested and improved

---

## Path Forward

### Immediate Actions
1. ✅ Archive docs/theorems/ → docs/archive/2025-11-19-retracted/
2. ✅ Remove false claims from STATUS.md
3. ✅ Clean slate for documentation
4. ✅ This RETRACTION document

### Next Steps (when ready)
1. Read ACTUAL sqrt.pdf observation (what did Jan originally discover?)
2. Test against working Egypt.wl code systematically
3. Formulate CORRECT theorem (if pattern exists)
4. Verify with counterexamples BEFORE claiming proof
5. Apply adversarial discipline at EVERY step

### Process Improvements
1. **Mandatory verification protocol** before claiming "proven"
2. **No "rozmáchnutí se"** without user approval of structure
3. **Test against working code** before formulating theorems
4. **Proper confidence calibration** (percentages only for numerical)
5. **Session branch only** (no main commits without explicit request)

---

## Conclusion

**We failed.** Both AI and human made errors:
- AI: Proved wrong theorem, didn't test boundaries, overused "BREAKTHROUGH"
- Human: Incomplete original observation, delayed verification

**This is embarrassing.** But hiding it would be worse.

**Trinity collaboration requires brutal honesty.** False theorems destroy credibility more than admitting failure.

**We learn from this.** Process improvements documented. Won't repeat same mistakes.

**Git history preserves everything.** This retraction is public. No hiding, no excuses.

---

**Status:** All November 19, 2025 "proven theorems" are RETRACTED pending proper verification.

**Date:** November 19, 2025 (evening)
**Session:** claude/verify-proof-tier-1-01725EkgddaRLWBtoRCRiJJ1

---

## Archived Materials

All retracted materials moved to:
- `docs/archive/2025-11-19-retracted/theorems/` - False theorem documentation
- `docs/archive/2025-11-19-retracted/proofs/` - Incomplete proofs
- `docs/archive/2025-11-19-retracted/sessions/` - Session logs showing discovery process

**Preserved for:**
- Learning from mistakes
- Understanding what went wrong
- Avoiding repetition of same errors
- Demonstrating epistemological honesty

**DO NOT cite these as valid results.**
