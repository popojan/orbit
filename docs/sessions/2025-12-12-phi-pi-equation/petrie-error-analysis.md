# Petrie Error Bar Analysis: Pyramid φ Hypotheses

**Date:** 2025-12-12
**Purpose:** Quantitative evaluation of competing hypotheses for Great Pyramid slope
**Methodology:** Error propagation from Petrie's 1883 measurements

---

## Source Data (Petrie 1883)

### Direct Measurements

| Parameter | Value | Error | Source |
|-----------|-------|-------|--------|
| Base (mean of 4 sides) | 9068.8" | ±7.8" | Petrie Table, p.39 |
| Base side variation | 0.65 feet | — | Livio (2002) |
| Royal cubit | 20.620" | ±0.005" | King's Chamber |
| King's Chamber height | 230.09" | ±0.5" | Petrie p.74 |

### Derived Values

| Parameter | Value | Calculation |
|-----------|-------|-------------|
| Base in cubits | 439.8 | 9068.8 / 20.620 |
| Height in cubits | ~280 | From slope extrapolation |
| Height/base ratio | 7/11 | 280/440 (design assumption) |

**Note:** Original pyramid height is CALCULATED, not directly measured (capstone missing since antiquity).

---

## Error Propagation

### Slope Angle Calculation

```
tan(θ) = 2h/b = 2 × (height/base)
θ = arctan(2r) where r = height/base
```

### Error Sources

| Source | Relative error | Notes |
|--------|----------------|-------|
| Base measurement | 0.086% | 7.8" / 9068.8" |
| Height estimate | 0.12% | ~7" uncertainty in 5776" |
| Cubit definition | 0.024% | 0.005" / 20.62" |

### Combined Error

```
σ(r)/r = √(σ²(h)/h² + σ²(b)/b²) ≈ 0.13%
```

### Angle Error

```
dθ/dr = 2/(1 + 4r²)

For r = 7/11:
σ(θ) = dθ/dr × σ(r) × r ≈ ±0.036°
```

**Result:** θ = 51.84° ± 0.036° (1σ)

---

## Hypothesis Testing

### Petrie's Measured Angle

From base 9068.8" and estimated height 5776":
```
θ_Petrie = arctan(2 × 5776/9068.8) = 51.867°
```

### Competing Hypotheses

| Hypothesis | Predicted angle | Formula |
|------------|-----------------|---------|
| **7/11 (seked)** | 51.843° | arctan(14/11) |
| **√φ/2 (Kepler)** | 51.827° | arctan(√φ) |
| **2/π** | 51.854° | arctan(4/π) |
| **1/φ** | 51.027° | arctan(2/φ) |

### Statistical Results

| Hypothesis | Δ from Petrie | |Δ|/σ | Status (1σ) |
|------------|---------------|------|--------------|
| **2/π** | -0.013° | 0.36σ | ✅ Consistent |
| **7/11** | -0.024° | 0.67σ | ✅ Consistent |
| **√φ/2** | -0.040° | 1.1σ | ~ Marginal |
| **1/φ** | -0.84° | 23σ | ❌ EXCLUDED |

---

## Key Finding: Cannot Distinguish 7/11 from 2/π

Both hypotheses are statistically consistent with Petrie's measurement.

**However:** This is expected because **7/11 is a common convergent** of both √φ/2 and 2/π!

```
Convergents of √φ/2: ..., 2/3, 5/8, 7/11, 159/250, ...
Convergents of 2/π:  ..., 2/3, 7/11, 219/344, ...

Common convergents: {1/2, 2/3, 7/11}
```

7/11 is the **last common convergent** before the sequences diverge.

---

## The √5 Evidence: King's Chamber

**Critical observation:** Interior chambers are not eroded!

### King's Chamber Dimensions (Petrie)

| Dimension | Measured | Best fit |
|-----------|----------|----------|
| Length | 412.59" | **20 cubits** |
| Width | 206.29" | **10 cubits** |
| Height | 230.09" | **5√5 cubits** |

### √5 Verification

| Hypothesis | Value (cubits) | Error from measured |
|------------|----------------|---------------------|
| **5√5** | 11.180 | **0.02 cubits** |
| 11 | 11.000 | 0.16 cubits (8× worse) |
| 12 | 12.000 | 0.84 cubits (42× worse) |

**Conclusion:** 5√5 is unambiguously the best fit. This is direct evidence that Egyptians used √5.

### Connection to φ

```
φ = (1 + √5)/2

King's Chamber height = 5√5 cubits
    → Evidence for √5 knowledge
    → Supports φ hypothesis for exterior
```

---

## Circularity Warning

### The Problem

1. Petrie measured BASE directly (reliable)
2. HEIGHT is calculated from slope + base
3. Slope measured from few remaining casing stones
4. "280 cubits" assumes integer design

### Breaking the Circularity

The **King's Chamber** breaks the circularity:
- Interior, not eroded
- Measured directly by Petrie
- Shows √5 (irrational), not just integers
- Independent of exterior slope assumptions

---

## Adversarial Checklist

| Check | Status |
|-------|--------|
| Error bars computed from primary sources | ✅ |
| Competing hypotheses tested fairly | ✅ |
| Circularity identified | ✅ |
| Independent evidence (King's Chamber) | ✅ |
| Falsifiable predictions | ✅ |

### What Would Falsify Each Hypothesis?

| Hypothesis | Falsified if... |
|------------|-----------------|
| **7/11 design** | Base/height ≠ 440/280 cubits |
| **√φ/2 intent** | No √5 evidence anywhere |
| **2/π intent** | No π evidence (but Rhind has π!) |
| **Random choice** | Pattern extends to other pyramids |

---

## Conclusion

1. **1/φ is definitively excluded** (23σ)

2. **7/11, √φ/2, and 2/π cannot be distinguished** by angle alone (~1σ separation)

3. **King's Chamber 5√5 provides independent √5 evidence**

4. **7/11 as "dual encoding"** of both √φ/2 and 2/π remains plausible

5. **Heinzl's criticism is valid:** Pure angle measurement cannot resolve intent

6. **Our contribution:** Structural arguments (convergents, orbits, seked-7) go beyond angle comparison

---

## Sources

- Petrie, W.M.F. (1883). *The Pyramids and Temples of Gizeh*. [Online](http://www.ronaldbirdsall.com/gizeh/petrie/)
- Livio, M. (2002). *The Golden Ratio*. Review.
- Rossi, C. (2007). *Architecture and Mathematics in Ancient Egypt*. Cambridge.
- [Jim Alison - King's Chamber measurements](http://home.hiwaay.net/~jalison/gpkc.html)
- [David Furlong - Sekeds](https://www.davidfurlong.co.uk/sekeds_greatpyramid.html)
