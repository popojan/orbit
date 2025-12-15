# Fibonacci Fraction Arithmetic

**Status:** 🔬 EXPLORATION (Dec 15, 2025)

## Setup

Every rational p/q has a canonical Fibonacci representation:
```
p/q = (Σ F_{aᵢ}) / F_n
```
where n = z(q) is the Fibonacci entry point and {aᵢ} are Zeckendorf indices of the scaled numerator m = p·F_n/q.

**Question:** What happens under arithmetic operations (+, −, ×, ÷)?

---

## Key Identities

### Fibonacci-Lucas Product
```
F_a × L_n = F_{a+n} + (-1)^{n+1} F_{a-n}
```

### Special Cases
- F_n × L_n = F_{2n} (index doubling)
- F_{2n}/F_n = L_n (scaling by Lucas)

### Divisibility
- F_n | F_m ⟺ n | m
- z(lcm(a,b)) = lcm(z(a), z(b))

---

## Addition

### Theorem (Fibonacci Fraction Addition)

For r₁ = p₁/q₁ and r₂ = p₂/q₂:

**Result:** r₁ + r₂ has Fibonacci denominator F_N where N = lcm(z(q₁), z(q₂))

**Algorithm:**
1. Compute n₁ = z(q₁), n₂ = z(q₂)
2. N = lcm(n₁, n₂)
3. Scale numerators: m₁ × (F_N/F_{n₁}), m₂ × (F_N/F_{n₂})
4. Add scaled integers
5. Apply Zeckendorf to sum

### Index Transformation

When scaling m with Zeckendorf indices {aᵢ} by F_N/F_n:

For N = 2n (simplest case):
- Factor is L_n
- Each index a transforms: a → {a+n, a-n} with sign (-1)^{n+1}

For general N = kn:
- F_{kn}/F_n = product of Lucas numbers along chain
- Apply identity iteratively

### Examples

| r₁ | r₂ | r₁ + r₂ | N = lcm(n₁,n₂) | Result indices |
|----|-----|---------|----------------|----------------|
| 1/2 | 1/3 | 5/6 | lcm(3,4) = 12 | {11, 8, 6, 3} |
| 2/5 | 3/8 | 31/40 | lcm(5,6) = 30 | {29, 26, 20, 17, 15, 13, 4, 2} |

---

## Subtraction

Subtraction follows the same pattern as addition:
- Common denominator: F_N where N = lcm(z(q₁), z(q₂))
- Subtract scaled numerators (must be positive)
- Apply Zeckendorf

### Examples

| r₁ | r₂ | r₁ - r₂ | N | Result indices |
|----|-----|---------|---|----------------|
| 3/4 | 1/3 | 5/12 | 12 | {10, 5} |
| 5/8 | 1/2 | 1/8 | 6 | {2} |
| 7/11 | 2/5 | 13/55 | 10 | {7} |

---

## Multiplication

### Entry Point Behavior

**Key difference from addition:** z(q₁ × q₂) ≠ lcm(z(q₁), z(q₂)) in general!

Examples:
- z(3×3) = z(9) = 12, but lcm(4,4) = 4
- z(5×5) = z(25) = 25, but lcm(5,5) = 5
- z(7×7) = z(49) = 56, but lcm(8,8) = 8

This connects to **Wall's conjecture**: z(p²) = p·z(p) for primes p.

### Product Identity

**F_m × F_n = (L_{m+n} - (-1)^n L_{|m-n|}) / 5**

This involves Lucas numbers, making multiplication less "Fibonacci-native" than addition.

### Examples

| r₁ | r₂ | Product | z(new denom) | Result indices |
|-----|-----|---------|--------------|----------------|
| 1/2 | 1/3 | 1/6 | z(6) = 12 | {8, 4} |
| 2/3 | 3/5 | 2/5 | z(15) = 20, but reduces to z(5) = 5 | {3} |
| 1/2 | 1/2 | 1/4 | z(4) = 6 | {3} |

---

## Summary: Addition vs Multiplication

