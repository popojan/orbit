# Pi Exploration: Interval Bounds and Iteration Methods

**Session:** 2025-12-20
**Status:** Open

## Context

Following successful exploration of:
- **√n**: Egypt/Chebyshev methods, Babylonian algorithm
- **e**: Bessel polynomials, CF structure, Stern-Brocot tree, Mediant bounds

Now exploring **π** with similar goals:
1. Rational interval bounds (like EulerEInterval)
2. Monotone convergence formulas
3. Self-referential iterations (like Babylonian for √, Newton for e)
4. Connections to known series/algorithms

---

## Known Approaches for π

### 1. Continued Fraction
$$\pi = 3 + \cfrac{1}{7 + \cfrac{1}{15 + \cfrac{1}{1 + \cfrac{1}{292 + \cdots}}}}$$

CF of π is **irregular** (unlike e which has pattern [2; 1, 2k, 1]).

First terms: [3; 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, ...]

### 2. Machin-type Formulas
$$\frac{\pi}{4} = 4\arctan\frac{1}{5} - \arctan\frac{1}{239}$$

Uses arctangent series: $\arctan(x) = x - x^3/3 + x^5/5 - \cdots$

### 3. Ramanujan/Chudnovsky Series
$$\frac{1}{\pi} = \frac{12}{640320^{3/2}} \sum_{k=0}^{\infty} \frac{(-1)^k (6k)! (545140134k + 13591409)}{(3k)!(k!)^3 640320^{3k}}$$

~14 digits per term (fastest known series).

### 4. BBP Formula (Bailey-Borwein-Plouffe)
$$\pi = \sum_{k=0}^{\infty} \frac{1}{16^k} \left( \frac{4}{8k+1} - \frac{2}{8k+4} - \frac{1}{8k+5} - \frac{1}{8k+6} \right)$$

Allows computing hex digits of π without prior digits.

### 5. Gauss AGM (Arithmetic-Geometric Mean)
$$\pi = \frac{4 \cdot \text{AGM}(1, 1/\sqrt{2})^2}{1 - \sum_{j=1}^{\infty} 2^{j+1}(a_j^2 - b_j^2)}$$

Quadratic convergence (~doubles digits each iteration).

### 6. Wallis Product
$$\frac{\pi}{2} = \prod_{n=1}^{\infty} \frac{4n^2}{4n^2 - 1} = \frac{2}{1} \cdot \frac{2}{3} \cdot \frac{4}{3} \cdot \frac{4}{5} \cdot \frac{6}{5} \cdot \frac{6}{7} \cdots$$

Slow convergence, but elegant.

### 7. Viète's Formula
$$\frac{2}{\pi} = \frac{\sqrt{2}}{2} \cdot \frac{\sqrt{2 + \sqrt{2}}}{2} \cdot \frac{\sqrt{2 + \sqrt{2 + \sqrt{2}}}}{2} \cdots$$

Nested radicals.

---

## Research Questions

1. **Can we find monotone rational bounds for π like EulerEIntervalMediant?**
   - CF convergents alternate around π
   - Mediant approach should work similarly

2. **Is there a "Bessel polynomial" analog for π?**
   - e has y_n(2)/s_n → e
   - What gives π?

3. **Self-referential iteration for π?**
   - For e: x(2 - ln x) → e
   - For π: Newton on sin(x) = 0 gives x - tan(x) → nπ
   - Or: x - (sin x)/cos x = x - tan x

4. **Stern-Brocot path for π?**
   - π = [3; 7, 15, 1, 292, ...] encodes SB path
   - No simple pattern like e's triads

---

## Session Log

### 1. Minkowski Geometry Intuition

**Idea:** Start from π = 4 (L¹/L∞ value) and "correct" toward Euclidean π.

In Lᵖ geometry, π is the ratio of circumference to diameter of the unit ball:

- **L¹ (Manhattan):** π₁ = 4 (diamond: perimeter = 8, diameter = 2)
- **L² (Euclidean):** π₂ = π ≈ 3.14159
- **L∞ (Chebyshev):** π∞ = 4 (square: perimeter = 8, diameter = 2)

Key insight: L¹ and L∞ are **dual**, both giving π = 4. L² is **self-dual**, giving the transcendental π.

BBP formula rewrite:
$$\pi = 4 - \frac{1}{2} - \frac{1}{5} - \frac{1}{6} + \text{(higher corrections)}$$
$$= \frac{47}{15} + \cdots \approx 3.133... + \cdots$$

### 2. CF Convergents and Mediant Bounds

CF(π) = [3; 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, ...]

**Convergents alternate around π:**

