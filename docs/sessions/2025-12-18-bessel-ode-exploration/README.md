# Session: Bessel ODE and Exponential Connection

**Date:** 2025-12-18
**Topic:** Deriving e from Bessel differential equations

---

## Main Discovery

The Bessel polynomial ODE encodes the exponential function through its asymptotic behavior:

$$\boxed{\lim_{n\to\infty} \frac{y_n(x)}{(2n-1)!! \cdot x^n} = e^{1/x}}$$

where $y_n(x)$ is the Bessel polynomial satisfying:
$$x^2 y'' + (2x+2) y' - n(n+1) y = 0$$

with recurrence:
$$y_{n+1}(x) = (2n+1)x \cdot y_n(x) + y_{n-1}(x)$$

### Special Cases

| $x$ | Limit | Value |
|-----|-------|-------|
| 1 | $e^1 = e$ | 2.71828... |
| 2 | $e^{1/2} = \sqrt{e}$ | 1.64872... |
| 3 | $e^{1/3}$ | 1.39561... |

---

## Relationship to Monotone Series and e-Spiral

### The e-Spiral Work

Our e-spiral paper involves:
- Continued fraction for $\coth(1/2) = (e+1)/(e-1) = [2; 6, 10, 14, \ldots]$
- Convergents $p_n/q_n$ where denominators relate to Bessel polynomials $y_n(-2)$ (OEIS A002119)
- Spiral function $g(z) = \frac{-16\pi e \cdot z}{K_{2z-1}(-1/2) \cdot K_{2z+1}(-1/2)}$

### How This Session Connects

The Bessel polynomial ODE is the common source:

```
        Bessel Polynomial ODE
                 ↓
    x²y'' + (2x+2)y' - n(n+1)y = 0
                 ↓
        Recurrence: y_{n+1} = (2n+1)x·y_n + y_{n-1}
                 ↓
   ┌─────────────┼─────────────┐
   ↓             ↓             ↓
 y_n(-2)       y_n(1)        y_n(2)
   ↓             ↓             ↓
 A002119    ~ e·(2n-1)!!   ~ √e·(2n-1)!!·2^n
(CF denom)  (asymptotics)   (asymptotics)
```

**Key insight:** The same ODE that generates:
1. The denominators $q_n$ for convergents to $e$ (via $y_n(-2)$)
2. The asymptotic behavior encoding $e^{1/x}$

### Reverse Bessel Polynomials

The reverse Bessel polynomials $\theta_n(x) = x^n y_n(1/x)$ satisfy:
$$\theta_{n+1}(x) = (2n+1) \theta_n(x) + x^2 \theta_{n-1}(x)$$

At $x = 1/2$:
$$\theta_n(1/2) = (1/2)^n y_n(2)$$

Therefore:
$$\lim_{n\to\infty} \frac{\theta_n(1/2)}{(2n-1)!!} = \sqrt{e}$$

### The Spiral Interpolation

The spiral $g(z)$ interpolates between integer points using K-functions. At half-integer indices, $K_{n+1/2}(x)$ has elementary form:

$$K_{n+1/2}(x) = \sqrt{\frac{\pi}{2x}} e^{-x} \frac{\theta_n(x)}{x^n}$$

The exponential $e^{-x}$ appears explicitly in the solution — this is why Euler's number emerges from the Bessel polynomial asymptotics.

---

## Helmholtz Equation in Spherical Coordinates

### The Equation

The Helmholtz equation describes wave phenomena:
$$\nabla^2 \psi + k^2 \psi = 0$$

In spherical coordinates $(r, \theta, \phi)$:
$$\frac{1}{r^2}\frac{\partial}{\partial r}\left(r^2 \frac{\partial \psi}{\partial r}\right) + \frac{1}{r^2 \sin\theta}\frac{\partial}{\partial \theta}\left(\sin\theta \frac{\partial \psi}{\partial \theta}\right) + \frac{1}{r^2 \sin^2\theta}\frac{\partial^2 \psi}{\partial \phi^2} + k^2 \psi = 0$$

### Separation of Variables

Ansatz $\psi = R(r) \cdot Y(\theta, \phi)$ separates into:

**Angular part:** Spherical harmonics $Y_l^m(\theta, \phi)$

