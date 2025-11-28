# Semiprime Formula: Gamma/Factorial Reformulation

**Date:** 2025-11-27

## The Key Insight

The Pochhammer formulation can be rewritten using **differences of squares**:

```
(-1)^i * Poch(1-n, i) * Poch(1+n, i) = (n^2 - 1)(n^2 - 4)(n^2 - 9)...(n^2 - i^2)
```

This is simply:
```
Product over j = 1 to i of (n^2 - j^2)
```

## The Formula (Difference of Squares Form)

For semiprime n = pq with odd primes 3 <= p <= q:

```
        1
p = ---------
    1 - S(n)
```

where:

```
         m    { (n^2 - 1)(n^2 - 4)...(n^2 - i^2) }
S(n) = Sum    { --------------------------------- }
        i=1   {            2i + 1                }

m = floor((sqrt(n) - 1) / 2)
{x} = fractional part of x
```

## Why This Form is Better

1. **No alternating signs** - the (-1)^i disappears
2. **No Pochhammer notation** - just products everyone knows
3. **Geometric intuition** - "symmetric differences around n^2"

## Useful Identity

The product has a nice closed form:

```
Product_{j=1}^{i} (n^2 - j^2) = (n+i)! / (n * (n-i-1)!)
```

**Proof:**
```
(n^2 - j^2) = (n-j)(n+j)

Product_{j=1}^{i} (n-j) = (n-1)(n-2)...(n-i) = (n-1)! / (n-i-1)!

Product_{j=1}^{i} (n+j) = (n+1)(n+2)...(n+i) = (n+i)! / n!

Together: [(n-1)! / (n-i-1)!] * [(n+i)! / n!] = (n+i)! / (n * (n-i-1)!)
```

## Special Case

When i = n-1:
```
Product_{j=1}^{n-1} (n^2 - j^2) = (2n-1)! / n
```

## Gamma Function Connection

Using Gamma(k+1) = k!:

```
(n+i)! / (n * (n-i-1)!) = Gamma(n+i+1) / (n * Gamma(n-i))
```

So the term becomes:
```
Gamma(n+i+1) / (n * (2i+1) * Gamma(n-i))
```

## The Infinite Sum: Both Factors at Once

**Key Discovery:** Extending the sum to infinity captures BOTH prime factors!

For finite m = floor((sqrt(n)-1)/2), only the smaller factor p contributes.

For m → ∞, both p AND q contribute:

```
S_∞ = Σ_{i=1}^{∞} {(n²-1)(n²-4)...(n²-i²) / (2i+1)}

    = (p-1)/p + (q-1)/q

    = 2 - (p+q)/n
```

**Why?** The fractional part is non-zero only when (2i+1) is a prime factor of n:
- At i = (p-1)/2 where 2i+1 = p: contributes (p-1)/p
- At i = (q-1)/2 where 2i+1 = q: contributes (q-1)/q
- All other terms: contribute 0

## Vieta's Formulas: Complete Factorization

From S_∞ we get p + q directly:

```
p + q = n(2 - S_∞)
```

Combined with p × q = n, we have Vieta's formulas! The factors are roots of:

```
x² - (p+q)x + n = 0
x² - n(2 - S_∞)x + n = 0
```

Solving:

```
p, q = [n(2 - S_∞) ± sqrt(n²(2 - S_∞)² - 4n)] / 2
```

## Mathematica Implementation

```mathematica
factorSemiprime[n_] := Module[{s, t, disc},
  s = Sum[FractionalPart[Product[n^2 - j^2, {j, 1, i}]/(2i + 1)], {i, 1, n}];
  t = n (2 - s);  (* = p + q *)
  disc = t^2 - 4 n;
  {(t - Sqrt[disc])/2, (t + Sqrt[disc])/2}
]
```

## Equivalent Mod Formulation

```
S_∞ = Σ_{i=1}^{∞} Mod[∏_{j=1}^{i}(n²-j²), 2i+1] / (2i+1)
```

The Mod "detects" prime factors: Mod = d-1 when d|n, else Mod = 0.

## Connection to Euler's Totient

**Key identity:**
```
S_∞ = (n + φ(n) - 1) / n
```

**Proof:**
```
φ(pq) = (p-1)(q-1) = n - (p+q) + 1
p + q = n - φ(n) + 1
S_∞ = 2 - (p+q)/n = (n + φ(n) - 1)/n  ✓
```

