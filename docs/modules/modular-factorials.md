# Efficient Modular Factorial Computation

## Overview

This module implements an efficient method for computing `n! mod p` for prime `p`, exploiting the beautiful structure of `((p-1)/2)! mod p` which can be determined up to sign based on whether -1 is a quadratic residue modulo p.

## The Core Insight

For prime $p$ and $\frac{p-1}{2} \le n < p$:

**Instead of computing $n!$ from scratch**, we use:

$$n! \equiv \left(\frac{p-1}{2}\right)! \times \left(\frac{p-1}{2} + 1\right) \times \cdots \times n \pmod{p}$$

The key: $\left(\frac{p-1}{2}\right)! \bmod p$ has predictable structure!

## The Half-Factorial Values

For prime $p > 2$:

**Case 1:** $p \equiv 1 \pmod{4}$
- $\sqrt{-1}$ exists mod $p$
- $\left(\frac{p-1}{2}\right)! \equiv \pm\sqrt{-1} \pmod{p}$
- Can compute $\sqrt{-1} = \text{PowerMod}[p-1, 1/2, p]$

**Case 2:** $p \equiv 3 \pmod{4}$
- $\sqrt{-1}$ does NOT exist mod $p$
- $\left(\frac{p-1}{2}\right)! \equiv \pm 1 \pmod{p}$

### Examples

For $p = 13$ ($\equiv 1 \pmod{4}$):
- $\sqrt{-1} \equiv 5$ or $8 \pmod{13}$
- $6! \equiv 5 \pmod{13}$ ✓ (one of the square roots)

For $p = 7$ ($\equiv 3 \pmod{4}$):
- $\sqrt{-1}$ does not exist
- $3! \equiv 6 \equiv -1 \pmod{7}$ ✓

## Mathematical Background

### Connection to Gauss Sums

The value of $\left(\frac{p-1}{2}\right)! \bmod p$ is intimately connected to **Gauss sums** and quadratic residues:

$$g(\chi) = \sum_{n} \chi(n) \zeta^n$$

where $\chi$ is the Legendre symbol and $\zeta$ is a primitive root of unity.

### Stickelberger Relation

The **Stickelberger relation** from algebraic number theory governs the sign ambiguity in $\left(\frac{p-1}{2}\right)! \bmod p$. This deep connection explains why the values are so predictable!

## Usage

### Basic Factorial Computation

```mathematica
<< Orbit`

(* Compute 10! mod 13 *)
FactorialMod[10, 13]
(* Returns: 6 *)

(* Verify *)
Mod[10!, 13]
(* Returns: 6 *)
```

### Computing sqrt(-1) mod p

```mathematica
(* For p ≡ 1 (mod 4) *)
SqrtMod[13]
(* Returns: {True, {5, 8}} *)

(* Verify: 5² ≡ -1 (mod 13) *)
Mod[5^2, 13]
(* Returns: 12 ≡ -1 *)

(* For p ≡ 3 (mod 4) *)
SqrtMod[7]
(* Returns: {False, {1, 6}} *)
```

### Half-Factorial Values

```mathematica
(* Get the half-factorial value *)
HalfFactorialMod[13]
(* Returns: 5 (which is 6! mod 13) *)

(* Get possible values *)
HalfFactorialValues[13]
(* Returns: {True, {5, 8}} - indicating sqrt(-1) exists *)
```

### Verification

```mathematica
(* Single verification *)
VerifyFactorialMod[10, 13]

(* Batch verification for p = 17 *)
BatchVerifyFactorialMod[Range[9, 16], 17]
```

## Efficiency

The method is more efficient than naive factorial computation because:

1. **Predictable base value**: $\left(\frac{p-1}{2}\right)!$ is one of 2-4 known values
2. **Reduced multiplications**: Only $\sim n-\frac{p-1}{2}$ multiplications needed
3. **Modular arithmetic**: All operations stay in $\mathbb{Z}/p\mathbb{Z}$

### Performance Characteristics

For $n$ close to $p$, the speedup is minimal. The real advantage is having a **closed-form characterization** of the half-factorial base value.

## Pattern Exploration

### Classify Primes

```mathematica
(* Classify primes by half-factorial structure *)
classification = ClassifyPrimesByHalfFactorial[100];

(* Count primes with sqrt(-1) *)
Length[classification["Has sqrt(-1)"]]

(* Get primes ≡ 1 (mod 4) *)
classification["p==1(mod 4)"]
```

### Observed Patterns

For $p \equiv 3 \pmod{4}$, the sign of $\left(\frac{p-1}{2}\right)!$ follows a pattern:

| $p$ | $\left(\frac{p-1}{2}\right)! \bmod p$ |
|-----|---------------------------------------|
| 3   | $\equiv 1$                            |
| 7   | $\equiv -1$                           |
| 11  | $\equiv -1$                           |
| 19  | $\equiv -1$                           |
| 23  | $\equiv 1$                            |
| 31  | $\equiv 1$                            |

This pattern is governed by the **class number** and other deep invariants!

## API Reference

### Core Functions

- `SqrtMod[p]` - Compute $\sqrt{-1} \bmod p$ if it exists
- `HalfFactorialMod[p]` - Compute $\left(\frac{p-1}{2}\right)! \bmod p$
- `HalfFactorialValues[p]` - Get possible values for half-factorial
- `FactorialMod[n, p]` - Efficiently compute $n! \bmod p$
- `FactorialMod[n]` - Use $p = \text{NextPrime}[2n, -1]$

### Verification

- `NaiveFactorialMod[n, p]` - Naive computation for comparison
- `VerifyFactorialMod[n, p]` - Detailed verification
- `BatchVerifyFactorialMod[nList, p]` - Batch verification

### Analysis

- `ClassifyPrimesByHalfFactorial[pmax]` - Classify primes by structure
- `ComparePerformance[n, p]` - Performance comparison

## Examples

```mathematica
(* Explore the pattern for small primes *)
Table[{p, Mod[p, 4], HalfFactorialMod[p]},
  {p, Select[Range[3, 50], PrimeQ]}] // TableForm

