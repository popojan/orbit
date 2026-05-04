# Chebyshev Ω-Bijection — T_n(x+1) − 1 Factorization

**Date:** 2026-05-04
**Status:** 🔬 Numerically verified for n ≤ 50; 🤔 partial conjecture, sharp boundary identified

## Summary

We tested the conjecture from `project_chebyshev_omega_bijection.md` (raised at
the close of `2026-05-04-chebyshev-pell-witness/`) using the polynomial

$$P_n(x) = T_n(x+1) - 1$$

and found a clean partial result with a **sharp boundary**:

> **Theorem (verified for n ∈ [2, 50]):**
> For all integers n ≥ 2 with **4 ∤ n**, the polynomial T_n(x+1) − 1 has
> exactly **Ω(n)** distinct irreducible factors over ℚ[x] of degree ≥ 1
> whose constant term is a (signed) prime, and the multiset of those
> primes equals the prime factorization multiset of n.
>
> For n with **4 | n**, the bijection fails.

37/37 of the n with 4 ∤ n match. 0/12 of the n with 4 | n match.

## Why it works (odd n and n ≡ 2 mod 4)

The roots of T_n(y) − 1 are y = cos(2kπ/n), k = 0, ..., n−1, with multiplicity
2 in the bulk and multiplicity 1 at boundary (y = ±1). The factorization is

$$T_n(y) - 1 = 2^{n-1} (y-1) \cdot [(y+1)]_{n \text{ even}} \cdot \prod_{d \mid n,\ d > 2} \tilde\psi_d(y)^2$$

where $\tilde\psi_d(y)$ is the integer minimal polynomial of $2\cos(2\pi/d)$
(Chebyshev–cyclotomic polynomial of degree φ(d)/2).

After the substitution y = x+1, each $\tilde\psi_d$ becomes a polynomial
$F_d(x) = \tilde\psi_d(2(x+1))/(\text{content})$ whose **constant term equals
$\Phi_d(1)$** (the cyclotomic polynomial evaluated at 1):

$$\Phi_d(1) = \begin{cases} p & \text{if } d = p^k \text{ (prime power)} \\ 1 & \text{otherwise} \end{cases}$$

For each prime power divisor $p^k > 1$ of n, we get one irreducible factor
$F_{p^k}$ with constant $p$. Counting these gives exactly **Ω(n)** factors
with prime constants.

### Identity behind it

For odd prime p, the constant of $F_p$ is

$$F_p(0) = 2^{(p-1)/2} \prod_{k=1}^{(p-1)/2} (1 - \cos(2k\pi/p)) = 2^{p-1} \prod_{k=1}^{(p-1)/2} \sin^2(k\pi/p) = p$$

using the well-known identity $\prod_{k=1}^{p-1} 2\sin(k\pi/p) = p$.

## Why it breaks at 4 | n

The cyclotomic polynomial $\psi_d(y)$ for $d = 4$ is $\psi_4(y) = y$ (since
$2\cos(\pi/2) = 0$). Under the shift $y = 2(x+1)$ we get
$\psi_4(2(x+1)) = 2(x+1)$, which factors in ℚ[x] as

$$2 \cdot (x+1)$$

The "2" predicted by $\Phi_4(1) = 2$ is **absorbed into the leading
coefficient** rather than appearing as the constant of the primitive
ℚ-irreducible factor (x+1), which has constant 1. Same phenomenon for
$d = 2^k$ with k ≥ 3 (their min polys are not divisible by y, but the
leading content still pulls out the 2).

Concretely for n = 4:

$$T_4(x+1) - 1 = 8 \cdot x \cdot (x+2) \cdot (x+1)^2$$

We see only **one** prime-constant factor (x+2) instead of the **two**
predicted by Ω(4) = 2. The "missing" 2 is in the leading 8 = 2³.

## Verification

Scripts:
- [`scripts/verify_bijection.wl`](scripts/verify_bijection.wl) — n ∈ [2, 50] with detailed factor dump
- [`scripts/extended_n_200.wl`](scripts/extended_n_200.wl) — n ∈ [2, 200] + alternative-polynomial sweep

Outputs: `scripts/verify_output.log`, `scripts/extended_output.log`

### n ∈ [2, 200] by 2-adic valuation

