# Open Directions — Chebyshev Ω-Bijection

**Date created:** 2026-05-04
**Maintainer:** Jan + AI (collaborative log)
**Purpose:** Track speculative and concrete follow-ups so we don't lose threads.

Each direction is annotated with **status** (open/explored/parked/closed),
**channel-match** (does the technique fit the question?), **investment**
(rough), **payoff** (rough), and **kill criterion** (when to stop).

---

## A. Quadratic reciprocity / Legendre / Euler channel

### A1. Polynomial form of supplementary law `(2/p)`
**Status:** ✅ formalized (see `quadratic-reciprocity-formalization.md`, Theorem 1)
**Investment:** done
**Payoff:** clean statement, possibly publishable as note in *Monthly* / *Math Mag*

### A2. Wieferich detection via F_p mod p²
**Status:** 🤔 hypothesis, untested
**Channel-match:** high — $F_p^2 \equiv x^{p-1} \pmod p$ exactly, so the "next-order"
correction $F_p(x)^2 - x^{p-1}$ should be divisible by $p$ but not $p^2$ generically;
for **Wieferich primes** $(2^{p-1} \equiv 1 \pmod{p^2})$ the divisibility may go higher.
**Investment:** medium (compute F_p mod p² for p up to 5000, look for outliers)
**Payoff:** if Wieferich is detected, novel polynomial primality criterion;
known Wieferichs are 1093, 3511 — easy to check
**Kill criterion:** if F_p mod p² is "boringly" the same monomial up to lifted sign,
no extra info; close.

### A3. Legendre symbols of other small primes via $F_p$
**Status:** ⏸️ open
**Setup:** Theorem 1 gave $(2/p)$ via leading coefficient $2^{(p-1)/2}$.
The other coefficients of $F_p$ involve different combinations of $T_a(x+1)$
which mod $p$ might encode $(3/p), (5/p), \ldots$.
**Channel-match:** medium — could work or could collapse to trivial
**Investment:** low (look at second coefficient, etc.)
**Kill criterion:** if all sub-leading coefficients are 0 mod $p$, no info.

### A4. Higher reciprocity (cubic, quartic) via $F_p$ in larger structure
**Status:** ⏸️ very speculative
**Setup:** quartic reciprocity uses $\mathbb{Z}[i]$; cubic uses $\mathbb{Z}[\zeta_3]$.
Chebyshev embeds in $\mathbb{Q}(\zeta_d)^+$ — real cyclotomic. Q: do specialized
Chebyshev polynomials over $\mathbb{Z}[\zeta_3]$ encode cubic reciprocity?
**Channel-match:** unclear — probably no, since Chebyshev is intrinsically real
**Kill criterion:** if cubic-Chebyshev analogs don't naturally exist or aren't real, drop.

---

## B. Frobenius / cyclotomic structure channel

### B1. Frobenius lift `F_{pm} ≡ F_m^{p-1} mod p`
**Status:** ✅ formalized (Theorem 3); narrow empirical verification
**Investment:** small follow-up needed — verify across more $d$ values (currently only $p=2$ cases)
**Payoff:** lemma in joint paper

### B2. Splitting of primes via Chebyshev factorization
**Status:** ✅ corollary noted (Corollary 4)
**Investment:** done modulo write-up
**Payoff:** Chebyshev = visual real-cyclotomic factorization

### B3. Frobenius for $p = 2$ (special case)
**Status:** ⏸️ unclear (script saw failure for $n = 6, 18, 30$)
**Setup:** $T_n(x+1) - 1 \equiv (T_{n/2}(x+1) - 1)^2 \pmod 2$ fails when
$\text{intCont}(T_n(x+1)-1)$ is even. Need Tate-style refinement.
**Channel-match:** medium
**Investment:** low
**Kill criterion:** if intCont obstruction is intrinsic, accept and document.

### B4. Iwasawa-style p-adic analysis of $F_p$
**Status:** ⏸️ very speculative
**Setup:** $F_p(x) \in \mathbb{Z}[x]$ has $p$-adic valuation structure of coefficients.
Connection to $p$-adic L-functions of cyclotomic fields?
**Channel-match:** low (Iwasawa is about Galois extensions, not real cyclotomic)
**Kill criterion:** drop unless A2 gives Wieferich connection.

---

## C. Coefficient closed-form channel

### C1. Closed form for $c_k(n)$
**Status:** ✅ done: $c_k(n) = \frac{2^k n}{2k+1}\binom{(n-1)/2 + k}{2k}$
**Investment:** done
**Payoff:** included in main result

### C2. OEIS lookup of $c_k(n)$ sequences
**Status:** ⏸️ open
**Setup:** for fixed $k$, $c_k(n)$ as $n$ ranges over odd integers might be a known sequence.
- $k=0$: $c_0 = n$ (trivial)
- $k=1$: $c_1(n) = n(n^2-1)/12$ — for n=3,5,7,9,...: 2, 10, 28, 60, 110, 182, ... (OEIS?)
- $k=2$: $c_2(n) = n(n^2-1)(n^2-9)/480$ — n=5,7,9,11,...: 4, 28, 108, 308, ...

