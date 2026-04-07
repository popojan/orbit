# Ballot Multiplicative Structure across Z[√D] Rings

**Date:** 2026-04-07
**Status:** Exploratory, strong empirical patterns

## Setup

For non-square $D$ with Pell solution $(x_1, y_1)$, the ballot number is:

$$B(D) = \frac{1}{x_1}\binom{x_1 + y_1 - 1}{y_1}$$

For fixed $y$, this is a polynomial in $x$ of degree $y-1$:
- $y = 1$: $B = 1$
- $y = 2$: $B = (x+1)/2$
- $y = 3$: $B = (x+1)(x+2)/6$
- $y = k$: $B = (x+1)^{\overline{k-1}} / k!$ (rising factorial / factorial)

## Observation: near-primorial factorization

Ballot numbers at Pell solutions factor into products of small primes, with
most primes appearing at power 1. The factorization resembles a primorial
with "holes" — some small primes missing, higher primes occasionally appearing
at power > 1.

This is expected: $B$ is a product of $y-1$ consecutive integers $(x+1, x+2, \ldots, x+y-1)$
divided by $y!$. Consecutive integers contribute small prime factors richly.

## Cross-ring structure: ballot ratios

Comparing ballot numbers across different $D$ (different $\mathbb{Z}[\sqrt{D}]$ rings):

### Same-y ratios

For $D_1, D_2$ with solutions $(x_1, y)$ and $(x_2, y)$ (same $y$):

$$\frac{B(D_2)}{B(D_1)} = \frac{(x_2+1)^{\overline{y-1}}}{(x_1+1)^{\overline{y-1}}}$$

This is a ratio of two products of $y-1$ consecutive integers — always rational,
often with large cancellation (shared factors).

### Cross-y ratios (empirical focus)

For $D_1$ with solution $(x_1, y_1)$ and $D_2$ with $(x_2, y_2)$ where $y_2 / y_1$
is a simple ratio (2, 3/2, etc.), the ballot ratio is often a **small integer
or simple fraction**.

Verified systematically for D = 2..500, y ≤ 30:

**y-ratio = 3/2 (y₁ = 2, y₂ = 3):**
| $D_1$ $(x_1, 2)$ | $D_2$ $(x_2, 3)$ | ballot ratio |
|:---:|:---:|:---:|
| 20 (9, 2) | 7 (8, 3) | 3 |
| 90 (19, 2) | 40 (19, 3) | 7 |
| 182 (27, 2) | 75 (26, 3) | 9 |
| 306 (35, 2) | 75 (26, 3) | 7 |
| 420 (41, 2) | 75 (26, 3) | 6 |
| 342 (37, 2) | 32 (17, 3) | 3 |
| 342 (37, 2) | 152 (37, 3) | 13 |

**Mechanism for y₁=2, y₂=3:**
$$\frac{B(x_2, 3)}{B(x_1, 2)} = \frac{(x_2+1)(x_2+2)/6}{(x_1+1)/2} = \frac{(x_2+1)(x_2+2)}{3(x_1+1)}$$

Small integer ratio ⟺ $3(x_1+1) \mid (x_2+1)(x_2+2)$.

## p-adic valuation profiles

Ballot numbers viewed as vectors of $p$-adic valuations $(v_2, v_3, v_5, v_7, \ldots)$:

- Within same $y$: profiles differ in 1-3 primes ("Hamming distance")
- Cross-$y$ with simple $y$-ratio: profiles still close

**Hamming distance 1 pairs** (ballot numbers differ by a single prime factor):

| $D_1$ (sol) | $D_2$ (sol) | Prime difference |
|:---:|:---:|:---:|
| 7 (8, 3) | 18 (17, 4) | +19 |
| 7 (8, 3) | 215 (44, 3) | +23 |
| 18 (17, 4) | 32 (17, 3) | -5 |
| 40 (19, 3) | 95 (39, 4) | +41 |
| 87 (28, 3) | 203 (57, 4) | +59 |
| 150 (49, 4) | 200 (99, 7) | +4 (= 2²) |

## Direction: multiplicative lattice of Pell solutions

Simple ballot ratios between different $D$ encode **arithmetic relationships between
Pell x-coordinates** through the multiplicative structure of rising factorials.

A ballot ratio of $p$ (prime) between $D_1$ and $D_2$ means their Pell solutions share
almost all prime factors in their rising factorial products, differing by exactly one
prime $p$. This defines a **graph on Pell solutions** where edges are labeled by primes.

### Open questions

1. **Graph structure:** What does the "ballot neighbor graph" (Hamming-1 pairs) look like?
   Is it connected? Does it cluster by class number, regulator size, or CF period?

2. **Predictive power:** Given a known Pell solution $(x_1, y_1)$ for $D_1$, can ballot
   neighbors predict Pell solutions for nearby $D_2$? I.e., if $B(D_2) = p \cdot B(D_1)$,
   does knowing $p$ help find $(x_2, y_2)$?

3. **Large D:** Does the near-primorial structure persist for hard Pell cases (D = 61, 409)?
   The factorization of ballot numbers for these D has thousands of prime factors — do
   they still neighbor ballot numbers of other D in the Hamming-1 sense?

4. **Cross-family bridges:** The simplest ratios occur between D in the same Richaud-Degert
   family (same $y$). Do non-trivial bridges exist between distant families (large $y$-ratio)?
