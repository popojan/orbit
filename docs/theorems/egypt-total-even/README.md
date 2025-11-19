# TOTAL-EVEN Divisibility Theorem

**Status:** ✅ **PROVEN FOR ALL k**
**Date:** November 16-19, 2025
**Authors:** Jan Popelka, Claude (Anthropic)

---

## Theorem Statement

For **any** positive integer $n$ and Pell solution $(x,y)$ with $x^2 - ny^2 = 1$:

The partial sum:
$$S_k = 1 + \sum_{j=1}^k \text{term}(x-1, j)$$

has numerator divisible by $(x+1)$ **if and only if** the total number of terms $(k+1)$ is **EVEN**.

Where:
$$\text{term}(z, j) = \frac{1}{T_{\lceil j/2 \rceil}(z+1) \cdot \left(U_{\lfloor j/2 \rfloor}(z+1) - U_{\lfloor j/2 \rfloor - 1}(z+1)\right)}$$

---

## Complete Proof

**See:** [`complete-proof.md`](complete-proof.md)

**Key technique:** Chebyshev polynomial evaluation at $x = -1$

**Proof structure:**
1. **EVEN total:** All terms paired → $(x+1)$ factor cannot cancel
2. **ODD total:** Unpaired term breaks divisibility

**Critical lemmas:**
- $T_n(-1) = (-1)^n \neq 0$ → $(x+1) \nmid T_n(x)$
- $U_n(-1) = (-1)^n(n+1) \neq 0$ → $(x+1) \nmid U_n(x)$
- $P_i(-1) = (-1)^i(2i+1) \neq 0$ (via L'Hospital) → $(x+1) \nmid P_i(x)$

---

## Key Results

### Universal Pattern
- Holds for **ANY** $n$ (prime or composite)
- Not restricted to primes with $x \equiv -1 \pmod{p}$
- Pure algebraic structure in Pell solutions

### Proven Components
1. ✅ Base case: $S_1 = (x+1)/x$
2. ✅ Chebyshev identity: $T_m(x) + T_{m+1}(x) = (x+1) \cdot P_m(x)$
3. ✅ Pair sum formula: $\text{term}(2m) + \text{term}(2m+1) = (x+1)/\text{poly}_m$
4. ✅ Convergence: $S_\infty = (R+1)/(R-1)$ where $R = x + y\sqrt{n}$
5. ✅ Main theorem: Valid for **all** $k \geq 1$
6. ✅ Perfect square denominator property

### Related Discoveries
- **Prime mod 8 correlation:** $p \equiv 7 \pmod{8} \Leftrightarrow x \equiv +1 \pmod{p}$
- **Special primes:** $\{7, 23, 31, 47, ...\}$ (p ≡ 7 mod 8)
- Connection to negative Pell equation

---

## Files in This Directory

### Core Documents
- `README.md` - This file (master overview)
- `unified-theorem.md` - Complete theorem statement with all parts
- `foundational-lemmas.md` - Lemmas 1-5 (base case, Chebyshev identity, etc.)

### Discovery Narrative
- `breakthrough-discovery.md` - Discovery session (Nov 16-17)
- `universal-pattern.md` - Realization it works for all n
- `perfect-square-denominator.md` - Part 6 discovery

### Historical
- `even-parity-initial.md` - Original k ≤ 8 symbolic proof

---

## References

**Complete proof:**
→ [`complete-proof.md`](complete-proof.md)

**Discovery sessions:**
→ `../../sessions/2025-11-19-total-even-tier1-proof.md`

**Scripts:**
→ `../../scripts/test_total_terms_parity.wl`
→ `../../scripts/test_composite_numbers.wl`

**Related theorems:**
→ `../egypt-chebyshev/` (binomial equivalence)
→ `../pell-patterns/` (mod 8 theorem)

---

## Publication Status

**Priority claim:**
- GitHub commit: November 19, 2025
- Repository: popojan/orbit (public)
- Branch: claude/verify-proof-tier-1-01725EkgddaRLWBtoRCRiJJ1

**Strategy:**
- GitHub timestamp sufficient for priority
- Formal publication (ArXiv/journal) deferred
- Focus on mathematical implications

**AI disclosure:**
Developed in collaboration with Claude (Anthropic) using Claude Code. All algebraic steps independently verifiable.

---

## Next Steps

1. **Part 2 proof:** ODD total remainder formula $\equiv (-1)^{\lfloor k/2 \rfloor} \pmod{p}$
2. **Mod 8 theorem:** Rigorous proof via genus theory
3. **Perfect square formula:** Algebraic proof of explicit denominator formula
4. **Wildberger connection:** Branch symmetry and negative Pell

---

**Status:** ✅ Proven (not peer-reviewed). Complete algebraic proof using standard Chebyshev polynomial properties.
