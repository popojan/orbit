# Projection Formula Simplification for n = Prime

**Date:** November 18, 2025
**Context:** Can projection formula simplify for special case n = prime?

---

## General Projection Formula

$$F_n(\alpha) = \sum_{d=2}^{\infty} \left[|(n-d^2) \bmod d| + \varepsilon\right]^{-\alpha}$$

---

## For n = Prime p

### Divisibility Structure

For prime p:
- $d | p$ only when $d \in \{1, p\}$
- For $d \in \{2, 3, ..., p-1\}$: $d \nmid p$
- For $d = p$: $(p - p^2) \bmod p = ?$

**Compute:**
$$p - p^2 = p(1 - p) = -p(p-1)$$

Since $p | p(p-1)$:
$$(p - p^2) \bmod p = 0$$

**Special term at d = p:**
$$\text{term}_p = [\varepsilon]^{-\alpha}$$

This is **singular** (large contribution when ε small).

---

### Range Split

**Split sum into ranges:**

1. **d < √p:** Many terms, residues vary
2. **d = √p (if p perfect square, which it's not for prime):** N/A
3. **√p < d < p:** Moderate residues
4. **d = p:** Residue = 0 → singular term
5. **d > p:** Residues generally non-zero

$$F_p(\alpha) = \sum_{d=2}^{p-1} [R_d(p)]^{-\alpha} + \varepsilon^{-\alpha} + \sum_{d=p+1}^{\infty} [R_d(p)]^{-\alpha}$$

---

### Residue Pattern for d < p

For prime p and $2 \leq d < p$:
$$R_d(p) = |(p - d^2) \bmod d|$$

**Examples for p = 97:**

| d | d² | p - d² | (p-d²) mod d | Residue |
|---|----|----|--------------|---------|
| 2 | 4 | 93 | 1 | 1 |
| 3 | 9 | 88 | 1 | 1 |
| 5 | 25 | 72 | 2 | 2 |
| 7 | 49 | 48 | 6 | 1 (min(6, 7-6)) |
| 10 | 100 | -3 | 7 | 3 (min(7, 3)) |

**Observation:** Residues are **pseudo-random** (no obvious pattern).

For quadratic residues modulo p, this involves:
- $(p - d^2) \bmod d$ where $d < p$
- Related to whether $p \equiv d^2 \pmod d$ (always true when $d | d^2$)

**No obvious closed form.**

---

### Simplified Count

**Can we count terms with specific residues?**

For fixed residue r:
$$N_r(p) = \#\{d : 2 \leq d < p, \; (p - d^2) \bmod d = r\}$$

Then:
$$F_p(\alpha) \approx \sum_{r=0}^{\infty} N_r(p) \cdot (r + \varepsilon)^{-\alpha}$$

**But:** $N_r(p)$ depends on number-theoretic properties of p (quadratic residues, etc.).

Unlikely to have closed form.

---

### Asymptotic for Large p

**For d ≪ √p:**
$$p - d^2 \approx p \quad \Rightarrow \quad (p \bmod d)$$

By equidistribution:
$$\text{Average residue} \approx d/2$$

**Contribution from d ∈ [2, √p]:**
$$\sum_{d=2}^{\sqrt{p}} (d/2)^{-\alpha} \approx \text{const} \cdot p^{(1-\alpha)/2}$$

**For √p < d < p:**
More complex (p - d² can be negative).

**Total asymptotic:**
$$F_p(\alpha) \sim C(\alpha) \cdot p^{\beta(\alpha)} + \varepsilon^{-\alpha}$$

where $\beta(\alpha)$ depends on α.

**Still not closed form**, but asymptotic estimate possible.

---

### Special Cases

#### p = 2 (smallest prime)

$$F_2(\alpha) = \sum_{d=2}^{\infty} [(2 - d^2) \bmod d]^{-\alpha}$$

For d = 2: $(2 - 4) \bmod 2 = 0$ → singular.

Rest: $(2 - d^2) \bmod d$ for d > 2.

**Not simpler.**

#### Mersenne Primes (p = 2^k - 1)

Special structure? $p + 1 = 2^k$ (power of 2).

$(p - d^2) = (2^k - 1 - d^2)$

No obvious simplification via binary structure.

---

## Verdict: Primes Do NOT Simplify Further

**Key findings:**
- ❌ No closed form for $F_p(\alpha)$
- ❌ Residues $(p - d^2) \bmod d$ are pseudo-random
- ✅ **Asymptotic** estimate possible: $F_p \sim C \cdot p^{\beta} + \varepsilon^{-\alpha}$
- ✅ **Singular term** at d = p: $\varepsilon^{-\alpha}$

**Why primes don't simplify:**
- Few divisors (d | p) → less structure to exploit
- Residues depend on quadratic character (number theory complexity)
- Sum over d still required

**Contrast to composites:**
- Many divisors → more terms with residue = 0
- But also no closed form

**Conclusion:** Projection formula is **already as simple as it gets** for general n (including primes).

Further simplification would require deeper number-theoretic insights (quadratic reciprocity, Gauss sums, etc.).

---

**Status:** ANALYSIS
**Outcome:** Primes do not admit further simplification
