# E-Prime Connections: The s_n Sequence and Prime Distribution

**Session:** 2025-12-19
**Status:** Open (characterization problem unsolved)

## The Sequence

The continued fraction convergents of Euler's e have denominators satisfying:

$$s_0 = 1, \quad s_1 = 7, \quad s_n = (4n+2) \cdot s_{n-1} + s_{n-2}$$

First terms: 1, 7, 71, 1001, 18089, 398959, 10391023, ...

**Key observation:** $s_1 = 7$ — the prime 7 is the "seed" of this sequence.

---

## Main Findings

### 1. Which Primes Divide $s_n$?

**~37% of primes** divide some $s_n$ (35/95 up to 500). The rest never do.

| Prime p | First n | Pattern | Differences |
|---------|---------|---------|-------------|
| 7 | n = 1 | n ≡ 1, 3 (mod 7) | {2, 5} |
| 11 | n = 3 | n ≡ 3, 5 (mod 11) | {2, 9} |
| 13 | n = 3 | n ≡ 3, 7 (mod 13) | {4, 9} |
| 71 | n = 2 | s₂ = 71 itself | {7, 64} |

**Primes that NEVER divide $s_n$:** 2, 3, 5, 17, 19, 23, 29, 37, 43, 47, 53, 59, 61, 67, 73, ...

**Key pattern:** Each dividing prime has exactly **2 residue classes** where $p \mid s_n$.

### 2. Why Periodicity is NOT Obvious

The recurrence $s_n = (4n+2) \cdot s_{n-1} + s_{n-2}$ has **coefficient depending on n**.

This is NOT a linear recurrence with constant coefficients (like Fibonacci).

- For Fibonacci: $F_n \mod p$ is always periodic (Pisano period)
- For $s_n$: periodicity depends on whether the orbit contains a zero

**Open question:** What characterizes primes that divide/don't divide some $s_n$?

### 3. Prime Underdispersion (Universal Phenomenon)

Testing uniformity of prime distribution across residue classes:

| Modulus m | k = φ(m) | Fano ratio | Interpretation |
|-----------|----------|------------|----------------|
| 7 | 6 | 0.039 | 25× more uniform than random |
| 11 | 10 | 0.039 | 25× more uniform than random |
| 13 | 12 | 0.029 | 34× more uniform than random |
| 77 | 60 | 0.147 | 7× more uniform than random |

**Key insight:** Smaller k → stronger underdispersion.

This is a **universal property of primes** (Bombieri-Vinogradov theorem), NOT special to 77 or e.

### 4. The 77 Extension Was Arbitrary

We originally studied 77 = 7 × 11 because:
- $s_1 = 7$ (seed)
- $11 \mid s_3 = 1001$

But this extension was **arbitrary**:
- Could have used 7 × 13 = 91 (since $13 \mid s_3$ too)
- Could have used 7 × 71 = 497 (since $s_2 = 71$)

**The truly special number is 7 alone** — the initial condition of the recurrence.

The group-theoretic structure $(Z/77Z)^* \cong C_2 \times C_{30}$ is just standard number theory, not connected to e.

---

## Conclusions

1. **The s_n sequence has interesting divisibility structure:**
   - ~37.5% of primes divide some term
   - Dividing primes have exactly 2 residue classes
   - Periodicity is non-trivial (coefficient depends on n)

2. **77 has no special connection to prime distribution:**
   - Prime underdispersion is universal (not 77-specific)
   - The 77 = 7 × 11 factorization was arbitrary

3. **If studying e-prime connections, focus on 7 alone:**
   - $s_1 = 7$ is the genuinely special fact
   - The extension to 77 added complexity without insight

---

### 5. Orbit Structure (New Findings)

**Period:** The sequence $s_n \mod p$ has period **exactly 2p**.

**Orbit properties:**
- Orbit is symmetric: $v$ is hit iff $p-v$ is hit
- Covers ~60% of $\mathbb{Z}/p\mathbb{Z}$ (varies by prime)
- Dividing primes: exactly 4 zeros in orbit (2 positions × 2 in period)
- Non-dividing primes: NO zeros in orbit at all

