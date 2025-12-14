# Orbit Applications - Research Directions

**Date:** December 14, 2025
**Status:** Ideas for future exploration

After implementing the `MoebiusInvolutions` module with proper orbit signatures, we identified several potential applications and research directions.

---

## Background

The group ⟨σ, κ⟩ acts on (0,1)∩ℚ where:
- σ(x) = (1-x)/(1+x) — silver involution
- κ(x) = 1-x — copper involution

**Complete invariant:** Orbit signature {A, B} where:
- A = odd(p), B = odd(q-p) for canonical form
- gcd(A, B) = 1
- A ≤ B

**Canonical form:** A/(A+B) — unique representative with smallest numerator

---

## 1. Fraction Compression

**Idea:** Represent any fraction as (canonical, path)

```mathematica
q = 15/17
CanonicalRep[q] → 1/2
ToCanonicalPath[q] → {{"σ", "κ", "σ", "κ"}, 1/2}
```

**Potential benefit:** For fractions with large numerator/denominator but simple orbit structure, the path representation could be more compact.

**Questions:**
- When is path encoding shorter than direct p/q?
- Connection to continued fraction length?

---

## 2. Fast Orbit Membership Test

**Idea:** Test if two fractions are σκ-related in O(log q) time

```mathematica
SameOrbit[3/8, 5/11] → True   (* both have signature {3,5} *)
SameOrbit[3/8, 1/16] → False  (* {3,5} vs {1,15}, same I=15! *)
```

**Key insight:** Same invariant I is necessary but NOT sufficient. Must check full signature {A, B}.

**Applications:**
- Equivalence classes for pattern matching
- Deduplication in fraction databases

---

## 3. Factorization Detector

**Idea:** Number of orbits for invariant I reveals prime factorization structure

```
I = p₁·p₂·...·pₖ  →  2^(k-1) distinct orbits
```

| I | Factorization | # Orbits | Signatures |
|---|---------------|----------|------------|
| 3 | prime | 1 | {1,3} |
| 15 | 3×5 | 2 | {1,15}, {3,5} |
| 105 | 3×5×7 | 4 | {1,105}, {3,35}, {5,21}, {7,15} |

**Implication:** Counting orbits gives ω(I) = number of distinct prime factors.

---

## 4. Egyptian Fraction Transformations

**Observation:** κ induces systematic transformation on Egypt tuples

```
κ: {1, v, 1, 1} ↔ {1, 1, 1, v}
   1/(1+v)      ↔   v/(1+v)
```

Examples:
- 1/4 → {{1, 3, 1, 1}} and 3/4 → {{1, 1, 1, 3}}
- 1/5 → {{1, 4, 1, 1}} and 4/5 → {{1, 1, 1, 4}}

**Questions:**
- What transformation does σ induce on Egypt tuples?
- Is there a group action on the tuple space?
- Do orbit-related fractions have similar Egypt complexity?

---

## 5. Orbit Enumeration Bijection

**Theorem:** There is a bijection

```
Orbits under ⟨σ,κ⟩  ↔  {(A, B) : A ≤ B, A,B odd, gcd(A,B) = 1}
```

**Canonical representative:** A/(A+B)

**Counting:**

| max I | # Orbits |
|-------|----------|
| 10 | 5 |
| 50 | 31 |
| 100 | 70 |
| 500 | 429 |
| 1000 | 923 |

Growth is approximately linear in n (coprimality gives factor 6/π²).

---

## 6. Farey Sequence Orbit Structure

**Observation:** Farey(n) partitions naturally into orbits

```mathematica
Farey(17): 95 fractions → 16 orbits
Average orbit size: ~6 fractions
```

Largest orbits contain "common" fractions like 1/4, 3/4, 2/5, 3/5, ...

**Questions:**
- Asymptotic distribution of orbit sizes in Farey(n)?
- Which orbits grow fastest with n?

---

## 7. Normalization for ML/Pattern Recognition

**Idea:** Reduce all fractions to canonical form before analysis

**Benefits:**
- Smaller feature space
- Symmetry exploitation "for free"
- κ-invariance built in

**Example:** Instead of treating 3/8 and 5/8 as different, map both to canonical 3/8.

