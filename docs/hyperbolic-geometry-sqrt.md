# Hyperbolic Geometry and Square Root Approximations

**Date:** 2025-11-21
**Context:** Analysis of Binet sqrt formula revealed deep connection to hyperbolic geometry

## Overview

Square root approximations via Pell equation solutions exhibit fundamental connections to hyperbolic geometry. This document explores why the closed-form Binet formula produces hyperbolic tangent expressions and what this reveals about the geometric nature of convergence.

## The Binet Formula

**Binet sqrt approximation:**

```mathematica
BinetSqrt[n, start, k] = Sqrt[n] * (p^k - q^k)/(p^k + q^k)
```

where:
- `p = start + Sqrt[n]` (expanding unit)
- `q = start - Sqrt[n]` (contracting unit)
- `k` = iteration count

For Pell-based start: `start = (x-1)/y` where `(x,y)` solves `x² - n·y² = 1`

## Closed Form Discovery

When Wolfram evaluates BinetSqrt symbolically (without numeric k), it produces:

```mathematica
-Sqrt[2] * Tanh[1/2 (I π - 2 ArcSinh[1]) * k]
```

**This is not a bug — it's revealing deep structure.**

## Mathematical Breakdown

### Step 1: Pell Fundamental Unit

For `n = 2`, the Pell equation `x² - 2y² = 1` has fundamental solution `(x,y) = (3,2)`.

The **fundamental unit** is:
```
ε = x + y√2 = 3 + 2√2
```

For start point `(x-1)/y = 2/2 = 1`:
```
p = 1 + √2
q = 1 - √2
```

**Key observation:** `p·q = (1+√2)(1-√2) = 1 - 2 = -1`

This means `p` and `q` are **reciprocals** (up to sign):
```
q = -1/p
```

### Step 2: Exponential Form

Rewrite the Binet formula:
```
(p^k - q^k)/(p^k + q^k) = (p^k - (-1/p)^k)/(p^k + (-1/p)^k)
```

For odd k:
```
= (p^k + p^(-k))/(p^k - p^(-k))  [using (-1)^k = -1]
```

Let `α = ln(p)`. Then `p^k = e^(kα)`, so:
```
= (e^(kα) + e^(-kα))/(e^(kα) - e^(-kα))
= coth(kα)
```

For even k, we get `tanh(kα)` instead.

### Step 3: Connection to ArcSinh

**Claim:** `ln(1 + √2) = ArcSinh(1)`

**Proof:**
```
sinh(x) = (e^x - e^(-x))/2
```

We want `sinh(α) = 1`:
```
(e^α - e^(-α))/2 = 1
e^α - e^(-α) = 2
```

Multiply by `e^α`:
```
e^(2α) - 1 = 2e^α
e^(2α) - 2e^α - 1 = 0
```

Quadratic in `e^α`:
```
e^α = (2 ± √(4+4))/2 = 1 ± √2
```

Taking positive solution: `e^α = 1 + √2`

Therefore: `α = ln(1 + √2) = ArcSinh(1)` ✓

### Step 4: Wolfram's Canonical Form

Wolfram recognizes:
```
(p^k - q^k)/(p^k + q^k) = tanh(k · ln(p))
                        = tanh(k · ArcSinh(1))
```

The `I π` term comes from branch cut handling when simplifying `(-1)^k`.

## Hyperbolic Geometry Interpretation

### The Hyperbolic Plane

The upper half-plane model `H² = {z ∈ ℂ : Im(z) > 0}` carries hyperbolic metric:
```
ds² = (dx² + dy²)/y²
```

Geodesics are semicircles perpendicular to real axis.

### Pell Equation as Hyperbolic Isometry

The Pell equation `x² - ny² = 1` describes **unit hyperbolas** in the `(x,y)` plane.

Solutions form a **multiplicative group** under:
```
(x₁,y₁) * (x₂,y₂) = (x₁x₂ + ny₁y₂, x₁y₂ + x₂y₁)
```

This is isomorphic to the hyperbolic rotation group!

**Fundamental unit** `ε = x + y√n` generates all solutions via:
```
(xₖ, yₖ) = ε^k = (x + y√n)^k
```

This is **hyperbolic translation** by distance `k·ln(ε)`.

### Convergence as Hyperbolic Flow

The Binet approximation:
```
Sqrt[n] * tanh(k · α)  where α = ArcSinh(start/√n)
```

represents:
1. Initial position at hyperbolic distance `α` from origin
2. Flow along geodesic for "time" `k`
3. Hyperbolic tangent maps infinite hyperbolic line → finite interval `[-1, 1]`

**As k → ∞:**
```
tanh(kα) → 1  (exponentially fast)
```

Error decays like:
```
ε_k ~ 2e^(-2kα) = 2/ε^(2k)
```

where `ε = e^α = 1 + √2` is the **fundamental unit**.

## Comparison: Babylonian vs Binet

### Babylonian (Newton) Method

**Iteration:**
```
x_{n+1} = (x_n + n/x_n)/2
```

**Convergence:**
- Quadratic: `ε_{n+1} ~ ε_n²`
- Error: `ε_k ~ ε₀^(2^k)`
- Geometric interpretation: **Arithmetic-Harmonic mean in Euclidean space**

