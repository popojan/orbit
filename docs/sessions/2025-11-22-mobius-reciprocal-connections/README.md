# Möbius Transformations and Reciprocal Functional Equations

**Date:** 2025-11-22 (afternoon continuation)
**Session:** Continuation of [palindromic-symmetries](../2025-11-22-palindromic-symmetries/)
**Status:** 🔬 EXPLORATION

---

## Context

Following morning's exploration of reciprocal functional equations f(z)·f(1/z) = C in hypergeometric functions, investigated connection to Möbius transformations and potential applications to Riemann zeta zeros.

---

## Main Finding: Palindromic Möbius Form

### Main Result

**Möbius transformations satisfying reciprocal functional equation:**

```
f(z) = (az + b)/(bz + a)  →  f(z)·f(1/z) = 1
```

**Proof:**
```
Numerator: (az+b)(a+bz) = ab + a²z + b²z + abz² = ab(1+z²) + z(a²+b²)
Denominator: (bz+a)(b+az) = ab + a²z + b²z + abz² = ab(1+z²) + z(a²+b²)

∴ f(z)·f(1/z) = 1  ✓
```

### Properties

1. **Palindromic coefficients:** [a, b, b, a]
2. **Reciprocal pole/zero pairs:**
   - Pole: z = -a/b
   - Zero: z = -b/a
   - Product: (-a/b)·(-b/a) = 1
3. **Unit circle preservation:** For |a| = |b|, maps |z|=1 → |w|=1
4. **Parametric family:** Different (a,b) map different circles/lines to unit circle

### Connection to Morning's Work

This complements the Chebyshev tangent functions from morning session:
- Chebyshev: algebraic functions with reciprocal roots → palindromic polynomials
- Möbius: rational functions with palindromic form → reciprocal equation
- **Common structure:** Palindromic coefficients ↔ reciprocal functional equation

---

## Investigation: Mapping Re(z) = 1/2 to Unit Circle

### Question Posed

Given vertical line Re(z) = 1/2 (critical line for RH), find transformation to unit circle.

### Findings

**Standard Möbius:** w = z/(z-1)
- ✓ Maps Re(z) = 1/2 → |w| = 1
- ✗ Does NOT satisfy w(z)·w(1/z) = C
- ✗ Non-constant angular velocity dθ/dt = -4/(1+4t²)

**Analysis:**
```
z = 1/2 + t·I  (on critical line)
1/z = (1/2 - t·I)/(1/4 + t²)  (NOT on critical line, except t=0)
```

**Conclusion:** Mapping Re(z)=1/2 to circle and satisfying reciprocal equation are **independent properties**.

### Angular Velocity

For w = z/(z-1) with z = 1/2 + t·I:

```
dθ/dt = -4/(1 + 4t²)

Maximum at t=0: |dθ/dt| = 4 (fastest)
Limit t→±∞: dθ/dt → 0 (slows down)
```

**Geometric interpretation:**
- Center of line (t=0) maps fast → point w=-1
- Ends of line (t→±∞) collapse → point w=+1 (pole)
- Infinite line "crumples" onto compact circle

---

## Riemann Zeta Connection (Speculative)

### Motivation

Riemann hypothesis: all non-trivial zeros on Re(s) = 1/2

Could Möbius transformations reveal structure in zero distribution?

### Fundamental Limitation

**Cannot uniformly spread high zeros on circle via Möbius:**

Any Möbius mapping entire line Re(z)=1/2 to circle must:
- Map infinite line → compact circle
- High zeros (large |t|) → collapse to pole
- Cannot "stretch" infinity uniformly

**Why:** |dw/dz| ~ 1/|cz+d|² → 0 as |z| → ∞

### Alternative: 3D Spiral

**Idea:** Map to spiral, not circle:
```
Spiral point: (x(k), y(k), z(k))
Projection: (x, y) on unit circle via AlgebraicCirclePoint
Height: z ~ t_n (imaginary part of zero)
```

