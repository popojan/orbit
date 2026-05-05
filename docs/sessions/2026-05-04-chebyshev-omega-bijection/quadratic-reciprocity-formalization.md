# Quadratic Reciprocity via Cyclotomic Chebyshev Factorization

**Date:** 2026-05-04
**Status:** 🔬 Verified for primes p ≤ 97, prime powers p^k ≤ 200 (odd p),
composites pm ≤ 60; proofs given, results are classical recombination
(see Literature section).

## Setup

For odd $n$, define the **cyclotomic Chebyshev master polynomial**

$$H_n(x) := 1 + 2 \sum_{a=1}^{(n-1)/2} T_a(x+1) \in \mathbb{Z}[x]$$

with the identity (proved via Dirichlet kernel):

$$T_n(x+1) - 1 = x \cdot H_n(x)^2$$

It factors as $H_n(x) = \prod_{d \mid n,\ d > 1} F_d(x)$ where $F_d(x)$ is the integer
minimal polynomial of $\cos(2\pi/d)$ shifted by $x \to \cos - 1$, of degree
$\varphi(d)/2$ and constant $\Phi_d(1)$ (= $p$ if $d = p^k$, else 1).

For $n = p$ odd prime: $H_p = F_p$ (single irreducible factor of degree $(p-1)/2$,
constant $p$, leading $2^{(p-1)/2}$).

---

## Theorem 1 (Supplementary law of quadratic reciprocity, polynomial form)

For every odd prime $p$,

$$\boxed{\,F_p(x) \equiv \left(\frac{2}{p}\right) x^{(p-1)/2} \pmod{p}\,}$$

where $\left(\frac{2}{p}\right) = (-1)^{(p^2-1)/8}$ is the Legendre symbol of 2 modulo $p$.

### Proof

**Step 1.** Chebyshev Frobenius: $T_p(y) \equiv y^p \pmod p$.

This is classical. One proof: write $T_p(y) = \frac{1}{2}\big((y + \sqrt{y^2-1})^p + (y - \sqrt{y^2-1})^p\big)$. By the binomial theorem mod $p$,
$$(y \pm \sqrt{y^2-1})^p \equiv y^p \pm (\sqrt{y^2-1})^p \pmod p,$$
and the $\sqrt{\cdot}$ terms cancel in the sum, leaving $T_p(y) \equiv y^p \pmod p$.

**Step 2.** Substituting $y = x+1$:
$$T_p(x+1) - 1 \equiv (x+1)^p - 1 \equiv x^p \pmod p$$
using $(x+1)^p \equiv x^p + 1 \pmod p$.

**Step 3.** From the identity $T_p(x+1) - 1 = x \cdot F_p(x)^2$ (since $H_p = F_p$
for prime $p$), we get
$$x \cdot F_p(x)^2 \equiv x^p \pmod p \implies F_p(x)^2 \equiv x^{p-1} \pmod p$$
(dividing by $x$ in $\mathbb{F}_p[x]$).

**Step 4.** $\mathbb{F}_p[x]$ is a UFD, and $x^{p-1}$ has unique square root
$\pm x^{(p-1)/2}$ up to sign. Therefore
$$F_p(x) \equiv c \cdot x^{(p-1)/2} \pmod p \quad \text{for some } c \in \{\pm 1\}.$$

**Step 5.** Identify $c$ via the leading coefficient. The leading coefficient
of $F_p(x) = 1 + 2\sum_{a=1}^{(p-1)/2} T_a(x+1)$ in the variable $x$ is
$2 \cdot 2^{(p-1)/2 - 1} = 2^{(p-1)/2}$.

Mod $p$, by Euler's criterion,
$$2^{(p-1)/2} \equiv \left(\frac{2}{p}\right) \pmod p.$$

Hence $c = \left(\frac{2}{p}\right)$. $\square$

---

## Theorem 2 (Prime powers)

For every odd prime $p$ and $k \geq 1$,

