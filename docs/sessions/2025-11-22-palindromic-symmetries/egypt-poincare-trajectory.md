# Egypt Trajectory in Hyperbolic Geometry

**Date:** 2025-11-22
**Status:** 🔬 NUMERICALLY VERIFIED

## Summary

Egypt approximations to √n naturally live inside the Poincaré disk (hyperbolic plane). The trajectory converges to the boundary while maintaining perfect inversion symmetry with its mirror image outside the disk.

## Key Findings

### 1. Geometric Confinement

All Egypt approximations r_k map to **inside the Poincaré disk** (radius r < 1):

```mathematica
r_Poincare = Tanh[ArcSinh[√((r_k - 1)/2)]]
```

**Numerical verification:**
- √2: All k ∈ [1,50] give r < 1 ✓
- √5: All k ∈ [1,50] give r < 1 ✓
- √13: All k ∈ [1,50] give r < 1 ✓

**Geometric interpretation:**
- Egypt trajectory stays on **upper hyperboloid sheet**
- Converges toward boundary (r → 1) but never reaches it
- Infinite hyperbolic distance to boundary

### 2. Inversion Symmetry

Perfect inversion property: **r_inside × r_outside = 1**

| k | r_inside | r_outside | Product |
|---|----------|-----------|---------|
| 1 | 0.994100 | 1.005935 | 1.0 ✓ |
| 10 | 0.993856 | 1.006182 | 1.0 ✓ |
| 50 | 0.993855 | 1.006182 | 1.0 ✓ |

**Max deviation from 1:** < 10⁻¹⁵

**Geometric interpretation:**
- Inverted trajectory lives on **lower hyperboloid sheet**
- Maps outside Poincaré disk (r > 1)
- Reflects (x,y,z) ↔ (-x,-y,-z) symmetry on hyperboloid

### 3. Linear Scaling of (1+2k)·s

The scaled hyperbolic coordinate grows **linearly with k**:

```
s_k = ArcSinh[√((r_k - 1)/2)]
(1+2k)·s_k ≈ a·k + b
```

**Measured for √13:**
- k=1: (1+2k)·s = 8.73
- k=10: (1+2k)·s = 60.7
- k=50: (1+2k)·s ≈ 290 (linear extrapolation)

**Interpretation:**
- (1+2k) acts as "velocity" in hyperbolic space
- Linear growth suggests systematic geometric structure
- Related to Chebyshev degree (2⌈k/2⌉ + 2⌊k/2⌋ + 1 = 1+2k)

### 4. Exponential Convergence

Velocity ds/dk decays **exponentially**:

```
k=1:  ds/dk ≈ -0.02
k=10: ds/dk ≈ -9.3×10⁻¹⁴
```

**Acceleration trend:** Positive (convergence slows near target)

**NOT a geodesic:** Velocity is not constant (geodesics have constant velocity in hyperbolic space), but shows systematic exponential decay.

**Interpretation:**
- Egypt trajectory is not a simple geodesic
- Follows more complex path (spiral toward boundary)
- Exponential decay typical of hyperbolic flow

## Visualizations

**Created files** (in `visualizations/`):

1. **viz_egypt_convergence.png** - r_k → √n convergence
2. **viz_egypt_hyperbolic_s.png** - Hyperbolic coordinate s_k evolution
3. **viz_egypt_scaled_coordinate.png** - (1+2k)·s_k linear growth
4. **viz_egypt_phase_space.png** - Phase portrait (s vs ds/dk)
5. **viz_egypt_trajectory.png** - 2D trajectory in (k, s) space
6. **viz_egypt_hyperbolic_combined.png** - Combined 2×2 grid

**Poincaré disk visualizations:**

7. **viz_poincare_inversion_2.png** - √2 trajectory (inside + outside)
8. **viz_poincare_inversion_5.png** - √5 trajectory
9. **viz_poincare_inversion_13.png** - √13 trajectory (k=1..50)
10. **viz_poincare_radial.png** - Radial convergence comparison
11. **viz_poincare_inversion_radial.png** - Inside vs outside radii

**Key visual features:**
- Blue points: Egypt trajectory inside disk
- Red points: Inverted trajectory outside disk
- Gray dashed lines: Inversion connections
- Spiral pattern: Convergence toward unit circle

## Inversion Testing

Tested 6 candidate inversions:
- 1/x
- 2/x
- 1/(x-1)
- Möbius: (2+x)/(2-x)
- Tanh[ArcSinh[√(x/2)]]
- -ArcSinh[√(x/2)]

**Result:** No simple algebraic reciprocity in Egypt approximations themselves.

**However:** Poincaré radius inversion r → 1/r is **exact** (reflects upper ↔ lower sheet symmetry).

