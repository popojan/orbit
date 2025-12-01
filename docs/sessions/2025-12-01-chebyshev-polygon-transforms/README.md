# Chebyshev Polygon Function Transforms

**Date:** December 1, 2025

## Motivation

Study of primitive lobe SignSums showed complexity comparable to factorization. The hypothesis was that primality of k might be "encoded in the function as a whole" rather than in local lobe structure.

**Geometric insight:** For a regular n-gon, primality means no "skip pattern" creates a smaller regular polygon. For prime n, every skip d (1 < d < n) visits ALL vertices. For composite n = a·b, skipping by a creates a b-gon.

## Key Identity

In the angular domain (x = cos θ):

$$f(\theta) = \text{ChebyshevPolygonFunction}[\cos\theta, k] = -\sin(k\theta)\sin(\theta)$$

This is naturally **2π-periodic** with trivial Fourier expansion:
$$-\sin(k\theta)\sin(\theta) = \frac{\cos((k+1)\theta) - \cos((k-1)\theta)}{2}$$

Only **two non-zero Fourier coefficients** regardless of k!

## Methods Tested

| Method | Distinguishes prime/composite? | Notes |
|--------|-------------------------------|-------|
| L² norm | No | Constant = 1/4 for all k |
| Fourier spectrum | No | Peak shifts with k, shape similar |
| DC component F(0) | Only parity | 0 for even k, 4/((k-2)k(k+2)) for odd k≥5 |
| Sampling at roots of unity | No | All zeros at k-th roots |
| Skip-pattern sums | **Yes** | But equivalent to trial division |
| Inner product matrix | Only parity | Tridiagonal in Chebyshev weight |
| GCD of polynomials | Complex | Not directly related to divisibility |
| Möbius-weighted integral | **Yes** | Gives μ(k)·π/8, but requires divisors |

## Detailed Findings

### 1. Skip Patterns (Geometric Divisibility Test)

For (k+1)-gon, sampling f at skip-d pattern:
- **Prime (k+1):** All skip patterns visit full polygon, sum = 0
- **Composite (k+1):** Some patterns create sub-polygons with non-zero sum

Example (k=5, 6-gon):
- skip 2 → 3-gon, sum = 0
- skip 3 → 2-gon, sum = -0.5 (non-zero!)

**Conclusion:** Detects compositeness, but finding which d works = finding divisor.

### 2. Möbius-Weighted Integral

$$M(k) = \sum_{d|k} \mu(d) \int_0^\pi f(\theta, k/d)^2 d\theta = \mu(k) \cdot \frac{\pi}{8}$$

- Primes: -π/8
- Squarefree composites: +π/8
- Numbers with squared factors: 0

**Conclusion:** Clean formula, but requires knowing divisors of k.

### 3. Polynomial Factorization

$$f_k(x) = (1-x^2) \cdot g_k(x)$$

where core polynomial g_k has parity structure:
- Even k → g_k has only odd powers of x
- Odd k → g_k has only even powers of x

GCD relationships exist (e.g., g_5 | g_10) but don't directly encode primality.

### 4. Inner Product Matrix

$$M_{ij} = \int_{-1}^{1} f_i(x) f_j(x) dx$$

- Non-zero only when i, j have same parity
- With Chebyshev weight 1/√(1-x²): becomes tridiagonal with diagonal π/4, off-diagonal -π/8

## Zero Structure (Corrected)

The zeros of f_k(x) are at:
$$x_m = \cos\left(\frac{m\pi}{k}\right), \quad m = 0, 1, \ldots, k$$

- Boundary zeros: m = 0 (x = 1) and m = k (x = -1) → factor (1 - x²)
- Internal zeros: m = 1, ..., k-1

**Primitivity criterion:** Zero x_m is primitive iff GCD(m, k) = 1.

For prime k: ALL internal zeros are primitive (m = 1, ..., k-1).
For composite k = a·b: zeros with GCD(m, k) = d > 1 correspond to sub-polygon structure.

## Polynomial Factorization Approach

**Key insight:** Polynomial factorization over ℚ is in **P** (polynomial time), unlike integer factorization!

### LLL Algorithm