| Operation | Denominator Entry Point | Scaling Factor | Native? |
|-----------|------------------------|----------------|---------|
| Addition | N = lcm(n₁, n₂) | F_N/F_nᵢ = Lucas products | ✓ Fibonacci |
| Multiplication | z(q₁ q₂) ≠ lcm (complex) | Involves L/5 | Hybrid Fib-Lucas |

---

## Index-Space Algorithms

### Why Zeckendorf Chose All-Positive

Zeckendorf's representation (gap ≥ 2, all positive) is the **simplest** unique representation, but not the only one:

| Representation | Gap Rule | Coefficients | Unique? |
|---------------|----------|--------------|---------|
| Zeckendorf | ≥ 2, same sign | {0, 1} | ✓ |
| Far-difference (Alpert) | ≥ 4 same, ≥ 3 opposite | {-1, 0, +1} | ✓ |

For arithmetic, **signed representations** may be more natural since the Lucas scaling identity produces signed results.

### Normalization Rules

**Addition (consecutive same-sign):**
- F_n + F_{n-1} = F_{n+1}

**Subtraction (gap-2):**
- F_n - F_{n-2} = F_{n-1}

**Larger gaps:** Expand using F_n = F_{n-1} + F_{n-2} until gap closes.

**Example:** F_8 - F_4 = 21 - 3 = 18
```
F_8 = F_7 + F_6
F_8 - F_4 = F_7 + F_6 - F_4
F_6 - F_4 = F_5  (gap-2 rule)
= F_7 + F_5 = {7, 5}  ✓
```

### Complexity (Literature Results)

**Key references:**
- Ahlbach, Usatine, Pippenger (2012) [arXiv:1207.4497]
- Idziaszek (2021) [LIPIcs.FUN.2021.16]

**Zeckendorf arithmetic complexity (n-digit numbers):**

| Operation | Time | Circuit Size | Circuit Depth |
|-----------|------|--------------|---------------|
| Addition | O(n) | O(n) | O(log n) |
| Subtraction | O(n) | O(n) | O(log n) |
| Multiplication (naive) | O(n²) | O(n²) | O(n log n) |
| **Multiplication (FFT)** | **O(n log n)** | - | - |
| Normalization | O(n) | O(n) | O(log n) |

**Key insight (Idziaszek 2021):** Multiplication via golden ratio base:
1. Convert Zeck → Lucas representation: O(n)
2. Convert Lucas → base-φ: O(n)
3. FFT convolution: O(n log n)
4. Normalize weights [0,M]: O(n log M) = O(n log n)
5. Convert base-φ → Zeck: O(n)

**Total: O(n log n)** - matching binary multiplication!

**Normalization algorithm (Theorem 2):**
For weights in range [0, M], normalization takes O(n log M) via bit decomposition:
- Decompose each weight into m = ⌊log M⌋ + 1 bits
- Perform m phases of doubling + addition
- Each phase is O(n), total O(n log M)

---

## Zeckendorf vs Alpert: Analysis

### Question: Should we switch to Alpert for arithmetic?

**Key Finding:** Denominators are INDEPENDENT of numerator representation.
- Denominator = F_n where n = z(q) from Pisano divisibility
- This holds for both Zeckendorf and Alpert numerators

### Lucas Identity and Alpert Gaps

The Lucas scaling identity produces:
```
F_a × L_n = F_{a+n} + (-1)^{n+1} F_{a-n}
Gap = 2n
```

**Gap analysis:**
| n | Sign of second term | Gap | Alpert requirement | Valid? |
|---|--------------------|----|-------------------|--------|
| 1 | + (same) | 2 | ≥ 4 | ❌ |
| 2 | − (opposite) | 4 | ≥ 3 | ✓ |
| 3 | + (same) | 6 | ≥ 4 | ✓ |
| 4 | − (opposite) | 8 | ≥ 3 | ✓ |

**Conclusion:** For n ≥ 2, Lucas outputs naturally satisfy Alpert gap requirements!

### Why Zeckendorf was chosen (for Fibonacci Fractions)

