# Chebyshev Visualization: Infinite Interference

## Files

- **infinite_interference.glsl** - Shadertoy GLSL implementation
- **regular-235.png** - Static visualization showing curves for k=2, 3, 5

## Live Demo

Interactive animation: https://www.shadertoy.com/view/MXc3Rj

## Description

Visualization of the family of curves:

```mathematica
subnrefu[x_, k_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x]
```

Each curve inscribes perfectly within the unit circle, touching at the vertices of a regular (k+1)-gon.

## Key Properties

- **Unit integral norm**: ∫|f_k| dθ = 1 for all k
- **Regular polygon contact**: k+1 points where curve touches unit circle
- **Smooth closed curves**: Despite discrete contact points
- **Rotation symmetry**: [rotation angle formula - TBD]

## Mathematical Details

See: `../docs/chebyshev-visualization.md`

## Complex Number Formulation

The GLSL implementation expresses the function using complex arithmetic:

```
f_k(x) = (-1)^k · i√(1-x²)/2 · [(1-2x² - 2i·x√(1-x²))^k - (1-2x² + 2i·x√(1-x²))^k]
```

This Binet-like formula using conjugate differences automatically produces the Chebyshev polynomial relationship.

## Connection to Main Research

Emerged from exploration of Chebyshev polynomials for:
- Square root rationalization (see `../docs/chebyshev-pell-sqrt-framework.md`)
- Egyptian fraction decompositions
- Optimal polynomial approximation

The shared mathematical structure connects orthogonal polynomial systems to rational approximation and unit norm preservation.
