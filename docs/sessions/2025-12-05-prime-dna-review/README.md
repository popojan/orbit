# Prime DNA Review: Gap Distribution and Chebyshev-like Bias

**Date:** 2025-12-05
**Status:** Analysis complete

## Summary

Review of the "Prime DNA" prime generation tool (`../prime`) revealed that while the claimed 15-25x speedup is real, it comes from **standard trial division**, not from any special property of the DNA sequence.

However, analysis uncovered an interesting structural property: **prime gaps mod 4 exhibit significant bias**.

## Key Findings

### 1. DNA Speedup is Trial Division

| Mode | Speedup | Source |
|------|---------|--------|
| `-d 0` (DNA only) | ~2x | Odd-only filtering (standard) |
| `-d 1000` | ~15-25x | Trial division |

**DNA-specific contribution: ~1.0x (none)**

Statistical test (5000 samples, 150-bit): DNA 1.9% vs Random 2.1% primes, p > 0.05.

### 2. DNA Bit Distribution is NOT Random

DNA bit = `(gap/2) mod 2`:
- gap ≡ 2 (mod 4) → DNA = 1
- gap ≡ 0 (mod 4) → DNA = 0

**Measured distribution (first 10,000 gaps):**

| Bit | Count | Percent |
|-----|-------|---------|
| 1 | 5862 | **58.6%** |
| 0 | 4137 | **41.4%** |

**Deviation from random: 17%**

### 3. Connection to Known Number Theory

This bias is related to (but distinct from) classical Chebyshev bias:

| Phenomenon | Description |
|------------|-------------|
| Chebyshev bias | Primes ≡ 3 (mod 4) more common than ≡ 1 (mod 4) |
| DNA bit bias | Gaps ≡ 2 (mod 4) more common than ≡ 0 (mod 4) |

Related literature:
- [Chebyshev Bias - Wolfram MathWorld](https://mathworld.wolfram.com/ChebyshevBias.html)
- [Rubinstein-Sarnak (1994)](https://projecteuclid.org/journals/experimental-mathematics/volume-3/issue-3/Chebyshevs-bias/em/1048515870.pdf) - Quantification of Chebyshev bias
- [Lemke Oliver-Soundararajan (PNAS 2016)](https://www.pnas.org/doi/10.1073/pnas.1605366113) - Unexpected biases in consecutive primes

### 4. Composite Structure Test

**Hypothesis:** DNA composites might have special structure (large prime × small factors).

**Result:** FALSIFIED

| Metric | DNA | Random |
|--------|-----|--------|
| Cofactor (n/largest) | 2.57×10⁹ | 2.11×10⁹ |
| Distinct factors | 3.36 | 3.53 |
| Small factors (<1000) | 1.70 | 1.88 |
| Semiprimes (p×q) | **19.5%** | **19.5%** |

DNA composites are indistinguishable from random composites.

## Conclusion

**Random bits + trial division = DNA + trial division**

The DNA sequence has structure (58.6% ones from prime gap distribution), but this structure does NOT translate to:
- Higher prime density
- Different composite structure
- Better trial division efficiency

## Open Questions

1. **Why doesn't the 58.6%/41.4% bias help?**
   - The bias affects bit distribution but not divisibility patterns
   - Prime gaps encode local structure, not global primality

2. **Is gaps mod 4 distribution studied in literature?**
   - Chebyshev bias is about primes mod 4, not gaps
   - Lemke Oliver-Soundararajan is about consecutive prime patterns

## Code

Verification script for DNA bit distribution:

```mathematica
primes = Prime[Range[2, 10001]];
gaps = Differences[primes];
dnaBits = Mod[gaps/2, 2];
Print["1s: ", Count[dnaBits, 1], " (", N[100*Count[dnaBits, 1]/Length[dnaBits]], "%)"];
Print["0s: ", Count[dnaBits, 0], " (", N[100*Count[dnaBits, 0]/Length[dnaBits]], "%)"];
```

## Related

- Prime DNA Tool: `../prime/REVIEW.md` (separate repo)
- [Self-Adversarial Discipline](../../CLAUDE.md#self-adversarial-discipline) - Protocol used for this analysis
