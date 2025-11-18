#!/usr/bin/env python3
"""
Test: Does ν₂(p±1) determine ν₂(x₀) for variable cases?

For p ≡ 15, 31 (mod 32), we know ν₂(x₀) varies.

Hypothesis: Maybe ν₂(p-1) or ν₂(p+1) correlates with ν₂(x₀)?
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

def test_nu2_correlation(primes, mod_class):
    """Test correlation between ν₂(p±1) and ν₂(x₀)"""
    results = []

    for p in primes:
        if p % 32 != mod_class:
            continue

        x0, y0 = pell_fundamental_solution(p)

        nu2_p_minus_1 = two_adic_valuation(p - 1)
        nu2_p_plus_1 = two_adic_valuation(p + 1)
        nu2_x0 = two_adic_valuation(x0)

        results.append({
            'p': p,
            'nu2_p_minus_1': nu2_p_minus_1,
            'nu2_p_plus_1': nu2_p_plus_1,
            'nu2_x0': nu2_x0
        })

    return results

def analyze_correlation(results, mod_class):
    """Analyze correlation patterns"""
    print("=" * 80)
    print(f"CASE: p ≡ {mod_class} (mod 32)")
    print("=" * 80)
    print(f"Sample size: {len(results)}")
    print()

    # Group by ν₂(p-1)
    print("Correlation: ν₂(p-1) → ν₂(x₀)")
    print("-" * 80)
    by_nu2_p_minus_1 = {}
    for r in results:
        key = r['nu2_p_minus_1']
        if key not in by_nu2_p_minus_1:
            by_nu2_p_minus_1[key] = []
        by_nu2_p_minus_1[key].append(r['nu2_x0'])

    for val in sorted(by_nu2_p_minus_1.keys()):
        nu2_x0_vals = by_nu2_p_minus_1[val]
        from collections import Counter
        counts = Counter(nu2_x0_vals)

        print(f"\nν₂(p-1) = {val}: {len(nu2_x0_vals)} primes")
        for nu2_x0 in sorted(counts.keys()):
            pct = 100.0 * counts[nu2_x0] / len(nu2_x0_vals)
            print(f"  ν₂(x₀) = {nu2_x0:2d}: {counts[nu2_x0]:3d}/{len(nu2_x0_vals)} = {pct:5.1f}%")

    # Group by ν₂(p+1)
    print()
    print("Correlation: ν₂(p+1) → ν₂(x₀)")
    print("-" * 80)
    by_nu2_p_plus_1 = {}
    for r in results:
        key = r['nu2_p_plus_1']
        if key not in by_nu2_p_plus_1:
            by_nu2_p_plus_1[key] = []
        by_nu2_p_plus_1[key].append(r['nu2_x0'])

    for val in sorted(by_nu2_p_plus_1.keys()):
        nu2_x0_vals = by_nu2_p_plus_1[val]
        from collections import Counter
        counts = Counter(nu2_x0_vals)

        print(f"\nν₂(p+1) = {val}: {len(nu2_x0_vals)} primes")
        for nu2_x0 in sorted(counts.keys()):
            pct = 100.0 * counts[nu2_x0] / len(nu2_x0_vals)
            print(f"  ν₂(x₀) = {nu2_x0:2d}: {counts[nu2_x0]:3d}/{len(nu2_x0_vals)} = {pct:5.1f}%")

    # Joint distribution
    print()
    print("Joint: (ν₂(p-1), ν₂(p+1)) → ν₂(x₀)")
    print("-" * 80)
    by_joint = {}
    for r in results:
        key = (r['nu2_p_minus_1'], r['nu2_p_plus_1'])
        if key not in by_joint:
            by_joint[key] = []
        by_joint[key].append(r['nu2_x0'])

    for (nu2_p_m1, nu2_p_p1) in sorted(by_joint.keys()):
        nu2_x0_vals = by_joint[(nu2_p_m1, nu2_p_p1)]
        from collections import Counter
        counts = Counter(nu2_x0_vals)

        unique = len(counts)
        is_deterministic = (unique == 1)

        if len(nu2_x0_vals) >= 3:  # Only show if enough samples
            status = "DETERMINISTIC" if is_deterministic else "VARIABLE"
            print(f"\n(ν₂(p-1), ν₂(p+1)) = ({nu2_p_m1}, {nu2_p_p1}): {len(nu2_x0_vals)} primes → {status}")

            if is_deterministic:
                print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
            else:
                for nu2_x0 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2_x0] / len(nu2_x0_vals)
                    print(f"  ν₂(x₀) = {nu2_x0:2d}: {counts[nu2_x0]:2d}/{len(nu2_x0_vals)} = {pct:5.1f}%")

    print()

def main():
    # Get all primes up to 10000
    test_primes = [p for p in range(7, 10000) if is_prime(p) and p % 8 == 7]

    # Test p ≡ 15 (mod 32)
    results_15 = test_nu2_correlation(test_primes, 15)
    analyze_correlation(results_15, 15)

    print()
    print("=" * 80)
    print()

    # Test p ≡ 31 (mod 32)
    results_31 = test_nu2_correlation(test_primes, 31)
    analyze_correlation(results_31, 31)

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print("If ν₂(p±1) determines ν₂(x₀), we'll see:")
    print("  → Deterministic pattern in joint distribution")
    print("  → Each (ν₂(p-1), ν₂(p+1)) pair maps to unique ν₂(x₀)")
    print()
    print("If still variable:")
    print("  → Need even deeper structure (factorization? CF period?)")
    print()

if __name__ == '__main__':
    main()
