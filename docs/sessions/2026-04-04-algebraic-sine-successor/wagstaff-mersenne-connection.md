# Wagstaff–Mersenne Factorization of Prime Period Seeds

**Date:** 2026-04-04
**Status:** ✅ PROVEN (cyclotomic polynomial identity)

## The Seed for Prime Period

The successor orbit with exact period $2p$ (for odd prime $p$) has algebraic seed:

$$o_p = \frac{1}{|\lambda - e^{i\pi/p}|^2} = \frac{1}{\lambda^2 - 2\lambda\cos(\pi/p) + 1}$$

This is an algebraic number in $\mathbb{Q}(\cos(\pi/p))$, the maximal real subfield
of the cyclotomic field $\mathbb{Q}(\zeta_{2p})$, of degree $(p-1)/2$ over $\mathbb{Q}$.

## The Norm Formula

The norm (product of all Galois conjugates) has a closed form:

$$\boxed{\frac{1}{\mathrm{Nm}(o_p)} = \Phi_{2p}(\lambda) = \frac{\lambda^p + 1}{\lambda + 1}}$$

For $\lambda = 2$ (default scale):

$$\frac{1}{\mathrm{Nm}(o_p)} = \frac{2^p + 1}{3}$$

These are the **Wagstaff numbers**.

### Proof

The key observation: $\lambda^2 - 2\lambda\cos\theta + 1 = |\lambda - e^{i\theta}|^2$.
So $1/o_p = |\lambda - \omega|^2$ where $\omega = e^{i\pi/p}$ is a primitive $2p$-th root of unity.

The Galois conjugates of $\cos(\pi/p)$ are $\cos(k\pi/p)$ for odd $k$, $1 \leq k \leq p-2$.
These pair with $\cos((2p-k)\pi/p)$ to give the full set of primitive $2p$-th roots:

$$\frac{1}{\mathrm{Nm}(o_p)}
= \prod_{\substack{k \text{ odd} \\ 1 \leq k \leq p-2}} |\lambda - e^{ik\pi/p}|^2
= \prod_{\gcd(j, 2p)=1} (\lambda - e^{ij\pi/p})
= \Phi_{2p}(\lambda) \qquad \square$$

where $\Phi_{2p}$ is the $2p$-th cyclotomic polynomial, which for odd prime $p$ equals
$(\lambda^p + 1)/(\lambda + 1)$.

## The Wagstaff–Mersenne Factorization

The full product over ALL conjugates of $\cos(\pi/p)$ (not just the Galois orbit of $o_p$)
splits into two classical sequences:

$$\prod_{k=1}^{p-1} |\lambda - e^{ik\pi/p}|^2 = \frac{\lambda^{2p} - 1}{\lambda^2 - 1}
= \underbrace{\frac{\lambda^p + 1}{\lambda + 1}}_{\Phi_{2p}(\lambda)} \times \underbrace{\frac{\lambda^p - 1}{\lambda - 1}}_{\Phi_p(\lambda)}$$

| Conjugates | Product | $\lambda = 2$ | Name |
|---|---|---|---|
| **Odd** $k$ (orbit of $\cos(\pi/p)$) | $\Phi_{2p}(\lambda)$ | $(2^p+1)/3$ | **Wagstaff number** |
| **Even** $k$ (orbit of $\cos(2\pi/p)$) | $\Phi_p(\lambda)$ | $2^p - 1$ | **Mersenne number** |
| **All** $k$ | $\Phi_{2p} \cdot \Phi_p$ | $(4^p-1)/3$ | Full product |

The odd/even split corresponds to the two orbits of the Galois group
$\mathrm{Gal}(\mathbb{Q}(\zeta_{2p})/\mathbb{Q})$ on the cosine values.

## Numerical Data ($\lambda = 2$)

| $p$ | Period $2p$ | Degree | Wagstaff $(2^p{+}1)/3$ | Prime? | Mersenne $2^p{-}1$ | Prime? |
|---|---|---|---|---|---|---|
| 3 | 6 | 1 | 3 | ✅ | 7 | ✅ |
| 5 | 10 | 2 | 11 | ✅ | 31 | ✅ |
| 7 | 14 | 3 | 43 | ✅ | 127 | ✅ |
| 11 | 22 | 5 | 683 | ✅ | 2047 = 23·89 | ❌ |
| 13 | 26 | 6 | 2731 | ✅ | 8191 | ✅ |
| 17 | 34 | 8 | 43691 | ✅ | 131071 | ✅ |
| 19 | 38 | 9 | 174763 | ✅ | 524287 | ✅ |
| 23 | 46 | 11 | 2796203 | ✅ | 8388607 = 47·178481 | ❌ |
| 29 | 58 | 14 | 178956971 = 59·3033169 | ❌ | 536870911 = 233·1103·2089 | ❌ |
| 31 | 62 | 15 | 715827883 | ✅ | 2147483647 | ✅ |

## The Primality Question

> **For which primes $p$ is $\mathrm{Nm}(o_p)^{-1}$ prime?**

This is exactly the **Wagstaff prime** problem: determine all primes $p$ such that
$(2^p + 1)/3$ is prime.

Known Wagstaff primes correspond to
$p = 3, 5, 7, 11, 13, 17, 19, 23, 31, 43, 61, 79, 101, 127, 167, 191, 199, 313, 347, \ldots$

It is conjectured (but unproven) that infinitely many Wagstaff primes exist.
Their density among primes of size $N$ is heuristically $\sim C / \ln N$,
similar to Mersenne primes.

## General Scale $\lambda$

For $\lambda \neq 2$, the norm $\Phi_{2p}(\lambda) = (\lambda^p + 1)/(\lambda + 1)$
connects to other families of prime-hunting:

| $\lambda$ | $\Phi_{2p}(\lambda)$ | Known prime family |
|---|---|---|
| 2 | $(2^p + 1)/3$ | Wagstaff primes |
| 3 | $(3^p + 1)/4$ | Generalized Wagstaff (base 3) |
| 10 | $(10^p + 1)/11$ | Near-repunit primes |

## What This Means for the Successor Orbit

The successor orbit parametrizes a family of algebraic numbers $\{o_q\}$ indexed by
the period $2q$. Restricting to prime periods $2p$:

1. Each $o_p$ generates a specific number field of degree $(p-1)/2$
2. The norm of $o_p$ is $(\lambda + 1)/(\lambda^p + 1)$ — a rational number
3. The denominator $(\lambda^p + 1)/(\lambda + 1)$ is a cyclotomic polynomial evaluation
4. Its primality is equivalent to the Wagstaff prime problem

The successor orbit doesn't solve the Wagstaff conjecture, but it provides
a natural geometric context: Wagstaff numbers arise as the **total algebraic
complexity** (= norm of the seed) needed to construct an orbit of prime period.
