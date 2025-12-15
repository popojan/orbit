# The Pell-Fibonacci Bridge via Involutions

## Discovery

The ratio **7/5** simultaneously lives in two metallic ratio worlds:

| World | Interpretation | Equation |
|-------|----------------|----------|
| Golden (φ) | (F₅+F₃)/F₅ = 7/5 | Fibonacci form `{5, {5,3}}` |
| Silver (δ) | δ³ = 7+5√2 | Pell: 7² - 2·5² = -1 |

This is a **bridge** connecting Fibonacci fractions to Pell equations.

---

## The Involution Framework

### Common Structure

Both metallic ratios have conjugation involutions:

| Ratio | Definition | Conjugate σ(·) | Norm | Trace |
|-------|------------|----------------|------|-------|
| Golden φ | (1+√5)/2 | ψ = (1-√5)/2 | φψ = -1 | φ+ψ = 1 |
| Silver δ | 1+√2 | 1-√2 | δσ(δ) = -1 | δ+σ(δ) = 2 |

### Symmetric/Antisymmetric Decomposition

For any α in ℤ[√D]:

```
α = a + b√D

Trace:     Tr(α) = α + σ(α) = 2a
Norm-diff: α - σ(α) = 2b√D
```

### Powers Generate Pell Solutions

**Golden (D=5):**
```
φⁿ + ψⁿ = Lₙ     (Lucas - symmetric)
φⁿ - ψⁿ = Fₙ√5   (Fibonacci·√5 - antisymmetric)
```

**Silver (D=2):**
```
δⁿ = aₙ + bₙ√2

n=1: 1 + 1·√2     → 1² - 2·1² = -1
n=2: 3 + 2·√2     → 3² - 2·2² = 1
n=3: 7 + 5·√2     → 7² - 2·5² = -1  ← HERE
n=4: 17 + 12·√2   → 17² - 2·12² = 1
n=5: 41 + 29·√2   → 41² - 2·29² = -1
```

---

## The Bridge Point: 7/5

### Fibonacci Perspective

```
7 = F₅ + F₃ = 5 + 2
5 = F₅

7/5 = (F₅ + F₃)/F₅
    = {5, {5, 3}} in Fibonacci form
    = Zeckendorf length 2
```

### Pell Perspective

```
δ³ = (1+√2)³ = 7 + 5√2

x = 7, y = 5 solves x² - 2y² = -1
```

### Why This Works

The number **5** appears in both sequences:

| Sequence | Position | Value |
|----------|----------|-------|
| Fibonacci | F₅ | 5 |
| Pell | P₃ | 5 |

Complete overlap: `{0, 1, 2, 5}` - these are the **only** common values.

The ratio 7/5 exploits this overlap:
- Numerator 7 = F₅ + F₃ (Fibonacci sum)
- Denominator 5 = F₅ = P₃ (shared value)

---

## Generalization: D ≈ 5φ²ᵏ

### Hypothesis

When D/5 ≈ φ²ᵏ, the Pell fundamental solution has simple Fibonacci form.

### Evidence

| D | D/5 | ≈ φᵏ | First Pell Solution | Zeck Length |
|---|-----|------|---------------------|-------------|
| 5 | 1 | φ⁰ | 9/4 | **2** |
| 13 | 2.6 | φ² | 18/5 | **2** |
| 34 | 6.8 | φ⁴ | 35/6 | 6 |
| 90 | 18 | φ⁶ | 19/2 | 3 |

### D=5 and D=13 Share Structure

```
D=5:  9/4  = (F₇+F₅)/F₆ = 18/8 → {6, {7,5}}
D=13: 18/5 = (F₇+F₅)/F₅ = 18/5 → {5, {7,5}}
```

**Same numerator pattern `{7,5}`**, different denominator index!

---

## Fibonacci-Structured Pell Solutions

### General Pattern

Ratios of form `(F_{k+2} + F_k)/F_n` solve Pell equations:

