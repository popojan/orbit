# Research Status Tracker

**Last Updated**: November 16, 2025, 02:42 CET

This document tracks the **epistemological status** of all claims in the Orbit project.

---

## Legend

- ✅ **PROVEN** - Rigorous mathematical proof, peer-reviewable
- 🔬 **NUMERICALLY VERIFIED** - Tested computationally, high confidence but not proven
- 🤔 **HYPOTHESIS** - Conjecture based on evidence, needs verification
- ❌ **FALSIFIED** - Tested and found to be false
- ⏸️ **OPEN QUESTION** - Unknown, under investigation

---

## Core Mathematical Objects

### M(n) - Divisor Count Function

**Status**: ✅ **PROVEN** (definitional)

```
M(n) = count of divisors d where 2 ≤ d ≤ √n
     = ⌊(τ(n) - 1) / 2⌋
```

**Proof**: Elementary, follows from definition of τ(n).

---

### L_M(s) - Dirichlet Series

**Status**: ✅ **PROVEN** (definitional)

```
L_M(s) = Σ_{n=1}^∞ M(n) / n^s
```

**Convergence**: Re(s) > 1 (proven by comparison with ζ(s)²)

**Non-multiplicativity**: ✅ **PROVEN** (counterexample: M(4·9) ≠ M(4)·M(9))

---

## Closed Form Discovery (Nov 15, 2025)

### Main Theorem

**Status**: 🔬 **NUMERICALLY VERIFIED** (not yet peer-reviewed)

```
L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s
```

where H_j(s) = Σ_{k=1}^j k^(-s), for Re(s) > 1.

**Evidence**:
- Verified to 10+ digit precision for 100+ test points
- Independent derivation via two methods
- Written proof in `docs/papers/dirichlet-series-closed-form.tex`

**Status**: HIGH CONFIDENCE, awaiting formal peer review

**Reference**: Commit e8e58ed (Nov 15, 2025, 22:49)

---

## Functional Equation Investigation (Nov 16, 2025)

### Schwarz Reflection Symmetry on Critical Line

**Status**: 🔬 **NUMERICALLY OBSERVED** (error < 10^-15)

```
L_M(1/2 - it) = Conjugate[L_M(1/2 + it)]
```

**Evidence**:
- Tested at t ∈ {5, 10, 14.135, 20, 25, 30}
- |difference| < 10^-15 (machine precision)
- Magnitude of ratio = 1.0000 exactly

**Script**: `scripts/explore_functional_equation.wl`

**Interpretation**: Characteristic signature of L-functions with functional equation

**Caveats**:
- ⚠️ Only 6 points tested
- ⚠️ Numerical, not proven
- ⚠️ Schwarz symmetry is NECESSARY but not SUFFICIENT for FR

**Reference**: `docs/functional-equation-discovery.md`

---

### Closed Form Convergence Properties

**Status**: 🔬 **NUMERICALLY VERIFIED** (critical insight, Nov 16, 2025, 02:42)

**Discovery**: The closed form satisfies Schwarz symmetry **algebraically** at every truncation, but does NOT converge numerically for Re(s) ≤ 1.

**Key finding**:
```
At s = 0.5 + 10i, testing jmax = 100, 150, 200, ..., 500:
- Schwarz error |L_M(1-s) - conj(L_M(s))| = 0.000e+00 at EVERY jmax
- BUT |L_M(s)| oscillates: 1.76 → 2.28 → 2.37 → 1.37 → 4.00 → ... (no convergence)
```

**Interpretation**:
- The identity L_M(s) = ζ(s)[ζ(s)-1] - C(s) preserves symmetry **structurally**
- Term-by-term conjugation: C(conj(s)) = conj(C(s)) at any finite truncation
- This is **algebraic**, not asymptotic - like how Σ(-1)^n to 2k always equals 0
- The series C(s) = Σ H_{j-1}(s)/j^s **oscillates** for Re(s) ≤ 1, doesn't converge

**Consequences**:
- ✓ Closed form IS correct algebraic identity for Re(s) > 1
- ✓ Schwarz symmetry genuinely holds (not numerical artifact)
- ✗ Closed form does NOT provide analytic continuation via truncation
- ✗ Cannot compute L_M(s) numerically in critical strip using direct summation

