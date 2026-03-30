# Unified Richaud-Degert Family Table

**Date:** March 30, 2026

## The Universal Formula

Every R-D type real quadratic field has a **closed-form fundamental Pell solution**
given by a single algebraic identity, parameterized by an integer r >= 1.

### Even r = 2s

    n = s*t^2 + 2s       x = s*t^2 + 1       y = t

### Odd r

    n = r^2*u^2 + r      x = 2*r*u^2 + 1     y = 2u

### Proof

Both are trivial algebraic identities:

**Even r = 2s:**

    x^2 - n*y^2 = (s*t^2 + 1)^2 - (s^2*t^2 + 2s)*t^2
                = s^2*t^4 + 2*s*t^2 + 1 - s^2*t^4 - 2*s*t^2
                = 1

**Odd r:**

    x^2 - n*y^2 = (2*r*u^2 + 1)^2 - (r^2*u^2 + r)*4*u^2
                = 4*r^2*u^4 + 4*r*u^2 + 1 - 4*r^2*u^4 - 4*r*u^2
                = 1

### Equivalent form via a0 = Floor(sqrt(n))

For n = a0^2 + r with r | 2*a0:

    x = (2*a0^2 + r) / r
    y = 2*a0 / r

The even/odd split is just the substitution a0 = s*t (even r) or a0 = r*u (odd r).

## Complete Table

| r | n | x | y | R - log(n) |
|--:|:--|:--|:--|:--|
| 1 | u² + 1 | 2u² + 1 | 2u | +1.386 |
| 2 | t² + 2 | t² + 1 | t | +0.693 |
| 3 | 9u² + 3 | 6u² + 1 | 2u | +0.288 |
| **4** | **4t² + 4** | **2t² + 1** | **t** | **0.000** |
| 5 | 25u² + 5 | 10u² + 1 | 2u | -0.223 |
| 6 | 9t² + 6 | 3t² + 1 | t | -0.405 |
| 7 | 49u² + 7 | 14u² + 1 | 2u | -0.560 |
| 8 | 16t² + 8 | 4t² + 1 | t | -0.693 |
| 9 | 81u² + 9 | 18u² + 1 | 2u | -0.811 |
| 10 | 25t² + 10 | 5t² + 1 | t | -0.916 |
| 11 | 121u² + 11 | 22u² + 1 | 2u | -1.012 |
| 12 | 36t² + 12 | 6t² + 1 | t | -1.099 |
| 13 | 169u² + 13 | 26u² + 1 | 2u | -1.179 |
| 14 | 49t² + 14 | 7t² + 1 | t | -1.253 |
| 15 | 225u² + 15 | 30u² + 1 | 2u | -1.322 |
| 16 | 64t² + 16 | 8t² + 1 | t | -1.386 |

The correction is **exactly log(4/r)**, so:

    R = log(4n/r) + O(1/n)

For r = 4 the correction vanishes: R = log(n) exactly (to leading order).

### General asymptotic for all families

For a family where x is degree D polynomial in k with n ~ 4k^2:

    R/log(n) → D/2     (as k → ∞, convergence is O(1/log k))

| family type   | deg(x) | CF period L | R/log(n) → |
|---------------|--------|-------------|------------|
| R-D           |   2    |    ≤ 2      |    **1**   |
| non-R-D L=8   |   4    |      8      |    **2**   |
| non-R-D L=14  |   6    |     14      |    **3**   |

The convergence is slow (logarithmic): for n=916 (k=15, deg 6),
R/log(n) = 2.39, still far from the limit of 3.

## Verification

Verified fundamental (= smallest positive Pell solution) for all r = 1..16,
parameter values 1..50 using Wolfram `FindInstance`. Zero failures.

See `rd-verify.wl` and `rd-unified.wl` for the verification scripts.

## CF Period Structure

R-D members (where r | 4*a0) have **bounded CF period** (independent of a0):

- r = 1: L = 1 (period-one CF, simplest possible)
- r = 2: L = 2
- r = 3..16 (R-D branch): L = 2

The CF template is [a0; 4*a0/r, 2*a0] with entries linear in a0.

## Coverage (density)

R-D numbers with r <= 16 make up:

