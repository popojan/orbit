#!/usr/bin/env python3
"""
Test: R(n) correlation with distance to nearest perfect square

Hypothesis: R(n) depends on how close n is to k² for some integer k.
- Close to perfect square → easy √n approximation → short CF → small R
- Far from perfect squares → hard approximation → long CF → large R

This explains why 13, 61 might be "easy" primes:
- 13 = 3² + 4 (distance 4 from 9)
- 61 = 8² - 3 (distance 3 from 64)
"""

import math
from decimal import Decimal, getcontext
import statistics

getcontext().prec = 100

def is_perfect_square(n):
    sqrt_n = int(math.sqrt(n))
    return sqrt_n * sqrt_n == n

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

def M(n):
    """Childhood function."""
    count = 0
    sqrt_n = int(math.sqrt(n))
    for d in range(2, sqrt_n + 1):
        if n % d == 0:
            count += 1
    return count

def distance_to_perfect_square(n):
    """
    Distance to nearest perfect square.

    Returns: (distance, k, type)
    where k is nearest root and type is "below" or "above"
    """
    k_low = int(math.sqrt(n))
    k_high = k_low + 1

    dist_low = n - k_low**2
    dist_high = k_high**2 - n

    if dist_low < dist_high:
        return dist_low, k_low, "above"
    else:
        return dist_high, k_high, "below"

def continued_fraction_sqrt(D, max_period=10000):
    if is_perfect_square(D):
        return {'a0': int(math.sqrt(D)), 'period': [], 'period_length': 0}

    a0 = int(math.sqrt(D))
    seen = {}
    period = []
    m, d, a = 0, 1, a0

    for k in range(max_period):
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d

        state = (m, d)
        if state in seen:
            period_start = seen[state]
            actual_period = period[period_start:]
            return {
                'a0': a0,
                'period': actual_period,
                'period_length': len(actual_period)
            }

        seen[state] = len(period)
        period.append(a)

    raise ValueError(f"Period not found for D={D}")

def cf_convergents(a0, period, num_convergents=None):
    if num_convergents is None:
        num_convergents = 2 * len(period)

    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1
    convergents = [(p_curr, q_curr)]

    for k in range(num_convergents):
        a_k = period[k % len(period)]
        p_next = a_k * p_curr + p_prev
        q_next = a_k * q_curr + q_prev
        convergents.append((p_next, q_next))
        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

    return convergents

def regulator_direct_from_cf(D):
    cf = continued_fraction_sqrt(D)

    if cf['period_length'] == 0:
        return 0.0, 1, 0

    period = cf['period']
    n = len(period)

    convergents = cf_convergents(cf['a0'], period, num_convergents=2*n)

    if n % 2 == 1:
        p, q = convergents[n-1]
    else:
        p, q = convergents[2*n-1]

    x0, y0 = p, q

    if x0**2 - D * y0**2 != 1:
        raise ValueError(f"Not a Pell solution for D={D}")

    D_dec = Decimal(D)
    x0_dec = Decimal(x0)
    y0_dec = Decimal(y0)

    sqrt_D = D_dec.sqrt()
    epsilon = x0_dec + y0_dec * sqrt_D

    R = float(epsilon.ln())

    return R, x0, y0

def pearson(x, y):
    n = len(x)
    mean_x = statistics.mean(x)
    mean_y = statistics.mean(y)

    cov = sum((x[i] - mean_x) * (y[i] - mean_y) for i in range(n)) / n
    std_x = statistics.stdev(x)
    std_y = statistics.stdev(y)

    return cov / (std_x * std_y)

# ============================================================================
# Main Analysis
# ============================================================================

print("="*80)
print("R(n) vs DISTANCE TO PERFECT SQUARE")
print("="*80)
print()

# Test for n = 2..200 (skip perfect squares)
data = []

for n in range(2, 201):
    if is_perfect_square(n):
        continue

    try:
        R, x, y = regulator_direct_from_cf(n)
        M_n = M(n)
        period = continued_fraction_sqrt(n)['period_length']
        dist, k, pos = distance_to_perfect_square(n)

        data.append({
            'n': n,
            'M': M_n,
            'R': R,
            'period': period,
            'dist': dist,
            'k': k,
            'position': pos,
            'is_prime': is_prime(n)
        })
    except Exception as e:
        print(f"Failed for n={n}: {e}")

print(f"Collected {len(data)} data points (n = 2..200, excluding perfect squares)")
print()

# Correlation analysis
print("="*80)
print("CORRELATION ANALYSIS")
print("="*80)
print()

