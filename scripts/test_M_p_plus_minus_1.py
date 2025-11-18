#!/usr/bin/env python3
"""
Test: Does M(p±1) determine ν₂(x₀) for variable cases?

M(n) = count of divisors d where 2 ≤ d ≤ √n
     = floor[(τ(n) - 1) / 2]

This is from primal forest / Dirichlet series L_M(s) project!

Hypothesis: Divisor structure of p±1 might determine ν₂(x₀)
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
    """Count all divisors of n"""
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
    """M(n) = floor[(τ(n) - 1) / 2]"""
    tau_n = count_divisors(n)
    return (tau_n - 1) // 2

def test_M_correlation(primes, mod_class):
    """Test M(p±1) correlation with ν₂(x₀)"""
    results = []

    for p in primes:
        if p % 32 != mod_class:
            continue

        x0, y0 = pell_fundamental_solution(p)
        nu2_x0 = two_adic_valuation(x0)

        M_p_minus_1 = M(p - 1)
        M_p_plus_1 = M(p + 1)
        tau_p_minus_1 = count_divisors(p - 1)
        tau_p_plus_1 = count_divisors(p + 1)

        results.append({
            'p': p,
            'M_p_minus_1': M_p_minus_1,
            'M_p_plus_1': M_p_plus_1,
            'tau_p_minus_1': tau_p_minus_1,
            'tau_p_plus_1': tau_p_plus_1,
            'nu2_x0': nu2_x0
        })

    return results

def analyze_M_correlation(results, mod_class):
    """Analyze M(p±1) correlation"""
    print("=" * 80)
    print(f"CASE: p ≡ {mod_class} (mod 32)")
    print("=" * 80)
    print(f"Sample size: {len(results)}")
    print()

    # M(p-1)
    print("Correlation: M(p-1) → ν₂(x₀)")
    print("-" * 80)
    by_M_p_minus_1 = {}
    for r in results:
        key = r['M_p_minus_1']
        if key not in by_M_p_minus_1:
            by_M_p_minus_1[key] = []
        by_M_p_minus_1[key].append(r['nu2_x0'])

    for val in sorted(by_M_p_minus_1.keys()):
        nu2_vals = by_M_p_minus_1[val]
        from collections import Counter
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 3:
            status = "DETERMINISTIC" if is_det else "VARIABLE"
            print(f"\nM(p-1) = {val}: {len(nu2_vals)} primes → {status}")

            if is_det:
                print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
            else:
                for nu2 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2] / len(nu2_vals)
                    print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    # M(p+1)
    print()
    print("Correlation: M(p+1) → ν₂(x₀)")
    print("-" * 80)
    by_M_p_plus_1 = {}
    for r in results:
        key = r['M_p_plus_1']
        if key not in by_M_p_plus_1:
            by_M_p_plus_1[key] = []
        by_M_p_plus_1[key].append(r['nu2_x0'])

    for val in sorted(by_M_p_plus_1.keys()):
        nu2_vals = by_M_p_plus_1[val]
        from collections import Counter
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 3:
            status = "DETERMINISTIC" if is_det else "VARIABLE"
            print(f"\nM(p+1) = {val}: {len(nu2_vals)} primes → {status}")

            if is_det:
                print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
            else:
                for nu2 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2] / len(nu2_vals)
                    print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    # τ(p-1)
    print()
    print("Correlation: τ(p-1) → ν₂(x₀)")
    print("-" * 80)
    by_tau_p_minus_1 = {}
    for r in results:
        key = r['tau_p_minus_1']
        if key not in by_tau_p_minus_1:
            by_tau_p_minus_1[key] = []
        by_tau_p_minus_1[key].append(r['nu2_x0'])

    for val in sorted(by_tau_p_minus_1.keys()):
        nu2_vals = by_tau_p_minus_1[val]
        from collections import Counter
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 3:
            status = "DETERMINISTIC" if is_det else "VARIABLE"
            print(f"\nτ(p-1) = {val}: {len(nu2_vals)} primes → {status}")

            if is_det:
                print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
            else:
                for nu2 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2] / len(nu2_vals)
                    print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    # Joint: (M(p-1), M(p+1))
    print()
    print("Joint: (M(p-1), M(p+1)) → ν₂(x₀)")
    print("-" * 80)
    by_joint_M = {}
    for r in results:
        key = (r['M_p_minus_1'], r['M_p_plus_1'])
        if key not in by_joint_M:
            by_joint_M[key] = []
        by_joint_M[key].append(r['nu2_x0'])

    deterministic_count = 0
    total_with_samples = 0

    for (M_m1, M_p1) in sorted(by_joint_M.keys()):
        nu2_vals = by_joint_M[(M_m1, M_p1)]
        from collections import Counter
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 2:
            total_with_samples += 1
            if is_det:
                deterministic_count += 1

        if len(nu2_vals) >= 3:
            status = "DETERMINISTIC ✅" if is_det else "VARIABLE"
            print(f"\n(M(p-1), M(p+1)) = ({M_m1}, {M_p1}): {len(nu2_vals)} primes → {status}")

            if is_det:
                print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
            else:
                for nu2 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2] / len(nu2_vals)
                    print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    print()
    print(f"Deterministic joint pairs: {deterministic_count}/{total_with_samples}")
    print()

def main():
    test_primes = [p for p in range(7, 10000) if is_prime(p) and p % 8 == 7]

    # Test p ≡ 15 (mod 32)
    results_15 = test_M_correlation(test_primes, 15)
    analyze_M_correlation(results_15, 15)

    print()
    print("=" * 80)
    print()

    # Test p ≡ 31 (mod 32)
    results_31 = test_M_correlation(test_primes, 31)
    analyze_M_correlation(results_31, 31)

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print("If M(p±1) determines ν₂(x₀):")
    print("  → Connection between primal forest and Pell structure!")
    print("  → L_M(s) Dirichlet series might encode Pell chaos")
    print()
    print("This would be DEEP - divisor structure determining 2-adic Pell behavior")
    print()

if __name__ == '__main__':
    main()
