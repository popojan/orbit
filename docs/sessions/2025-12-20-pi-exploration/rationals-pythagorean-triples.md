# Rationals as Pythagorean Differences

Every rational number is a single subtraction from a Pythagorean triple.

## Quick Reference

**Given p/r → Triple:**
```
a = r² - p²
b = 2pr
c = r² + p²
```

**Given triple → Rational:**
```
p/r = (c - a)/b
```

**Bijection:** Rationals with opposite-parity (p,r) ↔ Primitive Pythagorean triples

**Note:** The bijection between rationals and Pythagorean triples is classical (Euclid, Diophantus). However, the explicit formula **p/r = (c-a)/b** — that every rational equals hypotenuse minus leg, divided by the other leg — appears to be a less commonly noted formulation. Standard references discuss the unit circle correspondence and slope parametrization, but rarely phrase it this directly.

---

## The Identity

For any rational **p/r** (with r > p > 0):

$$\frac{p}{r} = \frac{c - a}{b}$$

where **(a, b, c)** is the Pythagorean triple:

- a = r² - p²
- b = 2pr
- c = r² + p²

## Proof

**Claim:** Every rational p/r (with 0 < p < r) equals (c-a)/b for some Pythagorean triple.

**Proof:**

1. Define a = r² - p², b = 2pr, c = r² + p²

2. Verify it's Pythagorean:
   - a² + b² = (r² - p²)² + (2pr)² = r⁴ - 2p²r² + p⁴ + 4p²r² = (r² + p²)² = c² ✓

3. Compute (c - a)/b:
   - c - a = (r² + p²) - (r² - p²) = 2p²
   - (c - a)/b = 2p² / 2pr = p/r ✓

**QED**

The converse (every primitive triple gives a rational) follows from the same algebra run backwards.

## Examples

| p/r | Triple (a, b, c) | (c - a)/b |
|-----|------------------|-----------|
| 1/2 | (3, 4, 5) | (5 - 3)/4 = 1/2 |
| 1/3 | (8, 6, 10) → (4, 3, 5) | (5 - 4)/3 = 1/3 |
| 2/3 | (5, 12, 13) | (13 - 5)/12 = 2/3 |
| 3/4 | (7, 24, 25) | (25 - 7)/24 = 3/4 |
| 1/7 | (48, 14, 50) → (24, 7, 25) | (25 - 24)/7 = 1/7 |

## The Chain of Trivialities

We arrived at this through an unexpected path:

```
Egyptian fractions: q = 1/n₁ + 1/n₂ + ...
           ↓
Sqrt interval widths: 1/n = width of SqrtInterval[n² - 1, 1]
           ↓
Trivial Pell: x² - (n²-1)y² = 1 has solution (n, 1)
           ↓
Difference of squares: n² - 1 = (n-1)(n+1)
           ↓
Pythagorean parametrization: a = m² - n², b = 2mn, c = m² + n²
           ↓
Single subtraction: p/r = (c - a)/b
```

**The entire Egyptian fraction machinery collapses to one subtraction.**

## Why It Works

The formula (c - a)/b simplifies:

$$\frac{c - a}{b} = \frac{(r^2 + p^2) - (r^2 - p^2)}{2pr} = \frac{2p^2}{2pr} = \frac{p}{r}$$

This is algebraically trivial, but the connection to:

- Pell equations (trivial solutions when d = n² - 1)
- Sqrt interval bounds
- Egyptian fractions
- The harmonic series

...was not obvious until we traced through the structure.

## The Bijection

**Primitive triples ↔ Rationals with opposite parity:**

| p/r | p,r parity | Triple | Primitive? |
|-----|------------|--------|------------|
| 1/2 | opposite | (3, 4, 5) | ✓ |
| 1/3 | same | (8, 6, 10) | ✗ (gcd=2) |
| 2/3 | opposite | (5, 12, 13) | ✓ |
| 3/4 | opposite | (7, 24, 25) | ✓ |
| 1/5 | same | (24, 10, 26) | ✗ (gcd=2) |
| 2/5 | opposite | (21, 20, 29) | ✓ |

