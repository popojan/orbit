# FactorialTerm vs Hypergeometric Functions

**Date:** 2025-11-22
**Question:** What is the relationship between `FactorialTerm[x,k]` and hypergeometric functions?

## Answer: FactorialTerm is RATIONAL, NOT Hypergeometric

### Definition

```mathematica
FactorialTerm[x, j] = 1 / (1 + Sum[2^(i-1) * x^i * (j+i)! / ((j-i)! * (2i)!), {i, 1, j}])
```

### Key Finding

The inner sum is a **POLYNOMIAL** of degree j:

| j | Sum |
|---|-----|
| 1 | `x` |
| 2 | `x(3 + 2x)` |
| 3 | `2x(3 + 5x + 2x²)` |
| 4 | `2x(5 + 15x + 14x² + 4x³)` |
| 5 | `x(15 + 70x + 112x² + 72x³ + 16x⁴)` |

**Therefore:** `FactorialTerm[x, j]` is a **RATIONAL FUNCTION** (not hypergeometric).

### Coefficient Patterns

For the sum `Sum[2^(i-1) * x^i * (j+i)! / ((j-i)! * (2i)!), {i, 1, j}]`:

**Leading coefficients (x^1):** Triangular numbers
- j=1: 1 = 1·2/2
- j=2: 3 = 2·3/2
- j=3: 6 = 3·4/2
- j=4: 10 = 4·5/2
- j=5: 15 = 5·6/2

**Trailing coefficients (x^j):** Powers of 2
- j=1: 1 = 2^0
- j=2: 2 = 2^1
- j=3: 4 = 2^2
- j=4: 8 = 2^3
- j=5: 16 = 2^4

### Symbolic Closed Form

Mathematica's `Sum` finds a closed form for the inner sum:

```mathematica
Sum[2^(i-1) * x^i * (j+i)! / ((j-i)! * (2i)!), {i, 1, j}]
  = -1/2 * (√(2+x) - √2·Cosh[(1+2k)·ArcSinh[√x/√2]]) / √(2+x)
```

This uses **hyperbolic functions** (Cosh, ArcSinh), NOT hypergeometric functions.

**Verification example (x=13, k=3):**
```
Hyperbolic form = 10556 ✓
Explicit sum    = 10556 ✓

FactorialTerm[13, 3] = 1/(1 + 10556) = 1/10557 ✓
ChebyshevTerm[13, 3] = 1/10557 ✓ (confirms conjecture)
```

### Relation to Hypergeometric Functions

**Individual Egypt factors:**
```mathematica
1/(1 + k*x) = Hypergeometric2F1[1, 1, 1, -k*x]  ✓
```

**Product (FactorialTerm):**
```mathematica
FactorialTerm[x, k] ≠ Any Hypergeometric2F1[a, b, c, f(x)]  ✗
```

### Why Not Hypergeometric?

Hypergeometric functions are defined as infinite series:
```
₂F₁(a,b;c;z) = Sum[(a)_n (b)_n / ((c)_n n!)] * z^n, {n, 0, ∞}
```

But `FactorialTerm` contains a **finite polynomial** (sum from i=1 to j), making it:
1. **Rational** (polynomial / polynomial)
2. **Elementary** (no special functions needed)
3. **Not hypergeometric** (finite sum, not infinite series)

### Comparison Summary

| Function | Type | Hypergeometric? |
|----------|------|-----------------|
| `1/(1+kx)` | Rational | Yes: ₂F₁[1,1,1;-kx] |
| `Egypt[k,x]` individual factor | Rational | Yes (each factor) |
| `FactorialTerm[x,k]` | Rational | **NO** |
| `ChebyshevTerm[x,k]` | Rational | **NO** |

### Conclusion

**FactorialTerm[x,k] is NOT expressible as a hypergeometric function.**

It is a rational function whose numerator sum can be expressed via hyperbolic functions, but this is a fundamentally different class from hypergeometric functions.

The confusion arises because:
1. Individual Egypt factors ARE hypergeometric
2. But their combination (FactorialTerm) is NOT
3. The finite sum structure makes it rational, not transcendental

### Bonus Discovery: Triple Identity

**NEW (2025-11-22):** The denominator `D(x,k) = 1 + Sum[...]` has THREE equivalent representations:

1. **Factorial form:** `1 + Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!)]`
2. **Chebyshev form:** `ChebyshevT[⌈k/2⌉, x+1] * (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1])`
3. **Hyperbolic form:** `1/2 + Cosh[(1+2k)·ArcSinh[√(x/2)]] / (√2·√(2+x))`

This reveals:
- **NEW identity** connecting Chebyshev polynomials to hyperbolic functions
- Bridge between combinatorics, approximation theory, and hyperbolic geometry
- Possible path to algebraic proof of Egypt-Chebyshev equivalence

See: `docs/sessions/2025-11-22-palindromic-symmetries/triple-identity-factorial-chebyshev-hyperbolic.md`
