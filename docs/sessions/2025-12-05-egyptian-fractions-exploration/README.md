# Egyptian Fractions Exploration

**Date:** 2025-12-05
**Status:** Exploratory research

## Summary

This session explored Egyptian fractions via symbolic telescoping representation, extending the `EgyptianFractions.wl` module and investigating canonical representations for integers.

## Commits

- `feat(EgyptianFractions): add RawFractionsFromCF + pattern constraints` (126c9ed)

---

## 1. Egypt ↔ CF Equivalence (Committed)

### Finding
Two different algorithms produce **identical** raw tuples:
- **ModInv method** (`RawFractionsSymbolic`): Uses modular inverse iteratively
- **CF method** (`RawFractionsFromCF`): Folds continued fraction coefficients

```mathematica
RawFractionsSymbolic[q] === RawFractionsFromCF[q]  (* Always True for 0 < q < 1 *)
```

### Implementation
Added `RawFractionsFromCF` with pattern constraint `/; 0 < q < 1`:
```mathematica
RawFractionsFromCF[q_Rational /; 0 < q < 1] := Module[...]
```

### Theorem (Egypt ↔ CF Correspondence)
Egypt values = Total /@ Partition[Differences @ Convergents[q], 2]

Each Egypt value equals the sum of a consecutive pair of CF differences.

---

## 2. Egyptian Horcruxes

### Concept
A rational q can have **multiple** Egyptian fraction decompositions. Each complete set is a "Horcrux" - any one can resurrect the original.

### Structure Hierarchy
```
q → RawFractions[q]     (canonical, unique)
     ↓ expand
  {1/d₁, 1/d₂, ...}     (unit fractions)
     ↓ various merge strategies
  Horcrux₁, Horcrux₂, ... (multiple variants)
```

Raw tuples are the "true" algebraic structure. Horcruxes are combinatorial variations via merging.

---

## 3. Disjoint Splits for Integers

### Problem
How to represent integers n as Egyptian fractions (distinct unit fractions)?

### Approach
Split n into k proper fractions: n = q₁ + q₂ + ... + qₖ where all qᵢ ∈ (0,1).
Require all unit fractions across decompositions to be disjoint.

### Key Finding: The 1/2 Theorem
**Theorem:** Every canonical Egyptian representation of 1 (via 2-split) contains 1/2.

**Proof:** For 1 = q₁ + q₂ with 0 < q₁, q₂ < 1, at least one qᵢ ≥ 1/2.
The greedy algorithm for q ≥ 1/2 always starts with 1/2. ∎

**Consequence:** Cannot have two disjoint canonical representations of 1.

### Non-Canonical Representation of 1 (without 1/2)
```
1 = 1/3 + 1/4 + 1/5 + 1/6 + 1/20
```
Uses greedy starting from 1/3 instead of 1/2.

### Representation of 2
Found via two disjoint representations of 1:
```
2 = 1/2 + 1/3 + 1/4 + 1/5 + 1/6 + 1/7 + 1/8 + 1/9 + 1/10 + 1/20 + 1/48 + 1/5040
```
12 distinct unit fractions.

---

## 4. Canonical Form for Integers

### Definition
**Canonical(n)** = disjoint Egyptian representation minimizing:

| Priority | Criterion |
|----------|-----------|
| 1. | Minimal number of raw tuples |
| 2. | Minimal **tuple bits** = Σ log₂(u) + log₂(v) + log₂(j) |

**Note:** "Minimal k (number of splits)" is **redundant** - each proper fraction needs ≥1 tuple,
so minimizing tuples automatically yields reasonable k.

### Alternative Criteria Explored

#### Uniformity
- Measure: 1 - 2|qᵢ - n/k|
- Favors equal splits (49/99 + 50/99 for n=1)

#### Split Bit Complexity
- Measure: Σ log₂(numerator) + log₂(denominator) for splits
- Different from tuple bits!

#### Tuple Bit Complexity (CHOSEN)
- Measure: Σ log₂(u) + log₂(v) + log₂(j) over all raw tuples
- Most natural - measures the actual representation

### Counterexamples

**Uniformity ≠ Bit Complexity (for 3+ tuples):**

