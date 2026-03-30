# Pell Regulator Families by Even-Square Distance

**Date:** March 30, 2026
**Status:** Active investigation

## Discovery

When Pell regulators R(n) are grouped by **distance to the nearest even square**,
the growth R ~ C * log(n) becomes perfectly regular for small distances d.
The constant C depends only on d (and m mod 8 for |d| >= 8).

This is in sharp contrast to the regulators themselves, which appear erratic.

## The Distance Function

For each non-square n, define:

    m = nearest even integer >= ceil(sqrt(n))
    d = n - m^2

This writes n = (2k)^2 + d where 2k = m. The key range is d in (-m, m],
but the interesting families are small |d|.

**Why even squares?** The CF of sqrt((2k)^2 + d) has leading partial quotient
a0 = 2k (even), and the period structure becomes a clean function of d alone.
Odd squares do not produce the same regularity — the CF period depends on
additional arithmetic conditions when a0 is odd.

**Why ceiling?** This assigns each n to the even square *above* it, so
d <= 0 for n <= m^2 and d > 0 for n just above the previous even square.
The range d in {-m+1, ..., m-1} covers all non-squares in the interval.

## Observed Families

### d = +/- 1: Period 1 (or 2), R/log(n) -> 1/2

    n = (2m)^2 + 1:  CF = [2m; 4m, 4m, ...]     period 1
    n = (2m)^2 - 1:  CF = [2m-1; 1, 2(2m-1), ...]  period 2

    Pell solution: x = 2m, y = 1  (for d=+1)
    epsilon = 2m + sqrt(4m^2+1) ~ 4m
    R = log(4m) ~ log(n)/2 + log(2)/2

    R/log(n) -> 1/2     (CV < 1%)

### d = +/- 2: Period 2 (or 4), R/log(n) -> 1

    n = (2m)^2 + 2:  CF = [2m; 2m, 4m, ...]   period 2
    n = (2m)^2 - 2:  CF = [2m-1; 1, 2m-2, 1, 2(2m-1), ...]  period 4

    Pell solution: x = (2m)^2 - 1, y = 2m  (for d=+2)
    epsilon ~ 4m^2 -> R ~ log(4m^2) ~ log(n)

    R/log(n) -> 1.066   (CV ~ 4%)

### d = +/- 4: Period 2, R/log(n) -> 1 (exactly)

    n = (2m)^2 + 4:  CF = [2m; m, 4m, m, 4m, ...]   period 2

    Pell solution: x = 2m^2 + 1, y = m     (VERIFIED for m=1..316)
    epsilon = (2m^2+1) + m*sqrt(4m^2+4)
    R = log(epsilon) -> log(4m^2) = log(n)

    R/log(n) -> 1.000    (CV = 0.001% — effectively exact!)

    This is the cleanest family. The CF template [2m; m, 4m] has entries
    that are LINEAR in m, giving an explicit closed-form Pell solution.

### d = +/- 8: Period 2 or 8, 2 branches by m mod 4

    m mod 4 = 0:  CF = [2m; m/2, 4m]           period 2   R/log(n) -> 0.93
    m mod 4 = 2:  CF = [2m; ..8 entries..]      period 8   R/log(n) -> 1.86 (= 2x)

### d = +/- 16: 3 branches by m mod 8

    m mod 8 = 0:  CF period 2    R/log(n) -> 0.86
    m mod 8 = 4:  CF period 8    R/log(n) -> 1.72 (= 2x)
    m mod 8 = 2,6: CF period 10-14  R/log(n) -> 2.49-2.59 (= 3x)

## CF Template Structure

For each family, the CF of sqrt((2m)^2 + d) has the form:

    [2m; a1(m), a2(m), ..., aL(m), 4m]

where the interior entries ai(m) are **linear functions of m** (or constants).
The period L and the coefficients depend on d and m mod (something small).

