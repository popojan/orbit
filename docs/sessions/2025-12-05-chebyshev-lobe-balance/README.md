# Session: Chebyshev Polygon Lobe Balance

**Date:** December 5, 2025
**Status:** Complete geometric characterization

---

## Main Result: Lobe Size Distribution

For the Chebyshev n-gon with lobe areas $B(n,k) = 1 + \beta_{\text{geom}}(n) \cdot \cos\frac{(2k-1)\pi}{n}$, where $\beta_{\text{geom}} < 0$:

- **Small lobes:** $B(n,k) < 1$ (below average)
- **Large lobes:** $B(n,k) > 1$ (above average)
- **Fair lobes:** $B(n,k) = 1$ (exactly average)

The balance between small and large lobes depends only on $n \mod 4$.

---

## Prime Polygons

For prime p, the lobe balance is particularly clean:

| p | p mod 4 | Small | Large | Balance | Interpretation |
|---|---------|-------|-------|---------|----------------|
| 5 | 1 | 1 | 3 | **-2** | 2 more large |
| 7 | 3 | 3 | 3 | **0** | perfect balance |
| 11 | 3 | 5 | 5 | **0** | perfect balance |
| 13 | 1 | 5 | 7 | **-2** | 2 more large |
| 17 | 1 | 7 | 9 | **-2** | 2 more large |
| 19 | 3 | 9 | 9 | **0** | perfect balance |
| 23 | 3 | 11 | 11 | **0** | perfect balance |
| 29 | 1 | 13 | 15 | **-2** | 2 more large |
| 31 | 3 | 15 | 15 | **0** | perfect balance |
| 37 | 1 | 17 | 19 | **-2** | 2 more large |

**Theorem (Prime Lobe Balance):**

For odd prime p:

$$\text{(small lobes)} - \text{(large lobes)} = \begin{cases} -2 & p \equiv 1 \pmod 4 \\ 0 & p \equiv 3 \pmod 4 \end{cases}$$

**Geometric meaning:**
- **p ≡ 1 (mod 4):** The Chebyshev p-gon has exactly 2 more large lobes than small lobes
- **p ≡ 3 (mod 4):** The Chebyshev p-gon has perfect balance between large and small lobes

---

## General n: Congruence Classes

For arbitrary $n \geq 3$, the pattern depends on $n \mod 4$:

### n ≡ 0 (mod 4)

| n | Small | Large | Fair | Balance |
|---|-------|-------|------|---------|
| 4 | 1 | 2 | 0 | -1 |
| 8 | 3 | 4 | 0 | -1 |
| 12 | 5 | 6 | 0 | -1 |
| 16 | 7 | 8 | 0 | -1 |
| 20 | 9 | 10 | 0 | -1 |

**Pattern:** 1 more large than small, no fair lobes.

### n ≡ 1 (mod 4)

| n | Small | Large | Fair | Balance |
|---|-------|-------|------|---------|
| 5 | 1 | 3 | 0 | -2 |
| 9 | 3 | 5 | 0 | -2 |
| 13 | 5 | 7 | 0 | -2 |
| 17 | 7 | 9 | 0 | -2 |
| 21 | 9 | 11 | 0 | -2 |

**Pattern:** 2 more large than small, no fair lobes.

### n ≡ 2 (mod 4)

| n | Small | Large | Fair | Balance | Fair lobe indices |
|---|-------|-------|------|---------|-------------------|
| 6 | 1 | 2 | 2 | -1 | k = 2, 5 |
| 10 | 3 | 4 | 2 | -1 | k = 3, 8 |
| 14 | 5 | 6 | 2 | -1 | k = 4, 11 |
| 18 | 7 | 8 | 2 | -1 | k = 5, 14 |
| 22 | 9 | 10 | 2 | -1 | k = 6, 17 |

**Pattern:** 1 more large than small, **2 fair lobes exist**.

Fair lobe positions: $k_1 = \frac{n+2}{4}$ and $k_2 = \frac{3n+2}{4}$

