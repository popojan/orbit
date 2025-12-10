# CF ↔ Egyptian Fractions Equivalence

**Created:** 2025-12-10
**Status:** 🔬 NUMERICALLY VERIFIED, proof needed
**Context:** Relationship between continued fractions and Raw Egyptian fraction representation

---

## Overview

The Orbit paclet's `EgyptianFractions` function uses two algorithms that produce **identical results**:
1. **ModInv algorithm** (`RawFractionsSymbolic`) — modular inverse iteration
2. **CF algorithm** (`RawFractionsFromCF`) — continued fraction pairing

This document explores the equivalence and its implications.

---

## The Theorem (from EgyptianFractions.wl)

```
Connection to continued fractions (THEOREM):
  Egypt values = Total /@ Partition[Differences @ Convergents[q], 2]

  - CF differences alternate: +d₁, -d₂, +d₃, -d₄, ...
  - Pairing cancels alternation: (d₁ - d₂), (d₃ - d₄), ... all positive
  - This explains WHY Egypt is monotone: paired differences yield positive increments.
```

### Verification

```mathematica
q = 219/344;  (* approximation of 2/π *)

convs = Convergents[q];
(* {0, 1, 1/2, 2/3, 7/11, 219/344} *)

diffs = Differences[convs];
(* {1, -1/2, 1/6, -1/33, 1/3784} — alternating signs! *)

paired = Total /@ Partition[diffs, 2];
(* {1/2, 3/22} — always positive! *)

(* Matches first two Raw tuple values *)
```

### Key Identity

```mathematica
RawFractionsFromCF[q] === RawFractionsSymbolic[q]  (* TRUE for all 0 < q < 1 *)
```

---

## Algorithms Compared

### 1. ModInv Algorithm (RawFractionsSymbolic)

```mathematica
While[a > 0 && b > 1,
  v = PowerMod[-a, -1, b];  (* Modular inverse *)
  {t, a} = QuotientRemainder[a, (1 + a*v)/b];
  b -= t*v;
  PrependTo[result, {b, v, 1, t}];
];
```

### 2. CF Algorithm (RawFractionsFromCF)

```mathematica
RawStep[{a1_, b1_, 1, j1_}, {b2_, j2_}] := {#, b1 + b2 * #, 1, j2} &[a1 + j1 * b1]

cf = ContinuedFraction[q];
pairs = Partition[Drop[cf, 1], 2];
FoldList[RawStep, {1, 0, 1, 0}, pairs]
```

---

## Why Egypt is Monotone (Key Insight)

**CF convergents alternate above/below the target:**
```
p₁/q₁ < p₃/q₃ < p₅/q₅ < ... < x < ... < p₄/q₄ < p₂/q₂
```

**CF differences alternate signs:**
```
d₁ = +, d₂ = -, d₃ = +, d₄ = -, ...
```

**Pairing cancels alternation:**
```
(d₁ - d₂) = (+) - (-) = positive
(d₃ - d₄) = (+) - (-) = positive
```

**Therefore Egypt partial sums are strictly increasing!**

---

## Open Problems (for paper extension)

### Problem 1: Tuple Identity Proof

**Conjecture:** For all 0 < q < 1:
```
RawFractionsSymbolic[q] === RawFractionsFromCF[q]
```

**Status:** Numerically verified, algebraic proof needed.

**Approach hints:**
- ModInv: `v = (-a)^(-1) mod b`, iterates on (a, b)
- CF: pairs `[a₁, a₂]` via `RawStep` recurrence
- Both reduce to Euclidean algorithm structure?
- Key: show tuple parameters `(u, v, i, j)` match at each step

**What would constitute proof:**
- Show ModInv iteration ↔ CF coefficient pairing bijection
- Or: derive one algorithm from the other algebraically

---

### Problem 2: Irrational Extension

**Question:** How to define Egypt representation for irrationals?

**Proposal:**
```
Egypt(x) = lim_{n→∞} Egypt(pₙ/qₙ)  where pₙ/qₙ are CF convergents
```

**Properties to prove:**
1. Sequence of tuple lists is "compatible" (prefixes preserved?)
2. Partial sums converge monotonically to x
3. Rate of convergence vs CF convergents

**Example (2/π):**
```
Conv 5: 7/11     → {{1,1,1,1}, {2,3,1,3}}
Conv 6: 219/344  → {{1,1,1,1}, {2,3,1,3}, {11,333,1,1}}
Conv 7: 226/355  → {{1,1,1,1}, {2,3,1,3}, {11,344,1,1}}  ← tuple changes!
```

**Open:** Does tuple list stabilize, or keep changing?

---

### Problem 3: Structural Insights

**What does Raw format reveal that CF doesn't?**
- Bifurcation in shared prefixes (pyramid research)
- Telescoping interpretation (algebraic structure)
- Arithmetic progressions in denominators

**Complexity:**
- CF: O(log q) partial quotients
- Raw: O(log q) tuples (same asymptotic?)
- But Raw tuples encode *ranges* of unit fractions

---

## Example: 2/π Approximation

```mathematica
q = 219/344;  (* 6th convergent of 2/π *)

Raw = {{1,1,1,1}, {2,3,1,3}, {11,333,1,1}}

Tuple values:
  {1,1,1,1}   → 1/2      = 0.5
  {2,3,1,3}   → 3/22     ≈ 0.136
  {11,333,1,1} → 1/3784  ≈ 0.000264

Partial sums: 0.5, 0.636, 0.6366...  (monotone!)
```

---

## References

- `Orbit/Kernel/EgyptianFractions.wl` — implementation
- Session: [2025-12-08-gamma-framework](../2025-12-08-gamma-framework/) — Raw format discovery in pyramid context
