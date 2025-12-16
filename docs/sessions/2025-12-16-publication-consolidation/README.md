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
