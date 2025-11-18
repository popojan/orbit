#!/usr/bin/env python3
"""
Quantify the asymmetry pattern discovered:
x₀ mod q tends to be in lower/upper half depending on whether q < p or q > p
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

def nth_prime_before(p, n):
    """Find n-th prime before p"""
    primes_before = []
    candidate = p - 1
    while len(primes_before) < n and candidate >= 2:
        if is_prime(candidate):
            primes_before.append(candidate)
        candidate -= 1
    return primes_before[n-1] if len(primes_before) >= n else None

def nth_prime_after(p, n):
    """Find n-th prime after p"""
    primes_after = []
    candidate = p + 1
    while len(primes_after) < n:
        if is_prime(candidate):
            primes_after.append(candidate)
        candidate += 1
    return primes_after[n-1]

def test_asymmetry(test_primes, max_distance=10):
    """Test asymmetry pattern"""
    print("="*80)
    print("ASYMMETRY QUANTIFICATION")
    print("="*80)
    print()

    # Collect data
    before_data = {k: [] for k in range(1, max_distance + 1)}
    after_data = {k: [] for k in range(1, max_distance + 1)}

    for p in test_primes:
        x0, _ = pell_fundamental_solution(p)

        # Check primes before p
        for k in range(1, max_distance + 1):
            q = nth_prime_before(p, k)
            if q is not None:
                x0_mod_q = x0 % q
                normalized = x0_mod_q / q
                before_data[k].append({
                    'p': p,
                    'q': q,
                    'x0_mod_q': x0_mod_q,
                    'normalized': normalized,
                    'upper_half': normalized > 0.5
                })

        # Check primes after p
        for k in range(1, max_distance + 1):
            q = nth_prime_after(p, k)
            x0_mod_q = x0 % q
            normalized = x0_mod_q / q
            after_data[k].append({
                'p': p,
                'q': q,
                'x0_mod_q': x0_mod_q,
                'normalized': normalized,
                'upper_half': normalized > 0.5
            })

    # Analyze asymmetry
    print("Position | Direction | Upper half | Lower half | Avg normalized")
    print("-" * 80)

    for k in range(1, max_distance + 1):
        # Before
        if before_data[k]:
            total = len(before_data[k])
            upper = sum(1 for d in before_data[k] if d['upper_half'])
            lower = total - upper
            avg = sum(d['normalized'] for d in before_data[k]) / total

            print(f"  -{k:2d}    | BEFORE p  | {upper:3d}/{total} = {100.0*upper/total:5.1f}% | "
                  f"{lower:3d}/{total} = {100.0*lower/total:5.1f}% | {avg:.4f}")

    print()

    for k in range(1, max_distance + 1):
        # After
        if after_data[k]:
            total = len(after_data[k])
            upper = sum(1 for d in after_data[k] if d['upper_half'])
            lower = total - upper
            avg = sum(d['normalized'] for d in after_data[k]) / total

            print(f"  +{k:2d}    | AFTER p   | {upper:3d}/{total} = {100.0*upper/total:5.1f}% | "
                  f"{lower:3d}/{total} = {100.0*lower/total:5.1f}% | {avg:.4f}")

    print()
    print("=" * 80)
    print("STATISTICAL SIGNIFICANCE")
    print("=" * 80)

    # For position ±1 (nearest neighbors)
    before_1 = before_data[1]
    after_1 = after_data[1]

    if before_1 and after_1:
        before_upper_pct = 100.0 * sum(1 for d in before_1 if d['upper_half']) / len(before_1)
        after_upper_pct = 100.0 * sum(1 for d in after_1 if d['upper_half']) / len(after_1)

        print(f"\nNearest neighbors (±1):")
        print(f"  BEFORE p: {before_upper_pct:.1f}% in upper half")
        print(f"  AFTER p:  {after_upper_pct:.1f}% in upper half")
        print(f"  Difference: {after_upper_pct - before_upper_pct:+.1f}%")
        print()

        if before_upper_pct < 45 and after_upper_pct > 55:
            print("PATTERN CONFIRMED: Asymmetry detected!")
        else:
            print("Pattern weak or absent")

if __name__ == '__main__':
    # Test primes
    test_primes = [p for p in range(50, 500) if is_prime(p)]

    print(f"Testing asymmetry for {len(test_primes)} primes...\n")

    test_asymmetry(test_primes, max_distance=10)
