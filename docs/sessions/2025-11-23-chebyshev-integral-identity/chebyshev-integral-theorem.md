# Chebyshev Polynomial Integral Identity

**Date:** November 23, 2025
**Session:** Continuation from context overflow (2025-11-22 Egypt convergence analysis)

## Executive Summary

Discovered and proved integral identity for Chebyshev polynomials T_k:

**Main Result:** For k ≥ 2,
```
∫_{-1}^{1} |T_{k+1}(x) - x·T_k(x)| dx = 1
```

**Related Identity:** Simplified integrals (without absolute value) give a different sequence:
```
AB[k] = { 1/k                           k odd
        { -(1/(k+1) + 1/(k-1))/2        k even
```

Note: AB[k] ≠ 1 (different integral, different results). Main result verified symbolically and proven using trigonometric substitution.

---

## Geometric Motivation

Define f(x,k) = T_{k+1}(x) - x·T_k(x).

**Unit Circle Constraint:** Points (x, f(x,k)) satisfying x² + f(x,k)² = 1:
- **Boundary singularities:** (±1, 0)
- **Interior points:** k distinct x-values in (-1,1), each with ±f(x,k)
- **Total:** 2k interior points + 2 boundary points

**Structure:** The k interior x-values correspond to vertices of a regular k-gon inscribed in the unit circle, with each vertex appearing as a double root.

**Examples:**
- k=2: square (4 vertices as double roots)
- k=3: hexagon (6 vertices as double roots)
- k=4: octagon (8 vertices as double roots)

---

## Main Theorem

### Statement

**Theorem 1 (Chebyshev Integral Identity):**

For all integers k ≥ 2,
```
∫_{-1}^{1} |T_{k+1}(x) - x·T_k(x)| dx = 1
```

where T_k(x) denotes the Chebyshev polynomial of the first kind of degree k.

**Special Case:** For k = 1,
```
∫_{-1}^{1} |T_2(x) - x·T_1(x)| dx = 4/3
```

### Historical Form

**User's Original Question:**
```
How to show that ∫_{-1}^{1} |f(x,k)| dx = 1 for any natural k,
where f(x,k) = T_{k+1}(x) - x·T_k(x)?
```

### Connection to Chebyshev Polynomials of Second Kind

From Mason & Handscomb (2002), the mutual recurrence relation gives:

```
T_{k+1}(x) - x·T_k(x) = -(1-x²)·U_{k-1}(x)
```

where U_k are Chebyshev polynomials of the second kind.

Therefore:
```
∫_{-1}^{1} |T_{k+1}(x) - x·T_k(x)| dx = ∫_{-1}^{1} (1-x²)|U_{k-1}(x)| dx
```

This identity does not appear in standard references (Mason & Handscomb, MathWorld, DLMF).

---

## Proof

### Step 1: Simplification via Recurrence

Using the three-term recurrence T_{k+1}(x) = 2x·T_k(x) - T_{k-1}(x):

```
f(x,k) = T_{k+1}(x) - x·T_k(x)
       = [2x·T_k(x) - T_{k-1}(x)] - x·T_k(x)
       = x·T_k(x) - T_{k-1}(x)
```

### Step 2: Trigonometric Substitution

Let x = cos(θ), dx = -sin(θ) dθ.

Using T_k(cos θ) = cos(kθ):

```
f(cos θ, k) = cos(θ)·cos(kθ) - cos((k-1)θ)
```

**Product-to-sum formula:**
```
cos(θ)·cos(kθ) = [cos((k+1)θ) + cos((k-1)θ)]/2
```

Therefore:
```
f(cos θ, k) = [cos((k+1)θ) + cos((k-1)θ)]/2 - cos((k-1)θ)
            = [cos((k+1)θ) - cos((k-1)θ)]/2
```

**Difference formula:**
```
cos(A) - cos(B) = -2·sin((A+B)/2)·sin((A-B)/2)
```

Therefore:
```
f(cos θ, k) = -sin(kθ)·sin(θ)
```

### Step 3: Integral Transformation

```
I_k = ∫_{-1}^{1} |f(x,k)| dx
    = ∫_{π}^{0} |-sin(kθ)·sin(θ)| · |-sin(θ)| dθ
    = ∫_{0}^{π} |sin(kθ)|·sin²(θ) dθ
```

(For θ ∈ [0,π], sin(θ) ≥ 0, so reversing limits removes both minus signs)

### Step 4: Fourier Decomposition

Using sin²(θ) = (1 - cos(2θ))/2:

```
I_k = (1/2)·[A_k - B_k]
```

where:
```
A_k = ∫_{0}^{π} |sin(kθ)| dθ
B_k = ∫_{0}^{π} |sin(kθ)|·cos(2θ) dθ
```

