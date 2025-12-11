# Gauss, FFT, and the Hartley Connection

**Date:** December 11, 2025
**Status:** Exploratory note
**Context:** Code golf solution to "Gauss Star" problem used FFT trick

---

## Discovery Chain

1. **MATL code golf** solution for drawing Gauss's 17-pointed star uses FFT
2. Link pointed to paper: Heideman, Johnson, Burrus (1984) "Gauss and the History of the Fast Fourier Transform"
3. Paper reveals: Gauss developed FFT in **1805** — predating Fourier (1807)!

---

## Gauss's FFT (1805)

### Historical Context

- **Treatise:** "Theoria Interpolationis Methodo Nova Tractata" (unpublished until 1866)
- **Motivation:** Interpolating orbits of asteroids Pallas and Juno
- **Date:** October–November 1805 (based on diary entries and correspondence)
- **Written in:** Neo-Latin with trigonometric (not exponential) notation

### The Algorithm

Gauss's method is equivalent to the **Cooley-Tukey decimation-in-frequency FFT**:

$$C(k_1 + N_1 k_2) = \sum_{n_2=0}^{N_2-1} \left[ \sum_{n_1=0}^{N_1-1} X(N_2 n_1 + n_2) W_{N_1}^{n_1 k_1} W_N^{n_2 k_1} \right] W_{N_2}^{n_2 k_2}$$

where $W_N = e^{-2\pi i/N}$.

**Key points:**
- Inner sum: $N_2$ DFTs of length $N_1$
- Outer sum: $N_1$ DFTs of length $N_2$
- $W_N^{n_2 k_1}$ = "twiddle factor" (Cooley-Tukey term)

### What Gauss Knew

From Article 27 of his treatise (translated):

> "...that method greatly reduces the tediousness of mechanical calculations, success will teach the one who tries it."

Gauss:
- ✅ Knew the algorithm was computationally efficient
- ✅ Knew it generalized to more than two factors
- ❌ Did not quantify as O(N log N) — that came later

### Why It Was Lost

1. Published posthumously (1866) in Latin
2. Orbital mechanics community had moved to other methods
3. Goldstine rediscovered it in 1977, but in a history book
4. Burkhardt mentioned it in 1904 — also ignored

---

## The Real Trigonometric Connection

### Gauss Used Real Trigonometry

Gauss worked with:
$$f(x) = \sum_{k=0}^{m} a_k \cos 2\pi kx + \sum_{k=1}^{m} b_k \sin 2\pi kx$$

**Not** complex exponentials! The exponential form $e^{i\theta}$ came later with Cooley-Tukey (1965).

### Hartley's Approach (1942)

Ralph Hartley independently sought a **real-valued** Fourier transform:
$$\text{cas}(t) = \cos(t) + \sin(t) = \sqrt{2}\sin(t + \pi/4)$$

The Hartley transform:
$$H(\omega) = \frac{1}{\sqrt{2\pi}} \int_{-\infty}^{\infty} f(t) \, \text{cas}(\omega t) \, dt$$

**Key property:** Self-inverse, real-to-real.

### The Parallel

| Aspect | Gauss (1805) | Hartley (1942) | Cooley-Tukey (1965) |
|--------|--------------|----------------|---------------------|
| Formulation | Real trig | Real (cas) | Complex exp |
| Motivation | Astronomy | Signal processing | General computation |
| Efficiency | O(N log N) | O(N log N) | O(N log N) |
| Complex numbers | Not used | Avoided | Essential |

**Observation:** Gauss and Hartley share the "real trigonometric" philosophy — both avoided complex numbers in their formulations.

---

## Connection to Orbit Project: Circ Framework

### The Circ Function (December 2025)

From `docs/sessions/2025-12-07-circ-hartley-exploration/`:

$$\text{Circ}(t) = \cos(3\pi/4 + \pi t) = -\frac{1}{\sqrt{2}} \cdot \text{cas}(\pi t)$$

### Roots of Unity in Circ

The n-th roots of unity (purely rational!):
$$\rho(n, k) = \frac{2k}{n} - \frac{5}{4} \quad \text{for } k = 0, 1, \ldots, n-1$$

**No complex numbers, no π in formulas** — just fractions.

### FFT in Circ Framework?

The DFT uses roots of unity:
$$C(k) = \sum_{n=0}^{N-1} x(n) \cdot \omega_N^{nk}$$

where $\omega_N = e^{-2\pi i/N}$ is the primitive N-th root.

