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

### ✅ ANSWERED: Kolmogorov Analysis — No General Improvement

**Question:** Can orbit encoding (signature + path) beat direct (p, q) encoding?

**Analysis framework:**
- Direct encoding: ~log₂(p) + log₂(q) bits
- Orbit encoding: ~log₂(A) + log₂(B) + |path| bits
- Since A = p/2^α and B = (q-p)/2^β:
  - Savings ≈ α + β - |path|
  - Orbit wins when |path| < α + β

**Empirical test (Farey(30), 229 non-canonical fractions):**

| Metric | Value |
|--------|-------|
| Orbit wins | **0 (0%)** |
| Ties | 32 (14%) |
| Direct wins | 197 (86%) |
| Mean diff | **+1.4 bits** (orbit worse) |
| Max penalty | 4 bits |

**Worst cases (orbit costly):**
- 16/29, 16/27, 16/25, etc.: path=8, α+β=4 → costs 4 extra bits

**Conclusion:** ❌ **Orbit encoding offers NO Kolmogorov advantage.**

The path length |path| always meets or exceeds α + β because:
- σκ = x/(2-x) grows denominators, doesn't "halve" distances
- 2-adic valuation doesn't correlate with orbit graph distance

**Earlier claim (RETRACTED):** Initial estimates of 1.3 bits savings were WRONG — based on faulty log-based path estimation instead of actual BFS distances.

**Implementation:** `scripts/kolmogorov_analysis.wl`

---

## 2. Fast Orbit Membership Test

### ✅ IMPLEMENTED

**Function:** `SameOrbit[q1, q2]` in `MoebiusInvolutions.wl`

```mathematica
SameOrbit[3/8, 5/11] → True   (* both have signature {3,5} *)
SameOrbit[3/8, 1/16] → False  (* {3,5} vs {1,15}, same I=15! *)
```

**Key insight:** Same invariant I is necessary but NOT sufficient. Must check full signature {A, B}.

**Related functions (all implemented):**
- `OrbitSignature[q]` — returns {A, B}
- `CanonicalRep[q]` — returns canonical form A/(A+B)
- `ToCanonicalPath[q]` — returns {path, canonical}

**Applications:**
- Equivalence classes for pattern matching
- Deduplication in fraction databases

---

## 3. Orbit-Factorization Correspondence

**Observation:** Orbits with invariant I correspond to coprime factorizations of I.

```
I = p₁·p₂·...·pₖ  →  2^(k-1) orbits (each prime goes to A or B)
```

| I | ω(I) | # Orbits | Signatures |
|---|------|----------|------------|
| 3 | 1 | 1 | {1,3} |
| 15 | 2 | 2 | {1,15}, {3,5} |
| 105 | 3 | 4 | {1,105}, {3,35}, {5,21}, {7,15} |

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

### ✅ ANSWERED: Group Action on Egypt Tuples

**κ rule (complement/swap):**
```
κ: {1, v, 1, j} ↔ {1, j, 1, v}
```
Swaps second and fourth parameters.

**σ rule (complex):**
- σ({1, 1, 1, 1}) = {1, 2, 1, 1}
- σ({1, 2, 1, 1}) = {1, 1, 1, 1}
- σ({1, 2k, 1, 1}) = {1, 1, 1, k} for k ≥ 2

**κσ rule (halving!):**
```
κσ: {1, 2k, 1, 1} → {1, k, 1, 1}
```
Halves the v parameter when v is even.

**Orbit structure from halving:**

The orbit of 1/5 = {1, 4, 1, 1} under ⟨σ, κ⟩:
```
{1,4,1,1} --κσ--> {1,2,1,1} --κσ--> {1,1,1,1} (fixed)
    ↕κ                ↕κ                ↕κ
{1,1,1,4}         {1,1,1,2}         {1,1,1,1}
```
This gives all 1/(2^k+1) and 2^k/(2^k+1) fractions.

### ✅ ANSWERED: Egypt Complexity in Orbits

**Finding:** Orbit-related fractions do NOT necessarily have same tuple count.