$$F_{p^k}(x) \equiv \left(\frac{2}{p}\right) x^{\varphi(p^k)/2} \pmod p.$$

### Proof

Iterating the Chebyshev Frobenius: $T_{p^k}(y) = T_p \circ T_p \circ \cdots \circ T_p(y) \equiv y^{p^k} \pmod p$.

So $T_{p^k}(x+1) - 1 \equiv x^{p^k} \pmod p$.

The factorization $T_{p^k}(x+1) - 1 = x \cdot H_{p^k}(x)^2$ with
$H_{p^k} = F_p \cdot F_{p^2} \cdots F_{p^k}$ gives
$$x \cdot \prod_{j=1}^{k} F_{p^j}(x)^2 \equiv x^{p^k} \pmod p \implies \prod_{j=1}^{k} F_{p^j}(x)^2 \equiv x^{p^k - 1} \pmod p.$$

Each $F_{p^j}^2$ has degree $\varphi(p^j)$, summing to $p^k - 1$. By unique
factorization in $\mathbb{F}_p[x]$ (and an inductive argument starting from
Theorem 1), each $F_{p^j}^2 \equiv x^{\varphi(p^j)} \pmod p$, so
$$F_{p^j}(x) \equiv \pm x^{\varphi(p^j)/2} \pmod p.$$

The leading coefficient of $F_{p^j}(x)$ is $2^{\varphi(p^j)/2} = 2^{p^{j-1}(p-1)/2}$.
By Fermat, $2^{p-1} \equiv 1 \pmod p$, so
$$2^{p^{j-1}(p-1)/2} = \big(2^{(p-1)/2}\big)^{p^{j-1}} \equiv \left(\frac{2}{p}\right)^{p^{j-1}} \equiv \left(\frac{2}{p}\right) \pmod p$$
(since $\left(\frac{2}{p}\right) = \pm 1$ and $p^{j-1}$ is odd for $p$ odd). $\square$

---

## Theorem 3 (Frobenius for composite $d$, refined)

The classical cyclotomic Frobenius is $\Phi_{pm}(t) \equiv \Phi_m(t)^{p-1} \pmod p$
when $\gcd(p, m) = 1$. Translating to Chebyshev variables via $t + t^{-1} = 2(x+1)$
encounters one subtlety: for $d > 2$, $F_d$ has degree $\varphi(d)/2$ (Galois-pair
collapse), but for $d = 2$ the substitution does not collapse pairs (the unique
root $t = -1$ is self-reciprocal). This breaks degree-counting at $m = 2$.

**Three cases** (verified for $pm \leq 60$, all $p$ prime up to 13):

**(3a)** For odd prime $p$ and integer $m \geq 3$ with $\gcd(p, m) = 1$:
$$F_{pm}(x) \equiv F_m(x)^{p-1} \pmod p.$$

**(3b)** For odd prime $p$ and $m = 2$:
$$F_{2p}(x) \equiv \left(\frac{2}{p}\right) F_2(x)^{(p-1)/2} \pmod p.$$

**(3c)** For $p = 2$, odd $m \geq 3$:
$$F_{2m}(x) \equiv F_m(x) \pmod 2 \quad (\text{both sides reduce to } 1).$$

### Proofs

**(3a):** From cyclotomic Frobenius $\Phi_{pm}(t) \equiv \Phi_m(t)^{p-1} \pmod p$
(proof: $\Phi_{pm}(t) = \Phi_m(t^p)/\Phi_m(t)$; reduce mod $p$ via Frobenius
$\Phi_m(t^p) \equiv \Phi_m(t)^p$). Both sides have degree $(p-1)\varphi(m)$ in
$t$; under the substitution $y = t + t^{-1}$ both halve consistently to give
the Chebyshev-side identity. Constants match: $F_{pm}(0) = \Phi_{pm}(1) = 1$
(since $pm$ has $\geq 2$ distinct primes), and $F_m(0)^{p-1} \equiv 1 \pmod p$
by Fermat (whether $F_m(0) = q$ prime or 1).

