# Technical Comparison: Surd Algorithm vs Extended Euclidean Algorithm

**Date**: 2025-11-18
**Purpose**: Detailed technical comparison addressing the relationship between CF computation and XGCD
**Status**: 🎓 TECHNICAL REFERENCE

---

## 1. The User's Hypothesis

> "I guess the auxiliary sequence must be related to Extended Euclidean algorithm, that is the heart of the convergent calculation... when dealing with rational convergents and going backwards the sequence of coefficients the xgcd tracks should probably correspond to the auxiliary sequence you mention."

**Analysis**: This hypothesis contains both correct and incorrect elements. Let me clarify precisely where the connection exists and where it doesn't.

---

## 2. Extended Euclidean Algorithm (XGCD)

### 2.1 Standard XGCD for Integers

**Input**: Two integers a, b with a ≥ b > 0
**Output**: Integers (g, s, t) such that g = gcd(a,b) and s·a + t·b = g

**Algorithm**:
```
r₀ = a,    s₀ = 1,    t₀ = 0
r₁ = b,    s₁ = 0,    t₁ = 1

For k = 1, 2, 3, ... until rₖ₊₁ = 0:
  qₖ = ⌊rₖ₋₁ / rₖ⌋         [quotient]
  rₖ₊₁ = rₖ₋₁ - qₖ·rₖ       [remainder]
  sₖ₊₁ = sₖ₋₁ - qₖ·sₖ
  tₖ₊₁ = tₖ₋₁ - qₖ·tₖ

Final: gcd(a,b) = rₙ,  and  sₙ·a + tₙ·b = rₙ
```

### 2.2 Connection to Continued Fractions

**Key observation**: The quotients qₖ from XGCD are EXACTLY the partial quotients of the continued fraction a/b.

**Example**: a = 105, b = 38

XGCD steps:
```
r₀ = 105,  q₁ = ⌊105/38⌋ = 2,  r₁ = 105 - 2·38 = 29
r₁ = 38,   q₂ = ⌊38/29⌋ = 1,   r₂ = 38 - 1·29 = 9
r₂ = 29,   q₃ = ⌊29/9⌋ = 3,    r₃ = 29 - 3·9 = 2
r₃ = 9,    q₄ = ⌊9/2⌋ = 4,     r₄ = 9 - 4·2 = 1
r₄ = 2,    q₅ = ⌊2/1⌋ = 2,     r₅ = 0
```

Continued fraction:
```
105/38 = [2; 1, 3, 4, 2]
         = 2 + 1/(1 + 1/(3 + 1/(4 + 1/2)))
```

**Conclusion**: For rational numbers p/q, XGCD IS the standard algorithm for computing the CF expansion.

---

## 3. Surd Algorithm for √D

### 3.1 The Problem with XGCD for √D

**Question**: Can we use XGCD to compute CF(√D)?

**Problem**: √D is irrational! We can't write √D = p/q with integers p, q.

**Naive approach**:
1. Approximate √D ≈ p/q to high precision
2. Run XGCD on (p, q)
3. Get partial quotients

**Issues**:
- We need to know how precise p/q must be for N terms
- Round-off errors accumulate
- Inefficient compared to direct methods

### 3.2 Surd Algorithm: Direct Computation

**Instead**, we use the **surd algorithm** which computes CF(√D) directly without rational approximation:

```
Initial:
  m₀ = 0,  d₀ = 1,  a₀ = ⌊√D⌋

Recurrence (k ≥ 0):
  mₖ₊₁ = dₖ·aₖ - mₖ
  dₖ₊₁ = (D - m²ₖ₊₁)/dₖ        [always divides exactly!]
  aₖ₊₁ = ⌊(a₀ + mₖ₊₁)/dₖ₊₁⌋
```

**Key insight**: The complete quotient at step k is:
```
αₖ = (√D + mₖ)/dₖ
```

And we have:
```
αₖ = aₖ + 1/αₖ₊₁
```

This gives us the CF without ever approximating √D as rational!

### 3.3 Why (m, d) is NOT the same as XGCD coefficients

**XGCD tracks**: (rₖ, sₖ, tₖ) where sₖ·a + tₖ·b = rₖ

**Surd algorithm tracks**: (mₖ, dₖ) where (√D + mₖ)/dₖ is the k-th complete quotient

**These are fundamentally different**:
- XGCD works with remainders from division
- Surd algorithm works with algebraic properties of √D
- (m, d) encode the quadratic nature of √D
- (s, t) encode linear combinations

---

## 4. Where XGCD and Convergents DO Connect

### 4.1 Convergent Computation

Both XGCD and CF convergents use the SAME recurrence:

**Convergents** pₖ/qₖ satisfy:
```
p₋₁ = 1,    p₀ = a₀
q₋₁ = 0,    q₀ = 1

For k ≥ 0:
  pₖ₊₁ = aₖ₊₁·pₖ + pₖ₋₁
  qₖ₊₁ = aₖ₊₁·qₖ + qₖ₋₁
```