1. **Simplicity:** All coefficients are +1 (indices only, no signs)
2. **Canonical:** Greedy algorithm produces unique result
3. **Historical:** Zeckendorf (1972) predates Alpert (2009)
4. **Same complexity:** Both use O(log n) terms asymptotically

### Example: Same number, different representations

For n = 10:
- **Zeckendorf:** F_6 + F_3 = 8 + 2 = 10 (gap=3, same sign)
- **Alpert:** F_7 − F_4 = 13 − 3 = 10 (gap=3, opposite sign)

Both have 2 terms, but Alpert requires tracking signs.

### Trade-offs for Arithmetic

| Aspect | Zeckendorf | Alpert |
|--------|-----------|--------|
| After Lucas scaling | Needs normalization | Often already valid |
| Storage | Indices only | Indices + signs |
| Algorithm | Simple greedy | More complex |
| Normalization | Well-understood | Less explored |

### Recommendation

**Keep Zeckendorf for canonical representation** but internally use signed intermediate forms during arithmetic, then normalize to Zeckendorf at the end.

This gets the best of both:
- Lucas scaling produces signed sums naturally
- Final output is canonical Zeckendorf
- No need to implement full Alpert normalization

---

## Comparison: Fibonacci vs Standard Rational Arithmetic

### Standard Rational Arithmetic (p/q + r/s)

Let n = max(log p, log q, log r, log s) be the bit-size.

| Operation | Naive | Best Known |
|-----------|-------|------------|
| gcd(q, s) | O(n²) | O(n log² n log log n) |
| lcm(q, s) | O(n²) | O(n log n) after gcd |
| Multiply p×s, r×q | O(n²) | O(n log n) FFT |
| Add numerators | O(n) | O(n) |
| **Total** | **O(n²)** | **O(n log² n log log n)** |

### Fibonacci Fraction Arithmetic

**Bottleneck: Computing z(q)** (Fibonacci entry point)

| Step | Complexity | Notes |
|------|------------|-------|
| Compute z(q₁), z(q₂) | **Unknown** | Requires factoring or search |
| N = lcm(z(q₁), z(q₂)) | O(n log² n) | After entry points known |
| Scale by F_N/F_n | O(n log n) | Lucas chain multiplication |
| Add numerators | O(n) | Zeckendorf addition |
| Normalize result | O(n) | 3-pass algorithm |

**The z(q) problem:**
- For general q, computing z(q) requires knowing prime factorization
- z(p) for prime p divides p² − 1 (or 2(p² − 1) if p ≡ ±1 mod 5)
- No polynomial-time algorithm known for computing z(q) from q alone
- **This makes Fibonacci arithmetic NOT faster than standard for arbitrary rationals**

### When Fibonacci Arithmetic IS Efficient

1. **Denominators are Fibonacci numbers:** z(F_n) = n (trivial)
2. **Entry points precomputed/cached:** Amortized over many operations
3. **Working within Fibonacci lattice:** All denominators divide some F_N

**Special case: Fibonacci-denominator fractions**
If q₁ = F_{n₁} and q₂ = F_{n₂}:
- z(F_n) = n (immediate)
- N = lcm(n₁, n₂) (integer lcm, O(log n))
- All operations become O(n log n) or better

### Verdict

**For general rationals:** Standard arithmetic is better (no z(q) computation needed).

**For Fibonacci-denominator fractions:** Fibonacci arithmetic achieves O(n log n), competitive with best rational algorithms, and may have structural advantages (index-space operations, no large integer gcd).

---

## Open Questions

1. **Full index-space subtraction algorithm?** Need complete borrowing rules for arbitrary signed combinations.

2. ~~**Connection to far-difference representation?**~~ RESOLVED: Alpert gaps are naturally satisfied by Lucas outputs for n ≥ 2.

3. **Multiplicative closure?** When does F_a/F_b × F_c/F_d simplify to another Fibonacci ratio?

4. **Optimal representation for arithmetic?** Hybrid approach recommended: signed intermediate, Zeckendorf output.

5. **Fast z(q) computation?** Is there a subexponential algorithm for Fibonacci entry point without factoring?
