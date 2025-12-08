# The γ Framework: Rational Circle Algebra for Mathematics and Physics

**Evolution:**
- [Circ Function Exploration](../2025-12-07-circ-hartley-exploration/README.md) — original development (Circ)
- [Squarical Geometry](../2025-12-08-squarical-geometry/README.md) — L^p generalization (κ[t,p])
- **This document** — renaming Circ → γ, physics applications

---

## Overview

The **γ framework** provides a unified rational parametrization of trigonometry where:
- All operations stay in rationals until explicitly evaluated
- Multiplication on the circle becomes addition of parameters
- A single function γ replaces both sin and cos

This document showcases how classical trigonometric formulas from mathematics and physics can be elegantly rewritten in native γ notation.

## The Core Function

```
γ[t] = cos(3π/4 + πt)
```

**Key properties:**
- **Inert by default**: `γ[1/4]` stays symbolic until you call `N[]`
- **Full period**: t ∈ [0, 2) covers the complete circle
- **Rational parameters**: Special angles have simple rational t values

| Classical angle | Rational t | γ[t] value |
|-----------------|------------|------------|
| 0° (= 360°) | -3/4 | 1 |
| 45° | -1/2 | √2/2 |
| 90° | -1/4 | 0 |
| 135° | 0 | -√2/2 |
| 180° | 1/4 | -1 |
| 270° | 3/4 | 0 |

## The Three Symmetries

The framework has three fundamental symmetries that replace classical trig identities:

| Symmetry | Formula | Classical analog |
|----------|---------|------------------|
| **Negation** | γ[-t] | Reflection / time reversal |
| **Shift** | γ[t + ½] | 90° rotation (multiply by i) |
| **Dual** | γ[1 - t] | Framework/basis swap |

### The Fundamental Identity

**Shift equals negation:**
```
γ[t + ½] = γ[-t]
```

This single identity replaces the classical sin/cos relationship!

- **cos-like**: γ[t]
- **sin-like**: γ[t + ½] = γ[-t]

No need for two separate functions.

## The Greek Alphabet

| Symbol | Name | Formula | Meaning | Typing |
|--------|------|---------|---------|--------|
| **γ** | gamma | γ[t] = cos(3π/4 + πt) | Angle function (γωνία) | `Esc g Esc` |
| **κ** | kappa | κ[t] = {γ[-t], γ[t]} | Circle coordinates (κύκλος) | `Esc k Esc` |
| **ρ** | rho | ρ[n] = 2/n - 5/4 | n-th root of unity (ῥίζα) | `Esc r Esc` |
| **α** | alpha | α[expr] | Reveal classical form | `Esc a Esc` |
| **φ** | phi | φ[t] = κ[t].{1,I} | Complex form (φαντασία) | `Esc j Esc` |

### Circle Multiplication

The key algebraic insight: **multiplication on the circle is addition of parameters**.

```
t₁ ⊗ t₂ = t₁ + t₂ + 5/4
```

This makes working with roots of unity trivial:
```mathematica
ρ[17] ⊗ ρ[17] = ρ[17, 2]     (* square of primitive 17th root *)
ρ[n] ⊙ k = ρ[n, k]           (* k-th power *)
```

---

# Showcase: Equations Rewritten in γ

## Mathematics

### Pythagorean Identity

**Classical:**
```
sin²θ + cos²θ = 1
```

**Native γ:**
```
γ[t]² + γ[-t]² = 1
```

Or equivalently, using κ:
```
|κ[t]|² = 1
```

### Double Angle Formulas

**Classical:**
```
cos(2θ) = cos²θ - sin²θ
sin(2θ) = 2 sinθ cosθ
```

**Native γ:**
```
γ[2t] = γ[t]² - γ[-t]²
γ[2t + ½] = 2 γ[t] γ[-t]
```

Or simply: the parameter doubles!

### Sum Formulas

**Classical:**
```
cos(α + β) = cosα cosβ - sinα sinβ
```

**Native γ:**
```
γ[s + t + 5/4] = γ[s]γ[t] - γ[-s]γ[-t]
```

