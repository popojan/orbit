# Interval Width Determinants

**Session:** 2025-12-20

## Observation

Consider the matrix M where:
```mathematica
M[i,j] = FactorInteger[err@PhiInterval@i / err@PiInterval@j] // First // Last
```
where `err[x_] := x // MinMax // Reverse // Subtract @@ # &` (interval width)

This gives the **exponent of 2** in the ratio (since 2 is the smallest prime factor).

**Counterintuitive result:**
- Mixed (Phi/Pi): Det = 0, Rank = 3 (singular!)
- Same type (Phi/Phi or Pi/Pi): Det ≠ 0

Naively, mixing should create more independence...

## Explanation

### The ideal structure (rank-2)

The widths have specific 2-exponent patterns:
- **PiInterval[j]**: width = 1/(60 × 16^j), so exp₂ = -(4j + 2)
- **PhiInterval[i]**: width has exp₂ = a[i] where a = {-3,-2,-4,-2,-3,-2,-5,...}

The matrix entry should be:
```
M[i,j] = a[i] - (-(4j+2)) = a[i] + 4j + 2
```

This is **rank-2**: linear in j plus constant in i.

### The exception (rank → 3)

At position **(15, 1)**:
- PhiInterval[15] has exp₂ = -6
- PiInterval[1] has exp₂ = -6
- The 2's **cancel exactly**!

When 2's cancel, `FactorInteger // First` returns {3, exp} instead of {2, exp}.
The actual entry becomes **-1** (exponent of 3) instead of 0.

**Single entry perturbation raises rank from 2 to 3.**

### Matrix decomposition

```
Actual = Ideal + Perturbation
```
where:
- Ideal[i,j] = a[i] + 4j + 2 (rank 2)
- Perturbation = sparse matrix with single -1 at (15,1) (rank 1)

Result: rank 2 + rank 1 = rank 3

## The matrices (8×8 submatrix)

### Mixed (Phi/Pi) - SINGULAR, rank 3
```
{{3, 7, 11, 15, 19, 23, 27, 31},
 {4, 8, 12, 16, 20, 24, 28, 32},
 {2, 6, 10, 14, 18, 22, 26, 30},
 {4, 8, 12, 16, 20, 24, 28, 32},
 {3, 7, 11, 15, 19, 23, 27, 31},
 {4, 8, 12, 16, 20, 24, 28, 32},
 {1, 5,  9, 13, 17, 21, 25, 29},
 {4, 8, 12, 16, 20, 24, 28, 32}}
```
Each row is arithmetic progression with step 4.
Starting values cycle: {3,4,2,4,3,4,1,4,...}

### Pi/Pi - Toeplitz structure
```
{{1, 4, 8, 12, 16, 20, 24, 28},
 {-4, 1, 4, 8, 12, 16, 20, 24},
 {-8, -4, 1, 4, 8, 12, 16, 20},
 ...}
```
Entry (i,j) = 4(j-i), antisymmetric Toeplitz.
Det = 67201 (for 15×15)

### Phi/Phi - lower triangular pattern
```
{{1, 1, 1, 1, ...},
 {-1, 1, 1, 1, ...},
 {-1, -1, 1, 1, ...},
 ...}
```
Det = 52224 (for 15×15)

## Key insight

**Rank deficiency from matching structure.**

The mixed matrix has rank 3 (not full rank 31) because:
1. Pi widths have geometric progression 16^j → linear j-dependence
2. Phi widths have periodic 2-exponent pattern → only 4 distinct row types
3. Occasional 2-cancellation (e.g., position 15,1) adds one rank

Same-type matrices avoid this by having different structure (Toeplitz for Pi/Pi, triangular for Phi/Phi).

## Why position (15,1)?

PhiInterval[15] involves specific Fibonacci numbers whose 2-valuation equals 6:
```mathematica
FactorInteger[err@PhiInterval@15]
(* {{2,-6}, {3,-2}, {7,-1}, {23,-1}, {47,-1}, {769,-1}, ...} *)
```

This matches PiInterval[1]'s 2-valuation of 6, causing complete cancellation.

## The 2-valuation pattern

