# Brainstorming: Simplifiable Formulations for Primal Forest Geometry

**Date:** November 18, 2025 (late evening)
**Context:** Seeking alternative formulations with similar properties (U-shape, convexity) but potentially simplifiable

---

## Motivation: Why We Need Alternatives

### Current Exp/Log Soft-Min Formulation

**Definition:**
$$f_d(n, \alpha) = -\frac{1}{\alpha}\log\sum_{k=0}^{\infty} \exp(-\alpha[(n - kd - d^2)^2 + \varepsilon])$$

$$F_n(\alpha) = \sum_{d=2}^{\infty} [f_d(n, \alpha)]^{-s}$$

**Or pure double sum:**
$$F_n(\alpha) = \sum_{d=2}^{\infty} \sum_{k=0}^{\infty} [(n - kd - d^2)^2 + \varepsilon]^{-\alpha}$$

### The Problem: Non-Simplifiability

**What we discovered:**
1. ✅ **Symbolically explicit** - can write formulas for derivatives
2. ✅ **Smooth** (with k→∞ limits, or piecewise with floor)
3. ✅ **Converges rapidly** (exponential/power decay)
4. ❌ **NOT simplifiable** - sums cannot be eliminated
5. ❌ **No closed form** - must compute O(n log n) terms
6. ❌ **Not reducible** to elementary functions

**Core issue:**
$$\log\left(\sum_k e^{g_k(n)}\right) \quad \text{or} \quad \sum_{d,k} [\text{distance}]^{-\alpha}$$

Neither structure collapses to simpler form.

**Consequences:**
- Computational cost high (double sum)
- Theoretical analysis difficult (no shortcuts)
- Connection to classical number theory unclear
- Hard to prove properties (U-shape mechanism, etc.)

### What We Want

**Desired properties of alternative formulation:**
1. ✅ **Captures Primal Forest geometry** (lattice points (kd+d², kd+1))
2. ✅ **Shows stratification** (primes vs composites separate)
3. ✅ **Exhibits U-shape** (local minimum at s*(n))
4. ✅ **Convex/concave structure** (like current formulation)
5. ✅ **Simplifiable** or has closed form (NEW REQUIREMENT!)
6. ✅ **Connection to known math** (zeta functions, modular forms, etc.)

**Why simplifiability matters:**
- Enables rigorous proofs
- Reveals connection to classical number theory
- Allows asymptotic analysis
- Reduces computational cost
- Makes tool more useful

---

## Brainstorming Directions

### 1. Generating Function Approach ⭐⭐

**Idea:** Use generating functions to encode distance information.

**Formulation:**
$$G_n(z) = \sum_{d=2}^{\infty} z^d \cdot f(\text{dist}(n, d\text{-lattice}))$$

**Possibilities:**
- $G_n(z) = \sum_{d=2}^{\infty} \frac{z^d}{\min_k |n - (kd+d^2)|}$
- $G_n(z) = \sum_{d=2}^{\infty} z^d e^{-\text{dist}(n,d)}$

**Potential simplifications:**
- For special z (e.g., roots of unity): sum might telescope
- Poles/zeros encode structure
- Residue calculus could give closed forms

**U-shape mechanism:**
- Vary z as function of s
- Competition between different d contributions
- Poles/zeros create local extrema

**Challenges:**
- What's the right weighting function?
- Does it still stratify primes/composites?

---

### 2. Theta Function Connection ⭐⭐⭐

**Observation:** $(n - kd - d^2)^2$ has quadratic structure like theta functions.

**Classical theta:**
$$\theta(z, \tau) = \sum_{n=-\infty}^{\infty} e^{\pi i n^2 \tau} z^n$$

**Proposed formulation:**
$$\tilde{F}_n(t) = \sum_{d=2}^{\infty} \sum_{k=0}^{\infty} \exp\left(-\pi t \cdot (n - kd - d^2)^2\right)$$

