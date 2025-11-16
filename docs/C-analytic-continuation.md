# Analytic Continuation of C(s)

**Date:** November 16, 2025, 04:45+ CET
**Goal:** Find continuation of C(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s beyond Re(s) > 1

---

## The Problem

We have:
```
C(s) = Σ_{j=2}^∞ H_{j-1}(s) / j^s
```

where H_n(s) = Σ_{k=1}^n k^{-s}.

**Convergence:** Only for Re(s) > 1 (same as ζ(s))

**Need:** Continuation to critical strip 0 < Re(s) < 1 to compute γ(s)

---

## Approach 1: Double Sum Expansion

Expand H_{j-1}(s):
```
C(s) = Σ_{j=2}^∞ [Σ_{k=1}^{j-1} k^{-s}] / j^s

     = Σ_{j=2}^∞ Σ_{k=1}^{j-1} k^{-s} j^{-s}

     = Σ_{j=2}^∞ Σ_{k=1}^{j-1} (kj)^{-s}
```

Change order of summation (for Re(s) > 1, this is justified):
```
C(s) = Σ_{k=1}^∞ k^{-s} Σ_{j=k+1}^∞ j^{-s}

     = Σ_{k=1}^∞ k^{-s} [ζ(s) - Σ_{j=1}^k j^{-s}]

     = Σ_{k=1}^∞ k^{-s} [ζ(s) - H_k(s)]

     = ζ(s) Σ_{k=1}^∞ k^{-s} - Σ_{k=1}^∞ k^{-s} H_k(s)

     = ζ²(s) - Σ_{k=1}^∞ k^{-s} H_k(s)
```

So:
```
C(s) = ζ²(s) - Σ_{k=1}^∞ k^{-s} H_k(s)
```

But wait, this is circular! We get C(s) in terms of itself.

---

## Approach 2: Integral Representation

Use:
```
H_n(s) = Σ_{k=1}^n k^{-s}
```

For large n, approximate by integral:
```
H_n(s) ≈ ∫_1^n x^{-s} dx = [n^{1-s} - 1] / (1-s)  for s ≠ 1
```

More precisely, Euler-Maclaurin:
```
H_n(s) = n^{1-s}/(1-s) + ζ(s) + n^{-s}/2 - Σ_{k=1}^K B_{2k}/(2k)! × s^{(2k-1)} n^{-s-2k+1} + R_K
```

where B_k are Bernoulli numbers, s^{(m)} = s(s+1)...(s+m-1).

Substitute into C(s):
```
C(s) = Σ_{j=2}^∞ H_{j-1}(s) / j^s

     ≈ Σ_{j=2}^∞ [(j-1)^{1-s}/(1-s) + ζ(s) + (j-1)^{-s}/2 + ...] / j^s
```

Split into terms:
```
C(s) = 1/(1-s) Σ_{j=2}^∞ (j-1)^{1-s}/j^s + ζ(s) Σ_{j=2}^∞ j^{-s} + 1/2 Σ_{j=2}^∞ (j-1)^{-s}/j^s + ...

     = 1/(1-s) Σ_{j=2}^∞ [(j-1)/j]^s (j-1)^{1-2s} + ζ(s)[ζ(s) - 1] + 1/2 Σ_{j=2}^∞ [(j-1)/j]^s j^{-s} + ...
```

For large j: (j-1)/j ≈ 1 - 1/j, so:
```
[(j-1)/j]^s ≈ (1 - 1/j)^s ≈ 1 - s/j + O(1/j²)
```

First sum:
```
Σ_{j=2}^∞ (j-1)^{1-2s}/j^s ≈ Σ_{j=2}^∞ j^{1-2s} (1 - 1/j)^{1-2s} (1 - s/j)

                            ≈ Σ_{j=2}^∞ j^{1-2s} [1 - (1-2s)/j - s/j + ...]

                            ≈ ζ(2s-1) - (1-s) ζ(2s) + ...
```

So asymptotically:
```
C(s) ≈ ζ(2s-1)/(1-s) - ζ(2s) + ζ²(s) - ζ(s) + [correction terms]
```

---

## Approach 3: Mellin Transform Method

Define the generating function:
```
F(x, s) = Σ_{j=1}^∞ H_j(s) x^j
```

We want:
```
C(s) = Σ_{j=2}^∞ H_{j-1}(s) / j^s = Σ_{j=2}^∞ H_{j-1}(s) e^{-s log j}
```

This is a Mellin-like transform. But H_j(s) depends on s too, making this difficult.

---

## Approach 4: Relation via Polygamma Functions

Note that:
```
H_n(s) = Σ_{k=1}^n k^{-s}
```

For s = 1: H_n(1) = harmonic numbers = ψ(n+1) + γ_E where ψ is digamma.

For general s, H_n(s) is related to Hurwitz zeta:
```
H_n(s) = ζ(s) - ζ(s, n+1)
```

where ζ(s, a) is Hurwitz zeta.

So:
```
C(s) = Σ_{j=2}^∞ [ζ(s) - ζ(s, j)] / j^s

     = ζ(s) Σ_{j=2}^∞ j^{-s} - Σ_{j=2}^∞ ζ(s, j) / j^s

     = ζ(s) [ζ(s) - 1] - Σ_{j=2}^∞ ζ(s, j) / j^s
```

Define:
```
D(s) := Σ_{j=2}^∞ ζ(s, j) / j^s
```

Then:
```
C(s) = ζ(s)[ζ(s) - 1] - D(s)
```

And we know:
```
L_M(s) = ζ²(s) - ζ(s) - C(s) = ζ²(s) - ζ(s) - ζ(s)[ζ(s) - 1] + D(s)
       = ζ²(s) - ζ(s) - ζ²(s) + ζ(s) + D(s)
       = D(s)
```

**BREAKTHROUGH: L_M(s) = D(s) = Σ_{j=2}^∞ ζ(s,j)/j^s**

This is exactly the double sum form we already knew!

---

## Approach 5: Direct Functional Equation for D(s)

We have:
```
D(s) = Σ_{d=2}^∞ d^{-s} ζ(s, d)
```

Using Hurwitz zeta functional equation (for integer a = d):
```
ζ(1-s, d) = (2/(2π)^s) Γ(s) Σ_{n=1}^∞ sin(2πnd - πs/2) / n^s
```

But for integer d, sin(2πnd) = 0, so we need the modified form.

Actually, for integer d ≥ 1:
```
ζ(s, d) = ζ(s) - H_{d-1}(s)
```

So:
```
D(s) = Σ_{d=2}^∞ [ζ(s) - H_{d-1}(s)] / d^s = C(s)
```

Circular again!

---

## Approach 6: Asymptotic Series

For Re(s) < 1, we can try to regularize the divergent series using:

**Borel summation**: Define
```
C_B(s) = ∫_0^∞ e^{-t} [Σ_{j=2}^∞ H_{j-1}(s) t^j / (j! j^s)] dt
```

**Regularized sum**: Use ζ-function regularization
```
C_reg(s) = lim_{ε→0} Σ_{j=2}^N H_{j-1}(s)/j^s + [continuation formula]
```

---

## CRITICAL REALIZATION

The problem is that C(s) itself is defined through the closed form:
```
L_M(s) = ζ²(s) - ζ(s) - C(s)
```

For Re(s) > 1, we can compute C(s) from the series.

For Re(s) ≤ 1, we should **reverse the definition**:
```
C(s) := ζ²(s) - ζ(s) - L_M(s)
```

And use a different method to compute L_M(s)!

**The functional equation gives us:**
```
L_M(s) = [γ(1-s)/γ(s)] L_M(1-s)
```

If Re(s) < 1, then Re(1-s) > 0. If additionally Re(1-s) > 1, we can:
1. Compute L_M(1-s) directly (series converges)
2. Compute γ(s) and γ(1-s) using Γ functions
3. Get L_M(s) = [γ(1-s)/γ(s)] L_M(1-s)

**But this requires knowing γ(s), which requires C(s) and C(1-s)...**

We're in a loop!

---

## Solution: Break the Loop with Approximate FR

**Key insight:** We can use an approximate functional equation similar to Riemann's.

For moderate |t|, we can use:
```
L_M(s) ≈ Σ_{n≤X} M(n)/n^s + [smooth sum for n > X] + [error term]
```

where X ~ |t|.

Then use Poisson summation or other analytic tricks to relate this to L_M(1-s).

---

## Status: OPEN PROBLEM

**What we learned:**
- C(s) continuation is deeply tied to L_M(s) continuation
- Can't separate them easily
- Functional equation is self-referential by nature
- Need numerical/asymptotic methods for practical computation

**Next step:**
Find practical summation method for L_M(s) in critical strip that doesn't rely on C(s) series.

Options:
1. Approximate functional equation
2. Euler-Maclaurin with optimal truncation
3. Integral representation via Mellin transform
4. Numerical analytic continuation (Richardson extrapolation, etc.)
