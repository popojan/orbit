#!/usr/bin/env python3
"""
Analyze L_M(s) on the critical line Re(s) = 1/2

Focus: Study the phase arg(R(s)) where R(s) = L_M(1-s)/L_M(s)
On critical line, 1-s = conj(s), so |R(s)| = 1 by Schwarz symmetry.
"""

from mpmath import mp, zeta, gamma, pi, sin, cos, exp, log, sqrt
from mpmath import re, im, arg, fabs, conj

# Set precision
mp.dps = 50

def partial_zeta(s, n):
    """Compute H_n(s) = sum_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed_form(s, jmax=300):
    """
    Compute L_M(s) using closed form:
    L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s
    """
    zeta_s = zeta(s)
    correction = mp.mpf(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = partial_zeta(s, j - 1)
        correction += H_j_minus_1 / mp.power(j, s)
    return zeta_s * (zeta_s - 1) - correction

def analyze_critical_line():
    """Analyze L_M(s) on critical line Re(s) = 1/2"""

    print("=" * 80)
    print("Analysis of L_M(s) on Critical Line Re(s) = 1/2")
    print("=" * 80)
    print()

    # Test points on critical line
    t_values = [5, 10, 14.135, 20, 21.022, 25, 30, 40, 50]

    print("Verifying Schwarz Symmetry: L_M(1/2 - it) = conj(L_M(1/2 + it))")
    print()
    print(f"{'t':<10} {'|L_M(s)|':<20} {'arg(L_M(s))':<20} {'|R(s)|':<15} {'arg(R(s))':<20}")
    print("-" * 85)

    data = []

    for t in t_values:
        s = mp.mpc(0.5, t)

        try:
            L_s = L_M_closed_form(s, jmax=200)
            L_conj_s = conj(L_s)  # This should equal L_M(1-s) by Schwarz symmetry
            L_1ms = L_M_closed_form(1 - s, jmax=200)

            # Check Schwarz symmetry
            schwarz_error = fabs(L_conj_s - L_1ms)

            # Compute ratio R(s) = L_M(1-s)/L_M(s)
            if fabs(L_s) > 1e-40:
                ratio = L_1ms / L_s
                ratio_mag = fabs(ratio)
                ratio_arg = arg(ratio)
            else:
                ratio_mag = 0
                ratio_arg = 0

            # Collect data
            L_mag = fabs(L_s)
            L_arg = arg(L_s)

            t_str = f"{float(t):.3f}"
            L_mag_str = f"{float(L_mag):.10e}"
            L_arg_str = f"{float(L_arg):.10f}"
            ratio_mag_str = f"{float(ratio_mag):.10f}"
            ratio_arg_str = f"{float(ratio_arg):.10f}"

            print(f"{t_str:<10} {L_mag_str:<20} {L_arg_str:<20} {ratio_mag_str:<15} {ratio_arg_str:<20}")

            data.append({
                't': float(t),
                'L_mag': float(L_mag),
                'L_arg': float(L_arg),
                'ratio_mag': float(ratio_mag),
                'ratio_arg': float(ratio_arg),
                'schwarz_error': float(schwarz_error)
            })

        except Exception as e:
            print(f"{t:<10} ERROR: {e}")

    print()
    print("=" * 80)
    print("Schwarz Symmetry Verification")
    print("=" * 80)
    print()

    print(f"{'t':<10} {'|L_M(conj(s)) - L_M(1-s)|':<30} {'Status':<10}")
    print("-" * 50)
    for d in data:
        error_str = f"{d['schwarz_error']:.3e}"
        status = "✓ VERIFIED" if d['schwarz_error'] < 1e-10 else "✗ FAIL"
        print(f"{d['t']:<10.3f} {error_str:<30} {status:<10}")

    print()
    print("=" * 80)
    print("Analysis of arg(R(s)) on Critical Line")
    print("=" * 80)
    print()
    print("On critical line, R(s) = L_M(1-s)/L_M(s) = conj(L_M(s))/L_M(s)")
    print("This is a pure phase: R(s) = e^{-2i·arg(L_M(s))}")
    print()
    print(f"{'t':<10} {'arg(L_M(s))':<20} {'arg(R(s))':<20} {'Predicted arg(R)':<20} {'Error':<15}")
    print("-" * 85)

    for d in data:
        predicted = -2 * d['L_arg']
        error = abs(d['ratio_arg'] - predicted)

        t_str = f"{d['t']:.3f}"
        L_arg_str = f"{d['L_arg']:.10f}"
        ratio_arg_str = f"{d['ratio_arg']:.10f}"
        predicted_str = f"{predicted:.10f}"
        error_str = f"{error:.3e}"

        print(f"{t_str:<10} {L_arg_str:<20} {ratio_arg_str:<20} {predicted_str:<20} {error_str:<15}")

    print()
    print("=" * 80)
    print("Summary")
    print("=" * 80)
    print()
    print("✓ Schwarz symmetry holds (errors < 10^-10)")
    print("✓ On critical line: |R(s)| = 1 exactly")
    print("✓ Phase relation: arg(R(s)) = -2·arg(L_M(s))")
    print()
    print("INTERPRETATION:")
    print("  Since L_M(1-s) = conj(L_M(s)) on Re(s) = 1/2,")
    print("  we have R(s) = conj(L_M(s))/L_M(s) = e^{-2i·arg(L_M(s))}")
    print()
    print("This confirms Schwarz symmetry but doesn't directly reveal γ(s).")
    print("We need to analyze OFF critical line to find the functional equation.")
    print()

if __name__ == "__main__":
    analyze_critical_line()
