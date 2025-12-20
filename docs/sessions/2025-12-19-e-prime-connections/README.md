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

### 8. Bessel Polynomial Closed Form

The $s_n$ sequence has an explicit closed form via Bessel polynomials:

**Bessel polynomial:**
$$y_n(x) = \sum_{k=0}^{n} \frac{(n+k)!}{(n-k)! \, k!} \left(\frac{x}{2}\right)^k$$

Alternative form: $y_n(x) = {}_2F_0(-n, n+1; \, ; -x/2)$ (terminating hypergeometric)

**Connection to $s_n$:**
$$s_n = (-1)^{n+1} \cdot y_{n+1}(-2)$$

First values of $y_n(-2)$: 1, −1, 7, −71, 1001, −18089, 398959, ...

**Euler e monotone term:**
$$\text{term}_j = \frac{4(4j+3)}{y_{2j}(-2) \cdot y_{2j+2}(-2)} = \frac{4(4j+3)}{s_{2j-1} \cdot s_{2j+1}}$$

**Series for e:**
$$e = 1 + \sum_{j=0}^{\infty} \frac{4(4j+3)}{s_{2j-1} \cdot s_{2j+1}}$$

First terms: $\frac{12}{7}, \frac{4}{1001}, \frac{4}{36305269}, \ldots$

**Comparison with ETermCanonical:**

| Form | BesselK order | Type | Index symmetry |
|------|---------------|------|----------------|
| ETerm (discrete) | Half-integer $K_{n+1/2}$ | Bessel polynomial (finite sum) | $y_{2j}, y_{2j+2}$ (asymmetric) |
| ETermCanonical | Integer $K_{2t-1}, K_{2t+1}$ | Transcendental (infinite series) | symmetric around $2t$ |

The ETermCanonical formula:
$$g(t) = \frac{-16t \pi e}{K_{2t-1}(-\tfrac{1}{2}) \cdot K_{2t+1}(-\tfrac{1}{2})}$$

**Two-level structure:**

Half-integer BesselK terminates at Level 1:
$$K_{n+1/2}(z) = \sqrt{\frac{\pi}{2z}} e^{-z} \cdot \sum_{k=0}^{n} \frac{(n+k)!}{k!(n-k)!} (2z)^{-k} \quad \text{(finite polynomial)}$$

Integer-order BesselK expands to Level 2:
$$K_n(z) = \text{polynomial} + (-1)^{n+1} \log(z/2) \cdot I_n(z) + \text{digamma series}$$

where $I_n(z) = \sum_{k=0}^{\infty} \frac{(z/2)^{n+2k}}{k!(n+k)!}$ is an infinite series.

**Connection:** $y_n(-2) = \frac{i \cdot K_{n+1/2}(-\tfrac{1}{2})}{\sqrt{e\pi}}$

This means:

- **ETerm** (half-integer $K$) → unfolds to finite Bessel polynomial → DONE
- **ETermCanonical** (integer $K$) → unfolds to $I_n$, $\log$, $\psi$ (digamma) → genuine analytic continuation

### Key Discovery: BesselK-Free Closed Form (2025-12-20)

**Trick:** Evaluate ETermCanonical at $t + \frac{3}{4}$ instead of integer $t$:

$$g\left(t + \frac{3}{4}\right) = \frac{-16(t + \frac{3}{4}) \pi e}{K_{2t+\frac{1}{2}}\left(-\frac{1}{2}\right) \cdot K_{2t+\frac{5}{2}}\left(-\frac{1}{2}\right)}$$

The orders $2t + \frac{1}{2}$ and $2t + \frac{5}{2}$ are now **half-integer** (for integer $t$), so they reduce to Bessel polynomials!

Using $K_{n+\frac{1}{2}}\left(-\frac{1}{2}\right) = -i\sqrt{\pi e} \cdot y_n(-2)$:

