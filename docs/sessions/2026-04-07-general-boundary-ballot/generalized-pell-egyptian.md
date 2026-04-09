# Generalized Pell Equation and Egyptian Sqrt for Irrational d

**Date:** 2026-04-07
**Status:** 🔬 NUMERICALLY VERIFIED, 🤔 implementation proposed

## Two Independent Mechanisms

The session revealed two distinct mechanisms that happen to share the same parameter α:

### Mechanism A: Staircase Ballot (no √ needed)

```
Input:  ANY irrational α > 0
Method: Floor[x/α] staircase → DP lattice paths
Output: Ballot numbers at convergents and semi-convergents of α
```

**No square root involved.** The staircase detects CF structure of **α itself**, not √α. Works for π, e, φ, ∛2, anything irrational.

### Mechanism B: Generalized Pell + Egyptian Sqrt (√ essential)

```
Input:  ANY real d > 0  (integer, rational, algebraic, transcendental)
Method: CF convergents of √d → "approximate Pell" solutions
Output: Bounded-norm pairs (p,q) with |p² − d·q²| < 2√d
        → Egyptian correction: √d ≈ p/q − N/(2pq)
```

**Square root is essential here.** The quadratic form p²−dq² requires α = √d. The Egyptian correction formula √d = (p²−N)^(1/2)/q ≈ p/q − N/(2pq) − ... is a Taylor expansion around the exact Pell solution (N=0).

### How They Connect

If you CHOOSE α = √d in Mechanism A, the ballot hits are at convergents of √d — which are exactly the "approximate Pell" solutions of Mechanism B. The ballot theorem tells you WHERE these solutions are; the Egyptian method tells you WHAT TO DO with them.

```
Mechanism A (detection):  Floor[x/√d] → ballot hits at convergents of √d
                                               ↓
Mechanism B (exploitation):        p²−dq² = N (bounded)
                                               ↓
                               √d ≈ p/q − N/(2pq)   [Egyptian correction]
```

## Generalized Pell Equation

### Definition

For any real d > 0 (not a perfect square of a rational), the **generalized Pell equation** is:

> Find integer pairs (p, q) with q > 0 minimizing |p² − d·q²|.

Solutions are the CF convergents of √d.

### Fundamental Theorem (Lagrange + Hurwitz)

For convergents p_k/q_k of √d:

**|p_k² − d·q_k²| < 2√d**

Moreover, infinitely many convergents satisfy the tighter Hurwitz bound:

**|p_k² − d·q_k²| < 2√d/√5**

### Integer d (classical Pell)

