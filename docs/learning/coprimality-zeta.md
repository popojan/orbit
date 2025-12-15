# Coprimality Probability and ζ(2)

**Result:** The probability that two random integers are coprime is 6/π².

## Derivation

Two integers are coprime iff no prime divides both. For each prime p:
- P(p | a) = 1/p
- P(p | both a and b) = 1/p²
- P(p ∤ gcd(a,b)) = 1 - 1/p²

Since divisibility by different primes is independent:

$$P(\gcd(a,b) = 1) = \prod_{p \text{ prime}} \left(1 - \frac{1}{p^2}\right)$$

## Connection to ζ(2)

The Euler product formula:

$$\zeta(s) = \sum_{n=1}^{\infty} \frac{1}{n^s} = \prod_{p} \frac{1}{1 - p^{-s}}$$

Taking s = 2:

$$\zeta(2) = \prod_{p} \frac{1}{1 - p^{-2}}$$

Therefore:

$$\frac{1}{\zeta(2)} = \prod_{p} \left(1 - \frac{1}{p^2}\right) = P(\gcd(a,b) = 1)$$

Since ζ(2) = π²/6 (Basel problem, solved by Euler 1734):

$$P(\gcd(a,b) = 1) = \frac{6}{\pi^2} \approx 0.6079$$

## Generalization

For k random integers to be mutually coprime:

$$P(\gcd(a_1, \ldots, a_k) = 1) = \frac{1}{\zeta(k)}$$

| k | ζ(k) | P(coprime) |
|---|------|------------|
| 2 | π²/6 | 6/π² ≈ 0.608 |
| 3 | ζ(3) ≈ 1.202 | ≈ 0.832 |
| 4 | π⁴/90 | 90/π⁴ ≈ 0.924 |

## References

- Euler, L. (1734). Solution to the Basel problem
- Hardy & Wright, *An Introduction to the Theory of Numbers*, Ch. 18
