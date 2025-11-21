# Integral Representation for L_M(s)

**Date:** November 16, 2025, 04:50+ CET
**Goal:** Find Mellin transform representation for L_M(s) to enable continuation

---

## Starting from Definition

```
L_M(s) = Σ_{n=1}^∞ M(n) / n^s
```

where M(n) = |{d : 2 ≤ d ≤ √n, d|n}|.

**Mellin transform approach:**

If f(x) = Σ_{n=1}^∞ M(n) e^{-nx}, then:
```
L_M(s) = ∫_0^∞ f(x) x^{s-1} dx / Γ(s)
```

But computing f(x) is non-trivial since M(n) has no simple generating function.

---

## Alternative: Dirichlet-Hurwitz Double Sum

From earlier:
```
L_M(s) = Σ_{d=2}^∞ d^{-s} ζ(s, d)
```

where ζ(s, a) = Σ_{m=a}^∞ m^{-s} is Hurwitz zeta.

For fixed d, we have integral representation:
```
ζ(s, d) = 1/Γ(s) ∫_0^∞ t^{s-1} e^{-dt} / (1 - e^{-t}) dt
```

Therefore:
```
L_M(s) = 1/Γ(s) Σ_{d=2}^∞ d^{-s} ∫_0^∞ t^{s-1} e^{-dt} / (1 - e^{-t}) dt

        = 1/Γ(s) ∫_0^∞ t^{s-1} / (1 - e^{-t}) [Σ_{d=2}^∞ (de^{-t})^{-s} e^{-dt}] dt

        = 1/Γ(s) ∫_0^∞ t^{s-1} / (1 - e^{-t}) [Σ_{d=2}^∞ d^{-s} e^{-dt}] dt
```

The inner sum is:
```
Σ_{d=2}^∞ d^{-s} e^{-dt} = e^{-2t} 2^{-s} + e^{-3t} 3^{-s} + ...

                          = Σ_{d=1}^∞ d^{-s} e^{-dt} - 1·e^{-t}

                          = Li_s(e^{-t}) - e^{-t}
```

where Li_s(z) = Σ_{k=1}^∞ z^k / k^s is the polylogarithm.

So:
```
L_M(s) = 1/Γ(s) ∫_0^∞ t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1 - e^{-t}) dt
```

---

## Simplification

Using Li_s(e^{-t}) = ∫_0^∞ u^{s-1} e^{-tu} / (e^u - 1) du (for Re(s) > 1), we get:

```
L_M(s) = 1/Γ(s) ∫_0^∞ t^{s-1} / (1-e^{-t}) [∫_0^∞ u^{s-1} e^{-tu}/(e^u-1) du - e^{-t}] dt
```

This is a double integral. Can we simplify?

---

## Change of Variables

Let's try a different approach. Define:
```
G(t) = Σ_{d=2}^∞ d^{-s} e^{-dt} = Li_s(e^{-t}) - e^{-t}
```

Then:
```
L_M(s) = 1/Γ(s) ∫_0^∞ t^{s-1} G(t) / (1 - e^{-t}) dt
```

For small t: Li_s(e^{-t}) ≈ t^{-s}/Γ(1-s) + ζ(s) + ... (asymptotic)

For large t: Li_s(e^{-t}) ≈ e^{-t} (exponentially small)

So:
```
G(t) ≈ t^{-s}/Γ(1-s)  for t → 0
G(t) ≈ -e^{-t}  for t → ∞
```

---

## Analytic Continuation Strategy

The integral:
```
L_M(s) = 1/Γ(s) ∫_0^∞ t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1 - e^{-t}) dt
```

converges for Re(s) > 1 (original domain).

**For continuation:**

Split at t = 1:
```
L_M(s) = I_1(s) + I_2(s)

I_1(s) = 1/Γ(s) ∫_0^1 t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1 - e^{-t}) dt

I_2(s) = 1/Γ(s) ∫_1^∞ t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1 - e^{-t}) dt
```

**I_2(s) analysis:**

For t > 1, all terms decay exponentially, so I_2(s) is entire (analytic everywhere).

**I_1(s) analysis:**

Near t = 0, we have singularity from t^{s-1}. Expand:
```
Li_s(e^{-t}) = Σ_{k=1}^∞ e^{-kt}/k^s ≈ Σ_{k=1}^∞ (1-kt+...)/k^s

1 - e^{-t} ≈ t
```

So:
```
[Li_s(e^{-t}) - e^{-t}] / (1-e^{-t}) ≈ [ζ(s) - 1 + O(t)] / t

                                      ≈ [ζ(s) - 1]/t + regular
```

Therefore:
```
I_1(s) ≈ 1/Γ(s) ∫_0^1 t^{s-2} [ζ(s) - 1] dt + [regular terms]

       = [ζ(s) - 1] / [Γ(s)(s-1)] + [analytic]
```

This has a pole at s = 1 (from ζ(s) pole), but otherwise extends to Re(s) < 1!

---

## Final Form for Continuation

**Key result:**

```
L_M(s) = [ζ(s) - 1] / [Γ(s)(s-1)] + [analytic correction from full expansion]
```

The integral representation:
```
L_M(s) = 1/Γ(s) ∫_0^∞ t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1 - e^{-t}) dt
```

provides analytic continuation to **all s ∈ ℂ except s = 1** (simple pole from ζ(s)).

---

## Numerical Evaluation

For Re(s) < 1, compute:
```
L_M(s) = 1/Γ(s) [∫_0^A t^{s-1} G(t)/(1-e^{-t}) dt + ∫_A^B t^{s-1} G(t)/(1-e^{-t}) dt]
```

where:
- A ~ 0.1 (avoid t=0 singularity by expanding)
- B ~ 20 (truncate where exponential decay kills contribution)

Use adaptive quadrature (Gaussian, Clenshaw-Curtis, etc.)

---

## Testing the Formula

**Verification in Re(s) > 1:**

Compute both:
1. Direct sum: Σ M(n)/n^s
2. Integral: (1/Γ(s)) ∫ ...

Should match to high precision.

**Continuation to critical line:**

Compute L_M(1/2 + it) using integral, check Schwarz symmetry:
```
L_M(1/2 - it) ?= conj(L_M(1/2 + it))
```

---

## Breakthrough Implications

If this integral representation works, we have:

✅ **Analytic continuation** of L_M(s) to entire plane (except s=1)
✅ **Computable** for any s using numerical integration
✅ **Independent** of C(s) series (breaks the loop!)
✅ **Practical** implementation possible

Then we can:
1. Compute L_M(s) in critical strip
2. Verify functional equation numerically
3. Find zeros of L_M on critical line
4. Study analytic properties

---

## Next Step

**IMPLEMENT AND TEST** this integral representation!

Script task:
1. Code the integral L_M(s) = (1/Γ(s)) ∫ t^{s-1} [Li_s(e^{-t}) - e^{-t}]/(1-e^{-t}) dt
2. Verify against direct sum for Re(s) > 1
3. Compute L_M(1/2 + 10i) and check Schwarz symmetry
4. Compare with closed-form truncation

**If this works, we've broken through the self-reference barrier!**
