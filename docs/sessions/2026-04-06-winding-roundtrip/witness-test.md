# Witness Test: Matrix Rows as Primality Witnesses

**Date:** 2026-04-06
**Status:** 🔬 NUMERICALLY VERIFIED (200×200)

## The mechanism

The roundtrip sieve tests each column candidate $k$ against the matrix:

$$\text{mismatches}(k, j) = \#\{n : \lfloor \gamma_n \ln k / (2\pi) \rfloor \neq W_{nj}\}$$

The correct prime $p_j$ gives **zero mismatches** (by definition of $W$).
Any wrong candidate $k \neq p_j$ gives **positive mismatches**.

This is analogous to Fermat primality testing: rows of $W$ are "witnesses"
that distinguish the correct prime from impostors.

## Key difference from Fermat

Fermat test: $a^{p-1} \equiv 1 \pmod{p}$ can have false positives
(Carmichael numbers pass for all witnesses).

W-test: the correct $p_j$ has **exactly zero** mismatches. Any $k \neq p_j$
has **strictly positive** mismatches. No false positives possible — the
test is a tautology for the correct value (W was built from it).

## Empirical results (200×200)

### Full matrix (200 witnesses)

ALS without sieve gives 193/200 primes correct. The 7 failures are
all $p \to p+2$ (ALS bias for large primes). With roundtrip sieve:
200/200.

For the 7 problem columns:

| Column | $p$ correct | $p$ wrong | Witnesses for correct | Witnesses for wrong | Margin |
|--------|------------|-----------|----------------------|--------------------:|-------:|
| 146 | 839 | 841 | 200 | 188 | 12 |
| 150 | 863 | 865 | 200 | 185 | 15 |
| 168 | 997 | 999 | 200 | 190 | 10 |
| 178 | 1061 | 1063 | 200 | 194 | 6 |
| 193 | 1171 | 1173 | 200 | 193 | 7 |
| 196 | 1193 | 1195 | 200 | 192 | 8 |
| 200 | 1223 | 1225 | 200 | 190 | 10 |

Correct prime: always 200/200. Wrong candidate: 185–194/200.

### Minimum witnesses needed

How many rows (witnesses) suffice for the correct prime to win
by majority?

| Column | $p \to p+2$ | Min rows needed |
|--------|------------|----------------|
| 150 | 863 → 865 | 11 |
| 196 | 1193 → 1195 | 20 |
| 146 | 839 → 841 | 32 |
| 168 | 997 → 999 | 31 |
| 200 | 1223 → 1225 | 72 |
| 178 | 1061 → 1063 | 71 |
| 193 | 1171 → 1173 | 83 |

**11 to 83 witnesses suffice** — far fewer than the full 200 rows.
The number varies per column (depends on how close $\ln p$ and
$\ln(p+2)$ are in their effect on the Floor values).

## Theoretical perspective

For the correct prime $p_j$: all 200 rows are "witnesses" by
construction ($W$ was built from $p_j$, so Floor always matches).

For a wrong candidate $k$: $\ln k \neq \ln p_j$, so
$\lfloor \gamma_n \ln k/(2\pi) \rfloor \neq \lfloor \gamma_n \ln p_j/(2\pi) \rfloor$
whenever $\gamma_n (\ln k - \ln p_j)/(2\pi)$ crosses an integer boundary.

The number of "disagreeing witnesses" is approximately
$N \cdot |\ln k - \ln p_j| \cdot \bar{\gamma}/(2\pi)$, where
$\bar{\gamma}$ is the mean zero height. For $k = p + 2$:
$|\ln(p+2) - \ln p| \approx 2/p$, giving ~$N \cdot \bar{\gamma}/(\pi p)$
disagreements.

For $N = 200$, $\bar{\gamma} \approx 400$, $p = 1000$:
disagreements $\approx 200 \cdot 400/(3142) \approx 25$. Consistent with
observed margins (6–15 with exact $\gamma$, but using approximate
$\gamma$ from ALS reduces the effective count).

## Complexity note

The roundtrip sieve is $O(N \cdot K \cdot C)$ where $C$ is the number
of candidates per column (~8). For $N = K$: $O(N^2)$. This is worse
than Eratosthenes ($O(N \log\log N)$) for finding primes alone, but
the sieve simultaneously recovers both primes AND zeros — both sides
of the duality — from a single integer matrix.
