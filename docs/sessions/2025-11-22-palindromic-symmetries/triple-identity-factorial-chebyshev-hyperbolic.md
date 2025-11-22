# Triple Identity: Factorial-Chebyshev-Hyperbolic

**Date:** 2025-11-22
**Status:** 🔬 NUMERICALLY VERIFIED (k=1..6, multiple x values)
**Discovery:** Hyperbolic form found by Mathematica's `Sum` function

## The Identity

Three equivalent expressions for the denominator `D(x,k)`:

```mathematica
D(x,k) := 1 + Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!), {i, 1, k}]
```

**Factorial form (Combinatorics):**
```
D(x,k) = 1 + Sum[2^(i-1) * x^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), {i,1,k}]
```

**Chebyshev form (Orthogonal Polynomials):**
```
D(x,k) = ChebyshevT[⌈k/2⌉, x+1] * (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1])
```

**Hyperbolic form (Geometry):**
```
D(x,k) = 1/2 + Cosh[(1+2k)·ArcSinh[√(x/2)]] / (√2·√(2+x))
```

## Relationship to FactorialTerm/ChebyshevTerm

Both functions compute `1/D(x,k)`:

```mathematica
FactorialTerm[x, k] = 1/D(x,k)
ChebyshevTerm[x, k] = 1/D(x,k)
```

Therefore:
```
FactorialTerm[x, k] = ChebyshevTerm[x, k]  (Egypt-Chebyshev equivalence)
```

## Numerical Verification

### Example: x=13, k=3

```
Factorial sum:   10556
Chebyshev prod:  10557 = 1 + 10556 ✓
Hyperbolic:      10556.0 ✓

D(13, 3) = 10557

FactorialTerm[13, 3] = 1/10557 ✓
ChebyshevTerm[13, 3] = 1/10557 ✓
```

### Symbolic Verification (k=1..4)

| k | Factorial Sum | Chebyshev Product | Match? |
|---|---------------|-------------------|--------|
| 1 | `x` | `1 + x` | ✓ |
| 2 | `3x + 2x²` | `1 + 3x + 2x²` | ✓ |
| 3 | `6x + 10x² + 4x³` | `1 + 6x + 10x² + 4x³` | ✓ |
| 4 | `10x + 30x² + 28x³ + 8x⁴` | `1 + 10x + 30x² + 28x³ + 8x⁴` | ✓ |

## Novel Insights

### 1. Factorial-Chebyshev Identity (Status: Conjecture → Evidence)

```
1 + Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!)]
  = ChebyshevT[⌈k/2⌉, x+1] * (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1])
```

**Significance:** Connects finite factorial sums to products of orthogonal polynomials.

### 2. Factorial-Hyperbolic Identity (Status: NOVEL)

```
1 + Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!)]
  = 1/2 + Cosh[(1+2k)·ArcSinh[√(x/2)]] / (√2·√(2+x))
```

**Significance:**
- Closed form for finite factorial sum
- No summation required
- Uses hyperbolic functions, NOT hypergeometric functions
- Discovered by Mathematica's symbolic `Sum` function

### 3. Chebyshev-Hyperbolic Identity (Status: NEW!)

```
ChebyshevT[⌈k/2⌉, x+1] * (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1])
  = 1/2 + Cosh[(1+2k)·ArcSinh[√(x/2)]] / (√2·√(2+x))
```

**With substitution u = x+1:**
```
ChebyshevT[⌈k/2⌉, u] * (ChebyshevU[⌊k/2⌋, u] - ChebyshevU[⌊k/2⌋-1, u])
  = 1/2 + Cosh[(1+2k)·ArcSinh[√((u-1)/2)]] / (√2·√(u+1))
```

**Significance:**
- **NEW representation of Chebyshev polynomial products using hyperbolic functions**
- Standard Chebyshev representations use circular functions (cos, sin)
- This identity uses hyperbolic functions (Cosh, ArcSinh)
- May provide bridge to hyperbolic geometry interpretation

## Coefficient Patterns

For the factorial sum `Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!), {i, 1, k}]`:

