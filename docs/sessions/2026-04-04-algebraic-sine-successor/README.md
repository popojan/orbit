# Algebraic Sine from Successor Axiom

**Date:** 2026-04-04
**Status:** ✅ PROVEN (all components are standard results; the synthesis is new)

## Starting Point

Define "next natural number" without +1 addition:

```wolfram
f[0, o_] := o
f[1, o_] := 2 o
f[k_, o_] := (f[k - 1, o]^2 - f[0, o]) / f[k - 2, o]
```

At `o = 1`: produces **1, 2, 3, 4, 5, ...** — the natural numbers.

## Core Identity

This recurrence is the **Chebyshev U Cassini identity**:

$$U_{k+1}(x)\,U_{k-1}(x) = U_k(x)^2 - 1$$

The successor without addition: `next = (current² − 1) / previous`.

## Closed Form

$$f(k, o) = o\,U_k(c) + \tfrac{1-o}{2}\,U_{k-1}(c), \qquad c = \frac{5o-1}{4o}$$

### Where does c = (5o-1)/(4o) come from?

The nonlinear recurrence `f[k]·f[k-2] = f[k-1]² − o` hides a **linear** recurrence:

$$f_{k+1} = \alpha\, f_k - f_{k-1}$$

From initial conditions `f[0]=o, f[1]=2o, f[2]=4o−1`:

$$\alpha = \frac{f_2 + f_0}{f_1} = \frac{(4o-1) + o}{2o} = \frac{5o - 1}{2o}$$

The Chebyshev parameter is half the linear coefficient: **c = α/2 = (5o−1)/(4o)**.

The "magic" ratio traces back to `f[2] = 4o − 1`: the first non-trivial iterate
determines the entire linear recurrence. The 5 comes from 4+1 (the coefficient
of o in f[2] plus the initial f[0]=o), and the −1 from the constant term in f[2].

If we had started with `f[1] = λo` instead of `2o`, we'd get `α = (λ²o − 1 + o)/(λo)`.
The factor 2 gives the cleanest case where `α(o=1) = 2`, producing arithmetic naturals.

## Three Regimes

| Parameter | c | Behavior |
|-----------|---|----------|
| o = 1 | c = 1 | **Naturals**: 1, 2, 3, 4, 5, ... (arithmetic) |
| o > 1 | c > 1 | Exponential growth (hyperbolic Chebyshev) |
| 1/9 < o < 1 | c < 1 | **Oscillatory**: algebraic sine wave |

## Oscillatory Regime: Rational Sine Wave

For 1/9 < o < 1, with θ = arccos(c):

$$f(k, o) = \frac{4\,o^{3/2}}{\sqrt{(1-o)(9o-1)}} \;\sin(k\theta + \varphi)$$

- **Amplitude**: 4o^(3/2) / √((1−o)(9o−1))
- **Period**: 2π / arccos((5o−1)/(4o))
- **Phase**: tan φ = √((1−o)(9o−1)) / (3o+1)

The amplitude derivation uses a clean cancellation: A² + B² = o, where
A = (3o+1)/4 and B = √((1−o)(9o−1))/4 are the sin/cos coefficients.

## π Disappears: Algebraic Sine

**Key result:** the quasiperiod T = 2π/arccos(c) is algebraic **if and only if**
T is rational (proved via Gelfond–Schneider theorem).

Rational T = 2q requires c = cos(pπ/q), and cos(pπ/q) is **always algebraic**
(it lives in the maximal real subfield Q(ζ_{2q})⁺ of the cyclotomic field,
whose Galois group is abelian → always solvable by radicals).

Therefore: for any desired precision ε, choose q large enough, compute the
algebraic o = 1/(5 − 4cos(π/q)), and the recurrence produces algebraic
samples of sine — no transcendental π ever appears in any computed value.

### Exact Periodic Cases

| q | Period | o | Radical form |
|---|--------|---|--------------|
| 3 | 6 | 1/3 | rational |
| 4 | 8 | 1/(5−2√2) | nested √ |
| 5 | 10 | (4+√5)/11 | nested √ |
| 6 | 12 | 1/(5−2√3) | nested √ |
| 8 | 16 | 1/(5−2√(2+√2)) | nested √√ |
| 12 | 24 | 1/(5−2√(2+√3)) | nested √√ |
| 2ⁿ | 2ⁿ⁺¹ | 1/(5−2√(2+√(2+...√2))) | n-deep nesting |

