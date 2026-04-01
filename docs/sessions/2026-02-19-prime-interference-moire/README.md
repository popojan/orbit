# Prime Interference Shader — Moiré Patterns and ζ(s)²

**Date:** 2026-02-19
**Status:** 🤔 HYPOTHESIS (moiré–zeta connection); ✅ CONFIRMED (geometry and prime characterization)

## Overview

Analysis of `visualizations/prime_interference.glsl` — a shader that draws two families of
lines whose intersections encode the divisor structure of natural numbers, with primes
characterized by the absence of interior intersections. The progressive zoom-out creates
moiré interference patterns whose frequency content may relate to ζ(s)².

## The Shader Geometry

### Line families

For each index `i = 1, 2, 3, ...`, two lines are drawn:

- **Positive family:** `y = i − x/i`, slope `−1/i`, y-intercept `+i`
- **Negative family:** `y = −i + x/i`, slope `+1/i`, y-intercept `−i`

All lines pass through the y-axis. The `i = 1` lines are `y = 1 − x` and `y = x − 1`,
forming a V-shape with vertex at `(1, 0)`.

### Intersection structure

Lines within the same family never intersect in the visible region `x ≥ 0` (they would
meet at `x = −ij < 0`).

Cross-family intersections: positive line `i` meets negative line `j` at:

```
x = ij,   y = i − j
```

**At x = n**, the intersection points are `(n, i − j)` for every ordered factorization
`n = ij` with `i, j ≥ 1`. The number of such points equals `d(n)`, the divisor count.

### Prime characterization

For a **prime** `p`, the only factorizations are `1 × p` and `p × 1`, yielding
intersections only at `y = ±(p − 1)` — on the boundary lines `y = ±(x − 1)`.
No intersections appear in the interior `|y| < p − 1`.

For a **composite** `n = ab` with `a, b > 1`, additional intersections appear at
intermediate y-values (e.g., `y = a − b`).

## Relation to Prvoles (Primal Forest)

The `prvoles.tex` paper describes a discrete "tree planting" visualization of the
Eratosthenes sieve: for each composite `n = p(p + k)`, a tree is placed at
`(n, kp + 1)`. Each factor `p` generates a 45° diagonal with spacing `(p, p)`.

| Aspect | Prvoles | Shader |
|--------|---------|--------|
| Objects | Discrete points (trees) | Continuous lines |
| Encoding | Explicit: plant tree per divisor | Emergent: intersections from line geometry |
| Diagonals | All slope 1 (45°), spacing varies by p | Slopes ±1/i, all through y-axis |
| Primes | Zero trees at x = p | Intersections only on boundary y = ±(x−1) |
| Scalability | Discrete — no new info at zoom | Continuous — moiré patterns emerge |

Both encode the same arithmetic fact: at `x = n`, the number of features reflects `d(n)`.
The shader is a continuous generalization where the divisor lattice is **self-emergent**
from line geometry — no enumeration of composites required.

The shader's key advantage is that continuous lines produce **interference patterns** at
large zoom that carry aggregate information about the divisor structure, which discrete
points cannot.

## Coordinate Convention: To Shift or Not to Shift

### Current convention (shader as-is)

The x-coordinate directly represents the natural number: position `x = n` corresponds to
the integer `n`. The boundary lines are `y = ±(x − 1)`, forming a V with vertex at
`(1, 0)`.

**Pros:**
- Direct correspondence: x-coordinate IS the number being tested
- No mental offset when reading the visualization
- Intersection at `(ij, i − j)` — clean product formula
- The number 1 sits at x = 1, where the V-vertex is (the "most prime" position,
  with zero interior intersections and even the boundary intersections collapsed to a point)

**Cons:**
- Boundary lines are `y = ±(x − 1)`, not the cleaner `y = ±x`
- The origin `(0, 0)` has no natural number interpretation
- Line equations `y = i − x/i` have the asymmetric constant term

### Shifted convention: x → x + 1

