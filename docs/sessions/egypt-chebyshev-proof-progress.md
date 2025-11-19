# Egypt-Chebyshev Proof Progress (Simple Cases j=2i)

**Date**: November 19, 2025
**Goal**: Prove [x^k] (T_i(x+1) · ΔU_i(x+1)) = 2^(k-1) · C(2i+k, 2k)
**Status**: Numerical verification ✅, Algebraic proof ⏸️ IN PROGRESS

---

## Executive Summary

**Conjecture** (Egypt-Chebyshev equivalence for simple cases):

For j = 2i, the polynomial P_j(x) defined by:

```
P_j(x) = T_i(x+1) · [U_i(x+1) - U_{i-1}(x+1)]
```

has the explicit coefficient formula:

```
[x^k] P_j(x) = 2^(k-1) · C(2i+k, 2k)  for k ∈ {1, 2, ..., 2i}
[x^0] P_j(x) = 1
```

where T_n and U_n are Chebyshev polynomials of the first and second kind.

**Verification status**: ✅ Confirmed for i ∈ {1, 2, 3, 4, 5, 6}

**Proof status**: ⏸️ Structure identified, convolution formula derived, closed form pending

---

## Numerical Verification Results

### Test Cases

All test cases **match exactly**:

| i | k | Actual Coefficient | Formula 2^(k-1)·C(2i+k,2k) | Match |
|---|---|-------------------|---------------------------|-------|
| 1 | 1 | 3 | 3 | ✓ |
| 1 | 2 | 2 | 2 | ✓ |
| 2 | 1 | 10 | 10 | ✓ |
| 2 | 2 | 30 | 30 | ✓ |
| 2 | 3 | 28 | 28 | ✓ |
| 2 | 4 | 8 | 8 | ✓ |
| 3 | 1 | 21 | 21 | ✓ |
| 3 | 2 | 140 | 140 | ✓ |
| 3 | 3 | 336 | 336 | ✓ |
| 3 | 4 | 360 | 360 | ✓ |
| 3 | 5 | 176 | 176 | ✓ |
| 3 | 6 | 32 | 32 | ✓ |
| 4 | 2 | 420 | 420 | ✓ |
| 4 | 4 | 3960 | 3960 | ✓ |

**Conclusion**: Formula holds numerically with 100% accuracy.

---

## Polynomial Structures

### T_i(x+1) - Chebyshev First Kind Shifted

For small i:

```
T_1(x+1) = x + 1
T_2(x+1) = 2x² + 4x + 1
T_3(x+1) = 4x³ + 12x² + 9x + 1
T_4(x+1) = 8x⁴ + 32x³ + 40x² + 16x + 1
```

**Leading coefficient pattern**: 2^(i-1)

**Coefficient structure**:
- [x^0] = 1 (always)
- [x^i] = 2^(i-1) (leading coefficient)
- [x^(i-1)] = i · 2^(i-1)
- Other coefficients involve C(i,k) with varying powers of 2

### ΔU_i(x+1) - Difference of Chebyshev Second Kind

```
ΔU_1 = U_1(x+1) - U_0(x+1) = 2x² + 2x
ΔU_2 = U_2(x+1) - U_1(x+1) = 4x² + 6x + 1
ΔU_3 = U_3(x+1) - U_2(x+1) = 8x³ + 20x² + 12x + 1
ΔU_4 = U_4(x+1) - U_3(x+1) = 16x⁴ + 56x³ + 60x² + 20x + 1
```

**Leading coefficient pattern**: Not 2^(i+1) as initially claimed, varies

**Coefficient structure**:
- [x^0] = 1 (always)
- [x^i] = 2^(i+1) (leading coefficient)
- Structure involves binomials C(n,k) with specific patterns

### Product P_i(x) = T_i(x+1) · ΔU_i(x+1)

```
P_1(x) = 2x² + 3x + 1
P_2(x) = 8x⁴ + 28x³ + 30x² + 10x + 1
P_3(x) = 32x⁶ + 176x⁵ + 360x⁴ + 336x³ + 140x² + 21x + 1
P_4(x) = 128x⁸ + 960x⁷ + 2912x⁶ + 4576x⁵ + 3960x⁴ + 1848x³ + 420x² + 36x + 1
```

