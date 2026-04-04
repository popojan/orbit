# General Scale λ: The Full Symbolic Picture

**Date:** 2026-04-04
**Status:** ✅ PROVEN (algebraic identities, verified symbolically)

## Setup

The recurrence with **arbitrary scale** $\lambda > 1$:

$$f_0 = o, \quad f_1 = \lambda\, o, \quad f_{k+1} = \frac{f_k^2 - o}{f_{k-1}}$$

## What Is Invariant (Independent of λ)

**Cassini invariant = $o$, always:**

$$f_1^2 - f_0 \cdot f_2 = (\lambda o)^2 - o(\lambda^2 o - 1) = o$$

The recurrence `next = (current² − o) / previous` does not depend on λ.
The scale only affects which Chebyshev parameter corresponds to a given seed.

## What Depends on λ

### Chebyshev Parameter

$$c = \frac{(\lambda^2 + 1)\,o - 1}{2\lambda\, o}$$

### Oscillatory Regime

$$\frac{1}{(\lambda+1)^2} < o < \frac{1}{(\lambda-1)^2}$$

| λ | Lower bound | Upper bound | Width |
|---|-------------|-------------|-------|
| 2 | 1/9 ≈ 0.111 | 1 | 0.889 |
| 3 | 1/16 = 0.0625 | 1/4 = 0.25 | 0.1875 |
| 4 | 1/25 = 0.04 | 1/9 ≈ 0.111 | 0.071 |
| 5 | 1/36 ≈ 0.028 | 1/16 = 0.0625 | 0.035 |

Larger λ → narrower oscillatory window, centered around smaller $o$.

### Boundary Arithmetic Progressions (c = 1)

At the upper boundary $o = 1/(\lambda-1)^2$, the sequence produces:

$$o \cdot (1, \lambda, 2\lambda-1, 3\lambda-2, \ldots) = o \cdot (1 + k(\lambda-1))_{k \geq 0}$$

| λ | $o$ | Progression | Step |
|---|-----|-------------|------|
| 2 | 1 | 1, 2, 3, 4, 5, ... (naturals) | 1 |
| 3 | 1/4 | 1, 3, 5, 7, 9, ... (odds) | 2 |
| 4 | 1/9 | 1, 4, 7, 10, 13, ... | 3 |
| 5 | 1/16 | 1, 5, 9, 13, 17, ... | 4 |
| $\lambda$ | $1/(\lambda-1)^2$ | $1, \lambda, 2\lambda-1, \ldots$ | $\lambda - 1$ |

**λ selects which arithmetic progression sits at the oscillatory boundary.**

## The Geometric Formula

The seed $o$ for exact period $2q$ at scale $\lambda$:

$$\boxed{o = \frac{1}{|\lambda - e^{i\pi/q}|^2} = \frac{1}{\lambda^2 - 2\lambda\cos(\pi/q) + 1}}$$

The seed is the **inverse squared distance** from $\lambda$ (real line)
to $e^{i\pi/q}$ (unit circle). This is the Poisson kernel structure.

**Derivation:** Solving $c = \cos(\pi/q)$ for $o$:
$$\frac{(\lambda^2+1)o - 1}{2\lambda o} = \cos(\pi/q)$$
$$o = \frac{1}{\lambda^2 + 1 - 2\lambda\cos(\pi/q)} = \frac{1}{|\lambda - e^{i\pi/q}|^2} \qquad \square$$

**Consequences:**
- As $\lambda \to 1$: $o \to 1/|1 - e^{i\pi/q}|^2 = 1/(4\sin^2(\pi/2q))$ → large $o$
- As $\lambda \to \infty$: $o \to 1/\lambda^2$ → small $o$
- Fixed $q$, varying $\lambda$: traces out a curve in the $(λ, o)$ plane

## Discriminant and Modular Arithmetic

### General Discriminant

For $o = a/b$ (rational) at scale $\lambda$ (integer):

$$\text{disc} = \frac{-(b - (\lambda-1)^2 a)((\lambda+1)^2 a - b)}{\lambda^2 a^2}$$

The numerator factors as:

$$D(a, b, \lambda) = \big(b - (\lambda-1)^2 a\big)\big((\lambda+1)^2 a - b\big)$$

