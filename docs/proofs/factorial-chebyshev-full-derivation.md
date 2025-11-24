# Full Algebraic Proof: Factorial = Chebyshev

**Date:** 2025-11-24
**Method:** Explicit binomial expansion and coefficient matching
**Status:** 🚧 SYSTEMATIC DERIVATION IN PROGRESS

---

## Theorem Statement

For any k ≥ 1:

```
1 + Σ[i=1 to k] 2^(i-1) · x^i · (k+i)! / ((k-i)! · (2i)!)
= T[⌈k/2⌉, x+1] · (U[⌊k/2⌋, x+1] - U[⌊k/2⌋-1, x+1])
```

---

## Proof Strategy

**Method**: Direct coefficient extraction using binomial theorem

### Key Steps:

1. **Express T_n(y) coefficients** using M&H formula
2. **Express U_m(y) coefficients** using MathWorld formula
3. **Expand (x+1)^p** via binomial theorem
4. **Compute T_n(x+1) coefficients** via convolution
5. **Compute ΔU_m(x+1) coefficients** via convolution
6. **Compute product coefficients** via second convolution
7. **Match with factorial formula** algebraically

---

## Part 1: Chebyshev Coefficient Formulas

### T_n(y) de Moivre Form

**Source**: Wikipedia, de Moivre's formula (standard textbook derivation)

**Derivation**: From `cos(nθ) = Re[(cos θ + i sin θ)^n]`, substitute `y = cos θ`, expand binomially, extract real part.

```
T_n(y) = Σ[j=0 to ⌊n/2⌋] binomial(n, 2j) · (y^2 - 1)^j · y^(n-2j)
```

**Coefficient of y^p** (where p = n-2j):
```
c_j^(n) = binomial(n, 2j) · coefficient of y^p in (y^2-1)^j
```

**Note**: For n=0, T_0(y) = 1 (special case)

### U_n(y) de Moivre Form

**Source**: Wikipedia, similar derivation from complex exponential

```
U_n(y) = Σ[k=0 to ⌊n/2⌋] binomial(n+1, 2k+1) · (y^2 - 1)^k · y^(n-2k)
```

**Coefficient of y^p** (where p = n-2k):
```
d_k^(n) = binomial(n+1, 2k+1) · coefficient of y^p in (y^2-1)^k
```

**Note**: For n=-1, U_{-1}(y) = 0 (by convention)

**References**:
- Cody, W.J. (1970). "A survey of practical rational and polynomial approximation of functions". SIAM Review. 12(3): 400–423. doi:10.1137/1012082
- Mathar, Richard J. (2006). "Chebyshev series expansion of inverse polynomials". Journal of Computational and Applied Mathematics. 196(2): 596–607. arXiv:math/0403344
- Wikipedia Chebyshev polynomials article (de Moivre derivation)

**Verification script**: `scripts/experiments/demoivre_formulas_final.wl` (verified n=0..5, all MATCH)

---

## Part 2: Shift to (x+1) Argument

### Binomial Theorem

```
(x+1)^p = Σ[s=0 to p] binomial(p, s) · x^s
```

### T_n(x+1) Coefficient Extraction

Starting point:
```
T_n(x+1) = Σ[j=0 to ⌊n/2⌋] c_j^(n) · (x+1)^(n-2j)
```

Expand (x+1)^(n-2j):
```
(x+1)^(n-2j) = Σ[s=0 to n-2j] binomial(n-2j, s) · x^s
```

Therefore:
```
T_n(x+1) = Σ[j=0 to ⌊n/2⌋] c_j^(n) · Σ[s=0 to n-2j] binomial(n-2j, s) · x^s
```

**Coefficient of x^i** in T_n(x+1):
```
[x^i] T_n(x+1) = Σ[j: i ≤ n-2j] c_j^(n) · binomial(n-2j, i)
```

Since i ≤ n-2j ⟺ j ≤ (n-i)/2:
```
[x^i] T_n(x+1) = Σ[j=0 to ⌊(n-i)/2⌋] c_j^(n) · binomial(n-2j, i)
```

Substituting c_j^(n):
```
[x^i] T_n(x+1) = Σ[j=0 to ⌊(n-i)/2⌋] (-1)^j · 2^(n-2j-1) · binomial(n, n-j) / binomial(n-j, j) · binomial(n-2j, i)
```

---

## Part 3: U_m(x+1) Coefficient Extraction

Similarly for U_m(x+1):
```
U_m(x+1) = Σ[r=0 to ⌊m/2⌋] d_r^(m) · (x+1)^(m-2r)
```

**Coefficient of x^i** in U_m(x+1):
```
[x^i] U_m(x+1) = Σ[r=0 to ⌊(m-i)/2⌋] (-1)^r · binomial(m-r, r) · 2^(m-2r) · binomial(m-2r, i)
```

---

## Part 4: ΔU_m = U_m - U_{m-1} Coefficients

```
[x^i] ΔU_m(x+1) = [x^i] U_m(x+1) - [x^i] U_{m-1}(x+1)
```

```
= Σ[r=0 to ⌊(m-i)/2⌋] (-1)^r · binomial(m-r, r) · 2^(m-2r) · binomial(m-2r, i)
  - Σ[r=0 to ⌊(m-1-i)/2⌋] (-1)^r · binomial(m-1-r, r) · 2^(m-1-2r) · binomial(m-1-2r, i)
```

**This is the key expression we need to work with.**

---

## Part 5: Product T_n(x+1) · ΔU_m(x+1)

By convolution:
```
[x^i] [T_n(x+1) · ΔU_m(x+1)] = Σ[ℓ=0 to i] ([x^ℓ] T_n(x+1)) · ([x^(i-ℓ)] ΔU_m(x+1))
```

This is:
```
Σ[ℓ=0 to i]
  [Σ[j=0 to ⌊(n-ℓ)/2⌋] (-1)^j · 2^(n-2j-1) · binomial(n, n-j) / binomial(n-j, j) · binomial(n-2j, ℓ)]
  ·
  [expression for ΔU_m coefficient of x^(i-ℓ)]
```

---

## Part 6: Computational Approach for Simplification

The above expressions are **correct but extremely complex** to simplify by hand.

**Strategy**: Use symbolic computation to:
1. Verify formula produces correct coefficients for k=1..10
2. Establish pattern
3. Use Gosper/Zeilberger if needed to prove binomial identity

Let me create systematic verification script...

---

**Status**: Framework established. Next: systematic symbolic computation.
