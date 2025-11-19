# Egypt.wl k=EVEN Pattern - Rigorous Proof Attempt

**Date**: November 16, 2025, 23:55 CET
**Status**: 🔬 SETUP - Documenting initial state before proof attempt
**Goal**: Prove k=EVEN modular property rigorously

---

## Problem Statement

### The Observation (Numerical, 1298× improvement)

For Pell equation x² - n·y² = 1, the approximation formula:
```
√n ≈ (x-1)/y · f(x-1, k)
```

exhibits **dramatic parity dependence**:

- **k=EVEN**: Exponentially better approximation
- **k=ODD**: Exponentially worse approximation
- **Example n=13**: EVEN is 1298× better than ODD

### Modular Property

**Claim**: For non-special primes (where n ∤ (x-1)):
```
(x-1)/y · f(x-1, k) ≡ 0 (mod n)  ⟺  k is EVEN
```

**Special primes** {2,7,23} where n|(x-1): property holds for ALL k.

---

## Mathematical Framework

### Pell Equation Solutions

**Equation**: x² - n·y² = 1

**Fundamental solution**: Smallest (x,y) ∈ ℤ⁺ satisfying equation.

**Regulator**: R(n) = ln(x + y√n)

### Approximation Function f(x,k)

**Two equivalent forms** (proven numerically exact):

#### Form 1: Factorial series
```
f(n,k) = 1 + Σ_{j=1}^k 1/(1 + Σ_{i=1}^j 2^{i-1} (j+i)!/(j-i)!(2i)! n^i)
```

#### Form 2: Chebyshev polynomials
```
term[x,k] = 1/(T_{⌈k/2⌉}(x+1) · [U_{⌊k/2⌋}(x+1) - U_{⌊k/2⌋-1}(x+1)])
```

where T_n, U_n are Chebyshev polynomials of first and second kind.

**Equivalence**: term0[x,j] = term[x,j] (verified numerically)

---

## Key Insight: Regulator as Central Object

### Everything is a function of R(n)!

**Critical observation** (from user):

Both components can be expressed **purely** as functions of regulator R(n):

1. **(x-1)/y** = function of R(n)
2. **f(x,k)** = function of R(n)

### Pell Solutions from Regulator

**Parametrization**:
```
x = ⌊e^R cosh(R)⌋  (approximate, needs exact formula)
y = ⌊e^R sinh(R)/√n⌋
```

Actually, exact relation:
```
x + y√n = e^R
x - y√n = e^{-R}

→ x = (e^R + e^{-R})/2 = cosh(R)
→ y = (e^R - e^{-R})/(2√n) = sinh(R)/√n
```

### Regulator Reconstruction Theorem

**From Hallgren (2006)** - Quantum Algorithms for Pell's Equation:

**Theorem**: Given ⌊R⌋ (nearest integer to regulator R = ln(x + y√n)),
can reconstruct exact fundamental Pell solution (x,y) using classical post-processing.

**Bounds**: R ≤ √Δ log Δ where Δ is discriminant, so ⌊R⌋ has polynomial bit size.

**Implication**: Deep structure connecting R ↔ (x,y).

**Reference**: Hallgren, S. (2006). Polynomial-Time Quantum Algorithms for Pell's
Equation and the Principal Ideal Problem. *STOC'02*, pages 653-658.

**Path**: `/home/jan/Documents/papers/primes/pell.pdf`

---

## Explicit R-Formulation (Egypt.wl Convention)

### Notation Convention

**Egypt.wl uses integer R** (not real regulator):
```
R = Exp[regulator] = x + y√n  (fundamental unit)
R · R̄ = (x + y√n)(x - y√n) = 1
R̄ = 1/R = x - y√n
```

### Component Formulas

**From Pell equation identity:**
```mathematica
x = (R + 1/R)/2
y = (R - 1/R)/(2√n)
```

**First component:**
```mathematica
(x - 1)/y = √n · (R - 1)/(R + 1)
```

**Second component (Chebyshev → geometric series):**

For Chebyshev polynomials evaluated at x = (R + 1/R)/2:
```mathematica
T_m((R + 1/R)/2) = (R^m + R^(-m))/2
```

