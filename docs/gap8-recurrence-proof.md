# GAP 8 Proof: Binomial Recurrence Identity

**Date:** November 20, 2025
**Status:** ⏸️ IN PROGRESS

---

## Goal

Prove algebraically that f(n,k) = 2^k·C(n+k, 2k) satisfies the recurrence:

```
f(n+2, k) = 4f(n, k-2) + 8f(n, k-1) + 2f(n, k) - f(n-2, k)
```

This recurrence was **derived directly** from Chebyshev polynomial structure (ΔU_n), with NO circular reasoning.

---

## Context

**What we have proven:**

1. ✅ **g(n,k) = [x^k] ΔU_n(x+1) satisfies this recurrence**
   - Derived from Chebyshev recurrence: U_n(x) = 2xU_{n-1}(x) - U_{n-2}(x)
   - Showed: ΔU_{n+2}(x) = (4x² - 2)ΔU_n(x) - ΔU_{n-2}(x)
   - Shifted x → x+1, extracted [x^k] coefficients
   - Result: g(n+2,k) = 4g(n,k-2) + 8g(n,k-1) + 2g(n,k) - g(n-2,k)
   - **This is pure algebra from polynomial structure**

2. ✅ **Base cases: g(n,k) = f(n,k) for n=2,4**
   - Previously verified by direct polynomial expansion

3. 🔬 **f(n,k) satisfies recurrence NUMERICALLY**
   - Verified for 43 test cases (n≤16, various k)
   - Wolfram numerical verification: 100% match

**What we need:**

❌ **Algebraic proof that f(n,k) satisfies the recurrence**

Once proven: g = f by uniqueness (same recurrence + base cases) → GAP 8 closed ✓

---

## The Identity to Prove

Expanding f(n,k) = 2^k·C(n+k, 2k):

```
LHS: f(n+2, k) = 2^k · C(n+2+k, 2k)

RHS: 4f(n, k-2) + 8f(n, k-1) + 2f(n, k) - f(n-2, k)
   = 4·2^(k-2)·C(n+k-2, 2k-4) + 8·2^(k-1)·C(n+k-1, 2k-2)
     + 2·2^k·C(n+k, 2k) - 2^k·C(n-2+k, 2k)
   = 2^(k-2)[4C(n+k-2, 2k-4) + 16C(n+k-1, 2k-2) + 8C(n+k, 2k) - 4C(n-2+k, 2k)]
```

Dividing both sides by 2^k (or equivalently by 2^(k-2) and rescaling):

**Simplified identity:**
```
4·C(n+2+k, 2k) = 4C(n+k-2, 2k-4) + 16C(n+k-1, 2k-2) + 8C(n+k, 2k) - 4C(n-2+k, 2k)
```

Or dividing by 4:
```
C(n+2+k, 2k) = C(n+k-2, 2k-4) + 4C(n+k-1, 2k-2) + 2C(n+k, 2k) - C(n-2+k, 2k)
```

---

## Proof Strategy

**Approach:** Apply Pascal's identity repeatedly to expand LHS, collect terms, match RHS.

Pascal's identity: `C(n,k) = C(n-1,k) + C(n-1,k-1)`

---

## Algebraic Proof (Work in Progress)

### Step 1: Expand LHS using Pascal

Starting with LHS = C(n+2+k, 2k):

```
C(n+2+k, 2k) = C(n+1+k, 2k) + C(n+1+k, 2k-1)
```

Expand further:
```
C(n+1+k, 2k) = C(n+k, 2k) + C(n+k, 2k-1)
C(n+1+k, 2k-1) = C(n+k, 2k-1) + C(n+k, 2k-2)
```

Therefore:
```
C(n+2+k, 2k) = C(n+k, 2k) + C(n+k, 2k-1) + C(n+k, 2k-1) + C(n+k, 2k-2)
              = C(n+k, 2k) + 2C(n+k, 2k-1) + C(n+k, 2k-2)
```

### Step 2: Further expansion needed

We have LHS in terms of C(n+k, *), but RHS contains:
- C(n+k-2, 2k-4)
- C(n+k-1, 2k-2)
- C(n+k, 2k)
- C(n-2+k, 2k)

Need to relate these using Pascal...

**[CONTINUING...]**

---

## Alternative Approach: Generating Functions?

The recurrence g(n+2,k) = 4g(n,k-2) + 8g(n,k-1) + 2g(n,k) - g(n-2,k) is complex due to:
- Step of 2 in n
- Multiple k shifts
- Subtraction term

Generating function might be messy. Stick with Pascal for now.

---

## Alternative Approach: Induction on n?

**Claim:** For fixed k, prove by induction on n (even n ≥ 4):
```
f(n+2,k) = 4f(n,k-2) + 8f(n,k-1) + 2f(n,k) - f(n-2,k)
```

**Base case:** n=4, k≥2
- Verify identity holds (numerical or direct computation)

**Inductive step:** Assume true for n, prove for n+2
- Substitute f(n,k) = 2^k·C(n+k, 2k)
- Apply Pascal's identity to relate C(n+2+k,2k) to C(n+k,2k), etc.
- Show equality after algebraic manipulation

This might be more tractable...

---

## Status

**Progress:**
- ✅ Identified exact identity to prove
- ✅ Simplified to binomial-only form
- ⏸️ Pascal expansion in progress
- ⏸️ Alternative: induction approach to explore

**Next steps:**
- Complete Pascal expansion proof, OR
- Try induction approach with detailed base case verification

---

**Self-Adversarial Check:**

✓ This is the RIGHT identity (derived from polynomial structure, no circular assumption)
✓ Numerical confidence is very high (43 cases pass)
✓ Standard binomial techniques (Pascal, Vandermonde) should work
⚠️ Algebra is getting complex - might need systematic computer algebra (but must show steps!)
⚠️ Could spend significant time on this - is there simpler approach?

**Honest assessment:** Identity is almost certainly true, but hand proof is non-trivial.

---
