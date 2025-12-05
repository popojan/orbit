# L-Functions, Class Numbers, and Chebyshev Geometry

**Date:** December 5, 2025
**Context:** Connection discovered during sign-cosine identity research
**Prerequisites:** [character-sums-introduction.md](character-sums-introduction.md), [multiplicative-characters.wl](multiplicative-characters.wl)

---

## Overview

This document explains the remarkable three-level bridge:

```
GEOMETRY              ALGEBRA                 ANALYSIS
─────────             ───────                 ────────
Chebyshev lobes   →   Character sums     →   L-functions
sign(cos) = ±1        S(1, p/4)              L(1, χ)
small vs large        (finite!)              (infinite series)
```

The key insight: **L(1, χ) can be computed via finite sums**, and our sign-cosine formula gives geometric meaning to these sums.

---

## 1. The L-Function

### Definition

The Dirichlet L-function for a character χ is:

$$L(s, \chi) = \sum_{n=1}^{\infty} \frac{\chi(n)}{n^s}$$

At s = 1 (for non-principal χ), this converges to a finite value L(1, χ).

### Why It Matters

The **Dirichlet class number formula** connects L(1, χ) to class numbers:

$$h(-D) = \frac{\sqrt{D}}{\pi} \cdot L(1, \chi_D)$$

where D is the (absolute value of) discriminant and χ_D is the Kronecker symbol.

---

## 2. The Miracle: Infinite Series = Finite Sum

### For p ≡ 1 (mod 4)

The twisted L-function L(1, χ₄χₚ) satisfies:

$$L(1, \chi_4 \chi_p) = \frac{\pi}{\sqrt{p}} \cdot S(1, p/4)$$

where:

$$S(1, p/4) = \sum_{k=1}^{(p-1)/4} \chi_p(k) = \sum_{k=1}^{(p-1)/4} \left(\frac{k}{p}\right)$$

**This is remarkable:**
- Left side: Infinite series Σ χ(n)/n
- Right side: Finite sum of ~p/4 Legendre symbols!

### Numerical Verification

| p | S(1, p/4) | (π/√p)·S | L(1, χ₄χₚ) direct | Match |
|---|-----------|----------|-------------------|-------|
| 5 | 1 | 1.4050 | 1.4049 | ✓ |
| 17 | 2 | 1.5239 | 1.5239 | ✓ |
| 29 | 3 | 1.7501 | 1.7501 | ✓ |
| 41 | 4 | 1.9625 | 1.9625 | ✓ |

---

## 3. Connection to Our Sign-Cosine Formula

### The Chain

From our [sign-cosine identity paper](../papers/sign-cosine-identity.tex):

$$W(p) = \sum_{k=1}^{p-1} \chi(k) \cdot \text{sign}\left(\cos\frac{(2k-1)\pi}{p}\right) = 4 \cdot S(1, p/4) - 2$$

Combined with h(-p) = 2·S(1, p/4):

$$W(p) = 2h(-p) - 2$$

### The Full Bridge

```
W(p) = 4S - 2                      [Our formula]
     ↓
S(1, p/4) = (W + 2)/4              [Algebra]
     ↓
L(1, χ₄χₚ) = (π/√p) · S            [Classical identity]
     ↓
h(-p) = (2√p/π) · L(1, χ₄χₚ)       [Class number formula]
```

### Geometric Interpretation of L(1, χ)

Since S(1, p/4) counts "character-weighted quarter-interval", and our sign-cosine formula shows this equals lobe-weighted sums:

$$L(1, \chi_4\chi_p) = \frac{\pi}{\sqrt{p}} \cdot \frac{(\Sigma\chi_{\text{small lobes}}) - (\Sigma\chi_{\text{large lobes}}) + 2}{4}$$

**The L-function value encodes Chebyshev lobe geometry!**

---

## 4. Why Subexponential Algorithms Are Faster

### Our Approach: O(p)

We compute S(1, p/4) directly:
- Sum p/4 Legendre symbols
- Each Legendre symbol: O(log p)
- Total: O(p log p)

### Subexponential Approach: O(D^{1/4+ε})

PARI/GP and similar systems use:

1. **Baby-step giant-step in class group** - find group structure in O(√h) operations
2. **Relation finding** - lattice reduction techniques
3. **Analytic approximation** - evaluate L(1, χ) via functional equation

For p = 10^8:
- Our method: ~25 million operations
- Subexp method: ~100 operations

### Why The Difference?

Our finite sum formula is **exact but brute-force**. We sum O(p) terms.

Subexponential methods **exploit group structure**:
- Class group Cl(K) has order h
- Don't enumerate; use algebraic shortcuts
- Similar in spirit to Pollard's rho for factoring

---

## 5. Inverting the Formula

### From L-function to Our Sums

Given L(1, χ₄χₚ), we can recover everything:

```mathematica
(* Given L-value, compute geometric quantities *)
fromL[p_, Lval_] := Module[{S, W, h},
  S = Sqrt[p]/Pi * Lval;        (* Quarter sum *)
  h = 2 * S;                     (* Class number *)
  W = 4*S - 2;                   (* Our weighted sum *)
  <|"S" -> S, "h" -> h, "W" -> W|>
];
```

