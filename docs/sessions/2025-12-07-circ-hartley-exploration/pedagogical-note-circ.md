# Pedagogical Note: Why Two Trig Functions?

**Date:** December 7, 2025
**Context:** Exploration of Circ framework led to fundamental questions about sin/cos

## The Question

> "Proč je výhodné zavést zvlášť dvě goniometrické funkce pro popis jednotkového kruhu, když jedna stačí?"

## The Circ Unification

Circ unifies sin and cos:
$$\text{Circ}(t) = \cos\left(\frac{3\pi}{4} + \pi t\right)$$

with:
- $\sin(\theta) = \text{Circ}(\theta/\pi - 5/4)$
- $\cos(\theta) = \text{Circ}(-\theta/\pi + 5/4)$

## The Core Identity: sin/cos as Symmetric/Antisymmetric Parts

The deepest insight from the Circ framework:

$$\cos(\pi t) = -\frac{\text{Circ}[t] + \text{Circ}[-t]}{\sqrt{2}} \quad \text{(symmetric part)}$$

$$\sin(\pi t) = -\frac{\text{Circ}[t] - \text{Circ}[-t]}{\sqrt{2}} \quad \text{(antisymmetric part)}$$

**This answers "why two functions?"** — they're the even and odd components of Circ under reflection t → -t.

Any function f(t) decomposes into:
- **Even part:** $[f(t) + f(-t)]/2$
- **Odd part:** $[f(t) - f(-t)]/2$

For Circ, these are exactly cos and sin (up to scaling).

**Pedagogical value:** This isn't computationally simpler than standard trig, but it reveals the *origin* of the sin/cos relationship — they're twins separated by symmetry, not independent functions that happen to be related.

## Arguments FOR Two Functions (sin/cos)

### 1. Clean Taylor Series (Parity)
```
sin(x) = x - x³/6 + x⁵/120 - ...    (odd powers only)
cos(x) = 1 - x²/2 + x⁴/24 - ...     (even powers only)
Circ[t] = mixes ALL powers           (no parity structure)
```

### 2. Derivative Cycle
```
Standard:  cos → -sin → -cos → sin → cos  (needs 2 functions)
Circ:      Circ[t] → -π·Circ[t+½] → -π²·Circ[t+1] → ...  (shift only!)
```
**Verdict:** Circ is actually CLEANER here — derivative = parameter shift.

### 3. Euler's Formula (Re/Im Separation)
$$e^{ix} = \cos(x) + i\sin(x)$$

The even/odd decomposition:
- $\cos(x) = (e^{ix} + e^{-ix})/2$ (even part)
- $\sin(x) = (e^{ix} - e^{-ix})/2i$ (odd part)

**Counter-argument:** This separation feels "artificial" — why privilege the real axis?

### 4. Fourier Orthogonality
Standard Fourier needs pairs: $\{cos(nx), sin(nx)\}$

With Circ: $\{Circ[nt], Circ[-nt]\}$ — still need PAIRS!

**Verdict:** The "two-ness" doesn't disappear, it relocates to t ↔ -t symmetry.

## The Hartley Connection (!)

Exploring whether Circ collapses Fourier variants led to a discovery:

$$\text{Circ}(t) = -\frac{1}{\sqrt{2}} \cdot \text{cas}(\pi t)$$

where $\text{cas}(x) = \cos(x) + \sin(x)$ is the **Hartley function** (1942).

**Key insight:** cas also has the "diagonal" phase!
$$\text{cas}(x) = \sqrt{2} \cdot \cos(x - \pi/4)$$

So both cas and Circ are on the diagonal where $|\cos\phi| = |\sin\phi| = 1/\sqrt{2}$:
- cas: phase $-\pi/4$
- Circ: phase $+3\pi/4$

Difference = $\pi$ (just a sign flip). **Same geometry, different notation!**

### Fourier Variants

| Transform | Basis | Functions |
|-----------|-------|-----------|
| Classic Fourier | sin, cos | 2 real |
| Complex Fourier | $e^{inx}$ | 1 complex |
| DCT | cos only | 1 real (even) |
| DST | sin only | 1 real (odd) |
| **Hartley** | cas = cos + sin | **1 real** |

**The Hartley transform already unified sin/cos in 1942!**

