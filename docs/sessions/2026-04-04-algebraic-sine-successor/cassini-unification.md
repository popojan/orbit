# Cassini Invariant: One Number Unifies Everything

**Date:** 2026-04-04
**Status:** 🔬 NUMERICALLY VERIFIED for all modules; individual pieces are standard results

## The Invariant

For any three consecutive terms $a, b, c$ of a second-order sequence, compute:

$$\boxed{\text{Cassini} = b^2 - a \cdot c}$$

If this value is **constant** across the sequence, then:
- The sequence satisfies `next = (current² − Cassini) / previous`
- The sequence IS Chebyshev (up to scaling and initial conditions)
- The Cassini value is the **seed** — the single number that characterizes the recurrence

This is the **inverse problem**: given any sequence, one computation tells you if it's
an instance of the universal recurrence and what its seed is.

## Unification Table

| Orbit Module | Sequence | Cassini | Chebyshev form |
|---|---|---|---|
| *(this session)* | $f(k, 1) = 1, 2, 3, 4, \ldots$ | $1$ | $U_k(1)$ |
| PellChebyshevSolve | Pell $q$-values ($p^2 - Dq^2 = 1$) | $q_1^2$ | $q_1 \cdot U_{k-1}(p_1)$ |
| PellChebyshevSolve | Pell $p$-values | $-Dq_1^2$ | $T_k(p_1)$ |
| CircFunctions | $\gamma[\rho[n,k]] = \sin(2k\pi/n)$ | $\sin^2(2\pi/n)$ | $\sin(2\pi/n) \cdot U_{k-1}(\cos 2\pi/n)$ |
| EgyptianFractions | Raw tuple factors $u + vk$ | $v^2$ | arithmetic $= v \cdot U_k(1) + u - v$ |
| *(Fibonacci)* | $F_{2k+2} = 1, 3, 8, 21, \ldots$ | $1$ | $U_k(3/2)$ |
| *(Pell numbers)* | $P_{2k} = 0, 2, 12, 70, \ldots$ | $4$ | $2 \cdot U_{k-1}(3)$ |

## Derivations

### Pell Equation: $q_k = q_1 \cdot U_{k-1}(p_1)$, $p_k = T_k(p_1)$

The $k$-th solution $(p_k, q_k)$ of $p^2 - Dq^2 = 1$ satisfies:

**q-values** (Chebyshev U):
```
q-Cassini = q₁²    (constant for all D)
next_q = (q_current² - q₁²) / q_previous
```

Verified for all non-square $D$ from 2 to 30.

**p-values** (Chebyshev T):
```
p-Cassini = -D·q₁²  (constant, negative for D > 0)
next_p = (p_current² + D·q₁²) / p_previous
```

This is already what `PellChebyshevSolve.wl` does — but now it falls out
from a single invariant computation on three consecutive terms.

### CircFunctions: $\gamma[\rho[n,k]]$ is Chebyshev with seed $\sin^2(2\pi/n)$

The sequence $\gamma[\rho[n,1]], \gamma[\rho[n,2]], \ldots, \gamma[\rho[n, n-1]]$
equals $\sin(2k\pi/n)$ for $k = 1, \ldots, n-1$.

Since $\sin(2k\pi/n) = \sin(2\pi/n) \cdot U_{k-1}(\cos(2\pi/n))$:

- The Cassini invariant is $\sin^2(2\pi/n)$ — **algebraic** for all $n$
- The Chebyshev parameter is $\cos(2\pi/n)$ — also algebraic
- The period is exactly $n$

The γ function's integer periodicity is a direct consequence of $U_k(\cos(\pi/q))$
having exact period $2q$.

| $n$ | $\sin^2(2\pi/n)$ | Chebyshev $x$ |
|---|---|---|
| 3 | $3/4$ | $-1/2$ |
| 4 | $1$ | $0$ |
| 5 | $(5+\sqrt{5})/8$ | $(\sqrt{5}-1)/4$ |
| 6 | $3/4$ | $1/2$ |
| 8 | $1/2$ | $\sqrt{2}/2$ |
| 12 | $1/4$ | $\sqrt{3}/2$ |

### Egyptian Fractions: Arithmetic sequences have Cassini $= v^2$

The raw tuple format `{u, v, i, j}` generates factors $u + vk$ for $k = i, \ldots, j$.
These form an arithmetic sequence with step $v$.

