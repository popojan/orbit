# Primorial Formula: Investigation Findings

## Current Understanding

### The Pattern (CONFIRMED)

For the formula:

$$\text{Primorial}_0(m) = \text{Denominator}\left[\frac{1}{2} \sum_{k=1}^{\lfloor(m-1)/2\rfloor} \frac{(-1)^k \cdot k!}{2k+1}\right]$$

**Key Finding:** The denominator at step $k$ equals:

$$D_k = 2 \times \prod_{\substack{p \text{ prime} \\ 3 \le p \le 2k+1}} p$$

### Step-by-Step Mechanism

1. **Individual terms** have the form: $\frac{(-1)^k \cdot k!}{2k+1}$
   - The denominator of each term (after reducing $k!$) is $(2k+1)$
   - These are consecutive odd numbers: $3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, \ldots$

2. **When $2k+1$ is PRIME**: A new prime enters the overall denominator
   - $k=1$: $2k+1 = 3$ (prime) → denom becomes $2 \times 3 = 6$
   - $k=2$: $2k+1 = 5$ (prime) → denom becomes $2 \times 3 \times 5 = 30$
   - $k=3$: $2k+1 = 7$ (prime) → denom becomes $2 \times 3 \times 5 \times 7 = 210$

3. **When $2k+1$ is COMPOSITE**: Denominator doesn't change!
   - $k=4$: $2k+1 = 9 = 3^2$ (composite) → denom stays at $210$
   - $k=7$: $2k+1 = 15 = 3 \times 5$ (composite) → denom stays the same

4. **Factor of 2**: Comes from the $\frac{1}{2}$ coefficient

### Example: m = 13

| k | 2k+1 | Prime? | Denominator | Factorization |
|---|------|--------|-------------|---------------|
| 1 | 3    | YES    | 6           | 2×3           |
| 2 | 5    | YES    | 30          | 2×3×5         |
| 3 | 7    | YES    | 210         | 2×3×5×7       |
| 4 | 9    | no     | 210         | 2×3×5×7       |
| 5 | 11   | YES    | 2310        | 2×3×5×7×11    |
| 6 | 13   | YES    | 30030       | 2×3×5×7×11×13 |

**Final result**: 30030 = primorial of primes up to 13 ✓

## The Deep Mystery (UNSOLVED)

### What We Know

✓ The denominators systematically accumulate prime factors
✓ Only the FIRST power of each prime appears
✓ The 2k+1 sequence introduces primes at the right times
✓ The pattern is 100% consistent

### What We DON'T Know

❓ **WHY do higher prime powers from $k!$ cancel out?**

In the numerators, we have factorials $k!$ which contain higher powers of primes:
- $4! = 24 = 2^3 \times 3$
- $5! = 120 = 2^3 \times 3 \times 5$
- $6! = 720 = 2^4 \times 3^2 \times 5$

Yet when we sum these rational terms, somehow the $2^3, 2^4, 3^2$, etc. all cancel, leaving only:
- $2^1 \times 3^1 \times 5^1 \times 7^1 \times \cdots$ (the primorial!)

### The Cancellation Mechanism

Looking at the partial sums (reduced rationals):

```
k=1: -1/6           (numerator: -1)
k=2: 1/30           (numerator: 1)
k=3: -83/210        (numerator: -83 = prime!)
k=4: 197/210        (numerator: 197 = prime!)
k=5: -10433/2310    (numerator: -10433 = prime!)
k=6: 695971/30030   (numerator: 29×103×233)
```

The **numerators** appear to be absorbing the extra prime powers somehow!

## Possible Explanations (Speculation)

### Hypothesis 1: Systematic GCD Cancellation

When adding consecutive terms:

$$\frac{a}{d_1} + \frac{b}{d_2} = \frac{a \cdot d_2 + b \cdot d_1}{d_1 \cdot d_2}$$

Perhaps the GCDs between numerators and denominators systematically eliminate higher powers?

### Hypothesis 2: Legendre's Formula Connection

Legendre's formula for prime factorization of $k!$:

$$\nu_p(k!) = \sum_{i=1}^{\infty} \left\lfloor \frac{k}{p^i} \right\rfloor$$

Maybe the alternating sum structure causes these valuations to "reset" to 1?

### Hypothesis 3: Generating Function Magic

The sum might be related to a generating function for primorials where:
- The coefficients encode prime structure
- The alternating signs cause telescoping cancellation
- The denominator "captures" exactly the primorial

### Hypothesis 4: Modular Arithmetic Structure

Perhaps viewing this mod p for each prime reveals why p² cancels:
- The sum might have special properties modulo p²
- Connection to Wilson's theorem or Wolstenholme's theorem?

## Next Steps for Investigation

1. **Track prime powers through addition**: Follow ν_p(numerator) and ν_p(denominator) step by step

2. **Examine numerator patterns**: Why are many partial sum numerators prime?

3. **Modular analysis**: Compute the sum mod p² for various primes

4. **Literature search**: Look for papers on:
   - Factorial denominators in alternating sums
   - Generating functions for primorials
   - Egyptian fraction representations with primorial denominators

5. **Generalization attempts**: What happens if we change:
   - The coefficients?
   - The factorial structure?
   - The denominators (2k+1)?

## Status

**Understanding Level**: ★★☆☆☆

- ✓ We know WHAT happens (pattern confirmed)
- ✓ We know WHERE primes enter (from 2k+1)
- ✓ We know WHEN changes occur (prime vs composite 2k+1)
- ❌ We DON'T know WHY higher powers cancel
- ❌ We DON'T have a proof

This remains a genuine mathematical mystery worthy of deeper investigation!

---

*Investigation started: 2025-11-12*
*Key pattern discovered: Denominator = 2 × (product of odd primes up to 2k+1)*
*Deep mystery: Cancellation mechanism for higher prime powers*