### Step 5: Lemma 1 - Value of A_k

**Lemma 1:** For all k ≥ 1, A_k = 2.

**Proof:**

|sin(kθ)| has period π/k. Over [0,π], it completes k half-periods.

```
A_k = ∫_{0}^{π} |sin(kθ)| dθ
    = k·∫_{0}^{π/k} sin(kθ) dθ
    = k·[-cos(kθ)/k]_{0}^{π/k}
    = k·[(−cos(π) + cos(0))/k]
    = k·[2/k]
    = 2
```

**Verified symbolically:** Mathematica confirms A_k = 2 for k = 1..12.

### Step 6: Lemma 2 - Value of B_k

**Lemma 2:** For all k ≥ 2, B_k = 0.

**Proof (Symmetry Argument):**

Let φ = θ - π/2 (shift origin to midpoint).

**For |sin(k(φ + π/2))|:**
- k even: sin(kπ/2) = 0 → |sin(k(φ + π/2))| = |cos(kφ)| (even in φ)
- k odd: cos(kπ/2) = 0 → |sin(k(φ + π/2))| = |cos(kφ)| (even in φ)

**For cos(2(φ + π/2)):**
```
cos(2φ + π) = -cos(2φ)  (odd in φ)
```

**Result:** Integral of (even function) × (odd function) over symmetric interval = 0.

**Verified symbolically:** Mathematica confirms B_k = 0 for k = 2..10, with B_7 requiring FullSimplify.

**Special case k=1:**
```
B_1 = ∫_{0}^{π} |sin(θ)|·cos(2θ) dθ = -2/3
```

(Both sin(θ) and cos(2θ) are odd about π/2, so product is even → nonzero)

### Step 7: Conclusion

For k ≥ 2:
```
I_k = (A_k - B_k)/2 = (2 - 0)/2 = 1
```

For k = 1:
```
I_1 = (2 - (-2/3))/2 = 4/3
```

**Q.E.D.** ∎

---

## Related Identity: Simplified Integrals (Without Absolute Value)

**Note:** This section explores a **different integral** than the main theorem. The main theorem uses |sin(kθ)|·sin²(θ), while this uses sin(kθ)·sin²(θ) without absolute value. The results are different: main theorem gives 1, while this gives AB[k] ≠ 1.

### Definitions

Computing without absolute value and with cos(θ) instead of cos(2θ):

```mathematica
Ak[k_] := Integrate[Sin[k θ], {θ, 0, π}]
Bk[k_] := Integrate[Sin[k θ] Cos[θ], {θ, 0, π}]
AB[k_] := (Ak[k] - Bk[k])/2
```

### Results

**A_k pattern:**
- **Odd k:** A_k = 2/k
- **Even k:** A_k = 0

**B_k pattern:**

Using product-to-sum: sin(kθ)·cos(θ) = [sin((k+1)θ) + sin((k-1)θ)]/2

Therefore: **B_k = (A_{k+1} + A_{k-1})/2**

Verified symbolically for k = 1..10.

### Unified Formula

**Theorem 2 (Simplified Integral Identity):**

Define AB[k] := (A_k - B_k)/2 where A_k, B_k as above. Then:

```
AB[k] = { 1/k                           k odd
        { -(1/(k+1) + 1/(k-1))/2        k even
```

**Explicit values:**
- AB[1] = 1
- AB[2] = -2/3
- AB[3] = 1/3
- AB[4] = -4/15
- AB[5] = 1/5
- AB[6] = -6/35
- AB[7] = 1/7
- AB[8] = -8/63
- AB[9] = 1/9
- AB[10] = -10/99

**Asymptotic behavior:**

Both odd and even cases approach **~±1/k** for large k:
- Odd: AB[k] = 1/k exactly
- Even: AB[2m] ~ -1/(2m) = -1/k for large m

This **1/k structure** may have significance in hyperbolic geometry interpretation of Egypt method.

### Closed Forms

**For even k = 2m:**

From B_{2m} = (A_{2m+1} + A_{2m-1})/2 = (2/(2m+1) + 2/(2m-1))/2:

```
AB[2m] = (0 - (1/(2m+1) + 1/(2m-1)))/2
       = -(2m+1 + 2m-1)/[2(2m+1)(2m-1)]
       = -4m/[2(4m²-1)]
       = -2m/(4m²-1)
```

Verified symbolically for m = 1..7.

**For odd k = 2m+1:**

From direct computation: **AB[2m+1] = 1/(2m+1)**

Verified symbolically for m = 0..6.

### x-domain Representation

**Inverse transformation:** The simplified integrals can be expressed in x-coordinates.

Using the substitution x = cos(θ), dx = -sin(θ) dθ, and the relation:
```
sin(kθ) = -f(x,k)/√(1-x²)
```

