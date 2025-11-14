# Computational Utility Analysis: The Final Verdict

## The Circle of Dependencies (from primorial-duality.tex)

For odd prime $m$ with $k = (m-1)/2$:

$$\Sigma_m^{\text{alt}} = \frac{N_{\text{alt}}}{D} = \frac{N_{\text{alt}}}{\text{Primorial}(m)/2}$$

Where:
- $D = \text{Primorial}(m)/2 = \prod_{p \leq m, p \text{ prime}} p / 2$
- $G = \gcd(N_{\text{alt}}, D \cdot \Sigma_m) = \text{LCM}(\text{odd composites } 3, 5, 7, \ldots, m-1)$
- $N_{\text{alt}} = \text{Numerator}[\Sigma_m^{\text{alt}}]$
- $N_{\text{non}} = \text{Numerator}[\Sigma_m^{\text{non-alt}}]$

**Proven relationships:**
1. $D = \text{Primorial}(m)/2$ (exact)
2. $G = \text{LCM}(\text{odd composites } \leq m-1)$ (proven structure)
3. $N_{\text{alt}} \equiv (-1)^{(m+1)/2} \cdot k! \pmod{m}$ (proven congruence)
4. $\gcd(N_{\text{alt}}, D) = 1$ (all factors of $N > m$)
5. $N_{\text{alt}} \approx D \cdot k!/(2k+1) \cdot (1 - 1/k)$ (asymptotic, <1% error)

## Comprehensive Utility Table

| Given | Can Compute | Method | Complexity | Utility Assessment |
|-------|-------------|--------|------------|-------------------|
| **Prime $m$** | $D = \text{Primorial}(m)/2$ | Sieve primes $\leq m$, multiply, divide by 2 | $O(m \log \log m)$ sieve | ✓ **USEFUL** - Fast primorial computation |
| **Prime $m$** | $G$ (GCD structure) | $\text{LCM}(\text{odd composites } \leq m-1)$ | $O(m \log \log m)$ | ✓ Theoretical interest only |
| **Prime $m$** | $N_{\text{alt}}$ | Evaluate $\Sigma_m^{\text{alt}}$, extract numerator | $O(k \cdot k!)$ factorial evaluation | ✗ **NOT USEFUL** - Exponential cost |
| **Prime $m$** | $\Sigma_m^{\text{alt}}$ | Direct sum evaluation | $O(k \cdot k!)$ | ✗ Not useful - expensive |
| **Prime $m$** | $\theta(m)$ | $\log(D)$ after computing $D$ | $O(m \log \log m) + O(\log m)$ | ✓ **USEFUL** - Fast θ via primorial |
| **Primorial(m)** | Prime $m$ | Factorize, find largest prime factor | $O(\sqrt{\text{Primorial}})$ or factor | ✗ Not useful - factorization hard |
| **Primorial(m)** | $D$ | Divide by 2 | $O(1)$ | ✓ Trivial |
| **Primorial(m)** | $N_{\text{alt}}$ | Need to find $m$ first, then evaluate sum | Factorization + exponential | ✗ Not useful - compound difficulty |
| **$D$ (denominator)** | Primorial(m) | Multiply by 2 | $O(1)$ | ✓ Trivial |
| **$D$ (denominator)** | Prime $m$ | Factorize $2D$, find largest prime | Factorization-hard | ✗ Not useful |
| **$D$ (denominator)** | $N_{\text{alt}}$ | Need $m$ first (hard), then sum (expensive) | Factorization + exponential | ✗ Not useful |
| **$G$ (GCD structure)** | Prime $m$ | Factorize, analyze LCM structure | Factorization-hard | ✗ Not useful |
| **$G$ (GCD structure)** | $D$ | Need $m$ first | Factorization-hard | ✗ Not useful |
| **$N_{\text{alt}}$ (numerator)** | Prime $m$ | Search for $m$ where $\text{Numerator}[\Sigma_m] = N$ | $O(\text{search}) \cdot O(k!)$ | ✗ **NOT USEFUL** - Doubly exponential |
| **$N_{\text{alt}}$ (numerator)** | $D$ | Need $m$ first (see above) | Doubly exponential | ✗ Not useful |
| **$N_{\text{alt}}$ (numerator)** | Primality of $N$ | Standard primality tests | $O((\log N)^6)$ AKS or faster | ✓ But unrelated to formula |
| **$\Sigma_m^{\text{alt}}$ (sum value)** | $D$ | Extract denominator of reduced fraction | $O(\log N + \log D)$ GCD | ✓ But already know the value |
| **$\Sigma_m^{\text{alt}}$ (sum value)** | $N_{\text{alt}}$ | Extract numerator | $O(\log N + \log D)$ GCD | ✓ But already know the value |
| **$\Sigma_m^{\text{alt}}$ (sum value)** | Prime $m$ | Estimate from magnitude, search | Search over primes | ✗ Not useful - uncertain |
| **Prime $m$ + $D$** | Consistency check | Verify $D = \text{Primorial}(m)/2$ | $O(m \log \log m)$ | ✓ Verification only |
| **Prime $m$ + $N_{\text{alt}}$** | $\Sigma_m$ | $N_{\text{alt}} / D$ where $D$ from $m$ | $O(m)$ division | ✓ But need $N$ first (hard) |
| **Prime $m$ + estimate of $N$** | Bound on $N_{\text{alt}}$ | Use asymptotic formula | $O(k!)$ for exact $k!$ | △ Bounds too loose (1% = huge) |
| **$D$ + $N_{\text{alt}}$** | $\Sigma_m$ | $N/D$ | $O(\log)$ division | ✓ But both are hard to get independently |
| **$D$ + $N_{\text{alt}}$** | Prime $m$ | Factorize $2D$, find largest prime | Factorization-hard | ✗ Not useful |
| **$N_{\text{alt}}$ + modular constraint** | Narrow $m$ candidates | $N \equiv c \pmod{m}$ gives candidates | Linear search | △ Weak constraint (infinite solutions) |

