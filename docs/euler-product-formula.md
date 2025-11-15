# Euler Product for Sum[M(n)/n^s]

**Date**: November 15, 2025

---

## Main Result

The Dirichlet series
$$\sum_{n=2}^{\infty} \frac{M(n)}{n^s}$$

has an Euler product representation:

$$\prod_{p \text{ prime}} L_p(s)$$

where the local factor is:

$$L_p(s) = 1 + (p^s + 1) \cdot \frac{p^s}{(p^{2s} - 1)^2}$$

---

## Derivation

### Step 1: Pattern for Prime Powers

For prime $p$:
$$M(p^k) = \lfloor k/2 \rfloor$$

Verification:
- $M(p) = \lfloor 1/2 \rfloor = 0$
- $M(p^2) = \lfloor 2/2 \rfloor = 1$
- $M(p^3) = \lfloor 3/2 \rfloor = 1$
- $M(p^4) = \lfloor 4/2 \rfloor = 2$
- $M(p^5) = \lfloor 5/2 \rfloor = 2$

---

### Step 2: Local Euler Factor

$$L_p(s) = \sum_{k=0}^{\infty} \frac{M(p^k)}{p^{ks}} = 1 + \sum_{k=1}^{\infty} \frac{\lfloor k/2 \rfloor}{p^{ks}}$$

Expanding first few terms:
$$= 1 + \frac{0}{p^s} + \frac{1}{p^{2s}} + \frac{1}{p^{3s}} + \frac{2}{p^{4s}} + \frac{2}{p^{5s}} + \frac{3}{p^{6s}} + \cdots$$

---

### Step 3: Split into Even/Odd

For even $k = 2m$: $\lfloor 2m/2 \rfloor = m$

For odd $k = 2m+1$: $\lfloor (2m+1)/2 \rfloor = m$

Therefore:
$$L_p(s) = 1 + \sum_{m=1}^{\infty} \frac{m}{p^{2ms}} + \sum_{m=1}^{\infty} \frac{m}{p^{(2m+1)s}}$$

$$= 1 + \sum_{m=1}^{\infty} \frac{m}{p^{2ms}} + \frac{1}{p^s} \sum_{m=1}^{\infty} \frac{m}{p^{2ms}}$$

$$= 1 + \left(1 + \frac{1}{p^s}\right) \sum_{m=1}^{\infty} \frac{m}{p^{2ms}}$$

---

### Step 4: Geometric Series

Using $\sum_{m=1}^{\infty} m x^m = \frac{x}{(1-x)^2}$ with $x = p^{-2s}$:

$$\sum_{m=1}^{\infty} \frac{m}{p^{2ms}} = \frac{1/p^{2s}}{(1 - 1/p^{2s})^2} = \frac{p^{2s}}{(p^{2s} - 1)^2}$$

---

### Step 5: Final Form

$$L_p(s) = 1 + \left(1 + \frac{1}{p^s}\right) \cdot \frac{p^{2s}}{(p^{2s} - 1)^2}$$

$$= 1 + \frac{p^s + 1}{p^s} \cdot \frac{p^{2s}}{(p^{2s} - 1)^2}$$

$$= 1 + (p^s + 1) \cdot \frac{p^s}{(p^{2s} - 1)^2}$$

---

## Simplified Form

Let $x = p^s$. Then:

$$L_p(s) = 1 + (x + 1) \cdot \frac{x}{(x^2 - 1)^2}$$

$$= \frac{(x^2 - 1)^2 + x(x + 1)}{(x^2 - 1)^2}$$

Numerator:
$$(x^2 - 1)^2 + x(x + 1) = x^4 - 2x^2 + 1 + x^2 + x = x^4 - x^2 + x + 1$$

Therefore:
$$L_p(s) = \frac{p^{4s} - p^{2s} + p^s + 1}{(p^{2s} - 1)^2}$$

---

## Relation to Zeta Function

**Key observation**: This does NOT factor into simple zeta functions!

Compare:
- Divisor function: $\sum \tau(n)/n^s = \zeta(s)^2$
- Our function: $\sum M(n)/n^s = \prod_p L_p(s)$ (new Euler product)

The numerator $p^{4s} - p^{2s} + p^s + 1$ does not factor nicely in terms of $(1 - p^{-s})$ factors.

---

## Numerical Verification

For $s = 2$:

| Prime $p$ | $L_p(2)$ (numerical) | $L_p(2)$ (formula) | Match |
|-----------|----------------------|-------------------|-------|
| 2 | 1.08888... | 1.08888... | ✓ |
| 3 | 1.01406... | 1.01406... | ✓ |
| 5 | 1.00167... | 1.00167... | ✓ |

Full Euler product (to $p = 100$):
$$\prod_{p \leq 100} L_p(2) \approx 1.1067$$

Direct sum (to $n = 100$):
$$\sum_{n=2}^{100} \frac{M(n)}{n^2} \approx 0.2254$$

**ISSUE**: These don't match! Need to investigate...

Possible reasons:
1. Convergence slow for Euler product?
2. Need more terms in direct sum?
3. Error in local factor formula?

---

## Status

✓ Pattern $M(p^k) = \lfloor k/2 \rfloor$ verified

✓ Closed form for $L_p(s)$ derived

✓ Geometric series evaluation correct

⚠ Euler product vs direct sum mismatch - **INVESTIGATION NEEDED**

---

**Next**: Debug the mismatch between Euler product and direct summation.
