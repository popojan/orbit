# Fast Computation of e via σ-Conjugation

**Date:** 2025-12-17
**Status:** ❌ CF known since Euler (1737) | 🔬 Bessel connection known (A002119) | 🤔 Monotonic telescoping formula — novelty unclear

## Discovery

Two formulas for Euler's number using the Möbius involution σ(x) = (1-x)/(1+x):

### Formula 1: Continued Fraction

```mathematica
e = 2 + σ(ContinuedFractionK[2 + 4k, {k, 1, ∞}])
```

Equivalently:
$$e = 2 + \sigma\left(\mathop{\mathrm{K}}_{k=1}^{\infty} \frac{2+4k}{1}\right)$$

### Formula 2: Bernoulli Series

```mathematica
e = 2 + σ(Sum[2 BernoulliB[2n]/(2n)!, {n, 1, ∞}])
```

Equivalently:
$$e = 2 + \sigma\left(\sum_{n=1}^{\infty} \frac{2B_{2n}}{(2n)!}\right)$$

where $B_{2n}$ are Bernoulli numbers.

## Mathematical Derivation

### Key Identity Chain

1. **Arithmetic CF identity** (known, OEIS A016825):
   $$\coth(1/2) = [2; 6, 10, 14, 18, \ldots] = \frac{e+1}{e-1}$$

2. **Generalized CF evaluation**:
   $$\mathop{\mathrm{K}}_{k=1}^{\infty} \frac{2+4k}{1} = \coth(1/2) - 2 = \frac{3-e}{e-1}$$

3. **Bernoulli series for coth** (known):
   $$\coth(x) = \frac{1}{x} + \sum_{n=1}^{\infty} \frac{2^{2n} B_{2n}}{(2n)!} x^{2n-1}$$

   For x = 1/2:
   $$\coth(1/2) - 2 = \sum_{n=1}^{\infty} \frac{2 B_{2n}}{(2n)!}$$

4. **σ-conjugation** (the key insight):
   $$\sigma\left(\frac{3-e}{e-1}\right) = \frac{1 - \frac{3-e}{e-1}}{1 + \frac{3-e}{e-1}} = \frac{(e-1)-(3-e)}{(e-1)+(3-e)} = \frac{2e-4}{2} = e-2$$

5. **Final formula**:
   $$e = 2 + \sigma(\text{either representation})$$

## Convergence Comparison

| n terms | 1/n! (standard) | Brothers | **CF(2+4k)** | Bernoulli |
|---------|-----------------|----------|--------------|-----------|
| 5       | 2 digits        | 8        | **12**       | 8         |
| 10      | 7 digits        | 21       | **27**       | 16        |
| 15      | 13 digits       | 35       | **45**       | 24        |

**The CF formula converges ~3 digits per term**, significantly faster than:
- Standard 1/n!: ~0.9 digits/term
- Brothers formula: ~2.3 digits/term

## Verification Code

```mathematica
(* Define σ involution *)
sigma[x_] := (1 - x)/(1 + x);

(* Formula 1: CF *)
eCF[n_] := 2 + sigma[ContinuedFractionK[2 + 4 k, {k, 1, n}]];

(* Formula 2: Bernoulli *)
eBern[n_] := 2 + sigma[Sum[2 BernoulliB[2 k]/(2 k)!, {k, 1, n}]];

(* Symbolic verification *)
ContinuedFractionK[2 + 4 k, {k, 1, Infinity}] (* Returns (3-E)/(E-1) *)
2 + sigma[(3 - E)/(E - 1)] // FullSimplify   (* Returns E *)
```

## What Is Potentially Novel?

### Known:
- coth(1/2) = (e+1)/(e-1) with CF [2; 6, 10, 14, ...] — OEIS A016825
- Bernoulli series for coth(x)
- The involution σ(x) = (1-x)/(1+x) (Cayley transform)

### Potentially Novel:
1. **The explicit formula e = 2 + σ(K...)** as a computation method
2. **The observation that this CF converges faster** than standard e formulas
3. **The unified view** connecting CF, Bernoulli series, and σ via coth(1/2)