**Bijection condition:** gcd(p, r) = 1 AND p ≢ r (mod 2)

When p, r have the **same parity**, the triple has gcd = 2 (not primitive).

## Why Not Use Triples as Main Representation?

Despite every rational having "its" triangle, p/r wins:

| Aspect | p/r | (a, b, c) |
|--------|-----|-----------|
| Storage | 2 integers | 3 integers (each ~r²) |
| Addition | (p₁r₂ + p₂r₁)/(r₁r₂) | No closed form |
| Multiplication | (p₁p₂)/(r₁r₂) | No closed form |
| Comparison | p₁r₂ vs p₂r₁ | Must extract p, r |

**Triples encode geometry; p/r encodes arithmetic.**

## The Polar Insight

p/r = tan(θ/2) where θ is the angle on the unit circle.

So **p/r already IS a polar representation** - the half-angle tangent (stereographic parameter). Storing θ directly would be transcendental and lose exactness.

## Connection to Unit Circle

This is the classical **stereographic projection**:

- Pythagorean triple (a, b, c) → rational point (a/c, b/c) on unit circle
- Line from (-1, 0) with rational slope → rational point on circle
- Every rational corresponds to exactly one primitive triple (up to scaling)

Known since antiquity (Euclid, Diophantus, possibly Babylonians).

## The Harmonic Series Connection

The unit fractions 1/n arise from **trivial Pell solutions**:

| n | d = n² - 1 | Pell solution | SqrtInterval width |
|---|------------|---------------|-------------------|
| 2 | 3 | (2, 1) | 1/2 |
| 3 | 8 | (3, 1) | 1/3 |
| 4 | 15 | (4, 1) | 1/4 |
| 5 | 24 | (5, 1) | 1/5 |

The harmonic series 1/2 + 1/3 + 1/4 + ... = sum of trivial Pell widths.

For d = n² - 1:

- Pell equation x² - dy² = 1 has obvious solution (n, 1)
- SqrtInterval[d, 1] = [(n² - 1)/n, n]
- Width = n - (n² - 1)/n = 1/n

## Summary

| Object | Reduces To |
|--------|------------|
| Harmonic series terms 1/n | Trivial Pell solutions (n, 1) |
| Trivial Pell d = n² - 1 | Difference of squares |
| Egyptian fraction sum | Unnecessary (single subtraction suffices) |
| Any rational p/r | Pythagorean triple (r²-p², 2pr, r²+p²) |
| Pythagorean triples | Rational points on unit circle |

**Everything reduces to: (a - b)(a + b) = a² - b²**

## Historical References

### Euclid's Elements, Book X, Lemma 1 to Proposition 29 (~300 BCE)

Euclid gives the parametrization: (a, b, c) = (m² − n², 2mn, m² + n²)

> "Lemma 1 to Proposition 29 gives Euclid's formula for producing all fundamental Pythagorean triples."

This is the earliest known complete characterization of Pythagorean triples.