| Index | Convergent | Decimal | Direction |
|-------|-----------|---------|-----------|
| 0 | 3 | 3.0 | below |
| 1 | 22/7 | 3.1428... | above |
| 2 | 333/106 | 3.1415... | below |
| 3 | 355/113 | 3.14159292... | above |
| 4 | 103993/33102 | 3.1415926530... | below |
| 5 | 104348/33215 | 3.1415926539... | above |

**Mediant improvement (vs interval width):**

| k | Interval | Mediant | Improvement |
|---|----------|---------|-------------|
| 1 | [333/106, 22/7] | **355/113** (Zu Chongzhi!) | 2526× |
| 2 | [103993/33102, 355/113] | 104348/33215 | 403× |
| 3 | [208341/66317, 104348/33215] | 312689/99532 | 7.8× |
| 4 | [833719/265381, 312689/99532] | 1146408/364913 | 11.8× |
| 5 | [4272943/1360120, 1146408/364913] | 5419351/1725033 | 45× |

**Key observation:** Unlike e (consistent 10-40× improvement), π shows **highly variable** improvement due to irregular CF. The k=1 case is exceptional because mediant(333/106, 22/7) = 355/113, one of history's best rational approximations to π.

### 3. Comparison: e vs π

| Property | e | π |
|----------|---|---|
| CF pattern | Regular [2; 1,2k,1] | Irregular |
| Mediant improvement | 10-40× (consistent) | 7-2500× (variable) |
| Bessel connection | y_{n+1}(2)/sₙ | None known |
| Self-iteration | x(2 - ln x) | Newton on sin(x)=0 |
| Stern-Brocot | Triads R²(LR^{2k}L)* | No simple pattern |
| Interval width | 2/(qₙqₙ₊₃) | 1/(qₙqₙ₊₁) standard CF |

### 4. Special Functions and π

**Gamma/Beta:**

- Γ(1/2) = √π
- B(1/2, 1/2) = π

**Elliptic integrals:**

- K(0) = π/2 (complete elliptic integral of first kind)

**Bessel zeros:**

- j₀,ₙ₊₁ - j₀,ₙ → π as n → ∞
- Asymptotic: j₀,ₙ ~ (n - 1/4)π
- Error: O(1/n) — slow convergence

**Hypergeometric:**

- ₂F₁(1/2, 1/2; 3/2; 1) = π/2
- Partial sums converge slowly

### 5. Fast Series Comparison

| Series | Digits/term | Notes |
|--------|-------------|-------|
| Leibniz | ~0.3 | 1 - 1/3 + 1/5 - ... |
| Machin | ~1.4 | 4·arctan(1/5) - arctan(1/239) |
| BBP | ~1.2 hex | Computes hex digits independently |
| Bellard | ~3 | Faster BBP variant |
| **Chudnovsky** | **~14** | Fastest known series |
| AGM | doubles | Quadratic convergence |

### 6. Why π is "Harder" than e

1. **Irregular CF**: e has predictable triadic pattern [1,2k,1]; π has no pattern
2. **No polynomial structure**: e comes from Bessel polynomials evaluated at 2; π has no known analog
3. **Transcendence type**: Both are transcendental, but π appears in more "geometric" contexts (circles, spheres) while e appears in "growth" contexts (exponentials, logarithms)
4. **Interval bounds**: For e, EulerEInterval uses every 3rd CF convergent with width = 2/...; for π, must use consecutive convergents

### 7. Self-Referential Iterations

**Newton for π** (on sin(x) = 0):
$$x_{n+1} = x_n - \tan(x_n)$$

From x₀ = 3: 1 → 3 → 10 → 29 digits (quadratic convergence)
From x₀ = 22/7: 3 → 9 → 28 digits

**Gauss-Legendre** (AGM-based):
$$a_{n+1} = \frac{a_n + b_n}{2}, \quad b_{n+1} = \sqrt{a_n b_n}$$
$$\pi = \frac{4 \cdot \text{AGM}(1, 1/\sqrt{2})^2}{1 - \sum 2^{j+1}(a_j^2 - b_j^2)}$$

Quadratic convergence: 1 → 4 → 10 → 20 → 42 digits

| Iteration | Convergence | Requires |
|-----------|-------------|----------|
| Newton (tan) | Quadratic | tan(x) |
| Gauss-Legendre | Quadratic | √ |
| Borwein cubic | Cubic | ∛ |
| **Bessel (for e)** | **Linear** | **Pure algebra** |

**Key difference:** For e, Bessel polynomial recurrence is purely algebraic. For π, all fast iterations require transcendental/algebraic operations (sin, tan, √, ∛).