M_vals = [d['M'] for d in data]
R_vals = [d['R'] for d in data]
period_vals = [d['period'] for d in data]
dist_vals = [d['dist'] for d in data]

print("Pearson correlations with R(n):")
print(f"  M(n) vs R:      {pearson(M_vals, R_vals):+.4f}")
print(f"  dist vs R:      {pearson(dist_vals, R_vals):+.4f}  ⭐ [NEW!]")
print(f"  period vs R:    {pearson(period_vals, R_vals):+.4f}")
print()

print("Pearson correlations with period:")
print(f"  M(n) vs period: {pearson(M_vals, period_vals):+.4f}")
print(f"  dist vs period: {pearson(dist_vals, period_vals):+.4f}  ⭐ [NEW!]")
print()

# Stratify by prime/composite
primes = [d for d in data if d['is_prime']]
composites = [d for d in data if not d['is_prime']]

print("="*80)
print("STRATIFIED: PRIMES vs COMPOSITES")
print("="*80)
print()

print(f"PRIMES (n={len(primes)}):")
if primes:
    R_prime = [d['R'] for d in primes]
    dist_prime = [d['dist'] for d in primes]
    print(f"  Mean R:        {statistics.mean(R_prime):.4f}")
    print(f"  Mean dist:     {statistics.mean(dist_prime):.2f}")
    print(f"  dist vs R:     {pearson(dist_prime, R_prime):+.4f}")
print()

print(f"COMPOSITES (n={len(composites)}):")
if composites:
    R_comp = [d['R'] for d in composites]
    dist_comp = [d['dist'] for d in composites]
    M_comp = [d['M'] for d in composites]
    print(f"  Mean R:        {statistics.mean(R_comp):.4f}")
    print(f"  Mean dist:     {statistics.mean(dist_comp):.2f}")
    print(f"  dist vs R:     {pearson(dist_comp, R_comp):+.4f}")
    print(f"  M vs R:        {pearson(M_comp, R_comp):+.4f}")
print()

# Find examples
print("="*80)
print("EXAMPLES: CLOSE TO PERFECT SQUARE (dist ≤ 5)")
print("="*80)
print()

close_examples = sorted([d for d in data if d['dist'] <= 5], key=lambda x: x['dist'])

print("   n    dist  k²±  Prime?   R      Period  M(n)")
print("-" * 60)
for d in close_examples[:20]:
    sign = "+" if d['position'] == "above" else "-"
    k_sq = f"{d['k']}²{sign}{d['dist']}"
    prime_str = "PRIME" if d['is_prime'] else "comp"
    print(f"{d['n']:4d}   {d['dist']:3d}  {k_sq:8s}  {prime_str:5s}  {d['R']:7.3f}  {d['period']:4d}    {d['M']:2d}")

print()
print("="*80)
print("EXAMPLES: FAR FROM PERFECT SQUARE (dist ≥ 20)")
print("="*80)
print()

far_examples = sorted([d for d in data if d['dist'] >= 20], key=lambda x: -x['dist'])

print("   n    dist  k²±   Prime?   R      Period  M(n)")
print("-" * 60)
for d in far_examples[:20]:
    sign = "+" if d['position'] == "above" else "-"
    k_sq = f"{d['k']}²{sign}{d['dist']}"
    prime_str = "PRIME" if d['is_prime'] else "comp"
    print(f"{d['n']:4d}   {d['dist']:3d}  {k_sq:8s}  {prime_str:5s}  {d['R']:7.3f}  {d['period']:4d}    {d['M']:2d}")

print()
print("="*80)
print("CONCLUSION")
print("="*80)
print()

corr_dist_R = pearson(dist_vals, R_vals)
corr_M_R = pearson(M_vals, R_vals)

print("HYPOTHESIS: R(n) depends on distance to perfect square")
print()

if abs(corr_dist_R) > abs(corr_M_R):
    print(f"✅ CONFIRMED! dist → R correlation ({corr_dist_R:+.4f}) stronger than M → R ({corr_M_R:+.4f})")
    print()
    print("KEY INSIGHT: R(n) is more about √n approximability than divisor count!")
else:
    print(f"❌ REJECTED: M → R correlation ({corr_M_R:+.4f}) stronger than dist → R ({corr_dist_R:+.4f})")

print()
print("Next steps:")
print("  - Test quadratic residues (n ≡ □ mod k)?")
print("  - Investigate outliers (small dist but large R)?")
print("  - Connect to Egypt.wl approximation quality?")