- [Euclid's Elements Book X Prop. 29](http://aleph0.clarku.edu/~djoyce/elements/bookX/propX29.html) (Clark University, D.E. Joyce)

### Diophantus, Arithmetica, Book II, Problem 8 (~250 CE)

Diophantus solves: "To divide a square into a sum of two squares."

His method: intersect circle x² + y² = a² with line y = tx − a, giving rational point (x₀, y₀). This is exactly the **stereographic projection** that connects rationals to Pythagorean triples.

Example: Divide 16 into two squares → 256/25 + 144/25 = 16

*Historical note:* Fermat wrote his famous "Last Theorem" marginal note next to this very problem.

- [Diophantus II.VIII - Wikipedia](https://en.wikipedia.org/wiki/Diophantus_II.VIII)
- [Diophantus II 8-10](https://web.calstatela.edu/faculty/hmendel/Ancient%20Mathematics/Diophantus/Arithmetica/Diophantus.II.8-10.html) (Cal State LA)

### Babylonians, Plimpton 322 (~1800 BCE)

The tablet Plimpton 322 shows Babylonians could construct Pythagorean triples, possibly using a method equivalent to the parametrization.

## Modern References

- [Pythagorean triple - Wikipedia](https://en.wikipedia.org/wiki/Pythagorean_triple)
- [Keith Conrad - Pythagorean Triples](https://kconrad.math.uconn.edu/blurbs/ugradnumthy/pythagtriple.pdf) (UConn)
- [UBC - Parametrization of Pythagorean triples](https://personal.math.ubc.ca/~cass/courses/m446-03/pl322/parametrization.html)

## Limit Triangles for Irrationals

For irrational α with convergents p_n/r_n → α, each convergent gives a triangle:

```
p_n/r_n → (r_n² - p_n², 2p_n r_n, r_n² + p_n²)
```

**What diverges:** Side lengths → ∞

**What converges:** The angle and shape ratios

| Quantity | Limit |
|----------|-------|
| a/c | (1 - α²)/(1 + α²) = cos(θ) |
| b/c | 2α/(1 + α²) = sin(θ) |
| Angle | θ = 2 arctan(α) |

The **angle θ is the invariant** that survives in the limit.

### Calculating All Three Angles

For irrational α, the limit right triangle has angles:

| Angle | Radians | Degrees | t-measure |
|-------|---------|---------|-----------|
| Right angle | π/2 | 90° | 1 |
| Opposite "b" | 2 arctan(α) | — | α |
| Opposite "a" | π/2 - 2 arctan(α) | — | (1-α)/(1+α) |

**Why (1-α)/(1+α)?** The complement formula in t-measure:

```
t(90° - θ) = tan(π/4 - θ/2) = (1 - tan(θ/2))/(1 + tan(θ/2)) = (1 - α)/(1 + α)
```

This is the Möbius involution γ(x) = (1-x)/(1+x) — it swaps complementary angles.

### Special Irrationals

| α | θ (degrees) | 90°-θ | t-complement (1-α)/(1+α) |
|---|-------------|-------|--------------------------|
| √2 - 1 ≈ 0.414 | **45.00°** | **45.00°** | √2 - 1 ≈ 0.414 (self-complementary!) |
| 1/φ ≈ 0.618 | 63.43° | 26.57° | √5 - 2 ≈ 0.236 |
| 1/e ≈ 0.368 | 40.40° | 49.60° | (e-1)/(e+1) ≈ 0.462 |
| 1/π ≈ 0.318 | 35.31° | 54.69° | (π-1)/(π+1) ≈ 0.518 |

**Note:** √2 - 1 is a fixed point of γ(x) = (1-x)/(1+x), hence the 45-45-90 isoceles right triangle.

### Connection to Weierstrass Substitution

The Pythagorean triple parametrization IS the Weierstrass substitution:

```
t = tan(θ/2) = p/r

cos(θ) = (1 - t²)/(1 + t²) = a/c
sin(θ) = 2t/(1 + t²) = b/c
```

For rationals: t = p/r gives a finite triangle.
For irrationals: t = α gives the "limit triangle" — infinite sides, finite angle.

## The Rational Angle Measure

Using **t = tan(θ/2)** as the angle measure instead of radians:

| Property | Radians | t-measure |
|----------|---------|-----------|
| Right angle | π/2 ≈ 1.571 | **1** (exact!) |
| Full circle | 2π ≈ 6.283 | ℝ ∪ {∞} |
| 30° | π/6 | 2 - √3 (irrational) |
| 45° | π/4 | √2 - 1 (irrational) |
| 53.13° (3-4-5) | ugly | **1/2** (rational!) |
| 36.87° (3-4-5) | ugly | **1/3** (rational!) |

**The inversion:** Traditional "nice" angles (30°, 45°, 60°) become irrational. Pythagorean angles become the rational, "nice" ones.

This is **π-free trigonometry**:

- No transcendental constants needed
- Rationals ↔ Pythagorean triangles
- Irrationals ↔ non-Pythagorean points on circle

Related: Wildberger's rational trigonometry uses spread s = sin²(θ). Our t = tan(θ/2) is the stereographic version.

### Historical Note: The t-measure Algebra

The t = tan(θ/2) substitution has a long history:

| Period | Contributor | Contribution |
|--------|-------------|--------------|
| ~150 BCE | Hipparchus | Half-angle relations in chord tables |
| ~150 CE | Ptolemy | Refined in the Almagest |
| 1768 | Euler | Used to evaluate ∫dx/(a + b cos x) |
| 1817 | Legendre | Described general method |
| 1818 | Gauss | Credited by Weierstrass with the idea |
| ~1875 | Weierstrass | Popularized in integral calculus lectures |

The substitution is known by many names:

- **Weierstrass substitution** (common in the West, though historically dubious)
- **Universal trigonometric substitution** (Russia)
- **Half-tangent** or **semi-tangent** (17th century)
- **"World's sneakiest substitution"** (Michael Spivak)

The connection to Pythagorean triples via stereographic projection is equally ancient — known to Euclid (Book X) and Diophantus (Arithmetica II.8), with possible Babylonian origins (Plimpton 322, ~1800 BCE).

**References:**

- [Tangent half-angle substitution - Wikipedia](https://en.wikipedia.org/wiki/Tangent_half-angle_substitution)
- [Pythagorean triple - Wikipedia](https://en.wikipedia.org/wiki/Pythagorean_triple)
- [UBC - Pythagorean triples and rational points](https://secure.math.ubc.ca/~cass/courses/m446-03/pl322/triples.html)

### Conversion to Radians

In t-measure, angle operations are algebraic:

- Addition of angles: t₁ ⊕ t₂ = (t₁ + t₂)/(1 - t₁t₂)
- Complement: (1 - t)/(1 + t)
- Double angle: 2t/(1 - t²)
- cos(θ), sin(θ): rational functions of t

Converting to radians requires the Gregory-Leibniz series:

$$\theta = 2 \arctan(\alpha) = 2\left(\alpha - \frac{\alpha^3}{3} + \frac{\alpha^5}{5} - \frac{\alpha^7}{7} + \cdots\right)$$

At α = 1 (right angle):

$$\frac{\pi}{2} = 2\left(1 - \frac{1}{3} + \frac{1}{5} - \frac{1}{7} + \cdots\right)$$

This series connects the t-measure to traditional radians.

### Implementation: CircFunctions Package

Our `Orbit` package implements a **generalization** of the t-measure algebra in `CircFunctions.wl`.

The key insight: **t-measure is specific to L^∞ geometry (the square)**. We implement a more general γ-algebra that works for any Lᵖ geometry:

| Package | Parametrizes | Works for |
|---------|--------------|-----------|
| γ-algebra (CircFunctions) | Universal angle | Any Lᵖ (circle, diamond, square...) |
| t-measure | tan(θ/2) | Only L^∞ (square) |

**Usage:**

```mathematica
<< Orbit`

(* γ stays symbolic - no coordinates yet *)
t = ρ[12, 1];                    (* 30° angle *)
doubled = CircTimes[t, t];        (* angle addition → 60° *)

(* Choose your geometry at evaluation time: *)
κ[t, 2]    (* → circle point: {cos, sin} *)
κ[t, 1]    (* → diamond point: taxicab *)
κ[t, ∞]    (* → square point: {±1, tan(θ)} ← t-measure! *)
```

**The t-measure emerges automatically** when you evaluate γ-algebra with κ[..., ∞]:

```mathematica
α[κ[ρ[2n, 1], ∞]] = {1, Tan[π/n]} = {1, tan(θ/2)}
```

This connects:
- **Weierstrass substitution** (classical analysis)
- **Minkowski L^∞ geometry** (the unit square)
- **Rational circle algebra** (our γ-parametrization)

All three are the same structure viewed from different angles. The γ-algebra is "coordinate-free" until you choose p — staying in the rational world as long as possible.

## See Also

- `rational-interval-bounds.md` - Unit fraction interval widths for π, e, φ, √n (this session)
- `Orbit/Kernel/SquareRootRationalizations.wl` - SqrtInterval implementation
- `Orbit/Kernel/CircFunctions.wl` - γ-algebra and Lᵖ geometry
