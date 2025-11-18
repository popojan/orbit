#!/usr/bin/env python3
"""
Analyze p ≡ 7 (mod 8) case: why does ν₂(x₀) vary?

We know ν₂(x₀) ≥ 3, but actual values are 3, 4, 5, 7, 8...

Can we predict EXACT ν₂(x₀) from p mod higher power of 2?
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
    """Compute ν₂(n)"""
    if n == 0:
        return float('inf')
    val = 0
    while n % 2 == 0:
        val += 1
        n //= 2
    return val

def analyze_p7mod8_pattern(primes_7mod8):
    """Analyze p ≡ 7 (mod 8) to find pattern for exact ν₂(x₀)"""
    results = []

    for p in primes_7mod8:
        x0, y0 = pell_fundamental_solution(p)
        nu2 = two_adic_valuation(x0)

        results.append({
            'p': p,
            'p_mod_16': p % 16,
            'p_mod_32': p % 32,
            'p_mod_64': p % 64,
            'x0': x0,
            'nu2_x0': nu2,
            'x0_div_2^3': x0 // 8,
            'x0_div_2^nu2': x0 // (2**nu2) if nu2 < 20 else None
        })

    return results

def print_analysis(results):
    print("=" * 80)
    print("DEEPER ANALYSIS: p ≡ 7 (mod 8)")
    print("=" * 80)
    print()

    # Group by ν₂(x₀)
    by_nu2 = {}
    for r in results:
        key = r['nu2_x0']
        if key not in by_nu2:
            by_nu2[key] = []
        by_nu2[key].append(r)

    print("Distribution of ν₂(x₀):")
    print("-" * 80)
    for nu2 in sorted(by_nu2.keys()):
        group = by_nu2[nu2]
        print(f"\nν₂(x₀) = {nu2}: {len(group)} cases")

        # Check correlation with p mod 16, 32, 64
        p_mod_16_vals = [r['p_mod_16'] for r in group]
        p_mod_32_vals = [r['p_mod_32'] for r in group]
        p_mod_64_vals = [r['p_mod_64'] for r in group]

        print(f"  p mod 16: {set(p_mod_16_vals)}")
        print(f"  p mod 32: {set(p_mod_32_vals)}")
        print(f"  p mod 64: {set(p_mod_64_vals)}")

        print(f"  Examples:")
        for r in group[:5]:
            odd_part = r['x0_div_2^nu2'] if r['x0_div_2^nu2'] else "?"
            print(f"    p = {r['p']:5d} (≡ {r['p_mod_64']:2d} mod 64): "
                  f"x₀ = 2^{nu2} · {odd_part}")

    print()
    print("=" * 80)
    print("CORRELATION TESTS")
    print("=" * 80)
    print()

    # Test: p mod 16 → ν₂(x₀)?
    print("p mod 16 vs ν₂(x₀):")
    print("-" * 80)
    by_p_mod_16 = {}
    for r in results:
        key = r['p_mod_16']
        if key not in by_p_mod_16:
            by_p_mod_16[key] = []
        by_p_mod_16[key].append(r)

    for mod16 in sorted(by_p_mod_16.keys()):
        group = by_p_mod_16[mod16]
        nu2_vals = [r['nu2_x0'] for r in group]
        from collections import Counter
        counts = Counter(nu2_vals)

        print(f"p ≡ {mod16} (mod 16):")
        for nu2 in sorted(counts.keys()):
            print(f"  ν₂(x₀) = {nu2}: {counts[nu2]}/{len(group)}")

    print()
    print("=" * 80)

    # Test: p mod 32 → ν₂(x₀)?
    print("p mod 32 vs ν₂(x₀):")
    print("-" * 80)
    by_p_mod_32 = {}
    for r in results:
        key = r['p_mod_32']
        if key not in by_p_mod_32:
            by_p_mod_32[key] = []
        by_p_mod_32[key].append(r)

    for mod32 in sorted(by_p_mod_32.keys()):
        group = by_p_mod_32[mod32]
        nu2_vals = [r['nu2_x0'] for r in group]
        from collections import Counter
        counts = Counter(nu2_vals)

        print(f"p ≡ {mod32} (mod 32): n={len(group)}")
        for nu2 in sorted(counts.keys()):
            print(f"  ν₂(x₀) = {nu2}: {counts[nu2]}")

    print()

if __name__ == '__main__':
    # Get primes p ≡ 7 (mod 8) up to 5000 for better statistics
    test_primes = [p for p in range(7, 5000) if is_prime(p) and p % 8 == 7]

    print(f"Analyzing {len(test_primes)} primes p ≡ 7 (mod 8)...\n")

    results = analyze_p7mod8_pattern(test_primes)
    print_analysis(results)

    # Summary
    print("\nSUMMARY:")
    print("=" * 80)
    nu2_vals = [r['nu2_x0'] for r in results]
    from collections import Counter
    counts = Counter(nu2_vals)

    print("Overall ν₂(x₀) distribution for p ≡ 7 (mod 8):")
    for nu2 in sorted(counts.keys()):
        pct = 100.0 * counts[nu2] / len(results)
        print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:3d}/{len(results)} = {pct:5.1f}%")

    print()
    print("Most common: ν₂(x₀) = 3 (minimum possible)")
    print("Rare: ν₂(x₀) ≥ 5 (larger valuations)")
    print()
