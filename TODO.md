# TODO: Future Explorations

## Generalization: Beyond Primes

### Core Question

**What properties of `PrimeQ` are essential for the DAG structure and Gap Theorem to hold?**

Could we define an alternative set $S \subset \mathbb{N}$ with a similar predicate that:
- Supports greedy additive decomposition
- Forms a DAG via immediate predecessor relationships
- Satisfies an analogous Gap Theorem

### Current Implementation Dependencies

The Orbit DAG construction uses:

1. **Ordered sequence**: Enumerable set $\{s_1, s_2, s_3, \ldots\}$ with $s_{i+1} > s_i$
2. **Index function**: $\sigma: S \to \mathbb{N}$ analogous to $\pi$ (prime index)
3. **Greedy decomposition**: `Sparse(n)` - largest element $\leq n$, subtract, repeat
4. **Unique decomposition**: Greedy choice is deterministic
5. **Value-Index interplay**: The subtle mixing between VALUE space and INDEX space

### The Crucial Property: Near-Unit Local Density

**Gap Theorem relies on:**

For prime $p$ with gap $g = \text{NextPrime}(p) - p$:
- **VALUE space gap**: $g$ units between consecutive primes
- **INDEX space count**: Exactly $g$ primes at indices $\pi(p), \pi(p)+1, \ldots, \pi(p)+g-1$

This equality requires: **local density × average gap $\approx$ 1**

For primes:
- Density $\sim 1/\ln(n)$ (Prime Number Theorem)
- Average gap $\sim \ln(p)$
- Product $\approx 1$ ✓

### Candidate Sets for Testing

#### High Priority: Semiprimes

**Set**: $\{4, 6, 9, 10, 14, 15, 21, 22, 25, 26, \ldots\}$ (products of exactly 2 primes)

**Why promising:**
- Denser than primes (includes more numbers)
- Still has structure (multiplicative, related to primes)
- Greedy decomposition well-defined
- Density higher than primes → might preserve local density property

**Test**: Implement `SemiprimeOrbit` and check if analogous Gap Theorem holds

#### Medium Priority: k-Almost Primes

**Set**: Numbers with exactly $k$ prime factors (counting multiplicity)

- $k=1$: Primes (original case)
- $k=2$: Semiprimes
- $k=3$: Products of 3 primes, etc.

Explore how Gap Theorem behavior changes with $k$.

#### Sets That Will Likely Fail

**Powers of 2**: $\{2, 4, 8, 16, 32, \ldots\}$
- Gap grows exponentially: $2^{n+1} - 2^n = 2^n$
- Only 1 element in each gap range
- **Prediction**: Gap Theorem fails (gap $\gg$ count)

**Fibonacci numbers**: $\{1, 2, 3, 5, 8, 13, 21, 34, \ldots\}$
- Gaps grow super-linearly (Golden ratio growth)
- Sparse distribution
- **Prediction**: Gap Theorem fails

**Perfect squares**: $\{1, 4, 9, 16, 25, \ldots\}$
- Gap: $(n+1)^2 - n^2 = 2n + 1$
- Very sparse (density $\sim 1/\sqrt{n}$)
- **Prediction**: Gap Theorem fails dramatically

### Implementation Plan

#### Phase 1: Infrastructure Generalization

- [ ] Abstract `PrimeRepSparse` to `GreedySparse[predicate, n]`
- [ ] Abstract `PrimeOrbit` to `SetOrbit[predicate, n]`
- [ ] Abstract `DirectPrimeDag` to `DirectSetDag[predicate, max]`
- [ ] Create `SetIndex[predicate, value]` analogous to `PrimePi`

#### Phase 2: Semiprime Testing

- [ ] Implement `SemiprimeQ` predicate (or use `PrimeOmega[n] == 2`)
- [ ] Implement `Semiprime[k]` (k-th semiprime)
- [ ] Implement `SemiprimePi[n]` (count semiprimes ≤ n)
- [ ] Build semiprime DAG
- [ ] Test: Does gap(s) = count of semiprimes with s as immediate predecessor?

#### Phase 3: Theoretical Analysis

- [ ] For what density functions $\rho(n)$ does Gap Theorem hold?
- [ ] Formalize: Gap Theorem ↔ density condition
- [ ] Prove or disprove necessity of near-unit local density

#### Phase 4: Comparative Visualization

- [ ] Overlay DAG structures for different sets
- [ ] Compare in-degree distributions
- [ ] Compare orbit length growth rates
- [ ] Statistical tests: when does Gap Theorem hold?

### Open Theoretical Questions

1. **Density Threshold**: Is there a critical density below which Gap Theorem fails?

2. **Additive vs Multiplicative**: Primes are multiplicative atoms. Do we need multiplicative structure, or is additive decomposition sufficient?

3. **Uniqueness**: Greedy decomposition is unique for primes. Is uniqueness necessary?

4. **Growth Rate**: Primes have $p_n \sim n \ln n$. What growth rates preserve the theorem?

5. **Attractor Structure**: Prime 2 is unique attractor. Do all valid sets have a unique attractor?

### Computational Experiments

#### Experiment 1: Semiprime Gap Theorem

```mathematica
(* Semiprimes: products of exactly 2 primes *)
SemiprimeQ[n_] := PrimeOmega[n] == 2
Semiprime[k_] := Select[Range[2, Infinity], SemiprimeQ, k][[-1]]
SemiprimePi[n_] := Count[Range[2, n], _?SemiprimeQ]

(* Test Gap Theorem analog *)
TestSemiprimeGapTheorem[smax_] := Module[{semiprimes, violations},
  semiprimes = Select[Range[2, smax], SemiprimeQ];
  (* ... similar structure to VerifyGapTheorem ... *)
]
```

**Hypothesis**: Semiprimes are denser than primes → Gap Theorem might hold with different constant factor.

#### Experiment 2: Controlled Density Sets

Generate synthetic sets with controlled density:
- $\rho(n) = c / \ln(n)$ for various $c$
- Check which values of $c$ preserve Gap Theorem

#### Experiment 3: Minimal Counterexample

Find the "smallest" modification of primes that breaks Gap Theorem:
- Remove certain primes
- Add certain composites
- Characterize the breaking point

### Documentation

- [ ] Write mathematical paper: "Generalized Gap Theorem for Structured Sets"
- [ ] Document necessary and sufficient conditions
- [ ] Prove or disprove: PrimeQ is unique (up to density scaling)

### Meta-Question

**Is PrimeQ special, or is it just one instance of a broader pattern?**

If Gap Theorem generalizes to many sets, it reveals a deep **density-gap duality** independent of prime structure. If it fails for all other natural sets, it reveals something profound about primes themselves.

---

**Target Audience**: AI assistants (Claude Code) exploring mathematical generalizations
**Status**: Theoretical exploration, not yet implemented
**Priority**: Low (interesting but not urgent)
