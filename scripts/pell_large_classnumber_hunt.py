#!/usr/bin/env python3
"""
Large-scale hunt for h>1 primes and their properties.

Focus: Find rare h(p) > 1 cases and analyze:
  - How does R(p) differ for h>1?
  - How does τ differ?
  - Is there p mod pattern?
  - Distance to nearest square?
"""

from sympy import sqrt, isprime
from sympy.ntheory.continued_fraction import continued_fraction_periodic
import subprocess
import sys

def pell_fundamental_solution_fast(D):
    """Fast Pell solver - just get x0, y0."""
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

def class_number_pari(D):
    """Compute h(D) via PARI/GP."""
    try:
        disc = D if D % 4 == 1 else 4 * D
        result = subprocess.run(
            ['gp', '-q', '-f'],
            input=f'print(qfbclassno({disc}))\n',
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            return int(result.stdout.strip())
        return None
    except:
        return None

def regulator(D):
    """R(D) = log(x₀ + y₀√D)."""
    sol = pell_fundamental_solution_fast(D)
    if sol is None:
        return None
    x0, y0 = sol
    import math
    return math.log(x0 + y0 * math.sqrt(D))

def dist_to_square(p):
    """Distance to nearest perfect square."""
    import math
    k = int(math.sqrt(p))
    return min(p - k**2, (k+1)**2 - p)

def analyze_large_sample():
    """Hunt for h>1 primes in large sample."""

    print("=" * 80)
    print("LARGE SCALE HUNT: h(p) > 1 Cases")
    print("=" * 80)
    print()

    # Test all primes p ≡ 3 (mod 4) up to 5000
    primes = [p for p in range(3, 5000) if isprime(p) and p % 4 == 3]

    print(f"Testing {len(primes)} primes p ≡ 3 (mod 4) in [3, 5000]...")
    print()
    print("Progress: ", end="", flush=True)

    results = []
    h_gt_1 = []

    for i, p in enumerate(primes):
        if i % 50 == 0:
            print(f"{i}/{len(primes)} ", end="", flush=True)

        try:
            # Get Pell data
            sol = pell_fundamental_solution_fast(p)
            if sol is None:
                continue

            # Period
            cf = continued_fraction_periodic(0, 1, p)
            tau = len(cf[1])

            # Regulator
            R = regulator(p)

            # Class number
            h = class_number_pari(p)
            if h is None:
                continue

            # Distance to square
            d_sq = dist_to_square(p)

            data = {
                'p': p,
                'p_mod8': p % 8,
                'tau': tau,
                'R': R,
                'h': h,
                'd_sq': d_sq
            }

            results.append(data)

            if h > 1:
                h_gt_1.append(data)

        except Exception as e:
            continue

    print(f"\n\nCompleted: {len(results)} primes analyzed")
    print()

    # Summary statistics
    print("=" * 80)
    print("OVERALL STATISTICS")
    print("=" * 80)
    print()

    h_vals = [r['h'] for r in results]
    from collections import Counter
    h_dist = Counter(h_vals)

    print(f"Class number distribution (all {len(results)} primes):")
    for h_val, count in sorted(h_dist.items()):
        pct = 100 * count / len(results)
        print(f"  h = {h_val:2d}: {count:4d} primes ({pct:5.2f}%)")

    print()
    print(f"Total h > 1: {len(h_gt_1)} primes ({100*len(h_gt_1)/len(results):.2f}%)")
    print()

    # Analyze h > 1 cases
    if h_gt_1:
        print("=" * 80)
        print(f"DETAILED ANALYSIS: {len(h_gt_1)} primes with h > 1")
        print("=" * 80)
        print()

        # Sort by h value
        h_gt_1_sorted = sorted(h_gt_1, key=lambda x: (x['h'], x['p']))

        print("Complete list:")
        print()
        print("    p   h  τ   R(p)    d_sq  p%8")
        print("-" * 50)

        for r in h_gt_1_sorted:
            print(f"  {r['p']:4d}  {r['h']:2d}  {r['tau']:2d}  {r['R']:6.2f}  {r['d_sq']:4d}   {r['p_mod8']}")

        print()

        # Compare with h=1 statistics
        h_eq_1 = [r for r in results if r['h'] == 1]

        print("Comparison: h=1 vs h>1")
        print()

        import numpy as np

        R_h1 = [r['R'] for r in h_eq_1]
        R_hg1 = [r['R'] for r in h_gt_1]
        tau_h1 = [r['tau'] for r in h_eq_1]
        tau_hg1 = [r['tau'] for r in h_gt_1]
        dsq_h1 = [r['d_sq'] for r in h_eq_1]
        dsq_hg1 = [r['d_sq'] for r in h_gt_1]

        print(f"  Regulator R(p):")
        print(f"    h=1:  mean={np.mean(R_h1):6.2f}, median={np.median(R_h1):6.2f}, std={np.std(R_h1):6.2f}")
        print(f"    h>1:  mean={np.mean(R_hg1):6.2f}, median={np.median(R_hg1):6.2f}, std={np.std(R_hg1):6.2f}")
        print()

        print(f"  Period τ:")
        print(f"    h=1:  mean={np.mean(tau_h1):6.2f}, median={np.median(tau_h1):6.2f}, std={np.std(tau_h1):6.2f}")
        print(f"    h>1:  mean={np.mean(tau_hg1):6.2f}, median={np.median(tau_hg1):6.2f}, std={np.std(tau_hg1):6.2f}")
        print()

        print(f"  Distance to square:")
        print(f"    h=1:  mean={np.mean(dsq_h1):6.2f}, median={np.median(dsq_h1):6.2f}, std={np.std(dsq_h1):6.2f}")
        print(f"    h>1:  mean={np.mean(dsq_hg1):6.2f}, median={np.median(dsq_hg1):6.2f}, std={np.std(dsq_hg1):6.2f}")
        print()

        # p mod 8 distribution
        print(f"  p mod 8 distribution:")
        h1_mod3 = sum(1 for r in h_eq_1 if r['p_mod8'] == 3)
        h1_mod7 = sum(1 for r in h_eq_1 if r['p_mod8'] == 7)
        hg1_mod3 = sum(1 for r in h_gt_1 if r['p_mod8'] == 3)
        hg1_mod7 = sum(1 for r in h_gt_1 if r['p_mod8'] == 7)

        print(f"    h=1:  p≡3(mod 8): {h1_mod3}/{len(h_eq_1)} = {100*h1_mod3/len(h_eq_1):.1f}%")
        print(f"          p≡7(mod 8): {h1_mod7}/{len(h_eq_1)} = {100*h1_mod7/len(h_eq_1):.1f}%")
        print(f"    h>1:  p≡3(mod 8): {hg1_mod3}/{len(h_gt_1)} = {100*hg1_mod3/len(h_gt_1):.1f}%")
        print(f"          p≡7(mod 8): {hg1_mod7}/{len(h_gt_1)} = {100*hg1_mod7/len(h_gt_1):.1f}%")

    print()
    print("=" * 80)

    return results, h_gt_1

if __name__ == "__main__":
    results, h_gt_1 = analyze_large_sample()
