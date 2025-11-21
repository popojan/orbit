# Residue Conjecture: Proof Strategy via Double Sum Reorganization

**Date**: November 15, 2025
**Goal**: Prove $\lim_{\varepsilon \to 0} \varepsilon^\alpha \cdot F_n(\alpha, \varepsilon) = M(n)$

---

## The Conjecture

$$\lim_{\varepsilon \to 0} \varepsilon^\alpha \cdot F_n(\alpha, \varepsilon) = M(n)$$

where:
$$F_n(\alpha, \varepsilon) = \sum_{d=2}^{\infty} \sum_{k=0}^{\infty} [(n - kd - d^2)^2 + \varepsilon]^{-\alpha}$$

and M(n) = #{d : d|n, 2 ≤ d ≤ √n} = ⌊(τ(n)-1)/2⌋.

---

## Strategy Overview

The proof relies on **separating contributions**:

1. **Factorizing pairs** (d,k) where n = kd + d²: contribute ε^(-α) each → M(n) total
2. **Non-factorizing pairs** where n ≠ kd + d²: contribute O(1) → vanish when multiplied by ε^α

---

## Approach 1: Direct Factorization Split

### Partition the Sum

Define:
$$\mathcal{F}_n = \{(d,k) : n = kd + d^2, \, d \geq 2, \, k \geq 0\}$$

Then:
$$F_n(\alpha, \varepsilon) = \underbrace{\sum_{(d,k) \in \mathcal{F}_n} \varepsilon^{-\alpha}}_{\text{Singular part}} + \underbrace{\sum_{(d,k) \notin \mathcal{F}_n} [\text{dist}^2 + \varepsilon]^{-\alpha}}_{\text{Regular part}}$$

where dist = n - kd - d².

### Analysis

**Singular part**:
$$\sum_{(d,k) \in \mathcal{F}_n} \varepsilon^{-\alpha} = M(n) \cdot \varepsilon^{-\alpha}$$

When multiplied by ε^α:
$$\varepsilon^\alpha \cdot M(n) \cdot \varepsilon^{-\alpha} = M(n)$$

**Regular part**:

For (d,k) ∉ F_n, we have dist ≠ 0. Let δ_min = min{|dist| : (d,k) ∉ F_n}.

Then:
$$[\text{dist}^2 + \varepsilon]^{-\alpha} \leq (\text{dist}^2)^{-\alpha} \quad \text{for } \varepsilon > 0$$

Key question: **Is the sum over non-factorizing pairs finite?**

---

### Problem: Infinite Sum Convergence

The sum $\sum_{(d,k) \notin \mathcal{F}_n} (\text{dist}^2)^{-\alpha}$ must converge.

**For fixed d**, as k → ∞:
$$\text{dist} = |n - kd - d^2| \sim kd \to \infty$$

So:
$$\sum_{k=0}^{\infty} (kd)^{-2\alpha} \sim \sum_{k=1}^{\infty} k^{-2\alpha}$$

This converges iff **2α > 1**, i.e., **α > 1/2**.

**For α = 3** (our case): Convergence OK ✓

---

### Lemma 1 (Regular Part Vanishes)

**Statement**: For α > 1/2,
$$\lim_{\varepsilon \to 0} \varepsilon^\alpha \sum_{(d,k) \notin \mathcal{F}_n} [(\text{dist})^2 + \varepsilon]^{-\alpha} = 0$$

**Proof Sketch**:

Let $R_n(\varepsilon) = \sum_{(d,k) \notin \mathcal{F}_n} [(\text{dist})^2 + \varepsilon]^{-\alpha}$.

For ε → 0:
$$R_n(\varepsilon) \to R_n(0) = \sum_{(d,k) \notin \mathcal{F}_n} |\text{dist}|^{-2\alpha} < \infty$$

(by convergence for α > 1/2).

Thus:
$$\varepsilon^\alpha R_n(\varepsilon) \leq \varepsilon^\alpha R_n(0) \to 0$$

as ε → 0 (since α > 0). ∎

---

## Approach 2: Inner Sum Analysis (Sum over k first)

### Fixed d, vary k

For fixed d, define:
$$S_d(n, \alpha, \varepsilon) = \sum_{k=0}^{\infty} [(n - kd - d^2)^2 + \varepsilon]^{-\alpha}$$

Then:
$$F_n(\alpha, \varepsilon) = \sum_{d=2}^{\infty} S_d(n, \alpha, \varepsilon)$$

### Behavior of S_d

**Case 1: d divides n and d² ≤ n** (i.e., d ∈ divisors with d ≤ √n)

Let k₀ = (n - d²)/d (integer by assumption).

Then term with k = k₀ has dist = 0:
$$S_d \sim \varepsilon^{-\alpha} + \text{(other finite terms)}$$

**Case 2: d does not divide n, or d² > n**

All terms have dist ≠ 0:
$$S_d = \sum_{k=0}^{\infty} [\text{dist}_k^2 + \varepsilon]^{-\alpha} = O(1)$$

