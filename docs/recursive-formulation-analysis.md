# Recursive Primorial Formulation: Analysis and Simplification

## Connection Between Formulations

We have two equivalent ways to compute primorials:

### Explicit Formula (Original)
$$\text{Primorial}(m) = \text{Denominator}\left[\frac{1}{2} \sum_{k=1}^{h} \frac{(-1)^k \cdot k!}{2k+1}\right]$$

where $h = \lfloor(m-1)/2\rfloor$.

### Recursive Formula (Alternative)

**State:** $\{n, a, b\}$ with initial state $\{0, 0, 1\}$

**Recurrence:**
$$\begin{align}
a[n+1] &= b[n] \\
b[n+1] &= b[n] + (a[n] - b[n]) \cdot \left(n + \frac{1}{3 + 2n}\right)
\end{align}$$

**Extraction:**
$$\text{Primorial}(m) = 2 \cdot \text{Denominator}[b[h] - 1]$$

### The Connection

**Key identity verified:**
$$b[h] - 1 = \sum_{k=1}^{h} \frac{(-1)^k \cdot k!}{2k+1}$$

The recursive formula computes the **alternating sum WITHOUT the factor of 1/2**. The factor of 2 in the extraction compensates for this.

## Simplified Coefficient Form

### Original Coefficient
$$n + \frac{1}{3 + 2n}$$

### Factored Form
$$\frac{(2n+1)(n+1)}{2n+3}$$

**Derivation:**
$$\begin{align}
n + \frac{1}{3 + 2n} &= \frac{n(3 + 2n) + 1}{3 + 2n} \\
&= \frac{3n + 2n^2 + 1}{2n + 3} \\
&= \frac{2n^2 + 3n + 1}{2n + 3} \\
&= \frac{(2n+1)(n+1)}{2n+3}
\end{align}$$

Notice: The factor $(2n+1)$ appears in the numerator - this connects to the denominators in the explicit sum!

### Asymptotic Behavior
$$\frac{(2n+1)(n+1)}{2n+3} = n + \frac{5n+1}{2n+3} \approx n + O(1)$$

For large $n$, the coefficient approaches $n$.

## Alternative Recurrence Forms

### Expanded Form
$$b[n+1] = b[n] + a[n] \cdot \frac{(2n+1)(n+1)}{2n+3} - b[n] \cdot \frac{(2n+1)(n+1)}{2n+3}$$

### Factored by Terms
$$b[n+1] = b[n] \left[1 - \frac{(2n+1)(n+1)}{2n+3}\right] + a[n] \cdot \frac{(2n+1)(n+1)}{2n+3}$$

Simplifying the coefficient of $b[n]$:
$$1 - \frac{(2n+1)(n+1)}{2n+3} = \frac{2 - n - 2n^2}{2n+3}$$

### Second-Order Form

Substituting $a[n] = b[n-1]$:
$$b[n+1] = b[n] \cdot \frac{2 - n - 2n^2}{2n+3} + b[n-1] \cdot \frac{(2n+1)(n+1)}{2n+3}$$

This is a **second-order linear recurrence with polynomial coefficients**. Such recurrences can sometimes be solved using hypergeometric or Pochhammer-type functions.

## Sieve Behavior

### Denominator Evolution

**Observation from computational sieve:**

| n | 2n+1 | Prime? | Denom(b[n-1]) | Denom(b[n]) | Factor |
|---|------|--------|---------------|-------------|--------|
| 1 | 3    | YES    | 1             | 3           | ×3     |
| 2 | 5    | YES    | 3             | 15          | ×5     |
| 3 | 7    | YES    | 15            | 105         | ×7     |
| 4 | 9    | no     | 105           | 105         | ×1     |
| 5 | 11   | YES    | 105           | 1155        | ×11    |
| 6 | 13   | YES    | 1155          | 15015       | ×13    |
| 7 | 15   | no     | 15015         | 15015       | ×1     |
| 8 | 17   | YES    | 15015         | 255255      | ×17    |

