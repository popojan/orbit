#!/usr/bin/env python3
"""
ATTACK 2: y₀ mod p Pattern Discovery

We cracked x₀ mod p via center convergent.
Now: What about y₀ mod p?

Theory:
  x₀ = x_c² + py_c²
  y₀ = 2x_c·y_c

Taking mod p:
  x₀ ≡ x_c² (mod p)  ✓ (already exploited)
  y₀ ≡ 2x_c·y_c (mod p)  ← NEW TARGET

Hypothesis: Can we predict y₀ mod p from p mod 8?
Or from center convergent data?
"""

from sympy import sqrt, floor, isprime
from sympy.ntheory.continued_fraction import continued_fraction_periodic
from fractions import Fraction
import sys

def pell_fundamental_solution(D):
    """Find fundamental solution to x² - Dy² = 1 using CF."""
    if int(sqrt(D))**2 == D:
        return None

    cf = continued_fraction_periodic(0, 1, D)
    a0 = cf[0]
    period = cf[1]

    # Convergents
    h_prev, h_curr = 1, a0
    k_prev, k_curr = 0, 1

    for i in range(len(period)):
        a = period[i]
        h_next = a * h_curr + h_prev
        k_next = a * k_curr + k_prev

        # Check Pell equation
        if h_next**2 - D * k_next**2 == 1:
            return (h_next, k_next)

        h_prev, h_curr = h_curr, h_next
        k_prev, k_curr = k_curr, k_next

    # If period doesn't give solution, double it
    for i in range(len(period)):
        a = period[i]
        h_next = a * h_curr + h_prev
        k_next = a * k_curr + k_prev

        if h_next**2 - D * k_next**2 == 1:
            return (h_next, k_next)

        h_prev, h_curr = h_curr, h_next
        k_prev, k_curr = k_curr, k_next

    return None

def center_convergent(D):
    """Compute center convergent and its norm."""
    cf = continued_fraction_periodic(0, 1, D)
    a0 = cf[0]
    period = cf[1]
    tau = len(period)

    center_idx = tau // 2

    # Build convergents up to center
    h_prev, h_curr = 1, a0
    k_prev, k_curr = 0, 1

    for i in range(center_idx):
        a = period[i]
        h_next = a * h_curr + h_prev
        k_next = a * k_curr + k_prev
        h_prev, h_curr = h_curr, h_next
        k_prev, k_curr = k_curr, k_next

    x_c, y_c = h_curr, k_curr
    norm = x_c**2 - D * y_c**2

    return x_c, y_c, norm, tau

