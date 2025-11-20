# Square Root Methods in Orbit Paclet

**Complete Overview of Rational Square Root Approximation Methods**

---

## Quick Reference Table

| Method | Parameters | Return Type | Convergence | Requires Pell | Primary Use Case |
|--------|------------|-------------|-------------|---------------|------------------|
| **SqrtRationalization** | k | Rational | Very fast | Yes | Exact rational with Chebyshev |
| **NestedChebyshevSqrt** | {m1, m2} | Rational | Super-quadratic | Optional | Extreme precision (>1000 digits) |
| **BinetSqrt** | k | Interval | Exponential | No | Certified bounds, exponential conv. |
| **BabylonianSqrt** | k | Interval | Quadratic | No | Certified bounds, classical Newton |
| **EgyptSqrt** | k | Interval | Very fast | Yes | Factorial series with bounds |

---

## Method Descriptions

### 1. SqrtRationalization[n, opts]

**Original Pell+Chebyshev method**

```mathematica
<< Orbit`
approx = SqrtRationalization[13, Method -> "Rational", Accuracy -> 10]
(* → rational approximation *)
```

**Formula:**
$$\sqrt{n} \approx \frac{x-1}{y} \left(1 + \sum_{j=1}^{k} \text{ChebyshevTerm}[x-1, j]\right)$$

where $(x, y) = \text{PellSolution}[n]$

**Properties:**
- Returns single rational value
- All Chebyshev terms are **perfectly rational** at Pell solution
- Monotone increasing sequence (approaches from below)
- Very fast convergence

**Options:**
- `Method -> "Rational" | "List" | "Expression"`
- `Accuracy -> k` (number of terms, default 8)

**When to use:**
- Need exact rational approximation
- Prefer single value over bounds
- Working with Pell solutions

---

### 2. NestedChebyshevSqrt[n, {m1, m2}, opts]

**Ultra-high precision via nested iterations**

```mathematica
<< Orbit`
approx = NestedChebyshevSqrt[13, {3, 3}]
(* → rational, ~3000 digits precision in 0.01s *)

approx = NestedChebyshevSqrt[13, {1, 7}]
(* → rational, ~871k digits precision in 0.09s *)
```

**Formula:**
$$\text{nestqrt}(n, n_0, \{m_1, m_2\}) = \underbrace{\text{sym}(n, \cdots \text{sym}(n, n_0, m_1) \cdots, m_1)}_{m_2 \text{ iterations}}$$

**Parameters:**
- `m1` - Chebyshev order per iteration (1, 2, or 3 recommended)
- `m2` - number of nesting iterations

**Precision scaling:**
- m1=1: ~6x precision per iteration (optimized: 20x faster)
- m1=2: ~8x precision per iteration (optimized: 20x faster)
- m1=3: ~10x precision per iteration

**Options:**
- `StartingPoint -> "Pell" | "Crude" | rational` (default: "Pell")

**When to use:**
- Extreme precision (>1000 digits)
- Speed is critical
- Don't need certified bounds

**Performance:**
- Crossover vs Babylonian: ~4000 digits
- Speedup: 1.7x at 4k digits → 2.7x at 871k digits
- Demonstrated: 60 million digits (62M)

---

### 3. BinetSqrt[nn, n, k]

**Binet formula with certified bounds**

```mathematica
<< Orbit`
bounds = BinetSqrt[13, 3, 5]
(* → Interval[{lower, upper}] *)

