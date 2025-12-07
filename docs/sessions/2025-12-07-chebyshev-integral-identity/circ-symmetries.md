# Circ Symmetries and Chebyshev Connections

**Date:** December 7, 2025
**Status:** Exploration documenting circ function properties and applications

## Core Definition

The **circ** function unifies sine and cosine through a single definition:

$$\text{Circ}(t) = \cos\left(\frac{3\pi}{4} + \pi t\right)$$

### Special Values

| t | Circ(t) |
|---|---------|
| −3/4 | 1 |
| −1/2 | 1/√2 |
| −1/4 | 0 |
| 0 | −1/√2 |
| 1/4 | −1 |
| 1/2 | −1/√2 |
| 3/4 | 0 |
| 1 | 1/√2 |

**Period:** Circ(t + 2) = Circ(t)

## Fundamental Identities

### Unit Circle Identity
$$\text{Circ}(t)^2 + \text{Circ}(-t)^2 = 1$$

This allows parametrizing the unit circle as {Circ(t), Circ(−t)}.

### Sum and Difference
$$\text{Circ}(t) + \text{Circ}(-t) = -\sqrt{2}\cos(\pi t)$$
$$\text{Circ}(t) - \text{Circ}(-t) = -\sqrt{2}\sin(\pi t)$$

### Product
$$\text{Circ}(t) \cdot \text{Circ}(-t) = \frac{1}{2}\cos(2\pi t)$$
$$\text{Circ}(s) \cdot \text{Circ}(t) = \frac{1}{2}\left[\cos(\pi(s-t)) + \sin(\pi(s+t))\right]$$

### Square
$$\text{Circ}(t)^2 = \frac{1 + \sin(2\pi t)}{2}$$

## Shift Identities

| Expression | Simplification |
|------------|----------------|
| Circ(t + 1) | sin(π/4 + πt) |
| Circ(t + 1/2) | −cos(π/4 + πt) |
| Circ(−t) | −cos(π/4 + πt) |
| Circ(1 − t) | cos(π/4 + πt) |
| Circ(1/2 − t) | −sin(π/4 + πt) |

**Key relation:** Circ(1 − t) = −Circ(−t)

## Reconstructing Standard Trig

Both Sin and Cos derive from Circ with the **same formula structure**:

$$\sin(\theta) = \text{Circ}\left(\frac{\theta}{\pi} - \frac{5}{4}\right)$$
$$\cos(\theta) = \text{Circ}\left(-\frac{\theta}{\pi} + \frac{5}{4}\right)$$

The unification: sin and cos are Circ with **opposite argument signs**.

## Spread Connection

The connection to Wildberger's rational trigonometry:

$$\text{spread} = \frac{1 - \text{Circ}(t)}{2}$$
$$\text{Circ}(t) = 1 - 2 \cdot \text{spread}$$

| Circ(t) | spread | geometric meaning |
|---------|--------|-------------------|
| 1 | 0 | parallel |
| 1/2 | 1/4 | 30° |
| 0 | 1/2 | 45° |
| −1/2 | 3/4 | 60° |
| −1 | 1 | perpendicular |

---

## Application: Chebyshev Lobe Areas

### The Lobe Area Formula

For the Chebyshev difference function $f_n(x) = T_{n+1}(x) - xT_n(x)$, the area of lobe $k$ is:

$$A(n,k) = \frac{1}{n} + \beta(n) \cos\left(\frac{(2k-1)\pi}{n}\right)$$

where $\beta(n) = \frac{n\cos(\pi/n)}{4 - n^2}$

### Lobe Symmetry

The symmetry $A(n,k) = A(n, n+1-k)$ follows from cosine being even:

- Lobe $k$: argument $u = (2k-1)\pi/n$
- Lobe $n+1-k$: argument $= (2n+1-2k)\pi/n = 2\pi - u$

Since $\cos(2\pi - u) = \cos(u)$:
$$A(n,k) = A(n, n+1-k) \quad \checkmark$$

---

## Application: The f_n Function

### Trigonometric Form

With $x = \cos(\theta)$:
$$f_n(\cos\theta) = -\sin(\theta)\sin(n\theta)$$

### Via Circ

