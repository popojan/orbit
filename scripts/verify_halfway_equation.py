#!/usr/bin/env python3
"""
Verify the "halfway equation" for CF of √p.

Hypothesis: At position n/2 (halfway through period n), convergent satisfies:
    x² - py² = 2·(-1)^(n/2)

If true, this explains period mod 4 structure via Legendre symbols.
"""

import math

def is_prime(n):
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(math.sqrt(n)) + 1, 2):
        if n % i == 0:
            return False
    return True

def cf_sqrt(D, max_iter=10000):
    """Compute continued fraction expansion of √D."""
    a0 = int(math.sqrt(D))
    if a0 * a0 == D:
        return None

    seen = {}
    period = []
    m, d, a = 0, 1, a0

    for k in range(max_iter):
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d
        state = (m, d)
        if state in seen:
            return {'a0': a0, 'period': period[seen[state]:], 'n': len(period[seen[state]:])}
        seen[state] = len(period)
        period.append(a)

    return None

def convergent(a0, period, k):
    """Compute k-th convergent."""
    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1

    for i in range(k):
        a_k = period[i % len(period)]
        p_next = a_k * p_curr + p_prev
        q_next = a_k * q_curr + q_prev
        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

    return p_curr, q_curr

def legendre_symbol(a, p):
    """Compute Legendre symbol (a/p) using Euler's criterion."""
    if p == 2:
        return 1
    a = a % p
    if a == 0:
        return 0
    result = pow(a, (p - 1) // 2, p)
    return -1 if result == p - 1 else result

# ============================================================================
# Verification
# ============================================================================

print("="*80)
print("HALFWAY EQUATION VERIFICATION")
print("="*80)
print()
print("Testing hypothesis: x² - py² = 2·(-1)^(n/2) at halfway point")
print()

# Test primes from each mod 8 class
test_cases = {
    1: [17, 41, 73, 89, 97],
    3: [3, 11, 19, 43, 59, 67, 83],
    7: [7, 23, 31, 47, 71, 79, 103]
}

for mod8_class in [3, 7, 1]:  # Test 3,7 first (even periods)
    print(f"{'='*80}")
    print(f"p ≡ {mod8_class} (mod 8)")
    print(f"{'='*80}")

    primes = test_cases[mod8_class]

    print()
    print("   p   period  n/2  m  expected_norm  actual_norm  (2/p) (-2/p)  match?")
    print("-"*85)

    for p in primes:
        cf = cf_sqrt(p)
        if cf is None:
            continue

        n = cf['n']

        if n % 2 == 1:
            print(f"{p:4d}  {n:4d} (ODD period - skip)")
            continue

        # Halfway point
        half = n // 2
        m = half  # This is the m in the equation

        x_half, y_half = convergent(cf['a0'], cf['period'], half-1)  # -1 because 0-indexed

        norm = x_half**2 - p * y_half**2
        expected_norm = 2 * ((-1) ** m)

        # Legendre symbols
        leg_2 = legendre_symbol(2, p)
        leg_minus2 = legendre_symbol(-2, p)

        match = "✓" if norm == expected_norm else "✗"

        print(f"{p:4d}  {n:4d}   {half:3d}  {m:2d}     {expected_norm:+3d}           {norm:+6d}      {leg_2:+2d}     {leg_minus2:+2d}     {match}")

    print()

print("="*80)
print("ANALYSIS")
print("="*80)
print()
print("Key observations:")
print("1. For p ≡ 3 (mod 8): (2/p) = -1, period ≡ 2 (mod 4)")
print("   - Halfway m is odd → expect norm = -2")
print("   - If m were even → norm = 2, but 2 is NOT QR → contradiction!")
print()
print("2. For p ≡ 7 (mod 8): (2/p) = +1, period ≡ 0 (mod 4)")
print("   - Halfway m is even → expect norm = 2")
print("   - If m were odd → norm = -2, but (-2/p) = -1 → contradiction!")
print()
print("This explains WHY period mod 4 is determined by Legendre symbols!")
