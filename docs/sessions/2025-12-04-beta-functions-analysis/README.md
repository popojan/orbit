# Session: Two Beta Functions - Analysis and Disambiguation

**Date:** December 4, 2025
**Status:** Active investigation

---

## Main Result: A New Trigonometric-Arithmetic Identity

**Theorem (December 4, 2025):**

For any odd prime p:

$$\sum_{k=1}^{p-1} \text{sign}\left(\cos\frac{(2k-1)\pi}{p}\right) = -(1 + (-1)^{(p-1)/2})$$

**Equivalently:**
$$A(p) = \begin{cases} -2 & \text{if } p \equiv 1 \pmod{4} \\ 0 & \text{if } p \equiv 3 \pmod{4} \end{cases}$$

**Significance:**
- Left side: purely trigonometric (sign of cosines)
- Right side: purely arithmetic (depends only on p mod 4)
- **Connection:** The mod 4 condition is equivalent to "-1 is a quadratic residue mod p"

**Origin:** This arose from studying Chebyshev polygon lobe areas B(n,k) = 1 + β·cos((2k-1)π/n).

**Status:** ✅ **PROVEN** — see [rigorous proof](main-theorem-proof.md)

**Related results:**
- [Algebraic proof of complementarity with Aladov (1896)](complementarity-proof.md)
- [Historical context: Aladov and Russian tradition](historical-context.md)

---

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

Both lines pass through (x=0, B=1) in this abstract (x, B) space.
Note: x here is the **phase parameter** cos(θ), not the geometric x-coordinate of a lobe.

### Physical Interpretation

- **A_geom**: Represents actual Chebyshev lobe areas
  - Edge lobes (k=1, k=n; geometrically near x = ±1): **tiny** areas
  - Center lobes (k ≈ n/2; geometrically near x = 0): **largest** areas
  - "Fair" lobes (B=1): **average** area, at intermediate geometric positions
- **A_res**: Artificial construction that does NOT represent geometric reality

The negative β_geom arises naturally from Chebyshev geometry:
- Numerator: cos(π/n) > 0
- Denominator: (4 - n²) < 0 for n > 2
- Result: β_geom < 0

### Visualizations

- `figures/lobe_comparison_n7.png` - A_geom vs A_res for n=7
- `figures/lobe_comparison_n20.png` - A_geom vs A_res for n=20
- `figures/B_vs_x_linear.png` - B as linear function of x
- `figures/B_vs_k.png` - B as function of lobe index k

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

---

## Fixed Point Analysis: B(n,k) = 1

### Motivation

The affine transformation between B_geom and B_res has a **fixed point** at B = 1:

```mathematica
Solve[BResToBGeom[n, x] == BGeomToBRes[n, x], x]
(* {{x -> 1}} *)
```

At B = 1, both representations are identical — no transformation needed.

### Derivation: Where Does B = 1 Occur?

**Starting point:**
$$B(n,k) = 1 + \beta \cdot \cos\left(\frac{(2k-1)\pi}{n}\right)$$

**Condition B = 1:**
$$\beta \cdot \cos\left(\frac{(2k-1)\pi}{n}\right) = 0$$

Since β ≠ 0 for n > 2:
$$\cos\left(\frac{(2k-1)\pi}{n}\right) = 0$$

**Solving cos(θ) = 0:**
$$\theta = \frac{\pi}{2} + m\pi, \quad m \in \mathbb{Z}$$

**Substituting θ = (2k-1)π/n:**
$$\frac{(2k-1)\pi}{n} = \frac{\pi}{2} + m\pi$$

$$\frac{2k-1}{n} = \frac{1}{2} + m$$

$$2k - 1 = \frac{n}{2} + mn$$

$$k = \frac{n + 2 + 2mn}{4}$$

### Result: Crossing Points

For k ∈ [1, n], two solutions exist:

$$k_1(n) = \frac{n + 2}{4} \quad (m = 0)$$

$$k_2(n) = \frac{3n + 2}{4} \quad (m = 1)$$

### Properties

| Property | Value |
|----------|-------|
| Symmetry | k₁ + k₂ = n + 1 (symmetric around center) |
| Integer k | Only when n ≡ 2 (mod 4) |
| Examples | n=6: k∈{2,5}, n=10: k∈{3,8}, n=14: k∈{4,11} |

### Geometric Interpretation

**Important clarification:** The parameter θ(k) = (2k-1)π/n in the formula is a **phase parameter**, NOT the geometric x-coordinate of lobe k on the Chebyshev curve.

When θ(k) = π/2 or 3π/2, we have cos(θ) = 0, so B = 1. But this does **not** mean lobe k is geometrically located at x = 0.

**Example for n = 10:**
- "Fair" lobes k = 3, 8 have B = 1
- But geometrically, lobe 3 is at x ∈ [-0.81, -0.59], lobe 8 is at x ∈ [0.59, 0.81]
- Lobes at x ≈ 0 (lobes 5, 6) have B ≈ 1.94 (the largest!)

The cos((2k-1)π/n) factor modulates how much lobe k deviates from the baseline B = 1, but its value is determined by the lobe INDEX k, not its geometric position.

### Why This Matters

1. **Representation-independent:** At B = 1, the choice of β is irrelevant
2. **Pivot point:** Both B_geom and B_res oscillate around this common baseline
3. **Normalization anchor:** The value B = 1 corresponds to uniform lobe area 1/n

### Special Case: n ≡ 2 (mod 4)

**When do actual lobes have B = 1 exactly?**