### 8. Heegner Numbers and Chudnovsky

**Heegner numbers** d where ℚ(√-d) has class number 1:
$$\{1, 2, 3, 7, 11, 19, 43, 67, 163\}$$

**Ramanujan's "almost integers":**

| d | e^(π√d) ≈ | n | Error |
|---|-----------|---|-------|
| 43 | n³ + 744 | 960 | ~10⁻⁴ |
| 67 | n³ + 744 | 5280 | ~10⁻⁶ |
| 163 | n³ + 744 | 640320 | ~10⁻¹³ |

**Why 744?** From the j-invariant Fourier expansion:
$$j(\tau) = \frac{1}{q} + 744 + 196884q + 21493760q^2 + \cdots$$
where q = e^{2πiτ}.

- 744 = 3 × 248, where 248 = dim(E₈)
- 196884 = 1 + 196883, where 196883 = dim of smallest nontrivial Monster group representation
- This is **Monstrous Moonshine**!

**Chudnovsky formula** uses 640320 from j((1+√-163)/2) = -640320³:
$$\frac{1}{\pi} = \frac{12}{640320^{3/2}} \sum_{k=0}^{\infty} \frac{(-1)^k (6k)! (545140134k + 13591409)}{(3k)!(k!)^3 640320^{3k}}$$

**Connection to imaginary quadratic fields:**

- π appears via modular forms and CM (complex multiplication)
- Class number 1 fields give the cleanest formulas
- Larger Heegner numbers → faster convergence

---

## Notes: Connections (Not a Unified Theory)

**Observed connections** (standard results, not new):

- π = 4 × L(1, χ₄) — direct L-function expression
- √d relates to L(1, χ_d) via class number formula (but circular)
- e has NO direct L-function expression — comes from Bessel/exponential world

**Sign-cosine identity** (our paper): Geometric reformulation of class number, connects Chebyshev lobe geometry to h(-p). Pedagogically useful, not computationally faster.

**Honest assessment**: These are connections between known results, not a new unified theory. The constants come from different mathematical structures:

- π: L-functions, imaginary quadratic fields
- √d: Pell equation, real quadratic fields
- e: Bessel functions, exponential growth

---

## ✅ Main Result: Wallis Pi Interval Bounds

**Goal achieved:** Closed-form interval bounds for π **without computing CF expansion**.

### The Wallis Partial Product

Define the Wallis partial product:
$$W_n = \prod_{k=1}^{n} \frac{4k^2}{4k^2 - 1} = \frac{((2n)!!)^2}{(2n-1)!! \cdot (2n+1)!!}$$

**Closed form using central binomial:**
$$W_n = \frac{16^n}{(2n+1) \binom{2n}{n}^2}$$

### Interval Bounds

**Lower bound:**
$$L_n = 2W_n = \frac{2 \cdot 16^n}{(2n+1) \binom{2n}{n}^2}$$

**Upper bound:**
$$U_n = 2W_n \cdot \frac{4n+2}{4n+1} = \frac{2 \cdot 16^n \cdot (4n+2)}{(2n+1)(4n+1) \binom{2n}{n}^2}$$

**Width:**
$$U_n - L_n = \frac{2 \cdot 16^n}{(2n+1)(4n+1) \binom{2n}{n}^2} \sim \frac{\pi}{4n}$$

### Verification

| n | Lower | Upper | Width | π ∈ [L,U] |
|---|-------|-------|-------|-----------|
| 1 | 2.667 | 3.200 | 0.533 | ✓ |
| 2 | 2.844 | 3.160 | 0.316 | ✓ |
| 3 | 2.926 | 3.151 | 0.225 | ✓ |
| 4 | 2.972 | 3.147 | 0.175 | ✓ |
| 5 | 3.002 | 3.145 | 0.143 | ✓ |
| 10 | 3.068 | 3.143 | 0.075 | ✓ |

### Comparison with e

| Property | e (Bessel) | π (Wallis) |
|----------|-----------|------------|
| Lower bound | $\frac{y_{n+1}(2)}{s_{n+1}}$ | $\frac{2 \cdot 16^n}{(2n+1)C_{2n}^2}$ |
| Upper bound | $\frac{y_n(2)}{s_n}$ | $\frac{2 \cdot 16^n(4n+2)}{(2n+1)(4n+1)C_{2n}^2}$ |
| Width | $\frac{2}{s_n s_{n+1}}$ | $\frac{2 \cdot 16^n}{(2n+1)(4n+1)C_{2n}^2}$ |
| Convergence | **Exponential** (s_n grows ~exp) | O(1/n) |
| Operations | Pure algebra | Pure algebra |

