# Egypt Compact Representation: Range Quadruplets

**Date:** November 25, 2025
**Status:** 🔬 Working note - not peer-reviewed

---

## Core Concept

The Rust implementation in `~/github/egypt/` uses **range quadruplet representation** `(b, v, i, j)` that compresses sequences of unit fractions with arithmetic progression denominators.

**Key advantage:** Logarithmic memory compression with lazy evaluation.

---

## Range Quadruplet Definition

A quadruplet `(b, v, i, j)` represents:

```
∑_{k=i}^{j} 1/((b - v + v·k)(b + v·k))
```

**Example:**
```rust
(100, 1, 1, 5) → 1/(99·101) + 1/(100·102) + 1/(101·103) +
                 1/(102·104) + 1/(103·105)
```

Single tuple → **5 unit fractions**

**Special case (natural number):**
```rust
(n, 0, 0, 0) → n/1
```

### Expansion Algorithm

```rust
fn expand(eg: &Vec<(Integer, Integer, Integer, Integer)>) -> Vec<...> {
    for (b, v, i, j) in eg.iter() {
        if v.is_zero() && i.is_zero() && j.is_zero() {
            ret.push((b, 1, 0, 0));  // Natural number
        } else {
            for k in i..=j {
                denom = (b - v + v*k) * (b + v*k);
                ret.push((1, denom, 0, 0));
            }
        }
    }
}
```

**Lazy evaluation:** Expansion happens only when output needed.

---

## Asymmetry: Fast Decompose, Slow Sum

### Decomposition → O(log n)

```rust
fn as_egyptian_fraction_symbolic(x: &Integer, y: &Integer) {
    // Integer part (if x ≥ y)
    if x >= y {
        ret.push((x/y, 0, 0, 0));
        x %= y;
    }

    // Greedy proper fraction decomposition
    while x > 0 && y > 1 {
        let v = (-x).invert(y)?;    // Modular inverse
        let (t, x_new) = x.div_rem((x*v + 1) / y);
        y -= v * t;
        ret.push((y, v, 1, t));     // Range quadruplet
    }
}
```

**Complexity:**
- O(log y) iterations
- Each iteration: O(log² y) modular arithmetic
- Output: ~5-20 quadruplets (empirically)

### Summation → O(n²)

```rust
fn merge(eg: &Vec<...>) -> Vec<...> {
    for j in (i+1)..eg.len() {
        q += Rational::from((p.0, p.1));  // GCD + normalize
        if q.numer() == &1 { ... }        // Find subsequences summing to 1
    }
}
```

**Why slow:** Rational addition requires GCD(numerator, denominator) normalization.

**Benchmark:**
```bash
$ time ./egypt -s '2^9689 - 1' '2^9941 - 1'
real    0m0.345s    # Mersenne-scale input

$ time ./egypt --limit 2 999999 1000000
real    0m0.002s    # 17-term output
```

Memory: **O(log n)** quadruplets vs. **O(n)** explicit fractions

---

## Termination Proof Sketch: "Bubble to Head"

### Claim

`fix_duplicates()` always terminates with distinct denominators.

### Strategy

After expansion, list is sorted by denominator (ascending). Duplicates are consecutive.

**Algorithm:**
```rust
while duplicates exist {
    Find consecutive duplicates: (1/d, 1/d, ..., 1/d) at position i
    Sum: cnt/d
    Redecompose: as_egyptian_fraction_symbolic(cnt, d)
    Insert results before position i
    Preserve suffix (position ≥ last_i unchanged)
}
```

### Proof Sketch

**1. Merge direction:**
```
cnt/d where cnt ≥ 2, d > 1
→ Greedy produces: 1/d₁ + 1/d₂ + ... where dⱼ ≤ d
→ At least one dⱼ < d (greedy strictly decreases for proper fractions)
```

**2. Suffix preservation:**
- All denominators > d remain in place (`ret.extend(eg[last_i..])`)
- New terms inserted **before** position i

**3. Monotone progress:**
- Define tail start: first finalized position (no duplicates beyond)
- Each iteration: tail start moves left (more terms finalized)
- Eventually: all terms finalized

**4. Termination:**
- Finite denominators, monotone progress → guaranteed termination
- No "bounce back" (greedy only produces ≤ d from cnt/d)

### Edge Case: Multiple Integer Parts