**Channel-match:** trivial (cheap diagnostic)
**Investment:** 5 minutes
**Payoff:** unknown but cheap

### C3. Generating function for $H_n$
**Status:** ⏸️ open
**Setup:** $\sum_{n \text{ odd}} H_n(x) z^n / n$ might have closed form via Dirichlet kernel
$\sum_n \frac{\sin(n\theta/2)}{\sin(\theta/2)} z^n = ?$.
**Channel-match:** medium
**Investment:** 1 hour
**Payoff:** elegant if it works

### C4. Resultant `Res(F_p, F_q)` for primes p, q
**Status:** ⏸️ open
**Channel-match:** high (resultants of cyclotomic polys are well-studied)
**Investment:** low (Wolfram Resultant)
**Payoff:** possibly clean number-theoretic identity

---

## D. q-deformation channel

### D1. q-Chebyshev analog $F_p^{(q)}(x)$ with $F_p^{(1)} = F_p$
**Status:** ⏸️ very open, untouched
**Setup:** standard q-Chebyshev definitions exist (Foata–Han, Carlitz). Define
$$F_p^{(q)}(x) := \text{q-deformed } 1 + (q + q^{-1}) \sum T_a^{(q)}(x+1)$$
or similar. At $q = 1$: recover $F_p$. At $q = 2$: ?
**Channel-match:** unclear — needs careful definition
**Investment:** medium-high
**Payoff:** potentially big (Mersenne!)

### D2. q-Mersenne primality from $F_p^{(q)}$ at $q = 2$
**Status:** ⏸️ speculative
**Setup:** if $F_p^{(q)}(0) = \Phi_p(q)$ in some natural deformation, then at $q=2$
the constant becomes $\Phi_p(2)$. For prime $p$, $\Phi_p(2) = M_p$ Mersenne number.
$M_p$ prime ⟺ $p$ Mersenne exponent.
**Channel-match:** would need to *match* Mersenne primality to a Chebyshev identity
**Investment:** high (full q-deformation work)
**Payoff:** if it works, novel primality test or restatement of Lucas–Lehmer.
**Kill criterion:** if natural q-deformation gives $\Phi_d(q)$ but factorization
structure doesn't transfer, just constant equals Mersenne number — that's not a test, that's tautology.

### D3. q-Euler / q-Frobenius criteria
**Status:** ⏸️ untouched
**Setup:** if Theorem 1 q-deforms cleanly, we'd get a $q$-Legendre-like symbol
$(2/p)_q$. Connection to quantum number theory?
**Channel-match:** unclear
**Investment:** high
**Kill criterion:** drop unless D1 succeeds.

---

## E. Computational / algorithmic channel

### E1. $H_n$ as efficient cyclotomic polynomial computation
**Status:** ⏸️ open
**Setup:** $H_n(x) = 1 + 2 \sum T_a(x+1)$ has $(n-1)/2$ Chebyshev evals.
For applications needing many cyclotomic-Chebyshev polys at once, this might
be faster than iterating min-poly computation.
**Channel-match:** medium (specialized)
**Investment:** low
**Payoff:** practical Mathematica/SageMath function

### E2. Polynomial primality test from $H_n$ irreducibility
**Status:** ⏸️ trivial — $n$ prime ⟺ $H_n$ irreducible over $\mathbb{Q}$
**Channel-match:** high but circular
**Kill criterion:** factoring $H_n$ over $\mathbb{Q}$ via LLL is no faster than
direct primality, so this is just reformulation. Drop unless we find unexpected speedup.

### E3. Smoothness detection
**Status:** ⏸️ open
**Setup:** smooth $n$ have many small divisors → many small-degree $F_d$ factors of $H_n$.
Compute $H_n$ and look at degree distribution → detect smoothness without factoring $n$.
**Channel-match:** medium-low (needs factoring $H_n$ which is also expensive)
**Investment:** low
**Kill criterion:** if it's slower than trial division, drop.

---

## F. Algebraic geometry / arithmetic geometry channel

