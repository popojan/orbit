# Generating Functions - Quick Reference

**Personal tutorial for working with GFs**

---

## Definition

For sequence {a₁, a₂, a₃, ...}, the **ordinary generating function** is:

```
G(z) = Σ_{k=1}^∞ aₖ·zᵏ = a₁z + a₂z² + a₃z³ + ...
```

**Power series in z**, coefficients encode the sequence.

---

## Basic Operations

### 1. Coefficient Extraction

**From series → coefficient:**
```
aₖ = [zᵏ]G(z)
```

**Methods:**
```mathematica
(* Method 1: SeriesCoefficient *)
a[k_] := SeriesCoefficient[G[z], {z, 0, k}]

(* Method 2: Via derivatives *)
a[k_] := (1/k!) * Limit[D[G[z], {z, k}], z -> 0]

(* Method 3: Expand and read *)
Series[G[z], {z, 0, maxK}]
```

### 2. Linear Combinations

```
αG(z) + βH(z) ↔ α·aₖ + β·bₖ
```

### 3. Shift Operations

```
z·G(z)   ↔ aₖ₋₁  (shift right, a₀ = 0)
G(z)/z   ↔ aₖ₊₁  (shift left)
z²·G(z)  ↔ aₖ₋₂
```

**Example:** If G(z) = z + 2z² + 3z³ + ..., then z·G(z) = z² + 2z³ + 3z⁴ + ...

### 4. Derivative ↔ Index Multiplication

```
G'(z)    ↔ k·aₖ
z·G'(z)  ↔ k·aₖ
```

**Example:**
```
If aₖ = 1/k → G'(z) generates {1, 1/2, 1/3, ...}
```

### 5. Integration ↔ Index Division

```
∫₀ᶻ G(t)dt ↔ aₖ/(k+1)
```

### 6. Partial Sums

If Sₖ = Σᵢ₌₁ᵏ aᵢ (partial sums), then:

```
S(z) = G(z)/(1-z)
```

**Proof:** (1-z)⁻¹ = 1 + z + z² + ... convolves with coefficients.

### 7. Convolution (Cauchy Product)

```
G(z)·H(z) ↔ cₖ where cₖ = Σᵢ₌₀ᵏ aᵢ·bₖ₋ᵢ
```

**Applications:**
- Fibonacci: F(z)² generates convolution
- Combinatorics: counting paths, partitions

---

## Advanced: Regularization / Summation

### Abel Summation

If Σ aₖ diverges or oscillates, define:

```
"Sum" = lim_{z→1⁻} G(z)
```

**Example (Grandi's series):**
```
1 - 1 + 1 - 1 + ...
G(z) = z/(1+z)
lim_{z→1⁻} G(z) = 1/2
```

### Cesàro Summation

Average of partial sums:

```
Cesàro mean = lim_{N→∞} (1/N) Σₙ₌₁ᴺ Sₙ
```

**Connection to GF:**
```
If lim_{z→1⁻} G(z) exists, it equals Cesàro mean
```

---

## Radius of Convergence

**Cauchy-Hadamard formula:**
```
1/R = limsup_{k→∞} |aₖ|^(1/k)
```

**Series converges for |z| < R**

**Example (Chebyshev GF):**
```
aₖ ~ 1/k → |aₖ|^(1/k) → 1
→ R = 1
```

**Outside radius:** Closed form provides **analytic continuation** (complex values).

---

## Common GFs

### Geometric Series

```
1/(1-z) = 1 + z + z² + z³ + ...  (R = 1)
aₖ = 1
```

### Exponential

```
eᶻ = 1 + z + z²/2! + z³/3! + ...  (R = ∞)
aₖ = 1/k!
```

### Logarithm

```
-log(1-z) = z + z²/2 + z³/3 + ...  (R = 1)
aₖ = 1/k
```

### ArcTanh

```
ArcTanh(z) = z + z³/3 + z⁵/5 + z⁷/7 + ...  (R = 1)
a₂ₖ₊₁ = 1/(2k+1), a₂ₖ = 0
```

---

## Chebyshev GF Example

### Definition
```mathematica
G[z_] := ArcTanh[z] + (2z + (1+z²)Log[(z-1)²]/2 - (1+z²)Log[1+z])/(4z)
```

### Properties
- **R = 1** (converges for |z| < 1)
- **G(1/2) = 1/2 - Log[3]/8** ≈ 0.363
- **lim_{z→1⁻} G(z) = 1/2** (regularized sum)

### Power Series
```
G(z) = z - (2z²)/3 + z³/3 - (4z⁴)/15 + z⁵/5 - (6z⁶)/35 + ...
```

**Pattern:**
- Odd k: aₖ = 1/k
- Even k: aₖ = -(1/(k+1) + 1/(k-1))/2

### Extraction
```mathematica
AB[k_] := SeriesCoefficient[G[z], {z, 0, k}]

(* Examples *)
AB[1]  → 1
AB[2]  → -2/3
AB[3]  → 1/3
AB[10] → -10/99
```

---

## Practical Wolfram Code

```mathematica
(* Define GF *)
G[z_] := (* your closed form *)

(* Extract single coefficient *)
a[k_] := SeriesCoefficient[G[z], {z, 0, k}]

(* Expand multiple terms *)
series = Series[G[z], {z, 0, 20}]

(* Numerical evaluation *)
G[1/2] // N

(* Regularized sum (if R=1) *)
Limit[G[z], z -> 1, Direction -> "FromBelow"]

(* Check radius of convergence *)
coeffs = Table[a[k], {k, 1, 100}];
radii = Table[1/Abs[coeffs[[k]]]^(1/k), {k, 1, 100}];
ListPlot[radii]  (* Should approach R *)

(* Verify identity *)
reconstructed = Sum[a[k] * (1/2)^k, {k, 1, 100}]
exact = G[1/2]
Abs[reconstructed - exact]  (* Check error *)
```

---

## When to Use GFs

**Good for:**
- Solving recurrence relations
- Counting problems (combinatorics)
- Finding closed forms for sequences
- Regularizing divergent sums
- Asymptotic analysis (via singularities)

**Not ideal for:**
- Sequences without structure
- When direct formula is easier
- Highly irregular sequences

---

## References

- **Wilf, H. S.** *Generatingfunctionology* (free PDF)
- **Graham, Knuth, Patashnik** *Concrete Mathematics* (Chapter 7)
- **Flajolet & Sedgewick** *Analytic Combinatorics* (advanced)

---

**Created:** 2025-11-23
**Context:** Chebyshev integral identity exploration
