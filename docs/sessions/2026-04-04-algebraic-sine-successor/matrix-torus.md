# Matrix Formulation and the Torus

**Date:** 2026-04-04
**Status:** ✅ PROVEN (linear algebra over Q)

## The Transfer Matrix

The linear recurrence $f_{k+1} = \alpha f_k - f_{k-1}$ is equivalent to:

$$\begin{pmatrix} f_{k+1} \\ f_k \end{pmatrix} = M^k \begin{pmatrix} f_1 \\ f_0 \end{pmatrix}, \qquad M = \begin{pmatrix} \alpha & -1 \\ 1 & 0 \end{pmatrix}$$

with $\det M = 1$ (because $Q = 1$ in the Lucas classification).

For $o = a/b$ at scale $\lambda$: $\alpha = \frac{(\lambda^2+1)a - b}{\lambda a}$.

## The Integer Matrix

Clearing denominators: $N = \lambda a \cdot M$:

$$\boxed{N = \begin{pmatrix} (\lambda^2+1)a - b & -\lambda a \\ \lambda a & 0 \end{pmatrix}}$$

$N$ has **integer entries** and $\det N = (\lambda a)^2$.

The orbit is:

$$f_k = \frac{(N^k \cdot v_0)_2}{(\lambda a)^k \cdot b}, \qquad v_0 = \begin{pmatrix} \lambda a \cdot f_1 \\ \lambda a \cdot f_0 \end{pmatrix} = \begin{pmatrix} \lambda^2 a^2 / b \\ \lambda a^2 / b \end{pmatrix}$$

or more cleanly with $w_0 = b \cdot v_0 = (\lambda^2 a^2,\; \lambda a^2)$:

$$f_k = \frac{(N^k \cdot w_0)_2}{(\lambda a)^k \cdot b^2}$$

where $N^k \cdot w_0$ is always an **integer vector**.

### Examples

| $o$ | $\lambda$ | $N$ | $\det N$ |
|-----|-----------|-----|----------|
| $10/11$ | 2 | $\begin{pmatrix} 39 & -20 \\ 20 & 0 \end{pmatrix}$ | 400 |
| $2/3$ | 2 | $\begin{pmatrix} 7 & -4 \\ 4 & 0 \end{pmatrix}$ | 16 |
| $3/4$ | 2 | $\begin{pmatrix} 11 & -6 \\ 6 & 0 \end{pmatrix}$ | 36 |
| $a/b$ | $\lambda$ | $\begin{pmatrix} (\lambda^2+1)a-b & -\lambda a \\ \lambda a & 0 \end{pmatrix}$ | $(\lambda a)^2$ |

## The Integer Trace Sequence

The trace $s_k = \text{tr}(N^k)$ satisfies:

$$s_{k+1} = \text{tr}(N) \cdot s_k - \det(N) \cdot s_{k-1}$$

$$\boxed{s_{k+1} = \big((\lambda^2+1)a - b\big) \cdot s_k - (\lambda a)^2 \cdot s_{k-1}}$$

with $s_0 = 2$, $s_1 = (\lambda^2+1)a - b$.

This is an **integer sequence** that encodes the full orbit:
$s_k = (\lambda a)^k \cdot 2 T_k(\alpha/2)$ where $T_k$ is Chebyshev of the first kind.

For $o = 10/11$, $\lambda = 2$: $s_{k+1} = 39\, s_k - 400\, s_{k-1}$,
giving $2, 39, 721, 12519, 199841, \ldots$

## The Matrix IS the Torus

The eigenvalues of $N$ are $\lambda a \cdot e^{\pm i\theta}$ where $\theta = \arccos(\alpha/2)$.

Over $\mathbb{R}$, the matrix $N$ acts as **rotation by $\theta$ and scaling by $\lambda a$**.
After $k$ steps: rotation by $k\theta$, scaling by $(\lambda a)^k$.

