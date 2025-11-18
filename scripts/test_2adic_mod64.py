#!/usr/bin/env python3
"""
Test: Can p mod 64 (or higher) determine EXACT ν₂(x₀) for variable cases?

Variable cases:
  p ≡ 15 (mod 32): ν₂(x₀) ∈ {4,5,6,7,8,9}
  p ≡ 31 (mod 32): ν₂(x₀) ∈ {4,5,6,7,8,9}

Question: Does p mod 64 (or mod 128, 256, ...) predict exact value?
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

def test_mod_higher_powers(primes, base_mod_class):
    """Test if p mod higher powers predicts ν₂(x₀)"""
    results = []

    for p in primes:
        if p % 32 != base_mod_class:
            continue

        x0, y0 = pell_fundamental_solution(p)
        nu2 = two_adic_valuation(x0)

        results.append({
            'p': p,
            'p_mod_32': p % 32,
            'p_mod_64': p % 64,
            'p_mod_128': p % 128,
            'p_mod_256': p % 256,
            'nu2_x0': nu2
        })

    return results

def analyze_correlation(results, mod_power):
    """Check if p mod 2^k determines ν₂(x₀) uniquely"""
    by_mod = {}
    for r in results:
        key = r[f'p_mod_{mod_power}']
        if key not in by_mod:
            by_mod[key] = []
        by_mod[key].append(r['nu2_x0'])

    print(f"\nCorrelation: p mod {mod_power} → ν₂(x₀)")
    print("-" * 80)

    deterministic_count = 0
    total_classes = 0

    for mod_val in sorted(by_mod.keys()):
        nu2_vals = by_mod[mod_val]
        unique_nu2 = set(nu2_vals)

        is_deterministic = len(unique_nu2) == 1

        if is_deterministic:
            deterministic_count += 1

        total_classes += 1

        if len(nu2_vals) >= 3:  # Only show classes with enough samples
            from collections import Counter
            counts = Counter(nu2_vals)

            status = "DETERMINISTIC" if is_deterministic else "VARIABLE"
            print(f"p ≡ {mod_val:3d} (mod {mod_power}): n={len(nu2_vals):3d} → {status}")

            if is_deterministic:
                print(f"  ν₂(x₀) = {list(unique_nu2)[0]} ALWAYS")
            else:
                print(f"  ν₂(x₀) distribution:")
                for nu2 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2] / len(nu2_vals)
                    print(f"    {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    print()
    print(f"Summary: {deterministic_count}/{total_classes} classes are deterministic")

    return deterministic_count == total_classes

def main():
    # Get all primes up to 10000
    test_primes = [p for p in range(7, 10000) if is_prime(p) and p % 8 == 7]

    print("=" * 80)
    print("TESTING HIGHER 2-ADIC REFINEMENT")
    print("=" * 80)
    print()

    # Test p ≡ 15 (mod 32) - variable case
    print("CASE: p ≡ 15 (mod 32)")
    print("=" * 80)
    results_15 = test_mod_higher_powers(test_primes, 15)
    print(f"Sample size: {len(results_15)} primes")

    # Try mod 64
    det_64 = analyze_correlation(results_15, 64)

    if not det_64:
        # Try mod 128
        det_128 = analyze_correlation(results_15, 128)

    if not det_64 and not det_128:
        # Try mod 256
        det_256 = analyze_correlation(results_15, 256)

    print()
    print("=" * 80)

    # Test p ≡ 31 (mod 32) - variable case
    print("CASE: p ≡ 31 (mod 32)")
    print("=" * 80)
    results_31 = test_mod_higher_powers(test_primes, 31)
    print(f"Sample size: {len(results_31)} primes")

    # Try mod 64
    det_64 = analyze_correlation(results_31, 64)

    if not det_64:
        # Try mod 128
        det_128 = analyze_correlation(results_31, 128)

    if not det_64 and not det_128:
        # Try mod 256
        det_256 = analyze_correlation(results_31, 256)

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print("If no deterministic pattern found at mod 256, then:")
    print("  → 2-adic valuation is NOT fully determined by p mod 2^k")
    print("  → Requires deeper structure (CF period? class group?)")
    print()

if __name__ == '__main__':
    main()