| v₂(n) | count | match |
|-------|-------|-------|
| 0 (odd) | 99 | **99/99** ✓ |
| 1 (≡ 2 mod 4) | 50 | **50/50** ✓ |
| 2 | 25 | 0/25 ✗ |
| 3 | 13 | 0/13 ✗ |
| 4 | 6 | 0/6 ✗ |
| 5 | 3 | 0/3 ✗ |
| 6 | 2 | 0/2 ✗ |
| 7 | 1 | 0/1 ✗ |

**Sharp dichotomy: 149/149 match for 4 ∤ n, 0/50 for 4 | n.**

### Alternative polynomials all fail for 4 | n

Tested 8 alternative candidates over all n with 4 | n in [4, 50]:
`T_n(x±1) ± 1`, `T_n(x) − 1` (no shift), `T_n(2x+1) − 1`, `U_{n−1}(x+1)`,
`T_n(x+1)² − 1`, `(T_n(x+1) − 1)(T_n(x−1) + 1)`. **None recovers** the missing
prime-2 factors. T_n(x+1) − 1 itself remains the best candidate (gives the
prime factors with v₂(n) = 1 for prime 2, i.e., ω-style for prime 2). All
other shifts give either the same answer or strictly less (no x = 0 root).

**Conclusion: the 4 | n obstruction appears structural, not a shift artifact.**

### Sample factorizations (verified)

**n = 9 = 3² (odd, Ω = 2):**
$$T_9(x+1) - 1 = x \cdot (2x+3)^2 \cdot (8x^3 + 24x^2 + 18x + 3)^2$$
Two prime-3 factors ✓.

**n = 15 = 3 · 5 (odd, Ω = 2):**
$$T_{15}(x+1) - 1 = x \cdot (2x+3)^2 \cdot (4x^2 + 10x + 5)^2 \cdot (16x^4 + 56x^3 + 56x^2 + 16x + 1)^2$$
Const 3, 5, plus a degree-4 extraneous factor with constant 1 (corresponding to
the composite divisor d = 15) ✓.

**n = 18 = 2 · 3² (Ω = 3, v₂ = 1):**
$$T_{18}(x+1) - 1 = 2 \cdot x \cdot (x+2) \cdot (\ldots)^2 \cdot (2x+3)^2 \cdot (\ldots)^2 \cdot (8x^3 + 24x^2 + 18x + 3)^2$$
Const 2, 3, 3 ✓.

**n = 12 = 2² · 3 (Ω = 3, v₂ = 2):** mismatch.
$$T_{12}(x+1) - 1 = 8 \cdot x \cdot (\ldots)^2 \cdot (x+2) \cdot (\ldots)^2 \cdot (2x+3)^2 \cdot (\ldots)^2$$
Only two prime-constant factors (x+2, 2x+3); the "missing" 2 sits in leading 8.

## Comparison with original conjecture

Original conjecture: T_n(x)/x via the composition T_n = T_{p_1^{a_1}} ∘ ⋯
gives Ω(n) factors with prime constants.

| | T_n(x)/x (composition) | **T_n(x+1) − 1 (cyclotomic)** |
|---|---|---|
| Works for odd n | ✓ | ✓ |
| Works for n ≡ 2 mod 4 | ✗ (T_n(0) ≠ 0) | ✓ |
| Works for 4 \| n | ✗ | ✗ |
| Structural reason | composition | $\Phi_d(1)$ identity |

The cyclotomic polynomial T_n(x+1) − 1 covers strictly more cases (adds all
n ≡ 2 mod 4) and has a cleaner structural reason.

## Update: 4 | n is NOT a real obstruction (intCont encodes v_2(n))

Empirical finding (verified for n ≤ 100):
$$\boxed{\text{intCont}(T_n(x+1) - 1) = 2^{2 v_2(n) - 1} \quad \text{for } v_2(n) \geq 1}$$

The integer leading content of T_n(x+1) − 1 (the deg-0 factor in `FactorList`) is
exactly $2^{2 v_2(n) - 1}$ for $v_2(n) \geq 1$, and 1 otherwise.

**Recovery formula:**
$$v_2(n) = \frac{v_2(\text{intCont}) + 1}{2}$$

So the "missing" prime-2 factors for 4 | n are encoded *in the leading content*,
not lost. The bijection extends to all n if we count:
- Distinct ℚ-irreducible factors with prime constant (gives all odd primes with multiplicity, plus one factor for prime 2 if v_2(n) ≥ 1)
- Plus the 2-content of the integer leading constant (recovers v_2(n))

