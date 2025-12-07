# Circ Function Exploration: Hartley Connection

**Date:** December 7, 2025
**Status:** Exploration complete

> **Note:** This document explores a notational framework that unifies sin/cos. All mathematics here is well-known; the contribution is pedagogical perspective. The Circ parametrization is equivalent to the Hartley cas function (1942).

## Summary

This session explored the Circ function framework:
- **Circ[t] = Cos[3π/4 + πt]** - unifies sin and cos via t ↔ -t symmetry
- **Key observation:** Circ is equivalent to the Hartley cas function (1942)

## Main Findings

### 1. Hartley Connection (Rediscovery)

The Circ function independently arrives at the same idea as Hartley (1942):

$$\text{Circ}(t) = -\frac{1}{\sqrt{2}} \cdot \text{cas}(\pi t)$$

where **cas(x) = cos(x) + sin(x)** is the Hartley function.

**Key insight:** Both cas and Circ have the "diagonal" phase where |cos φ| = |sin φ| = 1/√2:
- cas(x) = √2 · cos(x - π/4)
- Circ(t) = cos(3π/4 + πt)

The difference (π) is just a sign flip. **Same geometry, different notation.**

### 2. Why Two Trig Functions Exist

| Aspect | sin/cos | Circ/cas | Winner |
|--------|---------|----------|--------|
| Taylor series | clean parity | mixed | sin/cos |
| Derivative | 2-function cycle | shift | **Circ** |
| Fourier | 2 functions | 2 values (±t) | tie |
| Conceptual | established | unified | Circ? |

**Bottom line:** The "two-ness" doesn't disappear - it relocates from {sin, cos} to {t, -t}.

### 3. Trajectory vs Coordinates Perspective

**Standard view:**
- Circle = 2D object
- Description: (x, y) = (cos θ, sin θ) — two independent coordinates

**Alternative view (Circ perspective):**
- Circle = 1D trajectory with t ↔ -t symmetry
- Description: {Circ[t], Circ[-t]} — "twin particles" going opposite directions

The pair satisfies Circ[t]² + Circ[-t]² = 1 — the twins are **complementary**, not independent.

### 4. Why cas/Hartley Didn't Catch On

The Fast Fourier Transform (FFT, Cooley-Tukey 1965) became dominant before Hartley gained traction:
- Complex FFT optimizations were already mature
- Specialized real-FFT algorithms are only marginally less efficient than DHT
- Existing infrastructure favored complex Fourier

### 5. Prosthaphaeresis vs t ↔ -t Decomposition

Two ways to express sin(y)cos(x) as a sum:

**Standard prosthaphaeresis:**
$$\sin(y)\cos(x) = \frac{\sin(x+y) + \sin(y-x)}{2}$$
- 2 terms
- Shows: angle addition

**Circ decomposition (via t ↔ -t symmetry):**
$$\sin(\pi v) = -\frac{\text{Circ}[v] - \text{Circ}[-v]}{\sqrt{2}} \quad \text{(antisymmetric)}$$
$$\cos(\pi u) = -\frac{\text{Circ}[u] + \text{Circ}[-u]}{\sqrt{2}} \quad \text{(symmetric)}$$

Their product expands to 4 Circ values on the grid {±u, ±v}.

| Approach | Terms | Shows |
|----------|-------|-------|
| Prosthaphaeresis | 2 | Angles compose |
| Circ t↔-t | 4 | sin/cos are twins |

**Pedagogical value:** The Circ approach isn't computationally simpler, but it reveals *why* sin and cos are related — they're the antisymmetric and symmetric parts of the same function under reflection.

### 6. Deep Identities in Circ Framework

All major trigonometric identities share a common theme in Circ: **symmetric/antisymmetric decomposition under t → -t**.

#### Tangent as Symmetric Quotient
$$\tan(\pi t) = \frac{\text{Circ}[t] - \text{Circ}[-t]}{\text{Circ}[t] + \text{Circ}[-t]} = \frac{\text{antisym}}{\text{sym}}$$

#### De Moivre / Complex Exponential
Define the "complex Circ":
$$Z[t] := \text{Circ}[t] - i \cdot \text{Circ}[-t]$$

Then:
$$e^{i\pi t} = -e^{i\pi/4} \cdot Z[t]$$