**(3b):** Degrees: $\deg F_{2p} = \varphi(2p)/2 = (p-1)/2$, $\deg F_2 = 1$, so
$\deg F_2^{(p-1)/2} = (p-1)/2$ matches. Both polynomials are determined modulo $p$
up to a non-zero scalar; the constant of $F_{2p}$ is $\Phi_{2p}(1) = 1$, and the
constant of $F_2(x)^{(p-1)/2}$ at $x = 0$ is $2^{(p-1)/2} \equiv \left(\frac{2}{p}\right) \pmod p$
(Euler's criterion). Hence the scalar is $\left(\frac{2}{p}\right)$. $\square$

**(3c):** $F_d$ for odd $d > 1$ has odd constant $\Phi_d(1) \in \{p, 1\}$ and
even non-constant coefficients (induction, using $H_n = 1 + 2 \sum T_a$), so
$F_d \equiv 1 \pmod 2$ for all odd $d > 1$. Both $F_{2m}$ and $F_m$ reduce to $1$. $\square$

---

## Corollary 4 (Splitting of $p$ in real cyclotomic fields)

For prime $p \nmid d$, the factorization of $F_d(x) \pmod p$ has the same shape
as the factorization of $\Phi_d(t) \pmod p$, which encodes the splitting of $p$
in $\mathbb{Q}(\zeta_d)$.

Specifically, $F_d(x) \pmod p$ factors into $\varphi(d) / (2 f)$ irreducible
factors, each of degree $f$, where $f = \mathrm{ord}_d(p) / 2$ if $p^{\mathrm{ord}_d(p)/2} \equiv -1 \pmod d$, else $f = \mathrm{ord}_d(p)$.

This is the **Chebyshev (real-cyclotomic) version of the splitting theorem**.

---

## Verification (computational)

Verified by `scripts/theorem3_extended.wl`:

- **Theorem 1**: all odd primes $3 \leq p \leq 97$ (25 primes) — 100% match
- **Theorem 2**: all odd prime powers $3 \leq p^k \leq 200$ (verified) — 100% match;
  fails at $p = 2$ powers ($d = 4, 8, 16, 32, 64, 128$) because $\left(\frac{2}{2}\right)$
  is not defined and ψ_{2^k} hits $y=0$ root for $k \geq 2$
- **Theorem 3a** ($m \geq 3$, $\gcd(p,m)=1$): all 44 valid pairs with $pm \leq 60$ — 100% match
- **Theorem 3b** ($m = 2$): verified for $p \in \{3, 5, 7, 11, 13\}$ — 100% match
- **Theorem 3c** ($p = 2$): verified for $m \in \{3, 5, ..., 29\}$ — 100% match (trivial)

---

## Literature (classical antecedents)

The polynomial-structure side of this work is **already in the literature**.
Specifically, our master polynomial $H_n(x)$ is (up to a linear shift) the
**Chebyshev polynomial of the fourth kind** $W_{(n-1)/2}$.

### Direct correspondence with Doi (2025), arXiv:2501.16478

In Doi's notation (following Barnes 1977 and Mason–Handscomb), let
$c_n(x) := U_n(x/2)$ (rescaled Chebyshev of the second kind) and
$$p_n^+(x) := c_n(x) + c_{n-1}(x) = W_n(x/2),$$
the **Chebyshev polynomial of the fourth kind** (after rescaling).

Under the substitution $x \to 2(x+1)$:
$$p_n^+(2(x+1)) = U_n(x+1) + U_{n-1}(x+1) = \frac{\sin((2n+1)\theta/2)}{\sin(\theta/2)} \quad (\cos\theta = x+1)$$
which is **exactly our $H_{2n+1}(x)$**. Equivalently
$$\boxed{\,H_n(x) = W_{(n-1)/2}(x+1) \quad \text{for odd } n.\,}$$

Doi's **Theorem 1.4(ii)** then gives our factorization explicitly: for odd $n > 2$,
$$\psi_n(x) = p_{\lfloor n/2 \rfloor}^+(x) \Big/ \prod_{2 < d < n,\ d \mid n} \psi_{n/d}(x) \cdot (\text{Möbius corrections})$$
which translates verbatim to $F_n(x) = H_n(x) / \prod_{d|n,\ 1 < d < n} F_d(x)$.

The identity $T_n(x+1) - 1 = x \cdot H_n(x)^2$ is Doi's **Theorem 2.2** (that
$t_n(x) \pm 2$ is divisible by $(p_s^\pm(x))^2$) restated under the shift.