The integrand transforms as:
```
g(x,k) = (1-x)·U_{k-1}(x)/2 = -f(x,k)/(2·(1+x))
```

where U_{k-1}(x) is the Chebyshev polynomial of the second kind.

**Verification:**
```
∫_{-1}^{1} g(x,k) dx = AB[k] = (A_k - B_k)/2
```

This follows from the mutual recurrence relation (Mason & Handscomb):
```
f(x,k) = T_{k+1}(x) - x·T_k(x) = -(1-x²)·U_{k-1}(x)
```

Therefore:
```
g_A(x,k) = -f(x,k)/(1-x²) = U_{k-1}(x)
g_B(x,k) = -x·f(x,k)/(1-x²) = x·U_{k-1}(x)
g(x,k) = (g_A - g_B)/2 = (1-x)·U_{k-1}(x)/2
```

### Generating Function

**Definition:** For the sequence {AB[k]}, define the ordinary generating function:
```
G(z) = Σ_{k=1}^∞ AB[k]·z^k
```

#### Closed Form

**Theorem 3 (Generating Function Identity):**

The generating function G(z) has closed form in elementary transcendental functions:

```mathematica
G(z) = ArcTanh(z) + [2z + (1+z²)Log[(z-1)²]/2 - (1+z²)Log(1+z)] / (4z)
```

**Derivation:** Using the integral representation of AB[k] and the geometric series identity:
```
Σ_{k=1}^∞ z^k sin(kθ) = z·sin(θ) / (1 - 2z·cos(θ) + z²)
```

we obtain:
```
G(z) = (1/2) ∫₀^π [1-cos(θ)]·z·sin(θ)/(1-2z·cos(θ)+z²) dθ
```

Mathematica evaluates this integral to the closed form above.

#### Properties

**Radius of convergence:** R = 1
- Series converges for |z| < 1
- Diverges for |z| > 1
- Closed form provides analytic continuation

**Special values:**
```
G(1/2) = 1/2 - Log[3]/8 ≈ 0.3627
lim_{z→1⁻} G(z) = 1/2  (Cesàro/Abel sum)
```

**Power series expansion:**
```
G(z) = z - (2z²)/3 + z³/3 - (4z⁴)/15 + z⁵/5 - (6z⁶)/35 + z⁷/7 - (8z⁸)/63 + ...
```

Coefficients match AB[k] exactly:
- Odd k: coefficient = 1/k
- Even k: coefficient = -(1/(k+1) + 1/(k-1))/2

**Coefficient extraction:**
```mathematica
AB[k] = SeriesCoefficient[G[z], {z, 0, k}]
      = (1/k!) · [d^k/dz^k G(z)]_{z=0}
```

#### Sum Identity

**Theorem 4 (Regularized Sum):**

The oscillating series Σ AB[k] has Cesàro/Abel sum equal to 1/2:

```
lim_{N→∞} (1/N) Σ_{n=1}^N S_n = 1/2
lim_{z→1⁻} G(z) = 1/2
```

where S_n = Σ_{k=1}^n AB[k].

**Proof:** Decompose into odd and even terms:
```
Σ AB[2m+1] = Σ 1/(2m+1)           (diverges)
Σ AB[2m]   = -Σ 1/(2m+1) + 1/2    (from closed form)
Total      = 1/2
```

Verified numerically: partial sums oscillate around 1/2 with amplitude ~ 1/N.

---

## Unified Formulas

### Trigonometric Form (Main Theorem)

```
I_k = (1/2)·[A_k - B_k]

where:
  A_k = ∫_{0}^{π} |sin(kθ)| dθ = 2
  B_k = ∫_{0}^{π} |sin(kθ)|·cos(2θ) dθ = { -2/3  k=1
                                           {  0    k≥2
```

Result:
```
I_k = { 4/3  k=1
      {  1   k≥2
```

### Polynomial Form (Alternative)

```
∫_{-1}^{1} |x·T_k(x) - T_{k-1}(x)| dx = { 4/3  k=1
                                         {  1   k≥2
```

### Chebyshev Second Kind Form

```
∫_{-1}^{1} (1-x²)|U_{k-1}(x)| dx = { 4/3  k=1
                                     {  1   k≥2
```

### Simplified Integral Form (Different from Main Theorem)

**Note:** This is a related but different integral. Unlike the main theorem (which equals 1 for k≥2), AB[k] varies with k.

```
AB[k] = (1/2)·[∫_{0}^{π} sin(kθ) dθ - ∫_{0}^{π} sin(kθ)·cos(θ) dθ]

      = { 1/k                           k odd
        { -(1/(k+1) + 1/(k-1))/2        k even
```

---

## Why k=1 is Exceptional

### Analysis

For k=1:
```
f(x,1) = x·T_1(x) - T_0(x) = x² - 1
```