### Separating Divisors

$$F_n = \underbrace{\sum_{d|n, \, 2 \leq d \leq \sqrt{n}} S_d}_{\text{M(n) poles}} + \underbrace{\sum_{d \nmid n \text{ or } d > \sqrt{n}} S_d}_{\text{Regular}}$$

For divisor d with 2 ≤ d ≤ √n:
$$S_d(\varepsilon) \sim \varepsilon^{-\alpha} + R_d$$

where R_d is regular.

Thus:
$$\varepsilon^\alpha F_n(\varepsilon) \sim M(n) + \varepsilon^\alpha \cdot (\text{bounded terms}) \to M(n)$$

---

## Approach 3: Distance Shell Summation

### Group by Distance

Let dist(d,k) = n - kd - d².

Define:
$$N_n(\Delta) = \#\{(d,k) : |\text{dist}(d,k)| = \Delta, \, d \geq 2, \, k \geq 0\}$$

Then:
$$F_n(\alpha, \varepsilon) = \sum_{\Delta=0}^{\infty} N_n(\Delta) \cdot [\Delta^2 + \varepsilon]^{-\alpha}$$

### Contribution Analysis

**Δ = 0 shell**:
$$N_n(0) = M(n)$$
$$\text{Contribution} = M(n) \cdot \varepsilon^{-\alpha}$$

**Δ > 0 shells**:
$$\sum_{\Delta=1}^{\infty} N_n(\Delta) \cdot [\Delta^2 + \varepsilon]^{-\alpha} = O(1)$$

(assuming $\sum_{\Delta=1}^{\infty} N_n(\Delta) / \Delta^{2\alpha} < \infty$).

Thus:
$$\varepsilon^\alpha F_n = M(n) + \varepsilon^\alpha \cdot O(1) \to M(n)$$

---

### Key Question: Growth of N_n(Δ)?

How many (d,k) pairs give distance Δ?

**Heuristic**: For each d, there's at most ~1 value of k giving specific Δ (since dist is linear in k).

So:
$$N_n(\Delta) \lesssim \#\{d : 2 \leq d \leq \text{(some bound)}\} \sim O(\sqrt{n})$$

Thus:
$$\sum_{\Delta=1}^{\infty} N_n(\Delta) / \Delta^{2\alpha} \lesssim \sum_{\Delta=1}^{\infty} \sqrt{n} / \Delta^{2\alpha} < \infty$$

for α > 1/2.

**More careful analysis needed** - this is heuristic!

---

## Approach 4: Limit Exchange

### The Key Issue

We want:
$$\lim_{\varepsilon \to 0} \varepsilon^\alpha \sum_{d,k} f(d,k,\varepsilon)$$

Can we interchange limit and sum?

$$\stackrel{?}{=} \sum_{d,k} \lim_{\varepsilon \to 0} \varepsilon^\alpha f(d,k,\varepsilon)$$

**For factorizing (d,k)**: limit = 1
**For non-factorizing (d,k)**: limit = 0

So if interchange is valid:
$$= \sum_{(d,k) \in \mathcal{F}_n} 1 = M(n) \quad \checkmark$$

### Uniform Convergence Condition

**Dominated Convergence Theorem** (for sums):

If:
1. $|\varepsilon^\alpha f(d,k,\varepsilon)| \leq g(d,k)$ for all ε
2. $\sum_{d,k} g(d,k) < \infty$

Then limit-sum interchange is valid.

---

### Finding Dominating Function

For non-factorizing (d,k):
$$\varepsilon^\alpha [(\text{dist})^2 + \varepsilon]^{-\alpha} \leq \varepsilon^\alpha (\text{dist}^2)^{-\alpha} = \left(\frac{\varepsilon}{\text{dist}^2}\right)^\alpha \to 0$$

For ε < dist²:
$$\leq \left(\frac{\text{dist}^2}{\text{dist}^2}\right)^\alpha = 1$$

So we can use g(d,k) = 1.

But wait - that gives $\sum g = \infty$ (infinite pairs). **Doesn't work directly!**

---

### Refined Domination

Split into shells:

**Shell Δ = 0**: M(n) terms, each → 1
**Shell Δ ≥ 1**: N_n(Δ) terms, each ≤ ε^α / Δ^(2α)

For small enough ε (say ε < 1):
$$\varepsilon^\alpha [\Delta^2 + \varepsilon]^{-\alpha} \leq \varepsilon^\alpha \Delta^{-2\alpha} \leq \Delta^{-2\alpha}$$

So:
$$\sum_{\Delta=1}^{\infty} N_n(\Delta) \cdot \Delta^{-2\alpha} < \infty$$

