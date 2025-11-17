#!/usr/bin/env python3
"""
Analyze the relationship between halfway convergent and fundamental solution
for primes p ≡ 3 (mod 8).

Goal: Find algebraic relationship that proves x₀ ≡ -1 (mod p).
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

def cf_sqrt_detailed(D, max_iter=10000):
    """Compute CF with all details."""
    a0 = int(math.sqrt(D))
    if a0 * a0 == D:
        return None

    seen = {}
    period = []
    convergents = []
    m_vals, d_vals = [0], [1]

    # Initial convergent
    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1
    convergents.append((a0, 1))

    m, d, a = 0, 1, a0

    for k in range(max_iter):
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d

        m_vals.append(m)
        d_vals.append(d)

        # Compute convergent
        p_next = a * p_curr + p_prev
        q_next = a * q_curr + q_prev
        convergents.append((p_next, q_next))

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

        state = (m, d)
        if state in seen:
            period_start = seen[state]
            return {
                'a0': a0,
                'period': period[period_start:],
                'n': len(period[period_start:]),
                'convergents': convergents,
                'm_vals': m_vals,
                'd_vals': d_vals,
                'period_full': period
            }
        seen[state] = len(period)
        period.append(a)

    return None

def analyze_relationship(p):
    """Analyze relationship between x_m and x₀."""
    cf = cf_sqrt_detailed(p)
    if cf is None:
        return None

    n = cf['n']

    if n % 2 != 0:
        return None  # Only even periods

    m = n // 2

    # Halfway position
    pos_half = m - 1
    # Fundamental position for p ≡ 3 (mod 4)
    pos_fund = n - 1

    if pos_fund >= len(cf['convergents']) or pos_half >= len(cf['convergents']):
        return None

    x_m, y_m = cf['convergents'][pos_half]
    x_0, y_0 = cf['convergents'][pos_fund]

    norm_m = x_m*x_m - p*y_m*y_m
    norm_0 = x_0*x_0 - p*y_0*y_0

    return {
        'p': p,
        'n': n,
        'm': m,
        'x_m': x_m,
        'y_m': y_m,
        'x_0': x_0,
        'y_0': y_0,
        'norm_m': norm_m,
        'norm_0': norm_0,
        'period': cf['period']
    }

def test_algebraic_relations(data):
    """Test various algebraic relationships between (x_m, y_m) and (x_0, y_0)."""
    p = data['p']
    x_m, y_m = data['x_m'], data['y_m']
    x_0, y_0 = data['x_0'], data['y_0']

    results = {}

    # Test 1: Is x_0 = some polynomial in x_m, y_m?
    # For norm -2 → norm 1, typical is: (x + y√p)² or similar

    # Try: (x_m + y_m√p)²
    x_sq = x_m*x_m + p*y_m*y_m
    y_sq = 2*x_m*y_m

    results['square_formula'] = {
        'x_sq': x_sq,
        'y_sq': y_sq,
        'matches_x0': x_sq == x_0,
        'matches_y0': y_sq == y_0
    }

    # Try: Relation mod p
    x_m_mod_p = x_m % p
    x_0_mod_p = x_0 % p

    results['mod_p'] = {
        'x_m_mod_p': x_m_mod_p,
        'x_0_mod_p': x_0_mod_p,
        'x_m² mod p': (x_m * x_m) % p,
        'relation': None
    }

    # Since norm_m = -2, we have x_m² ≡ -2 (mod p)
    # Can we relate this to x_0 mod p?

    # Try: x_0 related to x_m via norm doubling?
    # From (a² - pb²) = -2 to (x² - py²) = 1
    # One way: multiply by conjugate or self

    # Check if x_0² - 1 relates to x_m
    x0_sq_minus_1 = x_0*x_0 - 1
    # From Pell: x_0² - 1 = py_0²

    results['pell_relation'] = {
        'x_0² - 1': x0_sq_minus_1,
        'py_0²': p * y_0 * y_0,
        'matches': x0_sq_minus_1 == p * y_0 * y_0
    }

    # Key question: If x_m² ≡ -2 (mod p), what can we say about x_0?

    # From x_m² - py_m² = -2:
    # x_m² = py_m² - 2
    # x_m² ≡ -2 (mod p)

    # From x_0² - py_0² = 1:
    # x_0² = py_0² + 1
    # x_0² ≡ 1 (mod p)

    # Can we show x_0 ≡ -1 (mod p) from x_m² ≡ -2 (mod p)?

    return results

# ============================================================================
# Main Analysis
# ============================================================================

print("="*80)
print("HALFWAY → FUNDAMENTAL RELATIONSHIP for p ≡ 3 (mod 8)")
print("="*80)
print()

test_primes = [p for p in range(3, 100) if is_prime(p) and p % 8 == 3]

print("Testing primes p ≡ 3 (mod 8):")
print()
print("   p   n   m  norm_m  x_m  x_0  x_m mod p  x_0 mod p  x_0² formula")
print("-"*80)

for p in test_primes[:10]:
    data = analyze_relationship(p)
    if data:
        rel = test_algebraic_relations(data)

        # Check if x_0 = x_m² + py_m²
        x_formula = data['x_m']**2 + p*data['y_m']**2
        matches = "✓" if x_formula == data['x_0'] else "✗"

        print(f"{p:4d} {data['n']:3d} {data['m']:3d}   {data['norm_m']:+3d}   "
              f"{data['x_m']:4d} {data['x_0']:4d}     "
              f"{data['x_m'] % p:4d}       {data['x_0'] % p:4d}         {matches}")

print()
print("="*80)
print("ALGEBRAIC RELATIONSHIP")
print("="*80)
print()

# Detailed analysis for first few primes
for p in test_primes[:5]:
    data = analyze_relationship(p)
    if data:
        rel = test_algebraic_relations(data)

        print(f"p = {p}:")
        print(f"  Period n = {data['n']} = 2·{data['m']}")
        print(f"  Halfway: ({data['x_m']}, {data['y_m']}), norm = {data['norm_m']}")
        print(f"  Fundamental: ({data['x_0']}, {data['y_0']}), norm = {data['norm_0']}")
        print()
        print(f"  Test: x_0 = x_m² + py_m² = {data['x_m']**2} + {p}·{data['y_m']**2} = {data['x_m']**2 + p*data['y_m']**2}")
        print(f"        Actual x_0 = {data['x_0']}")
        print(f"        Match: {rel['square_formula']['matches_x0']}")
        print()
        print(f"  Modulo p:")
        print(f"    x_m ≡ {data['x_m'] % p} (mod {p})")
        print(f"    x_m² ≡ {(data['x_m']**2) % p} (mod {p})  [should be ≡ -2]")
        print(f"    x_0 ≡ {data['x_0'] % p} (mod {p})  [should be ≡ -1]")
        print()

print("="*80)
print("KEY OBSERVATION")
print("="*80)
print()
print("If x_0 = x_m² + py_m² holds, then:")
print("  x_0 ≡ x_m² (mod p)")
print()
print("From halfway equation: x_m² - py_m² = -2")
print("  → x_m² = py_m² - 2")
print("  → x_m² ≡ -2 (mod p)")
print()
print("Therefore: x_0 ≡ -2 (mod p)")
print()
print("But we observe x_0 ≡ -1 (mod p) from data!")
print()
print("This means x_0 ≠ x_m² + py_m² in general.")
print()
print("Need to find the correct relationship...")
