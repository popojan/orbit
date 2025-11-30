# The Altsum Circle Identity

A recreational exploration connecting Chebyshev lobe areas to circles and $\pi$.

## 1. Starting Point: Chebyshev Lobe Areas

The Chebyshev polynomial $T_n(x)$ on $[-1, 1]$ creates $n$ lobes. The area of the $k$-th lobe (for $k = 1, \ldots, n$) is given by the closed form:

$$
A_n(k) = \frac{8 - 2n^2 + n^2\left(\cos\frac{2(k-1)\pi}{n} + \cos\frac{2k\pi}{n}\right)}{8n - 2n^3}
$$

This formula is implemented as `ChebyshevLobeArea[n, k]` in the Orbit paclet.

## 2. The Signed Lobe Integral

Consider the continuous extension where we integrate the lobe area formula with alternating signs:

$$
S(n) = \int_0^n (-1)^k \cdot A_n(k) \, dk
$$

Using the symbolic formula `ChebyshevLobeAreaSymbolic[n, k]` and evaluating this integral, we obtain the **altsum function**:

$$
\boxed{\text{altsum}(n) = \frac{1 + e^{in\pi} - \dfrac{n^2\left(\cos\frac{2\pi}{n} + \cos(n\pi) - \sin(n\pi)\tan\frac{\pi}{n}\right)}{n^2 - 4}}{2n}}
$$

This is a complex-valued function with interesting properties.

## 3. The $\pi$ Identity

**Main Result:** The imaginary part of altsum integrates to $\pi$:

$$
\boxed{\int_0^\infty 4 \cdot \text{Im}[\text{altsum}(n)] \, dn = \pi}
$$

This was verified both symbolically (Mathematica confirms $= \pi$ exactly) and numerically.

### Asymptotic behavior

The integrand $4 \cdot \text{Im}[\text{altsum}(n)]$ has:
- **Zeros** at all integers $n$
- **Asymmetric oscillation**: touches 0 at integers, dips negative between them
- **Decaying envelope**: amplitude $\sim 1/n$

This asymmetric, decaying oscillation is precisely what makes the integral converge to a finite value ($\pi$) rather than oscillating unboundedly.

### Cumulative integral

| Upper limit $N$ | $\int_0^N 4 \cdot \text{Im}[\text{altsum}] \, dn$ |
|-----------------|---------------------------------------------------|
| 10              | 3.07                                              |
| 50              | 3.12                                              |
| 100             | 3.13                                              |
| $\infty$        | $\pi = 3.14159...$                                |

## 4. The Circle Transformation

### The problem with the original function

When plotted in polar coordinates with $r = 4 \cdot \text{Im}[\text{altsum}(n/\pi)]$ and $\theta = n$, the result is a **drifting spiral**, not a circle. This is because:
- The amplitude decays as $\sim 1/n$
- The oscillation is asymmetric (biased negative)

### The solution: multiply by $n$

By multiplying by $n$ (the inverse of the $1/n$ envelope), we obtain:

$$
n \cdot 4 \cdot \text{Im}[\text{altsum}(n)] = 2\sin(n\pi)
$$

This is an **exact algebraic identity** for all $n$ (verified via `ComplexExpand`).

### The resulting circle

In polar coordinates with $\theta = n/\pi$:

$$
r(\theta) = \frac{\theta}{\pi} \cdot 4 \cdot \text{Im}\left[\text{altsum}\left(\frac{\theta}{\pi}\right)\right] = 2\sin(\theta)
$$

This is the classic polar circle $r = 2\sin(\theta)$:
- **Center**: $(0, 1)$ in Cartesian coordinates
- **Radius**: $1$
- **Diameter**: $2$
- **Passes through origin**: at $\theta = 0, \pi, 2\pi, \ldots$

## 5. Angular Velocity Around the Center

For the polar circle $r = A\sin(\theta)$, the Cartesian coordinates relative to the center $(0, A/2)$ are:

$$
\begin{aligned}
x_{\text{rel}} &= \frac{A}{2}\sin(2\theta) \\
y_{\text{rel}} &= -\frac{A}{2}\cos(2\theta)
\end{aligned}
$$

This traces a circle with angle $\phi = 2\theta - \pi/2$ around the center.

**Key result:** The angular velocity around the true center is **constant**:

$$
\frac{d\phi}{d\theta} = 2
$$

This means:
- The motion around the center is **uniform circular motion**
- The point completes one full revolution as $\theta$ goes from $0$ to $\pi$ (not $2\pi$)
- The angular velocity is **twice** the parameter rate

## 6. Double Integral Form

The complete journey from Chebyshev lobes to $\pi$ in a single double integral:

$$\boxed{\int_0^\infty \text{Im}\left[\int_0^n (-1)^k \cdot \frac{8 - 2n^2 + n^2\left(\cos\frac{2(k-1)\pi}{n} + \cos\frac{2k\pi}{n}\right)}{8n - 2n^3} \, dk\right] dn = \frac{\pi}{4}}$$