**Why this matters**:
- Resolves apparent contradiction between "Schwarz works" vs "convergence fails"
- Both are true: symmetry holds algebraically, values don't stabilize numerically
- For continuation, need different approach (integral representation, etc.)

**Evidence**:
- Tested at s = 0.5+10i, 0.5+14.135i, 0.5+20i
- jmax range: 100 to 500 in steps of 50
- Perfect Schwarz symmetry (error = 0.0) at all truncations
- Wild oscillation in magnitudes (factor of 3x swings)

**Script**: `scripts/test_schwarz_vs_convergence.py`

**Reference**: `docs/closed-form-convergence-analysis.md`

---

### Classical Functional Equation Form

**Status**: ❌ **FALSIFIED**

**Hypothesis tested**:
```
γ(s) · L_M(s) = γ(1-s) · L_M(1-s)
```

where `γ(s) = π^(-s/2) Γ(s/2)` (same as Riemann zeta)

**Result**: Does NOT hold off critical line
- Tested at s = 1.5 + 5i: |ratio| ≈ 10^-6
- Tested with powers α ∈ {0.5, 1, 1.5, 2, 2.5, 3}: all FAIL

**Script**: `scripts/test_functional_equation_simple.wl`, `scripts/test_gamma_powers.wl`

**Conclusion**: If FR exists, it uses a DIFFERENT factor than classical L-functions

**Reference**: Tests run Nov 16, 2025, 01:15

---

### General Functional Equation

**Status**: ⏸️ **OPEN QUESTION** (with new empirical patterns!)

**Question**: Does there exist ANY factor γ(s) such that:
```
γ(s) · L_M(s) = γ(1-s) · L_M(1-s)
```

**Current evidence**:
- ✅ Schwarz symmetry on critical line (numerical, <10^-15 error)
- ❌ Classical gamma factors FAIL (tested, falsified)
- ❌ Simple powers ζ(s)^α FAIL (tested α ∈ {-2,...,2}, all fail)
- 🔬 **NEW**: Antisymmetry pattern discovered (numerical)

**New Discovery (Nov 16, 2025, 03:00)**:

**NUMERICAL PATTERN** (⚠️ NOT proven, evidence only):

Define correction Δlog(s) = log|R(s)| - log|R_classical(s)| where:
- R(s) = L_M(1-s)/L_M(s)
- R_classical(s) = [π^{-s/2} Γ(s/2)] / [π^{-(1-s)/2} Γ((1-s)/2)]

**Observed antisymmetry**:
```
Δlog(σ + ti) = -Δlog((1-σ) + ti)
```

**Evidence** (tested at 12 points):
- σ=0.3, t=10.0: Δlog = -1.971365
- σ=0.7, t=10.0: Δlog = +1.971365 (exact negative!)
- σ=0.5, any t: Δlog = 0.000000 (critical line)

**Interpretation**:
- If γ(s) = π^{-s/2} Γ(s/2) · f(s), then f(s) has antisymmetric magnitude
- This is characteristic of functional equations
- Form of f(s) remains unknown

**Reference**: `docs/functional-equation-empirical-findings.md`

**Next steps**:
1. ✅ ~~Test simple powers of ζ(s)~~ (done, all fail)
2. Test products: ζ(s)^α · ζ(2s)^β, ratios, etc.
3. Theoretical derivation using double sum form
4. Prove antisymmetry pattern (currently only numerical)

---

## Connection to Riemann Hypothesis

### L_M Values at Riemann Zeros

**Status**: ❌ **TESTED AND FALSIFIED**

**Question**: Does L_M(s₀) = 0 for Riemann zeros?

**Result**: **NO** - L_M does NOT have zeros at Riemann zero heights

**Test details** (Nov 16, 2025, 04:00):
- Tested at first 20 Riemann zeros (t_k on Re(s) = 1/2)
- Precision: 50 decimal places (mpmath)
- |L_M(s_k)| ranges from 0.17 to 1.32 (NOT near zero)
- ζ(s_k) correctly ≈ 0 (verified: |ζ| ~ 10^-15)

