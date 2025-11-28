# Unit Fraction Discovery: Primality & Factorization

**Date:** 2025-11-28 (late session continuation)

## The Formula

```mathematica
f[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, ∞}])
```

Starting index variations `{j, 0, i}` vs `{j, 1, i}` give different unit fraction sequences.

## Key Discovery

For the `{j, 1, i}` variant:

```
f[n] = num/den  where num = rad(odd part of n)
```

| n | f[n] | Interpretation |
|---|------|----------------|
| 3 | 3/32 | prime, num = 3 |
| 5 | 5/46624 | prime, num = 5 |
| 7 | 7/524854336 | prime, num = 7 |
| 15 = 3×5 | 15/... | squarefree, num = 15 |
| 9 = 3² | 3/... | has square, num = 3 |

## Factorization via gcd

For **squarefree composites** (num = n):

```
gcd(den ± k, n) = factor  for small k
```

| n | Factor found | Offset k |
|---|--------------|----------|
| 15 = 3×5 | 3 | -1 |
| 21 = 3×7 | 3 | +1 |
| 35 = 5×7 | 7 | +2 |
| 77 = 7×11 | 7 | -3 |
| 143 = 11×13 | 13 | +2 |

For **primes**: gcd(den±k, p) is always 1 or p (trivial).

## Combined Algorithm

```
1. Compute f[n] = num/den
2. If num < n → n has square factor or is even
3. If num = n:
   - Search gcd(den ± k, n) for k = 0, 1, 2, ...
   - Factor found → COMPOSITE
   - No factor → PRIME
```

## Variant Relationships

Four variants based on starting indices:
- `f00`: j=0..i, i=0..n  
- `f01`: j=0..i, i=1..n
- `f10`: j=1..i, i=0..n-1
- `f11`: j=1..i, i=1..n-1

**Exact relationships:**
```
S₀₀ = n² × S₁₀   (each term has factor n²)
S₀₁ = n² × S₁₁   (each term has factor n²)
S₁₀ - S₁₁ = 1    (empty product term)
S₀₀ - S₀₁ = n²   (first term is n²)
```

## Transition Point Discovery

For sequence of denominators d[k] starting at index k:

```
gcd(d[k] - d[k+1], n) = n  for k < min((p-1)/2, (q-1)/2)
gcd(d[k] - d[k+1], n) ≠ n  for k ≥ min((p-1)/2, (q-1)/2)
```

The **transition point** reveals the smaller factor: `p = 2k + 1`

**100% success rate on tested semiprimes!**

## Singularity Connection

The transition occurs where gcd(2i+1, n) > 1:

```
For i = (p-1)/2: gcd(2i+1, n) = gcd(p, n) = p
```

This is **equivalent to trial division by odd numbers**!

## Why Sum "Doesn't Converge" Symbolically

For symbolic n, the terms are:

```
T[i] = Product[n² - j², {j,1,i}] / (2i+1)
     = (-1)^i × Pochhammer[1-n, i] × Pochhammer[1+n, i] / (2i+1)
```

The Pochhammer products grow like factorials:
- Pochhammer[1+n, i] ~ (n+i)!/n! grows rapidly
- For symbolic n, this diverges

**But for integer n:**
- When i ≥ n: the product includes (n² - n²) = 0
- So T[i] = 0 for i ≥ n
- The "infinite" sum has only **n-1 nonzero terms**!

## Sum Convergence

Sum of all f[n] converges!

```
Sum[f[n], n=2..∞] ≈ 1.0983836192811585706...
```

The denominator grows super-exponentially: log₁₀(den) ~ n²

## Computational Complexity

**NOT a speedup!**

```
Approach 1: Direct computation
  - Sum has O(n) nonzero terms
  - Each term requires O(i) multiplications
  - Total: O(n²) operations
  - Numbers have O(n²) digits → O(n⁴) bit operations

Approach 2: Transition detection via full denominators  
  - Need O(√n) denominators
  - Each is O(n²) digits
  - Total: O(n^2.5) or worse

Approach 3: Mod n detection
  - Cannot compute T[i] mod n at Wilson points
  - gcd(2i+1, n) = factor at Wilson points → singularity!
  - Reduces to trial division by odd numbers

Compare to:
- Trial division: O(√n) divisions, O(log²n) per division
- Our methods are SLOWER
```

The formula is **mathematically beautiful** but **computationally equivalent to trial division**.

## Connection to Wilson Theorem

```
Product[n² - j², j=1..(p-1)/2] ≡ -(((p-1)/2)!)² ≡ (-1)^((p+1)/2) × (p-1)! (mod p)
                                                ≡ (-1)^((p+3)/2) (mod p)  by Wilson
```

