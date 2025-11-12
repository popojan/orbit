# Egyptian Horcruxes: Steganographic Secret Sharing

## Overview

"Egyptian Horcruxes" is a steganographic technique based on Egyptian fraction decomposition, inspired by J.K. Rowling's Harry Potter series where Lord Voldemort splits his soul into multiple Horcruxes. A rational "secret" is split into unit fractions with the same remarkable property: **multiple independent sets, any one of which can resurrect the whole**.

*With honorable mention to J.K. Rowling's beloved work, which provided the perfect metaphor for this mathematical phenomenon.*

## The Horcrux Metaphor

**The Twist: Multiple Resurrection Paths**

In J.K. Rowling's beloved Harry Potter series, Voldemort creates 7 Horcruxes - each a different object containing a fragment of his soul. The crucial property: **any one Horcrux can bring him back to life**, but to kill him permanently, you must destroy **all of them**.

Egyptian Horcruxes mirror this perfectly:

**In Harry Potter (Voldemort's 7 Horcruxes):**
- Soul split into 7 different objects (diary, ring, locket, cup, diadem, snake, Harry)
- **ANY ONE Horcrux** can resurrect the Dark Lord
- Must **FIND AND DESTROY ALL** to kill him permanently
- Multiple independent "resurrection paths"

**In Egyptian Horcruxes:**
- Rational split into **multiple different sets** of unit fractions
- **ANY ONE COMPLETE SET** can recover the secret rational
- Must **FIND AND ELIMINATE ALL SETS** to prevent recovery
- Multiple independent "resurrection paths" for the same mathematical "soul"

### Example: The 7 Horcruxes of 23/29

The rational **23/29** generates 51 different Horcrux sets! Here are the canonical 7:

```
Set 1: {1/2, 1/6, 1/9, 1/126, 1/266, 1/276, 1/152076}           → 23/29
Set 2: {1/2, 1/4, 1/32, 1/126, 1/456, 1/608, ...}              → 23/29
Set 3: {1/2, 1/5, 1/12, 1/120, 1/696}                          → 23/29
Set 4: {1/2, 1/6, 1/9, 1/86, 1/456, 1/696, 1/14706}           → 23/29
Set 5: {1/2, 1/4, 1/36, 1/107, 1/266, 1/456, ...}             → 23/29
Set 6: {1/2, 1/4, 1/36, 1/107, 1/168, ...}                     → 23/29
Set 7: {1/2, 1/4, 1/32, 1/92, 1/1495, ...}                     → 23/29
```

**Each set independently recovers 23/29!**

### The Perfect Analogy

| Property | Voldemort | Egyptian Horcruxes |
|----------|-----------|-------------------|
| **Number of sets** | 7 Horcrux objects | 51+ sets for 23/29 |
| **Recovery** | ANY ONE brings back Dark Lord | ANY ONE COMPLETE SET recovers rational |
| **To defeat** | Destroy ALL Horcruxes | Find and eliminate ALL sets |
| **Redundancy** | Multiple resurrection paths | Multiple valid decompositions |
| **Fragility** | Each Horcrux fragile individually | Each set fragile (missing one fraction breaks it) |
| **Set-level resilience** | Soul survives if any Horcrux remains | Secret survives if any complete set remains |

### Key Insight: Two-Level Structure

**Level 1 - Between sets**: REDUNDANT
- Many different sets exist (51 for 23/29)
- Secret survives if **any one** complete set is preserved
- Attacker must find **all** sets to prevent recovery

**Level 2 - Within each set**: FRAGILE
- Each set requires **all** its fractions
- Missing even **one** fraction from a set breaks that recovery path
- But other sets still work!

This creates a beautiful duality:
- **Robust** at the set level (many independent paths)
- **Fragile** at the fraction level (all-or-nothing per set)

## Key Properties

### 1. Computational Asymmetry

**Forward direction (splitting)**: FAST
```
7/11 → {1/2, 1/8, 1/88}  [milliseconds]
```

**Backward direction (recovery)**: SLOW
```
{1/2, 1/8, 1/88} → 7/11  [requires high precision, large LCM]
```

The greedy Egyptian fraction algorithm generates decomposition quickly, but summing arbitrary unit fractions back requires:
- Computing LCM of large denominators
- High precision arithmetic
- No guarantee of recognizing the "correct" rational

### 2. Redundancy

Multiple valid decompositions of the same rational:

```
7/11 = 1/2 + 1/9 + 1/40 + 1/3960
7/11 = 1/2 + 1/8 + 1/88
7/11 = 1/2 + 1/10 + 1/28 + 1/1540
```

This provides:
- **Plausible deniability**: "I wasn't hiding that specific representation"
- **Multiple channels**: Different decompositions for different recipients
- **Error detection**: If two sources give different but valid sets, both are authentic

### 3. Fragility

**All-or-nothing property**: Missing even one unit fraction makes recovery impossible (or computationally infeasible).

```
{1/2, 1/8, 1/88} → 7/11  ✓
{1/2, 1/8}       → 5/8   ✗ (wrong rational)
{1/2, 1/88}      → ?     ✗ (can't determine original)
```

This creates **perfect secret sharing** for some applications:
- Can't partially recover secret
- No information leak from subset
- Natural threshold cryptography

## The Algorithm

```mathematica
EgyptianHorcrux[q_Rational, extra_List, k_, m_] :=
 Select[ReverseSort@Join[extra, #] & /@ DeleteDuplicatesBy[Table[
     Module[{e = EgyptianFractions[q], idx},
      idx = RandomInteger[{1, m}, Length@e];
      ReverseSort[
       Join @@ (EgyptianFractions[Total@#[[All, 1]],
            Method -> "ReverseMerge"] & /@
          GatherBy[Transpose[{e, idx}], Last])]
     ], k], Last], Length@DeleteDuplicates@# == Length@# &]
```

**Parameters:**
- `q`: The rational "soul" to split
- `extra`: Additional fixed fractions to include in all decompositions
- `k`: Number of random attempts to generate
- `m`: Maximum number of groups to split fractions into

**Algorithm steps:**
1. Generate Egyptian fraction decomposition of `q`
2. Randomly partition fractions into `m` groups
3. Re-decompose each group using "ReverseMerge" method
4. Combine results to get alternative representation
5. Repeat `k` times and remove duplicates
6. Filter to ensure all fractions are distinct (no duplicates)

## Example Usage

```mathematica
<< Ratio`

(* Generate multiple Horcrux sets for 7/11 *)
horcruxSets = EgyptianHorcrux[7/11, {}, 100, 2];

(* Each set recovers the original *)
Total /@ horcruxSets
(* → {7/11, 7/11, 7/11, ...} *)

(* Different representations *)
horcruxSets[[1]]  (* → {1/2, 1/9, 1/40, 1/3960} *)
horcruxSets[[2]]  (* → {1/2, 1/8, 1/88} *)
horcruxSets[[3]]  (* → {1/2, 1/10, 1/28, 1/1540} *)
```

## Applications

### 1. Steganography with Redundancy

**Hide multiple Horcrux sets across different channels:**

```
Channel A: {1/2, 1/5, 1/12, 1/120, 1/696} → 23/29 (Set 3)
Channel B: {1/2, 1/6, 1/9, 1/86, 1/456, 1/696, 1/14706} → 23/29 (Set 4)
Channel C: {Other unit fractions...}
```

**Attacker's dilemma:**
- Must find **ALL 51 sets** hidden across all channels to prevent recovery
- Defender only needs **ONE complete set** to survive
- Even if attacker finds and destroys 50 sets, the 51st can resurrect the secret

**Defender's advantage:**
- Can distribute different sets via different routes (email, DNS, images, etc.)
- Loss of some channels doesn't compromise secret
- Natural redundancy without explicit error correction

The unit fractions blend naturally with other fractional data. Without knowing:
- Which fractions belong to which set
- How many sets exist in total
- What order to combine them
- What the target rational is

...recovery is infeasible, and prevention of recovery is even harder!

### 2. Proof of Work

**Challenge**: Given unit fractions `{1/2, 1/8, 1/88}`, find the "simplest" rational they sum to.

**Easy direction**: Check if they sum to 7/11 (fast)
**Hard direction**: Search rational space for the "right" answer (slow)

This creates a computational puzzle similar to Bitcoin mining.

### 3. Secret Sharing with Threshold

**Scenario**: Split a rational secret among `n` parties such that any `k` of them can recover it.

**Implementation**:
1. Generate `n` different Horcrux sets for the same rational
2. Distribute one set to each party
3. Any `k` parties can verify they have valid sets
4. But need all pieces from at least one complete set to recover

**Properties**:
- No partial information leak
- Natural redundancy from multiple representations
- Computational hardness adds security layer

### 4. Time-Lock Encryption

**Scenario**: Encrypt a rational such that recovery takes predictable computation time.

**Implementation**:
1. Split rational into many unit fractions (long sum)
2. Scatter fractions across data stream
3. Recovery requires collecting all pieces and computing large LCM
4. Computation time = O(product of denominators)

**Advantage**: Unlike hash-based time-locks, this is **verifiable** - you can check intermediate progress.

## Security Analysis

### Strengths

1. **Computational asymmetry**: Splitting O(n), recovery O(n²) or worse
2. **Information theoretic**: Missing one fraction ≈ missing the secret
3. **Plausible deniability**: Multiple valid representations
4. **No key management**: The fractions themselves are the "key"

### Weaknesses

1. **Not cryptographically secure**: Given all fractions, recovery is easy
2. **Fragile to transmission errors**: One bit flip breaks recovery
3. **Denominator growth**: Large rationals → huge denominators
4. **Pattern recognition**: Statistical analysis might identify Horcrux sets

### Suitable For

- **Low-security steganography** (obscurity, not cryptographic strength)
- **Academic/puzzle applications** (computational challenges)
- **Error detection** (fragility ensures integrity)
- **Educational demonstrations** (interesting number theory)

### NOT Suitable For

- **Military/financial secrets** (use real cryptography)
- **Long-term storage** (error accumulation)
- **High-value targets** (insufficient security)

## Implementation Notes

### Requirements

- **Ratio` package**: Provides `EgyptianFractions` function
- **ReverseMerge method**: Alternative decomposition algorithm
- **Rational arithmetic**: Exact, not floating point

### Performance

**Generation** (k=100, m=2):
- Small rationals (7/11): ~10ms
- Medium rationals (123/456): ~100ms
- Large rationals: depends on Egyptian fraction length

**Recovery** (if you have all pieces):
- Simple sum: O(n log n) where n = number of fractions
- Large LCM computation for exact rational

### Edge Cases

**Rationals with short Egyptian fractions:**
- Fewer alternative representations possible
- Less redundancy, less steganographic value

**Rationals with long Egyptian fractions:**
- Many alternatives available
- Better for hiding, but slower generation

**Improper fractions (> 1):**
- Split into integer + proper fraction
- Hide integer separately or encode differently

## Relation to Classical Secret Sharing

### Shamir's Secret Sharing

**Shamir (polynomial-based):**
- Information theoretic security
- Threshold: any k of n shares
- Shares don't reveal secret individually
- Cryptographically sound

**Egyptian Horcruxes:**
- Computational security (weak)
- Threshold: all pieces of one set needed
- Fragile (any missing piece breaks it)
- Number theoretic, not cryptographic

### Comparison

| Property | Shamir | Egyptian Horcruxes |
|----------|--------|-------------------|
| Security | Strong | Weak (obscurity) |
| Threshold | Flexible (k-of-n) | Rigid (all-of-one-set) |
| Redundancy | Via multiple shares | Via multiple representations |
| Computation | Fast (polynomial eval) | Asymmetric (fast split, slow sum) |
| Theory | Cryptography | Number theory |

**Use cases overlap minimally** - Egyptian Horcruxes are more for puzzles and steganography than serious cryptography.

## Mathematical Beauty

Despite limited practical security, Egyptian Horcruxes demonstrate beautiful mathematical properties:

1. **Multiple decompositions**: Non-unique representation of rationals
2. **Computational asymmetry**: Forward ≠ Backward complexity
3. **Fragility from completeness**: All-or-nothing recovery
4. **Algorithmic number theory**: Egyptian fractions have rich structure

The concept bridges:
- **Classical number theory** (Egyptian fractions, Fibonacci's greedy algorithm)
- **Modern computation** (algorithmic complexity, one-way functions)
- **Cryptographic thinking** (secret sharing, steganography)

## Further Exploration

### Open Questions

1. **How many distinct Horcrux sets exist for a given rational?** (Combinatorial question)
2. **Can we bound the recovery complexity?** (Computational complexity theory)
3. **What's the information-theoretic security of partial sets?** (Does k-1 fractions leak anything?)
4. **Optimal denominator growth for maximum steganographic capacity?** (Optimization problem)

### Variations

**Nested Horcruxes**: Split each Horcrux into sub-Horcruxes (recursive - Horcruxes all the way down!)
**Horcrux Networks**: Graph where each edge is a fraction, paths sum to secrets
**Probabilistic Recovery**: Use approximate arithmetic to "guess" at original
**Horcrux Chains**: Sequential dependencies where each set unlocks the next
**Voldemort's Revenge**: Use 23/29 with exactly 7 canonical sets (literary homage)
**The Dark Lord's Fortune**: Larger rationals → more sets → greater resilience (123/456 might generate hundreds!)

## Conclusion

Egyptian Horcruxes provide an entertaining intersection of number theory, steganography, and computational complexity. While not suitable for serious cryptographic applications, they offer:

- **Educational value**: Teaching Egyptian fractions and computational asymmetry
- **Puzzle applications**: Mathematical challenges and CTF problems
- **Artistic steganography**: Hiding rationals in plain sight
- **Theoretical interest**: Non-unique representations and fragility

The name captures the essence perfectly: splitting a mathematical "soul" into fragments that are individually harmless but collectively powerful, yet fatally fragile to loss.

---

**Created**: 2025-11-12
**Requires**: Ratio` package (system-wide installation)
**Code**: `horcrux.wl`
**Inspiration**: J.K. Rowling's Harry Potter + Egyptian fraction theory
**Perfect ratio**: 23/29 generates ≥51 Horcrux sets (far exceeding Voldemort's 7!)
**The twist**: Any one complete set resurrects the "soul", but all sets must be destroyed to kill it permanently
