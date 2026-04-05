# Euler Triangles: The Angular Structure of Zero Counting

**Date:** 2026-04-05
**Status:** 🤔 EXPLORATORY (geometric reframing of the Euler product)

## The Triangle

For each prime $p$ and height $T$ on the critical line, three points in $\mathbb{C}$:

$$0, \qquad 1, \qquad p^{-s} = \frac{e^{-iT\ln p}}{\sqrt{p}}$$

form a triangle with:

| Side | Length | Meaning |
|------|--------|---------|
| $0 \to 1$ | $1$ | Fixed (the "unit") |
| $0 \to p^{-s}$ | $1/\sqrt{p}$ | Shrinks with $p$ |
| $1 \to p^{-s}$ | $\|1 - p^{-s}\|$ | **Euler factor** |

The angle at the origin between the two sides:

$$\theta_p = T\ln p \pmod{2\pi}$$

This is the **phase** of prime $p$ at height $T$, and its cosine is our seed:
$c_p = \cos(T\ln p)$.

## The Third Side = Euler Factor

By the law of cosines:

$$|1 - p^{-s}|^2 = 1 + \frac{1}{p} - \frac{2c_p}{\sqrt{p}}$$

This is the quadratic polynomial in $c_p$ from the Chebyshev collapse.

The Euler product:

$$|\zeta(1/2+iT)|^2 = \prod_p \frac{1}{|1-p^{-s}|^2} = \prod_p \frac{1}{1 - 2c_p/\sqrt{p} + 1/p}$$

is a product of **inverse squared third sides** of these triangles.

## Zero Counting = Sum of Angles

The angle at the origin in the "distorted" triangle $(0, 1, 1-p^{-s})$:

$$\alpha_p = \arg(1 - p^{-s}) = \arctan\frac{s_p/\sqrt{p}}{1 - c_p/\sqrt{p}}$$

where $s_p = \sin(T\ln p)$, $c_p = \cos(T\ln p)$.

The oscillatory part of the zero counting function:

$$\boxed{S(T) = -\frac{1}{\pi}\sum_p \alpha_p}$$

Zero counting is a **sum of angles** — one angle per prime.

## The Right Triangle

The point $1 - p^{-s}$ has coordinates $(1 - c_p/\sqrt{p},\; s_p/\sqrt{p})$.
The legs of the right triangle from the origin:

- Horizontal: $1 - c_p/\sqrt{p}$ (deviation from the unit)
- Vertical: $s_p/\sqrt{p}$ (oscillatory part)
- Hypotenuse: $|1 - p^{-s}|$ (Euler factor)

Pythagorean:

$$\left(\frac{s_p}{\sqrt{p}}\right)^2 + \left(1 - \frac{c_p}{\sqrt{p}}\right)^2 = |1 - p^{-s}|^2$$

The angle $\alpha_p$ is the angle of this right triangle at the origin.

## Degenerate Limit

At the degenerate point ($T = 0$ or formally all $c_p = 1$, $s_p = 0$):

- Vertical leg: $s_p/\sqrt{p} = 0$
- Horizontal leg: $1 - 1/\sqrt{p} > 0$
- Angle: $\alpha_p = 0$ for all primes
- All triangles collapse to the real line
- $S(0) = 0$ — no oscillatory correction

Moving away from degeneracy: the angles $\alpha_p$ become nonzero.
The angular structure IS the deviation from counting.

## Zeros of $\zeta$: Angular Cancellation

$\zeta(1/2 + iT) = 0$ means $|\zeta| = 0$, which requires:

$$\prod_p (1 - p^{-s}) = 0$$

But no single factor vanishes (since $|p^{-s}| = 1/\sqrt{p} < 1$). So the zero
must come from **collective cancellation**: the complex vectors $1 - p^{-s}$
conspire so their product vanishes.

In the triangle picture: at a zeta zero, the Euler factor vectors
$\vec{v}_p = 1 - p^{-s}$ from all primes, when multiplied together,
point in directions that cancel to zero.

The ANGLE part: $\arg\zeta = \sum_p \alpha_p$ must equal $\pi/2 + n\pi$
(for the product to cross the real axis toward zero).

## Connection to the Orbit Framework

The seed $c_p = \cos(T\ln p)$ parametrizes the triangle:
- $c_p = 1$: triangle collapses (degenerate, no angle)
- $c_p = 0$: maximally "open" triangle
- $c_p = -1$: triangle maximally extended

The Chebyshev parameter determines the **shape** of the triangle.
The orbit framework describes how this shape evolves as $T$ changes
(via $T_k$ and $U_k$ polynomials in $c_p$).

The angular structure is inherently **multiplicative** (it comes from the
Euler product, i.e., from the factorization of integers). The orbit
structure is **additive** (it comes from the explicit formula, i.e., from
the linear recurrence). The two are connected by the prime-zero duality.

## The Full Picture

| Object | Additive (explicit formula) | Multiplicative (Euler product) |
|--------|----------------------------|-------------------------------|
| $\psi(x)$ | $x - \sum_\rho x^\rho/\rho$ | (no direct expression) |
| $\ln\|\zeta\|^2$ | (no direct expression) | $-\sum_p \ln\|1-p^{-s}\|^2$ |
| $S(T)$ | $N(T) - \text{smooth}$ | $-\frac{1}{\pi}\sum_p \alpha_p$ |
| Orbit parameter | $c_n = \cos\gamma_n$ (per zero) | $c_p = \cos(T\ln p)$ (per prime) |
| Triangle | — | Vertices $0, 1, p^{-s}$ |
| Angle | — | $\alpha_p = \arg(1-p^{-s})$ |

The orbit framework lives on the additive side. The Euler triangles live on
the multiplicative side. They describe the same function ($\zeta$) from
dual perspectives.
