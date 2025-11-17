#!/usr/bin/env python3
"""
Adversarial test: Primes FARTHEST from perfect squares.

Hypothesis:
  p far from k² → large R(p) → h=1 (chaos in units, not classes)
  p = k²-2      → small R(p) → h>1 (chaos in classes, not units)

Test: Find primes with maximum distance to nearest square.
"""

from sympy import sqrt, isprime
from sympy.ntheory.continued_fraction import continued_fraction_periodic
import subprocess
import math

def pell_solution(D):
    if int(sqrt(D))**2 == D:
        return None
    cf = continued_fraction_periodic(0, 1, D)
    period = cf[1]
    h_prev, h_curr = 1, cf[0]
    k_prev, k_curr = 0, 1
    for _ in range(2 * len(period)):
        for a in period:
            h_next = a * h_curr + h_prev
            k_next = a * k_curr + k_prev
            if h_next**2 - D * k_next**2 == 1:
                return (h_next, k_next)
            h_prev, h_curr = h_curr, h_next
            k_prev, k_curr = k_curr, k_next
    return None

def class_number(D):
    try:
        disc = D if D % 4 == 1 else 4 * D
        result = subprocess.run(
            ['gp', '-q', '-f'],
            input=f'print(qfbclassno({disc}))\n',
            capture_output=True, text=True, timeout=10
        )
        return int(result.stdout.strip()) if result.returncode == 0 else None
    except:
        return None

def regulator(D):
    sol = pell_solution(D)
    if sol is None:
        return None
    x0, y0 = sol
    return math.log(x0 + y0 * math.sqrt(D))

def dist_to_square(p):
    k = int(math.sqrt(p))
    dist_down = p - k**2
    dist_up = (k+1)**2 - p
    return min(dist_down, dist_up)

def max_distance_hunt():
    """Find primes with maximum distance to squares."""

    print("=" * 80)
    print("ADVERSARIAL TEST: Primes Farthest From Squares")
    print("=" * 80)
    print()

    # Scan primes p < 10000
    primes_mod_3_4 = [p for p in range(3, 10000) if isprime(p) and p % 4 == 3]

    print(f"Analyzing {len(primes_mod_3_4)} primes p ≡ 3 (mod 4) in [3, 10000]...")
    print()

    results = []

    for p in primes_mod_3_4:
        d_sq = dist_to_square(p)

        # Compute R, τ, h
        R = regulator(p)
        cf = continued_fraction_periodic(0, 1, p)
        tau = len(cf[1])

        if p < 5000:
            h = class_number(p)
        else:
            h = None

        results.append({
            'p': p,
            'd_sq': d_sq,
            'R': R,
            'tau': tau,
            'h': h
        })

    print(f"Completed analysis of {len(results)} primes")
    print()

    # Sort by distance
    results_sorted = sorted(results, key=lambda x: -x['d_sq'])

    # Top 20 farthest
    print("=" * 80)
    print("TOP 20 PRIMES FARTHEST FROM SQUARES")
    print("=" * 80)
    print()
    print("    p    d_sq   R(p)    τ    h")
    print("-" * 50)

    for r in results_sorted[:20]:
        h_str = f"{r['h']:3d}" if r['h'] is not None else "  -"
        print(f"  {r['p']:4d}   {r['d_sq']:3d}  {r['R']:6.2f}  {r['tau']:3d}  {h_str}")

    print()

    # Statistics: correlation d_sq vs R
    import numpy as np

    d_sq_vals = [r['d_sq'] for r in results]
    R_vals = [r['R'] for r in results if r['R'] is not None]
    d_sq_for_R = [r['d_sq'] for r in results if r['R'] is not None]

    corr_d_R = np.corrcoef(d_sq_for_R, R_vals)[0, 1]

    print("Correlation analysis:")
    print(f"  d_sq vs R(p): r = {corr_d_R:+.3f}")
    print()

    # Top vs bottom comparison
    top_20 = results_sorted[:20]
    bottom_20 = results_sorted[-20:]

    top_R = [r['R'] for r in top_20 if r['R'] is not None]
    bottom_R = [r['R'] for r in bottom_20 if r['R'] is not None]

    top_h = [r['h'] for r in top_20 if r['h'] is not None]
    bottom_h = [r['h'] for r in bottom_20 if r['h'] is not None]

    print("Comparison: Top 20 (farthest) vs Bottom 20 (closest)")
    print()

    if top_R and bottom_R:
        print(f"  Regulator R:")
        print(f"    Farthest (d_sq large): mean = {np.mean(top_R):6.2f}, median = {np.median(top_R):6.2f}")
        print(f"    Closest  (d_sq small): mean = {np.mean(bottom_R):6.2f}, median = {np.median(bottom_R):6.2f}")
        print()

    if top_h and bottom_h:
        from collections import Counter

        top_h1 = sum(1 for h in top_h if h == 1)
        bottom_h1 = sum(1 for h in bottom_h if h == 1)

        print(f"  Class number h=1 rate:")
        print(f"    Farthest: {top_h1}/{len(top_h)} = {100*top_h1/len(top_h):.1f}%")
        print(f"    Closest:  {bottom_h1}/{len(bottom_h)} = {100*bottom_h1/len(bottom_h):.1f}%")
        print()

        print(f"  Mean class number:")
        print(f"    Farthest: {np.mean(top_h):.2f}")
        print(f"    Closest:  {np.mean(bottom_h):.2f}")

    print()

    # Check if k²-2 primes are in bottom
    k_sq_minus_2 = [k**2 - 2 for k in range(2, 101) if isprime(k**2 - 2) and k**2 - 2 < 10000]
    k_sq_in_bottom = [p for p in k_sq_minus_2 if p in [r['p'] for r in bottom_20]]

    print(f"k²-2 primes in bottom 20 (closest to squares):")
    print(f"  Count: {len(k_sq_in_bottom)}/26 k²-2 primes are in bottom 20")
    if k_sq_in_bottom:
        print(f"  Examples: {k_sq_in_bottom[:5]}")

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print()

    if corr_d_R > 0.5:
        print("✓ HYPOTHESIS CONFIRMED:")
        print("  Primes far from squares → large R(p) → hard Pell")
        print("  Primes close to squares → small R(p) → easy Pell")
        print()
        print("  k²-2 is TRIVIAL because it's closest to square!")
    else:
        print("✗ HYPOTHESIS REJECTED:")
        print("  Distance to square does NOT strongly correlate with R(p)")

    print()

    return results

if __name__ == "__main__":
    results = max_distance_hunt()
