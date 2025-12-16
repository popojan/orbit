# Publication Consolidation

**Date:** December 16, 2025

## Summary

External review of 7 papers. Cleanup and refinements based on feedback.

## Key Changes

- Deleted tautological modules (ChebyshevZeta, PrimeOrbits)
- Unified bibliography (`references.bib`)
- Reframed Egyptian fractions novelty (computational refinement, not new bijection)
- Added OEIS sequence references (A034386, A001175, A000045)
- Tightened Fibonacci Prop 4.1 (anti-symmetric polynomial class)

## Review Verdict

Top 3 ready for submission: Primorial, Chebyshev integral, Egyptian fractions.

See `docs/STATUS.md` for current paper status.

---

## Research Timeline (recalled Dec 16, 2025)

Original path to discoveries (pre-AI collaboration):

```
Lissajous visualization experiments
    ↓
"which crossing is closest to origin?" → idx[] function
    ↓
answer: k = x⁻¹ mod p (or p - x⁻¹)
    ↓
observation: approximation error is always ±1/(pk) — unit fraction!
    ↓
idea: custom Egyptian fractions algorithm
    ↓
problem: O(n) terms worst case
    ↓
observation: repeated steps return "same" results up to some point
    ↓
idea: execute all identical steps at once → range [i,j]
    ↓
telescoping format {u, v, i, j} → O(log n) tuples
```

Later (with AI collaboration):
```
what's original vs. rediscovered?
    ↓
connections to class numbers via sign function
    ↓
QR clustering, reflection duality L'/L*
```

Key insight: The unit fraction error property follows directly from xk ≡ ±1 (mod p).

---

## Sign-Cosine Paper: Deep Analysis

**Status:** Needs substantial rework. Original framing rejected by reviewer.

### Problem with Original Paper

The paper claims "geometric interpretation" of class numbers via Chebyshev lobes, but:
- W(p) = 4*S(1, p/4) - 2 reduces to classical quarter-interval sum
- "Chebyshev" framing is cosmetic — removing it doesn't change mathematics
- Reviewer: "notational reformulation, not mathematical novelty"

### New Discovery: QR Clustering

Adversarial analysis revealed a genuine geometric phenomenon:

**Observation:** For all p = 1 (mod 4), quadratic residues (QR) cluster at edges of {1,...,p-1}, while QNR cluster in the middle.

| p | avg|QR - p/2| | avg|QNR - p/2| | QR farther? |
|---|---------------|----------------|-------------|
| 5 | 1.5 | 0.5 | Yes |
| 13 | 3.8 | 2.2 | Yes |
| 17 | 4.8 | 3.2 | Yes |
| 29 | 8.1 | 5.9 | Yes |
| 37 | 10.4 | 7.6 | Yes |
| ... | ... | ... | Always Yes |

This is universal for p = 1 (mod 4).

### Why This Matters

1. **Sign function detects QR clustering:**
   - sign(cos((2k-1)pi/p)) = +1 at edges (k near 1 or p-1)
   - sign = -1 in middle (k near p/2)
   - QR preferentially fall where sign = +1

2. **Class number quantifies clustering:**
   - h(-p) = 2 * S(1, p/4) = 2 * (QR excess in first quarter)
   - Measures how unevenly QR distribute across number line

3. **Symmetry alignment is not trivial:**
   - Geometric symmetry (cos even around pi) aligns with
   - Arithmetic symmetry (chi(p-k) = chi(k) when -1 is QR)
   - Both conditions hold exactly when p = 1 (mod 4)

### Potential Paper Reframe

Instead of "Chebyshev lobes" (cosmetic), focus on:
- QR clustering as geometric phenomenon
- Sign function as clustering detector
- Class number as clustering measure
- Why geometric and arithmetic symmetries align

### Open Questions

1. Is QR clustering at edges a known result? (Need literature search)
2. Is there deeper reason why geometric (cos) and arithmetic (chi) symmetries coincide for p = 1 (mod 4)?
3. Can this perspective yield new bounds or algorithms?

### Literature Search Results

**Classical geometric interpretation of h(-p):**
- Lattices in complex plane with complex multiplication
- Ideal classes = homothety classes of lattices
- Connection to binary quadratic forms (Gauss)

**QR distribution — known results:**
- Quadratic excess E(p) = QR in (0,p/2) minus QR in (p/2,p) — Davenport 1930s
- For p ≡ 3 (mod 4): E(p) > 0 (QR cluster at beginning)
- For p ≡ 1 (mod 4): E(p) = 0 (symmetric)
- Quarter-interval sums S(1, p/4) = h(-p)/2 — Dirichlet, classical

