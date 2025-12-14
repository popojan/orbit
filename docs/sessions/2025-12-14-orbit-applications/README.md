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

8. **Rational neural networks:** ✅ **SOLVED** — Training in ℚ works! See below.

---

## 12. Training Neural Networks in ℚ

**Result:** Gradient descent works entirely in rational arithmetic.

**Key insight:** Piecewise linear sigmoid → piecewise constant derivative → rational gradients.

| Component | How it stays in ℚ |
|-----------|-------------------|
| Initialization | Farey sequence elements |
| Forward pass | Orbit sigmoid (piecewise linear) |
| Gradients | Slopes are rational constants |
| Loss | Squared error `(y-t)²` |
| Updates | `w - η·∇` with rational lr |
| Denominator control | `limit_denominator()` (Farey approx) |

**XOR learned from random init:**
```
Epoch   0: loss=1.46, acc=2/4
Epoch 100: loss=0.61, acc=4/4
Epoch 450: loss=0.009, acc=4/4

Final weights (exact fractions):
  H1: w=[-426627/73804, 497801/85282], b=-237879/70790
  Out: w=[665597/89515, 348029/45865], b=-203391/54811
```

**Benefits:**
- Exact reproducibility (bit-identical across platforms)
- Formal verification possible
- No floating point drift in long inference chains
- Denominators stay bounded (~100k with Farey approximation)

**Implementation:** `scripts/rational_nn_poc.py`

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

## 13. Hyperparameters

The orbit sigmoid has two key hyperparameters:

| Parameter | Description | Default | Effect |
|-----------|-------------|---------|--------|
| **I** (invariant) | Orbit signature product A×B | 19 | Determines LUT points, smoothness |
| **max_denom** | Maximum denominator in orbit | 10000 | Controls orbit size, approximation quality |

**Smoothness analysis** (Section 10) used max_denom=10000. Results for different I:

| I | n points | Logit gap ratio | Notes |
|---|----------|-----------------|-------|
| 1 | 27 | 1.0 (perfect) | Sparse but uniform |
| 3 | 50 | ~2.5 | |
| 7 | 48 | ~3.0 | |
| **19** | 46 | **2.0** | Sweet spot |
| 21 | 88 | 5.9 | More points but less uniform |

Increasing max_denom adds more orbit points (finer approximation) at cost of larger LUT.

---

## 14. Related Work & References

### Prior Art

**Formal verification of NNs with rational weights:**
- Ehlers, R. (2017). [Formal Verification of Piece-Wise Linear Feed-Forward Neural Networks](https://arxiv.org/abs/1705.01320). *ATVA 2017*. — Requires rational weights for decidability.
- Bunel et al. (2018). [A Unified View of Piecewise Linear Neural Network Verification](https://www.robots.ox.ac.uk/~tvg/publications/2018/nn_verif.pdf). *NeurIPS 2018*.

**Rational activation functions:**
- Boullé, N., Nakatsukasa, Y., Townsend, A. (2020). [Rational Neural Networks](https://www.maths.ox.ac.uk/node/39104). *NeurIPS 2020*. — Uses P(x)/Q(x) activations, not exact arithmetic.

**Neural arithmetic:**
- Madsen, A., Johansen, A. (2020). [Neural Arithmetic Units](https://arxiv.org/abs/2001.05016). *ICLR 2020*. — NNs that learn arithmetic operations.

### Our Specific Contribution

What distinguishes this work from prior art:

1. **Orbit-based LUT construction**: Sigmoid breakpoints come from Möbius involution orbits, not arbitrary piecewise linear approximation. This gives mathematical structure (ln(2) gaps).

2. **Training from scratch in ℚ**: Prior work typically trains in floats, then converts to rationals for verification. We train entirely in ℚ.

3. **Farey initialization**: Weight initialization using Farey sequence elements (native to ℚ).

4. **Tunable invariant I**: The orbit invariant is a hyperparameter affecting smoothness/accuracy trade-off. This is novel.

**Honest assessment**: The core idea (piecewise linear + rational arithmetic) is known. Our contribution is the specific orbit-based construction and end-to-end ℚ training POC.

---

## References

- Paper: `docs/papers/involution-decomposition.tex` — Main theoretical results
- Module: `Orbit/Kernel/MoebiusInvolutions.wl` — Implementation