The crossing points k₁ = (n+2)/4 and k₂ = (3n+2)/4 are integers only when:
- (n+2) is divisible by 4
- This happens when n ≡ 2 (mod 4)

**Examples:**

| n | k₁ = (n+2)/4 | k₂ = (3n+2)/4 | Lobe positions |
|---|--------------|---------------|----------------|
| 6 | 2 | 5 | x ∈ [-0.87, -0.5] and [0.5, 0.87] |
| 10 | 3 | 8 | x ∈ [-0.81, -0.59] and [0.59, 0.81] |
| 14 | 4 | 11 | x ∈ [-0.78, -0.62] and [0.62, 0.78] |

**For n NOT ≡ 2 (mod 4):** k₁, k₂ are non-integers, so no actual lobe has B = 1 exactly. The "fair" point exists only as interpolation between adjacent lobes.

**Key insight:** These "fair" lobes are at **intermediate geometric positions** — not at the edges (smallest lobes) nor at the center (largest lobes).

### Fair Lobes: Position and Number-Theoretic Properties

**Position within the lobe sequence:**

Fair lobes are located at the **quartile positions**:
- k₁/n = (n+2)/(4n) → **1/4** as n → ∞
- k₂/n = (3n+2)/(4n) → **3/4** as n → ∞

This means fair lobes **separate** the three regions:
```
Lobes 1 to k₁-1:     cos > 0 → B < 1 (small, edge lobes)
Lobe k₁:             cos = 0 → B = 1 (fair, first quartile)
Lobes k₁+1 to k₂-1:  cos < 0 → B > 1 (large, central lobes)
Lobe k₂:             cos = 0 → B = 1 (fair, third quartile)
Lobes k₂+1 to n:     cos > 0 → B < 1 (small, edge lobes)
```

**Critical observation: Fair lobes vs primes**

| n mod 4 | k₁, k₂ integers? | Examples | Primality |
|---------|------------------|----------|-----------|
| 0 | NO | n = 4, 8, 12, ... | Composite |
| 1 | NO | n = 5, 9, 13, 17, ... | **Includes primes** |
| 2 | **YES** | n = 2, 6, 10, 14, ... | Composite (except n=2) |
| 3 | NO | n = 3, 7, 11, 19, ... | **Includes primes** |

**Key result:**
- **For odd primes p:** Fair lobes do NOT exist (k₁, k₂ are non-integers)
- **For n ≡ 2 (mod 4):** Fair lobes exist, but n is composite (except n=2)

This explains why the sign asymmetry theorem A(p) = ±2 for primes involves an **imbalance** — there are no exact B = 1 lobes to provide a neutral boundary! The "fair point" falls between two adjacent lobes.

### Fair Lobes: Primitive vs Inherited Classification

**Question:** Are fair lobes primitive (gcd(k,n) = 1) or inherited (gcd(k,n) > 1)?

**Answer:** Fair lobes always form a **mixed pair** — one primitive, one inherited!

**Analysis for n = 4m + 2:**

| m | n | k₁ = m+1 | k₂ = 3m+2 | Pattern |
|---|---|----------|-----------|---------|
| 1 (odd) | 6 | 2 (even→I) | 5 (odd→P) | I/P |
| 2 (even) | 10 | 3 (odd→P) | 8 (even→I) | P/I |
| 3 (odd) | 14 | 4 (even→I) | 11 (odd→P) | I/P |
| 4 (even) | 18 | 5 (odd→P) | 14 (even→I) | P/I |
| 5 (odd) | 22 | 6 (even→I) | 17 (odd→P) | I/P |

**Algebraic explanation:**

For n = 4m + 2 = 2(2m+1) where (2m+1) is odd:
- k₁ = m + 1, k₂ = 3m + 2
- When m is odd: k₁ is even (shares factor 2 with n) → **inherited**
- When m is even: k₁ is odd (coprime with n) → **primitive**
- k₂ has opposite parity to k₁

**Key insight:** Since n = 2·(odd), the factor 2 is the only common factor possible. One of {k₁, k₂} is even (inherited), the other is odd (primitive).

**Consequence:**
- Fair lobes are NOT purely inherited (under INDEX definition)
- One fair lobe always participates in primitive sums from primitive-lobe-signs theorems
- The primitive fair lobe contributes B = 1 to ∑_{gcd(k,n)=1} B(n,k)

### Important: Two Different "Primitive" Definitions!

**Warning:** Two sessions use DIFFERENT definitions of "primitive lobe":

| Session | Definition | Condition | #Primitive |
|---------|------------|-----------|------------|
| **primitive-lobe-signs** | INDEX | gcd(k, n) = 1 | = φ(n) |
| **chebyshev-primality** | BOTH | gcd(k-1, n)=1 AND gcd(k, n)=1 | < φ(n) |

**Example for n = 15:**
- INDEX definition: 8 primitive lobes (= φ(15))
- BOTH definition: 3 primitive lobes

**Why BOTH is stricter:** Requires BOTH boundary indices to be coprime to n, not just the lobe index.

**Why this matters for fair lobes:**
- Under INDEX: Fair lobe k=3 (for n=10) IS primitive (gcd(3,10)=1)
- Under BOTH: Fair lobe k=3 is NOT primitive (gcd(2,10)=2 ≠ 1)

**Key result from chebyshev-primality:** The BOTH definition is the **unique non-trivial choice** — only AND (both boundaries) gives non-zero sign sum. LEFT-only, RIGHT-only, and NEITHER all sum to zero.

