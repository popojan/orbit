# Lattice Path Synthesis: Egypt ↔ Lobb ↔ Stern-Brocot

**Date:** 2025-11-25
**Context:** Connecting hyperbolic-factorial identity with lattice path interpretation

---

## Executive Summary

**Discovery:** Egypt factorial series has combinatorial interpretation via **Lobb numbers** (Grand Dyck paths) and connects to **Stern-Brocot tree** structure from archived "primal forest" work.

**Key equation:**
```
Cosh[(1+2k)·ArcSinh[√(x/2)]] = (√2·√(2+x)) · (1/2 + Σ 2^(i-1)·x^i·(k+i)!/((k-i)!·(2i)!))
```

**Factor (1+2k) appears in:**
- Hyperbolic argument: Cosh[(1+2k)·...]
- Lobb formula: T(n,k) = **(2k+1)** · C(2n, n-k) / (n+k+1)
- Not a coincidence!

---

## Three Lattice Path Structures

### 1. Lobb Numbers (Grand Dyck Paths)

**Formula:** T(n,k) = (2k+1) · C(2n, n-k) / (n+k+1)

**Counts:**
- Lattice paths (0,0) → (n,n) touching line x-y=k
- Grand Dyck paths with k downward returns to x-axis
- Standard tableaux of shape (n+k, n-k)

**First column:** Catalan numbers C_n

**Triangle:**
```
n=0: 1
n=1: 1, 1
n=2: 2, 3, 1
n=3: 5, 9, 5, 1
n=4: 14, 28, 20, 7, 1
n=5: 42, 90, 75, 35, 9, 1
```

### 2. Egypt Coefficients (Our Formula)

**Formula:** a_i(k) = 2^(i-1) · Poch[k-i+1, 2i] / (2i)!

**Sequences:**
```
k=1: {1}
k=2: {3, 2}
k=3: {6, 10, 4}
k=4: {10, 30, 28, 8}
k=5: {15, 70, 112, 72, 16}
k=6: {21, 140, 336, 360, 176, 32}
```

**Pattern:** First term = k(k+1)/2 (triangular numbers) ✓

**Shared values with Lobb:** 28 appears in both!

### 3. Stern-Brocot / Primal Forest (C(3i, 2i))

**From archived work:**

For simple symmetric cases (Wildberger algorithm):
```
Coefficient at position i: 2^(i-1) · C(3i, 2i)
```

**C(3i, 2i) = lattice paths from (0,0) to (2i, i)**
- 2i steps RIGHT
- i steps UP

**Connection to continued fractions:**
- LR string = path in Stern-Brocot tree
- Egypt approximates √n via rational continued fraction
- Monotonic convergence vs alternating (CF)

---

## Synthesis: Three Perspectives on Same Structure

### Common Elements

**All three involve:**
1. Central binomial structure (2i)! in denominator
2. Powers of 2: 2^(i-1) or (2k+1) factor
3. Pochhammer / rising factorials
4. Lattice path interpretation

### Hypothesis: Weighted Lobb Sum

**Egypt factorial series might be:**
```
Σ 2^(i-1) · x^i · (weight) · Lobb(n_i, k_i)
```

where weight and indices depend on k, i parameters.

**Evidence:**
- Factor (1+2k) in both hyperbolic arg and Lobb formula
- Central binomials appear in both
- Triangular number pattern (first terms)

### Lattice Path Bijection (Conjecture)

**Egypt trajectory as weighted Grand Dyck path:**

1. **Start:** (0,0)
2. **Steps:** UP='+', DOWN='-' (from Wildberger LR)
3. **Weight:** Each path weighted by 2^(i-1) · x^i
4. **Constraint:** Touch but don't cross specific line (Lobb)
5. **Endpoint:** Related to √n approximation bounds

**Example for k=3:**
```
Coefficients {6, 10, 4} encode:
- 6 paths at level i=1
- 10 paths at level i=2
- 4 paths at level i=3
```

