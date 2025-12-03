# Session: Primitive Lobe Signs and Number Theory

**Date:** December 3, 2025
**Status:** 🔬 NUMERICALLY VERIFIED

## Summary

Exploration of B(n,k) restricted to primitive indices (where gcd(k,n) = 1) reveals deep connections to classical number theory: Möbius function, Gauss sums, quadratic residues, and Legendre symbols.

## Main Results

### 1. Primitive Lobe Sum Formula

**Theorem:** For n ≥ 2,
$$\sum_{\gcd(k,n)=1} B(n,k) = \varphi(n) + \beta(n) \cdot \mu(n) \cdot \cos\frac{\pi}{n}$$

where:
- $\varphi(n)$ = Euler totient function
- $\mu(n)$ = Möbius function
- $\beta(n) = \frac{\sin(\pi/n) - (\pi/n)\cos(\pi/n)}{2\sin^3(\pi/n)}$

**Proof sketch:**
$$\sum_{\gcd(k,n)=1} B(n,k) = \varphi(n) + \beta(n) \sum_{\gcd(k,n)=1} \cos\frac{(2k-1)\pi}{n}$$

The cosine sum equals $\text{Re}[e^{-i\pi/n} \cdot c_n(1)]$ where $c_n(1) = \mu(n)$ is the Ramanujan sum.

**Numerical verification:** All n from 2 to 100 match exactly.

### 2. Sign Asymmetry for Primes

**Theorem:** For odd prime p, let
$$A(p) = \#\{k : 1 \leq k \leq p-1, B(p,k) > 1\} - \#\{k : 1 \leq k \leq p-1, B(p,k) < 1\}$$

Then:
$$A(p) = \begin{cases} -2 & \text{if } p \equiv 1 \pmod{4} \\ 0 & \text{if } p \equiv 3 \pmod{4} \end{cases}$$

**Interpretation:**
- For $p \equiv 3 \pmod{4}$: lobe signs are perfectly balanced
- For $p \equiv 1 \pmod{4}$: two more lobes are "small" (B < 1) than "large" (B > 1)

**Connection:** This dichotomy reflects that $-1$ is a quadratic residue mod p iff $p \equiv 1 \pmod{4}$.

### 3. Legendre-Weighted B Sum (B-Gauss Connection)

**Theorem:** For odd prime p,
$$\sum_{k=1}^{p-1} \left(\frac{k}{p}\right) B(p,k) = \beta(p) \cdot \sqrt{p} \cdot \begin{cases} \cos(\pi/p) & \text{if } p \equiv 1 \pmod{4} \\ \sin(\pi/p) & \text{if } p \equiv 3 \pmod{4} \end{cases}$$

where $\left(\frac{k}{p}\right)$ is the Legendre symbol.

**Proof:**
$$\sum_{k=1}^{p-1} \left(\frac{k}{p}\right) B(p,k) = \beta(p) \sum_{k=1}^{p-1} \left(\frac{k}{p}\right) \cos\frac{(2k-1)\pi}{p}$$

The cosine sum equals $\text{Re}[e^{-i\pi/p} \cdot G_p]$ where $G_p$ is the quadratic Gauss sum:
$$G_p = \sum_{k=1}^{p-1} \left(\frac{k}{p}\right) e^{2\pi i k/p}$$

Using the classical result $G_p^2 = \left(\frac{-1}{p}\right) p$:
- $p \equiv 1 \pmod{4}$: $G_p = \sqrt{p}$ (real)
- $p \equiv 3 \pmod{4}$: $G_p = i\sqrt{p}$ (purely imaginary)

### 4. Quadratic Residue Distribution

**Observation:** For prime p, comparing B-values over quadratic residues (QR) vs non-residues (QNR):

| p mod 4 | Sum over QR vs QNR | Pattern |
|---------|-------------------|---------|
| 1 | Sum_QR > Sum_QNR | Difference grows with p |
| 3 | Sum_QR ≈ Sum_QNR | Nearly equal |

The difference $\sum_{k \in QR} B(p,k) - \sum_{k \in QNR} B(p,k)$ is always positive but varies with p.

## Connection to RH/GRH

**Question:** Do these results help with the Riemann Hypothesis or Generalized RH?

**Answer:** Not directly.

- The B-Gauss connection is a **finite** sum over k (for fixed p)
- L-functions $L(s, \chi)$ are **infinite** sums over n
- Different mathematical objects

The triviality we found for RH (cosh - sinh = e^{-θ}) applies equally to GRH. The Legendre weighting doesn't escape the fundamental limitation.

**What these results DO show:**
- B(n,k) "knows" about arithmetic structure
- Primitive roots, characters, and reciprocity are encoded in lobe geometry
- The Chebyshev polygon framework connects naturally to classical number theory

## Formulas Summary

| Object | Formula |
|--------|---------|
| Primitive sum | $\sum_{\gcd(k,n)=1} B(n,k) = \varphi(n) + \beta(n) \mu(n) \cos(\pi/n)$ |
| Sign asymmetry | $A(p) = -2 \cdot \mathbf{1}_{p \equiv 1 (4)}$ |
| Legendre-B sum | $\sum (k|p) B(p,k) = \beta(p) \sqrt{p} \cdot \text{trig}(\pi/p)$ |
| Cosine-Gauss | $\sum (k|p) \cos\frac{(2k-1)\pi}{p} = \sqrt{p} \cdot \text{trig}(\pi/p)$ |

## Open Questions

1. Is there a direct formula for $\sum_{k \in QR} B(p,k)$ involving class numbers?
2. Can the B-Gauss connection be extended to general Dirichlet characters?
3. What is the distribution of B(p,k) values as p → ∞?

## Code Snippets

```mathematica
(* B function *)
beta[n_] := (Sin[Pi/n] - Pi/n Cos[Pi/n]) / (2 Sin[Pi/n]^3)
B[n_, k_] := 1 + beta[n] * Cos[(2k-1) Pi/n]

(* Primitive sum *)
primSum[n_] := Sum[If[GCD[k,n] == 1, B[n,k], 0], {k, 1, n}]

(* Verify formula *)
predicted[n_] := EulerPhi[n] + beta[n] * MoebiusMu[n] * Cos[Pi/n]

(* Sign asymmetry for prime p *)
asymmetry[p_] := Module[{signs},
  signs = Sign[B[p, #] - 1] & /@ Range[p-1];
  Count[signs, 1] - Count[signs, -1]
]

(* Legendre-weighted sum *)
legendreB[p_] := Sum[JacobiSymbol[k, p] * B[p, k], {k, 1, p-1}]
```

## Files

- `README.md` - This documentation
