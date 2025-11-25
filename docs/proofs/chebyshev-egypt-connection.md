# Chebyshev-Egypt Connection

**Date:** 2025-11-25
**Status:** Standard Chebyshev + Pell theory (computational reformulation)

---

## Summary

The Egypt method is **algebraically equivalent to Pell powers**, just expressed in a computationally advantageous form.

**Key finding (2025-11-25):**
```
Egypt[k] = Pell[k+1] = (x_{k+1} - 1) / y_{k+1}
```

The Factorial ↔ Chebyshev ↔ Hyperbolic equivalence is **standard Chebyshev polynomial theory**.

---

## Standard Identities (Literature)

### 1. Hyperbolic-Chebyshev Connection

**Standard result:**
```
cosh(n·arcsinh(z)) = T_n(√(1+z²))
```

where T_n is the Chebyshev polynomial of the first kind.

**Source:** Standard Chebyshev theory. See:
- [Wikipedia: Chebyshev polynomials](https://en.wikipedia.org/wiki/Chebyshev_polynomials)
- Mason & Handscomb: Chebyshev Polynomials, Chapter 2

### 2. Chebyshev Coefficient Formula

**Standard result:**
```
T_n(x) = n · Σ_{k=0}^{n} (-2)^k · (n+k-1)!/((n-k)!·(2k)!) · (1-x)^k    [n > 0]
```

**Source:**
- [Math StackExchange: Explicit Chebyshev formula](https://math.stackexchange.com/questions/3483628/)
- Mason & Handscomb, Chapter 2

### 3. Our "Factorial Form"

Our formula:
```
D(x,k) = 1 + Σ_{i=1}^{k} 2^(i-1) · x^i · (k+i)!/((k-i)!·(2i)!)
```

This is **the same pattern** as the standard Chebyshev coefficient formula with variable substitution.

---

## What Our Work Established

### Verified (not discovered):
- The three forms (Factorial, Chebyshev, Hyperbolic) are equivalent ✓
- Coefficient matching is exact ✓
- Computational verification k ≤ 200 ✓

### These are standard results we rediscovered:
- Hyperbolic ↔ Chebyshev: `cosh(n·arcsinh(z)) = T_n(√(1+z²))` (textbook)
- Factorial coefficient formula: Standard Chebyshev (textbook)

---

## Egypt = Pell Powers (Key Finding)

**Proven 2025-11-25:**

```
Egypt[k] = (x_{k+1} - 1) / y_{k+1}
```

where `(x_k, y_k)` are Pell solutions via recurrence:
```
x_{k+1} = x₁·x_k + n·y₁·y_k
y_{k+1} = x₁·y_k + y₁·x_k
```

### Verification (n=13)

| k | Egypt[k] | Pell[k+1] | Equal |
|---|----------|-----------|-------|
| 1 | 2340/649 | 2340/649 | ✓ |
| 2 | (exact match) | (exact match) | ✓ |
| 3 | (exact match) | (exact match) | ✓ |

### Algebraic Proof (k=1)

```
Egypt[1] = (x-1)/y · (1 + 1/x) = (x²-1)/(xy) = ny/x

Pell[2] = (x₁² + ny₁² - 1)/(2x₁y₁)
        = 2ny₁²/(2x₁y₁)           [using x² - ny² = 1]
        = ny₁/x₁

IDENTICAL
```

### Monotonic Convergence

This is **standard Pell theory**:
- All `(x_k - 1)/y_k` are lower bounds (below √n)
- All `x_k/y_k` are upper bounds (above √n)
- Both converge monotonically toward √n

**Not novel** - follows from `x_k² - ny_k² = 1`.

---

## Egypt's Actual Contribution

Egypt is a **reformulation** of Pell powers with **minor** computational difference:

| Aspect | Egypt | Pell Powers |
|--------|-------|-------------|
| Result | Same rational | Same rational |
| Intermediates | ~k/2 digits | ~k digits |
| Growth | O(k) | O(k) |
| Advantage | ~2x smaller | — |

**Not a fundamental improvement** - same asymptotic complexity, just ~2x constant factor in intermediate size.

**Trade-off:** Egypt requires fundamental Pell solution (same as Pell powers).

---

## Deprecated: "Novel Aspects"

~~The following were thought to be novel but are standard:~~

1. ~~Egypt Construction~~ → Pell powers reformulated
2. ~~Monotonic Convergence~~ → Standard Pell theory
3. ~~Reciprocal Structure~~ → Encodes Pell recurrence

---

## Archived Files

The following files contain our "proof" work which is actually rediscovery of standard results. They are retained for historical reference but should not be cited as novel proofs:

- `factorial-chebyshev-*.md` - Various proof attempts (standard result)
- `hyperbolic-chebyshev-*.md` - Derivations (standard result)

---

## References

### Standard Literature
1. Wikipedia: [Chebyshev polynomials](https://en.wikipedia.org/wiki/Chebyshev_polynomials)
2. MathWorld: [Chebyshev Polynomial of the First Kind](https://mathworld.wolfram.com/ChebyshevPolynomialoftheFirstKind.html)
3. DLMF: [Section 18.5 - Chebyshev Polynomials](https://dlmf.nist.gov/18.5)
4. Mason & Handscomb: Chebyshev Polynomials (CRC Press)

### Our Implementation
- Orbit Paclet: `Orbit/Kernel/SquareRootRationalizations.wl`
- Egypt method: `EgyptSqrt`, `FactorialTerm`
- Chebyshev method: `ChebyshevTerm`
- Hyperbolic method: `HyperbolicTerm`

---

**Last updated:** 2025-11-25