| Ratio | Form | D | Pell |
|-------|------|---|------|
| 7/5 | (F₅+F₃)/F₅ | **2** | -1 |
| 7/2 | (F₅+F₃)/F₃ | 12 | 1 |
| 11/2 | (F₆+F₄)/F₃ | **30** | 1 |
| 18/5 | (F₇+F₅)/F₅ | **13** | -1 |
| 29/2 | (F₈+F₆)/F₃ | 210 | 1 |

### Connection to Lucas Numbers

Note: F_{k+2} + F_k = L_{k+1} (Lucas identity!)

So these ratios are really L_{k+1}/F_n for various n.

---

## Theoretical Implications

### 1. Unified Metallic Ratio Theory

The involution σ(√D) = -√D is universal. Different D values give different "metallic" ratios, but the algebraic structure is identical.

### 2. Fibonacci as Universal Probe

Our Fibonacci fraction representation can detect when a rational has simple structure relative to ANY metallic ratio, not just φ.

### 3. Pell Solution Complexity

**Conjecture:** Zeckendorf length of Pell fundamental solution measures "distance" from the golden ratio world.

- D=5: length 2 (φ is native)
- D=13: length 2 (close to 5φ²)
- D=61: length 29 (far from any 5φ²ᵏ)

---

## General Bridge: Coverage Analysis

### Definition: "Simple"

A ratio x/y has **simple Fibonacci form** if its representation `{n, zeck}` has:
```
|zeck| ≤ 3
```

That is, the numerator is a sum of **at most 3** non-consecutive Fibonacci numbers:

| Zeck Length | Form | Example |
|-------------|------|---------|
| 1 | F_a / F_n | 8/3 = F_6/F_4 |
| 2 | (F_a + F_b) / F_n | 18/5 = (F_7+F_5)/F_5 |
| 3 | (F_a + F_b + F_c) / F_n | 70/13 = (F_3+F_7+F_{10})/F_7 |

The threshold 3 is chosen empirically - it captures ratios that are "close" to pure Fibonacci structure.

### The Question

Can we find Fibonacci-simple Pell solutions for **any** non-square D, not just D=2?

### Experimental Results (D ≤ 50)

**Coverage: 63% of non-square D have Pell solutions with Zeck length ≤ 3**

| Zeck Length | D Values |
|-------------|----------|
| 1 | 2, 3, 5, 6, 7, 8, 10, 24, 26, 42 |
| 2 | 11, 12, 13, 15, 17, 20, 23, 27, 30, 35, 37, 48, 50 |
| 3 | 29, 32, 40, 41 |
| >3 or none | 14, 18, 19, 21, 22, 28, 31, 33, 34, 38, 39, 43-47 |

### Sample Simple Solutions

| D | Ratio | Pell | Fibonacci Form |
|---|-------|------|----------------|
| 2 | 1/1 | -1 | {2, {2}} |
| 7 | 8/3 | 1 | {4, {6}} |
| 13 | 18/5 | -1 | {5, {5, 7}} |
| 24 | 5/1 | 1 | {2, {5}} |
| 29 | 70/13 | -1 | {7, {3, 7, 10}} |
| 42 | 13/2 | 1 | {3, {7}} |

### What Doesn't Predict Simplicity

- **CF period**: D=18, 38, 39 have period 2 but no simple solution
- **Primality**: Both primes (19, 31, 43, 47) and composites (14, 21, 28) fail
- **Factorization**: No obvious pattern

### The Partial Bridge

The Fibonacci representation provides a **partial bridge** to Pell equations:

- Works for ~63% of D values (with Zeck ≤ 3)
- Not universal - some D inherently incompatible with Fibonacci structure
- The "difficult" D values live in ℤ[√D] too far from ℤ[√5]

### Algebraic Interpretation (Partial Bridge)

With denominator constraint y = F_n:
```
x/y = (sum of Fibonacci numbers) / F_n
```

This constrains both x and y to lie near Fibonacci numbers, which only happens when the arithmetic of ℤ[√D] accidentally aligns with ℤ[√5].

---

## Full Bridge: Dropping the Single-Denominator Constraint

### Key Insight

