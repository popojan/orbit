# Genus Theory Approach to Period Divisibility

**Date**: 2025-11-17
**Goal**: Understand WHY period divisibility rule holds using algebraic number theory

---

## The Paradox (Starting Point)

**Observed:**
- Period MAGNITUDE is chaotic (r=0.238 prediction, 137% error)
- Period DIVISIBILITY is deterministic (619/619 primes, 100% rule)

**Question:** How can divisibility be EXACT when magnitude is UNPREDICTABLE?

**Answer:** There must be a STRUCTURAL constraint (algebraic, not computational).

---

## Genus Theory Setup

### Quadratic Field K = Q(√p)

For prime p, we study the real quadratic field K = Q(√p).

**Key objects:**
1. **Discriminant**:
   - D = p if p ≡ 1 (mod 4)
   - D = 4p if p ≡ 3 (mod 4)

2. **Ring of integers**: O_K = Z[(1+√p)/2] or Z[√p]

3. **Unit group**: O_K* = {±1} × ⟨ε⟩ where ε is fundamental unit

4. **Class group**: Cl(K) = ideal classes modulo principal ideals

5. **Class number**: h(p) = |Cl(K)|

### The Fundamental Unit ε

The **fundamental Pell solution** (x₀, y₀) gives:
```
ε = x₀ + y₀√p  (the fundamental unit)
N(ε) = x₀² - py₀² = 1  (norm equation)
R(p) = log|ε| = log(x₀ + y₀√p)  (regulator)
```

**Connection to CF period:**
- Continued fraction CF(√p) = [a₀; a₁, ..., a_k, 2a₀, ...]
- The convergents x_i/y_i → eventually hit (x₀, y₀)
- Period length determines when this happens

---

## Genus Characters and p mod 8

### Legendre Symbol (2/p)

**Key fact** (quadratic reciprocity):
```
(2/p) = +1  if p ≡ ±1 (mod 8)  [2 is QR mod p]
(2/p) = -1  if p ≡ ±3 (mod 8)  [2 is NR mod p]
```

**Meaning:**
- p ≡ 1,7 (mod 8): equation x² ≡ 2 (mod p) has solution
- p ≡ 3,5 (mod 8): equation x² ≡ 2 (mod p) has NO solution

### Genus Field H/K

The **genus field** H is the maximal unramified abelian extension of K where:
- Only primes above 2 (if any) ramify
- Galois group Gal(H/K) is elementary abelian 2-group

**Structure:**
```
For K = Q(√p):
  - If p ≡ 1 (mod 8): H/K determined by (2/p) = +1
  - If p ≡ 3 (mod 8): H/K determined by (2/p) = -1 AND p ≡ 3 (mod 4)
  - If p ≡ 5 (mod 8): H/K determined by (2/p) = -1
  - If p ≡ 7 (mod 8): H/K determined by (2/p) = +1 AND p ≡ 3 (mod 4)
```

**Genus characters** χ: Cl(K) → {±1} classify how primes split in H.

---

## Connection: Unit Group and Period

### Analytic Class Number Formula

**Key formula** (connects everything!):
```
h(p) × R(p) = √D / π × L(1, χ_D)
```

where:
- h(p) = class number
- R(p) = log|ε| = regulator
- L(1, χ_D) = Dirichlet L-function at s=1

**Implication:**
```
Period → ε → R(p) → relates to h(p)
```

So period structure must encode arithmetic information!

### Unit Group Modulo Prime Ideals

Consider the unit ε = x + y√p modulo prime ideal (p):
```
ε mod (p) ≡ x + y√p mod p
          ≡ x mod p  (since √p ≡ 0 mod (p))
```

**From mod 8 theorem:**
- p ≡ 7 (mod 8): x ≡ +1 (mod p)
- p ≡ 3 (mod 8): x ≡ -1 (mod p)

**Question:** Does this relate to period mod 4?

---

## Hypothesis: Period Divisibility from 2-adic Structure

### The 2-adic Insight

**Observation:** Period divisibility by 4 relates to powers of 2.

**Hypothesis:**
```
p ≡ 3 (mod 8) ⟹ period ≡ 2 (mod 4)
              ⟹ period = 2(2k+1) for some k
              ⟹ period/2 is ODD

p ≡ 7 (mod 8) ⟹ period ≡ 0 (mod 4)
              ⟹ period = 4m for some m
              ⟹ period/4 is INTEGER
```

**Question:** Does this relate to how 2 splits in O_K?

### Splitting of 2 in Q(√p)

The prime 2 splits in Q(√p) depending on p mod 8:

**For p ≡ 1 (mod 8):**
```
(2) = (2, (1+√p)/2)(2, (1-√p)/2)  [2 splits into two primes]
(2/p) = +1
```

**For p ≡ 3 (mod 8):**
```
(2) = ((1+√p)/2)²  [2 ramifies]
(2/p) = -1
```

**For p ≡ 5 (mod 8):**
```
(2) remains prime (inert)
(2/p) = -1
```