**Radial part:** Spherical Bessel equation (with $x = kr$):
$$x^2 R'' + 2x R' + [x^2 - l(l+1)] R = 0$$

This is precisely the ODE we studied! The solutions are:

| Function | Definition | Name |
|----------|------------|------|
| $j_l(x)$ | $\sqrt{\frac{\pi}{2x}} J_{l+1/2}(x)$ | Spherical Bessel, 1st kind |
| $y_l(x)$ | $\sqrt{\frac{\pi}{2x}} Y_{l+1/2}(x)$ | Spherical Bessel, 2nd kind |
| $k_l(x)$ | $\sqrt{\frac{\pi}{2x}} K_{l+1/2}(x)$ | Modified spherical Bessel |

### Physical Problems

| Problem | Description |
|---------|-------------|
| **Wave scattering on sphere** | EM or acoustic waves impinging on spherical object |
| **Antenna radiation** | Dipole and multipole radiation patterns |
| **Hydrogen atom** | Radial Schrödinger equation (with Coulomb potential) |
| **Heat conduction** | Temperature field in spherical shells |
| **Acoustic resonators** | Normal modes of spherical cavity |

### Why This Matters

The modified spherical Bessel function $k_l(x)$ has elementary form:

$$k_l(x) = \frac{\pi}{2} \frac{e^{-x}}{x} P_l(1/x)$$

where $P_l$ is a polynomial (the reverse Bessel polynomial $\theta_l$).

The exponential $e^{-x}$ describes **exponential decay** away from the source — characteristic of:
- Evanescent waves (beyond cutoff)
- Thermal decay
- Screened potentials (Yukawa)

The fact that these functions contain $e$ explicitly connects to why Euler's number appears in the Bessel polynomial asymptotics.

---

## Key Files

| File | Description |
|------|-------------|
| `bessel-ode-explore.wl` | Initial ODE exploration |
| `bessel-exp-connection.wl` | Connection to exponential |
| `bessel-half-integer.wl` | Half-integer order analysis |
| `spherical-bessel.wl` | Spherical Bessel connection |
| `theta-y-relation.wl` | Main discovery: $y_n(x) \sim e^{1/x} \cdot (2n-1)!! \cdot x^n$ |
| `e-from-bessel.wl` | Two representations of $e$ via Bessel |
| `prove-sqrt-e.wl` | Asymptotic analysis attempts |

---

## Summary Diagram

```
                    HELMHOLTZ EQUATION ∇²ψ + k²ψ = 0
                              ↓
                    Spherical coordinates
                              ↓
              ┌───────────────┴───────────────┐
              ↓                               ↓
      Angular part                      Radial part
    Y_l^m(θ,φ) spherical             x²R'' + 2xR' + [x² - l(l+1)]R = 0
       harmonics                              ↓
                                    Spherical Bessel functions
                                              ↓
                                    K_{l+1/2}(x) = √(π/2x) e^{-x} θ_l(x)/x^l
                                              ↓
                              Reverse Bessel polynomials θ_l(x)
                                              ↓
                                    θ_l(x) = x^l y_l(1/x)
                                              ↓
                              Bessel polynomials y_n(x)
                                              ↓
                         ┌────────────────────┴────────────────────┐
                         ↓                                        ↓
              y_n(-2) = A002119                     lim y_n(x)/[(2n-1)!!·x^n] = e^{1/x}
              CF denominators for e                    Exponential encoded!
                         ↓                                        ↓
                         └────────────────────┬────────────────────┘
                                              ↓
                                     e-SPIRAL g(z)
```

---

## Status of the Asymptotic Formula

**Status:** ✅ PROVEN (Grosswald 1951, Theorem 1)

### Original Theorem Statement

From Grosswald (1951), p. 197-198:

> **Main Result (1):** Let $Y_n(x) = k_n x^n e^{1/x}$ where $k_n = (2n)!/n!2^n$.
> Then, for fixed $x$ with $|x| > 1$: $\lim_{n\to\infty} y_n(x)/Y_n(x) = 1$.

Since $k_n = (2n)!/(n! 2^n) = (2n-1)!!$, this is equivalent to:
$$\boxed{y_n(x) \sim (2n-1)!! \cdot x^n \cdot e^{1/x} \quad \text{as } n \to \infty}$$