**Key insight:** Both use purely algebraic closed forms (no CF computation needed), but e converges **exponentially faster** due to its regular CF structure. At n=10:

- π width ≈ 0.075
- e width ≈ 10⁻²⁰

### Alternative: Tighter bounds via (4n+2)/(4n+1) factor

The upper bound multiplier $(4n+2)/(4n+1)$ is the **tightest integer-form** upper bound. The exact threshold where $2W_n(1+1/k) = \pi$ is at $k \approx 4n + 1.5$, so:

- $k = 4n+1$ → valid upper bound ✓
- $k = 4n+2$ → invalid (below π) ✗

### Faster Alternative: Machin Partial Sums

Machin's formula $\frac{\pi}{4} = 4\arctan\frac{1}{5} - \arctan\frac{1}{239}$ gives alternating partial sums:

$$M_n = 4\left(4\sum_{k=0}^{n} \frac{(-1)^k}{(2k+1)5^{2k+1}} - \sum_{k=0}^{n} \frac{(-1)^k}{(2k+1)239^{2k+1}}\right)$$

| n | Even $M_n$ (upper) | Odd $M_n$ (lower) | Error |
|---|-------------------|-------------------|-------|
| 0 | 3.183 | — | ~0.04 |
| 1 | — | 3.1406 | ~0.001 |
| 2 | 3.14162 | — | ~3×10⁻⁵ |
| 5 | — | 3.14159265 | ~10⁻⁹ |
| 10 | 3.14159265358979... | — | ~10⁻¹⁷ |

**Trade-off:**

- Wallis: O(n) terms in closed form, O(1/n) convergence
- Machin: O(n) terms in series form, ~1.4 digits/term (~10^{-1.4n})

Machin wins for precision, but Wallis is a single closed-form expression.

### Best Result: BBP Interval Bounds

BBP partial sums are **monotonically increasing lower bounds**:

$$L_n = \sum_{k=0}^{n} \frac{1}{16^k} \left( \frac{4}{8k+1} - \frac{2}{8k+4} - \frac{1}{8k+5} - \frac{1}{8k+6} \right)$$

Upper bound via geometric tail:
$$U_n = L_n + \frac{4}{15 \cdot 16^{n+1}}$$

| n | Lower | Upper | Width | Digits |
|---|-------|-------|-------|--------|
| 0 | 3.133 | 3.150 | 0.017 | 1 |
| 2 | 3.14159 | 3.14165 | 6.5×10⁻⁵ | 4 |
| 5 | 3.141592653 | 3.141592669 | 1.6×10⁻⁸ | 7 |
| 8 | 3.14159265358975 | 3.14159265359363 | 3.9×10⁻¹² | 11 |

**Convergence: ~1.2 digits/term** (exponential, width = 4/(15·16^{n+1}))

### Summary: π Interval Methods

| Method | Convergence | Form | Best for |
|--------|------------|------|----------|
| Wallis | O(1/n) | Closed-form | Simplicity |
| Machin | ~1.4 digits/term | Series | Precision |
| **BBP** | **~1.2 digits/term** | **Series + tail** | **Interval bounds** |
| CF | Variable | Convergents | Best approximations |

---

## Philosophical Digression: Does the Continuum Exist?

**Question:** What if neither continuous physics nor real numbers exist, and we should work with rational approximations everywhere? Would this lead to contradictions?

### Arguments FOR a Discrete-Only World

1. **Rationals are dense in ℝ**: Any measurement has finite precision, so we only ever observe rationals. The "real" π is operationally indistinguishable from our interval bounds.

2. **Planck scale discreteness**: Time and space may be fundamentally discrete:
   - Planck time: t_P ≈ 5.4 × 10⁻⁴⁴ s
   - Planck length: l_P ≈ 1.6 × 10⁻³⁵ m
   - If these are the "pixels" of reality, the continuum is an approximation

