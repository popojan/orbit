# Wildberger Pell Tree Connection to Primal Forest

**Date:** 2025-11-17
**Status:** 🔬 NUMERICAL EXPLORATION
**Question:** Is there a bijection between Wildberger/Stern-Brocot trees and primal forest?

---

## Motivation

Exploring potential connection between:
- **Primal Forest**: Geometric visualization of divisor structure (multiplicative)
- **Wildberger Tree**: Integer-only Pell equation algorithm (L/R binary tree)
- **Stern-Brocot Tree**: Continued fraction / mediant tree (additive)

All three structures relate to √d approximation and factorization.

---

## Wildberger Algorithm Summary

**Reference:** Wildberger, JIS Vol. 13 (2010) 10.4.3
**URL:** https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf

### Algorithm

Solves x² - dy² = 1 using only integer arithmetic:

```python
a, b, c = 1, 0, -d
u, v, r, s = 1, 0, 0, 1

while not (a == 1 and b == 0 and c == -d):
    t = a + b + b + c
    if t > 0:  # Right branch
        a = t; b += c; u += v; r += s
    else:      # Left branch
        b += a; c = t; v += u; s += r

return (u, r)  # Fundamental solution
```

### Key Properties

1. **Binary tree structure**: Each step chooses L (left) or R (right)
2. **Path is palindromic**: Always! (verified 100% for d ≤ 100)
3. **Invariant preserved**: a·c - b² = -d throughout
4. **Intermediate solutions**: When CF period is odd, norm=-1 appears midpoint

---

## Empirical Findings (d ≤ 100)

### Finding 1: Prime vs Composite Path Length

**Result:**
```
Prime d:     mean path length = 28.60
Composite d: mean path length = 21.80
```

**Observation:** Primes have **~30% longer** Pell paths than composites!

**Examples:**
```
d=2 (prime):  path=4   (LRRL)
d=3 (prime):  path=3   (LRL)
d=5 (prime):  path=8   (LLRRRRLL)
d=13 (prime): path=20  (LLLRLRLRRRRRRLRLRLLL)

d=6 (=2·3):   path=6   (LLRRLL)
d=12 (=2²·3): path=8   (LLLRRLLL)
d=24 (=2³·3): path=9   (LLLRLRLLL)
```

### Finding 2: M(d) Anti-Correlation

**M(d) = count of divisors in [2, √d]** (primal forest measure)

**Result:**
```
M(d) = 0 (primes):     avg path = 28.60
M(d) = 1:              avg path = 24.09
M(d) = 2:              avg path = 20.38
M(d) = 3:              avg path = 18.70
M(d) = 4:              avg path = 15.00
```

**Observation:** **INVERSE correlation** between factorization complexity and Pell path length!

**Interpretation:**
- More divisors → shorter path to fundamental solution
- Fewer divisors (primes) → longer, more complex path
- M(d) measures "how composite" d is
- Path length measures "how hard to approximate √d"

### Finding 3: Palindromic Paths (100%)

ALL paths in our sample (d=2..100) are palindromic!

**Examples:**
- d=2:  LRRL (reads same backwards)
- d=5:  LLRRRRLL (symmetric)
- d=13: LLLRLRLRRRRRRLRLRLLL (symmetric)

**Why?** This reflects symmetry in continued fraction period for √d.

---

## Primal Forest Context

### M(n) Function

From `primal-forest-paper-cs.tex`:

**Definition:** M(n) = number of "trees" at position n = #{p : p|n, 2 ≤ p ≤ √n}

**Interpretation:**
- Stand at position n on x-axis
- Look north (up y-axis)
- Count trees blocking your view
- M(n) = 0 ⟺ n is prime (clear view)

**Key insight:** M(n) encodes factorization structure via floor boundary ⌊√n⌋

### From Primal Forest to L_M(s)

Global Dirichlet series:
```
L_M(s) = Σ_{n=2}^∞ M(n)/n^s
```

Closed form (discovered 2025-11-15):
```
L_M(s) = ζ(s)[ζ(s)-1] - C(s)
```