**Grosswald's note** (p. 198, footnote 4):
> "It is precisely the property of BP to approximate an exponential, which permits their use in the proof of the transcendency of e."

### Our Numerical Verification

Confirms the result:
- At $x=1$: converges to $e$ with 15+ digit accuracy by $n=150$
- At $x=2$: converges to $\sqrt{e}$ with 15+ digit accuracy by $n=100$
- At $x=3$: converges to $e^{1/3}$ with similar accuracy

---

## References

### Primary Sources

1. **Grosswald (1951)** - E. Grosswald, "On some algebraic properties of the Bessel polynomials,"
   *Trans. Amer. Math. Soc.* **71**(2) (Sep. 1951), 197–210.
   [JSTOR: 1990686](http://www.jstor.org/stable/1990686) |
   [DOI: 10.1090/S0002-9947-1951-0053280-2](https://doi.org/10.1090/S0002-9947-1951-0053280-2)
   - **Main source for asymptotic formula** (Theorem 1, p. 197-198)
   - Also proves irreducibility, zeros location, Galois groups

2. **Grosswald (1978)** - E. Grosswald, *Bessel Polynomials*,
   Lecture Notes in Mathematics, Vol. 698, Springer, 1978.
   - Comprehensive monograph on Bessel polynomials

3. **Krall-Frink (1949)** - H.L. Krall and O. Frink, "A new class of orthogonal polynomials: The Bessel polynomials,"
   *Trans. Amer. Math. Soc.* **65** (1949), 100–115.
   [DOI: 10.1090/S0002-9947-1949-0028473-1](https://doi.org/10.1090/S0002-9947-1949-0028473-1)
   - Original definition and orthogonality properties

### Survey Articles

4. **Srivastava (2023)** - H.M. Srivastava, "An Introductory Overview of Bessel Polynomials, the Generalized Bessel Polynomials and the q-Bessel Polynomials,"
   *Symmetry* **15**(4) (2023), 822.
   [DOI: 10.3390/sym15040822](https://doi.org/10.3390/sym15040822)
   - Modern survey citing Grosswald 1951 results

### Reference Works

5. **DLMF §18.34** - NIST Digital Library of Mathematical Functions, Section 18.34: Bessel Polynomials.
   [https://dlmf.nist.gov/18.34](https://dlmf.nist.gov/18.34)

---

---

## E-Spiral Intersection Analysis

### Main Results

**X-Axis Crossings (Im(g) = 0):**

All x-axis crossings occur at $t = \frac{2k+1}{4}$ for $k \in \mathbb{Z}$.

At these points, the Bessel orders are half-integers, and the function yields **exact rational values**.

**Key Theorem:** For $n \geq 0$:
$$g\left(\frac{3}{4} + n\right) = \frac{4(4n+3)}{s_{2n-1} \cdot s_{2n+1}}$$

These are **exactly** the terms of our monotone e-series:
$$e = 1 + \sum_{n=0}^{\infty} g\left(\frac{3}{4} + n\right)$$

| $t$ | $g(t)$ | Notes |
|-----|--------|-------|
| $\frac{1}{4}$ | $-4$ | Intermediate |
| $\frac{3}{4}$ | $\frac{12}{7}$ | Series term $a_0$ |
| $\frac{5}{4}$ | $\frac{20}{71}$ | Intermediate |
| $\frac{7}{4}$ | $\frac{4}{1001}$ | Series term $a_1$ |
| $\frac{11}{4}$ | $\frac{4}{36305269}$ | Series term $a_2$ |

### Interval Width Formula

The half-width of `EulerEInterval[k]` is a **unit fraction**:

$$\frac{T_{2k} - T_{2k-1}}{2} = \frac{1}{s_{2k-1} \cdot s_{2k}}$$

| $k$ | Half-width | Denominator |
|-----|------------|-------------|
| 1 | $\frac{1}{497}$ | $7 \times 71$ |
| 2 | $\frac{1}{18107089}$ | $1001 \times 18089$ |
| 3 | $\frac{1}{4145592145057}$ | $398959 \times 10391023$ |

### Divisibility Theorem

Let $D_k = s_{2k-1} \cdot s_{2k}$ be the denominator of the half-width. Then:

$$7 \mid D_k \iff k \equiv 1, 2, 4, 5 \pmod 7$$
$$11 \mid D_k \iff k \equiv 2, 3, 7, 8 \pmod{11}$$

**Proof:** The recurrence $s_n = (4n+2)s_{n-1} + s_{n-2}$ yields:
- $s_n \equiv 0 \pmod 7 \iff n \equiv 1, 3 \pmod 7$
- $s_n \equiv 0 \pmod{11} \iff n \equiv 3, 5 \pmod{11}$

Since $D_k = s_{2k-1} \cdot s_{2k}$, we have $p \mid D_k$ iff $p \mid s_{2k-1}$ or $p \mid s_{2k}$. Solving $2k-1 \equiv r \pmod p$ and $2k \equiv r \pmod p$ for the zero residues $r$ gives the stated conditions. $\square$

**Corollary:** The denominators $D_k$ exhibit periodic divisibility patterns with period 7 for the prime 7, and period 11 for the prime 11. Their interplay has period $\text{lcm}(7,11) = 77$.

### The 77-Structure of Euler's e

The number $77 = 7 \times 11$ is **intrinsically connected** to the continued fraction of $e$:

$$77 \mid s_n \iff n \equiv 3, 36, 38, 71 \pmod{77}$$

**Origin of 7 and 11:**
- $s_1 = 7$ (initial condition of the recurrence)
- $s_3 = 1001 = 7 \times 11 \times 13$ (first term divisible by 77)

The recurrence $s_n = (4n+2)s_{n-1} + s_{n-2}$ propagates these divisibilities with period 77, creating a deep arithmetic structure connecting Euler's constant to the primes 7 and 11.

**CRT decomposition:** The four residue classes follow from:

| $n \bmod 7$ | $n \bmod 11$ | $n \bmod 77$ |
|-------------|--------------|--------------|
| 1 | 3 | 36 |
| 1 | 5 | 71 |
| 3 | 3 | 3 |
| 3 | 5 | 38 |

**Y-Axis Crossings (Re(g) = 0):** Transcendental, but solutions exist:
- Largest at $t \approx \pm 0.5405$ (near $\pm 6/11$) with $\text{Im}(g) \approx \mp 2.428$
- Additional crossings at $t \approx \pm 0.91, \pm 1.14, \pm 1.37, \pm 1.62, ...$

**Self-Intersections:** Two found (transcendental):
- Outer: $t_1 \approx 0.645$, $t_2 \approx -0.053$ at $g \approx 1.35 - 1.50i$
- Inner: $t_1 \approx -1.184$, $t_2 \approx 0.012$ at $g \approx -0.29 + 0.37i$

### Symbolic Formulas

For the denominator product:
$$K_{2t-1}(-\tfrac{1}{2}) \cdot K_{2t+1}(-\tfrac{1}{2})$$

we have:
$$\text{Re}(\text{denom}) = K_1 K_2 \cos(4\pi t) + \pi \sin(2\pi t)(K_1 I_2 + K_2 I_1) - \pi^2 I_1 I_2$$
$$\text{Im}(\text{denom}) = -K_1 K_2 \sin(4\pi t) + \pi \cos(2\pi t)(K_1 I_2 + K_2 I_1)$$

where $K_i = K_{2t \pm 1}(\frac{1}{2})$ and $I_i = I_{2t \pm 1}(\frac{1}{2})$.

Setting $\text{Im}(\text{denom}) = 0$ yields $\cos(2\pi t) = 0$, i.e., $t = \frac{1}{4} + \frac{n}{2}$.

See `symbolic-summary.md` for complete derivation.

---

## Open Questions

1. **Direct proof:** Can we derive the asymptotic formula directly from the ODE without generating functions?
2. ~~**Connection to e-spiral:** How does this relate to our spiral interpolation $g(z)$ specifically?~~ ✅ ANSWERED: Series terms are exactly x-axis crossings at $t = 3/4 + n$.
3. **Modular connection:** Are there modular properties connecting Bessel polynomials to $e$?
4. **Complex extension:** What is the domain of validity for complex $x$ in the asymptotic formula?
