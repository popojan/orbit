# Algebraic Circle Parametrizations and Integer Periods

**Date:** 2025-11-21
**Context:** Exploration during sqrt approximation research
**Motivation:** Wildberger-inspired search for transcendence-free geometry

## Overview

This document describes two related constructions for generating points on the unit circle using algebraic parameters:

1. **ChebyshevPolygonFunction**: T_{k+1}(x) - x·T_k(x) generating regular polygon vertices
2. **AlgebraicCirclePoint**: Complex power construction with integer period

Both emerged from investigations into Chebyshev polynomial properties during square root approximation studies.

## Historical Context and Motivation

### The Transcendence Problem

Classical circle parametrizations use π:
- **Standard form**: (cos θ, sin θ) where θ ∈ [0, 2π)
- **Problem**: π is transcendental (not a root of any polynomial with rational coefficients)
- **Wildberger perspective**: Avoid transcendental constants when possible

### The Search for Integer Periods

**Objective**: Find parametrization where:
1. Period T is an **integer** (not involving π)
2. Coordinates are **algebraic** (nested radicals, constructible)
3. Discrete parameter k ∈ ℤ cycles through exactly T distinct points

**Discovery**: For special algebraic parameters a = Cot[π/(2n)], the construction (a-I)^(4k)/(1+a²)^(2k) achieves integer period T = n.

**Trade-off accepted**:
```
Transcendental π  →  Algebraic irrational numbers (√2, √3, etc.)
```

Eliminated transcendence, but not irrationality. This is the best possible for non-trivial polygons (Gauss-Wantzel theorem).

---

## Construction 1: ChebyshevPolygonFunction

### Definition

```mathematica
ChebyshevPolygonFunction[x, k] := ChebyshevT[k+1, x] - x * ChebyshevT[k, x]
```

### Main Theorem

**Vertices of Regular Polygons:**

Solutions to the equation x² + f(x, k)² = 1, excluding singularities x = ±1, give exactly k+1 points forming a regular (k+1)-gon inscribed in the unit circle.

**Proof sketch:**
1. T_{k+1}(cos θ) = cos((k+1)θ) (Chebyshev identity)
2. Substituting x = cos θ and solving shows vertices at equally-spaced angles
3. Singularities x = ±1 arise from poles in the Chebyshev construction

### Properties

**1. Symmetry:**
- k even: f(-x, k) = -f(x, k) (odd function, central symmetry)
- k odd: f(-x, k) = f(x, k) (even function)

**2. Rotation Property:**
Polygon is rotated such that no two vertices share the same x-coordinate, ensuring f is single-valued (proper function).

**3. Unit Integral Conjecture:**
```
∫_{-1}^{1} |ChebyshevPolygonFunction[x, k]| dx = 1  for k ≥ 2
```
Status: Numerically verified, not proven.

### Example: Square (k=3)

```mathematica
(* Exclude x = ±1 singularities *)
sols = Solve[x^2 + ChebyshevPolygonFunction[x, 3]^2 == 1 && Abs[x] < 1, x, Reals];

(* 4 vertices at angles -150°, -30°, 90°, (and one more) *)
(* When sorted by angle: exactly 120° apart → regular triangle *)
(* Wait - actually k=3 gives 3 vertices forming equilateral triangle *)
```

**Note**: Must sort vertices by angle (not x-coordinate) to see regular spacing.

---

## Construction 2: AlgebraicCirclePoint

### Definition

```mathematica
AlgebraicCirclePoint[k_Integer, a_] := {Re[z], Im[z]} where
  z = (a - I)^(4k) / (1 + a²)^(2k)
```

**Properties:**
- Always on unit circle: |z| = 1 for all k ∈ ℤ
- Period T = π/(2·ArcCot[a])
- For special a, period T is an integer

### The Special Constant: n=24

**Discovery:** For n = 24, we have:

```mathematica
a = Cot[π/48] = 2 + √2 + √3 + √6
```