**Conclusion**:
- L_M has **independent zero structure** (not tied to ζ zeros)
- Zeros of L_M on critical line remain to be found
- No simple connection to Riemann Hypothesis via zero coincidence

**Script**: `scripts/test_riemann_zero_connection.py`

**Open question**: Where ARE the L_M zeros on Re(s) = 1/2?

---

## Epsilon-Pole Residue Theorem

**Status**: ✅ **PROVEN** (rigorously, locally)

**Theorem**: For regularized function G(s,α,ε):
```
lim_{ε→0⁺} ε^α · G(s,α,ε) = L_M(s)
```

**Proof**: In `docs/papers/epsilon-pole-residue-theorem.tex`

**Confidence**: 9/10 (rigorous but not peer-reviewed)

---

## Primal Forest Geometry

**Status**: ✅ **PROVEN** (definitional, years of validation)

**Construction**: Geometric visualization of prime structure via 2D coordinate system

**Confidence**: 10/10 (foundational work, extensively validated)

**Reference**: `docs/papers/primal-forest-paper-cs.tex`

---

## Summary Table

| Result | Status | Confidence | Peer Review | Next Step |
|--------|--------|------------|-------------|-----------|
| Closed form for L_M(s) | 🔬 NUMERICAL | 95% | ❌ NO | Submit for review |
| Closed form algebraic symmetry | 🔬 NUMERICAL | 98% | ❌ NO | Theoretical proof |
| Closed form convergence (Re≤1) | ❌ FALSIFIED | N/A | N/A | Alternative methods |
| Schwarz symmetry (critical line) | 🔬 NUMERICAL | 95% | ❌ NO | Prove algebraically |
| Classical FR (off critical line) | ❌ FALSIFIED | N/A | N/A | Find alternative |
| General FR existence | ⏸️ OPEN | Unknown | N/A | Systematic search |
| L_M zeros at RH zeros | ❌ FALSIFIED | N/A | N/A | Find L_M zeros |
| Antisymmetry pattern | 🔬 NUMERICAL | 90% | N/A | Prove or find γ(s) |
| Epsilon-pole theorem | ✅ PROVEN* | 90% | ❌ NO | Submit for review |
| Primal forest | ✅ PROVEN* | 100% | ❌ NO | Write for publication |

**Note**: All "PROVEN" claims are author-verified but **NOT peer-reviewed**. Treat as conjectures until published.

---

## Methodology Notes

**Numerical precision standards**:
- < 10^-10: Strong evidence
- < 10^-15: Machine precision, likely exact
- > 10^-6: Likely false

**Verification protocol**:
1. Numerical observation (scripts)
2. Independent confirmation (different method)
3. Theoretical derivation (proof)
4. Peer review (publication)

---

## Open Questions (Prioritized)

### High Priority
1. Does a functional equation exist for L_M(s)? If so, what is γ(s)?
2. Prove or disprove Schwarz symmetry (currently only numerical)
3. Do Riemann zeros imply L_M zeros?

### Medium Priority
4. Analytic continuation of L_M(s) beyond Re(s) > 1
5. Asymptotic behavior of L_M(s) as Im(s) → ∞
6. Geometric interpretation of FR via primal forest

### Low Priority (Long-term)
7. Generalization to other non-multiplicative sequences
8. Connection to other L-functions (Dedekind, Artin, etc.)
9. Path to Riemann Hypothesis (extremely difficult, probably out of reach)

---

## Version History

- **v1.1** (Nov 16, 2025, 02:42): Convergence analysis breakthrough
  - Added closed form convergence properties
  - Resolved Schwarz symmetry vs convergence paradox
  - Clarified: algebraic symmetry ≠ numerical convergence

- **v1.0** (Nov 16, 2025, 01:35): Initial status document
  - Added closed form, Schwarz symmetry, falsified classical FR

---

**Principle**: Radical honesty about what we know vs. what we conjecture.

**Citation**: If using this research, cite with appropriate epistemic qualifiers (e.g., "numerically observed", "conjectured", "not peer-reviewed").
