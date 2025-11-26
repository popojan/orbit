# Generating Functions Quick Course
## From Sequences to Power Series

**Goal:** Understand generating functions for sequence manipulation and closed forms
**Approach:** Socratic questions within each chapter
**Commitment:** Practical understanding, ready to use in Wolfram Language

---

## Structure

1. **Motivation - Why generating functions?**
2. **Basic operations**
3. **Common generating functions**
4. **Advanced: Regularization**
5. **Practical workflow**

---

## Chapter 1: Motivation - Why Generating Functions?

### The Problem

You have a sequence: 1, 1, 2, 3, 5, 8, 13, ...

**Questions you might ask:**
- What's the 100th term?
- Is there a closed formula?
- What's the sum of all terms (if it converges)?

Direct computation is tedious. Is there a better way?

---

### The Idea

**Package the sequence into a function:**

```
{a₁, a₂, a₃, ...} → G(z) = a₁z + a₂z² + a₃z³ + ...
```

The sequence becomes **coefficients** of a power series.

**Socratic Question 1:**
If G(z) = z + z² + z³ + ..., what sequence does this represent?
*Hint: Read off the coefficients of z, z², z³, ...*

---

### Why This Helps

Operations on sequences become operations on functions:

| Sequence operation | GF operation |
|-------------------|--------------|
| Add sequences | Add functions |
| Shift by 1 | Multiply by z |
| Partial sums | Divide by (1-z) |

Functions are easier to manipulate than infinite lists!

**Socratic Question 2:**
If G(z) = z/(1-z) = z + z² + z³ + ..., what is z·G(z)?
*Hint: Multiply and read coefficients.*

---

### The Geometric Series

The simplest closed form:

```
1 + z + z² + z³ + ... = 1/(1-z)  for |z| < 1
```

**Socratic Question 3:**
The sequence {1, 1, 1, 1, ...} has GF = 1/(1-z). What about {0, 1, 1, 1, ...}?
*Hint: Shifting right introduces a factor of z.*

---

## Chapter 2: Basic Operations

### Coefficient Extraction

**Notation:** [zᵏ]G(z) means "coefficient of zᵏ in G(z)"

```mathematica
(* Wolfram Language *)
SeriesCoefficient[1/(1-z), {z, 0, 5}]
(* Returns 1 - the coefficient of z⁵ *)
```

**Socratic Question 4:**
What is [z³] in G(z) = z/(1-z²)?
*Hint: Expand z/(1-z²) = z(1 + z² + z⁴ + ...) first.*

---

### Shifting

**Right shift (delay):**
```
z·G(z) ↔ {0, a₁, a₂, a₃, ...}
```

**Left shift (advance):**
```
(G(z) - a₁z)/z ↔ {a₂, a₃, a₄, ...}
```

**Socratic Question 5:**
Fibonacci satisfies Fₙ = Fₙ₋₁ + Fₙ₋₂. If F(z) is its GF, write an equation for F(z).
*Hint: Fₙ₋₁ corresponds to z·F(z), Fₙ₋₂ to z²·F(z).*

---

### Solving Fibonacci

From the recurrence Fₙ = Fₙ₋₁ + Fₙ₋₂ with F₁ = F₂ = 1:

```
F(z) = z·F(z) + z²·F(z) + z
```

The extra z accounts for initial conditions.

Solving: F(z) = z/(1 - z - z²)

**Socratic Question 6:**
Can you factor (1 - z - z²)? What does this tell you about the closed form?
*Hint: Roots are related to the golden ratio φ.*

---

### Partial Fractions → Closed Form

```
1 - z - z² = -(z - φ)(z - ψ)  where φ = (1+√5)/2, ψ = (1-√5)/2
```

Partial fractions give:
```
F(z) = (1/√5)[1/(1-φz) - 1/(1-ψz)]
```

Expanding: Fₙ = (φⁿ - ψⁿ)/√5  ← **Binet's formula!**

**Socratic Question 7:**
Why is Fₙ always an integer, even though φ and √5 are irrational?
*Hint: What happens to ψⁿ as n grows?*

---

## Chapter 3: Common Generating Functions

### The Essential List

| Sequence | GF | Radius |
|----------|-----|--------|
| {1, 1, 1, ...} | 1/(1-z) | 1 |
| {1, 2, 3, ...} | 1/(1-z)² | 1 |
| {1, 1/2, 1/3, ...} | -log(1-z)/z | 1 |
| {1, 1/2!, 1/3!, ...} | (eᶻ-1)/z | ∞ |

---

### Derivative Trick

**Key insight:** Differentiation multiplies coefficients by index.