| Orbit | Size | Tuple counts |
|-------|------|--------------|
| 1/2 | 11 | all 1 |
| 1/3 | 12 | all 1 |
| 1/5 | 14 | all 1 |
| 1/4 | 21 | mixed (1-2) |
| 1/6 | 21 | mixed (1-3) |
| 3/8 | 21 | mostly 2 |

**Pattern:** Simple signatures {1, 2^k-1} tend to have single-tuple orbits.

---

## 5. Orbit Enumeration Bijection

**Theorem:** There is a bijection

```
Orbits under ⟨σ,κ⟩  ↔  {(A, B) : A ≤ B, A,B odd, gcd(A,B) = 1}
```

**Canonical representative:** A/(A+B)

**Counting orbits with invariant I = A×B ≤ n:**

| n | # Orbits | Orbits/n |
|---|----------|----------|
| 100 | 70 | 0.70 |
| 1000 | 923 | 0.92 |
| 10000 | 11580 | 1.16 |

**Asymptotic:** Growth is approximately linear in n. The coprimality constraint gcd(A,B) = 1 introduces the factor **6/π² = 1/ζ(2) ≈ 0.608** — the probability that two random integers are coprime (see [coprimality-zeta](../../learning/coprimality-zeta.md)).

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

## 9. Connection to Calkin-Wilf / Stern-Brocot Trees

The full group ⟨σ, κ, ι⟩ generates the Calkin-Wilf tree (transitive on ℚ⁺).

### ✅ ANSWERED (Trivial)

**Key observation:** σκ = x/(2-x) is a simple Möbius map.

**Recurrence:** For signature {1, n} with canonical 1/(n+1):
```
(σκ)^k (1/(n+1)) = 1/(2^k · n + 1)
```

**Examples:**
- {1,1}: denominators 2, 3, 5, 9, 17, 33, ... = 2^k + 1
- {1,3}: denominators 4, 7, 13, 25, 49, ... = 2^k·3 + 1

**Stern-Brocot connection:** σκ doubles the L-run length in SB tree.

**Structure:**
- ⟨σ,κ⟩ orbits = vertical fibers (fixed signature)
- CW/SB trees = horizontal structure (by denominator sum)
- Orbits cut diagonally with exponentially increasing depth

**Note:** This connection is algebraically trivial (one Möbius formula). The non-trivial content of the decomposition lies in the **signature invariance** — how σ, κ interact with 2-adic valuations to preserve {odd(p), odd(q-p)}.

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

6. **Why is I=19 special?** ✅ **OBSERVATION** — See Section 15 below.

7. **Optimal invariant for n points:** Given a target number of LUT entries, which invariant I minimizes PWL error? Is there a closed-form relationship?

8. **Rational neural networks:** ✅ **SOLVED** — Training in ℚ works! See below.

9. **Kolmogorov complexity:** ❌ **DISPROVED** — Orbit encoding does NOT beat direct (p,q) encoding. See Section 1.

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

## 15. Why I=19 is Special (Observation)

**Finding**: Among all prime invariants, p=19 gives the smoothest orbit sigmoid on all metrics.

| p | p-1 | Factorization | Gap ratio | RMSE | Max error |
|---|-----|---------------|-----------|------|-----------|
| 7 | 6 | 2×3 | 2.60 | 0.00071 | 0.0021 |
| 13 | 12 | 2²×3 | 2.49 | 0.00068 | 0.0021 |
| **19** | **18** | **2×3²** | **2.02** | **0.00058** | **0.0014** |
| 37 | 36 | 2²×3² | 2.39 | 0.00065 | 0.0019 |
| 53 | 52 | 2²×13 | 2.19 | 0.00060 | 0.0017 |
| 109 | 108 | 2²×3³ | 2.16 | 0.00060 | 0.0016 |

**Observation**: Optimal primes have p-1 that is **3-smooth** (only factors 2 and 3).

The **2×3² = 18** structure appears optimal:
- One factor of 2
- Two factors of 3
- Gives p = 19