**Matrix formulation:**
$$\begin{pmatrix} s_n \\ s_{n-1} \end{pmatrix} = M_n M_{n-1} \cdots M_1 \begin{pmatrix} 1 \\ 1 \end{pmatrix}, \quad M_n = \begin{pmatrix} 4n+2 & 1 \\ 1 & 0 \end{pmatrix}$$

Full period product $M_{2p-1} \cdots M_0 \equiv I \pmod{p}$ (confirming period = 2p).

### 6. Half-Width Interval Connection

The EulerEInterval half-widths have denominators:
$$\text{denom}(\text{width}_k) = s_{2k-1} \cdot s_{2k}$$

**Equivalence:** $p \mid s_n$ for some $n$ ⟺ $p \mid$ (some half-width denominator)

### 7. Sequence Not in OEIS

The sequence of primes dividing some $s_n$:
$$7, 11, 13, 31, 41, 71, 79, 97, 101, 103, 107, 157, 173, 181, 199, \ldots$$

**Not found in OEIS** as of 2025-12-19. Could be submitted as new sequence.

---

## Partial Characterization

### Partial Necessary Condition (With Counterexample)

**Hypothesis:** If p divides some $s_n$, then:
$$\text{lcm}(\text{ord}_p(7), \text{ord}_p(11), \text{ord}_p(13)) \geq \frac{p - 1}{2}$$

**Evidence (165 primes up to 1000, excluding 7, 11, 13):**
- Dividing primes: 57 total
- Dividing with lcm < (p-1)/2: **0** (condition holds up to 1000)
- Non-dividing with lcm ≥ (p-1)/2: 105 (condition not sufficient)

**Borderline cases (lcm = (p-1)/2 exactly):**
- Dividing: 5 primes (283, 439, 523, 653, 887)
- Non-dividing: 8 primes (53, 113, 131, 139, 503, 563, 607, 641)

**⚠️ COUNTEREXAMPLE at p = 1453:**
- p = 1453 divides $s_n$ (verified)
- lcm(ord(7), ord(11), ord(13)) = 363 = (p-1)/4
- This is LESS than (p-1)/2 = 726

**Conclusion:** The condition lcm ≥ (p-1)/2 is **NOT necessary**. The characterization remains open.

**Interpretation:** The values 7, 11, 13 are "key generators" (s₁ = 7, s₃ = 7×11×13), but their multiplicative orders do not fully characterize which primes divide the sequence.

### Failed Attempts

Individual orders **did NOT work**:
- ord(7) mod p alone (no threshold)
- ord(11) mod p alone (no threshold)
- Legendre symbols (7|p), (11|p) (both QR and NQR in both classes)
- Residue classes p mod 7, 11, 28, 44 (no clean pattern)
- Quadratic forms x² + 7y² (partial overlap only)

---

## Open Questions

1. **Characterization of dividing primes:**
   - No simple necessary condition found (p=1453 breaks lcm hypothesis)
   - What property makes the orbit hit 0?
   - Why do ~37% of primes divide some $s_n$?

2. **The "2 classes" phenomenon:**
   - Why exactly 2 residue classes for each dividing prime?
   - Differences always sum to p: {a, p-a} pattern
   - Connected to orbit symmetry (v hit ⟺ p-v hit)?

3. **Relation to Bessel functions:**
   - $s_n = (-1)^{n+1} y_{n+1}(-2)$ where $y_n$ is Bessel polynomial
   - The e-spiral uses $K_{2t\pm 1}(-1/2)$

4. **Proved vs Observed:**
   - $p = 2$ never divides: **PROVED** (since $4n+2 \equiv 0$, orbit locked to $s_n \equiv 1$)
   - Period = 2p: **OBSERVED** (all tested primes)
   - Exactly 2 residue classes: **OBSERVED** (all dividing primes tested)
   - LCM hypothesis: **FALSIFIED** (counterexample p=1453)

---

## Scripts

- `classify-v3.wl` - Find all dividing primes up to bound
- `orbit-size.wl` - Analyze orbit sizes and multiplicative orders
- `zero-condition.wl` - Matrix and orbit zero analysis
- `half-width-check.wl` - Connection to EulerEInterval
- `test-combined.wl` - Combined ord(7), ord(11), ord(13) analysis
- `uniformity-test.wl` - Chi-squared and Fano factor analysis
