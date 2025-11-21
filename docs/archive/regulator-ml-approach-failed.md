# ML Approach to R(n) Prediction: Failed Experiment

**Date**: 2025-11-17
**Status**: ❌ **FAILED APPROACH** (documented for future reference)
**Time invested**: ~6 hours
**Result**: Rational coefficients found, but no theoretical insight gained

---

## Summary

**Goal**: Predict regulator R(n) = log(x₀ + y₀√n) using machine learning approach:
```
R(n) ≈ g(n mod 8) × (const + α·dist - β·M)
```

**Result**: Model achieves 23-69% explained variance with rational coefficients, but:
- ❌ No mechanism understood
- ❌ Distance correlation overrated (0.197, not 0.739)
- ❌ Model degrades for larger n
- ❌ Prime bifurcation discovered but unexplained
- ✅ CF period (r=0.82) was already known but ignored!

**Lesson**: **Fitting without mechanism is futile.** Return to theory.

---

## What We Did (Chronologically)

### 1. Fixed Falsification Test Metrics ✓

**Problem found**: Original test used absolute error on x (exponential scale).

**Fix**: Changed to relative error:
```mathematica
relErrorX = |x_pred - x_true| / x_true
```

**Result**: Correct! Original model now shows catastrophic failure:
- MAE(R) = 7.98 (need <2.0) ❌
- Mean relative error = 5.5×10¹¹% ❌
- Correlation = 0.167 (need >0.7) ❌
- **0/4 criteria passed**

### 2. Discovered Rational Coefficients ✓

**Approach**: Use Minimize (not LinearModelFit) to find exact α, β, const.

**Result**: Simple fractions found!
```
mod 1: α=3/46,  β=25/38,  const=20/21
mod 3: α=9/67,  β=21/76,  const=82/113
mod 5: α=5/28,  β=33/82,  const=11/19
mod 7: α=3/22,  β=5/18,   const=13/19  ← SIMPLEST!
```

**Observation**: Rational structure exists (denominators 18-113), but...

**Problem**: What do these fractions MEAN? No theoretical interpretation!

### 3. Error Analysis Revealed Problems ❌

**Test**: Analyzed 145 test cases (n ∈ (100,400]).

**Finding 1 - Mod 5 catastrophe**:
```
mod 1: 3,105% error
mod 3: 1,034% error
mod 5: 1.44×10¹¹% error  ← 8 ORDERS worse!
mod 7: 357% error
```

**Finding 2 - Distance is WEAK**:
```
Correlation (dist ↔ relative error): 0.197  ← WEAK!
```

Original claim (regulator-structure-complete.md): dist ↔ R = 0.739 "extremely strong"

**This was WRONG!** Artifact of absolute error on log scale.

**Finding 3 - What actually helps**:
```
h(n):      +10-17% R² improvement  ← HELPS
CF period: +12% R² (mod 5)          ← HELPS
dist:      0.197 correlation        ← WEAK
```

### 4. Universal Prime Bifurcation ⭐

**Discovery**: ALL mod classes show prime/composite split:
```
            Primes    Composites   Ratio
mod 1:      21.5      10.5         2.04× ★
mod 3:      14.5      6.68         2.16× ★★ (highest!)
mod 5:      20.0      11.8         1.69× ★
mod 7:      12.5      7.64         1.64× ★

All 4/4 mods: ratio > 1.6×
```

**Tested**: 1228 primes (n < 10000), universal pattern confirmed.

**But**: WHY? No mechanism!

**Hypotheses** (untested):
- Primes have longer CF periods?
- M(p) = 0 implies special CF structure?
- Connection to primality?

### 5. Attempted Stratified Model ❌

**Idea**: Split baseline g(mod8, isPrime) to fix bifurcation.

**Problem**: Adds 4 more parameters, still no insight!

**Abandoned**: This is curve fitting, not understanding.

---

## Critical Mistakes

