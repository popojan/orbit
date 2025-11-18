#!/usr/bin/env python3
"""
Systematic analysis: x₀ mod q for various primes q
(where q ≠ p, and we're solving x² - py² = 1)

Goal: Find if x₀ mod q has predictable pattern based on p
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

def analyze_x0_mod_q(test_primes, q):
    """
    For fixed q, analyze x₀ mod q across different p values

    Args:
        test_primes: list of primes p to test
        q: modulus (prime)

    Returns:
        results dict
    """
    results = []

    for p in test_primes:
        if p == q:
            continue  # Skip p = q

        x0, y0 = pell_fundamental_solution(p)

        results.append({
            'p': p,
            'p_mod_q': p % q,
            'p_mod_8': p % 8,
            'x0_mod_q': x0 % q,
            'x0': x0
        })

    return results

def print_analysis(results, q):
    """Print analysis for fixed q"""
    print(f"\n{'='*80}")
    print(f"ANALYSIS: x₀ mod {q} (across different primes p)")
    print(f"{'='*80}\n")

    # Overall distribution
    x0_mod_q_counts = {}
    for r in results:
        val = r['x0_mod_q']
        x0_mod_q_counts[val] = x0_mod_q_counts.get(val, 0) + 1

    print(f"Overall x₀ mod {q} distribution:")
    print("-" * 80)
    for val in sorted(x0_mod_q_counts.keys()):
        count = x0_mod_q_counts[val]
        total = len(results)
        print(f"  x₀ ≡ {val} (mod {q}): {count:3d}/{total} = {100.0*count/total:5.1f}%")
    print()

    # By p mod q
    print(f"Grouped by p mod {q}:")
    print("-" * 80)

    by_p_mod_q = {}
    for r in results:
        key = r['p_mod_q']
        if key not in by_p_mod_q:
            by_p_mod_q[key] = []
        by_p_mod_q[key].append(r)

    for p_mod_q in sorted(by_p_mod_q.keys()):
        if p_mod_q == 0:
            continue  # Skip p ≡ 0 (mod q) - shouldn't happen for primes

        group = by_p_mod_q[p_mod_q]
        print(f"\n  p ≡ {p_mod_q} (mod {q}):")

        # Count x₀ mod q values
        x0_counts = {}
        for r in group:
            val = r['x0_mod_q']
            x0_counts[val] = x0_counts.get(val, 0) + 1

        total = len(group)
        for val in sorted(x0_counts.keys()):
            count = x0_counts[val]
            pct = 100.0 * count / total
            marker = " ★" if pct >= 90.0 else ""
            print(f"    x₀ ≡ {val} (mod {q}): {count:2d}/{total} = {pct:5.1f}%{marker}")

    print()

def check_correlation_with_p_mod_8(results, q):
    """Check if x₀ mod q correlates with p mod 8"""
    print(f"Correlation with p mod 8:")
    print("-" * 80)

    by_p_mod_8 = {}
    for r in results:
        key = r['p_mod_8']
        if key not in by_p_mod_8:
            by_p_mod_8[key] = []
        by_p_mod_8[key].append(r)

    for p8 in sorted(by_p_mod_8.keys()):
        group = by_p_mod_8[p8]
        print(f"\n  p ≡ {p8} (mod 8):")

        x0_counts = {}
        for r in group:
            val = r['x0_mod_q']
            x0_counts[val] = x0_counts.get(val, 0) + 1

        total = len(group)
        for val in sorted(x0_counts.keys()):
            count = x0_counts[val]
            pct = 100.0 * count / total
            marker = " ★" if pct >= 90.0 else ""
            print(f"    x₀ ≡ {val} (mod {q}): {count:2d}/{total} = {pct:5.1f}%{marker}")

    print()

if __name__ == '__main__':
    # Test primes p (solving x² - py² = 1)
    test_primes = [p for p in range(3, 500) if is_prime(p)]

    # Analyze for small primes q
    for q in [3, 5, 7, 11]:
        results = analyze_x0_mod_q(test_primes, q)
        print_analysis(results, q)
        check_correlation_with_p_mod_8(results, q)

        # Check if there's ANY strong pattern
        has_pattern = False
        by_p_mod_q = {}
        for r in results:
            key = r['p_mod_q']
            if key not in by_p_mod_q:
                by_p_mod_q[key] = []
            by_p_mod_q[key].append(r)

        for p_mod_q, group in by_p_mod_q.items():
            x0_counts = {}
            for r in group:
                val = r['x0_mod_q']
                x0_counts[val] = x0_counts.get(val, 0) + 1

            # Check if one value dominates (>80%)
            total = len(group)
            for count in x0_counts.values():
                if count / total > 0.8:
                    has_pattern = True

        if has_pattern:
            print(f"★★★ PATTERN FOUND for q = {q}! ★★★")
        else:
            print(f"No strong pattern for q = {q} (appears random)")

        print("\n")
