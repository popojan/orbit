# Linearization: The Winding Number Barrier

**Date:** 2026-04-05
**Status:** ✅ PROVEN (the chain of maps), 🤔 INTERPRETIVE (the barrier)

## The Three-Level Chain

The interaction matrix $M_{np} = \cos(\gamma_n\ln p)$ arises from a rank-1 object
through two successive maps:

$$\underbrace{\gamma_n\ln p}_{\text{rank 1}} \;\xrightarrow{\;\;i \cdot (\;) \to e^{i(\;)}\;\;}\; \underbrace{e^{i\gamma_n\ln p}}_{\text{unit circle } S^1} \;\xrightarrow{\;\;\mathrm{Re}\;\;}\; \underbrace{\cos(\gamma_n\ln p)}_{\text{full rank}}$$

### Level 1: The linear matrix $\Theta$ (rank 1)

$$\Theta_{np} = \gamma_n\ln p = \boldsymbol{\gamma} \cdot \boldsymbol{\ell}^{\,T}$$

where $\boldsymbol{\gamma} = (\gamma_1, \gamma_2, \gamma_3, \ldots)^T$ and
$\boldsymbol{\ell} = (\ln 2, \ln 3, \ln 5, \ldots)^T$.

This is an outer product of two vectors — **exactly rank 1**.

SVD: one singular value $\sigma = \|\boldsymbol{\gamma}\| \cdot \|\boldsymbol{\ell}\|$.
All information is in two vectors. Trivially decomposable.

### Level 2: The circle matrix $Z$ (modulus 1, "multiplicative rank 1")

$$Z_{np} = e^{i\gamma_n\ln p} = p^{i\gamma_n}$$

Every entry lies on the unit circle: $|Z_{np}| = 1$. The matrix satisfies:

$$Z_{np} = \alpha_n^{\,\beta_p}, \qquad \alpha_n = e^{i\gamma_n}, \quad \beta_p = \ln p$$

This is "multiplicative rank 1" — one base per zero, one exponent per prime.
In the logarithm: $\log Z_{np} = i\gamma_n\ln p$ recovers rank 1.

### Level 3: The real matrix $M$ (full rank)

$$M_{np} = \mathrm{Re}(Z_{np}) = \cos(\gamma_n\ln p)$$

The projection $\mathrm{Re}: S^1 \to [-1, 1]$ **discards the phase** (the imaginary
part $\sin(\gamma_n\ln p)$). This loss of information inflates the rank from
"multiplicative 1" to full.

## Linearization: Inverting the Chain

To recover rank 1 from $M$: invert both maps.

### Step 1: Lift $M$ to the circle ($\mathrm{Re}^{-1}$)

Given $M_{np} = \cos(\gamma_n\ln p)$, recover $Z_{np} = e^{i\gamma_n\ln p}$:

$$Z_{np} = M_{np} + i\,S_{np}, \qquad S_{np} = \sin(\gamma_n\ln p)$$

This requires knowing the sine — equivalently, the **sign** of $\sin(\gamma_n\ln p)$
at each entry. From the explicit formula: both $\cos$ and $\sin$ parts are available
(via $T_k$ and $U_k$ orbits).

### Step 2: Unwrap the circle ($\log$)

Given $Z_{np} = e^{i\gamma_n\ln p}$, recover $\Theta_{np} = \gamma_n\ln p$:

$$\gamma_n\ln p = \mathrm{Im}(\log Z_{np}) + 2\pi\, w_{np}$$

where $w_{np} \in \mathbb{Z}$ is the **winding number** — how many full $2\pi$
rotations $\gamma_n\ln p$ completes:

$$w_{np} = \left\lfloor\frac{\gamma_n\ln p}{2\pi}\right\rfloor$$

## The Winding Number Barrier

The linearization works — but the unwrapping requires the winding numbers $w_{np}$.

**Knowing $w_{np}$ IS knowing $\gamma_n\ln p$** (up to the fractional part in $[0, 2\pi)$,
which $\arccos$ provides). So the winding numbers encode essentially the
same information as the original problem.

$$\gamma_n\ln p = 2\pi\, w_{np} + \arccos(M_{np})$$

The matrix decomposes into:

$$\underbrace{\gamma_n\ln p}_{\text{rank 1}} = \underbrace{2\pi\, w_{np}}_{\text{integer, "hard"}} + \underbrace{\arccos(M_{np})}_{\text{known from data, values in } [0,\pi]}$$

| Component | Rank | Status |
|-----------|------|--------|
| $\gamma_n\ln p$ | 1 | The "answer" |
| $\arccos(M_{np})$ | Full | Computable from data |
| $w_{np}$ | ? | **The barrier** |

The winding number matrix $w_{np} = \lfloor\gamma_n\ln p/(2\pi)\rfloor$ carries the
"integer part" of the interaction. If $w$ were rank 1 (i.e., $w_{np} = f(n)g(p)$
for some functions), the problem would reduce. But $\lfloor ab/(2\pi)\rfloor$
is NOT a separable function of $a$ and $b$ — the floor function destroys rank 1.

## Where Chebyshev Fits

The Chebyshev map $T_k(\cos\theta) = \cos(k\theta)$ operates **within one period**
of the cosine — it multiplies the angle $\theta$ by $k$ while staying on $[-1, 1]$.

$$T_k: [-1, 1] \to [-1, 1], \qquad \cos\theta \mapsto \cos(k\theta)$$

This is the **intra-period** structure. The Chebyshev factorization
$M_{np} = T_{w_p}(v_n)$ captures how the interaction works WITHIN each
$2\pi$-period of the cosine.

The winding numbers capture the **inter-period** structure — how many full
periods have elapsed. Chebyshev sees the residual angle; the winding
numbers see the integer count.

$$\gamma_n\ln p = \underbrace{2\pi\, w_{np}}_{\text{inter-period (winding)}} + \underbrace{\theta_{np}}_{\text{intra-period (Chebyshev)}}$$

## Connection to the Circ Framework

The unit circle $S^1$ with the map $\theta \mapsto k\theta$ is exactly the
structure of the **circular orbit** from the successor framework.

In the 2D circ framework: diagonalization on $S^1$ separates modes.
Here: the same $S^1$ structure appears, but with TWO families of
"frequencies" — $\gamma_n$ (zeros) and $\ln p$ (primes) — interacting
multiplicatively.

The diagonalization that works in 2D (Fourier on $S^1$) would work here too,
IF we could separate the two families. The multiplicative coupling
$\gamma_n \cdot \ln p$ (product, not sum) prevents standard Fourier separation.

## Summary

$$\boxed{\text{Number theory} = \text{rank-1 structure} + \text{winding numbers} + \text{Re projection}}$$

The rank-1 matrix $\gamma_n\ln p$ contains all the information.
The exponential map wraps it onto the circle (multiplicative rank 1).
The real-part projection loses the phase (full rank).
Recovering the original requires unwinding — and the winding numbers
ARE the number-theoretic content.

The Chebyshev framework captures the intra-period structure (what happens
within one winding). The winding numbers capture the inter-period structure
(how many times around). Both are needed; neither alone suffices.