And the circle identity connecting the inner integral to polar coordinates:

$$\boxed{n \cdot 4 \cdot \text{Im}\left[\int_0^n (-1)^k A_n(k) \, dk\right] = 2\sin(n\pi) = r(\theta)\big|_{\theta=n\pi}}$$

where $r = 2\sin\theta$ is the polar circle centered at $(0, 1)$ with radius 1.

## 7. The Chebyshev-Cosine Deviation Identity

A bonus identity discovered while comparing paths to $\pi$:

$$\boxed{\int_0^\infty \frac{2 - 2\cos(k\pi)}{k^3 - 4k} \, dk = \int_0^{2\pi} \frac{\cos(t) - 1}{2t} \, dt = \frac{-\gamma + \text{Ci}(2\pi) - \ln(2\pi)}{2}}$$

where $\gamma \approx 0.5772$ is the Euler-Mascheroni constant and $\text{Ci}$ is the cosine integral.

**Numerical value:** $\approx -1.2188$

### Cleaner form using Cin

The identity can be written more elegantly using the **entire cosine integral** $\text{Cin}(x) = \int_0^x \frac{1-\cos(t)}{t} dt$:

$$\boxed{\int_0^\infty \frac{4(1 - \cos(k\pi))}{k(4-k^2)} \, dk = \text{Cin}(2\pi)}$$

where $\text{Cin}(2\pi) = \gamma - \text{Ci}(2\pi) + \ln(2\pi) \approx 2.4377$.

Without the factor of 4: $\int_0^\infty \frac{1 - \cos(k\pi)}{k(4-k^2)} \, dk = \frac{\text{Cin}(2\pi)}{4}$

**References:** [Wikipedia: Trigonometric integral](https://en.wikipedia.org/wiki/Trigonometric_integral), [DLMF §6.2](https://dlmf.nist.gov/6.2)

### Self-consistency form

The identity can be expressed entirely in terms of Cin and its derivative $\text{Cin}'(x) = \frac{1-\cos(x)}{x}$:

$$\boxed{\int_0^\infty \frac{4\pi \cdot \text{Cin}'(k\pi)}{4-k^2} \, dk = \text{Cin}(2\pi)}$$

### Matched-argument form

With substitution $u = k\pi/2$, the Cin' argument matches the RHS:

$$\boxed{\int_0^\infty \frac{2\pi^2 \cdot \text{Cin}'(2u)}{\pi^2 - u^2} \, du = \text{Cin}(2\pi)}$$

- **Poles** at $u = \pm\pi$
- **At the pole** $u = \pi$: $\text{Cin}'(2\pi)$ — same argument as RHS
- This is a **self-consistency relation** specific to the Chebyshev structure

The kernel $\frac{2\pi^2}{\pi^2 - u^2} = \frac{2\pi^2}{(\pi-u)(\pi+u)}$ makes $\pi$ the "resonant point" — the identity evaluates Cin at twice the pole location.

### Infinite rotations = One rotation

This identity has a beautiful interpretation:

- **LHS**: The factor $\cos(k\pi)$ oscillates forever ($+1, -1, +1, -1, \ldots$), creating infinite rotations with decaying amplitude ($\sim 1/k^3$)
- **RHS**: Integrates over exactly **one period** $[0, 2\pi]$ of cosine

The identity says: *Infinite damped oscillations accumulate to half of one period's deviation integral.*

The decay factor $1/(k(4-k^2))$ is precisely calibrated so that the infinite winding "collapses" to a single period — analogous to how $e^{2\pi i} = 1$ (going around once returns to 1).

### Partial integrals do NOT match

Interestingly, defining $L(N) = \int_0^N \text{LHS integrand}$ and $R(T) = \int_0^T \text{RHS integrand}$, the partial integrals follow completely different paths but converge to the same limit. There is no simple transformation $g$ such that $L(k) = R(g(k))$ for all $k$ — the identity is a "limit miracle" where two independent integrals conspire to the same value.

### Origin

The left side arises from $\int\int [T_{k+1}(x) - xT_k(x)] \, dx \, dk$ — a direct Chebyshev polynomial double integral.

## Summary

| Transformation | Result | Interpretation |
|----------------|--------|----------------|
| $4 \cdot \text{Im}[\text{altsum}(n)]$ | Decaying asymmetric oscillation | Spiral in polar |
| $\int_0^\infty 4 \cdot \text{Im}[\text{altsum}] \, dn$ | $\pi$ | Definite integral identity |
| $n \cdot 4 \cdot \text{Im}[\text{altsum}(n)]$ | $= 2\sin(n\pi)$ (exact) | Perfect circle $r = 2\sin\theta$ |

The Chebyshev signed lobe integral, after envelope compensation, reduces to the simplest possible polar circle.

---

*Discovered: November 30, 2025*
