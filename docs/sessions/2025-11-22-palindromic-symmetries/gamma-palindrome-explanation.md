# Gamma Palindrome Explanation

## Weight Structure in `reconstruct[nn, n, k]`

```
w[i] = n^(2-2i+2⌈k/2⌉) · nn^i / (Γ(-1+2i) · Γ(4-2i+k))
```

## Key Discovery: Constant Sum Property

**Gamma arguments:**
- α(i) = -1 + 2i
- β(i) = 4 - 2i + k

**Sum:**
```
α(i) + β(i) = (-1+2i) + (4-2i+k) = 3+k = CONSTANT
```

This is **independent of i**!

## Concrete Example (k=5)

| i | Γ arg 1 | Γ arg 2 | Sum | Mirror pair |
|---|---------|---------|-----|-------------|
| 1 | 1       | 7       | 8   | i=4         |
| 2 | 3       | 5       | 8   | i=3         |
| 3 | 5       | 3       | 8   | i=2         |
| 4 | 7       | 1       | 8   | i=1         |

**Observation:**
- Γ(1)·Γ(7) at i=1 ↔ Γ(7)·Γ(1) at i=4
- Γ(3)·Γ(5) at i=2 ↔ Γ(5)·Γ(3) at i=3

**Swap property:** α(i) = β(j) and β(i) = α(j) where j = limit+1-i

## Theoretical Foundation: Beta Function Symmetry

### Beta Function Definition
```
B(a,b) = Γ(a)·Γ(b) / Γ(a+b)
```

### Fundamental Symmetry
```
B(a,b) = B(b,a)
```

This is **trivial from commutativity** of multiplication, but has deep consequences!

### Application to Weights

When α + β = S (constant):
```
Γ(α)·Γ(β) = Γ(S)·B(α,β)          (by definition)
          = Γ(S)·B(β,α)          (by symmetry B(a,b)=B(b,a))
          = Γ(β)·Γ(α)            (by commutativity)
```

Therefore: **Swapping (α,β) → (β,α) doesn't change the Gamma product!**

### Index Transformation

Mirror transformation: i → j = (limit+1-i)

This swaps:
- α(i) = -1+2i → α(j) = -1+2(limit+1-i) = -1+2limit+2-2i
- β(i) = 4-2i+k → β(j) = 4-2(limit+1-i)+k = 4-2limit-2+2i+k

For k=5, limit=4:
- i=1: α=1, β=7
- j=4: α=7, β=1  ← **Perfect swap!**

## Why Not Exact Palindrome?

Weights also have power factors: n^(2-2i+2⌈k/2⌉) · nn^i

**Full weight ratio:**
```
w[i] / w[j] = [n^(2-2i) · nn^i] / [n^(2-2j) · nn^j] · [Γ(α_j)·Γ(β_j)] / [Γ(α_i)·Γ(β_i)]
            = [n^(2-2i) · nn^i] / [n^(2-2j) · nn^j] · 1  (by Gamma symmetry)
            = (n/nn)^(2(j-i)) · (nn)^(i-j)
```

**When n ≈ nn ≈ √target:**
- Ratio approaches 1
- Weights become **approximately palindromic**
- But NOT exactly due to power factors

## The Real Palindrome: Gamma Structure

**What IS palindromic:**
The Gamma factor arrangement:
```
Γ(α₁)·Γ(β₁), Γ(α₂)·Γ(β₂), ..., Γ(α_lim)·Γ(β_lim)
= Γ(β_lim)·Γ(α_lim), ..., Γ(β₂)·Γ(α₂), Γ(β₁)·Γ(α₁)
```

**What is NOT palindromic:**
The full weights w[i] due to n^/nn^ power factors

## Why Does This Matter?

**Convergence implication:**
- Symmetric Gamma structure creates balanced contributions from low/high indices
- Each term i is "paired" with term (limit+1-i)
- Power factors introduce asymmetry that fine-tunes convergence
- Result: Exponential convergence to √nn

**Mathematical elegance:**
- Beta symmetry B(a,b)=B(b,a) is fundamental
- Appears here in disguise as Gamma palindrome
- Creates hidden structure in sqrt approximation

## Comparison with Tangent Palindrome

| Aspect | Tangent F_n(x) | Gamma Weights |
|--------|----------------|---------------|
| **Palindrome type** | Exact coefficients | Approximate (Gamma part exact) |
| **Mechanism** | f(x)·f(1/x)=±1 | B(a,b)=B(b,a) |
| **Origin** | Complementary angles | Beta symmetry |
| **Structure** | p_n/x ↔ q_n | w[i] ↔ w[limit+1-i] |
| **Power law** | Polynomial reversal | n^/nn^ breaks exact palindrome |

## Conclusion

**Gamma weights have STRUCTURAL palindrome:**
- Gamma arguments swap: (α,β) ↔ (β,α)
- Beta function symmetry: B(a,b) = B(b,a)
- Creates symmetric weight pattern

**NOT exact numerical palindrome:**
- Power factors n^(2-2i)·nn^i break exact symmetry
- When n ≈ nn, approaches palindrome
- Asymmetry fine-tunes convergence

**This is deeper than coefficient matching** - it's about Beta function symmetry creating balanced summation structure in sqrt approximation.