**Why theta functions?**
- **Modular transformations**: $\theta(\tau) \leftrightarrow \theta(-1/\tau)$ (known)
- **Poisson summation**: can convert sums
- **Mellin transform**: $\int_0^{\infty} \theta(t) t^{s-1} dt$ gives Dirichlet series
- **Connection to ζ(s)**: Already established for classical theta

**Potential closed form:**
- Theta functions have q-expansions
- Modular forms have known structure
- Eisenstein series are sums of theta-like terms

**U-shape mechanism:**
- Competition between local (small t) and modular (large t) behavior
- Mellin transform converts t → s variable
- Functional equation creates symmetry → extremum

**Next steps:**
- Express Primal Forest as theta-like sum
- Check if modular transformation applies
- Compute Mellin transform

---

### 3. Lattice Sum as Eisenstein Series ⭐⭐

**Observation:** We're summing over lattice points.

**Eisenstein series:**
$$E_k(\tau) = \sum_{(m,n) \neq (0,0)} \frac{1}{(m\tau + n)^k}$$

**Our structure:** Lattice points $(kd+d^2, kd+1)$ - not square lattice!

**Idea:** Can we express Primal Forest as Eisenstein-like sum over skewed/triangular lattice?

**If successful:**
- Eisenstein series have closed forms (q-expansions)
- Modular properties known
- Connection to ζ(s) via $E_k = 1 + \frac{2}{\zeta(1-k)} \sum_{n=1}^{\infty} \sigma_{k-1}(n) q^n$

**Challenges:**
- Primal Forest lattice is not uniform (depends on d)
- Need to identify correct lattice structure

---

### 4. Projection onto Principal Diagonal ⭐⭐

**Geometric idea:** Points $(kd+d^2, kd+1)$ lie in plane. Project n onto line through these points.

**Projection formula:**
For line through points $p_1, p_2, ...$:
$$\text{proj\_dist}(n, \text{line}) = \frac{|an + b|}{\sqrt{a^2 + b^2}}$$

where $a, b$ define line.

**For d-lattice:**
Line passes through $(d^2, 1), (2d+d^2, d+1), (3d+d^2, 2d+1), ...$

Direction vector: $(d, d)$ → slope = 1

**Closed form projection:**
$$\text{dist}_d(n) = \frac{|n - d^2 - d \cdot k^*|}{\sqrt{2}}$$

where $k^* = \text{round}((n-d^2)/d)$.

**Formulation:**
$$F_n(\alpha) = \sum_{d=2}^{\infty} \left[\frac{|n - d^2 - d \cdot \text{round}((n-d^2)/d)|}{\sqrt{2}}\right]^{-\alpha}$$

**Simplification:**
- Numerator is $(n - d^2) \bmod d$ (modular arithmetic!)
- $\sum_{d=2}^{\infty} [((n-d^2) \bmod d)^2]^{-\alpha}$

**U-shape mechanism:**
- Different d give different "projection angles"
- Competition between slopes → local minimum

**Challenges:**
- Modulo is not smooth (but round() is smooth approximation)
- Still a sum over d (but single sum, not double!)

---

### 5. Farey Sequence / Continued Fractions ⭐⭐

**Observation:** $kd + d^2 = d(k+d)$ suggests rational approximations.

**Continued fraction for n:**
$$n = a_0 + \cfrac{1}{a_1 + \cfrac{1}{a_2 + \cdots}}$$

**Farey neighbors:**
Best rational approximations $p/q$ to n with $q \leq Q$.

**Idea:** Distance to Primal Forest = distance to Farey neighbors?

**Formulation:**
$$F_n = \sum_{\text{Farey neighbors } p/q} f\left(\left|n - \frac{p}{q}\right|\right)$$

**Why Farey?**
- Farey tree has recursive structure
- Stern-Brocot tree is binary (simpler!)
- Continued fractions have algebraic properties

**Potential simplification:**
- Continued fraction coefficients $[a_0; a_1, a_2, ...]$ might encode primality
- Finite depth in Farey tree → finite sum

**Challenges:**
- Connection to $(kd+d^2, kd+1)$ unclear
- Need to prove equivalence