---

## 8. Convergent Analysis

**Question:** Do convergents of quadratic irrationals have special orbit properties?

**Observation:** Convergents of √2-1 (fixed point of σ!) have varying signatures:

| Convergent | Signature | I |
|------------|-----------|---|
| 1/2 | {1,1} | 1 |
| 2/5 | {1,3} | 3 |
| 5/12 | {5,7} | 35 |
| 12/29 | {3,17} | 51 |

No obvious pattern yet. Worth investigating for:
- Golden ratio convergents (Fibonacci)
- Other quadratic surds

---

## 9. Connection to Calkin-Wilf Tree

The full group ⟨σ, κ, ι⟩ generates the Calkin-Wilf tree (transitive on ℚ⁺).

**Question:** How do ⟨σ,κ⟩ orbits relate to CW tree structure?

Each orbit is a "slice" of the tree connected by ι (inversion).

---

## 10. Sigmoid Quantization (Potential ML Application)

**Discovery:** Sorted orbit values naturally form sigmoid curves. Some invariants give remarkably smooth sigmoids suitable for piecewise-linear approximation.

**Key finding:** In logit space, orbit gaps are multiples of **ln(2)** (fundamental!).

| I | n points | Logit gap ratio | PWL max error |
|---|----------|-----------------|---------------|
| 1 | 19 | **1.0** (perfect) | 0.55% |
| **19** | 30 | **2.0** | **0.14%** |
| 27 | 28 | 2.0 | 0.14% |
| 21 | 60 | 5.9 | 0.11% |

**I=19 is the sweet spot:** 30 points (5 bits), nearly uniform logit spacing, 0.14% max error.

**Why ln(2)?** The operations σκ: y → y/2 and κσ: y → 2y scale logit by ±ln(2).

**Potential applications:**
- Edge inference without FPU
- LSTM/GRU gate quantization
- Deterministic sigmoid (no float drift)
- Binary classification output layer

**Implementations:**
- `scripts/orbit_sigmoid.py` — Python orbit sigmoid class
- `scripts/orbit_sigmoid_test.cpp` — C++ benchmark (vs std::exp)
- `scripts/rational_nn_poc.py` — Rational neural network POC (XOR)

---

## 11. Open Problems

1. **Asymptotic orbit count:** Exact formula for #{orbits with I ≤ n}?

2. **Egypt-orbit correspondence:** Complete characterization of how σ,κ transform Egypt tuples?

3. **Optimal path finding:** Given two fractions in same orbit, find shortest σκ-path between them?

4. **Irrational extensions:** The involutions extend to ℝ. What are the "orbits" of irrational numbers under ⟨σ,κ⟩? (Dense in (0,1)?)

5. **Higher-dimensional analogues:** Can this orbit structure generalize to ℚⁿ?

6. **Why is I=19 special?** Among all prime invariants, I=19 gives the smoothest sigmoid (lowest logit-space gap ratio after I=1). What makes 19 special in this context? Is there a number-theoretic explanation involving 19, ln(2), and the orbit structure?

7. **Optimal invariant for n points:** Given a target number of LUT entries, which invariant I minimizes PWL error? Is there a closed-form relationship?

8. **Rational neural networks:** Can orbit sigmoid enable fully rational neural networks? Benefits: exact reproducibility, formal verification, no float drift. Challenge: training (gradient descent in ℚ?).

---

## Code Examples

```mathematica
<< Orbit`

(* Basic operations *)
CanonicalRep[5/8]           (* → 3/8 *)
OrbitSignature[5/8]         (* → {3, 5} *)
SameOrbit[3/8, 5/11]        (* → True *)
ToCanonicalPath[15/17]      (* → {{"σ","κ","σ","κ"}, 1/2} *)

(* Farey orbit analysis *)
grouped = GroupBy[Most@Rest@FareySequence[20], CanonicalRep];
Length[grouped]  (* number of orbits in Farey(20) *)
```

---

## References

- Paper: `docs/papers/involution-decomposition.tex` — Main theoretical results
- Module: `Orbit/Kernel/MoebiusInvolutions.wl` — Implementation
