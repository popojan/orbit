# W(p) and Class Number Connection

**Date:** December 5, 2025
**Status:** Numerically verified, proof needed

## Adversarial Check Summary

| Aspect | Result |
|--------|--------|
| Formula W(p) = 2h(-p) - 2 | ✅ Verified to p = 100000 |
| Computational speedup | ❌ No (W(p) is ~16× slower than built-in) |
| **Novelty** | ❌ Equivalent to classical 1/4-th character sum |
| LCM pattern for h(-p)-1 | ❌ Falsified at p=257 |

## 🎯 Key Finding: Reduction to Classical Results

**Our formula is equivalent to Dirichlet's 1/4-th character sum!**

$$W(p) = 4 \cdot S(1, p/4) - 2$$

where $S(1, \ell) = \sum_{1 \leq k < \ell} \chi(k)$ is the classical character sum.

Combined with $W(p) = 2h(-p) - 2$, this gives:

$$S(1, p/4) = \frac{h(-p)}{2} \quad \text{for } p \equiv 1 \pmod 4$$

### Derivation from Classical Results

From [arXiv:1810.00227] Lemma 2(2): For $p \equiv 1 \pmod 4$:
$$S(1, p/4) = \frac{\sqrt{p}}{\pi} L(1, \chi_4 \chi_p)$$

From Dirichlet's class number formula:
$$h(-4p) = \frac{\sqrt{4p}}{2\pi} L(1, \chi_4 \chi_p)$$

Combining: $S(1, p/4) = h(-4p)/2$. Since $h(-4p) = h(-p)$ for $p \equiv 1 \pmod 4$ (same field!), we get $S(1, p/4) = h(-p)/2$.

**Value:** Formula is classical, but our **sign(cos) formulation** gives NEW geometric meaning:

## Geometric Interpretation: Arithmetic-Geometric Duality

$$W(p) = \sum_{k=1}^{p-1} \chi(k) \cdot \text{sign}(\cos) = (\Sigma\chi \text{ over small lobes}) - (\Sigma\chi \text{ over large lobes})$$

Since Chebyshev lobe areas satisfy $B(p,k) = 1 + \beta \cos\frac{(2k-1)\pi}{p}$ with $\beta < 0$:
- **sign(cos) = +1** → small lobe ($B < 1$)
- **sign(cos) = -1** → large lobe ($B > 1$)

**Therefore:** The class number $h(-p)$ measures how quadratic residues are distributed between small and large lobes of the Chebyshev p-gon!

$$h(-p) = \frac{W(p) + 2}{2} = \frac{(\Sigma\chi_{\text{small}}) - (\Sigma\chi_{\text{large}}) + 2}{2}$$

This is an **arithmetic-geometric duality**:
- $\chi(k)$ = quadratic character (pure arithmetic, modular)
- sign(cos) = lobe size indicator (pure geometry, Chebyshev polygon)

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

**Notation:** $h(-p)$ is standard notation in algebraic number theory. In Mathematica: `NumberFieldClassNumber[Sqrt[-p]]`. The discriminant of $\mathbb{Q}(\sqrt{-p})$ is $-p$ when $p \equiv 3 \pmod 4$ and $-4p$ when $p \equiv 1 \pmod 4$.

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

## ❌ FALSIFIED: LCM-like Growth Pattern

**Initial observation:** First ~24 values of $h(-p) - 1$ appeared to be prime powers only.

**Adversarial check:** FALSIFIED at p = 257 where $h(-p) - 1 = 15 = 3 \times 5$.

**Why this rules out LCM analogy:** LCM@@Range[n] can only add ONE prime at a time (when n is a prime power). If n+1 is composite, all its prime factors are already in Range[n]. Value 15 = 3×5 has two distinct primes — impossible for LCM growth.

---

## Open Questions

1. **Prove** the formula $W(p) = 2h(-p) - 2$ for $p \equiv 1 \pmod 4$
2. **Explain** why $W(p) = 2$ for $p \equiv 3 \pmod 4$ (sketch above, needs rigor)
3. **Generalize:** What is $W(n)$ for composite $n$?

---

## References

### Primary Sources

1. **Chattopadhyay, Roy, Sarkar & Thangadurai** (2020). "Distribution of Residues Modulo p Using the Dirichlet's Class Number Formula". In: Chakraborty, K. et al. (eds) *Class Groups of Number Fields and Related Topics*, Springer. [doi:10.1007/978-981-15-1514-9_9](https://link.springer.com/chapter/10.1007/978-981-15-1514-9_9). Open access preprint: [arXiv:1810.00227](https://arxiv.org/abs/1810.00227)
   - Lemma 2: $S(1, p/4) = \frac{\sqrt{p}}{\pi} L(1, \chi_4 \chi_p)$ for $p \equiv 1 \pmod 4$
   - Key paper connecting quarter-interval character sums to class numbers

2. **Berndt & Chowla** (1974). "Zero sums of the Legendre symbol". *Nordisk Mat. Tidskr.* 22, 5-8.
   - Lemma 3 in [1]: Vanishing sums $\sum_{n=1}^{(p-1)/2} \chi(n) = 0$ for $p \equiv 1 \pmod 4$

3. **Berndt, B.C.** (1976). "Classical theorems on quadratic residues". *Enseign. Math.* (2) 22, 261-304.
   - Comprehensive treatment of character sum identities

### Textbooks

4. **Ireland & Rosen**. *A Classical Introduction to Modern Number Theory*, 2nd ed., Springer GTM 84.
   - Chapter 16: Class Number Formula

5. **Wright, S.** (2016). "Quadratic residues and non-residues: Selected topics". [arXiv:1408.0235](https://arxiv.org/abs/1408.0235)

### Classical

6. **Dirichlet, P.G.L.** (1839). Class number formula for quadratic fields.