**Scenario:**
```
Initial: (5, 1, 0, 0)     // Integer part from x ≥ y
Merge:   (1, 1, 0, 0)     // From subset → exactly 1
```

**Problem:** `(5,1,0,0) != (1,1,0,0)` → **tuple inequality**, no merge!

**Consequence:** Could produce output like:
```
5   1
1   1
1   7
...
```

This violates canonical form (single integer part expected).

**Status:**
- Empirically **never observed** (millions of random tests)
- Egypt fractions are sparse → subsets rarely sum to exact integers
- Either extremely rare or structurally impossible

**Test coverage gap:** Current tests don't verify uniqueness of integer part.

---

## Testing Invariants

**Current tests** (`~/github/egypt/wl/test.wls` lines 11-14):
```mathematica
AllTrue[Rest[First/@fractions], # == 1 &]  (* All numerators = 1 *)
DuplicateFreeQ[Last/@fractions]            (* No duplicate denoms *)
Total[Divide@@@fractions] == original      (* Correct sum *)
```

**Missing invariant:**
```mathematica
Count[Last/@fractions, 1] <= 1             (* At most one integer part *)
```

**Recommendation:** Add this check to `test.wls` to detect multiple-integer edge case.

---

## Bridge to Chebyshev Framework: Open Problem

### The Gap

**Algebraic closed forms** (Orbit paclet):
```mathematica
FactorialTerm[x, j] = 1/(1 + Sum[...])     (* Explicit rational *)
ChebyshevTerm[x, k] = 1/(ChebyshevT[...])  (* Direct formula *)
```

**Range generators** (Rust):
```rust
(b, v, i, j)  // Lazy: ∑_{k=i}^j 1/((b-v+v·k)(b+v·k))
```

**Missing:** Direct construction of `(b,v,i,j)` from Chebyshev/Pell structure.

### Why It's Hard

1. **Egypt terms ≠ Single tuples:**
   - Each FactorialTerm is explicit sum (already evaluated)
   - Raw tuple represents unevaluated range
   - Mismatch in abstraction level

2. **Post-hoc defeats purpose:**
   - Evaluate FactorialTerm → rational → greedy → compress
   - Loses closed-form symbolic advantage

3. **Structural mapping unclear:**
   - Chebyshev recurrence → polynomial denominators
   - Raw tuples → arithmetic progressions
   - No obvious correspondence

### Research Value

Both representations serve different purposes:
- **Closed forms:** Symbolic manipulation, theoretical proofs, exact algebraic relationships
- **Raw tuples:** Computational efficiency, memory compression, streaming evaluation

**Future work:** Investigate whether Chebyshev recurrence induces natural arithmetic progression patterns in expanded denominators. If so, could bridge symbolic → compressed representations.

---

## Novel Contributions

**Not novel:**
- Egyptian fractions (ancient Egypt, Fibonacci 1202)
- Greedy algorithm for decomposition (classical)
- Continued fraction → Egyptian fraction conversion (textbook)

**Novel (or underexplored):**
- **Range quadruplet compression** as primary representation
- **Logarithmic memory bound** via lazy evaluation
- **Bubble-to-head termination** for duplicate resolution
- **Natural fit for sqrt iterations** (convergence order m+2 structure)

---

## Future Directions

1. **Prove uniqueness:** Show greedy + bisection never produces multiple integer parts
2. **Rigorous complexity:** Bound on `fix_duplicates()` iterations
3. **Chebyshev bridge:** Map σ_m iterations to range patterns
4. **Hybrid implementation:** Combine symbolic Chebyshev + compressed storage
5. **Memory profiling:** Egypt vs. Chebyshev at 10⁶+ digit precision

---

## References

- Rust implementation: `~/github/egypt/src/main.rs`
- Wolfram implementation: `Orbit/Kernel/SquareRootRationalizations.wl`
- Test suite: `~/github/egypt/wl/test.wls`
- Chebyshev σ_m framework: See `docs/drafts/chebyshev-pell-sqrt-paper.tex`

**Epistemic status:** 🔬 Empirical observation + proof sketch, requires rigorous verification

---

**Key insight:** The asymmetry (fast decompose, slow sum) is a feature, not a bug. Compact representation enables lazy evaluation, making decomposition tractable for massive inputs while keeping summation as opt-in expensive operation.
