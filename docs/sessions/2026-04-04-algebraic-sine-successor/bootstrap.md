# Self-Sustained Bootstrap: γ₁ + {2,3} → Everything

**Date:** 2026-04-05
**Status:** 🔬 PARTIAL SUCCESS (concept works, numerics need hardening)

## The Idea

Start with ONE zero ($\gamma_1$) and TWO primes ($\{2, 3\}$).
Alternately discover new zeros and new primes:

```
γ₁ + {2,3}
  → find γ₂ (from calibrated N(T))     ✓ works!
  → detect p=5,7 (von Mangoldt)         ✓ works!
  → find γ₃ (with more primes)          ✗ numerics fail
  → ...
```

## What Works

### Predicting γ₂ from γ₁ + {2,3}

With just 2 primes and 1 known zero:

| Primes | γ₂ error | Winding correct? |
|--------|----------|-----------------|
| {2,3} | 0.16 | **✓** |
| {2,3,5,7} | 0.006 | **✓** |

**2 primes suffice** for the correct winding row of γ₂.
One known zero is worth more than 200 primes without calibration.

### Discovering primes from zeros

Von Mangoldt score $-C(\ln n)\sqrt{n} > 0.3$ correctly identifies:
$5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47$ — all primes, no false positives.

Prime powers ($4, 8, 9, 25, 27, 32, 49$) also detected and correctly filtered.

## What Fails

### γ₃ and beyond: numerical instability

The calibrated $N(T) = \theta(T)/\pi + 1 + S(T) + \text{offset}$ is oscillatory.
`FindRoot` (Newton's method) jumps to wrong solutions.

**This is a numerical problem, not a conceptual one.**
The function $N(T)$ has the right zeros — but finding them requires
bracketing (bisection), not Newton iteration.

### Error propagation

A wrong γ₃ → wrong calibration → wrong γ₄ → cascade failure.
The inductive method is sensitive to individual errors.

**Mitigation:** use winding-row verification as error correction.
If the predicted winding row is inconsistent (fails multi-base check),
reject and retry with modified starting point.

## The Bootstrap Circuit

```
Known zeros ──→ von Mangoldt ──→ Discover primes
     ↑                                    │
     │                                    ↓
     └──── N(T) calibration ←── S(T) from primes
```

Both directions work individually:
- Zeros → primes: von Mangoldt detection ✓
- Primes → zeros: calibrated N(T) ✓ (for γ₂, numerics fail later)

The circuit is self-sustained IN PRINCIPLE. The implementation needs:
1. Robust zero-finding (bracketing, not Newton)
2. Error correction via winding row consistency
3. Careful management of accumulated calibration error

## Minimum Bootstrap Set

Empirically: $\gamma_1 + \{2, 3\}$ → $\gamma_2$ (correct winding with 2 primes).

This is the minimal "seed" from which the entire prime-zero structure
can (in principle) be reconstructed inductively.

## Open: Closed Form for γ₁?

The bootstrap requires ONE zero as input. Currently $\gamma_1 = 14.1347...$
is computed numerically. A closed-form expression for $\gamma_1$
(even approximate) would make the bootstrap fully "algebraic."

No closed form is known for any zeta zero height.