**Our reformulation (potentially novel):**
- "QR are on average farther from center than QNR" for p ≡ 1 (mod 4)
- Equivalent to S(1, p/4) > 0 but different presentation
- Sign function as "edge detector" — not found in literature

**Conclusion:**
The underlying mathematics is classical (Dirichlet's quarter-interval formula).
The geometric presentation as "QR edge-clustering" may be novel framing.
Worth developing if it provides new intuition or pedagogical value.

### Sources

- [John D. Cook: Distribution of Quadratic Residues](https://www.johndcook.com/blog/2019/07/12/distribution-of-quadratic-residues/)
- [Keith Conrad: Quadratic Residue Patterns](https://kconrad.math.uconn.edu/blurbs/) (local: papers/QuadraticResiduePatterns.pdf)
- [Wikipedia: Class number problem](https://en.wikipedia.org/wiki/Class_number_problem)

---

## Implementation: SignCosineIdentities.wl

Added `Orbit/Kernel/SignCosineIdentities.wl` module with:

### Functions

- `SignCosineA[p]` — Unweighted sum: A(p) = Σ sign(cos((2k-1)π/p))
- `SignCosineW[p]` — Character-weighted sum: W(p) = Σ χ(k)·sign(cos((2k-1)π/p))
- `SignCosinePartition[p]` — Partition counts: QR+, QR-, NQR+, NQR-
- `SignCosineVerifyIdentities[p]` — Verify all identities
- `SignCosineTable[pmax]` — Generate table for primes up to pmax

### Key Identities (Verified)

1. **Closed forms:**
   - p ≡ 1 (mod 4): A(p) = -2, W(p) = 2h(-p) - 2
   - p ≡ 3 (mod 4): A(p) = 0, W(p) = 2

2. **Unified identity:** W(p) = 2 - A(p)·(h(-p) - 2)

3. **Partition identities:**
   - (A + W)/2 = QR+ - QR-
   - (A - W)/2 = NQR+ - NQR-

### Verification

All 14 primes from 3 to 47 pass identity verification.

---

## Lissajous Connection to Class Numbers

### Discovery

The sign-cosine identity connects to Lissajous curve geometry via modular inverses.

### Lissajous Curves

For frequency ratio ω = x/y (coprime), the parametric curve:
```
(Sin[π·(x/y)·t], Sin[π·t])
```
crosses the x-axis at integer t = 0, 1, ..., 2y. At crossing t = k, the x-coordinate is:
```
x_k = Sin[π·x·k/y]
```

### Key Observation

**The crossing closest to origin (but not at origin)** occurs at:
```
k = y - x⁻¹ mod y
```
where x⁻¹ is the modular inverse. This gives x·k ≡ -1 (mod y), so:
```
x_k = Sin[π(y-1)/y] = Sin[π - π/y] ≈ π/y  (small)
```

### Connection to Class Numbers

**Theorem:** For prime p,
```
Σ_{x=1}^{p-1} χ(x) · sign(cos((2k-1)π/p))  where k = p - x⁻¹
```
equals **χ(-1) · W(p)**.

**Proof:** The map x → k = p - x⁻¹ is a bijection on {1, ..., p-1}.
- From k = p - x⁻¹, we get x⁻¹ = p - k, so x = (p-k)⁻¹ ≡ (-k)⁻¹ (mod p)
- Therefore χ(x) = χ((-k)⁻¹) = χ(-k)⁻¹ = χ(-1)·χ(k)⁻¹ = χ(-1)·χ(k)
- Summing: Σ_x χ(x)·sign(k) = χ(-1) · Σ_k χ(k)·sign(k) = χ(-1)·W(p)

**Corollary:**
- p ≡ 1 (mod 4): Lissajous sum = W(p) = 2h(-p) - 2
- p ≡ 3 (mod 4): Lissajous sum = -W(p) = -2

### Unified Picture

Three domains connected by the modular inverse:

| Domain | Role of x⁻¹ mod y |
|--------|-------------------|
| **Lissajous geometry** | Determines crossing closest to origin |
| **Egyptian fractions** | Constructs telescoping tuples |
| **Class numbers** | Bijection preserving character sum structure |

The modular inverse / XGCD algorithm is the common computational thread.

---

## Lissajous Paper Development (Continued)

### Reflection Duality Discovery

Key insight: There are **two** crossings closest to the origin, forming a symmetric pair:

- **k' = x⁻¹ mod p** — the "left" crossing (equivalently: first crossing with x·k ≡ 1)
- **k* = p - x⁻¹ mod p** — the "right" crossing (equivalently: first crossing with x·k ≡ -1)

These satisfy the reflection relation: **k' + k* = p**

### Duality Formulas

Define weighted sums over all x ∈ {1, ..., p-1}:

```
L' = Σ χ(x) · sign(sin(πx·k'/p))   where k' = x⁻¹
L* = Σ χ(x) · sign(sin(πx·k*/p))   where k* = p - x⁻¹
```

**Results:**
- L' = W(p)
- L* = χ(-1) · W(p)
- L' + L* = (1 + χ(-1)) · W(p)
- L' - L* = (1 - χ(-1)) · W(p)
- **L' · L* = χ(-1) · W²** ← sign detects p mod 4!

### Case Analysis

| Condition | L' | L* | L' + L* | L' · L* |
|-----------|----|----|---------|---------|
| p ≡ 1 (mod 4) | W | W | 2W | +W² |
| p ≡ 3 (mod 4) | 2 | -2 | 0 | -4 |

### Symmetric Class Number Formula

For p ≡ 1 (mod 4):
```
h(-p) = 1 + (L' + L*)/4
```

This uses **both** closest crossings symmetrically.

### Paper Updates Made

1. **Added Reflection Duality section** (Theorem 6, Definition, Corollaries 7-8)
2. **Expanded Proposition 6** to include NQR identity: (A-W)/2 = NQR+ - NQR-
3. **Restructured introduction** — moved Chebyshev formula from intro to Section 3.2
4. **Fixed bibliography** — unified with references.bib, proper citation keys
5. **Removed Computational Verification section** (redundant if no proof gaps)
6. **Created Lissajous figure script** — scripts/lissajous-figure.wl

### Computational Complexity Analysis

**Question:** Do our identities speed up class number computation?

**Answer:** No algorithmic speedup.
- Computing L' or L* requires modular inverse for each x: O(p · log p) operations
- Direct computation of h(-p) via Dirichlet also O(p · log p)
- Jacobi symbol evaluation: O(log² p) bit operations per evaluation
- Modular inverse via XGCD: O(log p) divisions, O(log² p) bit operations

**Conclusion:** Same asymptotic complexity. Value is conceptual, not computational.

### Research Directions Identified

The "conceptual insight" from the Lissajous perspective enables:

1. **New questions:**
   - Other curves with frequency ratio x/p?
   - 3D Lissajous analogs with analogous arithmetic structure?
   - What happens for composite moduli?

2. **Cross-domain connections:**
   - Physics applications (harmonic oscillators)?
   - Signal processing (frequency analysis)?

3. **Generalizations:**
   - Higher-order characters beyond Legendre?
   - Non-prime moduli?

4. **Modular inverse meta-pattern:**
   - Same structure appears in Egyptian fractions, XGCD, and now Lissajous
   - Is there a unifying framework?

5. **Reflection duality analogs:**
   - Do similar dualities exist in other character sum contexts?
   - Connection to functional equations?

6. **QR clustering applications:**
   - Visual tools for number theory education?
   - New perspectives on classical problems?

### Files Created/Modified

- `docs/papers/lissajous-class-numbers.tex` — main paper, extensively updated
- `scripts/lissajous-figure.wl` — figure generation script
- `docs/learning/lissajous-history.md` — historical background
- `docs/papers/references.bib` — added Popelka2025sign, Popelka2025egypt entries

### Literature Check

Confirmed: The Lissajous → class numbers perspective appears novel. The underlying mathematics (Dirichlet quarter-sum) is classical, but the geometric framing via Lissajous curves and the reflection duality formulation are new.

Recommended venues from external review:
- American Mathematical Monthly (appreciates "new perspectives on classics")
- Journal of Number Theory

### Future Directions Added to Paper

Three concrete open questions formulated:

1. **Geometric interpretation for composite discriminants:** ⚠️ REFRAMED after literature check.
   - The algebraic formula h(d) ~ √|d| · L(1, χ_d) / π with Kronecker symbol is CLASSICAL
   - What's OPEN: Does our *geometric* interpretation (Lissajous crossings) extend?
   - Complications: modular inverses only exist when gcd(x,n)=1; bijection structure changes
   - New framing: "Does 'closest crossing' perspective yield insight for discriminants beyond -p?"

2. **Higher-order characters:** ✅ Confirmed open after literature check.
   - Cubic reciprocity, Gauss sums for higher characters are known
   - BUT: Our specific identity χ(x) = χ(k*(x)) for higher characters is NOT in literature
   - Requires χ(-1) = 1 in character group — severely constrains which work

3. **Modular inverse as unifying structure:** ✅ Confirmed open after literature check.
   - No categorical framework found linking the three contexts
   - x⁻¹ mod n appears in: Lissajous crossings, Egyptian fractions, XGCD
   - Genuinely unexplored meta-question
