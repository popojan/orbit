# The Degenerate Case: Naturals as the Additive Group

**Date:** 2026-04-04
**Status:** ✅ PROVEN (linear algebra)

## The Observation

The successor recurrence with $o = 1$, $\lambda = 2$ produces the natural numbers:

$$1, 2, 3, 4, 5, \ldots$$

It "implements +1" without explicitly adding anything. The recurrence is:

$$f_{k+1} = 2f_k - f_{k-1}$$

which is equivalent to $f_{k+1} - f_k = f_k - f_{k-1}$ — **constant differences**.
This is an arithmetic progression, and the naturals are the simplest instance ($f_0 = 1$, $d = 1$).

## Why $\alpha = 2$ Is Special

The transfer matrix for $\alpha = 2$:

$$M = \begin{pmatrix} 2 & -1 \\ 1 & 0 \end{pmatrix} = I + J, \qquad J = \begin{pmatrix} 1 & -1 \\ 1 & -1 \end{pmatrix}$$

The key fact: **$J$ is nilpotent**, $J^2 = 0$. Therefore:

$$M^k = (I + J)^k = I + kJ = \begin{pmatrix} 1+k & -k \\ k & 1-k \end{pmatrix}$$

No exponential growth, no rotation — pure **translation**. The "+1" at each step
is literally the nilpotent matrix $J$. Each application of $M$ adds $J$ to the
accumulated state.

Verification:

$$M^k \begin{pmatrix} 2 \\ 1 \end{pmatrix} = \begin{pmatrix} k+2 \\ k+1 \end{pmatrix}$$

so $f_k = k + 1$, the naturals.

## Algebraic Identification

The set $\{I + tJ : t \in R\}$ is the **unipotent subgroup** of $\mathrm{GL}_2(R)$.
It is a group under matrix multiplication:

$$(I + t_1 J)(I + t_2 J) = I + (t_1 + t_2)J$$

because $J^2 = 0$. The group law is **addition of the parameter $t$**.

This is the **additive group scheme** $\mathbb{G}_a$:

$$U = \{I + tJ : t \in R\} \;\cong\; (R, +)$$

The isomorphism $t \mapsto I + tJ$ converts matrix multiplication into addition.
Counting the naturals is iterating this map: $I \to I + J \to I + 2J \to \cdots$

## The Triptych: Three Algebraic Groups

The successor recurrence parametrizes a one-parameter family interpolating between
three fundamental algebraic groups. The Chebyshev parameter $c = \alpha/2$
determines the regime:

| Regime | $c$ | Eigenvalues of $M$ | Group over $\mathbb{F}_p$ | Group scheme | Order |
|---|---|---|---|---|---|
| Oscillatory | $\|c\| < 1$ | $e^{\pm i\theta}$ on unit circle | $S^1(\mathbb{F}_p)$ (algebraic circle) | Non-split torus | $p + 1$ |
| **Degenerate** | $c = 1$ | $1, 1$ (Jordan block) | $(\mathbb{F}_p, +)$ | $\mathbb{G}_a$ (additive) | $p$ |
| Hyperbolic | $c > 1$ | $\lambda, \lambda^{-1}$ real | $\mathbb{F}_p^*$ (algebraic hyperbola) | $\mathbb{G}_m$ (multiplicative) | $p - 1$ |

The orders over $\mathbb{F}_p$ are **three consecutive integers**: $p+1$, $p$, $p-1$.
This is the standard trichotomy of rank-1 algebraic groups over finite fields.

### Geometric picture

- **Oscillatory:** the orbit traces a circle (rotation by angle $\theta$ per step)
- **Degenerate:** the "circle" has infinite radius; rotation becomes translation
- **Hyperbolic:** the orbit traces a hyperbola (hyperbolic rotation / squeeze)

The naturals sit at the **exact transition point** — the curvature of the circle
goes to zero, and what was periodic becomes linear.

In differential geometry, this limiting process is known as **Inönü–Wigner contraction**:
$\mathrm{SO}(2) \to (\mathbb{R}, +)$ as the radius $\to \infty$.

## Generalization: "Addition" in Any Ring

The recurrence $f_{k+1} = 2f_k - f_{k-1}$ works in any ring or module $R$.
It always gives an arithmetic progression $f_k = f_0 + k \cdot d$,
where $d = f_1 - f_0$. The structure $t \mapsto I + tJ$ embeds $(R, +)$
into $\mathrm{GL}_2(R)$ as a unipotent subgroup.

| Domain $R$ | Step $d$ | Period | What "counting" means |
|---|---|---|---|
| $\mathbb{Z}$ | $+1$ | $\infty$ | Natural numbers |
| $\mathbb{F}_p$ | $+1 \bmod p$ | $p$ | Naturals mod $p$ |
| $\mathbb{Z}/n\mathbb{Z}$ | $+d \bmod n$ | $n / \gcd(d, n)$ | Cyclic counting |
| $\mathrm{Mat}_n(R)$ | $+D$ | depends on $R$ | Matrix arithmetic progression |
| $\mathbb{H}$ (quaternions) | $+q$ | $\infty$ | Quaternionic counting |
| $R[\varepsilon]/(\varepsilon^2)$ | $+d$ | $\infty$ | Counting with "velocity" |

In every case the group is the same: the additive group $(R, +)$, realized as
the unipotent subgroup of $\mathrm{GL}_2(R)$.

## Connection to Other Regimes

The degenerate case is not isolated — it connects to both neighbors:

**From oscillatory:** As $o \to 1$ (with $\lambda = 2$), the Chebyshev parameter
$c = (5o - 1)/(4o) \to 1$. The oscillation period $T = 2\pi / \arccos(c) \to \infty$.
The sine wave stretches until it becomes a straight line. Trigonometric functions
degenerate into linear functions:

$$\lim_{c \to 1^{-}} \frac{\sin(k \arccos c)}{\sin(\arccos c)} = k = U_{k-1}(1)$$

**From hyperbolic:** As $o \to 1$ from above (larger seeds), the exponential growth
rate $\lambda = c + \sqrt{c^2 - 1} \to 1$. The hyperbola flattens into a line.

**At the boundary:** Both limits meet at $c = 1$: the naturals. This is
the **flat geometry** between elliptic (oscillatory) and hyperbolic regimes —
the Euclidean case in the Cayley–Klein classification.

| Geometry | Curvature | Group | Recurrence regime |
|---|---|---|---|
| Elliptic (spherical) | $\kappa > 0$ | $\mathrm{SO}(2)$ | Oscillatory |
| **Euclidean (flat)** | $\kappa = 0$ | $(\mathbb{R}, +)$ | **Degenerate** |
| Hyperbolic | $\kappa < 0$ | $\mathrm{SO}(1,1)$ | Hyperbolic |

## Why This Matters

The natural numbers are often taken as primitive — the starting point from which
everything else is built. Here they appear instead as a **degenerate limit**:
the point where a continuous family of algebraic structures (parametrized by the
seed $o$) transitions between two qualitatively different regimes.

"Counting" ($+1$) is not a separate operation bolted onto the structure.
It **emerges** from the same recurrence that produces sine waves and exponentials,
at the exact parameter value where oscillation and growth both vanish.

The nilpotent matrix $J$ — with $J^2 = 0$ — is the algebraic residue of this collapse.
It is "almost zero" (it squares to zero) but not quite (it acts nontrivially once).
That single nontrivial action is the successor function.
