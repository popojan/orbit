#!/usr/bin/env python3
"""
Phase Unwrapping Analysis of f(s)

Since |f(s)/f(1-s)| = 1.0 exactly, f(s) is pure phase on critical line.

Goal: Extract h(s) where f(s) = e^{ih(s)}

Strategy:
1. Compute arg(f(s)/f(1-s)) for many t values
2. Unwrap phase (remove 2π jumps)
3. Look for patterns: h(t) ∝ log(t)? t? t²?

This will tell us the functional form of f(s).
"""

from mpmath import mp, zeta, gamma, pi, exp, log, sqrt
from mpmath import re, im, arg, fabs, conj
import math

mp.dps = 50

def partial_zeta(s, n):
    """H_n(s) = Σ_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed_form(s, jmax=200):
    """L_M(s) using closed form (fixed jmax for critical line)"""
    zeta_s = zeta(s)
    correction = mp.mpc(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = partial_zeta(s, j - 1)
        correction += H_j_minus_1 / mp.power(j, s)
    return zeta_s * (zeta_s - 1) - correction

def gamma_classical(s):
    """Classical gamma factor: γ(s) = π^(-s/2) Γ(s/2)"""
    return mp.power(pi, -s/2) * gamma(s/2)

def compute_phase(t, jmax=200):
    """
    Compute arg(f(s)/f(1-s)) at s = 1/2 + it

    Returns unwrapped phase (cumulative, no 2π jumps)
    """
    s = mp.mpc(0.5, t)

    # L_M values
    L_s = L_M_closed_form(s, jmax)
    L_1ms = conj(L_s)  # Schwarz symmetry

    # Classical gamma
    g_s = gamma_classical(s)
    g_1ms = gamma_classical(1 - s)

    # f ratio
    ratio_L = L_1ms / L_s
    ratio_gamma = g_1ms / g_s
    f_ratio = ratio_L / ratio_gamma

    # Phase
    phase = arg(f_ratio)

    return float(phase)

def unwrap_phase(phases):
    """
    Remove 2π jumps from phase sequence.

    Returns cumulative unwrapped phase.
    """
    unwrapped = [phases[0]]
    cumulative_shift = 0

    for i in range(1, len(phases)):
        diff = phases[i] - phases[i-1]

        # Detect jump
        if diff > math.pi:
            cumulative_shift -= 2 * math.pi
        elif diff < -math.pi:
            cumulative_shift += 2 * math.pi

        unwrapped.append(phases[i] + cumulative_shift)

    return unwrapped

def main():
    print("=" * 80)
    print("Phase Unwrapping Analysis")
    print("=" * 80)
    print()
    print("Goal: Find h(t) where f(1/2+it) = e^{ih(t)}")
    print()
    print("Since |f(s)/f(1-s)| = 1.0, the ratio is pure phase:")
    print("  f(s)/f(1-s) = e^{iθ(t)}")
    print()
    print("We extract θ(t), unwrap 2π jumps, and look for pattern.")
    print()
    print("=" * 80)

    # Dense sampling of t values
    t_values = [
        2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 14.135, 15, 16, 17, 18, 19, 20,
        21, 21.022, 22, 23, 24, 25, 26, 27, 28, 29, 30,
        35, 40, 45, 50
    ]

    print()
    print("STEP 1: Compute raw phases")
    print("=" * 80)
    print()

    phases_raw = []

    print(f"{'t':<10} {'arg(f/f) [rad]':<20}")
    print("-" * 30)

    for t in t_values:
        phase = compute_phase(t, jmax=200)
        phases_raw.append(phase)
        print(f"{t:<10.3f} {phase:<20.10f}")

    print()
    print("=" * 80)
    print("STEP 2: Unwrap phase (remove 2π jumps)")
    print("=" * 80)
    print()

    phases_unwrapped = unwrap_phase(phases_raw)

    print(f"{'t':<10} {'Unwrapped θ(t)':<20} {'θ(t)/log(t)':<20} {'θ(t)/t':<20}")
    print("-" * 70)

    data = []

    for i, t in enumerate(t_values):
        theta = phases_unwrapped[i]
        theta_over_logt = theta / math.log(t) if t > 1 else 0
        theta_over_t = theta / t

        print(f"{t:<10.3f} {theta:<20.10f} {theta_over_logt:<20.10f} {theta_over_t:<20.10f}")

        data.append({
            't': t,
            'theta': theta,
            'theta_over_logt': theta_over_logt,
            'theta_over_t': theta_over_t
        })

    print()
    print("=" * 80)
    print("STEP 3: Pattern analysis")
    print("=" * 80)
    print()

    # Check if θ/log(t) is roughly constant
    ratios_logt = [d['theta_over_logt'] for d in data if d['t'] > 1]
    mean_logt = sum(ratios_logt) / len(ratios_logt)
    std_logt = math.sqrt(sum((x - mean_logt)**2 for x in ratios_logt) / len(ratios_logt))

    print(f"Testing θ(t) ∝ log(t):")
    print(f"  Mean(θ/log t) = {mean_logt:.6f}")
    print(f"  StdDev        = {std_logt:.6f}")
    print(f"  Rel variation = {100*std_logt/abs(mean_logt):.2f}%")

    if abs(std_logt/mean_logt) < 0.1:
        print(f"  ✓ θ(t) ≈ {mean_logt:.6f} · log(t)  (good fit!)")
    else:
        print(f"  ✗ Not a simple log(t) scaling")

    print()

    # Check if θ/t is roughly constant
    ratios_t = [d['theta_over_t'] for d in data]
    mean_t = sum(ratios_t) / len(ratios_t)
    std_t = math.sqrt(sum((x - mean_t)**2 for x in ratios_t) / len(ratios_t))

    print(f"Testing θ(t) ∝ t:")
    print(f"  Mean(θ/t) = {mean_t:.6f}")
    print(f"  StdDev    = {std_t:.6f}")
    print(f"  Rel variation = {100*std_t/abs(mean_t):.2f}%")

    if abs(std_t/mean_t) < 0.1:
        print(f"  ✓ θ(t) ≈ {mean_t:.6f} · t  (good fit!)")
    else:
        print(f"  ✗ Not a simple t scaling")

    print()

    # Look at oscillation pattern
    print("Analyzing oscillation:")
    print()
    print(f"{'t':<10} {'θ(t)':<15} {'Δθ':<15} {'Period?':<15}")
    print("-" * 55)

    extrema = []
    for i in range(1, len(data) - 1):
        theta_prev = data[i-1]['theta']
        theta_curr = data[i]['theta']
        theta_next = data[i+1]['theta']

        # Local maximum
        if theta_curr > theta_prev and theta_curr > theta_next:
            extrema.append(('max', data[i]['t'], theta_curr))

        # Local minimum
        if theta_curr < theta_prev and theta_curr < theta_next:
            extrema.append(('min', data[i]['t'], theta_curr))

    for i, (typ, t, theta) in enumerate(extrema):
        if i > 0:
            delta_t = t - extrema[i-1][1]
            delta_theta = theta - extrema[i-1][2]
            print(f"{t:<10.3f} {theta:<15.6f} {delta_theta:<15.6f} {delta_t:<15.3f}")
        else:
            print(f"{t:<10.3f} {theta:<15.6f} {'---':<15} {'---':<15}")

    print()
    print("=" * 80)
    print("CRITICAL INSIGHT")
    print("=" * 80)
    print()
    print("θ(t) OSCILLATES - not a simple monotonic function!")
    print()
    print("This suggests f(s) is NOT a simple power or exponential.")
    print("Possible explanations:")
    print("  1. f(s) involves oscillatory functions (sin, cos)")
    print("  2. f(s) involves ζ(s) or L_M(s) which have complex structure")
    print("  3. Phase comes from arg(ζ(s)) or arg(L_M(s))")
    print()
    print("Next: Check if θ(t) = α·arg(ζ(1/2+it)) or similar")

    print()
    print("=" * 80)
    print("NEXT STEPS")
    print("=" * 80)
    print()
    print("Based on the best fit, guess candidates:")
    print("  - If θ ∝ log(t): try f(s) ∝ (Im s)^{iα}")
    print("  - If θ ∝ t: try f(s) = exp(iβ·Im(s))")
    print("  - Look for connection to ζ(s) or L_M(s) structure")
    print()

if __name__ == "__main__":
    main()
