# Lychrel Numbers and the 196 Problem

**Status:** Open problem (since 1987)
**Field:** Recreational mathematics, number theory

---

## Definition

A **Lychrel number** is a natural number that cannot form a palindrome through the iterative process of:
1. Reverse the digits
2. Add to original
3. Repeat

## The 196 Problem

**196** is the smallest candidate Lychrel number in base 10.

### Factorization

```
196 = 2² × 7² = 14²
```

Interesting: double square, product of smallest primes squared.

### Sequence

```
196 + 691 = 887 (prime!)
887 + 788 = 1675 = 5² × 67
1675 + 5761 = 7436 = 2² × 11 × 13²
...
```

### Key Observation: Factor 11

From step 3 onwards, **all values are divisible by 11**.

This is because in base 10:
```
10^k ≡ (-1)^k (mod 11)
```

So `n + reverse(n)` often inherits divisibility by 11.

### Why This Doesn't Prove Non-Palindrome

Even-digit palindromes are **always divisible by 11**:
```
abba = 11 × (91a + 10b)
abccba = 11 × (9091a + 910b + 100c)
```

So divisibility by 11 is **not an obstruction** to reaching a palindrome.

---

## Current State

- Computed: >10⁹ iterations (numbers with billions of digits)
- No palindrome found for 196
- No proof of non-existence
- Base-dependent: 196 reaches palindrome in other bases!

---

## Non-Connection to 290-Theorem

Despite both involving "special" numbers around 200-300:

| Property | 196 Problem | 290-Theorem |
|----------|-------------|-------------|
| Base-dependent | YES (base 10) | NO (algebraic) |
| Structure | Digit manipulation | Quadratic forms |
| Status | Open | Proved (2005) |

**No mathematical connection** — just numerical coincidence.

---

## References

- [Lychrel number - Wikipedia](https://en.wikipedia.org/wiki/Lychrel_number)
- John Walker (1987) — first extensive computation
- [196 and other Lychrel numbers](http://www.p196.org/)

---

## Related in Orbit

- [290-Theorem](290-theorem.md) — unrelated but compared
- [Small Numbers Conjecture](../sessions/2025-12-12-vymazalova-reflections/small-numbers-conjecture.md)