{lower, upper} = Normal[bounds]
(* → extract numeric list *)
```

**Formula:**
$$\text{BinetSqrt}(n, n_0, k) = \sqrt{n} \cdot \left\{\frac{p^k - q^k}{p^k + q^k}, \frac{p^k + q^k}{p^k - q^k}\right\}$$

where $p = n_0 + \sqrt{n}$, $q = n_0 - \sqrt{n}$

**Properties:**
- Returns `Interval[{lower, upper}]`
- Bounds converge **exponentially**: $\sim 2^k$
- Does NOT require Pell solution
- Native bounds formula (no conversion needed)

**When to use:**
- Need certified interval bounds
- Exponential convergence desired
- No Pell solution available
- Interval arithmetic operations

**Convergence:**
- Factor $\sim 2^k$ precision improvement
- Faster than Babylonian for same k
- Works with any starting approximation

---

### 4. BabylonianSqrt[nn, n, k]

**Classical Newton method with bounds**

```mathematica
<< Orbit`
bounds = BabylonianSqrt[13, 3, 3]
(* → Interval[{lower, upper}] *)
```

**Formula:**
- Starting bounds: $\left\{\frac{2n \cdot d}{n^2 + d}, \frac{n^2 + d}{2n}\right\}$
- Iteration: $\{L', U'\} = \left\{\frac{d}{\text{avg}(L,U)}, \text{avg}(L,U)\right\}$

**Properties:**
- Returns `Interval[{lower, upper}]`
- **Quadratic convergence**: precision doubles per iteration
- Does NOT require Pell solution
- Classical, well-understood algorithm

**When to use:**
- Need certified bounds
- Prefer classical method (pedagogical)
- Reference baseline for comparisons
- Quadratic convergence sufficient

**Convergence:**
- Precision ~ $2^{2^k}$ (doubles per iteration)
- Slower than BinetSqrt for same k
- Well-suited for moderate precision (<100 digits)

---

### 5. EgyptSqrt[n, {x, y}, k]

**Factorial series with bounds (Egypt repository integration)**

```mathematica
<< Orbit`
pell = PellSolution[13]
bounds = EgyptSqrt[13, {x, y} /. pell, 10]
(* → Interval[{lower, upper}] *)
```

**Formula:**
$$r = \frac{x-1}{y} \left(1 + \sum_{j=1}^{k} \frac{1}{1 + \sum_{i=1}^{j} 2^{i-1} (x-1)^i \frac{(j+i)!}{(j-i)! (2i)!}}\right)$$

Then constructs bounds: $\text{Interval}[\{r, n/r\}]$ (sorted)

**Properties:**
- Returns `Interval[{lower, upper}]`
- Uses factorial-based series (Egypt repo formula)
- **Requires Pell solution**
- Very fast convergence (comparable to Chebyshev)

**When to use:**
- Need certified bounds with factorial formula
- Already have Pell solution
- Prefer explicit factorial structure
- Connecting to Egypt repository work

**Convergence:**
- Very fast (similar to SqrtRationalization)
- Guaranteed lower bound property (monotone increasing)
- Combinatorial structure (binomial coefficients)

---

## Helper Functions

### PellSolution[d]

**Solves Pell equation $x^2 - d \cdot y^2 = 1$**

```mathematica
pell = PellSolution[13]
(* → {x -> 649, y -> 180} *)
```

**Algorithm:** Wildberger's efficient method

**Required by:** SqrtRationalization, EgyptSqrt

**Optional for:** NestedChebyshevSqrt (StartingPoint option)

---

### MakeBounds[n, r]

**Converts single approximation to interval bounds**

```mathematica
approx = SqrtRationalization[13, Accuracy -> 10]
bounds = MakeBounds[13, approx]
(* → Interval[{lower, upper}] *)
```

**Formula:**
$$\text{MakeBounds}(n, r) = \begin{cases}
\text{Interval}[\{r, n/r\}] & \text{if } r^2 < n \\
\text{Interval}[\{n/r, r\}] & \text{otherwise}
\end{cases}$$

**Smart sorting:** Uses $r^2 < n$ test (faster than rational comparison)

---

### FactorialTerm[x, j] & ChebyshevTerm[x, k]

**Low-level term computation (internal use)**

```mathematica
(* Factorial-based term from Egypt repository *)
FactorialTerm[x, j]