**XGCD coefficients** (sₖ, tₖ) satisfy:
```
s₀ = 1,     t₀ = 0
s₁ = 0,     t₁ = 1

For k ≥ 1:
  sₖ₊₁ = sₖ₋₁ - qₖ·sₖ
  tₖ₊₁ = tₖ₋₁ - qₖ·tₖ
```

**Connection**: If we set qₖ = aₖ, then (pₖ, qₖ) and (sₖ, tₖ) follow SIMILAR recurrences (but with different signs).

### 4.2 The Classical Identity

**Theorem** (Classical):
```
pₖ·qₖ₋₁ - pₖ₋₁·qₖ = (-1)^(k+1)
```

This is the **determinant** of the convergent matrix:
```
det([pₖ     pₖ₋₁]) = (-1)^(k+1)
    [qₖ     qₖ₋₁]
```

**Bézout form**:
```
qₖ₋₁·pₖ + (-qₖ)·pₖ₋₁ = (-1)^(k+1)
```

**Interpretation**: The pair **(qₖ₋₁, -qₖ)** is the "XGCD solution" for (pₖ₋₁, pₖ) in the sense that it gives a linear combination equal to ±1.

### 4.3 Backward Reconstruction

**The user's intuition is correct HERE**:

If you have convergents pₖ/qₖ and run XGCD backward:

```
gcd(pₖ, qₖ) = 1  (convergents are always in lowest terms)

XGCD(pₖ, qₖ) produces quotients that are EXACTLY a₀, a₁, ..., aₖ
```

**So**:
- Forward: Partial quotients aₖ → Convergents (p/q)ₖ
- Backward: Convergents (p/q)ₖ → XGCD → Partial quotients aₖ

**But**: The surd algorithm (m, d) computes aₖ DIRECTLY from √D, without going through convergents!

---

## 5. Precise Statement of the Relationship

### 5.1 Three Different Algorithms

| Algorithm | Input | Output | Uses XGCD? |
|-----------|-------|--------|------------|
| **XGCD for rationals** | p, q | CF(p/q) = [a₀; a₁, ...] | YES (this IS XGCD) |
| **Surd algorithm** | D | CF(√D) = [a₀; a₁, ...] | NO (uses (m,d) directly) |
| **Convergent recovery** | pₖ, qₖ | CF that gives this convergent | YES (run XGCD) |

### 5.2 What's the Same

✅ All three produce the SAME sequence of partial quotients aₖ (for their respective inputs)
✅ All three connect to the convergent recurrence
✅ All three have determinant identity pₖqₖ₋₁ - pₖ₋₁qₖ = ±1

### 5.3 What's Different

❌ XGCD works with remainders (rₖ), surd algorithm works with complete quotients ((√D + m)/d)
❌ XGCD computes (s,t) coefficients, surd algorithm computes (m,d) parameters
❌ XGCD is for rationals, surd algorithm is for quadratic irrationals
❌ The sequences (sₖ,tₖ) and (mₖ,dₖ) are DIFFERENT sequences with different meanings

---

## 6. Matrix Perspective

### 6.1 XGCD as Matrix Product

The XGCD algorithm can be viewed as matrix multiplication:

```
[rₖ₊₁   rₖ  ]   [0  1] [rₖ    rₖ₋₁]
[sₖ₊₁   sₖ  ] = [1 -qₖ]·[sₖ    sₖ₋₁]
[tₖ₊₁   tₖ  ]   [     ] [tₖ    tₖ₋₁]
```

### 6.2 CF Convergents as Matrix Product

Convergents can be computed via:

```
[pₖ    pₖ₋₁]   [a₀ 1]   [a₁ 1]       [aₖ 1]
[qₖ    qₖ₋₁] = [1  0] · [1  0] · ... [1  0]
```

### 6.3 Surd Algorithm: No Matrix Formulation

The surd algorithm (m, d) does NOT have a clean matrix formulation like XGCD or convergents.

**Why?** Because (m, d) tracks properties of the IRRATIONAL √D, not just the rational convergents.

---

## 7. Answer to the Original Question

### 7.1 "Is the auxiliary sequence related to XGCD?"

**Direct answer**: NO, the surd algorithm (m, d, a) is NOT the Extended Euclidean Algorithm.

**But with nuance**:
- YES: Both algorithms compute partial quotients aₖ
- YES: Both connect to convergent theory via the same recurrence
- YES: Running XGCD on convergents pₖ/qₖ recovers the CF
- NO: The sequences (mₖ, dₖ) and (sₖ, tₖ) are fundamentally different
- NO: XGCD works for rationals, surd algorithm works for √D directly

### 7.2 "Does XGCD track coefficients corresponding to the auxiliary sequence?"

**Answer**: NO, they track different things.

**What XGCD tracks**:
- Remainders rₖ
- Bézout coefficients (sₖ, tₖ) such that sₖ·a + tₖ·b = rₖ