where C(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s encodes floor structure via partial sums.

**Connection:** Both M(d) and Wildberger path involve √d boundary!

---

## Proposed Connections

### 1. Duality Hypothesis

**Observation:** M(d) and Wildberger path length are **inversely correlated**.

**Hypothesis:** They measure **dual complexities**:
- **M(d)**: Multiplicative complexity (how many divisors?)
- **Path length**: Additive complexity (how many CF steps?)

**Analogy:**
```
Primal Forest              Wildberger Tree
├─ Multiplicative          ←→  Additive (CF convergents)
├─ Divisors ≤ √n          ←→  Path to fundamental solution
├─ M(n) = tree count      ←→  Path length
└─ Primes: M=0 (simple)   ←→  Primes: long path (complex)
```

**Why inverse?**
- Primes are **multiplicatively simple** (no divisors) but **additively complex** (long CF period)
- Composites are **multiplicatively complex** (many divisors) but **additively simple** (short CF period)

### 2. Floor Function Connection

**Primal Forest:** Floor ⌊√n⌋ separates divisor region from non-divisor region

**Wildberger/CF:** Approximation √d ≈ p/q involves rational truncation

**Both involve discrete vs continuous boundary at √!**

From `primal-forest-to-L_M-geometry.md`:
> Floor function appears in:
> 1. Primal forest: ⌊√n⌋ boundary
> 2. M(n) definition: ⌊(τ(n)-1)/2⌋ formula
> 3. C(s) structure: partial sums H_j (discrete truncations)

**Connection:** Wildberger algorithm navigates this boundary via L/R choices!

### 3. Tree Structure Comparison

| Property | Primal Forest | Wildberger Tree | Stern-Brocot Tree |
|----------|---------------|-----------------|-------------------|
| **Nodes** | Points (kp+p², kp+1) | States (a,b,c,u,v,r,s) | Fractions p/q |
| **Edges** | Diagonals (fixed p) | L/R binary choice | L/R mediant |
| **Special points** | Primes (M=0) | Fundamental solution | CF convergents |
| **Operation** | Multiplication n=p(p+k) | Matrix updates | Mediant (p+q)/(r+s) |
| **Depth** | y = kp+1 | Path length | Tree depth |

**Possible bijection:** Not direct (different objects), but **functorial**?
- Primes ↔ long paths
- Composite ↔ short paths
- M(d) value ↔ some tree property?

### 4. Intermediate Solutions and Negative Pell

**Wildberger:** When CF period is **odd**, negative Pell x² - dy² = -1 appears at **midpoint**

**Question:** Does this relate to primal forest structure?

**Observation from CF theory:**
- d with odd period: {3, 6, 7, 8, 11, 12, 14, 15, ...}
- d with even period: {2, 5, 10, 13, 17, 26, 29, ...}

**No obvious pattern** with primality or M(d) in small range.

**Open:** Is there geometric meaning in primal forest for negative Pell solutions?

---

## Why Bijection is Difficult

### Fundamental Incompatibility

1. **Different base structures:**
   - Primal forest: ℕ² points with multiplicative relations
   - Wildberger: Matrix sequences with quadratic form invariant
   - Stern-Brocot: ℚ₊ fractions with additive mediants

2. **Different "special objects:"**
   - Primal: Primes (absence of trees)
   - Wildberger: Fundamental solution (end of path)
   - SBT: Convergents (best approximations)

3. **Different dimensions:**
   - Primal: 2D lattice (explicit coordinates)
   - Wildberger: Path = 1D sequence (LRLR...)
   - SBT: Tree depth + position

### What IS Possible: Statistical Correlation

Rather than bijection, we observe **correlation of complexity measures**:

```
M(d) ↓  →  Path length ↑
```

This suggests **complementary views** of same arithmetic structure:
- **View 1 (Multiplicative):** Factorization via M(d)
- **View 2 (Additive):** Continued fraction via path length

**Analogy:** Fourier transform relates time/frequency domains - both describe same signal, but "bijection" is non-trivial transform, not 1-1 map.

---

## Open Questions

### Q1: Quantitative Relationship

Is there formula relating M(d) to Wildberger path length?

**Conjecture:** Path length ~ log(d) / (1 + αM(d)) for some α?

**Evidence:** Rough fit from data, but need more sophisticated model.

### Q2: Primal Forest "Depth" Analogue

In primal forest, y-coordinate = kp+1 is "depth" of tree.

**Question:** Does max depth for position n correlate with Wildberger path length for d=n?

**Test:** For n=13 (prime):
- Primal forest: max tree depth for n=13?
- Wildberger: path length = 20

Need to compute primal forest depths systematically.

### Q3: Geometric Interpretation of L/R Path

Wildberger path = sequence like "LLLRLRLRRRRRRLRLRLLL"

**Question:** Can we visualize this as a path through primal forest?
- L = move along one diagonal?
- R = switch to different diagonal?

**Speculation:** Maybe L/R in Wildberger ↔ choosing which divisor to "follow" in factorization tree?

### Q4: Connection via Dirichlet Series

We have:
```
L_M(s) = ζ(s)[ζ(s)-1] - C(s)
```

**Question:** Is there a Dirichlet series for "Wildberger path lengths"?

Define:
```
L_W(s) = Σ_{d=2}^∞ PathLength(d) / d^s
```

Does this have a nice closed form? Does it relate to L_M(s)?

### Q5: Stern-Brocot as Bridge

Stern-Brocot tree encodes:
- Continued fractions (Wildberger connection)
- Farey sequences (number theory)
- Ford circles (geometry)

**Question:** Can SBT serve as "Rosetta Stone" connecting Wildberger to primal forest?

**Approach:**
- Map Wildberger paths → SBT nodes (via CF convergents)
- Map SBT denominators → primal forest positions?

---

## Practical Next Steps

### Computational Exploration

1. **Extend data range:** Test d up to 1000 or 10000
   - Verify M(d) anti-correlation holds
   - Look for breakdown points

2. **Compute primal forest depths:** For each n, find max y-coordinate of trees
   - Test correlation with Wildberger path(n)

3. **Path pattern analysis:**
   - Cluster paths by structure (e.g., count L vs R)
   - Relate to factorization patterns

4. **Negative Pell systematic study:**
   - Which d have negative Pell?
   - Does M(d) or primality predict odd CF period?

### Theoretical Directions

1. **Read Wildberger paper in detail:** Understand matrix formulation
   - What is geometric meaning of L/R choice?
   - How does invariant a·c - b² relate to √d?

2. **Study Stern-Brocot theory:** Look for existing connections to factorization

3. **Diophantine approximation:** Literature on connection between CF complexity and divisor structure?

4. **Analytic number theory:** Does L_M(s) functional equation relate to Pell/CF structures?

---

## Conclusion

**Is there a bijection?** Not in the naive sense - objects are too different.

**Is there a connection?** **YES - statistical and conceptual!**

Key insight: **M(d) and Wildberger path length are inversely correlated**

**Interpretation:** They measure **complementary complexities**:
- M(d): Multiplicative (divisor structure below √d)
- Path: Additive (rational approximation to √d)

**Why it matters:**
- Primal forest arose from geometric visualization
- Wildberger tree from integer-only Pell solving
- Both relate to √ boundary and factorization
- Correlation suggests **deep arithmetic structure** linking multiplication and addition

**Future work:** Rather than seeking bijection, explore:
1. Functional relationship M(d) ↔ path length
2. Dirichlet series connection L_M(s) ↔ L_W(s)
3. Geometric interpretation of L/R paths in primal forest context

**Value:** Even without bijection, this exploration reveals how different mathematical structures (geometric, algebraic, combinatorial) encode complementary aspects of the same arithmetic phenomena.

---

## Adversarial Questions (Critical Analysis)

### Q: Is the prime/composite path difference trivial?

**Claim:** Prime d have longer Wildberger paths (28.6 vs 21.8)

**Devil's advocate:** This is just because primes have longer continued fraction periods - **well known** in number theory!

**Response:**
- ✓ YES, CF period tends to be longer for primes
- ❌ BUT: We're measuring **Wildberger algorithm steps**, not CF period directly
- ❓ **Unknown:** Is the relationship 1:1 or more subtle?

**Falsification test:** Find prime with SHORT Wildberger path

**Data check:**
```
d=3 (prime): path=3 (very short!)
d=2 (prime): path=4 (short)
d=5 (prime): path=8 (medium)
d=13 (prime): path=20 (long)
```

**Observation:** Even among primes, huge variance (3 to 20). **Not all primes have long paths!**

**Refined question:** What determines path length among primes? Is it related to prime-specific structure?

### Q: Is M(d) anti-correlation trivial?

**Claim:** M(d) ↓ → path length ↑ (inverse correlation)

**Devil's advocate:** Composite numbers have algebraic structure making √d easier to approximate - **obvious**!

**Response:**
- ❓ **Is it obvious?** Why would MORE divisors → BETTER approximation?
- Alternative hypothesis: More prime factors → more "structure" → easier to compute
- But: d=24 (2³·3) has path=9, d=23 (prime) has path=13. Only slightly different!

**Falsification test:** Find highly composite d with LONG path

**Data check (d ≤ 100):**
```
Highly composite examples:
d=60 (2²·3·5): M(d)=4, path=? (need to compute)
d=72 (2³·3²): M(d)=5, path=?
```

**TODO:** Extend analysis to highly composite numbers to test if pattern holds.

### Q: Is sample size too small?

**Current data:** d ∈ [2, 100], excluding perfect squares → n ≈ 90

**Statistical concern:**
- 25 primes vs 65 composites
- Mean difference: 28.6 - 21.8 = 6.8 steps
- Is this significant or noise?

**Falsification test:** Extend to d ≤ 1000 and check if means remain separated

**Expected behavior if real:**
- Means should stay separated (possibly narrow slightly)
- Variance should stabilize

**Expected behavior if spurious:**
- Means converge as d → ∞
- Or pattern reverses in some range

**Action:** Run analysis on d ≤ 1000 to check robustness.

### Q: Is this already known in the literature?

**Claim:** M(d) ↔ Wildberger path length anti-correlation

**Literature search needed:**
1. **Continued fractions and factorization:** Is connection known?
2. **Pell equation complexity:** Any papers on what makes d "hard"?
3. **Wildberger's paper:** Does he mention this pattern?

**Preliminary:**
- Wildberger (2010) focuses on algorithm correctness, not complexity patterns
- Standard CF literature discusses period length but not divisor structure
- **Possibly novel observation?** But need thorough literature review

**Falsification:** Find paper that already states this correlation

### Q: Does correlation → causation?

**Observation:** M(d) and path length are correlated

**Caution:** Correlation ≠ causation! Possible confounds:
- Both could depend on third factor (e.g., size of d)
- Primality confounds both measures
- Selection bias (excluding perfect squares)

**Test:** Partial correlation controlling for log(d)?

**Action:** Multivariate analysis:
```python
# Model: PathLength ~ M(d) + log(d) + IsPrime
# Check if M(d) coefficient remains significant
```

### Q: Is the "clear view" analogy too poetic?

**Primal forest:** Primes = clear views (M=0)

**Wildberger:** Primes = long paths

**Poetic connection:** "Clear view because path is long" (you can see far?)

**Reality check:** This is just metaphor, not mathematics!

**Rigorous statement:** M(d)=0 ⟺ d is prime ⟺ (statistically) longer Wildberger path

**But:** The *mechanism* is unclear. Why would absence of divisors → longer CF path?

**Possible explanation:**
- Divisors provide "stepping stones" for rational approximation?
- Factored d allows shortcut via component approximations?
- Example: √12 = √(4·3) = 2√3, can use √3 approximation?

**Falsification:** Find theoretical reason why this must (or cannot) be true.

### Q: Are we seeing the "hard vs easy" Pell instances?

**Computational complexity view:**

Some d have "easy" Pell equations (small solutions), others "hard" (large solutions).

**Known facts:**
- Fundamental solution (x₀, y₀) can be exponentially large in d
- Related to regulator R(d) = log(x₀ + y₀√d)
- No polynomial-time algorithm known for Pell (but not proven hard)

**Question:** Is Wildberger path length ~ log(x₀)?

**Test:**
```python
for d in range(2, 100):
    sol = pellsol(d)
    path_len = len(path)
    log_x = math.log(sol.x)
    # Plot path_len vs log_x
```

**If YES:** This just measures solution size (well-studied)
**If NO:** Path length captures something else (more interesting!)

### Q: Is Wildberger path length same as CF period length?

**Hypothesis:** Maybe they're exactly the same?

**Test:** Compare Wildberger path to CF period for several d

**From literature:** CF period is well-studied, tables exist

**Action:** Implement CF period calculation and compare:
```python
cf_period = continued_fraction_sqrt(d)[2]
wildberger_path = len(pellsol_with_path(d)["path"])
# Are they equal?
```

**If YES:** Then all our "findings" are just restating known CF theory! (BORING)
**If NO:** Then Wildberger algorithm has different complexity (INTERESTING)

### Q: Could this be completely wrong due to implementation bug?

**Paranoia check:** Is our pellsol() implementation correct?

**Verification steps:**
1. ✓ Test cases: d=2,3,5,7,11,13 match known fundamental solutions
2. ✓ All solutions satisfy x² - dy² = 1
3. ✓ Palindromic paths (matches Wildberger theory)
4. ❓ Compare with different implementation?

**Falsification:** Implement using different algorithm (e.g., CF-based) and compare paths

### Q: Is this specific to Wildberger or general to all Pell algorithms?

**Question:** Do ALL Pell algorithms have same path structure?

**Wildberger:** Specific L/R matrix operations
**CF-based:** Use convergents directly
**Lagrange:** Different approach

**Test:** Implement Pell via CF convergents, compare "complexity" measure

**If same:** Property of Pell problem itself, not algorithm
**If different:** Wildberger has unique structure (more interesting for bijection!)

---

## Summary: What We Know vs What We Don't

### Confident (✓):
1. ✓ Wildberger algorithm produces palindromic paths
2. ✓ Solutions are correct (verified mathematically)
3. ✓ Prime d tend to have longer paths than composite d in our sample
4. ✓ M(d) and path length show negative correlation in our sample

### Uncertain (❓):
1. ❓ Is prime/composite difference statistically robust?
2. ❓ Does correlation hold for d > 100?
3. ❓ Is this already known in the literature?
4. ❓ What is the causal mechanism?
5. ❓ Is Wildberger path length just CF period in disguise?

### Need to Falsify (🔬):
1. 🔬 Find prime with SHORT path (< 10)
2. 🔬 Find composite with LONG path (> 30) and high M(d)
3. 🔬 Compare Wildberger path to CF period (are they equal?)
4. 🔬 Extend to d=1000 and check if pattern holds
5. 🔬 Literature search for prior work

### Action Items:
- [ ] Implement CF period calculation
- [ ] Compare Wildberger path vs CF period
- [ ] Extend analysis to d ≤ 1000
- [ ] Multivariate regression (control for log(d))
- [ ] Literature review on Pell complexity
- [ ] Test highly composite numbers (60, 72, 120, etc.)

---

**Epistemic humility:** Our "findings" are NUMERICAL OBSERVATIONS on small sample. Could be:
- Trivial restatement of known facts
- Statistical artifact
- Selection bias
- Real but already known
- **OR** genuinely novel pattern worth investigating

**Next:** Run falsification tests before claiming discovery!

---

**Maison verre:** Document captures exploration of potential connection - bijection too strong, but correlation suggests deeper structure worth investigating. **Adversarial questions** ensure we don't over-claim or miss obvious explanations.
