# Algebraic Proof: Factorial ↔ Chebyshev

**Date:** 2025-11-24
**Method:** Explicit coefficient extraction and matching
**Status:** 🚧 IN PROGRESS

---

## Theorem

For any k ≥ 1 and x ≥ 0:

```
D_fact(x,k) = 1 + Σ[i=1 to k] 2^(i-1) · x^i · (k+i)! / ((k-i)! · (2i)!)
            = T[⌈k/2⌉, x+1] · (U[⌊k/2⌋, x+1] - U[⌊k/2⌋-1, x+1])
            = D_cheb(x,k)
```

---

## Proof Strategy

Show that both sides produce identical polynomial coefficients by:
1. Extract explicit coefficient formulas for T_n(y) and U_n(y)
2. Shift argument: y = x+1, compute coefficients of x^i
3. Compute product [T_n(x+1)] · [U_m(x+1) - U_{m-1}(x+1)]
4. Match with factorial coefficient: 2^(i-1) · (k+i)! / ((k-i)! · (2i)!)

---

## Step 1: Chebyshev Coefficient Formulas

### T_n(y) Coefficients

**Source**: Mason & Handscomb, equation (2.18)

For T_n(y) = Σ c_j^(n) · y^(n-2j), the coefficient of y^(n-2j) is:

```
c_j^(n) = (-1)^j · 2^(n-2j-1) · binomial(n, n-j) / binomial(n-j, j)
```

Simplified:
```
c_j^(n) = (-1)^j · 2^(n-2j-1) · n! / [(n-j)! · j! · (n-2j)!] · (n-2j)! · j! / (n-j)!
        = (-1)^j · 2^(n-2j-1) · n! · (n-2j)! / [(n-j)!]^2
```

### U_n(y) Coefficients

**Source**: Wolfram MathWorld

For U_n(y) = Σ[r=0 to ⌊n/2⌋] (-1)^r · binomial(n-r, r) · (2y)^(n-2r)

The coefficient of y^j is (where j = n-2r):
```
coefficient of y^j in U_n(y) = (-1)^((n-j)/2) · binomial((n+j)/2, (n-j)/2) · 2^j
```

---

## Step 2: Shift to x+1 Argument

We need coefficients of T_n(x+1) and U_m(x+1) as polynomials in x.

### Binomial Expansion

```
(x+1)^p = Σ[s=0 to p] binomial(p, s) · x^s
```

### T_n(x+1) Expansion

```
T_n(x+1) = Σ[j=0 to ⌊n/2⌋] c_j^(n) · (x+1)^(n-2j)
         = Σ[j] c_j^(n) · Σ[s] binomial(n-2j, s) · x^s
```

Coefficient of x^i in T_n(x+1):
```
[x^i] T_n(x+1) = Σ[j: i ≤ n-2j] c_j^(n) · binomial(n-2j, i)
```

### U_m(x+1) Expansion

Similarly:
```
[x^i] U_m(x+1) = Σ[r: i ≤ m-2r] (-1)^r · binomial(m-r, r) · 2^(m-2r) · binomial(m-2r, i)
```

---

## Step 3: Coefficient Analysis for Specific Cases

Let's verify for k=1, k=2 explicitly to see the pattern.

### Case k=1: n=1, m=0

```
T_1(x+1) = x+1
U_0(x+1) = 1
U_{-1}(x+1) = 0 (by convention)
```

Product:
```
T_1(x+1) · [U_0(x+1) - U_{-1}(x+1)] = (x+1) · 1 = x + 1
```

Factorial form:
```
1 + Σ[i=1 to 1] 2^(i-1) · x^i · (1+i)! / ((1-i)! · (2i)!)
= 1 + 2^0 · x · 2! / (0! · 2!)
= 1 + x
```

✓ Match!

### Case k=2: n=1, m=1

```
T_1(x+1) = x+1
U_1(x+1) = 2(x+1) = 2x + 2
U_0(x+1) = 1
```

Product:
```
(x+1) · [(2x+2) - 1] = (x+1)(2x+1) = 2x^2 + 3x + 1
```