For p | n:
- At i = (p-1)/2, the sum has a Wilson-type singularity
- This is exactly where trial division would find the factor

## Linear Combination Factorization

**Key discovery:** For variants f00 and f10 with denominators d00 and d10:

```
gcd(-d00 + b × d10, n) = factor   for small b
```

### Algebraic Structure (PROVEN)

Let S₁₀ = A/n where A is the numerator. Then:

```
B = n                     (denominator of S₁₀)
d00 = n×A - 1            (denominator of f00)
d10 = A - n              (denominator of f10)
```

**Key theorem:** For factor p | n:
```
gcd(-d00 + b×d10, n) contains p  ⟺  b ≡ -A⁻¹ (mod p)
```

### Why Small Coefficients Work

The optimal b for finding factor p is b = -A⁻¹ mod p.

**Empirical observation:** A mod p is typically small (1-9):

| n | p | q | A%p | A%q | b_p | b_q |
|---|---|---|-----|-----|-----|-----|
| 15 | 3 | 5 | 1 | 2 | -1 | 2 |
| 21 | 3 | 7 | 2 | 4 | 1 | -2 |
| 77 | 7 | 11 | 3 | 4 | 2 | -3 |
| 143 | 11 | 13 | 9 | 2 | -5 | 6 |
| 221 | 13 | 17 | 9 | 4 | -3 | 4 |

**Result:** All tested semiprimes factor with **b ∈ {-5,...,+6}**

### Factoring Algorithm

```mathematica
factorViaCombination[n_] := Module[{d00, d10, g},
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];

  Do[
    g = GCD[-d00 + b*d10, n];
    If[1 < g < n, Return[g]],
    {b, {-5,-4,-3,-2,-1,1,2,3,4,5,6}}
  ];
  Return[1]  (* prime *)
]
```

**100% success rate on all tested squarefree semiprimes!**

### Complexity Analysis

Still requires computing d00 and d10 with O(n²) digits.
- Arithmetic on O(n²)-digit numbers: O(n⁴) bit operations
- Not faster than trial division O(√n × log²n)

But the algebraic structure is remarkable: **small linear combinations of two huge numbers reveal factors.**

## Key Theorem: A ≡ ±q (mod p)

**Theorem (Nov 28, 2025):** For semiprime n = p × q where p, q are distinct odd primes:

```
A ≡ ±q (mod p)
```

where the sign depends on p mod 4 and the Stickelberger relation:

- **p ≡ 1 (mod 4):** A ≡ -q (mod p)
- **p ≡ 3 (mod 4):** A ≡ q × ((p-1)/2)! (mod p), where ((p-1)/2)! ≡ ±1 (mod p)

**Corollary:** The optimal coefficient b = -A⁻¹ (mod p) satisfies:
```
b ≡ ±q⁻¹ (mod p)
```

**Proof sketch:**
1. The sum S₁₀ has a singularity at i = (p-1)/2 where the denominator equals p
2. Before the singularity, all partial sums are ≡ 0 (mod p)
3. At the singularity, the contribution involves Product[n² - j², j=1..(p-1)/2]
4. For n = pq, this product ≡ (-1)^((p-1)/2) × ((p-1)/2)!² (mod p)
5. By Wilson's theorem and Stickelberger relation, this reduces to ±q (mod p)

**Verification:** Tested on all semiprimes p×q for p,q ∈ {3,5,7,11,13,17,19,23,29} - 100% match!

This theorem connects:
- Half-Factorial Numerator Theorem (from drafts)
- Stickelberger relation for ((p-1)/2)!
- Wilson's theorem (p-1)! ≡ -1 (mod p)

## Open Questions

### Resolved
- ✅ Why small coefficients work: b = -A⁻¹ (mod p), and A ≡ ±q (mod p)
- ✅ Why is A mod p "small"? It's ±q mod p, determined by the other factor!
- ✅ Connection to Wilson/Stickelberger: singularity at i=(p-1)/2 involves half-factorial

### Still Open
1. **OEIS lookup** for denominator sequence: 1, 32, 46624, 524854336, ...

2. **Sum limit** Sum[f[n], n=2..∞] ≈ 1.0983836192811585706...
   - Not obviously related to π, e, or common constants

3. **Can we compute A mod p without computing A?**
   - Knowing A ≡ ±q (mod p) doesn't help since we need p to compute mod p
   - Still requires O(n²)-digit arithmetic to get full A

4. Non-integer n regularization via Gamma functions?

5. Connection to hypergeometric 2F1 functions?

## Alternating Sum Exploration

The alternating sum:
```
Sum[(-1)^n × f₁₀[n], n=2..∞] ≈ 0.9106691107943440...
```

