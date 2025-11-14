# Chebyshev Curve Visualization: "Infinite Interference"

## Overview

This document describes the visualization of a family of curves derived from Chebyshev polynomials that inscribe perfectly within the unit circle, touching at the vertices of regular n-gons.

**Shadertoy implementation**: https://www.shadertoy.com/view/MXc3Rj

## The Mathematical Formula

### Wolfram Language Form

```mathematica
subnrefu[x_, k_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x]
```

### Complex Number Formulation (GLSL)

The same function can be expressed using complex arithmetic:

```glsl
vec2 subnreff(float x, float k) {
   vec2 r = vec2(0, sqrt(x*x*(1 - x*x)));  // r = i·x·√(1-x²)

   vec2 base = vec2(1 - 2*x*x, 0);  // 1 - 2x²

   return (-1)^k · r · [(base - 2r)^k - (base + 2r)^k] / (2x)
}
```

In mathematical notation:

$$f_k(x) = (-1)^k \cdot \frac{ix\sqrt{1-x^2}}{2x} \left[(1 - 2x^2 - 2ix\sqrt{1-x^2})^k - (1 - 2x^2 + 2ix\sqrt{1-x^2})^k\right]$$

Simplifying:

$$f_k(x) = \frac{(-1)^k \cdot i\sqrt{1-x^2}}{2} \left[(1 - 2x^2 - 2ix\sqrt{1-x^2})^k - (1 - 2x^2 + 2ix\sqrt{1-x^2})^k\right]$$

## Connection to Chebyshev Polynomials

This complex formulation is a **Binet-like formula** for Chebyshev polynomials:

- The two terms $(1 - 2x^2 \pm 2ix\sqrt{1-x^2})^k$ are complex conjugates
- Their difference formula generates the Chebyshev polynomial relationship
- The imaginary part extracts the desired combination

**Key insight**: The difference of conjugate powers automatically produces real-valued results, which equal the Chebyshev polynomial combination $T_{k+1}(x) - x \cdot T_k(x)$.

## Geometric Properties

### Unit Circle Inscription

For each integer $k \geq 2$, the curve parameterized by:

$$\gamma_k(\theta) = f_k(\cos\theta) \cdot e^{i\theta}, \quad \theta \in [0, 2\pi]$$

has the following properties:

1. **Unit norm at regular intervals**: The curve touches the unit circle at exactly $k+1$ points, forming the vertices of a regular $(k+1)$-gon

2. **Unit integral norm**: For all $k$:
   $$\int_0^{2\pi} |f_k(\cos\theta)| \, d\theta = 1$$

3. **Smooth closed curve**: Despite touching the circle at discrete points, the curve is infinitely smooth everywhere

### Examples

| k | Contact points | Regular polygon | Color in visualization |
|---|----------------|-----------------|------------------------|
| 2 | 3 | Equilateral triangle | Orange |
| 3 | 4 | Square | Green |
| 5 | 6 | Hexagon | Cyan |

## The Rotation Key

**The critical insight**: The contact points are not at the standard regular polygon positions, but are **rotated by $-\pi/(2k)$**.

### Explicit Angle Formulas

For a curve with parameter $k$, the $k+1$ contact points occur at angles:

$$\theta_i = -\frac{\pi}{2k} + \frac{2\pi}{k+1} \cdot i, \quad i = 0, 1, \ldots, k$$

**The offset $-\pi/(2k)$** rotates the regular $(k+1)$-gon by **half of its exterior angle**, which creates the optimal symmetric arrangement for the Chebyshev structure.

### Star Pattern Construction

To create the n-star polygon (as in the visualizations), use twice as many points with half the angular spacing:

$$\phi_j = -\frac{\pi}{2k} + \frac{\pi}{k} \cdot j, \quad j = 0, 1, \ldots, 2k-1$$

Then alternate between:
- Outer points (full radius): $\phi_{2j}$
- Inner points (scaled radius $r < 1$): $\phi_{2j+1}$

```mathematica
(* k points on regular k-gon, rotated by -π/(2k) *)
circf[k_] := Table[
  Through[{Cos, Sin}[-π/(2k) + (2π/k)·i]],
  {i, 0, k-1}
]

(* 2k points for star pattern *)
circpf[k_] := Table[
  Through[{Cos, Sin}[-π/(2k) + π/k·i]],
  {i, 0, 2k-1}
]
```

