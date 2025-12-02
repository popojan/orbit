# Rotated Chebyshev Polygon Functions

**Date:** December 1, 2025

## Motivation

The standard ChebyshevPolygonFunction $f_k(x) = T_{k+1}(x) - x \cdot T_k(x)$ produces curves where the inscribed k-gon vertices are rotated by angle $\pi/(2k)$ from the standard position. This rotation varies with k, making comparison across different k values difficult.

This document derives the polynomial formula for arbitrary rotation, allowing normalization to a "base position" independent of k.

## Original Parametric Form

For $\theta \in [0, \pi]$:
$$\begin{cases}
x(\theta) = \cos\theta \\
y(\theta) = -\sin(k\theta)\sin\theta
\end{cases}$$

The k vertices (where $x^2 + y^2 = 1$) occur at:
$$\theta_n = \frac{(2n+1)\pi}{2k}, \quad n = 0, 1, \ldots, k-1$$

First vertex is at angle $-\pi/(2k)$ from the positive x-axis.

## Rotated Parametric Form

### Trigonometric Version

For rotation by angle $\delta$:
$$\begin{cases}
x_\delta(\theta) = \cos\delta \cdot \cos\theta + \sin\delta \cdot \sin(k\theta)\sin\theta \\
y_\delta(\theta) = \sin\delta \cdot \cos\theta - \cos\delta \cdot \sin(k\theta)\sin\theta
\end{cases}$$

### Complex Version

$$z_\delta(\theta) = e^{i\delta} \cdot (\cos\theta - i\sin(k\theta)\sin\theta)$$

## Polynomial Form (No Trigonometric Functions)

Using Chebyshev polynomial identities:
- $\sin(k\theta) = \sin\theta \cdot U_{k-1}(\cos\theta)$

With parameter $t = \cos\theta \in [-1, 1]$ and constants $c = \cos\delta$, $s = \sin\delta$:

$$\boxed{\begin{cases}
x_\delta(t) = c \cdot t + s \cdot (1-t^2) \cdot U_{k-1}(t) \\
y_\delta(t) = s \cdot t - c \cdot (1-t^2) \cdot U_{k-1}(t)
\end{cases}}$$

This is **purely polynomial** in $t$ for fixed $(c, s)$.

### Compact Matrix Form

$$\begin{pmatrix} x_\delta \\ y_\delta \end{pmatrix} = \begin{pmatrix} c & s \\ s & -c \end{pmatrix} \begin{pmatrix} t \\ (1-t^2) U_{k-1}(t) \end{pmatrix}$$

Note: The matrix is NOT a standard rotation matrix (it has determinant $-c^2 - s^2 = -1$).

## Base Position (First Vertex at Angle 0)

To place the first vertex on the positive x-axis, set $\delta = \pi/(2k)$:

$$c_k = \cos\frac{\pi}{2k}, \quad s_k = \sin\frac{\pi}{2k}$$

### Algebraic Values of $c_k$ and $s_k$

| k | $c_k = \cos(\pi/(2k))$ | $s_k = \sin(\pi/(2k))$ |
|---|------------------------|------------------------|
| 2 | $\frac{\sqrt{2}}{2}$ | $\frac{\sqrt{2}}{2}$ |
| 3 | $\frac{\sqrt{3}}{2}$ | $\frac{1}{2}$ |
| 4 | $\frac{\sqrt{2+\sqrt{2}}}{2}$ | $\frac{\sqrt{2-\sqrt{2}}}{2}$ |
| 5 | $\frac{1+\sqrt{5}}{4}$ | $\frac{\sqrt{10-2\sqrt{5}}}{4}$ |
| 6 | $\frac{\sqrt{2+\sqrt{3}}}{2}$ | $\frac{\sqrt{2-\sqrt{3}}}{2}$ |

**General:** $c_k$ is a root of $\text{MinPoly}[\cos(\pi/(2k))]$, a polynomial of degree $\phi(4k)/2$.

### Explicit Base Position Formula