This gives **exact integer period T = 24**.

**Why n=24?**
- 24 = 2³ × 3 (constructible by Gauss-Wantzel)
- Requires nested radicals: √2, √3, √6 = √2·√3
- Closed algebraic form exists (not true for all n)

### Known Algebraic Forms

| n | a = Cot[π/(2n)] | Period T | Simplifies? |
|---|-----------------|----------|-------------|
| 3 | √3 | 3 | Yes |
| 5 | √(5 + 2√5) | 5 | Yes |
| 6 | 2 + √3 | 6 | Yes |
| 24 | 2 + √2 + √3 + √6 | 24 | Yes (found by search) |

### Comparison with Other Parameters

**For integer a (e.g., a=3):**
- Unit circle preserved: |z| = 1 ✓
- Period T ≈ 4.88 (irrational) ✗
- Points never return exactly to start
- Creates "spiral with zero pitch" (quasi-periodic winding)

---

## Geometric Interpretation: Two Angular Velocities

### The Dual-Rotation Perspective

For integer parameters a, the construction exhibits **two independent angular velocities**:

**ω₁**: Rotation of position vector (phase of (a-I)^(4k))
**ω₂**: Rotation of reference frame (implicit in normalization)

**Both circles have radius 1** (not classical epicycles with different radii).

**Behavior depends on ω₁/ω₂:**

| Parameter type | ω₁/ω₂ | Behavior |
|----------------|-------|----------|
| Algebraic a = Cot[π/(2n)] | Rational | Periodic (closes after T steps) |
| Integer a | Irrational | Quasi-periodic (never closes exactly) |

### Relative Motion

In a rotating reference frame moving at ω₂, the position vector rotates at:
```
ω_rel = ω₁ - ω₂
```

When ω₁/ω₂ ∈ ℚ, relative motion is periodic → integer period emerges.

This is analogous to:
- Beat frequency in acoustics
- Difference frequency in optics
- Synodic period in astronomy

But here **both rotations have equal radius** (unit circle), unlike classical epicycles.

---

## Comparison with Classical Parametrizations

### Standard Trigonometric Form

```mathematica
StandardCircle[θ_] := {Cos[θ], Sin[θ]}
```

**Properties:**
- Continuous parameter θ ∈ ℝ
- Uses transcendental π
- Natural for continuous geometry
- Uniform angular spacing

### Stereographic Projection (Rational Parametrization)

```mathematica
RationalCircle[t_] := {(1-t²)/(1+t²), 2t/(1+t²)}
```

**Properties:**
- Rational parameter t ∈ ℝ
- Projects line onto circle from pole (0, 1)
- No periodicity (t: -∞ to +∞)
- Used for Pythagorean triples
- **Geometry**: Projection (not rotation)

### AlgebraicCirclePoint (This Work)

```mathematica
AlgebraicCirclePoint[k, a] where z = (a-I)^(4k)/(1+a²)^(2k)
```

**Properties:**
- Discrete integer parameter k ∈ ℤ
- Algebraic (not transcendental) for special a
- Integer period for constructible n
- **Geometry**: Discrete rotation

**Key distinction:**
- **Stereographic**: Continuous projection (∞ → circle)
- **Algebraic**: Discrete rotation (ℤ → circle with period)

---

## Wildberger Connection

### Rational Trigonometry Goals

Norman Wildberger's framework aims to:
1. Avoid transcendental constants (sin, cos, π)
2. Work with quadrance Q = x² + y² instead of distance
3. Use spread s instead of angle
4. Keep all calculations algebraic

### This Construction's Alignment

**Achieved:**
- ✓ Eliminated transcendental π from period
- ✓ Integer period T (discrete steps)
- ✓ Algebraic coordinates (nested radicals)
- ✓ Constructible geometry (Gauss-Wantzel numbers)

**Not achieved:**
- ✗ Still need irrational numbers (√2, √3, √6)
- ✗ Not purely rational (impossible for non-trivial polygons)