| d   | L  | CF template                     | x formula        |
|-----|----|---------------------------------|------------------|
| +1  | 1  | [2m; 4m]                        | 2m               |
| -1  | 2  | [2m-1; 1, 2(2m-1)]             | 2m               |
| +2  | 2  | [2m; 2m, 4m]                    | 4m^2 - 1         |
| +4  | 2  | [2m; m, 4m]                     | 2m^2 + 1         |
| -4  | 4  | [2m-1; 1, m-1, 1, 2(2m-1)]     | (2m)^2 - 1       |
| +8  | 2  | [2m; m/2, 4m]  (m mod 4 = 0)   | m^2/2 + 1        |
| +8  | 8  | [2m; ...]       (m mod 4 = 2)  | (larger)         |

## Key Observation: Regulator Without CF Walk

For the families with fixed CF period, the regulator is:

    R = log(x + y*sqrt(n))

where x and y are **polynomial functions of m**. Since n = 4m^2 + d:

    R = log(P(m) + Q(m)*sqrt(4m^2 + d))

This is computable in O(1) — no CF walk, no BSGS, no baby-giant steps.
For d = +4: R = log((2m^2+1) + m*sqrt(4m^2+4)).

The question is: for which d values does a polynomial formula exist?

**Answer so far:** For d where the CF period is bounded (independent of m),
polynomial formulas exist. This includes d = 1, 2, 4, and specific
congruence classes within d = 8, 16. For d = 3, the CF period grows
with m, and no such formula exists.

## Connection to Richaud-Degert Type Fields

This is a **known phenomenon** — these are the **Richaud-Degert (R-D) type**
real quadratic fields, first classified by Richaud (1866) and Degert (1958).

A field Q(sqrt(n)) is of R-D type when n = m^2 + d and **d | 4m**. These
fields have:
- Explicit closed-form fundamental units (polynomial in m)
- Short CF periods (bounded, independent of m)
- Small regulators: R ~ C * log(n)

### Why Powers of 2 Work

The R-D condition d | 4m explains the observed structure:

| d    | d divides 4m when | R-D branch | Non-R-D branch |
|------|-------------------|------------|----------------|
| +-1  | always            | all m      | (none)         |
| +-2  | always            | all m      | (none)         |
| +-4  | always            | all m      | (none)         |
| +-8  | m even (m%4=0)    | m%4=0: L=2 | m%4=2: L=8    |
| +-16 | 4|m (m%8=0)       | m%8=0: L=2 | m%8=2,4,6: L=8-14 |
| d=3  | rarely (3|4m)     | sparse     | most m         |

For d = +-1, +-2, +-4: the condition d | 4m is satisfied for ALL even m,
so every entry in the family is R-D type → one clean curve.

For d = +-8: 8 | 4m iff 2 | m, i.e., m mod 4 = 0. The other branch
(m mod 4 = 2) is NOT R-D → longer period, different growth rate.

For d = +-16: 16 | 4m iff 4 | m, i.e., m mod 8 = 0. Two non-R-D branches.

For non-power-of-2 d: the condition d | 4m depends on the odd prime
factors of d, which create irregular congruence conditions → no clean families.

### Key References

