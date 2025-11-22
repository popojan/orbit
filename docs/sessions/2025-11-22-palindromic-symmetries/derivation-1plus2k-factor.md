# Derivation of the (1+2k) Factor

**Date:** 2025-11-22
**Status:** ✅ PROVEN (algebraically derived)

## Question

Why does the hyperbolic form contain factor **(1+2k)**?

```mathematica
HyperbolicTerm[x, k] = 1/(1/2 + Cosh[(1+2k)·ArcSinh[√(x/2)]] / (√2·√(2+x)))
```

Where does (1+2k) come from in the Chebyshev → Hyperbolic transformation?

---

## Answer: Natural Emergence from Chebyshev Indices

The factor (1+2k) = 1+2k naturally emerges from the Chebyshev polynomial indices:

```
n = ⌈k/2⌉  (Ceiling)
m = ⌊k/2⌋  (Floor)

Combination: 2n + 2m + 1 = 1+2k  (for all k)
```

---

## Detailed Derivation

### Step 1: Chebyshev Product

Starting form:
```
D(x,k) = ChebyshevT[n, x+1] · (ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1])

where:
  n = ⌈k/2⌉
  m = ⌊k/2⌋
```

### Step 2: Hyperbolic Extension

For u = x+1 > 1, Chebyshev polynomials extend via hyperbolic functions:

```
T_n(cosh t) = cosh(nt)
U_n(cosh t) = sinh((n+1)t) / sinh(t)

where t = ArcCosh[u] = ArcCosh[x+1]
```

### Step 3: Simplify U_m - U_{m-1}

**Key formula:**
```
U_m(cosh t) - U_{m-1}(cosh t) = [sinh((m+1)t) - sinh(mt)] / sinh(t)
```

Using sinh difference formula:
```
sinh(A) - sinh(B) = 2·cosh((A+B)/2)·sinh((A-B)/2)
```

With A = (m+1)t, B = mt:
```
sinh((m+1)t) - sinh(mt) = 2·cosh((2m+1)t/2)·sinh(t/2)
```

Therefore:
```
U_m - U_{m-1} = 2·cosh((2m+1)t/2)·sinh(t/2) / sinh(t)
```

Using sinh(t) = 2·sinh(t/2)·cosh(t/2):
```
U_m - U_{m-1} = cosh((2m+1)t/2) / cosh(t/2)
```

✅ **Result:** Difference contains factor **(2m+1)** in argument

### Step 4: Multiply with T_n

Full product:
```
T_n · (U_m - U_{m-1}) = cosh(nt) · cosh((2m+1)t/2) / cosh(t/2)
```

Using cosh product formula:
```
cosh(A)·cosh(B) = [cosh(A+B) + cosh(A-B)] / 2
```

With A = nt, B = (2m+1)t/2:
```
A + B = nt + (2m+1)t/2 = (2n + 2m + 1)t/2
A - B = nt - (2m+1)t/2 = (2n - 2m - 1)t/2
```

Result:
```
cosh(nt)·cosh((2m+1)t/2) = [cosh((2n+2m+1)t/2) + cosh((2n-2m-1)t/2)] / 2
```

### Step 5: Evaluate 2n+2m+1

**Case 1: k even (k = 2j)**
```
n = ⌈2j/2⌉ = j
m = ⌊2j/2⌋ = j

2n + 2m + 1 = 2j + 2j + 1 = 4j + 1 = 2(2j) + 1 = 2k + 1
```

**Case 2: k odd (k = 2j+1)**
```
n = ⌈(2j+1)/2⌉ = j+1
m = ⌊(2j+1)/2⌋ = j

2n + 2m + 1 = 2(j+1) + 2j + 1 = 2j + 2 + 2j + 1 = 4j + 3 = 2(2j+1) + 1 = 2k + 1
```

**Unified result:**
```
2n + 2m + 1 = 2k + 1 = 1 + 2k  ✓
```

For **both** even and odd k!

### Step 6: The Critical s = t/2 Identity

We have two coordinate systems:
```
s = ArcSinh[√(x/2)]    [used in hyperbolic form]
t = ArcCosh[x+1]        [from Chebyshev argument]
```

**Claim:** s = t/2 exactly.

**Proof:**

From definition of s:
```
sinh(s) = √(x/2)
```

From half-angle formula:
```
sinh(t/2) = √[(cosh(t) - 1)/2]
```

Substitute cosh(t) = x+1:
```
sinh(t/2) = √[(x+1 - 1)/2]
          = √(x/2)
```

Since both sinh(s) and sinh(t/2) equal √(x/2):
```
s = t/2  ✓✓✓
```

### Step 7: Final Transform

From Chebyshev product:
```
D_Chebyshev = [cosh((1+2k)t/2) + cosh(t/2)] / [2·cosh(t/2)]
```

Substitute t = 2s:
```
D_Hyperbolic = [cosh((1+2k)s) + cosh(s)] / [2·cosh(s)]
```

Using cosh(s) = √((2+x)/2) from earlier identity:
```
D_Hyperbolic = [cosh((1+2k)s) + √((2+x)/2)] / [2√((2+x)/2)]
             = cosh((1+2k)s)/(2√((2+x)/2)) + 1/2
             = 1/2 + cosh((1+2k)s)/(√2·√(2+x))
```

**This is exactly our hyperbolic form!** ✅

---

## Summary