$$K_{2t+\frac{1}{2}} \cdot K_{2t+\frac{5}{2}} = (-i\sqrt{\pi e})^2 \cdot y_{2t}(-2) \cdot y_{2t+2}(-2) = -\pi e \cdot y_{2t}(-2) \cdot y_{2t+2}(-2)$$

**Result — TRUE CLOSED FORM without BesselK:**

$$\boxed{g\left(t + \frac{3}{4}\right) = \frac{4(4t+3)}{y_{2t}(-2) \cdot y_{2t+2}(-2)}}$$

where the Bessel polynomial evaluated at $x = -2$:

$$y_n(-2) = \sum_{k=0}^{n} \frac{(n+k)!}{(n-k)! \, k!} (-1)^k$$

**Values:** $y_0 = 1, \; y_1 = -1, \; y_2 = 7, \; y_3 = -71, \; y_4 = 1001, \; y_5 = -18089, \; y_6 = 398959, \ldots$

**Connection to $s_n$:** $y_n(-2) = (-1)^n \cdot s_{n-1}$ for $n \geq 1$

**Properties of this form:**

- ✅ Finite sum (not infinite series)
- ✅ No recursion needed
- ✅ No transcendental functions (only factorials)
- ✅ BesselK completely eliminated
- ✅ Numerically verified to match ETermCanonical

### 9. Egypt ↔ EulerE Connection (2025-12-20)

**EgyptianFractionsInterval** and **EulerEInterval** share convergents:

- `EgyptianFractionsInterval[E, MaxItems -> 6n-1]` lower bound = `EulerEInterval[n]` lower bound
- `EgyptianFractionsInterval[E, MaxItems -> 6n+2]` upper bound = `EulerEInterval[n]` upper bound

**Relationship:** $s_n = q_{3n+1}$ where $q_i$ are CF denominators of e (0-indexed).

**Egypt closed form for e:**
$$e = 2 + \sum_{k=1}^{\infty} \frac{n_k}{q_{2k-2} \cdot q_{2k}}$$

where $q_n$ are CF denominators and $n_k = \{2, 1, 1, 6, 1, 1, 10, 1, 1, 14, \ldots\}$

Pattern for $n_k$: equals 2 if k=1, equals $4m+2$ if $k = 3m+1$ for $m \geq 1$, equals 1 otherwise.

**Comparison:**

| Form | Requires recursion? | True closed form? |
|------|--------------------|--------------------|
| Egypt ($q_n$) | YES | NO |
| EulerE ($s_n$) | YES | NO |
| Bessel polynomial $y_n(-2)$ | NO (explicit sum) | **YES** |
| ETermCanonical (BesselK) | NO | YES (but transcendental) |
| **$g(t+\frac{3}{4})$ form** | NO | **YES (elementary!)** |

### 10. The e² Convergence Identity (2025-12-20)

**Discovery:** The ratio of Bessel polynomial products converges to e²:

$$\lim_{t \to \infty} \frac{y_{2t}(2) \cdot y_{2t+2}(2)}{s_{2t-1} \cdot s_{2t+1}} = e^2$$

**Bessel polynomial at x = 2:**

$$y_n(2) = \sum_{k=0}^{n} \frac{(n+k)!}{(n-k)! \, k!}$$

First values: $y_0(2) = 1, \; y_1(2) = 3, \; y_2(2) = 19, \; y_3(2) = 201, \; y_4(2) = 3001, \ldots$ (OEIS A001515)

**Both sequences satisfy the same recursion:**

$$a_{n+1} = (4n+2) \cdot a_n + a_{n-1}$$

- $y_n(2)$: starts with $y_0(2) = 1, y_1(2) = 3$
- $s_n$ (i.e., $|y_n(-2)|$): starts with $s_0 = 1, s_1 = 7$

**Numerical verification:**

