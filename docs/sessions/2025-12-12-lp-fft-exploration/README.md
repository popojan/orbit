# L^p FFT Exploration: Roots of Unity in Non-Euclidean Geometries

**Date:** 2025-12-12
**Status:** Exploratory hypothesis
**Context:** Emerged from CyclotomicFFT γ-framework integration

---

## Observation

The γ framework supports arbitrary L^p geometries via `κ[t, p]`. When applied to roots of unity:

```mathematica
κ[ρ[n, k], p]  (* k-th n-th root in L^p geometry *)
```

This places the same angular positions on different "unit circles":

| p | Geometry | Shape | Unit set |
|---|----------|-------|----------|
| 1 | Taxicab | Diamond | \|x\| + \|y\| = 1 |
| 2 | Euclidean | Circle | x² + y² = 1 |
| ∞ | Chebyshev | Square | max(\|x\|, \|y\|) = 1 |

---

## Initial Findings (n = 8)

For 8th roots of unity in different geometries:

| k | p=2 (circle) | p=1 (diamond) | p=∞ (square) |
|---|--------------|---------------|--------------|
| 1 | (0.71, 0.71) | (0.5, 0.5) | (1, 1) |
| 2 | (0, 1) | (0, 1) | (0, 1) |
| 3 | (-0.71, 0.71) | (-0.5, 0.5) | (-1, 1) |
| 4 | (-1, 0) | (-1, 0) | (-1, 0) |
| 5 | (-0.71, -0.71) | (-0.5, -0.5) | (-1, -1) |
| 6 | (0, -1) | (0, -1) | (0, -1) |
| 7 | (0.71, -0.71) | (0.5, -0.5) | (1, -1) |
| 8 | (1, 0) | (1, 0) | (1, 0) |

**Key observations:**
1. Points on axes (k=2,4,6,8) are **identical** across all geometries
2. Points on diagonals (k=1,3,5,7) differ by geometry
3. All points have unit norm in their respective L^p metric

---

## Hypothesis: Walsh-Hadamard ↔ L^∞ Connection

The p=∞ case gives vertices of a square: {±1} × {±1}.

Walsh-Hadamard transform uses basis functions valued in {-1, +1}.

**Original conjecture:** Walsh-Hadamard transform is the "L^∞ FFT" — the limiting case of DFT as p → ∞.

**Update:** This is **FALSE**. L^∞ roots have zeros (points on axes), while Walsh uses only {±1}.
However, L^∞ geometry DOES define a valid "square DFT" with angle-preserving multiplication.

---

## Key Finding: Angle Invariance

**L^p geometry preserves angular multiplication!**

The multiplication operation in ALL L^p geometries is:
1. Standard complex multiplication: `(a+bi)(c+di)`
2. Normalize result to L^p unit: `z / ||z||_p`

Verified for n=8:
```
z₁ = (1,1)  →  z₁² = 2i  →  L^∞ norm: (0,1) = k=2  ✓
z₁³ = (-2,2) →  L^∞ norm: (-1,1) = k=3  ✓
... all 8 powers match!
```

**Invariant:** angle (= t parameter in γ framework)
**Variant:** distance from origin (= 1 in respective L^p norm)

This means the γ framework's `⊗` operation (parameter addition) is **geometry-independent**!

---

## Open Questions

1. ~~**Does "L^p DFT" have a consistent definition?**~~  → YES, via angle-preserving multiplication
   - ~~What is the correct multiplication operation in L^p geometry?~~ → complex mult + L^p normalization
   - Is there a meaningful convolution theorem?

2. **Interpolation between FFT and Walsh-Hadamard**
   - As p goes from 2 to ∞, how does the transform change?
   - Is there a continuous family of transforms?

3. **p = 1 (Taxicab) case**
   - Diamond geometry has π = 4 (same as Chebyshev!)
   - What transform corresponds to p = 1?

4. **Tropical algebra connection**
   - Tropical semiring uses max/+ operations
   - This relates to L^∞ geometry
   - Is there a "tropical FFT"?

---

## Implementation: LpDFT

Added to `Orbit/Kernel/CyclotomicFFT.wl`:

```mathematica
<< Orbit`

signal = {1, 2, 3, 4, 5, 6, 7, 8};

LpDFT[signal, 2]   (* standard circular DFT *)
LpDFT[signal, 1]   (* diamond/taxicab geometry *)
LpDFT[signal, ∞]   (* square/Chebyshev geometry *)
```

### Experimental findings

| Property | p=2 | p=1 | p=∞ |
|----------|-----|-----|-----|
| Perfect reconstruction | Yes | Approx | Approx |
| Spectral leakage | None | Yes | Yes |
| Hölder dual | — | p=∞ | p=1 |

**p=1 and p=∞ are Hölder conjugates:** Their spectra have constant ratio √2.

### Sparsity comparison

Tested on 20 random 16-element signals (threshold 0.3):

| p | Mean sparse bins | Interpretation |
|---|------------------|----------------|
| 2 | 8.75% | Baseline |
| 1 | 10.6% (~20% more) | Slightly more sparse |
| ∞ | 4.4% | Less sparse |

**Observation:** p=1 gives slightly more sparse representations, but the effect is modest.

---

## Literature to Search

- "L^p Fourier transform"
- "Walsh-Hadamard" + "geometric interpretation"
- "Tropical Fourier transform"
- "Non-Euclidean signal processing"

---

## Code to Run

```mathematica
<< Orbit`

(* Compare n-th roots in different geometries *)
compareRoots[n_, p_] := N[κ[ρ[n, Range[n]], p]]

(* Visualize *)
visualize[n_] := Graphics[{
  {Blue, Circle[]},
  {Red, Line[{{-1,0},{0,1},{1,0},{0,-1},{-1,0}}]},  (* diamond *)
  {Green, Line[{{-1,-1},{-1,1},{1,1},{1,-1},{-1,-1}}]},  (* square *)
  {PointSize[Large],
    {Blue, Point[compareRoots[n, 2]]},
    {Red, Point[compareRoots[n, 1]]},
    {Green, Point[compareRoots[n, Infinity]]}
  }
}, Axes -> True]
```

---

## Related

- [290-Theorem Connection Speculation](290-connection-speculation.md) - framework offsets hit 31% of critical integers
- [γ Framework](../2025-12-08-gamma-framework/README.md)
- [Squarical Geometry](../2025-12-08-squarical-geometry/README.md)
- [Gauss FFT and Hartley](../2025-12-11-gauss-fft-hartley/README.md)
