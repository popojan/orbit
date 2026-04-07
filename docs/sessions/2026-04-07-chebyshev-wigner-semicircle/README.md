# Session: |C_k| as Wigner Semicircle Kernel via Anti-Aliasing

**Date:** 2026-04-07
**Status:** Complete (clean identity, not deep RMT)
**Builds on:** Chebyshev Integral Theorem (`docs/papers/chebyshev-integral-identity.tex`)

## Motivation

The Chebyshev Integral Theorem establishes that
$$\int_{-1}^{1} |C_k(x)|\,dx = 1 \quad\text{for } k \ge 2$$
where $C_k(x) = T_{k+1}(x) - x\,T_k(x) = -(1-x^2)\,U_{k-1}(x)$.

This means $|C_k|$ is a unit-mass non-negative function on $[-1,1]$ --- a probability density.
A natural "toy application": treat $|C_k|$ as a smeared Dirac delta on $[-1,1]$ and integrate
another function against it:
$$\langle f \rangle_k := \int_{-1}^{1} f(x)\,|C_k(x)|\,dx$$

The key appreciation: we have a **closed-form** function $C_k(x) = T_{k+1}(x) - x\,T_k(x)$
whose absolute value has a prescribed envelope $(2/\pi)(1-x^2)$ and unit integral. An explicit
polynomial with known DC envelope, parametrized by oscillation count $k$.

## Entry point: odd-power blindness

The exploratory function
```mathematica
noOddPowers[f_, hi_ : 10] :=
  Table[Integrate[f[x], {x, -1, 1}]^-1
    Integrate[f[x] Abs@ChebyshevPolygonFunction[x, k], {x, -1, 1}],
  {k, 1, hi}]
```
was tested with $f(x) = ax^3 + bx^2 + cx + d$. Observation:

- Coefficients of **odd powers** ($a$, $c$) drop out of the result for **all** $k$.
- From $k \ge 3$, the ratio **stabilizes** to a single value depending only on the even coefficients.

**Odd-power blindness** is explained by parity: $|C_k(x)|$ is always an even function
(since $C_k$ has definite parity --- even for odd $k$, odd for even $k$ --- and $|{\cdot}|$
makes both cases even). Integration of (odd $\times$ even) over $[-1,1]$ vanishes.

The **stabilization** is deeper.

## Main result: Wigner semicircle moments

### Theorem (numerically verified, 20-digit precision)

For integer $k \ge n + 2$:
$$\int_{-1}^{1} x^{2n}\,|C_k(x)|\,dx \;=\; \frac{C_n}{4^n}$$
where $C_n = \binom{2n}{n}/(n+1)$ is the $n$-th **Catalan number**.

These are exactly the even moments of the **Wigner semicircle distribution**
on $[-1,1]$ with density $(2/\pi)\sqrt{1-x^2}$.

### Stabilization thresholds

| Moment $x^{2n}$ | Wigner value $C_n/4^n$ | Exact from $k =$ |
|:---:|:---:|:---:|
| $x^0$ | 1 | 2 |
| $x^2$ | 1/4 | 3 |
| $x^4$ | 1/8 | 4 |
| $x^6$ | 5/64 | 5 |
| $x^8$ | 7/128 | 6 |
| $x^{10}$ | 21/512 | 7 |
| $x^{2n}$ | $C_n/4^n$ | $n+2$ |

**Status:** 🔬 NUMERICALLY VERIFIED (20-digit precision, $n = 0,\ldots,8$, $k$ up to 15)

### Corollary: polynomial integration

For any polynomial $p(x)$ of degree $d$, and any $k \ge \lceil d/2 \rceil + 2$:
$$\int_{-1}^{1} p(x)\,|C_k(x)|\,dx \;=\; \int_{-1}^{1} p_{\mathrm{even}}(x)\;\frac{2}{\pi}\sqrt{1-x^2}\;dx$$
where $p_{\mathrm{even}}(x) = \tfrac{1}{2}[p(x)+p(-x)]$ is the even part of $p$.

In words: **$|C_k|$ acts as the Wigner semicircle weight on polynomials of degree $< 2(k-1)$.**

## Mechanism: Fourier orthogonality