### F1. Discriminant of $H_n$ (or its factors)
**Status:** ⏸️ open
**Setup:** $\text{Disc}(F_p)$ for prime $p$ should be a clean function of $p$
(it's discriminant of a Galois extension of $\mathbb{Q}$). Known formula for
discriminant of $\mathbb{Q}(\zeta_p)^+$: $p^{(p-3)/2}$.
**Channel-match:** high (classical)
**Investment:** low
**Payoff:** likely re-derivation of known result

### F2. Galois group of splitting field of $H_n$
**Status:** ⏸️ tautological — same as $\Phi_n$, isomorphic to $(\mathbb{Z}/n\mathbb{Z})^* / \{\pm 1\}$
**Kill criterion:** done by classical theory. Drop.

### F3. $L$-functions associated with $H_n$
**Status:** ⏸️ very speculative
**Setup:** Dirichlet $L(s, \chi)$ for characters mod $n$ relate to $\Phi_n$.
Chebyshev side might give a "real" L-function.
**Channel-match:** low
**Kill criterion:** probably just relabels Dirichlet L-functions.

---

## G. Cryptographic channel

### G1. Chebyshev cryptosystem cryptanalysis
**Status:** ⏸️ open, low priority
**Setup:** Kocarev et al. proposed PKC based on $T_n(x) \bmod p$ semigroup property.
Our factorization structure of $T_n(x+1) - 1$ might leak key info.
**Channel-match:** medium (different polynomial used in PKC)
**Investment:** medium
**Payoff:** if successful, paper in IACR; if not, just shows PKC is robust
**Kill criterion:** if PKC's protocol uses $T_n(x) \bmod p$ (different polynomial), our results may not apply.

### G2. ZK proof of factorization via Chebyshev decomposition
**Status:** ⏸️ trivial
**Kill criterion:** any factorization gives a ZK-proof; nothing special. Drop.

---

## H. Connection to other Orbit-project threads

### H1. Egyptian / CF compression of $H_n(x)$ values
**Status:** ⏸️ open
**Setup:** CF expansion of $H_n(0) = n$ trivial. CF of $H_n(\alpha)$ for some
algebraic $\alpha$ might encode arithmetic of $n$.
**Channel-match:** unclear
**Investment:** medium
**Kill criterion:** if CFs are random-looking, drop.

### H2. Möbius involution × cyclotomic Chebyshev
**Status:** ⏸️ open
**Setup:** the silver involution $\gamma_s(x) = (1-x)/(1+x)$ acts on Chebyshev polys.
What does $H_n \circ \gamma_s$ look like?
**Channel-match:** high (project-internal)
**Investment:** low
**Payoff:** possibly clean involution identity

### H3. Pell / quadratic field connection
**Status:** ⏸️ open
**Setup:** $\cos(2\pi/d)$ for $d | n$ gives algebraic numbers in real quadratic
or higher fields. Does $H_n$ encode Pell-equation solutions?
**Channel-match:** medium
**Investment:** medium
**Kill criterion:** if it just rederives standard cyclotomic facts, drop.

---

## I. Generalization channel

### I1. Other orthogonal polynomial families
**Status:** ⏸️ open
**Setup:** does an analog of $H_n$ exist for Legendre $P_n$, Hermite $H_n$, Jacobi
$P_n^{(\alpha,\beta)}$? Specifically: is there an identity
$P_n(\text{shift}) - c = \text{(extraneous)} \cdot G_n^2$
with $G_n$ encoding factorization of $n$?
**Channel-match:** likely low (Chebyshev's link to roots of unity is special)
**Investment:** medium (test in Mathematica)
**Kill criterion:** if no such identity for any other family, drop with note.

### I2. Bernoulli / Euler polynomials
**Status:** ⏸️ open
**Setup:** Bernoulli polynomial roots and von Staudt–Clausen theorem
have prime-detection flavor. Connection?
**Channel-match:** unclear
**Investment:** low
**Payoff:** unknown

### I3. Hyperbolic Chebyshev (= Lucas/Lehmer)
**Status:** ⏸️ open, project-relevant
**Setup:** hyperbolic version $T_n(\cosh \theta) = \cosh(n\theta)$ gives Lucas
sequences. Does $H_n$ have a Lucas-Lehmer interpretation?
**Channel-match:** high (Lucas–Lehmer is *the* Mersenne test)
**Investment:** medium
**Payoff:** could connect to D2 (q-Mersenne)

---

## Currently most promising (sorted by my estimate)

1. **A2** — Wieferich detection via $F_p \bmod p^2$ (concrete, low cost)
2. **C2** — OEIS lookup of $c_k(n)$ (5-minute cost, possibly novel)
3. **F1** — Discriminant of $H_n$ (1 hour cost)
4. **D1+D2** — q-deformation toward Mersenne (high investment, biggest payoff if it works)
5. **A1+B1+B2** — write up the formalization as short note (low cost, modest publication)

## Currently least promising

- **F2** (Galois group: tautological)
- **G2** (ZK trivial)
- **E2** (no algorithmic speedup)
- **A4** (cubic reciprocity wrong channel)

## Open question for next session

> Which of A2 (Wieferich), D2 (Mersenne via q), or F1 (discriminant) should we
> attempt first?

My recommendation: **A2 — Wieferich**, because:
- The setup is already in place ($F_p$, mod arithmetic)
- Cost is genuinely 1 hour (compute $F_p \bmod p^2$ for $p \leq 5000$)
- Two known Wieferich primes (1093, 3511) give clear positive controls
- If it doesn't fire, we close the door and move on
- If it does fire, the result is immediately interesting

A2 alone would justify a follow-up session.
