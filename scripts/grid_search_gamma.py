#!/usr/bin/env python3
"""
Grid search for functional equation factor γ(s)

Compute R(s) = L_M(1-s)/L_M(s) on a grid of s values
and try to identify the pattern.

Focus on log(R(s)) to separate magnitude and phase.
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
    # γ(s) = π^{-s/2} Γ(s/2)
    # γ(s)/γ(1-s) = π^{(1-2s)/2} Γ(s/2) / Γ((1-s)/2)
    return mp.power(pi, (1 - 2*s)/2) * gamma(s/2) / gamma((1-s)/2)

def analyze_log_ratio(s):
    """
    Analyze log(R(s)) where R(s) = L_M(1-s)/L_M(s)

    Returns: log|R(s)|, arg(R(s)), and comparison with known functions
    """
    L_s = L_M_closed_form(s, jmax=150)
    L_1ms = L_M_closed_form(1 - s, jmax=150)

    if fabs(L_s) < 1e-30:
        return None

    ratio = L_1ms / L_s

    log_mag = log(fabs(ratio))
    phase = arg(ratio)

    # Compare with classical
    classical = classical_gamma_ratio(s)
    log_classical_mag = log(fabs(classical))
    classical_phase = arg(classical)

    # Compute the "correction" needed
    log_correction = log_mag - log_classical_mag
    phase_correction = phase - classical_phase

    return {
        'log_mag': float(log_mag),
        'phase': float(phase),
        'log_classical': float(log_classical_mag),
        'classical_phase': float(classical_phase),
        'log_correction': float(log_correction),
        'phase_correction': float(phase_correction)
    }

def main():
    print("=" * 80)
    print("Grid Search for γ(s) Pattern")
    print("=" * 80)
    print()
    print("Analyzing R(s) = L_M(1-s)/L_M(s) on a grid")
    print("Comparing with classical γ(s) = π^{-s/2} Γ(s/2)")
    print()

    # Grid of test points (sigma, t) where s = sigma + it
    # Focus on strip 0 < Re(s) < 1
    sigma_values = [0.3, 0.5, 0.7]
    t_values = [10, 14.135, 20, 25]

    print(f"{'s':<20} {'log|R(s)|':<15} {'arg(R)':<15} {'log|classical|':<15} {'Δlog':<15} {'Δphase':<15}")
    print("-" * 95)

    results = []

    for sigma in sigma_values:
        for t in t_values:
            s = mp.mpc(sigma, t)

            try:
                data = analyze_log_ratio(s)
                if data is None:
                    continue

                s_str = f"{float(sigma):.1f}+{float(t):.1f}i"
                print(f"{s_str:<20} {data['log_mag']:<15.6f} {data['phase']:<15.6f} "
                      f"{data['log_classical']:<15.6f} {data['log_correction']:<15.6f} {data['phase_correction']:<15.6f}")

                results.append({
                    'sigma': sigma,
                    't': t,
                    **data
                })

            except Exception as e:
                print(f"{sigma}+{t}i: ERROR: {e}")

    print()
    print("=" * 80)
    print("Analysis of Corrections")
    print("=" * 80)
    print()
    print("If FR exists with γ(s) = π^{-s/2} Γ(s/2) · f(s), then:")
    print("  R(s) = [γ(s)/γ(1-s)] · [f(s)/f(1-s)]")
    print("  log|R(s)| = log|classical| + log|f(s)/f(1-s)|")
    print()
    print("The 'Δlog' and 'Δphase' columns show the correction factor.")
    print()

    # Look for patterns in corrections
    if len(results) > 0:
        print("Pattern analysis:")
        print()

        # Check if corrections depend on sigma or t
        print(f"{'sigma':<10} {'t':<10} {'Δlog':<15} {'Δphase':<15}")
        print("-" * 50)
        for r in results:
            print(f"{r['sigma']:<10.1f} {r['t']:<10.1f} {r['log_correction']:<15.6f} {r['phase_correction']:<15.6f}")

        print()
        print("Looking for patterns:")

        # Group by sigma
        for sigma in sigma_values:
            sigma_results = [r for r in results if r['sigma'] == sigma]
            if len(sigma_results) > 1:
                avg_log_corr = sum(r['log_correction'] for r in sigma_results) / len(sigma_results)
                std_log_corr = (sum((r['log_correction'] - avg_log_corr)**2 for r in sigma_results) / len(sigma_results))**0.5
                print(f"  σ={sigma:.1f}: avg Δlog = {avg_log_corr:.6f} ± {std_log_corr:.6f}")

    print()
    print("=" * 80)
    print("Next Steps")
    print("=" * 80)
    print()
    print("1. The corrections Δlog and Δphase represent the 'mystery factor' f(s)")
    print("2. Need to find a function f(s) such that:")
    print("   - log|f(s)/f(1-s)| matches Δlog")
    print("   - arg(f(s)/f(1-s)) matches Δphase")
    print("3. Candidates: powers of ζ(s), products with ζ(s), etc.")
    print()

if __name__ == "__main__":
    main()
