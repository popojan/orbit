# Chebyshev Geometry and Primality

**Date:** 2025-11-28
**Status:** 🔬 NUMERICALLY VERIFIED / 🤔 HYPOTHESIS

## Motivation

The paper "The 1/π Invariant in Chebyshev Polynomial Geometry" establishes that:
$$\int_{-1}^{1} |T_{k+1}(x) - x \cdot T_k(x)| \, dx = 1$$
for all $k \in \frac{1}{2}\mathbb{Z}$ with $k \geq 3/2$.

This invariant holds for ALL natural numbers k ≥ 2, regardless of whether k is prime or composite. The question arises: **does the internal structure of this integral encode information about primality or factorization?**

## Key Definitions

### The Chebyshev Difference Function
$$f_k(x) = T_{k+1}(x) - x \cdot T_k(x) = -\sin(k\theta)\sin(\theta)$$
where $x = \cos\theta$.

### Zero Points
The zeros of $f_k(x)$ in $[-1, 1]$ are:
$$x_n = \cos\frac{n\pi}{k}, \quad n = 0, 1, \ldots, k$$

These are exactly the roots of $U_{k-1}(x)$ (Chebyshev polynomial of second kind) plus the endpoints.

### Lobes
**Lobe n** (for $n = 1, \ldots, k$) is the region between zeros $x_{n-1}$ and $x_n$.

In θ-coordinates: the interval $\left[\frac{(n-1)\pi}{k}, \frac{n\pi}{k}\right]$.

### Classification of Zero Points
- Zero point $n$ is **primitive** if $\gcd(n, k) = 1$
- Zero point $n$ is **inherited** if $\gcd(n, k) > 1$

