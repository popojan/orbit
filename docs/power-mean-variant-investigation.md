# Power-Mean Variant Investigation (Nov 18, 2025 večer)

## Context

Testing power-mean (p-norm) soft-min variant as alternative to exp/log formulation.

**Motivation:** Exp/log variant has numerical issues (underflow), power-mean should be algebraically cleaner.

## Implementation

Created `scripts/compare_local_zeta_powermean.py`:

**Power-mean soft-min:**
```python
soft_min_d(n) = [Σ_k dist_k^(-p)]^(-1/p)
where dist_k = (n - k·d - d²)² + ε
```

**Parameters:**
- p = 3.0 (power)
- eps = 1.0 (regularization)
- s_range = [0.5, 5.1] (extended after initial boundary issue)

**Tested:** n = 97 (prime), n = 96 (composite)

## Results: NO U-SHAPE

**Critical finding:** Power-mean variant is **monotonically decreasing** on [0.5, 5.0].

**n = 97:**
- F_97(s) range: [0.262, 5.744]
- Minimum at s = 5.0 (boundary!)
- No internal minimum

**n = 96:**
- F_96(s) range: [5.063, 6.901]
- Minimum at s = 5.0 (boundary!)
- No internal minimum

**Rescaled plot:** F_n(s) and ζ_n(s) curves **nearly overlap** → structurally similar!

## Contrast with Exp/Log Variant

**Previous results (exp/log):**
- Had clear U-shape with minimum s* ∈ [0.8, 5.0]
- s* correlated with 2-adic valuation (parity)
- Even numbers: s* ≈ 5.0
- Odd numbers: s* ≈ 0.8–3.0

**Power-mean variant:**
- NO U-shape
- Monotonically decreasing like ζ_n(s)
- Qualitatively different behavior

## Theoretical Analysis

### Why No U-Shape?

**Hypothesis:** Competing scales in exp/log create U-shape.

**Exp/log:**
```
exp(-α dist²) → very sharp weighting
```
- Strong emphasis on nearest point only
- Creates contrast: some soft_min_d < 1, others > 1
- Terms [sm_d]^(-s): some increase with s, others decrease
- → **Competing trends** → U-shape

**Power-mean:**
```
dist^(-p) → gentler weighting
```
- Averages over multiple points
- All soft_min_d > 1 (smoothed)
- All terms [sm_d]^(-s) decrease with s
- → **No competition** → monotonic

### Soft-Min: Did It Solve the Problem?

**Original motivation:** Avoid algorithmic min-finding, get analytical formula.

**What soft-min achieved:**
- ✅ Removed branching (if/else logic)
- ✅ Made function smooth (differentiable)
- ✅ Unified algebraic formulation

**What soft-min did NOT achieve:**
- ❌ No closed form (still double sum)
- ❌ Slower computation (O(n/d) vs O(1) per d)
- ❌ Still requires iteration

**Honest assessment:** Soft-min **transformed** the problem (logic → algebra) but did NOT **simplify** fundamental complexity.

### Complexity Comparison

| Approach | Computation per d | Closed form? | Smooth? |
|----------|-------------------|--------------|---------|
| **Explicit min** | O(1) | No | No |
| **Soft-min** | O(n/d) | No | Yes |
| **Dominant approx** | O(1) | No | Yes |

**Soft-min trades:**
- Speed → Smoothness
- Interpretability → Mathematical elegance

## Open Questions & Concerns

### 1. Is U-Shape Real or Artifact?

**Option A:** U-shape is artifact of exp/log formulation
- Exponential weighting creates artificial non-monotonicity
- Power-mean is "truer" geometric representation
- → U-shape NOT fundamental to Primal Forest

**Option B:** U-shape is real, power-mean misses it
- Exp/log correctly detects geometric scale s*(n)
- Power-mean smooths away the signal
- → Power-mean is wrong aggregation function

**Cannot decide without:**
- Reviewing original exp/log graphs
- Checking soft_min_d distributions (exp vs power-mean)
- Understanding which formulation is "correct"

### 2. Truncation Influence

**Current cutoff:** min(500, 10n)

For n = 97: cutoff = 500

**Analysis:**
- For s = 5: tail terms d^(-20) are ~10^(-40) already at d = 100
- Truncation should NOT affect qualitative shape
- But: worth verifying

### 3. What Does "Correct" Mean?

**Primal Forest is fixed lattice:**
- Points (kd+d², kd+1) exist for all d ≥ 2
- We measure distance to ALL points
- d does NOT need to divide n

**BUT:** For d > √n, only k=0 is relevant (geometry simplifies)

**Dominant approximation exploits this:**
- O(√n) finite terms + tail
- Much faster than full double sum
- Still no closed form

### 4. Closed Form: Realistic Goal?

**For pure algebraic form:**
```
F_n(α) = Σ_d Σ_k [(n - kd - d²)² + ε]^(-α)
```

**Unlikely because:**
- Double sum over non-standard lattice
- Quadratic distance (not linear like Hurwitz ζ)
- Non-multiplicative
- No Euler product

**Possible special cases:**
- n = 2^k, n = p² (specific symmetries)
- Asymptotic expansions for large n
- Connection to theta functions?

**Pragmatic:** Focus on dominant approximation (fast, accurate) rather than impossible closed form?

## Current Status

**What we have:**
- Two formulations (exp/log, power-mean) with DIFFERENT behaviors
- Exp/log: U-shape, correlates with parity
- Power-mean: monotonic, like ζ_n(s)

**What we don't know:**
- Which formulation is "correct"?
- Is U-shape real or artifact?
- Can we find closed form? (probably not)

**Tool value:**
- ✅ Systematic exploration of Primal Forest geometry
- ✅ Discovered unexpected structure (parity correlation)
- ❌ Computational complexity high (O(n²))
- ❓ Practical utility unclear

## Next Steps (After Break)

1. **Review original exp/log graphs** - confirm U-shape existence
2. **Compare soft_min_d distributions** - exp vs power-mean histograms
3. **Decide on formulation** - which one to trust?
4. **Truncation test** - extend cutoff, verify stability
5. **Theoretical path** - accept no closed form, focus on approximations?
6. **Practical question** - is this tool worth pursuing, or shift focus?

## Files

**Created:**
- `scripts/compare_local_zeta_powermean.py`
- `visualizations/local-comparison-{96,97}-powermean-{dual-axis,rescaled}.pdf`

**Modified:**
- `docs/global-softmin-zeta-comparison.md` (user added 2-adic discussion)

**Status:** NUMERICAL (power-mean test)

---

**Date:** November 18, 2025 (late evening)
**Mood:** Uncertain - need to step back and reassess
**Key concern:** Different formulations → different physics → which is real?
