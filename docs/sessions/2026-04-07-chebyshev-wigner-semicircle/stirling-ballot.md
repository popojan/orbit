# Stirling's Formula via Pell-Ballot Geometry

**Date:** 2026-04-07
**Status:** Exploratory observation, not yet proven

## Discovery

Starting from `PellBallotCount[d, x]` — the number of monotonic lattice paths from $(1,0)$
to $(x, y^*(x))$ staying above the Pell hyperbola $u^2 - Dv^2 \geq 1$ — we define the
**ballot sequence** for a given $D$:

$$b_D(x) = \frac{1}{x}\binom{x + y^*(x) - 1}{y^*(x)}, \quad y^*(x) = \left\lfloor\sqrt{\frac{x^2-1}{D}}\right\rfloor$$

and study the cumulative log-product:

$$S_D(k) = \sum_{x=1}^{k} \log b_D(x)$$

## Three phases

For $n = \lfloor\sqrt{D}\rfloor$, the ballot sequence has three phases:

| Phase | $x$ range | $y^*(x)$ | $b_D(x)$ | Contribution to $S$ |
|-------|-----------|----------|-----------|---------------------|
| I | $1 \leq x \leq n$ | 0 | $1/x$ | $-\log(n!)$ |
| II | $n < x \leq \sim 2n$ | 1 | 1 | 0 |
| III | $\sim 2n < x$ | 2 | $(x+1)/2$ | growing |

Phase I is universal (independent of $D$). Phase II contributes nothing.
Phase III compensates the Phase I deficit with ballot numbers $(x+1)/2$.

## The $e$-crossing

$S_D(k)$ crosses the value $e = 2.71828\ldots$ at a point $b$ satisfying:

$$\frac{b}{n} \to e \quad \text{as } n \to \infty$$

Numerically verified:

| $n$ | $b/n$ |
|:---:|:---:|
| 7 | 2.731 |
| 10 | 2.706 |
| 15 | 2.702 |
| 20 | 2.707 |
| 25 | 2.713 |

Convergence to $e$ (oscillatory).

## Stirling from Pell-Ballot

Setting $S_D(b) = e$ with $b \approx en$ and $a \approx 2n+1$:

$$\log(n!) = \text{LogGamma}(en + 2) - \text{LogGamma}(2n + 2) - (en - 2n)\log 2 - e$$

This is an **exact** equation (given the exact $b$) that determines $\log(n!)$ from the
ballot structure of the Pell hyperbola. When $b/n = e$ exactly, it becomes a closed-form
Stirling-type identity.

The constant $e$ appears **twice**:
1. As the crossing threshold: $S_D(b) = e$
2. As the crossing ratio: $b/n \to e$

## Classical Stirling comparison

The classical derivations of Stirling's formula $n! \approx \sqrt{2\pi n}(n/e)^n$ use:

1. **Euler-Maclaurin summation** (historical, Stirling 1730): approximate $\sum \log k$ by
   $\int \log x\, dx = x\log x - x$, with correction terms involving Bernoulli numbers.

2. **Laplace method / saddle point**: write $n! = \int_0^\infty x^n e^{-x} dx$, approximate
   the integrand near its maximum at $x = n$ by a Gaussian. The $\sqrt{2\pi n}$ comes from
   the Gaussian integral.

3. **Central limit theorem**: $\log(n!) = \sum_{k=1}^n \log k$ is a sum of independent
   terms; CLT gives the leading asymptotics.

Our derivation is structurally different:
- $\log(n!)$ arises as the **Phase I deficit** of the Pell-ballot sequence
- The compensation by Phase III ballot numbers $(x+1)/2$ involves **lattice path counting**
- The crossing point $b \approx en$ comes from the **geometry of the Pell hyperbola**
- No integration, no saddle point, no Bernoulli numbers — purely combinatorial/geometric

## Open questions

1. **Proof of $b/n \to e$:** Can we derive this from Stirling itself (circular?) or from
   the ballot structure directly?
2. **Why $e$ twice?** Is the double appearance of $e$ (threshold and ratio) a consequence
   of a single deeper identity?
3. **Error terms:** The classical Stirling has correction $1 + 1/(12n) + \ldots$. Does the
   Pell-ballot derivation give a different (perhaps combinatorially meaningful) error series?
4. **Is this circular?** We use LogGamma to solve for $b$. If the $b/n \to e$ convergence
   can be proven independently of Stirling, the derivation is non-circular. If it requires
   Stirling, it's a reformulation rather than a new proof.