| t | $\frac{y_{2t}(2) \cdot y_{2t+2}(2)}{s_{2t-1} \cdot s_{2t+1}}$ | Error from $e^2$ |
|---|--------------------------------------------------------------|------------------|
| 0 | 8.14286 | $\approx 0.75$ |
| 1 | 7.41584 | $\approx 0.027$ |
| 2 | 7.38969 | $\approx 7 \times 10^{-4}$ |
| 5 | 7.38906 | $< 10^{-15}$ |
| 10 | 7.38906 | $< 10^{-58}$ |

**Convergence rate:** Extremely fast (super-exponential).

**Even/Odd matrix decomposition:**

For the product matrix $M_{mn} = y_m(x) \cdot y_n(x)$:

$$\text{Even part} = \frac{y_m(2) y_n(2) + y_m(-2) y_n(-2)}{2}$$

$$\text{Odd part} = \frac{y_m(2) y_n(2) - y_m(-2) y_n(-2)}{2}$$

The e² identity arises from the ratio of these products at specific indices.

**Connection to e-series:**

The discrete ETerm formula:

$$e = 1 + \sum_{t=0}^{\infty} \frac{4(4t+3)}{s_{2t-1} \cdot s_{2t+1}}$$

Combined with the e² identity suggests deeper structure connecting:

- CF denominators $s_n$ (encode rational approximations to e)
- Bessel polynomials $y_n(2)$ (purely combinatorial)
- The constant $e^2$

### 11. Wronskian Structure and the Alternating Series (2025-12-20)

**Key insight:** $y_n(2)$ and $s_n$ are two solutions of the SAME recurrence with different initial conditions.

| Sequence | Recurrence | Initial values |
|----------|------------|----------------|
| $y_n(2)$ | $a_{n+1} = (4n+2)a_n + a_{n-1}$ | $y_0=1, y_1=3$ |
| $s_n$ | $a_{n+1} = (4n+2)a_n + a_{n-1}$ | $s_0=1, s_1=7$ |

**Wronskian identity (exact):**

$$y_n(2) \cdot s_{n-2} - y_{n-1}(2) \cdot s_{n-1} = (-1)^{n+1} \cdot 2$$

**Ratio convergence:**

Define $r_n = \frac{y_n(2)}{s_{n-1}}$. Then:

$$\lim_{n \to \infty} r_n = e$$

First values: $r_2 = 19/7 \approx 2.714$, $r_3 = 193/71 \approx 2.718$, $r_4 = 2721/1001 \approx 2.71828...$

**The e² identity explained:**

$$\frac{y_{2t}(2) \cdot y_{2t+2}(2)}{s_{2t-1} \cdot s_{2t+1}} = r_{2t} \cdot r_{2t+2} \to e^2$$

The e² limit is simply the product of two $r_n$ values, each converging to e.

**Alternating series for e (from Wronskian):**

The telescoping identity $r_n - r_{n-1} = \frac{(-1)^{n+1} \cdot 2}{s_{n-2} \cdot s_{n-1}}$ gives:

$$\boxed{e = 3 + \sum_{k=0}^{\infty} \frac{(-1)^{k+1} \cdot 2}{s_k \cdot s_{k+1}}}$$

This is a **new alternating series for e** derived from the Wronskian structure.

**Product simplification:**

The original product of sums can be written as:

$$s_{2t-1} \cdot s_{2t+1} = \frac{y_{2t}(2) \cdot y_{2t+2}(2)}{r_{2t} \cdot r_{2t+2}}$$

where $r_n = e - \text{tail}_n$ and $\text{tail}_n = \sum_{j \geq n-1} \frac{(-1)^{j+1} \cdot 2}{s_j \cdot s_{j+1}} \to 0$.

Asymptotically: $s_{2t-1} \cdot s_{2t+1} \sim \frac{y_{2t}(2) \cdot y_{2t+2}(2)}{e^2}$

**Summary of two series for e:**

