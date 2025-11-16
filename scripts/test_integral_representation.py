#!/usr/bin/env python3
"""
Test integral representation for L_M(s)

Theoretical formula:
  L_M(s) = (1/Γ(s)) ∫_0^∞ t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1 - e^{-t}) dt

Test:
1. Verify against direct sum for Re(s) > 1
2. Compute L_M(s) in critical strip
3. Check Schwarz symmetry
4. Compare with γ(s) formula predictions
"""

from mpmath import mp, gamma, polylog, exp, quad, conj, fabs
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

def L_M_direct(s, nmax=1000):
    """Direct Dirichlet series"""
    result = mp.mpc(0)
    for n in range(1, nmax + 1):
        result += M(n) / mp.power(n, s)
    return result

def integrand(t, s):
    """
    Integrand: t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1 - e^{-t})
    """
    if t == 0:
        return mp.mpc(0)

    exp_mt = exp(-t)

    # Polylog Li_s(e^{-t})
    Li_s_val = polylog(s, exp_mt)

    # Numerator: Li_s(e^{-t}) - e^{-t}
    numerator = Li_s_val - exp_mt

    # Denominator: 1 - e^{-t}
    denominator = 1 - exp_mt

    # t^{s-1}
    t_power = mp.power(t, s - 1)

    return t_power * numerator / denominator

def L_M_integral(s):
    """
    Integral representation:
    L_M(s) = (1/Γ(s)) ∫_0^∞ t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1 - e^{-t}) dt
    """
    # Compute integral
    # Split at reasonable points to handle near-zero and tail

    # For t near 0, use careful integration
    # For large t, exponential decay makes it negligible

    integral_val = quad(lambda t: integrand(t, s), [0, 50], maxdegree=10)

    # Divide by Γ(s)
    gamma_s = gamma(s)

    return integral_val / gamma_s

def main():
    print("=" * 80)
    print("Testing Integral Representation for L_M(s)")
    print("=" * 80)
    print()
    print("Formula: L_M(s) = (1/Γ(s)) ∫_0^∞ t^{s-1} [Li_s(e^{-t}) - e^{-t}]/(1-e^{-t}) dt")
    print()
    print("=" * 80)

    # Test 1: Convergence region Re(s) > 1
    print()
    print("TEST 1: Verification in convergence region Re(s) > 1")
    print("=" * 80)
    print()
    print(f"{'s':<20} {'Direct sum':<25} {'Integral':<25} {'Error':<15}")
    print("-" * 85)

    test_points_conv = [
        mp.mpc(2, 0),
        mp.mpc(1.5, 5),
        mp.mpc(1.2, 10),
    ]

    for s in test_points_conv:
        try:
            L_direct = L_M_direct(s, nmax=500)
            L_int = L_M_integral(s)
            error = fabs(L_direct - L_int)

            print(f"{str(s):<20} {str(L_direct):<25} {str(L_int):<25} {float(error):<15.6e}")
        except Exception as e:
            print(f"{str(s):<20} ERROR: {e}")

    print()
    print("=" * 80)
    print("TEST 2: Critical line Re(s) = 1/2")
    print("=" * 80)
    print()

    # Test on critical line
    test_points_crit = [
        mp.mpc(0.5, 5),
        mp.mpc(0.5, 10),
        mp.mpc(0.5, 14.135),
        mp.mpc(0.5, 20),
    ]

    print(f"{'s':<20} {'L_M(s)':<30} {'|L_M(s)|':<15}")
    print("-" * 65)

    results_crit = []
    for s in test_points_crit:
        try:
            L_s = L_M_integral(s)
            results_crit.append((s, L_s))
            print(f"{str(s):<20} {str(L_s):<30} {float(fabs(L_s)):<15.6f}")
        except Exception as e:
            print(f"{str(s):<20} ERROR: {e}")
            results_crit.append((s, None))

    print()
    print("=" * 80)
    print("TEST 3: Schwarz Symmetry on Critical Line")
    print("=" * 80)
    print()
    print("Testing: L_M(1/2 - it) ?= conj(L_M(1/2 + it))")
    print()
    print(f"{'t':<10} {'|L_M(1/2+it)|':<20} {'|L_M(1/2-it)|':<20} {'Schwarz error':<20}")
    print("-" * 70)

    for s_pos, L_pos in results_crit:
        if L_pos is None:
            continue

        t_val = float(s_pos.imag)
        s_neg = mp.mpc(0.5, -t_val)

        try:
            L_neg = L_M_integral(s_neg)

            # Schwarz: L(conj(s)) = conj(L(s))
            schwarz_error = fabs(L_neg - conj(L_pos))

            print(f"{t_val:<10.3f} {float(fabs(L_pos)):<20.10f} {float(fabs(L_neg)):<20.10f} {float(schwarz_error):<20.6e}")
        except Exception as e:
            print(f"{t_val:<10.3f} ERROR: {e}")

    print()
    print("=" * 80)
    print("TEST 4: Critical strip 0 < Re(s) < 1 (beyond closed form!)")
    print("=" * 80)
    print()

    test_points_strip = [
        mp.mpc(0.3, 10),
        mp.mpc(0.7, 10),
        mp.mpc(0.25, 20),
    ]

    print(f"{'s':<20} {'L_M(s)':<35} {'|L_M(s)|':<15}")
    print("-" * 70)

    for s in test_points_strip:
        try:
            L_s = L_M_integral(s)
            print(f"{str(s):<20} {str(L_s):<35} {float(fabs(L_s)):<15.6f}")
        except Exception as e:
            print(f"{str(s):<20} ERROR: {e}")

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print()

    print("If integral matches direct sum in Re(s) > 1:")
    print("  ✓ Formula is CORRECT")
    print()
    print("If Schwarz error < 10^-10:")
    print("  ✓ Symmetry CONFIRMED via independent method")
    print()
    print("If computable in critical strip:")
    print("  ✓ ANALYTIC CONTINUATION achieved!")
    print("  ✓ No dependence on C(s) series")
    print("  ✓ Self-reference loop BROKEN")
    print()

if __name__ == "__main__":
    main()
