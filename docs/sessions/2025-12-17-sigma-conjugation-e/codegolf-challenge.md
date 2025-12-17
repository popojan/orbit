# Arithmetic Continued Fractions (Euler's e and beyond)

Given *a*, *d*, and *n*, compute the **n-th convergent** of an arithmetic continued fraction and transform it.

## Continued fraction structure

The n-th convergent of an arithmetic continued fraction with parameters *a*, *d*:

$$[0; a, a+d, a+2d, \ldots, a+(n-1)d] = \cfrac{1}{a + \cfrac{1}{(a+d) + \cfrac{1}{(a+2d) + \cfrac{1}{\ddots + \cfrac{1}{a+(n-1)d}}}}}$$

For example, with *a*=6, *d*=4, *n*=3:

$$[0; 6, 10, 14] = \cfrac{1}{6 + \cfrac{1}{10 + \cfrac{1}{14}}} = \frac{141}{860}$$

## The transform

From the n-th convergent *p*/*q*, compute:

$$\text{result} = \frac{3q + p}{q + p}$$

For *a*=6, *d*=4, this converges to **Euler's number e**.

## Input

Three integers *a*, *d*, *n* where *a* ≥ 1, *d* ≥ 0, *n* ≥ 1. Input may be taken in any convenient format (three arguments, list, etc.).

## Output

Numerator and denominator as two integers (in that order). Format: tuple, list, two lines, space-separated, or native fraction type. Reduced form not required.

## Test cases (a=6, d=4 → e)

| n | numerator | denominator | correct digits of e |
|---|-----------|-------------|---------------------|
| 1 | 19 | 7 | 2 |
| 2 | 193 | 71 | 4 |
| 3 | 2721 | 1001 | 6 |
| 5 | 1084483 | 398959 | 12 |
| 6 | 28245729 | 10391023 | 15 |

## Test cases (other a, d)

| a | d | n | numerator | denominator |
|---|---|---|-----------|-------------|
| 2 | 0 | 5 | 239 | 99 |
| 1 | 2 | 4 | 284 | 133 |

## Scoring

[tag:code-golf] — shortest code in bytes wins.

**Tags:** `code-golf`, `math`, `number`, `rational-numbers`, `sequence`

## Background

Euler (1737) discovered that (*e*−1)/2 = [0; 1, 6, 10, 14, ...]. Our form [0; 6, 10, 14, ...] drops the leading 1, giving a pure arithmetic progression that yields *e* directly via the transform.

## References

- [OEIS A002119](https://oeis.org/A002119) — `p + q = (-1)^(n+1) * y(n+1, -2)`, Bessel polynomial
- [OEIS A016825](https://oeis.org/A016825) — the sequence 2, 6, 10, 14, ... (CF for coth(1/2))
- [Wikipedia: List of representations of e](https://en.wikipedia.org/wiki/List_of_representations_of_e#As_a_continued_fraction)
- [MathWorld: e Continued Fraction](https://mathworld.wolfram.com/eContinuedFraction.html)