## Equivalence to Factoring

**Theorem:** Computing S_∞ is equivalent to factoring n.

- Given S_∞ → get p+q = n(2 - S_∞) → Vieta gives p,q
- Given p,q → trivially compute S_∞

**Implication:** A closed-form for S_∞ would be a **breakthrough in factoring**.

## Open Question

Is there a **closed form** for S_∞ without iteration?

```
S_∞ = Σ_{p|n, p odd prime} (p-1)/p = ???
```

**Status:** Unknown, but NOT proven impossible.

**Possible connections:**
- Dirichlet L-functions: L(s, χ₀) = ζ(s) ∏_{p|n}(1 - p^{-s})
- Ramanujan sums and Möbius inversion
- p-adic analysis
- Analytic number theory (integrals, residues)

## Explored Directions (Nov 27, 2025)

### 1. L-functions
- L(s, χ₀) = ζ(s)(1 - p^{-s})(1 - q^{-s}) encodes p, q
- But extracting them requires knowing them already
- **Status:** No shortcut found

### 2. Modular Forms / Divisor Functions
- p + q = σ₁(n) - n - 1
- σ₁(n) appears in Eisenstein series E₂(τ)
- But extracting specific coefficient offers no advantage
- **Status:** Equivalent problem

### 3. Ramanujan Sums
- c_k(n) = k-1 if prime k | n, else -1
- Detects prime divisors!
- Identity: Σ c_q(n)/q^s = σ_{1-s}(n)/ζ(s)
- **Status:** Detection works but requires iteration

### 4. Analytic Continuation
- F(n, s) = Σ {f(n,i)/(2i+1)} / i^s converges
- F(n, 0) = S_∞
- F(n, 1) = 2(p+q)/n
- Identity: F(n, 0) + F(n, 1)/2 = 2
- **Status:** Beautiful structure, no computational shortcut

## Equivalent Problems

All computationally equivalent for n = pq:
1. S_∞ = (p-1)/p + (q-1)/q
2. φ(n) = (p-1)(q-1)
3. σ₁(n) = (1+p)(1+q)
4. σ₋₁(n) = (1+1/p)(1+1/q)
5. p + q

**A closed form for ANY of these would be a factoring breakthrough.**

### 5. Comparison with Shor's Algorithm

Both our formula and Shor use the same underlying structure:
- **Detection mechanism:** Same! Both detect p | n via (Z/nZ)* properties
  - Our formula: Wilson's theorem → {f(n,i)/p} = (p-1)/p
  - Ramanujan: c_p(n) = p-1 when p | n
  - Shor: gcd(a^(r/2) ± 1, n) reveals factors

- **Quantum advantage:** NOT in detection, but in PARALLEL EVALUATION
  - Quantum: superposition evaluates a^x mod n for ALL x simultaneously
  - QFT extracts period r in O((log n)³)
  - Classical: must iterate, O(√n) or worse

**Conclusion:** Structure exists (factoring is not random), but exploiting it
classically without iteration seems to require P = NP or similar breakthrough.

### 6. Compressed Sensing Perspective

The signal s[i] = {f(n,i)/(2i+1)} is **2-sparse** for semiprime n = pq:
- Nonzero only at i = (p-1)/2 and i = (q-1)/2
- Values are (p-1)/p and (q-1)/q

**Compressed sensing theory:** For k-sparse signal of length N, need O(k log N) measurements.
For k=2, N~√n, this suggests O(log n) measurements could suffice.

**The catch:** Each "measurement" requires O(√n) computation to evaluate signal[n, i].
Even with O(log n) clever measurements, total work is O(√n log n) — no improvement.

**Status:** Sparse structure exists but cannot be exploited without fast signal evaluation.

### 7. Alternating Sum G(-1)

The generating function G(x) = Σ signal[n,i] × x^i has interesting properties:
- G(1) = S_∞ = (p-1)/p + (q-1)/q
- G(-1) = (-1)^{(p-1)/2} × (p-1)/p + (-1)^{(q-1)/2} × (q-1)/q

**Key insight:** When p ≢ q (mod 4), G(1) and G(-1) **separate** the factors:
- If p≡1(4), q≡3(4): (p-1)/p = (G(1)+G(-1))/2, (q-1)/q = (G(1)-G(-1))/2
- If p≡3(4), q≡1(4): (p-1)/p = (G(1)-G(-1))/2, (q-1)/q = (G(1)+G(-1))/2