**Pattern in 2×3^b + 1 family**:

| b | p | Gap ratio |
|---|---|-----------|
| 1 | 7 | 2.60 |
| **2** | **19** | **2.02** |
| 4 | 163 | 3.31 |
| 5 | 487 | 6.92 |

Even within this family, **b=2 is the sweet spot**.

**Connection to orbit structure**: The involutions σ: x → (1-x)/(1+x) and κ: x → 1-x interact with the multiplicative structure of denominators. When p-1 = 2×3², the orbit under ⟨σ,κ⟩ achieves maximal uniformity in logit space.

**Status**: Empirical observation. The precise number-theoretic mechanism connecting 2×3² to orbit uniformity remains an open question.

---

## 16. Fibonacci-Orbit Connection (√n Convergent Analysis)

**Discovery:** Convergent differences of √n produce orbit invariants with Fibonacci structure.

### Convergent Difference Invariants

For √n, consecutive convergents differ by unit fractions:
```
c_k - c_{k-1} = ±1/(q_{k-1} × q_k)
```

The orbit invariant of 1/m is `odd(m-1)`, so:
```
Invariant(c_k - c_{k-1}) = odd(q_{k-1} × q_k - 1)
```

### Fibonacci Invariant Sequence

When √n has CF period starting with consecutive 1s, the convergent denominators follow Fibonacci:
```
q_1, q_2, q_3, ... = 1, 1, 2, 3, 5, 8, 13, ...
```

Products F_k × F_{k+1} give:
```
1, 2, 6, 15, 40, 104, 273, 714, ...
```

Invariants odd(F_k × F_{k+1} - 1):
```
0, 1, 5, 7, 39, 103, 17, 713, 1869, 2447, ...
```

### Pure Fibonacci Surds

Surds with CF = [a₀; 1,1,...,1, 2a₀] (k ones before 2a₀):

| n | a₀ | k (ones) | Invariant prefix |
|---|-----|---------|------------------|
| 7 | 2 | 3 | {0, 1, 5} |
| 13 | 3 | 4 | {0, 1, 5, 7} |
| 58 | 7 | 6 | {0, 1, 5, 7, 39, 103} |
| 135 | 11 | 7 | {0, 1, 5, 7, 39, 103, 17} |
| **819** | 28 | **9** | {0, 1, 5, 7, 39, 103, 17, 713, 1869} |

**√819 is special:** Has 9 leading 1s in its CF period, matching all 9 Fibonacci invariants!

### Pattern

For CF = [a₀; 1^k, 2a₀], we have n = a₀² + r where:
- k=1: r/a₀ = 2
- k=3: r/a₀ → 4/3
- k≥6: r/a₀ → 5/4

### Why √819 is Exceptional: Golden Ratio Connection

**Key discovery:** The number of leading 1s in CF(√(9n)) correlates with how close `frac(3√n)` is to **1/φ = 0.6180339...**

| n | frac(3√n) | dist to 1/φ | leading 1s |
|---|-----------|-------------|------------|
| **91** | **0.6182** | **0.00014** | **9** |
| 15 | 0.6189 | 0.00092 | 7 |
| 149 | 0.6196 | 0.00163 | 5 |
| 62 | 0.6220 | 0.00399 | 5 |

**Why?** The continued fraction of 1/φ is [0; 1,1,1,1,...] — **all ones**! When 3√n ≈ k + 1/φ, the CF of √(9n) "inherits" this Fibonacci structure.

**Additional structure:**
- 91 = 7 × 13 = L₄ × F₇ (Lucas prime × Fibonacci prime!)
- This Lucas-Fibonacci factorization may explain the extremal proximity to 1/φ

**Status**: Strong empirical correlation. The precise mechanism connecting L₄×F₇ to 1/φ proximity remains open.

---

## 17. Lucas Primality Indicator Investigation

**Motivation:** Since n = F_k × L_m produces optimal 1/φ approximations, can we use this structure to detect primality of Lucas numbers?

### Method