See: `docs/sessions/2025-11-28-chebyshev-primality/README.md` section "Why Primitive Pair is the Only Non-Trivial Definition"

---

## Open Directions

### Direction 1: Continuous Extension

What if k is not an integer? B(n, k) as a continuous function of k:
- Physical interpretation of fractional lobes?
- Connection to continuous Fourier transform?

### Direction 2: Fourier Interpretation

B = 1 is the "DC component" (zero frequency). The β·cos term is the fundamental mode.
- Higher harmonics?
- Spectral decomposition of lobe areas?

### Direction 3: Is There a Deeper Connection?

**Observation:** At B = 1, both β functions give the same result:
- B_geom = 1 + β_geom · 0 = 1
- B_res = 1 + β_res · 0 = 1

**Adversarial check:** This is **trivially true** — anything times zero equals zero. The equality `1 + A·0 = 1 + B·0` holds for ANY A, B and says nothing about a relationship between them.

**What would be meaningful:**
- A non-trivial relationship between β_geom and β_res at points where cos ≠ 0
- A deeper reason why the formula has the form `B = 1 + β·cos(θ)` with baseline exactly 1
- Understanding why β_res (constructed for η(s) poles) produces valid lobe areas at all

**Current status:** The "unification at B = 1" is a **structural coincidence** of the formula, not evidence of a deep connection. The η(s) link via β_res remains unexplained.

### Final Assessment: Fair Lobes Do NOT Connect β_geom to η(s)

**Why this path fails:**

1. **Fair lobes exist only for composite n:** n ≡ 2 (mod 4) means n is even (except n=2)
2. **Under BOTH definition, all lobes are inherited:** For even n, consecutive integers always share factor 2 with n
3. **The B = 1 agreement is trivial:** Both β_geom·cos(θ) and β_res·cos(θ) equal zero when cos(θ) = 0
4. **η(s) poles come from β_res structure:** The poles at n = 1/k arise from cot(π/n) in β_res, unrelated to fair lobes

**Conclusion:** The fair lobe analysis reveals interesting structural properties of B(n,k), but does NOT provide a geometric justification for β_res or the Dirichlet eta construction. The connection between Chebyshev geometry (β_geom) and η(s) (β_res) remains an open question.

---

## Polygon Hierarchy: How 2p-Polygon Splits p-Polygon Lobes

### Setup: Two Related Polygons

For prime p, consider TWO Chebyshev polygons:
- **p-polygon:** has p lobes, roots at cos(jπ/p) for j = 0, 1, ..., p
- **2p-polygon:** has 2p lobes, roots at cos(jπ/(2p)) for j = 0, 1, ..., 2p

**Key observation:** The 2p-polygon roots CONTAIN all p-polygon roots!
- Even indices of 2p-roots = p-roots
- Odd indices of 2p-roots = NEW "interpolated" roots

### Geometric Meaning: Each p-Lobe Splits into Two 2p-Lobes

**Example for p = 5:**

```
p-roots (boundaries): cos(jπ/5) for j = 0,...,5
  = [1.0, 0.809, 0.309, -0.309, -0.809, -1.0]

2p-roots (boundaries): cos(jπ/10) for j = 0,...,10
  = [1.0, 0.951, 0.809, 0.588, 0.309, 0, -0.309, -0.588, -0.809, -0.951, -1.0]

Observe: 2p-roots at EVEN indices = p-roots
         2p-roots at ODD indices = NEW interpolated roots
```

**How p-lobe 2 splits:**
- p-lobe 2 spans [p-root 1, p-root 2] = [0.809, 0.309] on x-axis
- 2p-polygon inserts NEW root at x = 0.588 = cos(3π/10)
- Result: two 2p-lobes
  - 2p-lobe 3: [0.809, 0.588]
  - 2p-lobe 4: [0.588, 0.309]

**Important distinction:** The "fair" condition B = 1 comes from the ARGUMENT (2k-1)π/(2p) = π/2 in the Fourier formula, NOT from geometric x-position = 0. For k = 3: argument = 5π/10 = π/2, so cos = 0, hence B = 1.

### Where Does the Fair Lobe Come From?

The fair lobe (B = 1) occurs when cos((2k-1)π/(2p)) = 0, i.e., when the argument equals π/2.

For 2p-lobe k = 2j-1 (first half of p-lobe j):
- Argument = (4j-3)π/(2p)
- Fair when 4j - 3 = p, i.e., j = (p+3)/4
- This is an integer only when **p ≡ 1 (mod 4)**

For 2p-lobe k = 2j (second half of p-lobe j):
- Argument = (4j-1)π/(2p)
- Fair when 4j - 1 = p, i.e., j = (p+1)/4
- This is an integer only when **p ≡ 3 (mod 4)**

### The Dichotomy Theorem

**Theorem:** For n = 2p where p is an odd prime:

| p mod 4 | Host p-lobe j | Which half is FAIR | Host lobe size |
|---------|---------------|-------------------|----------------|
| **1** | j = (p+3)/4 | FIRST (k = 2j-1) | **LARGE** (B > 1) |
| **3** | j = (p+1)/4 | SECOND (k = 2j) | **SMALL** (B < 1) |

**Geometric interpretation:**
- **p ≡ 1 (mod 4):** Fair point (B=1) arises from splitting a LARGE p-lobe
- **p ≡ 3 (mod 4):** Fair point arises from splitting a SMALL p-lobe

### Numerical Verification