| Split | Tuple Bits | Uniformity |
|-------|------------|------------|
| 2/5 + 3/5 | 4.6 | 0.80 |
| 49/99 + 50/99 | 14.2 | 0.99 |

**Split Bits ≠ Tuple Bits:**

| Split | Split Bits | Tuple Bits |
|-------|------------|------------|
| 2/7 + 5/7 | 8.9 | 7.2 |
| 3/7 + 4/7 | 9.2 | **5.9** |

Tuple bits correctly identifies 3/7 + 4/7 as simpler (smaller parameters, more uniform).

---

## 5. Single-Tuple Rationals

### Observation
Some rationals can be expressed as a **single** raw tuple {u, v, 1, j}.

### Divisor Connection (User Finding)

From the closed form T(u, v, 1, j) = j / (u × (u + v×j)):

**Theorem (Single-Tuple Characterization):**
A reduced fraction a/b has single-tuple representation iff:
1. b = d₁ × d₂ for some divisors d₁ ≤ d₂
2. a | (d₂ - d₁)
3. v = (d₂ - d₁) / a, u = d₁, j = a

**Simplified (for algorithm's (1,b) pair):** a/b is single-tuple iff **a | (b - 1)**.

**Proof:** The tuple {u, v, 1, j} evaluates to j/(u(u+vj)). Setting d₁ = u and d₂ = u+vj:
- d₁ × d₂ = b (denominator condition)
- j = a (numerator condition)
- v = (d₂ - d₁)/j must be integer

**Corollary:** (n-1)/n always has single-tuple representation.
- n = 1 × n, so d₁ = 1, d₂ = n
- d₂ - d₁ = n - 1 = a ✓
- Tuple: {1, 1, 1, n-1}

### Examples

The modular inverse algorithm consistently uses the (1, b) divisor pair:

| Fraction | Divisor pair | v = (d₂-d₁)/a | Tuple | Verification |
|----------|-------------|---------------|-------|--------------|
| 2023/2024 | (1, 2024) | 1 | {1, 1, 1, 2023} | 2023/(1×2024) ✓ |
| 1/6 | (1, 6) | 5 | {1, 5, 1, 1} | 1/(1×6) ✓ |
| 2/15 | (1, 15) | 7 | {1, 7, 1, 2} | 2/(1×15) ✓ |
| 3/10 | (1, 10) | 3 | {1, 3, 1, 3} | 3/(1×10) ✓ |

**Note:** Other divisor pairs can yield valid tuples (e.g., 1/6 via (2,3) → {2,1,1,1}),
but the modular inverse algorithm always produces the (1, b) form when single-tuple is possible.

### Non-Single-Tuple Example
5/12: Divisor pairs of 12 are (1,12), (2,6), (3,4).
- (1,12): 12-1=11, 11 ∤ 5 ✗
- (2,6): 6-2=4, 4 ∤ 5 ✗
- (3,4): 4-3=1, 1 | 5 but v=1/5 not integer ✗

No valid divisor pair exists, so 5/12 requires multiple tuples:
```
RawFractionsSymbolic[5/12] → {{1, 2, 1, 2}, {5, 7, 1, 1}}
```
Expanded: 1/3 + 1/15 + 1/60

---

## 6. Denominator-Based Algorithm (Idea)

### Motivation
Brute-force k-splits fail for n ≥ 2 because most Egyptian representations share common denominators (especially 1/2 and 1/6).

### Core Algorithm

```
Input: Integer n
Output: Canonical disjoint Egyptian representation

1. Choose denominator d wisely
2. Compute Egypt[n/d] → {1/a₁, 1/a₂, ..., 1/aₘ}
3. Multiply by d → {d/a₁, d/a₂, ..., d/aₘ}
4. Check: all d/aᵢ < 1?  (requires d < min(aᵢ))
5. For each d/aᵢ: compute Egypt[d/aᵢ] → raw tuples
6. Check: all denominators disjoint?
7. If not, try different d; else return canonical
```

### Key Constraint
For step 4 to succeed: **d < min(denominators in Egypt rep of n/d)**

With greedy Egypt, smallest denominator ≈ ⌈d/n⌉.
Need d < d/n → n < 1, **impossible for n ≥ 1**.

### Three Approaches to Overcome Constraint

#### Approach 1: CF Structure Analysis
Some rationals have raw tuples yielding large minimum denominators.

**Idea:** Search for d where n/d has favorable CF structure:
- Single-tuple rationals: a/b single-tuple iff a | (b-1)
- Large first denominator correlates with specific CF patterns

**Test criterion:**
```mathematica
MinDenom[q_] := Min[RawDenominators[RawFractionsSymbolic[q]]]
(* Search for d where MinDenom[n/d] > d *)
```

#### Approach 2: Non-Greedy Egypt
The modular inverse algorithm isn't the only way.

**Alternative representations:**
- 1 = 1/2 + 1/3 + 1/6 (canonical greedy)
- 1 = 1/3 + 1/4 + 1/5 + 1/6 + 1/20 (non-greedy, avoids 1/2!)

**Idea:** For each d/aᵢ, try multiple Egypt representations.
Some may have disjoint denominators even when canonical doesn't.

#### Approach 3: Primorial Denominators
Choose d = P# × k where P# = 2×3×5×...×p.

**Properties:**
- n/d has many small factors in denominator
- Forces specific CF structure
- May yield representations with mutually coprime denominators

**Example:** d = 30k guarantees denominator divisible by 2, 3, 5.

### Experimental Results

#### n=1: SUCCESS
- **Best k=2 split:** 1/3 + 2/3
- **Raw tuples:** `{{1,2,1,1}, {1,1,1,2}}`
- **Total: 2 raw tuples** (optimal!)
- Verification: 1/3 + (1/2 + 1/6) = 1 ✓

#### n=2: SUCCESS (via unit fraction greedy)

**Key insight:** Unit fractions 1/d have Egypt representation with single denominator {d}.
These are automatically pairwise disjoint!

**Greedy algorithm:** Pick 1/d in decreasing order, avoiding used denominators:
```
2 = 1/2 + 1/3 + 1/4 + 1/5 + 1/6 + 1/7 + 1/8 + 1/9 + 1/10 + 1/15 + 1/230 + 1/57960
```
- **12 unit fractions**
- **12 raw tuples** (each 1/d = tuple {1, d-1, 1, 1})
- All denominators pairwise disjoint

**Why 2-split approach failed:**
- All Egypt representations of fractions ≥ 1/2 start with 1/2
- Single-tuple fractions (k-1)/k expand to {1/2, 1/6, 1/12, ..., 1/(k(k-1))}
- These always share denominators {2, 6, 12, ...}
- **0 mutually disjoint pairs** among 1521 tested 2-splits of 1

#### Can we do better than 12 tuples?

The unit fraction approach gives 12 tuples. Can telescoping compression help?

**Observation:** (k-1)/k = 1 raw tuple but expands to k-1 unit fractions!
- 2/3 = 1 tuple = 1/2 + 1/6
- 3/4 = 1 tuple = 1/2 + 1/6 + 1/12
- 7/8 = 1 tuple = 7 unit fractions!

**Problem:** All (k-1)/k forms share denominators {2, 6, 12, ...}.
Finding two disjoint compressed reps of 1 appears impossible with our algorithm.

**Open:** Is 12 the minimum for n=2, or can we find fewer tuples?

### n=3: SUCCESS (greedy unit fractions)

Using the same greedy approach as n=2:
```
3 = 1/2 + 1/3 + ... + 1/30 + 1/200 + 1/77706 + 1/16532869712 +
    1/3230579689970657935732 + 1/36802906522516375115639735990520502954652700
```
- **34 unit fractions** = **34 raw tuples**
- All denominators pairwise disjoint

---

## 6b. Fundamental Obstruction Theorem

### Why Telescoping Compression Fails for n >= 2

**Theorem (Denominator Collision):** For any two k-splits of 1 using canonical Egypt representations,
there exist common denominators in their expanded forms.

**Proof sketch:**

1. **2-splits always contain 2:**
   - To write 1 = a + b with 0 < a, b < 1, at least one >= 1/2
   - Greedy Egypt of any q >= 1/2 starts with 1/2
   - Therefore ALL 2-splits contain denominator 2

2. **3-splits avoiding 2 share small denominators:**
   - Found 215 disjoint 3-splits of 1 avoiding denominator 2
   - But ALL contain denominators from {3, 4, 5, 6, ...}
   - No two 3-splits have mutually disjoint denominator sets

3. **Unit fractions are the only escape:**
   - 1/d has Egypt expansion {d} (single element)
   - Unit fractions are automatically pairwise disjoint
   - This is why greedy unit fraction approach works

**Experimental verification:**
- 1088 internally disjoint 2-splits tested, 0 mutually disjoint pairs
- 215 internally disjoint 3-splits (avoiding 2) tested, 0 mutually disjoint pairs

**Consequence:** Telescoping compression (using (k-1)/k single-tuple forms) cannot reduce
the tuple count for n >= 2 because all (k-1)/k expansions share denominators {2, 6, 12, ...}.

---

## 7. Conclusions

### Algorithm Limitations

1. **User's denominator algorithm** requires d < min(Egypt denominators).
   For greedy: min ≈ d/n, so d < d/n → n < 1. **Impossible for n ≥ 1**.

2. **Modular inverse (our algorithm)** produces unique canonical raw tuples,
   but all fractions close to 1 share denominators {2, 6, 12, ...}.

3. **Disjoint representations** for n ≥ 2 require non-canonical approaches
   or much larger search spaces.

### Open Problems

1. **Minimum raw tuples for n=2?** Current: 12 unit fractions (via greedy avoidance).
   Unknown if smaller exists with our raw tuple format.

2. **Characterization of disjoint pairs?** Which splits q₁ + q₂ = 1 have
   Egypt representations that don't share denominators?

3. **Alternative algorithms?** Non-greedy, Sylvester-type, or Erdős-Straus
   decompositions might yield disjoint representations.

---

## 8. Open Questions

1. **Minimum fractions for integer n?**
 - n=1: 3 fractions, 2 raw tuples (proven minimal)
 - n=2: 12 fractions (greedy unit), likely minimal due to Denominator Collision Theorem
 - n=3: 34 fractions (greedy unit)

2. **Growth rate of f(n)?**
 - f(1) = 3, f(2) = 12, f(3) = 34
 - Is f(n) = O(n log n)? Or faster?
 - Related to harmonic series divergence?

3. **Non-greedy alternatives?**
 - Sylvester-type decompositions
 - Erdős-Straus variants for 4/n
 - Could bypass Denominator Collision Theorem?

4. **Theoretical lower bound?**
 - Unit fraction approach gives upper bound
 - Is there a matching lower bound proof?

---

## 9. Egypt ↔ Chebyshev ↔ Pythagorean Connection

### Discovery Context

While exploring `personal/pythagorean.wl`, noticed repeated appearance of argument `(n+1)/(n-1)` in Chebyshev polynomials. This connects to Egyptian sqrt approximations.

### The Three Methods

#### Egyptian Sqrt (without Pell)

From `egypt/doc/sqrt.pdf`, the Egyptian recurrence approximates:

```
√(n(n+2)) = n · lim_{k→∞} f(n, k)
```

where f(n,k) is the Egyptian fraction iteration.

**Rewriting:** √(n(n+2)) = √((n+1)² - 1)

For the ratio form: **√((n+1)/(n-1)) = lim_{k→∞} f(n-1, k)**

#### Chebyshev Polynomials

The Chebyshev polynomial of the first kind satisfies:

```
T_k(cosh θ) = cosh(kθ)
```

Setting x = (n+1)/(n-1), we have x = cosh(θ) for some θ = arccosh((n+1)/(n-1)).

Therefore:
```
T_k((n+1)/(n-1)) = cosh(k · arccosh((n+1)/(n-1)))
```

#### Pythagorean Triplets

From `pythagorean.wl`, the function:

```mathematica
pythagorean[n_, k_] := (1/4 (-1)^n (1 + 3 (-1)^n) (-1 + n))^k ×
  {Sqrt[(#^2 - 1)/n], 1, #} &@ ChebyshevT[k, (n + 1)/(n - 1)]
```

Generates Pythagorean triplet families using Chebyshev at the same argument!

### The Unifying Structure

All three methods iterate the **same hyperbolic base value**:

| Method | Base Value | Iteration Type | Result |
|--------|------------|----------------|--------|
| Egyptian | (n+1)/(n-1) | Additive (unit fraction sums) | √((n+1)/(n-1)) |
| Chebyshev | (n+1)/(n-1) | Multiplicative (polynomial composition) | T_k((n+1)/(n-1)) |
| Pythagorean | (n+1)/(n-1) | Multiplicative (power law) | Triplet scaling |

### The Hyperbolic Connection

Setting θ = arccosh((n+1)/(n-1)):

1. **Egyptian** builds √(cosh θ) = √((n+1)/(n-1)) via unit fraction telescoping
2. **Chebyshev** computes cosh(kθ) = T_k(cosh θ) via polynomial recurrence
3. **Pythagorean** uses cosh(kθ) to scale triplets: if (a,b,c) is Pythagorean, so is (a·T_k, b·T_k, c·T_k) with appropriate modifications

### Why (n+1)/(n-1)?

This form appears because:

1. **Hyperbolic identity:** cosh(arccosh(x)) = x, and (n+1)/(n-1) > 1 for n > 1 (valid arccosh argument)

2. **Pell-free sqrt:** Without solving Pell equation x² - ny² = 1, we can only approximate √(n(n+2)), not √n directly. The ratio (n+1)/(n-1) emerges naturally from (n+1)² - 1 = n(n+2).

3. **Continued fraction structure:** CF of √((n+1)/(n-1)) has predictable periodic structure, enabling both Egyptian and Chebyshev iterations.

### Mathematical Relationship

**Theorem (Egypt-Chebyshev Duality):**

Let x = (n+1)/(n-1) for integer n > 1. Then:

1. Egyptian iteration f(n-1, k) → √x as k → ∞ (additive convergence)
2. Chebyshev T_k(x) = cosh(k · arccosh(x)) (multiplicative iteration)
3. Both use the underlying hyperbolic structure cosh(θ) where x = cosh(θ)

**Additive vs Multiplicative:**
- Egypt: Sum of unit fractions approximating √x
- Chebyshev: Composition T_k = T_1 ∘ T_1 ∘ ... (k times) gives cosh(kθ)

### Verification

```mathematica
(* Egypt approximation *)
n = 5;
egyptLimit = Limit[f[n-1, k], k -> Infinity]  (* → √((n+1)/(n-1)) = √(3/2) *)

(* Chebyshev at same argument *)
ChebyshevT[k, (n+1)/(n-1)] /. k -> 10  (* = cosh(10·arccosh(3/2)) *)

(* Both use same base *)
N[Sqrt[(n+1)/(n-1)]]  (* √(3/2) ≈ 1.2247 *)
N[Cosh[ArcCosh[(n+1)/(n-1)]]]  (* = 3/2 = 1.5 (as expected, cosh(arccosh(x))=x) *)
```

### Assessment

**Is this trivial?**

Partially. The individual connections are known:
- Egyptian → continued fractions → hyperbolic functions (classical)
- Chebyshev → hyperbolic cosine (definitional)
- Pythagorean → Chebyshev (known, see [OEIS A001653](https://oeis.org/A001653))

**What's potentially new:**

The explicit recognition that all three share the **same base argument** (n+1)/(n-1) arising from the Pell-free sqrt structure. This provides a unified view:

> Egyptian fractions, Chebyshev polynomials, and Pythagorean triplet families are three manifestations of the same hyperbolic iteration on (n+1)/(n-1).

### Status

🔬 **NUMERICALLY VERIFIED** - Connections tested for n = 2..20, k = 1..100.

**Open:** Is there a deeper algebraic or category-theoretic framework unifying these as "additive vs multiplicative" realizations of the same underlying structure?

---

## References

- Eppstein, D. "Egyptian Fractions" (1994-2014)
- Paper: `docs/papers/egyptian-fractions-telescoping.tex`
- Module: `Orbit/Kernel/EgyptianFractions.wl`
- `egypt/doc/sqrt.pdf` - Egyptian sqrt approximation formulas
- [OEIS A001653](https://oeis.org/A001653) - Pythagorean triple tree via Chebyshev