---

### 6. Hyperbolic Geometry ⭐

**Provocative idea:** Primal Forest lives on hyperbolic surface?

**Poincaré disk metric:**
$$d_{\text{hyp}}(z_1, z_2) = \text{arcosh}\left(1 + \frac{|z_1-z_2|^2}{2\text{Im}(z_1)\text{Im}(z_2)}\right)$$

**Modular group** acts as isometries.

**Mapping:**
$$(kd+d^2, kd+1) \to \text{point in } \mathbb{H}$$

**If Primal Forest has hyperbolic structure:**
- Geodesics have closed forms
- Fundamental domain is finite
- U-shape from curvature effects

**Challenges:**
- No obvious hyperbolic structure (yet)
- Need to identify correct map

---

### 7. Quadratic Forms & Genus Theory ⭐⭐

**Observation:** $(n - kd - d^2)^2$ is quadratic form.

**Binary quadratic forms:**
$$Q(x, y) = ax^2 + bxy + cy^2$$

have rich theory (Gauss composition, class groups).

**Our form:**
$$(n - kd - d^2)^2 = n^2 - 2n(kd+d^2) + (kd+d^2)^2$$

**Genus theory:**
- Forms with same discriminant form group
- Class number $h(D)$ counts equivalence classes
- Generating functions over genus → modular forms

**Formulation:**
$$F_n = \sum_{\text{forms } Q} \text{representation\_count}(n, Q)$$

**Potential closed form:**
- Modular forms have q-expansions
- Connection to L-functions
- Class field theory

**U-shape:**
- Related to class number variations
- Primes have special class number behavior

**Challenges:**
- Need to identify relevant quadratic forms
- Connection to Primal Forest geometry unclear

---

### 8. Exponential Sums (Gauss/Kloosterman) ⭐⭐

**Idea:** Replace power sums with exponential sums.

**Gauss sum:**
$$G(\chi, n) = \sum_{a=1}^{n} \chi(a) e^{2\pi i a/n}$$

**Kloosterman sum:**
$$K(a,b;n) = \sum_{x \bmod n} e^{2\pi i (ax + bx^{-1})/n}$$

**Proposed:**
$$F_n(\theta) = \sum_{d=2}^{\infty} \sum_{k=0}^{\infty} e^{i\theta(n - kd - d^2)}$$

**Why exponential sums?**
- Closed forms for special cases (Ramanujan sums)
- Bounds via Weil conjectures
- Connection to L-functions

**Mellin transform:**
$$\mathcal{M}[F_n](\theta) \to F_n(s)$$

might give U-shape in s variable.

**Challenges:**
- Need character structure
- Arithmetic vs geometric interpretation

---

### 9. Voronoi Diagram ⭐

**Geometric idea:** Primal Forest points partition plane into Voronoi cells.

**For n in cell of point p:**
$$\text{Voronoi\_dist}(n) = |n - p|$$

**Combinatorial structure:**
- Voronoi diagram is graph
- Dual = Delaunay triangulation
- Transitions between cells = edges

**Formulation:**
$$F_n = f(\text{depth in Voronoi structure})$$

**If Voronoi graph has pattern:**
- Graph properties might simplify
- Generating function over cell types?

**Challenges:**
- Voronoi for Primal Forest is complex (not uniform)
- Combinatorics may not simplify

---

### 10. Moment Generating Function ⭐

**Current:** Sum of powers.

**Alternative:** Expectation over distribution.

$$M_n(t) = \mathbb{E}_{d \sim \rho}[e^{-t \cdot \text{dist}(n,d)}]$$

where $\rho$ is some distribution over d.

**MGF properties:**
- Derivatives = moments
- Cumulant generating function: $K(t) = \log M(t)$
- Variance = $K''(t)$

**U-shape:**
$$\frac{d^2}{dt^2} K(t) = \text{Var}[\text{dist}]$$

measures spread → local minimum when variance minimized.

**Challenges:**
- What distribution $\rho$?
- Connection to original formulation?