## Special Computational Angles

| Question | Input | Feasibility | Utility |
|----------|-------|-------------|---------|
| Given large prime $P$, is it a factorial sum numerator? | $P$ | Search small $m$ until $\text{Numerator}[\Sigma_m] = P$ | Certificate verification only |
| Fast primorial computation? | Prime $m$ | **YES** - via sieve | ✓ **ALREADY STANDARD** |
| Prime generation via formula? | Prime $m$ | Evaluate sum, check if $N$ prime | ✗ Too slow (other methods faster) |
| Test primality of $m$ using formula? | Candidate $m$ | Compute $\Sigma_m$, check denominator structure | ✗ Much slower than standard tests |
| Compute $\theta(m)$ without listing primes? | Prime $m$ | $\theta(m) = \log(\text{Primorial}(m))$ | △ Still need primorial first |
| Use GCD structure for anything? | $G$ | Theoretical curiosity | ✗ No computational advantage |
| Extract prime factors of $N$ easily? | $N_{\text{alt}}$ | Standard factorization | ✗ No special structure helps |
| Use asymptotic formula to bound $N$? | Prime $m$ | $N \approx D \cdot k!/(2k+1)(1-1/k)$ | △ 1% error = exponentially large range |
| Invert the formula? | $D$ or $N$ or both | Find $m$ or other components | ✗ **FUNDAMENTALLY HARD** |

## The Circular Dependency Breakdown

```
Given m → (easy) → D → (hard) → m
Given m → (exponential) → N → (super-hard) → m
Given m → (easy) → G → (hard) → m
Given D → (hard) → m → (exponential) → N
Given N → (search) → m → (easy) → D
Given G → (hard) → m → (easy) → D
```

**The pattern:**
- Forward (m → components): Easy to exponential
- Backward (components → m): Hard to super-hard
- Cross (between components without m): Requires going through m (bottleneck)

## Why Inversion Fails: The Fundamental Obstacles

### 1. **The Factorization Barrier**

**Problem:** $D = \text{Primorial}(m)/2$ encodes $m$ as its largest prime factor.

**Obstacle:** Finding largest prime factor requires factorization, which is:
- Computationally hard (no known polynomial algorithm)
- The primorial is the product of ALL primes up to $m$
- Even if factorizable, doesn't help with finding $N$

**Verdict:** No shortcut exists.

### 2. **The Exponential Growth Barrier**

**Problem:** $N_{\text{alt}} \approx D \cdot k!/(2k+1)$ where $k = (m-1)/2$

**Obstacle:**
- $k!$ grows super-exponentially
- Even 1% error bound spans $\sim 10^6$ candidates for $m=17$
- Checking each candidate requires primality testing or factorization
- Grows impossibly large for $m \geq 31$

**Verdict:** Search space is exponentially infeasible.

### 3. **The Modular Constraint Weakness**

**Problem:** $N \equiv (-1)^{(m+1)/2} \cdot k! \pmod{m}$

**Obstacle:**
- Only reduces $N$ modulo $m$
- $N \gg m$ typically (by many orders of magnitude)
- Arithmetic progression has infinitely many solutions
- Combined with other constraints, still leaves exponential candidates

**Verdict:** Too weak to enable inversion.

### 4. **The Definition Circularity**

