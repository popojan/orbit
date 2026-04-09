# Born Expansion for Lattice Paths: Structure and Interpretation

**Date:** 2026-04-09 (evening reflection)
**Status:** Speculative interpretation of verified results — documented for chronology

---

## What we found (summary of Results 10–12)

The correction $\Delta_2$ for lattice path counts under an irrational staircase
$\lfloor x/\alpha \rfloor$ decomposes as a **finite, terminating Born expansion**:

$$\Delta_2 = \sum_{k=1}^{a_2} (-1)^{k+1} \sum_{\substack{S \subset [a_2] \\ |S|=k}}
\prod_{i \in S} D_i \cdot \prod_{i \notin S} T_i$$

where each $T_i$ is a Toeplitz convolution (Vandermonde kernel) and each $D_i$
is a correction from the Result 7 formula with **universal offset $A = d_0 - 2$**.

Key structural properties:
- Order $k$ first contributes at depth $d = (k-1) q_1$
- Each order improves accuracy by $\sim 100\times$
- The expansion terminates exactly at order $a_2$ (the second partial quotient)
- Verified across 6 irrationals ($\sqrt{5}, \sqrt{2}, \pi, \mathrm{Im}[\zeta_1], \sqrt{3}, \varphi$)

---

## The physics analogy

The Born expansion is not just a naming coincidence. The structure maps directly
onto scattering theory:

| Lattice paths | Quantum scattering |
|---|---|
| Toeplitz $T(a)$ = $\binom{a+j-s}{j-s}$ | Free propagator (uniform potential) |
| Correction $D_i$ (R7 formula) | Scattering potential at site $i$ |
| Born order $k$ | $k$-fold scattering |
| Vandermonde–Chu convolution | Green's function composition |
| Ballot number $B(p,q)$ at convergent | Resonance (clean eigenstate) |
| Staircase $\lfloor x/\alpha \rfloor$ | Potential landscape |

The staircase defines a "potential." Toeplitz propagates paths through uniform
stairs (no correction needed). Each sub-block boundary is a "scattering event"
where dimensional truncation creates a defect. The Born expansion decomposes
the total effect into: no scattering (allT), single scattering (born1),
double (born2), etc.

### Is this analogy superficial?

Three observations suggest it is **not**:

1. **The convergence rate** ($\sim 100\times$ per order) is not arbitrary.
   In scattering theory, the Born series converges when the potential is "weak"
   relative to the kinetic energy. Here, the "weakness" is controlled by the
   ratio $q_1 / p_1$ — the CF approximation quality. Better CF approximation
   $\Rightarrow$ weaker scattering $\Rightarrow$ faster Born convergence.

2. **The resonance structure** is exact, not approximate. Ballot numbers
   $B(p_k, q_k)$ at CF convergents are the "clean states" where scattering
   effects cancel. This is the lattice path analogue of resonant tunneling:
   at convergent positions, the staircase is locally indistinguishable from
   a line, so path counts take the "free" form.

3. **The order activation** at $d = (k-1) q_1$ has a causal interpretation:
   each correction $D_i$ is localized at rows $d_{0,i}, \ldots, d_{0,i} + q_1 - 1$.
   An order-$k$ term requires $k$ corrections to "interact," which needs
   at least $(k-1)$ gaps of $q_1$ rows between them. This is the lattice path
   analogue of spatial separation between scatterers.

### What's surprising: pure integer combinatorics with physics structure

The lattice path counts $v_j(p)$ are **integers** — they count monotonic paths
on $\mathbb{Z}^2$. There is no continuous potential, no Hilbert space, no
differential equation. Yet the correction structure spontaneously organizes
into a Born series with:
- Free propagator (Toeplitz/Vandermonde)
- Localized perturbations (R7 corrections)
- Finite-order termination (from finite $a_2$)
- Exponential convergence per order

This suggests that the **CF hierarchy itself** is the discrete analogue of
a scattering problem, where the "waves" are lattice paths and the "potential"
is the deviation of the staircase from a straight line.

---

## The CF connection: corrections as approximation error

### Convergents as resonances

At a CF convergent $p_k/q_k$, the staircase $\lfloor q_k x / p_k \rfloor$
is locally a straight line (by the Floor Agreement Lemma, R5). The path count
takes the "ideal" form:

$$v_j(p_k) = \frac{p_k - wj}{p_k} \binom{p_k + j - 1}{j}$$

This is the **uniform formula** (R2) — the "free propagator" result.
No correction needed. The convergent is a **resonance**: the path count is
as if the boundary were a perfect line.

Between convergents, the staircase deviates from a line, and corrections
appear. The Born expansion quantifies these corrections **hierarchically**:
the first correction comes from the first CF level (level-1 sub-blocks),
the second from pairs of CF levels interacting, etc.