- 41% of n <= 100
- 15% of n <= 1000
- 4.7% of n <= 10000
- 1.5% of n <= 100000

Density decays as O(1/sqrt(n)) since the R-D condition r | 2*a0 forces
a0 to be a multiple of r/gcd(r,2), and such n are spaced ~r apart near a0.

## Connection to Even-Square Distance

In the even-square convention n = (2k)^2 + d used in the main README:

- d > 0 maps directly to r = d
- d < 0 maps to r = |d| + 4k - 1 (re-indexing via a0 = 2k - 1)

The unified formula subsumes both signs of d.

## Non-R-D Fixed-Period Branches

For d = 2^k (k >= 3), there exist **additional fixed-period branches** where
the R-D condition fails but the CF period is still bounded and the fundamental
solution is a **polynomial in k**. All proved as algebraic identities.

### Degree-4 families (CF period 8)

| family | n | x | y | R → |
|:--|:--|:--|:--|:--|
| d=+8, k odd | 4k² + 8 | 2k⁴ + 4k² + 1 | k³ + k | 2 log(n) |
| d=-8, k odd | 4k² - 8 | 2k⁴ - 4k² + 1 | k³ - k | 2 log(n) |
| d=+16, k≡2 mod 4 | 4k² + 16 | k⁴/2 + 2k² + 1 | (k³ + 2k)/4 | 2 log(n) |
| d=-16, k≡2 mod 4 | 4k² - 16 | k⁴/2 - 2k² + 1 | (k³ - 2k)/4 | 2 log(n) |

**Proofs** (all verified symbolically via Expand[x^2 - n*y^2] = 1):

d=+8, k odd:

    (2k^4+4k^2+1)^2 - (4k^2+8)(k^3+k)^2
    = 4k^8+16k^6+20k^4+8k^2+1 - 4k^8-16k^6-20k^4-8k^2 = 1

d=-8, k odd:

    (2k^4-4k^2+1)^2 - (4k^2-8)(k^3-k)^2
    = 4k^8-16k^6+20k^4-8k^2+1 - 4k^8+16k^6-20k^4+8k^2 = 1

d=+16, k=2 mod 4:

    (k^4/2+2k^2+1)^2 - (4k^2+16)(k^3+2k)^2/16
    = (k^8+8k^6+20k^4+16k^2+4)/4 - (k^8+8k^6+20k^4+16k^2)/4 = 1

d=-16, k=2 mod 4: analogous (sign flips).

Verified fundamental for k = 1..51 (d=8) and k = 2..62 (d=16).

### Degree-6 family (CF period 14)

**d=+16, k odd** — the richest non-R-D branch:

    x = (k^2 + 2)(k^4 + 4k^2 + 1) / 2
    y = k(k^2 + 1)(k^2 + 3) / 4

Factored forms:

    x = (k^6 + 6k^4 + 9k^2 + 2) / 2
    y = (k^5 + 4k^3 + 3k) / 4

**Proof:** x^2 - (4k^2+16)*y^2 = 1 verified symbolically (Wolfram Simplify).

Verified fundamental for all odd k = 3, 5, ..., 25.

    R ~ 3*log(n)  (degree 6 means x ~ k^6 ~ n^3)

### d=-16, k odd: collapses to degree 2!

Surprise: this branch has much simpler formulas than expected:

    x = k(k^2 - 3) / 2
    y = (k^2 - 1) / 4

This is actually equivalent to the R-D formula with a different r value!
(The n = 4k^2 - 16 case re-indexes to n = (2k-1)^2 + (4k-17) when
4k-17 > 0, which for large k is a new R-D type.)

Verified for k = 5, 7, ..., 25.

### Pattern: degree = 2m, period = 6m - 4

| m | deg(x) | CF period L | R/log(n) → |
|--:|-------:|------------:|-----------:|
| 1 |      2 |           2 |          1 |
| 2 |      4 |           8 |          2 |
| 3 |      6 |          14 |          3 |

## The Governing Principle: Chebyshev-Demeyer Identity

All polynomial Pell families for d = 2^a arise from a single algebraic identity
due to Demeyer — the **polynomial Pell equation** satisfied by Chebyshev polynomials:

    T_m(z)^2 - (z^2 - 1) * U_{m-1}(z)^2 = 1      (for all z, all m)