### Mistake 1: Ignored CF Period (r=0.82!)

**From STATUS.md** (egypt-primal-forest-connection, previous branch):
```
R(D) vs CF period: r = +0.82  (strong positive!) ⭐
```

**This was ALREADY KNOWN!**

But we:
- Focused on dist (r=0.197)
- Built ML models
- Wasted time on stratification

**Should have**: Started with CF period analysis!

### Mistake 2: Distance Overrated

**Original claim**: dist ↔ R correlation = 0.739 (mod 5)

**Reality**: dist ↔ error = 0.197 (all mods)

**Why wrong?**
- Measured on log scale (R) not exponential scale (x)
- Used absolute error (scale-dependent)
- Didn't separate primes/composites

**Correct**: CF period (0.82) >> dist (0.197)

### Mistake 3: ML Without Mechanism

**What we did**:
```
1. Find rational coefficients (3/46, 5/28, ...)
2. Stratify by isPrime
3. Add features (h, period)
4. Fit, fit, fit...
```

**What we learned**: Nothing about WHY.

**Physics analogy**:
```
Bad:  Fit planetary orbits to polynomials (accurate but meaningless)
Good: Derive from F = GMm/r² (Newton's law)
```

We did the bad thing.

### Mistake 4: Model Degrades (Ignored)

**Observation**:
```
Training (n ≤ 100 → 100-200): r = 0.64
Large n  (200-400):           r = 0.49  (23% degradation)
```

**This means**: Missing scale-dependent factors OR fundamental limitation.

