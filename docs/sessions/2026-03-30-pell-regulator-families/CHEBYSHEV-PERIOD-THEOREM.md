# Chebyshev-Pell Period Theorem

## Statement

**Given:** Non-square n, integer c >= 1, decomposition c^2 n = a_0^2 + r
with z = (2a_0^2 + r)/r in Z, w = 2a_0/r = p_w/d (reduced fraction).

**Then:** x = T_m(z), y = c w U_{m-1}(z) is a Pell solution x^2 - n y^2 = 1,
where

    m = lcm_{p^e || d} alpha(p^e)

and alpha(p^e) is the **Lucas rank of apparition** of the sequence (P, Q) = (2z, 1)
modulo p^e: the smallest positive n with U_n(2z, 1) = 0 mod p^e.

The regulator satisfies R_pell = m * arccosh(z) / k for some positive integer k
(the fundamentality index).

## Verification

| Property | Test size | Result |
|----------|-----------|--------|
| m = lcm(alpha(p^e)) | 4284 decompositions, n <= 500, c <= 20 | 4284/4284 |
| alpha(p) = 2 iff p \| z | 4776 (z, p) pairs | 4776/4776 |
| Symmetry alpha(z, p) = alpha(p-z, p) | 2045 pairs | 2045/2045 |
| R-D case (d = 1): m = 1 | 745 R-D decompositions, n <= 10000 | 745/745 |
| Lifting alpha(p^2) = p alpha(p) | 686 (z, p) pairs | 633/686 (92.3%) |

The lifting property holds except at small primes where p^2 | U_{alpha(p)}.

## Properties of alpha(p)

### 1. Eigenvalue interpretation

alpha(p) equals the multiplicative order of the **Chebyshev eigenvalue**
lambda = z + sqrt(z^2 - 1) modulo p, with a correction for the quadratic
character:

- **Split case** (n is QR mod p, so sqrt(z^2-1) in F_p):
  alpha(p) = ord(lambda) in F_p^*,  and  alpha(p) | p - 1.

- **Inert case** (n is QNR mod p, so sqrt(z^2-1) in F_{p^2} \ F_p):
  alpha(p) = ord(lambda) / 2 in F_{p^2}^*,  and  alpha(p) | p + 1.

In both cases: alpha(p) | p - (z^2 - 1 | p) where (. | p) is the Legendre symbol.

The Legendre symbol (z^2 - 1 | p) = (n | p) whenever p does not divide r.
This holds because z^2 - 1 = 4 a_0^2 n / r^2.

### 2. Minimal rank

**alpha(p) = 2 if and only if p | z.**

Proof: U_0(z) = 1 (never zero), U_1(z) = 2z. So the first possible zero is at
k = 1, giving alpha = 2, which happens iff 2z = 0 mod p iff p | z (for odd p;
for p = 2 it holds since z is odd, giving U_1 = 2z = 0 mod 2 always).

Consequence: if d | z then alpha(p) = 2 for every odd prime p | d, giving m = 2
(optimal for d > 1).

### 3. Symmetry

alpha(z, p) = alpha(p - z, p) for all z and odd primes p.

This follows from the identity U_k(-z) = (-1)^k U_k(z), which means the
zero positions are the same.

### 4. Prime power lifting

For most (z, p): alpha(p^2) = p * alpha(p). Exceptions occur when
p^2 | U_{alpha(p)}(2z, 1), in which case alpha(p^2) = alpha(p). This is
the standard lifting behavior for Lucas sequences.

### 5. Alpha value spectrum

For a fixed prime p, the map z -> alpha(z, p) on z in {2, ..., p-2} takes values:

- **Split alpha values**: divisors d of p - 1 with d >= 3, each appearing
  for phi(d) / 2 values of z (pairing lambda with lambda^{-1}).
- **Inert alpha values**: divisors d of p + 1 with d >= 3.
- **alpha = 2**: exactly 2 values of z (those with p | z, counting z and p-z).
- **alpha = p**: exactly 2 values (z = 1 and z = p - 1, degenerate cases).

The median alpha is approximately (p +/- 1) / 2. Full-rank alpha (= p +/- 1)
occurs in only ~0.3% of (z, p) pairs.

## Special cases

### d = 1 (Richaud-Degert)

When d = 1 (i.e., r | 2a_0), the lcm over an empty set of primes gives m = 1.
The Chebyshev solution is simply x = z, y = w, which is the classical R-D formula.

With the Pell regulator (using 2R when the fundamental unit has norm -1):
**m = 1 for all R-D decompositions** (745/745).

### d = 2

alpha(2) = 2 always (since z is odd). So m = 2: the solution uses
T_2(z) = 2z^2 - 1 and U_1(z) = 2z.

