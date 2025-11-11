# Prime Index DAG and the Gap Theorem

## Motivation and Construction

Starting from a greedy binary prime-weight representation of natural numbers, we discovered a recursive tree structure that, when restricted to primes, reveals fundamental relationships between prime gaps and graph-theoretic centrality.

### The Greedy Prime Representation

For any natural number n, define the **greedy prime decomposition**:

```
PrimeRepSparse(n):
  r = n, primes = []
  while r ≥ 2:
    p = largest prime ≤ r
    append p to primes
    r = r - p
  append r to primes (remainder ∈ {0,1})
  return primes
```

**Properties:**
- Unique by construction (greedy algorithm is deterministic)
- Sparse (typically uses O(log n / log log n) primes)
- Every n ≥ 2 can be represented
- Remainder is always 0 or 1 (if r ≥ 2, there exists prime p with 2 ≤ p ≤ r)

**Examples:**
- 96 = 89 + 7 + 0
- 100 = 97 + 3 + 0
- 23 = 23 + 0

### The Recursive Tree Structure

Apply the prime index function π recursively to build trees:

```
rec(n):
  decomp = PrimeRepSparse(n)
  indices = π(decomp)  // apply π to each prime
  return [rec(i) for i in indices if i > 0, else 0]
```

Where π(p) is the index of prime p in the sequence (π(2)=1, π(3)=2, π(5)=3, ...).

**Key insight:** This creates unique rooted ordered trees with only 0-leaves for each n.

### Universal Attractors

**Theorem:** Every n ≥ 3 has prime 3 in its orbit.

**Proof sketch:** By strong induction on n.
- Base cases: n ∈ {3,4,5,6} directly contain 3 or reach it via π(5)=3
- Inductive step: For n ≥ 7, let p be the largest prime used in PrimeRepSparse(n). Then p ≥ 5, so π(p) ≥ 3. By induction on π(p) < n, the orbit of π(p) contains 3, therefore the orbit of n contains 3.

Since π(3) = 2, this proves {2,3} are universal attractors.

## The Prime DAG

Restricting to primes only, define the **direct prime DAG**:

**Vertices:** The set of primes P = {2, 3, 5, 7, 11, ...}

**Edges:** p → q if q appears in PrimeRepSparse(π(p))

This is a directed acyclic graph where:
- All primes flow to universal attractors {2, 3}
- Edge p → q means "prime p's index decomposes to include prime q"
- Not a tree: contains shortcuts and diamond patterns

### Structure Observed

- **Funnel topology:** Sources at top, converging to {2,3} at bottom
- **Hub structure:** Certain primes have very high in-degree
- **Communities:** Primes cluster by similar flow patterns
- **Layered:** Natural stratification by distance to attractors

### Why π Matters

Without the π function (using only strict < decomposition), the DAG becomes nearly linear:
- Each prime connects mainly to the previous prime
- Few interesting patterns
- Trivial flow structure

The π function creates **non-local connections** (π(113) = 30, far from 113), which generates the rich DAG structure.

## The Gap Theorem

### Statement

**Theorem:** For any prime p, the number of primes with p in their immediate orbit equals the gap after p.

Formally: Let N(p) = |{q ∈ P : p ∈ PrimeOrbit_direct(q)}|

Then: N(p) = NextPrime(p) - p

### Proof

Let p be a prime, and let g = NextPrime(p) - p be the gap after p.

**Claim:** Prime q has p in its immediate orbit iff π(q) ∈ [p, p+g).

**Proof of claim:**

(⟹) Suppose p ∈ PrimeOrbit_direct(q).

By definition, p appears in PrimeRepSparse(π(q)).

The greedy algorithm chooses the largest prime ≤ π(q) at each step.

For p to appear, we need:
- At some point in the decomposition, the remainder r satisfies: the largest prime ≤ r is p
- This requires: p ≤ r < NextPrime(p)

Since the greedy algorithm starts with π(q) and only decreases, we must have:
- π(q) ≥ p (otherwise p could never appear)
- The largest prime ≤ π(q) must be ≤ p at some point

If the largest prime ≤ π(q) is > p initially, then π(q) ≥ NextPrime(p).
But then the greedy algorithm would use NextPrime(p) instead of p.

Therefore: p ≤ π(q) < NextPrime(p) = p + g.

(⟸) Suppose π(q) ∈ [p, p+g).

Then the largest prime ≤ π(q) is p (since NextPrime(p) = p+g > π(q) ≥ p).

The greedy algorithm will choose p in the first step of decomposing π(q).

Therefore p ∈ PrimeRepSparse(π(q)), so p ∈ PrimeOrbit_direct(q). ∎

**Counting:**

The primes q with π(q) ∈ [p, p+g) are exactly:
{Prime(p), Prime(p+1), ..., Prime(p+g-1)}

This is a set of size g = NextPrime(p) - p. ∎

### Computational Verification

Example: p = 23
- NextPrime(23) = 29
- Gap = 29 - 23 = 6
- Primes with 23 in orbit: {Prime(23), Prime(24), Prime(25), Prime(26), Prime(27), Prime(28)}
- Count = 6 ✓

Example: p = 113  
- NextPrime(113) = 127
- Gap = 127 - 113 = 14
- Count = 14 primes have 113 in their immediate orbit
- This explains why 113 appeared in ~10% of orbits up to 100k - it's a major hub!