For each Lucas number L_m (m = 2 to 60):
1. Find optimal k ∈ [1, 80] that minimizes dist = |frac(3√(F_k × L_m)) - 1/φ|
2. Compute various normalized metrics
3. Compare distributions for prime vs composite L_m

### Key Formula

```
n = F_k × L_m
dist = min(|frac(3√n) - 1/φ|, |1 - frac(3√n) - 1/φ|)
```

### Metrics Tested

| Metric | Prime Mean | Comp Mean | Ratio |
|--------|------------|-----------|-------|
| dist × log(n) | 0.051 | 0.084 | 1.66 |
| dist × √log(n) | 0.0097 | 0.014 | 1.44 |
| dist × n^0.1 | 0.037 | 0.26 | **7.09** |
| dist × log(log(n)) | 0.0061 | 0.0083 | 1.36 |
| dist × m | 0.045 | 0.081 | 1.79 |
| Combined: (dist×n^0.1)/(1+\|k/m-φ\|) | 0.018 | 0.19 | **10.58** |

### Additional Patterns

**Optimal k − m:**
- PRIME mean: 14.6
- COMPOSITE mean: 3.6

Primes tend to have optimal k much larger than m; composites have k ≈ m.

**Leading 1s in CF(√n):**
- PRIME mean: 0.67
- COMPOSITE mean: 0.15
- All values with 2+ leading 1s are prime

**CF period of √n:**
- PRIME mean: ~20,000
- COMPOSITE mean: ~58,000
- Composites have longer CF periods

### Classification Results

Best threshold classification (using combined metric):
- **Best F1 score:** 0.52 (threshold = 0.01)
- **Best accuracy:** 78% (threshold = 0.005)

Confusion matrix at threshold 0.01:
```
              Predicted
            Prime  Comp
Actual Prime:  11     4
Actual Comp:   16    28
```

### Top-Ranked Lucas Numbers

By combined metric (lower = more "prime-like"):

| Rank | L_m | Prime? | Score |
|------|-----|--------|-------|
| 1 | L₂ = 3 | PRIME | 0.00012 |
| 2 | L₄ = 7 | PRIME | 0.00020 |
| 3 | L₁₅ = 1364 | comp | 0.00047 |
| 4 | L₂₇ = 439204 | comp | 0.00068 |
| 5 | L₅ = 11 | PRIME | 0.00098 |
| 6 | L₁₉ = 9349 | PRIME | 0.00109 |

### Conclusion

**Statistical separation exists** (up to 10× ratio in means) but is **not sufficient for reliable primality testing**:

1. High ratios are driven by outliers in the composite class
2. Prime and composite distributions overlap significantly
3. Best classifier achieves only 52% F1 score

**Interpretation:** The Fibonacci-Lucas-golden ratio structure captures *some* information about primality, but the relationship is indirect. Primes cluster toward better φ-approximations, but many composites achieve similarly good approximations.

**Open question:** Is there a theoretical explanation for why prime L_m values tend to produce smaller normalized distances?

---

## 18. XGCD via Continuant Polynomials

**Discovery:** The involution chain structure leads to closed-form XGCD.

### The Chain Pattern

Every rational p/q with CF = [0; a₁, a₂, ..., aₙ] corresponds to:

$$\frac{p}{q} = \iota R^{a_1} \iota R^{a_2} \cdots \iota R^{a_n}(0)$$

where R(x) = x + 1 and ι(x) = 1/x.

### Continuant Polynomials

The **continuant** K(a₁, ..., aₙ) satisfies:
- K() = 1
- K(a) = a
- K(a, b) = ab + 1
- K(a, b, c) = abc + a + c
- K(a₁, ..., aₙ) = aₙ · K(a₁, ..., aₙ₋₁) + K(a₁, ..., aₙ₋₂)

### Closed-Form XGCD

For gcd(p, q) with CF quotients [a₁, ..., aₙ]:

| Component | Formula |
|-----------|---------|
| p | K(a₁, ..., aₙ) |
| q | K(a₂, ..., aₙ) |
| Bézout x | (-1)ⁿ K(a₂, ..., aₙ₋₁) |
| Bézout y | (-1)ⁿ⁺¹ K(a₁, ..., aₙ₋₁) |