**Examples verified:**
- n = 143 = 11×13: p≡3, q≡1 → separation works perfectly
- n = 35 = 5×7: p≡1, q≡3 → separation works
- n = 77 = 7×11: both ≡3(4) → G(-1) = -G(1), no extra info

**Status:** Beautiful algebraic structure, but computing G(-1) still requires iteration.

### 8. Wilson Detection Mechanism (Rigorous)

**Identity:** At i = (p-1)/2 where 2i+1 = p:
```
∏_{j=1}^{(p-1)/2} (n² - j²) ≡ (-1)^{(p-1)/2} × ((p-1)/2)!² ≡ p-1 (mod p)
```

This is because:
- n ≡ 0 (mod p), so n² - j² ≡ -j² (mod p)
- ∏(-j²) = (-1)^i × (i!)²
- By Wilson-like identity: (-1)^{(p-1)/2} × ((p-1)/2)!² ≡ -1 (mod p)

**Result:** {∏(n²-j²)/p} = (p-1)/p at i = (p-1)/2. QED.

### 9. Dirichlet Series Encoding

S_∞(n) can be encoded in a Dirichlet series:
```
D(s) = Σ_n S_∞(n) n^{-s} = 2ζ(s) - ζ(s) × P(1+s)
```
where P(s) = Σ_p p^{-s} is the prime zeta function.

**Alternative formulation:**
```
S_∞ = ω(n) - Σ_{p|n} 1/p = 2 - (p+q)/n
```
where ω(n) = number of distinct prime factors.

**Connection to φ(n)/n:**
```
log(φ(n)/n) = Σ log(1 - 1/p) ≈ -Σ 1/p = -(p+q)/n
```
Approximation error ~O(1/p²).

### 10. The Circle Closes

Every approach leads to the same equivalence class:
```
S_∞ ↔ Σ 1/p ↔ φ(n)/n ↔ σ₁(n) ↔ p+q ↔ factorization
```

Computing **any** of these in closed form (without iteration) would solve factoring.
No such closed form is known. Not proven impossible.

## Why Factoring is Hard (Summary)

1. **Multiplication is one-way:** n = p×q easy, inverse hard
2. **Information mixing:** p+q requires knowing where signal is nonzero
3. **Detection requires testing:** Wilson detects p|n only when we evaluate at i=(p-1)/2
4. **No shortcut to special positions:** Must iterate to find where 2i+1 divides n

**The quantum advantage** (Shor) is not in detection mechanism (same as ours)
but in **parallel evaluation** via superposition.

### 11. Continued Fractions

CF expansion of √n provides another factoring approach:
- Convergents p_k/q_k satisfy p² - nq² = ±1 (Pell equation)
- gcd(p-1, n) may reveal factors
- For n = 143: gcd(12-1, 143) = 11 at k=2 ✓

**Key difference:**
- CF: quadratic residue structure (multiplicative)
- Our formula: Wilson/factorial structure (additive)

Both require iteration. Different mechanisms, same barrier.

## Scripts Created

- `scripts/sparse-recovery-test.wl` - Compressed sensing analysis
- `scripts/alternating-sum-analysis.wl` - G(-1) and mod 4 separation
- `scripts/integral-representation.wl` - Wilson mechanism proof
- `scripts/polynomial-root-detection.wl` - Polynomial/Ramanujan approach
- `scripts/generating-function-factorization.wl` - Dirichlet series connection
- `scripts/continued-fraction-connection.wl` - CF factoring comparison
- `scripts/final-summary.wl` - Complete equivalence web summary

## Final Verdict

**The Equivalence Web:**
```
S_∞ ↔ φ(n) ↔ σ₁(n) ↔ Σ1/p ↔ p+q ↔ FACTORIZATION
```

**Core Barrier:**
```
STRUCTURE EXISTS but ACCESSING IT requires ITERATION
```

**Open Question:** Does a closed form exist that bypasses iteration?
- Not proven impossible
- Would solve integer factorization
- All explored approaches require O(√n) or worse

**Quantum Insight:** Shor's advantage is PARALLEL EVALUATION, not better detection.
Our Wilson-based detection is equally valid; the gap is in evaluation strategy.

