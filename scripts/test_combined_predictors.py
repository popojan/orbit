#!/usr/bin/env python3
"""
Test: Can COMBINATION of features determine ν₂(x₀)?

Features to combine:
  - M(p±1)
  - p mod 64
  - τ(p±1)
  - ν₂(τ) where τ is CF period

Maybe no single feature works, but joint does?
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

def count_divisors(n):
    if n <= 0:
        return 0
    count = 0
    i = 1
    while i * i <= n:
        if n % i == 0:
            count += 1
            if i * i != n:
                count += 1
        i += 1
    return count

def M(n):
    tau_n = count_divisors(n)
    return (tau_n - 1) // 2

def test_combined(primes, mod_class):
    """Test combined features"""
    results = []

    for p in primes:
        if p % 32 != mod_class:
            continue

        x0, y0 = pell_fundamental_solution(p)
        nu2_x0 = two_adic_valuation(x0)

        M_p_minus_1 = M(p - 1)
        M_p_plus_1 = M(p + 1)
        p_mod_64 = p % 64

        results.append({
            'p': p,
            'M_p_minus_1': M_p_minus_1,
            'M_p_plus_1': M_p_plus_1,
            'p_mod_64': p_mod_64,
            'nu2_x0': nu2_x0
        })

    return results

def analyze_combined(results, mod_class):
    """Analyze combined features"""
    print("=" * 80)
    print(f"CASE: p ≡ {mod_class} (mod 32)")
    print("=" * 80)
    print(f"Sample size: {len(results)}")
    print()

    # Triple: (M(p-1), M(p+1), p mod 64)
    print("Triple: (M(p-1), M(p+1), p mod 64) → ν₂(x₀)")
    print("-" * 80)
    by_triple = {}
    for r in results:
        key = (r['M_p_minus_1'], r['M_p_plus_1'], r['p_mod_64'])
        if key not in by_triple:
            by_triple[key] = []
        by_triple[key].append(r['nu2_x0'])

    deterministic_count = 0
    total_with_samples = 0

    for (M_m1, M_p1, p64) in sorted(by_triple.keys()):
        nu2_vals = by_triple[(M_m1, M_p1, p64)]
        from collections import Counter
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 2:
            total_with_samples += 1
            if is_det:
                deterministic_count += 1

        if len(nu2_vals) >= 2:  # Show pairs and above
            status = "✅ DET" if is_det else "VARIABLE"
            print(f"({M_m1:2d}, {M_p1:2d}, {p64:2d}): n={len(nu2_vals):2d} → {status}", end="")

            if is_det:
                print(f" | ν₂(x₀) = {list(counts.keys())[0]}")
            else:
                print(f" | {dict(counts)}")

    print()
    print(f"Deterministic: {deterministic_count}/{total_with_samples} = {100.0*deterministic_count/total_with_samples:.1f}%")
    print()

def main():
    test_primes = [p for p in range(7, 10000) if is_prime(p) and p % 8 == 7]

    # Test p ≡ 15 (mod 32)
    results_15 = test_combined(test_primes, 15)
    analyze_combined(results_15, 15)

    print()

    # Test p ≡ 31 (mod 32)
    results_31 = test_combined(test_primes, 31)
    analyze_combined(results_31, 31)

    print()
    print("=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print("If adding p mod 64 helps:")
    print("  → Finer determinism with combined features")
    print()
    print("If still mostly variable:")
    print("  → Fundamental chaos in these cases")
    print("  → May require class group / genus theory")
    print("  → OR truly non-computable from simple features")
    print()

if __name__ == '__main__':
    main()