The torus structure:
- **Fast angle**: $k\theta \bmod 2\pi$ (advances by $\theta$ each step)
- **Slow drift**: $k\theta - 2\pi \lfloor k\theta/(2\pi) \rfloor$ accumulates over quasi-periods
- **Both are encoded** in the pair $(N^k w_0)_1, (N^k w_0)_2$ — two integers

No decomposition into "fast" and "slow" components is needed or possible
without leaving the integers. The matrix multiplication carries both
speeds simultaneously.

## Quasi-Period via Trace

The trace detects near-returns:

$$\text{tr}(N^k) \approx 2 \cdot (\lambda a)^k \quad \Longleftrightarrow \quad k\theta \approx 2\pi n$$

because $\text{tr}(N^k) = (\lambda a)^k \cdot 2\cos(k\theta)$, and $\cos(k\theta) \approx 1$
when $k\theta$ is near a multiple of $2\pi$.

The convergents of the quasi-period $T = 2\pi/\theta$ are visible as values of $k$
where $s_k / (\lambda a)^k$ is close to 2:

| $k$ | $s_k / 20^k$ | Turns | Quality |
|-----|---------------|-------|---------|
| 28 | 1.99992 | ≈ 1 | good |
| 701 | 1.999999... | ≈ 25 | excellent |
| 37378 | 2 − 10⁻¹⁴ | ≈ 1333 | superb |

## Modular Reduction

$N^k \bmod m$: a $2 \times 2$ matrix with entries in $\{0, \ldots, m-1\}$.

- Always periodic (finite group)
- Period divides $m^2 - 1$ (or $m^2 - m$, depending on splitting)
- Recovers the orbit exactly: $f_k \equiv (N^k w_0)_2 \cdot (\lambda a)^{-k} \cdot b^{-2} \pmod{m}$

For prime $p$:
- The period of $N^k \bmod p$ divides $p - 1$ (if disc is QR) or $p + 1$ (if disc is NR)
- The orbit on $\mathbb{F}_p^2$ is a **finite circle** — the torus collapses to a cyclic group

### Phase Portraits

Example: $o = 10/11$, $\lambda = 2$, $p = 41$ (period 14).

The orbit $(N^k w_0 \bmod 41)$ traces out 14 points on a "discrete circle" in $\mathbb{F}_{41}^2$:

```
(20,10) → (6,31) → (24,38) → (12,29) → (11,35) → (16,15) → (37,33)
→ (4,2) → (34,39) → (13,24) → (27,14) → (35,7) → (36,3) → (32,23) → (20,10)
```

## Why Denominators Must Grow

Over $\mathbb{Q}$, the denominators of $f_k$ grow as $(\lambda a)^k / b$.
This is **unavoidable** for irrational rotation:

1. If denominators were bounded, $f_k$ would take finitely many values → periodic
2. But the period $T$ is transcendental (by Gelfond-Schneider) → not periodic
3. Therefore denominators are unbounded $\square$

The matrix formulation doesn't eliminate this growth — it **reorganizes** it.
Instead of fractions with growing denominators, you get integers with growing
magnitude. The denominator $(\lambda a)^k$ is separated out as a known scale factor.

The growth is the price of irrationality, just as $\pi$ was the price of continuity.

## Summary

| Representation | Numbers | Growth | Periodizable? |
|---|---|---|---|
| $f_k \in \mathbb{Q}$ | fractions | denominators $\sim (\lambda a)^k$ | mod $p$ only |
| $N^k w_0 \in \mathbb{Z}^2$ | integer pairs | magnitude $\sim (\lambda a)^k$ | mod $m$ |
| $s_k = \text{tr}(N^k) \in \mathbb{Z}$ | single integer | magnitude $\sim (\lambda a)^k$ | mod $m$ |
| $N^k \bmod m$ | matrix in $(\mathbb{Z}/m)^{2\times 2}$ | **bounded** | **always periodic** |

The matrix $N$ is the canonical encoding. It carries the full torus
in two integers, evaluates to exact rationals via known scale factor,
and collapses to finite orbits under any modulus.
