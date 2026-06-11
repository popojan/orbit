# Closed Form for the Left Limit C⁻(p/q): the Sharpened-Barrier System

**Date:** 2026-06-11 (continuation session)
**Status:** 🔬 NUMERICALLY VERIFIED (25/25 rationals, down to 6×10⁻¹¹); proof
strategy established (coupling + Chernoff), formal write-up pending
**Origin:** the ρ⁻ = ρᵏ integer discovery of the morning session

---

## Statement

Let $\rho(s,j)$ be the ruin probability of the periodic Sturmian walk for
slope $p/q$ (paper framework: rises $r_j = \lfloor p(j{+}1)/q\rfloor -
\lfloor pj/q\rfloor$, ansatz $\rho(s,j) = \sum_i c_i A_j^{(i)} t_i^s$,
boundary $\rho(-1,j) = 1$ for all $j$, and
$C(p/q) = (1 - \rho(s_0, j_0))/2$ with $s_0 = \lfloor p/q \rfloor$,
$j_0 = 1$).

Define the **sharpened system** $\tilde\rho$: identical interior recursion,
identical roots $t_i$ and amplitudes $A_j^{(i)}$, but absorbing level **0 at
phase 0** and $-1$ elsewhere; i.e. the phase-0 row of the boundary system
becomes $\sum_i c_i A_0^{(i)} = 1$ (the factor $1/t_i$ is dropped). Then

$$\boxed{\;C^-(p/q) = \frac{1 - \tilde\rho(s_0, j_0)}{2}, \qquad
J(p/q) = \frac{\tilde\rho(s_0, j_0) - \rho(s_0, j_0)}{2}\;}$$

In particular $J(p/q)$ is **algebraic for every rational slope** — the
entire left-jump hierarchy of $C(\alpha)$ has a closed form.

## Derivation of the limit object

**Column-drop lemma.** For $x = p/q - \varepsilon$, $\varepsilon \to 0^+$:
$\lfloor x m \rfloor = \lfloor (p/q) m \rfloor - 1$ exactly at columns
$q \mid m$ (fractional part $0$ drops under any negative perturbation), and
is unchanged at all other columns for $m < 1/(q\varepsilon)$ (fractional
parts $\geq 1/q$ survive). Hence on any fixed horizon the below-perturbed
gap process is

$$\tilde s(\tau) = s(\tau) - [\,q \mid (\tau+1)\,],$$

the original gap with a one-unit dip in force throughout every $q$-th
column. Ruin of the dipped walk ⟺ $s \leq -1$ anywhere, or $s = 0$ while
at phase $0$ — the sharpened barrier.

**Integer case ($q = 1$):** every column dips, $\tilde s = s - 1$
uniformly, and the modified boundary gives $\tilde\rho(s) = \rho^s$ —
recovering the machine-precision-verified $1 - 2C^-(k) = \rho_k^k$,
i.e. $C^-(k) = (\tau_k - 1)/2$.

## Proof strategy (coupling)

Let $x_K \uparrow p/q$ be the CF-extension family ($\varepsilon_K =
1/(qq_K)$). Since $C$ is monotone, the left limit exists and is
approach-independent, so the family suffices.

1. **Monotone direction:** $\lfloor x_K m \rfloor \leq
   \lfloor (p/q)m \rfloor - [q \mid m]$ for all $m$, so under the
   common coin-flip coupling $s_K(\tau) \leq \tilde s(\tau)$ pointwise ⟹
   survival$(x_K) \leq$ survival$(\tilde{\;})$ ⟹ $C^- \leq \tilde C$.
2. **Tail direction:** $s_K \equiv \tilde s$ on columns $m \leq q_K$;
   they differ only beyond. The probability that the $\tilde{\;}$-surviving
   walk ever returns within distance 1 of the barrier after $\sim 2q_K$
   coin flips is bounded by Chernoff: the step distribution
   ($+r_j$ or $-1$, fair coin) has positive drift, so
   $P(s_t \leq c) \leq e^{\theta c}\lambda_\theta^{\,t}$ with
   $\lambda_\theta < 1$; summing over later columns gives a bound
   $\to 0$ as $K \to \infty$. ⟹ $\tilde C - C(x_K) \to 0$.

Together: $C^-(p/q) = \tilde C$. The argument is rigorous at the level of
the periodic-walk survival probabilities; transferring to the lattice-path
constant uses the paper's identification $C = (1-\rho)/2$
(eq. C-rational; verified there to 20+ digits against path counts).

## Verification

- **25/25 rationals** (`12_general_left_limit_formula.wl`): the formula
  matches every measured left limit within that measurement's accuracy —
  residuals 3×10⁻⁸–4×10⁻⁷ for the sharp ladders, up to ~2×10⁻⁴ exactly for
  the sloppiest extrapolations (14/13). It also retro-explains the script-07
  DP crossover value for 701/651 (≈ 0.058801 = the true limit).
- **Precision test** (`13_formula_precision_test.wl`): deep uniform ladders
  K = {22, 26, 30}: 8/5 agrees to **6×10⁻¹¹**, 5/3 to 4×10⁻⁹.
- **Exact example** (`13b_exact_J32.wl`): for 3/2 (sub-unit roots
  0.43691, 0.71974 — both real):
  - $C^-(3/2)$: minimal polynomial $64x^6+256x^5+336x^4+56x^3-84x^2+16x-1$
  - $J(3/2) = 0.0272922840\ldots$: minimal polynomial
    $64x^6-896x^5+4336x^4-7688x^3+2100x^2-528x+13$
  (measured ladder estimate 0.02728 was accurate to 1×10⁻⁵.)

## Paper erratum #2 (found en route)

The Example "slope 3/2" displayed the reduced quartic as
$t^4+2t^3-2t^2-2t+1$ — wrong: that polynomial vanishes at $t = 1$ and
factors as $(t^2+2t-1)(t^2-1)$, unrelated to the master equation. Correct:
$t^5-4t^2+4t-1 = (t-1)(t^4+t^3+t^2-3t+1)$, and the two sub-unit roots are
**real** (the "complex conjugate pair" claim belonged to the wrong
quartic). Fixed in the paper together with the closed-form addition.

## Consequences

1. **Open direction "closed form for C⁻(p/q)": RESOLVED** (modulo the
   formal write-up of the coupling argument).
2. The jump law $J(p/q) = (\tilde\rho - \rho)/2$ is a **one-row
   perturbation** of the boundary system — Cramer's rule gives $J$ as a
   ratio of determinants in the root data, opening the decay law
   $c(\alpha, q) = q^2 J$ to direct asymptotic analysis (replaces ladder
   extrapolation entirely; exact sum rules now computable for any q).
3. The TV ↔ C analogy closes elegantly: both functions are
   right-continuous with left jumps at every rational; TV's jump is
   $2/((q-q^*)q)$ from the CF subdivision identity, C's jump is
   $(\tilde\rho-\rho)(s_0,j_0)/2$ from a one-unit barrier sharpening at the
   zero-fractional-part columns.
