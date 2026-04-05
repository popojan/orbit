# Dual Orbit Formula: Zero Counting via Prime-Parametrized Orbits

**Date:** 2026-04-05
**Status:** 🔬 EXPLORING (formal identity, convergence needs care)

## The Duality

The explicit formula for $\psi(x)$ expresses prime counting via zeta zeros.
The argument of $\zeta$ on the critical line expresses zero counting via primes.

| | $\psi(x)$ | $N(T)$ |
|---|---|---|
| Counts | Primes | Zeros |
| Main term | $x$ | $\frac{T}{2\pi}\ln\frac{T}{2\pi e} + \frac{7}{8}$ |
| Corrections | $\sum_\rho$ (zeros as frequencies) | $\sum_p$ (primes as frequencies) |
| Orbit seeds | $c_n = \cos(\gamma_n/N)$ | $c_p = \cos(\ln p/N')$ |

## The Dual Formula

The zero counting function:

$$N(T) = \frac{\theta(T)}{\pi} + 1 + S(T)$$

where $\theta(T) = \mathrm{Im}\ln\Gamma(1/4 + iT/2) - \frac{T}{2}\ln\pi$
is the Riemann-Siegel theta function, and:

$$S(T) = \frac{1}{\pi}\arg\zeta(1/2 + iT) = -\frac{1}{\pi}\sum_p\sum_{m=1}^{\infty} \frac{\sin(mT\ln p)}{m\,p^{m/2}}$$

(formal; requires regularization for convergence on the critical line)

### Chebyshev substitution

Choose resolution $N'$ and set $k = N'T$ (integer). For each prime $p$:

$$\sin(T\ln p) = \sin\frac{\ln p}{N'} \cdot U_{N'T - 1}\!\left(\cos\frac{\ln p}{N'}\right)$$

The **dual orbit identity**:

$$S(T) = -\frac{1}{\pi}\sum_p \frac{\sin(\ln p / N')}{p^{1/2}} \cdot U_{N'T-1}\!\left(\cos\frac{\ln p}{N'}\right) + O(\text{higher } m)$$

(keeping only $m = 1$ terms; higher $m$ contribute $O(1/p)$ corrections)

### The dual seed

Each prime $p$ has Chebyshev parameter:

$$c_p = \cos\frac{\ln p}{N'}$$

For $N' \to \infty$: $c_p \to 1$ (all primes degenerate).
The phantom $N'$ cancels, recovering $\sin(T\ln p)$.

## The Dual Derivative

Differentiating $S(T)$ with respect to $T$:

$$S'(T) = -\frac{1}{\pi}\sum_p \frac{\ln p}{\sqrt{p}}\,\cos(T\ln p)$$

Compare with the primal derivative:

$$\psi'(x) = 1 - \frac{2}{\sqrt{x}}\sum_n \cos(\gamma_n\ln x)$$

| | $\psi'(x)$ | $S'(T)$ |
|---|---|---|
| Sum over | Zeros | Primes |
| Weights | **None** ($\|\rho\|^2$ cancels) | $\ln p/\sqrt{p}$ (does NOT cancel) |
| Main term | $1$ (constant) | $\sim \frac{1}{2\pi}\ln\frac{T}{2\pi}$ (logarithmic) |

The duality is **imperfect**: $\psi'$ achieves the elegant unweighted form,
but $S'$ retains weights $\ln p/\sqrt{p}$. This asymmetry reflects the
nonlinearity of the zero counting main term ($T\log T$ vs. linear $x$).

## Numerical Verification

Verified: dual orbit form matches standard prime sum to $\sim 10^{-13}$.

Convergence with number of primes is slower than convergence of $\psi$
with number of zeros. This reflects the slower decay of $1/\sqrt{p}$
vs. $1/|\rho_n|^2 \sim 1/\gamma_n^2$.

## The Perturbation Picture

As $N' \to \infty$: all prime seeds degenerate ($c_p \to 1$). Each prime's orbit
becomes "counting" ($U_k(1) = k+1$). The corrections are organized by powers
of $(\ln p)^2 / N'^2$ — the same near-degenerate expansion as for $\psi$,
but with primes playing the role of zeros.

The non-perturbative barrier applies here too: the Taylor expansion of
$\sin(T\ln p)$ around the degenerate point, summed over primes term by term,
diverges at each order — exactly as the zero sum did for $\psi$.

## Chebyshev Collapse = Euler Product

### The generating function identity

The Chebyshev polynomial of the first kind has the generating function:

$$\sum_{m=1}^{\infty} \frac{T_m(c)}{m}\, r^m = -\frac{1}{2}\ln(1 - 2cr + r^2)$$

With $r = p^{-1/2}$ and $c = c_p = \cos(T\ln p)$:

$$\sum_{m=1}^{\infty} \frac{T_m(c_p)}{m\, p^{m/2}} = -\frac{1}{2}\ln\!\left(1 - \frac{2c_p}{\sqrt{p}} + \frac{1}{p}\right)$$

This collapses the infinite sum over prime powers ($m = 1, 2, 3, \ldots$)
into a **single logarithm per prime**.

### Connection to the Euler product

The right side is exactly $-\frac{1}{2}\ln|1 - p^{-s}|^2$ with $s = 1/2 + iT$,
since $|1 - p^{-s}|^2 = 1 - 2\,\mathrm{Re}(p^{-s}) + |p^{-s}|^2 = 1 - 2c_p/\sqrt{p} + 1/p$.

Therefore:

$$\ln|\zeta(1/2+iT)|^2 = -\sum_p \ln\!\left(1 - \frac{2c_p}{\sqrt{p}} + \frac{1}{p}\right)$$

The Euler product $\zeta(s) = \prod_p(1-p^{-s})^{-1}$, written in Chebyshev language,
is a **product of quadratic polynomials in the seeds** $c_p = \cos(T\ln p)$:

$$|\zeta(1/2+iT)|^2 = \prod_p \frac{1}{1 - 2c_p/\sqrt{p} + 1/p}$$

### For the imaginary part (zero counting)

Similarly, using the $U$ generating function and $\sin(mT\ln p) = \sin(T\ln p)\cdot U_{m-1}(\cos(T\ln p))$:

$$S(T) = -\frac{1}{\pi}\sum_p \mathrm{Im}\!\left[\ln\!\left(1 - p^{-1/2 - iT}\right)\right]$$

$$= -\frac{1}{\pi}\sum_p \arctan\frac{s_p/\sqrt{p}}{1 - c_p/\sqrt{p}}$$

where $s_p = \sin(T\ln p)$ and $c_p = \cos(T\ln p)$.

Each prime contributes **one arctan** instead of an infinite series over powers.

### What the orbit view adds

The Euler product is classical. The orbit rewriting makes explicit:

1. The argument of the logarithm/arctan is a **quadratic polynomial** in $c_p$
2. The seed $c_p = \cos(T\ln p)$ is the Chebyshev parameter of prime $p$ at height $T$
3. The collapse $\sum_m T_m(c)/m \cdot r^m \to -\frac{1}{2}\ln(1-2cr+r^2)$
   is the **resummation** of the orbit generating function

### Convergence caveat

The Euler product does NOT converge absolutely on the critical line ($\sigma = 1/2$).
Individual terms decay as $\sim 1/\sqrt{p}$, and $\sum 1/\sqrt{p}$ diverges.
The collapsed form inherits this: it is the Euler product in disguise,
with identical convergence properties (conditional, not absolute).

This is the dual face of the non-perturbative barrier: on the primal side
($\psi$), the Taylor expansion diverges term-by-term over zeros. On the dual
side ($N(T)$), the Euler product diverges over primes. Both require careful
summation (resummation / conditional convergence) to give finite answers.