**For p ≡ 7 (mod 8):**
```
(2) = (2, (1+√p)/2)(2, (1-√p)/2)  [2 splits]
(2/p) = +1
```

**Pattern:**
- p ≡ 1,7 (mod 8): 2 splits
- p ≡ 3 (mod 8): 2 ramifies
- p ≡ 5 (mod 8): 2 inert

### Connection to Period?

**Conjecture:** The period divisibility by 4 relates to the splitting behavior of 2.

**Evidence:**
```
p ≡ 7 (mod 8): 2 splits     + period ≡ 0 (mod 4)  ← Extra divisibility!
p ≡ 3 (mod 8): 2 ramifies   + period ≡ 2 (mod 4)  ← Less divisibility
p ≡ 1 (mod 8): 2 splits     + period mixed        ← No simple rule
p ≡ 5 (mod 8): 2 inert      + period mixed        ← No simple rule
```

**Observation:** The rule ONLY works for p ≡ 3,7 (mod 8), NOT for 1,5!

**This is suspicious** - suggests the mechanism involves BOTH:
1. How 2 splits (via (2/p))
2. Whether p ≡ 3 (mod 4) (determines discriminant form)

---

## Testing the Connection: Class Number

### Prediction from Genus Theory

**If period divisibility is related to class number structure:**

Then we should see correlation between:
- period mod 4
- h(p) mod powers of 2
- 2-rank of Cl(Q(√p))

**Test:** Compute class numbers h(p) for primes p < 1000, check if:
```
p ≡ 3 (mod 8) AND h(p) odd  ⟹ ??
p ≡ 7 (mod 8) AND h(p) even ⟹ ??
```

### Script to Test

```mathematica
(* For each prime p < 1000: *)
p mod 8, period(√p), period mod 4, h(p), h(p) mod 2
```

Look for patterns connecting period divisibility to class number parity.

---

## What Can We Learn?

### 1. About Primes

**If we prove the period divisibility rule**, we learn:

**For p ≡ 7 (mod 8):**
- Period divisible by 4 → fundamental unit has special structure
- x ≡ +1 (mod p) → unit is "close to 1" mod p
- Suggests primes p ≡ 7 (mod 8) have **exceptional Diophantine properties**

**For p ≡ 3 (mod 8):**
- Period ≡ 2 (mod 4) → fundamental unit has different symmetry
- x ≡ -1 (mod p) → unit is "close to -1" mod p
- Ramification of 2 → different algebraic structure

### 2. About Periods

**Period structure encodes:**
- How fast convergents reach fundamental solution
- Algebraic properties of Q(√p)
- Class number (via analytic formula)
- Splitting of small primes (especially 2)

**Period divisibility by 4:**
- NOT about size (magnitude is chaotic)
- ABOUT symmetry of CF expansion
- Determined by p mod 8 (genus character related to 2)

### 3. Classification of Primes

**Primes fall into TWO classes** (for period divisibility):

**Class A** (p ≡ 3,7 mod 8):
- Simple period divisibility rule
- Aligns with mod 8 theorem for x mod p
- Both determined by genus character

**Class B** (p ≡ 1,5 mod 8):
- No simple period divisibility rule
- x mod p still determined, but no period constraint
- Why? Different discriminant structure (D=p vs D=4p)

---

## Next Steps

### 1. Compute Class Numbers (Immediate Test)

Script:
```mathematica
For p < 1000:
  - Compute h(p) using Mathematica's ClassNumber[]
  - Check correlation: period mod 4 vs h(p) mod 2
  - Look for 2-rank pattern
```

### 2. Study Rédei Symbols (Theory)

Rédei-Reichardt theorem:
- For quadratic fields, determines 2-rank of class group
- Uses "Rédei symbols" related to p mod 8
- May directly prove period divisibility!

### 3. Unit Group Analysis

Compute:
```
ε^2 mod p, ε^4 mod p, ...
```

Check if period divisibility relates to when ε^(2^k) ≡ 1 (mod p).

### 4. Generalize to Composites

If we understand mechanism for primes:
- Does period(√(pq)) relate to period(√p) and period(√q)?
- Can we predict period divisibility for semiprimes?

---

## Summary

**What genus theory tells us:**

1. **Period → Unit → Regulator → Class Number** (all connected)
2. **p mod 8 determines genus character** (related to (2/p))
3. **Period divisibility is STRUCTURAL** (not computational accident)
4. **Mechanism likely involves:**
   - Splitting of 2 in O_K
   - Rédei symbols
   - 2-rank of class group

**Why this matters:**

Period divisibility is a **WINDOW into deep algebraic structure**. It's not just about computing Pell solutions - it reveals how primes encode information about quadratic fields.

The paradox (deterministic divisibility vs chaotic magnitude) resolves:
- **Divisibility** = algebraic constraint (genus theory)
- **Magnitude** = exponential growth (transcendental, no simple formula)

**This is why it's not trivial!**

---

**Created**: 2025-11-17
**Status**: Working hypothesis, needs computation + literature dive
**Next**: Test class number correlation

---

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