$$P_k^{\text{base}}(t) = \left( c_k t + s_k (1-t^2) U_{k-1}(t),\; s_k t - c_k (1-t^2) U_{k-1}(t) \right)$$

## Special Cases

### k = 2 (Digon)

$U_1(t) = 2t$, $c = s = \frac{\sqrt{2}}{2}$

$$\begin{cases}
x_{\text{base}}(t) = \frac{\sqrt{2}}{2} \left( t + 2t(1-t^2) \right) = \frac{\sqrt{2}}{2} t (3 - 2t^2) \\
y_{\text{base}}(t) = \frac{\sqrt{2}}{2} \left( t - 2t(1-t^2) \right) = \frac{\sqrt{2}}{2} t (2t^2 - 1)
\end{cases}$$

### k = 3 (Triangle)

$U_2(t) = 4t^2 - 1$, $c = \frac{\sqrt{3}}{2}$, $s = \frac{1}{2}$

$$\begin{cases}
x_{\text{base}}(t) = \frac{\sqrt{3}}{2} t + \frac{1}{2} (1-t^2)(4t^2-1) \\
y_{\text{base}}(t) = \frac{1}{2} t - \frac{\sqrt{3}}{2} (1-t^2)(4t^2-1)
\end{cases}$$

## Implicit Algebraic Form

For $\delta \neq 0$, the curve is generally NOT a function $y = f(x)$. Instead, it's an implicit algebraic relation $F(x, y) = 0$.

To find the implicit form, eliminate $t$ from the parametric equations. The result is a polynomial equation of degree $\sim 2k$ in $(x, y)$.

**Example (k=2, base position):**

From $x = \frac{\sqrt{2}}{2} t(3-2t^2)$ and $y = \frac{\sqrt{2}}{2} t(2t^2-1)$:

$$x + y = \sqrt{2} t, \quad x - y = \sqrt{2} t (2 - 2t^2) = \sqrt{2} \cdot 2t(1-t^2)$$

So $t = \frac{x+y}{\sqrt{2}}$ and $x - y = 2(x+y)(1 - \frac{(x+y)^2}{2})$

This gives a cubic implicit equation in $(x, y)$.

## Wolfram Language Implementation

```mathematica
(* Rotated Chebyshev Polygon Function - Polynomial Form *)
RotatedPolygonCurve[k_Integer, delta_][t_] := Module[
  {c = Cos[delta], s = Sin[delta], u = ChebyshevU[k-1, t]},
  {c*t + s*(1 - t^2)*u, s*t - c*(1 - t^2)*u}
]

(* Base position (first vertex at angle 0) *)
BasePolygonCurve[k_Integer][t_] := RotatedPolygonCurve[k, Pi/(2k)][t]

(* Plot example *)
ParametricPlot[
  Evaluate@Table[BasePolygonCurve[k][t], {k, 3, 7}],
  {t, -1, 1},
  AspectRatio -> Automatic,
  PlotRange -> {{-1.1, 1.1}, {-1.1, 1.1}}
]
```

## Relationship to Original ChebyshevPolygonFunction

Original: $f_k(x) = -(1-x^2) U_{k-1}(x)$

This is the $y$-component of the unrotated ($\delta = 0$) parametric curve:
- $x(t) = t$
- $y(t) = -(1-t^2) U_{k-1}(t) = f_k(t)$

The rotated version generalizes this to arbitrary orientation while preserving:
1. The inscribed k-gon structure
2. The unit disk containment
3. The polynomial nature

## Integral Invariant Under Rotation

**Conjecture:** The L¹ norm $\int |y_\delta(t)| \sqrt{1 + (dx/dt)^2 + (dy/dt)^2} \, dt$ may NOT be rotation-invariant in general.

However, the **area** enclosed by the parametric curve IS rotation-invariant (rotation preserves area).

**To investigate:** Does the 1/π area invariant extend to the rotated forms?

## References

- Session README: `docs/sessions/2025-12-01-chebyshev-polygon-transforms/README.md`
- Paper: `docs/papers/chebyshev-integral-identity.tex`
- DLMF 18.5: Chebyshev Polynomials