(*
  Prime   Mod 4   Half-factorial
  3       3       1
  5       1       2
  7       3       6 ≡ -1
  11      3       10 ≡ -1
  13      1       5  (sqrt(-1))
  17      1       13 (sqrt(-1))
  ...
*)

(* Verify sqrt properties *)
p = 29;
{exists, values} = SqrtMod[p];
If[exists,
  Print["sqrt(-1) mod ", p, " = ", values];
  Print["Verification: ", values[[1]]^2, " ≡ ", Mod[values[[1]]^2, p], " (mod ", p, ")"]
]
(*
  sqrt(-1) mod 29 = {12, 17}
  Verification: 144 ≡ 28 ≡ -1 (mod 29)
*)
```

## Theoretical Connections

1. **Wilson's Theorem**: $(p-1)! \equiv -1 \pmod{p}$
2. **Quadratic Reciprocity**: Determines when $\sqrt{-1}$ exists
3. **Gauss Sums**: Connect to exponential sums and character theory
4. **Stickelberger Relation**: Governs sign ambiguities

## Limitations

- Requires prime $p$
- Most efficient for $n$ in range $\frac{p-1}{2} \le n < p$
- **Sign determination requires actual computation** (up to sign)

### The CRT Dream (And Why It Fails)

One might hope to use the Chinese Remainder Theorem to compute factorials:

**The idea:**
1. Compute $n! \bmod p$ for multiple primes $p$ (each known up to $\pm$ sign)
2. Use CRT to reconstruct $n!$ from these residues
3. Efficient factorial computation!

**Why this fails catastrophically:**

**Problem 1: Sign Ambiguity**
- Each residue $n! \bmod p$ is one of 2 values (or 4 for $p \equiv 1 \pmod{4}$)
- With $k$ primes, you have $2^k$ possible sign combinations
- Determining which combination is correct requires computation as expensive as the factorial itself!

**Problem 2: Prime Coverage**
- To reconstruct $n!$ via CRT, need: $\prod p_i > n!$
- $n!$ grows like $(n/e)^n$ (Stirling)
- Product of primes up to $n$ grows like $e^n$ (Prime Number Theorem)
- Need primes **way** bigger than $n$ → defeats the efficiency!

**Example:** For $n = 20$:
- $20! \approx 2.4 \times 10^{18}$
- Product of primes up to 100 $\approx 2.3 \times 10^{38}$ (good coverage)
- But $\sim$25 primes → $2^{25} \approx 33$ million sign combinations to check!

**Verdict**: Beautiful theoretical structure, but **computationally useless** for CRT reconstruction. The sign ambiguity is fatal.

## Suggested Readings & Connections

### Related Theory

1. **Quadratic Residues and Reciprocity**
   - Gauss's Disquisitiones Arithmeticae (Arts. 98-102 on quadratic residues)
   - Quadratic reciprocity law
   - Legendre symbol and Jacobi symbol
   - "Number Theory" by Borevich & Shafarevich

2. **Gauss Sums**
   - Connection to $\sqrt{-1} \bmod p$ and half-factorials
   - Exponential sums in analytic number theory
   - "Gauss and Jacobi Sums" by Berndt, Evans, Williams
   - Applications to character sums

3. **Stickelberger's Theorem**
   - Algebraic number theory and class field theory
   - Sign determination in cyclotomic fields
   - Connection to ideal class groups
   - "Algebraic Number Theory" by Lang

4. **Factorial Modular Arithmetic**
   - Wilson's theorem and its generalizations
   - Factorial prime factorization (Legendre's formula)
   - "Introduction to Analytic Number Theory" by Apostol
   - Applications to primality testing

5. **Chinese Remainder Theorem**
   - CRT and its limitations (as discussed above)
   - Applications in computational number theory
   - "Concrete Mathematics" by Graham, Knuth, Patashnik

### Practical Value

Despite theoretical elegance:
- **Not faster** than naive factorial computation for actual calculation
- **CRT application fails** due to sign ambiguity
- **Main value**: Understanding the algebraic structure of factorials modulo primes

Useful for:
- Verification of factorial computations
- Theoretical investigations in modular arithmetic
- Understanding connections between Gauss sums and factorials

### Keywords for Further Research

- Gauss sums, quadratic residues, Stickelberger relation, half-factorial modulo prime, Wilson's theorem, Chinese Remainder Theorem limitations, class field theory, cyclotomic fields

## Future Directions

- Full proof of sign patterns for $p \equiv 3 \pmod{4}$ via class numbers
- Connection to $p$-adic analysis and $p$-adic gamma functions
- Generalize to composite moduli (if possible)
- Investigate rare cases where sign can be predicted efficiently

## References

- Gauss sums and quadratic residues (classical number theory)
- Stickelberger relation in algebraic number theory
- Original implementation: User-provided recreational mathematics
- Status: Theoretically understood via Gauss sums; CRT application proven impractical
