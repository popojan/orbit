#!/usr/bin/env python3
"""
Test: Does x₀ mod q correlate with whether p is QR/NQR mod q?

Quadratic Residue (QR): p ≡ r² (mod q) for some r
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

def is_quadratic_residue(a, q):
    """
    Check if a is quadratic residue mod q (odd prime q)
    Using Euler's criterion: a^((q-1)/2) ≡ 1 (mod q) if QR
    """
    if q == 2:
        return True  # Everything is QR mod 2
    return pow(a, (q - 1) // 2, q) == 1

def test_qr_correlation(test_primes, q):
    """Test if x₀ mod q correlates with p being QR/NQR mod q"""
    results = []

    for p in test_primes:
        if p == q:
            continue

        x0, y0 = pell_fundamental_solution(p)

        is_qr = is_quadratic_residue(p, q)

        results.append({
            'p': p,
            'p_mod_q': p % q,
            'is_qr': is_qr,
            'x0_mod_q': x0 % q
        })

    return results

def print_qr_analysis(results, q):
    """Print QR correlation analysis"""
    print(f"\n{'='*80}")
    print(f"QR CORRELATION: p QR/NQR mod {q} vs x₀ mod {q}")
    print(f"{'='*80}\n")

    # Separate by QR/NQR
    qr_group = [r for r in results if r['is_qr']]
    nqr_group = [r for r in results if not r['is_qr']]

    print(f"p is QR mod {q}:")
    print("-" * 80)
    if qr_group:
        x0_counts = {}
        for r in qr_group:
            val = r['x0_mod_q']
            x0_counts[val] = x0_counts.get(val, 0) + 1

        total = len(qr_group)
        for val in sorted(x0_counts.keys()):
            count = x0_counts[val]
            pct = 100.0 * count / total
            marker = " ★" if pct >= 90.0 else ""
            print(f"  x₀ ≡ {val} (mod {q}): {count:2d}/{total} = {pct:5.1f}%{marker}")
    print()

    print(f"p is NQR mod {q}:")
    print("-" * 80)
    if nqr_group:
        x0_counts = {}
        for r in nqr_group:
            val = r['x0_mod_q']
            x0_counts[val] = x0_counts.get(val, 0) + 1

        total = len(nqr_group)
        for val in sorted(x0_counts.keys()):
            count = x0_counts[val]
            pct = 100.0 * count / total
            marker = " ★" if pct >= 90.0 else ""
            print(f"  x₀ ≡ {val} (mod {q}): {count:2d}/{total} = {pct:5.1f}%{marker}")
    print()

    # Check if there's a strong difference
    if qr_group and nqr_group:
        print("Pattern strength:")
        print("-" * 80)
        # Find most common x₀ mod q for each group
        qr_mode = max(x0_counts, key=lambda k: sum(1 for r in qr_group if r['x0_mod_q'] == k))
        nqr_x0_counts = {}
        for r in nqr_group:
            val = r['x0_mod_q']
            nqr_x0_counts[val] = nqr_x0_counts.get(val, 0) + 1
        nqr_mode = max(nqr_x0_counts, key=lambda k: sum(1 for r in nqr_group if r['x0_mod_q'] == k))

        if qr_mode != nqr_mode:
            print(f"  QR → x₀ ≡ {qr_mode} (mod {q}) most common")
            print(f"  NQR → x₀ ≡ {nqr_mode} (mod {q}) most common")
            print(f"  → Different modes - potential pattern!")
        else:
            print(f"  Same mode for both - likely random")

if __name__ == '__main__':
    test_primes = [p for p in range(3, 500) if is_prime(p)]

    for q in [3, 5, 7, 11]:
        results = test_qr_correlation(test_primes, q)
        print_qr_analysis(results, q)