**Our response**: Add isPrime splits (doesn't help scale issue!)

**Should do**: Analyze WHY degradation (period? depth? other structure?)

---

## What Actually Works

### 1. Prime Bifurcation (Empirical)

**Status**: ✅ ROBUST (1228 primes tested)

**Pattern**: Primes have ~2× higher R than composites (ratio 1.64-2.16x).

**Universal**: All mod 8 classes show this.

**But**: ❌ NO EXPLANATION

**Next**: Need theory:
- Why do primes have higher R?
- CF period connection?
- Algebraic structure?

### 2. CF Period Correlation (Known)

**Status**: ✅ ALREADY IN STATUS.MD (r=0.82)

**From previous work**:
```
R(D) vs period: r = +0.82  (strong!)
```

**Next**: Derive theoretical relationship:
- period(√n) from n mod 8?
- period → R formula?
- Why primes have longer periods?

### 3. Rational Coefficients (Interesting)

**Status**: 🔬 NUMERICAL (no theory)

**Finding**: Denominators 18-113, mostly reasonable fractions.

**Examples**:
- mod 7: α=3/22, β=5/18, const=13/19 (simplest)
- mod 1: α=3/46, β=25/38, const=20/21

**Question**: Do these relate to CF structure? Class numbers? Genus theory?

**But**: Without theory, just curve fitting.

---

## Lessons Learned

### 1. Theory Before Fitting

**Wrong approach** (what we did):
```
1. Fit model R ~ g(mod8) × (1 + α·dist - β·M)
2. Get rational coefficients
3. Try to interpret
```

**Right approach** (what we should do):
```
1. Understand CF structure for √n
2. Derive period formula
3. Connect period → R theoretically
4. Test predictions
```

### 2. Metrics Matter

**Distance correlation**:
- Original (wrong): 0.739 on log scale with absolute error
- Corrected: 0.197 with relative error on exponential scale

**Factor of 4 difference!**

**Always**: Use scale-appropriate metrics (relative for exponential quantities).

### 3. Empirical ≠ Explained

**Prime bifurcation**:
- ✅ Observed: 1228 primes, 0 counterexamples
- ❌ Explained: No mechanism

**Until we know WHY, it's just a pattern, not understanding.**

### 4. Ignore Known Results at Your Peril

**CF period**: r=0.82 correlation (STATUS.md)

**Us**: Spent 6 hours fitting dist (r=0.197) and stratifying by isPrime.

**Should have**: Started with "Why does CF period correlate 0.82?"

---

## Next Steps (Correct Path)

### Priority 1: CF Period Analysis

**Goal**: Understand period(√n) → R(n) mechanism.

**Tasks**:
1. Measure period for 1000+ values of n
2. Find formula: period(n) from n mod 8, primality, etc.
3. Derive theoretical relationship: R ~ f(period)
4. Test: Does this explain 82% variance?

**Why this**: Already know r=0.82, strongest predictor.

### Priority 2: Prime Structure Theory

**Goal**: Explain why primes have 2× higher R.

**Hypotheses to test**:
1. Primes have longer CF periods (empirical test)
2. M(p) = 0 → simpler CF structure → longer period?
3. Connection to primality testing (Lucas-Lehmer uses iteration)?

**Approach**: Theory first, then verify.

### Priority 3: Recursive Distance

**Idea** (untested):
```
n = k² + c₁
c₁ = k₁² + c₂
c₂ = k₂² + c₃
...
```

**Question**: Does R(n) depend on depth/structure of this chain?

**Why interesting**: Could explain variance not captured by simple dist.

### Priority 4: Algebraic Operations

**Question**: Is there algebraic structure?
```
R(p×q) = f(R(p), R(q))?
R(p+q) = g(R(p), R(q))?
```

**Why**: Would reveal deep structure (group? semigroup?).

---

## Files Created (To Archive or Delete)

**ML scripts** (archive, don't use):
```
scripts/rational_coefficient_fit.wl       - Rational fit
scripts/stratified_model_fit.wl           - Prime/composite split
scripts/analyze_prediction_errors.wl      - Error analysis
scripts/investigate_mod5_anomaly.wl       - Mod 5 investigation
scripts/test_prime_composite_bifurcation.wl - Bifurcation universality
```

**Falsification tests** (keep, useful):
```
scripts/falsification_test_v2.wl          - Corrected metrics
scripts/falsify_mod8_claim.wl             - Egypt.wl theorem test (1228 primes)
```

**Documents**:
```
docs/mod5-bifurcation.md                  - Rename to prime-bifurcation-universal.md
```

---

## Handoff to Web Claude

**Task**: Prove (or find reference for) Egypt.wl mod 8 theorem:

```
For prime p and fundamental Pell solution x² - py² = 1:
  p ≡ 7 (mod 8) ⟺ x ≡ +1 (mod p)
  p ≡ 1,3 (mod 8) ⟺ x ≡ -1 (mod p)
```

**Evidence**:
- 52 primes (original test)
- 1228 primes < 10000 (our falsification attempt)
- **0 counterexamples**

**Status on review-handoff branch**: No proof achieved after 2 hours, multiple approaches tried.

**Recommendation**:
1. Try MathOverflow (draft question exists in docs/)
2. Or deep dive genus theory (Rédei symbols)
3. Or accept as numerically verified and move on

**Our assumption**: We proceed assuming it's TRUE (confidence 99%+).

---

## Meta-Commentary

**Quote from user**: "nestačilo by se zatím omezit jen na primes a později semiprimes, atackovat composites je šílené v této fázi, neztrácíme se?"

**Answer**: Yes, we got lost. ❌

**What went wrong**:
1. Started ML fitting instead of theory
2. Ignored strongest predictor (CF period)
3. Overengineered (stratification, rational coefficients)
4. Lost sight of goal: MECHANISM not PREDICTION

**Recovery**:
- Document failures honestly ✓
- Return to CF period analysis
- Focus on primes only
- Theory before fitting

---

**Created**: 2025-11-17
**Time wasted**: 6 hours
**Lessons learned**: Valuable (don't repeat!)
**Next session**: CF period analysis (the right way)

---

🤖 Generated with Claude Code (with humility)
Co-Authored-By: Claude <noreply@anthropic.com>
