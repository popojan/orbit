# Ballot Product Invariant over Z[√D] bands

**Date:** 2026-04-07
**Status:** Numerically verified, mechanism understood

## Setup

For non-square $D > 1$, define the ballot sequence:
$$b_D(x) = \frac{1}{x}\binom{x + y^*(x) - 1}{y^*(x)}, \quad y^*(x) = \left\lfloor\sqrt{\frac{x^2-1}{D}}\right\rfloor$$

and the cumulative log-product $S_D(k) = \sum_{x=1}^{k} \log b_D(x)$.

## Three-phase structure

For $n = \lfloor\sqrt{D}\rfloor$:

| Phase | Range | $y^*$ | $b_D(x)$ | Closed form of product |
|:---:|:---:|:---:|:---:|:---:|
| 0 | $x = 1 \ldots n$ | 0 | $1/x$ | $1/n!$ |
| 1 | $x = n{+}1 \ldots a{-}1$ | 1 | 1 | 1 |
| 2 | $x = a \ldots b$ | 2 | $(x{+}1)/2$ | $(b{+}1)! \;/\; (a! \cdot 2^{b-a+1})$ |

where $a = \lceil 2\sqrt{D} \rceil$ (first $x$ with $y^* = 2$).

## Total product: closed form

$$\prod_{x=1}^{b} b_D(x) = \frac{(b+1)!}{n! \;\cdot\; a! \;\cdot\; 2^{b-a+1}}$$

Verified exactly for $n = 3, 5, 7, 10, 15$.

## Band invariance

The product depends on $D$ only through $n = \lfloor\sqrt{D}\rfloor$.
All $D$ in the band $(n^2, (n+1)^2)$ give at most **two** invariant values
(corresponding to the two possible discrete crossing positions of $S$ near $e$).

Verified for bands $n = 3$ through $n = 10$.

### Invariant values

| $n$ | Band | Values |
|:---:|:---:|:---:|
| 3 | $D = 10 \ldots 15$ | $15, \; 165/8$ |
| 4 | $D = 17 \ldots 24$ | $55/8, \; 143/16$ |
| 5 | $D = 26 \ldots 35$ | $273/16, \; 91/4$ |
| 6 | $D = 37 \ldots 48$ | $357/8, \; 51/8$ |
| 7 | $D = 50 \ldots 63$ | $323/28, \; 969/64$ |

## Z[√D] interpretation

The invariance reflects that the **near-origin geometry** of the lattice $\mathbb{Z}[\sqrt{D}]$
above the Pell hyperbola $u^2 - Dv^2 = 1$ depends only on $n = \lfloor\sqrt{D}\rfloor$:

- **Phase 0** ($y^* = 0$): lattice points $(x, 0)$ for $x \leq n$ lie above the hyperbola
  for all $D$ in the band. Their ballot numbers $1/x$ are universal.

- **Phase 1** ($y^* = 1$): points $(x, 1)$ with $x^2 - D \geq 1$ form a band of width
  $\sim n$ that also depends only on $n$ (since $x^2 - D \geq 1 \iff x \geq \lceil\sqrt{D+1}\rceil \approx n+1$).

- **Phase 2** ($y^* = 2$): points $(x, 2)$ with $x^2 - 4D \geq 1$, starting at $x = a \approx 2n$.
  Ballot numbers $(x+1)/2$ depend only on $x$, not on $D$.

So the product through all three phases is a function of $n$ alone: a ratio of factorials
and a power of 2 that encodes the shape of $\mathbb{Z}[\sqrt{D}]$ near the origin.

## Connection to Stirling

The $e$-crossing equation $S_D(b) = e$ with $b/n \to e$ gives:

$$\log \frac{(en + 1)!}{n! \cdot (2n+1)! \cdot 2^{(e-2)n}} \approx e$$

This is a Stirling-type identity discovered from the ballot geometry.
However, $b/n \to e$ is a consequence of Stirling (not independent of it),
so this is a reformulation rather than a new proof.

## What IS new

1. **The invariant itself**: the product of ballot numbers $b_D(x)$ for $x = 1 \ldots b$
   is constant across $\mathbb{Z}[\sqrt{D}]$ rings with the same $\lfloor\sqrt{D}\rfloor$.

2. **Closed form**: the product factors as $(b+1)! / (n! \cdot a! \cdot 2^{b-a+1})$
   through the three-phase decomposition.

3. **Path to discovery**: the invariant was found by studying `PellBallotCount` —
   lattice paths above the Pell hyperbola. The ballot numbers arise from the Shadow
   Identity (path count = ballot for CF convergents). The band invariance comes from
   the geometry of $\mathbb{Z}[\sqrt{D}]$ near the origin.
