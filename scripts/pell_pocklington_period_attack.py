#!/usr/bin/env python3
"""
Pocklington attack: Predict CF period from p-1 structure.

Hypothesis: Arithmetic complexity of p-1 correlates with CF period length.

Test multiple structural properties:
1. ω(p-1) - distinct prime factors
2. Ω(p-1) - total prime factors (with multiplicity)
3. lpf(p-1) - largest prime factor
4. B-smoothness - all factors below bound B
5. 2-valuation - v₂(p-1) = highest power of 2 dividing p-1
6. Radical - product of distinct prime factors

Strategy: Find which property best predicts period.
"""

from sympy import isprime, factorint, primefactors, sqrt
from sympy.ntheory.continued_fraction import continued_fraction_periodic
import numpy as np
from collections import Counter, defaultdict
import math

def cf_period_length(p):
    """Compute continued fraction period length for √p."""
    cf = continued_fraction_periodic(0, 1, p)
    return len(cf[1])

def omega_distinct(n):
    """Number of distinct prime factors ω(n)."""
    return len(factorint(n))

def omega_total(n):
    """Total number of prime factors Ω(n) with multiplicity."""
    factors = factorint(n)
    return sum(factors.values())

def largest_prime_factor(n):
    """Largest prime factor of n."""
    factors = factorint(n)
    return max(factors.keys()) if factors else 1

def two_valuation(n):
    """v₂(n) = highest power of 2 dividing n."""
    if n % 2 != 0:
        return 0
    factors = factorint(n)
    return factors.get(2, 0)

def is_B_smooth(n, B):
    """Check if all prime factors of n are ≤ B."""
    return largest_prime_factor(n) <= B

def radical(n):
    """Product of distinct prime factors."""
    return np.prod(primefactors(n))