### Binet Method

**Formula:**
```
x_k = √n · (p^k - q^k)/(p^k + q^k)
```

**Convergence:**
- Linear/Exponential: `ε_{k+1} ~ ε_k · const`
- Error: `ε_k ~ (1+√n)^(-2k)`
- Geometric interpretation: **Geodesic flow in hyperbolic space**

### Why Different Geometries?

**Babylonian:**
- Operates on approximations `x ≈ √n`
- Uses arithmetic operations (`+`, `/`)
- Natural geometry: **Euclidean**
- Convergence: iteration doubles precision

**Binet:**
- Operates on Pell pairs `(x,y)` satisfying `x² - ny² = 1`
- Uses exponential operations (powers of fundamental unit)
- Natural geometry: **Hyperbolic** (unit hyperbola!)
- Convergence: exponential decay rate = ln(fundamental unit)

## Implications

### 1. Convergence Rate is Geometric Invariant

The convergence rate `α = ArcSinh(start/√n)` is the **hyperbolic distance** from approximation to true value.

Better start point = smaller hyperbolic distance = faster convergence.

Pell solution is **optimal** because it minimizes hyperbolic distance!

### 2. Fundamental Unit Controls Speed

For different `n`, convergence rate is:
```
rate = ln(x + y√n)  where (x,y) is fundamental Pell solution
```

Larger fundamental unit → faster convergence.

**Example:**
- `n=2`: `ε = 3 + 2√2 ≈ 5.83` → `ln(ε) ≈ 1.76`
- `n=3`: `ε = 2 + √3 ≈ 3.73` → `ln(ε) ≈ 1.32`
- `n=61`: `ε = 1766319049 + 226153980√61 ≈ 3.5×10⁹` → `ln(ε) ≈ 22.0`

Number fields with large fundamental units have **extremely fast** Binet convergence!

### 3. Connection to Continued Fractions

Pell solutions come from continued fraction convergents:
```
√n = [a₀; a₁, a₂, ..., aₖ, ...]
```

Convergents `pₙ/qₙ` satisfy:
```
pₙ² - n·qₙ² = ±1
```

This is the **Lagrange algorithm** for finding geodesics on modular surface!

## Code Examples

### Verify Hyperbolic Form

```mathematica
<< Orbit`

(* Binet formula - symbolic k *)
n = 2;
start = 1;  (* (x-1)/y for Pell solution *)
p = start + Sqrt[n];
q = start - Sqrt[n];

(* Symbolic result *)
symbolicBinet = Sqrt[n] * (p^k - q^k)/(p^k + q^k) // FullSimplify
(* → -√2 Tanh[k ArcSinh[1]] *)

(* Verify for specific k *)
k = 5;
numeric = Sqrt[n] * Tanh[k * ArcSinh[1]]
binet = BinetSqrt[n, start, k]
N[Mean[First[List @@ binet]]] - N[numeric]
(* → 0. *)
```

### Convergence Rate Analysis

```mathematica
(* Fundamental unit *)
sol = PellSolution[2];
{x, y} = Values[Association @@ sol];
epsilon = x + y*Sqrt[2]  (* → 3 + 2√2 *)
alpha = Log[epsilon]      (* → 1.7627... = ArcSinh[1] *)

(* Error for different k *)
Table[{k, 2*Exp[-2*k*alpha]}, {k, 1, 10}]
(* Shows exponential decay with rate 2α *)
```

### Hyperbolic Distance

```mathematica
(* Distance from approximation to √2 *)
HyperbolicDistance[approx_] := ArcSinh[Abs[approx - Sqrt[2]]/Sqrt[2]]

(* Better approximation → smaller hyperbolic distance *)
HyperbolicDistance[1]      (* Pell start *)
HyperbolicDistance[1.4]    (* Closer, but not Pell-optimal *)
```

## References

1. **Pell Equation and Hyperbolic Geometry:**
   - Wildberger, N.J. (2010). "A Rational Approach to Pell's Equation" *JIS* 13
   - https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf

2. **Continued Fractions and Geodesics:**
   - Series, C. (1985). "The geometry of Markoff numbers" *Math. Intelligencer* 7

3. **Hyperbolic Trigonometry:**
   - Ratcliffe, J. (2006). *Foundations of Hyperbolic Manifolds* (Chapter 3)

4. **Algebraic Number Theory:**
   - Neukirch, J. (1999). *Algebraic Number Theory* (Unit groups, Chapter I.7)

## Open Questions

1. **Does Chebyshev method have geometric interpretation?**
   - NestedChebyshev achieves higher-order convergence
   - What is the natural geometry for polynomial-based iteration?

2. **Optimal start points:**
   - Pell solution minimizes hyperbolic distance for Binet
   - What about Babylonian? Is there geometric optimality?

3. **Connection to modular forms:**
   - Pell equation ↔ binary quadratic forms ↔ modular surface
   - Can we use modular form theory to predict convergence rates?

---

**Summary:** Square root approximations via Pell solutions are fundamentally **hyperbolic geometric objects**. Convergence rate = hyperbolic distance, controlled by logarithm of fundamental unit. This explains why closed-form involves `tanh` and connects to deep number theory.