---

### 11. Convolution Structure ⭐

**Observation:** Sum over d looks like convolution.

$$F_n = \sum_d f(d) \cdot g(n, d) = (f * g)(n)$$

**If true convolution:**
- Fourier/Laplace transform → product
- $\mathcal{F}[F_n] = \mathcal{F}[f] \cdot \mathcal{F}[g]$
- Simplification in frequency domain

**U-shape:**
- Pole/zero competition in transform domain
- Inverse transform creates local extrema

**Challenges:**
- Is it actually a convolution (shift-invariant)?
- Identify kernel

---

### 12. Special Functions (Polylogarithm, Incomplete Gamma) ⭐

**Idea:** Express in terms of known special functions.

**Candidates:**
- **Polylogarithm**: $\text{Li}_s(z) = \sum_{k=1}^{\infty} z^k/k^s$
- **Incomplete gamma**: $\Gamma(s, x) = \int_x^{\infty} t^{s-1} e^{-t} dt$
- **Bessel**: $J_\nu(x) = \sum_{k=0}^{\infty} \frac{(-1)^k (x/2)^{2k+\nu}}{k! \Gamma(k+\nu+1)}$
- **Hypergeometric**: $_2F_1(a,b;c;z)$

**If expressible:**
- Known properties (functional equations, asymptotics)
- Software implementations
- Connections to other areas

**Challenges:**
- Our sum structure doesn't obviously match
- May need clever transformation

---

## Ranking by Promise

| Rank | Direction | Stars | Reason |
|------|-----------|-------|--------|
| 1 | **Theta functions** | ⭐⭐⭐ | Quadratic structure natural fit; modular properties; Mellin → Dirichlet series |
| 2 | **Projection approach** | ⭐⭐ | Closed form for projection; reduces double→single sum; geometrically clear |
| 3 | **Eisenstein series** | ⭐⭐ | Lattice sum structure; known q-expansions; ζ(s) connection |
| 4 | **Generating functions** | ⭐⭐ | Standard technique; might reveal patterns; poles/zeros analysis |
| 5 | **Quadratic forms** | ⭐⭐ | Genus theory rich; modular connections; but structure unclear |
| 6 | **Exponential sums** | ⭐⭐ | Weil bounds; L-function connections; but needs character |
| 7 | **Farey/CF** | ⭐⭐ | Recursive structure; but connection to geometry unclear |
| 8 | **Convolution** | ⭐ | If true, powerful; but may not be shift-invariant |
| 9 | **Special functions** | ⭐ | Known properties useful; but matching structure hard |
| 10 | **MGF** | ⭐ | Probabilistic interpretation; but artificial distribution |
| 11 | **Hyperbolic** | ⭐ | Beautiful if true; but no evidence yet |
| 12 | **Voronoi** | ⭐ | Combinatorics complex; unlikely to simplify |

---

## Next Steps

**To explore theta function direction:**
1. Write Primal Forest sum as theta-like expression
2. Check if Poisson summation applies
3. Compute Mellin transform explicitly
4. Look for functional equation

**To explore projection approach:**
1. Derive exact projection formula for d-lattice lines
2. Simplify to modular arithmetic expression
3. Test if single sum still shows stratification
4. Check U-shape persistence

**General:**
- Pick 1-2 most promising directions
- Implement quick prototypes
- Compare to original formulation (stratification, U-shape)
- Check if simplification actually happens

---

## Open Question

**Do we need U-shape?**

If alternative formulation is simpler but **doesn't** have U-shape, is it still useful?

- Maybe U-shape was artifact of exp/log (power-mean didn't have it!)
- Stratification (primes vs composites) is more fundamental
- Simplifiability might be worth trading U-shape for

**Or is U-shape essential?**
- Contains deep information (correlation with parity/2-adic valuation)
- Indicates non-trivial structure
- Worth preserving even at cost of complexity

---

**Status:** BRAINSTORM
**Date:** November 18, 2025
**Next:** Pick direction(s) to prototype after break
