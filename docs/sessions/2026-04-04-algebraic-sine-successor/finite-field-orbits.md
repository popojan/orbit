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

### Algebraic Circle Condition

> **The orbit lies on an algebraic circle (conic) in $\mathbb{F}_p^2$
> if and only if $(\lambda a)^2 \equiv 1 \pmod{p}$, i.e.,
> $p \mid (\lambda a - 1)(\lambda a + 1)$.**

The quadratic form $Q(x, y) = x^2 - \text{tr}(N) \cdot xy + \det(N) \cdot y^2$
is **constant on the orbit** if and only if $\det(N) \equiv 1 \pmod{p}$.

Since $\det(N) = (\lambda a)^2$, the condition reduces to $\lambda a \equiv \pm 1 \pmod{p}$.

For $\lambda = 2$, $o = a/b$: the circle condition is $p \mid (2a - 1)(2a + 1) = 4a^2 - 1$.

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

### Normalizing the Spiral to a Circle

When $\det(N) \not\equiv 1$, the orbit spirals. But the spiral can be
**normalized** to a circle by dividing out the known scale factor at each step.

The matrix $M = N / (\lambda a)$ has $\det(M) = 1$, and its orbit preserves
$Q(x,y) = x^2 - \alpha_M xy + y^2$ exactly. The normalized orbit is:

$$\tilde{v}_k = (\lambda a)^{-k} \cdot N^k \cdot w_0 \pmod{p}$$

This requires $(\lambda a)^{-1} \bmod p$ to exist, i.e., $p \nmid \lambda a$.

> **Normalization condition:** $\gcd(\lambda a, p) = 1$.
> This excludes only the finitely many primes dividing $\lambda a$.
> For all other primes, the spiral can always be collapsed to a circle.

**Concretely** for $o = a/b$, $\lambda = 2$: let $s = (2a)^{-1} \bmod p$. Then:

$$\tilde{v}_k = s^k \cdot (N^k \cdot w_0) \pmod{p}$$

The normalized vector $\tilde{v}_k$ traces a circle: $Q(\tilde{v}_k) \equiv Q(w_0)$ for all $k$.

**What the normalization means geometrically:** $N$ acts as rotation + scaling.
The scaling factor $\lambda a$ per step is known a priori. Dividing it out
at each step removes the scaling, leaving pure rotation — a circle.
This is the finite-field analogue of dividing $e^{(n+i\theta)k}$ by $e^{nk}$
to get $e^{i\theta k}$ — stripping the radial growth to expose the angle.

**When is normalization unnecessary?** When $(\lambda a)^2 \equiv 1 \pmod{p}$,
i.e., $s^2 \equiv 1$, so $s = \pm 1$ and the scaling is trivial (sign at most).
That is exactly the algebraic circle condition above.

## Group-Theoretic Identification

The orbit group of `SuccessorOrbitMod` is a cyclic subgroup of a **Cartan subgroup**
of $\mathrm{GL}_2(\mathbb{F}_p)$. The isomorphism class depends on the splitting
behavior of the characteristic polynomial $r^2 - \alpha r + \delta$ modulo $p$,
where $\alpha = \mathrm{tr}(N) \bmod p$ and $\delta = \det(N) \bmod p$.

### The quotient ring

The `polyPowMod` implementation computes in the ring

$$R = \mathbb{F}_p[r] \big/ (r^2 - \alpha\, r + \delta)$$

The orbit is $\{r^k : k = 0, 1, \ldots\}$ inside $R^*$ (the multiplicative group of $R$).
The discriminant $\Delta = \alpha^2 - 4\delta \bmod p$ determines $R$:

