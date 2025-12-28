# Great Pyramid of Giza and Continued Fractions

**Session:** 2025-12-20 (Revival)

**Related:** [HSM.SE Question: Giza pyramids and convergents of √φ/2](https://hsm.stackexchange.com/questions/19065/giza-pyramids-and-convergents-of-%E2%88%9A%CF%86-2-known-connection)

## Summary

The original SE question observed that pyramid **ratios** (7/11, 2/3, 5/8) are √φ/2 convergents.

**New finding:** The Great Pyramid's **absolute dimensions** (280 × 440 cubits) are uniquely determined by continued fraction theory. Only for scaling k=40 do the dimensions appear directly in the convergent bounds of √(7/11).

## The 7th Convergent of √(7/11)

```mathematica
Convergents[Sqrt[7/11], 7]
(* {0, 1, 3/4, 4/5, 67/84, 71/89, 280/351} *)
```

The **7th convergent** (1-indexed) of √(7/11) is exactly **280/351**.

The pair {c₇, (7/11)/c₇} brackets √(7/11):

| Bound | Value | Pyramid dimension |
|-------|-------|-------------------|
| Lower | 280/351 ≈ √(7/11) | **280** = height |
| Upper | 351/440 ≈ √(7/11) | **440** = base |

## Self-Referential Structure (Properly Understood)

**The claim is NOT** that (280/351) × (351/440) = 7/11 — this is trivially true for any convergent.

**The claim IS** that for k=40 specifically, the pyramid dimensions **appear directly** in the convergent bounds:

| Scaling k | Dimensions | In √(7/11) bounds? |
|-----------|------------|---------------------|
| 10 | 70 × 110 | ✗ 70 ∉ {280, 351}, 110 ∉ {351, 440} |
| 20 | 140 × 220 | ✗ |
| 30 | 210 × 330 | ✗ |
| **40** | **280 × 440** | **✓ 280 = numerator, 440 = denominator** |
| 50 | 350 × 550 | ✗ |
| 60 | 420 × 660 | ✗ |

**Only k=40 makes the pyramid dimensions visible in the NT structure.**

For any other k:
- The pyramid would still have ratio 7/11
- But the dimensions would NOT appear in √(7/11) convergent bounds
- The connection to √(7/11) would be "hidden"

## Why Only Certain Convergents Work

For dimensions 7k × 11k to appear in convergent bounds, we need:
- Numerator of lower bound divisible by **7**
- Denominator of upper bound divisible by **11**

Checking all convergents of √(7/11):

| Convergent # | Value | Numerator/7 | Valid k? |
|--------------|-------|-------------|----------|
| 3 | 3/4 | 3/7 | ✗ |
| 4 | 4/5 | 4/7 | ✗ |
| 5 | 67/84 | 67/7 | ✗ |
| 6 | 71/89 | 71/7 | ✗ |
| **7** | **280/351** | **40** | **✓ k=40** |
| 8 | 631/791 | 631/7 | ✗ |
| ... | | | |
| **13** | 196560/246401 | 28080 | ✓ k=28080 |
| **19** | 137984840/... | 19712120 | ✓ k=19712120 |

Pattern: every **6th** convergent (7, 13, 19, 25, ...) has numerator divisible by 7.

### Physical Implications

| Convergent # | k | Pyramid size | Realistic? |
|--------------|---|--------------|------------|
| 7 | 40 | 280 × 440 cubits ≈ 147 × 230 m | **✓ Khufu** |
| 13 | 28 080 | 196 560 × 308 880 cubits ≈ **103 × 162 km** | ✗ |
| 19 | 19 712 120 | ~10 000 × 16 000 km | ✗ (larger than Earth) |

**k=40 is the unique physically realizable solution.**

## Connection to x² − 77y² = 1

The 7th convergent 280/351 relates to the Brahmagupta-Bhaskara equation:

```
x² − 77y² = 1
Fundamental solution: (x, y) = (351, 40)
```

Formalized by Brahmagupta (*Brāhmasphuṭasiddhānta*, 628 CE) and Bhaskara II (chakravala method, 1150 CE).

This gives:
- Height = 7 × 40 = **280**
- Base = 11 × 40 = **440**
- Bridge = **351** (appears in both bounds)

## The Seked Connection

Egyptian seked measures horizontal run per **7 palms** (1 royal cubit) of rise.

```
Seked = (base/2) / height × 7
```

For Khufu (ratio 7/11):
```
Seked = (11/2) / 7 × 7 = 11/2 = 5.5 palms = 5p 2d
```

**The 7 in the ratio cancels with the 7 in the seked definition!**

This suggests the number 7 is structurally linked:
- Royal cubit = **7** palms (unit definition)
- Seked = run per **7** palms (slope definition)
- Ratio = **7**/11 → clean seked = 11/2

## Comparison with Other Giza Pyramids

| Pyramid | Ratio | Actual k | Brahmagupta y | Match? |
|---------|-------|----------|---------------|--------|
| Khufu | 7/11 | 40 | 40 | **✓** |
| Khafre | 2/3 | 137 | 2 | ✗ |
| Menkaure | 5/8 | 25 | 3 | ✗ |

Only Khufu uses the mathematically special scaling.

### Pell Equations for Other Pyramids (Added Dec 24, 2025)

If we treat each pyramid's k value as the fundamental y-solution of *some* Pell equation x² − Dy² = ±1, what D values result?

| Pyramid | Ratio | k | D | Equation | Notes |
|---------|-------|-----|------|----------|-------|
| Khufu | 7/11 | 40 | 77 | 351² − 77·40² = 1 | D = 7×11 |
| Khafre | 2/3 | 137 | 2330 | 6613² − 2330·137² = −1 | D = 2×5×233 |
| Menkaure | 5/8 | 25 | 53 | 182² − 53·25² = −1 | D prime |

Each k is indeed a fundamental y-solution, but only for Khufu does D equal the product of ratio components. The values 53 and 2330 are simply the smallest D for which 25 and 137 appear as fundamental solutions — no obvious connection to 5×8=40 or 2×3=6.

**Numerical curiosities** (likely coincidental):
- 2330 = 10 × 233 = 10 × F₁₃ (Fibonacci)
- 25 = 5² (square of ratio numerator)
- 137 is the 33rd prime

### Mediant Structure (Added Dec 24, 2025)

The three ratios satisfy a Farey/Stern-Brocot relationship:

```
mediant(2/3, 5/8) = (2+5)/(3+8) = 7/11
```

Verification that 2/3 and 5/8 are Farey neighbors: |2×8 − 3×5| = |16 − 15| = 1 ✓

This means 7/11 is the child of 2/3 and 5/8 in the Stern-Brocot tree.

### Fibonacci and Lucas Structure (Added Dec 24, 2025)

The ratios correspond to consecutive terms in Fibonacci and Lucas sequences:

| Pyramid | Ratio | Sequence |
|---------|-------|----------|
| Khafre | 2/3 | F₃/F₄ |
| Menkaure | 5/8 | F₅/F₆ |
| Khufu | 7/11 | L₄/L₅ |

Where Fₙ = {1,1,2,3,5,8,13,...} and Lₙ = {2,1,3,4,7,11,18,...}.

The mediant of two consecutive Fibonacci ratios yields a Lucas ratio:
```
mediant(F₃/F₄, F₅/F₆) = L₄/L₅
```

This pattern **does generalize**:
```
mediant(Fₙ/Fₙ₊₁, Fₙ₊₂/Fₙ₊₃) = Lₙ₊₁/Lₙ₊₂
```

Verified for n = 1..8. This is likely a known identity following from Fₙ + Fₙ₊₂ = Lₙ₊₁.

**Interpretive caution:** These observations are numerical facts about the ratios. They do not imply the Egyptians knew Fibonacci/Lucas sequences or deliberately chose these relationships. The ratios are also √φ/2 convergents (positions 4, 5, 6), which may be the more fundamental explanation.

## Adversarial Analysis

### What IS special:
1. **7/11 is a √φ/2 convergent** — non-trivial, in original question
2. **280/351 is a √(7/11) convergent** — structurally necessary given Brahmagupta
3. **k=40 makes dimensions visible in bounds** — unique property

### What is NOT special (or trivial):
1. ~~"Self-referential: product = 7/11"~~ — true for ANY convergent bounds
2. ~~"7th convergent for 7/11"~~ — depends on indexing convention (would be 6th with c₀)
3. ~~"GCD = Brahmagupta y"~~ — always true: GCD(7k, 11k) = k for coprime 7, 11

### Alternative hypothesis:
- Egyptians wanted ~51° slope (aesthetic/structural)
- Chose 280 (divisible by 7 = palms/cubit) and 440 (round, ≈ 2 khet)
- Brahmagupta/convergent structure is **emergent**, not designed

## Historical Context

**Timeline:**
- Great Pyramid (Khufu): c. 2560 BCE
- Rhind Papyrus: c. 1650 BCE
- Brahmagupta: 628 CE
- Bhaskara II: 1150 CE

**Royal cubit origin:**
- Common cubit = 6 palms ≈ 45 cm (forearm to fingertip)
- Royal cubit = 7 palms ≈ 52.4 cm (common + pharaoh's palm width)
- Anatomically derived, not mathematically chosen

**Note:** Claims about "monthly calibration with death penalty" appear in metrology circles but lack primary Egyptian sources. Likely modern embellishment.

## Verification

```mathematica
(* 7th convergent *)
Convergents[Sqrt[7/11], 7][[7]]
(* 280/351 *)

(* Bounds *)
c7 = 280/351;
{c7, (7/11)/c7}
(* {280/351, 351/440} *)

(* Brahmagupta equation *)
351^2 - 77*40^2
(* 1 *)

(* Only k=40 works *)
Table[{k, 7k, 11k,
  MemberQ[{280, 351}, 7k] && MemberQ[{351, 440}, 11k]},
  {k, 10, 60, 10}]
(* Only k=40 gives True *)
```

## Connection to Bessel Sequence (s₃ = 1001)

The Pythagorean triple from 7/11 is (36, 77, 85), giving ratio a/b = 36/77.

```mathematica
SqrtInterval[36/77, 1]
(* Interval[{168480/246401, 246401/360360}] *)
```

The upper bound denominator **360360 = 360 × 1001 = 360 × s₃**.

Where s₃ = 7 × 11 × 13 = 1001 is the 3rd term of the Bessel sequence for Euler's e approximation.

This connects:
- **77 = 7 × 11** from ratio 7/11
- **351 = 27 × 13** from Pell x-solution (contains factor 13)
- **1001 = 7 × 11 × 13 = s₃** appears naturally

The 13 in the Pell solution "completes" the triple 7 × 11 × 13 = s₃.

## Open Questions

1. Did the number 7 have special significance in Egyptian mathematics?
2. Is the k=40 choice coincidence, practical (round number), or intentional?
3. Why does only Khufu (not Khafre/Menkaure) use Brahmagupta scaling?
4. Is the s₃ = 1001 connection meaningful or coincidental?
5. Is the mediant relationship (7/11 = mediant of 2/3 and 5/8) coincidence or design?
6. ~~Does the Fibonacci→Lucas mediant pattern generalize?~~ **Yes** — see above.

## References

1. Brahmagupta, *Brāhmasphuṭasiddhānta* (628 CE)
2. Bhaskara II, *Līlāvatī* and *Bījagaṇita* (1150 CE)
3. Herz-Fischler, R., *The Shape of the Great Pyramid* (2000)
4. Rossi, C., *Architecture and Mathematics in Ancient Egypt* (2007)
5. Petrie, W.M.F., *The Pyramids and Temples of Gizeh* (1883)