### General d

m = lcm of alpha values for all prime powers dividing d. Typical size:
m ~ d / 2 (since median alpha ~ p/2). In the worst case m can approach
d (when all alpha values are coprime), but shared factors in the lcm
usually reduce m.

## Worked example: n = 13078849728

| | Value |
|-|-------|
| n | 2^6 * 3 * 7 * 19 * 43^2 * 277 |
| c | 5 |
| c^2 n | 326971243200 |
| a_0 | 571728 |
| r | 98337216 = 2^6 * 3 * 43^2 * 277 |
| z | 6649 |
| d | 86 = 2 * 43 |

Prime decomposition of d:

| p | alpha(p) | Splitting in Q(sqrt(n_sf)) | Bound p-(n\|p) | Bound/alpha |
|---|----------|---------------------------|----------------|-------------|
| 2 | 2 | inert | 3 | 1.5 |
| 43 | 21 | **split** (43 \| n) | 42 | 2 |

m = lcm(2, 21) = **42**.

R = 42 * arccosh(6649) = 398.80549469... (matches quadregulator(4n) to 50 digits).

Note: the default decomposition (c = 1) gives z = 6539379193/45671 (non-integer,
delta = 45671). R / arccosh(z) ~ 31.74, which is **not** an integer. The c = 5
scaling is essential.

## Non-universality

R = m * arccosh(z) with integer m requires z to be an integer, which requires
r | 2 a_0^2 in the decomposition c^2 n = a_0^2 + r.

For the default decomposition (c = 1, a_0 = floor(sqrt(n))), this holds for only
~11% of n. For the remaining ~89%, z is a non-integer rational, and
R / arccosh(z) is **transcendental** by Baker's theorem (since the norm-1 element
alpha = z + w sqrt(n) is not a unit of any order in Q(sqrt(n))).

Scaling (c > 1) and the divisor method extend coverage:

| c_max | n <= 200 | n <= 1000 |
|-------|----------|-----------|
| 1 | ~25% | ~13% |
| 20 | 79% | ~45% |
| 100 | ~90% | 67% |

**Hard primes** (127, 193, 409, 541, 991) remain uncoverable at any c <= 500.
For prime n: any decomposition c^2 n = a_0^2 + r with r | 2c^2 n encodes
a generalized Pell equation, making the approach circular.

## Connection to Lucas sequence theory

The Chebyshev polynomial U_k(z) equals the Lucas sequence value U_{k+1}(2z, 1),
so the rank of apparition alpha(p) is exactly the classical Lucas entry point.
The well-known theory gives:

- alpha(p) | p - (Delta | p) where Delta = 4(z^2 - 1)
- Lifting: alpha(p^e) = p^{e-1} alpha(p) generically
- Period of U_k mod p divides 2(p - (Delta | p))
- Zeros of U_k mod p occur at k = alpha - 1, 2 alpha - 1, ...

What is new is the application to the Pell regulator: the Chebyshev degree m
required to produce an integer Pell solution from a rational decomposition
is completely determined by these classical invariants.

## Algorithm

Given n:

1. For c = 1, 2, ..., C_max:
   - Enumerate divisors r of 2 c^2 n with c^2 n - r = square.
   - For each: z = (2 a_0^2 + r) / r. Skip if not integer.
   - d = r / gcd(r, 2 a_0). If d = 1: R = arccosh(z), done.
   - Factor d. For each prime power p^e || d:
     iterate U_k(z) mod p^e to find alpha(p^e). Cost: O(p^e).
   - m = lcm of alpha values.
   - R_cand = m * arccosh(z). Verify via cosh/sinh rounding.
2. Fall back to BSGS for uncovered n.

## Scripts

All in this session directory:

| File | Purpose |
|------|---------|
| `arccosh_m.gp` | Initial test: R/arccosh(z) is NOT generally integer |
| `arccosh_m2.gp` | Delta distribution, divisor method, surprise cases |
| `arccosh_m3.gp` | Norm sign fix (Pell vs field regulator), O_K membership |
| `arccosh_m4.gp` | m-value distribution (all R-D give m=1), delta=2 analysis |
| `cheb_period.gp` | Chebyshev period method: finds m via U_k mod d iteration |
| `cheb_theory.gp` | Lucas rank connection, eigenvalue interpretation |
| `cheb_deep.gp` | Splitting type, Legendre connection, forced alpha=2 |
| `cheb_structure.gp` | Symmetry, spectrum, lifting, full theorem summary |
| `hard_primes.gp` | Attack on n=127,193 with high c (negative result) |
| `verify_n.gp` | Verification of n=13078849728 with c=5 |
