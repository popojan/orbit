#!/usr/bin/env python3
"""
Empirical search for functional equation factor γ(s)

Strategy:
If γ(s) L_M(s) = γ(1-s) L_M(1-s), then:
    γ(s)/γ(1-s) = L_M(1-s)/L_M(s)

We compute this ratio numerically and look for patterns.
"""

from mpmath import mp, zeta, gamma, pi, sin, cos, exp, log, sqrt
from mpmath import re, im, arg, fabs

# Set precision
mp.dps = 50  # 50 decimal places

def M(n):
    """Divisor count function M(n) = floor((tau(n)-1)/2)"""
    # tau(n) = number of divisors
    # For now, compute by factorization
    tau = 0
    for d in range(1, int(n**0.5) + 2):
        if d * d > n:
            break
        if n % d == 0:
            tau += 1 if d * d == n else 2
    return (tau - 1) // 2

def L_M_direct(s, nmax=200):
    """Compute L_M(s) directly from definition"""
    total = mp.mpf(0)
    for n in range(1, nmax + 1):
        total += mp.mpf(M(n)) / mp.power(n, s)
    return total

def partial_zeta(s, n):
    """Compute H_n(s) = sum_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed_form(s, jmax=300):
    """
    Compute L_M(s) using closed form:
    L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s
    """
    zeta_s = zeta(s)

    # Correction sum
    correction = mp.mpf(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = partial_zeta(s, j - 1)
        correction += H_j_minus_1 / mp.power(j, s)

    return zeta_s * (zeta_s - 1) - correction

def compute_ratio(s):
    """
    Compute R(s) = L_M(1-s) / L_M(s)
    """
    L_s = L_M_closed_form(s)
    L_1ms = L_M_closed_form(1 - s)

    if fabs(L_s) < 1e-40:
        return None  # Avoid division by zero

    return L_1ms / L_s

def test_gamma_candidates(s, ratio):
    """
    Test various candidate forms for γ(s)/γ(1-s) against the computed ratio.

    Returns: list of (name, candidate_value, error) tuples
    """
    results = []

    # Candidate 1: Classical (already falsified, but check)
    # γ(s) = π^{-s/2} Γ(s/2)
    # γ(s)/γ(1-s) = [π^{-s/2} Γ(s/2)] / [π^{-(1-s)/2} Γ((1-s)/2)]
    #              = π^{(1-2s)/2} Γ(s/2) / Γ((1-s)/2)
    classical = mp.power(pi, (1 - 2*s)/2) * gamma(s/2) / gamma((1-s)/2)
    results.append(("Classical γ", classical, fabs(ratio - classical)))

    # Candidate 2: Double the classical
    # γ(s) = π^{-s} Γ(s)
    double_classical = mp.power(pi, (1 - 2*s)) * gamma(s) / gamma(1-s)
    results.append(("Double classical", double_classical, fabs(ratio - double_classical)))

    # Candidate 3: Involves ζ(s)
    # γ(s)/γ(1-s) = ζ(1-s)/ζ(s)
    try:
        zeta_ratio = zeta(1-s) / zeta(s)
        results.append(("Zeta ratio", zeta_ratio, fabs(ratio - zeta_ratio)))
    except:
        pass

    # Candidate 4: Product form
    # γ(s)/γ(1-s) = π^{(1-2s)/2} Γ(s/2)/Γ((1-s)/2) · ζ(1-s)/ζ(s)
    try:
        product = classical * zeta_ratio
        results.append(("Classical × ζ", product, fabs(ratio - product)))
    except:
        pass

    # Candidate 5: With sin factor
    # χ(s) = 2^s π^{s-1} sin(πs/2) Γ(1-s)
    chi_s = mp.power(2, s) * mp.power(pi, s-1) * sin(pi*s/2) * gamma(1-s)
    chi_1ms = mp.power(2, 1-s) * mp.power(pi, -s) * sin(pi*(1-s)/2) * gamma(s)
    if fabs(chi_1ms) > 1e-40:
        chi_ratio = chi_s / chi_1ms
        results.append(("χ(s)/χ(1-s)", chi_ratio, fabs(ratio - chi_ratio)))

    # Candidate 6: Modified with L_M at endpoints
    # This is circular, but might reveal structure
    # Skip for now

    return results

def main():
    print("=" * 80)
    print("Empirical Search for Functional Equation Factor γ(s)")
    print("=" * 80)
    print()

    # Test points: various s values
    test_points = [
        2.0 + 0j,
        2.5 + 0j,
        3.0 + 0j,
        1.5 + 5j,
        0.6 + 10j,
        0.7 + 14.135j,  # Near first Riemann zero
        0.5 + 20j,      # Critical line
        0.3 + 15j,
    ]

    print(f"{'s':<20} {'L_M(s)':<25} {'L_M(1-s)':<25} {'Ratio magnitude':<20}")
    print("-" * 90)

    for s in test_points:
        s = mp.mpc(s)

        try:
            L_s = L_M_closed_form(s, jmax=200)
            L_1ms = L_M_closed_form(1 - s, jmax=200)

            if fabs(L_s) < 1e-40:
                print(f"{str(s):<20} {'(zero)':<25} {'-':<25} {'-':<20}")
                continue

            ratio = L_1ms / L_s
            ratio_mag = fabs(ratio)

            # Convert to string for printing
            s_str = str(s)[:18]
            L_s_str = f"{float(fabs(L_s)):.10e}"
            L_1ms_str = f"{float(fabs(L_1ms)):.10e}"
            ratio_str = f"{float(ratio_mag):.10e}"

            print(f"{s_str:<20} {L_s_str:<25} {L_1ms_str:<25} {ratio_str:<20}")

        except Exception as e:
            print(f"{s!s:<20} ERROR: {e}")

    print("\n" + "=" * 80)
    print("Testing Candidate Forms for γ(s)/γ(1-s)")
    print("=" * 80)
    print()

    # Pick a few representative points
    analysis_points = [
        1.5 + 5j,
        0.7 + 14.135j,
        0.5 + 20j,
    ]

    for s in analysis_points:
        s = mp.mpc(s)
        print(f"\nAt s = {str(s)[:30]}:")
        print("-" * 60)

        try:
            ratio = compute_ratio(s)
            if ratio is None:
                print("  L_M(s) too small, skipping")
                continue

            print(f"  Computed ratio R(s) = L_M(1-s)/L_M(s)")
            print(f"    |R(s)| = {float(fabs(ratio)):.10e}")
            print(f"    arg(R(s)) = {float(arg(ratio)):.10f}")
            print()

            candidates = test_gamma_candidates(s, ratio)

            print(f"  {'Candidate':<25} {'Error':<20} {'Match?':<10}")
            print(f"  {'-'*55}")
            for name, value, error in candidates:
                match = "✓" if error < 1e-6 else "✗"
                error_float = float(error) if error < 1e100 else float('inf')
                print(f"  {name:<25} {error_float:<20.10e} {match:<10}")

        except Exception as e:
            print(f"  ERROR: {e}")

    print("\n" + "=" * 80)
    print("Analysis Complete")
    print("=" * 80)

if __name__ == "__main__":
    main()