- Richaud (1866), Degert (1958): Original R-D classification
- Yokoi (1970): Extended types with explicit fundamental units
  [ScienceDirect](https://www.sciencedirect.com/science/article/pii/0022314X70900107)
- Mollin & Williams (1990): Class number one for extended R-D types
- Biro (2003): Resolution of Yokoi's and Chowla's conjectures
- Nimbran (2023): Patterns in CF of square roots, parametric families
  [JIS Vol.26](https://cs.uwaterloo.ca/journals/JIS/VOL26/Nimbran/nimbran14.pdf)
- Ozer & Salem (2017): Computational techniques for explicit fundamental units
  [IJAAS](https://www.science-gate.com/IJAAS/V4I2/Özer.html)
- Kopp & Lagarias (2025): Unit-generated orders, discriminants n^2 +- 4
  [arXiv](https://arxiv.org/pdf/2512.11311)

### What May Be New Here

The individual R-D families are well-known. What may be less explored is:

1. The **systematic visual stratification** by even-square distance that
   makes R-D vs non-R-D branches immediately visible as distinct curves
   in a single plot

2. The **precise branch structure** for d = 2^k, where the number of
   branches equals k-1 and the R/log(n) ratios are in integer proportions

3. The **practical observation** that the 100k regulator dataset decomposes
   almost entirely into these families, with the erratic-looking R values
   being a superposition of regular R-D curves and non-R-D noise

## Beyond R-D: Fixed-Period Non-R-D Branches (Possibly Novel)

The R-D condition d | 4m explains only the **shortest-period branch** in each
family. For d = +-8 and d = +-16, additional branches exist where the R-D
condition is NOT satisfied, yet the CF period is FIXED (independent of m)
and the regulator is perfectly predictable.

### d = +16: Three branches, only one is R-D

| m mod 8 | R-D? | CF period | CF template | R/log(n) |
|---------|------|-----------|-------------|----------|
| 0       | yes  | 2         | [2m; m/4, 4m] | 0.86 |
| 4       | yes* | 8         | [2m; fixed pattern linear in m] | 1.72 |
| 2, 6    | NO   | 14        | [2m; fixed pattern linear in m] | 2.56 |

*m%8=4 satisfies 16|4m, but gets L=8 not L=2.

The L=8 and L=14 branches are NOT covered by classical R-D theory.
Their CF partial quotients are linear in m (verified for m up to 60),
giving polynomial Pell solutions and R ~ C * log(n) with precise C.

### Critical contrast with d = 3

For d = +3:
- m mod 3 = 0 (R-D): L = 2 always. CF = [2m; 2m/3, 4m]. Predictable.
- m mod 3 = 1: L = 6, 10, 12, 28, 10, 26, 18, 20, ... GROWS irregularly
- m mod 3 = 2: L = 4, 10, 20, 10, 16, 12, 32, ... GROWS irregularly

This is why d = 3 shows only ONE clean line (the R-D branch) while
d = 16 shows THREE clean lines. The non-R-D branches of d = 3 have
growing, unpredictable CF periods. The non-R-D branches of d = 8 and
d = 16 have FIXED CF periods — a phenomenon specific to power-of-2
distances.

### Why powers of 2 are special

For d = 2^k:
- The CF of sqrt((2m)^2 + 2^k) depends on the 2-adic structure of m
- When v_2(m) >= k/2 (R-D condition), the period is minimal (L=2)
- When v_2(m) < k/2, the period is STILL FIXED — determined by
  v_2(m) mod (k-1) or similar. The 2-adic valuation creates a finite
  number of cases, each with a rigid CF template.

For d with odd prime factors (d = 3, 5, 6, 7, ...):
- The non-R-D branches have CF periods that grow with m
- The interaction between the odd prime structure of d and the
  even-square geometry creates unbounded period variation

This appears to be a new observation: **the fixed-period non-R-D branches
for d = 2^k are parametric Pell families beyond classical R-D theory.**

## Unified R-D Formula (NEW)

**See [UNIFIED-RD-TABLE.md](UNIFIED-RD-TABLE.md) for the complete result.**

All R-D families collapse to a single algebraic identity:

    n = a₀² + r,  r | 2a₀:   x = (2a₀²+r)/r,   y = 2a₀/r

Or equivalently:

    Even r=2s:  n = s²t²+2s,  x = st²+1,  y = t
    Odd r:      n = r²u²+r,   x = 2ru²+1, y = 2u

With R = log(4n/r) + O(1/n), giving R/log(n) → 1 for all families.

## Non-R-D Polynomial Families (NEW)

For d = 2^k, the non-R-D branches also have **closed-form polynomial
Pell solutions**. All proved as algebraic identities:

| d    | condition   | L  | x formula              | y formula       | deg |
|------|-------------|----|-----------------------|-----------------|-----|
| +8   | k odd       |  8 | 2k⁴+4k²+1            | k³+k            | 4   |
| -8   | k odd       |  8 | 2k⁴-4k²+1            | k³-k            | 4   |
| +16  | k≡2 mod 4   |  8 | k⁴/2+2k²+1           | (k³+2k)/4       | 4   |
| -16  | k≡2 mod 4   |  8 | k⁴/2-2k²+1           | (k³-2k)/4       | 4   |
| +16  | k odd       | 14 | (k²+2)(k⁴+4k²+1)/2   | k(k²+1)(k²+3)/4| 6   |

Pattern: **deg(x) = 2m**, CF period **L = 6m - 4** for m >= 2.

## Governing Principle: Chebyshev-Demeyer Identity (NEW)

Foundation is the **polynomial Pell equation** (Demeyer):

    T_m(z)² - (z²-1)·U_{m-1}(z)² = 1

Combined with z²-1 = n·k²/2^{2a-4}, this gives explicitly:

    x = T_m(z),   y = k·U_{m-1}(z)/2^{a-2},   z = k²/2^{a-3}+1

| d | v₂(k) | m | x formula | verified |
|:--|:--|--:|:--|:--|
| 8 | >=1 | 1 | k²+1 | all k<=51 |
| 8 | 0 | 2 | 2k⁴+4k²+1 | all k<=51 |
| 16 | >=2 | 1 | (k²+2)/2 | all k<=62 |
| 16 | 1 | 2 | (k⁴+4k²+2)/2 | all k<=62 |
| 16 | 0 | 3 | (k²+2)(k⁴+4k²+1)/2 | all k<=25 |

**d = 16 is the boundary**: for d >= 32, T_m(z) produces non-integers
(denominator of z is too large). Pell solutions for d >= 32 depend on
specific arithmetic of k²+d/4, not a universal Chebyshev formula.

## The Chebyshev Tower (NEW)

For **arbitrary** d = 2^a, restricting k to divisibility class k = 2^{ceil((a-3)/2)}·j:

    z = k²/2^{a-3} + 1     (integer)
    x = T_m(z)              (Chebyshev polynomial)
    m = 2^{ceil((a-4)/2)}   (for j odd; halves with each factor of 2 in j)

**Verified 100%** for a = 3..12. Two base towers:
- a odd: z = j²+1, base field Q(√3) when j=1
- a even: z = 2j²+1, base field Q(√2) when j=1

Coverage: 1/2^{ceil((a-3)/2)} of all k. Full coverage only for a ≤ 4 (d ≤ 16).
For uncovered k: Pell depends on field-specific arithmetic of k²+2^{a-2}.

## Generalization to Arbitrary r (NEW)

The Chebyshev mechanism extends far beyond r = 2^a.

### The denominator defect

For n = a₀² + r, the R-D seed z = (2a₀²+r)/r has denominator δ = denom(z).
The Chebyshev mechanism applies iff **δ ≤ 2** (proved: necessity by 2-adic
induction on T_m denominators; sufficiency by T₃ half-integer trick).

### Mixed strategy for composite r

For r = 2^b · p₁^{e₁} · ... · pₛ^{eₛ}: require p_i^{⌈e_i/2⌉} | a₀
(consumes odd primes from δ), then v₂(a₀) ≥ ⌈(b-2)/2⌉ (Chebyshev for 2-part).

Verified 100% for r ∈ {3,5,6,7,10,12,14,20,24,28,40,56}, 20 k-values each.
Example: r=12, a₀=3k gives n=9k²+12, solvable for ALL k.

### Why only p=2 works for Chebyshev

T_m has leading coefficient 2^{m-1}. For z with denominator q:
- q = 2: T_m(z) denom = 2^m/2^{m-1} = 2 (constant!). T₃ maps ½ℤ → ℤ.
- q ≥ 3: T_m(z) denom = q^m/2^{m-1} → ∞. NEVER integer.

Dickson polynomials D_n(x,a) with a ≠ 1 also fail: identity has RHS = 4a^n
(growing), and no p-adic compensation exists.

### Scaling trick: c²n instead of n

For n not directly solvable: try c²n = a₀² + r with δ ≤ 2 for some c > 1.
If (x, Y) solves x²-c²n·Y²=1 and c|Y, then (x, Y/c) solves x²-ny²=1.

**Caveat**: gives valid but not necessarily FUNDAMENTAL solution. Reduction
to fundamental = discrete logarithm in the unit group.

### Density analysis

**Fundamental (c=1)**: count ~ √N · (log N)^c. Density → 0 as (log N)^c/√N.

| N | c=1 | c≤10 | c≤√N |
|---|-----|------|------|
| 500 | 32.7% | 62.9% | 70.9% |
| 2000 | 20.1% | 40.8% | 57.0% |
| 5000 | 14.9% | 30.5% | 48.0% |
| 10000 | 11.6% | 23.7% | — |

**Non-fundamental (c≤√N)**: density ~ 1/log(N), extremely slow decay.
Practically covers ~50% for N ~ 5000.

### Tower multiplicity

Each odd j gives two towers (a odd → Q(√sqfree(j²+2)), a even → Q(√sqfree(j²+1))).
j=1: Q(√3), Q(√2). j=3: Q(√11), Q(√10). j=5: Q(√3) again, Q(√26).
Infinitely many distinct towers. Not every prime appears as a tower field.

## Open Questions

1. ~~Exact CF templates for L=8 and L=14 branches.~~ **SOLVED.**
2. ~~General d = 2^k structure.~~ **SOLVED**: Chebyshev tower for all a.
3. ~~Why does the period stabilize?~~ **ANSWERED**: 2-adic valuation.
4. ~~Non-power-of-2 distances.~~ **SOLVED**: mixed strategy consumes odd primes.
5. ~~Why only p=2?~~ **ANSWERED**: T_m leading coefficient 2^{m-1} is unique.
6. **Fundamentality proof.** Conjecture verified (220 cases, 0 failures).
   Monotonicity argument for c=1 is strong but not rigorous for c>1.
7. ~~Discrete log reduction.~~ **PARTIALLY ANSWERED**: k/m analysis below.
8. **Density lower bound.** Is the c≤√N density exactly Θ(1/log N)?
9. **Can Chebyshev be replaced?** For δ ≥ 3: any other polynomial identity?

## Power Analysis: k vs m (NEW)

**Critical correction**: y = c·Y (not Y/c). No divisibility issue — every c works!

For c>1: our formula gives ε^k for the field Q(√n), where k = R'/R.
The Chebyshev index m is known. The question: what is k/m?

### Comprehensive data (n ≤ 200, c ≤ 30, 1034 pairs)

- **k = m: 748 cases (72.3%)** — the formula gives exactly ε^m, m known
- **k/m integer: 880 cases (85.1%)** — even when k≠m, the ratio is often integer
- **k/m = integer > 1: 132 cases** — higher power than expected
- **k < m: 154 cases** — formula gives LOWER power than m! (k/m = 1/3, 1/2, 2/3, ...)

### Key pattern: k < m happens when c²n has SIMPLER field

When k/m = 1/3: the R-D seed for c²n happens to give the field's fundamental
unit directly (m=3 from Chebyshev, but the actual power k=1).
Example: n=13, c=1, m=3 but k=1 (the T₃ formula IS the fundamental solution).

When k/m = 1/2: similar — norm(-1) unit exists, halving the regulator.
Example: n=44, c=1: formula gives m=2 but fund unit has norm -1, so k=1.

### Algorithmic implications

When k = m (72.3%): extract ε from ε^m by O(log m) NUDUPL operations.
When k/m is a known small rational: similarly extract.
When k/m is unknown: need R or class number information — still hard.

### Scripts
- `power-analysis.wl` — corrected y=cY computation
- `k-vs-m-comprehensive.wl` — full k vs m scan

## Files

- `pell-families.wl` — Wolfram analysis toolkit (original)
- `plot-all-with-rd.wl` — Visualization scripts
- `rd-verify.wl` — Master R-D table verification
- `rd-unified.wl` — Elegant parameterization with proofs
- `non-rd-branches.wl` — Non-R-D branch exploration
- `non-rd-verify.wl` — Degree-4 non-R-D verification
- `deg6-verify.wl` — Degree-6 polynomial discovery
- `UNIFIED-RD-TABLE.md` — Complete unified documentation
- `README.md` — this document

## Usage

```wolfram
Get["pell-families.wl"];
reg = loadRegulators["~/github/zzz/build/reg100k.csv"];
families = analyzePowerOf2Distances[reg, 4];
plotFamilies[families]
plotFamiliesRatio[families]
```