### n ≡ 3 (mod 4)

| n | Small | Large | Fair | Balance |
|---|-------|-------|------|---------|
| 3 | 1 | 1 | 0 | 0 |
| 7 | 3 | 3 | 0 | 0 |
| 11 | 5 | 5 | 0 | 0 |
| 15 | 7 | 7 | 0 | 0 |
| 19 | 9 | 9 | 0 | 0 |

**Pattern:** Perfect balance, no fair lobes.

---

## Summary Theorem

**Theorem (General Lobe Balance):**

For $n \geq 3$, let $A(n) = \text{(small lobes)} - \text{(large lobes)}$. Then:

$$A(n) = \begin{cases} -1 & n \equiv 0 \pmod 4 \\ -2 & n \equiv 1 \pmod 4 \\ -1 & n \equiv 2 \pmod 4 \\ 0 & n \equiv 3 \pmod 4 \end{cases}$$

Fair lobes (with $B = 1$ exactly) exist if and only if $n \equiv 2 \pmod 4$.

---

## Algebraic Formulation

The balance $A(n)$ equals the sign sum:

$$A(n) = \sum_{k=1}^{n-1} \text{sign}\left(\cos\frac{(2k-1)\pi}{n}\right)$$

This follows because $\beta_{\text{geom}} < 0$, so:
- $\cos > 0 \Rightarrow B < 1$ (small)
- $\cos < 0 \Rightarrow B > 1$ (large)

---

## Connection to Number Theory

For primes, the mod 4 dichotomy connects to quadratic residues:

$$A(p) = -(1 + \chi(-1))$$

where $\chi(-1) = \left(\frac{-1}{p}\right)$ is the Legendre symbol.

- $p \equiv 1 \pmod 4$: $\chi(-1) = 1$, so $A(p) = -2$
- $p \equiv 3 \pmod 4$: $\chi(-1) = -1$, so $A(p) = 0$

This connects the purely geometric lobe balance to the arithmetic structure of primes.

See also:
- [Sign-Cosine Identity Paper](../../papers/sign-cosine-identity.tex)
- [Class Number Connection](class-number-connection.md) — **Major finding:** $W(p) = 2h(-p) - 2$ for $p \equiv 1 \pmod 4$

---

## Verification Code

```mathematica
(* Lobe balance computation *)
beta[n_] := n^2 Cos[Pi/n] / (4 - n^2);
B[n_, k_] := 1 + beta[n] Cos[(2k-1) Pi / n];

lobeBalance[n_] := Module[{lobes, small, large},
  lobes = Table[B[n, k], {k, 1, n-1}];
  small = Count[lobes, b_ /; b < 1 - 10^-10];
  large = Count[lobes, b_ /; b > 1 + 10^-10];
  small - large
];

(* Verify for n = 3 to 50 *)
Table[{n, Mod[n, 4], lobeBalance[n]}, {n, 3, 50}]
```

---

## Origin

**The journey:**

1. **Geometry** — Chebyshev lobe areas $B(n,k) = 1 + \beta \cos\frac{(2k-1)\pi}{n}$
2. **Sign sum** — Studying which lobes are large/small led to $\sum \text{sign}(\cos(...))$
3. **Back to geometry** — The algebraic identity has clean geometric meaning: lobe balance

The algebraic formula:
$$\sum_{k=1}^{p-1} \text{sign}\left(\cos\frac{(2k-1)\pi}{p}\right) = -(1 + (-1)^{(p-1)/2})$$

encodes the geometric fact: Chebyshev p-gons have perfect lobe balance iff $p \equiv 3 \pmod 4$.

**Session lineage:**
- [2025-11-23-chebyshev-integral-identity](../2025-11-23-chebyshev-integral-identity/) — original lobe area formula (geometry)
- [2025-12-04-beta-functions-analysis](../2025-12-04-beta-functions-analysis/) — sign-cosine identity (algebra)
- This session — geometric interpretation (back to geometry)
