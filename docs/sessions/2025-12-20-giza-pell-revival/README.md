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

## Open Questions

1. Did the number 7 have special significance in Egyptian mathematics?
2. Is the k=40 choice coincidence, practical (round number), or intentional?
3. Why does only Khufu (not Khafre/Menkaure) use Brahmagupta scaling?

## References

1. Brahmagupta, *Brāhmasphuṭasiddhānta* (628 CE)
2. Bhaskara II, *Līlāvatī* and *Bījagaṇita* (1150 CE)
3. Herz-Fischler, R., *The Shape of the Great Pyramid* (2000)
4. Rossi, C., *Architecture and Mathematics in Ancient Egypt* (2007)
5. Petrie, W.M.F., *The Pyramids and Temples of Gizeh* (1883)