Denominator in term[x, k]:
```mathematica
term[x, k] ~ 1/R^k  (for k even, asymptotically)
```

**Geometric series with quotient 1/R:**
```mathematica
f(x-1, k) ≈ 1 + C · Sum[1/R^j, {j, 1, k}]
          = 1 + C · (1 - 1/R^k)/(R - 1)

Limit k → ∞:
f(x-1, ∞) = 1 + C/(R - 1)
```

### The Self-Referential Structure

**Circularity:**
```
√n ≈ (x-1)/y · f(x-1, k)
   = g(R(n), k)
```

Where:
- √n defines Pell equation x² - ny² = 1
- Pell equation yields R(n) = x + y√n
- We use R(n) to approximate √n back!

**The Pattern (Numerical Observation):**
```
g(R(n), k) ≡ 0 (mod n)  ⟺  k is EVEN
```

**Exception**: Special primes {2, 7, 23, ...} where n|(x-1) ⟺ n|(R-1).
For these: divisibility holds for ALL k (both even and odd).

### No Rigorous Proof Yet

**Status**: Pattern observed via Wolfram numerics (effective factorization mod n).

**Observation strength**: Very strong - pattern repeats consistently, n divides exactly.

**What's missing**: Theoretical explanation WHY parity of k controls divisibility mod n.

---

## What We Know (Proven/Verified)

### ✅ Numerical Facts

1. **Equivalence**: term0[x,j] = term[x,j] for all tested values
2. **k=EVEN superiority**: Consistent across many n (especially n=13)
3. **Modular property**: Holds numerically for EVEN k
4. **Special primes**: n ∈ {2,7,23} behave differently (n|(x-1))

### ✅ Theoretical Connections

1. **Chebyshev parity structure**:
   - k=EVEN: ⌈k/2⌉ = ⌊k/2⌋ = k/2 (symmetric)
   - k=ODD: ⌈k/2⌉ = ⌊k/2⌋ + 1 (asymmetric)

2. **Factorial denominators**:
   - (j+i)! / (j-i)! (2i)! exhibit period structure mod n
   - Wilson's theorem: (p-1)! ≡ -1 (mod p) for prime p

3. **Regulator centrality**:
   - All components express as R(n) functions
   - Reconstruction possible from ⌊R⌋

---

## What We Don't Know (Open Questions)

### ❓ Primary Question

**Why does k parity affect modular divisibility?**

Specifically:
```
(x-1)/y · f(x-1, k) ≡ 0 (mod n)
```

holds if k=EVEN but fails if k=ODD (for non-special n).

### ❓ Mechanism Questions

1. **Chebyshev parity role**:
   - How does T_{k/2} vs T_{(k+1)/2} affect mod n behavior?
   - Connection to Chebyshev polynomial properties mod p?

2. **Factorial structure mod n**:
   - Does factorial denominator have period 2 mod n?
   - Wilson's theorem generalization?
   - Legendre's formula for p-adic valuation?

3. **Regulator structure**:
   - Can we express modular property purely in terms of R(n)?
   - Does R(n) mod 2 control k parity requirement?

4. **Special primes mechanism**:
   - Why do {2,7,23} behave specially?
   - What is common: n|(x-1) for these?
   - Characterization of all special primes?

---

## Proof Strategy (Proposed)

### Approach 1: Chebyshev Modular Properties

**Goal**: Analyze Chebyshev polynomials mod n.

**Known results**:
- T_n(x) has specific congruence properties
- U_n(x) related to cyclotomic polynomials

**Method**:
1. Expand term[x,k] mod n for k=EVEN vs k=ODD
2. Show denominator divisibility pattern differs by parity
3. Connect to (x-1)/y structure

**Difficulty**: Medium-High (requires Chebyshev theory)

### Approach 2: Factorial Denominator Analysis

**Goal**: Prove factorial structure has period 2 mod n.

**Known results**:
- Wilson's theorem: (p-1)! ≡ -1 (mod p)
- Legendre: ν_p(n!) = Σ ⌊n/p^k⌋

**Method**:
1. Analyze (j+i)!/(j-i)!(2i)! mod n
2. Show parity-dependent cancellation
3. Connect to k=EVEN requirement

