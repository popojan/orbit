# Mondrian Clock - Complete Subset Sum Representation

**Date:** December 6, 2025
**Status:** Session in progress

## The Clock

Live: https://hraj.si/now
Steam Wallpaper Engine: https://steamcommunity.com/sharedfiles/filedetails/?id=3125524524

A Mondrian-style animated clock where time is displayed using a subset sum representation.

## The Seven Numbers

```
{1, 2, 4, 6, 12, 15, 20}
```

**Properties:**
- Sum = 60 (exactly the number of minutes in an hour)
- All are divisors of 60
- Every integer 0-59 can be represented as a subset sum

## Subset Sum Representations

Each minute has at least one representation:

| Minute | Representations |
|--------|-----------------|
| 0 | [] or [1,2,4,6,12,15,20] |
| 1 | [1] |
| 2 | [2] |
| 6 | [6] or [2,4] |
| 12 | [12] or [2,4,6] |
| 27 | [1,6,20], [1,2,4,20], [12,15], [2,4,6,15] |
| 59 | [2,4,6,12,15,20] |

Some minutes have multiple representations, enabling visual variety.

## The Period

From Steam description:
> The actual period of the clock is (2^30)(3^16) minutes, which is more than 6 times the estimated age of the Universe.

This astronomical period comes from cycling through all representation choices:
- Minutes with 2 representations contribute factor of 2
- Minutes with 3 representations contribute factor of 3
- Minutes with 4 representations contribute factor of 4 = 2²

## Origin of the Seven Numbers

Found via **greedy/bruteforce search** with constraint:

> Subsets can express all rational numbers p/q where q ∈ {1,2,3,4,5,6} ∪ {60}

### Why 7 Elements?

Theoretical minimum is 6 (since 2⁶ = 64 ≥ 61). Two 6-element solutions exist:
- {1, 2, 4, 8, 15, 30}
- {1, 2, 4, 8, 16, 29}

But these aren't composed of **divisors of 60**.

### Divisor-Based Solutions (7 elements)

Three 7-element sets exist using only divisors of 60:

| Set | Multi-rep minutes | Max reps | Period factors |
|-----|-------------------|----------|----------------|
| {1, 2, 3, 4, 5, 15, 30} | 43 | 3 | 2¹⁹ × 3²⁴ |
| {1, 2, 4, 5, 6, 12, 30} | 43 | 4 | 2³¹ × 3¹⁶ |
| **{1, 2, 4, 6, 12, 15, 20}** | **39** | 4 | 2²⁹ × 3¹⁶ |

The chosen set has the **fewest minutes with multiple representations** → more stable visual display.

### Completeness Property

Each element ≤ 1 + sum of previous elements:
```
1 ≤ 1 ✓
2 ≤ 2 ✓
4 ≤ 4 ✓
6 ≤ 8 ✓
12 ≤ 14 ✓
15 ≤ 26 ✓
20 ≤ 41 ✓
```

This guarantees all subset sums 0-60 are achievable.

## Three Independent Requirements

The bits_k construction for a Mondrian clock must satisfy:

1. **Complete coverage of 0 to LCM(1..k)** — for the clock to display all states
2. **FareySequence[k] representable** — mathematical elegance
3. **All elements divide LCM(1..k)** — for visual tiling on a grid

### Why 6-element sets fail for Mondrian

Two 6-element sets satisfy requirements 1 and 2:

| Set | Covers 0-60 | Covers Farey[6] | All divide 60? |
|-----|-------------|-----------------|----------------|
| {1,2,4,8,15,30} | ✓ | ✓ | ❌ (8∤60) |
| {1,2,4,8,16,29} | ✓ | ✓ | ❌ (8,16,29∤60) |
| **{1,2,4,6,12,15,20}** | ✓ | ✓ | ✓ |

The 6-element sets work mathematically but **cannot tile a rectangle** because 8, 16, 29 don't divide 60.

### bits_6 is the unique minimal solution

{1, 2, 4, 6, 12, 15, 20} is the **only 7-element set** satisfying all three requirements.

Additional benefits:
- Completeness property (each element ≤ 1 + sum of previous) → covers 0-60
- Sum = LCM(1..6) = 60 → covers Farey[6]
- High redundancy → period 2³⁰×3¹⁶ (vs 2³ for 6-element sets)

## Connection to Farey Sequences

**Key insight:** bits_k covers exactly FareySequence[k].

Since Sum(bits_k) = LCM(1..k), every fraction p/q with q ≤ k can be written as:
```
p/q = (p · LCM/q) / LCM
```
And that numerator is always a valid subset sum.

### bits_6 Covers FareySequence[6]

```
FareySequence[6] = {0, 1/6, 1/5, 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 5/6, 1}
```

| Fraction | = n/60 | Subset |
|----------|--------|--------|
| 1/6 | 10/60 | {4, 6} |
| 1/5 | 12/60 | {12} |
| 1/4 | 15/60 | {15} |
| 1/3 | 20/60 | {20} |
| 2/5 | 24/60 | {4, 20} |
| 1/2 | 30/60 | {4, 6, 20} |
| 3/5 | 36/60 | {1, 15, 20} |
| 2/3 | 40/60 | {2, 6, 12, 20} |
| 3/4 | 45/60 | {4, 6, 15, 20} |
| 4/5 | 48/60 | {1, 2, 6, 4, 15, 20} |
| 5/6 | 50/60 | {1, 2, 12, 15, 20} |

### Duality: Farey vs Binary

| System | Denominator | Weights | Use case |
|--------|-------------|---------|----------|
| Farey | LCM(1..k) | bits_k | Rational approximation |
| Binary | 2^n | {1,2,4,...,2^(n-1)} | Standard computers |

Binary {1,2,4,8,16,32} sums to 63, not 64 — the "off by one" that makes binary different from Farey-based systems.