Together: full Ω(n) information, full prime factorization recoverable from
T_n(x+1) − 1.

## Closed forms (verified)

### Master closed form for H_n (odd n)

$$\boxed{\,H_n(x) = 1 + 2 \sum_{a=1}^{(n-1)/2} T_a(x+1)\,} \qquad (\text{any odd } n)$$

with the identity
$$T_n(x+1) - 1 = x \cdot H_n(x)^2.$$

$H_n$ has degree $(n-1)/2$, $H_n(0) = n$. This factors over ℚ as
$H_n = \prod_{d|n,\ d>1} F_d$, where $F_d$ is the integer min poly of
$\cos(2\pi/d)$ shifted by $x \to \cos - 1$.

Verified for n ∈ {3, 5, ..., 315}.

**Proof sketch.** Substitute $\cos\theta = x+1$, so $x = -2\sin^2(\theta/2)$.
Then $T_n(x+1) - 1 = \cos(n\theta) - 1 = -2\sin^2(n\theta/2)$, giving
$$\frac{T_n(x+1) - 1}{x} = \left(\frac{\sin(n\theta/2)}{\sin(\theta/2)}\right)^2.$$
The Dirichlet kernel for odd $n = 2k+1$:
$$\frac{\sin((2k+1)\theta/2)}{\sin(\theta/2)} = 1 + 2\sum_{j=1}^{k}\cos(j\theta) = 1 + 2\sum_{j=1}^{(n-1)/2} T_j(x+1) = H_n(x). \square$$

### Coefficients c_k(n) of H_n in closed form

$$H_n(x) = \sum_{k=0}^{(n-1)/2} c_k(n) x^k, \qquad c_k(n) = \frac{2^k n}{2k+1} \binom{(n-1)/2 + k}{2k}$$

Equivalently:
$$c_k(n) = \frac{n \prod_{j=1}^{k}(n^2 - (2j-1)^2)}{2^k (2k+1)!}$$

A polynomial in n of degree $2k+1$ for fixed k. Examples:
- $c_0(n) = n$
- $c_1(n) = n(n^2-1)/12$
- $c_2(n) = n(n^2-1)(n^2-9)/480$
- $c_3(n) = n(n^2-1)(n^2-9)(n^2-25)/40320$

Verified for n ∈ {3, 5, ..., 15}.

### Recursion (step by 2)

$$H_{n+2}(x) = H_n(x) + 2 T_{(n+1)/2}(x+1)$$

Trivial from the sum definition. **Useful for computation** (incremental
generation of $H_n$), but **does not aid factorization**: the factor
structure of $H_n$ depends on the divisor structure of $n$, which has no
mod-2 periodicity.

Sieve property: $F_d \mid H_n \iff d \mid n$. Hence $H_n$ is irreducible iff
$n$ is prime.

### F_p(x) for prime p odd (special case n = p)

For $n = p$ prime, $H_p = F_p$ (single irreducible factor):
$$F_p(x) = 1 + 2 \sum_{a=1}^{(p-1)/2} T_a(x+1)$$

Examples:
- $F_3 = 2x + 3$
- $F_5 = 4x^2 + 10x + 5$
- $F_7 = 8x^3 + 28x^2 + 28x + 7$
- $F_{11} = 32 x^5 + 176 x^4 + 352 x^3 + 308 x^2 + 110 x + 11$

(Initially I presented this only as a prime-case formula; in fact it
generalizes to **all odd n** as $H_n$ above.)

### S_n: cleared polynomial (no extraneous factors)

$$S_n(x) = \prod_{\substack{d|n,\ d>1 \\ d \text{ prime power}}} F_d(x)$$

Properties:
- $\deg S_n = \frac{1}{2} \sum_{p | n} (p^{v_p(n)} - 1)$ — often much smaller than n
- $S_n(0) = \pm n$
- factors as Ω(n) irreducible pieces, each with prime constant

Degree comparison (odd n):

| n | T_n(x+1)−1 | H_n | S_n | Ω(n) |
|---|---|---|---|---|
| 15 | 15 | 7 | 3 | 2 |
| 35 | 35 | 17 | 5 | 2 |
| 105 | 105 | 52 | 6 | 3 |
| 165 | 165 | 82 | 8 | 3 |
| 225 | 225 | 112 | 16 | 4 |