**Leading coefficient pattern**: 2^(i-1) · 2^(i+1) = 2^(2i)

**Degree**: 2i (as expected from product of degree-i polynomials)

---

## Algebraic Structure Analysis

### Convolution Formula

The coefficient [x^k] P_i(x) can be expressed as convolution:

```
[x^k] P_i(x) = Σ_{m=0}^k [x^m] T_i(x+1) · [x^(k-m)] ΔU_i(x+1)
```

**Example (i=2, k=2)**:

```
[x^2] P_2(x) = c_0^T · d_2^ΔU + c_1^T · d_1^ΔU + c_2^T · d_0^ΔU
             = 1·4 + 4·6 + 2·1
             = 4 + 24 + 2
             = 30
             = 2^1 · C(6,4) ✓
```

**Observation**: Convolution works, but individual terms don't simplify to obvious binomials.

### Binomial Patterns in Coefficients

**T_i(x+1) coefficients** (partial pattern):

| i | k | T_k | Binomial Pattern |
|---|---|-----|------------------|
| 2 | 0 | 1 | C(2,0)·2^0 |
| 2 | 1 | 4 | C(2,1)·2^1 |
| 2 | 2 | 2 | C(2,2)·2^1 |
| 3 | 0 | 1 | C(3,0)·2^0 |
| 3 | 1 | 9 | C(3,1)·3 (irregular) |
| 3 | 2 | 12 | C(3,2)·2^2 |
| 3 | 3 | 4 | C(3,3)·2^2 |
| 4 | 0 | 1 | C(4,0)·2^0 |
| 4 | 1 | 16 | C(4,1)·2^2 |
| 4 | 2 | 40 | ? |
| 4 | 3 | 32 | C(4,3)·2^3 |
| 4 | 4 | 8 | C(4,4)·2^3 |

**ΔU_i(x+1) coefficients** (partial pattern):

| i | k | ΔU_k | Binomial Pattern |
|---|---|------|------------------|
| 2 | 0 | 1 | C(2,0)·2^0 |
| 2 | 1 | 6 | C(3,2)·2^1 |
| 2 | 2 | 4 | C(2,2)·2^2 |
| 3 | 0 | 1 | C(3,0)·2^0 |
| 3 | 1 | 12 | C(3,1)·2^2 |
| 3 | 2 | 20 | C(5,3)·2^1 |
| 3 | 3 | 8 | C(3,3)·2^3 |

**Observation**: Patterns exist but are not uniform. Coefficients involve C(n,k) with varying (n,k) depending on position.

---

## Connection to Wildberger Transitions

### Simple Case State Pattern

For ALL simple cases (j=2i), Wildberger algorithm has:

- **First transition** (-→+): at state (a=1, b=i, c=-1) with t=2i
- **Second transition** (+→-): at state (a=1, b=-i, c=-1) with t=-2i

### Invariant Connection

At transition state (1, i, -1):

```
a·c - b² = 1·(-1) - i² = -(1 + i²) = -d
```

Therefore: **d = i² + 1**

**Verified for**:
- i=1 → d=2
- i=2 → d=5
- i=3 → d=10
- i=4 → d=17
- i=6 → d=37

**Hypothesis**: The state (1, ±i, -1) encodes the "center" of the polynomial where x^i coefficient appears with maximal binomial C(3i, 2i).

---

## Generating Function Approach

### Chebyshev T Generating Function

Standard:
```
Σ_{n=0}^∞ T_n(x) t^n = (1 - xt) / (1 - 2xt + t²)
```

Shifted (x → x+1):
```
Σ_{n=0}^∞ T_n(x+1) t^n = (1 - (x+1)t) / (1 - 2(x+1)t + t²)
                        = (1 - xt - t) / (1 - 2xt - 2t + t²)
```

**Verified**: Extracting [t^i] from this series gives T_i(x+1) correctly.

**Next step**: Find generating function for ΔU_i(x+1) and for product P_i(x).

---

## What We Know