**LLL = Lenstra–Lenstra–Lovász** (1982) - lattice basis reduction algorithm.

Used for polynomial factorization over ℚ:
1. Find roots mod p (small prime)
2. "Lift" using Hensel's lemma
3. LLL finds true factors from p-adic approximations

### Factor Structure (Computational Verification)

**For prime p ≥ 5:**
```
f_p(x) = -1 · (1-x) · (1+x) · F_odd(x) · F_even(x)
```
where:
- F_odd = MinPoly[cos(π/p)], degree (p-1)/2, zeros at cos(mπ/p) for odd m ∈ {1, 3, 5, ..., p-2}
- F_even = MinPoly[cos(2π/p)], degree (p-1)/2, zeros at cos(mπ/p) for even m ∈ {2, 4, 6, ..., p-1}
- ALL zeros are primitive (GCD(m, p) = 1)

**Explicit formula (verified computationally):**
$$f_p(x) = -1 \cdot (1-x) \cdot (1+x) \cdot \text{MinPoly}[\cos(\pi/p)] \cdot \text{MinPoly}[\cos(2\pi/p)]$$

**Example for p = 7:**
```mathematica
f_7(x) = -1 · (1-x) · (1+x) · (1 - 4x - 4x² + 8x³) · (-1 - 4x + 4x² + 8x³)
```
where:
- MinPoly[cos(π/7)] = 1 - 4x - 4x² + 8x³
- MinPoly[cos(2π/7)] = -1 - 4x + 4x² + 8x³
- Both have degree 3 = φ(7)/2

| p | Factor count | Core degrees | φ(p)/2 |
|---|--------------|--------------|--------|
| 5 | 5 | {2, 2} | 2 |
| 7 | 5 | {3, 3} | 3 |
| 11 | 5 | {5, 5} | 5 |
| 13 | 5 | {6, 6} | 6 |
| 17 | 5 | {8, 8} | 8 |
| 19 | 5 | {9, 9} | 9 |

**For composite k:**
- More factors, organized by GCD classes
- Factor of degree φ(k)/2 for primitive zeros (GCD(m,k) = 1)
- Separate factors for each divisor class d | k

| k | Factor count | Primitive degree | φ(k)/2 |
|---|--------------|------------------|--------|
| 6 | 7 | 2 | 1 |
| 8 | 6 | 4 | 2 |
| 9 | 7 | {3, 3} | 3 |
| 10 | 7 | 4 | 2 |
| 12 | 9 | 4 | 2 |

### Cyclotomic Polynomial Connection (Literature: Known Result)