3. **Computable numbers**: Only countably many numbers are computable. Most "reals" are inaccessible (can't be specified by any algorithm). Why assume they exist?

4. **Constructive mathematics**: Brouwer, Bishop, and others developed math without excluded middle or completed infinities. It works, just differently.

5. **Digital physics** (Zuse, Fredkin, Wolfram): The universe might be a cellular automaton. Continuous PDEs would be approximations to discrete update rules.

### Arguments AGAINST (Why Continuum Seems Necessary)

1. **Differential equations**: Physics uses ODEs/PDEs everywhere. Discrete approximations work, but the continuum formulation is simpler.

2. **Rotational symmetry**: A discrete lattice breaks rotation invariance. But we observe rotational symmetry in nature (atoms, orbits).

3. **Lorentz invariance**: Special relativity's continuous symmetry is hard to reconcile with a discrete substrate.

4. **Irrational ratios in nature**:
   - Golden ratio in phyllotaxis (but: Fibonacci approximations work)
   - π in circles (but: we showed interval bounds suffice)
   - √2 in diagonals (but: Babylonian iteration gives arbitrary precision)

5. **Measure theory**: Probability on ℝ needs Lebesgue measure. Discrete probability is different (no uniform distribution on ℕ).

### The Pragmatic Resolution

**No observable contradiction arises** from using only rationals, because:

1. Every measurement has error bars → interval arithmetic works
2. Every computation is finite → computable approximations suffice
3. Every physical theory is approximate → discrete simulations reproduce physics

**The question becomes metaphysical, not mathematical:**

- Does √2 "exist" independently of our approximations?
- Is π a completed object, or just the limit of our procedures?

**Time specifically**:
- Fastest oscillations: Planck frequency ω_P ≈ 1.9 × 10⁴³ Hz
- If time is "measured in Planck ticks", it's discrete
- But this doesn't change the math—just the interpretation

### Connection to Our Work

Our interval bounds (EulerEInterval, Wallis/BBP for π) are **exactly what a constructivist would use**:
- Never claim to "have" the irrational
- Only claim to bound it within rational intervals
- Arbitrarily narrow intervals ≈ "the limit exists" constructively

**Honest conclusion**: The continuum is a useful fiction that simplifies calculations. Whether it "really exists" may be undecidable—and for computation, it doesn't matter.

---

## Unit Fraction Widths: A Unified API

### Three Interval Functions

We now have a unified API for interval bounds on fundamental constants:

| Function | Constant | Width Formula | Unit Fraction? |
|----------|----------|---------------|----------------|
| `PiInterval[k]` | π | 1/(60 × 16^k) | **Always** ✓ |
| `EInterval[k]` | e | 1/D_k | **Always** ✓ |
| `SqrtInterval[n, k]` | √n | 1/D_{n,k} | When x is odd |

**Implementation:** All three are in `Orbit` package:
- `PiInterval` = alias for `PiIntervalBBP`
- `EInterval` = alias for `EulerEIntervalMediant`
- `SqrtInterval` = uses Pell solutions + EgyptSqrt

### Combining Intervals: Algebraic Properties

When combining intervals I₁ = [a, b] and I₂ = [c, d] (positive):

**Sum and Difference:**
- I₁ + I₂ = [a+c, b+d], width = (b-a) + (d-c)
- I₁ - I₂ = [a-d, b-c], width = (b-a) + (d-c)
- **Same width** (trivially: both = w₁ + w₂)

**Product and Quotient:**
- I₁ × I₂ = [ac, bd], width = bd - ac
- I₁ / I₂ = [a/d, b/c], width = (bd - ac)/(cd)
- **Same numerator** (bd - ac)

### Discovery: Why Product and Quotient Share Numerators

This is a **general property of interval arithmetic**, not specific to π and e:

$$\text{Product width} = bd - ac$$
$$\text{Quotient width} = \frac{bd - ac}{cd}$$

The numerator `bd - ac` appears in both. This explains why we observed:

```
k=1: Pi×E num = 575635, Pi/E num = 575635 ✓
k=2: Pi×E num = 23962596596837, Pi/E num = 23962596596837 ✓
```

### Width Numerator Factorizations

| k | Pi×E numerator | Factorization |
|---|----------------|---------------|
| 1 | 575,635 | 5 × 115127 |
| 2 | 23,962,596,596,837 | prime |
| 3 | 1,128,017,326,578,388,704,197 | 89 × 274471 × 46177381158763 |
| 4 | (30 digits) | 555143 × (24-digit prime) |

**Observation:** Numerators are mostly prime or semiprime—no obvious factorial or power structure. The unit fraction property is NOT preserved under multiplication.

### Error Propagation

Relative errors follow standard propagation rules:
- Product: rel_err(I₁×I₂) ≈ rel_err(I₁) + rel_err(I₂)
- Sum: rel_err(I₁+I₂) < rel_err(product) (because sum is smaller than product)

For k=2:
- π relative error: 2.1 × 10⁻⁵
- e relative error: 2.1 × 10⁻⁹ (much smaller due to faster CF convergence)
- π×e relative error: 2.1 × 10⁻⁵ (dominated by π)

**Conclusion:** The e bounds are so tight that for practical purposes, `Pi×E` precision is limited by the π interval alone.