## Literature Search Results

### What IS documented:

1. **CF for (e-1)/(e+1) = tanh(1/2)**: `[0; 2, 6, 10, 14, ...]` — MathWorld
2. **CF for coth(1/2) = (e+1)/(e-1)**: `[2; 6, 10, 14, ...]` — OEIS A016825
3. **General formula for e^(x/y)** with 6y, 10y, 14y pattern — Wikipedia
4. **Bernoulli series for coth(x)** — classical

### What appears NOT documented:

1. **The explicit formula `e = 2 + σ(K...)`** as a computational method
2. **The convergence rate comparison** showing ~3 digits/term
3. **The unified presentation** via σ-conjugation connecting:
   - Generalized CF K(2+4k)
   - Bernoulli series
   - coth(1/2) - 2

### Novelty Assessment

**Status: NOT NOVEL — Known since Euler (1737/1748)**

### Historical Origin

**Euler himself** published this in 1737 and 1748:

```
(e-1)/2 = [0; 1, 6, 10, 14, 18, 22, ...]
```

The general theorem (Theorem 5 in numbers.computation.free.fr):
```
(1/2)(e^(1/p) - 1) = [0; 2p-1, 6p, 10p, 14p, ...]
```
For p=1 gives Euler's formula. Proof uses tanh(x) continued fraction development.

### Timeline

| Year | Event |
|------|-------|
| **1737/1748** | Euler publishes CF for (e-1)/2 = [0; 1, 6, 10, 14, ...] |
| 1999 | Wedeniwski uses CF method for 869M digit record |
| 2025 | We rediscover via σ-conjugation (not novel) |

### What We Found

Our σ-presentation `e = 2 + σ(K[2+4k])` is a reformulation of Euler's 280-year-old result:
- `(e-1)/2 = [0; 1, 6, 10, 14, ...]` (Euler)
- `coth(1/2) - 2 = [0; 6, 10, 14, ...]` (equivalent, cleaner arithmetic progression)
- `σ(coth(1/2) - 2) = e - 2` (our presentation)

**Conclusion:** Classical result from Euler. No paper needed.

## Bessel Polynomial Connection

### Discovery

The convergent sum $p_n + q_n$ (which appears as the output denominator) satisfies:

$$p_n + q_n = (-1)^{n+1} \cdot y_{n+1}(-2)$$

where $y_n(x)$ is the Bessel polynomial.

### Verification

| n | p_n + q_n | y_{n+1}(-2) | (−1)^{n+1}·y_{n+1}(−2) |
|---|-----------|-------------|------------------------|
| 0 | 1 | −1 | 1 ✓ |
| 1 | 7 | 7 | 7 ✓ |
| 2 | 71 | −71 | 71 ✓ |
| 3 | 1001 | 1001 | 1001 ✓ |
| 4 | 18089 | −18089 | 18089 ✓ |

### Recurrence

The sequence satisfies:
$$s_n = (4n+2) \cdot s_{n-1} + s_{n-2}$$

with $s_0 = 1$, $s_1 = 7$.

### OEIS Reference