| $\Delta \bmod p$ | Ring $R$ | $R^*$ |
|---|---|---|
| **NR** (non-residue) | $\mathbb{F}_{p^2}$ | $\mathbb{Z}/(p^2-1)$ |
| **QR** (quadratic residue) | $\mathbb{F}_p \times \mathbb{F}_p$ | $\mathbb{Z}/(p{-}1) \times \mathbb{Z}/(p{-}1)$ |
| **0** (ramified) | $\mathbb{F}_p[\varepsilon]/(\varepsilon^2)$ | $\mathbb{F}_p^* \ltimes \mathbb{F}_p$ |

### Without normalization (raw orbit)

The orbit group $\langle r \rangle \leq R^*$ is cyclic. Since $\det(N) = (\lambda a)^2$,
the element $r$ has **norm** $\mathrm{Nm}(r) = \delta = (\lambda a)^2 \bmod p$,
which is generically $\neq 1$. The orbit spirals through a family of conics
(see "When det(N) ≢ 1" above).

In the language of algebraic groups:

| Case | Standard name | Structure |
|---|---|---|
| Inert ($\Delta$ NR) | **Non-split Cartan subgroup** of $\mathrm{GL}_2(\mathbb{F}_p)$ | $\cong \mathbb{F}_{p^2}^*$, also called a **Singer cycle** subgroup |
| Split ($\Delta$ QR) | **Split Cartan subgroup** of $\mathrm{GL}_2(\mathbb{F}_p)$ | $\cong \mathbb{F}_p^* \times \mathbb{F}_p^*$ (diagonal matrices after conjugation) |

The orbit period divides:
- Inert: $p^2 - 1$
- Split: $\mathrm{lcm}(\mathrm{ord}(\lambda_1), \mathrm{ord}(\lambda_2))$ where $\lambda_i \in \mathbb{F}_p$ are the eigenvalues

### With normalization (unit-norm orbit)

Dividing out the known scale factor $(\lambda a)^{-1} \bmod p$ at each step
(see "Normalizing the Spiral to a Circle" above) gives a unit-norm element
$\tilde{r} = r / (\lambda a)$ with $\mathrm{Nm}(\tilde{r}) = 1$. The normalized
orbit $\langle \tilde{r} \rangle$ lives in the **norm-1 subgroup** of $R^*$:

$$\ker\!\big(\mathrm{Nm}: R^* \to \mathbb{F}_p^*\big)$$

| Case | Norm-1 subgroup | Standard name | Order |
|---|---|---|---|
| Inert | $\ker(\mathrm{Nm}: \mathbb{F}_{p^2}^* \to \mathbb{F}_p^*)$ | **Algebraic circle** $S^1(\mathbb{F}_p)$ | $p + 1$ |
| Split | $\{(\lambda, \lambda^{-1}) : \lambda \in \mathbb{F}_p^*\}$ | **Algebraic hyperbola** | $p - 1$ |

These sit inside $\mathrm{SL}_2(\mathbb{F}_p)$ and are exactly the
**Cartan subgroups of $\mathrm{SL}_2(\mathbb{F}_p)$**:

- **Non-split Cartan** of $\mathrm{SL}_2(\mathbb{F}_p)$: cyclic of order $p + 1$
- **Split Cartan** of $\mathrm{SL}_2(\mathbb{F}_p)$: cyclic of order $p - 1$

The algebraic circle condition $(\lambda a)^2 \equiv 1 \pmod{p}$ from the previous
section is precisely the condition that normalization is trivial — the raw orbit
already has unit norm and lives on a single conic.

### Summary

$$\langle N \bmod p \rangle \;\leq\; \text{Cartan subgroup of } \mathrm{GL}_2(\mathbb{F}_p)
\;\xrightarrow{\;\det = 1\;}\; \text{Cartan subgroup of } \mathrm{SL}_2(\mathbb{F}_p)$$

The `polyPowMod` implementation computes in $\mathbb{F}_{p^2}$ (or $\mathbb{F}_p \times \mathbb{F}_p$)
without constructing the field extension explicitly. This is the same algebraic structure
underlying the **LUC cryptosystem** and **Lucas primality tests**.

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