**De Moivre theorem:**
$$Z[t]^n = (-1)^{n-1} \cdot e^{i\pi(1-n)/4} \cdot Z[nt]$$

The "complex Circ" Z[t] behaves like an exponential — powers correspond to argument multiplication!

#### Weierstrass Substitution
$$C_+ = \text{Circ}[t/2] + \text{Circ}[-t/2] \quad \text{(sym at t/2)}$$
$$C_- = \text{Circ}[t/2] - \text{Circ}[-t/2] \quad \text{(antisym at t/2)}$$

$$u = \tan(\pi t/2) = \frac{C_-}{C_+}$$

With: $C_+^2 + C_-^2 = 2$ and $C_+^2 - C_-^2 = 2\cos(\pi t)$

Weierstrass = antisym/sym ratio at **half** the angle.

#### Double Angle (bonus)
$$\text{Circ}[t]^2 - \text{Circ}[-t]^2 = \sin(2\pi t)$$
$$\text{Circ}[t] \cdot \text{Circ}[-t] = \frac{\cos(2\pi t)}{2}$$

### 7. Interpreting i as a Shift Operator

The imaginary unit i has a natural interpretation in the Circ framework (this is a standard perspective from geometric algebra).

**Key observation:** Multiplication by i on the unit circle (x,y) = (Circ[-t], Circ[t]) corresponds exactly to the parameter shift t → t + 1/2.

**Define:** S is the shift operator: S·Circ[t] = Circ[t + 1/2]

**Why S² = -1?** Circ has **antiperiod 1**:
$$\text{Circ}[t + 1] = -\text{Circ}[t]$$

Therefore:
$$S^2 \cdot \text{Circ}[t] = \text{Circ}[t + 1] = -\text{Circ}[t] \implies S^2 = -1$$

**Hierarchy of unification:**

| Standard | Circ framework |
|----------|----------------|
| sin(πt), cos(πt) | antisym/sym parts of Circ |
| i | shift operator S (shift by 1/2) |
| e^(iπt) | shift by t |
| complex z | (Circ[-t], Circ[t]) |

This provides a unified notation where everything is expressed via Circ and parameter shifts.

#### De Moivre Without i (Strictly Real)

**Definition:** P[t] := (Circ[-t], Circ[t]) — a pair of real numbers on the unit circle

**Multiplication (purely real):**
$$P[t_1] \otimes P[t_2] := P[t_1 + t_2 + \tfrac{5}{4}]$$

This is just addition of real parameters! No complex numbers involved.

**Powers:** P[t]^n means n-fold application of ⊗:
- P[t]² = P[t] ⊗ P[t] = P[2t + 5/4]
- P[t]³ = P[t] ⊗ P[t] ⊗ P[t] = P[3t + 5/2]

**Theorem (De Moivre, strictly real):**
$$P[t]^n = P\left[n \cdot t + \frac{5(n-1)}{4}\right]$$

**Proof:** By induction. P[t]^(n+1) = P[t]^n ⊗ P[t] = P[nt + 5(n-1)/4] ⊗ P[t] = P[nt + 5(n-1)/4 + t + 5/4] = P[(n+1)t + 5n/4]. ∎

**Special cases:**
- n = 2: P[t]² = P[2t + 5/4] (angle doubling)
- n = 3: P[t]³ = P[3t + 5/2] (angle tripling)
- n = -1: P[t]⁻¹ = P[-t - 5/2] (reflection)

**Where is i?** Nowhere in the formulas! The construction uses only:
1. Real pairs P[t] = (Circ[-t], Circ[t])
2. Real arithmetic: t₁ + t₂ + 5/4

#### Historical Note: Which Came First?

The relationship between complex numbers and real pairs is a matter of historical development, not mathematical priority:

**Algebraic origins (16th century Italy):**
- **Girolamo Cardano** (1501–1576): *Ars Magna* (1545) encountered √(−1) when solving cubics, but called such quantities "fictitious"
- **Raphael Bombelli** (1526–1572): First to state manipulation rules for complex numbers; proved that real solutions could emerge from "imaginary" intermediate values (famous example: x³ = 15x + 4)

