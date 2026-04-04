# Prime Periods and the Wagstaff–Mersenne Connection

**Date:** 2026-04-04
**Status:** ✅ PROVEN (cyclotomic identity), 🤔 INTERPRETIVE (geometric meaning)

## Origin

The successor recurrence was constructed to answer a purely algebraic question:

> Can we implement "+1" without explicitly adding anything?

The answer: the recurrence $f_{k+1} = (f_k^2 - o) / f_{k-1}$ with $o = 1$ produces
the natural numbers $1, 2, 3, \ldots$ via quadratic self-interaction and one step
of memory. No arithmetic operations beyond multiplication and division.

The recurrence itself has nothing to do with primes. They enter through a deliberate
follow-up question:

> What is the algebraic cost of exact periodicity — specifically, of prime period?

We put primes into the question. What is interesting is not that "primes appeared
from nowhere", but that the answer turned out to be a specific, named family
of numbers with deep open problems — rather than some opaque expression.

## The Cost of Exact Period

For the orbit to have exact period $2q$, the seed must be:

$$o_q = \frac{1}{\lambda^2 - 2\lambda\cos(\pi/q) + 1} = \frac{1}{|\lambda - e^{i\pi/q}|^2}$$

This is an algebraic number in $\mathbb{Q}(\cos(\pi/q))$ of degree $\varphi(q)/2$
over $\mathbb{Q}$. The **norm** (product of all Galois conjugates) measures the
total algebraic complexity of the seed:

$$\frac{1}{\mathrm{Nm}(o_q)} = \Phi_{2q}(\lambda)$$

where $\Phi_{2q}$ is the $2q$-th cyclotomic polynomial.

## Prime Periods: Wagstaff Numbers

For **prime** period $2p$ (odd prime $p$), the cyclotomic polynomial simplifies:

$$\Phi_{2p}(\lambda) = \frac{\lambda^p + 1}{\lambda + 1}$$

At the default scale $\lambda = 2$:

$$\frac{1}{\mathrm{Nm}(o_p)} = \frac{2^p + 1}{3}$$

These are **Wagstaff numbers**.

### What Are Wagstaff Numbers?

A **Wagstaff number** is a number of the form $(2^q + 1)/3$ where $q$ is an odd
positive integer. The division by 3 always yields an integer because
$2^q + 1 \equiv 0 \pmod{3}$ for odd $q$ (since $2 \equiv -1 \pmod{3}$).

A **Wagstaff prime** is a Wagstaff number that is itself prime. This requires $q$
itself to be prime (if $q = ab$ is composite, then $2^a + 1$ divides $2^q + 1$
when $b$ is odd, giving a nontrivial factor of $(2^q + 1)/3$).

Known Wagstaff primes (as of 2025):

| $p$ | $(2^p + 1)/3$ | Digits |
|-----|---------------|--------|
| 3 | 3 | 1 |
| 5 | 11 | 2 |
| 7 | 43 | 2 |
| 11 | 683 | 3 |
| 13 | 2731 | 4 |
| 17 | 43691 | 5 |
| 19 | 174763 | 6 |
| 23 | 2796203 | 7 |
| 31 | 715827883 | 9 |
| 43 | 2932031007403 | 13 |
| 61 | $\approx 7.7 \times 10^{17}$ | 18 |
| 79 | $\approx 2.0 \times 10^{23}$ | 24 |
| 101 | $\approx 8.5 \times 10^{29}$ | 30 |
| 127 | $\approx 5.7 \times 10^{37}$ | 38 |
| ... | ... | ... |

It is conjectured that infinitely many Wagstaff primes exist, but this is unproven.
Their heuristic density among primes of size $N$ is $\sim C / \ln N$, comparable
to Mersenne primes.

Wagstaff numbers are related to **Mersenne numbers** $M_p = 2^p - 1$ through:

$$4^p - 1 = (2^p + 1)(2^p - 1)$$

The two factors correspond to the two Galois orbits of the seed's conjugates
(see below).

## The Galois Factorization

The full product of $|\lambda - e^{ik\pi/p}|^2$ over all $k = 1, \ldots, p-1$
factors into two cyclotomic evaluations:

$$\prod_{k=1}^{p-1} |\lambda - e^{ik\pi/p}|^2 = \frac{\lambda^{2p} - 1}{\lambda^2 - 1}
= \underbrace{\frac{\lambda^p + 1}{\lambda + 1}}_{\text{odd } k:\; \Phi_{2p}(\lambda)} \times \underbrace{\frac{\lambda^p - 1}{\lambda - 1}}_{\text{even } k:\; \Phi_p(\lambda)}$$

