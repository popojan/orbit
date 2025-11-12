# Primorial via Rational Sum Formula

## Overview

This module implements a surprising formula that computes primorials (products of consecutive primes) through the denominator of a rational sum.

## The Formula

For $m \geq 3$, the primorial of all primes up to $m$ is given by:

$$\text{Primorial}(m) = \text{Denominator}\left[\frac{1}{2} \sum_{k=1}^{\lfloor(m-1)/2\rfloor} \frac{(-1)^k \cdot k!}{2k+1}\right]$$

**Note:** $m = 2$ is handled as a special case (returns 2 directly).

## How It Works

### Explicit Formula

The core formula `PrimorialRaw[m]` computes a rational number:

```mathematica
PrimorialRaw[m] := 1/2 * Sum[(-1)^k * (k!)/(2*k + 1), {k, Floor[(m - 1)/2]}]
```

The denominator of this rational, when reduced to lowest terms, remarkably equals the primorial of all primes ≤ m.

### Iterative Sieve Formula

There's also a recurrent formulation that builds up the primorial iteratively:

```mathematica
(* Initial state *)
{n, a, b} = {0, 0, 1}

(* Recurrence *)
RecurseState[{n, a, b}] = {n + 1, b, b + (a - b)*(n + 1/(3 + 2*n))}

(* Extract primorial from state after h = Floor[(m-1)/2] iterations *)
Primorial(m) = 2 * Denominator[-1 + b]
```

## Usage

### Basic Usage

```mathematica
<< Orbit`

(* Compute primorial of primes up to 13 *)
Primorial0[13]
(* Returns: 30030 = 2*3*5*7*11*13 *)

(* Get the raw rational value *)
PrimorialRaw[13]
(* Returns: rational with denominator 30030 *)

(* Using sieve method *)
state = SieveState[13]
primorial = PrimorialFromState[state]
(* Also returns: 30030 *)
```

### Verification

```mathematica
(* Verify against standard primorial *)
m = 23;
standard = Times @@ Prime @ Range @ PrimePi[m];
computed = Primorial0[m];
computed == standard
(* Returns: True *)

(* Batch verification *)
BatchVerifyPrimorial[100]
(* Verifies for all m from 2 to 100 *)
```

## API Reference

### Core Functions

- `PrimorialRaw[m]` - Returns the rational sum whose denominator is the primorial
- `Primorial0[m]` - Extracts primorial from the denominator
- `RecurseState[{n,a,b}]` - Advances the sieve state by one iteration
- `SieveState[m]` - Computes sieve state for position m
- `PrimorialFromState[state]` - Extracts primorial from a sieve state

### Verification Functions

- `StandardPrimorial[m]` - Standard computation: product of primes up to $m$
- `VerifyPrimorial[m, method]` - Verifies a specific method
- `BatchVerifyPrimorial[mmax, method]` - Batch verification
- `CompareAllMethods[m]` - Compares all methods side-by-side

## Performance

The formula is efficient for moderate values of m:

- m = 100: instantaneous (37-digit result)
- m = 500: ~0.001s (207-digit result)
- m = 1000: ~0.002s (416-digit result)
- m = 5000: ~0.06s (2134-digit result)

## Mathematical Background

The connection between this alternating factorial sum and primorials is non-obvious and beautiful. The formula encodes the primorial in the common denominator that arises when the sum is reduced to a single rational.

### Why This Works (Open Problem!)

**The cancellation phenomenon**: When computing the sum and reducing to lowest terms:

$$\frac{1}{2} \sum_{k=1}^{\lfloor(m-1)/2\rfloor} \frac{(-1)^k \cdot k!}{2k+1}$$

The individual denominators $2k+1$ include prime powers ($9=3^2$, $25=5^2$, $27=3^3$, ...) and composites ($15=3 \times 5$, $21=3 \times 7$, ...). Naively, the LCM would retain these higher powers.

**Yet** the final denominator contains exactly the primorial: only the **first power** of each prime up to $m$.

**Open question**: Why do the numerators (containing factorials $k!$) have precisely the right prime factors to cancel all $p^j$ (for $j > 1$) through GCD reduction? The mechanism of this systematic cancellation requires rigorous proof!

### Theoretical Connections

1. **Generating Functions**: The formula may be related to generating functions for prime-counting functions
2. **Factorial Denominators**: Structure similar to harmonic number denominators (which involve primorials)
3. **Alternating Sums**: The (-1)^k alternation creates systematic cancellations
4. **Egyptian Fractions**: Connection to unit fraction representations

### Conjectures

- The cancellation pattern may be related to Legendre's formula for factorial prime factorization
- Could connect to p-adic valuations and the structure of Z-modules
- Possible generating function interpretation for primorial sequence

## Examples

```mathematica
(* Small examples *)
Table[{m, PrimePi[m], Primorial0[m]}, {m, 2, 20}]

(* Compare methods *)
m = 17;
{
  "Standard" -> Times @@ Prime @ Range @ PrimePi[m],
  "Formula" -> Primorial0[m],
  "Sieve" -> PrimorialFromState[SieveState[m]]
}
(* All three return: 510510 *)
```

## Suggested Readings & Connections

### Related Theory

1. **Primorials and Arithmetic Functions**
   - "The distribution of primorials" - Research on primorial asymptotics
   - Primorial primes and their connection to Euclid numbers

2. **Factorial Denominators**
   - Wolstenholme's theorem on binomial coefficient denominators
   - Harmonic numbers and their prime factorization
   - Legendre's formula: ν_p(n!) = Σ floor(n/p^k)

3. **Alternating Sums**
   - Euler's work on alternating factorial series
   - Combinatorial identities involving factorials
   - Gregory-Leibniz series and rational approximations

4. **Computational Number Theory**
   - OEIS sequences related to primorials (A002110, A034386)
   - Experimental mathematics approaches to prime functions

### Open Research Questions

1. **Cancellation Mechanism**: Why do higher prime powers cancel exactly?
2. **Generalization**: Can this be extended to other prime-related products?
3. **Complexity**: Is there a lower bound on computational complexity?
4. **Connections**: Links to modular forms, L-functions, or zeta functions?

### Keywords for Further Research

- Primorial, factorial prime factorization, alternating sums, generating functions for primes, p-adic valuation, Egyptian fractions, experimental number theory

## References

- For more mathematical explorations, see the main CLAUDE.md guide
- Original discovery: Computational/experimental mathematics
- Status: Formula verified computationally; theoretical explanation incomplete