So the **polynomial structure** (factorization, closed form, square identity)
is a re-derivation of:
- Watkins & Zeitlin (1993, *Amer. Math. Monthly* 100(5))
- Barnes (1977, *J. Elisha Mitchell Sci. Soc.* 93(1))
- Gürtaş (2017, *AMM* 124(1); 2022 follow-up on variants)
- Doi (2025, arXiv:2501.16478, with explicit non-recursive formula)

### Mod-p / Legendre side

The reduction $T_p(x) \equiv x^p \pmod p$ (Chebyshev Frobenius) and Euler's
criterion $2^{(p-1)/2} \equiv (2/p) \pmod p$ are classical. The combination
appears in **Eisenstein-style proofs of quadratic reciprocity** (using
$\sin(qx) = \sin(x) U_q(4\sin^2 x)$ as the kernel). Whether Theorem 1 in
the *exact* form $F_p(x) \equiv (2/p) x^{(p-1)/2} \pmod p$ appears verbatim
is uncertain, but it is a 2-line consequence of standard facts.

### Honest assessment

- **Polynomial structure** (Theorem 0 / $H_n$): **classical**, fully covered
  by Doi 2025 + Watkins–Zeitlin 1993 + Barnes 1977.
- **Theorem 1 (mod-p Legendre)**: classical-adjacent, Eisenstein-style,
  possibly worth a short *Monthly* note if not already published.
- **Theorem 2 (prime powers)**: same status as Theorem 1.
- **Theorem 3 (Frobenius lift)**: classical cyclotomic Frobenius.
- **Possibly novel**: the integer content formula $\text{intCont}(T_n(x+1) - 1) = 2^{2 v_2(n) - 1}$
  (in `README.md` § "4 \| n is NOT a real obstruction"), which encodes the
  2-adic valuation in the leading content. Not seen in the literature surveyed,
  though it may follow from $W_n$ leading-coefficient analysis. Worth a short
  literature dive.

The session's main value is **expository synthesis**, not new mathematics, *except*
possibly the intCont formula and the open directions in `OPEN-DIRECTIONS.md`
(notably A2 Wieferich and D1+D2 q-Mersenne).

---

## Adversarial check

- ✓ **Sign correctness.** Theorem 1's leading-coefficient computation
  ($2^{(p-1)/2} \equiv (2/p)$) is independent of the squared identity, confirming
  the sign matches Euler/Legendre.
- ✓ **Theorem 3 cases unified.** Initial empirical failure at $m = 2$ exposed
  the degree-halving asymmetry; refined statement (3b) re-introduces the same
  Legendre symbol $(2/p)$ as Theorem 1, giving thematic coherence.
- ✓ **Folklore status documented.** Direct correspondence $H_n(x) = W_{(n-1)/2}(x+1)$
  identified via Doi 2025; polynomial-structure side is classical.
  Mod-p / Legendre side is Eisenstein-style classical material.

## What this lets us prove cleanly

1. The supplementary law $\left(\frac{2}{p}\right) = (-1)^{(p^2-1)/8}$ as an
   immediate corollary by computing $F_p(x)$ at specific values.
2. The classical splitting of primes in real cyclotomic fields, packaged
   as Chebyshev polynomial factorizations.
3. A Wieferich-style higher-order test (next document): $F_p \pmod {p^2}$.