## Orbit Tools Investigation (Nov 27, evening)

### Egyptian Fractions and S_∞

Tested whether Egyptian fraction decomposition of S_∞ reveals factors:

**Results:** 14/28 semiprimes (50%) had factors revealed in Egyptian denominators!

Example for n = 143 = 11 × 13:
- S_∞ = 262/143
- Egyptian: 1/1 + 1/2 + 1/4 + 1/13 + 1/191 + ...
- gcd(13, 143) = 13 ← Factor revealed!

**Partial sums also work:**
- S_5 = 10/11 (after first factor detected)
- Egyptian(10/11) = 1/2 + 1/3 + 1/14 + 1/231
- gcd(231, 143) = 11 ← Factor revealed!

**Catch:** This is alternative extraction, not speedup:
- Still need O(√n) iterations to compute S_∞ or partial sums
- Once we have S_i = (p-1)/p, direct computation p = 1/(1-S_i) works
- Egyptian decomposition adds O(log n) extra work

**Scripts:**
- `scripts/orbit-tools-factoring.wl` - Chebyshev, primorial connections
- `scripts/egyptian-factor-detection.wl` - Systematic Egyptian testing
- `scripts/partial-sum-egyptian.wl` - Partial sum analysis

### Pell Solution Factoring

Our Orbit `PellSolution[n]` directly reveals factors for most semiprimes!

**Method:**
- Pell equation: x² - ny² = 1
- Solution gives x² ≡ 1 (mod n)
- gcd(x±1, n) may reveal factors

**Test results:** 14/17 semiprimes (82%) factored successfully!

Example for n = 143 = 11 × 13:
- Pell solution: x = 12, y = 1
- gcd(12-1, 143) = gcd(11, 143) = **11** ← Factor!
- gcd(12+1, 143) = gcd(13, 143) = **13** ← Factor!

**Connection to Shor:** This is EXACTLY what Shor does - finds x with x² ≡ 1 (mod n).
Quantum advantage is finding such x in O((log n)³) instead of O(√n).

**Catch:** Solving Pell requires O(√n) CF iterations - same as trial division!

**Scripts:**
- `scripts/orbit-sqrt-factoring.wl` - FactorialTerm, ChebyshevTerm analysis
- `scripts/pell-factoring-test.wl` - Systematic Pell factoring test

## Deep Exploration: Why No Shortcut? (Nov 27, late)

### Attempted Approaches (All require O(√n) iteration):

| Approach | Key Insight | Why No Shortcut |
|----------|-------------|-----------------|
| **Fourier series** | {x} = 1/2 - (1/π)Σ sin(2πkx)/k | Fractional part is discrete, not continuous |
| **Hypergeometric** | f(n,i) ~ Pochhammer products | Raw series DIVERGES, needs regularization |
| **Continuous extension** | g(n,x) for real x | Poles at x = n, n+1, ... |
| **p-adic analysis** | v_p(f) structure | Need to know p to work in Q_p |
| **Functional equations** | S(mn) = S(m) + S(n) additive | Needs factors to apply! |
| **Optimization** | min |n mod x| | = trial division |
| **Fermat's method** | Search s where s²-4n = □ | O(q - √n) worst case |

### The Fundamental Barrier

```
┌─────────────────────────────────────────────────────────────────┐
│  DETECTION is easy    │  ACCESS requires iteration            │
├─────────────────────────────────────────────────────────────────┤
│  Wilson: f ≡ p-1 (mod p) at i = (p-1)/2                       │
│  Ramanujan: c_p(n) = p-1 when p|n                              │
│  Pell: x² ≡ 1 (mod n) → gcd(x±1, n)                           │
│  Fermat: s² - 4n = □ → factors                                 │
├─────────────────────────────────────────────────────────────────┤
│  ALL these WORK perfectly!                                      │
│  But we must FIND the right position/value without knowing p,q │
└─────────────────────────────────────────────────────────────────┘
```

### Why Quantum is Different

**Shor's algorithm:**
- Same detection mechanism (x² ≡ 1 mod n → gcd)
- Different ACCESS: quantum superposition evaluates ALL x simultaneously
- QFT extracts period in O((log n)³)

**Classical (including our formula):**
- Same detection mechanism
- Sequential evaluation: must test each candidate
- O(√n) best known

### Key Discoveries