```
G(z) = Σ aₖzᵏ  →  G'(z) = Σ k·aₖzᵏ⁻¹
```

So: z·G'(z) = Σ k·aₖzᵏ

**Socratic Question 8:**
If G(z) = -log(1-z) = z + z²/2 + z³/3 + ..., what is z·G'(z)?
*Hint: Differentiate -log(1-z) and multiply by z.*

---

### Integration Trick

**Inverse:** Integration divides coefficients by index.

```
∫₀ᶻ G(t)dt ↔ {a₁, a₂/2, a₃/3, ...}
```

**Socratic Question 9:**
Starting from 1/(1-z) = 1 + z + z² + ..., derive -log(1-z) = z + z²/2 + z³/3 + ...
*Hint: Integrate term by term.*

---

### Partial Sums

If Sₙ = a₁ + a₂ + ... + aₙ (partial sums), then:

```
S(z) = G(z)/(1-z)
```

**Why?** Multiplying by 1/(1-z) = 1 + z + z² + ... convolves with all-ones sequence.

**Socratic Question 10:**
What's the GF for {1, 3, 6, 10, ...} (triangular numbers)?
*Hint: Triangular numbers are partial sums of {1, 2, 3, ...}.*

---

## Chapter 4: Regularization

### Beyond Convergence

Some series diverge:
```
1 - 1 + 1 - 1 + ... = ?
```

But the GF is well-defined:
```
G(z) = z - z² + z³ - ... = z/(1+z)
```

**Socratic Question 11:**
What is lim(z→1⁻) of z/(1+z)? Does this give a "value" to the divergent series?
*Hint: Just substitute z=1.*

---

### Abel Summation

**Definition:** The Abel sum of Σaₖ is:
```
lim_{z→1⁻} G(z)
```

For Grandi's series: z/(1+z) → 1/2 as z→1⁻

This is consistent with:
- Cesàro mean: (1+0+1+0+...)/n → 1/2
- Analytic continuation

**Socratic Question 12:**
Calculate the Abel sum of 1 - 2 + 3 - 4 + 5 - ...
*Hint: GF is z/(1+z)². Find the limit.*

---

### When Regularization Works

Abel summation extends to series that:
- Oscillate (like Grandi's)
- Grow slowly

It does NOT help with:
- Rapidly divergent series (1 + 2 + 4 + 8 + ...)
- Series with no pattern

**Socratic Question 13:**
The GF for {1, 2, 4, 8, ...} is z/(1-2z). Why can't we use z→1⁻ here?
*Hint: Where is the singularity?*

---

## Chapter 5: Practical Workflow

### Step 1: Identify the GF

```mathematica
(* From closed form *)
G[z_] := z/(1 - z - z^2)

(* Or from definition *)
G[z_] := Sum[Fibonacci[k] z^k, {k, 1, Infinity}]
```

---

### Step 2: Extract Coefficients

```mathematica
(* Single coefficient *)
a[k_] := SeriesCoefficient[G[z], {z, 0, k}]

(* Table of coefficients *)
Table[a[k], {k, 1, 10}]

(* Or expand directly *)
Series[G[z], {z, 0, 10}]
```

---

### Step 3: Find Closed Form

```mathematica
(* Partial fractions *)
Apart[z/(1 - z - z^2)]

(* Look for pattern *)
FindSequenceFunction[{1, 1, 2, 3, 5, 8}]
```

---

### Step 4: Verify

```mathematica
(* Check reconstruction *)
Sum[a[k] (1/2)^k, {k, 1, 50}] == G[1/2] // Simplify

(* Check recurrence *)
Table[a[k] == a[k-1] + a[k-2], {k, 3, 10}]
```

---

### Step 5: Regularize (if needed)

```mathematica
(* Abel sum for |z|=1 boundary *)
Limit[G[z], z -> 1, Direction -> "FromBelow"]

(* Or analytic continuation *)
G[1] /. Log[_] :> Undefined  (* handle carefully *)
```

---

## Summary

**Generating functions transform:**
- Sequences → Power series
- Recurrences → Algebraic equations
- Sums → Limits

**Key operations:**
- Shift: multiply by z
- Index multiply: differentiate
- Partial sums: divide by (1-z)
- Regularize: limit z→1⁻

**Workflow:** Define GF → Extract coefficients → Find closed form → Verify

---

## References

- **Wilf, H. S.** *Generatingfunctionology* (free PDF online)
- **Graham, Knuth, Patashnik** *Concrete Mathematics* (Chapter 7)
- **Flajolet & Sedgewick** *Analytic Combinatorics* (advanced)

---

**Created:** 2025-11-26
**Context:** Converted from reference format to Socratic learning format