def pocklington_analysis():
    """Comprehensive p-1 structure vs CF period analysis."""

    print("=" * 80)
    print("POCKLINGTON ATTACK: p-1 Structure → CF Period Prediction")
    print("=" * 80)
    print()

    print("Scanning primes p ≡ 3 (mod 4) up to 10000...")
    print("Progress: ", end="", flush=True)

    primes = []
    for p in range(3, 10000):
        if p % 1000 == 0:
            print(f"{p} ", end="", flush=True)
        if isprime(p) and p % 4 == 3:
            primes.append(p)

    print(f"\n\nAnalyzing {len(primes)} primes...")
    print()

    results = []

    for p in primes:
        period = cf_period_length(p)

        # p-1 structure
        pm1 = p - 1

        w_distinct = omega_distinct(pm1)
        w_total = omega_total(pm1)
        lpf = largest_prime_factor(pm1)
        v2 = two_valuation(pm1)
        rad = radical(pm1)

        # B-smoothness
        smooth_10 = is_B_smooth(pm1, 10)
        smooth_20 = is_B_smooth(pm1, 20)
        smooth_50 = is_B_smooth(pm1, 50)
        smooth_100 = is_B_smooth(pm1, 100)

        results.append({
            'p': p,
            'period': period,
            'pm1': pm1,
            'omega': w_distinct,
            'Omega': w_total,
            'lpf': lpf,
            'v2': v2,
            'radical': rad,
            'smooth_10': smooth_10,
            'smooth_20': smooth_20,
            'smooth_50': smooth_50,
            'smooth_100': smooth_100
        })

    print(f"Completed analysis of {len(results)} primes")
    print()

    # Extract vectors for correlation
    periods = np.array([r['period'] for r in results])
    omegas = np.array([r['omega'] for r in results])
    Omegas = np.array([r['Omega'] for r in results])
    lpfs = np.array([r['lpf'] for r in results])
    v2s = np.array([r['v2'] for r in results])
    radicals = np.array([r['radical'] for r in results])

    log_radicals = np.log(radicals)
    log_lpfs = np.log(lpfs)

    # Correlations
    print("=" * 80)
    print("CORRELATION ANALYSIS: p-1 structure vs CF period")
    print("=" * 80)
    print()

    corr_omega = np.corrcoef(omegas, periods)[0, 1]
    corr_Omega = np.corrcoef(Omegas, periods)[0, 1]
    corr_lpf = np.corrcoef(lpfs, periods)[0, 1]
    corr_log_lpf = np.corrcoef(log_lpfs, periods)[0, 1]
    corr_v2 = np.corrcoef(v2s, periods)[0, 1]
    corr_radical = np.corrcoef(radicals, periods)[0, 1]
    corr_log_radical = np.corrcoef(log_radicals, periods)[0, 1]

    print("Correlation coefficients:")
    print(f"  ω(p-1)       vs period: r = {corr_omega:+.3f}")
    print(f"  Ω(p-1)       vs period: r = {corr_Omega:+.3f}")
    print(f"  lpf(p-1)     vs period: r = {corr_lpf:+.3f}")
    print(f"  log(lpf)     vs period: r = {corr_log_lpf:+.3f}")
    print(f"  v₂(p-1)      vs period: r = {corr_v2:+.3f}")
    print(f"  rad(p-1)     vs period: r = {corr_radical:+.3f}")
    print(f"  log(rad)     vs period: r = {corr_log_radical:+.3f}")
    print()

    # Best predictor
    correlations = {
        'ω(p-1)': corr_omega,
        'Ω(p-1)': corr_Omega,
        'lpf(p-1)': corr_lpf,
        'log(lpf)': corr_log_lpf,
        'v₂(p-1)': corr_v2,
        'rad(p-1)': corr_radical,
        'log(rad)': corr_log_radical
    }

    best_pred, best_corr = max(correlations.items(), key=lambda x: abs(x[1]))

    print(f"✓ Best predictor: {best_pred} (r = {best_corr:+.3f})")
    print()

    # Smoothness analysis
    print("=" * 80)
    print("B-SMOOTHNESS ANALYSIS")
    print("=" * 80)
    print()

    for B in [10, 20, 50, 100]:
        smooth_key = f'smooth_{B}'
        smooth_primes = [r for r in results if r[smooth_key]]
        rough_primes = [r for r in results if not r[smooth_key]]

        if smooth_primes and rough_primes:
            smooth_periods = [r['period'] for r in smooth_primes]
            rough_periods = [r['period'] for r in rough_primes]

            print(f"B = {B}:")
            print(f"  {B}-smooth: {len(smooth_primes):4d} primes, mean period = {np.mean(smooth_periods):6.2f}")
            print(f"  {B}-rough:  {len(rough_primes):4d} primes, mean period = {np.mean(rough_periods):6.2f}")
            print(f"  Ratio: {np.mean(rough_periods) / np.mean(smooth_periods):.2f}×")
            print()

    # ω(p-1) stratification (from previous analysis)
    print("=" * 80)
    print("ω(p-1) STRATIFICATION")
    print("=" * 80)
    print()

    omega_groups = defaultdict(list)
    for r in results:
        omega_groups[r['omega']].append(r['period'])

    print("Period by ω(p-1):")
    for omega in sorted(omega_groups.keys()):
        periods_group = omega_groups[omega]
        print(f"  ω = {omega}: {len(periods_group):4d} primes, mean period = {np.mean(periods_group):6.2f}, median = {np.median(periods_group):6.2f}")
    print()

    # High vs low ω
    high_omega = [r for r in results if r['omega'] >= 4]
    low_omega = [r for r in results if r['omega'] <= 2]

    if high_omega and low_omega:
        high_periods = [r['period'] for r in high_omega]
        low_periods = [r['period'] for r in low_omega]

        print(f"High ω (≥4): {len(high_omega):4d} primes, mean period = {np.mean(high_periods):6.2f}")
        print(f"Low ω (≤2):  {len(low_omega):4d} primes, mean period = {np.mean(low_periods):6.2f}")
        print(f"Ratio: {np.mean(high_periods) / np.mean(low_periods):.2f}×")
        print()

    # lpf(p-1) stratification
    print("=" * 80)
    print("lpf(p-1) STRATIFICATION")
    print("=" * 80)
    print()

    lpf_quartiles = np.percentile(lpfs, [25, 50, 75])

    lpf_Q1 = [r for r in results if r['lpf'] <= lpf_quartiles[0]]
    lpf_Q2 = [r for r in results if lpf_quartiles[0] < r['lpf'] <= lpf_quartiles[1]]
    lpf_Q3 = [r for r in results if lpf_quartiles[1] < r['lpf'] <= lpf_quartiles[2]]
    lpf_Q4 = [r for r in results if r['lpf'] > lpf_quartiles[2]]

    print("Period by lpf(p-1) quartiles:")
    for i, (quartile, lpf_bound) in enumerate(zip([lpf_Q1, lpf_Q2, lpf_Q3, lpf_Q4],
                                                    [lpf_quartiles[0], lpf_quartiles[1], lpf_quartiles[2], np.inf]), 1):
        if quartile:
            periods_q = [r['period'] for r in quartile]
            lpfs_q = [r['lpf'] for r in quartile]
            print(f"  Q{i} (lpf ≤ {lpf_bound:6.0f}): {len(quartile):4d} primes, mean period = {np.mean(periods_q):6.2f}, mean lpf = {np.mean(lpfs_q):6.0f}")
    print()

    # 2-valuation analysis
    print("=" * 80)
    print("2-VALUATION ANALYSIS")
    print("=" * 80)
    print()

    v2_groups = defaultdict(list)
    for r in results:
        v2_groups[r['v2']].append(r['period'])

    print("Period by v₂(p-1):")
    for v2 in sorted(v2_groups.keys())[:10]:  # First 10 for readability
        periods_group = v2_groups[v2]
        print(f"  v₂ = {v2:2d}: {len(periods_group):4d} primes, mean period = {np.mean(periods_group):6.2f}")
    print()

    # Top 20 hardest Pell with p-1 structure
    print("=" * 80)
    print("TOP 20 HARDEST PELL: p-1 Structure")
    print("=" * 80)
    print()

    results_sorted = sorted(results, key=lambda x: -x['period'])

    print("    p    period  ω(p-1)  Ω(p-1)  lpf(p-1)  v₂(p-1)  p-1 factorization")
    print("-" * 90)

    for r in results_sorted[:20]:
        pm1_factors = factorint(r['pm1'])
        factorization = ' · '.join([f"{p}^{e}" if e > 1 else str(p) for p, e in sorted(pm1_factors.items())])

        print(f"  {r['p']:5d}   {r['period']:4d}     {r['omega']:2d}      {r['Omega']:2d}      {r['lpf']:5d}     {r['v2']:2d}      {factorization}")

    print()

    # Bottom 20 easiest Pell with p-1 structure
    print("=" * 80)
    print("BOTTOM 20 EASIEST PELL: p-1 Structure")
    print("=" * 80)
    print()

    print("    p    period  ω(p-1)  Ω(p-1)  lpf(p-1)  v₂(p-1)  p-1 factorization")
    print("-" * 90)

    for r in results_sorted[-20:]:
        pm1_factors = factorint(r['pm1'])
        factorization = ' · '.join([f"{p}^{e}" if e > 1 else str(p) for p, e in sorted(pm1_factors.items())])

        print(f"  {r['p']:5d}   {r['period']:4d}     {r['omega']:2d}      {r['Omega']:2d}      {r['lpf']:5d}     {r['v2']:2d}      {factorization}")

    print()

    # Conclusion
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print()

    print("Pocklington structure predictors (ranked by |r|):")
    for i, (name, corr) in enumerate(sorted(correlations.items(), key=lambda x: -abs(x[1])), 1):
        print(f"  {i}. {name:12s}: r = {corr:+.3f}")
    print()

    if abs(best_corr) > 0.5:
        print(f"✓ Strong predictor found: {best_pred}")
        print(f"  Arithmetic complexity of p-1 → longer CF period")
        print()
    elif abs(best_corr) > 0.3:
        print(f"✓ Moderate predictor found: {best_pred}")
        print(f"  p-1 structure partially explains period length")
        print()
    else:
        print("✗ No strong predictor found")
        print("  p-1 structure alone insufficient for period prediction")
        print()

    print("Next steps:")
    print("  1. Test p+1 structure (different theory)")
    print("  2. Combine multiple p-1 features (multivariate regression)")
    print("  3. Genus theory connection (splitting patterns)")
    print("  4. Class field theory (conductor f divides p-1 or p+1)")
    print()

    return results

if __name__ == "__main__":
    results = pocklington_analysis()
