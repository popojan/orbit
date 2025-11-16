#!/usr/bin/env python3
"""
Test: Is θ(t) = arg(ζ(s)) or arg(L_M(s))?

Since f(s) is pure phase, maybe:
  f(s) = ζ(s)^{iα} / ζ(1-s)^{iα}
  f(s) = L_M(s)^{iβ} / L_M(1-s)^{iβ}

or similar.

Test by comparing θ(t) with arg of various functions.
"""

from mpmath import mp, zeta, gamma, pi, arg, conj, fabs
import math

mp.dps = 50

def partial_zeta(s, n):
    """H_n(s) = Σ_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed_form(s, jmax=200):
    """L_M(s) using closed form"""
    zeta_s = zeta(s)
    correction = mp.mpc(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = partial_zeta(s, j - 1)
        correction += H_j_minus_1 / mp.power(j, s)
    return zeta_s * (zeta_s - 1) - correction

def gamma_classical(s):
    """γ(s) = π^(-s/2) Γ(s/2)"""
    return mp.power(pi, -s/2) * gamma(s/2)

def compute_phase(t):
    """Compute arg(f(s)/f(1-s)) at s = 1/2 + it"""
    s = mp.mpc(0.5, t)
    L_s = L_M_closed_form(s, jmax=200)
    L_1ms = conj(L_s)
    g_s = gamma_classical(s)
    g_1ms = gamma_classical(1 - s)
    f_ratio = (L_1ms / L_s) / (g_1ms / g_s)
    return float(arg(f_ratio))

def main():
    print("=" * 80)
    print("Testing: θ(t) = arg(ζ(s)) or arg(L_M(s))?")
    print("=" * 80)
    print()
    print("Strategy: Compare θ(t) with arguments of various functions")
    print()
    print("=" * 80)

    # Test points
    t_values = [5, 10, 14.135, 20, 25, 30]

    print()
    print(f"{'t':<10} {'θ(t)':<15} {'arg(ζ)':<15} {'arg(L_M)':<15} {'arg(Γ)':<15}")
    print("-" * 70)

    data = []

    for t in t_values:
        s = mp.mpc(0.5, t)

        # Compute θ
        theta = compute_phase(t)

        # Compute arguments
        zeta_s = zeta(s)
        L_s = L_M_closed_form(s, jmax=200)
        gamma_s = gamma(s/2)

        arg_zeta = float(arg(zeta_s))
        arg_L = float(arg(L_s))
        arg_gamma = float(arg(gamma_s))

        print(f"{t:<10.3f} {theta:<15.6f} {arg_zeta:<15.6f} {arg_L:<15.6f} {arg_gamma:<15.6f}")

        data.append({
            't': t,
            'theta': theta,
            'arg_zeta': arg_zeta,
            'arg_L': arg_L,
            'arg_gamma': arg_gamma
        })

    print()
    print("=" * 80)
    print("Testing linear combinations")
    print("=" * 80)
    print()

    # Test if θ = α·arg(ζ) + β·arg(L) + ...
    print(f"{'t':<10} {'θ':<12} {'2·arg(ζ)':<12} {'θ - 2·arg(ζ)':<15} {'Match?':<10}")
    print("-" * 60)

    matches = []

    for d in data:
        t = d['t']
        theta = d['theta']
        arg_zeta = d['arg_zeta']

        # Try θ = 2·arg(ζ)
        pred_2zeta = 2 * arg_zeta
        diff = theta - pred_2zeta

        match = "✓" if abs(diff) < 0.5 else "✗"

        print(f"{t:<10.3f} {theta:<12.6f} {pred_2zeta:<12.6f} {diff:<15.6f} {match:<10}")

        if abs(diff) < 0.5:
            matches.append(t)

    print()

    if len(matches) >= len(data) // 2:
        print(f"✓ Good match for θ = 2·arg(ζ(s)) at {len(matches)}/{len(data)} points!")
    else:
        print("✗ Not a simple 2·arg(ζ) relationship")

    print()
    print("=" * 80)
    print("Testing θ = α·arg(ζ(s)) for various α")
    print("=" * 80)
    print()

    # Try different values of α
    alphas = [0.5, 1, 1.5, 2, 2.5, 3, -1, -2]

    print(f"{'α':<10} {'Mean error':<15} {'Std error':<15} {'Good fit?':<10}")
    print("-" * 50)

    best_alpha = None
    best_error = float('inf')

    for alpha in alphas:
        errors = []
        for d in data:
            pred = alpha * d['arg_zeta']
            error = abs(d['theta'] - pred)
            errors.append(error)

        mean_err = sum(errors) / len(errors)
        std_err = math.sqrt(sum((e - mean_err)**2 for e in errors) / len(errors))

        good = "✓" if mean_err < 1.0 else "✗"

        print(f"{alpha:<10.2f} {mean_err:<15.6f} {std_err:<15.6f} {good:<10}")

        if mean_err < best_error:
            best_error = mean_err
            best_alpha = alpha

    print()

    if best_error < 1.0:
        print(f"✓ Best fit: θ(t) ≈ {best_alpha:.2f}·arg(ζ(1/2+it))")
        print(f"  Mean error: {best_error:.6f} rad")
    else:
        print("✗ No simple α·arg(ζ) relationship found")

    print()
    print("=" * 80)
    print("Testing θ = arg(ζ^α)")
    print("=" * 80)
    print()
    print("Note: arg(ζ^α) = α·arg(ζ) for real α")
    print("But we can test complex α!")
    print()

    # Test θ = arg(ζ(s)^{iβ})
    # arg(ζ^{iβ}) = β·log|ζ| is REAL (imaginary exponent)

    print(f"{'t':<10} {'θ':<12} {'log|ζ|':<12} {'θ/log|ζ|':<15}")
    print("-" * 50)

    ratios = []
    for d in data:
        t = d['t']
        theta = d['theta']

        s = mp.mpc(0.5, t)
        zeta_s = zeta(s)
        log_abs_zeta = float(mp.log(fabs(zeta_s)))

        ratio = theta / log_abs_zeta if abs(log_abs_zeta) > 0.01 else 0

        print(f"{t:<10.3f} {theta:<12.6f} {log_abs_zeta:<12.6f} {ratio:<15.6f}")

        if abs(log_abs_zeta) > 0.01:
            ratios.append(ratio)

    if ratios:
        mean_ratio = sum(ratios) / len(ratios)
        std_ratio = math.sqrt(sum((r - mean_ratio)**2 for r in ratios) / len(ratios))

        print()
        print(f"Mean(θ/log|ζ|) = {mean_ratio:.6f}")
        print(f"StdDev          = {std_ratio:.6f}")

        if abs(std_ratio/mean_ratio) < 0.3:
            print(f"✓ Possible: f(s) = ζ(s)^{{i·{mean_ratio:.6f}}}")

    print()
    print("=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print()

    if best_alpha and best_error < 1.0:
        print(f"Best candidate: θ(t) = {best_alpha:.2f}·arg(ζ(1/2+it))")
        print()
        print("This suggests:")
        print(f"  f(s) = [ζ(s)/ζ(1-s)]^{{i·{best_alpha/2:.2f}}}")
    else:
        print("No simple relationship found with arg(ζ)")
        print("May need combination of ζ, L_M, Γ arguments")

    print()

if __name__ == "__main__":
    main()