**Problem:** $N$ is DEFINED as $\text{Numerator}[\sum_{i=1}^k (-1)^i i!/(2i+1)]$

**Obstacle:**
- We proved properties of $D$ (denominator)
- We proved $N \bmod m$ (modular constraint)
- We proved $\gcd(N, D) = 1$ (coprimality)
- But none of these **determine** $N$ without evaluating the sum
- Evaluating the sum IS the definition of $N$

**Verdict:** Cannot escape the definition.

## The Asymmetry: What Works vs. What Doesn't

### ✓ **WORKS: Forward Direction**

| Start | End | Method | Use Case |
|-------|-----|--------|----------|
| Prime $m$ | Primorial(m) | Sieve + multiply | Standard algorithm |
| Prime $m$ | $\theta(m)$ | Log of primorial | Prime counting function |
| Prime $m$ | $D$ | Primorial/2 | Denominator verification |
| Prime $m$ | $G$ | LCM of odd composites | Theoretical analysis |

**Why it works:** Moving from simple (single prime) to complex (product structure).

### ✗ **FAILS: Backward Direction**

| Start | End | Obstacle | Why It Fails |
|-------|-----|----------|--------------|
| $D$ | Prime $m$ | Factorization | Computationally hard problem |
| $N$ | Prime $m$ | Search + exponential | Doubly expensive |
| Primorial(m) | $N$ | Need $m$ + sum evaluation | Factorization + exponential |
| $G$ | Prime $m$ | Factorization of LCM | Hard + structural complexity |
| Asymptotic bound | Exact $N$ | 1% error = exponential range | Bounds too loose |

**Why it fails:** Moving from complex (product/sum) to simple (prime) requires inverting hard problems.

## Final Verdict: Burial of the Dream

### 🪦 **Dreams That Must Be Buried**

1. ✗ **Fast computation of numerator $N$ given only $m$**
   - Reason: Definition requires sum evaluation ($O(k \cdot k!)$)
   - Alternative: None exists

2. ✗ **Inversion: Find $m$ given $D$ efficiently**
   - Reason: Requires factorization of primorial
   - Alternative: None exists

3. ✗ **Inversion: Find $m$ given $N$ efficiently**
   - Reason: Requires search over exponential space
   - Alternative: None exists

4. ✗ **Use formula for fast prime generation**
   - Reason: Evaluation is exponentially expensive
   - Alternative: Standard methods (sieves, probabilistic) are faster

5. ✗ **Use formula for primality testing**
   - Reason: Computing denominator structure is slower than AKS
   - Alternative: Standard primality tests are polynomial

6. ✗ **Extract information about large primes from primorial**
   - Reason: Information encoded via exponential sum evaluation
   - Alternative: None exists

7. ✗ **Use GCD structure for computational advantage**
   - Reason: Provides no shortcut for any hard problem
   - Alternative: Theoretical interest only

8. ✗ **Tighten asymptotic bounds enough for inversion**
   - Reason: Even 1% error is exponentially large
   - Alternative: Would need error $< 10^{-k}$ where $k \sim m$ (impossible)

### ✓ **What Remains Valuable**

1. ✓ **Theoretical beauty:** Exact primorial structure in denominators
2. ✓ **Proof technique:** p-adic valuation analysis
3. ✓ **Modular structure:** Connection to Stickelberger relation
4. ✓ **Number-theoretic insight:** Factorial sums encode prime products
5. ✓ **Certificate verification:** Can verify a number IS a factorial sum numerator (if small enough)
6. ✓ **Pedagogical value:** Illustrates limits of elementary methods
7. ✓ **Primorial computation:** Formula confirms standard primorial via different route

## Conclusion: The Strange Loop Is Unbreakable

The circular dependency is **fundamental**, not a bug:

```
         m (prime)
         ↓ easy
    D = Primorial(m)/2
         ↓ HARD (factorization)
         m
         ↓ EXPONENTIAL (sum evaluation)
         N (numerator)
         ↓ SUPER-HARD (search)
         m
```

**Every path back to $m$ goes through a hard problem.**

**Every path to $N$ goes through exponential evaluation.**

**No shortcuts exist.**

The formula is a **profound theoretical result** about the hidden structure in factorial sums, but it provides **no computational advantage** for any standard problem (primality testing, prime generation, factorization, or inversion).

The dream of direct utility must be buried. 🪦

The mathematical beauty remains eternal. ✨

---

**Epitaph:**

*"Here lies the dream that factorial sums might efficiently compute large primes.*
*The denominator was exact, the numerator was prime,*
*but the exponential barrier proved insurmountable.*
*May it rest in theoretical peace."*

*— Proven 2025, Buried 2025*
