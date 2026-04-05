# Constraint Reconstruction: Winding Matrix from Primes Alone

**Date:** 2026-04-05
**Status:** 🔬 PROOF OF CONCEPT (4×4, exact matrix ranked #2 of 220)

## The Experiment

Can we reconstruct the winding matrix $w_{np} = \lfloor\gamma_n\ln p/(2\pi)\rfloor$
using ONLY prime-derived constraints, without computing any zeta zeros?

### Available constraints (from primes only)

1. **Row consistency**: each row must satisfy $w_{np} = \lfloor a_n\ln p\rfloor$ for
   some real $a_n$ — not all integer matrices qualify

2. **$N(T)$ bounds**: the zero counting function $N(T) = \theta(T)/\pi + 1 + S(T)$
   (computable from primes) bounds $a_n = \gamma_n/(2\pi)$ to intervals

3. **Ordering**: $a_1 < a_2 < a_3 < \ldots$ (zeros are ordered)

4. **Von Mangoldt detection**: $\sum_n\cos(2\pi\{a_n\ln p\})$ should be negative
   at primes (pair correlation constraint)

### Results for 4×4 (4 zeros × 4 primes: 2, 3, 5, 7)

| Constraint applied | Candidates remaining |
|--------------------|---------------------|
| Row consistency only | 1 837 620 |
| + $N(T)$ bounds on $a_n$ | **220** |
| + Von Mangoldt score ranking | Exact matrix at **rank #2** |

The correct matrix $\{1,2,3,4\}, \{2,3,5,6\}, \{2,4,6,7\}, \{3,5,7,9\}$ was identified
as the second-best candidate. The only better-scoring matrix differs in ONE entry
(row 4: $\{3,5,8,10\}$ vs. correct $\{3,5,7,9\}$).

## What This Means

With 3 simple constraints — all derivable from primes — the space of $\sim 2$ million
possible matrices narrows to $\sim 200$, with the correct answer in the top 2.

Additional constraints (not yet implemented) that would narrow further:

- More primes per row (5, 7, ... columns instead of 4)
- Precise $S(T)$ from the Euler product (tighter $a_n$ bounds)
- Cross-row correlation constraints (from $M^TM$ structure)
- Smith invariant factor constraint ($d_n$ small)

## The Procedure

Given only primes $p_1, \ldots, p_k$:

1. Compute $N(T)$ bounds from $\theta(T)$ and $S(T)$ → intervals for $a_n$
2. Enumerate consistent rows: $\lfloor a\ln p_j\rfloor$ for $a$ in each interval
3. Form ordered matrices ($a_1 < a_2 < \ldots$)
4. Score by von Mangoldt: $\sum_{n,p}\cos(2\pi\{a_n\ln p\})$ → most negative wins
5. Top candidate(s) give the winding matrix → rows encode $\gamma_n$

No zeta zeros are computed at any step. The zeros EMERGE from the constraints.

## Limitations

- Tested only at 4×4. Scaling to larger sizes: the enumeration grows, but constraints
  grow faster (each additional prime adds a constraint per row).
- The von Mangoldt score is heuristic (uses midpoint $a_n$, not the full interval).
  A more careful implementation would integrate over the allowed interval.
- The exact matrix was #2, not #1. More constraints or more primes per row
  would likely promote it to #1.
