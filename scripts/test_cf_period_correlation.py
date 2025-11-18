#!/usr/bin/env python3
"""
Test: Does CF period τ (or τ mod something) determine ν₂(x₀)?

CF period is fundamental to Pell structure.
Maybe ν₂(x₀) correlates with:
  - τ itself
  - τ mod 8, 16, 32
  - ν₂(τ)
"""

import sys
sys.path.append('/home/user/orbit/scripts')
from pell_solver_integer import pell_fundamental_solution

def is_prime(n):
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(n**0.5) + 1, 2):
        if n % i == 0:
            return False
    return True

def two_adic_valuation(n):
    if n == 0:
        return float('inf')
    val = 0
    while n % 2 == 0:
        val += 1
        n //= 2
    return val

def continued_fraction_period(D):
    """Compute CF period for √D"""
    a0 = int(D**0.5)
    if a0 * a0 == D:
        return None  # Perfect square

    P, Q = 0, 1
    a = a0

    seen = {}
    period = []
    step = 0

    while True:
        P = a * Q - P
        Q = (D - P * P) // Q
        a = (a0 + P) // Q

        state = (P, Q)
        if state in seen:
            period_start = seen[state]
            return period[period_start:]

        seen[state] = step
        period.append(a)
        step += 1

        if step > 10000:
            return None  # Safety

def test_cf_period_correlation(primes, mod_class):
    """Test CF period correlation with ν₂(x₀)"""
    results = []

    for p in primes:
        if p % 32 != mod_class:
            continue

        x0, y0 = pell_fundamental_solution(p)
        period = continued_fraction_period(p)

        if period is None:
            continue

        tau = len(period)
        nu2_x0 = two_adic_valuation(x0)
        nu2_tau = two_adic_valuation(tau)

        results.append({
            'p': p,
            'tau': tau,
            'tau_mod_8': tau % 8,
            'tau_mod_16': tau % 16,
            'nu2_tau': nu2_tau,
            'nu2_x0': nu2_x0
        })

    return results

def analyze_cf_correlation(results, mod_class):
    """Analyze CF period correlation"""
    print("=" * 80)
    print(f"CASE: p ≡ {mod_class} (mod 32)")
    print("=" * 80)
    print(f"Sample size: {len(results)}")
    print()

    # τ mod 8
    print("Correlation: τ mod 8 → ν₂(x₀)")
    print("-" * 80)
    by_tau_mod_8 = {}
    for r in results:
        key = r['tau_mod_8']
        if key not in by_tau_mod_8:
            by_tau_mod_8[key] = []
        by_tau_mod_8[key].append(r['nu2_x0'])

    for val in sorted(by_tau_mod_8.keys()):
        nu2_vals = by_tau_mod_8[val]
        from collections import Counter
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 3:
            status = "DETERMINISTIC" if is_det else "VARIABLE"
            print(f"\nτ ≡ {val} (mod 8): {len(nu2_vals)} primes → {status}")

            if is_det:
                print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
            else:
                for nu2 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2] / len(nu2_vals)
                    print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    # τ mod 16
    print()
    print("Correlation: τ mod 16 → ν₂(x₀)")
    print("-" * 80)
    by_tau_mod_16 = {}
    for r in results:
        key = r['tau_mod_16']
        if key not in by_tau_mod_16:
            by_tau_mod_16[key] = []
        by_tau_mod_16[key].append(r['nu2_x0'])

    for val in sorted(by_tau_mod_16.keys()):
        nu2_vals = by_tau_mod_16[val]
        from collections import Counter
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 3:
            status = "DETERMINISTIC" if is_det else "VARIABLE"
            print(f"\nτ ≡ {val} (mod 16): {len(nu2_vals)} primes → {status}")

            if is_det:
                print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
            else:
                for nu2 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2] / len(nu2_vals)
                    print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    # ν₂(τ)
    print()
    print("Correlation: ν₂(τ) → ν₂(x₀)")
    print("-" * 80)
    by_nu2_tau = {}
    for r in results:
        key = r['nu2_tau']
        if key not in by_nu2_tau:
            by_nu2_tau[key] = []
        by_nu2_tau[key].append(r['nu2_x0'])

    for val in sorted(by_nu2_tau.keys()):
        nu2_vals = by_nu2_tau[val]
        from collections import Counter
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 3:
            status = "DETERMINISTIC" if is_det else "VARIABLE"
            print(f"\nν₂(τ) = {val}: {len(nu2_vals)} primes → {status}")

            if is_det:
                print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
            else:
                for nu2 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2] / len(nu2_vals)
                    print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    print()

def main():
    test_primes = [p for p in range(7, 10000) if is_prime(p) and p % 8 == 7]

    # Test p ≡ 15 (mod 32)
    results_15 = test_cf_period_correlation(test_primes, 15)
    analyze_cf_correlation(results_15, 15)

    print()
    print("=" * 80)
    print()

    # Test p ≡ 31 (mod 32)
    results_31 = test_cf_period_correlation(test_primes, 31)
    analyze_cf_correlation(results_31, 31)

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print("If CF period structure determines ν₂(x₀):")
    print("  → Will see deterministic pattern")
    print()
    print("Otherwise:")
    print("  → ν₂(x₀) may be 'random' (chaotic, non-computable from simple p properties)")
    print("  → OR requires class group / genus theory")
    print()

if __name__ == '__main__':
    main()