**Difficulty**: Medium (elementary number theory)

### Approach 3: Regulator-Based Proof

**Goal**: Express everything in terms of R(n), prove via regulator properties.

**Hypothesis**:
```
(x-1)/y · f(x-1, k) = g(R, k) for some function g
g(R, k) ≡ 0 (mod n)  ⟺  k even
```

**Method**:
1. Derive exact R-based formulas for (x-1)/y and f(x,k)
2. Combine to single R-based expression
3. Analyze mod n using R properties

**Difficulty**: High (needs R structure theory)

**Advantage**: Most elegant if achievable!

---

## Immediate Next Steps

### Step 1: Verify Modular Property Systematically

**Implement test**:
```wolfram
VerifyModular[n_, kMax_] :=
  (* For each k ∈ [1, kMax], check if (x-1)/y f(x-1,k) ≡ 0 (mod n) *)
```

**Test cases**:
- n = 13 (known strong pattern)
- n ∈ {2,7,23} (special primes)
- n = other primes and composites

**Goal**: Establish pattern scope and exceptions.

### Step 2: Analyze Chebyshev Parity

**Compute explicitly**:
```
term[x, 2m] vs term[x, 2m+1]
```

for small m, identify structural difference.

**Focus**: Denominator structure:
```
T_{m}(x+1) · [U_{m}(x+1) - U_{m-1}(x+1)]      (k=2m even)
T_{m+1}(x+1) · [U_{m}(x+1) - U_{m-1}(x+1)]    (k=2m+1 odd)
```

**Question**: Does this affect divisibility mod n?

### Step 3: Factorial Period Analysis

**Examine**:
```
(j+i)! / (j-i)! (2i)!  mod n
```

for j ∈ [1, 10], i ∈ [1, j], various n.

**Look for**:
- Period 2 pattern in j or i
- Cancellation when summed over EVEN j vs ODD j
- Connection to n structure (prime, composite, etc.)

### Step 4: Special Primes Characterization

**Question**: What characterizes {2,7,23}?

**Test hypothesis**: n|(x-1) for fundamental solution.

**Method**:
- Compute fundamental (x,y) for many n
- Check which satisfy n|(x-1)
- Compare to {2,7,23}

**Goal**: Find all special primes (if finite).

---

## Resources Needed

### From User (Optional)

1. **Quantum computing paper**: Regulator reconstruction theorem
   - Not urgent, but good theoretical context
   - Classical post-processing part is relevant

### From Exploration

2. **egypt/doc notebooks**: Computational experiments
   - pell-*.nb series (many variants explored)
   - Likely contain empirical patterns not yet formalized

3. **Egypt.wl implementation**: Working code
   - term0 vs term equivalence
   - Numerical tests already done

---

## Success Criteria

### Minimal Success ⭐

Prove modular property for **specific case** (e.g., n=13, k=EVEN).

**Value**: Demonstrates proof technique is viable.

### Moderate Success ⭐⭐

Prove for **all primes p** (excluding special cases).

**Value**: General theorem with exceptions.

### Full Success ⭐⭐⭐

Prove for **all n**, characterize special cases completely.

**Value**: Complete understanding, publishable result.

---

## Current Status

**Setup complete**: ✅ Framework documented

**Next**: Choose initial approach (Step 1: Verification + Step 2: Chebyshev?)

**Estimate**:
- Verification: 1-2 hours
- Initial analysis: 2-3 hours
- Proof attempt: 3-10 hours (depends on complexity)

**Total**: Multi-session project (~2-3 days intensive work)

---

## Notes

- **"To číslo je nezajímavé"**: User noted 1298 is not significant (just example)
- **Focus**: Pattern (EVEN vs ODD), not specific magnitude
- **Regulátor perspective**: Most promising theoretical angle
- **Practical limitation**: Desktop CLI (WolframScript), not quantum

---

**Status**: Ready to begin systematic investigation.

**Recommendation**: Start with Step 1 (verification) + Step 2 (Chebyshev analysis) tomorrow when fresh.

**Tonight**: Commit this framework document, end session on double success (Mellin + Egypt setup).