### From Geometry to L-function

```mathematica
(* Given Chebyshev lobe data, compute L-value *)
toLfunction[p_] := Module[{W, S},
  W = Sum[JacobiSymbol[k, p] * Sign[Cos[(2k-1) Pi/p]], {k, 1, p-1}];
  S = (W + 2)/4;
  Pi/Sqrt[p] * S
];
```

---

## 6. The Three Worlds

| Aspect | Geometry | Algebra | Analysis |
|--------|----------|---------|----------|
| Object | Chebyshev p-gon lobes | Character sum S | L-function L(1,χ) |
| Nature | Finite, visual | Finite, combinatorial | Infinite, analytic |
| Key formula | B(k) = 1 + β·cos(...) | S = Σχ(k) | L = Σχ(n)/n |
| Information | Lobe sizes | Residue distribution | Arithmetic invariant |
| Computation | Count sign(cos) | Sum Legendre symbols | Dirichlet series |

**The miracle:** All three encode the SAME number h(-p)!

---

## 7. Classical Sources for Finite L-Formulas

### Primary Reference

**Chattopadhyay et al. (2020)** [arXiv:1810.00227](https://arxiv.org/abs/1810.00227)
- Lemma 2(2): S(1, p/4) = (√p/π) · L(1, χ₄χₚ)

### Other Finite Formulas

1. **For p ≡ 3 (mod 4):**
   $$L(1, \chi_p) = \frac{\pi}{p\sqrt{p}} \sum_{a=1}^{p-1} a \cdot \chi(a)$$

2. **Log-tangent formula:**
   $$L(1, \chi_p) = \frac{1}{\sqrt{p}} \sum_{a=1}^{(p-1)/2} \chi(a) \log\tan\frac{a\pi}{p}$$

3. **Cotangent formula:**
   $$h(-p) = -\frac{1}{p} \sum_{a=1}^{p-1} a \cdot \chi(a) \quad \text{(for } p \equiv 3 \text{ mod } 4\text{)}$$

---

## 8. Computational Demonstration

```mathematica
(* Complete demonstration of the three-level bridge *)

(* Level 1: Geometry - Chebyshev lobe classification *)
classifyLobes[p_] := Module[{beta, lobes},
  beta = p^2 Cos[Pi/p] / (4 - p^2);
  lobes = Table[
    {k, 1 + beta Cos[(2k-1) Pi/p], Sign[Cos[(2k-1) Pi/p]]},
    {k, 1, p-1}
  ];
  <|"small" -> Select[lobes, #[[2]] < 1 &],
    "large" -> Select[lobes, #[[2]] > 1 &]|>
];

(* Level 2: Algebra - Character sum *)
quarterSum[p_] := Sum[JacobiSymbol[k, p], {k, 1, (p-1)/4}];
weightedSum[p_] := Sum[JacobiSymbol[k, p] Sign[Cos[(2k-1) Pi/p]], {k, 1, p-1}];

(* Level 3: Analysis - L-function *)
twistedL[p_, terms_: 50000] := N[Sum[
  If[OddQ[n], (-1)^((n-1)/2), 0] JacobiSymbol[n, p] / n,
  {n, 1, terms}
], 10];

(* Verify the bridge for p = 41 *)
p = 41;
S = quarterSum[p];
W = weightedSum[p];
h = NumberFieldClassNumber[Sqrt[-p]];
L = twistedL[p];

Print["p = ", p];
Print["Quarter sum S(1,p/4) = ", S];
Print["Weighted sum W(p) = ", W];
Print["Class number h(-p) = ", h];
Print["L(1, χ₄χₚ) = ", L];
Print[];
Print["Verifications:"];
Print["  W = 4S - 2: ", W == 4*S - 2];
Print["  h = 2S: ", h == 2*S];
Print["  L ≈ (π/√p)S: ", Abs[L - N[Pi/Sqrt[p] * S]] < 0.0001];
```

Output:
```
p = 41
Quarter sum S(1,p/4) = 4
Weighted sum W(p) = 14
Class number h(-p) = 8
L(1, χ₄χₚ) = 1.96250...

Verifications:
  W = 4S - 2: True
  h = 2S: True
  L ≈ (π/√p)S: True
```

---

## 9. Open Questions

1. **Can we give geometric meaning to other L-function values?**
   - What about L(2, χ), L(3, χ)?
   - Do higher Chebyshev harmonics appear?

2. **Generalization to composite n?**
   - Our sign-cosine works for any n
   - What does it compute for composite moduli?

3. **Connection to subexponential algorithms?**
   - Can geometric intuition suggest new computational approaches?
   - Baby-step giant-step in "lobe space"?

---

## References

1. Chattopadhyay, Roy, Sarkar & Thangadurai (2020). [arXiv:1810.00227](https://arxiv.org/abs/1810.00227)
2. Ireland & Rosen, *A Classical Introduction to Modern Number Theory*, Ch. 16
3. Washington, *Introduction to Cyclotomic Fields*, Ch. 4
4. Our paper: [sign-cosine-identity.tex](../papers/sign-cosine-identity.tex)
