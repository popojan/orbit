#!/usr/bin/env python3
"""
Explore x₀ mod 8 pattern

Can we extend x₀ mod 4 to x₀ mod 8?
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

def test_x0_mod8(primes):
    """Test x₀ mod 8"""
    results = []

    for p in primes:
        x0, y0 = pell_fundamental_solution(p)

        results.append({
            'p': p,
            'p_mod_8': p % 8,
            'p_mod_16': p % 16,
            'p_mod_32': p % 32,
            'x0_mod_4': x0 % 4,
            'x0_mod_8': x0 % 8,
            'x0_mod_16': x0 % 16,
            'x0': x0
        })

    return results

def analyze_pattern(results):
    """Look for x₀ mod 8 pattern"""
    print("=" * 80)
    print("x₀ MOD 8 PATTERN EXPLORATION")
    print("=" * 80)
    print()

    # Group by p mod 8
    by_p_mod_8 = {}
    for r in results:
        key = r['p_mod_8']
        if key not in by_p_mod_8:
            by_p_mod_8[key] = []
        by_p_mod_8[key].append(r)

    for mod8 in sorted(by_p_mod_8.keys()):
        group = by_p_mod_8[mod8]
        print(f"p ≡ {mod8} (mod 8):")
        print("-" * 80)

        # Count x₀ mod 8 values
        x0_mod8_counts = {}
        for r in group:
            val = r['x0_mod_8']
            x0_mod8_counts[val] = x0_mod8_counts.get(val, 0) + 1

        for val in sorted(x0_mod8_counts.keys()):
            count = x0_mod8_counts[val]
            total = len(group)
            print(f"  x₀ ≡ {val} (mod 8): {count}/{total} = {100.0 * count / total:.1f}%")

        print()

    # Try p mod 16 correlation
    print("=" * 80)
    print("TRY p mod 16 → x₀ mod 8:")
    print("=" * 80)
    print()

    by_p_mod_16 = {}
    for r in results:
        key = r['p_mod_16']
        if key not in by_p_mod_16:
            by_p_mod_16[key] = []
        by_p_mod_16[key].append(r)

    for mod16 in sorted(by_p_mod_16.keys()):
        group = by_p_mod_16[mod16]
        print(f"p ≡ {mod16:2d} (mod 16):")

        # Count x₀ mod 8 values
        x0_mod8_counts = {}
        for r in group:
            val = r['x0_mod_8']
            x0_mod8_counts[val] = x0_mod8_counts.get(val, 0) + 1

        for val in sorted(x0_mod8_counts.keys()):
            count = x0_mod8_counts[val]
            total = len(group)
            if total > 0:
                print(f"  x₀ ≡ {val} (mod 8): {count}/{total} = {100.0 * count / total:.1f}%")

        print()

if __name__ == '__main__':
    test_primes = [p for p in range(3, 1000) if is_prime(p)]

    print(f"Exploring x₀ mod 8 for {len(test_primes)} primes...\n")

    results = test_x0_mod8(test_primes)
    analyze_pattern(results)
