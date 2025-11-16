#!/usr/bin/env python3
"""
CRITICAL TEST: Schwarz Symmetry vs Convergence

Question: Can Schwarz symmetry hold even if values oscillate?

Test both:
1. Does L_M(1-s, jmax) = conj(L_M(s, jmax)) for each jmax? (Schwarz)
2. Does L_M(s, jmax) converge as jmax increases? (Convergence)

Hypothesis: Symmetry can hold even if values don't converge!
"""

from mpmath import mp, zeta, conj, fabs

mp.dps = 40

def partial_zeta(s, n):
    """H_n(s) = Σ_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed(s, jmax):
    """
    L_M(s) = ζ(s)[ζ(s)-1] - Σ_{j=2}^jmax H_{j-1}(s)/j^s
    """
    zs = zeta(s)
    part1 = zs * (zs - 1)

    part2 = mp.mpc(0)
    for j in range(2, jmax + 1):
        H = partial_zeta(s, j - 1)
        part2 += H / mp.power(j, s)

    return part1 - part2

def test_critical_line_behavior(s):
    """
    Test BOTH convergence and Schwarz symmetry
    """
    print(f"\n{'='*80}")
    print(f"Testing s = {s}")
    print(f"  (On critical line: 1-s = conj(s) = {1-s})")
    print(f"{'='*80}\n")

    jmax_values = [100, 150, 200, 250, 300, 350, 400, 450, 500]

    print(f"{'jmax':<8} {'|L_M(s)|':<18} {'|L_M(1-s)|':<18} {'Schwarz Error':<18} {'Convergence':<15}")
    print("-" * 85)

    prev_L_s = None
    prev_L_1ms = None

    for jmax in jmax_values:
        # Compute L_M(s) and L_M(1-s)
        L_s = L_M_closed(s, jmax)
        L_1ms = L_M_closed(1 - s, jmax)

        # Test Schwarz symmetry: L_M(1-s) should equal conj(L_M(s))
        L_s_conj = conj(L_s)
        schwarz_error = fabs(L_1ms - L_s_conj)

        # Test convergence: how much did values change?
        if prev_L_s is not None:
            conv_s = fabs(L_s - prev_L_s)
            conv_1ms = fabs(L_1ms - prev_L_1ms)
            conv_str = f"{float(conv_s):.3e}"
        else:
            conv_str = "N/A"

        # Display
        mag_s = fabs(L_s)
        mag_1ms = fabs(L_1ms)

        print(f"{jmax:<8} {float(mag_s):<18.10f} {float(mag_1ms):<18.10f} "
              f"{float(schwarz_error):<18.3e} {conv_str:<15}")

        prev_L_s = L_s
        prev_L_1ms = L_1ms

    print()

def main():
    print("=" * 80)
    print("CRITICAL TEST: Schwarz Symmetry vs Convergence")
    print("=" * 80)
    print()
    print("Question: Can the closed form satisfy Schwarz symmetry")
    print("          even if it doesn't converge?")
    print()
    print("Test:")
    print("  - Schwarz: |L_M(1-s) - conj(L_M(s))| should be small")
    print("  - Convergence: |L_M(s, jmax) - L_M(s, jmax-50)| should decrease")
    print()
    print("Hypothesis: Symmetry can hold even with oscillation!")
    print("=" * 80)

    # Test at various critical line points
    test_points = [
        mp.mpc(0.5, 10),
        mp.mpc(0.5, 14.135),  # Riemann zero
        mp.mpc(0.5, 20),
    ]

    for s in test_points:
        test_critical_line_behavior(s)

    print()
    print("=" * 80)
    print("ANALYSIS")
    print("=" * 80)
    print()
    print("If Schwarz error stays small BUT convergence doesn't improve:")
    print("  → Symmetry holds even though values oscillate!")
    print("  → Closed form is SYMMETRICALLY WRONG at all jmax")
    print("  → Original Schwarz test was misleading (assumed convergence)")
    print()
    print("If BOTH Schwarz error AND convergence improve:")
    print("  → Closed form actually works, just needs larger jmax")
    print("  → Original convergence test was impatient")
    print()
    print("If Schwarz error grows:")
    print("  → Original Schwarz test was lucky coincidence at jmax=200")
    print("  → Symmetry doesn't really hold")
    print()

if __name__ == "__main__":
    main()