(* Chebyshev-based term *)
ChebyshevTerm[x, k]
```

**Conjecture:** `FactorialTerm[x,j] == ChebyshevTerm[x,j]` for all x, j

**Status:** Numerically verified (j=1,2,3,4), algebraically unproven

**See:** `docs/egypt-chebyshev-equivalence.md`

---

## Error Analysis Functions

### BinetError[n, k, x]

**Computational error formula for Binet method**

```mathematica
error = BinetError[13, 5, 3)
(* → n - BinetSqrt[...]^2 *)
```

### BinetErrorChebyshev[n, k, x]

**Closed-form Chebyshev error formula**

```mathematica
error = BinetErrorChebyshev[13, 5, 3]
(* → (-1)^k * (4*n)/(x^2-1) * ChebyshevT[k,x]/ChebyshevU[k-1,x]^2 *)
```

**Reveals Chebyshev structure in Binet convergence**

---

## Comparison Chart

### Convergence Rates

| Method | Rate | Precision after k iterations |
|--------|------|------------------------------|
| BabylonianSqrt | Quadratic | $\sim 2^{2^k}$ decimal places |
| BinetSqrt | Exponential | $\sim c \cdot 2^k$ decimal places |
| SqrtRationalization | Very fast | Comparable to Chebyshev |
| EgyptSqrt | Very fast | Comparable to Chebyshev |
| NestedChebyshevSqrt | Super-quadratic | $\sim 10^k$ decimal places (m1=3) |

### Precision Sweet Spots

| Precision Target | Recommended Method | Why |
|------------------|-------------------|-----|
| < 100 digits | BabylonianSqrt or BinetSqrt | Classical, fast |
| 100-1000 digits | SqrtRationalization or EgyptSqrt | Very fast, exact rational |
| 1000-10k digits | NestedChebyshevSqrt {3,3} | Super-quadratic |
| 10k-1M digits | NestedChebyshevSqrt {1,7} | Optimized m1=1 |
| > 1M digits | NestedChebyshevSqrt {1,10+} | Only practical option |

### Bounds vs Single Value

| Return Type | Methods | Use Case |
|-------------|---------|----------|
| **Rational** | SqrtRationalization, NestedChebyshevSqrt | Exact computation, symbolic work |
| **Interval** | BinetSqrt, BabylonianSqrt, EgyptSqrt | Certified bounds, interval arithmetic |

**Convert:** Use `MakeBounds[n, r]` to convert Rational → Interval

**Extract:** Use `Normal[interval]` to get `{lower, upper}` list

---

## Usage Examples

### Example 1: Moderate Precision with Bounds

```mathematica
<< Orbit`

(* Classical Babylonian - quadratic convergence *)
bounds = BabylonianSqrt[13, 3, 5]
(* Interval[{3.60555..., 3.60555...}] *)

(* Check membership *)
Sqrt[13] ∈ bounds
(* True *)

(* Extract for numerics *)
{lower, upper} = Normal[bounds]
width = upper - lower
```

### Example 2: High Precision Rational

```mathematica
<< Orbit`

(* Get Pell solution *)
pell = PellSolution[13]
(* {x -> 649, y -> 180} *)

(* Exact rational approximation *)
approx = SqrtRationalization[13, Method -> "Rational", Accuracy -> 20]

(* Convert to bounds if needed *)
bounds = MakeBounds[13, approx]
```

### Example 3: Extreme Precision

```mathematica
<< Orbit`

(* 3000 digits in 0.01 seconds *)
approx = NestedChebyshevSqrt[13, {3, 3}]

(* 871k digits in 0.09 seconds *)
approx = NestedChebyshevSqrt[13, {1, 7}]

(* Measure precision *)
error = Log10[Abs[13 - approx^2]]
(* -871000 → 871k decimal places *)
```

### Example 4: Interval Arithmetic

```mathematica
<< Orbit`