The offset 5/4 appears because multiplication is `⊗`, not `+`.

### Euler's Formula

**Classical:**
```
e^(iθ) = cosθ + i sinθ
```

**Native γ:**
```
e^(iπ(t + 3/4)) = γ[-t] + i γ[t] = φ[t]
```

The complex exponential is just our φ function!

### Roots of Unity

**Classical:**
```
ω_k = e^(2πik/n) for k = 0, 1, ..., n-1
```

**Native γ:**
```
φ[ρ[n, k]] for k = 1, 2, ..., n
```

where ρ[n, k] = 2k/n - 5/4.

**Example — vertices of regular 17-gon:**
```mathematica
κ[ρ[17, Range[17]]]
```
Both ρ and κ thread over lists — no mapping needed.

---

## Physics

### Component Roles in κ[t]

Since κ[t] = {γ[-t], γ[t]} = {x, y}:
- **x-component**: γ[-t] = **cos-like**
- **y-component**: γ[t] = **sin-like**

This matches classical κ[t] ↔ {cos θ, sin θ}.

### Inclined Plane

**Classical (angle θ from horizontal):**
```
F_parallel = mg sin(θ)
F_normal = mg cos(θ)
```

**Native γ (surface at parameter t):**
```
F_parallel = mg γ[t]      ← y-component (sin-like)
F_normal = mg γ[-t]       ← x-component (cos-like)
```

The surface direction is κ[t], gravity is {0, -g}, projection is direct.

### Simple Harmonic Motion

**Classical:**
```
x(τ) = A cos(ωτ + φ₀)
v(τ) = -Aω sin(ωτ + φ₀)
```

**Native γ (phase parameter t(τ) = ωτ/π + t₀):**
```
x = A γ[-t]       ← cos-like
v = -Aω γ[t]      ← sin-like
```

Position and velocity are related by **negation**: x uses γ[-t], v uses γ[t].

### Projectile Motion

**Classical:**
```
Range R = v₀² sin(2θ) / g
```

**Native γ:**
```
R = v₀² · 2γ[t]γ[-t] / g
```

Or using the double-angle form:
```
R = v₀² γ[2t + ½] / g
```

### Snell's Law (Refraction)

**Classical:**
```
n₁ sin(θ₁) = n₂ sin(θ₂)
```

**Native γ:**
```
n₁ γ[t₁] = n₂ γ[t₂]      ← sin-like
```

### Work Done by Force

**Classical:**
```
W = F · d · cos(θ)
```

**Native γ:**
```
W = F · d · γ[-t]     ← cos-like
```

### Malus's Law (Polarization)

**Classical:**
```
I = I₀ cos²(θ)
```

**Native γ:**
```
I = I₀ γ[-t]²         ← cos-like squared
```

### Torque

**Classical:**
```
τ = r × F = rF sin(θ)
```

**Native γ:**
```
τ = rF γ[t]      ← sin-like (y-component)
```

---

## Electrical Engineering

This is where γ truly excels — **phasor multiplication becomes parameter addition**.

### The Key Advantage

**Classical phasors:**
```
A·e^{iθ} × B·e^{iφ} = AB·e^{i(θ+φ)}
```
Must track magnitude and phase separately, phases in radians (irrational for most angles).

**Native γ phasors:**
```
(A·φ[t₁]) × (B·φ[t₂]) ~ AB·φ[t₁ ⊗ t₂]
```
Phases combine via ⊗ — **exact rational arithmetic**!

### Cascaded Filter Stages

```
Stage 1: phase t₁ = 1/6
Stage 2: phase t₂ = 1/4
Stage 3: phase t₃ = 1/8

Total phase = t₁ ⊗ t₂ ⊗ t₃ = 1/6 + 1/4 + 1/8 + 5/4 + 5/4
            = (4 + 6 + 3 + 30 + 30)/24 = 73/24
```

No floating point accumulation errors — pure rational arithmetic throughout!

### Three-Phase Power (120° = 2/3 shift)

**Classical:**
```
Phase A: cos(ωt)
Phase B: cos(ωt - 2π/3)
Phase C: cos(ωt - 4π/3)
```

