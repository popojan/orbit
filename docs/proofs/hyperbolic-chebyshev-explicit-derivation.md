# Explicit Hand-Derivable Proof: Chebyshev ↔ Hyperbolic

**Date:** 2025-11-24
**Method:** Step-by-step algebraic derivation (no black boxes)
**Status:** ✅ ALGEBRAICALLY PROVEN

---

## Goal

Prove algebraically that for any k ≥ 1:

```
D_cheb(x,k) = T[⌈k/2⌉, x+1] · (U[⌊k/2⌋, x+1] - U[⌊k/2⌋-1, x+1])
           = 1/2 + Cosh[(1+2k)·ArcSinh[√(x/2)]] / (√2·√(2+x))
           = D_hyp(x,k)
```

---

## Proof Strategy

Transform Chebyshev polynomials to hyperbolic form via:
1. **Hyperbolic extension** (standard identity for u > 1)
2. **Trigonometric identities** (sinh/cosh formulas)
3. **Coordinate change** (s = t/2 via half-angle formula)

All steps use **standard mathematical identities** (no computational verification).

---

## Step 1: Chebyshev Starting Point

For k ≥ 1, define:
```
n = ⌈k/2⌉  (ceiling)
m = ⌊k/2⌋  (floor)
```

Chebyshev form:
```
D_cheb(x,k) = T_n(x+1) · [U_m(x+1) - U_{m-1}(x+1)]
```

---

## Step 2: Hyperbolic Extension of Chebyshev Polynomials

**Standard mathematical identity** for u > 1:

```
T_n(u) = T_n(cosh t) = cosh(nt)
U_n(u) = U_n(cosh t) = sinh((n+1)t) / sinh(t)

where t = ArcCosh[u]
```

For our case, u = x+1 (with x ≥ 0), so:
```
t = ArcCosh[x+1]
```

This gives:
```
T_n(x+1) = cosh(nt)
U_m(x+1) = sinh((m+1)t) / sinh(t)
U_{m-1}(x+1) = sinh(mt) / sinh(t)
```

---

## Step 3: Simplify U_m - U_{m-1}

Difference:
```
U_m(x+1) - U_{m-1}(x+1) = [sinh((m+1)t) - sinh(mt)] / sinh(t)
```

**Standard sinh difference formula:**
```
sinh(A) - sinh(B) = 2·cosh((A+B)/2)·sinh((A-B)/2)
```

Apply with A = (m+1)t, B = mt:
```
sinh((m+1)t) - sinh(mt) = 2·cosh((2m+1)t/2)·sinh(t/2)
```

Therefore:
```
U_m - U_{m-1} = 2·cosh((2m+1)t/2)·sinh(t/2) / sinh(t)
```

**Standard double-angle identity:** sinh(t) = 2·sinh(t/2)·cosh(t/2)

Substitute:
```
U_m - U_{m-1} = 2·cosh((2m+1)t/2)·sinh(t/2) / [2·sinh(t/2)·cosh(t/2)]
              = cosh((2m+1)t/2) / cosh(t/2)
```

---

## Step 4: Compute T_n · (U_m - U_{m-1})

Full product:
```
D_cheb = T_n · (U_m - U_{m-1})
       = cosh(nt) · cosh((2m+1)t/2) / cosh(t/2)
```

**Standard cosh product formula:**
```
cosh(A)·cosh(B) = [cosh(A+B) + cosh(A-B)] / 2
```

Apply with A = nt, B = (2m+1)t/2:
```
A + B = nt + (2m+1)t/2 = (2n + 2m + 1)t/2
A - B = nt - (2m+1)t/2 = (2n - 2m - 1)t/2
```

Result:
```
cosh(nt)·cosh((2m+1)t/2) = [cosh((2n+2m+1)t/2) + cosh((2n-2m-1)t/2)] / 2
```

Therefore:
```
D_cheb = [cosh((2n+2m+1)t/2) + cosh((2n-2m-1)t/2)] / [2·cosh(t/2)]
```

---

## Step 5: Evaluate 2n+2m+1 = 1+2k

**Case 1: k even** (k = 2j)
```
n = ⌈k/2⌉ = j
m = ⌊k/2⌋ = j

2n + 2m + 1 = 2j + 2j + 1 = 4j + 1 = 2k + 1
```