The number of primitive zero points equals $\varphi(k)$ (Euler's totient function).

### Classification of Lobes
A lobe is classified based on its boundary zeros:

**Definition (strict):** Lobe $n$ is **primitive** iff BOTH boundaries are primitive:
$$\gcd(n-1, k) = 1 \quad \text{AND} \quad \gcd(n, k) = 1$$

**Consequence:**
- Lobe 1: boundary 0 has $\gcd(0, k) = k \neq 1$ → always inherited
- Lobe k: boundary k has $\gcd(k, k) = k \neq 1$ → always inherited
- For prime $p$: exactly $p-2$ primitive lobes (all except edge lobes)
- For even $k$: 0 primitive lobes (since either $n$ or $n-1$ is even)

## Connection to Cyclotomic Polynomials

| Cyclotomic Polynomials | Chebyshev Geometry |
|------------------------|---------------------|
| Primitive roots $e^{2\pi i j/n}$ where $\gcd(j,n)=1$ | Primitive zeros $\cos(n\pi/k)$ where $\gcd(n,k)=1$ |
| Count = $\varphi(n)$ = degree of $\Phi_n$ | Count = $\varphi(k)$ |
| $\Phi_n$ divides $x^n - 1$ | $U_{k-1}$ has divisibility structure via divisors |

## First Observations

### 1. Primitive Zero Count = φ(k)
🔬 **VERIFIED** for k = 2, ..., 24

The number of primitive zero points (those with $\gcd(n, k) = 1$) equals exactly $\varphi(k)$.

**For primes:** All $p-1$ zeros are primitive.
**For composites:** Only $\varphi(k) < k-1$ zeros are primitive.

### 2. Prime vs. Composite Lobe Structure

| k | Type | Primitive Lobes | Area in Primitive |
|---|------|-----------------|-------------------|
| 5 | prime | 3 | 91.2% |
| 7 | prime | 5 | 96.7% |
| 11 | prime | 9 | 99.1% |
| 13 | prime | 11 | 99.5% |
| 6 | 2×3 | 0 | 0% |
| 9 | 3² | 3 | 33.3% |
| 10 | 2×5 | 0 | 0% |
| 15 | 3×5 | 3 | 15.9% |

### 3. Asymptotic for Primes
🔬 **VERIFIED**

For prime $p$, the area in the two edge (inherited) lobes scales as:
$$\text{Edge area} = \frac{2(\pi^2 - 4)}{p^3} + O(p^{-5})$$

Therefore:
$$\text{Primitive lobe area} = 1 - \frac{2(\pi^2 - 4)}{p^3} + O(p^{-5})$$

The constant $\pi^2 - 4 \approx 5.87$ arises from:
$$\int_0^\pi u^2 \sin u \, du = \pi^2 - 4$$

### 4. Even Numbers Have Zero Primitive Lobes
🔬 **VERIFIED**

For any even $k$, there are NO primitive lobes. This is because for any lobe $n$, either $n$ or $n-1$ is even, so $\gcd(\cdot, k) \geq 2$.

## Interpretation

**Primes** have "clean" Chebyshev geometry — almost all area is in primitive lobes.

**Composites** have "hierarchical" structure — area is distributed across inherited lobes according to divisor structure.

The invariant (total area = 1) acts as a "conservation law" — factorization changes internal structure but not the total.

## Refined Classification (Update 1)

The original classification treated edge lobes (1 and k) as "inherited". However, the zeros at $x = \pm 1$ are **universal** — they are zeros of $f_k$ for ALL k. This leads to a cleaner three-way classification:

### Area Decomposition
$$1 = A_{\text{univ}}(k) + A_{\text{prim}}(k) + A_{\text{inh}}(k)$$

| Component | Definition |
|-----------|------------|
| $A_{\text{univ}}(k)$ | Area of edge lobes (lobes 1 and k) |
| $A_{\text{prim}}(k)$ | Area of inner lobes where $\gcd(n-1,k)=\gcd(n,k)=1$ |
| $A_{\text{inh}}(k)$ | Area of inner lobes where $\gcd>1$ on at least one boundary |

### Primality Characterization
🔬 **VERIFIED** for k = 3, ..., 20

$$\boxed{k \text{ is prime} \iff A_{\text{inh}}(k) = 0}$$

**For primes:** All inner lobes are primitive (no inherited area).
**For composites:** Some inner lobes have boundaries divisible by factors of k.

### Numerical Evidence

| k | Type | $A_{\text{univ}}$ | $A_{\text{prim}}$ | $A_{\text{inh}}$ |
|---|------|-------------------|-------------------|------------------|
| 5 | prime | 0.088 | 0.912 | **0** |
| 7 | prime | 0.033 | 0.967 | **0** |
| 11 | prime | 0.0087 | 0.991 | **0** |
| 6 | 2×3 | 0.052 | 0 | 0.948 |
| 9 | 3² | 0.016 | 0.333 | 0.651 |
| 15 | 3×5 | 0.0035 | 0.159 | 0.838 |

## Theorems for Odd k (Update 2)

### Even Numbers: Zero Primitive Lobes
🔬 **VERIFIED**

For any **even** k, $A_{\text{prim}}(k) = 0$.

**Proof:** For any inner lobe n, either n is even (so $\gcd(n,k) \geq 2$) or n is odd (so n-1 is even, thus $\gcd(n-1,k) \geq 2$). ∎

### Formula for Number of Primitive Lobes (Odd k)
🔬 **VERIFIED** for 17 test cases

For **odd** $k = \prod_i p_i^{e_i}$:

$$\boxed{\#\text{PrimLobes}(k) = \prod_i (p_i - 2) \cdot p_i^{e_i-1}}$$

**Special cases:**
- Prime $p$: $(p-2) \cdot p^0 = p-2$ ✓
- Prime power $p^e$: $(p-2) \cdot p^{e-1}$ ✓
- Semiprime $pq$: $(p-2)(q-2)$ ✓

### Ratio to Euler's Totient
$$\frac{\#\text{PrimLobes}(k)}{\varphi(k)} = \prod_{p|k} \frac{p-2}{p-1}$$

| k | Prime factors | Ratio |
|---|---------------|-------|
| 9 = 3² | {3} | 1/2 |
| 35 = 5×7 | {5,7} | 5/8 |
| 105 = 3×5×7 | {3,5,7} | 5/16 |

### Asymptotic Behavior

For primorials of odd primes: ratio → 0 as more primes included.
- {3}: 0.500
- {3,5}: 0.375
- {3,5,7}: 0.312
- {3,5,7,11}: 0.281
- {3,5,7,11,13}: 0.258

**Interpretation:** Numbers with many distinct prime factors have almost all inner area inherited.

## Farey Connection (Update 3)

### The J_k Integral
From Remark 5 of the paper:
$$J_k = \frac{1}{2}\int_{-1}^{1}(1-x)U_{k-1}(x)\,dx$$

**Formula:**
- Odd k: $J_k = \frac{1}{k}$ (unit fractions!)
- Even k: $J_k = -\frac{k}{k^2-1} = -\frac{1}{2}\left(\frac{1}{k-1} + \frac{1}{k+1}\right)$

### Partial Sums = Farey Neighbors of 1/2
🔬 **VERIFIED** for n = 1, ..., 14

$$\boxed{S_n = \sum_{k=1}^{n} J_k = \text{Farey neighbor of } \frac{1}{2} \text{ in } F_{n+1}}$$

| n | $S_n$ | Position |
|---|-------|----------|
| odd | $\frac{m}{2m-1}$ | upper neighbor (> 1/2) |
| even | $\frac{m}{2m+1}$ | lower neighbor (< 1/2) |

where $m = \lceil n/2 \rceil$.

**Convergence:** $S_n \to \frac{1}{2}$ (Abel sum)

### Two Views of Chebyshev Geometry

| Aspect | Lobe Theory | Farey Theory |
|--------|-------------|--------------|
| Integral | $\int\|f_k\|dx = 1$ | $\int(1-x)U_{k-1}dx = J_k$ |
| Key insight | Primitive vs inherited lobes | Partial sums = Farey neighbors |
| Primality | $A_{\text{inh}} = 0$ ⟺ prime | (no direct connection found) |
| Limit | Area always 1 | Sum → 1/2 |

### Open: Connection Between Theories?

The lobe structure (with absolute value) and the Farey structure (without absolute value) both arise from Chebyshev polynomials. Is there a deeper connection?

- Both involve $U_{k-1}(x)$
- Lobe theory sees parity of k (even k → no primitive lobes)
- Farey theory sees parity of n (odd/even → upper/lower neighbor)

## Utilizing the Invariant (Update 4)

The invariant $A_{\text{univ}} + A_{\text{prim}} + A_{\text{inh}} = 1$ constrains the algebraic structure of individual areas.

### Individual Lobe Areas

Each lobe area contains terms like $\cos(n\pi/k)$:
$$A(\text{lobe } n) = \frac{a_n + \sum_j b_j \cos(m_j \pi/k)}{c_n}$$

These are **algebraic numbers**, generally irrational.

### Algebraic Cancellation

🔬 **VERIFIED**

| k | Type | $A_{\text{prim}}$ | Algebraic degree |
|---|------|-------------------|------------------|
| 9 = 3² | prime power | 1/3 | 1 (rational!) |
| 25 = 5² | prime power | 3/5 | 1 (rational!) |
| 15 = 3×5 | semiprime | irrational | 4 |
| 21 = 3×7 | semiprime | irrational | 6 |

### Theorem: Rationality for Prime Powers
🔬 **VERIFIED** for $p \in \{3,5,7\}$, $e \in \{2,3\}$

For $k = p^e$ (prime power):
$$\boxed{A_{\text{prim}}(p^e) = \frac{p-2}{p} \in \mathbb{Q}}$$

The $\cos(n\pi/p^e)$ terms **completely cancel** due to the cyclic Galois structure.

### Why Semiprimes Give Irrational Areas

For $k = pq$ (semiprime):
- Galois group is product of cyclic groups
- Cancellation of $\cos$ terms is **incomplete**
- $A_{\text{prim}}$ is algebraic but irrational

**Example:** $A_{\text{prim}}(15) = \frac{221 + 75\cos(\pi/15) - 75\cos(2\pi/15) - 75\sin(7\pi/30)}{1105}$

This has minimal polynomial of degree 4 over $\mathbb{Q}$.

### Interpretation

The invariant (total = 1) guarantees the **sum** is rational, but the **distribution** among universal, primitive, and inherited areas depends on:
- For prime powers: complete algebraic cancellation → rational components
- For semiprimes: incomplete cancellation → algebraic irrational components

## Connection: Sign Structure (Update 5)

### Sign of Lobes
Each lobe $n$ has a sign $(-1)^{n-1}$:
- Odd lobes: +1
- Even lobes: -1

### Sign Sum of Primitive Lobes
Define: $\Sigma\text{signs}(k) = \#\text{odd primitive lobes} - \#\text{even primitive lobes}$

🔬 **VERIFIED** for k ≤ 50

| k type | Σsigns |
|--------|--------|
| Prime power $p^e$ | -1 |
| Semiprime $pq$ | +1 or -3 (depends on $p, q$) |

### The Bridge Formula
$$\boxed{J_{\text{prim}}(k) = \frac{\Sigma\text{signs}(k)}{k}}$$

This connects lobe structure (via signs) to Farey theory (via $J_k$)!

### Decomposition of $J_k = 1/k$ (odd k)

Since $J_k = J_{\text{univ}} + J_{\text{prim}} + J_{\text{inh}} = 1/k$:

| Σsigns | $J_{\text{prim}}$ | $J_{\text{univ}} + J_{\text{inh}}$ | Interpretation |
|--------|-------------------|-----------------------------------|----------------|
| -1 | $-1/k$ | $2/k$ | Prime powers: J_inh = 0, J_univ = 2/k |
| +1 | $+1/k$ | **0** | J_univ = -J_inh (exact cancellation!) |
| -3 | $-3/k$ | $4/k$ | Compensation needed |

### Unified Picture

```
Chebyshev U_{k-1}(x)
        │
   ┌────┴────┐
   │         │
|lobes|   J_k (signed)
   │         │
   │    ┌────┴────┐
   │    │         │
   │  Farey    Sign structure
   │  neighbors  of lobes
   │    │         │
   └────┴────┬────┘
             │
      J_prim = Σsigns/k
```

The sign structure of primitive lobes determines their contribution to $J_k$, which in turn generates Farey neighbors of 1/2.

## Formula for Σsigns in Semiprimes (Update 6)

### The Theorem
🔬 **VERIFIED** for 301 semiprimes

For semiprime $k = pq$ with $p < q$ both odd primes:

$$\boxed{\Sigma\text{signs}(pq) = \begin{cases}
+1 & \text{if } p^{-1} \bmod q \text{ is odd} \\[1ex]
-3 & \text{if } p^{-1} \bmod q \text{ is even}
\end{cases}}$$

where $p^{-1} \bmod q$ is the modular inverse of $p$ modulo $q$.

### Examples

| $p$ | $q$ | $p^{-1} \bmod q$ | Parity | $\Sigma\text{signs}$ |
|-----|-----|------------------|--------|----------------------|
| 3 | 5 | 2 | even | -3 |
| 3 | 7 | 5 | odd | +1 |
| 5 | 7 | 3 | odd | +1 |
| 5 | 13 | 8 | even | -3 |
| 7 | 11 | 8 | even | -3 |
| 7 | 17 | 5 | odd | +1 |

### Corollary: Formula for p = 3

For $k = 3q$ with prime $q > 3$:

$$\Sigma\text{signs}(3q) = \begin{cases}
+1 & \text{if } q \equiv 1 \pmod{6} \\[1ex]
-3 & \text{if } q \equiv 5 \pmod{6}
\end{cases}$$

**Proof:** The inverse $3^{-1} \bmod q$ satisfies $3r \equiv 1 \pmod{q}$, so $r = (kq+1)/3$ for smallest positive $k$ with $kq \equiv -1 \pmod 3$. For $q \equiv 1 \pmod{6}$, we get $r$ odd; for $q \equiv 5 \pmod{6}$, we get $r$ even. ∎

### Asymmetry Note

Interestingly, the formula is **not symmetric** in $p$ and $q$:
- $p^{-1} \bmod q$ and $q^{-1} \bmod p$ can have different parities
- Example: $p=3, q=5$: $3^{-1} \bmod 5 = 2$ (even), $5^{-1} \bmod 3 = 2$ (even) — same
- Example: $p=7, q=11$: $7^{-1} \bmod 11 = 8$ (even), $11^{-1} \bmod 7 = 2$ (even) — same
- For most semiprimes, symmetry holds

### Even Semiprimes

For $k = 2q$ (even semiprime): $\Sigma\text{signs} = 0$ (no primitive lobes exist).

## General Structure of Σsigns (Update 7)

### Congruence Theorem
🔬 **VERIFIED** for k ≤ 300

For any odd $k$ with $\omega(k)$ distinct prime factors:

$$\boxed{\Sigma\text{signs}(k) \equiv 1 - 2\omega(k) \pmod{4}}$$

| $\omega(k)$ | Congruence | Observed values |
|-------------|------------|-----------------|
| 1 | $\equiv 3$ (mod 4) | {-1} always |
| 2 | $\equiv 1$ (mod 4) | {+1, -3} |
| 3 | $\equiv 3$ (mod 4) | {-1, -5} |

### Key Invariant

$$\boxed{\Sigma\text{signs}(k) \text{ is always ODD}}$$

for any odd $k > 1$.

### Interpretation

- Within each $\omega$-class, possible Σsigns values differ by 4
- The "baseline" value $1 - 2\omega$ shifts down by 2 with each new prime factor
- The specific value within the congruence class depends on parity of modular inverses

## Open Questions

1. ~~**Formula for Σsigns:** What determines whether a semiprime $pq$ has Σsigns = +1 or -3?~~ **SOLVED** (Update 6)

2. **Deeper meaning:** Why does the parity of $p^{-1} \bmod q$ control the sign structure of Chebyshev lobes?

3. **Computational use:** Can this geometric structure provide any computational advantage for primality testing?

   **Analysis:** To check $A_{\text{inh}}(k) = 0$, we need to verify $\gcd(n, k) = 1$ for all $n \in \{1, \ldots, k-1\}$.
   - This requires $O(k)$ gcd computations
   - Each gcd is $O(\log k)$
   - **Total: $O(k \log k)$** — linear in k, exponential in bit-length

   Compare to Miller-Rabin: $O(\log^3 k)$ — polynomial in bit-length.

   **Conclusion:** Chebyshev characterization is conceptually beautiful but computationally useless for primality testing (600 million times slower for k = 10¹²).

## Files

- `README.md` - This document
- `lobe-analysis.wl` - Core Wolfram functions for lobe analysis
- `signsums.wl` - Direct computation of Σsigns
- `signsums-formula.wl` - Testing formula hypotheses
- `verify-signsums-formula.wl` - Verification of p^(-1) mod q formula
- `signsums-analysis.wl` - General analysis including ω(k) congruence