For PhiInterval widths, the 2-valuation follows:
```
a[2k] = -2          (all even positions)
a[2k-1] = -(3 + ν₂(k))   (odd positions, where ν₂ = 2-adic valuation)
```

**Verified** for k = 1 to 32.

This means:
- a[1,5,9,13,...] = -3 (ν₂(odd) = 0)
- a[3,11,19,27,...] = -4 (ν₂(2mod4) = 1)
- a[7,23,39,...] = -5 (ν₂(4mod8) = 2)
- a[15,47,...] = -6 (ν₂(8mod16) = 3)
- etc.

## Cancellation analysis

When 2-exponents match, "First // Last" picks exp₃ instead of exp₂.

| Matrix | Cancellations (31×31) | Spillover effect |
|--------|----------------------|------------------|
| Phi/Phi | 311 | High variation in exp₃ → full rank |
| Pi/Pi | 31 (diagonal only) | Diagonal = 1 → full rank |
| Phi/Pi | 16 | Too sparse to break rank-2 |

## Key theorem

**Pure exp₂ structure**: All three matrices are rank-2 and singular.

**With spillover to exp₃**: Same-type matrices gain enough rank to be non-singular, while mixed matrices gain only 1 extra rank.

This explains the counterintuitive result:
- Same-type: Many cancellations → varied spillover → full rank → Det ≠ 0
- Mixed: Few cancellations → sparse spillover → near rank-2 → Det = 0

## Higher p-adic analysis

### Pure p-valuation matrices

For any fixed prime p, the matrix M[i,j] = νₚ(ratio) has:
- **Phi/Phi**: Rank 2 for all p
- **Pi/Pi**: Rank 2 for p=2, rank 0 for p>2 (no variation)
- **Phi/Pi**: Rank 1-2 for all p

### Combined valuations