**Findings:**
- Close to η(3) = (3/4)ζ(3) ≈ 0.9015... (difference ~0.009)
- Continued fraction of (s - η(3)): [0; 109, 1, 1, 2, 1, 50, 3, ...]
- No simple closed form found involving π, e, ln(2), Catalan, or zeta values
- PSLQ search with common constants unsuccessful

**Partial sum structure:**
- f₁₀[2] = 1 exactly
- Numerators: n for n prime, largest odd divisor otherwise
- Denominators: 1, 32, 221, 46624, 2029667, 524854336, ... (not in OEIS)

## Separated Product Variant

Formula with product separated from sum:
```mathematica
fSep[n_, k_] := -1/(1 - Product[n^2 - j^2, {j, 1, k}] * (HarmonicNumber[2n-1] - HarmonicNumber[n-1]/2))
```

**Key identity for odd harmonic sum:**
```
1 + 1/3 + 1/5 + ... + 1/(2n-1) = HarmonicNumber[2n-1] - HarmonicNumber[n-1]/2
```

**Properties of fSep[n, n-1]:**
- Numerator = n for primes
- Numerator = 1 for composites (simpler than f₁₀!)
- BUT: Pk[n, n-1] = (2n-1)!/n — larger than Wilson's (n-1)!

## Original FractionalPart Formula (forfacti)

The original "closed form" factorization without explicit gcd:
```mathematica
forfacti[n_] := Module[{m = Floor[(Sqrt[n]-1)/2]},
  Sum[FractionalPart[Gamma[1+i+n]/(n*(1+2i)*Gamma[n-i])], {i, 1, m}]]

factor[n_] := 1/(1 - forfacti[n])
```

**Results:**
| n | p (smaller) | forfacti[n] | 1/(1-forfacti) |
|---|-------------|-------------|----------------|
| 15 | 3 | 2/3 | **3** |
| 35 | 5 | 4/5 | **5** |
| 77 | 7 | 6/7 | **7** |
| 143 | 11 | 10/11 | **11** |
| prime | — | 0 | undefined |

**No explicit gcd!** Just evaluate and invert.

### Analysis of Each Term

```
Term = Gamma[1+i+n]/(n*(1+2i)*Gamma[n-i])
     = Product[j, j=n-i..n+i] / (n*(2i+1))
     = (2i+1 consecutive integers centered at n) / (n*(2i+1))
```

**Key pattern:**
```
FracPart ≠ 0  ⟺  2i+1 = p (smaller factor)
              ⟺  i = (p-1)/2

When nonzero: FracPart = (p-1)/p
```

**Why?** At i = (p-1)/2, the Wilson singularity creates a non-integer quotient. FractionalPart captures exactly (p-1)/p.

### The Catch: Still Trial Division!

The iteration i = 1, 2, 3, ... tests 2i+1 = 3, 5, 7, ...

First nonzero FracPart occurs when 2i+1 = p (smallest factor).

**This IS trial division by odd numbers!**

| Trial division | forfacti |
|----------------|----------|
| n mod 3 = 0? | FracPart at i=1 ≠ 0? |
| n mod 5 = 0? | FracPart at i=2 ≠ 0? |
| n mod 7 = 0? | FracPart at i=3 ≠ 0? |

Moreover, each iteration computes Gamma ratios — **more expensive** than n mod p!

## Final Verdict: All Roads Lead to Trial Division

| Approach | Why it's trial division |
|----------|------------------------|
| Full computation | O(n²) digits, singularity at Wilson points |
| Mod n computation | Singularity detection = trial division |
| forfacti iteration | Testing i=1,2,3... means testing 2i+1=3,5,7... |
| FractionalPart | Implicit gcd via Wilson singularity |
| Separated product | Still needs huge (2n-1)! computation |
| Linear combinations | Requires O(n²)-digit numbers |

## Conclusion

Beautiful mathematical structure connecting:
- Egyptian fractions
- Pochhammer products / Gamma functions
- Wilson's theorem and Stickelberger relation
- Half-factorials and quadratic residues
- Primality testing
- Factorization

**Key theorems:**
1. A ≡ ±q (mod p) explains why linear combinations with small b work
2. forfacti[n] = (p-1)/p gives closed form without explicit gcd
3. FractionalPart detects Wilson singularity implicitly

**But NO computational advantage** — all roads lead to the O(√n) barrier.

The Wilson singularities are **exactly** where trial division succeeds. Every "closed form" either:
- Requires O(n²)-digit arithmetic, or
- Iterates through potential factors (= trial division), or
- Uses implicit gcd via fraction reduction

**Mathematically elegant. Computationally useless.**
