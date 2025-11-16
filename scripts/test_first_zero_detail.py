#!/usr/bin/env python3
"""
Detailed analysis near first Riemann zero

First zero: t₁ ≈ 14.134725...
{t₁} ≈ 0.134725

Hypothesis: Period of θ oscillation near t₁ equals {t₁}?

Test with fine grid around t₁.
"""

from mpmath import mp, zeta, gamma, pi, arg, conj
import math

mp.dps = 50

FIRST_ZERO = "14.134725141734693790457251983562470270784257115699243175685567460149"

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

def unwrap_phases(phases):
    """Unwrap phase jumps"""
    unwrapped = [phases[0]]
    for i in range(1, len(phases)):
        diff = phases[i] - phases[i-1]
        if diff > math.pi:
            unwrapped.append(phases[i] - 2*math.pi)
        elif diff < -math.pi:
            unwrapped.append(phases[i] + 2*math.pi)
        else:
            unwrapped.append(phases[i])

    # Make cumulative
    for i in range(1, len(unwrapped)):
        while unwrapped[i] - unwrapped[i-1] > math.pi:
            unwrapped[i] -= 2*math.pi
        while unwrapped[i] - unwrapped[i-1] < -math.pi:
            unwrapped[i] += 2*math.pi

    return unwrapped

def main():
    print("=" * 80)
    print("Detailed Analysis Near First Riemann Zero")
    print("=" * 80)
    print()

    t1 = float(mp.mpf(FIRST_ZERO))
    t1_frac = t1 - math.floor(t1)

    print(f"First Riemann zero: t₁ = {t1:.10f}")
    print(f"Floor: {math.floor(t1)}")
    print(f"Fractional part: {{t₁}} = {t1_frac:.10f}")
    print()
    print("=" * 80)

    # Sample around the zero with fine resolution
    t_min = 13.5
    t_max = 15.0
    step = 0.05  # Fine grid

    t_values = []
    t_current = t_min
    while t_current <= t_max:
        t_values.append(t_current)
        t_current += step

    print()
    print(f"Computing θ(t) for t ∈ [{t_min}, {t_max}] with step {step}")
    print(f"Total points: {len(t_values)}")
    print()

    phases_raw = []
    for t in t_values:
        phase = compute_phase(t)
        phases_raw.append(phase)

    phases_unwrapped = unwrap_phases(phases_raw)

    # Find extrema
    extrema = []
    for i in range(1, len(t_values) - 1):
        if phases_unwrapped[i] > phases_unwrapped[i-1] and phases_unwrapped[i] > phases_unwrapped[i+1]:
            extrema.append(('max', t_values[i], phases_unwrapped[i]))
        elif phases_unwrapped[i] < phases_unwrapped[i-1] and phases_unwrapped[i] < phases_unwrapped[i+1]:
            extrema.append(('min', t_values[i], phases_unwrapped[i]))

    print("Extrema found:")
    print(f"{'Type':<8} {'t':<12} {'θ(t)':<15} {'Distance to t₁':<20} {'Period':<15}")
    print("-" * 70)

    for i, (typ, t, theta) in enumerate(extrema):
        dist_to_zero = abs(t - t1)

        if i > 0:
            period = t - extrema[i-1][1]
            period_str = f"{period:.6f}"
        else:
            period_str = "---"

        marker = " ← NEAR ZERO" if dist_to_zero < 0.5 else ""

        print(f"{typ:<8} {t:<12.6f} {theta:<15.6f} {dist_to_zero:<20.6f} {period_str:<15}{marker}")

    print()
    print("=" * 80)
    print("Period Analysis Around t₁")
    print("=" * 80)
    print()

    # Find extrema closest to t1
    extrema_near_zero = [(typ, t, theta) for typ, t, theta in extrema if abs(t - t1) < 1.0]

    if len(extrema_near_zero) >= 2:
        print(f"Extrema within ±1.0 of t₁ = {t1:.6f}:")
        print()

        for i, (typ, t, theta) in enumerate(extrema_near_zero):
            print(f"  {i+1}. {typ:3s} at t = {t:.6f}, θ = {theta:.6f}")
            if i > 0:
                prev_t = extrema_near_zero[i-1][1]
                period = t - prev_t
                print(f"     Period from previous: {period:.6f}")
                print(f"     Compared to {{t₁}}: {t1_frac:.6f}")
                print(f"     Difference: {abs(period - t1_frac):.6f}")

        print()

    # Check if any period matches {t1}
    periods_near_zero = []
    for i in range(1, len(extrema_near_zero)):
        period = extrema_near_zero[i][1] - extrema_near_zero[i-1][1]
        periods_near_zero.append(period)

    if periods_near_zero:
        print("Periods near first zero:")
        for i, p in enumerate(periods_near_zero):
            error = abs(p - t1_frac)
            rel_error = 100 * error / t1_frac if t1_frac > 0 else 0
            match = "✓ MATCH!" if rel_error < 5 else ""
            print(f"  Period {i+1}: {p:.6f}  (error: {error:.6f}, {rel_error:.2f}%)  {match}")

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print()

    if periods_near_zero:
        best_match = min(periods_near_zero, key=lambda p: abs(p - t1_frac))
        error = abs(best_match - t1_frac)
        rel_error = 100 * error / t1_frac

        if rel_error < 5:
            print(f"🎉 CONFIRMED: Period near first zero ≈ {{t₁}}")
            print(f"   Best match: {best_match:.6f}")
            print(f"   {{t₁}} =     {t1_frac:.6f}")
            print(f"   Error:      {error:.6f} ({rel_error:.2f}%)")
            print()
            print("This suggests the first Riemann zero has SPECIAL behavior!")
        else:
            print(f"Period ~{best_match:.6f} does not match {{t₁}} = {t1_frac:.6f}")
            print(f"Relative error: {rel_error:.2f}%")
    else:
        print("Not enough extrema found near first zero to determine period.")

    print()

if __name__ == "__main__":
    main()
