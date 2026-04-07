# Phase Invariants and Norms

**Date:** 2026-04-07
**Status:** Numerically verified

## Phase structure recap

For $D$ with $n = \lfloor\sqrt{D}\rfloor$, the ballot sequence $b_D(x)$ has phases:

| Phase $k$ | $x$ range | $y^*(x)$ | $b_D(x)$ |
|:---:|:---:|:---:|:---:|
| 0 | $1 \ldots n$ | 0 | $1/x$ |
| 1 | $n{+}1 \ldots 2n$ | 1 | $1$ |
| 2 | $2n{+}1 \ldots 3n$ | 2 | $(x{+}1)/2$ |
| $k$ | $kn{+}1 \ldots (k{+}1)n$ | $k$ | $\binom{x+k-1}{k}/x$ |

Phase boundaries approximate: exact boundaries at $x = \lceil\sqrt{Dk^2+1}\rceil \approx kn$.

## Invariant at end of phase $k$

$$I_k(n) = \prod_{j=0}^{k}\;\prod_{x=jn+1}^{(j+1)n} \frac{1}{x}\binom{x+j-1}{j}$$

This depends **only on $n$**, not on $D$ within the band $(n^2, (n+1)^2)$.
Band invariance holds because $b_D(x) = \binom{x+k-1}{k}/x$ depends on $x$ and $k$,
and the phase assignment $k = y^*(x)$ is the same for all $D$ in the band (to within
$\pm 1$ at boundaries).

### First few invariants

| $k$ | $I_k(n)$ |
|:---:|:---|
| 0 | $1/n!$ |
| 1 | $1/n!$ (phase 1 contributes nothing) |
| 2 | $(3n+1)! \;/\; (n! \cdot (2n+1)! \cdot 2^n)$ |
| 3 | $I_2(n) \times \prod_{x=3n+1}^{4n} (x+1)(x+2)/6$ |

### Scaling

| $k$ | $\log I_k(n)$ scaling |
|:---:|:---|
| 0 | $-n\log n + n$ (Stirling) |
| 2 | $\sim +n\log(3/2)$ (compensates phase 0) |
| 3 | $\sim 5n$ |
| 4 | $\sim 12n$ |

The $e$-crossing (where $\log I \approx e$) falls in phase 2 for all $D \geq 12$.

## ANY threshold gives an invariant

A crossing threshold $c$ gives band-invariant crossing **if and only if** the crossing
falls inside a phase (not on a phase boundary). Since ballot values within a phase
depend only on $x$ and $k$, the cumulative sum at any $x$ inside a phase is the same
for all $D$ in the band.

The threshold $e$ is **not special**. Constants $0, 1, \pi, 42$ all give band invariants.
The appearance of $e$ in $b/n \to e$ is a consequence of Stirling's formula
($\log(n!) \approx n\log n - n$), not an independent phenomenon.

## Norms at phase boundaries

At the end of phase $k$, the point $(x, y^*) = ((k+1)n,\; k)$ has norm:

$$N_k(n, D) = ((k+1)n)^2 - D\,k^2$$

For $D = n^2 + 1$ (canonical representative):

$$N_k = n^2(2k+1) - k^2$$

### Key contrast

| Property | Invariant $I_k(n)$ | Norm $N_k(n, D)$ |
|:---:|:---:|:---:|
| Depends on $D$? | **No** (only $n$) | **Yes** (from phase 1 onward) |
| Growth in $k$ | Super-exponential | Linear ($\sim 2kn^2$) |
| Information | Combinatorial (Gamma ratios) | Arithmetic ($x^2 - Dy^2$) |

The norm $N_k$ is the quantity that distinguishes different $D$ within a band.
The invariant $I_k$ is the quantity that is universal across the band.

Together they give complementary views of the lattice point $(x, y^*)$:
- $I_k$ says how many ballot paths reach it (combinatorial)
- $N_k$ says where it sits relative to the hyperbola (arithmetic)

## Stirling and beyond

Phase 2 invariant gives Stirling: $I_2(n) = (3n+1)!/(n!(2n+1)!2^n) \sim e^e$ as $n \to \infty$.

Higher phases give a **family of factorial identities**, each involving products of
rising factorials (Pochhammer symbols) balanced against $1/n!$:

$$I_k(n) = \frac{1}{n!} \prod_{j=2}^{k}\;\prod_{x=jn+1}^{(j+1)n} \frac{(x+1)^{\overline{j-1}}}{j!}$$

These are new identities (not reducible to Stirling) for $k \geq 3$.