**Native γ:**
```
Phase A: γ[t]
Phase B: γ[t + 2/3]
Phase C: γ[t + 4/3]
```

Clean rational offsets! And the balanced sum:
```
κ[t] + κ[t + 2/3] + κ[t + 4/3] = {0, 0}
```
(Verified numerically — three symmetrically placed vectors sum to zero.)

### Power Factor

**Classical:**
```
PF = cos(φ)  where φ is impedance phase angle
```

**Native γ:**
```
PF = γ[-t]   where t is impedance phase parameter
```

If t is rational, the power factor stays symbolic until final evaluation.

### Impedance Phase Shortcuts

| Component | Impedance | Phase parameter |
|-----------|-----------|-----------------|
| Resistor | R | t = -3/4 (0°) |
| Inductor | iωL | t = -1/4 (+90°) |
| Capacitor | 1/(iωC) | t = 1/4 (-90°) |

Combining impedances: phases add via ⊗ for series multiplication.

---

## The Symmetry Triptych

All three symmetries have physical interpretations:

| Symmetry | Formula | Mathematical meaning | Physical meaning |
|----------|---------|---------------------|------------------|
| **-t** | γ[-t] = γ[t + ½] | sin ↔ cos swap | Time reversal, reflection |
| **t + ½** | 90° rotation | Multiply by i | Phase shift, velocity↔position |
| **1 - t** | Framework duality | Basis change | Conjugate variables? |

### Composition

The symmetries combine:
```
-(1-t) = t - 1     (negation of dual)
(1-t) + ½ = 3/2 - t   (shift of dual = conjugate!)
```

Note: CircConjugate[t] = 3/2 - t appears naturally!

---

## L^p Geometries (Squarical)

The framework extends to non-Euclidean geometries via κ[t, p]:

| p | Geometry | Shape | π value |
|---|----------|-------|---------|
| 1 | Taxicab | Diamond | 4 |
| 2 | Euclidean | Circle | 3.14159... |
| ∞ | Chebyshev | Square | 4 |

**Key insight:** The rational algebra (γ, ρ, ⊗) is **geometry-independent**. Only κ[t, p] changes with p.

```mathematica
κ[t]      (* Euclidean — default *)
κ[t, 1]   (* Taxicab — diamond *)
κ[t, ∞]   (* Chebyshev — square *)
```

The Euclidean π ≈ 3.14159 is the **minimum** — both extremes give π = 4.

---

## Summary

The γ framework offers:

1. **One function instead of two** — γ[t] with shift symmetry replaces sin/cos
2. **Rational parameters** — exact arithmetic until final evaluation
3. **Addition for multiplication** — circle algebra becomes linear
4. **Three clear symmetries** — negation, shift, dual
5. **Geometry independence** — same algebra works for all L^p norms

The cost is a mental shift from degrees/radians to rational parameters. The gain is algebraic elegance and computational exactness.

---

## Formal Foundations

The γ framework's simplification rules (upvalues) relate to term rewriting systems.

**Wolfram vs Prolog:** Mathematica's pattern matching is greedy (first match wins), unlike Prolog's backtracking search. Rules must be carefully ordered to ensure termination and confluence. See: [Wolfram vs Prolog Patterns](../../reference/wolfram-vs-prolog-patterns.md)

---

## References

**Session evolution:**
- [Circ Function Exploration](../2025-12-07-circ-hartley-exploration/README.md) — Original Circ development
- [Squarical Geometry](../2025-12-08-squarical-geometry/README.md) — L^p generalization

**Learning materials:**
- [Minkowski Geometries](../../learning/minkowski-geometries.md) — L^p norms and π(p)
- [Hölder Conjugates](../../learning/hoelder-conjugates.md) — Duality in L^p spaces

## Implementation

See: `Orbit/Kernel/CircFunctions.wl`

```mathematica
<< Orbit`
γ[1/4]           (* inert symbolic *)
N[γ[1/4]]        (* → -1. *)
κ[ρ[17]]         (* 17-gon vertex *)
α[κ[ρ[17]]]      (* → {Cos[2π/17], Sin[2π/17]} *)
```