## Mod-p Frobenius identity

For p odd prime dividing n:
$$T_n(x+1) - 1 \equiv (T_{n/p}(x+1) - 1)^p \pmod{p}$$

Verified for n ∈ {6, 12, 15, 18, 30, 35, 60, 105} and corresponding p odd. Fails
for p = 2 (because intCont ≡ 0 mod 2).

This is essentially Frobenius applied to the cyclotomic-Chebyshev decomposition.

## Open / speculative

### q-deformation hint

$\Phi_d(q)$ at q = 1 detects prime-powers (the basis of our bijection).
At q = 2, $\Phi_d(2)$ produces **Bang/Zsygmondy primes** — primitive prime
divisors of $2^n - 1$:

- $\Phi_5(2) = 31$ (prime)
- $\Phi_7(2) = 127 = M_7$ (Mersenne!)
- $\Phi_{11}(2) = 2047 = 23 \cdot 89$
- $\Phi_{17}(2) = 131071 = M_{17}$

A q-deformed Chebyshev cyclotomic, with $F_p^{(q)}(x)$ analogous to our $F_p$,
might give a **q-Mersenne primality test**: the constant of the analogous
factor evaluated at q = 2 would be $\Phi_p(2)$, which is prime ↔ Mersenne prime
condition. Speculative but a clean direction.

### Other extensions (BFS open directions)

Possible directions:

1. **Track polynomial content separately.** Define "extended constant" = constant
   term of $\psi_d(2(x+1))$ as a polynomial (not its primitive part), giving
   $\Phi_d(1)$ universally. The bijection then becomes: count ψ_d-blocks (with
   their leading coefficients) instead of ℚ-irreducible factors. This is more
   bookkeeping but mathematically clean.

2. **Different polynomial for 4 | n.** Try $T_n(x+a) - b$ for other (a, b)
   such that the boundary roots avoid the y = 0 issue. E.g., shift away from
   y = 0 by using $T_n(x) - T_n(c)$ for some other c.

3. **Restrict the conjecture.** Accept that the clean form holds only for
   n ∈ {odd} ∪ {2 mod 4}, and document the leading-content correction for
   4 | n separately.

**Channel-match check:** $\Phi_d(1)$ "reads" the prime-power-vs-not distinction
of d directly (von Mangoldt-style), so for any polynomial built from T_n via
cyclotomic decomposition, the same $\Phi_d(1) = p$-or-1 dichotomy will appear.
Direction 1 is universal but trades irreducibility for content tracking.
Direction 2 was eliminated empirically (8 candidates tried; none works) — the
4 | n obstruction sits at $\psi_4(y) = y$ (which has 0 as a root) and persists
under any rational change of variables that keeps the cyclotomic structure.
**Recommendation: adopt direction 1 (track content) or restrict the conjecture
to n ∉ 4ℤ.**

## Files

- `scripts/verify_bijection.wl` — initial verification (n ≤ 50, factor dump)
- `scripts/extended_n_200.wl` — extended verification + alternative shifts (n ≤ 200)
- `scripts/explore_v2.wl` — closed form, S_n construction, content, Frobenius, q-hint
- `scripts/*_output.log` — full numerical outputs

## Adversarial check

- ✓ **Not a tautology.** The constants $\Phi_d(1)$ are computed by an
  independent identity (von Mangoldt), not derived from the conjecture.
- ✓ **Boundaries tested.** v₂(n) checked from 0 to 5; sharp transition at
  v₂(n) = 1 → 2.
- ✓ **Multiplicity matches.** For odd n, prime constant multiplicities exactly
  match the prime factorization multiset (e.g., n=27=3³ gives three factors all
  with const 3).
- ⚠️ **Limited range.** Verified n ≤ 50; should extend to ~500 for confidence.
- ⚠️ **No proof yet.** The structural argument above sketches WHY it works for
  odd n / 2 mod 4, but is not formalized as a theorem. Needs:
  (i) proof that $\Phi_d(1) = p$ for d = p^k via von Mangoldt;
  (ii) proof that the substitution y = x+1 preserves irreducibility of
       primitive parts for d ≠ 2^k (k ≥ 2).