| Function | Phi/Phi rank | Phi/Pi rank |
|----------|-------------|-------------|
| Sum of \|valuations\| | Full | 2 |
| Weighted (p×e) | Full | 2 |
| Omega (# primes) | Full | 2 |
| ν₂ + ν₃ | 2 | 2 |

### The "First Prime" insight

The original `First // Last` picks the **smallest prime** in the factorization.

| Matrix | Smallest prime varies? | Result |
|--------|----------------------|--------|
| **Phi/Phi** | Yes: 1,2,3,5,13,17,53,79 | Full rank |
| **Phi/Pi** | No: always 2 | Rank 2 |

**Why?** Pi widths = 1/(60 × 16^j) always have factor 2, so the ratio always has 2 as smallest prime. This locks Phi/Pi into pure ν₂ structure.

For Phi/Phi, when 2's cancel, the smallest prime shifts to 3, 5, or Fibonacci-related primes (13, 17, 53, 79, ...), creating the variation needed for full rank.

## Predictability of factorizations

### Low rank implies structure

The rank-2 structure for each p-valuation means:
```
νₚ(width[i]/width[j]) = νₚ(width[i]) - νₚ(width[j])
```

This is trivially true for valuations, but implies the factorizations are **perfectly predictable**.

### Prime divisibility follows arithmetic progressions

| Prime | Step | Start | Origin |
|-------|------|-------|--------|
| 3 | 2 | 1 | All odd positions |
| 5, 11, 31 | 5 | 4 | Chebyshev period |
| 7, 23 | 4 | 3 | Chebyshev period |
| 13, 29 | 7 | 6 | Chebyshev period |
| 17, 19 | 3 | 2 | Chebyshev period |

### Why Phi widths are structured

PhiInterval uses SqrtInterval[5], which involves:
1. **Pell solution**: x=9, y=4 for x² - 5y² = 1
2. **Chebyshev polynomials**: T_n(x-1) = T_n(8)
3. **Chebyshev divisibility**: p | T_n(x) follows periodic patterns in n

The primes appearing at arithmetic progressions (17, 19, 23, 107, 1103, ...) are determined by **Chebyshev polynomial theory**, not Fibonacci coincidence!

### Why Pi widths are simpler

PiInterval uses BBP formula with widths 1/(60 × 16^n).
Only primes {2, 3, 5} appear, with 2-exponent linear in n.
No Chebyshev structure → simpler factorizations.

## Summary

The counterintuitive determinant behavior (mixed = singular, same = non-singular) arises from:

1. **Pure p-valuations are rank-2** for any prime
2. **Mixed matrices** stay locked in ν₂ (Pi always contributes factor 2)
3. **Same-type matrices** pick different primes at different positions via "First // Last", creating full rank

The underlying factorization structure is **completely predictable** from Chebyshev polynomial theory.

## Primality testing connection

### Chebyshev "Fermat" theorem

For prime p: **T_p(a) ≡ a (mod p)**

This is the Chebyshev analog of Fermat's little theorem.

### Chebyshev pseudoprimes

Composites passing T_n(8) ≡ 8 (mod n) for n < 1000:
{9, 21, 35, 63, 85, 119, 253, 323, 385, 595, 665, 805, 889, 935}

Fermat pseudoprimes (base 2) for n < 1000:
{341, 561, 645}

**No overlap!** The pseudoprime sets are disjoint.

### Practical value?

| Test | Pseudoprimes | Speed |
|------|--------------|-------|
| Fermat | 341, 561, ... | Fast (O(log n)) |
| Chebyshev | 9, 21, 35, ... | ~34x slower (2×2 matrix) |
| Combined | 1105, 2465, ... | Catches more, but not all |

The Chebyshev test doesn't beat Miller-Rabin, but the **disjoint pseudoprime structure** is theoretically interesting.

### Connection to interval widths

Primes appearing in PhiInterval widths follow Chebyshev periodicity:
- p | width[k] iff k ≡ start (mod step)
- The step is related to the Chebyshev period of p at argument 8

This makes the width factorizations **perfectly predictable** without needing to compute them.

## References

The Lucas-Chebyshev connection is well-documented in the literature:

1. [Matt Baker's Math Blog: Lucas sequences and Chebyshev polynomials](https://mattbaker.blog/2013/12/07/lucas-sequences-and-chebyshev-polynomials/)

2. [Pomerance: Primality Testing - Variations on a Theme of Lucas](https://math.dartmouth.edu/~carlp/lucasprime3.pdf) - Shows Lucas's ideas underlie Fermat, Lucas, and elliptic curve tests

3. [arXiv:2010.02677 - Chebyshev polynomials and higher order Lucas Lehmer algorithm](https://arxiv.org/abs/2010.02677) - Extends Lucas-Lehmer via Chebyshev T_n(x)

4. [The Lucas Sequences: Theory and Applications](https://notes.math.ca/en/article/the-lucas-sequences-theory-and-applications/) - Chapter 4 covers connections to Chebyshev polynomials

Key relationships:
- V_n(2x, 1) = 2 T_n(x) (Lucas V = Chebyshev 1st kind)
- U_n(2x, 1) = U_{n-1}(x) (Lucas U = Chebyshev 2nd kind)
- Lucas-Lehmer iteration S_n = S_{n-1}² - 2 is exactly 2 × T_{2^n}(2)

## SqrtInterval rational extension

Extended `SqrtInterval` to handle rational arguments using:

**√(p/q) = √(pq) / q**

This reduces rational square roots to integer square roots.

Examples:
```mathematica
SqrtInterval[5/4, 3]   (* √(5/4) = √20/4 *)
(* Interval[{180/161, 161/144}] *)

SqrtInterval[2/3, 3]   (* √(2/3) = √6/3 *)
(* Interval[{40/49, 49/60}] *)

SqrtInterval[8/18, 3]  (* Perfect square: 8×18 = 144 *)
(* Interval[{2/3, 2/3}] — exact! *)
```

**Unit fraction property preserved**: Width(√(p/q)) = Width(√(pq)) / q

If √(pq) has unit fraction width, so does √(p/q).

## Scripts

Saved to `chebyshev-primality.wl`:
- `ChebyshevFermatTest[n, a]` - T_p(a) ≡ a (mod p)
- `ChebyshevPseudoprimes[a, max]` - find Chebyshev pseudoprimes
- `LucasLehmerViaChebyshev[n]` - verify equivalence
- `FastChebyshevTMod[n, a, m]` - O(log n) modular Chebyshev
- `BailliePSW[n]` - combined Fermat + Lucas test
- `VerifyLucasChebyshev[]` - run all verifications