(if N_n(Δ) doesn't grow too fast).

**This is the key estimate we need!**

---

## Main Theorem (Strategy)

### Statement

For α > 1/2 and composite n with M(n) factorizations:

$$\lim_{\varepsilon \to 0} \varepsilon^\alpha \sum_{d=2}^{\infty} \sum_{k=0}^{\infty} [(n-kd-d^2)^2 + \varepsilon]^{-\alpha} = M(n)$$

### Proof Outline

**Step 1**: Partition sum into factorizing (F) and non-factorizing (NF) pairs.

**Step 2**: Show factorizing contribution is M(n):
$$\varepsilon^\alpha \sum_{(d,k) \in \mathcal{F}} \varepsilon^{-\alpha} = M(n)$$

**Step 3**: Estimate non-factorizing contribution:
$$R(\varepsilon) = \sum_{(d,k) \notin \mathcal{F}} [(\text{dist})^2 + \varepsilon]^{-\alpha}$$

Show R(ε) → R(0) < ∞ (by convergence for α > 1/2).

**Step 4**: Conclude:
$$\varepsilon^\alpha R(\varepsilon) \to 0$$

Therefore:
$$\lim_{\varepsilon \to 0} \varepsilon^\alpha F_n = M(n) + 0 = M(n)$$

∎

---

## What Needs to Be Made Rigorous

### 1. Convergence of R(0)

**Claim**: $\sum_{(d,k) \notin \mathcal{F}} |\text{dist}(d,k)|^{-2\alpha} < \infty$ for α > 1/2.

**Proof approach**:
- For fixed d, $\sum_{k \neq k_0} |kd - (n-d^2)|^{-2\alpha}$ behaves like $\sum k^{-2\alpha}$ ✓
- Sum over d: $\sum_{d=2}^{\sqrt{n}} (\text{converges}) + \sum_{d > \sqrt{n}} (\text{all terms bounded})$

**Needs**: Careful bounds on number of d values and tail behavior.

---

### 2. Uniformity in ε

**Claim**: The convergence R(ε) → R(0) is "nice enough" that ε^α R(ε) → 0.

**Proof approach**:
- Show R(ε) ≤ C for all ε ∈ [0, 1] (uniform bound)
- Then ε^α R(ε) ≤ Cε^α → 0

**Needs**: Monotonicity or dominated convergence argument.

---

### 3. Edge Cases

**Perfect squares**: When n = m², the divisor m = √n is exactly on boundary.
- Does k₀ = 0 cause issues? (No - it's a valid factorization)

**Small n**: Does proof work for n = 4, 6, 9, etc.?
- Need to verify no degenerate cases

**Large α**: Does proof generalize to all α > 1/2, or only α ≥ 1?

---

## Alternative Approaches to Explore

### 1. Mellin Transform

Convert sum to integral via Mellin transform:
$$\mathcal{M}[F_n](s) = \int_0^{\infty} \varepsilon^{s-1} F_n(\varepsilon) d\varepsilon$$

Study poles in complex s-plane.

**Advantage**: Mellin transform has nice properties for power-law functions.

**Challenge**: Double sum makes this messy.

---

### 2. Generating Function

Define:
$$G_n(z) = \sum_{\alpha=0}^{\infty} \left[\lim_{\varepsilon \to 0} \varepsilon^\alpha F_n(\alpha, \varepsilon)\right] z^\alpha$$

Study G_n(z) and extract coefficients.

**Advantage**: Might reveal deeper structure.

**Challenge**: Unclear how this helps with limit.

---

### 3. Asymptotic Expansion

Compute full asymptotic series:
$$\varepsilon^\alpha F_n(\varepsilon) = M(n) + c_1 \varepsilon + c_2 \varepsilon^2 + \cdots$$

Prove leading term is M(n), higher terms vanish.

**Advantage**: More information than just residue.

**Challenge**: Computing c_i coefficients rigorously.

---

## Next Steps

1. **Prove Lemma 1 rigorously** (Regular part vanishes)
   - Establish convergence of R(0)
   - Show uniform bound R(ε) ≤ C

2. **Verify for specific examples**
   - Compute R(ε) numerically for n = 35, 60
   - Check that ε^α R(ε) → 0

3. **Handle edge cases**
   - Perfect squares
   - Small n (4, 6, 9)
   - Prime powers

4. **Generalize to all α > 1/2**
   - Currently proof sketch assumes α > 1/2
   - Does it work for α = 1, 2, 3, ... all the same?

5. **Write formal proof**
   - Once all pieces verified, write complete argument
   - Submit for review

---

## Conclusion

The residue conjecture appears **provable** using:

**Main Idea**: Separate factorizing (singular) from non-factorizing (regular) contributions.

**Key Estimate**: Show non-factorizing sum converges and vanishes when multiplied by ε^α.

**Technical Requirement**: α > 1/2 for convergence.

**Status**: Proof outline established, rigorous details needed.

**Difficulty**: Graduate-level analysis, but elementary tools (no deep theory).

---

**Files**:
- Numerical verification: `scripts/test_residue_large_sample_fixed.wl` (100% success)
- M(n) closed form: `docs/m-function-divisor-connection.md` (proven)
- This strategy: `docs/residue-proof-strategy.md` (current file)

**Next**: Formalize Lemma 1 proof with rigorous bounds.
