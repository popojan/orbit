# Pyramid Ratios and Möbius Orbits

**Date:** 2025-12-12
**Status:** Active exploration
**Context:** Emerged from pyramid ratio analysis

---

## Starting Point

The Cheops ratio 7/11 is a convergent of BOTH:
- 2/π ≈ 0.6366...
- √φ/2 ≈ 0.6360...

This is the mediant of 2/3 and 5/8 in the Farey sequence.

---

## Möbius Involution Orbits

### The Involutions

Three Möbius involutions (each is its own inverse):

| Name | Formula | Fixed points |
|------|---------|--------------|
| silver | (1-x)/(1+x) | √2 - 1 |
| copper | 1 - x | 1/2 |
| gold | x/(1-x) | φ - 1 |

### Compositions

```
silver ∘ copper(x) = x/(2-x)
copper ∘ silver(x) = 2x/(1+x)
```

### Orbit Structure

**Key discovery:** The orbit of p/q under {silver, copper} has closed-form structure.

**SC iteration (silver ∘ copper):**
```
SC(x) = x/(2-x)
SC^n(p/q) = p / (2^n(q-p) + p)
```

For 7/11:
```
SC^n(7/11) = 7 / (4·2^n + 7)

n=0: 7/11
n=1: 7/15
n=2: 7/23
n=3: 7/39
...
lim: 0
```

**CS iteration (copper ∘ silver):**
```
CS(x) = 2x/(1+x)
CS^n(p/q) → 1
```

For 7/11:
```
7/11 → 7/9 → 7/8 → 14/15 → 28/29 → 56/57 → ...
```

**Denominator recurrence:** d_{n+1} = 2d_n - p with d_0 = q

**Orbit limits:** SC^∞ = 0, CS^∞ = 1 (boundary points of (0,1))

---

## Seked System and the Numerator 7

### The Connection

Egyptian seked = horizontal run per **7** cubits rise.

```
7/11 = 7 / (2 × seked)  where seked = 11/2 = 5.5
```

**The numerator 7 in our orbit is the seked reference height!**

### SC Preserves Seked Structure

```
SC(p/q) = p/(2q-p)
```

The transformation SC preserves the numerator — it maps seked-compatible ratios to other seked-compatible ratios:

| Fraction | Seked | Angle |
|----------|-------|-------|
| 7/11 | 5.5 | 51.8° |
| 7/15 | 7.5 | 43.0° |
| 7/23 | 11.5 | 31.3° |
| 7/9 | 4.5 | 57.3° |

### Pyramids in the SC Orbit

| Fraction | Seked | Angle | Pyramid |
|----------|-------|-------|---------|
| 7/11 | 5.5 | 51.8° | **Cheops** |
| 7/15 | 7.5 | 43.0° | **Bent Pyramid (upper)** |
| 7/9 | 4.5 | 57.3° | (steeper than Cheops) |
| 7/14=1/2 | 7 | 45.0° | **Red Pyramid** |

**Key finding:** The Bent Pyramid's upper section (seked 7.5) is **one SC step** from Cheops:
```
SC(7/11) = 7/15
```

**Open question:** Did Egyptian mathematicians know about this transformation family?

---

## Open Questions

1. **Raw tuple patterns:** How do Egyptian fraction representations transform under SC/CS?
2. **Convergent membership:** Which orbit elements are convergents of 2/π or √φ/2?
3. **Gold involution:** What happens when we add gold(x) = x/(1-x) to the group?
4. **Fixed point significance:** silver has fixed point √2-1, copper has 1/2, gold has φ-1. Connection?
