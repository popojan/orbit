#!/usr/bin/env python3
"""
p+1 duality attack: Does p+1 structure also predict CF period?

Motivation:
- p-1 structure gives r = +0.450 (moderate)
- Duality p-1 ↔ p+1 manifested in:
  * p mod 8 symmetry
  * Center norm sign antisymmetry
  * Genus theory splitting (both p-1 and p+1)

Hypothesis:
1. p+1 structure correlates with CF period (dual to p-1)
2. Combination (p-1, p+1) improves prediction
3. Antisymmetric features: ω(p+1) - ω(p-1), etc.

Exploration mode: ASSUME strong numerical evidence (n≥1000)
Sample: 1000+ primes p ≡ 3 (mod 4), random from [3, 50000]
"""

from sympy import isprime, factorint, primefactors, sqrt
from sympy.ntheory.continued_fraction import continued_fraction_periodic
import numpy as np
import random
from collections import defaultdict

def cf_period(p):
    """CF period length."""
    cf = continued_fraction_periodic(0, 1, p)
    return len(cf[1])

def omega(n):
    """Distinct prime factors."""
    return len(factorint(n))

def Omega(n):
    """Total prime factors with multiplicity."""
    factors = factorint(n)
    return sum(factors.values())

def lpf(n):
    """Largest prime factor."""
    factors = factorint(n)
    return max(factors.keys()) if factors else 1

def radical(n):
    """Product of distinct prime factors."""
    return int(np.prod(primefactors(n)))

