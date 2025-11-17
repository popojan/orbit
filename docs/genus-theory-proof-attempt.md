# Genus Theory Proof Attempt: Fundamental Unit Congruence mod p

**Date**: November 17, 2025
**Status**: 🔬 THEORETICAL EXPLORATION
**Goal**: Prove x₀ ≡ ±1 (mod p) classification via genus theory

---

## Empirical Pattern (VERIFIED)

For fundamental Pell solution x₀² - py₀² = 1 with prime p > 2:

```
p ≡ 1 (mod 4)  ⟹  x₀ ≡ -1 (mod p)
p ≡ 7 (mod 8)  ⟹  x₀ ≡ +1 (mod p)
```

Equivalently:
```
p ≡ 1 (mod 8)  ⟹  x₀ ≡ -1 (mod p)
p ≡ 3 (mod 8)  ⟹  x₀ ≡ -1 (mod p)
p ≡ 7 (mod 8)  ⟹  x₀ ≡ +1 (mod p)
```

**Verification**: 100% for tested primes (n > 30 per class)

---

## Quadratic Residue Context

The mod 8 classes have distinct QR profiles:

| p mod 8 | p mod 4 | (-1/p) | (2/p) | Special property |
|---------|---------|--------|-------|------------------|
| 1       | 1       | +1     | +1    | Both -1, 2 are QR |
| 3       | 3       | -1     | -1    | Neither -1, 2 are QR |
| 7       | 3       | -1     | +1    | **UNIQUE: 2 is QR, -1 is not** |

**Key observation**: p ≡ 7 (mod 8) is the ONLY class where:
- p ≡ 3 (mod 4) [so -1 is NOT a quadratic residue]
- p ≡ -1 (mod 8) [so 2 IS a quadratic residue]

This unique combination may determine fundamental unit behavior.

---

## Theoretical Framework

### 1. Fundamental Unit as Norm Equation

The fundamental unit ε₀ = x₀ + y₀√p satisfies:
```
N(ε₀) = x₀² - py₀² = 1
```

This is equivalent to the **norm equation** in Q(√p).

### 2. Genus Field Structure

For K = Q(√p), the **genus field** H₁ is the maximal abelian extension of K unramified outside infinity, with exponent dividing 2.

**Classical result** (genus theory):
```
H₁ = K(√a₁, √a₂, ..., √aₙ)
```
where the aᵢ are determined by the splitting of primes in K according to quadratic reciprocity.

For p ≡ 1 (mod 4):
```
H₁ = K  (genus field equals base field)
```

For p ≡ 3 (mod 4):
```
H₁ = K(√(-1)) or higher order depending on p mod 8
```

### 3. Hilbert Symbols and Local Structure

The **Hilbert symbol** (a,b)ᵥ at place v encodes local solvability of:
```
x² - ay² = bz²
```

For our case (x₀² - py₀² = 1):
```
(x₀, p)₂ = ?
(x₀, p)ₚ = ?
(x₀, p)∞ = ?
```

By the **product formula**:
```
∏ᵥ (x₀, p)ᵥ = 1
```

---

## Hypothesis: Mod 8 Connection via Hilbert Symbol at 2

**Conjecture**: The 2-adic Hilbert symbol (x₀, p)₂ distinguishes the mod 8 classes.

### Case 1: p ≡ 7 (mod 8)

Here p = 8k + 7, so p ≡ -1 (mod 8).

**Key fact**: 2 is a quadratic residue mod p (from QR law).

**Hypothesis**: This forces x₀ ≡ +1 (mod p) through:
1. Local condition at 2: (x₀, p)₂ determined by p ≡ -1 (mod 8)
2. Global product formula forces x₀ mod p compatibility
3. x₀ ≡ +1 (mod p) is the unique solution

### Case 2: p ≡ 1 or 3 (mod 8)

Here p ≡ 1 (mod 8) or p ≡ 3 (mod 8).

**For p ≡ 1 (mod 8)**: Both -1 and 2 are QR mod p
**For p ≡ 3 (mod 8)**: Neither -1 nor 2 are QR mod p

**Hypothesis**: These force x₀ ≡ -1 (mod p) by similar local-global argument.

---

## Approach via Norm from Q(√p) to Q

Consider the map:
```
N: Q(√p)* → Q*
ε = x + y√p ↦ x² - py²
```

For fundamental unit ε₀, we have N(ε₀) = 1.

**Key question**: What does x₀ ≡ ±1 (mod p) tell us about ε₀ mod 𝔭 where 𝔭 | p?

### Factorization of (p) in Q(√p)

Since p ≡ 1 (mod 4) or p ≡ 3 (mod 4):

**If p ≡ 1 (mod 4)**:
```
(p) = 𝔭·𝔭̄  (splits into two distinct primes)
```

**If p ≡ 3 (mod 4)**:
```
(p) = 𝔭²     (ramifies)
```

### Unit Reduction mod 𝔭

Consider ε₀ = x₀ + y₀√p mod 𝔭:

**For p ≡ 1 (mod 4)** (split):
√p ≡ α (mod 𝔭) where α² ≡ p (mod 𝔭)

But 𝔭 | p, so we need to work in O_K/𝔭.

**For p ≡ 3 (mod 4)** (ramified):
√p ≡ 0 (mod 𝔭) in some sense (ramification)

This gets technical. Let me try a different angle.

---

## Approach via Continued Fractions

### Period Structure

