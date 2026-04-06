# Winding Matrix Roundtrip: Integers → Primes + Zeros

**Date:** 2026-04-06
**Status:** 🔬 NUMERICALLY VERIFIED (100×100, 100% primes correct)

## Result

The integer winding matrix $W_{np} = \lfloor\gamma_n\ln p/(2\pi)\rfloor$
**uniquely determines** both the zeta zeros $\gamma_n$ and the primes $p_j$,
using only elementary arithmetic. No `PrimeQ`, no `ZetaZero`, no $\Gamma$ function.

## Algorithm: ALS + Lattice Snap

### Input
Integer matrix $W \in \mathbb{Z}^{n \times k}$ (nothing else).

### Core iteration

$$\Theta = W + \tfrac{1}{2} \qquad \text{(center floor bias)}$$

Initialize $a$ from dominant left singular vector of $\Theta$ (scaled). Then repeat:

$$\ell \leftarrow \Theta^\top a \,/\, \|a\|^2 \qquad \text{(one mat-vec)}$$
$$\ell_j \leftarrow \ln\!\bigl(\text{best odd integer near } e^{\ell_j}\bigr) \qquad \text{(roundtrip sieve + OddQ)}$$
$$a \leftarrow \Theta\,\ell \,/\, \|\ell\|^2 \qquad \text{(one mat-vec)}$$

Scale fix: $\ell_1 \leftarrow \ln 2$ (smallest column = smallest prime).

### Output

$$\gamma_n = 2\pi\, a_n, \qquad p_j = \mathrm{Round}(e^{\ell_j})$$
$$R_{np} = a_n\ell_j - W_{np} \qquad \text{(residual, fractional parts)}$$
$$M_{np} = \cos(2\pi R_{np}) \qquad \text{(interaction matrix)}$$

### Arithmetic used

`Floor`, `Round`, `Log`, `Exp`, `Mod(·,2)`, matrix-vector multiplication.

**Not used:** `PrimeQ`, `ZetaZero`, `RiemannSiegelTheta`, `Gamma`, any sieve.

### The "roundtrip sieve"

For each column $j$, the snap step tries several odd integers $k$ near
$e^{\ell_j}$ and picks the one minimizing column mismatches:

$$\text{score}(k) = \#\{n : \lfloor a_n \ln k/(2\pi)\rfloor \neq W_{nj}\}$$

with ALS proximity as tiebreaker. Primes win because composites give
wrong $\ln$ values. The only "primality test" is `OddQ` (all primes
except 2 are odd).

## Numerical Results

| Size | Primes correct | W roundtrip | $\gamma$ max error | $M$ max error |
|------|---------------|-------------|-------------------|--------------|
| 5×5 | 5/5 ✓ | 100% | 0.565 | 0.916 |
| 10×10 | 10/10 ✓ | 100% | 0.250 | — |
| 15×15 | 15/15 ✓ | 99.6% | 0.228 | 0.747 |
| 20×20 | 20/20 ✓ | 100% | 0.128 | 0.489 |
| 30×30 | 30/30 ✓ | 99.3% | 0.169 | — |
| 50×50 | 50/50 ✓ | 99.4% | 0.093 | — |
| 100×100 | 100/100 ✓ | 99.1% | 0.058 | 0.350 |

Key observation: **larger matrices are easier** — $\gamma$ error decreases
with size because more rows average out floor noise in the ALS projection.

## Why It Works

### The decomposition

$$\gamma_n\ln p = 2\pi\,W_{np} + 2\pi\,R_{np}$$

$W$ (integer) carries the "hard" information, $R$ (fractional) carries the "easy"
information. The linearization analysis (previous session) presented $W$ as
"the barrier" — knowing $W$ is equivalent to knowing $\gamma_n\ln p$ up to a
residual in $[0, 2\pi)$.

### The roundtrip

The ALS factorizes $W + \frac{1}{2} \approx a \otimes \ell$ (rank 1).
The lattice snap constrains $e^{\ell_j} \in \mathbb{Z}$ (and odd for $j > 1$).
These two constraints together — rank-1 structure + integer lattice —
**overdetermine** the factorization. There are far more constraints
(one per matrix entry) than unknowns ($n + k$ parameters).

Once $a$ and $\ell$ are known, $R = a\ell^\top - W$ is fully determined.
The "barrier" was not an obstacle — it was **the solution**.

### Why composites lose

For the correct prime $p_j$: $\lfloor a_n \ln p_j/(2\pi)\rfloor = W_{nj}$
for all $n$ (by construction).

For a nearby composite $c$: $|\ln c - \ln p_j| \approx 1/p_j$, so
$a_n(\ln c - \ln p_j)/(2\pi) \approx a_n/(2\pi p_j)$. For the $n$-th zero
height $\gamma_n = 2\pi a_n$, this shift is $\gamma_n/(2\pi p_j) \cdot (2\pi) = \gamma_n/p_j$.
When $\gamma_n/p_j > 1$ (i.e., $\gamma_n > p_j$), the floor value changes —
creating mismatches that the roundtrip sieve detects.

Since both $\gamma_n$ and $p_j$ grow, the condition $\gamma_n > p_j$ is
satisfied for most rows, making the sieve effective.

### Twin prime failure mode (fixed by OddQ)

Without `OddQ`, the ALS sometimes snaps to $p \pm 1$ (always even).
All observed errors were $p \to p\pm 1$ where $p\pm 1$ is even.
Filtering to odd candidates eliminates this — `Mod(n, 2)` is sufficient,
no full sieve needed.

