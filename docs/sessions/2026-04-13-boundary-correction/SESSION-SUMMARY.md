# Session Summary: Boundary Correction for C(α)

**Date:** 2026-04-13

## What matters (for the project)

The project studies $C(\alpha)$ — the asymptotic constant of lattice paths under barrier $y \leq \lfloor\alpha x\rfloor$. The fundamental objects are the **exact algebraic equations** that determine $C$:

| Slope | Defining equation | $C$ is... |
|-------|-------------------|-----------|
| Integer $k$ | $\rho^{k+1} = 2\rho - 1$ | $1 - \rho$, algebraic degree $k$ |
| Rational $p/q$ | $(2t-1)^q = t^{p+q}$ + $q \times q$ boundary | algebraic, degree grows with $p+q$ |
| Half-integer $p/2$ | **NEW:** $C = (1-\sqrt{\rho_+})(1+\sqrt{\rho_-})$ | closed form from 2 equations |
| Irrational | limit of rational convergents | unknown (algebraic? transcendental?) |

The **bridge identity** $C_k = 1 - 1/\tau_k$ (connecting to $k$-nacci constants) is the paper's main result. Everything below supports or extends it.

## New results (this session)

### 1. Exact closed form for $q = 2$ — THE main new result

$$C(p/2) = (1 - \sqrt{\rho_+})(1 + \sqrt{\rho_-})$$

where $\rho_+$ solves $\rho^{(p+2)/2} = 2\rho - 1$ and $\rho_-$ solves $\rho^{(p+2)/2} = 1 - 2\rho$.

- Verified to 15 digits for all odd $p$ from 3 to 13
- Derived from explicit solution of the $2 \times 2$ boundary system
- Transfer coefficients simplify to $f_i = \pm 1/\sqrt{r_i}$
- Factorizes as $C = C_{\text{smooth}} \cdot (1+\sqrt{\rho_-})/(1+\sqrt{\rho_+})$

### 2. Master equation is arrangement-invariant

All periodic barriers with slope $p/q$ share the same master equation $(2t-1)^q = t^{p+q}$. Step ordering within the period affects only boundary conditions, not the equation.

### 3. Universal sandwich (upper bound in paper, lower bound new)

$$1/2 - 2^{-\alpha} \leq C(\alpha) \leq C_{\text{smooth}}(\alpha) = 1 - \rho_+(\alpha)$$

Upper: equality iff $\alpha \in \mathbb{Z}$. Added to paper. Lower: equality at $\alpha = 1$. Verified for 196 slopes. Derived via log-linearization: $2 \times \text{middle} - \text{upper}$ in log-space $y = \ln(1/(1/2-C))$.

### 4. Fuss-Catalan formula for $k$-nacci constants (unified)

$\tau_k = 2/G_{k+1}(2^{-(k+1)})$ where $G_r$ is the $r$-ary tree generating function. Three-line proof via Lagrange inversion.

### 5. Paper errata: Example 2.1 table corrected (n=7 values for k=2,3,4)

## What does NOT work (adversarial assessment)

### Universal lower bound: FOUND

Via log-linearization (transform $y = \ln(1/(1/2 - C))$), Jan's intuition "$2 \times \text{middle} - \text{upper}$" works in the transformed space:

- Upper line: $y \sim (\alpha + 2)\ln 2$
- Middle (staircase center): $y \sim (\alpha + 1)\ln 2$
- Lower = $2 \times \text{middle} - \text{upper}$: $y \sim \alpha \ln 2$

Inverting: **$C(\alpha) \geq 1/2 - 2^{-\alpha}$**, verified for 196 slopes ($q \leq 9$, $\alpha \leq 8$), zero failures. Equality at $\alpha = 1$.

### Failed attempts (for the record)

- $C_{q2}(\alpha)$ as lower bound: fails for $q \geq 3$ (overestimates $C$)
- $2C_{q2} - C_{\text{smooth}}$: almost works (93/105) but fails near integers from below
- $C_{\text{smooth}}(\alpha - 1/2)$: correct asymptotic shift but fails at finite $\alpha$ (58/182)
- Asymptotic formula $1/2 - 2^{-(\alpha+3/2)}$ inverted from log-space: invalid for $\alpha < 3$ (overshoots $C$)

### Product formula doesn't generalize beyond $q = 2$

- $q = 3$: works only for $p \equiv 1 \pmod{3}$ (specific Sturmian symmetry)
- $q \geq 4$: no rational exponent gives an exact product
- The $q \times q$ boundary system is always solvable but doesn't factorize into a product

## What IS valuable

1. **Universal sandwich** $1/2 - 2^{-\alpha} \leq C(\alpha) \leq 1 - \rho_+(\alpha)$ — clean, simple, proven
2. **The $q = 2$ closed form** is a genuine new algebraic result, publishable
3. **The log-linearization** reveals the geometric structure: two parallel lines with slope $\ln 2$, staircase between them, flat steps of height $\ln 2$ and width 1
4. **$L(\theta) = 1/4$**: the limit $\lim_{k\to\infty} 2^k(1/2 - C(k+\theta)) = 1/4$ for all $\theta$ — universal flatness
5. **The arrangement invariance** of the master equation is a clean structural insight
6. **The OEIS deep dive** confirms the paper's bridge is new and identifies related independent work (Kotesovec, Spezia, Llorente)
7. **Exact boundary system computation** for general $q$ — fast, precise, replaces slow Richardson extrapolation

## For the paper

Already added: upper bound proposition + gap table + remark (Section 6).

To add: lower bound $C \geq 1/2 - 2^{-\alpha}$ (one line, elegant).

Could add: $q = 2$ closed form as a theorem (if we want to expand the paper). But the paper is a survey — the $q = 2$ result might fit better in a follow-up.

## Files

- `README.md` — session overview with $q=2$ theorem and generalization attempts
- `LOG-LINEARIZATION.md` — asymptotic analysis in transformed coordinates
- `scripts/01-31` — computational scripts (WolframScript)
- `../2026-04-11-polynomial-invariants/OEIS-DEEP-DIVE.md` — OEIS cross-reference analysis