(* Get bounds for √2 and √3 *)
sqrt2 = BinetSqrt[2, 1, 10]
sqrt3 = BinetSqrt[3, 1, 10]

(* Automatic interval arithmetic *)
sqrt2 + sqrt3
(* Interval[{lower, upper}] for √2 + √3 *)

sqrt2 * sqrt3
(* Interval[{lower, upper}] for √6 *)
```

### Example 5: Comparison Study

```mathematica
<< Orbit`

(* Compare convergence at equivalent precision *)
n = 13;
kBabylon = 5;

(* Reference: Babylonian *)
refBounds = BabylonianSqrt[n, 3, kBabylon]
refError = Log10[Abs[n - Mean[Normal[refBounds]]^2]]

(* Binet - exponential convergence *)
binetBounds = BinetSqrt[n, 3, kBabylon]

(* Egypt - factorial series *)
pell = PellSolution[n]
egyptBounds = EgyptSqrt[n, {x, y} /. pell, kBabylon]

(* Nested - super-quadratic *)
nestedApprox = NestedChebyshevSqrt[n, {3, 2}]
nestedBounds = MakeBounds[n, nestedApprox]
```

---

## Advanced Topics

### 2D Parameter Space (NestedChebyshev)

**Relationship between {m1, m2}:**

- m1 controls **convergence rate per iteration**
- m2 controls **number of iterations**
- Total precision ~ $(\text{rate}_{m1})^{m2}$

**Pareto frontier:**
- Lowest m1 = fastest computation
- Higher m1 = fewer iterations needed

**See:** `scripts/analyze_sqrt_convergence_relationships.wl` for complete 2D analysis

### Egypt-Chebyshev Equivalence

**Open conjecture:**
$$\text{FactorialTerm}[x,j] \stackrel{?}{=} \text{ChebyshevTerm}[x,j]$$

**Evidence:**
- Verified numerically for j=1,2,3,4
- Both yield identical polynomials with positive coefficients
- Binomial structure: $2^{i-1} \binom{j+i}{2i}$

**See:** `docs/egypt-chebyshev-equivalence.md`

### Pell Solution Characterization

**Unique property:** Chebyshev series yields **all rational terms** if and only if evaluated at Pell solution point $x = x_0 - 1$.

This characterizes Pell solutions via rationality condition.

---

## Performance Notes

### Optimizations

**NestedChebyshev m1=1,2:**
- Pre-simplified formulas (no ChebyshevU evaluation)
- ~20x speedup per iteration vs m1=3

**Smart sorting:**
- `EgyptSqrt` and `MakeBounds` use $r^2 < n$ test
- Cheaper than cross-multiply for large rationals

**Interval type:**
- Native Wolfram `Interval` for automatic arithmetic
- Use `Normal[...]` to extract when needed

### Benchmarks

**sqrt(13) precision:**

| Method | Iterations | Precision | Time |
|--------|-----------|-----------|------|
| Babylonian | 10 | ~32 digits | fast |
| Binet | 10 | ~64 digits | fast |
| SqrtRat | 10 | ~35 digits | fast |
| Egypt | 10 | ~35 digits | fast |
| Nested {3,3} | 3 (total) | ~3000 digits | 0.01s |
| Nested {1,7} | 7 (total) | ~871k digits | 0.09s |

---

## References

### Documentation
- `docs/modules/chebyshev-pell-sqrt-framework.md` - Complete framework
- `docs/egypt-chebyshev-equivalence.md` - Equivalence conjecture
- This file - Quick reference

### Analysis Scripts
- `scripts/analyze_sqrt_convergence_relationships.wl` - Convergence comparison
- `scripts/export_sqrt_convergence_data.wl` - CSV data export

### Code
- `Orbit/Kernel/SquareRootRationalizations.wl` - Implementation

### External
- Egypt repository: https://github.com/popojan/egypt
- Wildberger's Pell solver: https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf

---

*Last updated: November 2025*
*Orbit Paclet - Mathematical Explorations*