Properties:
- Real function → real transform
- Self-inverse: $H^2 = I$ (involution)
- Relation to Fourier: $F\{f\}(\omega) = \frac{H\{f\}(\omega) + H\{f\}(-\omega)}{2} - i\frac{H\{f\}(\omega) - H\{f\}(-\omega)}{2}$

## Conclusion

### Circ Rediscovers Hartley
The Circ framework independently arrives at the same idea as Hartley (1942):
unify sin and cos into a single real function via phase shift.

### The "Two-ness": Coordinates vs Trajectory

**Standard view:**
```
Circle = 2D object
Description: (x, y) = (cos θ, sin θ) — two independent coordinates
"Two-ness" is in GEOMETRY
```

**Alternative view (Circ perspective):**
```
Circle = 1D trajectory with t ↔ -t symmetry
Description: {Circ[t], Circ[-t]} — "twin particles" going opposite directions
"Two-ness" is in PROCESS/MOTION
```

This reframes the question: instead of "why two coordinates?", we ask "why two directions?"

The pair {Circ[t], Circ[-t]} satisfies Circ[t]² + Circ[-t]² = 1 — the twins are **complementary**, not independent. They are the same trajectory traversed both ways simultaneously.

This resonates with:
- **Feynman path integrals** — particle as sum over all paths
- **Wheeler's one-electron universe** — electron/positron as same particle in opposite time directions
- **Rotation vs position** — circle is fundamentally about MOVEMENT, not static points

The "two-ness" doesn't disappear, but its nature changes:
- From: two spatial dimensions
- To: one parameter with reflection symmetry

### What Circ/Hartley Actually Provides
1. **Derivative as shift** — genuinely cleaner than sin/cos cycle
2. **Single function** — conceptual simplification
3. **Real-only processing** — no complex numbers needed (useful in signal processing)

### What It Doesn't Provide
1. Clean parity structure (Taylor series mix all powers)
2. Escape from "pairs" in Fourier analysis
3. Anything mathematically new (it's a change of variables)

## Deep Identities: Common Theme

All major trig identities reduce to **sym/antisym decomposition under t → -t**:

| Identity | Circ Form |
|----------|-----------|
| tan(πt) | (Circ[t] - Circ[-t]) / (Circ[t] + Circ[-t]) |
| e^(iπt) | -e^(iπ/4) · (Circ[t] - i·Circ[-t]) |
| tan(πt/2) | (Circ[t/2] - Circ[-t/2]) / (Circ[t/2] + Circ[-t/2]) |
| sin(2πt) | Circ[t]² - Circ[-t]² |
| cos(2πt)/2 | Circ[t] · Circ[-t] |

The "complex Circ" Z[t] = Circ[t] - i·Circ[-t] satisfies De Moivre:
$$Z[t]^n = (-1)^{n-1} \cdot e^{i\pi(1-n)/4} \cdot Z[nt]$$

## Eliminating i: The Shift Operator

Even i itself can be demystified:
- **i = shift operator S** where S·Circ[t] = Circ[t + 1/2]
- **S² = -1** because Circ[t+1] = -Circ[t] (antiperiod 1)

Everything reduces to **one function** (Circ) and **parameter shifts**.

## Summary Table

| Aspect | sin/cos | Circ/cas | Winner |
|--------|---------|----------|--------|
| Taylor series | clean parity | mixed | sin/cos |
| Derivative | 2-function cycle | shift | **Circ** |
| Fourier | 2 functions | 2 values (±t) | tie |
| Conceptual | established | unified | Circ? |
| Historical | ancient | 1942 (Hartley) | — |

## References

- **Hartley, R. V. L. (1942).** "A More Symmetrical Fourier Analysis Applied to Transmission Problems". *Proceedings of the IRE.* 30 (3): 144–150.
  - DOI: [10.1109/JRPROC.1942.234333](https://doi.org/10.1109/JRPROC.1942.234333)
  - This is the original paper introducing cas(x) = cos(x) + sin(x)

- **Bracewell, R. N. (1986).** *The Hartley Transform.* Oxford University Press.
  - Comprehensive treatment of Hartley transform applications

- **Wikipedia:** [Hartley transform](https://en.wikipedia.org/wiki/Hartley_transform) — good overview with properties

## Meta-Note

This exploration documented "the journey" — including dead ends and rediscoveries.
The pedagogical value is in understanding WHY two trig functions exist,
even if the final answer is "it's a convention with trade-offs."