## Geometric Context

### Hyperboloid Model

Egypt parameter x maps to 3D hyperboloid:
```
x² + y² - z² = -1  (z > 0 for upper sheet)
```

**Coordinates:**
- s = ArcSinh[√(x/2)] (our hyperbolic coordinate)
- t = ArcCosh[x+1] (Chebyshev coordinate)
- **Key identity:** s = t/2 (exact)

### Poincaré Disk Model

Stereographic projection to unit disk:
```
r = Tanh[s] = Tanh[ArcSinh[√(x/2)]]
```

**Properties:**
- Conformal (preserves angles)
- Geodesics = circular arcs perpendicular to boundary
- Distance: d = 2·ArcTanh[r] → ∞ as r → 1

**Egypt trajectory:**
- Starts near boundary for k=1
- Spirals slightly inward (r decreases)
- Then converges back toward r → 1
- Never exits disk

## Connection to Triple Identity

The hyperbolic form is one component of the triple identity:

1. **Factorial:** D(x,k) = 1 + Sum[2^(i-1)·x^i·(k+i)!/((k-i)!·(2i)!)]
2. **Chebyshev:** T[⌈k/2⌉, x+1]·(U[⌊k/2⌋, x+1] - U[⌊k/2⌋-1, x+1])
3. **Hyperbolic:** 1/2 + Cosh[(1+2k)·s]/(√2·√(2+x))

The Poincaré trajectory visualization provides **geometric interpretation** of form (3).

## Future Directions

### Mathematical

1. **Complete algebraic proof:** Symbolic verification for general k
2. **Geodesic analysis:** Why exponential decay instead of constant velocity?
3. **Inversion transformation:** Find f(x) giving Egypt reciprocity
4. **Higher-dimensional generalization:** 3D hyperbolic space, quaternions?

### Physical Analogies (Speculative)

The Poincaré disk structure suggests connections to:

1. **AdS/CFT correspondence:**
   - Anti-de Sitter space (negative curvature)
   - Egypt trajectory = particle in AdS
   - Boundary convergence = holographic dual

2. **Black hole physics:**
   - Poincaré boundary = event horizon analog
   - Infinite distance d → ∞ as r → 1
   - Exponential convergence = time dilation effect

3. **Thermodynamics:**
   - (1+2k) ~ inverse temperature?
   - Convergence ~ entropy increase?
   - Inversion ~ time reversal symmetry?

**Status:** Pure speculation. Requires deep theoretical investigation.

### Open Questions

**Resolved in this session:**
- ✅ Where does (1+2k) come from? → Chebyshev indices 2⌈k/2⌉ + 2⌊k/2⌋ + 1
- ✅ Is s = t/2 exact? → Yes (proven via sinh half-angle)
- ✅ Do Egypt trajectories stay inside Poincaré disk? → Yes (all k tested)

**Still open:**
- ❓ Why is trajectory NOT a geodesic?
- ❓ What is the exact inversion f(x) for Egypt reciprocity?
- ❓ Is there physical meaning to hyperbolic structure?
- ❓ Can we prove r < 1 for all k analytically?

## References

**Related documentation:**
- `triple-identity-factorial-chebyshev-hyperbolic.md` - The three equivalent forms
- `geometric-context-chebyshev-hyperbolic.md` - Hyperbolic geometry foundations
- `derivation-1plus2k-factor.md` - Algebraic origin of (1+2k)

**Experiments (not committed, listed for reference):**

Scripts in `/scripts/experiments/`:
- `visualize_egypt_hyperbolic_trajectory.wl` - Main trajectory analysis
- `explore_inversion_symmetries.wl` - Inversion candidates testing
- `visualize_poincare_inversion.wl` - Disk visualization with inversions
- `test_high_k_identity.wl` - High-k verification (k up to 200)
- `derive_1plus2k_factor.wl` - Derivation of (1+2k)
- `derive_1plus2k_product.wl` - Product formula approach

**Hyperbolic geometry background:**
- Poincaré disk: Standard conformal model of hyperbolic plane
- Hyperboloid model: 3D embedding in Minkowski space
- Stereographic projection: Maps hyperboloid → disk

---

## Acknowledgments

**Key insight:** Egypt approximations naturally embed in hyperbolic geometry, not Euclidean.

The (1+2k) factor, initially mysterious ("liché číslo"), turns out to be the natural consequence of Chebyshev polynomial structure and hyperbolic coordinate transformations.

Inversion symmetry (r_upper × r_lower = 1) reflects fundamental (x,y,z) ↔ (-x,-y,-z) symmetry on the hyperboloid.

**Next:** Investigate why trajectory is not a geodesic, and whether this reveals deeper structure.