1. **S(n) is ADDITIVE**: S(mn) = S(m) + S(n) for coprime m, n
   - Rare property in number theory
   - But requires knowing factors to use!

2. **p-adic explains Wilson**: f(n,i) ≡ (-1)^i × (i!)² (mod p)
   - Quadratic Wilson gives f ≡ p-1 at i = (p-1)/2
   - Beautiful but not computational

3. **Optimization = Fermat**: Searching for p+q is Fermat's method
   - O(q - √n) complexity
   - Same as our formula for balanced primes

### Scripts Created

- `scripts/integral-deep-dive.wl` - Fourier, Mellin, continuous approaches
- `scripts/hypergeometric-approach.wl` - Pochhammer, divergence analysis
- `scripts/functional-equations.wl` - Additivity of S(n)
- `scripts/p-adic-exploration.wl` - Wilson in Q_p
- `scripts/optimization-perspective.wl` - Fermat connection

## Euler Totient Connection (Nov 27, continued)

### Key Identity: S_∞ and φ(n)

For semiprime n = pq:

```
φ(n) = (p-1)(q-1) = n - (p+q) + 1
p + q = n + 1 - φ(n)
```

Our formula gives: `p + q = n(2 - S_∞)`

Combining these:

```
φ(n) = 1 - n + n·S_∞
```

**S_∞ and φ(n) encode the SAME information!**

### Tested Totient Formulas

| Formula | Usefulness for Factoring |
|---------|-------------------------|
| `a\|b ⟹ φ(a)\|φ(b)` | Divisibility property, not computational |
| `m\|φ(a^m - 1)` | Requires factoring a^m - 1 (harder!) |
| `φ(mn) = φ(m)φ(n)·d/φ(d)` | Multiplicative, needs factors |
| `Σ_{d\|n} μ²(d)/φ(d) = n/φ(n)` | Sum over divisors (need to know them!) |
| `Σ_{gcd(k,n)=1} k = n·φ(n)/2` | Computing totatives requires factors |
| `φ(n)/n = φ(rad(n))/rad(n)` | Trivial for squarefree n |

**Conclusion:** All φ-based formulas are **circular** - they require factors to compute, but would give factors if computed.

### Cyclotomic Resultant Detection

```
Res(Φ_m, Φ_n) = 1  when gcd(m,n) = 1
Res(Φ_m, Φ_n) ≠ 1  when m | n (or related)
```

For n = 143 = 11 × 13:
- `Res(Φ₁₁, Φ₁₄₃) = 137858491849` ← detects 11!
- `Res(Φ₇, Φ₁₄₃) = 1` ← 7 doesn't divide 143

But computing for all candidates is still O(√n).

## Reciprocal Sum Analysis (Nov 27, continued)

### The Question

What if we sum reciprocals without fractional part regularization?

```
S_recip = Σ (2i+1)/f(n,i) where f(n,i) = ∏_{j=1}^{i}(n² - j²)
```

### Surprising Pattern

```
S_recip × n² → 3 as n → ∞
```

| n | S × n² |
|---|--------|
| 15 | 3.013 |
| 35 | 3.007 |
| 77 | 3.001 |
| 143 | 3.0004 |
| 323 | 3.00008 |

### Explanation: First Term Dominance

```
T₁ = 3/(n²-1)
T₁ × n² = 3n²/(n²-1) → 3
```

All higher terms vanish as O(n^{2-2i}) for i ≥ 2.

**This pattern has NOTHING to do with factors p, q!**
It's purely the asymptotic behavior of the first term.

### Epsilon Regularization

Tried exponential damping: `S_ε = Σ (2i+1)/f(n,i) × e^{-εi}`

Result: As ε → 0, we get S × n² → 3 again.
No factor information encoded in the sum VALUE.

The factor information is in **WHERE** we stop summing (singularity at i where f = 0 would occur at i = n, not useful).

### Scripts Created

- `scripts/reciprocal-sum-analysis.wl` - Why S×n² → 3
- `scripts/reciprocal-deviation.wl` - Deviation analysis
- `scripts/epsilon-regularization.wl` - Damping approaches
- `scripts/analytic-continuation.wl` - Fourier/Ramanujan detection
- `scripts/euler-totient-factoring.wl` - φ(n) formulas
- `scripts/totient-lcm-gcd.wl` - LCM/GCD φ formulas
