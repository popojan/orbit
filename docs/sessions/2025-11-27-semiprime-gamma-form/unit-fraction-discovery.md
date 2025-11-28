# Unit Fraction Discovery: Primality & Factorization

**Date:** 2025-11-28 (late session continuation)

## The Formula

```mathematica
f[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, ∞}])
```

Starting index variations `{j, 0, i}` vs `{j, 1, i}` give different unit fraction sequences.

## Key Discovery

For the `{j, 1, i}` variant:

```
f[n] = num/den  where num = rad(odd part of n)
```

| n | f[n] | Interpretation |
|---|------|----------------|
| 3 | 3/32 | prime, num = 3 |
| 5 | 5/46624 | prime, num = 5 |
| 7 | 7/524854336 | prime, num = 7 |
| 15 = 3×5 | 15/... | squarefree, num = 15 |
| 9 = 3² | 3/... | has square, num = 3 |

## Factorization via gcd

For **squarefree composites** (num = n):

```
gcd(den ± k, n) = factor  for small k
```

| n | Factor found | Offset k |
|---|--------------|----------|
| 15 = 3×5 | 3 | -1 |
| 21 = 3×7 | 3 | +1 |
| 35 = 5×7 | 7 | +2 |
| 77 = 7×11 | 7 | -3 |
| 143 = 11×13 | 13 | +2 |

For **primes**: gcd(den ± k, p) is always 1 or p (trivial).

## Combined Algorithm

```
1. Compute f[n] = num/den
2. If num < n → n has square factor or is even
3. If num = n:
   - Search gcd(den ± k, n) for k = 0, 1, 2, ...
   - Factor found → COMPOSITE
   - No factor → PRIME
```

## Why Sum "Doesn't Converge" Symbolically

For symbolic n, the terms are:

```
T[i] = Product[n² - j², {j,1,i}] / (2i+1)
     = (-1)^i × Pochhammer[1-n, i] × Pochhammer[1+n, i] / (2i+1)
```

The Pochhammer products grow like factorials:
- Pochhammer[1+n, i] ~ (n+i)!/n! grows rapidly
- For symbolic n, this diverges

**But for integer n:**
- When i ≥ n: the product includes (n² - n²) = 0
- So T[i] = 0 for i ≥ n
- The "infinite" sum has only **n-1 nonzero terms**!

## Computational Complexity

**NOT a speedup!**

```
Sum has O(n) nonzero terms
Each term requires O(i) multiplications for the product
Total: O(n²) operations

Compare to:
- Trial division: O(√n)
- Our formula is SLOWER
```

The formula is **mathematically beautiful** but **computationally worse** than trial division.

## Connection to Lissajous / Wilson

The same underlying structure:
- Wilson's theorem detects primes at i = (p-1)/2
- Lissajous diagonal y = -x pattern for factors
- Egyptian fractions encode this via unit fraction structure

All roads lead to the same O(√n) barrier for classical computation.

## Variants with Different Indices

| j start | i start | Pattern |
|---------|---------|---------|
| 0 | 0 | 1/7, 1/104, 1/3551, ... |
| 0 | 1 | 1/3, 1/95, 1/3535, ... |
| 1 | 0 | num = rad(odd part), factoring works |
| 1 | 1 | Similar, denominators differ by num |

The `{j=0, i=0}` variant gives **pure unit fractions** (numerator = 1) for all n ≥ 2.

## Open Questions

1. Is there a closed form for the denominator sequence?
2. Can the offset k be predicted without computing den?
3. Connection to DifferenceRoot / holonomic sequences?

## Conclusion

Beautiful mathematical structure connecting:
- Egyptian fractions
- Pochhammer products / Gamma functions
- Wilson's theorem
- Primality testing
- Factorization

But no computational advantage - the O(√n) barrier remains.