| λ | $D$ | Example $o = 10/11$ |
|---|-----|---------------------|
| 2 | $(b-a)(9a-b)$ | $(1)(79) = 79$ |
| 3 | $(b-4a)(16a-b)$ | $(11-40)(160-11) = (-29)(149)$ |
| 4 | $(b-9a)(25a-b)$ | $(11-90)(250-11) = (-79)(239)$ |
| $\lambda$ | $(b-(\lambda-1)^2 a)((\lambda+1)^2 a-b)$ | — |

### The Chain: λ → All Constants

Every constant in the theory traces back to λ alone:

```
λ                                    (the one free choice)
├── λ² = λ·λ                        (squaring in the recurrence)
├── λ²+1                            (numerator of α)
├── λ²-1 = (λ-1)(λ+1)              (difference)
├── (λ-1)² = λ²-2λ+1               (upper oscillatory boundary)
├── (λ+1)² = λ²+2λ+1               (lower oscillatory boundary)
└── (λ²-1)² = ((λ-1)(λ+1))²        (leading disc coefficient)
```

For λ = 2: the chain produces 4, 5, 3, 1, 9, 9 — all the "magic" numbers.

### Splitting Rule (General λ)

For $o = a/b$ at scale $\lambda$, the sequence mod prime $p$ has period:

$$\text{period} \;\Big|\; \begin{cases} p - 1 & \text{if } D \text{ is a quadratic residue mod } p \\ p + 1 & \text{if } D \text{ is a non-residue mod } p \end{cases}$$

**Degenerate primes** (excluded): those dividing $\lambda \cdot a \cdot b \cdot D$.

By quadratic reciprocity, the QR/NR classification depends on
$p \bmod{4|D|}$, so for each $(a, b, \lambda)$ there is a periodic
pattern determining which primes give which behavior.

### Comparison with CircFunctions

| | CircFunctions | General recurrence |
|---|---|---|
| Disc | $-1$ (fixed) | $-D/(\lambda a)^2$ (depends on $o, \lambda$) |
| Restriction | $p \equiv 1 \pmod{4}$ for all $n$ | $p \bmod{4|D|}$ determines splitting |
| Scope | universal (one rule for all roots of unity) | per-seed (each $o$ has its own rule) |
| Special case | $\lambda = 2$, Gaussian integers | general quadratic field |

CircFunctions lives in $\mathbb{Z}[i]$ (disc = $-1$). The general recurrence
lives in $\mathbb{Z}[\sqrt{D}]$ where $D$ depends on the seed and scale.

## Torus Structure for Quasiperiodic Orbits

When $o$ is rational but the quasi-period $T$ is irrational (generic case):

**Two speeds:**
- Fast: $\theta = \arccos(c)$ radians per step (one "turn" ≈ $\lfloor T \rfloor$ steps)
- Slow: drift $\varepsilon = \lfloor T \rfloor \cdot \theta - 2\pi$ per turn

**Continued fraction** $T = [a_0; a_1, a_2, \ldots]$ gives convergents $p_k/q_k$:
- $p_k$ steps ≈ $q_k$ turns, with error decreasing as $1/p_{k+1}$

**Modular quantization:** mod prime $p$, the irrational $T$ is "rounded" to an
integer period (dividing $p \pm 1$). Different primes give different integer
approximations to the same transcendental quasi-period.

**The denominator growth** of the rational sequence $f_k(a/b)$ is controlled by
$(\lambda \cdot b)^k$ — exponential in $k$. Modular reduction to $\mathbb{F}_p$
eliminates this growth entirely, keeping all values in $\{0, \ldots, p-1\}$.

## Summary: The Two Free Parameters

The entire theory has exactly **two** free parameters:

| Parameter | What it controls |
|---|---|
| $o$ (seed) | Cassini invariant, oscillation frequency, number field |
| $\lambda$ (scale) | Which arithmetic progression at the boundary, oscillatory window width |

Everything else — the Chebyshev parameter, discriminant, splitting conditions,
period, amplitude, phase, torus structure — is determined by these two.

And the recurrence itself depends only on $o$:

$$f_{k+1} = \frac{f_k^2 - o}{f_{k-1}}$$

The scale $\lambda$ is encoded in the initial conditions: $f_0 = o$, $f_1 = \lambda o$.
