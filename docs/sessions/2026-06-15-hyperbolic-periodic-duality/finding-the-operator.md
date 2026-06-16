# What "finding the operator" means — a near-miss, and the trichotomy's hints

**Date:** 2026-06-15
**Status:** 🧪 EXERCISE — pedagogical, with one runnable near-miss.
**Script:** [`scripts/nearmiss-smooth-operator.wl`](scripts/nearmiss-smooth-operator.wl)

## What "finding the operator" requires (three things, all at once)

1. an **explicit** Hilbert space and operator $T$ (a formula — matrix, Jacobi
   tridiagonal, differential operator), explicit enough that
2. **self-adjointness is provable** (not assumed) → real spectrum automatic, and
3. $\operatorname{spec}(T)=\{\gamma_n\}$ is a **theorem** (e.g. a determinant /
   trace-formula identity to $\xi$), not a numerical coincidence.

All three ⟹ RH. The hard parts in practice: most candidates are only
*symmetric*, not essentially self-adjoint (need a self-adjoint extension /
boundary conditions, and the choice changes the spectrum); and proving
$\operatorname{spec}=\{\gamma_n\}$ *exactly* (not just the right density) is where
essentially everything fails.

## A near-miss that is not nonsense: the smooth counting operator

Take $T=\operatorname{diag}(t_n)$ where $t_n$ solves the smooth count
$\theta(t_n)/\pi+1=n$ (Riemann–von Mangoldt main term). It is self-adjoint
(diagonal, real), and its eigenvalue **density is exactly correct**
($\bar N(T)\sim N(T)$). But (data, `n=1..40`):

| $n$ | $\gamma_n$ (true) | $t_n$ (smooth) | $t_n-\gamma_n$ |
|---|---|---|---|
| 1 | 14.1347 | 17.8478 | **3.713** |
| 2 | 21.0220 | 23.1717 | 2.150 |
| 5 | 32.9351 | 35.4679 | 2.533 |
| 20 | 77.1448 | 78.6726 | 1.528 |
| 40 | 122.9468 | 124.0038 | 1.057 |

mean $|t_n-\gamma_n|=1.39$, max $3.71$ — and it **does not shrink**: it is the
arithmetic fluctuation $S(t)=\tfrac1\pi\arg\zeta(\tfrac12+it)$, i.e. **the
primes**. The smooth operator is **RH-blind**: it would give the same $t_n$
whether or not RH holds, because it knows only the density.

**Can a cheap perturbation fix it?** Add one uniform off-diagonal coupling
$\beta$ (the cheapest prime-free knob) and minimise the RMS distance of the
eigenvalues to $\{\gamma_n\}$:

| $\beta$ | 0 | 1 | 2 | $\beta^\*=2.2$ | 3 |
|---|---|---|---|---|---|
| RMS to $\gamma_n$ | 1.555 | 1.546 | 1.533 | **1.533** | 1.547 |

The best single knob improves the RMS by $1.4\%$ — **one parameter cannot fit
40 structured arithmetic deviations.** And the operator that *does* work,
$\operatorname{diag}(\gamma_n)$, is **circular** (the zeros were the input; it
proves nothing about their reality).

**Lesson.** The smooth operator is the *integrable skeleton* — right density,
RH-blind. The gap to the true zeros is the arithmetic. No low-parameter
perturbation closes it; only the full arithmetic does, and feeding in the zeros
is circular. *"Finding the operator"* $=$ generating that arithmetic perturbation
**from the primes**, with self-adjointness provable.

## Does our trichotomy hint at the operator's form? — yes (correcting an earlier over-dismissal)

Taken as a *dynamical* structure (not a static relabel), the Cassini trichotomy
does narrow the search:

- **Transfer cocycle, not one matrix.** With varying coefficients, $M(c)$ is a
  **transfer matrix** and the Cassini form is its **cocycle invariant**. Spectrum
  real (in-band) ⟺ the cocycle is **elliptic** (zero **Lyapunov exponent**,
  bounded transfer); off-line ⟺ **hyperbolic** (positive Lyapunov, exponential
  growth — a "boost"). The trichotomy is the elliptic/hyperbolic Lyapunov
  dichotomy of a Jacobi transfer cocycle.
- **The operator's shape.** A 1-D real Jacobi/Schrödinger operator:
  $\operatorname{diag}\approx$ the smooth count (sets density), off-diagonal $=$
  the *successor/counting* coupling perturbed by an arithmetic potential (sets
  the fluctuations). RH $\Longleftrightarrow$ the cocycle is **critically
  elliptic** (zero Lyapunov) — no boost.
- **The cocycle's frequencies are $\log p$.** From our own dual-orbit identity,
  $c_p=\cos(\log p/N')$: the driving frequencies are the primes. So the operator
  is a (highly) **quasiperiodic** Jacobi operator with the incommensurate
  frequency set $\{\log p\}$.
- **The two-in-one boundary $=$ the cocycle's critical point** (elliptic↔hyperbolic),
  matching the `zzz` $\kappa=\pi$ crossover.

**Honest caveats.** This is hard territory (multi-frequency quasiperiodic
operators, Lyapunov exponents), and "zero Lyapunov ⟺ RH" is partly circular —
but the *form* it dictates (1-D real Jacobi, smooth diagonal + $\log p$-driven
cocycle, critical ellipticity) is a genuine hint, not nothing. It tells you
**what kind of object to build and what invariant to control**, which is more
than "some self-adjoint operator."

## Net

The near-miss shows the **skeleton** (smooth density, RH-blind) and that the
**missing ingredient is the arithmetic**, uncloseable cheaply. The trichotomy
hints the **shape** of that ingredient: a $\log p$-driven Jacobi cocycle whose
critical ellipticity (zero Lyapunov / no boost) *is* RH. Building it from primes,
with that ellipticity provable, is the wall — the same one, now with a picture of
both the operator and the obstruction.