### The deficit $\delta_j(p)$ as approximation landscape

The correction $\delta_j(p) = v_j(p) - v_j^{\mathrm{lin}}(p)$ encodes how
the CF structure of $\alpha$ affects lattice path counts at height $j$ and
position $p$. The Born expansion decomposes $\delta_j$ into:

$$\delta_j = \underbrace{\delta_j^{(1)}}_{\text{single-level corrections}}
- \underbrace{\delta_j^{(2)}}_{\text{level interactions}}
+ \underbrace{\delta_j^{(3)}}_{\text{triple interactions}} - \cdots$$

Each term involves the **same local correction** (R7 formula) propagated
through Toeplitz kernels. The self-similarity of the CF is reflected in:
- Same R7 formula at every level (only $A = d_0 - 2$ changes)
- Same Vandermonde propagation between levels
- Same $q_1$-periodic activation of higher orders

### Why $A = d_0 - 2$?

No proof yet. Two candidate interpretations:

**Boundary interpretation:** $d_0 - 2 = d_0 - 1 - 1$ where:
- First $-1$: the last-two-equal identity ($v_{q-1} = v_q$) reduces effective
  dimension by 1
- Second $-1$: the first new row after a rise is a "copy" of the previous
  (via prefix-sum), not a genuinely independent entry

Both are **boundary effects** of finite-dimensional lattice path counting.
If this is correct, $A = d_0 - 2$ is an Euler-characteristic-type correction.

**Shift interpretation:** The correction formula involves $\binom{A + m(w{+}1) - s}{mw - 1}$,
which counts paths in a strip of width $mw$ starting at position $A + 1$.
The offset $A = d_0 - 2$ places this strip exactly where the truncation
defect begins, i.e., one row below the effective boundary.

---

## What this might connect to

### Catalan generalization ($w = 1$ case)

For $w = 1$ (slope $> 1$, e.g., $\alpha = \varphi$): the Toeplitz entries
$\binom{a + j - s}{j - s}$ reduce to the Pascal triangle, and the R7
correction collapses to a single binomial via Vandermonde–Chu. The ballot
numbers become Catalan numbers $C_n = \frac{1}{n+1}\binom{2n}{n}$.

**Hypothesis:** For $w = 1$, the entire Born expansion reduces to known
Catalan recurrences. Our theory would then be a **$w$-generalization of
Catalan combinatorics to arbitrary irrational slope**, parameterized by the
CF of $\alpha$.

### Modular group action

The CF recursion $p_{k+1} = a_{k+1} p_k + p_{k-1}$ is the action of
$\mathrm{SL}(2, \mathbb{Z})$ on the rationals. Our transfer matrices
$M_k$ live in a **lattice path representation** of this action:
$M_k$ maps ballot counts at one convergent to the next, with the Born
expansion giving the explicit matrix entries.

The question: does our Born decomposition correspond to a known decomposition
of $\mathrm{SL}(2, \mathbb{Z})$ representations? The sub-block factorization
$M_2 = \prod_{i=1}^{a_2} \mathrm{SB}_i$ mirrors the $\mathrm{SL}(2, \mathbb{Z})$
factorization into elementary matrices.

### Gauss–Kuzmin and Born complexity

The second partial quotient $a_2$ controls the number of Born orders.
By the Gauss–Kuzmin theorem, $a_2$ follows the distribution
$P(a_2 = n) \sim \log_2(1 + 1/(n(n+2)))$. This gives the
**distributional complexity of the Born expansion**: for a "random" irrational,
$a_2 \leq 10$ about 93% of the time, meaning 10 Born orders suffice
for almost all $\alpha$.

But specific irrationals can have large $a_2$ ($\pi$ has $a_2 = 15$).
The iterative computation of $\prod(T_i - D_i)$ is $O(a_2)$ in matrix
multiplications, avoiding the $O(2^{a_2})$ enumeration of all Born terms.

---

## Open questions (for next session)

1. **Prove $A = d_0 - 2$.** Which interpretation (boundary/shift) is correct?
   A proof would clarify whether the $-2$ is combinatorial or topological.

2. **Verify $w = 1$ Catalan collapse.** If the Born expansion reduces to
   Catalan recurrences for $w = 1$, it confirms the theory is a genuine
   generalization of Catalan/ballot combinatorics.

3. **SL(2,Z) connection.** Express the Born decomposition in terms of the
   modular group action. This might connect to existing representation
   theory and explain the self-similarity.

4. **Convergence rate.** The $\sim 100\times$ per order is empirical.
   A theoretical bound (possibly in terms of $q_1/p_1$ or $w$) would
   formalize the "weak scattering" condition.

---

*Documented for chronology. These interpretations are speculative and
need verification. The numerical results (R10–R12) are solid; the
physics analogy and CF connection are proposed frameworks for
understanding them.*