**Case 2: k odd** (k = 2j+1)
```
n = ⌈k/2⌉ = j+1
m = ⌊k/2⌋ = j

2n + 2m + 1 = 2(j+1) + 2j + 1 = 4j + 3 = 2k + 1
```

**Unified result for all k:**
```
2n + 2m + 1 = 1 + 2k  ✓
```

Similarly, 2n - 2m - 1 = 1 (for k even) or -1 (for k odd).

---

## Step 6: Critical Identity - s = t/2

Define two coordinate systems:
```
s = ArcSinh[√(x/2)]    [hyperbolic coordinate]
t = ArcCosh[x+1]        [Chebyshev coordinate]
```

**Claim:** s = t/2 exactly.

**Proof:**

From definition of s:
```
sinh(s) = √(x/2)
```

**Standard sinh half-angle formula:**
```
sinh(t/2) = √[(cosh(t) - 1)/2]
```

From definition of t:
```
cosh(t) = x+1
```

Substitute:
```
sinh(t/2) = √[(x+1 - 1)/2]
          = √(x/2)
```

Since both sinh(s) and sinh(t/2) equal √(x/2):
```
s = t/2  ✓✓✓
```

**This is an exact algebraic identity**, not an approximation.

---

## Step 7: Coordinate Change t → 2s

From Step 4:
```
D_cheb = [cosh((1+2k)t/2) + cosh(t/2)] / [2·cosh(t/2)]
```

Substitute t = 2s:
```
D_hyp = [cosh((1+2k)s) + cosh(s)] / [2·cosh(s)]
```

Simplify:
```
D_hyp = cosh((1+2k)s) / [2·cosh(s)] + 1/2
```

---

## Step 8: Express cosh(s) in terms of x

From s = ArcSinh[√(x/2)]:
```
sinh(s) = √(x/2)
```

**Standard hyperbolic identity:**
```
cosh²(s) = 1 + sinh²(s)
```

Therefore:
```
cosh(s) = √(1 + x/2)
        = √((2+x)/2)
        = √(2+x)/√2
```

---

## Step 9: Final Form

Substitute cosh(s) = √(2+x)/√2 into Step 7:
```
D_hyp = cosh((1+2k)s) / [2·√(2+x)/√2] + 1/2
      = cosh((1+2k)s)·√2 / [2·√(2+x)] + 1/2
      = cosh((1+2k)s) / [√2·√(2+x)] + 1/2
```

Rearrange:
```
D_hyp(x,k) = 1/2 + Cosh[(1+2k)·ArcSinh[√(x/2)]] / (√2·√(2+x))
```

**This is exactly the hyperbolic form!** ✅

---

## Summary

**Proof method:** Pure algebraic manipulation using standard identities:
- Hyperbolic extension of Chebyshev polynomials: `T_n(cosh t) = cosh(nt)`
- Sinh difference formula: `sinh(A) - sinh(B) = 2·cosh((A+B)/2)·sinh((A-B)/2)`
- Cosh product formula: `cosh(A)·cosh(B) = [cosh(A+B) + cosh(A-B)]/2`
- Sinh half-angle formula: `sinh(t/2) = √[(cosh(t) - 1)/2]`
- Hyperbolic identity: `cosh²(s) = 1 + sinh²(s)`

**Key insight:** The s = t/2 identity (Step 6) is the bridge connecting:
- Chebyshev argument: t = ArcCosh[x+1]
- Hyperbolic argument: s = ArcSinh[√(x/2)]

**Epistemic status:** ✅ **ALGEBRAICALLY PROVEN** (no computational verification needed)

All steps are **hand-checkable** using standard mathematical identities.

---

## Verification Example: k = 2

To verify, compute both forms for k=2, x=1:

**Chebyshev form:**
- n = ⌈2/2⌉ = 1, m = ⌊2/2⌋ = 1
- T₁(2) = 2
- U₁(2) = 2·2 = 4 (using U₁(y) = 2y)
- U₀(2) = 1
- D_cheb = 2·(4-1) = 6

**Hyperbolic form:**
- s = ArcSinh[√(1/2)] ≈ 0.6585
- Cosh[5s]/(√2·√3) + 1/2 = 11/(2√6) + 1/2 ≈ 6

**Polynomial form:** Both expand to 1 + 3x + 2x² = 6 at x=1 ✓

---

**Completion date:** 2025-11-24
**Source of building blocks:** `docs/sessions/2025-11-22-palindromic-symmetries/derivation-1plus2k-factor.md`