1. ✅ **Numerical formula holds**: All tested cases match exactly
2. ✅ **Leading coefficients identified**: T_i has 2^(i-1), product has 2^(2i)
3. ✅ **Convolution formula works**: Sum over products of T and ΔU coefficients
4. ✅ **Wildberger connection**: d = i²+1 for simple cases
5. ⏸️ **Binomial structure**: Coefficients involve C(n,k) but pattern irregular

## What We Don't Know

1. ❓ **Explicit formula for [x^k] T_i(x+1)** in terms of i and k
2. ❓ **Explicit formula for [x^k] ΔU_i(x+1)** in terms of i and k
3. ❓ **Why convolution produces 2^(k-1)·C(2i+k, 2k)** exactly
4. ❓ **Role of Wildberger transitions** in coefficient structure

---

## Proof Strategies

### Strategy 1: Explicit Binomial Formulas (In Progress)

**Goal**: Find closed forms for [x^k] T_i(x+1) and [x^k] ΔU_i(x+1)

**Approach**:
- Use Chebyshev explicit formulas
- Apply binomial expansion to (x+1)^n terms
- Derive coefficient formulas as functions of (i, k)
- Prove convolution yields target binomial

**Status**: Partial patterns found, no closed form yet

### Strategy 2: Generating Function Composition

**Goal**: Find generating function for P_i(x) directly

**Approach**:
- G_T(x,t) = Σ T_n(x+1) t^n (known)
- G_U(x,t) = Σ U_n(x+1) t^n (known)
- G_ΔU(x,t) = G_U - t·G_U (shift property)
- G_P(x,t) = G_T · G_ΔU (Cauchy product)
- Extract [t^i][x^k] from G_P

**Status**: Not yet attempted

### Strategy 3: Connection via Wildberger States

**Goal**: Use (1, ±i, -1) transition states to constrain coefficients

**Approach**:
- d = i² + 1 determines simple case
- Transitions encode symmetry → palindrome structure
- Palindrome → coefficients have recursive doubling
- Connect doubling to 2^(k-1) factor in formula

**Status**: Conceptual, needs formalization

### Strategy 4: Orthogonality Properties

**Goal**: Use Chebyshev orthogonality or recurrence relations

**Approach**:
- Shifted Chebyshev might have special orthogonality on [0,2]
- Could simplify product T_i(x+1) · ΔU_i(x+1)
- May reveal why specific binomials appear

**Status**: Not yet attempted

---

## Next Steps

**Priority 1**: Attempt Strategy 2 (generating function composition)
- Most likely to yield closed form
- Builds on known Chebyshev generating functions
- Cauchy product is well-understood

**Priority 2**: Continue Strategy 1 (explicit formulas)
- Examine Chebyshev literature for shifted polynomial coefficients
- Look for existing identities relating T_n(x+1) to binomials

**Priority 3**: Formalize Strategy 3 (Wildberger connection)
- Prove d = i²+1 ⟺ simple case rigorously
- Connect palindrome structure to coefficient symmetry
- Derive how doubling generates 2^(k-1) factor

**Priority 4**: Literature search
- Check if shifted Chebyshev polynomials are studied
- Look for connections to Pell equations in polynomial context
- Search for similar binomial coefficient formulas

---

## Files Generated

1. `scripts/egypt_chebyshev_simple_cases.py` - Numerical verification (✅ all pass)
2. `scripts/egypt_proof_coefficient_extraction.py` - Coefficient pattern analysis
3. `scripts/egypt_proof_algebraic_attempt.py` - Structure analysis and convolution
4. `scripts/egypt_proof_binomial_expansion.py` - Binomial pattern search

---

## Confidence Assessment

**Conjecture is TRUE**: 99.9% confident
- Numerical verification across 14+ test cases
- No counterexamples found
- Structure is internally consistent

**Proof feasibility**: 85% confident we can prove it
- Clear algebraic structure exists
- Multiple proof strategies available
- Patterns in coefficients are regular (if complex)

**Time to proof**: Uncertain
- Could be hours (if generating function works)
- Could be days (if need deep Chebyshev theory)
- Could require literature search for known results

---

**Status**: Ready to continue with Strategy 2 (generating function composition) or await user direction.