| Type | Formula | Convergence |
|------|---------|-------------|
| Monotone | $e = 1 + \sum_{t=0}^{\infty} \frac{4(4t+3)}{s_{2t-1} \cdot s_{2t+1}}$ | From below |
| Alternating | $e = 3 + \sum_{k=0}^{\infty} \frac{(-1)^{k+1} \cdot 2}{s_k \cdot s_{k+1}}$ | Oscillating |

Both series use the same $s_n$ sequence (CF denominators for e).

**Matrix form (det = ±2):**

$$W_n = \begin{pmatrix} y_n(2) & y_{n-1}(2) \\ s_{n-1} & s_{n-2} \end{pmatrix}, \quad \det(W_n) = (-1)^{n+1} \cdot 2$$

**Error bound (without knowing e):**

$$|e - r_n| < \frac{2}{s_{n-1} \cdot s_{n-2}}$$

**Recovery formula:**

$$y_n(2) = \frac{(-1)^{n+1} \cdot 2 + y_{n-1}(2) \cdot s_{n-1}}{s_{n-2}}$$

Compute only $s_n$, recover $y_n(2)$ via Wronskian.

**Modular constraint:** When $s_{k} \equiv 0 \pmod{p}$:

$$y_{k+1}(2) \cdot s_{k-1} \equiv (-1)^{k} \cdot 2 \pmod{p}$$

### 12. Fast Recurrence for e (2025-12-20)

**Single recurrence, two initial conditions:**

$$\boxed{a_{n+1} = (4n+2) \cdot a_n + a_{n-1}}$$

| Sequence | $a_0$ | $a_1$ | Values |
|----------|-------|-------|--------|
| $p_n$ (čitatel) | 1 | 3 | 1, 3, 19, 193, 2721, 49171, ... |
| $q_n$ (jmenovatel) | 1 | 1 | 1, 1, 7, 71, 1001, 18089, ... |

**Aproximace:**

$$e_n = \frac{p_n}{q_n} \to e$$

| n | $p_n/q_n$ | Chyba |
|---|-----------|-------|
| 2 | 19/7 | $4 \times 10^{-3}$ |
| 4 | 2721/1001 | $10^{-7}$ |
| 6 | 1084483/398959 | $5 \times 10^{-13}$ |
| 8 | ... | $6 \times 10^{-19}$ |
| 10 | ... | $3 \times 10^{-25}$ |

**Konvergence:** ~2-3 číslice na krok (rostoucí s n).

**Asymptoticky:** Zisk $\sim \log_{10}(4n)$ číslic na krok.

**Porovnání metod (pro 25 číslic):**

| Metoda | Počet kroků | Operace |
|--------|-------------|---------|
| Taylorova řada | ~12 | 12 dělení + 12 sčítání |
| Řetězový zlomek | ~30 | 30 kroků zpětné substituce |
| **Tato rekurence** | ~10 | 10 násobení + 10 sčítání + 1 dělení |

**Benchmark (Wolfram):**

| n | Recurrence | FromCF | Vítěz |
|---|------------|--------|-------|
| 10 | 0.038 ms | 0.030 ms | CF 1.3x |
| 50 | 0.137 ms | 0.066 ms | CF 2.1x |
| 100 | 0.263 ms | 0.112 ms | CF 2.3x |

**Poznámka:** `FromContinuedFraction` je v Mathematica vysoce optimalizovaná.
Rekurence je užitečná pro: (1) přímý přístup k páru $(p_n, q_n)$,
(2) implementaci v jiných jazycích, (3) spojitost s Bessel polynomy.

**Posunutá rekurence (indexy souhlasí s EulerEConvergent):**

$$a_{k+1} = (4k+6) \cdot a_k + a_{k-1}$$

| Sekvence | Start | Hodnoty |
|----------|-------|---------|
| $p_n$ (čitatel) | $p_1=19$ | 19, 193, 2721, 49171, ... = $y_{n+1}(2)$ |
| $q_n$ (jmenovatel) | $q_1=7$ | 7, 71, 1001, 18089, ... = $s_n$ |