General recipe: solve Ψ_q(x) = MinimalPolynomial[2cos(π/q), x] = 0,
then o = 1/(5 − 2x).

## What Is Standard vs New

**Standard (19th century):**
- cos(pπ/q) algebraic — cyclotomic field theory (Gauss 1796)
- Chebyshev recurrence computes sin/cos via field operations
- Cassini identity U_{k+1}·U_{k-1} = U_k² − 1

**New framing:**
- A successor axiom (Peano without +1) → Chebyshev → sine → no π
- The naturals as degenerate boundary (c=1) of oscillatory algebraic waves
- Textbook path: π → sin → Chebyshev → algebraicity
- Our path: successor → Chebyshev → sin → π was never needed

## Finite Field Orbits

See [finite-field-orbits.md](finite-field-orbits.md) — the orbit mod $p$ traces
discrete circles (when $\det(N) \equiv 1 \bmod p$) or spirals (otherwise) in $\mathbb{F}_p^2$.
All integer periods $\geq 2$ are achievable. Diagonal symmetry = time reversal.
Connections to NTT, Lucas cryptography, and CircFunctions over finite fields.

## Matrix Formulation and the Torus

See [matrix-torus.md](matrix-torus.md) — the orbit is a matrix power:

$$N^k = \begin{pmatrix} (\lambda^2+1)a-b & -\lambda a \\ \lambda a & 0 \end{pmatrix}^k$$

$N$ is an **integer matrix**. Its $k$-th power gives exact rational orbit values
via $f_k = (N^k w_0)_2 / ((\lambda a)^k b^2)$. The trace $s_k = \text{tr}(N^k)$
is an integer sequence satisfying $s_{k+1} = ((\lambda^2+1)a-b)\,s_k - (\lambda a)^2 s_{k-1}$.

The matrix IS the torus — its two eigenvalues $\lambda a \cdot e^{\pm i\theta}$ encode
both rotation speeds simultaneously. Mod $m$, the orbit collapses to a finite circle.

## General Scale λ

See [general-scale.md](general-scale.md) — the scale $\lambda$ in $f_1 = \lambda o$
is a second free parameter that controls the oscillatory window and arithmetic boundary:

- **Cassini invariant = $o$** regardless of $\lambda$ (the recurrence itself is scale-invariant)
- **Oscillatory regime**: $1/(\lambda+1)^2 < o < 1/(\lambda-1)^2$
- **Boundary progression**: $\lambda = 2$ → naturals, $\lambda = 3$ → odds, $\lambda = n$ → step $n-1$
- **Period seed**: $o = 1/|\lambda - e^{i\pi/q}|^2$ (inverse squared distance to unit circle)
- **Discriminant**: $D = (b - (\lambda-1)^2 a)((\lambda+1)^2 a - b)$ for $o = a/b$

All "magic numbers" (5, 9, boundaries) trace back to $\lambda$ through the chain
$\lambda \to \lambda^2 \to \lambda^2 \pm 1 \to (\lambda \pm 1)^2$.

## Cassini Unification

See [cassini-unification.md](cassini-unification.md) — the Cassini invariant $b^2 - ac$
unifies all second-order sequences in the Orbit project under one recurrence:

- **PellChebyshevSolve**: $q_k = q_1 \cdot U_{k-1}(p_1)$, $p_k = T_k(p_1)$
- **CircFunctions**: $\gamma[\rho[n,k]]$ has Cassini $= \sin^2(2\pi/n)$
- **EgyptianFractions**: raw factors $u+vk$ have Cassini $= v^2$
- **Fibonacci**: bisected $F_{2k}$ has Cassini $= 1$ (= $U_k(3/2)$)

One computation on three consecutive terms tells you the seed.

## Corrected Scaling

The original recurrence subtracts f[0] = o. For general scaling, the correct
Cassini constant is **f[0]²**, not f[0]:

```wolfram
(* Works for any o, gives o, 2o, 3o, 4o, ... *)
g[k_] := (g[k-1]^2 - g[0]^2) / g[k-2]
```

For o=1, o² = o, so both versions coincide. The "broken" version (subtracting o
instead of o²) is what produces the richer oscillatory behavior.
