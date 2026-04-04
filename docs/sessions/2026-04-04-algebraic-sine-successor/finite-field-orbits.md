# Finite Field Orbits and Algebraic Circles

**Date:** 2026-04-04
**Status:** 🔬 NUMERICALLY VERIFIED, partially explored

## Orbits over F_p

The modular orbit `SuccessorOrbitMod[o, k, p]` traces points in $\mathbb{F}_p^2$.
For rational $o$: integer pairs via polynomial ring arithmetic.
For symbolic $o$: polynomials in $o$ over $\mathbb{F}_p$ via `Factor[..., Modulus -> p]`.

### All Periods Exist

For every integer $T \geq 2$, there exist $o$ and prime $p$ giving period exactly $T$.

**Proof sketch:** By Dirichlet's theorem, there exists a prime $p$ with $T \mid p \pm 1$.
The multiplicative group $\mathbb{F}_p^*$ (or $\mathbb{F}_{p^2}^*$) then contains
an element of order $T$, which can be realized as the eigenvalue of $N \bmod p$
for suitable $o$.

Period 1 is the only exception — it requires $o \equiv 0 \pmod{p}$ (trivial).

Examples:

| Period | $o$ | $p$ |
|--------|-----|-----|
| 2 | 6 | 29 |
| 3 | 48 | 67 |
| 17 | 51 | 101 |
| 47 | 8 | 283 |
| 59 | 526 | 709 |

### Diagonal Symmetry = Time Reversal

The orbit of `SuccessorOrbitMod[51, Range@100, 101]` has mirror symmetry
along the diagonal $x = y$. This is **time reversal**:

If $(x_k, y_k) = (f_{k+1}, f_k)$ is on the orbit, then $(y_k, x_k) = (f_k, f_{k+1})$
corresponds to step $-k + 2s$ for some fixed $s$ (the symmetry axis).

The axis passes through the point where $f_{k+1} = f_k$ (zero "velocity").

## The Algebraic Circle (Special Case)

### When det(N) ≡ 1 (mod p)

The quadratic form $Q(x, y) = x^2 - \text{tr}(N) \cdot xy + \det(N) \cdot y^2$
is **constant on the orbit** if and only if $\det(N) \equiv 1 \pmod{p}$.

Since $\det(N) = (\lambda a)^2$, this requires $(\lambda a)^2 \equiv 1 \pmod{p}$,
i.e., $\lambda a \equiv \pm 1 \pmod{p}$.

When this holds, the orbit lies on a **conic** (algebraic circle) in $\mathbb{F}_p^2$:

$$x^2 - \alpha \, xy + y^2 \equiv c \pmod{p}$$

where $\alpha = \text{tr}(N) \bmod p$ and $c$ is determined by the initial point.

**Example:** $o = 51$, $p = 101$: $\det(N) = 10404 \equiv 1 \pmod{101}$,
$\alpha = 52$, $c = 51$. All 17 orbit points lie on $x^2 - 52xy + y^2 \equiv 51$.

### When det(N) ≢ 1 (mod p)

The form **scales** by $\det(N) \bmod p$ at each step:

$$Q(N \cdot v) \equiv \det(N) \cdot Q(v) \pmod{p}$$

So $Q$ takes values $Q_0, Q_0 \cdot d, Q_0 \cdot d^2, \ldots$ where $d = \det(N) \bmod p$.
The orbit lies on a **family of conics** (a spiral in the discrete sense),
not a single one.

To get a true circle for any $(o, p)$: work with $M = N / (\lambda a)$ instead,
which has $\det(M) = 1$. This requires $(\lambda a)^{-1} \bmod p$ to exist
(i.e., $p \nmid \lambda a$).

## Connections (Unexplored)

### Number Theoretic Transform (NTT)
Classical NTT uses roots of unity $\omega^k \in \mathbb{F}_p$, requiring
the period to divide $p - 1$. Our orbit gives **2D roots of unity** (pairs
on the algebraic circle) with periods dividing $p^2 - 1$ — more flexibility.
This is effectively NTT over $\mathbb{F}_{p^2}$ without explicit field extension.

### Lucas-Based Cryptography (LUC)
The discrete log problem on the orbit — given $(x, y)$, find $k$ such that
$(x, y) = N^k \cdot w_0 \bmod p$ — is equivalent to discrete log in
$\mathbb{F}_{p^2}^*$. This is the basis of the LUC cryptosystem.

### CircFunctions over F_p
The $\gamma[\rho[n, k]]$ from CircFunctions, reduced mod $p$, should give
the same orbit structure. The algebraic circle is the finite-field version
of the unit circle that CircFunctions parametrizes.

### Error-Correcting Codes
BCH and Reed-Solomon codes evaluate polynomials at roots of unity.
The orbit points are alternative evaluation points with tunable period.

## Open Questions

1. For which $(o, p)$ does $\det(N) \equiv 1 \pmod{p}$, giving a true circle?
   (Answer: when $p \mid (\lambda a)^2 - 1$, i.e., $p \mid (\lambda a - 1)(\lambda a + 1)$.)

2. Can the spiral case ($\det \not\equiv 1$) be useful, e.g., as a discrete
   logarithmic spiral with number-theoretic properties?

3. What is the distribution of orbit points on the conic? Is it uniform?
   (Expected: yes, by Weyl equidistribution over finite fields.)

4. Connection to the period spectrum: does the algebraic cost $\varphi(q)/2$
   of period $2q$ (from `period-spectrum.md`) relate to the structure of
   the orbit over $\mathbb{F}_p$?
