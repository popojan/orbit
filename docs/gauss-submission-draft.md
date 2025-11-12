# Gauss AI Submission Draft

**Target**: https://www.math.inc/early-access

**Date prepared**: 2025-11-12

**Author**: Jan Popelka (popojan@protonmail.com)

---

## Submission Form Fields

**Name**: Jan Popelka

**Email**: popojan@protonmail.com

**What do you want to prove with Gauss?**

---

I've discovered a formula computing primorials (products of consecutive primes) via an alternating factorial sum, but lack a rigorous proof of the cancellation mechanism:

**Formula**: For m ≥ 3,
Primorial(m) = Denominator[1/2 · Σ(k=1 to ⌊(m-1)/2⌋) (-1)^k · k!/(2k+1)]

**Verified computational pattern**:
The final denominator equals 2 × (product of primes p where 3 ≤ p ≤ 2k+1), containing only **first powers** of each prime.

**The open problem**: Individual denominators 2k+1 include prime powers (9=3², 25=5², 27=3³, ...) and composites. Naively, the LCM would contain these higher powers. Yet when summing and reducing the rationals, the numerators k! contain precisely enough prime factors to **cancel all p^j (j>1)** via GCD reduction, leaving only p¹.

**Proof goal**: Show rigorously that for all primes p ≤ 2k+1:
ν_p(Denominator[S_k]) = 1

where ν_p is the p-adic valuation and S_k is the k-th partial sum.

**Repository**: https://github.com/popojan/orbit
See: docs/primorial-mystery-findings.md

---

## Notes on Submission

### Concerns
- **Priority/attribution**: This is unpublished work; repo is public but no preprint exists
- **Sharing incomplete results**: Computational verification complete but proof missing
- **Company access**: Math Inc. is US-based; unclear IP/collaboration terms

### Counterarguments
- Repository already public on GitHub (timestamped)
- Math Inc. appears to seek collaborations, not idea theft
- AI+Lean formal verification could provide computational power unavailable otherwise
- Could post arXiv preprint first for formal timestamping if concerned

### About Math Inc. / Gauss

**Website**: https://www.math.inc/gauss

**Key achievement**: Formalized the strong Prime Number Theorem in Lean (3 weeks, 25,000 lines, 1,100+ theorems) - Terry Tao estimated 18 months manual effort

**Technology**: Autoformalization agent working with Lean proof assistant

**Scale**: Thousands of concurrent AI agents, terabytes of RAM, working up to 12 hours each

**Status**: Beta testing with select mathematicians; accepting early access applications

**Goal**: Increase formal code by 2-3 orders of magnitude in 12 months as training ground for "verified superintelligence"

### Why This Problem Fits

✓ **Clear computational pattern**: Verified across many test cases
✓ **Precise question**: Why ν_p(denominator) = 1?
✓ **Tractable scope**: Elementary objects (factorials, rationals, p-adic valuations)
✓ **Known theory leverage**: Legendre's formula, rational arithmetic, GCD theory
✓ **Sweet spot**: Not trivial, not massive conjecture, genuinely non-obvious

The gap between "computationally observed" and "rigorously proven" is exactly what AI+formal methods target.

### Decision Points

1. **Submit as-is?** Yes, worth trying given public repo already exists
2. **Post arXiv preprint first?** Optional; could establish priority more formally
3. **Request collaboration terms clarity?** Could ask about IP/attribution in submission or follow-up
4. **Alternative**: Could try other formal proof communities (Lean Zulip, etc.) first

---

*This draft prepared by AI assistant; human decision required before submission*