Let $u = \theta/\pi$, then:
$$f_n(\cos(\pi u)) = -\text{Circ}(u - 5/4) \cdot \text{Circ}(nu - 5/4)$$

This expresses $f_n$ as a **product of two Circ terms**.

### Zeros

$f_n = 0$ when either factor vanishes:
- $\text{Circ}(u - 5/4) = 0$ → $u \in \{0, 1\}$ → $x = \pm 1$ (boundary)
- $\text{Circ}(nu - 5/4) = 0$ → $u = (5/4 + k/2)/n$ for integer $k$

---

## Paclet Implementation

The `CircFunctions` module in the Orbit paclet provides:

```mathematica
<< Orbit`

Circ[t]           (* Core function *)
CircSin[t]        (* Sin via Circ *)
CircCos[t]        (* Cos via Circ *)
CircPoint[t]      (* {Circ[t], Circ[-t]} - unit circle *)
CircToSpread[c]   (* (1-c)/2 *)
SpreadToCirc[s]   (* 1-2s *)
CircTaylor[t, n]  (* Taylor expansion *)
```

---

## Double Angle Formula

The double angle identity $\sin(2\theta) = 2\sin\theta\cos\theta$ becomes:

$$\text{Circ}(2v + 5/4) = 2\,\text{Circ}(v)\,\text{Circ}(-v)$$

Combined with $\text{Circ}(v)\text{Circ}(-v) = \frac{1}{2}\cos(2\pi v)$:

$$\text{Circ}(2v + 5/4) = \cos(2\pi v)$$

Also: $\cos(2\pi s) = -\text{Circ}(2s + 1/4)$

---

## Chebyshev Polynomials in Circ Coordinates

### The Main Identity

Since $T_n(\cos\theta) = \cos(n\theta)$ and $\text{Circ}(t) = \cos(3\pi/4 + \pi t)$:

$$T_n(\text{Circ}(t)) = \text{Circ}\left(nt + \frac{3(n-1)}{4}\right)$$

**Proof:** $T_n(\text{Circ}(t)) = \cos(n(3\pi/4 + \pi t)) = \cos(3n\pi/4 + n\pi t) = \text{Circ}(nt + 3(n-1)/4)$

### The Shift Pattern

The shift $3(n-1)/4 \mod 2$ has **period 8** in $n$:

| n mod 8 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---------|---|---|---|---|---|---|---|---|
| shift | 0 | 3/4 | 3/2 | 1/4 | 1 | 7/4 | 1/2 | 5/4 |

This period 8 is arithmetic (denominator 4 in shift, period 2 in Circ), not a deep symmetry.

### Chebyshev Recurrence in Circ Coordinates

The standard recurrence $T_{n+1}(x) = 2xT_n(x) - T_{n-1}(x)$ becomes:

$$\text{Circ}(s_{n+1}) = 2\,\text{Circ}(t)\,\text{Circ}(s_n) - \text{Circ}(s_{n-1})$$

where $s_n = nt + 3(n-1)/4$.

### Preservation of Structure

**Unit circle identity preserved:**
$$\text{Circ}(s)^2 + \text{Circ}(-s)^2 = 1$$

holds for $s = nt + 3(n-1)/4$, so Chebyshev polynomials map the unit circle to itself in Circ coordinates.

**Lorentz norm preserved:** For complex $t$, the split-quaternion norm $N = 1/2$ is invariant under Chebyshev application — the polynomials act as "isometries" on the hyperboloid.

### Composition Law

Chebyshev composition $T_m(T_n(x)) = T_{mn}(x)$ becomes:

$$\text{shift}_m \circ \text{shift}_n = \text{shift}_{mn}$$

where $\text{shift}_n(t) = nt + 3(n-1)/4$.

**Verification:** $m(nt + 3(n-1)/4) + 3(m-1)/4 = mnt + 3(mn-1)/4$ ✓

---

## Trig Products via Circ (from notebook)

The key identities that enable expressing products:

$$\text{Circ}(u) + \text{Circ}(-u) = -\sqrt{2}\cos(\pi u)$$
$$\text{Circ}(u) - \text{Circ}(-u) = -\sqrt{2}\sin(\pi u)$$

### Product Formulas

Using the product-to-sum identities, we get:

$$\sin(x)\cos(y) = \frac{1}{-2\sqrt{2}}\left[\text{Circ}\left(\frac{x+y}{\pi}\right) - \text{Circ}\left(-\frac{x+y}{\pi}\right) - \text{Circ}\left(\frac{x-y}{\pi}\right) + \text{Circ}\left(\frac{y-x}{\pi}\right)\right]$$

$$\cos(x)\cos(y) = \frac{1}{-2\sqrt{2}}\left[\text{Circ}\left(\frac{x+y}{\pi}\right) + \text{Circ}\left(-\frac{x+y}{\pi}\right) + \text{Circ}\left(\frac{x-y}{\pi}\right) + \text{Circ}\left(\frac{y-x}{\pi}\right)\right]$$

### Factor Extraction

The individual factors can also be expressed:
- $\sin(y) = \text{Circ}(y/\pi - 5/4)$
- $\cos(x) = \text{Circ}(x/\pi + 5/4)$

So: $\sin(y)\cos(x) = \text{Circ}(y/\pi - 5/4) \cdot \text{Circ}(x/\pi + 5/4)$

### The mull Structure

The notebook's `mull[x,y]` organizes this as:
```mathematica
mull[x,y] = {
  {4 circ-based terms},  (* combine differently for different products *)
  {Sin[y], Cos[x]}       (* the individual factors *)
}
```

- Sum of all 4 terms → $\cos(x)\sin(y)$
- Alternative sign pattern → $\cos(x)\cos(y)$

---

## The Deep Structure: Circ as Complex Exponential

### The Complex Encoding

Define $z[t] = \text{Circ}(t) + i\,\text{Circ}(-t)$. Then:

$$z[t] = e^{i(3\pi/4 + \pi t)}$$

This reveals Circ as the real part of a complex exponential starting at 135°.

### The Multiplication Law

$$z[t] \times z[s] = z[t + s + 3/4]$$

The 3/4 offset encodes the "seed" $e^{3i\pi/4}$.

**Verified:** $z[0]^2 = i = z[3/4]$ ✓

### The Imaginary Unit IS the Fold

$$i \times z[t] = z[t - 1/2]$$

Multiplication by $i$ (90° rotation) corresponds to a **parameter shift by 1/2**.

This means the $t \leftrightarrow -t$ symmetry that separates sin from cos is fundamentally connected to the action of $i$!

### Why 3π/4? The Equal-Weight Condition

The offset $3\pi/4 = 135°$ places $t=0$ on the diagonal where $|cos| = |sin|$.

**The phase addition formulas:**
$$\cos(\theta + \phi_1) + \cos(\theta + \phi_2) = 2\cos\left(\frac{\phi_1-\phi_2}{2}\right)\cos\left(\theta + \frac{\phi_1+\phi_2}{2}\right)$$
$$\cos(\theta + \phi_1) - \cos(\theta + \phi_2) = -2\sin\left(\frac{\phi_1-\phi_2}{2}\right)\sin\left(\theta + \frac{\phi_1+\phi_2}{2}\right)$$

**For Circ** with $\phi_1 = 3\pi/4 + \pi t$ and $\phi_2 = 3\pi/4 - \pi t$:
- Sum amplitude: $2\cos(3\pi/4) = -\sqrt{2}$
- Diff amplitude: $-2\sin(3\pi/4) = -\sqrt{2}$

**The amplitudes are equal!** This happens because $|\cos(3\pi/4)| = |\sin(3\pi/4)| = 1/\sqrt{2}$.

The four phases where this holds are $\pi/4, 3\pi/4, 5\pi/4, 7\pi/4$ — the 45° diagonals.

**Result:** Sin and cos emerge from the even/odd decomposition with the **same scaling factor**:
$$\text{Circ}(t) + \text{Circ}(-t) = -\sqrt{2}\cos(\pi t)$$
$$\text{Circ}(t) - \text{Circ}(-t) = -\sqrt{2}\sin(\pi t)$$

Any other phase would give different amplitudes, breaking the symmetry between sin and cos.

*Note: This may be a trivial observation from standard trigonometry, or it may be the key motivation for the Circ framework if the reformulation proves useful elsewhere.*

### The Grand Unification

```
ONE function (Circ)
      ↓
  FOLD along t ↔ -t
      ↓