Under $x = \cos\theta$:
$$|C_k(\cos\theta)| = \sin^2\theta\;|{\sin(k\theta)}|/\sin\theta \cdot \sin\theta = \sin^2\theta\;|\sin(k\theta)|$$

The moment integral becomes:
$$\int_0^\pi \cos^{2n}\theta\;\sin^2\theta\;|\sin(k\theta)|\;d\theta$$

Key observations:

1. $\cos^{2n}\theta\;\sin^2\theta$ is a trigonometric polynomial of degree $2n+2$
   (only Fourier modes $\cos(m\theta)$ with $m \le 2n+2$).

2. $|\sin(k\theta)|$ has Fourier cosine expansion with:
   - **DC component** $= 2/\pi$ (the average of $|\sin|$ over a period)
   - **Harmonics** at frequencies $2k, 4k, 6k, \ldots$

3. When $2k > 2n+2$, i.e. $k > n+1$, no harmonic of $|\sin(k\theta)|$ overlaps with
   the trigonometric polynomial. Only the DC component survives:

$$\int_0^\pi \cos^{2n}\theta\;\sin^2\theta\;|\sin(k\theta)|\;d\theta
  \;=\; \frac{2}{\pi}\int_0^\pi \cos^{2n}\theta\;\sin^2\theta\;d\theta$$

4. The right side is the $2n$-th moment of the Wigner semicircle, because
   the semicircle density $(2/\pi)\sqrt{1-x^2}$ becomes $(2/\pi)\sin^2\theta$ under $x = \cos\theta$.

**The threshold $k \ge n + 2$ is a Shannon--Nyquist anti-aliasing condition:**
the lowest harmonic of $|\sin(k\theta)|$ sits at frequency $2k$; the polynomial has
bandwidth $2n+2$. When $2k > 2n+2$, no aliasing occurs and only DC passes through.

## Conceptual summary

$$\underbrace{|C_k|}_{\text{Chebyshev lobe pulse}}
\;\xrightarrow[\text{on polynomials of deg} < 2(k-1)]{\text{acts as}}\;
\underbrace{\tfrac{2}{\pi}\sqrt{1-x^2}}_{\text{Wigner semicircle}}$$

The Chebyshev integral theorem ($\int |C_k| = 1$) is the **$n=0$ case** of this family.

The "smeared Dirac delta" intuition is apt: each $|C_k|$ is a unit-mass kernel that
oscillates with $k$ lobes on $[-1,1]$. For polynomials of degree below $2k-2$, these
oscillations average out, leaving only the DC envelope --- which is the semicircle.

## Honest assessment

The Wigner semicircle appears here for a **structural** reason, not a deep RMT one:

1. $|C_k(x)| = (1-x^2)|U_{k-1}(x)|$, so the factor $(1-x^2)$ — which IS the semicircle
   weight $\sqrt{1-x^2}$ squared — is baked into the definition from the start.
2. As $k$ grows, $|U_{k-1}(x)|\sqrt{1-x^2} = |\sin(k\theta)|$ equidistributes to its
   DC average $2/\pi$ (Weyl equidistribution / Riemann--Lebesgue).
3. What remains is $(2/\pi)(1-x^2) = (2/\pi)\sqrt{1-x^2} \cdot \sqrt{1-x^2}$, i.e. the
   semicircle density times $\sqrt{1-x^2}$... which is $(2/\pi)\sin^2\theta$ in the
   $\theta$ parametrization.

The Catalan numbers appear because they ARE the moments of $\sqrt{1-x^2}$. No free
probability or random matrix mechanism is at play.

**What IS valuable:**
- The Chebyshev integral theorem gains context: it is the $n=0$ member of a full
  moment family, all consequences of the same anti-aliasing mechanism.
- We have a **closed-form polynomial** $C_k(x) = T_{k+1}(x) - xT_k(x)$ whose
  absolute value has prescribed DC envelope $(2/\pi)(1-x^2)$, unit mass, and
  tunable oscillation frequency $k$. Such explicit constructions are not trivial
  even if the identity chain explaining them is routine.
- The Shannon--Nyquist framing (threshold = anti-aliasing) is clean and transferable.

## Connection to existing work

