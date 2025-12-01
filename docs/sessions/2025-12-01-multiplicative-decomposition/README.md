# Multiplicative Decomposition of Chebyshev Lobe Areas

**Date:** December 1, 2025
**Status:** Proven (algebraic proof via roots of unity cancellation)

## Discovery Context

This theorem emerged from exploring the connection between the Chebyshev lobe area function B(n,k) and the Chebyshev polynomial composition property.

### Triggering Prompts

**User prompt 1** (after discussing whether B(n,k) is an L-function):
> "No, just asking. The connection to primes we are building. Got it. Similar symmetries, different ontology"

**User prompt 2** (the key insight):
> "OK, teď zase prosím mluvme česky. B(n,k) is rescaled area in single k-th lobe of ChebyshevPolygonFunction. Could you check the connection, with respect to (Tₘ(Tₙ(x)) = Tₘₙ(x)) composition property!"

This prompted investigation of how lobe areas of composite n-gons relate to their factors.

## The Discovery

### Initial Observation

When computing B(12,k) for the 12-gon (= 3×4), an unexpected pattern emerged:

```
B(12,k) grouped by k mod 3:
  k ≡ 1 (mod 3): sum = 4.0  (= n = 4)
  k ≡ 2 (mod 3): sum = 4.0
  k ≡ 3 (mod 3): sum = 4.0

B(12,k) grouped by k mod 4:
  k ≡ 1 (mod 4): sum = 3.0  (= m = 3)
  k ≡ 2 (mod 4): sum = 3.0
  k ≡ 3 (mod 4): sum = 3.0
  k ≡ 4 (mod 4): sum = 3.0
```

### Theorem (Multiplicative Decomposition of Lobe Areas)

For n = m·d where m, d ≥ 3:

$$\sum_{k \equiv r \pmod{m}} A(n, k) = \frac{1}{m} \quad \text{for all } r \in \{1, \ldots, m\}$$

Equivalently:
$$\sum_{k \equiv r \pmod{m}} B(n, k) = d \quad \text{for all } r$$

### Numerical Verification

Tested for pairs (m, n):
- (3, 4), (3, 5), (4, 5), (3, 7), (5, 7)
- (3, 11), (5, 11), (7, 11)

All verified to machine precision.

### Proof Sketch

1. The lobe area decomposes as:
   $$A(n,k) = \frac{1}{n} + \text{oscillatory term with } \cos\frac{2\pi k}{n}$$

2. Sum over arithmetic progression k = r, r+m, r+2m, ..., r+(d-1)m:
   - Constant part: $d \cdot \frac{1}{n} = d \cdot \frac{1}{md} = \frac{1}{m}$
   - Oscillatory part: $\sum_{j=0}^{d-1} e^{2\pi i(r+jm)/(md)} = e^{2\pi ir/(md)} \cdot \underbrace{\sum_{j=0}^{d-1} e^{2\pi ij/d}}_{= 0}$

3. The sum of d-th roots of unity vanishes, killing the oscillatory term.

## Connection to Chebyshev Composition

| Property | Tₘ(Tₙ(x)) = Tₘₙ(x) | Lobe Areas |
|----------|---------------------|------------|
| Structure | mn-gon from composition | mn-gon has mn lobes |
| Decomposition | "m copies of n-structure" | m groups, each = 1/m area |
| Multiplicativity | Tₘ ∘ Tₙ = Tₘₙ | Σ A(mn, k≡r) = 1/m |

This is a **geometric analogue of Euler product factorization** - lobe areas "factor" according to the factorization of n!

## Interpretation

The mn-gon can be "viewed" in two equivalent ways:
1. As m copies of an n-gon structure (each with 1/m of total area)
2. As n copies of an m-gon structure (each with 1/n of total area)

This mirrors how L-functions factor over primes, though B(n,k) is not itself an L-function.

## Code

```mathematica
(* Lobe area function *)
A[n_, k_] := (8 - 2 n^2 + n^2 (Cos[(2 (k - 1) Pi)/n] + Cos[(2 k Pi)/n])) / (8 n - 2 n^3);
B[n_, k_] := n * A[n, k];

(* Verify multiplicative decomposition *)
VerifyDecomposition[m_, d_] := Module[{n = m*d},
  Table[
    Sum[A[n, r + j*m], {j, 0, d - 1}] // Simplify,
    {r, 1, m}
  ]
]

(* Example: m=3, d=5 -> should return {1/3, 1/3, 1/3} *)
VerifyDecomposition[3, 5]
```

## Open Questions

1. **Prime power case:** Does this extend to n = p^k for prime p?
2. **Three or more factors:** For n = abc, how do the groupings interact?
3. **Continuous extension:** What happens for non-integer grouping parameters?

## References

- Chebyshev composition: Tₘ(Tₙ(x)) = Tₘₙ(x) (standard identity)
- Lobe area function: `lobe-area-kernel.tex` in this repository
- Root Sum Identity: Section 10 of lobe-area-kernel.tex
