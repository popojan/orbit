# Debugging Integral Representation

**Goal:** Find error in derivation or identify numerical instability

---

## Step-by-Step Verification

### Starting Point (CORRECT)

```
L_M(s) = Σ_{d=2}^∞ d^{-s} ζ(s, d)
```

where ζ(s, a) = Σ_{m=a}^∞ m^{-s}.

---

### Hurwitz Zeta Integral (STANDARD)

```
ζ(s, a) = 1/Γ(s) ∫_0^∞ t^{s-1} e^{-at} / (1 - e^{-t}) dt
```

**Verification for ζ(s) = ζ(s, 1):**

Known:
```
ζ(s) = 1/Γ(s) ∫_0^∞ t^{s-1} / (e^t - 1) dt
```

Our formula with a=1:
```
ζ(s, 1) = 1/Γ(s) ∫_0^∞ t^{s-1} e^{-t} / (1 - e^{-t}) dt
       = 1/Γ(s) ∫_0^∞ t^{s-1} / [e^t(1 - e^{-t})]
       = 1/Γ(s) ∫_0^∞ t^{s-1} / (e^t - 1) dt  ✓
```

**Status: CORRECT**

---

### Substitution into L_M (CHECK ORDER OF OPERATIONS)

```
L_M(s) = Σ_{d=2}^∞ d^{-s} × [1/Γ(s) ∫_0^∞ t^{s-1} e^{-dt} / (1 - e^{-t}) dt]

       = 1/Γ(s) Σ_{d=2}^∞ d^{-s} ∫_0^∞ t^{s-1} e^{-dt} / (1 - e^{-t}) dt
```

**Can we interchange sum and integral?**

For Re(s) > 1, both sum and integral converge absolutely. By Fubini:
```
L_M(s) = 1/Γ(s) ∫_0^∞ t^{s-1} / (1 - e^{-t}) [Σ_{d=2}^∞ d^{-s} e^{-dt}] dt
```

**Status: JUSTIFIED for Re(s) > 1**

---

### Inner Sum Evaluation

```
Σ_{d=2}^∞ d^{-s} e^{-dt} = ?
```

**Approach 1:** Relate to polylogarithm

```
Li_s(z) := Σ_{k=1}^∞ z^k / k^s

Li_s(e^{-t}) = Σ_{k=1}^∞ e^{-kt} / k^s
```

Our sum:
```
Σ_{d=2}^∞ d^{-s} e^{-dt} = Σ_{d=1}^∞ d^{-s} e^{-dt} - 1^{-s} e^{-t}

                          = Li_s(e^{-t}) - e^{-t}
```

**Status: CORRECT**

---

### Final Formula

```
L_M(s) = 1/Γ(s) ∫_0^∞ t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1 - e^{-t}) dt
```

**Derivation status: MATHEMATICALLY CORRECT for Re(s) > 1**

---

## Why Numerical Error?

### Hypothesis 1: Direct Sum Truncation Error

Direct sum with nmax=500:
```
L_M(s) ≈ Σ_{n=1}^{500} M(n) / n^s
```

**Error estimate for Re(s) = 2:**

Tail: Σ_{n=501}^∞ M(n)/n^2

Since M(n) ~ τ(n)/2 ~ O(log n), we have:
```
|tail| ~ Σ_{n=501}^∞ log(n)/n^2 ~ log(500)/500 ~ 0.012
```

**This could explain ~0.006 error!**

### Hypothesis 2: Polylog Numerical Issues

For complex s, Li_s(e^{-t}) may have:
- Branch cuts
- Loss of precision in mpmath
- Cancellation errors when Li_s ≈ e^{-t}

**Test:** Compute Li_s(e^{-t}) - e^{-t} directly vs in parts

### Hypothesis 3: Integration Domain

Integration [0, ∞) with:
- t → 0: singularity from t^{s-1} when Re(s) < 1
- t → ∞: exponential decay (OK)

**Near t=0 behavior:**

```
Li_s(e^{-t}) = Σ e^{-kt}/k^s ≈ Σ (1 - kt + ...)/k^s
             = ζ(s) - t ζ(s-1) + O(t²)

1 - e^{-t} ≈ t

[Li_s(e^{-t}) - e^{-t}]/(1-e^{-t}) ≈ [ζ(s) - 1 - t ζ(s-1)]/t
                                    = [ζ(s) - 1]/t - ζ(s-1) + O(t)
```

So integrand ~ t^{s-2} [ζ(s) - 1] near t=0.

For Re(s) = 2: t^0 × const = OK
For Re(s) = 1.5: t^{-0.5} × const = integrable but needs care
For Re(s) = 1.2: t^{-0.8} × const = integrable but harder

**Numerical integration struggles with near-singular integrands!**

---

## Root Cause Analysis

**Primary issue: Integrand near t=0**

For complex s with Re(s) close to 1:
- Integrand has t^{s-2} behavior
- Re(s) = 1.2 → t^{-0.8} (nearly singular)
- Standard quadrature (Gaussian) not optimal for this

**Secondary issue: Direct sum truncation**

nmax=500 insufficient for high precision at Re(s) = 2.

---

## Fixes

### Fix 1: Separate Singular Part

```
L_M(s) = 1/Γ(s) [∫_0^1 ... + ∫_1^∞ ...]
```

For t ∈ [0, 1], expand:
```
[Li_s(e^{-t}) - e^{-t}]/(1-e^{-t}) = [ζ(s)-1]/t + f(t)
```

where f(t) is regular. Then:
```
∫_0^1 t^{s-1} [ζ(s)-1]/t dt = [ζ(s)-1] ∫_0^1 t^{s-2} dt
                              = [ζ(s)-1]/(s-1)
```

Compute this analytically, integrate f(t) numerically.

### Fix 2: Better Quadrature

Use specialized methods for:
- Nearly singular integrands (Gauss-Jacobi with weight)
- Infinite domain (Gauss-Laguerre)
- Or adaptive with higher tolerance

### Fix 3: Increase Direct Sum

Use nmax=5000 or 10000 to verify.

### Fix 4: Alternative Approach

**Euler-Maclaurin summation** for L_M(s) directly:

```
L_M(s) = Σ_{n=1}^N M(n)/n^s + [integral correction] + [remainder]
```

This might be more stable than integral representation.

---

## Immediate Test

**Before fixing integral:**

Test direct sum with nmax=5000 at s=2:
- If value changes significantly → truncation was the issue
- If matches previous → something else is wrong

**Quick verification:**

Compare:
```
1/Γ(2) ∫_0^∞ t [Li_2(e^{-t}) - e^{-t}]/(1-e^{-t}) dt  vs  Σ M(n)/n²
```

For s=2, Γ(2)=1, so integral should equal sum exactly.

---

## Conclusion

**Derivation: CORRECT ✓**

**Numerical implementation: NEEDS REFINEMENT**

Issues:
1. Direct sum truncation (nmax too small)
2. Integral near-singularity (needs careful quadrature)
3. Possibly mpmath polylog precision for complex s

**Next:** Test with improved direct sum (nmax=10000) first.