Classical result: For √p, the continued fraction has period n where:
- **Odd period n**: negative Pell x² - py² = -1 is solvable
- **Even period n**: negative Pell is NOT solvable

**Empirical observation** (from earlier tests):
```
p ≡ 3 (mod 8) → period ≡ 2 (mod 4) [verified]
p ≡ 7 (mod 8) → period ≡ 0 (mod 4) [verified]
```

**Question**: Does period mod 4 → x₀ mod p?

### Symmetry in CF Expansion

For √p with CF = [a₀; a₁, a₂, ..., aₙ, 2a₀], there's a **palindromic structure**:
```
aᵢ = aₙ₋ᵢ for i < n
```

**Hypothesis**: The symmetry + mod 8 class determines whether final convergent satisfies x ≡ +1 or -1 (mod p).

---

## Genus Theory via Class Field Theory

### Setup

For K = Q(√p), the class group Cl(K) splits into **genus classes**:
```
Cl(K) / Cl(K)² ≅ (Z/2Z)ʳ
```
where r is the **2-rank** of the class group.

**Genus theory** (Gauss): r is determined by number of primes dividing discriminant with odd multiplicity.

For prime p:
- Discriminant = p (if p ≡ 1 mod 4)
- Discriminant = 4p (if p ≡ 3 mod 4)

**Result**:
```
For p ≡ 1 (mod 4): r = 0 (principal genus only)
For p ≡ 3 (mod 4): r = 1 (two genera)
```

### Connection to Fundamental Unit

The fundamental unit ε₀ lives in the **unit group** O_K*.

**Question**: Does ε₀ have a **class field theoretic characterization** that depends on p mod 8?

**Idea**: Use the **norm residue symbol** from class field theory:
```
(a, K/F)_v = local Artin symbol
```

For K = Q(√p) and F = Q, this encodes how a ∈ Q* behaves in the extension.

---

## Rédei Theory and 2-Rank

**Rédei's theory** (1930s-1950s) gives explicit formulas for 2-rank of class groups using **genus characters** and **quadratic residue patterns**.

For real quadratic fields Q(√p):
```
rank₂(Cl(K)) = number of odd prime divisors of discriminant - 1
```

For our case:
- p ≡ 1 (mod 4): rank₂ = 0
- p ≡ 3 (mod 4): rank₂ ≥ 0 (depends on finer structure)

**Connection to units**: The **unit signature** (signs of ε₀ at real embeddings) may correlate with genus structure.

---

## Strategy: Product Formula Approach

### Hilbert Product Formula

For a, b ∈ Q*, the **global Hilbert symbol** satisfies:
```
∏ₚ (a,b)ₚ = 1
```
where the product is over all places p (including p=∞).

### Application to x₀² - py₀² = 1

Rewrite as:
```
x₀² = 1 + py₀²
```

Consider Hilbert symbols:
```
(x₀, 1 + py₀²)₂ = ?
(x₀, 1 + py₀²)ₚ = ?
(x₀, 1 + py₀²)∞ = +1 (since both positive)
```

**Key constraint**: Product must equal 1.

### At p=2 (2-adic)

The 2-adic Hilbert symbol (x₀, p)₂ depends on:
- x₀ mod 8
- p mod 8

**Explicit formula** (from symbol tables):
```
(a, b)₂ = (-1)^(ω(a)·ω(b) + ε(a)·φ(b) + ε(b)·φ(a))
```
where:
- ω(a) = 0 if a ≡ 1 (mod 4), 1 if a ≡ 3 (mod 4)
- ε(a) = 0 if a ≡ ±1 (mod 8), 1 if a ≡ ±3 (mod 8)

**Hypothesis**: For our x₀ and p, the formula forces specific x₀ mod p values depending on p mod 8.

---

## Computational Verification Needed

To proceed, I need to:

1. **Compute Hilbert symbols** (x₀, p)₂ for various primes
2. **Check 2-rank** of Cl(Q(√p)) and correlate with x₀ mod p
3. **Test product formula** explicitly
4. **Consult Leonard-Williams** (1980) quartic character paper for methodology

---

## Next Steps

### Immediate (computational):
1. Compute (x₀, p)₂ for 20+ primes in each mod 8 class
2. Check if (x₀, p)₂ = +1 always or depends on p mod 8
3. Correlate with x₀ ≡ ±1 (mod p) pattern

### Theoretical (research):
1. Search for **explicit genus theory formulas** for unit congruences
2. Find **class field theory** characterization of ε₀ mod p
3. Consult **Stevenhagen** papers on unit norm signatures
4. Check **Rédei symbol** literature for p ≡ 7 (mod 8) special case

### Proof attempt:
1. Show (x₀, p)₂ distinguishes p ≡ 7 (mod 8) from others
2. Use product formula to derive x₀ mod p constraint
3. Argue uniqueness from fundamental unit minimality

---

## Open Questions

1. **Is there a direct formula** for x₀ mod p in terms of CF coefficients?
2. **Does genus field H₁** have explicit generators involving ε₀?
3. **Can we use Dirichlet's class number formula** to connect h(p) with x₀ mod p?
4. **Is period ≡ 0 (mod 4) for p ≡ 7 (mod 8)** a rigorous theorem or empirical?

---

**Status**: Theoretical framework outlined. Need computational verification of Hilbert symbols + literature deep dive.

**Confidence**: 40% that genus theory + Hilbert symbols will yield proof.

**Alternative**: If Hilbert approach fails, try **direct CF analysis** or **ask MathOverflow**.