**What surd algorithm tracks**:
- Numerator offset mₖ (such that √D + mₖ is the numerator of complete quotient)
- Denominator dₖ (such that (√D + mₖ)/dₖ has integer part aₖ)

**These are not the same**!

### 7.3 "Going backwards, XGCD coefficients correspond to auxiliary sequence?"

**Answer**: PARTIALLY correct.

**Backward from convergents**:
- Start with pₖ/qₖ
- Run XGCD(pₖ, qₖ)
- Get quotients q₁, q₂, ... = a₀, a₁, a₂, ... (partial quotients)
- **These match the aₖ from surd algorithm** ✓

**But**:
- The coefficients (sₖ, tₖ) from XGCD DO NOT equal (mₖ, dₖ) from surd algorithm
- You recover the **partial quotients aₖ**, not the auxiliary parameters (m, d)

---

## 8. Pedagogical Summary

### 8.1 For Understanding Continued Fractions

**If you want CF(p/q) for rational p/q**:
→ Use XGCD (Euclidean algorithm)
→ Quotients qₖ = partial quotients aₖ

**If you want CF(√D) for irrational √D**:
→ Use surd algorithm with (m, d) sequence
→ Get partial quotients aₖ directly
→ XGCD not needed!

**If you have convergents pₖ/qₖ and want to recover CF**:
→ Run XGCD(pₖ, qₖ) to get quotients
→ Quotients = partial quotients aₖ

### 8.2 Terminology Precision

| Term | Correct usage | Avoid |
|------|---------------|-------|
| **Euclidean algorithm** | For gcd(a,b) | For CF(√D) |
| **Extended Euclidean algorithm** | For Bézout coefficients | For surd algorithm |
| **Surd algorithm** | For CF(√D) computation | "Auxiliary sequence related to XGCD" |
| **Complete quotients** | (√D + mₖ)/dₖ | "XGCD coefficients" |

### 8.3 What to Call It

**Correct names for (m, d, a) algorithm**:
- ✅ Surd algorithm
- ✅ Complete quotient algorithm
- ✅ Lagrange's algorithm (historical)
- ✅ Auxiliary sequence method

**Incorrect/misleading names**:
- ❌ "Extended Euclidean algorithm"
- ❌ "Related to XGCD"
- ❌ "Backwards XGCD coefficients"

---

## 9. Code Example: Side-by-Side Comparison

### 9.1 XGCD for Rational 105/38

```python
def xgcd(a, b):
    r0, s0, t0 = a, 1, 0
    r1, s1, t1 = b, 0, 1
    quotients = []

    while r1 != 0:
        q = r0 // r1
        quotients.append(q)
        r0, r1 = r1, r0 - q*r1
        s0, s1 = s1, s0 - q*s1
        t0, t1 = t1, t0 - q*t1

    return quotients, (r0, s0, t0)

quotients, (g, s, t) = xgcd(105, 38)
# quotients = [2, 1, 3, 4, 2]  ← These are the CF partial quotients!
# g = 1, s·105 + t·38 = 1
```

### 9.2 Surd Algorithm for √105

```python
def surd_cf(D):
    a0 = int(D**0.5)
    m, d, a = 0, 1, a0
    sequence = [(m, d, a)]

    while True:
        m = d*a - m
        d = (D - m*m) // d
        a = (a0 + m) // d
        sequence.append((m, d, a))

        if a == 2*a0:  # Period ends
            break

    return sequence

seq = surd_cf(105)
# seq = [(0,1,10), (10,5,4), (10,1,20), (10,5,4), ...]
#        (m, d, a) ↑         ↑ Partial quotients
# Partial quotients: [10, 4, 20, 4, ...]  ← Periodic!
```

### 9.3 Key Observation

For √105:
- Partial quotients: [10; 4, 20, 4, 20, ...] (repeating)
- (m, d) sequence: (10,5), (10,1), (10,5), ... (also repeating)

For 105/38:
- Partial quotients: [2; 1, 3, 4, 2] (terminates)
- XGCD gives same quotients

**These are DIFFERENT sequences** (one terminates, one is periodic)!

---

## 10. Conclusion

**Main point**: The surd algorithm (m, d, a) is **NOT** the Extended Euclidean Algorithm, though both compute continued fractions.

**Connection**: XGCD is used for **rational** CF, surd algorithm is used for **quadratic irrational** CF like √D.

**User's intuition**: Partially correct that there's a relationship through convergent theory, but the (m,d) sequence is not the same as XGCD coefficients.

**Recommendation**: Use standard terminology "surd algorithm" or "complete quotient algorithm", avoid references to XGCD when discussing CF(√D).

---

**References**:
- Knuth, *The Art of Computer Programming*, Vol 2, §4.5.3 (surd algorithm)
- Perron, *Die Lehre von den Kettenbrüchen* (1929) (classical treatment)
- Rockett-Szüsz, *Continued Fractions* (1992) (modern exposition)