### Chebyshev integral identity paper
The unit integral $\int |C_k| = 1$ (proven in `chebyshev-integral-identity.tex`) is the
zeroth moment of this family. The paper establishes the foundation; this session shows it
extends to all polynomial moments via the same mechanism.

### RMT session (2025-12-03)
The earlier RMT session explored B(n,k) lobe areas and their arcsine distribution.
That concerns the **discrete** distribution of lobe sizes for fixed $n$.
This session concerns the **continuous** measure $|C_k(x)|\,dx$ and its moments.
The two are complementary views of the same geometry.

## Pre-threshold values

For $k < n+2$, the moments deviate from Wigner. The pre-threshold values are:

| $k$ | $\int x^2 |C_k|$ | $\int x^4 |C_k|$ |
|:---:|:---:|:---:|
| 1 | 4/15 $\approx$ 0.267 | 8/105 $\approx$ 0.114 |
| 2 | 1/3 $\approx$ 0.333 | 1/6 $\approx$ 0.167 |
| 3 | **1/4** (Wigner) | 7/48 $\approx$ 0.146 |
| $\ge 4$ | **1/4** | **1/8** (Wigner) |

**Status:** ⏸️ OPEN QUESTION — closed forms for pre-threshold values

---

## Part 2: Pell-Ballot Conjecture

### Origin

The Catalan/ballot connection to Chebyshev moments raised the question: where do Catalan
numbers appear in a non-trivial, non-generic way? The Wildberger algorithm for Pell
equations walks on an integer lattice — a natural setting for lattice path counting with
a hyperbolic boundary constraint, analogous to the diagonal constraint in the ballot problem.

### Setup

Given non-square $D > 1$ with fundamental Pell solution $(x_1, y_1)$, i.e. $x_1^2 - D y_1^2 = 1$:

- **Lattice:** integer points $(u, r)$ with $u \ge 1$, $r \ge 0$
- **Source:** $(1, 0)$
- **Sink:** $(x_1, y_1)$
- **Steps:** unit right $(+1, 0)$ and unit up $(0, +1)$
- **Constraint:** every visited point satisfies $u^2 - D r^2 \ge 1$ (stays on or above the Pell hyperbola)

Total unconstrained paths: $\binom{x_1 - 1 + y_1}{y_1}$

### Conjecture (Pell-Ballot)

**For every non-square $D > 1$:**
$$\#\{\text{monotonic lattice paths } (1,0) \to (x_1, y_1) \text{ above } u^2 - Dy^2 \ge 1\}
  \;=\; \frac{1}{x_1}\binom{x_1 + y_1 - 1}{y_1}$$

This is the **ballot number** (generalized Catalan number).

**Special case:** When $x_1 = y_1 + 1$ (e.g., $D = 2$: $(x_1, y_1) = (3, 2)$), the formula
reduces to the **Catalan number** $C_{y_1} = \frac{1}{y_1+1}\binom{2y_1}{y_1}$.

**Status:** 🔬 NUMERICALLY VERIFIED for all non-square $D = 2, \ldots, 50$
(including $D = 13$ with $(x_1, y_1) = (649, 180)$ and $D = 29$ with $(9801, 1820)$).
Verification via dynamic programming (exact integer arithmetic).

### Verification table (small D)

| $D$ | $(x_1, y_1)$ | Total paths | Above hyperbola | $= \binom{x_1+y_1-1}{y_1}/x_1$? |
|:---:|:---:|:---:|:---:|:---:|
| 2 | (3, 2) | 6 | 2 | $C_2 = 2$ ✓ |
| 3 | (2, 1) | 2 | 1 | $C_1 = 1$ ✓ |
| 5 | (9, 4) | 495 | 55 | ✓ |
| 6 | (5, 2) | 15 | 3 | ✓ |
| 7 | (8, 3) | 120 | 15 | ✓ |
| 10 | (19, 6) | 134596 | 7084 | ✓ |
| 13 | (649, 180) | huge | huge | ✓ (exact) |
| 29 | (9801, 1820) | astronomical | astronomical | ✓ (exact) |

### Interpretation

The Pell hyperbola $x^2 - Dy^2 = 1$ acts as a **ballot boundary**: exactly $1/x_1$ of all
monotonic lattice paths from $(1,0)$ to $(x_1, y_1)$ stay above it. This is the same fraction
as in the classical ballot problem, where a linear boundary $y = x$ gives fraction $1/(m+1)$.

