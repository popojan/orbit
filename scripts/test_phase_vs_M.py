#!/usr/bin/env python3
"""
Test: Is θ(t) related to M(n)?

Hypothesis: θ(t) = Σ_{n≤t} α·M(n) or similar

Strategy:
1. Compute θ(n) for integer n
2. Compute first differences Δθ_n = θ(n) - θ(n-1)
3. Compare with M(n), τ(n), other functions
4. Look for pattern!
"""

from mpmath import mp, zeta, gamma, pi, arg, conj
import math

mp.dps = 50

def M(n):
    """M(n) = count of divisors d where 2 ≤ d ≤ √n"""
    if n < 4:
        return 0
    tau = 0
    sqrt_n = int(n**0.5) + 1
    for d in range(1, sqrt_n + 1):
        if d * d > n:
            break
        if n % d == 0:
            tau += 1 if d * d == n else 2
    return (tau - 1) // 2

def tau(n):
    """Count divisors of n"""
    count = 0
    sqrt_n = int(n**0.5) + 1
    for d in range(1, sqrt_n + 1):
        if d * d > n:
            break
        if n % d == 0:
            count += 1 if d * d == n else 2
    return count

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

def unwrap_single(phase, prev_unwrapped):
    """Unwrap single phase value given previous unwrapped value"""
    diff = phase - (prev_unwrapped % (2 * math.pi))
    if diff > math.pi:
        return prev_unwrapped + diff - 2 * math.pi
    elif diff < -math.pi:
        return prev_unwrapped + diff + 2 * math.pi
    else:
        return prev_unwrapped + diff

def main():
    print("=" * 80)
    print("Testing: Is θ(t) related to M(n)?")
    print("=" * 80)
    print()
    print("Hypothesis: Δθ_n = α·M(n) or θ(n) = Σ_{k≤n} β·M(k)")
    print()
    print("=" * 80)

    # Compute θ for integers 2 to 30
    n_values = list(range(2, 31))

    print()
    print("STEP 1: Compute θ(n) for integer n")
    print("=" * 80)
    print()

    theta_raw = []
    theta_unwrapped = []

    print(f"{'n':<5} {'θ_raw [rad]':<15} {'θ_unwrapped':<15}")
    print("-" * 35)

    prev_unwrapped = 0
    for n in n_values:
        phase = compute_phase(float(n))
        theta_raw.append(phase)

        if len(theta_unwrapped) == 0:
            unwrapped = phase
        else:
            unwrapped = unwrap_single(phase, theta_unwrapped[-1])

        theta_unwrapped.append(unwrapped)

        print(f"{n:<5} {phase:<15.6f} {unwrapped:<15.6f}")

    print()
    print("=" * 80)
    print("STEP 2: Compute first differences Δθ_n")
    print("=" * 80)
    print()

    print(f"{'n':<5} {'M(n)':<10} {'τ(n)':<10} {'Δθ_n':<15} {'Δθ/M':<15} {'Δθ/τ':<15}")
    print("-" * 70)

    deltas = []
    ratios_M = []
    ratios_tau = []

    for i in range(1, len(n_values)):
        n = n_values[i]
        delta = theta_unwrapped[i] - theta_unwrapped[i-1]
        deltas.append(delta)

        M_n = M(n)
        tau_n = tau(n)

        ratio_M = delta / M_n if M_n > 0 else 0
        ratio_tau = delta / tau_n if tau_n > 0 else 0

        ratios_M.append(ratio_M)
        ratios_tau.append(ratio_tau)

        print(f"{n:<5} {M_n:<10} {tau_n:<10} {delta:<15.6f} {ratio_M:<15.6f} {ratio_tau:<15.6f}")

    print()
    print("=" * 80)
    print("STEP 3: Statistical analysis")
    print("=" * 80)
    print()

    # Check if Δθ/M is roughly constant
    valid_ratios_M = [r for r in ratios_M if r != 0]
    if valid_ratios_M:
        mean_M = sum(valid_ratios_M) / len(valid_ratios_M)
        std_M = math.sqrt(sum((x - mean_M)**2 for x in valid_ratios_M) / len(valid_ratios_M))

        print(f"Testing Δθ_n = α·M(n):")
        print(f"  Mean(Δθ/M) = {mean_M:.6f}")
        print(f"  StdDev     = {std_M:.6f}")
        print(f"  Variation  = {100*std_M/abs(mean_M):.2f}%")

        if abs(std_M/mean_M) < 0.2:
            print(f"  ✓ GOOD FIT! Δθ_n ≈ {mean_M:.6f}·M(n)")
        else:
            print(f"  ✗ Not a good fit")

    print()

    # Check if Δθ/τ is roughly constant
    valid_ratios_tau = [r for r in ratios_tau if r != 0]
    if valid_ratios_tau:
        mean_tau = sum(valid_ratios_tau) / len(valid_ratios_tau)
        std_tau = math.sqrt(sum((x - mean_tau)**2 for x in valid_ratios_tau) / len(valid_ratios_tau))

        print(f"Testing Δθ_n = α·τ(n):")
        print(f"  Mean(Δθ/τ) = {mean_tau:.6f}")
        print(f"  StdDev     = {std_tau:.6f}")
        print(f"  Variation  = {100*std_tau/abs(mean_tau):.2f}%")

        if abs(std_tau/mean_tau) < 0.2:
            print(f"  ✓ GOOD FIT! Δθ_n ≈ {mean_tau:.6f}·τ(n)")
        else:
            print(f"  ✗ Not a good fit")

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print()

    if valid_ratios_M and abs(std_M/mean_M) < 0.2:
        print(f"🎉 BREAKTHROUGH: θ(t) = Σ_{{n≤t}} {mean_M:.6f}·M(n) + constant")
        print()
        print("This means f(s) is DIRECTLY constructed from M(n)!")
        print("The correction factor encodes the M-function structure!")
    elif valid_ratios_tau and abs(std_tau/mean_tau) < 0.2:
        print(f"🎉 DISCOVERY: θ(t) = Σ_{{n≤t}} {mean_tau:.6f}·τ(n) + constant")
        print()
        print("Phase related to divisor function!")
    else:
        print("No simple linear relationship found.")
        print("May need more complex formula or higher precision.")

    print()

if __name__ == "__main__":
    main()
