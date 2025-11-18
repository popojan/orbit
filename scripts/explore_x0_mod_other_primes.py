#!/usr/bin/env python3
"""
Explore x₀ mod q where q ≠ p (other primes)

For Pell equation x₀² - py₀² = 1, we know x₀ mod p pattern.
Can we find pattern for x₀ mod q where q is different prime?

If yes → multiple moduli → CRT reconstruction possible!
"""

import sys
sys.path.append('/home/user/orbit/scripts')
from pell_solver_integer import pell_fundamental_solution

def is_prime(n):
    """Quick primality check"""
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
    """Find next prime after n"""
    candidate = n + 1
    while not is_prime(candidate):
        candidate += 1
    return candidate

def prev_prime(n):
    """Find previous prime before n"""
    if n <= 2:
        return None
    candidate = n - 1
    while candidate >= 2:
        if is_prime(candidate):
            return candidate
        candidate -= 1
    return None

def explore_x0_mod_q(p):
    """
    For given prime p, compute x₀ from Pell equation x² - py² = 1
    Then check x₀ modulo various other primes q
    """
    # Get Pell solution
    x0, y0 = pell_fundamental_solution(p)

    # Previous and next primes
    q_prev = prev_prime(p)
    q_next = next_prime(p)

    # Small primes for testing
    small_primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]

    result = {
        'p': p,
        'x0': x0,
        'y0': y0,
        'x0_mod_p': x0 % p,
        'x0_mod_prev': x0 % q_prev if q_prev else None,
        'x0_mod_next': x0 % q_next,
        'q_prev': q_prev,
        'q_next': q_next,
        'x0_mod_small': {q: x0 % q for q in small_primes if q != p}
    }

    return result

def analyze_patterns(results):
    """Look for patterns in x₀ mod q"""
    print("=" * 80)
    print("PATTERN ANALYSIS: x₀ mod q (where q ≠ p)")
    print("=" * 80)
    print()

    # Pattern 1: x₀ mod 2
    print("Pattern: x₀ mod 2")
    print("-" * 80)
    mod2_counts = {}
    for r in results:
        val = r['x0_mod_small'].get(2)
        if val is not None:
            mod2_counts[val] = mod2_counts.get(val, 0) + 1
    print(f"  x₀ ≡ 0 (mod 2): {mod2_counts.get(0, 0)}")
    print(f"  x₀ ≡ 1 (mod 2): {mod2_counts.get(1, 0)}")
    print()

    # Pattern 2: x₀ mod 3
    print("Pattern: x₀ mod 3")
    print("-" * 80)
    mod3_counts = {}
    for r in results:
        val = r['x0_mod_small'].get(3)
        if val is not None:
            mod3_counts[val] = mod3_counts.get(val, 0) + 1
    for v in sorted(mod3_counts.keys()):
        print(f"  x₀ ≡ {v} (mod 3): {mod3_counts[v]}")
    print()

    # Pattern 3: Relationship with p mod 8
    print("Pattern: x₀ mod 2 vs p mod 8")
    print("-" * 80)
    by_p_mod_8 = {}
    for r in results:
        p_mod_8 = r['p'] % 8
        x0_mod_2 = r['x0_mod_small'].get(2)
        if x0_mod_2 is not None:
            key = (p_mod_8, x0_mod_2)
            by_p_mod_8[key] = by_p_mod_8.get(key, 0) + 1

    for p_class in [1, 3, 5, 7]:
        print(f"  p ≡ {p_class} (mod 8):")
        for x0_val in [0, 1]:
            count = by_p_mod_8.get((p_class, x0_val), 0)
            print(f"    x₀ ≡ {x0_val} (mod 2): {count}")
    print()

    # Pattern 4: x₀ mod next_prime
    print("Pattern: x₀ mod next_prime(p)")
    print("-" * 80)
    for r in results[:20]:  # First 20 examples
        print(f"  p = {r['p']:3d}, next = {r['q_next']:3d}, "
              f"x₀ mod {r['q_next']} = {r['x0_mod_next']:3d}")
    print("  ...")
    print()

if __name__ == '__main__':
    # Test primes
    test_primes = [p for p in range(3, 200) if is_prime(p)]

    print(f"Exploring x₀ mod q for {len(test_primes)} primes...")
    print()

    results = [explore_x0_mod_q(p) for p in test_primes]

    analyze_patterns(results)

    # Show a few detailed examples
    print("=" * 80)
    print("DETAILED EXAMPLES")
    print("=" * 80)
    print()

    for r in results[:5]:
        print(f"p = {r['p']}")
        print(f"  x₀ = {r['x0']}")
        print(f"  x₀ mod p = {r['x0_mod_p']}")
        print(f"  x₀ mod prev({r['q_prev']}) = {r['x0_mod_prev']}")
        print(f"  x₀ mod next({r['q_next']}) = {r['x0_mod_next']}")
        print(f"  Small primes: {r['x0_mod_small']}")
        print()