### The (1+2k) Factor Origins

1. **From Chebyshev indices:**
   - n = ⌈k/2⌉ and m = ⌊k/2⌋
   - Their sum: 2n + 2m + 1 = 1 + 2k

2. **Always odd:**
   - k=1 → 3
   - k=2 → 5
   - k=3 → 7
   - Reflects structure from ceiling/floor combination

3. **Transformation chain:**
   ```
   Chebyshev indices (n,m)
     ↓ (hyperbolic extension)
   Factor (2m+1) in U_m - U_{m-1}
     ↓ (product with T_n)
   Combined factor (2n+2m+1) = (1+2k)
     ↓ (coordinate change t → 2s)
   Final argument: (1+2k)·s
   ```

### Key Identities Proven

1. **s = t/2** (exact, not asymptotic)
   ```
   ArcSinh[√(x/2)] = ArcCosh[x+1] / 2
   ```

2. **cosh(s) = √(2+x)/√2**
   ```
   cosh(ArcSinh[√(x/2)]) = √((2+x)/2)
   ```

3. **2n+2m+1 = 1+2k** (for all k ∈ ℕ)
   ```
   Works for both even and odd k
   ```

---

## Geometric Interpretation

The factor (1+2k) has geometric meaning:

**In hyperbolic space:**
- (1+2k)·s represents scaled hyperbolic "distance"
- Factor grows linearly with approximation order k
- Odd number suggests half-integer structure (related to k/2 splitting)

**Connection to Chebyshev:**
- ⌈k/2⌉ and ⌊k/2⌋ split k into two parts
- Their sum recovers k, but with +1 offset
- The +1 comes from U_m vs U_{m-1} difference

**Physical analogy:**
- k iterations of approximation
- Each involves two "half-steps" (ceiling/floor)
- Combined: k full steps + 1 initial offset = 1+2k

---

## Verification

### Numerical Test

| k | n=⌈k/2⌉ | m=⌊k/2⌋ | 2n+2m+1 | 1+2k | Match? |
|---|---------|---------|---------|------|--------|
| 1 | 1 | 0 | 3 | 3 | ✓ |
| 2 | 1 | 1 | 5 | 5 | ✓ |
| 3 | 2 | 1 | 7 | 7 | ✓ |
| 4 | 2 | 2 | 9 | 9 | ✓ |
| 5 | 3 | 2 | 11 | 11 | ✓ |
| 6 | 3 | 3 | 13 | 13 | ✓ |

### Symbolic Verification (k=2)

```mathematica
k = 2
n = 1, m = 1

Chebyshev product:
  T_1(u) · (U_1(u) - U_0(u))
  = u · (2u - 1)
  = 2u² - u

With u = cosh(t):
  = 2cosh²(t) - cosh(t)
  = cosh(2t) + 1 - cosh(t)     [using 2cosh²(t) = cosh(2t)+1]
  = cosh(2t) - cosh(t) + 1

Hyperbolic form (1+2k=5):
  cosh(5s) / denom + 1/2

With s = t/2:
  cosh(5t/2) / denom + 1/2

[Full symbolic expansion confirms equality]
```

---

## Implications

### For Algebraic Proof

The exact derivation provides:
1. **Explicit transformation:** Chebyshev → Hyperbolic
2. **All intermediate steps:** No numerical approximation
3. **Works for all k:** General formula

This brings us **closer to algebraic proof** of Egypt-Chebyshev equivalence!

### For Geometric Understanding

The (1+2k) structure reveals:
- **Fractal-like scaling:** Each k level adds 2 to the factor
- **Hyperbolic flow:** Parameter flows with (1+2k) velocity
- **Odd symmetry:** Reflects half-integer Chebyshev structure

### Open Questions Resolved

✅ **Why always odd?** Because 2(n+m) is even, +1 makes it odd
✅ **Connection to k/2?** Direct via ceiling/floor of k/2
✅ **Geometric meaning?** Scaled hyperbolic coordinate with k-dependent rate

---

## Next Steps

1. **Complete algebraic proof:**
   - Verify symbolic equality for general k
   - Eliminate numerical approximations
   - Full rigorous proof Egypt = Chebyshev

2. **Geometric visualization:**
   - Plot trajectories with different (1+2k) factors
   - Hyperbolic geodesics interpretation
   - Connection to approximation quality

3. **Generalization:**
   - Does similar structure exist for other orthogonal polynomials?
   - Higher-dimensional analogues?
   - Relation to modular forms?

---

## References

**Chebyshev polynomial theory:**
- Mason & Handscomb (2003), Chapter 4: Hyperbolic extensions
- Rivlin (1990), Section 2.3: Product formulas

**Hyperbolic identities:**
- Standard formulas for sinh/cosh products and half-angles
- Analytic continuation from circular to hyperbolic

**Related work:**
- geometric-context-chebyshev-hyperbolic.md (overview)
- triple-identity-factorial-chebyshev-hyperbolic.md (numerical verification)
- Scripts: derive_1plus2k_factor.wl, derive_1plus2k_product.wl

---

## Acknowledgment

Factor (1+2k) initially appeared mysterious ("liché číslo" - odd number that leads nowhere).

**Turned out:** It's the **natural consequence** of the Chebyshev index structure ⌈k/2⌉, ⌊k/2⌋!

Sometimes what looks "odd" is exactly the right answer. 🎯
