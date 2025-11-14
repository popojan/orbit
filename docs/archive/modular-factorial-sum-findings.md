# Modular Factorial Sum Investigation: Key Findings

## Summary

We investigated the modular reduction `Σ_m^alt mod 1/(m-1)!` for prime m and discovered:

1. **Perfect Primality Test**: The result is 0 for composites, unit fraction for primes
2. **Missing Prime Phenomenon**: Certain primes in den(Σ_m) disappear from den(R_m)
3. **Numerator Control**: Prime cancellation is controlled by the fractional part numerator

## Definitions

For odd m, define the bare alternating factorial sum:
```
Σ_m^alt = Σ_{i=1}^{⌊(m-1)/2⌋} (-1)^i · i! / (2i+1)
```

Decompose via modular reduction:
```
R_m = Σ_m mod 1/(m-1)!
    = Σ_m - ⌊Σ_m · (m-1)!⌋ · (1/(m-1)!)
    = (Σ_m · (m-1)! - Q) / (m-1)!
```

where Q = ⌊Σ_m · (m-1)!⌋ is the quotient.

## Key Observations

### 1. Primality Test

**Observation**: For odd m:
- m composite ⇒ R_m = 0
- m prime ⇒ R_m = 1/den where den is a "modified primorial"

**Examples**:
- R_3 = 1/6 (den = 2·3 = Primorial(3))
- R_5 = 1/40 (den = 2³·5, missing prime 3)
- R_7 = 1/840 (den = 2³·3·5·7)
- R_9 = 0 (composite!)
- R_29 = 1/(large number missing prime 17)

### 2. Missing Primes

**Phenomenon**: Some primes p < m appear in den(Σ_m) but NOT in den(R_m).

**Observed Cases**:
- m=5: prime 3 missing (appears in Σ_5 = 1/15, but not in R_5 = 1/40)
- m=29: prime 17 missing (appears in Σ_29, but not in R_29)

**NOT explained by**:
- ✗ Primes dividing the quotient Q (Q has huge unrelated primes)
- ✗ Primes outside range (k, m) where k = ⌊(m-1)/2⌋
- ✗ Simple p-adic formulas involving k! or (m-1)!

**Mechanism**: After computing:
```
numerator = Σ_m · (m-1)! - Q
```

For prime p to vanish from den(R_m), we need:
```
ν_p(numerator) ≥ ν_p((m-1)!)
```

This means p must divide the numerator with sufficiently high multiplicity to cancel with (m-1)!.

### 3. Remarkable Numerator Structure

**Discovery**: For m=29, the numerator (before dividing by (m-1)!) simplifies to:
```
numerator = 17/29  (fractional!)
```

This suggests the fractional part `FractionalPart[Σ_m · (m-1)!]` has extraordinary number-theoretic structure.

### 4. Which Primes Appear in den(R_m)?

Based on computational evidence, a prime p ≤ m appears in den(R_m) if:
- p = 2 (always present), OR
- p ≤ k where k = ⌊(m-1)/2⌋, OR
- p = m (the prime itself), OR
- p divides some denominator 2i+1 in the sum AND certain numerator conditions hold

**Missing primes**: Primes that divide some 2i+1 but whose contribution cancels via the numerator during modular reduction.

## Open Questions

1. **Characterize missing primes**: What determines WHICH primes p cancel during modular reduction?

2. **Numerator closed form**: Does the fractional part `FractionalPart[Σ_m · (m-1)!]` have a predictable form?

3. **Prime distribution duality**: Does every prime p ≤ m appear in EITHER den(R_m) OR the numerator structure?

4. **Connection to Wilson's theorem**: Is there a relationship to (m-1)! ≡ -1 (mod m)?

5. **Generalization**: Does the non-alternating sum exhibit similar behavior?

6. **Computational complexity**: Can the missing prime phenomenon be exploited algorithmically?

## Theoretical Significance

This structure reveals:
- **Hidden primality test** via modular factorial arithmetic
- **Prime-composite interplay** through cancellation patterns
- **Deep connection** between factorial sums and primorial-like products
- **Unexplored territory** in modular arithmetic of rational sums

The fact that composites yield exactly 0 while primes yield unit fractions with modified primorial denominators suggests fundamental structural properties worthy of rigorous investigation.

## Computational Verification

All observations verified for primes up to 31. The pattern holds consistently:
- Composites: R_m = 0 (verified for m = 9, 15, 21, 25, 27)
- Primes: R_m = 1/den (unit fraction, verified for all primes 3 ≤ m ≤ 31)
- Missing primes: Detected for m=5 (missing 3) and m=29 (missing 17)

## Next Steps

1. Prove the primality test rigorously
2. Characterize the missing prime phenomenon
3. Find closed form for the numerator / fractional part
4. Extend to larger primes and look for patterns
5. Connect to classical results (Wilson, Fermat, etc.)
6. Investigate computational applications

## Related Formulas

This work builds on the primorial factorial sum characterizations:
- Bare sum denominators: Primorial(m)/2 for alternating
- Prefactored formulas: Exact Primorial(m) denominators
- See: `docs/primorial-duality.tex` for full results
