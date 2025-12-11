# Rhind Mathematical Papyrus 2/n Table

**Source:** [Wikipedia](https://en.wikipedia.org/wiki/Rhind_Mathematical_Papyrus_2/n_table) (CC BY-SA)
**Original:** Rhind Mathematical Papyrus, ~1650 BCE, scribe Ahmes
**Location:** British Museum

## The Table

Egyptian fraction decompositions of 2/n for odd n from 3 to 101.

| 2/n | Decomposition |
|-----|---------------|
| 2/3 | 1/2 + 1/6 |
| 2/5 | 1/3 + 1/15 |
| 2/7 | 1/4 + 1/28 |
| 2/9 | 1/6 + 1/18 |
| 2/11 | 1/6 + 1/66 |
| 2/13 | 1/8 + 1/52 + 1/104 |
| 2/15 | 1/10 + 1/30 |
| 2/17 | 1/12 + 1/51 + 1/68 |
| 2/19 | 1/12 + 1/76 + 1/114 |
| 2/21 | 1/14 + 1/42 |
| 2/23 | 1/12 + 1/276 |
| 2/25 | 1/15 + 1/75 |
| 2/27 | 1/18 + 1/54 |
| 2/29 | 1/24 + 1/58 + 1/174 + 1/232 |
| 2/31 | 1/20 + 1/124 + 1/155 |
| 2/33 | 1/22 + 1/66 |
| 2/35 | 1/30 + 1/42 |
| 2/37 | 1/24 + 1/111 + 1/296 |
| 2/39 | 1/26 + 1/78 |
| 2/41 | 1/24 + 1/246 + 1/328 |
| 2/43 | 1/42 + 1/86 + 1/129 + 1/301 |
| 2/45 | 1/30 + 1/90 |
| 2/47 | 1/30 + 1/141 + 1/470 |
| 2/49 | 1/28 + 1/196 |
| 2/51 | 1/34 + 1/102 |
| 2/53 | 1/30 + 1/318 + 1/795 |
| 2/55 | 1/30 + 1/330 |
| 2/57 | 1/38 + 1/114 |
| 2/59 | 1/36 + 1/236 + 1/531 |
| 2/61 | 1/40 + 1/244 + 1/488 + 1/610 |
| 2/63 | 1/42 + 1/126 |
| 2/65 | 1/39 + 1/195 |
| 2/67 | 1/40 + 1/335 + 1/536 |
| 2/69 | 1/46 + 1/138 |
| 2/71 | 1/40 + 1/568 + 1/710 |
| 2/73 | 1/60 + 1/219 + 1/292 + 1/365 |
| 2/75 | 1/50 + 1/150 |
| 2/77 | 1/44 + 1/308 |
| 2/79 | 1/60 + 1/237 + 1/316 + 1/790 |
| 2/81 | 1/54 + 1/162 |
| 2/83 | 1/60 + 1/332 + 1/415 + 1/498 |
| 2/85 | 1/51 + 1/255 |
| 2/87 | 1/58 + 1/174 |
| 2/89 | 1/60 + 1/356 + 1/534 + 1/890 |
| 2/91 | 1/70 + 1/130 |
| 2/93 | 1/62 + 1/186 |
| 2/95 | 1/60 + 1/380 + 1/570 |
| 2/97 | 1/56 + 1/679 + 1/776 |
| 2/99 | 1/66 + 1/198 |
| 2/101 | 1/101 + 1/202 + 1/303 + 1/606 |

## Comparison with Orbit CF-Canonical Algorithm

Our `EgyptianFractions` module uses modular inverse algorithm producing CF-canonical decompositions.

**Key differences:**
- Rhind optimizes for **small denominators** (practical computation)
- Orbit optimizes for **minimal tuples** (algebraic canonicity)

**Match rate:** 5/24 tested cases match exactly (n = 3, 5, 7, 11, 23)

Both are valid decompositions — the non-uniqueness of Egyptian fractions is the fundamental insight.

## Known Formulas Used by Ahmes

From Problem 61 of Rhind papyrus:

1. `2/(3n) = 1/(2n) + 1/(6n)` — for n divisible by 3
2. `2/n = 1/n + 1/(2n) + 1/(3n) + 1/(6n)` — yields 2/101 decomposition
3. `2/(mn) = 1/m × 1/k + 1/n × 1/k` where k = (m+n)/2

## References

- Vymazalová, H. *Staroegyptská matematika.* Praha, 2006.
- Chace, A.B. *The Rhind Mathematical Papyrus.* MAA, 1927-1929.
- [Wikipedia: Rhind Mathematical Papyrus 2/n table](https://en.wikipedia.org/wiki/Rhind_Mathematical_Papyrus_2/n_table)
