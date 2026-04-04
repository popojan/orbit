# Lucas Q=1 Family and Somos Generalization

**Date:** 2026-04-04
**Status:** ✅ Standard results, organized through the Cassini lens

## Lucas Sequences with Q = 1

The Lucas sequences $U_n(P, Q)$ and $V_n(P, Q)$ satisfy:
$$f_{n+1} = P \cdot f_n - Q \cdot f_{n-1}$$

Their Cassini invariant is $Q^n$, which is constant **only for Q = 1**.

**Q = 1 is the distinguished case** — the only one where:
1. Cassini is constant (not growing, not alternating)
2. The nonlinear recurrence `next = (current² − Δ) / previous` works
3. Characteristic roots satisfy $r_1 \cdot r_2 = Q = 1$ (lie on circle or hyperbola)
4. The recurrence generates Chebyshev polynomials

### The Q = 1 Zoo

All are Chebyshev polynomials evaluated at $x = P/2$:

| P | x = P/2 | U-type (Cassini = 1) | V-type (Cassini = 4−P²) |
|---|---------|----------------------|-------------------------|
| 1 | 1/2 | Fibonacci (period 12*) | Lucas numbers (period 12*) |
| **2** | **1** | **0, 1, 2, 3, 4, ... (naturals!)** | **2, 2, 2, ... (constant)** |
| 3 | 3/2 | 0, 1, 3, 8, 21, 55, ... (bisected Fib) | 2, 3, 7, 18, 47, ... |
| 4 | 2 | 0, 1, 4, 15, 56, ... (Pell $q$-values, D=3) | 2, 4, 14, 52, ... |
| 5 | 5/2 | 0, 1, 5, 24, 115, ... | 2, 5, 23, 110, ... |

*Fibonacci/Lucas with Q = −1 have alternating Cassini ±1. Bisection gives Q = 1.

**P = 2 is the boundary**: $x = 1$, naturals, V = constant. The degenerate case
that started the whole session.

### The Two Types

For each parameter $x = P/2$, there are exactly two Chebyshev sequences:

**U-type** ($U_k(x)$, first-kind-of-the-second-kind):
- $U_0 = 1, U_1 = 2x$
- Cassini = 1 (universal, independent of $x$)
- `next = (current² − 1) / previous`

**V-type** ($2 T_k(x)$, scaled first kind):
- $V_0 = 2, V_1 = P = 2x$
- Cassini = $4 - P^2 = 4(1 - x^2)$
- `next = (current² − (4 − P²)) / previous`
- For Pell: V-Cassini = $-Dq_1^2$

These are the two independent solutions of the same linear recurrence
$f_{k+1} = P f_k - f_{k-1}$, distinguished by their initial conditions
and Cassini invariant.

## Why Q ≠ 1 Fails

For $Q \neq 1$, the Cassini is $Q^n$ — it grows or oscillates:

| Q | Cassini | Sequence type | Our recurrence? |
|---|---------|---------------|-----------------|
| Q = 1 | 1 (constant) | Chebyshev | **YES** |
| Q = −1 | (−1)^n | Fibonacci, Pell | Bisect → yes |
| Q = 2 | 2^n | Mersenne-like | **NO** (growing) |
| Q = −2 | (−2)^n | Jacobsthal | **NO** (growing) |

The nonlinear recurrence `next = (current² − Δ) / previous` **requires constant Δ**.
When $Q \neq 1$, the varying Cassini means you'd need a different Δ at each step.

## Somos Sequences: Genus 1

### The Hierarchy

| Genus | Curve | Recurrence | Seeds | Test width |
|-------|-------|------------|-------|------------|
| 0 | $\mathbb{P}^1$ (circle) | $a \cdot c = b^2 - \Delta$ | 1 | 3 terms |
| 1 | Elliptic | $a \cdot e = \alpha \cdot b \cdot d + \beta \cdot c^2$ | 2 | 5 terms |
| $g$ | Genus $g$ | longer | $2g$ | $2g+3$ terms |

### Somos-4: The Simplest Genus-1 Recurrence

$$a_{n+4} \cdot a_n = a_{n+3} \cdot a_{n+1} + a_{n+2}^2$$

Starting from $1, 1, 1, 1$:

$$1, 1, 1, 1, 2, 3, 7, 23, 59, 314, 1529, 8209, 83313, \ldots$$

**All integers** — the Laurent phenomenon (Fomin-Zelevinsky).

### Key Differences from Genus 0

**No 3-term Cassini.** Computing $b^2 - ac$ for Somos-4 gives:
$$0, 1, 1, 1, 25, 16, 841, 16641, \ldots$$
Not constant. The 3-term invariant doesn't exist for genus 1.

**Super-exponential growth.** For genus 0, $\log a_n \sim C \cdot n$ (exponential).
For Somos-4, $\log a_n \sim C \cdot n^2$. This is because the associated function
is the Weierstrass $\sigma$, not $\sin$, and heights on elliptic curves grow quadratically.

**No periodicity over $\mathbb{Q}$.** The super-exponential growth prevents real periodicity.
But over finite fields $\mathbb{F}_p$, Somos-4 IS periodic:

| $p$ | Period | Related to |
|-----|--------|-----------|
| 5 | 16 | $|E(\mathbb{F}_5)|$ |
| 29 | 42 | $|E(\mathbb{F}_{29})|$ |

The period equals (or divides) the number of points on the associated
elliptic curve over $\mathbb{F}_p$ — the **elliptic curve group order**.

### The Analogy

| Feature | Genus 0 (our recurrence) | Genus 1 (Somos-4) |
|---------|--------------------------|---------------------|
| Function | $\sin(n\theta)$ | $\sigma(n\omega)/\sigma(\omega)^{n^2}$ |
| Parameters | 1 seed ($\Delta$) | 2 seeds (curve $a, b$) |
| Growth | $e^{C n}$ | $e^{C n^2}$ |
| Periodicity over $\mathbb{Q}$ | exact (period $2q$) | none (growth) |
| Periodicity over $\mathbb{F}_p$ | — | $= \|E(\mathbb{F}_p)\|$ |
| $\pi$ analogue | $\pi$ (circle period) | $\omega_1, \omega_2$ (lattice periods) |
| Invariant test | 3 terms → 1 number | 5 terms → 2 numbers |
| Group law | $\mathbb{Z}/2q\mathbb{Z} \subset S^1$ | $E(K)$ (Mordell-Weil) |

### What Somos-4 IS

Just as our recurrence generates addition on the circle ($\mathbb{P}^1$),
Somos-4 generates **addition on an elliptic curve**. The terms
$a_n$ are (up to normalization) the **division polynomials** $\psi_n$ of the curve,
which encode the $n$-fold addition $[n]P$ of a point $P$.

The Weierstrass $\sigma$-function is to Somos-4 what $\sin$ is to Chebyshev:
the transcendental function that the algebraic recurrence secretly computes.

## What This Means for Orbit

The Orbit project lives entirely in **genus 0**: all its sequences (Pell, Egyptian,
CircFunctions, Chebyshev) are instances of the one Cassini recurrence.

Genus 1 (Somos/elliptic) would be a natural **next chapter**:
- Elliptic curve factorization (Lenstra ECM) uses the same addition law
- Modular forms connect elliptic curves to number theory (Taniyama-Shimura)
- The j-invariant of the curve plays the role of the Chebyshev parameter $x$

But genus 0 is far from exhausted — the period spectrum, the algebraic sine,
and the π-free computation are all genus-0 phenomena that are already rich.