Factorial form:
```
1 + Σ[i=1 to 2] 2^(i-1) · x^i · (2+i)! / ((2-i)! · (2i)!)
= 1 + 2^0 · x · 3! / (1! · 2!) + 2^1 · x^2 · 4! / (0! · 4!)
= 1 + x · 6/2 + 2 · x^2 · 24/24
= 1 + 3x + 2x^2
```

✓ Match!

### Case k=3: n=2, m=1

```
T_2(x+1) = 2(x+1)^2 - 1 = 2x^2 + 4x + 1
U_1(x+1) = 2x + 2
U_0(x+1) = 1
```

Product:
```
(2x^2 + 4x + 1) · (2x + 1)
= 4x^3 + 2x^2 + 8x^2 + 4x + 2x + 1
= 4x^3 + 10x^2 + 6x + 1
```

Factorial form:
```
1 + Σ[i=1 to 3] 2^(i-1) · x^i · (3+i)! / ((3-i)! · (2i)!)
= 1 + x · 4!/(2!·2!) + 2x^2 · 5!/(1!·4!) + 4x^3 · 6!/(0!·6!)
= 1 + x · 24/4 + 2x^2 · 120/24 + 4x^3 · 720/720
= 1 + 6x + 10x^2 + 4x^3
```

✓ Match!

---

## Step 4: General Pattern Identification

From the specific cases, we observe:

**Coefficient of x^i in factorial form:**
```
a_i = 2^(i-1) · (k+i)! / ((k-i)! · (2i)!)
```

**Coefficient of x^i in Chebyshev product:**
Must equal a_i for all i ∈ {1, 2, ..., k}

---

## Step 5: General Proof Approach

To prove the general case, we need to show:

```
[x^i] [T_n(x+1) · (U_m(x+1) - U_{m-1}(x+1))] = 2^(i-1) · (k+i)! / ((k-i)! · (2i)!)
```

where n = ⌈k/2⌉, m = ⌊k/2⌋.

### Method: Convolution

The coefficient of x^i in a product P(x) · Q(x) is:
```
[x^i] [P(x) · Q(x)] = Σ[j=0 to i] ([x^j] P(x)) · ([x^(i-j)] Q(x))
```

### Challenge

This requires:
1. Computing binomial sums for T_n(x+1) coefficients
2. Computing U_m(x+1) - U_{m-1}(x+1) coefficients
3. Performing convolution
4. Simplifying to factorial form

This is algebraically intensive but mechanically straightforward.

---

## Step 6: Alternative Approach - Induction

**Base case**: Verified for k=1,2,3 above ✓

**Inductive step**: Show if true for k-1, then true for k

This would require:
- Factorial form recurrence relation
- Chebyshev form recurrence relation
- Showing they are compatible

**Challenge**: Factorial form doesn't have obvious recurrence in k.

---

## Step 7: Computational Verification as Bridge

Since direct algebraic proof is lengthy, we establish:

**Computational verification**: Coefficients match perfectly for k=1..200 ✓

**Algebraic framework**: Formulas exist (M&H, MathWorld) ✓

**Specific cases**: Hand-verified for k=1,2,3 ✓

**Conclusion**: The identity holds. Full expansion requires significant binomial algebra but is mechanically executable.

---

## Status

**Proven for**: k=1,2,3 (explicit hand calculation)

**Verified for**: k=1..200 (computational)

**Path to general proof**: Established (coefficient extraction + convolution)

**Estimated effort for full proof**: 4-8 hours of systematic binomial expansion

---

## References

**Coefficient formulas**:
- T_n: Mason & Handscomb, equation (2.18)
- U_n: Wolfram MathWorld

**Verification**:
- `scripts/experiments/chebyshev_to_factorial_backward.wl`
- `scripts/experiments/coefficient_pattern_analysis.wl`

---

**Next steps** (if pursuing full proof):
1. Derive general formula for [x^i] T_n(x+1)
2. Derive general formula for [x^i] [U_m(x+1) - U_{m-1}(x+1)]
3. Compute convolution
4. Simplify to match factorial form
5. Prove equality using binomial identities

**Last updated**: 2025-11-24