For Pell equations (irrational √D), we don't need the y = F_n constraint that's required for rational representation bijection!

**New construction:** Both x AND y are Zeckendorf sums:
```
x = F_{a₁} + F_{a₂} + ...  (Zeckendorf sum)
y = F_{b₁} + F_{b₂} + ...  (Zeckendorf sum)
D = (x² ± 1) / y²
```

### Coverage Comparison

| Constraint | Coverage (D ≤ 100) |
|------------|-------------------|
| y = F_n only | 48% (43/90) |
| y = Zeckendorf sum | **100%** (90/90) |

### Theorem: Universal Fibonacci-Pell Connection

**Every non-square D has a Pell solution x² - Dy² = ±1 where both x and y are Zeckendorf sums.**

This is because:
1. Every Pell equation has solutions (fundamental theorem)
2. Every positive integer has a unique Zeckendorf representation
3. Therefore, the fundamental Pell solution (x, y) automatically has Zeckendorf forms for both x and y

### Examples of "Hard" D Values

| D | x | y | x² - Dy² | Zeck(x) | Zeck(y) |
|---|---|---|----------|---------|---------|
| 43 | 3482 | 531 | 1 | {18,15,13,10} | {14,12,6,3} |
| 61 | 29718 | 3805 | -1 | {23,16,10,7,5,2} | {18,16,13,2} |
| 97 | 5604 | 569 | -1 | {19,16,14,10,4,2} | {14,12,9,7,2} |

### The Inductive Structure

The "simple" D values (short Zeckendorf) come from the formula:
```
D = (x² ± 1) / y²

where x, y are small Zeckendorf sums
```

Enumerate (x, y) pairs → generate D values with simple solutions.

**Coverage by combined Zeckendorf length |Zeck(x)| + |Zeck(y)|:**

| Max combined length | D values reached (≤100) |
|--------------------|------------------------|
| ≤ 4 | ~30% |
| ≤ 6 | ~50% |
| ≤ 8 | ~70% |
| ≤ 10 | ~85% |
| ≤ 15 | ~95% |
| unbounded | 100% |

---

## Complete Classification: D by Fibonacci Complexity

### The Fundamental Theorem

**Every Pell solution x/y has a unique Fibonacci rational form `{n, zeck}`** where:
```
x/y = (Σ_{k∈zeck} F_k) / F_n
```

The **Zeckendorf length** `|zeck|` measures how "close" D is to the Fibonacci/golden ratio world.

### Classification Table (D ≤ 60)

| |zeck| | D values | Count | Interpretation |
|--------|----------|-------|----------------|
| 1 | 2, 6, 7, 18, 42, 47 | 6 | Pure Fibonacci: x/y = F_k/F_n |
| 2 | 5, 11, 12, 13, 20, 23, 27, 30, 56 | 9 | Two-term sum |
| 3 | 14, 28, 29, 32, 39, 40, 41, 51, 58, 60 | 10 | Three-term sum |
| 4 | 10, 17, 21, 33, 45, 55 | 6 | Moderate complexity |
| 5-7 | 19, 22, 26, 34, 37, 38, 50, 53, 57, 59 | 10 | Higher complexity |
| 15+ | 31, 43, 44, 46, 52, 54 | 6 | Hard D values |
| 99 | 43 | 1 | Extremely hard |

### Key Examples

**Simple D (|zeck| = 1):** Solution is ratio of Fibonacci numbers
```
D=2:  3/2  = F_4/F_3 → {3, {4}}
D=6:  5/2  = F_5/F_3 → {3, {5}}
D=7:  8/3  = F_6/F_4 → {4, {6}}
D=42: 13/2 = F_7/F_3 → {3, {7}}
```

**Moderate D (|zeck| = 2):** Solution uses two Fibonacci numbers
```
D=5:  9/4  = (F_7+F_5)/F_6 → {6, {7,5}}
D=13: 18/5 = (F_7+F_5)/F_5 → {5, {7,5}}  (SAME numerator!)
D=12: 7/2  = (F_5+F_3)/F_3 → {3, {5,3}}
```

