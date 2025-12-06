# Cunningham Representation and Pell Equations

**Date:** December 6, 2025
**Status:** Exploratory session
**Inspired by:** [Oscar Cunningham's blog post](https://oscarcunningham.com/494/a-better-representation-for-real-numbers/)

## The Cunningham Representation

Oscar Cunningham proposes representing real numbers using the function:

```
f(x) = x/(1-x)
```

instead of the reciprocal `1/x` used in continued fractions.

For x ∈ [0,1), iterate:
1. Compute f(x) = x/(1-x)
2. Extract n = ⌊f(x)⌋
3. Update x ← f(x) - n
4. Repeat

This gives a sequence ⟨z; n₀, n₁, n₂, ...⟩ where z is the integer part.

## Key Advantages (from Cunningham)

| Property | Decimals | Continued Fractions | Cunningham |
|----------|----------|---------------------|------------|
| Uniqueness | ❌ | ❌ | ✅ |
| Order-preserving | ✅ | ❌ (alternates) | ✅ |
| Rationals | finite/periodic | finite | eventually zero |

## Our Discovery: Periodicity Preserved for √D

We tested whether Cunningham's representation preserves the periodicity of quadratic irrationals (Lagrange's theorem for CF).

### Tested: √D for D = 2, 3, 5, 7, 11, 13

| D | CF period | CF pattern | Cunningham period | Cunningham pattern |
|---|-----------|------------|-------------------|-------------------|
| 2 | 1 | [2̄] | 2 | {0,2} |
| 3 | 2 | [1,2̄] | 1 | {2} |
| 5 | 1 | [4̄] | 4 | {0,0,0,4} |
| 7 | 4 | [1,1,1,4̄] | 2 | {1,4} |
| 11 | 2 | [3,6̄] | 3 | {0,0,6} |
| 13 | 5 | [1,1,1,1,6̄] | 10 | {1,1,0,0,0,0,0,1,1,6} |

**Result: Cunningham representation IS periodic for all tested √D!**

The relationship between CF and Cunningham periods is non-trivial:
- Sometimes Cunningham is shorter (√3: 2→1, √7: 4→2)
- Sometimes Cunningham is longer (√5: 1→4, √13: 5→10)
- The "6" from CF appears preserved in Cunningham for √11, √13

## Connection to Pell Equation and Egyptian Fractions

For √13, the Pell equation x² - 13y² = 1 has fundamental solution (649, 180).

### What Cunningham gives directly

| k | Cunningham convergent | p² - 13q² |
|---|----------------------|-----------|
| 2 | **18/5** | **-1** |
| 12 | 23382/6485 | -1 |

Cunningham gives **quasi-solutions** (p² - Dq² = -1) directly, not the fundamental +1 solution.

### Key Discovery: Egyptian Connection

The ratio **18/5 = (649-1)/180 = (x-1)/y** is exactly what the Egyptian fraction formula needs!

| Representation | Direct output | Egyptian formula needs |
|----------------|--------------|------------------------|
| CF | 649/180 (fundamental) | Must compute (649-1)/180 |
| **Cunningham** | **18/5 directly!** | **18/5** ✓ |

This suggests Cunningham's representation may be more natural for Egyptian fraction expansions of √D than continued fractions.

### Deriving +1 from -1

From (a, b) with a² - Db² = -1, the +1 solution is:
```
x = a² + Db²
y = 2ab
```
For 18/5: x = 18² + 13·5² = 324 + 325 = 649, y = 2·18·5 = 180. ✓

## Comparison to Wildberger's Approach

Norman Wildberger advocates "algorithmic" definitions of real numbers as paths in the Stern-Brocot tree, avoiding completed infinities.

| | Stern-Brocot | Cunningham |
|--|--------------|------------|
| Steps | L/R (binary) | ℕ (count before change) |
| Order | Problematic | Preserved |
| √D periodic | ✅ | ✅ (longer period) |

Both are "algorithmic" in spirit — a real number is a rule/algorithm, not a completed infinite object.

## Next Steps

- [ ] Verify periodicity for other √D
- [ ] Find relationship between CF period and Cunningham period
- [ ] Explore if Cunningham convergents solve Pell
- [ ] Compare computational efficiency

## References

- Cunningham, O. "A Better Representation for Real Numbers" https://oscarcunningham.com/494/
- Wildberger, N.J. Various lectures on rational trigonometry and Stern-Brocot tree