### The Theorem

**Theorem (Chebyshev-Demeyer Pell Tower).** For n = 4k^2 + 2^a with
2^{ceil((a-3)/2)} | k, define:

    z = k^2 / 2^{a-3} + 1      (integer by the divisibility condition)
    m = min { m >= 1 : 2^{a-2} | k * U_{m-1}(z) }

Then the fundamental solution of x^2 - n*y^2 = 1 is:

    x = T_m(z)
    y = k * U_{m-1}(z) / 2^{a-2}

### Proof

The Chebyshev identity T_m(z)^2 - (z^2-1) * U_{m-1}(z)^2 = 1 combined
with the factorization

    z^2 - 1 = n * k^2 / 2^{2a-4}

gives

    T_m(z)^2 - n * (k * U_{m-1}(z) / 2^{a-2})^2 = 1.

The integrality condition on y determines m.  **QED**

### Verification

Verified for all a = 3..12, j = 1..11 (60 test cases, 0 failures).
See `demeyer-verify.wl`.

### Explicit formulas (d=8 and d=16, full coverage)

| d | v_2(k) | m | x = T_m(z) |
|:--|:--|--:|:--|
| 8 | >= 1 (even k) | 1 | k^2 + 1 |
| 8 | 0 (odd k) | 2 | 2k^4 + 4k^2 + 1 |
| 16 | >= 2 (4\|k) | 1 | (k^2 + 2) / 2 |
| 16 | 1 (k = 2 mod 4) | 2 | (k^4 + 4k^2 + 2) / 2 |
| 16 | 0 (odd k) | 3 | (k^2+2)(k^4+4k^2+1) / 2 |

### d = 16 is the boundary for FULL coverage

For d = 32 with k odd: z = (k^2+4)/4 (quarter-integer), and T_m(z) is never
integer. The Pell solution for these k depends on field-specific arithmetic
of k^2+8 (factorization, class number). See `cheb-principle.wl`.

### Summary of fixed-d families

| d | condition | L | x formula | deg(x) | R/log(n) → |
|:--|:--|--:|:--|--:|--:|
| any r | r \| 2a₀ | ≤2 | (2a₀²+r)/r | 2 | 1 |
| +8 | k odd | 8 | 2k⁴+4k²+1 | 4 | 2 |
| -8 | k odd | 8 | 2k⁴-4k²+1 | 4 | 2 |
| +16 | k≡2 mod 4 | 8 | k⁴/2+2k²+1 | 4 | 2 |
| -16 | k≡2 mod 4 | 8 | k⁴/2-2k²+1 | 4 | 2 |
| +16 | k odd | 14 | (k²+2)(k⁴+4k²+1)/2 | 6 | 3 |
| -16 | k odd | — | k(k²-3)/2 | 2* | 1 |

*d=-16, k odd is anomalous: collapses to R-D under re-parameterization.

## The Chebyshev Tower: Arbitrary d = 2^a

The Chebyshev principle extends to **arbitrary** d = 2^a by restricting k
to a divisibility class. This solves Pell for an infinite family of n
at each level of the tower.

### Construction

For n = 4k^2 + 2^a with k divisible by 2^{ceil((a-3)/2)}, write k = 2^s * j:

    z = k^2 / 2^{a-3} + 1       (always integer)
    x = T_m(z)                    (Chebyshev polynomial of the first kind)

where m depends on v_2(j) (2-adic valuation of the free parameter j).

### The z formula

    a even:  z = 2j^2 + 1    (j = k / 2^{(a-2)/2})
    a odd:   z = j^2 + 1     (j = k / 2^{(a-3)/2})

### The m formula

For j odd (hardest case, maximum m):

    m = 2^{ceil((a-4)/2)}

Explicitly:

