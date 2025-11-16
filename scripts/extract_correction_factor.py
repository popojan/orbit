#!/usr/bin/env python3
"""
Reverse Engineering of γ(s) Correction Factor

Strategy: Extract f(s) where γ(s) = π^(-s/2) Γ(s/2) · f(s)

From functional equation:
  γ(s)/γ(1-s) = L_M(1-s)/L_M(s)

So:
  f(s)/f(1-s) = [L_M(1-s)/L_M(s)] / [γ_classical(1-s)/γ_classical(s)]

On critical line Re(s) = 1/2:
  - L_M(1-s) = conj(L_M(s)) (Schwarz symmetry)
  - So we can compute f(s)/f(1-s) from data!

Then analyze behavior to guess form of f(s).
"""

from mpmath import mp, zeta, gamma, pi, exp, log, sqrt
from mpmath import re, im, arg, fabs, conj

mp.dps = 50

def partial_zeta(s, n):
    """H_n(s) = Σ_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed_form(s, jmax=200):
    """
    L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^jmax H_{j-1}(s)/j^s

    Note: Only converges for Re(s) > 1
    For Re(s) = 1/2, we use fixed jmax (oscillates, but value exists)
    """
    zeta_s = zeta(s)
    correction = mp.mpc(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = partial_zeta(s, j - 1)
        correction += H_j_minus_1 / mp.power(j, s)
    return zeta_s * (zeta_s - 1) - correction

def gamma_classical(s):
    """Classical gamma factor: γ(s) = π^(-s/2) Γ(s/2)"""
    return mp.power(pi, -s/2) * gamma(s/2)

def extract_f_ratio(s, jmax=200):
    """
    Extract f(s)/f(1-s) from data.

    On critical line Re(s) = 1/2:
      f(s)/f(1-s) = [L_M(1-s)/L_M(s)] / [γ_classical(1-s)/γ_classical(s)]
                  = [conj(L_M(s))/L_M(s)] / [γ_classical(1-s)/γ_classical(s)]
    """
    # Compute L_M(s)
    L_s = L_M_closed_form(s, jmax)

    # On critical line: L_M(1-s) = conj(L_M(s))
    L_1ms = conj(L_s)

    # Classical gamma ratio
    g_s = gamma_classical(s)
    g_1ms = gamma_classical(1 - s)

    # Extract f ratio
    ratio_L = L_1ms / L_s
    ratio_gamma_classical = g_1ms / g_s

    f_ratio = ratio_L / ratio_gamma_classical

    return {
        'f_ratio': f_ratio,
        'f_ratio_mag': fabs(f_ratio),
        'f_ratio_arg': arg(f_ratio),
        'L_s': L_s,
        'L_1ms': L_1ms,
    }

def test_candidate(s, candidate_name, candidate_func, jmax=200):
    """
    Test if candidate f(s) matches extracted data.

    candidate_func should compute f(s)/f(1-s)
    """
    # Extract actual f ratio from data
    data = extract_f_ratio(s, jmax)
    actual_ratio = data['f_ratio']

    # Compute candidate's prediction
    predicted_ratio = candidate_func(s)

    # Compare
    error = fabs(actual_ratio - predicted_ratio)
    rel_error = error / fabs(actual_ratio) if fabs(actual_ratio) > 0 else mp.inf

    return {
        'candidate': candidate_name,
        'actual': actual_ratio,
        'predicted': predicted_ratio,
        'error': error,
        'rel_error': rel_error,
        'match': rel_error < 0.01  # 1% tolerance
    }

def main():
    print("=" * 80)
    print("Reverse Engineering γ(s) Correction Factor")
    print("=" * 80)
    print()
    print("Goal: Find f(s) where γ(s) = π^(-s/2) Γ(s/2) · f(s)")
    print()
    print("Strategy:")
    print("  1. Extract f(s)/f(1-s) from numerical data on critical line")
    print("  2. Analyze how it depends on Im(s)")
    print("  3. Guess functional form based on patterns")
    print("  4. Test candidates")
    print()
    print("=" * 80)

    # Test points on critical line
    t_values = [5.0, 10.0, 14.135, 20.0, 25.0, 30.0]

    print()
    print("STEP 1: Extract f(s)/f(1-s) from data")
    print("=" * 80)
    print()
    print(f"{'t':<10} {'|f(s)/f(1-s)|':<20} {'arg(f/f)':<20} {'log|f/f|':<20}")
    print("-" * 70)

    data_points = []

    for t in t_values:
        s = mp.mpc(0.5, t)
        data = extract_f_ratio(s, jmax=200)

        mag = float(data['f_ratio_mag'])
        phase = float(data['f_ratio_arg'])
        log_mag = float(log(data['f_ratio_mag']))

        print(f"{t:<10.3f} {mag:<20.10f} {phase:<20.10f} {log_mag:<20.10f}")

        data_points.append({
            't': t,
            'mag': mag,
            'phase': phase,
            'log_mag': log_mag,
            'data': data
        })

    print()
    print("=" * 80)
    print("STEP 2: Analyze patterns")
    print("=" * 80)
    print()

    # Check if log|f/f| scales with t
    print("Testing if log|f(s)/f(1-s)| ∝ t:")
    print()
    print(f"{'t':<10} {'log|f/f|':<20} {'log|f/f|/t':<20}")
    print("-" * 50)

    for d in data_points:
        t = d['t']
        log_mag = d['log_mag']
        ratio = log_mag / t if t > 0 else 0
        print(f"{t:<10.3f} {log_mag:<20.10f} {ratio:<20.10f}")

    print()

    # Check if phase ∝ log(t)
    print("Testing if arg(f(s)/f(1-s)) ∝ log(t):")
    print()
    print(f"{'t':<10} {'arg(f/f)':<20} {'arg/(log t)':<20}")
    print("-" * 50)

    import math
    for d in data_points:
        t = d['t']
        phase = d['phase']
        ratio = phase / math.log(t) if t > 1 else 0
        print(f"{t:<10.3f} {phase:<20.10f} {ratio:<20.10f}")

    print()
    print("=" * 80)
    print("STEP 3: Candidate Testing")
    print("=" * 80)
    print()

    # Define candidates
    candidates = [
        ("ζ(s)", lambda s: zeta(s) / zeta(1-s)),
        ("ζ(s)²", lambda s: (zeta(s) / zeta(1-s))**2),
        ("ζ(2s)", lambda s: zeta(2*s) / zeta(2*(1-s))),
        ("ζ(s)/ζ(2s)", lambda s: (zeta(s) / zeta(1-s)) / (zeta(2*s) / zeta(2*(1-s)))),
        ("1 (trivial)", lambda s: mp.mpc(1, 0)),
    ]

    # Test at one point
    s_test = mp.mpc(0.5, 10.0)
    print(f"Testing candidates at s = {s_test}:")
    print()
    print(f"{'Candidate':<20} {'Error':<15} {'Rel Error %':<15} {'Match?':<10}")
    print("-" * 60)

    for name, func in candidates:
        result = test_candidate(s_test, name, func, jmax=200)
        error_str = f"{float(result['error']):.3e}"
        rel_str = f"{float(result['rel_error']) * 100:.2f}"
        match_str = "✓" if result['match'] else "✗"

        print(f"{name:<20} {error_str:<15} {rel_str:<15} {match_str:<10}")

    print()
    print("=" * 80)
    print("OBSERVATIONS")
    print("=" * 80)
    print()
    print("Look for patterns in the extracted data:")
    print("  - Does |f(s)/f(1-s)| grow/decay with |Im(s)|?")
    print("  - Is the growth exponential (∝ e^{αt}) or power (∝ t^β)?")
    print("  - Does arg(f/f) scale linearly with log(t)?")
    print()
    print("Common forms to try next:")
    print("  - f(s) = ζ(as+b)^α")
    print("  - f(s) = Γ(as+b) / Γ(cs+d)")
    print("  - f(s) = exp(polynomial in s)")
    print()
    print("Next: Refine candidates based on observed scaling!")
    print()

if __name__ == "__main__":
    main()