## What This Does NOT Do

1. **Does not construct $W$ from scratch.** $W$ was built using known
   $\gamma_n$ and $p_j$. The roundtrip shows $W$ encodes them recoverable,
   but doesn't explain where $W$ comes from.

2. **Does not prove RH.** The algorithm is numerical, not a proof.

3. **Does not bypass computing zeros.** To BUILD $W$, you need zeros.
   The value is structural: $W$ (integer) determines everything continuously.

## The Open Question

Can $W$ be constructed from **purely arithmetic constraints** without
knowing $\gamma_n$ or $p_j$? Candidate constraints:

- **Rank-1 + integer**: $W_{np} = \lfloor a_n \ell_j \rfloor$ for some reals $a, \ell$
- **Monotonicity**: $W$ non-decreasing in both indices
- **N(T) bounds**: zero-counting function constrains row parameters
- **Von Mangoldt score**: $\sum_n \cos(2\pi\{a_n \ln k\})$ detects primes at $k$
- **Smith form**: trivial invariant factors except possibly the last

A 4×4 proof of concept (previous session) showed these constraints
narrow ~2 million candidates to ~200, with the correct $W$ at rank #2.

If $W$ can be constructed from constraints alone, then primes and zeros
**both emerge** from a single integer matrix — neither is input.

## Constraint Hierarchy for W Construction

The goal: construct $W$ from **purely arithmetic constraints**, without
knowing $\gamma_n$ or $p_j$. Which constraints determine $W$ uniquely?

### Constraint table

| ID | Constraint | What it says | Source |
|----|-----------|-------------|--------|
| C1 | Rank-1 floor | $\exists a,\ell: W_{nj} = \lfloor a_n \ell_j \rfloor$ | structure |
| C2 | Monotonicity | $W$ non-decreasing in both indices | ordering |
| C3 | $W_{11} = 1$ | normalization (smallest entry) | structure |
| C4 | $e^{\ell_j} \in \mathbb{Z}$ | columns = log of integer | lattice |
| C5 | OddQ ($j > 1$) | $e^{\ell_j}$ odd for $j > 1$ | Mod(·, 2) |
| C6 | $N(T)$ bounds | $a_n$ in intervals from $\theta(T)/\pi + 1$ | π + Γ |
| C7 | Self-sieve | found $k_j$ coprime to all smaller $k_i$ | autoconsis. |

### Key observations

- **C4, C5 are weak per-row, strong per-matrix**: any single row admits
  many integer $k_j$ assignments, but ALL rows sharing the SAME $k_j$
  is very restrictive.

- **Column-first enumeration** is the right approach: for fixed column
  integers $k_1 < k_2 < k_3 < k_4$, the valid rows are determined by
  breakpoints of $\lfloor a \cdot \ln k_j \rfloor$, and can be enumerated.

- **First data point** (4×4, columns = {2,3,5,7}):
  98 valid rows → 4,082,925 monotone 4-tuples (matrices).
  Exact $W$ is among them. Further constraints needed to narrow down.

### Numerical results (4×4)

Per column-tuple, with C1+C2+C3 only (rank-1 floor, monotone, $W_{11}=1$):

| Column tuple | Valid rows | Monotone matrices |
|-------------|-----------|-------------------|
| {2, 3, 5, 7} ★ | 98 | 4,082,925 |
| {2, 3, 5, 9} | 82 | 2,024,785 |
| {2, 3, 5, 11} | 106 | 5,563,251 |

C4+C5 reduce the number of column-tuples to try, but each tuple still
yields millions of matrices. **Not sufficient for uniqueness.**

With C6 ($N(T)$ bounds, requires π): rows per position drop from ~98 to ~10.
Matrices per tuple: ~$10^4$ instead of ~$4 \times 10^6$.
Previous session confirmed: 220 candidates for 4×4 with $N(T)$ bounds.

### Conclusion

**π is necessary.** Without it (C1–C5+C7 only), the candidate space is
$O(10^6)$ per column-tuple — too large for uniqueness.
With π (C6), the space drops to $O(10^2)$ — tractable.

The role of π: it provides the zero-counting function $N(T) = \theta(T)/\pi + 1 + S(T)$,
which bounds where rows can appear. This is the ONLY place transcendental
information enters. Everything else is pure integer arithmetic.

## Scripts

- `lattice-roundtrip-v3.wl` — Final version (ALS + roundtrip sieve, no PrimeQ)
- `lattice-roundtrip-v2.wl` — ALS + PrimeQ snap (for comparison)
- `lattice-roundtrip.wl` — Earlier version with column-ratio bootstrap

## Development History

1. **SVD approach**: blind SVD of $W$ → fails (floor noise defeats singular vectors)
2. **Column ratios**: $L_j/L_1$ via row intersection → works for small primes, fails for large
3. **Bootstrap**: seed primes → $\gamma_n$ → remaining primes → iterate → 100% for most sizes
4. **ALS formulation**: $\Theta = W + \frac{1}{2}$, alternating least squares → clean, 2 mat-vecs per step
5. **Lattice snap**: $e^{\ell_j} \to$ nearest prime → fixes scale, handles twin primes
6. **Roundtrip sieve**: replace `PrimeQ` with column verification → primes emerge from consistency
7. **OddQ filter**: eliminate even composites → fixes all remaining twin-prime swaps
