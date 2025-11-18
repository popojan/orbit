#!/usr/bin/env python3
"""
Test: x₀ mod neighbor primes (prev and next)

For Pell equation x² - py² = 1, check:
- x₀ mod prev_prime(p)
- x₀ mod next_prime(p)

Looking for symmetric patterns.
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

def next_prime(n):
    candidate = n + 1
    while not is_prime(candidate):
        candidate += 1
    return candidate

def prev_prime(n):
    if n <= 2:
        return None
    candidate = n - 1
    while candidate >= 2:
        if is_prime(candidate):
            return candidate
        candidate -= 1
    return None

def analyze_neighbor_pattern(test_primes):
    """Analyze x₀ mod neighbor primes"""
    results = []

    for p in test_primes:
        x0, y0 = pell_fundamental_solution(p)

        p_prev = prev_prime(p)
        p_next = next_prime(p)

        if p_prev is None:
            continue

        result = {
            'p': p,
            'p_prev': p_prev,
            'p_next': p_next,
            'gap_prev': p - p_prev,
            'gap_next': p_next - p,
            'x0': x0,
            'x0_mod_prev': x0 % p_prev,
            'x0_mod_next': x0 % p_next,
            'x0_mod_p': x0 % p
        }

        results.append(result)

    return results

def print_analysis(results):
    print("="*80)
    print("NEIGHBOR PRIME ANALYSIS")
    print("="*80)
    print()

    print("Sample data (first 15 primes):")
    print("-"*80)
    for r in results[:15]:
        print(f"p = {r['p']:3d}  (gap: -{r['gap_prev']:2d}, +{r['gap_next']:2d})")
        print(f"  x0 mod prev({r['p_prev']:3d}) = {r['x0_mod_prev']:5d}")
        print(f"  x0 mod p   ({r['p']:3d}) = {r['x0_mod_p']:5d}")
        print(f"  x0 mod next({r['p_next']:3d}) = {r['x0_mod_next']:5d}")
        print()

    # Look for patterns
    print("="*80)
    print("PATTERN SEARCH")
    print("="*80)
    print()

    # Pattern 1: x₀ mod prev vs x₀ mod next correlation
    print("Pattern 1: Correlation between x0 mod prev and x0 mod next")
    print("-"*80)

    # Check if small values
    small_prev = sum(1 for r in results if r['x0_mod_prev'] < 10)
    small_next = sum(1 for r in results if r['x0_mod_next'] < 10)
    small_both = sum(1 for r in results if r['x0_mod_prev'] < 10 and r['x0_mod_next'] < 10)

    total = len(results)
    print(f"x0 mod prev < 10: {small_prev}/{total} = {100.0*small_prev/total:.1f}%")
    print(f"x0 mod next < 10: {small_next}/{total} = {100.0*small_next/total:.1f}%")
    print(f"Both < 10:        {small_both}/{total} = {100.0*small_both/total:.1f}%")
    print()

    # Pattern 2: Relationship to gap size
    print("Pattern 2: Relationship to prime gap")
    print("-"*80)

    # Separate by gap symmetry
    symmetric_gaps = [r for r in results if r['gap_prev'] == r['gap_next']]
    print(f"Symmetric gaps (gap_prev = gap_next): {len(symmetric_gaps)}/{total}")
    if symmetric_gaps:
        print("Examples:")
        for r in symmetric_gaps[:5]:
            print(f"  p={r['p']}, gap={r['gap_prev']}, "
                  f"x0 mod prev={r['x0_mod_prev']}, x0 mod next={r['x0_mod_next']}")
    print()

    # Pattern 3: Are x0 mod prev and x0 mod next close?
    print("Pattern 3: Distance between x0 mod prev and x0 mod next")
    print("-"*80)

    # Compute "closeness" - are they within 10% of each other relative to modulus?
    close_count = 0
    for r in results:
        # Normalize to [0, 1] range
        norm_prev = r['x0_mod_prev'] / r['p_prev']
        norm_next = r['x0_mod_next'] / r['p_next']
        if abs(norm_prev - norm_next) < 0.1:
            close_count += 1

    print(f"Normalized values within 0.1 of each other: {close_count}/{total} = {100.0*close_count/total:.1f}%")
    print("(Expected for random: ~10-20%)")
    print()

    # Pattern 4: Check specific residue classes
    print("Pattern 4: Common residue patterns")
    print("-"*80)

    # Count how often x0 ≡ 0, 1, -1 mod neighbor
    for mod_type in ['prev', 'next']:
        key = f'x0_mod_{mod_type}'
        neighbor_key = f'p_{mod_type}'

        count_0 = sum(1 for r in results if r[key] == 0)
        count_1 = sum(1 for r in results if r[key] == 1)
        count_m1 = sum(1 for r in results if r[key] == r[neighbor_key] - 1)

        print(f"x0 mod {mod_type}_prime(p):")
        print(f"  x0 ≡ 0:  {count_0:2d}/{total} = {100.0*count_0/total:.1f}%")
        print(f"  x0 ≡ 1:  {count_1:2d}/{total} = {100.0*count_1/total:.1f}%")
        print(f"  x0 ≡ -1: {count_m1:2d}/{total} = {100.0*count_m1/total:.1f}%")
    print()

if __name__ == '__main__':
    # Test primes (skip very small ones)
    test_primes = [p for p in range(7, 500) if is_prime(p)]

    print(f"Analyzing {len(test_primes)} primes...\n")

    results = analyze_neighbor_pattern(test_primes)
    print_analysis(results)
