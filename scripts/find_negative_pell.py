#!/usr/bin/env python3
"""
Find negative Pell solutions by brute force and compare with Wildberger algorithm

Key insight: Negative Pell x² - dy² = -1 exists iff CF period is odd.
If it exists, squaring it gives fundamental solution: (x₀,y₀)² = fundamental
"""

import math


def continued_fraction_sqrt(d, max_terms=1000):
    """Compute continued fraction of √d"""
    if int(math.sqrt(d))**2 == d:
        return None  # Perfect square

    m, d_val, a = 0, 1, int(math.sqrt(d))
    a0 = a
    cf = [a0]

    seen = {}
    while True:
        key = (m, d_val, a)
        if key in seen:
            period_start = seen[key]
            return a0, cf[period_start:], len(cf) - period_start
        seen[key] = len(cf) - 1

        m = d_val * a - m
        d_val = (d - m * m) // d_val
        a = (a0 + m) // d_val
        cf.append(a)

        if len(cf) > max_terms:
            break

    return a0, cf[1:], len(cf) - 1


def has_negative_pell_solution(d):
    """Check if x² - dy² = -1 has solutions (CF period must be odd)"""
    result = continued_fraction_sqrt(d)
    if result is None:
        return False
    a0, period, period_len = result
    return period_len % 2 == 1


def find_negative_pell_brute_force(d, max_search=10000):
    """Brute force search for negative Pell solution"""
    for y in range(1, max_search):
        x_squared = d * y * y - 1
        if x_squared <= 0:
            continue
        x = int(math.sqrt(x_squared))
        if x * x == x_squared:
            # Found solution!
            return (x, y)
    return None


def pellsol_simple(d):
    """Wildberger algorithm (simple version for comparison)"""
    a, b, c = 1, 0, -d
    u, v, r, s = 1, 0, 0, 1

    while True:
        t = a + b + b + c
        if t > 0:
            a = t
            b += c
            u += v
            r += s
        else:
            b += a
            c = t
            v += u
            s += r

        if a == 1 and b == 0 and c == -d:
            break

    return (u, r)


print("="*70)
print("Negative Pell Analysis: x² - dy² = -1")
print("="*70)
print()

print("Testing d values up to 100:")
print()
print(f"{'d':>3} {'CF Period':>10} {'Has -Pell?':>12} {'Brute Force':>20} {'Check':>10}")
print("-"*70)

has_neg_pell_list = []
no_neg_pell_list = []

for d in range(2, 101):
    # Skip perfect squares
    sqrt_d = int(math.sqrt(d))
    if sqrt_d * sqrt_d == d:
        continue

    # Check via CF period
    cf_result = continued_fraction_sqrt(d)
    if cf_result is None:
        continue

    a0, period, period_len = cf_result
    has_neg = period_len % 2 == 1

    # Try brute force
    neg_sol = find_negative_pell_brute_force(d, max_search=10000) if has_neg else None

    # Verify
    check = ""
    if neg_sol:
        x, y = neg_sol
        norm = x**2 - d*y**2
        check = f"{norm}"
        if has_neg:
            has_neg_pell_list.append(d)
    else:
        if not has_neg:
            no_neg_pell_list.append(d)

    if d <= 30 or has_neg:  # Show first 30 or any with neg Pell
        print(f"{d:3d} {period_len:10d} {str(has_neg):>12} {str(neg_sol) if neg_sol else 'None':>20} {check:>10}")

print()
print(f"Summary:")
print(f"  d with negative Pell: {len(has_neg_pell_list)}")
print(f"  d WITHOUT negative Pell: {len(no_neg_pell_list)}")
print()
print(f"d values WITH negative Pell (first 30):")
print(f"  {has_neg_pell_list[:30]}")
print()
print(f"d values WITHOUT negative Pell (first 30):")
print(f"  {no_neg_pell_list[:30]}")
print()

# Key observation: Compare fundamental solutions
print("="*70)
print("Relationship: (x₀,y₀)² = fundamental solution?")
print("="*70)
print()

for d in has_neg_pell_list[:10]:
    neg_sol = find_negative_pell_brute_force(d)
    fund_sol = pellsol_simple(d)

    if neg_sol:
        x0, y0 = neg_sol
        xf, yf = fund_sol

        # Square the negative Pell solution
        # (x₀ + y₀√d)² = x₀² + 2x₀y₀√d + y₀²d = (x₀²+y₀²d) + (2x₀y₀)√d
        # Since x₀² - dy₀² = -1, we have x₀²+dy₀² = 1+2dy₀²
        # Actually: (x₀ + y₀√d)² = (x₀²+dy₀²) + (2x₀y₀)√d
        x_squared = x0**2 + d*y0**2
        y_squared = 2*x0*y0

        print(f"d={d}:")
        print(f"  Negative Pell: ({x0}, {y0}), check: {x0**2 - d*y0**2}")
        print(f"  Fundamental: ({xf}, {yf}), check: {xf**2 - d*yf**2}")
        print(f"  Squared negative: ({x_squared}, {y_squared})")
        print(f"  Match? {(x_squared, y_squared) == (xf, yf)}")
        print()