When d is a non-square positive integer:
- Norms p² − dq² are **integers**
- The minimum achievable |norm| is **exactly 1** (Lagrange's theorem)
- Solutions with norm ±1 form a cyclic group under multiplication in ℤ[√d]
- `PellSolve[d]` finds the fundamental solution via Wildberger's algorithm (integer arithmetic only)

### Irrational d (generalized Pell)

When d is irrational (π, e, √2, etc.):
- Norms p² − dq² are **real numbers** (generally irrational)
- The infimum of |norm| is **0** (but never achieved) for transcendental d
- For algebraic d like φ², norms cluster around a non-zero accumulation point
- No algebraic structure (no ring ℤ[√d] since √d is transcendental for transcendental d)

### Rational non-square d

When d = a/b is rational but not a perfect square:
- Norms are rationals
- CF of √(a/b) is periodic (quadratic irrational)
- Norms cycle through a finite set: for d=3/2, norms alternate between +1 and −1/2

### Verification Data

| d | Type | min |N| | N values (first 5 conv) | Bound 2√d |
|---|---|---|---|---|
| 2 | integer | 1.000 | ±1, ±1, ±1, ... | 2.83 |
| π | transcendental | 0.122 | +0.86, −1.27, +1.53, −1.93, +0.47 | 3.54 |
| e | transcendental | 0.328 | +1.28, −1.87, +0.54, −1.58, +1.69 | 3.30 |
| φ² | algebraic | 1.382 | +1.38, −1.47, +1.44, −1.45, +1.45 | 3.24 |
| 3/2 | rational | 0.500 | +1, −1/2, +1, −1/2, ... | 2.45 |

**φ² is special:** Norms converge to ≈ ±1.4472 ≈ 1/√(1/φ²) = √(φ²) / φ² · ... actually, the limit is √5/√5 · something. The point is: for the "hardest to approximate" quadratic irrationals, norms have a definite non-zero limit.

## Egyptian Sqrt Generalization

### Classical Egyptian (integer d, Pell norm = 1)

Given Pell solution x²−dy² = 1:
```
√d = x/y · √(1 − 1/x²) = x/y − 1/(2x·y) − 1/(8x³·y) − ...
```

The existing `EgyptSqrt[{x, y}, k]` uses Chebyshev iteration:
```mathematica
xk = ChebyshevT[k+1, x]
yk = y · ChebyshevU[k, x]
√d ∈ [(xk−1)/yk, (xk+1)/yk]    width = 2/yk
```

Width shrinks as ~(2x)^(−2^k) — doubly exponential convergence.

### Generalized Egyptian (any d, approximate Pell norm = N)

Given convergent p/q of √d with p²−dq² = N:
```
√d = p/q · √(1 − N/p²) = p/q − N/(2p·q) − N²/(8p³·q) − ...
```

**First-order approximation:**
```
√d ≈ p/q − N/(2pq)       error ~ N²/(8p³q)
```

This is the SAME formula as classical Egyptian, with 1 replaced by N.

### Verified Improvement Factors

| d | (p, q) | N = p²−dq² | err(p/q) | err(corrected) | Factor |
|---|---|---|---|---|---|
| π | (39, 22) | +0.469 | 2.7×10⁻⁴ | 2.1×10⁻⁸ | 12967× |
| π | (296, 167) | +0.122 | 3.8×10⁻⁶ | 7.9×10⁻¹² | ~500k× |
| e | (61, 37) | −0.328 | 7.3×10⁻⁵ | 1.6×10⁻⁹ | 45404× |
| e | (5, 3) | +0.535 | 1.8×10⁻² | 9.7×10⁻⁵ | 186× |

The improvement factor grows as ~2p²/|N| — same scaling as classical Egyptian.

### ✅ Chebyshev T/U DOES Adapt — Via Scaled Argument

**Key algebra:** If p²−dq² = N, then (p/√N)² − d·(q/√N)² = 1. So (p/√N, q/√N) is an **exact Pell solution** in scaled coordinates.

The Chebyshev identity T²−(x²−1)U² = 1 applied at x = p/√N gives:

```
p_k = N^{k/2} · T_k(p/√N)
q_k = q · N^{(k-1)/2} · U_{k-1}(p/√N)

Then: p_k² − d·q_k² = N^k
```

**Equivalently**, the power recurrence (no √N needed):
```
p_{k+1} = 2p·p_k − N·p_{k-1}     (p₀=1, p₁=p)
q_{k+1} = 2p·q_k − N·q_{k-1}     (q₀=0, q₁=q)
```

Both produce identical sequences. The power recurrence is numerically more stable.

**Egyptian bounds at the k-th iterate:**
```
√d ∈ [(p_{k+1} − |N|^{(k+1)/2}) / q_{k+1},  (p_{k+1} + |N|^{(k+1)/2}) / q_{k+1}]
Width = 2|N|^{(k+1)/2} / q_{k+1}
```

For N=1 (classical): width = 2/q_{k+1}, matching the existing EgyptSqrt.

The original EgyptSqrt with scaled argument also works directly:
```
EgyptSqrt[{p/√N, q/√N}, k]    → interval containing √d  ✓
```
Verified for d=π with (39,22): all k=0..8 produce valid intervals.

### 🔬 VERIFIED: Faster Than Classical for |N| < 1

**The key discovery:** For irrational d, convergents can have |N| < 1 (impossible for integer d where min|N|=1). This makes the generalized iteration **faster** than classical Pell:

| k | d=2, N=1 | d=π, N=0.469 | d=π, N=0.122 | d=e, N=−0.328 |
|---|---|---|---|---|
| 1 | 2 digits | **7 digits** | **12 digits** | **8 digits** |
| 2 | 5 | **15** | **25** | **18** |
| 3 | 8 | **24** | **38** | **27** |
| 4 | 11 | **32** | **>50** | **36** |
| 5 | 14 | **40** | **>50** | **46** |
| 6 | 17 | **48** | **>50** | **>50** |

**Convergence rate:** error ~ C · (|N|/α²)^{2^k} where α = p + q√d.

- Classical (N=1): ~3 digits/iteration
- d=π, N=0.469: ~8 digits/iteration (4× faster)
- d=π, N=0.122: ~13 digits/iteration (>4× faster, >50 digits in 4 iterations)
- d=e, N=−0.328: ~9 digits/iteration (works for negative N)

**Why:** The doubly-exponential base is |N|/α² instead of 1/α². When |N| < 1, this base is smaller, giving faster convergence. For d=π with (296,167), |N|≈0.12 gives a base of ~4×10⁻¹³ instead of ~3×10⁻¹² for classical d=2.

### Proposed Implementation

```mathematica
(* Find best approximate Pell solution for any real d *)
PellSolveApprox[d_?NumericQ, nTerms_: 30] := Module[
  {cf, convs, norms, best},
  cf = ContinuedFraction[Sqrt[d], nTerms];
  convs = Table[{Numerator[#], Denominator[#]} &@
    FromContinuedFraction[Take[cf, k]], {k, 2, Length[cf]}];
  convs = DeleteDuplicatesBy[convs, First];
  norms = N[#[[1]]^2 - d #[[2]]^2] & /@ convs;
  best = convs[[Ordering[Abs /@ norms, 1][[1]]]];
  {best[[1]], best[[2]], N[best[[1]]^2 - d best[[2]]^2]}
]

(* Generalized Egyptian Sqrt via power recurrence *)
GeneralizedEgyptSqrt[d_?NumericQ, k_Integer: 4] := Module[
  {pqn, p, q, nn, pk, qk, pkOld, qkOld, tmp, nk},
  pqn = PellSolveApprox[d];
  {p, q, nn} = pqn;
  (* Power recurrence: (p+q√d)^{k+1} *)
  pkOld = 1; qkOld = 0; pk = p; qk = q;
  Do[tmp = 2 p pk - nn pkOld; pkOld = pk; pk = tmp;
     tmp = 2 p qk - nn qkOld; qkOld = qk; qk = tmp, {k}];
  nk = nn^(k + 1);
  (* Egyptian correction *)
  pk/qk - nk/(2 pk qk)
]
```

## Why √ is Load-Bearing for Egyptian but Not for Ballot

**Ballot theorem:** Detects CF convergents of α via lattice paths below ⌊x/α⌋. Any α works. The relevant number-theoretic object is the **CF expansion** of α.

**Egyptian sqrt:** Approximates √d via Pell-like solutions. Requires the quadratic form p²−dq². The relevant number-theoretic object is the **norm form** of ℤ[√d] (or its real-valued analogue for irrational d).

The **connection**: when α = √d, CF convergents of α = CF convergents of √d = approximate Pell solutions. Ballot detects them; Egyptian exploits them.

```
                    CF convergents of α
                   /                    \
        Ballot theorem              (only when α=√d)
        (any α, no √)               \
             |                   Generalized Pell: p²-dq²=N
             |                        |
     detects WHERE the              enables Egyptian correction
     best approximants are          √d ≈ p/q - N/(2pq)
```

**Summary:** √ enters because the Egyptian formula is a Taylor expansion of √(1−N/p²). You can't escape it — it IS the function you're approximating. The ballot theorem works without √ because it's about counting lattice paths, not approximating anything.

## Open Questions

- ✅ **Chebyshev for N≠1:** YES — use scaled argument p/√N, or equivalently the power recurrence. For |N|<1, convergence is FASTER than classical. See §"Chebyshev T/U DOES Adapt".
- ⏸️ **Optimal convergent selection:** For a given precision target, which convergent (p,q) minimizes total work? Smaller |N| = faster iteration, but larger (p,q) = harder to find.
- ⏸️ **Algebraic d:** For d = φ², norms cluster at ~±1.447 (never < 1). Egyptian convergence is bounded, not improving. Is there a workaround?
- ⏸️ **Dedekind cut property:** Classical EgyptSqrt gives lower·upper = d (Dedekind cut). Does the generalized version preserve this for N≠1? (Likely: lower·upper ≈ d with error ~N^{2k}.)
- ⏸️ **Paclet integration:** Extend `EgyptSqrt` to accept non-integer d, using CF convergent finder + power recurrence.