| Galois orbit | Conjugates of | Product | $\lambda = 2$ | Name |
|---|---|---|---|---|
| **Odd** $k$ | $\cos(\pi/p)$ | $\Phi_{2p}(\lambda)$ | $(2^p+1)/3$ | Wagstaff |
| **Even** $k$ | $\cos(2\pi/p)$ | $\Phi_p(\lambda)$ | $2^p - 1$ | Mersenne |

One recurrence, two families of prime candidates. They arise as complementary
halves of the same algebraic structure.

### Proof

$|\lambda - e^{i\theta}|^2 = \lambda^2 - 2\lambda\cos\theta + 1$.
The product over primitive $2p$-th roots of unity gives $\Phi_{2p}(\lambda)$
by definition of the cyclotomic polynomial.
For odd prime $p$: $\Phi_{2p}(x) = \Phi_p(-x) = (-x)^{p-1} - (-x)^{p-2} + \cdots + 1
= x^{p-1} - x^{p-2} + \cdots + 1 = (x^p + 1)/(x + 1)$. $\square$

## What This Construction Adds

### New perspective

Wagstaff numbers are traditionally defined arithmetically: $(2^p + 1)/3$.
Here they arise as the **norm of an algebraic seed** — the total algebraic complexity
required for the successor recurrence to achieve exact prime period.

We asked about prime periods, so primes are in the input. What we did NOT choose
is the output: it could have been any algebraic expression, but it turned out
to be $\Phi_{2p}(\lambda)$ — a cyclotomic polynomial evaluation that connects directly
to the Wagstaff family. The specificity of the answer is the surprise, not the
presence of primes.

### Wagstaff vs. Mersenne: directness of connection

- **Wagstaff** $\Phi_{2p}(\lambda) = (\lambda^p+1)/(\lambda+1)$: this IS the norm
  of $o_p$. It is the direct, unavoidable answer to "what is the algebraic cost
  of prime period $2p$?"
- **Mersenne** $\Phi_p(\lambda) = (\lambda^p-1)/(\lambda-1)$: this is the norm of the
  **complementary** Galois orbit (even conjugates of $\cos(2\pi/p)$, as opposed to
  odd conjugates of $\cos(\pi/p)$). It appears through the algebraic identity
  $(\lambda^{2p}-1)/(\lambda^2-1) = \Phi_{2p} \cdot \Phi_p$. The Mersenne connection
  is real but one step more indirect — it is the "other half" of the conjugate structure,
  not a direct property of $o_p$.

### The degenerate limit

The natural numbers (which contain the primes) sit at $o = 1$: the degenerate
point where period $\to \infty$ and algebraic cost $\to 0$ (the seed is rational).

Moving away from this point to exact period $2p$ requires seed $o_p$
of algebraic degree $(p-1)/2$, and the norm of $o_p$ is the reciprocal of
a Wagstaff number.

Two manifestations of primes in the same framework:
- **Primes within the naturals**: visible at the degenerate point $o = 1$
- **Wagstaff primes as norms of prime-period seeds**: visible at the cyclotomic points $o_p$

### General scale $\lambda$

Each $\lambda$ gives a different "recurrence universe" with its own prime-period seeds.
The norm is always $\Phi_{2p}(\lambda) = (\lambda^p + 1)/(\lambda + 1)$:

| $\lambda$ | Wagstaff family | First few for $p = 3, 5, 7, 11$ |
|---|---|---|
| 2 | $(2^p + 1)/3$ | 3, 11, 43, 683 |
| 3 | $(3^p + 1)/4$ | 7, 61, 547, 44287 |
| 10 | $(10^p + 1)/11$ | 91, 9091, 909091, ... |

### What this does NOT add

- No new primality test or proof technique
- No shortcut to the Wagstaff conjecture
- The cyclotomic identity $\Phi_{2p}(\lambda)$ is classical;
  the new element is the interpretation, not the computation

## Connection to the Triptych

The three algebraic groups from the finite-field analysis
(see `degenerate-case-additive-group.md` and `finite-field-orbits.md`)
connect to the prime structure as follows:

| Regime | Group | Period mod $p$ | Role in prime story |
|---|---|---|---|
| Degenerate ($c = 1$) | $\mathbb{G}_a$ | $p$ | Contains the primes (as a subset of naturals) |
| Oscillatory ($\|c\| < 1$) | Non-split torus | divides $p + 1$ | Exact periodicity; seeds are algebraic with Wagstaff norms |
| Hyperbolic ($c > 1$) | $\mathbb{G}_m$ | divides $p - 1$ | Mersenne side of the factorization |

The three regimes, the three groups, and the two prime families
are all facets of the same $\mathrm{GL}_2$ structure over $\mathbb{F}_p$.