Replace `x` with `x + 1` everywhere: now position `x = n` represents the number `n + 1`,
or equivalently, number `n` sits at position `x = n − 1`.

The line equations become:
- Positive: `y = i − (x+1)/i = (i² − 1)/i − x/i`
- Negative: `y = −i + (x+1)/i = (1 − i²)/i + x/i`

Intersections move to `(ij − 1, i − j)`.

**Pros:**
- The `i = 1` boundary lines become `y = ±x` (clean!)
- The origin represents 1, which is a natural anchor

**Cons:**
- Intersection formula becomes `(ij − 1, i − j)` — the `−1` is ugly
- Every number is off by one from its position, creating constant mental friction
- Line equations gain a `(i² − 1)/i` term instead of the clean `i`
- The product structure `x = ij` (the core arithmetic content!) is obscured
- For any analysis involving the divisor function, you'd constantly convert back

### Verdict

The current convention is superior for mathematical analysis. The clean product formula
`x = ij` at intersection points is the **load-bearing** property — it directly encodes
factorization, which is the entire point. The `y = ±(x − 1)` boundary is a cosmetic
blemish that vanishes asymptotically (for large x, the ±1 is negligible).

If the `y = ±x` aesthetics matter for a particular presentation, it's better to note the
asymptotic equivalence than to shift coordinates and break the product structure.

**Recommendation:** Keep the current convention. Document the asymptotic note
`y = ±(x − 1) ≈ ±x` for large x.

## O(1) Nearest-Line Distance — Continuous Factorization

### The problem

The original shader iterates over all $N$ lines per pixel, computing distances and
accumulating a multiplicative product — $O(N)$ per pixel. Can we find the nearest line
in $O(1)$?

### Distance to line $i$ from each family

The distance from point $(x, y)$ to each line is:

**Positive family** (line $i$: $x + iy - i^2 = 0$):

$$d_+(i) = \frac{|i^2 - yi - x|}{\sqrt{1 + i^2}}$$

**Negative family** (line $i$: $-x + iy + i^2 = 0$):

$$d_-(i) = \frac{|i^2 + yi - x|}{\sqrt{1 + i^2}}$$

### Solving for the nearest line

The numerator $|i^2 - yi - x|$ is a quadratic in $i$. It vanishes when a line passes
exactly through $(x, y)$. Setting the quadratic to zero:

$$i^2 - yi - x = 0 \quad \Longrightarrow \quad i^* = \frac{y + \sqrt{y^2 + 4x}}{2}$$

$$i^2 + yi - x = 0 \quad \Longrightarrow \quad i^{**} = \frac{-y + \sqrt{y^2 + 4x}}{2}$$

The nearest positive-family line has index $\lfloor i^* \rceil$ (nearest integer), and
the nearest negative-family line has index $\lfloor i^{**} \rceil$. Evaluating $d_+$ and
$d_-$ at the two bracketing integers for each gives **4 candidate distances**. The minimum
is the global nearest-line distance. Total cost: **one square root, four distance evaluations**.

### Continuous factorization identities

The pair $(i^*, i^{**})$ satisfies:

$$i^* \cdot i^{**} = x \qquad \text{(product = x-coordinate)}$$

$$i^* - i^{**} = y \qquad \text{(difference = y-coordinate)}$$

This is the **continuous factorization** of the point $(x, y)$: the point lies exactly
on a line intersection if and only if both $i^*$ and $i^{**}$ are positive integers —
in which case $x = ij$ is a factorization and $y = i - j$ is the factor difference.

The distance to the nearest line is governed by how far $i^*$ (or $i^{**}$) is from
the nearest integer — the **fractional parts** $\{i^*\}$ and $\{i^{**}\}$.

### Asymptotic form

For large $x$ (with $|y| \ll \sqrt{x}$):

$$i^* \approx \sqrt{x} + \frac{y}{2\sqrt{x}}, \qquad
i^{**} \approx \sqrt{x} - \frac{y}{2\sqrt{x}}$$