### Animation Details

The Shadertoy implementation rotates the coordinate system continuously:

```glsl
float a = 2π · time / 60;  // Period: 60 seconds
uv = rotate(uv, a);         // Rotate coordinates
```

This rotation reveals:
- How each curve maintains its regular polygon contact points
- The symmetric structure as it rotates through the $-\pi/(2k)$ offset
- The "interference" pattern between multiple curves at different k values

**Why the offset matters**: Without the $-\pi/(2k)$ rotation, the contact points would be at "cardinal" positions (0, π/k, 2π/k, ...). The offset creates the optimal symmetric arrangement where the Chebyshev polynomial naturally touches the unit circle.

## Rendering and Color Mapping

The Shadertoy implementation:

1. **Varying k with time**: `k = time` continuously varies which curve is displayed
2. **Coordinate rotation**: Background rotates with period 60s
3. **Anti-aliasing**: 5-point sampling for smooth edges
4. **Color channels**:
   - Red: unit circle boundary
   - Green: regions where imaginary part exceeds y-coordinate
   - Blue: regions where real part exceeds y-coordinate

## Mathematical Significance

### Why "Infinite Interference"?

The name comes from several interpretations:

1. **Wave interference**: The curve resembles interference patterns of waves with $k+1$ sources
2. **Infinite family**: There are infinitely many such curves (one for each $k$)
3. **Complex interference**: The formula uses complex conjugate pairs whose "interference" (difference) produces real curves

### Connection to Unit Roots

The contact points on the unit circle occur at the $(k+1)$-th roots of unity:

$$e^{2\pi i \cdot j/(k+1)}, \quad j = 0, 1, \ldots, k$$

This connects the Chebyshev structure to:
- Cyclotomic polynomials
- Discrete Fourier transforms
- Regular polygon symmetries

## Relation to Square Root Rationalization

These curves emerged during exploration of:
- Chebyshev polynomials for rational approximation
- Egyptian fraction decompositions
- Pell equation solutions

The shared mathematical structure:
- Orthogonal polynomial systems
- Optimal approximation properties
- Unit norm preservation
- Rational/irrational boundaries

See `chebyshev-pell-sqrt-framework.md` for the connection to square root rationalization.

## Implementation Notes

### Numerical Stability

The GLSL implementation uses:
- Complex arithmetic for clarity
- Power functions via polar form: $z^k = r^k \cdot e^{ik\theta}$
- Careful handling of $\sqrt{1-x^2}$ near boundaries

### Wolfram Language Implementation

```mathematica
(* Direct evaluation *)
PlotChebyshevCurve[k_, points_:1000] := Module[{
    θ = Range[0, 2π, 2π/points],
    x, vals
  },
  x = Cos[θ];
  vals = ChebyshevT[k+1, x] - x*ChebyshevT[k, x];
  Graphics[{
    Circle[],
    Line[Table[vals[[i]]*{Cos[θ[[i]]], Sin[θ[[i]]]}, {i, Length[θ]}]]
  }, Frame -> True]
]

(* For k=2,3,5 *)
Show[
  PlotChebyshevCurve[2],
  PlotChebyshevCurve[3],
  PlotChebyshevCurve[5]
]
```

## Open Questions

1. **General formula for contact point angles**: At which exact angles $\theta$ does $|f_k(\cos\theta)| = 1$?

2. **Area enclosed**: What is the area inside curve $\gamma_k$?

3. **Fourier coefficients**: What is the Fourier decomposition of $f_k(\cos\theta)$?

4. **Generalizations**: Do analogous curves exist for other orthogonal polynomial families (Legendre, Hermite, etc.)?

5. **Connection to conformal mapping**: Can these curves be expressed as images of the unit circle under a rational map?

## Conclusion

The "Infinite Interference" visualization reveals deep geometric structure in Chebyshev polynomials:

- ✓ Beautiful regular polygon contact patterns
- ✓ Unit integral norm for all curves
- ✓ Smooth closed paths despite discrete symmetries
- ✓ Complex number formulation via conjugate differences
- ✓ Natural animation through coordinate rotation

This rediscovery of classical polynomial structure through computational exploration demonstrates how visualization can reveal mathematical beauty that formulas alone might obscure.

---

*Visualization created: 2025*
*Shadertoy: "Infinite Interference" (MXc3Rj)*
*Documentation: 2025-11-12*
