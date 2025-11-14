# Theoretical Analysis of Factorial Variants for Primorial Formulas

## Framework

We seek functions f(k) to replace k! in the sum:
```
S_m = (1/2) · Sum[(-1)^k · f(k)/(2k+1), {k=1 to Floor[(m-1)/2]}]
```

such that: **Denominator[S_m] = Primorial(m)**

## The Key Invariant

From our proof, we need the recurrence:
```
N_{k+1} = N_k · (2k+3) + (-1)^{k+1} · f(k+1) · D_k
D_{k+1} = D_k · (2k+3)
```

to maintain: **ν_p(D_k) - ν_p(N_k) = 1** for all primes p ≤ 2k+1.

## Necessary Conditions

For the invariant to hold, we need f(k) such that:

### 1. **Factorial Inequality Analogue**
```
ν_p(f(k)) ≥ ν_p(2k+1) - 1
```

for all primes p dividing 2k+1, whenever ν_p(2k+1) ≥ 2.

### 2. **Recurrence Compatibility**
The function f(k) must satisfy a recurrence that allows us to track p-adic valuations.

### 3. **Growth Control**
Ideally: |f(k)| < k! to reduce numerator magnitudes.

---

## Candidate 1: Falling Factorial k!/(k-j)!

**Definition**: f_j(k) = k·(k-1)·...·(k-j+1) = k!/(k-j)!

**p-adic valuation**:
```
ν_p(f_j(k)) = ν_p(k!) - ν_p((k-j)!) = Σ_{i≥1} (⌊k/p^i⌋ - ⌊(k-j)/p^i⌋)
```

**Special case j=1**: f_1(k) = k
- ν_p(k) is simple: 0 or ≥1
- Fails factorial inequality: ν_p(k) < ν_p(2k+1) - 1 often

**Special case j=k-1**: f_{k-1}(k) = k!/(1!) = k!/1 = k!
- This is the original formula

**Middle ground**: Try f_2(k) = k·(k-1), f_3(k) = k·(k-1)·(k-2), etc.

**Analysis needed**: Does ν_p(k·(k-1)·...·(k-j+1)) ≥ ν_p(2k+1) - 1?

---

## Candidate 2: Binomial Coefficient Times Factorial

**Definition**: f(k) = C(k, j) · j! = k!/(k-j)! (same as Candidate 1!)

Or: f(k) = C(2k, k) (central binomial coefficient)

**p-adic valuation via Kummer**:
```
ν_p(C(m+n, m)) = (carries in m + n base p)
```

**For C(2k, k)**:
```
ν_p(C(2k, k)) = ν_p((2k)!) - 2·ν_p(k!)
```

**Analysis**:
- For p odd: Often ν_p(C(2k,k)) = 0 (no carries in k + k)
- For p=2: ν_p(C(2k,k)) can be positive

**Challenge**: Does C(2k, k) satisfy the factorial inequality?

---

## Candidate 3: Double Factorial n!!

**Definition**: k!! = k·(k-2)·(k-4)·...

**For odd k**: k!! = k·(k-2)·...·3·1 (all odd, no factors of 2)

**p-adic valuation for odd primes**:
Legendre-like but with stride 2.

**Advantage**: k!! < k!, reduces magnitudes

**Challenge**: Derive the recurrence for the invariant check.

---

## Candidate 4: Pochhammer Symbol (Rising Factorial)

**Definition**: (a)_k = a·(a+1)·(a+2)·...·(a+k-1)

**p-adic valuation**:
Similar to falling factorial but depends on starting point a.

**Special case a=1**: (1)_k = k! (original formula)

**Special case a=2**: (2)_k = (k+1)!/1 = (k+1)!

**Analysis**: Can we choose a to optimize?

---

## Candidate 5: Factorial with Prime Powers Removed

**Definition**: f(k) = k! / p^{ν_p(k!)} for specific prime p

**Example for p=2**: f(k) = k! / 2^{ν_2(k!)} (odd part of k!)

**Advantage**: Removes one prime's contribution entirely

**p-adic structure**: ν_2(f(k)) = 0 by construction

**Challenge**: Does this break the invariant for p=2?

---

## Candidate 6: Linear Combinations

**Definition**: f(k) = k! - α·(k-1)!

**User's example**: α = k-1 gives f(k) = (k-1)!

**p-adic valuation**:
```
ν_p(k! - α·(k-1)!) ≥ min(ν_p(k!), ν_p(α·(k-1)!))
```

**Analysis**: For α = k:
```
f(k) = k! - k·(k-1)! = (k-1)! · (k - k) = 0 (bad!)
```

For α < k:
```
ν_p(f(k)) = ν_p((k-1)!) + ν_p(k - α)
```

**Optimization goal**: Choose α to make |f(k)| small while preserving p-adic structure.

---

## Testing Strategy

For each candidate f(k):

### Step 1: Verify Factorial Inequality
Check numerically for many k, p:
```
ν_p(f(k)) ≥ ν_p(2k+1) - 1 when ν_p(2k+1) ≥ 2
```

### Step 2: Test Denominator Conjecture
Compute:
```
S_m = (1/2) · Sum[(-1)^k · f(k)/(2k+1), {k=1 to m_test}]
```

Check: Denominator[S_m] =? Primorial(m)

### Step 3: If Passes, Prove Invariant
Derive recurrence for (N_k, D_k) with f(k).
Prove ν_p(D_k) - ν_p(N_k) = 1 using modified factorial inequality.

### Step 4: Analyze Numerator Growth
Measure: |N_k| with f(k) vs |N_k| with k!

Goal: Find f(k) where |N_k| grows slower, potentially leading to closed form.

---

## Questions for Analysis

1. **Which f(k) satisfies the factorial inequality?**
   - Numerical testing can identify candidates
   - Theoretical proof for survivors

2. **Does the recurrence structure change?**
   - Some f(k) may have simpler recurrences
   - Could lead to closed forms

3. **Is there an optimal tradeoff?**
   - Smallest |f(k)| that still preserves primorials
   - Balance between magnitude and p-adic structure

4. **Connection to other number theory?**
   - Do any f(k) connect to known sequences (Catalan, Stirling, etc.)?
   - Generating functions?

---

## Next Steps

1. **Computational Survey**: Test all candidates numerically for m up to 100
2. **Theoretical Analysis**: For promising candidates, prove the invariant
3. **Optimization**: Find the minimal f(k) that works
4. **Closed Form Search**: Look for patterns in reduced numerators