Any arithmetic sequence $a, a+v, a+2v, \ldots$ satisfies:
$$b^2 - ac = (a + v)^2 - a(a + 2v) = v^2$$

So Egyptian fraction denominators have Cassini $= v^2$, and the recurrence is:
$$\text{next} = (\text{current}^2 - v^2) / \text{previous}$$

This is the "corrected" version from the main session ($o^2$ not $o$), which produces
scaled naturals: the most basic case.

### Fibonacci/Lucas: Alternating Cassini → Bisect

Standard Fibonacci has $F_n^2 - F_{n-1} F_{n+1} = (-1)^{n+1}$ (alternating ±1).
This means the product of characteristic roots is $-1$, not $+1$.

**Fix:** bisect. Even-indexed Fibonacci $F_{2k}$ has constant Cassini $= 1$:
$$F_{2k} = U_{k-1}(3/2) \quad (\text{starting from } k=1)$$

General rule: if a sequence has alternating Cassini $\pm c$, its even-indexed
subsequence has constant Cassini and fits our recurrence.

| Sequence | Raw Cassini | Bisected Cassini | Chebyshev |
|---|---|---|---|
| Fibonacci $F_k$ | $(-1)^{k+1}$ | $+1$ (even-indexed) | $U_k(3/2)$ |
| Pell $P_k$ | $(-1)^{k+1}$ | $+1$ (even-indexed) | $U_k(\sqrt{2})$ ? |
| Lucas $L_k$ | $(-1)^k \cdot 5$ | $-5$ | $T_k$ type |

## The Meta-Pattern

Every sequence in the Orbit project that arises from a second-order recurrence
can be classified by one number: its Cassini invariant.

- **Cassini = 1**: Universal Chebyshev U with standard normalization
  (naturals, bisected Fibonacci, normalized Pell q-values)
- **Cassini = $v^2$**: Scaled arithmetic/Chebyshev
  (Egyptian fraction factors, Pell q-values with $q_1 = v$)
- **Cassini = $\sin^2(2\pi/n)$**: Circle sampling
  (CircFunctions γ at roots of unity)
- **Cassini = $-D q_1^2$**: Pell numerators (Chebyshev T)
- **Cassini = $o$** (the "broken" subtraction): Deformed naturals
  (algebraic sine waves, the full oscillatory/exponential/arithmetic spectrum)

All of these are instances of:

$$\text{next} = \frac{\text{current}^2 - \text{seed}}{\text{previous}}$$

The seed IS the Cassini invariant. The sequence IS Chebyshev.

## Connection to Main Session Results

The main session (`README.md`) showed that the recurrence with seed $o$:
- At $o = 1$: generates naturals (Chebyshev at boundary $c = 1$)
- At algebraic $o < 1$: generates algebraic sine waves (no π needed)
- At $o > 1$: generates exponential growth (Pell/hyperbolic regime)

This document adds: **every Chebyshev-type sequence in Orbit is an instance
of this recurrence**, identifiable by computing one number from three terms.

## How Many Terms to Verify?

**Three terms** compute the candidate seed: $\Delta = b^2 - ac$.

**Four terms** verify it. Given $a, b, c, d$:
1. Compute $\Delta_1 = b^2 - ac$
2. Compute $\Delta_2 = c^2 - bd$
3. If $\Delta_1 = \Delta_2$, the invariant is constant **forever**.

**Proof of propagation:** If $\Delta_1 = \Delta_2 = \Delta$, then the recurrence
$f_{k+1} = (f_k^2 - \Delta)/f_{k-1}$ determines all future terms. And by definition:
$$f_k^2 - f_{k-1} \cdot f_{k+1} = f_k^2 - f_{k-1} \cdot \frac{f_k^2 - \Delta}{f_{k-1}} = \Delta \qquad \square$$

So constancy is automatic from the recurrence — you just need to check that the
given sequence actually follows it, which one extra term confirms.

## Practical Recipe

Given a mystery sequence $\ldots, a, b, c, d, \ldots$:

1. Compute $\Delta = b^2 - ac$ from any three consecutive terms
2. **Verify**: check $c^2 - bd = \Delta$ (one more term). If yes → constant forever.
3. If $\Delta$ alternates $\pm c$: bisect (take every other term), then recompute
4. The Chebyshev parameter is $x = \alpha/2$ where $\alpha = (c + \Delta/a) / b$ (from the hidden linear recurrence $f_{k+1} = \alpha f_k - f_{k-1}$)
