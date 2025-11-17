#!/usr/bin/env python3
"""
Analyze extremal cases: primes with unusual h(p) values.

Focus on:
- h=13: p=4759 (only case in our dataset!)
- h=9: p=3719
- h=7: p∈{1087,2251,2467,4139}
- What makes them special?
"""

from sympy import sqrt, isprime, factorint
from sympy.ntheory.continued_fraction import continued_fraction_periodic
import subprocess

def pell_solution(D):
    """Get fundamental solution."""
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

def regulator(D):
    """R(D) = log(ε₀)."""
    sol = pell_solution(D)
    if sol is None:
        return None
    x0, y0 = sol
    import math
    return math.log(x0 + y0 * math.sqrt(D))

def center_convergent(D):
    """Get center convergent and norm."""
    cf = continued_fraction_periodic(0, 1, D)
    period = cf[1]
    tau = len(period)
    center_idx = tau // 2

    h_prev, h_curr = 1, cf[0]
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

def dist_to_square(p):
    """Distance to nearest square."""
    import math
    k = int(math.sqrt(p))
    dist_down = p - k**2
    dist_up = (k+1)**2 - p
    if dist_down < dist_up:
        return dist_down, k, 'above'  # p = k² + d
    else:
        return dist_up, k+1, 'below'  # p = k² - d

def analyze_extremal():
    """Deep dive into extremal h(p) cases."""

    print("=" * 80)
    print("EXTREMAL CASES ANALYSIS")
    print("=" * 80)
    print()

    # Cases to analyze
    cases = [
        (4759, 13),  # h=13 (unique!)
        (3719, 9),   # h=9
        (1087, 7), (2251, 7), (2467, 7), (4139, 7),  # h=7
    ]

    results = []

    for p, h_expected in cases:
        print(f"Analyzing p = {p} (expected h = {h_expected})")
        print("-" * 60)

        # Verify class number
        h = class_number(p)
        print(f"  Class number h(p) = {h}")

        # Pell solution
        sol = pell_solution(p)
        if sol:
            x0, y0 = sol
            print(f"  Fundamental unit: ε₀ = {x0} + {y0}√{p}")
            print(f"    (x₀ has {len(str(x0))} digits)")

        # Regulator
        R = regulator(p)
        if R:
            print(f"  Regulator R(p) = {R:.4f}")

        # CF period
        cf = continued_fraction_periodic(0, 1, p)
        period = cf[1]
        tau = len(period)
        print(f"  CF period τ = {tau}")
        print(f"  CF period sequence: {period[:10]}{'...' if len(period) > 10 else ''}")

        # Center convergent
        x_c, y_c, norm, _ = center_convergent(p)
        print(f"  Center convergent: ({x_c}, {y_c})")
        print(f"  Center norm: {norm}")

        # Distance to square
        d_sq, k, direction = dist_to_square(p)
        if direction == 'above':
            print(f"  Distance to square: p = {k}² + {d_sq}")
        else:
            print(f"  Distance to square: p = {k}² - {d_sq}")

        # p mod patterns
        print(f"  p mod 8 = {p % 8}")
        print(f"  p mod 24 = {p % 24}")
        print(f"  p mod 120 = {p % 120}")

        # x₀ mod p (from breakthrough)
        if sol:
            x0_modp = x0 % p
            if x0_modp == p - 1:
                pattern = '-1'
            elif x0_modp == 1:
                pattern = '+1'
            else:
                pattern = f'{x0_modp}'
            print(f"  x₀ mod p ≡ {pattern}")

        print()

        results.append({
            'p': p, 'h': h, 'R': R, 'tau': tau,
            'norm': norm, 'd_sq': d_sq, 'k': k,
            'direction': direction
        })

    # Comparative analysis
    print("=" * 80)
    print("COMPARATIVE ANALYSIS")
    print("=" * 80)
    print()

    print("Summary table:")
    print()
    print("    p     h   τ   R(p)   d_sq   form        norm")
    print("-" * 70)

    for r in results:
        form_str = f"{int(r['k'])}²{'+' if r['direction']=='above' else '-'}{int(r['d_sq'])}"
        print(f"  {int(r['p']):4d}  {int(r['h']):3d}  {int(r['tau']):2d}  {r['R']:6.2f}  {int(r['d_sq']):4d}   {form_str:10s}  {int(r['norm']):+5d}")

    print()

    # Check for patterns
    print("Pattern observations:")
    print()

    # All h=7 cases
    h7_cases = [r for r in results if r['h'] == 7]
    if h7_cases:
        print(f"  h=7 cases ({len(h7_cases)} primes):")
        d_sq_vals = [r['d_sq'] for r in h7_cases]
        norm_vals = [r['norm'] for r in h7_cases]
        print(f"    d_sq values: {d_sq_vals}")
        print(f"    center norms: {norm_vals}")
        print()

    # h=9 case
    h9_case = [r for r in results if r['h'] == 9]
    if h9_case:
        r = h9_case[0]
        print(f"  h=9 case (p={r['p']}):")
        print(f"    d_sq = {r['d_sq']}, norm = {r['norm']}")
        print()

    # h=13 case (THE OUTLIER)
    h13_case = [r for r in results if r['h'] == 13]
    if h13_case:
        r = h13_case[0]
        print(f"  h=13 case (p={r['p']}) - UNIQUE OUTLIER:")
        print(f"    d_sq = {r['d_sq']}, norm = {r['norm']}")
        print(f"    τ = {r['tau']} (very short!)")
        print(f"    R = {r['R']:.4f} (very small!)")
        print(f"    p = {r['k']}² {'+' if r['direction']=='above' else '-'} {r['d_sq']}")
        print()
        print(f"    Why h=13 so large?")
        print(f"    - Shortest period (τ=4) among all h>1 cases")
        print(f"    - Smallest regulator among high-h cases")
        print(f"    - p = {r['k']}² - 2 (classic form)")
        print()

    print("=" * 80)

    return results

if __name__ == "__main__":
    results = analyze_extremal()
