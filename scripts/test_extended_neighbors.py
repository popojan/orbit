#!/usr/bin/env python3
"""
Test: x₀ mod extended neighbors

For Pell equation x² - py² = 1, check x₀ modulo:
- p[-5], p[-4], p[-3], p[-2], p[-1], p, p[+1], p[+2], p[+3], p[+4], p[+5]

Looking for local patterns around p.
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

def analyze_extended_neighbors(p, radius=5):
    """Analyze x₀ mod neighbors at distance -radius to +radius"""
    x0, y0 = pell_fundamental_solution(p)

    # Get neighbors
    neighbors = {}

    # Negative direction (primes before p)
    for k in range(1, radius + 1):
        q = nth_prime_before(p, k)
        if q is not None:
            neighbors[-k] = {
                'q': q,
                'x0_mod_q': x0 % q,
                'q_normalized': q / p  # relative size
            }

    # p itself
    neighbors[0] = {
        'q': p,
        'x0_mod_q': x0 % p,
        'q_normalized': 1.0
    }

    # Positive direction (primes after p)
    for k in range(1, radius + 1):
        q = nth_prime_after(p, k)
        neighbors[k] = {
            'q': q,
            'x0_mod_q': x0 % q,
            'q_normalized': q / p
        }

    return neighbors, x0

def print_neighbor_profile(p, neighbors, x0):
    """Print profile of x₀ mod neighbors"""
    print(f"\nPrime p = {p}, x0 = {x0}")
    print("-" * 80)

    for k in sorted(neighbors.keys()):
        n = neighbors[k]
        q = n['q']
        x0_mod_q = n['x0_mod_q']
        q_norm = n['q_normalized']

        # Normalize x0_mod_q to [0, 1]
        x0_norm = x0_mod_q / q

        direction = f"[{k:+2d}]"
        print(f"  {direction} q={q:5d} (×{q_norm:.3f}): "
              f"x0 ≡ {x0_mod_q:6d} (mod {q}) = {x0_norm:.4f} normalized")

def look_for_patterns(test_primes, radius=5):
    """Look for patterns across multiple primes"""
    print("=" * 80)
    print(f"EXTENDED NEIGHBOR ANALYSIS (radius={radius})")
    print("=" * 80)

    # Collect all data
    all_data = []
    for p in test_primes:
        neighbors, x0 = analyze_extended_neighbors(p, radius)
        all_data.append({
            'p': p,
            'neighbors': neighbors,
            'x0': x0
        })

    # Show a few examples
    print("\nSample profiles (first 5 primes):")
    print("=" * 80)
    for data in all_data[:5]:
        print_neighbor_profile(data['p'], data['neighbors'], data['x0'])

    # Look for patterns: small residues
    print("\n" + "=" * 80)
    print("PATTERN: Small residues (x0 mod q < 10)")
    print("=" * 80)

    for k in range(-radius, radius + 1):
        if k == 0:
            continue  # Skip p itself

        small_count = 0
        total_count = 0

        for data in all_data:
            if k in data['neighbors']:
                total_count += 1
                if data['neighbors'][k]['x0_mod_q'] < 10:
                    small_count += 1

        if total_count > 0:
            pct = 100.0 * small_count / total_count
            direction = "before" if k < 0 else "after"
            print(f"  Position [{k:+2d}] ({abs(k)}-th prime {direction} p): "
                  f"{small_count}/{total_count} = {pct:5.1f}% have x0 mod q < 10")

    # Look for patterns: normalized values
    print("\n" + "=" * 80)
    print("PATTERN: Normalized x0 mod q (x0 mod q)/q")
    print("=" * 80)

    for k in range(-radius, radius + 1):
        if k == 0:
            continue

        norm_values = []
        for data in all_data:
            if k in data['neighbors']:
                q = data['neighbors'][k]['q']
                x0_mod_q = data['neighbors'][k]['x0_mod_q']
                norm_values.append(x0_mod_q / q)

        if norm_values:
            avg = sum(norm_values) / len(norm_values)
            direction = "before" if k < 0 else "after"
            print(f"  Position [{k:+2d}] ({abs(k)}-th prime {direction} p): "
                  f"avg normalized = {avg:.4f}")

if __name__ == '__main__':
    # Test primes (larger ones to have enough neighbors)
    test_primes = [p for p in range(50, 500) if is_prime(p)]

    print(f"Analyzing {len(test_primes)} primes with radius=5 neighbors...\n")

    look_for_patterns(test_primes, radius=5)