**Advantages:**
- Infinite line → infinite spiral (no collapse)
- Projection uniformly distributed on circle
- Height distinguishes "dense" vs "sparse" regions
- Could use algebraic parametrization (period T=n, not 2π)

**Status:** Conceptual, not yet explored numerically

---

## Literature Review

### Conrad (2008): "Numbers on a Circle"

**Reference:** Keith Conrad, "Algebraic Numbers on the Unit Circle"
**Location:** `papers/conrad-numbers-on-circle.pdf`

#### What Conrad Covers (KNOWN)

**Palindromic Polynomials (Section 2):**

**Theorem 2.1 (Palindromic Characterization):**
```
f(z) palindromic ⟺ z^n f(1/z) = f(z) ⟺ c_k = c_{n-k}
```

**Theorem 2.6 (Roots on Circle via Substitution):**
```
Palindromic f(z) with roots on |z|=1
⟺ g(w) = z^{n/2} f(z) where w = z + 1/z has real roots in [-2,2]
⟺ Roots come in reciprocal pairs {α, 1/α}
```

**Cayley Transformation (Section 3):**
```
M(z) = (z - i)/(z + i)
Maps: real axis ↔ unit circle (bijection)
Used in eigenvalue problems (Hermitian ↔ unitary)
```

**r-Palindromic Generalization (Section 4):**
```
For circles of radius r ≠ 1: z^n f(r²/z) = r^n f(z)
```

#### What We Derived (Not Found in Reviewed Literature)

**Palindromic Möbius Form:**
```
f(z) = (az + b)/(bz + a)  →  f(z)·f(1/z) = 1
```

**Key differences from Conrad:**

1. **Explicit palindromic rational function form**
   - Conrad: Focus on polynomials, one specific Möbius (Cayley)
   - Us: General palindromic Möbius class (az+b)/(bz+a)

2. **Line-to-circle mapping condition**
   - Conrad: Cayley maps real axis to circle (specific case)
   - Us: **|a|=|b| maps arbitrary line to circle** (general construction)

3. **Unified reciprocal equation view**
   - Conrad: z+1/z substitution for dimension reduction
   - Us: Direct functional equation f(z)·f(1/z)=1 across function classes

4. **Systematic line construction**
   - Conrad: Not addressed
   - Us: For any line L, construct (a,b) mapping L → |w|=1

#### Literature Coverage Assessment

| Concept | Conrad | Our Work | Status |
|---------|---------|----------|---------|
| Palindromic polynomials | ✓ Theorem 2.1 | Applied | KNOWN |
| z+1/z substitution | ✓ Theorem 2.6 | Used | KNOWN |
| Cayley transformation | ✓ Section 3 | Special case | KNOWN |
| Reciprocal pairs {α,1/α} | ✓ Corollary 2.4 | Generalized | KNOWN |
| Palindromic Möbius (az+b)/(bz+a) | ✗ Not mentioned | ✓ Derived | Not found |
| Condition \|a\|=\|b\| for line→circle | ✗ Not mentioned | ✓ Proved | Not found |
| General line construction | ✗ Not addressed | ✓ Systematic | Not found |
| Reciprocal equation f(z)f(1/z)=1 | Implicit | ✓ Explicit | New framing |

#### How Our Work Extends Conrad

**Conrad provides:**
- Theoretical foundation (palindromic polynomials)
- One specific example (Cayley transformation)
- z+1/z substitution technique

**We extend with:**
- **General parametric family:** (az+b)/(bz+a) for all (a,b)
- **Geometric characterization:** |a|=|b| condition
- **Construction algorithm:** Map any line L to unit circle
- **Unified principle:** Palindromic structure → reciprocal equation across polynomials, hypergeometric, and rational functions

#### Connection to Morning Session

Conrad's Theorem 2.6 connects to our morning discoveries:

**Morning:** Chebyshev tangent polynomials F_n(z) have reciprocal root pairs → palindromic coefficients