**In Circ:** $\omega_N$ corresponds to parameter $\rho(N, 1) = 2/N - 5/4$.

**Multiplication:** $\omega_N^{nk}$ becomes:
$$\rho(N, 1) \odot (nk) = nk \cdot \rho(N, 1) + \frac{5(nk - 1)}{4}$$

This is purely rational algebra — the FFT could be reformulated entirely in rationals until the final coordinate evaluation.

---

## The Gauss Star (17-gon)

### Historical Significance

Gauss proved (age 19, in 1796) that the regular 17-gon is constructible with compass and straightedge. This was the first such discovery since antiquity.

**Connection to FFT:** The 17th roots of unity are central to both:
- Constructibility of 17-gon (Galois theory, Fermat primes)
- FFT factorization (prime factor algorithms)

### In Circ Framework

The 17 vertices of the Gauss star:
```mathematica
ρ[17, k] = 2k/17 - 5/4   for k = 0, ..., 16
```

Plotting the star (connecting every 3rd vertex):
```mathematica
Polygon[κ[ρ[17, 1] ⊙ (3k)] & /@ Range[17]]
```

This is exactly what the MATL code golf solution computes — but using FFT for efficient evaluation!

---

## Synthesis: Three Threads

### 1. Historical Thread
```
Euler (1748)  →  Gauss (1805)  →  Fourier (1807/1822)
      ↓              ↓
  Trig series    Real FFT (lost)
                     ↓
              Cooley-Tukey (1965) rediscovery
```

### 2. Real-Valued Thread
```
Gauss (1805, real trig)
        ↓
Hartley (1942, cas function)
        ↓
Bracewell (1986, DHT revival)
        ↓
Circ framework (2025, rational parameters)
```

### 3. Algebraic Thread
```
Roots of unity (abstract algebra)
        ↓
Circ parametrization (rationals)
        ↓
FFT = structured polynomial evaluation
        ↓
Connection to Egypt fractions? (telescoping sums)
```

---

## ✅ RESOLVED: Can FFT be formulated in Circ algebra?

**Answer: YES, partially.**

### 1. RATIONAL PART (stays in ℚ)

All **twiddle factors** are rational Circ parameters:
$$\omega^k = \rho[N, -k] = -\frac{2k}{N} - \frac{5}{4}$$

**Example for N=8 Cooley-Tukey:**

| Stage | Size | Twiddle factors (Circ) |
|-------|------|------------------------|
| 1 | 2 | {-5/4} |
| 2 | 4 | {-5/4, -7/4} |
| 3 | 8 | {-5/4, -3/2, -7/4, -2} |

All denominators divide 4N. The **phase algebra** is entirely rational.