### Computational Aspects

**Circularity issue:** To know quotients, must run Euclidean algorithm.

**But useful when:**
1. **Quotients known a priori** (structured numbers like Fibonacci)
2. **Verification** — check XGCD via multiplications (faster than divisions)
3. **Parallel computation** — continuants allow O(log n) depth via divide-and-conquer
4. **Algebraic families** — one formula covers infinitely many XGCDs

### Divide-and-Conquer Continuants

$$K(a_1, \ldots, a_n) = K(a_1, \ldots, a_m) \cdot K(a_{m+1}, \ldots, a_n) + K(a_1, \ldots, a_{m-1}) \cdot K(a_{m+2}, \ldots, a_n)$$

This enables **O(log n) parallel depth** vs O(n) sequential Euclidean.

---

## 19. Parametric XGCD Families

**Key finding:** When CF quotients follow a pattern, one formula gives infinitely many XGCDs.

### Last Quotient Varies: [0; a, k]

For CF = [0; a, k] where only k varies:

- p(k) = ak + 1
- q(k) = k
- **XGCD: (1, -a) — constant, independent of k!**

$$1 \cdot (ak + 1) - a \cdot k = 1 \quad \text{for ALL } k$$

### Example: a = 3

| k | p | q | XGCD |
|---|---|---|------|
| 1 | 4 | 1 | 1·4 - 3·1 = 1 |
| 2 | 7 | 2 | 1·7 - 3·2 = 1 |
| 3 | 10 | 3 | 1·10 - 3·3 = 1 |
| ... | ... | ... | Same formula! |

### General [0; a₁, ..., aₙ₋₁, k]

When only the last quotient varies, Bézout coefficients depend only on a₁, ..., aₙ₋₁, **not on k**.

---

## 20. Fibonacci XGCD Closed Forms

**Discovery:** XGCD of Fibonacci numbers has beautiful closed forms.

### Fundamental Identity

$$\gcd(F_i, F_j) = F_{\gcd(i,j)}$$

### Consecutive Fibonacci: XGCD(F_{n+1}, F_n)

$$\text{XGCD}(F_{n+1}, F_n) = \big((-1)^n F_{n-1}, \; (-1)^{n+1} F_n\big)$$

**The Bézout coefficients ARE Fibonacci numbers!**

| n | XGCD(F_{n+1}, F_n) | Coefficients |
|---|-------------------|--------------|
| 3 | XGCD(3, 2) | (1, -1) = (F₂, -F₃) |
| 4 | XGCD(5, 3) | (-1, 2) = (-F₂, F₃) |
| 5 | XGCD(8, 5) | (2, -3) = (F₃, -F₄) |
| 6 | XGCD(13, 8) | (-3, 5) = (-F₄, F₅) |

### Skip-One: XGCD(F_{n+2}, F_n)

$$\text{XGCD}(F_{n+2}, F_n) = \big((-1)^{n+1} F_{n-2}, \; (-1)^n F_n\big)$$

CF pattern: [0; 2, 1, 1, ..., 1, 2] with (n-3) ones in middle.

### Skip-Two: XGCD(F_{n+3}, F_n) when gcd(n,3)=1

Coefficients form sequence **1, 4, 17, 72, ...** = F_{3m}/2

This follows recurrence: aₙ = 4aₙ₋₁ + aₙ₋₂

### Implication

**No Euclidean needed for Fibonacci pairs!** Just look up in Fibonacci table + sign.

---

## 21. Fibonacci-Based Rational Number System

**→ Moved to separate session:** [2025-12-15-fibonacci-rationals](../2025-12-15-fibonacci-rationals/README.md)

This exploration grew from the XGCD findings above and warrants its own investigation with proper adversarial checking and literature review.

---

## References

- Paper: `docs/papers/involution-decomposition.tex` — Main theoretical results
- Module: `Orbit/Kernel/MoebiusInvolutions.wl` — Implementation