```
p    mod4   host j   B(p,j)    FAIR half   2p-lobe k
--   ----   ------   ------    ---------   ---------
5    1      2        1.298     FIRST       3
7    3      2        0.782     SECOND      4
13   1      4        1.120     FIRST       7
17   1      5        1.092     FIRST       9
19   3      5        0.918     SECOND      10
```

### Significance

This provides a **geometric interpretation of the mod 4 dichotomy** for primes:
- The dichotomy p ≡ 1 vs 3 (mod 4) manifests in polygon hierarchy
- It determines whether the "fair point" splits a large or small lobe
- This connects to the sign asymmetry theorem A(p) = ±2

However, this still does NOT directly connect to η(s), as the fair lobes only exist for composite n = 2p, not for primes themselves.

### Direction 4: Inverse Problem

Given B = 1 constraint, what curves (beyond Chebyshev) satisfy it?
- Family of curves through fixed crossing points
- Uniqueness under additional constraints

---

## Appendix: Three β Functions (Notation Clarification)

### Context

During review of the primitive-lobe-signs session (2025-12-03), we found a **third** β function being used, creating potential confusion.

### The Three Functions

| Function | Formula | Limit n→∞ | Origin |
|----------|---------|-----------|--------|
| β_geom | n²cos(π/n)/(4-n²) | **-1** | Derived from Chebyshev lobe geometry |
| β_res | (n - cot(π/n))/(4n) | **(π-1)/(4π) ≈ 0.170** | Constructed for η(s) poles |
| β_signs | (sin(π/n) - (π/n)cos(π/n))/(2sin³(π/n)) | **1/6 ≈ 0.167** | Ad hoc choice (see analysis below) |

**Simplified form of β_signs:**
$$\beta_{\text{signs}} = \frac{(n - \pi\cot(\pi/n)) \csc^2(\pi/n)}{2n}$$

Compare with β_res = (n - cot(π/n))/(4n) — note the **π** factor in the cot argument differs.

### Common Properties

All three β functions share:
1. **Same form:** B(n,k) = 1 + β·cos((2k-1)π/n)
2. **Same normalization:** ∑_{k=1}^n B(n,k) = n (because ∑cos = 0)
3. **Primitive sum formula:** ∑_{gcd(k,n)=1} B(n,k) = φ(n) + β·μ(n)·cos(π/n)

### Key Finding: Formulas Work for ANY β

The primitive sum formula and other results from primitive-lobe-signs session are **not specific to β_signs**. They work for any β function.

**Verification (n = 15, μ(15) = 1):**
- With β_geom: ∑B_primitive = 7.026 ✓
- With β_signs: ∑B_primitive = 8.166 ✓

Both match their respective formula predictions.

### Why β_signs and Not β = 1?

Analysis reveals β_signs was likely chosen for specific properties:

1. **Positive sign required:** β > 0 ensures the sign asymmetry theorem gives A(p) = -2 for p ≡ 1 (mod 4).
   - With β_geom < 0: A(p) = +2 (opposite convention)
   - With any β > 0: A(p) = -2

2. **Bounded oscillation:** Limit 1/6 gives B ∈ [5/6, 7/6] as n → ∞
   - With β = 1: B ∈ [0, 2] (wider range)
   - With β = 1/6: Nice bounded variation around baseline

3. **Nice variance:** Var[B] = β²/2 → 1/72 in the limit

**But the specific formula is suspect:** The formula `(sin θ - θ cos θ)/(2 sin³ θ)` has no documented derivation. It could be:
- A convenient formula that happens to have limit 1/6
- Derived from some forgotten integral
- An error (a simpler formula like β = 1/6 would work equally well)

**Recommendation:** For future work, consider using β = 1/6 (constant) instead of β_signs. The theorems work identically, and it avoids the unexplained formula.

### Conclusion: Notation Coincidence

**β_signs is NOT uniquely determined** by the theorems in primitive-lobe-signs session. It was likely **chosen** for nice properties rather than **derived** from geometry.

The primitive-lobe-signs session uses B(n,k) notation but represents a different quantity than B_geom (actual lobe areas) or B_res (η(s) construction).

### Recommendation

When citing results from primitive-lobe-signs session, clarify which β is meant:
- Results about **structure** (Möbius, Gauss sums, Legendre symbols) → hold for any β
- Results about **specific values** (e.g., "variance = 1/72") → depend on β_signs with limit 1/6

### β-Dependence Classification (Key Insight)

**What depends on β and what doesn't?**

| Property | β-dependent? | Why |
|----------|--------------|-----|
| ∑B(n,k) = n | NO | ∑cos((2k-1)π/n) = 0 |
| B(n, k_fair) = 1 | NO | cos = 0 at fair lobes |
| Ratio fair/total = 2/n | NO | β cancels (both numerator and denominator β-independent) |
| Primitive sum formula structure | NO | ∑_{gcd}B = φ(n) + β·μ(n)·cos(π/n) works for any β |
| Sign asymmetry A(p) = ±2 | **SIGN of β only** | Sign of β determines which lobes are "large" |
| B(n,k) for specific k ≠ fair | YES | cos ≠ 0, so β·cos term matters |
| Actual geometric lobe areas | YES | Only β_geom gives correct values |

**Practical consequence:**
- Questions about **ratios** and **structural properties** → β is irrelevant
- Questions about **actual lobe sizes** → must use β_geom
- Questions about **which lobes are large/small** → only sign of β matters

