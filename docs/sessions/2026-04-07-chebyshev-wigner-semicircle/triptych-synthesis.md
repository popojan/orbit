# Triptych Synthesis: Periodic — Counting — Hyperbolic

**Date:** 2026-04-07
**Status:** Conceptual synthesis, testable conjectures at the end

## The three worlds

The same trichotomy appears in three independent contexts within this repository:

### 1. Successor axiom (2026-04-04 session)

Chebyshev parameter $c = (5o-1)/(4o)$ in the recurrence $f_{k+1} = 2c\,f_k - f_{k-1}$:

| Regime | $c$ | Behavior |
|:---:|:---:|:---|
| Periodic | $c < 1$ | $f_k = A\sin(k\theta + \varphi)$ — algebraic sine wave |
| Counting | $c = 1$ | $f_k = k$ — natural numbers |
| Hyperbolic | $c > 1$ | $f_k = A\sinh(k\alpha + \beta)$ — exponential growth |

### 2. Continued fractions

| Regime | CF type | Example | Theorem |
|:---:|:---|:---|:---|
| Periodic | $[a_0; \overline{a_1, \ldots, a_L}]$ | $\sqrt{D}$ | Lagrange (1770): periodic CF $\iff$ quadratic irrational |
| Counting | $[a_0; f(1), f(2), f(3), \ldots]$, $f$ linear | $e$ | Euler (1737): arithmetic CF $\to$ $e$ via Bessel |
| Hyperbolic | $a_n$ growing exponentially | Liouville numbers | Unbounded CF $\to$ transcendental (usually) |

### 3. Ballot product (this session)

| Phase | $y^*(x)$ | Ballot $b_D(x)$ | Character |
|:---:|:---:|:---:|:---|
| 0 | 0 | $1/x$ (decaying) | Hyperbolic deficit: $-\log(n!)$ |
| 1 | 1 | $1$ (flat) | Transition |
| 2 | 2 | $(x+1)/2$ (linear growth) | Counting: arithmetic progression |

Boundary between phases: the Pell hyperbola $x^2 - Dy^2 = 1$ (periodic world).

Crossing constant: $e$ (counting world).

## The interface

In all three contexts, the **counting regime sits at the boundary** between periodic
and hyperbolic:

```
     PERIODIC          COUNTING          HYPERBOLIC
   (oscillatory)      (interface)       (exponential)
                           |
   CF(sqrt(D))        CF(e)            CF(Liouville)
   Lagrange           Euler            unbounded
   c < 1              c = 1            c > 1
   Pell hyperbola     ballot arith.    factorial growth
                           |
                      e = 2.71828...
```

The constant $e$ is the **characteristic constant of the interface**:

- Euler: $e$ is the limit of arithmetic continued fractions
- Stirling: $n! \sim (n/e)^n$ — $e$ governs the counting $\to$ exponential transition
- Ballot: the crossing where counting compensates periodic occurs at $b/n \to e$
- Successor: at $c = 1$ (counting regime), the recurrence gives $1, 2, 3, \ldots$
  and $e = \lim(1 + 1/n)^n$ governs the transition to exponential

## Concrete testable directions

### A. Pell solver via ballot asymptotics

The ballot product identity:
$$\frac{(b+1)!}{n!\;\cdot\;(2n)!\;\cdot\;2^{b-2n}} \approx e^e, \quad b \approx en$$

could potentially be inverted: given $D$ (hence $n = \lfloor\sqrt{D}\rfloor$),
the crossing point $b$ determines where the CF convergents of $\sqrt{D}$ are.

**Test:** For $D$ with long CF period, does the ballot crossing predict
the position of the first CF convergent with $y^* = 2$ more efficiently
than running the CF directly?

**Status:** 🤔 HYPOTHESIS — the crossing is O(n) which is worse than BSGS's O(n^{1/4}).
But the ballot product involves only multiplications of small numbers ((x+1)/2),
not full quadratic form operations.

### B. Wagstaff / primality connection

The Wagstaff numbers $(2^p + 1)/3$ involve the $c > 1$ (hyperbolic) Chebyshev regime.
Primality tests for Wagstaff numbers use Lucas sequences — which are Chebyshev polynomials
at specific $c > 1$ values.

**Test:** Does the ballot product for $D$ related to Wagstaff primes
($D = $ discriminant of the relevant quadratic field) have special structure?
Specifically: does the Shadow Identity (PellBallotQ) detect Wagstaff-related
CF convergents differently?

**Status:** 🤔 HYPOTHESIS — needs specific $D$ values tied to Wagstaff primes.

### C. Arithmetic CF as ballot product

Euler's arithmetic CF $[0; a, a+d, a+2d, \ldots]$ converges to expressions involving $e$.
Our ballot Phase 2 is an arithmetic sequence $(x+1)/2$.

**Test:** Can the convergents of Euler's arithmetic CF be expressed as
ballot numbers on some hyperbola? If $[0; 6, 10, 14, \ldots]$ gives $(e-1)/2$,
is there a $D$ such that the ballot product along the CF path of $\sqrt{D}$
reproduces this sequence?

**Status:** 🤔 HYPOTHESIS — the most promising direction. Would directly
link Euler's 1737 result to Pell geometry.

### D. Cross-world transfer

The ballot product bridges periodic ($\sqrt{D}$, Pell) and counting ($e$, arithmetic).
Can we use this bridge to transfer results?

- **Periodic → Counting:** Use Pell solution structure (known for specific $D$ families
  like $D = m^2 \pm 1$) to derive properties of $e$ approximations.
- **Counting → Periodic:** Use Euler's CF theory for $e$ to predict CF structure
  of $\sqrt{D}$ for specific $D$ ranges.

**Status:** ⏸️ OPEN — most speculative, but the ballot product IS a concrete
bridge object.

## What this session established

1. **Pell-Ballot conjecture** (verified D=2..50): lattice paths above Pell hyperbola
   counted by ballot numbers. Not in existing literature.

2. **Shadow Identity** (verified D=2..50, ~430 convergents): path count to $(p, y^*(p))$
   encodes CF denominator $q$ even when $(p, q)$ is below the hyperbola.

3. **Band invariant:** ballot product depends only on $\lfloor\sqrt{D}\rfloor$,
   not on $D$ itself. Closed form: $(b+1)!/(n! \cdot a! \cdot 2^{b-a+1})$.

4. **Triptych synthesis:** periodic (Lagrange), counting (Euler), hyperbolic (Chebyshev)
   are three regimes of the same Chebyshev parameter, and $e$ is the interface constant
   where counting compensates periodic in the ballot product.
