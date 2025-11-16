#!/usr/bin/env python3
"""
Test hypothesis: γ(s) = π^{-s/2} Γ(s/2) · [ζ(s)]^α

for various powers α.

If this works, then:
  R(s) = L_M(1-s)/L_M(s) = [classical ratio] · [ζ(s)/ζ(1-s)]^α
"""

from mpmath import mp, zeta, gamma, pi, sin, cos, exp, log, sqrt
from mpmath import re, im, arg, fabs, conj

# Set precision
mp.dps = 40

def partial_zeta(s, n):
    """Compute H_n(s) = sum_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed_form(s, jmax=200):
    """Compute L_M(s) using closed form"""
    zeta_s = zeta(s)
    correction = mp.mpf(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = partial_zeta(s, j - 1)
        correction += H_j_minus_1 / mp.power(j, s)
    return zeta_s * (zeta_s - 1) - correction

def classical_gamma_ratio(s):
    """Classical γ(s)/γ(1-s) for ζ(s)"""
    return mp.power(pi, (1 - 2*s)/2) * gamma(s/2) / gamma((1-s)/2)

def test_zeta_power(s, alpha):
    """
    Test if R(s) = [classical] · [ζ(s)/ζ(1-s)]^α

    Returns: error in magnitude and phase
    """
    L_s = L_M_closed_form(s, jmax=150)
    L_1ms = L_M_closed_form(1 - s, jmax=150)

    if fabs(L_s) < 1e-30:
        return None

    R_actual = L_1ms / L_s

    # Predicted R
    classical = classical_gamma_ratio(s)
    zeta_ratio = zeta(s) / zeta(1-s)

    R_predicted = classical * mp.power(zeta_ratio, alpha)

    # Compute error
    error_mag = fabs(fabs(R_actual) - fabs(R_predicted))
    error_phase = fabs(arg(R_actual) - arg(R_predicted))

    # Normalize phase error to [-π, π]
    while error_phase > pi:
        error_phase -= 2*pi
    error_phase = fabs(error_phase)

    return {
        'error_mag': float(error_mag),
        'error_phase': float(error_phase),
        'R_actual_mag': float(fabs(R_actual)),
        'R_predicted_mag': float(fabs(R_predicted)),
        'R_actual_phase': float(arg(R_actual)),
        'R_predicted_phase': float(arg(R_predicted))
    }

def main():
    print("=" * 80)
    print("Testing Hypothesis: γ(s) = π^{-s/2} Γ(s/2) · [ζ(s)]^α")
    print("=" * 80)
    print()

    # Test points
    test_points = [
        (0.3, 10),
        (0.3, 14.135),
        (0.3, 20),
        (0.7, 10),
        (0.7, 14.135),
        (0.7, 20),
    ]

    # Test various powers of zeta
    alpha_values = [-2.0, -1.5, -1.0, -0.5, 0.0, 0.5, 1.0, 1.5, 2.0]

    print("Testing different α values:\n")

    for alpha in alpha_values:
        print(f"\nα = {alpha:.1f}")
        print("-" * 80)
        print(f"{'s':<15} {'|R_act|':<15} {'|R_pred|':<15} {'Err_mag':<15} {'Err_phase':<15} {'Match?':<10}")
        print("-" * 80)

        total_error_mag = 0
        total_error_phase = 0
        count = 0

        for sigma, t in test_points:
            s = mp.mpc(sigma, t)

            try:
                result = test_zeta_power(s, alpha)
                if result is None:
                    continue

                s_str = f"{float(sigma):.1f}+{float(t):.1f}i"
                match = "✓" if result['error_mag'] < 0.01 and result['error_phase'] < 0.1 else "✗"

                print(f"{s_str:<15} {result['R_actual_mag']:<15.6f} {result['R_predicted_mag']:<15.6f} "
                      f"{result['error_mag']:<15.6e} {result['error_phase']:<15.6f} {match:<10}")

                total_error_mag += result['error_mag']
                total_error_phase += result['error_phase']
                count += 1

            except Exception as e:
                print(f"{sigma}+{t}i: ERROR: {e}")

        if count > 0:
            avg_err_mag = total_error_mag / count
            avg_err_phase = total_error_phase / count
            print(f"\nAverage errors: mag = {avg_err_mag:.6e}, phase = {avg_err_phase:.6f}")

            if avg_err_mag < 0.01 and avg_err_phase < 0.1:
                print(f"*** CANDIDATE FOUND: α = {alpha:.1f} ***")

    print()
    print("=" * 80)
    print("Summary")
    print("=" * 80)
    print()
    print("If a specific α value gives small errors across all test points,")
    print("then the functional equation factor is:")
    print("  γ(s) = π^{-s/2} Γ(s/2) · [ζ(s)]^α")
    print()

if __name__ == "__main__":
    main()