**Paclet API:**

```wolfram
<< Orbit`
EulerERational[10]                (* = EulerEConvergent[10] *)
EulerERecurrencePair[5]           (* {1084483, 398959} *)
EulerERational[5, Method->"Both"] (* verify recurrence = closed form *)
```

### 13. Symmetric Monotone Bounds for e² (2025-12-20)

**Problem:** The original e² formula alternates direction:

$$\frac{y_n(2) \cdot y_{n+2}(2)}{y_n(-2) \cdot y_{n+2}(-2)} \to e^2$$

- n even → converges from below
- n odd → converges from above

**Cause:** $y_n(-2) = (-1)^n |y_n(-2)|$ alternates sign. With indices (n, n+2) of same parity, magnitudes create asymmetric convergence.

**Solution:** Use consecutive indices (n, n+1) with mixed parity:

$$\text{bound}(n) = \left| \frac{y_n(2) \cdot y_{n+1}(2)}{y_n(-2) \cdot y_{n+1}(-2)} \right|$$

**Monotone interval bounds:**

| Starting index | Direction | Formula |
|----------------|-----------|---------|
| n = 2k (even) | from below ↑ | $\text{bound}(2k) \nearrow e^2$ |
| n = 2k+1 (odd) | from above ↓ | $\text{bound}(2k+1) \searrow e^2$ |

**Numerical verification:**

| k | lower = bound(2k) | upper = bound(2k+1) | width |
|---|-------------------|---------------------|-------|
| 1 | 7.378269... | 7.389131... | $1.1 \times 10^{-2}$ |
| 2 | 7.389055800... | 7.389056099... | $3.0 \times 10^{-7}$ |
| 3 | 7.38905609892934... | 7.38905609893065... | $1.3 \times 10^{-12}$ |
| 4 | 7.389056098930650225... | 7.389056098930650227... | $1.6 \times 10^{-18}$ |

**Wolfram one-liner:**

```wolfram
y[n_, x_] := Sum[Factorial[n+k]/(Factorial[n-k] Factorial[k]) (x/2)^k, {k, 0, n}];
bound[n_] := Abs[y[n, 2] y[n+1, 2] / (y[n, -2] y[n+1, -2])];
(* bound[2k] < E^2 < bound[2k+1], both monotone *)
```

**Paclet API:**

```wolfram
<< Orbit`
EulerESquareInterval[3]  (* Interval[{7.3890560989293..., 7.3890560989306...}] *)
Normal[%][[1]]           (* {lower, upper} as list *)
```

**Key insight:** Shifting from (n, n+2) to (n, n+1) — moving one index by 1 — transforms alternating convergence into monotone interval bounds.

### 14. Improved Rational Bounds via Mediant (2025-12-20)

**Discovery:** `EulerEConvergent[n]` has a simpler closed form:

$$\text{EulerEConvergent}[n] = \frac{y_{n+1}(2)}{s_n} = \frac{y_{n+1}(2)}{|y_{n+1}(-2)|}$$

This is just the ratio of Bessel polynomials at $x = 2$ and $x = -2$!

**Combining e and e² intervals:** Taking $\sqrt{\text{EulerESquareInterval}}$ gives 2× tighter bounds for e, but the bounds become irrational (algebraic).

**Better approach — Mediant (Farey sum):**

The mediant of two fractions $\frac{a}{b}$ and $\frac{c}{d}$ is $\frac{a+c}{b+d}$.

For consecutive EulerE convergents, the mediant is always BELOW e, giving:

$$\text{EulerEIntervalMediant}[k] = \left[\text{med}(T_{2k-1}, T_{2k}), \; T_{2k}\right]$$

**Comparison of all interval methods:**

