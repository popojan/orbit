#!/usr/bin/env python3
"""
Fixed integral representation test

Fixes:
1. Increase nmax for direct sum (500 → 5000)
2. Separate singular part of integral
3. Better quadrature setup
"""

from mpmath import mp, gamma, polylog, exp, quad, conj, fabs, zeta
import sys

mp.dps = 50

def M(n):
    """M(n) = count of divisors d where 2 ≤ d ≤ √n"""
    if n < 4:
        return 0
    count = 0
    sqrt_n = int(n**0.5) + 1
    for d in range(2, sqrt_n + 1):
        if d * d > n:
            break
        if n % d == 0:
            count += 1
    return count

def L_M_direct(s, nmax=5000):
    """Direct sum with LARGER nmax"""
    result = mp.mpc(0)
    for n in range(1, nmax + 1):
        result += M(n) / mp.power(n, s)
    return result

def integrand_regular(t, s):
    """
    Regular part: [Li_s(e^{-t}) - e^{-t}]/(1-e^{-t}) - [ζ(s)-1]/t

    This removes the t^{-1} singularity.
    """
    if t == 0:
        return mp.mpc(0)

    exp_mt = exp(-t)
    Li_s_val = polylog(s, exp_mt)

    # Full expression
    full = (Li_s_val - exp_mt) / (1 - exp_mt)

    # Singular part
    singular = (zeta(s) - 1) / t

    # Regular = full - singular
    regular = full - singular

    return mp.power(t, s - 1) * regular

def L_M_integral_fixed(s):
    """
    Integral with separated singular part:

    L_M(s) = 1/Γ(s) { [ζ(s)-1]/(s-1) + ∫_0^∞ t^{s-1} f_reg(t) dt }

    where f_reg(t) = [Li_s(e^{-t}) - e^{-t}]/(1-e^{-t}) - [ζ(s)-1]/t
    """

    # Singular part (analytical)
    if abs(s - 1) > 0.01:
        singular_contrib = (zeta(s) - 1) / (s - 1)
    else:
        # Near s=1, use L'Hopital or series
        # For now, skip this case
        singular_contrib = mp.mpc(0)

    # Regular part (numerical integration)
    # Split at t=10 (tail is exponentially small)
    regular_contrib = quad(lambda t: integrand_regular(t, s), [0, 30],
                          maxdegree=15, error=True)

    integral_val = singular_contrib + regular_contrib[0]
    error_est = regular_contrib[1]

    # Divide by Γ(s)
    gamma_s = gamma(s)

    return integral_val / gamma_s, error_est / abs(gamma_s)

def main():
    print("=" * 80)
    print("Testing FIXED Integral Representation")
    print("=" * 80)
    print()
    print("Fixes:")
    print("  1. nmax: 500 → 5000 (reduce direct sum truncation error)")
    print("  2. Separated singular part [ζ(s)-1]/(s-1) analytically")
    print("  3. Higher quadrature degree")
    print()
    print("=" * 80)

    # Test in convergence region
    print()
    print("TEST 1: Convergence region Re(s) > 1")
    print("=" * 80)
    print()

    test_points = [
        mp.mpc(2, 0),
        mp.mpc(1.5, 5),
        mp.mpc(1.2, 10),
    ]

    print(f"{'s':<20} {'Direct (n=5000)':<25} {'Integral':<25} {'Error':<15} {'Est.err':<10}")
    print("-" * 95)

    for s in test_points:
        try:
            L_direct = L_M_direct(s, nmax=5000)
            L_int, err_est = L_M_integral_fixed(s)
            error = fabs(L_direct - L_int)

            print(f"{str(s):<20} {str(L_direct)[:24]:<25} {str(L_int)[:24]:<25} {float(error):<15.6e} {float(err_est):<10.2e}")
        except Exception as e:
            print(f"{str(s):<20} ERROR: {e}")

    print()
    print("=" * 80)
    print("INTERPRETATION")
    print("=" * 80)
    print()

    print("If error < 10^-6:")
    print("  ✓ Integral formula WORKS")
    print("  ✓ Previous error was truncation + quadrature issues")
    print()
    print("If error still high:")
    print("  → Need different approach (Euler-Maclaurin, etc.)")
    print()

if __name__ == "__main__":
    main()