The fact that a HYPERBOLIC boundary produces the same ballot formula as a LINEAR one is
surprising and non-obvious. It suggests that the Pell hyperbola has a hidden "straightness"
from the perspective of lattice path combinatorics.

### Multi-norm extension

The ballot formula was tested at **all** lattice points above the hyperbola (not just Pell
solutions). Result: ballot = DP holds not only for $x^2 - Dy^2 = 1$ but for a specific
set of norms $N$:

| $D$ | Norms where ballot = DP | Note |
|:---:|:---|:---|
| 2 | {1, 2} | |
| 3 | {1} | only Pell |
| 5 | {1, 4, 5} | 5 = D |
| 6 | {1, 3} | |
| 7 | {1, 2} | |
| 10 | {1, 6, 9, 10} | 10 = D, 9 = 3² |
| 11 | {1, 5} | |
| 13 | {3, 4} | Pell sol outside test range |

### CF path characterization of ballot norms

The ballot formula holds at $(x, y)$ iff $x^2 - Dy^2 = N$ where $N$ is a
**positive norm along the CF path** (convergents + semi-convergents) to $\sqrt{D}$.

- Verified D = 2..30. Initial apparent mismatches (D = 13, 17, 19, ...) were search range
  artifacts — all confirmed when tested at actual CF path points.
- Includes D = 13: $(649, 180)$ with 180+ digit ballot number matching exactly.

**Consequence:** The ballot formula does NOT uniquely characterize Pell solutions ($N=1$).
It holds for all CF convergent/semi-convergent norms. The CF path is privileged.

**Status:** 🔬 NUMERICALLY VERIFIED (D = 2..30, all CF path points)

### Literature search (negative result)

Extensive search (April 2026) found **no prior work** combining lattice paths with a
hyperbolic boundary constraint and ballot/Catalan counting. The key references on
lattice path enumeration are:

- Krattenthaler, *Lattice Path Enumeration* (handbook chapter): the reflection principle
  is fundamentally a **linear** tool. For non-linear boundaries, "one cannot usually expect
  to find a useful exact formula." Our result contradicts this expectation.

- Dvoretzky--Motzkin cycle lemma and its generalization (Eu, Liu, Yeh, *SIAM J. Discrete Math.*
  2011): gives ballot formula $\beta/(m+n) \cdot \binom{m+n}{m}$ for paths under a LINE
  $y = \alpha x + \beta$. Strictly linear.

- Flajolet's Fundamental Lemma connects CF expansions to lattice path generating functions,
  but does not treat hyperbolic constraints.

- CF convergents as closest lattice points to $y = \sqrt{D}\,x$ is classical, but the
  connection to constrained path counting is not in the literature.

**Assessment:** The Pell-Ballot identity appears to be **new**. A hyperbolic boundary giving
the same ballot formula as a linear boundary is unexpected from the existing theory. The
mechanism likely involves the CF structure (convergents minimize $|p^2 - Dq^2|$), possibly
via a "hidden linearization" — the hyperbola $x^2 - Dy^2 = 1$ asymptotes to $y = x/\sqrt{D}$,
and the CF path tracks this asymptote closely enough for the ballot counting to work.

### What this does NOT do

This does **not** help solve the Pell equation: you need $(x_1, y_1)$ to state the result.
It characterizes the GEOMETRY of the CF path, not a computational shortcut.

### Open questions

1. **Proof:** Why does a hyperbolic boundary yield the linear ballot formula? Is there a
   cycle lemma variant that works for the Pell hyperbola, or a coordinate change that
   linearizes the problem?
2. **Negative Pell:** Modified ballot for $x^2 - Dy^2 = -1$?
3. **Why the CF path?** CF convergents minimize $|p^2 - Dq^2|$ and are closest lattice
   points to $y = \sqrt{D}\,x$. Does the ballot identity follow from this best-approximation
   property?

### Scripts

- `scripts/pell_ballot_dp.wl` — DP verification for all D up to 50
- `scripts/pell_ballot_enum.wl` — Brute-force enumeration with full path listing (small cases)