TWO functions (Sin, Cos) via Even/Odd decomposition
      ↓
  COMBINE with i
      ↓
COMPLEX exponential e^(iθ)
```

The entire structure of complex numbers and trigonometry emerges from:
1. **One function** Circ(t)
2. **One symmetry** t ↔ -t
3. **One combination** Circ(t) + i·Circ(-t)

### Caveat: New Clothes for Euler?

To be honest: this is essentially Euler's formula $e^{i\theta} = \cos\theta + i\sin\theta$ in reparametrized form. The "unification" is pedagogical rather than mathematical — it doesn't prove anything new.

**What IS genuinely useful:**
- The $t \leftrightarrow -t$ symmetry as an **organizing principle** for discovering identities
- A framework where the fold/reflection structure is **explicit**
- Unit circle parametrization {Circ(t), Circ(-t)} with constant Lorentz norm in complex extension

**Note on symmetry:** The $t \to -t$ operation swaps Re and Im (reflection across the **diagonal** $y = x$), which is different from complex conjugation (reflection across the x-axis). The operations $\{t \to -t, t \to t+1, t \to t+1/2\}$ generate D4 (dihedral symmetry of the square), giving the Circ framework a different symmetry structure than standard conjugate-symmetric complex analysis.

---

## Complex Extension

### Circ with Complex Arguments

For $t = x + iy$, the Circ function extends analytically:

$$\text{Circ}(x + iy) = \cos\left(\frac{3\pi}{4} + \pi x + i\pi y\right)$$

**Explicit form:**
- Real part: $-\cosh(\pi y)\sin(\pi(1/4 + x))$
- Imag part: $-\cos(\pi(1/4 + x))\sinh(\pi y)$

### Two Independent Symmetries

**1. Argument negation:** $t \to -t$
- Even part: $(\text{Circ}(t) + \text{Circ}(-t))/2 = -\cos(\pi t)/\sqrt{2}$
- Odd part: $(\text{Circ}(t) - \text{Circ}(-t))/2 = -\sin(\pi t)/\sqrt{2}$

**2. Argument conjugation:** $t \to \bar{t}$
$$\text{Circ}(\bar{t}) = \overline{\text{Circ}(t)}$$

This is the Schwarz reflection principle — Circ is real-analytic.

### The Four Basis Functions

Combining both symmetries, Circ decomposes into four fundamental components:

| Component | Formula | x-parity | y-parity |
|-----------|---------|----------|----------|
| cc | $\cos(\pi x)\cosh(\pi y)$ | even | even |
| ss | $\sin(\pi x)\sinh(\pi y)$ | odd | odd |
| sc | $\sin(\pi x)\cosh(\pi y)$ | odd | even |
| cs | $\cos(\pi x)\sinh(\pi y)$ | even | odd |

---

## Split-Quaternion Structure (Dec 7, 2025)

The complex extension of Circ reveals a beautiful connection to **split-quaternions** — a 4D algebra related to Lorentz geometry.

### The Algebra

The split-quaternion algebra has basis $\{1, i, j, k\}$ with:
- $i^2 = -1$ (imaginary unit)
- $j^2 = +1$ (hyperbolic unit)
- $k = ij$, $k^2 = +1$
- $ij = -ji$ (anti-commute)

This is NOT standard quaternions (where $i^2 = j^2 = k^2 = -1$).

### Circ in Split-Quaternion Basis

For complex argument $t = x + iy$, Circ decomposes into all four components:

$$\text{Circ}(x+iy) = a \cdot 1 + b \cdot i + c \cdot j + d \cdot k$$

where (with shorthand $c_x = \cos\pi x$, $s_x = \sin\pi x$, $C_y = \cosh\pi y$, $S_y = \sinh\pi y$):

| Component | Formula | Meaning |
|-----------|---------|---------|
| $a$ | $-c_x C_y / \sqrt{2}$ | real, compact |
| $b$ | $-s_x C_y / \sqrt{2}$ | imaginary, compact |
| $c$ | $-c_x S_y / \sqrt{2}$ | real, hyperbolic |
| $d$ | $+s_x S_y / \sqrt{2}$ | imaginary, hyperbolic |

### The Constant Lorentz Norm

The split-quaternion norm is:
$$N(q) = a^2 + b^2 - c^2 - d^2$$

**Remarkable fact:** For Circ, this norm is **constant**:
$$N(\text{Circ}) = \frac{1}{2}$$

independent of $x$ and $y$!

### Why 3π/4 is Special

The constancy comes from $|\cos(3\pi/4)| = |\sin(3\pi/4)| = 1/\sqrt{2}$:

1. All four components scale with the **same factor** $1/\sqrt{2}$
2. This enables: $a^2 + b^2 = (c_x^2 + s_x^2) C_y^2/2 = C_y^2/2$
3. Similarly: $c^2 + d^2 = S_y^2/2$
4. The Pythagorean identity $c_x^2 + s_x^2 = 1$ **eliminates x-dependence**
5. Then: $N = C_y^2/2 - S_y^2/2 = (C_y^2 - S_y^2)/2 = 1/2$ ✓

*Note:* A different phase (e.g., $\phi = \pi$) would give only 2 of the 4 components, and the Pythagorean cancellation would not apply — resulting in a variable norm.

### Geometric Interpretation

Circ traces a **Lorentz-invariant surface** in the 4D split-quaternion space:
- Signature (+,+,-,-) — two compact dimensions, two hyperbolic
- The 3π/4 phase spreads the function across all four dimensions
- This gives the constant Lorentz norm

### Idempotent Decomposition

Since $j^2 = 1$, we have idempotents $e_{\pm} = (1 \pm j)/2$ satisfying:
- $e_+^2 = e_+$, $e_-^2 = e_-$
- $e_+ \cdot e_- = 0$
- $e_+ + e_- = 1$

The algebra decomposes: $\mathbb{H}_{split} \cong \mathbb{C} \oplus \mathbb{C}$ along the $e_+$ and $e_-$ eigenspaces.

### Connection to Lorentz Geometry

The split-quaternion algebra is isomorphic to $2 \times 2$ real matrices:
- $1 \to \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix}$
- $i \to \begin{pmatrix} 0 & -1 \\ 1 & 0 \end{pmatrix}$
- $j \to \begin{pmatrix} 1 & 0 \\ 0 & -1 \end{pmatrix}$
- $k \to \begin{pmatrix} 0 & 1 \\ 1 & 0 \end{pmatrix}$

The Lorentz norm is the determinant: $N(q) = \det(M_q)$.

Circ with constant norm $1/2$ lies on a **hyperboloid** in this 4D space — the analog of the unit sphere, but with Lorentz signature.

### Summary

The 3π/4 phase that defines Circ is geometrically special: it places the function on a **Lorentz-invariant surface** where the norm $N = 1/2$ is independent of the argument.

*Note: This is the "quaternion connection" mentioned in Open Questions — it turns out to be split-quaternions rather than standard quaternions, which is fitting since we're mixing compact (circular) and non-compact (hyperbolic) structures.*

**See also:** [Split-quaternions learning doc](../../learning/split-quaternions.md) for a detailed introduction to split-quaternions vs standard quaternions.

---

## Open Questions

1. ~~Circ polynomials:~~ **Answered!** Chebyshev polynomials in Circ coordinates: $T_n(\text{Circ}(t)) = \text{Circ}(nt + 3(n-1)/4)$. See "Chebyshev Polynomials in Circ Coordinates" section.

2. **The circle[x,y,m] function:** What was the intended use of the Chebyshev-based circle function?

3. ~~Quaternion extension:~~ **Answered!** The structure is split-quaternionic with Lorentz signature.

4. ~~Physical interpretation:~~ **Premature.** Lorentz signature in abstract algebra ≠ physics. Missing: time coordinate, fields, equations of motion. See [physics-connection-review.md](../2025-11-22-palindromic-symmetries/physics-connection-review.md).

5. ~~Other Lorentz-invariant phases:~~ **Answered.** Four phases (π/4, 3π/4, 5π/4, 7π/4) all work. Choice of 3π/4 is conventional; π/4 would start in first quadrant but adds minus sign to cos reconstruction. Trade-off, not worth changing.

6. ~~Z/8Z symmetry:~~ **Debunked.** Period 8 is trivial arithmetic (denominator 4, period 2). Not related to D4.
