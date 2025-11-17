#!/usr/bin/env python3
"""
ATTACK 5: Class Number h(D) Correlation with Pell Patterns

Question: Does class number h(p) correlate with:
  - Center norm sign?
  - Period length?
  - Regulator R(p)?
  - x₀ mod p pattern?

We know:
  - M(D) vs R(D): r = -0.33 (moderate anticorrelation)
  - R(D) vs period: r = +0.82 (strong correlation)

New angle: How does h(p) fit into this?
"""

from sympy import sqrt, isprime
from sympy.ntheory.continued_fraction import continued_fraction_periodic
from sympy.ntheory import factorint
import sys

def pell_fundamental_solution(D):
    """Find fundamental solution using CF."""
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

def class_number_quadratic(D):
    """
    Compute class number h(D) for Q(sqrt(D)) where D is squarefree.

    Uses PARI/GP's qfbclassno() function via subprocess.
    """
    import subprocess

    try:
        # Call PARI/GP to compute class number
        # qfbclassno(D) computes class number for discriminant D
        # For real quadratic field Q(sqrt(p)) where p ≡ 1 (mod 4): discriminant = p
        # For p ≡ 3 (mod 4): discriminant = 4p

        if D % 4 == 1:
            disc = D
        else:
            disc = 4 * D

        result = subprocess.run(
            ['gp', '-q', '-f'],
            input=f'print(qfbclassno({disc}))\n',
            capture_output=True,
            text=True,
            timeout=5
        )

        if result.returncode == 0:
            h = int(result.stdout.strip())
            return h
        else:
            return None

    except Exception as e:
        return None

def regulator(D):
    """Compute regulator R(D) = log(x₀ + y₀√D)."""
    sol = pell_fundamental_solution(D)
    if sol is None:
        return None

    x0, y0 = sol
    import math
    sqrtD = math.sqrt(D)
    R = math.log(x0 + y0 * sqrtD)
    return R

def center_convergent(D):
    """Compute center convergent and norm."""
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

def analyze_class_number():
    """Analyze class number correlations."""

    print("=" * 80)
    print("ATTACK 5: Class Number h(p) Correlation Analysis")
    print("=" * 80)
    print()

    results = []

    # Test primes p ≡ 3 (mod 4) up to 500 (class number usually 1 for small p)
    primes = [p for p in range(3, 500) if isprime(p) and p % 4 == 3]

    print(f"Testing {len(primes)} primes p ≡ 3 (mod 4) in [3, 500]...")
    print()

    for p in primes:
        try:
            # Get Pell data
            sol = pell_fundamental_solution(p)
            if sol is None:
                continue

            x0, y0 = sol

            # Center convergent
            x_c, y_c, norm, tau = center_convergent(p)

            # Regulator
            R = regulator(p)

            # Class number (approximate for now)
            h = class_number_quadratic(p)

            # x₀ mod p pattern
            x0_modp = x0 % p
            x0_pattern = -1 if x0_modp == p - 1 else (+1 if x0_modp == 1 else 0)

            results.append({
                'p': p,
                'p_mod8': p % 8,
                'tau': tau,
                'tau_mod4': tau % 4,
                'R': R,
                'h': h,
                'norm': norm,
                'norm_sign': 1 if norm > 0 else -1,
                'x0_pattern': x0_pattern
            })

        except Exception as e:
            print(f"Error at p={p}: {e}")
            continue

    print(f"Successfully analyzed {len(results)} primes")
    print()

    # Analysis: Correlations
    print("Correlation Analysis:")
    print()

    # Compute correlations using numpy if available, else manual
    try:
        import numpy as np

        # Extract data
        R_data = [r['R'] for r in results if r['R'] is not None]
        tau_data = [r['tau'] for r in results if r['R'] is not None]
        h_data = [r['h'] for r in results if r['R'] is not None]

        # Correlations
        corr_R_tau = np.corrcoef(R_data, tau_data)[0, 1]
        corr_R_h = np.corrcoef(R_data, h_data)[0, 1]
        corr_tau_h = np.corrcoef(tau_data, h_data)[0, 1]

        print(f"  R(p) vs τ:   r = {corr_R_tau:+.3f}")
        print(f"  R(p) vs h(p): r = {corr_R_h:+.3f}")
        print(f"  τ vs h(p):   r = {corr_tau_h:+.3f}")
        print()

    except ImportError:
        print("  (numpy not available - skipping correlation computation)")
        print()

    # Analysis by p mod 8
    print("Distribution by p mod 8:")
    print()

    for pmod8 in [3, 7]:
        subset = [r for r in results if r['p_mod8'] == pmod8]
        if not subset:
            continue

        print(f"  p ≡ {pmod8} (mod 8): {len(subset)} primes")

        # Period stats
        tau_vals = [r['tau'] for r in subset]
        print(f"    Period τ: min={min(tau_vals)}, max={max(tau_vals)}, mean={sum(tau_vals)/len(tau_vals):.1f}")

        # Regulator stats
        R_vals = [r['R'] for r in subset if r['R'] is not None]
        if R_vals:
            print(f"    Regulator R: min={min(R_vals):.2f}, max={max(R_vals):.2f}, mean={sum(R_vals)/len(R_vals):.2f}")

        # Class number distribution
        h_vals = [r['h'] for r in subset]
        from collections import Counter
        h_dist = Counter(h_vals)
        print(f"    Class number h(p) distribution:")
        for h_val, count in sorted(h_dist.items()):
            print(f"      h = {h_val}: {count}/{len(subset)} = {100*count/len(subset):.1f}%")

        print()

    print("=" * 80)
    print("Class number computed using PARI/GP qfbclassno()")
    print("=" * 80)

    return results

if __name__ == "__main__":
    results = analyze_class_number()