**Example verification:**
```
n = 10, fair lobes k ∈ {3, 8}

β_geom = -0.991:  ∑B = 10, B_fair = 2, ratio = 0.2
β_res  =  0.173:  ∑B = 10, B_fair = 2, ratio = 0.2
β = 42.7:         ∑B = 10, B_fair = 2, ratio = 0.2
β = -1000:        ∑B = 10, B_fair = 2, ratio = 0.2

→ Ratio 2/n = 0.2 for ANY β (β cancels out)
```

---

## BOTH-Primitive Primality Test: Classical Result Rediscovery

### The Discovery Path

Starting from polygon hierarchy analysis, we asked: can Chebyshev structure provide non-binary primality scoring?

**BOTH-primitive count:** Number of k ∈ [1,n] where gcd(k-1, n) = 1 AND gcd(k, n) = 1

**Normalized score:**
$$\text{Score}(n) = \frac{\text{BOTH}(n)}{n - 2}$$

**Empirical finding:**
- All odd primes: Score = 1 exactly
- All odd composites: Score < 1
- Smooth gradation by factorization complexity

### Classical Formula (Known Result)

**This is a known result in number theory!**

$$\text{BOTH}(n) = n \cdot \prod_{p \mid n} \left(1 - \frac{2}{p}\right)$$