def duality_attack():
    """Test p+1 structure vs CF period (dual to p-1)."""

    print("=" * 80)
    print("p+1 DUALITY ATTACK: Testing p+1 Structure vs CF Period")
    print("=" * 80)
    print()

    # Generate large sample: 1000+ primes p ≡ 3 (mod 4)
    # Random sampling from [3, 50000]
    print("Generating sample: 1000+ primes p ≡ 3 (mod 4) from [3, 50000]...")
    print("Progress: ", end="", flush=True)

    candidates = [p for p in range(3, 50001) if isprime(p) and p % 4 == 3]

    # Random sample of 1200 (to ensure 1000+ after any filtering)
    sample_size = min(1200, len(candidates))
    sample_primes = random.sample(candidates, sample_size)
    sample_primes.sort()

    print(f"selected {len(sample_primes)} primes")
    print()

    results = []

    for i, p in enumerate(sample_primes):
        if (i+1) % 100 == 0:
            print(f"{i+1} ", end="", flush=True)

        # CF period
        period = cf_period(p)

        # p-1 structure
        pm1 = p - 1
        omega_pm1 = omega(pm1)
        Omega_pm1 = Omega(pm1)
        lpf_pm1 = lpf(pm1)
        rad_pm1 = radical(pm1)

        # p+1 structure (DUAL!)
        pp1 = p + 1
        omega_pp1 = omega(pp1)
        Omega_pp1 = Omega(pp1)
        lpf_pp1 = lpf(pp1)
        rad_pp1 = radical(pp1)

        # Antisymmetric features
        omega_diff = omega_pp1 - omega_pm1  # Antisymmetry
        omega_sum = omega_pp1 + omega_pm1   # Total complexity
        Omega_diff = Omega_pp1 - Omega_pm1
        Omega_sum = Omega_pp1 + Omega_pm1

        results.append({
            'p': p,
            'period': period,
            # p-1
            'omega_pm1': omega_pm1,
            'Omega_pm1': Omega_pm1,
            'lpf_pm1': lpf_pm1,
            'rad_pm1': rad_pm1,
            # p+1 (DUAL)
            'omega_pp1': omega_pp1,
            'Omega_pp1': Omega_pp1,
            'lpf_pp1': lpf_pp1,
            'rad_pp1': rad_pp1,
            # Antisymmetric
            'omega_diff': omega_diff,
            'omega_sum': omega_sum,
            'Omega_diff': Omega_diff,
            'Omega_sum': Omega_sum
        })

    print(f"\n\nCompleted analysis of {len(results)} primes")
    print()

    # Extract arrays
    periods = np.array([r['period'] for r in results])

    # p-1 features
    omega_pm1 = np.array([r['omega_pm1'] for r in results])
    Omega_pm1 = np.array([r['Omega_pm1'] for r in results])
    lpf_pm1 = np.array([r['lpf_pm1'] for r in results])
    rad_pm1 = np.array([r['rad_pm1'] for r in results])

    # p+1 features (DUAL)
    omega_pp1 = np.array([r['omega_pp1'] for r in results])
    Omega_pp1 = np.array([r['Omega_pp1'] for r in results])
    lpf_pp1 = np.array([r['lpf_pp1'] for r in results])
    rad_pp1 = np.array([r['rad_pp1'] for r in results])

    # Antisymmetric features
    omega_diff = np.array([r['omega_diff'] for r in results])
    omega_sum = np.array([r['omega_sum'] for r in results])
    Omega_diff = np.array([r['Omega_diff'] for r in results])
    Omega_sum = np.array([r['Omega_sum'] for r in results])

    log_rad_pm1 = np.log(rad_pm1)
    log_rad_pp1 = np.log(rad_pp1)
    log_lpf_pm1 = np.log(lpf_pm1)
    log_lpf_pp1 = np.log(lpf_pp1)

    # Correlations
    print("=" * 80)
    print("CORRELATION ANALYSIS: p-1 vs p+1 vs period")
    print("=" * 80)
    print()

    print("p-1 structure (baseline from previous attack):")
    corr_omega_pm1 = np.corrcoef(omega_pm1, periods)[0, 1]
    corr_Omega_pm1 = np.corrcoef(Omega_pm1, periods)[0, 1]
    corr_lpf_pm1 = np.corrcoef(lpf_pm1, periods)[0, 1]
    corr_log_rad_pm1 = np.corrcoef(log_rad_pm1, periods)[0, 1]

    print(f"  ω(p-1)       vs period: r = {corr_omega_pm1:+.3f}")
    print(f"  Ω(p-1)       vs period: r = {corr_Omega_pm1:+.3f}")
    print(f"  lpf(p-1)     vs period: r = {corr_lpf_pm1:+.3f}")
    print(f"  log(rad(p-1)) vs period: r = {corr_log_rad_pm1:+.3f}")
    print()

    print("p+1 structure (DUAL TEST):")
    corr_omega_pp1 = np.corrcoef(omega_pp1, periods)[0, 1]
    corr_Omega_pp1 = np.corrcoef(Omega_pp1, periods)[0, 1]
    corr_lpf_pp1 = np.corrcoef(lpf_pp1, periods)[0, 1]
    corr_log_rad_pp1 = np.corrcoef(log_rad_pp1, periods)[0, 1]

    print(f"  ω(p+1)       vs period: r = {corr_omega_pp1:+.3f}")
    print(f"  Ω(p+1)       vs period: r = {corr_Omega_pp1:+.3f}")
    print(f"  lpf(p+1)     vs period: r = {corr_lpf_pp1:+.3f}")
    print(f"  log(rad(p+1)) vs period: r = {corr_log_rad_pp1:+.3f}")
    print()

    print("Antisymmetric features (p+1 - p-1):")
    corr_omega_diff = np.corrcoef(omega_diff, periods)[0, 1]
    corr_Omega_diff = np.corrcoef(Omega_diff, periods)[0, 1]

    print(f"  ω(p+1) - ω(p-1)  vs period: r = {corr_omega_diff:+.3f}")
    print(f"  Ω(p+1) - Ω(p-1)  vs period: r = {corr_Omega_diff:+.3f}")
    print()

    print("Symmetric features (p+1 + p-1):")
    corr_omega_sum = np.corrcoef(omega_sum, periods)[0, 1]
    corr_Omega_sum = np.corrcoef(Omega_sum, periods)[0, 1]

    print(f"  ω(p+1) + ω(p-1)  vs period: r = {corr_omega_sum:+.3f}")
    print(f"  Ω(p+1) + Ω(p-1)  vs period: r = {corr_Omega_sum:+.3f}")
    print()

    # Best single predictor
    all_corrs = {
        'ω(p-1)': corr_omega_pm1,
        'Ω(p-1)': corr_Omega_pm1,
        'lpf(p-1)': corr_lpf_pm1,
        'log(rad(p-1))': corr_log_rad_pm1,
        'ω(p+1)': corr_omega_pp1,
        'Ω(p+1)': corr_Omega_pp1,
        'lpf(p+1)': corr_lpf_pp1,
        'log(rad(p+1))': corr_log_rad_pp1,
        'ω(p+1) - ω(p-1)': corr_omega_diff,
        'Ω(p+1) - Ω(p-1)': corr_Omega_diff,
        'ω(p+1) + ω(p-1)': corr_omega_sum,
        'Ω(p+1) + Ω(p-1)': corr_Omega_sum
    }

    best_feature, best_corr = max(all_corrs.items(), key=lambda x: abs(x[1]))

    print(f"✓ Best single predictor: {best_feature} (r = {best_corr:+.3f})")
    print()

    # Multivariate: try combining best features
    print("=" * 80)
    print("MULTIVARIATE ANALYSIS: Combining p-1 and p+1")
    print("=" * 80)
    print()

    # Linear combination test: α·ω(p-1) + β·ω(p+1)
    # Use least squares to find best α, β
    from sklearn.linear_model import LinearRegression

    # Model 1: ω(p-1) + ω(p+1)
    X1 = np.column_stack([omega_pm1, omega_pp1])
    model1 = LinearRegression().fit(X1, periods)
    r2_model1 = model1.score(X1, periods)

    print("Model 1: period ~ α·ω(p-1) + β·ω(p+1)")
    print(f"  α = {model1.coef_[0]:+.3f}")
    print(f"  β = {model1.coef_[1]:+.3f}")
    print(f"  R² = {r2_model1:.3f} (variance explained)")
    print(f"  r = {np.sqrt(r2_model1):+.3f}")
    print()

    # Model 2: ω(p-1), ω(p+1), Ω(p-1), Ω(p+1)
    X2 = np.column_stack([omega_pm1, omega_pp1, Omega_pm1, Omega_pp1])
    model2 = LinearRegression().fit(X2, periods)
    r2_model2 = model2.score(X2, periods)

    print("Model 2: period ~ ω(p-1) + ω(p+1) + Ω(p-1) + Ω(p+1)")
    print(f"  Coefficients: {model2.coef_}")
    print(f"  R² = {r2_model2:.3f}")
    print(f"  r = {np.sqrt(r2_model2):+.3f}")
    print()

    # Model 3: Sum and difference (antisymmetry)
    X3 = np.column_stack([omega_sum, omega_diff])
    model3 = LinearRegression().fit(X3, periods)
    r2_model3 = model3.score(X3, periods)

    print("Model 3: period ~ (ω(p+1) + ω(p-1)) + (ω(p+1) - ω(p-1))")
    print(f"  Coef(sum):  {model3.coef_[0]:+.3f}")
    print(f"  Coef(diff): {model3.coef_[1]:+.3f}")
    print(f"  R² = {r2_model3:.3f}")
    print(f"  r = {np.sqrt(r2_model3):+.3f}")
    print()

    # Comparison
    print("=" * 80)
    print("COMPARISON: Single vs Multivariate")
    print("=" * 80)
    print()

    r_omega_pm1_only = corr_omega_pm1
    r_multivariate_best = np.sqrt(max(r2_model1, r2_model2, r2_model3))

    print(f"Single predictor (ω(p-1)):           r = {r_omega_pm1_only:+.3f} → R² = {r_omega_pm1_only**2:.3f}")
    print(f"Best multivariate (p-1 AND p+1):     r = {r_multivariate_best:+.3f} → R² = {r_multivariate_best**2:.3f}")
    print()

    improvement = r_multivariate_best**2 - r_omega_pm1_only**2
    print(f"Improvement: +{100*improvement:.1f}% variance explained")
    print()

    # Duality test: Are p-1 and p+1 symmetric?
    print("=" * 80)
    print("DUALITY TEST: p-1 ↔ p+1 Symmetry")
    print("=" * 80)
    print()

    print(f"Correlation strength comparison:")
    print(f"  |r(ω(p-1), period)| = {abs(corr_omega_pm1):.3f}")
    print(f"  |r(ω(p+1), period)| = {abs(corr_omega_pp1):.3f}")
    print()

    if abs(corr_omega_pp1) > 0.3:
        print("✓ p+1 structure IS significant predictor!")
        if abs(corr_omega_pp1 - corr_omega_pm1) < 0.1:
            print("✓ SYMMETRIC: p-1 and p+1 have similar predictive power")
        else:
            print(f"~ ASYMMETRIC: p-1 stronger by {abs(corr_omega_pm1 - corr_omega_pp1):.3f}")
    else:
        print("✗ p+1 structure weak predictor (r < 0.3)")
    print()

    # Stratification by ω(p+1)
    print("=" * 80)
    print("ω(p+1) STRATIFICATION")
    print("=" * 80)
    print()

    omega_pp1_groups = defaultdict(list)
    for r in results:
        omega_pp1_groups[r['omega_pp1']].append(r['period'])

    print("Period by ω(p+1):")
    for w in sorted(omega_pp1_groups.keys())[:8]:  # First 8
        periods_group = omega_pp1_groups[w]
        if len(periods_group) >= 10:  # Only show if ≥10 samples
            print(f"  ω(p+1) = {w}: {len(periods_group):4d} primes, mean = {np.mean(periods_group):6.2f}, median = {np.median(periods_group):6.2f}")
    print()

    # Conclusion
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print()

    print(f"Dataset: {len(results)} primes p ≡ 3 (mod 4) from [3, 50000]")
    print()

    print("Key findings:")
    print(f"  1. p+1 correlation: ω(p+1) → period, r = {corr_omega_pp1:+.3f}")
    print(f"  2. p-1 correlation: ω(p-1) → period, r = {corr_omega_pm1:+.3f}")

    if abs(corr_omega_pp1) > abs(corr_omega_pm1):
        print(f"  3. ✓ p+1 STRONGER than p-1!")
    elif abs(corr_omega_pp1 - corr_omega_pm1) < 0.05:
        print(f"  3. ✓ p-1 and p+1 EQUALLY strong (duality!)")
    else:
        print(f"  3. ~ p-1 slightly stronger than p+1")

    print(f"  4. Multivariate: R² = {r_multivariate_best**2:.3f} ({100*r_multivariate_best**2:.1f}% variance)")
    print(f"  5. Improvement over single: +{100*improvement:.1f}%")
    print()

    if r_multivariate_best**2 > 0.30:
        print("✓ BREAKTHROUGH: Combined p-1 and p+1 explain >30% variance!")
        print("  → Duality pattern confirmed")
    elif r_multivariate_best**2 > 0.25:
        print("✓ SIGNIFICANT: Combined p-1 and p+1 explain >25% variance")
    else:
        print("~ MODERATE: Combined features help but variance still high")
    print()

    if abs(corr_omega_diff) > 0.2:
        print(f"✓ ANTISYMMETRY DETECTED: ω(p+1) - ω(p-1) → period, r = {corr_omega_diff:+.3f}")
        print("  → p-1 vs p+1 difference carries signal!")
    print()

    return results, {
        'corr_omega_pm1': corr_omega_pm1,
        'corr_omega_pp1': corr_omega_pp1,
        'corr_omega_sum': corr_omega_sum,
        'corr_omega_diff': corr_omega_diff,
        'r2_best': r_multivariate_best**2,
        'model_best': model2  # Save best model
    }

if __name__ == "__main__":
    random.seed(42)  # Reproducibility
    results, stats = duality_attack()
