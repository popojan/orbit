# Closed Form Convergence Analysis

**Date:** November 16, 2025
**Status:** 🔬 NUMERICALLY VERIFIED (high confidence)

---

## Critical Finding: Algebraic Symmetry Without Convergence

### The Mystery

We observed contradictory behavior:
1. Schwarz symmetry tests **succeeded**: L_M(1-s) = conj(L_M(s)) with error < 10^-15
2. Convergence tests **failed**: |L_M(s, jmax)| oscillates as jmax increases

**Resolution:** Both are correct! Schwarz symmetry holds **algebraically** at every truncation, independent of convergence.

---

## The Test

For s on critical line (Re(s) = 1/2), we computed:
- L_M(s, jmax) using closed form with varying jmax
- L_M(1-s, jmax) = L_M(conj(s), jmax)
- Checked both **Schwarz error** and **convergence**

### Results at s = 0.5 + 10i

| jmax | \|L_M(s)\| | Schwarz Error | Change from prev |
|------|-----------|---------------|------------------|
| 100  | 1.756     | **0.000e+00** | N/A              |
| 150  | 2.280     | **0.000e+00** | 3.846            |
| 200  | 2.375     | **0.000e+00** | 4.568            |
| 250  | 1.375     | **0.000e+00** | 3.174            |
| 300  | 4.000     | **0.000e+00** | 3.916            |
| 350  | 4.281     | **0.000e+00** | 7.048            |
| 400  | 3.125     | **0.000e+00** | 6.207            |
| 450  | 1.346     | **0.000e+00** | 2.797            |
| 500  | 2.742     | **0.000e+00** | 1.488            |

**Observation:**
- ✓ Schwarz error = 0 at **every** jmax (perfect algebraic symmetry)
- ✗ Values oscillate wildly, no convergence
- ✓ |L_M(s, jmax)| = |L_M(1-s, jmax)| exactly at each jmax

---

## Interpretation

### The Closed Form as Algebraic Identity

```
L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s
```

This identity has a remarkable property:

**For any finite truncation jmax:**
```
L_M(1-s, jmax) = conj(L_M(s, jmax))     when Re(s) = 1/2
```

This holds **algebraically**, regardless of whether the series converges!

### Analogy: Oscillating Series with Symmetry

Consider:
```
f(N) = Σ_{n=1}^N (-1)^n
```

Properties:
- f(1) = -1, f(2) = 0, f(3) = -1, f(4) = 0, ... (oscillates)
- But f(2k) = 0 for **all** k (a symmetry property)
- The symmetry holds despite non-convergence

Similarly:
- L_M(s, jmax) oscillates as jmax → ∞
- But L_M(1-s, jmax) = conj(L_M(s, jmax)) at **every** jmax
- The Schwarz symmetry is algebraic, not asymptotic

---

## Why the Original Tests Were Both Correct

### Test 1: Schwarz Symmetry (scripts/analyze_critical_line.py)

**What it tested:** At jmax=200, does L_M(1-s) = conj(L_M(s))?
**Result:** YES, error < 10^-10 ✓
**Conclusion:** Schwarz symmetry holds at this truncation

**What it did NOT test:** Whether jmax=200 is converged
**Implicit assumption:** Values at jmax=200 are "good enough"
**Reality:** They're not converged, but symmetry still holds!

### Test 2: Convergence (scripts/test_full_LM_convergence.py)

**What it tested:** Does L_M(s, jmax) → stable value as jmax → ∞?
**Result:** NO, oscillates ✗
**Conclusion:** Truncated sum doesn't converge for Re(s) ≤ 1

**What it did NOT test:** Schwarz symmetry
**Implication:** Even non-converged values can satisfy symmetries

### Resolution

Both tests are **correct**:
1. Schwarz symmetry holds (algebraically, at every truncation)
2. Values don't converge (series oscillates)

These are **compatible** - symmetry ≠ convergence!

---

## Implications for Analytic Continuation

### What the Closed Form IS:

✓ **Algebraically correct identity** for Re(s) > 1
✓ **Preserves Schwarz symmetry** even when truncated
✓ **Demonstrates existence** of symmetry relation

### What the Closed Form is NOT:

✗ **Numerical method** for computing L_M(s) at Re(s) ≤ 1
✗ **Analytic continuation** via direct summation
✗ **Convergent series** in critical strip

### Conclusion

The closed form:
```
L_M(s) = ζ(s)[ζ(s) - 1] - C(s)
```

is a **formal identity** that reveals structural properties (like Schwarz symmetry) but does **not** provide numerical convergence for Re(s) ≤ 1.

For analytic continuation, we need:
- Integral representation (Mellin transform)
- Functional equation with gamma factor
- Alternative summation methods (Euler-Maclaurin, etc.)
- OR: prove C(s) has a closed form in terms of known functions

---

## Technical Details

### Why Schwarz Symmetry Holds Algebraically

On critical line s = 1/2 + it:
- ζ(s) and ζ(1-s) = ζ(conj(s)) are related by functional equation
- H_j(s) = Σ_{k=1}^j k^{-s} satisfies H_j(conj(s)) = conj(H_j(s))
- Term-by-term: each summand in C(s) satisfies conjugation symmetry
- Therefore: C(conj(s)) = conj(C(s)) **at any truncation**

Even though the infinite sum doesn't converge, the finite truncation preserves the symmetry structure!

### Why Convergence Fails

For Re(s) ≤ 1:
```
C(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s
```

- H_j(s) ~ ζ(s) for large j (approximately constant)
- Terms ~ ζ(s)/j^s
- This is like Σ 1/j^s, which diverges for Re(s) ≤ 1
- BUT: ζ(s) itself diverges for Re(s) ≤ 1!
- The interplay creates oscillation, not convergence

The truncation error behaves erratically - sometimes cancels, sometimes amplifies.

---

## Next Steps

Since closed form doesn't provide numerical continuation:

1. **Integral representation**: Express L_M(s) as Mellin transform
2. **Functional equation**: Find γ(s) such that γ(s)L_M(s) = γ(1-s)L_M(1-s)
3. **Euler-Maclaurin**: Apply to partial sums for asymptotic expansion
4. **Alternative forms**: Look for C(s) in terms of polylogarithms, etc.

The Schwarz symmetry remains a **clue** that functional equation exists, even if closed form doesn't compute it numerically.

---

**Status:** 🔬 NUMERICAL (tested at 3 critical line points, jmax 100-500, all show perfect Schwarz symmetry with oscillating magnitudes)

**Confidence:** 95% (consistent pattern, mathematically coherent, resolves apparent contradiction)

**Peer review:** NONE