**Reference:** [MathOverflow: Consecutive integers coprime to a given number](https://mathoverflow.net/questions/412076/consecutive-integers-that-are-coprime-to-a-given-number)

Answer by **Noam D. Elkies** (Harvard):
> "For the first question it's n times the product of (p-2)/p over all prime factors of n
> (regardless of multiplicity). [...] These all fall quickly to the Chinese remainder theorem."

**Why it works:** For each prime p|n, exactly 2 residue classes mod p (namely 0 and -1)
cause either k or k+1 to be divisible by p. Hence factor (p-2)/p for each prime.

**Primality criterion follows immediately:**
- For prime p: BOTH(p) = p · (1 - 2/p) = **p - 2**
- For composite n: Product has multiple factors → BOTH(n) < n - 2

**Verification:**

| n | Type | BOTH(n) | Formula n·∏(1-2/p) | Match |
|---|------|---------|-------------------|-------|
| 7 | prime | 5 | 7·(5/7) = 5 | ✓ |
| 15 | 3×5 | 3 | 15·(1/3)·(3/5) = 3 | ✓ |
| 35 | 5×7 | 15 | 35·(3/5)·(5/7) = 15 | ✓ |
| 77 | 7×11 | 45 | 77·(5/7)·(9/11) = 45 | ✓ |

### What Does Chebyshev Visualization Add?

**Honest assessment:**

| Aspect | Added Value |
|--------|-------------|
| **Mathematical content** | ❌ Nothing new — classical NT result |
| **Computational power** | ❌ No improvement over direct formula |
| **Geometric intuition** | ✓ Visual interpretation of coprime pairs |
| **Pedagogical value** | ✓ "Primitive lobe = both boundaries coprime to n" |
| **Connection discovery** | ? Chebyshev ↔ coprime counting link (novelty unclear) |

**The Chebyshev framing is "syntactic sugar"** over known number theory.

### Potentially Novel Elements (To Be Falsified)

The following claims need verification against existing literature:

1. ~~**BOTH primality test:**~~ → ❌ **KNOWN** (Elkies, MathOverflow) — classical NT via CRT

2. **Explicit Chebyshev connection:** Is the link between T_{n+1}(x) - x·T_n(x) lobes and coprime consecutive pairs documented?

3. **Sign asymmetry theorem:** A(p) = ±2 if p≡1(mod 4), A(p) = 0 if p≡3(mod 4) (sign fixed by β) — is this known?

4. **Polygon hierarchy splitting:** The observation that 2p-polygon lobes split p-polygon lobes, with fair lobe position depending on p mod 4 — is this documented?

5. **β-function role:** The analysis showing β cancels in structural formulas but determines actual areas — is this perspective published?

**Status:** 🔬 UNDER INVESTIGATION — items 2-5 pending literature search

---

### Literature Search Progress (Dec 4, 2025)

#### Item 2: Chebyshev Connection — PARTIALLY KNOWN

**Known fact discovered:**
$$T_{n+1}(x) - x \cdot T_n(x) = -(1-x^2) \cdot U_{n-1}(x)$$

This is a **standard Chebyshev identity**. The "lobes" are zeros of U_{n-1}(x) plus boundary ±1.

**Sources checked:**
- [Chebyshev Polynomials and Primality Testing (Math.SE)](https://math.stackexchange.com/questions/109214/chebyshev-polynomials-and-primality-testing) — irreducibility criterion, NO coprime connection
- Rayes et al. 2005: "Factorization Properties of Chebyshev Polynomials" — GCD, divisibility, finite field factorization, NO coprime connection
- [Chebyshev Wikipedia](https://en.wikipedia.org/wiki/Chebyshev_polynomials) — standard properties
- [Brilliant.org Chebyshev](https://brilliant.org/wiki/chebyshev-polynomials-definition-and-properties/) — T_n, U_n identities

**Key observation:** Literature knows BOTH sides separately:
- Number theory: BOTH(n) = n·∏(1-2/p) (coprime consecutive pairs)
- Chebyshev theory: T_{n+1}-xT_n = -(1-x²)U_{n-1} (lobe polynomial)

**BUT: No reference found connecting these two!**

The "bridge" interpretation — that Chebyshev lobes geometrically encode coprime structure — appears **undocumented**.

**Intermediate verdict:** The individual components are known; the CONNECTION may be novel.

#### Item 3: Sign Asymmetry — RELATED RESULTS FOUND

**Search results (Dec 4, 2025):**

Several structurally related results found, but NOT our specific claim:

1. **Quadratic Excess E(p)** ([John D. Cook blog](https://www.johndcook.com/blog/2019/07/12/distribution-of-quadratic-residues/)):
   - p ≡ 1 (mod 4): E(p) = 0 (QRs symmetric around p/2)
   - p ≡ 3 (mod 4): E(p) > 0 (more QRs in first half)

2. **Sum of primitive roots for p ≡ 1 (mod 4)** ([Math.SE](https://math.stackexchange.com/questions/2730263)):
   - If g is primitive root, so is -g (when p ≡ 1 mod 4)
   - Therefore sum of primitive roots ≡ 0 (mod p)

3. **Sum of consecutive Legendre symbol products** ([Math.SE](https://math.stackexchange.com/questions/333704)):
   - $\sum_{a=1}^{p-2} \left(\frac{a(a+1)}{p}\right) = -1$
   - Related to our BOTH condition (consecutive coprimality)

**Key observation — REVERSED mod 4 structure:**

| Property | p ≡ 1 (mod 4) | p ≡ 3 (mod 4) |
|----------|---------------|---------------|
| Quadratic excess E(p) | = 0 (balanced) | > 0 (unbalanced) |
| **Our A(p)** | **= ±2** (unbalanced) | **= 0** (balanced) |

The mod 4 conditions are **complementary**! This suggests:
- Our sign asymmetry A(p) measures something **dual** to quadratic excess
- Both arise from -1 being QR iff p ≡ 1 (mod 4)
- The "reversal" may be due to cos((2k-1)π/p) vs QR counting

**Verdict:** No direct falsification. Related results exist but measure different quantities.

#### Item 4: Polygon Hierarchy — NO DIRECT REFERENCE

**Searched:**
- "Chebyshev polynomial n-gon lobe area splitting refinement" → No results
- [Wolfram Demonstrations: n-gon polynomials](https://demonstrations.wolfram.com/NGonPolynomials/) — shows T_n connection but no splitting analysis
- SIAM papers on domain splitting for Chebyshev interpolation — numerical analysis, not number theory

**Verdict:** The 2p-polygon splits p-polygon lobes observation appears **novel**.

#### Item 5: β-function Cancellation — NO ANALOG

**The observation:** β cancels in structural formulas (primitive sums, normalization) but determines actual lobe sizes.

**Searched:**
- Fourier coefficient cancellation in character sums → Not the same structure
- Amplitude vs phase in trigonometric sums → Too general

**Verdict:** This perspective on β appears **undocumented**.

---

### Related Known Results (Reference Points)

The following classical results are **structurally similar** but **not identical** to our claims.
Documented here as reference for future deeper search.

#### Ramanujan Sums (1918)

**Definition:**
$$c_q(n) = \sum_{\substack{k=1 \\ \gcd(k,q)=1}}^{q} e^{2\pi i k n / q} = \sum_{\substack{k=1 \\ \gcd(k,q)=1}}^{q} \cos\left(\frac{2\pi k n}{q}\right)$$

**Applications:**
- Fourier-like expansions of arithmetic functions (τ(n), φ(n), μ(n))
- Representation of numbers as sums of squares
- Vinogradov's theorem (odd numbers as sum of 3 primes)
- Modern: signal processing, denoising, DFT acceleration

**Key difference from our formula:**
| Aspect | Ramanujan | Our formula |
|--------|-----------|-------------|
| Argument | cos(2πkn/q) | cos((2k-1)π/n) |
| Variables | Two (k, n) | One effective (k/n ratio) |
| Sum over | gcd(k,q) = 1 | gcd(k,n)=1 AND gcd(k-1,n)=1 |

**Reference:** [MathWorld: Ramanujan's Sum](https://mathworld.wolfram.com/RamanujansSum.html)

#### Möbius Function as Sum of Primitive Roots of Unity

**Known theorem:**
$$\mu(n) = \sum_{\substack{k=1 \\ \gcd(k,n)=1}}^{n} e^{2\pi i k / n}$$

The Möbius function μ(n) equals the sum of primitive n-th roots of unity.

**Corollary (Gauss):** For prime p, sum of primitive roots mod p ≡ μ(p-1) (mod p).

**Key difference from our sign asymmetry:**
| Aspect | Known μ(n) result | Our A(p) = ±2 |
|--------|-------------------|---------------|
| Sum of | exp(2πik/n) | sign(cos((2k-1)π/n)) |
| Over | gcd(k,n) = 1 | BOTH-primitive (gcd(k,n)=gcd(k-1,n)=1) |
| Result | μ(n) ∈ {-1, 0, 1} | ±2 for primes |
| Depends on | Squarefreeness of n | p mod 4 |

**Reference:** [Math.SE: Möbius as sum of primitive roots](https://math.stackexchange.com/questions/1892410/the-m%C3%B6bius-function-is-the-sum-of-the-primitive-nth-roots-of-unity)

#### Gauss Sums and mod 4 Dichotomy

**Known:** Quadratic Gauss sum evaluation depends on k mod 4:
- k ≡ 0 (mod 4): (1+i)√k
- k ≡ 1 (mod 4): √k
- k ≡ 2 (mod 4): 0
- k ≡ 3 (mod 4): i√k

**Our polygon hierarchy** also shows mod 4 dependence (p ≡ 1 vs 3 determines which lobe splits).
Possible deep connection? Needs investigation.

**Reference:** [Wikipedia: Quadratic Gauss sum](https://en.wikipedia.org/wiki/Quadratic_Gauss_sum)

#### Quadratic Residue Sums and mod 4 (KEY FINDING)

**Known theorem:** The sum of quadratic residues vs nonresidues depends on p mod 4:

| p mod 4 | Sum(QR) vs Sum(QNR) | Reason |
|---------|---------------------|--------|
| p ≡ 1 (mod 4) | **Equal** (balanced) | -1 is QR, so negation preserves QR/QNR |
| p ≡ 3 (mod 4) | **Unequal** (QR < QNR in first half) | -1 is QNR, negation swaps QR ↔ QNR |

**Key insight:** -1 is quadratic residue mod p **iff** p ≡ 1 (mod 4).

**Our sign asymmetry A(p)** also depends on p mod 4!
- p ≡ 1 (mod 4): A(p) = **±2** (sign fixed by β choice)
- p ≡ 3 (mod 4): A(p) = **0**

**Possible deep connection:** Both phenomena arise from the same mod 4 structure of primes.
The sign of cos((2k-1)π/p) for primitive k may be related to quadratic character!

#### Aladov's Exact Formulas (1896) — HIGHLY RELEVANT

**Primary reference:** N. S. Aladov, "Sur la distribution des résidus quadratiques et non-quadratiques d'un nombre premier P dans la suite 1, 2, . . . , P − 1," (Russian) *Mat. Sb.* **18** (1896), 61–75. [URL](http://mi.mathnet.ru/eng/msb/v18/i1/p61)

**Expository source:** Keith Conrad, ["Quadratic Residue Patterns Modulo a Prime"](https://kconrad.math.uconn.edu/blurbs/ugradnumthy/QuadraticResiduePatterns.pdf) (contains modern exposition and historical overview)

Aladov (1896) found **exact formulas** for consecutive QR patterns depending on p mod 4:

| p mod 4 | N_p(+,+) | N_p(+,-) | N_p(-,+) | N_p(-,-) |
|---------|----------|----------|----------|----------|
| **1** | (p-5)/4 | (p-1)/4 | (p-1)/4 | (p-1)/4 |
| **3** | (p-3)/4 | **(p+1)/4** | (p-3)/4 | (p-3)/4 |

**Key observations:**
- For p ≡ 1 (mod 4): Pattern (+,+) is **under-represented** by exactly 1
- For p ≡ 3 (mod 4): Pattern (+,-) is **over-represented** by exactly 1
- The "anomalous" pattern differs based on p mod 4

**Connection to our work:**
- Aladov counts (a, a+1) pairs by QR pattern — uses Legendre symbols
- We count (k-1, k) pairs by coprimality — uses gcd
- Both show **exact mod 4 dependence** in the count deviations
- The STRUCTURE is identical even though the QUANTITY measured differs

**Historical chain:**
- Aladov (1896): Exact length-2 formulas
- von Sterneck (1898): Length 3-4 with restrictions
- Jacobsthal (1906): Exact length 2-3 formulas
- Davenport (1930s): Extended to length ≥ 4
- Weil (1948): Definitive O(√p) bound via Riemann hypothesis for curves

**Verdict:** The mod 4 structure in consecutive-pair counting is **classical** (Aladov 1896).
Our specific formula A(p) = ±2 or 0 may be a different manifestation of the same phenomenon.

### Convention Note: Sign Asymmetry A(p)

**Fundamental result (dichotomy):**
$$A(p) = 2 \cdot \text{sign}(\beta) \cdot \mathbf{1}_{p \equiv 1 \pmod{4}}$$

**Sign depends on β choice:**

| Session | β used | Sign of β | A(p≡1 mod 4) |
|---------|--------|-----------|--------------|
| primitive-lobe-signs | β_signs ≈ 1/6 | **+** | **-2** |
| This session | β_geom ≈ -1 | **-** | **+2** |

**Reason:** A(p) counts sign(B-1) = sign(β·cos(...)). Flipping β flips the sign.

**When citing:** Always specify which β convention is used.

**Reference:** [arXiv:1512.00896 - Sums of Quadratic Residues](https://arxiv.org/abs/1512.00896)

#### Chebyshev ↔ Cyclotomic Deep Connection (KEY FINDING)

**Known theorem:** Let ζ be a primitive 4n-th root of unity. Then:
$$\alpha = \frac{\zeta + \zeta^{-1}}{2} = \cos\left(\frac{\pi}{2n}\right)$$
is a root of Chebyshev T_n(x).

**Structural relationship:**
- α generates the **maximal real subfield** of the 4n-th cyclotomic field
- Degree over ℚ: φ(4n)/2
- T_n is irreducible over ℚ **iff** n is a power of 2

**Why this matters:**
- Chebyshev polynomial roots = real parts of roots of unity
- Cyclotomic field = algebraic structure of primitive roots
- Our "primitive lobe" structure may be encoding cyclotomic arithmetic

**Reference:** [MathOverflow: Chebyshev factoring mod primes](https://mathoverflow.net/questions/191377/chebyshev-polynomials-factoring-uniformly-modulo-all-primes)

---

### Summary: What's Known vs Potentially Novel (Updated Dec 4, 2025)

| Claim | Status | Known Analog |
|-------|--------|--------------|
| BOTH(n) = n·∏(1-2/p) | ❌ KNOWN | Elkies (CRT) |
| T_{n+1}-xT_n = -(1-x²)U_{n-1} | ❌ KNOWN | Standard Chebyshev |
| Bridge: Chebyshev lobes ↔ coprime pairs | ❓ UNCLEAR | No direct reference found |
| Sign asymmetry A(p) ∈ {±2, 0} | ❓ RELATED | **Aladov (1896)** has exact mod 4 formulas for consecutive QR patterns |
| Polygon hierarchy (mod 4) | ✓ NOVEL? | No reference found |
| β-function cancellation | ✓ NOVEL? | No analog found |

**Key insight from Conrad/Aladov:**
- Aladov (1896) proved **exact** mod 4 dependence for consecutive QR pattern counts
- Our A(p) has analogous mod 4 structure but measures different quantity (sign of cosine vs Legendre symbol)
- The underlying cause is the same: -1 is QR iff p ≡ 1 (mod 4)

**What remains potentially novel:**
1. The **specific formula** A(p) = 2·sign(β)·𝟙_{p≡1(mod 4)} for sign sums
2. The **geometric interpretation** via Chebyshev lobes
3. The **polygon hierarchy** observation (2p splits p)
4. The **β-cancellation** analysis

---

### Numerical Comparison: A(p) vs Aladov (Dec 4, 2025)

### Definitions

**Our sign asymmetry A(p):**
$$A(p) = \sum_{k=1}^{p-1} \text{sign}\left(\cos\frac{(2k-1)\pi}{p}\right)$$

**Aladov's consecutive pair asymmetry:**
$$\text{Alad}_2(p) = N_p(+,-) - N_p(-,+)$$

where $N_p(\epsilon_1, \epsilon_2)$ counts consecutive pairs $(k, k+1)$ with Legendre symbols $(\epsilon_1, \epsilon_2)$.

### Experimental Results (98 primes tested)

| p mod 4 | A(p) | Alad₂(p) | Interpretation |
|---------|------|----------|----------------|
| **1** | **-2** | 0 | Cosine signs asymmetric |
| **3** | 0 | **1** | QR pairs asymmetric |

**Verified formula:**
$$A(p) = -2 \cdot \mathbf{1}_{p \equiv 1 \pmod{4}}$$

### The Complementarity

A(p) and Aladov's asymmetry are **mod 4 complementary**:
- A(p) ≠ 0 exactly when Alad₂(p) = 0
- A(p) = 0 exactly when Alad₂(p) ≠ 0

Both depend on whether **-1 is a quadratic residue mod p** (true iff p ≡ 1 mod 4).

### Not Trivial!

These are genuinely different quantities:
- **Aladov**: Local property (consecutive pairs in sequence 1,2,...,p-1)
- **A(p)**: Global property (sign distribution around the circle)

Gauss sum analysis shows they are NOT simple transforms of each other:
- Gauss sum |G|² = p (exactly)
- Our exponential sum |E|² ~ p² (different scaling)

### Open Question

**Why are they complementary?**

Both arise from -1 being QR iff p ≡ 1 (mod 4), but the mechanism connecting:
- sign(cos((2k-1)π/p)) distribution
- consecutive Legendre symbol patterns

remains unclear. This may be a deeper number-theoretic relationship worth investigating.

---

## Russian Sources Search (Dec 4, 2025)

Extended literature search covering Russian mathematical tradition.

#### Kiritchenko, Tsfasman, Vlăduț, Zakharevich (2024)

Paper: *"Quadratic residue patterns, algebraic curves and a K3 surface"* (arXiv:2403.16326)

**Key findings:**
- ✅ **Cites Aladov (1896)** — Section 2.1 "Early history": "Namely, Aladov's paper [A] gives the answer for ℓ = 2"
- ✅ **Extensive mod 4 analysis** — exact formulas matching Aladov's
- ✅ **Preserves Goncharova's unpublished work** — K3 surface result
- ❌ **No Chebyshev polynomial connection** — uses algebraic geometry (curves, Jacobians, K3 surfaces)
- ❌ **No sign asymmetry formula like our A(p)**

**Authors:** Moscow HSE, MIPT (Russia), Aix-Marseille (France), UC Berkeley (USA)

#### Wang & Fang (2023)

Paper: *"Distribution Properties of Consecutive Quadratic Residue Sequences"* (Wiley)

**Key findings:**
- ❌ **Does NOT cite Aladov** — starts history at Carlitz (1956)
- ✅ Has mod 4 structure (works with p ≡ 3 mod 4 specifically)
- ❌ No Chebyshev connection
- ❌ Character sum methods only

#### The Bibliographic Divergence

| Source | Cites Aladov? | Chebyshev? | Our A(p)? |
|--------|---------------|------------|-----------|
| Kiritchenko et al. 2024 (Russian) | ✅ Yes | ❌ No | ❌ No |
| Wang & Fang 2023 (Chinese) | ❌ No | ❌ No | ❌ No |
| Conrad (expository, USA) | ✅ Yes | ❌ No | ❌ No |
| MathOverflow discussions | ❌ No | ❌ No | ❌ No |

**Conclusion:** Russian mathematical tradition maintains awareness of Aladov (1896), while most Western/Chinese literature does not. Our Chebyshev polynomial connection appears in **neither** tradition.

**Further reading:**
- [Historical Context: Aladov and Russian Mathematical Tradition](historical-context.md)
- [The Aladov Mystery: Who Was N. S. Aladov?](aladov-mystery.md)
- [Algebraic Proof: Why A(p) and Aladov Are Complementary](complementarity-proof.md)