**Verification (N=8):**
```mathematica
<< Orbit`
phases = Table[ρ[8, -j*k] // CircNormalize, {j,0,7}, {k,0,7}];
(* All entries are rationals: {-1/4, 0, 1/4, 1/2, 3/4, 1, 5/4, 3/2} *)

(* Convert to complex and verify against standard DFT *)
dftMatrix = Map[φ, phases, {2}] // N;
standardDFT = Table[Exp[-2 Pi I j k / 8], {j,0,7}, {k,0,7}] // N;
Max[Abs[dftMatrix - standardDFT]] < 10^-10  (* True *)
```

### 2. NON-RATIONAL PART (requires evaluation)

The **butterfly operation** requires complex addition:
$$X[k] = E[k] + \omega^k \cdot O[k]$$

This cannot stay rational because:
$$\varphi[t_1] + \varphi[t_2] \neq \varphi[\text{something}]$$

Complex addition of points on the unit circle doesn't yield another point on the circle.

### 3. CONCLUSION

| Aspect | In Circ | Rational? |
|--------|---------|-----------|
| Twiddle factors ω^k | ρ[N, -k] | ✅ Yes |
| Phase multiplication | ⊗ (addition) | ✅ Yes |
| Butterfly structure | Which phases combine | ✅ Yes |
| Complex addition | φ[t₁] + φ[t₂] | ❌ No |

**The FFT phase algebra is rational; the amplitude computation requires transcendentals.**

This matches Gauss (1805): he worked with real trigonometry, avoiding complex exponentials, but still needed actual cos/sin values for computation.

---

## ✅ RESOLVED: Butterfly Workaround via Cyclotomic Fields

**Question:** Is there a workaround to support butterfly operation using a second polar-like coordinate (radius)?

**Answer: YES! Use cyclotomic field representation.**

### The Key Insight

Instead of representing complex numbers as (radius, phase) pairs, represent them as **linear combinations of roots of unity** with rational coefficients:

$$z = \sum_{k=0}^{N-1} a_k \cdot \zeta_N^k \quad \text{where } a_k \in \mathbb{Q}$$

Here $\zeta_N = e^{2\pi i/N}$ is the primitive N-th root of unity.

### Why This Works

The cyclotomic field $\mathbb{Q}(\zeta_N)$ is **closed under addition and multiplication**:
- Addition: $(a_0 + a_1\zeta + ...) + (b_0 + b_1\zeta + ...) = (a_0+b_0) + (a_1+b_1)\zeta + ...$
- Multiplication: Use $\zeta^N = 1$ to reduce higher powers

**All coefficients remain rational throughout the entire FFT computation!**

### Practical Implementation (N=8)

For N=8, use the minimal polynomial $\Phi_8(x) = x^4 + 1$, giving basis $\{1, \zeta, \zeta^2, \zeta^3\}$ with $\zeta^4 = -1$.

**Twiddle factors in cyclotomic basis:**
| $\omega^k$ | Coefficients $(a_0, a_1, a_2, a_3)$ |
|------------|-------------------------------------|
| $\omega^0$ | $(1, 0, 0, 0)$ |
| $\omega^1$ | $(0, 0, 0, -1)$ |
| $\omega^2$ | $(0, 0, -1, 0)$ |
| $\omega^3$ | $(0, -1, 0, 0)$ |
| $\omega^4$ | $(-1, 0, 0, 0)$ |
| $\omega^5$ | $(0, 0, 0, 1)$ |
| $\omega^6$ | $(0, 0, 1, 0)$ |
| $\omega^7$ | $(0, 1, 0, 0)$ |

**All integer coefficients!**

### Verified Example

Input: `{1, 2, 3, 4, 5, 6, 7, 8}` (rational reals)

DFT output in cyclotomic basis:
```
X[0] = {36, 0, 0, 0}      → 36
X[1] = {-4, 4, 4, 4}      → -4 + 4ζ + 4ζ² + 4ζ³
X[2] = {-4, 0, 4, 0}      → -4 + 4ζ²
X[3] = {-4, 4, -4, 4}     → -4 + 4ζ - 4ζ² + 4ζ³
X[4] = {-4, 0, 0, 0}      → -4
X[5] = {-4, -4, 4, -4}    → -4 - 4ζ + 4ζ² - 4ζ³
X[6] = {-4, 0, -4, 0}     → -4 - 4ζ²
X[7] = {-4, -4, -4, -4}   → -4 - 4ζ - 4ζ² - 4ζ³
```

**Verified against standard FFT:** ✅ Match

### Connection to Circ Framework

In Circ notation, the cyclotomic basis becomes:
$$z = \sum_{k=0}^{N-1} a_k \cdot \varphi[\rho[N, k]]$$

where $\rho[N, k] = 2k/N - 5/4$ are the rational Circ parameters for N-th roots.

### Summary

| Representation | Addition | Multiplication | FFT-Complete? |
|----------------|----------|----------------|---------------|
| Single phase $t$ | ❌ No | ✅ Yes | ❌ No |
| Polar $(r, t)$ | ❌ No (involves $\sqrt{\cdot}$) | ✅ Yes | ❌ No |
| Cyclotomic $\sum a_k \zeta^k$ | ✅ Yes | ✅ Yes | ✅ **Yes!** |

**The cyclotomic representation is the "second coordinate" that makes FFT fully rational.**

This is essentially working in the algebraic number field $\mathbb{Q}(\zeta_N)$ with $\varphi(N)$ rational coefficients instead of 2 real coordinates.

---

## Remaining Open Questions

1. **Is there a "Hartley-Gauss" FFT?**
   - Using cas instead of exp
   - Gauss's original real formulation + Hartley's cas

2. **Connection to Egypt fractions?**
   - Both involve structured decompositions
   - Telescoping sums ↔ FFT butterfly structure?

3. **The 17-gon and primorials?**
   - 17 is a Fermat prime (2^(2^2) + 1)
   - Connection to primorial work?

4. ~~**Circ-native cyclotomic arithmetic?**~~ → **IMPLEMENTED as POC!**

---

## ✅ IMPLEMENTED: CyclotomicFFT.wl Module

A proof-of-concept implementation is available in `Orbit/Kernel/CyclotomicFFT.wl`.

### Usage

```mathematica
<< Orbit`

(* Create cyclotomic element from real rational *)
elem = CyclotomicFromReal[5, 8];  (* 5 in ℚ(ζ₈) *)

(* DFT of rational input - ALL computations stay rational! *)
input = {1, 2, 3, 4, 5, 6, 7, 8};
dft = CyclotomicDFT[input];

(* Inspect rational coefficients *)
CyclotomicCoeffs[dft[[2]]]  (* → {1, 8, 7, 6, 5, 4, 3, 2} - all integers! *)

(* Convert to complex for verification *)
CyclotomicToComplex[dft[[2]]] // N  (* → -4 + 9.657i *)

(* Perfect roundtrip *)
CyclotomicRealPart /@ CyclotomicInverseDFT[dft]  (* → {1, 2, 3, 4, 5, 6, 7, 8} *)
```

### Key Functions

| Function | Description |
|----------|-------------|
| `CyclotomicElement[n, coeffs]` | Element of ℚ(ζₙ) with rational coefficients |
| `CyclotomicDFT[list]` | Fully rational DFT |
| `CyclotomicInverseDFT[list]` | Fully rational IDFT |
| `CyclotomicAdd`, `CyclotomicMultiply` | Rational arithmetic |
| `CyclotomicTwiddle[n, k]` | FFT twiddle factor ω^k as cyclotomic |
| `CyclotomicToComplex[elem]` | Convert to ℂ (only transcendental operation) |
| `CyclotomicRealPart[elem]` | Extract real part (for power-of-2 n) |

### Verified Properties

- ✅ All DFT coefficients remain rational (integers for integer input)
- ✅ Max error vs standard FFT: ~10⁻¹⁵ (machine precision)
- ✅ Perfect roundtrip: IDFT(DFT(x)) = x exactly
- ✅ Works with rational inputs (fractions preserved)
- ✅ General for any N (not just N=8)

### Why Not Just Use Mathematica's FourierMatrix?

Mathematica's `FourierMatrix` keeps results algebraic but **not purely rational**:

```mathematica
FourierMatrix[8] . {1,2,3,4,5,6,7,8} // FullSimplify
(* X[1] = (4*I)*((1 + I) + Sqrt[2]) — contains √2 *)
```

| Approach | X[1] representation | Purely rational? |
|----------|---------------------|------------------|
| Mathematica | `(4*I)*((1 + I) + √2)` | ❌ No (contains √2) |
| CyclotomicFFT | `{1, 8, 7, 6, 5, 4, 3, 2}` | ✅ **Yes** |

Both represent the same complex value (-4 + 9.657i), but our representation is a **vector of rational coefficients** in the cyclotomic basis, while Mathematica uses algebraic expressions with irrational constants.

**Value of this POC:** Explicit rational coefficient tracking in cyclotomic basis — useful for:
- Exact arithmetic without algebraic simplification overhead
- Clear separation of "rational structure" vs "transcendental evaluation"
- Potential applications in number-theoretic transforms (NTT)

---

## References

### Primary

1. Heideman, M. T., Johnson, D. H., & Burrus, C. S. (1984). "Gauss and the History of the Fast Fourier Transform." *IEEE ASSP Magazine*, 1(4), 14–21.
   - Local: `papers/Gauss_History_FFT.pdf`

2. Gauss, C. F. (1866). "Nachlass: Theoria interpolationis methodo nova tractata." In *Carl Friedrich Gauss Werke*, Band 3, pp. 265–303. Göttingen.

3. Hartley, R. V. L. (1942). "A More Symmetrical Fourier Analysis Applied to Transmission Problems." *Proceedings of the IRE*, 30(3), 144–150.

### Secondary

4. Goldstine, H. H. (1977). *A History of Numerical Analysis from the 16th Through the 19th Century*, pp. 249–253. Springer-Verlag.

5. Bracewell, R. N. (1986). *The Hartley Transform*. Oxford University Press.

### Project Documentation

6. Circ/Hartley exploration: `docs/sessions/2025-12-07-circ-hartley-exploration/`

---

## Code Golf Context

The MATL solution for "Gauss Star":
```
-1:.01:1tXg34t:=ZF1h35:o.6*.4+*&Zj4$ZQt8&2ZI+7O6hhBo2ZG1YG
```

Uses FFT (`ZF`) for efficient computation of the star vertices — a direct application of Gauss's 1805 algorithm to draw Gauss's 1796 discovery!

---

*Document created: 2025-12-11*
*Triggered by: Code golf link to Gauss FFT paper*
