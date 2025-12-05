# W(p) and Class Number Connection

**Date:** December 5, 2025
**Status:** Numerically verified, proof needed

---

## Definition

$$W(p) = \sum_{k=1}^{p-1} \chi(k) \cdot \text{sign}\left(\cos\frac{(2k-1)\pi}{p}\right)$$

where $\chi(k) = \left(\frac{k}{p}\right)$ is the Legendre symbol.

---

## Main Result (Numerically Verified)

**Theorem (Conjecture):**

For odd prime $p$:

$$W(p) = \begin{cases} 2h(-p) - 2 & p \equiv 1 \pmod 4 \\ 2 & p \equiv 3 \pmod 4 \end{cases}$$

where $h(-p)$ is the class number of the imaginary quadratic field $\mathbb{Q}(\sqrt{-p})$.

---

## Numerical Evidence

### p ≡ 1 (mod 4)

| p | W(p) | h(-p) | 2h(-p)-2 | Match |
|---|------|-------|----------|-------|
| 5 | 2 | 2 | 2 | ✓ |
| 13 | 2 | 2 | 2 | ✓ |
| 17 | 6 | 4 | 6 | ✓ |
| 29 | 10 | 6 | 10 | ✓ |
| 37 | 2 | 2 | 2 | ✓ |
| 41 | 14 | 8 | 14 | ✓ |
| 53 | 10 | 6 | 10 | ✓ |
| 61 | 10 | 6 | 10 | ✓ |
| 73 | 6 | 4 | 6 | ✓ |
| 89 | 22 | 12 | 22 | ✓ |
| 97 | 6 | 4 | 6 | ✓ |
| 101 | 26 | 14 | 26 | ✓ |

### p ≡ 3 (mod 4)

| p | W(p) | h(-p) | Note |
|---|------|-------|------|
| 3 | 2 | 1 | W = 2 always |
| 7 | 2 | 1 | W = 2 always |
| 11 | 2 | 1 | W = 2 always |
| 19 | 2 | 1 | W = 2 always |
| 23 | 2 | 3 | W = 2 always |
| 31 | 2 | 3 | W = 2 always |
| 47 | 2 | 5 | W = 2 always |
| 71 | 2 | 7 | W = 2 always |

---

## Interpretation

### W(p) as "Agreement Measure"

W(p) counts the net agreement between two parities:
1. **Arithmetic parity:** $\chi(k) = \pm 1$ (is k a quadratic residue?)
2. **Geometric parity:** $\text{sign}(\cos) = \pm 1$ (which half of the circle?)

$$W(p) = (\text{agreements}) - (\text{disagreements})$$

### Why p ≡ 3 (mod 4) is constant

For $p \equiv 3 \pmod 4$, there's a symmetry that forces $W(p) = 2$ regardless of the class number. The pairing $k \leftrightarrow p-k$ has:
- $\chi(p-k) = \chi(-1)\chi(k) = -\chi(k)$ (since $\chi(-1) = -1$)
- $\text{sign}(\cos((2(p-k)-1)\pi/p)) = -\text{sign}(\cos((2k-1)\pi/p))$

Product: $(-\chi(k)) \cdot (-\text{sign}) = \chi(k) \cdot \text{sign}$ — terms pair to give same contribution!

### Why p ≡ 1 (mod 4) varies

For $p \equiv 1 \pmod 4$, $\chi(-1) = 1$, so the pairing symmetry is different, and the class number structure emerges.

---

## Connection to Chebyshev Geometry

Recall:
- $A(p) = \sum \text{sign}(\cos) = $ lobe balance (small vs large)
- $W(p) = \sum \chi(k) \cdot \text{sign}(\cos) = $ character-weighted balance

The identity $W(p) = 2h(-p) - 2$ (for $p \equiv 1$) connects Chebyshev lobe geometry to algebraic number theory!

---

## W(p)/2 = h(-p) - 1 Pattern

For $p \equiv 1 \pmod 4$:

$$\frac{W(p)}{2} = h(-p) - 1$$

Values: 1, 1, 3, 5, 1, 7, 5, 5, 3, 11, 3, 13, ...

**Observation:** These are h(-p) - 1, and many are primes. The appearance of 9 = 3² (at p = 181, 197, 229) corresponds to class numbers h = 10, suggesting connection to LCM structure.

---

## Verification Code

```mathematica
W[p_] := Sum[JacobiSymbol[k, p] * Sign[Cos[(2k-1) Pi / p]], {k, 1, p-1}];

(* Verify formula *)
Table[
  {p, W[p], 2 NumberFieldClassNumber[Sqrt[-p]] - 2,
   W[p] == 2 NumberFieldClassNumber[Sqrt[-p]] - 2},
  {p, Select[Prime[Range[50]], Mod[#, 4] == 1 &]}
]
```

---

## LCM-like Growth Pattern

The sequence $h(-p) - 1$ for $p \equiv 1 \pmod 4$:

$$1, 1, 3, 5, 1, 7, 5, 5, 3, 11, 3, 13, 5, 7, 7, 13, 5, 13, 9, 3, 9, 9, ...$$

**Observation:** These are mostly **primes or prime powers**!

| h(-p) - 1 | Factorization | First appearance |
|-----------|---------------|------------------|
| 1 | 1 | p = 5 |
| 3 | 3¹ | p = 17 |
| 5 | 5¹ | p = 29 |
| 7 | 7¹ | p = 41 |
| 9 | **3²** | p = 181 |
| 11 | 11¹ | p = 89 |
| 13 | 13¹ | p = 101 |

This mirrors LCM@@Range@n growth:
- n = 3: adds 3¹
- n = 5: adds 5¹
- n = 7: adds 7¹
- n = 9: adds **3²**
- n = 11: adds 11¹

**Analogy:** $\exp(\psi(n)) = \text{lcm}(1, 2, ..., n)$ where $\psi$ is Chebyshev's function.

The class numbers h(-p) seem to grow by "adding" prime powers in a similar fashion!

---

## Open Questions

1. **Prove** the formula $W(p) = 2h(-p) - 2$ for $p \equiv 1 \pmod 4$
2. **Explain** why $W(p) = 2$ for $p \equiv 3 \pmod 4$ (sketch above, needs rigor)
3. **LCM connection:** Why does $h(-p) - 1$ follow prime-power pattern?
4. **Generalize:** What is $W(n)$ for composite $n$?

---

## References

- Class number formula: Dirichlet (1839)
- Connection to L-functions: $h(-p) = \frac{\sqrt{p}}{\pi} L(1, \chi)$
- Ireland & Rosen, Chapter 16 (Class Number Formula)