### Implications

**1. Prime gaps encode DAG centrality**

Primes followed by large gaps are structural hubs:
- High in-degree in the direct DAG
- Many paths flow through them
- Central to the dynamics of the recursion

**2. Connection to prime distribution**

The DAG structure directly reflects:
- Gap distribution (probabilistic)
- Local clustering of primes
- Deviation from average density

**3. Gaps as "bandwidth"**

The gap after p determines how many subsequent primes "depend on" p in their decomposition.

Large gaps = high influence = attractor behavior

**Notable gap primes:**
- 89: gap = 8
- 113: gap = 14
- 523: gap = 18  
- 1327: gap = 34

These are natural candidates for major hubs in the DAG structure.

## Summary

Starting from a simple greedy additive decomposition and applying the prime index function recursively, we discovered:

1. **A unique tree structure** for every natural number
2. **Universal attractors** {2, 3} that all numbers reach
3. **A prime DAG** showing flow relationships between primes
4. **The Gap Theorem**: Prime gaps directly encode graph-theoretic centrality

The construction bridges:
- **Additive structure** (greedy decomposition)
- **Ordinal structure** (prime indexing via π)
- **Graph structure** (DAG topology)
- **Distribution theory** (prime gaps)

The non-obvious connection between gaps and in-degree reveals that classical questions about prime distribution have unexpected reformulations in terms of recursive dynamics on the prime sequence.

## Extended Discoveries

### Partial Order on Gap-Children

**Observation:** Among the g primes with hub p in their direct orbit (indices p through p+g-1), their complete orbits form a partially ordered set under inclusion.

**Structure:**
- **Unique minimum**: Orbit[p] is contained in all gap-children orbits
- **Multiple maxima**: Several incomparable maximal orbits exist
- **No supremum**: No single orbit achieves the union of all gap-children orbits

**Example (p = 113, gap = 14):**
```
Core orbit: {2, 3, 7, 29, 113} (minimal, appears in all)
Union: {2, 3, 5, 7, 11, 13, 29, 113}
But: No single orbit contains both 11 and 13
  - Index 124: {2, 3, 5, 7, 11, 29, 113}
  - Index 126: {2, 3, 5, 7, 13, 29, 113}
  These are incomparable (neither ⊆ other)
```

**Interpretation:** The partial order reflects incompatible factorization patterns among consecutive indices. Different arithmetic structures lead to different orbit enrichments.

### Orbit Length Distribution

**Discovery:** Within gap-children [p, p+g), orbit lengths follow a **step function** pattern, not monotonic growth.

**Characteristics:**
- Long flat plateaus (consecutive indices with same orbit size)
- Sudden jumps (adding new primes to orbit)
- Occasional drops (indices that don't add new primes)
- Final plateau typically highest/longest

**Computational Examples:**
- Prime 113 (gap 14): lengths 5→6→5→7→7
- Prime 523 (gap 18): lengths 6→7→6→8 with clear steps
- Prime 1327 (gap 34): pronounced step structure
- Prime 31397 (gap 72): dramatic plateaus and jumps

**Implication:** Consecutive composites cluster by arithmetic complexity. The step structure reveals how groups of consecutive indices share similar decomposition properties.

### Jump Mechanism

**Question:** What causes orbit length to jump?

**Answer:** New primes enter the orbit when the offset k = (p+k) - p is prime or contains "fresh" primes in its greedy decomposition.

**Examples from gap after 31397:**
- k = 13: offset 13 is prime → adds {13} to orbit
- k = 29: offset 30 = 29 + 1 → adds {29} to orbit  
- k = 41: offset 41 is prime → adds {41} to orbit

**Key insight:** The remainder after subtracting the base prime determines jump locations. This depends on the **additive decomposition** of k, not the **multiplicative factorization** of p+k.

### Orthogonality of Structures

**Fundamental observation:** Multiplicative structure (prime factorization) and additive/recursive structure (DAG orbits) are **orthogonal views** of natural numbers.

**Example:**
- Index 31410 = 2·3²·5·349 (factorization)
- Index 31410 = 31397 + 13 (greedy additive)
- Orbit gains prime 13 (from additive), not {2,3,5,349} (from multiplicative)

**Implications:**
- Factorization does not directly predict orbit properties
- Orbit properties do not directly reveal factorization
- Both are valid decompositions of ℕ with different information content
- The Gap Theorem provides one bridge between these views

**Philosophical stance:** Study the DAG structure independently on its own terms, allowing natural connections to classical number theory to emerge rather than forcing them prematurely.

## Future Directions

- Characterize primes by their DAG properties (distance to attractors, betweenness centrality, etc.)
- Study correlation between gap distribution and community structure
- Investigate whether DAG distance relates to other prime-theoretic functions
- Explore if the construction generalizes to other sequences (Fibonacci primes, etc.)
- Develop theory of orbit length distributions and jump patterns
- Characterize the partial order structure on gap-children systematically
- Search for additional bridges between multiplicative and additive/recursive structures

---

**Filed:** November 2025  
**Status:** Recreational exploration, gap theorem proven, extended with partial order and distribution results
**Connections:** Prime gaps, graph theory, recursive dynamics, number representations, partial orders, orthogonal decompositions