**Geometric interpretation (late 18th–19th century):**
- **Caspar Wessel** (1745–1818): Danish-Norwegian cartographer, presented geometric interpretation in 1797 (published 1799), but work went unnoticed until 1895
- **Jean-Robert Argand** (1768–1822): Paris bookkeeper, published in 1806 at his own expense (name not even on cover!); his work became influential → hence "Argand diagram"
- **Carl Friedrich Gauss**: Independently introduced the geometric view in 1831, having earlier expressed doubts about "the true metaphysics of √(−1)"

**The philosophical question:** Is the Circ/real-pair formulation "more fundamental" than complex numbers, or just "differently expressed"? Historically, complex algebra came first; the geometric/rotational interpretation came later. The Circ framework makes the "angles add under multiplication" property explicit, but whether this is deeper or merely pedagogically clearer is a matter of perspective, not mathematics.

#### Where is π?

| Standard | Circ | Meaning |
|----------|------|---------|
| period 2π | period 2 | full circle |
| e^(iπ) = -1 | P[t+1] = -P[t] | half turn = negation |
| e^(2πi) = 1 | P[t+2] = P[t] | full turn = identity |

**Euler's identities (π-free):**
- P[t + 1/2] = S·P[t] (90° rotation)
- P[t + 1] = -P[t] (180° rotation)
- P[t + 2] = P[t] (360° rotation)

**Where is π?** Hidden in the definition: Circ[t] = Cos[3π/4 + πt]. All formulas are π-free because we measure angles in "half-turns" instead of radians.

#### The 5/4 Offset: Diagonal Duality

The multiplication offset 5/4 in P[t₁] ⊗ P[t₂] = P[t₁ + t₂ + 5/4] is **not arbitrary** — it's one of exactly **two** choices forced by the diagonal geometry.

**The four diagonal phases** (where |cos φ| = |sin φ| = 1/√2):

| Phase | Start point P[0] | Multiplication offset |
|-------|------------------|----------------------|
| π/4 | (+1/√2, +1/√2) | 7/4 |
| 3π/4 | (−1/√2, −1/√2) | 5/4 |
| 5π/4 | (−1/√2, −1/√2) | 5/4 |
| 7π/4 | (+1/√2, +1/√2) | 7/4 |

Phases differing by π give the same Circ up to sign, so there are exactly **two distinct choices**: offset 5/4 or 7/4.

**The duality:**

Define the two frameworks:
- **CircA[t]** = Cos[3π/4 + πt] → offset **5/4** (our choice)
- **CircB[t]** = Cos[π/4 + πt] → offset **7/4** (the alternative)

These are related by:
$$P_B[t] = -\text{Swap}(P_A[t])$$

where Swap(x, y) = (y, x). The two frameworks are **reflections** of each other across the diagonal y = x, then negated.

**The S-conjugate relationship:**

The offsets differ by exactly 1/2:
$$\frac{7}{4} - \frac{5}{4} = \frac{1}{2} = \text{quarter turn}$$

This is precisely the **shift operator S** (multiplication by i)! The two frameworks are **S-conjugates** of each other.

**Interpretation:**

| Framework | Diagonal | "Handedness" |
|-----------|----------|--------------|
| CircA (5/4) | negative (−1/√2, −1/√2) | "left-handed" |
| CircB (7/4) | positive (+1/√2, +1/√2) | "right-handed" |

Choosing one over the other is analogous to:
- Choosing +√2 over −√2
- Choosing +i over −i
- Choosing right-handed over left-handed coordinates

**What we lose by choosing 5/4:**

Nothing mathematically — the structures are isomorphic via S. But the choice breaks a symmetry. A fully symmetric treatment would track **both** frameworks simultaneously, recognizing them as S-conjugate twins.

**Why 5/4 was chosen:** It corresponds to phase 3π/4, which gives Circ[t] = −cas(πt)/√2, making the Hartley connection most direct.

#### Roots of Unity

The n-th roots of unity in Circ framework:

$$\omega_k = P\left[\frac{2k}{n} - \frac{5}{4}\right] \quad \text{for } k = 0, 1, \ldots, n-1$$

**Examples:**
| n | Roots (as t values) | Spacing |
|---|---------------------|---------|
| 2 | -5/4, -1/4 | 1 |
| 3 | -5/4, -7/12, 1/12 | 2/3 |
| 4 | -5/4, -3/4, -1/4, 1/4 | 1/2 |
| 6 | -5/4, -11/12, -7/12, -1/4, 1/12, 5/12 | 1/3 |