$$\sqrt{y^2 + 4x} \approx 2\sqrt{x}, \qquad
\sqrt{1 + i_0^2} \approx \sqrt{x}$$

Substituting into the distance formula:

$$d_{\text{nearest}} \approx 2 \cdot \min\!\Big(\{i^*\},\, \{i^{**}\}\Big)$$

where $\{t\} = \min(t - \lfloor t \rfloor,\, \lceil t \rceil - t)$ is the distance to
the nearest integer.

### The moiré mechanism

The moiré patterns arise from $\{i^*\}$ and $\{i^{**}\}$ oscillating as the point
$(x, y)$ moves across the pixel grid. This is the same mechanism that creates moiré
in $\text{frac}(r/\lambda)$ interference patterns, except here the "wavelength" varies
with position because of the quadratic structure:

$$i^* = \frac{y + \sqrt{y^2 + 4x}}{2}$$

The fractional part of this expression oscillates with a position-dependent period,
creating the characteristic non-uniform moiré fringes.

### Implementation

The O(1) shader (`visualizations/prime_interference_O1.glsl`) replaces the $O(N)$ loop
with:

```glsl
float sqrtD = sqrt(y*y + 4.0*x);
float iStar = (y + sqrtD) * 0.5;     // continuous positive-family index
float jStar = (-y + sqrtD) * 0.5;    // continuous negative-family index

// Check 4 candidate lines (2 bracketing integers per family)
float dMin = min(min(dPosLo, dPosHi), min(dNegLo, dNegHi));
```

**Limitation:** This renders only the nearest line, not the full multiplicative product
of all lines. The visual result shows the same moiré structure (since the product is
dominated by the nearest-line factor) but with slightly different contrast characteristics.

## Experimental Results

### Segment density analysis (y=0 profile)

**Finding:** The $y = 0$ intensity profile is dominated by **perfect squares**, not
factorization structure. Along $y = 0$, both line families give the same distance:

$$d_{\pm}(i)\big|_{y=0} = \frac{|x - i^2|}{\sqrt{1 + i^2}}$$

This vanishes at $x = i^2$ (perfect squares), regardless of whether $x$ is prime or
composite. The profile cannot distinguish primes from composites.

### Full segment density ($y \in [-(n-1), n-1]$)

Average density over the full factorization-relevant segment showed primes (0.803) and
composites (0.797) nearly indistinguishable. The reason: the **multiplicative product**
`dist *= smoothstep(d)` goes to zero whenever ANY single line is nearby, and every line
from both families crosses every vertical segment. The product counts line crossings
(same for all $n$) rather than line intersections (which differ for primes vs composites).

**Conclusion:** The multiplicative rendering is visually effective but analytically
unsuitable for prime detection. An additive measure (counting simultaneous near-line
coincidences) would be needed, but this reduces to trial division.

## 🤔 HYPOTHESIS: Moiré Spectrum ↔ ζ(s)² Connection

**Status:** Untested hypothesis, documented before verification.

### Background

The moiré patterns arise when the pixel grid cannot resolve individual lines. The
rendered image is a **spatially sampled** version of the continuous line field. Sampling
creates aliasing, and the alias frequencies depend on the line density function.

### The density argument

At a point `(x, y)` near the x-axis (`y ≈ 0`), the nearby lines from the positive
family have indices `i ≈ √x` (solving `y = i − x/i = 0`), with local spacing
inversely proportional to `|dy/di| = 1 + x/i²`. At `i = √x` this gives spacing
proportional to `1/2`, so lines are roughly uniformly spaced near `y = 0` — but this
uniform spacing is **modulated** by the intersection structure.

The key: at positions `x = n` where `n` has many divisors, multiple intersection points
cluster near `y = 0` (e.g., for `n = ab`, the intersection at `y = a − b` is small when
`a ≈ b ≈ √n`). These clusters create local density variations in the line pattern.

