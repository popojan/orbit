# TODO: Sanity Checks and Open Questions

## Sanity Check: Is This Special to Primes?

**Purpose**: Quick reality check when developing prime-related structures.

**Heuristic**: If a discovered pattern/structure works for non-prime sequences too, it's probably:
- Trivial/obvious (not genuinely about primes)
- Unrelated to prime structure
- Wrong/coincidental

**Test**: Does Gap Theorem work for other sequences?

### Expected to Fail (Too Sparse)

- **Powers of 2**: $\{2, 4, 8, 16, 32, \ldots\}$ - exponentially sparse
- **Fibonacci**: $\{1, 2, 3, 5, 8, 13, 21, \ldots\}$ - super-linear gaps
- **Squares**: $\{1, 4, 9, 16, 25, \ldots\}$ - density $\sim 1/\sqrt{n}$

If Gap Theorem works for these → probably wrong/trivial!

### Might Be Interesting

- **Semiprimes**: $\{4, 6, 9, 10, 14, 15, \ldots\}$ (products of 2 primes) - denser than primes
- Testing whether it works here would tell us if the theorem is about:
  - Prime-specific structure (only works for primes)
  - Density properties (works for anything with similar density)

## Implementation: Abstract Sequence Version

To test Gap Theorem on other sequences, we need generic versions of core functions:

- [ ] **AbstractSparse[n, seq]** - greedy decomposition using sequence `seq` instead of primes
  - Input: integer `n`, sorted sequence `seq = {s₁, s₂, ...}`
  - Output: decomposition by repeatedly subtracting largest sᵢ ≤ remainder
  - Property: Must be deterministic (unique)

- [ ] **AbstractOrbit[n, seq]** - recursive orbit using sequence `seq`
  - Input: integer `n`, sequence `seq`
  - Output: set of all sequence elements in recursive decomposition

- [ ] **AbstractIndexFunction[s, seq]** - generalized π function
  - Input: sequence element `s`, sequence `seq`
  - Output: position of `s` in `seq` (1-indexed)

- [ ] **AbstractDirectDag[smax, seq]** - DAG for arbitrary sequence
  - Input: max value `smax`, sequence `seq`
  - Output: directed graph with edges s → max(AbstractSparse(IndexFunction(s), seq))

- [ ] **VerifyAbstractGapTheorem[smax, seq]** - test Gap Theorem for sequence
  - Check if in-degree(s) equals "gap" (next element - current element)
  - Report violations

### Test Sequences

Implement as named functions for easy testing:

- [ ] `PowersOf2[] = {2, 4, 8, 16, 32, 64, ...}`
- [ ] `Fibonacci[] = {1, 2, 3, 5, 8, 13, 21, ...}`
- [ ] `Squares[] = {1, 4, 9, 16, 25, 36, ...}`
- [ ] `Semiprimes[] = {4, 6, 9, 10, 14, 15, 21, ...}`

### Expected Results

Based on density heuristic:
- **Powers of 2, Fibonacci, Squares**: Gap Theorem should FAIL (too sparse)
- **Semiprimes**: Uncertain - this is the interesting test case!

## Other Open Questions

- [ ] Characterize primes with 100% incomparable gap-children posets
- [ ] What determines poset structure? Gap size? Arithmetic properties?
- [ ] Orbit length growth rate as function of prime index
- [ ] Distribution of path lengths to attractor (prime 2)
- [ ] Community structure in larger DAGs (beyond pmax=500)