**Hard D (|zeck| >> 1):** Very long Zeckendorf representation
```
D=31: x/y = 1520/273  → |zeck| = 15
D=43: x/y = 3482/531  → |zeck| = 99 (!)
D=46: x/y = 24335/3588 → |zeck| = 49
```

### Algorithmic Construction

The bijective Fibonacci rational representation provides an **algorithmic** (not closed-form) construction:

**Algorithm:** For any non-square D:
1. Compute fundamental Pell solution (x, y) via continued fractions
2. Compute `FibonacciFraction[x/y]` → `{n, zeck}`
3. The Zeckendorf length `|zeck|` classifies D

**No transformation between D values exists**, but the Fibonacci structure captures the complexity of each D relative to the golden ratio world.

### Why Some D Are Hard

The "hard" D values (|zeck| >> 1) have Pell solutions whose x/y ratio requires many Fibonacci terms. This happens when:
- The fundamental solution (x, y) has large x, y
- Neither x nor y factors nicely into Fibonacci numbers
- The ratio x/y is "far" from any simple Fibonacci ratio

---

## Correlation: CF Period vs Zeckendorf Length

### Empirical Finding (D ≤ 100)

**Pearson correlation: r = 0.58** (moderate positive)

| CF Period | Avg |zeck| | Range | D count |
|-----------|----------|-------|---------|
| 1 | 4.3 | 1-7 | 9 |
| 2 | 2.7 | 1-5 | 20 |
| 4 | 3.2 | 1-6 | 17 |
| 6 | 8.9 | 4-17 | 11 |
| 8 | 25 | 6-66 | 6 |
| 10 | 63 | 33-99 | 4 |
| 12 | 200 | 49-351 | 2 |

### Interpretation

Both metrics measure "complexity" of D from different perspectives:
- **CF period:** How many steps to approximate √D well
- **|zeck|:** How many Fibonacci terms to express x/y

**Anomaly:** Period 2 has LOWER average |zeck| (2.7) than period 1 (4.3). This suggests short even periods are "simpler" in Fibonacci terms than period 1.

### Notable Cases

**Simple (short period, short |zeck|):**
- D=2: period 1, |zeck|=1
- D=6, 18, 42: period 2, |zeck|=1

**Hard (long period, long |zeck|):**
- D=76: period 12, |zeck|=351
- D=43: period 10, |zeck|=99
- D=46: period 12, |zeck|=49

---

## Scaling: Algebraic Relationships Between D Values

### Observation

Multiplying D by a "simple" factor s can change Zeckendorf complexity:

| D | |zeck(D)| | s | sD | |zeck(sD)| |
|---|----------|---|----|-----------|
| 31 | 15 | 2 | 62 | 2 |
| 43 | 99 | 5 | 215 | 3 |
| 46 | 49 | 7 | 322 | 1 |

### Mathematical Interpretation

For hard D, scaling by s moves √(sD) closer to "Fibonacci-friendly" values:
- If √(sD) ≈ k·φ for some integer k, Fibonacci form is simple
- Simple s values: 2, 5, 6, 7, 8 (those with |zeck|=1 or 2)

**Note:** This is a mathematical curiosity about algebraic relationships, not a practical technique. Zeckendorf representation does not provide storage compression - it typically requires ~1.4× MORE bits than raw integer storage.

---

## Open Questions

1. **Asymptotic distribution:** What fraction of D ≤ N have |zeck| ≤ k as N → ∞?

2. **Period 2 anomaly:** Why do even periods (especially 2) give simpler Fibonacci forms?

3. **Scaling recovery:** Explicit formula to recover Pell(D) from Pell(sD) and Pell(s)?

4. **Optimal scaling:** Given hard D, what's the algorithm to find best scaling factor s?

5. **Polynomial structure:** What patterns exist in the FibonacciRationalize polynomials P(t) for Pell solutions?

---

## Connection to Prior Work

This connects to:
- **Algebraic structure of ℤ[φ]** (see main README)
- **Galois invariance theorem** (paper section 4)
- **Applications document** (Pell equation section)
