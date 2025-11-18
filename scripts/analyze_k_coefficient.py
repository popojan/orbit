#!/usr/bin/env python3
"""
Analyze coefficient k where x₀ = kp ± 1

For p ≡ 1 (mod 4): x₀ ≡ -1 (mod p) → x₀ = kp - 1
For p ≡ 3,7 (mod 8): need to determine sign

Check: does k have pattern based on p?
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

def analyze_k_coefficient(primes):
    """Analyze k where x₀ = kp ± 1"""
    results = []

    for p in primes:
        x0, y0 = pell_fundamental_solution(p)

        p_mod_4 = p % 4
        p_mod_8 = p % 8
        x0_mod_p = x0 % p

        # Determine sign and compute k
        if x0_mod_p == p - 1:  # x₀ ≡ -1 (mod p)
            # x₀ = kp - 1
            k = (x0 + 1) // p
            sign = -1
        elif x0_mod_p == 1:     # x₀ ≡ +1 (mod p)
            # x₀ = kp + 1
            k = (x0 - 1) // p
            sign = +1
        else:
            k = None
            sign = None

        results.append({
            'p': p,
            'p_mod_4': p_mod_4,
            'p_mod_8': p_mod_8,
            'x0': x0,
            'x0_mod_p': x0_mod_p,
            'x0_mod_2': x0 % 2,
            'sign': sign,
            'k': k,
            'k_mod_2': k % 2 if k is not None else None,
            'k_mod_4': k % 4 if k is not None else None
        })

    return results

def print_analysis(results):
    print("=" * 80)
    print("COEFFICIENT k ANALYSIS: x₀ = kp ± 1")
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

        # Sign pattern
        signs = [r['sign'] for r in group if r['sign'] is not None]
        sign_counts = {-1: signs.count(-1), +1: signs.count(+1)}
        print(f"  x₀ ≡ -1 (mod p): {sign_counts[-1]}/{len(group)}")
        print(f"  x₀ ≡ +1 (mod p): {sign_counts[+1]}/{len(group)}")

        # k parity pattern
        k_mod_2_counts = {}
        for r in group:
            if r['k_mod_2'] is not None:
                k_mod_2_counts[r['k_mod_2']] = k_mod_2_counts.get(r['k_mod_2'], 0) + 1

        print(f"  k parity:")
        for parity in sorted(k_mod_2_counts.keys()):
            parity_str = "EVEN" if parity == 0 else "ODD"
            print(f"    k ≡ {parity} (mod 2) [{parity_str}]: {k_mod_2_counts[parity]}/{len(group)}")

        # k mod 4 pattern
        k_mod_4_counts = {}
        for r in group:
            if r['k_mod_4'] is not None:
                k_mod_4_counts[r['k_mod_4']] = k_mod_4_counts.get(r['k_mod_4'], 0) + 1

        if k_mod_4_counts:
            print(f"  k mod 4:")
            for val in sorted(k_mod_4_counts.keys()):
                print(f"    k ≡ {val} (mod 4): {k_mod_4_counts[val]}/{len(group)}")

        print()

    # Detailed examples
    print("=" * 80)
    print("DETAILED EXAMPLES (first 10):")
    print("=" * 80)
    for r in results[:10]:
        sign_str = "+" if r['sign'] == 1 else "-"
        k_parity = "EVEN" if r['k_mod_2'] == 0 else "ODD" if r['k_mod_2'] == 1 else "?"
        print(f"p = {r['p']:3d} (≡{r['p_mod_8']} mod 8): "
              f"x₀ = {r['k']:8d}·{r['p']} {sign_str} 1, "
              f"k is {k_parity}, x₀ mod 2 = {r['x0_mod_2']}")

if __name__ == '__main__':
    test_primes = [p for p in range(3, 500) if is_prime(p)]

    print(f"Analyzing k coefficient for {len(test_primes)} primes...\n")

    results = analyze_k_coefficient(test_primes)
    print_analysis(results)