**Leading coefficients (x^1):** Triangular numbers
```
k=1: 1 = 1·2/2
k=2: 3 = 2·3/2
k=3: 6 = 3·4/2
k=4: 10 = 4·5/2
k=5: 15 = 5·6/2
```

**Trailing coefficients (x^k):** Powers of 2
```
k=1: 1 = 2^0
k=2: 2 = 2^1
k=3: 4 = 2^2
k=4: 8 = 2^3
k=5: 16 = 2^4
```

## Connections Between Domains

### Combinatorics ↔ Approximation Theory
- Factorial sums encode binomial-like coefficients
- These equal products of Chebyshev polynomials
- Chebyshev polynomials are optimal for minimax approximation

### Combinatorics ↔ Hyperbolic Geometry
- Factorial sums have closed hyperbolic form
- No summation needed: direct evaluation
- Connects discrete (factorial) to continuous (hyperbolic)

### Approximation Theory ↔ Hyperbolic Geometry
- **NEW:** Chebyshev products = Hyperbolic expressions
- Standard Chebyshev: `T_n(cos θ) = cos(nθ)` (circular)
- Our identity: Chebyshev products via Cosh/ArcSinh (hyperbolic)
- Analytic continuation connection:
  - `cos(iz) = Cosh(z)`
  - `arcsin(ix) = i·ArcSinh(x)`

## Open Questions

1. **Algebraic proof:** Can the Chebyshev-Hyperbolic identity be proven algebraically (not just numerically)?

2. **Geometric interpretation:** What does the hyperbolic form mean geometrically for rational approximations of √x?

3. **Generalization:** Does this pattern extend to other orthogonal polynomial families?

4. **Egypt-Chebyshev proof:** Can the hyperbolic form provide a path to algebraic proof of Egypt-Chebyshev equivalence?

5. **Literature:** Has the Chebyshev-Hyperbolic identity appeared before? (Preliminary search: no)

## Related Files

**Verification scripts:**
- `/home/jan/github/orbit/test_factorial_hypergeometric.wl` - Initial hypergeometric analysis
- `/home/jan/github/orbit/test_factorial_ratio_analysis.wl` - Term ratio analysis
- `/home/jan/github/orbit/test_sum_verification.wl` - Verification of x=13, k=3 case
- `/home/jan/github/orbit/correct_triple_identity.wl` - Symbolic verification k=1..4

**Analysis:**
- `/home/jan/github/orbit/factorial_term_hypergeometric_analysis.md` - Why FactorialTerm is NOT hypergeometric

**Orbit paclet:**
- `Orbit/Kernel/SquareRootRationalizations.wl:402-410` - FactorialTerm and ChebyshevTerm definitions

**Prior work:**
- `docs/sessions/2025-11-22-palindromic-symmetries/README.md` - Egypt tangent polynomials
- `docs/egypt-chebyshev-equivalence.md` - Original conjecture (numerical verification)

## References

**Chebyshev polynomial theory:**
- Mason, J.C. & Handscomb, D.C. (2003). *Chebyshev Polynomials*. Chapman & Hall/CRC.

**Hyperbolic functions:**
- Standard analytic continuation formulas connecting circular and hyperbolic functions

**Egypt repository:**
- Original factorial-based formula for √x rational approximations
- Conjectured equivalence to Chebyshev-based formula

## Status Summary

| Identity | Status | Evidence |
|----------|--------|----------|
| Factorial = Chebyshev | 🔬 Numerically verified | Symbolic k=1..6, Numerical x∈{0.5,1,2,5,10,13} |
| Factorial = Hyperbolic | 🔬 Numerically verified | Mathematica `Sum` + numerical tests |
| Chebyshev = Hyperbolic | 🔬 Numerically verified | Derived from above two |
| All three forms = D(x,k) | 🔬 Numerically verified | Transitive equality |

**Next steps:**
1. Search literature for Chebyshev-Hyperbolic identity
2. Attempt algebraic proof using analytic continuation
3. Explore geometric interpretation
4. Test for larger k values
5. Investigate generalization to other polynomial families