**Key properties:**
1. **No interior roots:** f(x,1) = 0 only at x = ±1 (boundary)
2. **No oscillation:** f(x,1) < 0 for all x ∈ (-1,1)
3. **Different scaling:** ∫_{-1}^{1} |x² - 1| dx = 4/3 ≠ 1

### Geometric Interpretation

- **k=1:** Parabola touching zero only at endpoints
- **k≥2:** Oscillating functions with interior roots creating balanced positive/negative regions

### Root Analysis

Number of roots in [-1,1]:
- k=1: 2 roots (both at boundary)
- k=2: 3 roots (includes x=0 interior)
- k=3: 4 roots (includes x=±1/2)
- k=4: 5 roots
- General: k+1 roots for k≥2

**Pattern:** k≥2 have interior roots creating oscillatory behavior that integrates to exactly 1.

### T_0 Exceptional

T_0(x) = 1 is the only **constant** Chebyshev polynomial (degree 0).

All T_k for k≥1 are **oscillatory** with k roots in (-1,1).

The combination x·T_1(x) - T_0(x) inherits non-oscillatory behavior from T_0.

---

## Literature Context

### Standard References

**Mason, J.C., & Handscomb, D.C. (2002).** *Chebyshev Polynomials.* Chapman & Hall/CRC.
- Chapters: Orthogonality, Integration using Chebyshev Polynomials
- Mutual recurrence: T_{k+1}(x) - x·T_k(x) = -(1-x²)·U_{k-1}(x)
- Standard integrals of T_k and U_k

**DLMF (Digital Library of Mathematical Functions)**
- Recurrence relations (§18.9)
- Orthogonality properties

**MathWorld - Wolfram**
- Chebyshev Polynomial of the First Kind
- Integration formulas

### What We Found

✓ **Known:** Recurrence relations, individual polynomial integrals
✓ **Known:** Relationship T_k ↔ U_k via T_{k+1} - x·T_k
✗ **Not found:** Integral ∫_{-1}^{1} |T_{k+1}(x) - x·T_k(x)| dx = 1
✗ **Not found:** 1/k structure in simplified form

**Conclusion:** Likely **new result** or minimally not standard/widely cited.

---

## Computational Verification

### Symbolic (Mathematica)

**Main theorem:** Verified for k = 1..8 using `Integrate[Abs[...]]`
- k=2..6: Returns exact integer 1
- k=7,8: Returns Root expressions that FullSimplify to 1

**Simplified form:** Verified for k = 1..10
- Odd k: AB[k] = 1/k exactly
- Even k: AB[k] matches closed form exactly

### Numerical (30+ digits)

Computed `NIntegrate[|sin(kθ)|·sin²(θ), {θ,0,π}]` for k=2..12:
- All values = 1.000...000 (error < 10^{-25})

---

## Future Directions

1. **Generalization:** Does similar identity hold for other orthogonal polynomial families?

2. **Hyperbolic geometry:** Explore 1/k structure in Egypt method convergence

3. **Spectral interpretation:** AB[k] ~ 1/k suggests connection to eigenvalue decay

4. ✅ **Generating function closed form:** COMPLETED
   - G(z) = ArcTanh(z) + [2z + (1+z²)Log[(z-1)²]/2 - (1+z²)Log(1+z)]/(4z)
   - Radius of convergence R = 1
   - Regularized sum = 1/2 (Cesàro/Abel)

5. **Physical meaning:** Why is pairwise derivative sum constant (from Nov 22 session)?

6. **Peer review:** Submit to journal (e.g., SIAM Review, Mathematics of Computation, Journal of Approximation Theory)

---

## Connection to Previous Work

This session builds on **2025-11-22 Egypt Convergence Analysis**:

- Triple identity: FactorialTerm = HyperbolicTerm = ChebyshevTerm
- Pell regulator R = x + y√n in decay rates
- Derivative anti-palindromic structure
- Pairwise sum constancy

**Common theme:** Trigonometric substitution reveals hidden structure in Chebyshev-based approximations.

---

## Files Created

### Main Session (2025-11-23)
- `chebyshev-integral-theorem.md` (this document)

### Working Scripts (/tmp)
- `chebyshev_integral_symbolic.wl` - Initial symbolic verification
- `complete_proof.wl` - Fourier decomposition approach
- `final_proof.wl` - Complete proof with both lemmas
- `explore_original_integrals.wl` - Simplified integral analysis

### Previous Session (2025-11-22)
- `2025-11-23-egypt-convergence-analysis.md` - Parent session

---

**Authors:** Jan Popelka, Claude (Anthropic)
**Repository:** [popojan/orbit](https://github.com/popojan/orbit) (public)
**Status:** ✅ Proven (not peer-reviewed)