**Pattern:** Roots are evenly spaced with step 2/n, starting from t = -5/4 ≡ 3/4 (mod 2).

**No i, no π in the formula** — just fractions!

#### Connection to Zeta Function

The Riemann functional equation contains sin(πs/2):
$$\zeta(s) = 2^s \pi^{s-1} \sin(\pi s/2) \, \Gamma(1-s) \, \zeta(1-s)$$

In Circ framework:
$$\sin(\pi s/2) = -\frac{\text{Circ}[s/2] - \text{Circ}[-s/2]}{\sqrt{2}}$$

**Dirichlet L-functions** use roots of unity for characters:
$$L(s, \chi) = \sum_{n=1}^{\infty} \frac{\chi(n)}{n^s}$$

where χ(n) = ω^(kn) with ω = primitive m-th root of unity.

In Circ: χ(n) = P[2kn/m - 5/4]

So L-functions become:
$$L(s, \chi) = \sum_{n=1}^{\infty} \frac{P[2kn/m - 5/4]}{n^s}$$

#### Taylor Series of Circ (Closed Form)

$$\text{Circ}(t) = \sum_{k=0}^{\infty} \frac{\varepsilon_k \cdot \pi^k}{\sqrt{2} \cdot k!} \, t^k$$

**Closed form for ε_k:**
$$\varepsilon_k = -\text{cas}\left(\frac{\pi k}{2}\right) = -\cos\frac{\pi k}{2} - \sin\frac{\pi k}{2}$$

Or arithmetically: $\varepsilon_k = (-1)^{\lfloor(k+2)/2\rfloor}$

| k | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | ... |
|---|---|---|---|---|---|---|---|---|---|
| ε_k | −1 | −1 | +1 | +1 | −1 | −1 | +1 | +1 | ... |

**Explicit series:**
$$\text{Circ}(t) = -\frac{1}{\sqrt{2}} - \frac{\pi t}{\sqrt{2}} + \frac{(\pi t)^2}{2\sqrt{2}} + \frac{(\pi t)^3}{6\sqrt{2}} - \frac{(\pi t)^4}{24\sqrt{2}} - \frac{(\pi t)^5}{120\sqrt{2}} + \cdots$$

**Observation:** The coefficient sign pattern ε_k = −cas(πk/2) connects the Taylor series back to Hartley! This is not coincidental — Circ is a scaled/shifted cas, so its Taylor coefficients inherit the cas structure.

**Contrast with sin/cos:** Unlike sin (odd powers only) or cos (even powers only), Circ contains **all powers** of t. This is the trade-off: Circ unifies the two functions but loses the clean parity separation that makes sin/cos Taylor series elegant.

**Sum of roots of unity:** Σ P[2k/n - 5/4] = (0, 0) for all n ≥ 2 (standard result).

*Note: The Circ parametrization is a change of variables; it cannot reveal structure not already present in standard coordinates.*

### 8. Chebyshev in Circ Coordinates

$$T_n(\text{Circ}[t]) = \text{Circ}\left[nt + \frac{3(n-1)}{4}\right]$$

**Symmetry preservation:**
- **Odd n:** {Circ[nt], Circ[-nt]} stays on unit circle (r² = 1)
- **Even n:** r² oscillates in [0, 2]

## What Circ/Hartley Actually Provides

1. **Derivative as shift** — genuinely cleaner than sin/cos cycle
2. **Single function** — conceptual simplification
3. **Real-only processing** — no complex numbers needed (useful in signal processing)

## What It Doesn't Provide

1. Clean parity structure (Taylor series mix all powers)
2. Escape from "pairs" in Fourier analysis
3. Anything mathematically new (it's a change of variables)

## Files

- **README.md** - This summary
- **pedagogical-note-circ.md** - Detailed exploration

## References

- **Hartley, R. V. L. (1942).** "A More Symmetrical Fourier Analysis Applied to Transmission Problems". *Proceedings of the IRE.* 30(3): 144–150. [DOI: 10.1109/JRPROC.1942.234333](https://doi.org/10.1109/JRPROC.1942.234333)
- **Bracewell, R. N. (1986).** *The Hartley Transform.* Oxford University Press.