[A002119](https://oeis.org/A002119) — Bessel polynomial y_n(−2)

### Significance

The "clean" form [0; 6, 10, 14, ...] (without Euler's leading 1 or OEIS's leading 2) gives convergent sums that are **exactly** Bessel polynomial values. This is a canonical algebraic structure.

## Monotonic Formula for e via Telescoping

### Discovery

The transformed convergents **alternate** around e (odd terms undershoot, even overshoot). By pairing consecutive differences, we obtain a **monotonically increasing** sequence converging to e from below.

### Telescoping Structure

The differences between consecutive transforms have a beautiful form:

$$d_n = T_{n+1} - T_n = \frac{(-1)^{n+1} \cdot 2}{s_n \cdot s_{n+1}}$$

where $s_n$ are the Bessel polynomial values.

### Unified Monotonic Formula

$$e = \frac{19}{7} + 2\sum_{k=1}^{\infty} \left[\frac{1}{s_{2k-1} \cdot s_{2k}} - \frac{1}{s_{2k} \cdot s_{2k+1}}\right]$$

where $s_n = (-1)^{n+1} \cdot y_{n+1}(-2)$ with $s_1 = 7, s_2 = 71, s_3 = 1001, s_4 = 18089, \ldots$

### Convergence Rate

| Pairs | Partial sum | Correct digits |
|-------|-------------|----------------|
| 0 | 19/7 = 2.714... | 2 |
| 1 | 2.71828171... | 6 |
| 2 | 2.7182818284585... | 12 |
| 3 | 2.718281828459045234757... | 18 |

**~6 digits per pair** (or ~12 digits per 2 pairs)

### Connection to Egyptian Fractions

This is **exactly** the same telescoping mechanism as in:

| System | Difference formula | Denominators |
|--------|-------------------|--------------|
| Egyptian fractions | $\frac{1}{a \cdot b}$ | consecutive products |
| Fibonacci rationals | $\frac{F_n}{F_k \cdot F_{k+1}}$ | Fibonacci products |
| **e via Bessel** | $\frac{2}{s_n \cdot s_{n+1}}$ | **Bessel products** |

All three systems share the same telescoping structure — a unified theory of monotonic rational approximations.

### Simplified Formula (middle term cancels!)

Combining the paired fractions with common denominator:

$$\frac{1}{s_{2k-1} \cdot s_{2k}} - \frac{1}{s_{2k} \cdot s_{2k+1}} = \frac{s_{2k+1} - s_{2k-1}}{s_{2k-1} \cdot s_{2k} \cdot s_{2k+1}}$$

Using recurrence $s_{2k+1} - s_{2k-1} = (8k+6) \cdot s_{2k}$:

$$= \frac{(8k+6) \cdot s_{2k}}{s_{2k-1} \cdot s_{2k} \cdot s_{2k+1}} = \frac{8k+6}{s_{2k-1} \cdot s_{2k+1}}$$

**The middle term $s_{2k}$ cancels!**

### Final Simplified Monotonic Formula

$$e = \frac{19}{7} + 4\sum_{k=1}^{\infty} \frac{4k+3}{s_{2k-1} \cdot s_{2k+1}}$$

where only **odd-indexed** Bessel values appear: $s_1 = 7, s_3 = 1001, s_5 = 398959, s_7 = 312129649, \ldots$

### Alternative: Starting from 3 (Alternating)

$$e = 3 + \sum_{n=0}^{\infty} \frac{(-1)^{n+1} \cdot 2}{s_n \cdot s_{n+1}}$$

$$= 3 - \frac{2}{7} + \frac{2}{497} - \frac{2}{71071} + \frac{2}{18107089} - \cdots$$

### Connection to Standard Convergents of e

Our transformed convergents $T_n$ are **every 3rd convergent** of the standard CF for e:

| Our $T_n$ | Position in Convergents[E] | Formula |
|-----------|---------------------------|---------|
| $T_1 = 19/7$ | 5th | $3 \cdot 1 + 2$ |
| $T_2 = 193/71$ | 8th | $3 \cdot 2 + 2$ |
| $T_3 = 2721/1001$ | 11th | $3 \cdot 3 + 2$ |
| $T_n$ | $(3n+2)$-th | $3n + 2$ |

The monotone sequence $M_k = T_{2k-1}$ picks positions 5, 11, 17, 23, ... (every 6th starting from 5).

### Verification Code

```mathematica
(* Bessel sequence via recurrence *)
s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4n + 2) s[n-1] + s[n-2];

(* Simplified monotonic formula *)
eMonotone[terms_] := 19/7 + 4 Sum[
  (4k + 3)/(s[2k - 1] s[2k + 1]),
  {k, 1, terms}
];

(* Test *)
N[eMonotone[4], 20]  (* 2.7182818284590452353... *)

(* Alternative from 3 *)
eFrom3[terms_] := 3 + Sum[
  (-1)^(n+1) 2/(s[n] s[n+1]),
  {n, 0, terms}
];
```

## BBP-Type Digit Extraction Formulas

### What are BBP formulas?

**Bailey–Borwein–Plouffe (BBP) formulas** allow computing the *n*-th digit of certain constants **directly**, without computing all preceding digits. Discovered 1995–1996.

General form:
$$\alpha = \sum_{k=0}^{\infty} \frac{1}{b^k} \cdot \frac{p(k)}{q(k)}$$

where *b* is the base and *p*, *q* are polynomials with integer coefficients.

### The original BBP formula for π (1996)

$$\pi = \sum_{k=0}^{\infty} \frac{1}{16^k} \left( \frac{4}{8k+1} - \frac{2}{8k+4} - \frac{1}{8k+5} - \frac{1}{8k+6} \right)$$

Allows extracting hexadecimal digits of π in O(*n* log *n*) time, O(log *n*) space.

### Constants with known BBP formulas

| Constant | Base | Formula type | Year |
|----------|------|--------------|------|
| π | 16 | BBP | 1996 |
| π² | 16 | BBP | 1996 |
| ln(2) | 2 | BBP | 1997 |
| ln(3), ln(5), ... | various | BBP | various |
| Catalan's G | 16 | BBP | 1997 |
| ζ(3) (Apéry) | — | no known BBP | — |
| **e** | — | **NO known BBP** | — |
| γ (Euler-Mascheroni) | — | no known BBP | — |

### Why does e lack a BBP formula?

BBP formulas arise from **polylogarithms** evaluated at rational points:
$$\text{Li}_s(x) = \sum_{k=1}^{\infty} \frac{x^k}{k^s}$$

The key identity:
$$\text{Li}_1(1/2) = \ln(2), \quad \text{Li}_2(1) = \pi^2/6$$

**π and ln(2)** appear naturally in polylogarithm identities at rational arguments.

**e = exp(1)** does not fit this structure:
- exp(x) is not a polylogarithm
- No known way to express *e* as a sum with geometric base factor 1/b^k
- This remains an **open problem** in computational number theory

### What exists for e instead

1. **Spigot algorithms** — produce digits sequentially (not random access)
2. **Binary splitting** — O(*n* log²*n* log log *n*), but computes all digits from start
3. **CF-based methods** (this session) — fast convergence (~3 digits/term), but not digit extraction

### Mathematical framework

BBP formulas are connected to:
- **Polylogarithms** Li_s(x)
- **Hurwitz zeta function** ζ(s, a)
- **Modular arithmetic** on digit positions
- **PSLQ algorithm** — integer relation finding (how BBP was discovered)

The existence of a BBP formula implies the constant is a **"polylogarithmic period"** — a specific algebraic structure that *e* apparently lacks.

### Open questions

1. Does *e* have a BBP-type formula in ANY base?
2. Can we prove *e* does NOT have such a formula?
3. What about Euler-Mascheroni γ?

These remain unsolved as of 2025.

## References

- [MathWorld: e Continued Fraction](https://mathworld.wolfram.com/eContinuedFraction.html)
- [Wikipedia: List of representations of e](https://en.wikipedia.org/wiki/List_of_representations_of_e)
- [OEIS A016825](https://oeis.org/A016825): CF for coth(1/2)
- [OEIS A003417](https://oeis.org/A003417): CF for e
- [numbers.computation.free.fr](http://numbers.computation.free.fr/Constants/E/e.html): Fast e computation — **key reference**, documents CF method since 1999
- [y-cruncher internals](https://www.numberworld.org/y-cruncher/internals/binary-splitting.html): Binary splitting for exp(1)
- [Bailey–Borwein–Plouffe formula](https://en.wikipedia.org/wiki/Bailey%E2%80%93Borwein%E2%80%93Plouffe_formula): Wikipedia on BBP
- [MathWorld: BBP Formula](https://mathworld.wolfram.com/BBPFormula.html): BBP-type formulas catalog
- [Original BBP paper (1997)](https://www.davidhbailey.com/dhbpapers/bbp-alg.pdf): "On the Rapid Computation of Various Polylogarithmic Constants"