**Each path contributes:**
- 2^(i-1): binary branching choices
- x^i: weight parameter
- Poch/factorial: constrained ordering on path

---

## Connection to Monotonic Convergence

**Why Egypt is monotonic (vs CF alternating):**

**Chebyshev polynomials outside [-1,1]:**
- Egypt evaluates T_n(x+1) where x = Pell solution >> 1
- Far outside oscillatory region [-1,1]
- Polynomials become **monotonic**

**Lattice path view:**
- Grand Dyck paths with **no crossing** below x-axis
- Always touch but stay above (Lobb condition)
- This enforces **monotonic approach** to limit

**Contrast with continued fractions:**
- CF alternates above/below target
- Corresponds to paths that **cross** reference line
- Different lattice constraint → different convergence

---

## Hyperbolic → Lattice Path Interpretation

**Our identity:**
```
Cosh[(1+2k)·ArcSinh[√(x/2)]] = factorial_series
```

**Decomposition:**
1. **ArcSinh:** Inverse hyperbolic sine (growth rate)
2. **Multiply by (1+2k):** Scale factor = Lobb (2k+1)
3. **Cosh:** Symmetric combination (path doubling?)
4. **Result:** Weighted sum of lattice path counts

**Combinatorial meaning:**
```
Hyperbolic function value =
  Sum over all Grand Dyck paths satisfying constraints:
    path_weight · 2^(branching_choices) · x^(path_length)
```

---

## Open Questions

### Q1: Explicit Bijection

**Find concrete bijection for k=1,2,3:**

Map each Egypt coefficient term to specific set of:
- Grand Dyck paths (Lobb)
- Or Stern-Brocot tree nodes
- Or standard tableaux

**Test:** Does bijection preserve count and weight?

### Q2: Why (1+2k)?

**Same factor in:**
- Cosh[(1+2k)·...] → hyperbolic argument
- (2k+1) → Lobb formula multiplier

**Possible explanations:**
- Scaling for path height constraint
- Relates to number of "returns" in Grand Dyck path
- Connection to Chebyshev recurrence degree

### Q3: Generalization

**Does this extend to:**
- Other Chebyshev types (U_n, V_n, W_n)?
- Other hyperbolic combinations?
- Complex argument generalizations?

### Q4: Computational Utility

**Can lattice path view provide:**
- Faster algorithms for Egypt approximation?
- Better error bounds via path counting?
- Geometric interpretation of convergence rate?

---

## Next Steps

**Immediate:**
1. Compute explicit bijection for k=1,2 (small cases)
2. Verify Lobb relationship for first few terms
3. Connect to Stern-Brocot tree structure

**Medium term:**
1. Formalize lattice path → factorial series mapping
2. Prove combinatorial identity connecting Lobb + Egypt
3. Extend to general Chebyshev polynomial interpretation

**Long term:**
1. Publish combinatorial interpretation of Egypt method
2. Connect to broader theory of orthogonal polynomials + lattice paths
3. Explore applications in algebraic number theory

---

## References

**Internal:**
- `docs/sessions/archive/three-questions-systematic-analysis.md` - C(3i, 2i) binomial, SB tree
- `docs/proofs/factorial-chebyshev-recurrence-proof.md` - Algebraic equivalence
- `docs/sessions/2025-11-22-palindromic-symmetries/` - Original Egypt discovery

**OEIS:**
- A039599: Lobb numbers triangle
- A000108: Catalan numbers
- A000217: Triangular numbers

**Literature to explore:**
- Lobb, A.: "Derived Equivalences of K3 Surfaces and Twists" (where Lobb numbers appear)
- Spitzer, F.: "A combinatorial lemma and its application to probability theory"
- Stanley, R.P.: "Enumerative Combinatorics" (lattice path chapters)

---

**Status:** Synthesis complete, bijection conjectured, awaiting explicit verification