### Connection to the divisor function

The number of intersection points at `x = n` is `d(n)` (divisor count). The Dirichlet
series for `d(n)` is:

```
∑_{n=1}^∞ d(n) n^{−s} = ζ(s)²
```

If the moiré pattern's intensity at position x is modulated by `d(n)` (more
intersections → different local texture), then the **spatial power spectrum** of the
moiré image along the x-axis should encode information about `ζ(s)²`.

### What would confirm this

1. Render the shader at a fixed zoom level, extract a 1D intensity profile along `y = 0`
2. Compute the power spectrum (FFT) of this intensity profile
3. Compare peak structure with predictions from `|ζ(σ + it)|²` for appropriate σ

The spatial frequency `k` in the moiré should map to the imaginary part `t` of the zeta
argument, with the zoom level determining the real part `σ`.

### What would falsify this

- Power spectrum shows only trivial peaks (harmonics of average line spacing)
- No correlation between spectrum and zeta zeros
- The moiré is dominated by pixel-grid aliasing artifacts unrelated to number theory

### Concrete prediction

At moderate zoom (where ~100 lines are visible), the 1D intensity profile along `y = 0`
should show quasi-periodic modulation. The FFT of this signal should have peaks whose
spacing is NOT uniform — it should reflect the irregular structure of highly composite
numbers (which create denser intersection clusters) vs. primes (which create sparser
regions).

### Adversarial counter-arguments

1. **Lossy compression:** Moiré is a low-pass filter. Individual prime positions are
   high-frequency features that get destroyed. At best we see density statistics, not
   individual primes.

2. **Pixel aliasing dominates:** The moiré may be primarily an artifact of pixel grid vs.
   line spacing, with number-theoretic content buried under aliasing noise.

3. **Equivalence to sieve:** Any computational extraction of prime information from the
   rendered image is likely equivalent to (and slower than) trial division. The lines ARE
   the sieve drawn continuously.

4. **The ζ(s)² connection may be formal only:** The divisor function appears in the
   geometry, and its Dirichlet series is ζ(s)², but the mapping from spatial frequencies
   in the moiré to the complex s-plane may not be clean enough to extract useful
   information.

### Honest assessment

The connection is **suggestive but unverified**. The divisor function genuinely governs
the intersection density, and ζ(s)² genuinely is its Dirichlet series. Whether the moiré
pattern is a faithful enough "physical Fourier analyzer" to make this visible is an
empirical question.

The most likely outcome: the moiré carries some statistical signature of prime density
(distinguishing prime-rich from prime-poor regions), but not enough to identify individual
primes or reproduce zeta zeros. Worth testing — the experiment is cheap (render + FFT).

## Proposed Experiments

1. **1D intensity profile:** Render at fixed zoom, extract horizontal slice at y = 0,
   compute FFT. Look for non-trivial spectral structure.

2. **Scale dependence:** Render at multiple zoom levels, track how dominant moiré
   frequencies shift. Does the relationship match ζ(σ + it) for varying σ?

3. **Comparison with random composites:** Replace the line arrangement with random slopes
   (destroying number-theoretic structure). Does the moiré spectrum change qualitatively?

4. **Vertical slices:** Extract vertical intensity profiles at x = p (primes) vs.
   x = n (composites). Is there a detectable textural difference?

## Files

- `visualizations/prime_interference.glsl` — original shader (O(N) per pixel)
- `visualizations/prime_interference_commented.glsl` — commented version with full
  geometric analysis
- `visualizations/prime_interference_O1.glsl` — O(1) per pixel using continuous
  factorization (nearest-line only, not full product)
- `docs/papers/prvoles.tex` — Primal Forest paper (discrete tree-planting approach)
- `docs/sessions/2026-02-19-prime-interference-moire/prime_interference.wl` — Wolfram
  Language port with analysis functions
- `docs/sessions/2026-02-19-prime-interference-moire/run_density.wl` — segment density
  experiment script