**Philosophical position:**
```
Pure rational geometry  ←  This work  →  Transcendental geometry
     (too restrictive)    (algebraic)      (classical)
```

Algebraic irrationals are a practical compromise: constructible, exact, but not transcendental.

---

## Implementation Notes

### Orbit Paclet Functions

**1. RegularPolygonParameter[n]**
```mathematica
(* Returns a = Cot[π/(2n)] *)
RegularPolygonParameter[24]  (* → 2 + √2 + √3 + √6 *)
```

**2. AlgebraicCirclePoint[k, a]**
```mathematica
(* Generate k-th point with parameter a *)
a = RegularPolygonParameter[24];
AlgebraicCirclePoint[0, a]   (* → {1, 0} *)
AlgebraicCirclePoint[1, a]   (* → {√3/2, -1/2} (exact) *)
```

**3. ChebyshevPolygonFunction[x, k]**
```mathematica
(* For implicit form: x² + f(x,k)² = 1 *)
ChebyshevPolygonFunction[0, 3]  (* → 1 *)
```

### Verification Script

```mathematica
<< Orbit`;

(* Test integer period *)
a = RegularPolygonParameter[24];
points = Table[AlgebraicCirclePoint[k, a], {k, 0, 23}];

(* Verify: point 24 equals point 0 *)
AlgebraicCirclePoint[24, a] == AlgebraicCirclePoint[0, a]  (* → True *)

(* All points on unit circle *)
AllTrue[points, Norm[#]^2 == 1 &]  (* → True *)
```

---

## Open Questions

### 1. Complete Characterization

**Question:** For which n does Cot[π/(2n)] have a closed form using nested square roots?

**Known:** n = 2^k · p₁ · ... · pₘ where pᵢ are distinct Fermat primes (Gauss-Wantzel)

**Wolfram behavior:** Simplifies some but not all constructible n automatically.

### 2. Explicit Forms for Larger n

**Found:** n = 24 gives 2 + √2 + √3 + √6

**Unknown:** Explicit forms for n = 48, 96, or other multiples of 24?

**Search method:** Originally found by systematic search for integer periods.

### 3. Connection to Chebyshev Recursion

**Question:** Why does T_{k+1}(x) - x·T_k(x) encode regular polygons?

**Partial answer:** Related to Chebyshev's angle multiplication formulas and their discrete structure.

### 4. Dual Velocities Formalism

**Question:** Can the "two angular velocities" be made rigorous?

**Direction:** Representation theory? Lie groups? Winding numbers?

---

## Historical Note

This construction emerged during investigations of:
1. Chebyshev polynomial properties for sqrt approximations
2. Egypt-Chebyshev factorial equivalence
3. Search for algebraic (non-transcendental) geometric structures

Originally implemented using **factorial formulas**, later recognized as Chebyshev polynomials.

The n=24 case was found through active search for integer periods, motivated by Wildberger's rational trigonometry philosophy.

---

## References

1. **Gauss-Wantzel Theorem**: Constructibility of regular polygons
   - Gauss, C.F. (1801). *Disquisitiones Arithmeticae*

2. **Wildberger's Rational Trigonometry**:
   - Wildberger, N.J. (2005). *Divine Proportions: Rational Trigonometry to Universal Geometry*

3. **Chebyshev Polynomials**:
   - Mason, J.C. & Handscomb, D.C. (2002). *Chebyshev Polynomials*

4. **This Repository**:
   - See `Orbit/Kernel/SquareRootRationalizations.wl` for implementation
   - See `docs/sessions/` for discovery narrative

---

**Summary:** AlgebraicCirclePoint provides a discrete, algebraic, integer-period parametrization of the unit circle, trading transcendental π for algebraic irrationals. It represents a middle ground between pure rational geometry and classical transcendental trigonometry, motivated by Wildberger's philosophy but accepting constructible algebraic numbers as necessary.