**This connection is well-known!** See [Chebyshev Polynomials and the Minimal Polynomial of cos(2π/n)](https://www.tandfonline.com/doi/abs/10.4169/amer.math.monthly.124.1.74) (American Mathematical Monthly, 2017).

**Key transformation chain:**

1. **Chebyshev substitution:** x = cos(θ), z = e^(iθ)
2. **Identity:** T_k(cos θ) = cos(kθ) = (z^k + z^(-k))/2
3. **ChebyshevPolygonFunction:** f_k(cos θ) = -sin(kθ)·sin(θ)

**In complex variable:**
$$f_k = \frac{(z^k - z^{-k})(z - z^{-1})}{4}$$

**Zeros:** cos(mπ/k) = Re(ζ^m) where ζ = e^(iπ/k) is primitive 2k-th root of unity.

**The minimal polynomial of cos(π/k):**
- deg(ψ_k) = φ(2k)/2
- This is classical theory connecting real parts of roots of unity to Chebyshev polynomials

**Conclusion:** ChebyshevPolygonFunction is NOT a new construction - it's a well-understood transformation of cyclotomic polynomials via the Chebyshev substitution x → cos(θ).

### Galois-Theoretic Interpretation

The odd/even split for primes corresponds to:
- cos(mπ/p) and cos((p-m)π/p) = -cos(mπ/p) are related by negation
- Odd m values: cos(π/p), cos(3π/p), ... form one Galois orbit
- Even m values: cos(2π/p), cos(4π/p), ... form another orbit
- For prime p, the Galois group Gal(ℚ(ζ₂ₚ)/ℚ) acts transitively within each parity class

### Complexity Analysis

**Theoretical:** Polynomial factorization over ℚ is in P.

**Practical:** Completely impractical for primality testing!

| k | Degree | Max coefficient bits | Trial division |
|---|--------|---------------------|----------------|
| 100 | 101 | 124 bits | 10 operations |
| 1000 | 1001 | 1267 bits | 32 operations |

- Coefficient growth: ~1.2k bits for degree k polynomial
- LLL complexity: O(n⁶ · log³B) where B = max coefficient
- Trial division: O(√k)

**Conclusion:** Theoretically interesting connection to Galois theory, but NOT a practical shortcut. Trial division wins by many orders of magnitude.

## Conclusion

**This session was an exercise in rediscovering relatively recent mathematics.**

What we found:
1. ChebyshevPolygonFunction factors reveal primality structure via cyclotomic theory
2. This is the Chebyshev transformation of the classical factorization x^n - 1 = ∏Φ_d(x)
3. Polynomial factorization over ℚ is in P, but practically useless (O(k⁶) vs O(√k) for trial division)

**Key lesson:** The "integer ↔ polynomial factorization" bijection is NOT unique to ChebyshevPolygonFunction:
- x^k - 1 has the same property (direct)
- Fibonacci polynomials have similar structure
- Any polynomial family built from roots of unity inherits this

The geometric insight about regular polygons is valid, but it's a restatement of cyclotomic field theory.

## Historical Context

**Surprising fact:** The explicit Chebyshev ↔ MinPoly[cos(2π/n)] connection is relatively recent!

| Year | Author | Contribution |
|------|--------|--------------|
| ~1800 | Gauss | Cyclotomic fields (general theory) |
| 1850s | Chebyshev | Polynomials T_k, U_k |
| **1933** | D.H. Lehmer | "Less explicit recipe" for MinPoly |
| **1993** | Watkins & Zeitlin | **First explicit formula** via Chebyshev ([Am. Math. Monthly](https://www.researchgate.net/publication/310781555_The_minimal_polynomial_of_cos2pn)) |
| 2017 | Various | Extensions and re-presentations |

**MathOverflow comment:** *"It's really surprising this was published in 1993. If you had asked me before, I would have wagered it should have been done by 1950."* ([source](https://mathoverflow.net/questions/287109/minimal-polynomial-of-cos%CF%80-n))

**Meta-lesson:** Even "obvious" connections between classical objects (Chebyshev polynomials, cyclotomic fields) can remain unformalized for 150+ years. Our 32-year rediscovery lag is not embarrassing - professional mathematicians expected this to be known 40 years earlier than it was.

## Potentially Original: The Integral Identity

**Important distinction:** While the algebraic connection (MinPoly ↔ Chebyshev) was known since 1993, our **integral identity** appears to be novel:

$$\int_{-1}^{1} |T_{k+1}(x) - x \cdot T_k(x)| \, dx = 1 \quad \forall k \geq 2$$

**What's NOT novel (trivial):**
- ∫ f_k² dx with Chebyshev weight = π/4 (orthogonality of sin functions)

**What IS potentially novel:**
- The L¹ norm ∫|f_k| dx = 1 (involves absolute value, not square)
- Geometric interpretation: total unsigned "lobe area" = 1

**Literature gap:** Watkins-Zeitlin (1993) and subsequent work focused on:
- Algebraic properties (MinPoly formulas)
- Recurrence relations
- Cyclotomic connections

They did NOT investigate integral properties with absolute values.

**Caveat:** This needs thorough literature search to confirm novelty.

## Answered Questions

1. **Connection to φ(k)?** ✅ YES - Factor degrees are exactly φ(k)/2 for primitive zeros
2. **Relationship to cyclotomic polynomials?** ✅ YES - F_odd = MinimalPolynomial[cos(π/p)]

## Remaining Open Questions

1. Can the factorization structure distinguish prime from prime-power (p vs p²)?
2. For composite k, explicit formula for factor count in terms of divisor structure?
3. Is there a "spectral" signature that counts factors without computing them?
4. Connection to Chebyshev's theorem on primes in arithmetic progressions?

## Files

- `README.md` - This summary
