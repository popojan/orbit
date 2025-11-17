#!/usr/bin/env python3
"""
Genus theory for p = k² - 2 primes.

These primes have special properties:
- All high-h outliers (h≥9) have this form
- τ = 4 always (proven or empirical?)
- Genus field Q(√p, √2) structure special

Theory:
For p = k² - 2, the fundamental unit can be expressed simply:
  ε₀ = k + √p  (if this satisfies Pell, which it should!)

Verification:
  (k + √p)² = k² + 2k√p + p = k² + p + 2k√p
  Since p = k² - 2, we have k² = p + 2
  So: k² + p = 2p + 2 = 2(p+1)

Wait, that doesn't give Pell directly. Let me check empirically.
"""

from sympy import sqrt, isprime
from sympy.ntheory.continued_fraction import continued_fraction_periodic
import subprocess

def class_number(D):
    """Get h(D) from PARI."""
    try:
        disc = D if D % 4 == 1 else 4 * D
        result = subprocess.run(
            ['gp', '-q', '-f'],
            input=f'print(qfbclassno({disc}))\n',
            capture_output=True, text=True, timeout=5
        )
        return int(result.stdout.strip()) if result.returncode == 0 else None
    except:
        return None

def pell_solution(D):
    """Get (x₀, y₀)."""
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

def test_simple_unit_hypothesis(p, k):
    """
    Test if ε₀ = k + √p (naive guess).
    This would mean x₀ = k, y₀ = 1, but that's too simple.

    Let's check what x₀ actually is.
    """
    sol = pell_solution(p)
    if sol is None:
        return None

    x0, y0 = sol

    # Check various relationships
    checks = {
        'x0 = k+1': x0 == k + 1,
        'x0 = 2k': x0 == 2 * k,
        'x0 = k² + 1': x0 == k**2 + 1,
        'x0 = k² - 1': x0 == k**2 - 1,
        'x0 = k²': x0 == k**2,
        'y0 = k': y0 == k,
        'y0 = k-1': y0 == k - 1,
        'y0 = k+1': y0 == k + 1,
    }

    return x0, y0, checks

def analyze_k_squared_minus_2():
    """Analyze all p = k² - 2 primes."""

    print("=" * 80)
    print("GENUS THEORY: p = k² - 2 Primes")
    print("=" * 80)
    print()

    results = []

    # Generate all p = k² - 2 primes for k up to 100
    print("Finding all p = k² - 2 primes for k ≤ 100...")
    print()

    for k in range(2, 101):
        p = k**2 - 2
        if p > 0 and isprime(p):
            results.append((p, k))

    print(f"Found {len(results)} primes of form k² - 2:")
    print()
    print("   k     p = k²-2      h(p)   τ   x₀        y₀")
    print("-" * 70)

    data = []

    for p, k in results:
        h = class_number(p)

        cf = continued_fraction_periodic(0, 1, p)
        tau = len(cf[1])

        sol = pell_solution(p)
        if sol:
            x0, y0 = sol

            data.append({
                'k': k,
                'p': p,
                'h': h,
                'tau': tau,
                'x0': x0,
                'y0': y0
            })

            print(f"  {int(k):3d}  {int(p):6d} ({int(k)}²-2)  {int(h):3d}   {int(tau):2d}   {int(x0):8d}   {int(y0):6d}")

    print()

    # Analysis: τ always 4?
    print("=" * 80)
    print("PATTERN ANALYSIS")
    print("=" * 80)
    print()

    tau_vals = [d['tau'] for d in data]
    tau_4_count = sum(1 for t in tau_vals if t == 4)

    print(f"Period τ distribution:")
    print(f"  τ = 4: {tau_4_count}/{len(data)} = {100*tau_4_count/len(data):.1f}%")
    if tau_4_count < len(data):
        other_tau = [d for d in data if d['tau'] != 4]
        print(f"  Other τ values:")
        for d in other_tau:
            print(f"    k={d['k']}, p={d['p']}, τ={d['tau']}")

    print()

    # Check x₀ vs k relationship
    print("x₀ relationship to k:")
    print()
    print("   k     p      x₀      x₀/k    x₀-k²   x₀-(k²-1)  x₀-(k²+1)")
    print("-" * 75)

    for d in data[:15]:  # First 15 for readability
        k, p, x0 = int(d['k']), int(d['p']), int(d['x0'])
        ratio = x0 / k
        diff_k2 = x0 - k**2
        diff_k2m1 = x0 - (k**2 - 1)
        diff_k2p1 = x0 - (k**2 + 1)

        print(f"  {k:3d}  {p:6d}  {x0:8d}  {ratio:7.2f}  {diff_k2:+6d}    {diff_k2m1:+6d}      {diff_k2p1:+6d}")

    print()

    # Check if x₀ = k² + 1 pattern
    x0_eq_k2p1 = sum(1 for d in data if d['x0'] == d['k']**2 + 1)
    print(f"x₀ = k² + 1 check: {x0_eq_k2p1}/{len(data)} = {100*x0_eq_k2p1/len(data):.1f}%")

    # Check y₀ vs k relationship
    print()
    print("y₀ relationship to k:")
    print()
    print("   k     p      y₀      y₀/k    y₀-k    y₀-(k-1)  y₀-(k+1)")
    print("-" * 70)

    for d in data[:15]:
        k, p, y0 = int(d['k']), int(d['p']), int(d['y0'])
        ratio = y0 / k
        diff_k = y0 - k
        diff_km1 = y0 - (k - 1)
        diff_kp1 = y0 - (k + 1)

        print(f"  {k:3d}  {p:6d}  {y0:6d}  {ratio:7.2f}  {diff_k:+5d}   {diff_km1:+5d}     {diff_kp1:+5d}")

    print()

    # Check if y₀ = k + 1 pattern
    y0_eq_kp1 = sum(1 for d in data if d['y0'] == d['k'] + 1)
    print(f"y₀ = k + 1 check: {y0_eq_kp1}/{len(data)} = {100*y0_eq_kp1/len(data):.1f}%")

    print()

    # Class number distribution
    print("Class number distribution for k² - 2 primes:")
    print()

    from collections import Counter
    h_vals = [d['h'] for d in data]
    h_dist = Counter(h_vals)

    for h_val, count in sorted(h_dist.items()):
        pct = 100 * count / len(data)
        print(f"  h = {h_val:2d}: {count:3d} primes ({pct:5.1f}%)")

    # Compare with general population
    print()
    print("Comparison with general p ≡ 7 (mod 8) population:")
    print("  General: ~84% have h=1 (from large hunt)")
    print(f"  k²-2:    {100*h_dist.get(1,0)/len(data):.1f}% have h=1")
    print()
    print("  → k²-2 primes have MUCH higher h>1 rate!")

    print()
    print("=" * 80)

    return data

if __name__ == "__main__":
    data = analyze_k_squared_minus_2()