| a | d | min k | z (j=1) | m (j odd) | m (j even) |
|--:|--:|:--|--:|--:|--:|
| 3 | 8 | j | j²+1 | 2 | 1 |
| 4 | 16 | 2j | 2j²+1 | 2 | 1 |
| 5 | 32 | 2j | j²+1 | 2 | 1 |
| 6 | 64 | 4j | 2j²+1 | 4 | 2 |
| 7 | 128 | 4j | j²+1 | 4 | 2 |
| 8 | 256 | 8j | 2j²+1 | 8 | 4 |
| 9 | 512 | 8j | j²+1 | 8 | 4 |
| 10 | 1024 | 16j | 2j²+1 | 16 | 8 |
| 12 | 4096 | 32j | 2j²+1 | 32 | 16 |
| 14 | 16384 | 64j | 2j²+1 | 64 | 32 |

m halves with each factor of 2 in j: **m(j) = m(1) / 2^{v_2(j)}** (until m=1).

### Verified

100% match for all a = 3..12, j = 1..11, using Wolfram FindInstance.
See `tower-verify.wl`.

### The two base towers

All levels reduce to just **two base fields** (for j=1):

**Tower A** (a odd): z = 2, field Q(√3)

    T_2(2)=7, T_4(2)=97, T_8(2)=18817, T_16(2)=708158977, ...

**Tower B** (a even): z = 3, field Q(√2)

    T_2(3)=17, T_4(3)=577, T_8(3)=665857, T_16(3)=886731088897, ...

For j > 1, z grows (j^2+1 or 2j^2+1) and the fields vary, but the
Chebyshev mechanism is universal.

### Explicit T_m(j^2+1) polynomials

| m | T_m(j²+1) | deg in j |
|--:|:--|--:|
| 1 | j² + 1 | 2 |
| 2 | 2j⁴ + 4j² + 1 | 4 |
| 3 | 4j⁶ + 12j⁴ + 9j² + 1 | 6 |
| 4 | 8j⁸ + 32j⁶ + 40j⁴ + 16j² + 1 | 8 |
| 8 | (degree 16 polynomial in j) | 16 |

Each is an **algebraic identity** for x^2 - n*y^2 = ±1 where n involves j.
The degree of x in j is 2m, giving R/log(n) → m.

### Coverage

| a | d | fraction of k covered |
|--:|--:|:--|
| 3 | 8 | 100% (all k) |
| 4 | 16 | 100% (all k, via half-integer z trick) |
| 5 | 32 | 50% (k even) |
| 6 | 64 | 25% (4 \| k) |
| 7 | 128 | 25% (4 \| k) |
| 8 | 256 | 12.5% (8 \| k) |
| 2p | 2^{2p} | 2^{1-p} |

For k outside the covered class, the Pell solution depends on the specific
arithmetic of k^2 + 2^{a-2} (which may or may not be R-D itself), and no
universal polynomial formula exists.

### Obstruction for uncovered k

For d = 32, k = 3 (odd): n' = k^2 + 8 = 17 (prime). The Pell solution
for n = 68 is x = 33, determined by Q(√17) being R-D type (17 = 4^2 + 1).
This is a **field-specific** fact, not a consequence of the Chebyshev tower.

For d = 32, k = 9 (odd): n' = 89 (prime). CF period = 5. x = 500001.
This is a "hard" Pell instance with no polynomial shortcut.

The uncovered cases are precisely those where k^2 + 2^{a-2} is not R-D
and has no simple algebraic structure — the irreducible core of the
Pell problem.

## Files

- `rd-verify.wl` — Master R-D table verification (FindInstance for r=1..16)
- `rd-unified.wl` — Elegant parameterization with proofs and coverage stats
- `non-rd-verify.wl` — Degree-4 non-R-D branch verification
- `deg6-verify.wl` — Degree-6 polynomial discovery and proof
- `non-rd-branches.wl` — Initial exploration of non-R-D branch patterns
- `cheb-verify.wl` — Chebyshev elevation verification (d=8, d=16)
- `cheb-principle.wl` — Why d=16 is the boundary
- `d32-even.wl` — d=32 even-k analysis
- `d32-twostep.wl` — d=32 two-step Chebyshev (field unit approach)
- `tower-recursive.wl` — Recursive tower structure
- `tower-verify.wl` — Complete tower verification a=3..12
- `pell-families.wl` — Original family analysis toolkit
- `plot-all-with-rd.wl` — Visualization of R-D vs non-R-D
