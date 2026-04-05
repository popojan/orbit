# Double Chebyshev Factorization of the Interaction Matrix

**Date:** 2026-04-05
**Status:** ✅ PROVEN (algebraic identity via $T_m \circ T_n = T_{mn}$)

## The Key Identity

The Chebyshev polynomials compose multiplicatively:

$$T_{m}(T_{n}(c)) = T_{mn}(c)$$

This allows the interaction matrix $M_{np} = \cos(\gamma_n\ln p)$ to be factored
using **two independent** resolution parameters.

## Two Dual Parameters

The primal and dual orbit formulas each introduce their own resolution:

| | Primal (zeros → primes) | Dual (primes → zeros) |
|---|---|---|
| **Resolution** | $N$ | $N'$ |
| **Orbit step** | $k_1 = N\ln p$ (depends on prime) | $k_2 = N'\gamma_n$ (depends on zero) |
| **Seed** | $\cos(\gamma_n/N)$ (depends on zero) | $\cos(\ln p/N')$ (depends on prime) |

Both give the same matrix: $M_{np} = T_{k_1}(\cos(\gamma_n/N)) = T_{k_2}(\cos(\ln p/N'))$.

## The Double Factorization

Using both parameters simultaneously, with $k_1 = N\ln p$ and $k_2 = N'\gamma_n$:

$$\frac{\gamma_n\ln p}{k_1 \cdot k_2} = \frac{\gamma_n\ln p}{N\ln p \cdot N'\gamma_n} = \frac{1}{NN'}$$

The double seed is **independent of $n$ and $p$**:

$$c_0 = \cos\frac{1}{NN'}$$

Therefore:

$$\boxed{M_{np} = T_{N\ln p}\!\Big(T_{N'\gamma_n}\!\big(\cos\tfrac{1}{NN'}\big)\Big)}$$

The interaction matrix is a **nested composition** of two Chebyshev polynomials
applied to a single universal seed.

## Separation of Variables

The factorization separates the matrix into:

| Layer | Formula | Depends on | Role |
|-------|---------|------------|------|
| **Seed** | $c_0 = \cos(1/(NN'))$ | Resolution only | Universal starting point |
| **Inner** $T$ | $T_{N'\gamma_n}(c_0)$ | Zero $n$ only | "Zero transform" of seed |
| **Outer** $T$ | $T_{N\ln p}(\cdot)$ | Prime $p$ only | "Prime transform" of result |

The zero index $n$ and the prime index $p$ enter through **separate**
Chebyshev applications. They never appear in the same $T$.

## Derivation

By the composition property $T_a(T_b(c)) = T_{ab}(c)$:

$$T_{N\ln p}\!\big(T_{N'\gamma_n}(c_0)\big) = T_{N\ln p \cdot N'\gamma_n}(c_0)
= \cos\!\left(N\ln p \cdot N'\gamma_n \cdot \arccos(c_0)\right)$$

With $c_0 = \cos(1/(NN'))$: $\arccos(c_0) = 1/(NN')$, so:

$$= \cos\!\left(N\ln p \cdot N'\gamma_n \cdot \frac{1}{NN'}\right) = \cos(\gamma_n\ln p) = M_{np} \qquad \square$$

The phantoms $N$ and $N'$ cancel independently.

## What This Means

### 1. The matrix $M$ has a "tensor-like" structure

Although $M_{np}$ is NOT a rank-1 matrix (it cannot be written as $f(n)g(p)$),
it IS a composition $T_{g(p)}(T_{f(n)}(c_0))$ — a nonlinear analog of
a tensor product, mediated by the Chebyshev composition.

### 2. The prime-zero interaction factors through one seed

All interaction between zeros and primes passes through the single number $c_0$.
The zero "encodes" itself into $c_0$ via $T_{N'\gamma_n}$, then the prime
"reads out" via $T_{N\ln p}$. The channel has bandwidth 1 (one real number).

### 3. Connection to prime powers and Euler product

The dual step $k_2 = N'\gamma_n$ at integer values connects to the
Chebyshev generating function (Euler product collapse):

$$\sum_{m=1}^{\infty} \frac{T_m(c_p)}{m\,p^{m/2}} = -\frac{1}{2}\ln(1 - 2c_p/\sqrt{p} + 1/p)$$

The prime power sum ($m = 1, 2, 3, \ldots$) is iteration of $T$ on the seed —
the same $T$ that appears in the outer layer of the double factorization.

### 4. The "vhodné" resolution

For the factorization to be polynomial (not just trigonometric), both
$k_1 = N\ln p$ and $k_2 = N'\gamma_n$ must be integers. This requires:

- $N\ln p \in \mathbb{Z}$ for all primes $p$ in the sum → impossible
  (unless we allow per-prime $N_p$)
- $N'\gamma_n \in \mathbb{Z}$ for all zeros $n$ in the sum → impossible
  (unless we allow per-zero $N'_n$)

With per-entry tuning ($N_p$ per prime, $N'_n$ per zero):
the double factorization becomes polynomial entry-by-entry,
but the matrix structure (SVD, rank) depends on the choice.

The "optimal" choice of $(N_p, N'_n)$ — minimizing some notion of
complexity of the seed matrix — is an open question.

## The Three-Level View

$$\underbrace{\cos(\gamma_n\ln p)}_{M_{np}} = \underbrace{T_{N\ln p}}_{\text{prime layer}}\!\!\left(\underbrace{T_{N'\gamma_n}}_{\text{zero layer}}\!\left(\underbrace{\cos\frac{1}{NN'}}_{\text{universal seed}}\right)\right)$$

Level 0: One number $c_0$ (the seed — captures resolution)

Level 1: One number per zero $T_{N'\gamma_n}(c_0)$ (zero encoding)

Level 2: One number per (zero, prime) pair $T_{N\ln p}(T_{N'\gamma_n}(c_0))$ (full matrix)

The matrix builds up in layers, each adding one dimension of structure.

## Correction: Universal Seed vs. Polynomial Form

The universal seed $c_0 = \cos(1/(NN'))$ with fixed $N, N'$ gives exact factorization,
but $k_1 = N\ln p$ and $k_2 = N'\gamma_n$ are **not integers** — the $T$'s are
trigonometric, not polynomial. The phantom cancellation makes this just
$\cos(\gamma_n\ln p)$ in disguise.

For genuine polynomials: we must **tune per entry**.

### Per-entry tuning

Choose integers $k_1^{(p)}$ per prime and $k_2^{(n)}$ per zero. Then:

$$M_{np} = T_{k_1^{(p)}}\!\Big(T_{k_2^{(n)}}\!\big(c_{np}\big)\Big)$$

where the entry-dependent seed is:

$$c_{np} = \cos\frac{\gamma_n\ln p}{k_1^{(p)}\, k_2^{(n)}}$$

Both $T$'s are genuine polynomials (integer degree), but the seed depends on $(n, p)$.

### What IS separable: the step matrix

The total Chebyshev step is $K_{np} = k_1^{(p)} \cdot k_2^{(n)}$ — a **rank-1 matrix**
(outer product of a prime vector and a zero vector).

The factorization $T_a \circ T_b = T_{ab}$ means the total interaction
$T_{K_{np}}$ factors through this rank-1 step matrix.

### The seed structure

$$c_{np} = \cos\frac{\gamma_n\ln p}{k_1^{(p)}\, k_2^{(n)}}$$

The seed depends on $(n, p)$ through the ratio $\gamma_n\ln p / K_{np}$.
Near degeneracy ($K_{np}$ large):

$$c_{np} \approx 1 - \frac{\gamma_n^2\ln^2 p}{2\,k_1^{(p)2}\, k_2^{(n)2}}$$

The correction factors as a product of zero-dependent ($\gamma_n^2/k_2^{(n)2}$)
and prime-dependent ($\ln^2 p/k_1^{(p)2}$) parts — a rank-1 structure
in the deviation from degeneracy.

### Minimal integer steps

For each (zero, prime) pair, the "minimal" $k_1^{(p)}, k_2^{(n)}$ are the
smallest positive integers such that the seed $c_{np}$ is well-behaved
(not too close to $\pm 1$ or $0$, giving a non-degenerate polynomial).

A natural choice: from continued fraction convergents of $\gamma_n/\pi$
and $\ln p / \pi$, pick denominators as $k_2^{(n)}$ and $k_1^{(p)}$.