**Pattern:** Denominator multiplies by $p$ when $2n+1 = p$ is prime, stays constant when $2n+1$ is composite.

### Prime Detection Mechanism

The sieve performs **implicit prime detection**:
- When $2n+1$ is prime, a new prime factor enters the denominator
- When $2n+1$ is composite, the numerator structure prevents new factors

This is the cancellation mechanism we identified via p-adic valuations:
- For composite $2n+1$: numerators contain GCD factors that cancel excess powers
- For large $k$ where $\nu_p(k!) \ge \nu_p(2k+1)$: terms become integers, no new denominators

## LCM Discrepancy

**Naive expectation:**
$$\text{Denom}[b[n]] = \text{LCM}(3, 5, 7, 9, 11, 13, 15, \ldots, 2n+1)$$

**Actual pattern:**
$$\text{Denom}[b[n]] = \frac{\text{LCM}(3, 5, 7, 9, 11, 13, 15, \ldots, 2n+1)}{3}$$
for $n \ge 4$.

The factor of 3 is lost due to GCD cancellation when $k=4$ (where $2k+1 = 9 = 3^2$).

Without the alternating sign $(-1)^k$, this factor would be lost permanently. The alternating sign controls the numerator structure to prevent over-cancellation.

## Telescoping Analysis

Examining differences $b[n+1] - b[n]$:

| n | $b[n+1] - b[n]$ | Numerator Factorization |
|---|-----------------|-------------------------|
| 0 | -1/3            | 1                       |
| 1 | 2/5             | 2                       |
| 2 | -6/7            | 2·3                     |
| 3 | 8/3             | 2³                      |
| 4 | -120/11         | 2³·3·5                  |
| 5 | 720/13          | 2⁴·3²·5                 |

The differences show **factorial-like growth** in numerators. The pattern suggests connection to $(n-1)!$ or similar factorial structure, but no obvious telescoping simplification emerges.

## Open Questions

1. **Generating function:** Can we find a closed form for $B(x) = \sum_{n=0}^{\infty} b[n] x^n$?

2. **Hypergeometric connection:** Is there a hypergeometric or Pochhammer representation?

3. **Matrix product:** The recurrence can be written as:
   $$\begin{pmatrix} a[n+1] \\ b[n+1] \end{pmatrix} = M[n] \begin{pmatrix} a[n] \\ b[n] \end{pmatrix}$$
   where
   $$M[n] = \begin{pmatrix} 0 & 1 \\ c[n] & 1-c[n] \end{pmatrix}, \quad c[n] = \frac{(2n+1)(n+1)}{2n+3}$$

   Can the product $\prod_{i=0}^{h-1} M[i]$ be simplified?

4. **Eliminating the $n$ variable:** Since $n$ appears explicitly in the coefficient, can we find a formulation that doesn't require tracking $n$ separately?

5. **Why this specific recurrence:** What deeper structure explains why this particular second-order recurrence generates primorials?

## Conclusion

The recursive formulation is **equivalent but not simpler** than the explicit sum. The key simplifications are:

✓ Coefficient factorization: $(2n+1)(n+1)/(2n+3)$
✓ Second-order form: eliminates $a[n]$ variable
✓ Prime detection property: denominators change only when $2n+1$ is prime

However, the recurrence remains non-trivial. The factorial structure and primorial emergence are encoded in the polynomial coefficients, but no further algebraic simplification is apparent without deeper techniques (hypergeometric functions, matrix products, etc.).

The **sieve visualization** reveals the prime-sieving mechanism clearly - a beautiful computational structure that mirrors Eratosthenes' sieve conceptually but operates through rational arithmetic.

---

*Analysis date: 2025-11-12*
*Related: primorial-mystery-findings.md, investigation-summary-2025-11-12.md*