| Method | Type | Improvement | Formula |
|--------|------|-------------|---------|
| `EulerEInterval` | Rational | baseline | $[T_{2k-1}, T_{2k}]$ |
| `EulerEIntervalHarmonic` | Rational | exactly 2× | $[\text{HM}, T_{2k}]$ |
| `EulerEIntervalGeometric` | Algebraic | ~2× | $\sqrt{\text{e}^2 \text{ bounds}}$ |
| **`EulerEIntervalMediant`** | **Rational** | **10-40×** | $[\text{Med}, T_{2k}]$ |

**Mediant improvement grows with k:**

| k | Standard width | Mediant width | Factor |
|---|----------------|---------------|--------|
| 1 | $4 \times 10^{-3}$ | $4 \times 10^{-4}$ | 11× |
| 2 | $1 \times 10^{-7}$ | $6 \times 10^{-9}$ | 19× |
| 3 | $5 \times 10^{-13}$ | $2 \times 10^{-14}$ | 27× |
| 4 | $6 \times 10^{-19}$ | $2 \times 10^{-20}$ | 35× |

**Why Harmonic = 2× exactly:**

For $\text{lo} \approx \text{hi} \approx e$:
$$\text{hi} - \text{HM} = \frac{\text{hi}(\text{hi} - \text{lo})}{\text{lo} + \text{hi}} \approx \frac{\text{hi} - \text{lo}}{2}$$

**Why Mediant improvement grows:**

$$\frac{\text{hi} - \text{lo}}{\text{hi} - \text{Med}} = \frac{q + s}{q}$$

where $q, s$ are denominators. Since $s > q$ and both grow, the ratio increases.

**Paclet API:**

```wolfram
<< Orbit`
EulerEIntervalMediant[3]   (* Interval[{...rational...}], 27× tighter *)
EulerEIntervalHarmonic[3]  (* Interval[{...rational...}], 2× tighter *)
EulerEIntervalGeometric[3] (* Interval[{...√rational...}], 2× tighter *)
```

### 15. Stern-Brocot Tree and e (Wildberger-style) (2025-12-20)

**Connection:** The mediant operation is the fundamental operation of the Stern-Brocot tree.

The continued fraction of e encodes a path in the SB tree:
$$e = [2; 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, \ldots]$$

**Triad structure:**
$$e = [2; (1, 2k, 1) \text{ for } k = 1, 2, 3, \ldots]$$

Each triad $(1, 2k, 1)$ in CF corresponds to path $L \, R^{2k} \, L$ in SB tree.

**Wildberger-style algorithm to reach e:**

1. Start at root: $\frac{0}{1} \oplus \frac{1}{0} = \frac{1}{1}$
2. Go $R$ twice (reach $\frac{3}{1}$)
3. Repeat forever for $k = 1, 2, 3, \ldots$:
   - $L$ once
   - $R$ $(2k)$ times
   - $L$ once

**Generated sequence:** $\frac{2}{1}, \frac{3}{1}, \frac{8}{3}, \frac{11}{4}, \frac{19}{7}, \frac{30}{11}, \ldots, \frac{193}{71}, \ldots$

**Why EulerEConvergent uses every 3rd:**

The triad $(1, 2k, 1)$ has period 3 in the CF. Each `EulerEConvergent[n]` corresponds to completing one full triad, giving the $(3n+2)$-th standard convergent.

**Mediant as semiconvergent:**

When we compute `EulerEIntervalMediant[k]`, we're finding the next node in the SB tree between two consecutive EulerE convergents — this is precisely a semiconvergent.

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
   - $s_n = (-1)^{n+1} y_{n+1}(-2)$ where $y_n(x) = \sum_{k=0}^{n} \frac{(n+k)!}{(n-k)! k!} (x/2)^k$
   - This gives TRUE closed form (no recursion needed)
   - The e-spiral analytic continuation uses $K_{2t\pm 1}(-1/2)$

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