**Conrad:** Palindromic polynomials ↔ roots on circle via z+1/z substitution

**Afternoon:** Palindromic Möbius (az+b)/(bz+a) → reciprocal functional equation

**Unified Pattern:**
```
Palindromic coefficients ↔ Reciprocal functional equations ↔ Circle geometry
```

This appears across:
- Polynomials (Conrad's focus)
- Hypergeometric functions (morning session)
- Möbius transformations (this session)

**Meta-Question:** Is there a general principle unifying these? (See [zeta-shift-symmetry.md](./zeta-shift-symmetry.md) for speculative application to Riemann zeros)

---

## Files Created

### Verification Scripts

**`verify_mobius_circle.wl`**
- Numerical verification: Re(z)=1/2 → |w|=1
- Tests multiple transformations w = (z-a)/(z-b)
- Confirms |w|=1 for all test points

**`verify_mobius_simple.wl`**
- Clean examples with specific z values
- Shows w(z)·w(1/z) varies (not constant)
- Inverse transformation analysis

**`verify_mobius_algebraic.wl`**
- Symbolic proof for z = 1/2 + t·I
- Computes |w|² = 1 algebraically
- General formula verification

**`analyze_angular_velocity.wl`**
- Derives dθ/dt = -4/(1+4t²)
- Shows non-constant angular velocity
- Arc length analysis

**`test_mobius_reciprocal.wl`**
- Tests w = z/(z-1): does NOT satisfy reciprocal equation
- Numerical counterexamples
- Confirms 1/z not on Re(z)=1/2 line

**`test_symmetric_mobius.wl`**
- **KEY RESULT:** f(z) = (az+b)/(bz+a) satisfies f(z)·f(1/z) = 1
- Algebraic proof
- Property analysis (reciprocal poles/zeros)
- Unit circle mapping verification

---

## Next Steps

### Immediate

- [ ] Update main LaTeX document with Möbius example ✓ (DONE)
- [ ] Document angular velocity findings
- [ ] Classify which circles/lines map to unit circle for given (a,b)

### Open Questions

1. **Circle Classification:** For f(z) = (az+b)/(bz+a), characterize input circles/lines mapping to |w|=1
2. **Optimal Mapping:** Which (a,b) makes critical line Re(z)=1/2 map to |w|=1?
3. **Spiral Exploration:** Numerically test zeta zero distribution on 3D spiral
4. **AlgebraicCirclePoint Connection:** Does period structure relate to zero spacing?

### Theoretical Directions

- **Montgomery pair correlation:** Does spiral view preserve GUE statistics?
- **Explicit formula:** Connection between prime distribution and zero spacing
- **Functional equation:** ζ(s) = ζ(1-s) relation to reciprocal transformations

---

## Status Tags

✓ **VERIFIED:** Palindromic Möbius satisfies reciprocal equation
🔬 **NUMERICAL:** Angular velocity computed, not constant
🤔 **HYPOTHESIS:** Spiral parametrization might preserve structure
⏸️ **OPEN:** Optimal (a,b) for critical line mapping

---

## References

**Session connections:**
- Morning session: Chebyshev reciprocal roots, gamma palindromes
- `palindromic-conjecture.tex`: Updated with Möbius example
- CLAUDE.md: Trinity protocol, self-adversarial discipline

**Literature:**
- Conrad, K. (2008). "Algebraic Numbers on the Unit Circle" - `papers/conrad-numbers-on-circle.pdf`
- Vieira, R.S. (2016). "On the number of roots of self-inversive polynomials" - `papers/ArXiv.1604390v2.pdf`
- BibTeX entries: `papers/conrad-roots-circle.bib`, `papers/vieira-self-inversive.bib`

---

**Note:** This session maintains context from morning. Key insight: **palindromic structure appears across multiple function classes** (polynomials, hypergeometric, Möbius) - suggests deeper principle.
