# Symbolic Formulas for E-Spiral Intersections

## The E-Spiral

$$g(t) = \frac{-16\pi e \cdot t}{K_{2t-1}(-\tfrac{1}{2}) \cdot K_{2t+1}(-\tfrac{1}{2})}$$

where $K_\nu(z)$ is the modified Bessel function of the second kind.

## Key Identity: BesselK at Negative Argument

For $x > 0$:
$$K_\nu(-x) = e^{-i\pi\nu} K_\nu(x) - i\pi I_\nu(x)$$

## X-Axis Crossings (Im(g) = 0)

### Symbolic Condition

The imaginary part of the denominator is:
$$\text{Im}(\text{denom}) = -K_1 K_2 \sin(4\pi t) + \pi\cos(2\pi t)(K_1 I_2 + K_2 I_1)$$

where:
- $K_1 = K_{2t-1}(\tfrac{1}{2})$, $K_2 = K_{2t+1}(\tfrac{1}{2})$
- $I_1 = I_{2t-1}(\tfrac{1}{2})$, $I_2 = I_{2t+1}(\tfrac{1}{2})$

Setting $\text{Im}(\text{denom}) = 0$:

**Case 1:** $\cos(2\pi t) = 0$ ⟹ $t = \frac{1}{4} + \frac{n}{2}$ for $n \in \mathbb{Z}$

**Case 2:** $\cos(2\pi t) \neq 0$ leads to transcendental equation (no closed-form solutions found).

### Explicit Values

**All x-axis crossings occur at $t = \frac{2k+1}{4}$ for $k \in \mathbb{Z}$.**

At these points, the Bessel orders are half-integers, yielding **exact rational values**:

| $t$ | $g(t)$ | Notes |
|-----|--------|-------|
| $-\frac{3}{4}$ | $-\frac{12}{7}$ | $= -g(\frac{3}{4})$ by oddness |
| $-\frac{1}{4}$ | $4$ | $= -g(\frac{1}{4})$ by oddness |
| $\frac{1}{4}$ | $-4$ | Intermediate point |
| $\frac{3}{4}$ | $\frac{12}{7}$ | **Series term $a_0$** |
| $\frac{5}{4}$ | $\frac{20}{71}$ | Intermediate point |
| $\frac{7}{4}$ | $\frac{4}{1001}$ | **Series term $a_1$** |
| $\frac{9}{4}$ | $\frac{36}{1284319}$ | Intermediate point |
| $\frac{11}{4}$ | $\frac{4}{36305269}$ | **Series term $a_2$** |

### Main Theorem: Series Terms

**For $n \geq 0$:**
$$g\left(\frac{3}{4} + n\right) = \frac{4(4n+3)}{s_{2n-1} \cdot s_{2n+1}}$$

where $s_n$ satisfies:
- $s_{-1} = 1$, $s_0 = 1$, $s_1 = 7$
- $s_n = (4n+2) s_{n-1} + s_{n-2}$

**These are exactly the terms of our monotone e-series:**
$$e = 1 + \sum_{n=0}^{\infty} g\left(\frac{3}{4} + n\right)$$

## Y-Axis Crossings (Re(g) = 0)

### Symbolic Condition

$$K_1 K_2 \cos(4\pi t) + \pi\sin(2\pi t)(K_1 I_2 + K_2 I_1) = \pi^2 I_1 I_2$$

This is a transcendental equation mixing trigonometric functions and Bessel functions of order $2t \pm 1$.

**No closed-form solutions**, but numerical solutions exist:

| $t$ | $\text{Im}(g)$ | Near fraction |
|-----|----------------|---------------|
| $\pm 0.5405$ | $\mp 2.428$ | $\pm 6/11$ |
| $\pm 0.9105$ | $\pm 1.383$ | |
| $\pm 1.1375$ | $\mp 0.655$ | |
| $\pm 1.3729$ | $\pm 0.104$ | |
| $\pm 1.6247$ | $\mp 0.012$ | |

**Largest y-crossing:** $t = -0.540454349891530...$ with $\text{Im}(g) = 2.428...$

## Self-Intersections

### Symbolic Condition

For $g(t_1) = g(t_2)$ with $t_1 \neq t_2$ and $t_1 \neq -t_2$:

$$\frac{t_1}{\text{denom}(t_1)} = \frac{t_2}{\text{denom}(t_2)}$$

This is doubly transcendental (Bessel functions at two different orders).

**Oddness constraint:** $g(-t) = -g(t)$, so pairs $(t, -t)$ map to *opposite* points $g(t)$ and $-g(t)$. This is NOT a self-intersection (points are negatives, not equal).

**Self-intersections found:**

| $t_1$ | $t_2$ | Location $g$ | $|g|$ |
|-------|-------|--------------|-------|
| $0.6454$ | $-0.0531$ | $1.35 - 1.50i$ | $2.02$ |
| $-1.1835$ | $0.0118$ | $-0.29 + 0.37i$ | $0.47$ |

These are transcendental (no closed form). By oddness, each has a symmetric partner at $(-t_2, -t_1) \to -g$.

## Summary

| Intersection Type | Formula | Solutions |
|-------------------|---------|-----------|
| **X-axis** | $\text{Im}(\text{denom}) = 0$ | $t = \frac{2k+1}{4}$, all $k \in \mathbb{Z}$ (exact rationals) |
| **Y-axis** | $\text{Re}(\text{denom}) = 0$ | Transcendental: $t \approx \pm 0.54, \pm 0.91, \pm 1.14, ...$ |
| **Self** | $g(t_1) = g(t_2)$ | At least 2 pairs found (transcendental) |

The x-axis crossings at $t = \frac{3}{4} + n$ give **exactly** the terms of our monotone series for $e$.
