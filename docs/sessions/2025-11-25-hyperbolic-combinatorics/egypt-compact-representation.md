# Egypt Compact Representation: Range Quadruplets

**Date:** November 25, 2025
**Status:** 🔬 Working note - not peer-reviewed

---

## Overview

The Rust implementation in `~/github/egypt/` uses a **range quadruplet representation** `(b, v, i, j)` that compresses sequences of unit fractions with arithmetic progression denominators. This provides logarithmic memory compression compared to explicit expansion.

## Standard Egyptian Fractions

Classic representation:
```
7/15 = 1/3 + 1/8 + 1/120
```

Memory: **O(n)** for n terms

## Range Quadruplet Compression

### Definition

A quadruplet `(b, v, i, j)` represents the sum:

```
∑_{k=i}^{j} 1/((b - v + v·k)(b + v·k))
```

**Example:**
```rust
(100, 1, 1, 5) represents:
  1/(99·101) + 1/(100·102) + 1/(101·103) + 1/(102·104) + 1/(103·105)
```

Single tuple → **5 unit fractions**

### Implementation (Rust)

```rust
fn expand(eg: &Vec<(Integer, Integer, Integer, Integer)>) -> Vec<...> {
    let mut ret = vec![];
    for (b, v, i, j) in eg.iter() {
        if v.is_zero() && i.is_zero() && j.is_zero() {
            // Natural number part: b/1
            ret.push((b.clone(), Integer::from(1), 0, 0));
        } else {
            // Generate range: k ∈ [i, j]
            for k in i.to_usize().unwrap()..j.to_usize().unwrap() + 1 {
                ret.push((
                    Integer::from(1),
                    b.clone().sub(v).add(v.clone().mul(k))
                        .mul(b.add(v.clone().mul(k))),
                    0, 0
                ));
            }
        }
    }
    ret
}
```

**Key insight:** Expansion is **lazy** - only when needed.

## Asymmetry: Fast Decompose, Slow Sum

### Decomposition (Fast)

```rust
fn as_egyptian_fraction_symbolic(x: &Integer, y: &Integer, ...) {
    while x > 0 && y > 1 {
        let v = (-x).invert(y)?;         // O(log n) modular inverse
        let (t, x) = x.div_rem(...);
        y -= v * t;
        ret.push((y, v, 1, t));          // Compressed quadruplet
    }
}
```

**Complexity:** O(log y) iterations, each O(log² y) arithmetic
**Output size:** ~5-20 quadruplets for typical inputs

### Summation (Slow)

```rust
fn merge(eg: &Vec<...>) -> Vec<...> {
    for j in (i + 1)..eg.len() {
        q += Rational::from((p.0, p.1));  // GCD + normalization
        if q.numer() == &1 { ... }
    }
}
```

**Complexity:** O(n²) rational additions
**Why slow:** Each `Rational::from()` requires GCD and normalization

## Memory Compression

For n-term Egyptian fraction:
- **Explicit representation:** O(n) denominators
- **Range quadruplets:** O(log n) tuples (empirically)

**Example benchmarks** (from `egypt/README.md`):
```bash
$ time ./egypt -s '2 9689 ^ 1 -' '2 9941 ^ 1 -'
real    0m0.345s    # Huge Mersenne-like input

$ time ./egypt --limit 2 999999 1000000
real    0m0.002s    # 17 terms output
```

## Connection to Square Root Approximations

### Egypt Method (Orbit paclet)

```mathematica
FactorialTerm[x, j] :=
    1 / (1 + Sum[2^(i-1) * x^i * Factorial[j+i] /
                 (Factorial[j-i] * Factorial[2*i]), {i, 1, j}])
```

**Problem:** Evaluating this sum is expensive (pre-expansion).

### Chebyshev Framework

```mathematica
ChebyshevTerm[x, k] :=
    1 / (ChebyshevT[⌈k/2⌉, x+1] *
         (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1]))
```

**Advantage:** Direct formula, no summation required.

## Novel Aspect

**Not novel:**
- Egyptian fractions via continued fractions (classical)
- Greedy algorithm for decomposition (Fibonacci, 1202 AD)

**Novel (or at least underexplored):**
- **Range quadruplet compression** as base representation
- Logarithmic memory bound for lazy evaluation
- Natural fit for iterative sqrt approximations (convergence order m+2)

## Open Questions

1. **No duplicate unit fractions:** Does recursive `halve_symbolic_sums()` + expansion guarantee all denominators are distinct?
   - **Status:** Empirically true (millions of test cases), theoretically unproven
   - **Critical for correctness:** If duplicates exist, `fix_duplicates()` must handle them (see lines 140-184)

2. **Theoretical bound:** Is O(log n) compression provable for all inputs?

3. **Optimal limits:** How does `--limit` parameter affect compression ratio?

4. **Connection to σ_m orders:** Do range sizes correlate with convergence order m+2?

5. **Symbolic computation:** Can Wolfram Language leverage this for EgyptSqrt iterations?

## Future Directions

1. **Hybrid representation:** Mix quadruplets with direct Chebyshev formulas
2. **Convergence analysis:** Study range structure vs. sqrt approximation error decay
3. **Memory profiling:** Compare Egypt vs. Chebyshev memory footprint at 10⁶ digits
4. **Bridge implementation:** Export Rust quadruplets → Wolfram for symbolic manipulation

---

## References

- Rust implementation: `~/github/egypt/src/main.rs`
- Wolfram implementation: `Orbit/Kernel/SquareRootRationalizations.wl`
- Related: Chebyshev U/U framework (independent of Pell solutions)

**Epistemic status:** 🔬 Empirical observation, theoretical analysis pending

---

**Key takeaway:** The asymmetry (fast decompose, slow sum) isn't a bug—it's a feature. The compact representation naturally supports lazy evaluation, making decomposition tractable even for massive inputs.
