# Global Dirichlet Series for M(n)

**Date**: November 15, 2025
**Status**: Work in progress - seeking connection to ζ(s)

---

## Main Object

Define the **M-series**:
$$L_M(s) = \sum_{n=2}^{\infty} \frac{M(n)}{n^s}$$

where $M(n) = \#\{d : d \mid n, \, 2 \leq d \leq \sqrt{n}\}$.

---

## Key Properties

### 1. M(n) is NOT Multiplicative

**Counterexample**:
- $M(6) = 1$ (divisor: 2)
- $M(2) \cdot M(3) = 0 \cdot 0 = 0 \neq 1$

Therefore **standard Euler product does NOT apply**.

---

### 2. Alternative Representation

Using $M(n) = \lfloor (\tau(n) - 1)/2 \rfloor$:

$$L_M(s) = \sum_{n=2}^{\infty} \frac{\lfloor (\tau(n) - 1)/2 \rfloor}{n^s}$$

This is **NOT** a simple function of $\sum \tau(n)/n^s = \zeta(s)^2$ due to the floor.

---

### 3. Divisor Sum Representation

Key insight: $M(n)$ counts divisors in a specific range.

$$M(n) = \sum_{\substack{d \mid n \\ 2 \leq d \leq \sqrt{n}}} 1$$

This can be rewritten as:
$$M(n) = \sum_{d \mid n} \mathbb{1}_{[2, \sqrt{n}]}(d)$$

where $\mathbb{1}_{[2, \sqrt{n}]}(d) = 1$ if $2 \leq d \leq \sqrt{n}$, else 0.

---

## Attempted Approaches

### Approach 1: Double Sum Over Divisors

$$L_M(s) = \sum_{n=2}^{\infty} \frac{1}{n^s} \sum_{\substack{d \mid n \\ 2 \leq d \leq \sqrt{n}}} 1$$

Interchange sums (valid for $s > 1$):
$$= \sum_{d=2}^{\infty} \sum_{\substack{n : d \mid n \\ d \leq \sqrt{n}}} \frac{1}{n^s}$$

For fixed $d$, the condition "$d \mid n$ and $d \leq \sqrt{n}$" means:
$$n = kd \quad \text{with} \quad d \leq \sqrt{kd} \implies d^2 \leq kd \implies d \leq k$$

So:
$$\sum_{\substack{n : d \mid n \\ d \leq \sqrt{n}}} \frac{1}{n^s} = \sum_{k=d}^{\infty} \frac{1}{(kd)^s} = \frac{1}{d^s} \sum_{k=d}^{\infty} \frac{1}{k^s}$$

Therefore:
$$L_M(s) = \sum_{d=2}^{\infty} \frac{1}{d^s} \sum_{k=d}^{\infty} \frac{1}{k^s}$$

---

### Approach 2: Relation to Zeta via Tail Sums

Define **tail zeta function**:
$$\zeta_{\geq m}(s) = \sum_{k=m}^{\infty} \frac{1}{k^s} = \zeta(s) - \sum_{k=1}^{m-1} \frac{1}{k^s}$$

Then:
$$L_M(s) = \sum_{d=2}^{\infty} \frac{\zeta_{\geq d}(s)}{d^s}$$

$$= \sum_{d=2}^{\infty} \frac{1}{d^s} \left[\zeta(s) - \sum_{k=1}^{d-1} \frac{1}{k^s}\right]$$

$$= \zeta(s) \sum_{d=2}^{\infty} \frac{1}{d^s} - \sum_{d=2}^{\infty} \frac{1}{d^s} \sum_{k=1}^{d-1} \frac{1}{k^s}$$

$$= \zeta(s) [\zeta(s) - 1] - \sum_{d=2}^{\infty} \sum_{k=1}^{d-1} \frac{1}{(kd)^s}$$

The double sum can be rewritten by interchanging order:
$$\sum_{d=2}^{\infty} \sum_{k=1}^{d-1} \frac{1}{(kd)^s} = \sum_{k=1}^{\infty} \sum_{d=k+1}^{\infty} \frac{1}{(kd)^s}$$

$$= \sum_{k=1}^{\infty} \frac{1}{k^s} \sum_{d=k+1}^{\infty} \frac{1}{d^s} = \sum_{k=1}^{\infty} \frac{\zeta_{\geq k+1}(s)}{k^s}$$

---

### Simplification

$$L_M(s) = \zeta(s)[\zeta(s) - 1] - \sum_{k=1}^{\infty} \frac{\zeta_{\geq k+1}(s)}{k^s}$$

But wait! The second sum is almost $L_M(s)$ itself (shifted indices).

Let me denote:
$$S(s) = \sum_{k=1}^{\infty} \frac{\zeta_{\geq k+1}(s)}{k^s}$$

Then:
$$S(s) = \sum_{k=1}^{\infty} \frac{1}{k^s} \sum_{d=k+1}^{\infty} \frac{1}{d^s}$$

Hmm, this is getting circular. Let me try a different manipulation.

---

## Numerical Values

For $s = 2$:

| Quantity | Value |
|----------|-------|
| $L_M(2)$ | 0.2487 (computed to $n=10000$) |
| $\zeta(2)$ | 1.6449 |
| $\zeta(2)^2$ | 2.7058 |
| $\zeta(2)[\zeta(2)-1]$ | 1.0611 |

**Observation**: $L_M(2)$ is much smaller than simple zeta products.

---

## Alternative: Mellin Transform

Another approach is to express $M(n)$ using indicator functions and Mellin transforms.

For $d \leq \sqrt{n}$, we have:
$$\mathbb{1}_{d \leq \sqrt{n}} = \mathbb{1}_{d^2 \leq n}$$

Using this:
$$L_M(s) = \sum_{n=2}^{\infty} \frac{1}{n^s} \sum_{\substack{d \mid n \\ d \geq 2}} \mathbb{1}_{d^2 \leq n}$$

This might be expressible via Mellin convolution.

---

## Status

✓ Derived double sum representation
✓ Connected to tail zeta functions
⚠ **Circular recursion** appeared - needs resolution
⚠ Numerical values suggest non-trivial relationship to $\zeta(s)$

**Next**: Resolve the recursion or find Mellin transform expression.

---

**To be continued...**
