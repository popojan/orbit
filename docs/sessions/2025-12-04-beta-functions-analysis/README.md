# Session: Two Beta Functions - Analysis and Disambiguation

**Date:** December 4, 2025
**Status:** Active investigation

## Motivation

During review of the hyperbolic-integration session (2025-12-03), we discovered that two different functions are both called `β(n)`:

1. **β_geom** from `CompletedLobeArea` (paclet)
2. **β_res** from hyperbolic-integration (residual construction)

This session documents the analysis and clarifies the relationship.

## The Two Functions

### β_geom (Geometric)

**Source:** `CompletedLobeAreaFourier` in Orbit paclet

$$\beta_{\text{geom}}(n) = \frac{n^2 \cos(\pi/n)}{4 - n^2}$$

**Properties:**
- Derived from Chebyshev lobe area geometry
- Poles at n = ±2
- Limit as n → ∞: **-1**
- β_geom(2) = -π/4 (L'Hôpital limit)

### β_res (Residual)

**Source:** hyperbolic-integration session, constructed for η(s) connection

$$\beta_{\text{res}}(n) = \frac{n - \cot(\pi/n)}{4n}$$

**Properties:**
- Constructed to have specific pole structure
- Poles at n = 1/k for all k ∈ ℤ \ {0}
- Limit as n → ∞: **(π-1)/(4π) ≈ 0.1704**
- β_res(2) = 1/4

### Numerical Comparison

| n | β_geom | β_res | Ratio |
|---|--------|-------|-------|
| 3 | -0.900 | +0.202 | -4.46 |
| 5 | -0.963 | +0.181 | -5.32 |
| 10 | -0.991 | +0.173 | -5.72 |
| 100 | -0.9999 | +0.1704 | -5.87 |
| ∞ | -1 | (π-1)/(4π) | -4π/(π-1) |

**Verification:** See `scripts/compare_betas.wl`

## Key Finding: β Cancels in n^{-s} Identity

The identity from eta-identity session:

$$n^{-s} = \frac{B(n, k_s) - 1}{\beta(n)} + \frac{in}{2\pi\beta(n)} \cdot \frac{\partial B}{\partial k}\bigg|_{k_s}$$

**Crucial observation:** β(n) cancels out!

- Term 1: `(B-1)/β = β·cos(...)/β = cos(...)`
- Term 2: `i·n/(2πβ)·∂B/∂k = i·n/(2πβ)·(-β·2π/n·sin(...)) = -i·sin(...)`

**Therefore:** The n^{-s} identity works for ANY β(n)!

**Verification:** See `scripts/identity_both_betas.wl`

## What Depends on Which β

| Property | Depends on β? | β_geom | β_res |
|----------|---------------|--------|-------|
| Form B = 1 + β·cos(...) | Yes (definition) | ✓ | ✓ |
| Identity n^{-s} = f(B, ∂B/∂k) | **NO** (β cancels) | ✓ | ✓ |
| k-integral ∫₀ⁿ B dk = n | **NO** | ✓ | ✓ |
| n-integral ∮ B dn → η(s) | **YES** (poles matter) | ❌ | ✓ |

**Verification:** See `scripts/k_integral_test.wl` and `scripts/n_integral_test.wl`

## Why the Difference for Contour Integration?

### β_geom pole structure
- Poles at n = ±2 (from denominator 4 - n²)
- Residue at n = 2: **0** (removable, cos(π/2) = 0 in numerator)
- Does NOT produce alternating series

### β_res pole structure
- Poles at n = 1/k where cot(kπ) diverges
- Residue at n = 1/k: **1/(4πk)**
- Combined with cos factor: Res[B, n=1/k] = **(-1)^k/(4πk)**
- Sum gives: Σ (-1)^k/(4πk) = **-η(1)/(4π)**

**Verification:** See `scripts/residue_analysis.wl`

## Origin of β_res

In hyperbolic-integration, β_res appears via Mittag-Leffler reconstruction:

$$\beta(n) = \sum_{k=1}^{N-1} \frac{1/(4\pi k)}{n - 1/k} + h_N(n)$$

This is constructing a function FROM its desired poles and residues.
The closed form `(n - cot(π/n))/(4n)` was found to match this structure.

**Key insight:** β_res was **constructed** to have poles at n = 1/k,
not derived from lobe area geometry.

## The Uniqueness Theorem (eta-identity session)

The session proved: **Cosine is FORCED** by the requirement to extract n^{-s}.

But it never asked: **Is β forced?**

Answer: **NO** - β can be arbitrary for the n^{-s} identity (it cancels).
BUT: β matters for contour integration over n.

## Exact Relationship Between β_geom and β_res

### Parameterization by θ = π/n

Both functions can be written more elegantly in terms of θ:

$$\beta_{\text{geom}}(\theta) = \frac{\pi^2 \cos\theta}{4\theta^2 - \pi^2}$$

$$\beta_{\text{res}}(\theta) = \frac{1}{4} - \frac{\theta \cot\theta}{4\pi} = \frac{\pi - \theta\cot\theta}{4\pi}$$

### Exact Transformation

**Theorem:** The two β functions are related by:

$$\beta_{\text{res}} = \frac{1}{4} + \beta_{\text{geom}} \cdot \frac{\theta(\pi^2 - 4\theta^2)}{4\pi^3 \sin\theta}$$

where θ = π/n.

Equivalently, defining the **multiplier function**:

$$m(\theta) = \frac{\theta(\pi^2 - 4\theta^2)}{4\pi^3 \sin\theta}$$

we have:

$$\beta_{\text{res}} - \frac{1}{4} = \beta_{\text{geom}} \cdot m(\theta)$$

**Verification:** See `scripts/exact_relationship.wl`

### Why θ Cannot Be Eliminated

The relationship involves θ explicitly because:
- β_res ~ θ·cot(θ) (linear in cot)
- β_geom ~ cos(θ)/θ² (rational in θ², trig in cos)

These are **algebraically incompatible** - one cannot be expressed as a pure function of the other.

### Approximate Polynomial Relationship

For practical purposes, in the range n ≥ 3 (β_geom ∈ [-1, -0.9]):

$$\beta_{\text{res}} \approx 2.278 + 6.709g + 8.632g^2 + 5.286g^3 + 1.256g^4$$

where g = β_geom. Maximum error ≈ 10⁻⁶.

**Verification:** See `scripts/polynomial_fit.wl`

## Can the Two β Be Unified?

### The Question

Given the user's symmetrized trigonometric functions (see Appendix), can we find a **single function C** such that substituting it for sin/cos makes β_geom = β_res?

### The Constraint

Setting β_geom = β_res with abstract C[u] replacing cos and C[-u] replacing sin leads to:

$$\frac{C[u]}{C[-u]} = R(u)$$

where u = 5/4 - 1/n and R(u) is the rational function:

$$R(u) = \frac{4(4u-3)(4u-7)}{169 - 284u + 240u^2 - 64u^3}$$

### The Obstruction

**Theorem:** No function C can unify the two β functions.

**Proof:** For any function C, we have:

$$\frac{C[u]}{C[-u]} \cdot \frac{C[-u]}{C[u]} = 1$$

But R(u) · R(-u) ≠ 1 (it's a non-trivial rational function of u).

Therefore, no C exists satisfying C[u]/C[-u] = R(u). □

### Geometric Interpretation

- Zeros of R(u) at u = 3/4 and u = 7/4 correspond to n = ±2 (poles of β_geom)
- This reflects the 0/0 form at n = 2: cos(π/2) = 0 in numerator
- The two β have **topologically incompatible** pole structures

**Verification:** See `scripts/unification_obstruction.wl`

## Open Questions

1. ~~**Is there a natural relationship between β_geom and β_res?**~~
   - ✅ **ANSWERED:** Yes, via exact transformation with multiplier m(θ)

2. **Which β is "correct" for the B(n,k) framework?**
   - β_geom: natural from geometry, but no η(s) connection via contours
   - β_res: artificial construction, but produces η(s)

3. **Can the same η(s) result be achieved with β_geom differently?**
   - Perhaps summing over n differently?
   - Or using a different contour?

4. **Why was the switch not noticed?**
   - β cancels in n^{-s} identity → both work there
   - Only when doing contour integration does it matter

## Implications for Documentation

The hyperbolic-integration session implicitly switches from β_geom to β_res
without documenting the change. This is not necessarily an error - both are
valid functions - but the presentation suggests they are the same.

**Recommendation:** Add clarifying note to hyperbolic-integration explaining
that β_res is a different function constructed for specific pole structure.

## Files

- `README.md` - this file
- `scripts/compare_betas.wl` - numerical comparison of both β functions
- `scripts/identity_both_betas.wl` - verify n^{-s} identity works for both
- `scripts/k_integral_test.wl` - verify k-integral works for both
- `scripts/n_integral_test.wl` - verify only β_res gives η(s) via residues
- `scripts/residue_analysis.wl` - detailed residue computation
- `scripts/exact_relationship.wl` - exact transformation β_res = f(β_geom, θ)
- `scripts/polynomial_fit.wl` - approximate polynomial β_res ≈ P(β_geom)
- `scripts/unification_obstruction.wl` - proof that no circ can unify both β

## References

- [2025-12-02-chebyshev-complex-analysis](../2025-12-02-chebyshev-complex-analysis/) - original β_geom definition
- [2025-12-02-eta-identity](../2025-12-02-eta-identity/) - n^{-s} identity, β cancellation
- [2025-12-03-hyperbolic-integration](../2025-12-03-hyperbolic-integration/) - introduces β_res
- Orbit paclet: `CompletedLobeAreaFourier` function

---

## Affine Transformation Between B_geom and B_res

### Discovery

Both B functions have the form `B = 1 + β·cos((2k-1)π/n)`, differing only in β. This means:

$$B_{\text{res}} - 1 = r(n) \cdot (B_{\text{geom}} - 1)$$

where the **transformation ratio** is:

$$r(n) = \frac{\beta_{\text{res}}}{\beta_{\text{geom}}}$$

### Geometric Interpretation

- Both curves oscillate around **B = 1**
- B_res is a **scaled reflection** of B_geom around B = 1
- Scale factor |r| ≈ 0.17 (compression)
- Negative r means reflection (flip)

### Inverse Problem: Geometric Realization

**Question:** Can we transform the actual Chebyshev curve to produce B_res lobe areas?

**Answer:** Not trivially. The algebraic transformation applies to scalar areas, but finding a spatial transformation T: ℝ² → ℝ² that achieves this is a **non-conformal mapping problem**.

- **Conformal mappings** preserve angles and scale areas uniformly locally → won't work
- **Simple amplitude scaling** g(x) = a + b·f(x) doesn't give the right area transformation
- **Required:** Non-linear envelope modulation g(x) = f(x)·envelope(x) with envelope chosen to satisfy integral constraints

This is an **inverse problem** with infinitely many solutions, none as elegant as the algebraic transformation.

### Wolfram Code

```mathematica
(* Transformation ratio *)
r[n_] := BetaResidual[n] / BetaGeometric[n]

(* Transform B_geom to B_res *)
BGeomToBRes[n_, bGeom_] := (1 - r[n]) + r[n] * bGeom

(* Equivalently: BRes - 1 = r[n] * (BGeom - 1) *)
```

## Geometric Comparison: A_geom vs A_res Lobe Curves

### The Question

What happens if we use β_res instead of β_geom in the lobe area formula?

$$A(n,k) = \frac{B(n,k)}{n} = \frac{1 + \beta(n) \cos((2k-1)\pi/n)}{n}$$

### Key Discovery: Inverted Curves

The two curves are **nearly mirror images** around the uniform baseline 1/n:

| Property | A_geom (Chebyshev) | A_res (Residual) |
|----------|-------------------|------------------|
| β sign | **NEGATIVE** (-0.98) | **POSITIVE** (+0.18) |
| Edge lobes (k=1, n) | Near zero (0.017) | Largest (0.165) |
| Center lobes (k≈n/2) | Largest (0.28) | Smallest (0.12) |
| Distribution | Strongly non-uniform | Nearly flat |
| Sum Σ A(n,k) | = 1 ✓ | = 1 ✓ |

**Both curves sum to 1** but have opposite structure!

### Exact Intersection at 1/n

**Theorem:** Both curves intersect at exactly B = 1 (equivalently A = 1/n).

**Proof:**
- A_geom = 1/n ⟺ 1 + β_geom·cos(...) = 1 ⟺ cos((2k-1)π/n) = 0
- A_res = 1/n ⟺ 1 + β_res·cos(...) = 1 ⟺ cos((2k-1)π/n) = 0

Same condition! The curves cross where the cosine term vanishes.

For n = 7: crossing at k = 2.25 and k = 5.75 (symmetric).

### B(n,x) as Linear Function

When viewed as B = 1 + β·x where x = cos((2k-1)π/n):

- B_geom(x) = 1 - 0.98x (decreasing, steep)
- B_res(x) = 1 + 0.18x (increasing, gentle)

Both lines pass through (0, 1).

### Physical Interpretation

- **A_geom**: Represents actual Chebyshev lobe areas (tiny at edges, large in center)
- **A_res**: Artificial construction that does NOT represent geometric reality

The negative β_geom arises naturally from Chebyshev geometry:
- Numerator: cos(π/n) > 0
- Denominator: (4 - n²) < 0 for n > 2
- Result: β_geom < 0

### Visualizations

- `lobe_comparison_n7.png` - A_geom vs A_res for n=7
- `lobe_comparison_n20.png` - A_geom vs A_res for n=20
- `B_vs_x_linear.png` - B as linear function of x
- `B_vs_k.png` - B as function of lobe index k

## Appendix: Symmetrized Trigonometric Functions

For future reference, these are the user's symmetrized sin/cos definitions based on a single `circ` function:

```mathematica
(* Core circ function - sin and cos unified *)
circ[t_] := 1 - 2 Sin[1/2 π (3/4 + t)]^2

(* Alternative representations *)
circt[t_] := Sqrt[2] (1 - 2 Sin[1/2 π (3/4 + t/π)]^2)
circg[t_] := -(Cos[π t]/Sqrt[2] + Sin[π t]/Sqrt[2])

(* Taylor series versions *)
circs[t_, n_] := Sum[
  ((1/2 + I/2) I^(1 + k) (1 - I (-1)^(1 + k))) / Gamma[1 + k] π^k / Sqrt[2] t^k,
  {k, 0, n}
]

circts[t_, n_] := Sum[
  ((1/2 + I/2) I^(1 + k) (1 - I (-1)^(1 + k))) / Gamma[1 + k] t^k,
  {k, 0, n}
]

(* Derived sin/cos via circ *)
sino[t_] := circ[t]           (* = Sin[π t + 5π/4] *)
coso[t_] := -circ[-t]         (* = -Cos[-(π t + 5π/4)] *)

(* Standard sin/cos reconstructed from circ *)
sin[t_] := circ[(t - π 5/4)/π]
cos[t_] := circ[-((t - π 5/4)/π)]
```

### Key Properties

1. **Unification:** Both sin and cos are expressed via a single function `circ`
2. **Symmetry:** `sin[t] = circ[u]` and `cos[t] = circ[-u]` for appropriate u
3. **Phase shift:** The 5π/4 offset places the "origin" at a symmetric point
4. **Verification:** `sin[t]` and `cos[t]` match standard `Sin[t]` and `Cos[t]` exactly

### Application to β Unification (Negative Result)

The exploration in this session attempted to find a modified `circ` function that would make β_geom = β_res. The constraint analysis showed:

- For β equality, we would need: `C[u]/C[-u] = R(u)`
- But `R(u) · R(-u) ≠ 1` (consistency requirement fails)
- **Conclusion:** No such `circ` modification exists

This proves the two β functions are **fundamentally different** and cannot be unified by any symmetric sin/cos deformation.
