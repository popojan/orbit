# Complex Analysis of the Completed Lobe Area Function B(n,k)

**Date:** December 2, 2025
**Status:** Proven results

## Motivation

Study the analytic properties of the Completed Lobe Area function B(n,k) as a function
of complex k. The key question: what can complex analysis tell us about this Chebyshev-derived
function, and how does it compare to classical entire functions like Riemann's xi?

## Definitions

### Lobe Area Function A(n,k)
```
A(n,k) = 1/n + alpha(n) * cos((2k-1)*pi/n)
```
where `alpha(n) = n*cos(pi/n)/(4-n^2) < 0` for n > 2.

### Completed Lobe Area B(n,k)
```
B(n,k) = n * A(n,k) = 1 + beta(n) * cos((2k-1)*pi/n)
```
where `beta(n) = n^2*cos(pi/n)/(4-n^2)`.

## Key Results

### 1. Holomorphicity

**Theorem:** B(n,k) is an **entire function** in k (holomorphic on all of C).

*Proof:* B(n,k) is a composition of polynomial and cosine functions, both entire.

### 2. Symmetries

| Property | Formula | Type |
|----------|---------|------|
| Periodicity | B(n, k+n) = B(n, k) | Period n |
| Reflection | B(n, 1-k) = B(n, k) | Axis k = 1/2 |
| Complementary | B(n, n+1-k) = B(n, k) | Axis k = (n+1)/2 |
| Even in n | B(-n, k) = B(n, k) | Double-even |

### 3. Critical Points

- **Maximum:** k = (n+1)/2, value -> 2 as n -> infinity
- **Minimum:** k = 1/2, value -> 0 as n -> infinity

### 4. Zeros - Main Result

**Theorem (Closed-Form Zeros):** The zeros of B(n,k) are:

```
k = 1/2 + m*n +/- i * (n / (2*pi)) * ArcCosh((n^2 - 4) / (n^2 * cos(pi/n)))
```

where m in Z. Equivalently, with delta(n) defined as:

```
delta(n) = n * ArcCosh(-1/beta(n)) / (2*pi)
         = n * ArcCosh((n^2 - 4) / (n^2 * cos(pi/n))) / (2*pi)
```

the zeros are at `k = 1/2 + m*n +/- i*delta(n)`.

### 4.1 Removable Singularity at n = 2

The formula for beta(n) has a 0/0 form at n = 2:

```
beta(2) = 4 * cos(pi/2) / (4 - 4) = 0/0
```

However, this is a **removable singularity**. By L'Hopital's rule:

```
lim_{n->2} beta(n) = -pi/4
lim_{n->2} delta(n) = ArcCosh(4/pi) / pi = 0.23025503...
```

The function delta(n) is continuous for all n >= 1 (with removable singularity at n=2):

| n | delta(n) |
|---|----------|
| 1 | 0.28055 |
| 1.5 | 0.24125 |
| 2 | 0.23026 (limit) |
| 3 | 0.22305 |
| 5 | 0.21954 |
| 10 | 0.21809 |
| 100 | 0.21762 |
| infinity | 0.21762 |

delta(n) decreases monotonically from delta(1) ~ 0.281 to delta(infinity) ~ 0.218.

**Theorem (Universal Limit):** As n -> infinity,

```
delta(n) -> sqrt(pi^2 - 8) / (2*pi) = 0.21761808912708625...
```

### 5. Critical Line Property

**Theorem:** ALL zeros of B(n,k) lie on the critical lines Re(k) = 1/2 (mod n).

*Proof:* This follows directly from the closed form. Since zeros are at k = 1/2 + mn +/- i*delta(n),
the real part is always 1/2 + mn = 1/2 (mod n).

**Note:** Unlike the Riemann Hypothesis, this is not a conjecture but a **proven fact**
following from the explicit Fourier structure.

### 6. No Real Zeros

**Theorem:** B(n,k) has no real zeros for any n >= 1.

*Proof:* Zeros occur where cos((2k-1)*pi/n) = -1/beta(n).
For all n >= 1, we have -1/beta(n) > 1, so the equation has no real solutions.

| n | -1/beta(n) | Real zeros? |
|---|------------|-------------|
| 1 | 3 | No |
| 2 | 4/pi = 1.273 | No |
| 3 | 1.111 | No |
| 4 | 1.061 | No |
| 5 | 1.038 | No |
| 10 | 1.009 | No |
| 100 | 1.0001 | No |
| infinity | 1 | Limit only |

### 7. Hadamard Factorization

As an entire function of order 1, B(n,k) admits a product representation:

```
B(n,k) = B(n, (n+1)/2) * prod_{m in Z} [1 + ((k - 1/2 - m*n) / delta(n))^2]
```

This reconstructs B entirely from its zeros.

## Comparison with Riemann Xi

| Property | Riemann xi(s) | B(n,k) |
|----------|---------------|--------|
| Type | Entire function | Entire function |
| Order | 1 | 1 |
| Critical line | Re(s) = 1/2 | Re(k) = 1/2 (mod n) |
| Zeros on critical line | Conjectured (RH) | **Proven** |
| Functional equation | xi(s) = xi(1-s) | B(n,1-k) = B(n,k) |
| Even symmetry | xi(s-bar) = xi(s)-bar | B(-n,k) = B(n,k) |
| Zero locations | Unknown distribution | Explicit: k = 1/2 + mn +/- i*delta |

## The Universal Constant

The imaginary offset of zeros converges to:

```
delta_infinity = sqrt(pi^2 - 8) / (2*pi)
```

### Derivation

For large n:
1. beta(n) = -1 + (pi^2/2 - 4)/n^2 + O(1/n^4)
2. -1/beta(n) = 1 + (pi^2/2 - 4)/n^2 + O(1/n^4)
3. ArcCosh(1 + epsilon) ~ sqrt(2*epsilon) for small epsilon
4. ArcCosh(-1/beta(n)) ~ sqrt(pi^2 - 8) / n
5. delta(n) = n * sqrt(pi^2 - 8) / n / (2*pi) = sqrt(pi^2 - 8) / (2*pi)

### Numerical Verification

| n | delta(n) |
|---|----------|
| 100 | 0.217622846... |
| 1000 | 0.217618136... |
| 10000 | 0.217618089... |
| infinity | 0.217618089127... |

## Geometric Interpretation

The zeros form a **lattice** in the complex plane:
- Real coordinates: 1/2, 1/2 + n, 1/2 + 2n, ... (critical lines)
- Imaginary coordinates: +/- delta(n) (symmetric about real axis)

As n -> infinity, the lattice becomes denser along the real axis while maintaining
fixed imaginary offset ~0.2176.

## Open Questions

1. **Is there a deeper connection** between delta_infinity = sqrt(pi^2 - 8)/(2*pi) and
   other mathematical constants?

2. **Does the product formula** have applications in approximation theory?

3. **Can the "proven RH" property** of B(n,k) inform approaches to the actual RH?

## Implementation

Functions available in Orbit paclet:
- `CompletedLobeArea[n, k]` - B(n,k) via symbolic definition
- `CompletedLobeAreaFourier[n, k]` - B(n,k) via Fourier form

## References

- Previous session: docs/sessions/2025-12-01-chebyshev-polygon-transforms/
- Lobe area kernel document: docs/drafts/lobe-area-kernel.pdf