def analyze_y0_modp():
    """Analyze y₀ mod p patterns for p ≡ 3 (mod 4)."""

    print("=" * 80)
    print("ATTACK 2: y₀ mod p Pattern Discovery")
    print("=" * 80)
    print()

    results = []

    # Test all primes p ≡ 3 (mod 4) up to 1000 (quick test)
    primes = [p for p in range(3, 1000) if isprime(p) and p % 4 == 3]

    print(f"Testing {len(primes)} primes p ≡ 3 (mod 4) in [3, 1000]...")
    print()

    for p in primes:
        try:
            # Get Pell solution
            sol = pell_fundamental_solution(p)
            if sol is None:
                continue

            x0, y0 = sol

            # Get center convergent
            x_c, y_c, norm, tau = center_convergent(p)

            # Compute y₀ mod p
            y0_modp = y0 % p

            # Theoretical: y₀ ≡ 2x_c·y_c (mod p)
            theory = (2 * x_c * y_c) % p

            # Check if theory matches
            matches = (y0_modp == theory)

            # Also compute x₀ mod p for reference
            x0_modp = x0 % p
            x0_pattern = -1 if x0_modp == p - 1 else (+1 if x0_modp == 1 else 0)

            # Collect data
            results.append({
                'p': p,
                'p_mod8': p % 8,
                'tau': tau,
                'tau_mod4': tau % 4,
                'x0_modp': x0_modp,
                'x0_pattern': x0_pattern,
                'y0_modp': y0_modp,
                'theory_2xcyc': theory,
                'matches_theory': matches,
                'x_c': x_c,
                'y_c': y_c,
                'norm': norm,
                'norm_sign': 1 if norm > 0 else -1
            })

        except Exception as e:
            print(f"Error at p={p}: {e}")
            continue

    print(f"Successfully analyzed {len(results)} primes")
    print()

    # Analysis 1: Does theory y₀ ≡ 2x_c·y_c (mod p) hold?
    theory_matches = sum(1 for r in results if r['matches_theory'])
    print(f"Theory check: y₀ ≡ 2x_c·y_c (mod p)")
    print(f"  Matches: {theory_matches}/{len(results)} = {100*theory_matches/len(results):.1f}%")
    print()

    # Analysis 2: Pattern in y₀ mod p
    print("Pattern search: y₀ mod p values")

    # Check if y₀ mod p is always small (like ±1, ±2)
    small_values = sum(1 for r in results if r['y0_modp'] <= 10 or r['y0_modp'] >= r['p'] - 10)
    print(f"  y₀ mod p is 'small' (≤10 or ≥p-10): {small_values}/{len(results)} = {100*small_values/len(results):.1f}%")

    # Distribution by p mod 8
    for pmod8 in [3, 7]:
        subset = [r for r in results if r['p_mod8'] == pmod8]
        if not subset:
            continue

        print(f"\n  p ≡ {pmod8} (mod 8): {len(subset)} primes")

        # Check y₀ mod p patterns
        y0_small = sum(1 for r in subset if r['y0_modp'] <= 10 or r['y0_modp'] >= r['p'] - 10)
        print(f"    Small y₀ mod p: {y0_small}/{len(subset)} = {100*y0_small/len(subset):.1f}%")

        # Check specific values
        y0_eq_2 = sum(1 for r in subset if r['y0_modp'] == 2)
        y0_eq_pm2 = sum(1 for r in subset if r['y0_modp'] in [2, r['p']-2])

        print(f"    y₀ ≡ 2 (mod p): {y0_eq_2}/{len(subset)} = {100*y0_eq_2/len(subset):.1f}%")
        print(f"    y₀ ≡ ±2 (mod p): {y0_eq_pm2}/{len(subset)} = {100*y0_eq_pm2/len(subset):.1f}%")

        # Sample distribution
        if len(subset) >= 10:
            sample = subset[:10]
            print(f"    Sample y₀ mod p values:")
            for r in sample:
                y_val = r['y0_modp'] if r['y0_modp'] <= r['p']//2 else r['y0_modp'] - r['p']
                print(f"      p={int(r['p']):3d}: y₀ ≡ {int(y_val):+5d} (mod p), x_c={int(r['x_c'])}, y_c={int(r['y_c'])}")

    # Analysis 3: Check y_c mod p instead
    print("\nPattern search: y_c mod p (center convergent y-coordinate)")

    for pmod8 in [3, 7]:
        subset = [r for r in results if r['p_mod8'] == pmod8]
        if not subset:
            continue

        print(f"\n  p ≡ {pmod8} (mod 8): {len(subset)} primes")

        # Check if y_c mod p is small
        yc_small = sum(1 for r in subset if (r['y_c'] % r['p']) <= 10 or (r['y_c'] % r['p']) >= r['p'] - 10)
        print(f"    y_c mod p is 'small': {yc_small}/{len(subset)} = {100*yc_small/len(subset):.1f}%")

        # Sample
        if len(subset) >= 5:
            sample = subset[:5]
            print(f"    Sample:")
            for r in sample:
                yc_modp = r['y_c'] % r['p']
                yc_val = yc_modp if yc_modp <= r['p']//2 else yc_modp - r['p']
                print(f"      p={int(r['p']):3d}: y_c ≡ {int(yc_val):+5d} (mod p)")

    # Analysis 4: Check if y₀/y_c has pattern
    print("\nPattern search: y₀/y_c ratio mod p")

    for pmod8 in [3, 7]:
        subset = [r for r in results if r['p_mod8'] == pmod8]
        if not subset:
            continue

        print(f"\n  p ≡ {pmod8} (mod 8):")

        # Sample ratio analysis
        if len(subset) >= 5:
            sample = subset[:5]
            for r in sample:
                # Compute y₀ * y_c^{-1} mod p (if y_c is invertible)
                p = int(r['p'])
                y0_modp = int(r['y0_modp'])
                y_c = int(r['y_c']) % p

                if y_c != 0:
                    try:
                        # Compute modular inverse
                        yc_inv = pow(y_c, -1, p)
                        ratio = (y0_modp * yc_inv) % p
                        ratio_signed = ratio if ratio <= p//2 else ratio - p

                        # Also compute 2x_c mod p
                        two_xc = (2 * int(r['x_c'])) % p
                        two_xc_signed = two_xc if two_xc <= p//2 else two_xc - p

                        matches_2xc = (ratio == two_xc)

                        print(f"    p={p:3d}: y₀/y_c ≡ {ratio_signed:+5d}, 2x_c ≡ {two_xc_signed:+5d}, match={matches_2xc}")
                    except:
                        pass

    print()
    print("=" * 80)
    print("Analysis complete")
    print("=" * 80)

    return results

if __name__ == "__main__":
    results = analyze_y0_modp()
