#!/usr/bin/env python3
"""
Test connection between L_M(s) zeros and Riemann zeta zeros

Question: Does L_M(s₀) = 0 when ζ(s₀) = 0?

This is testable with Schwarz symmetry alone (no full FR needed).
All Riemann zeros (assuming RH) lie on Re(s) = 1/2.
"""

from mpmath import mp, zeta, gamma, pi
from mpmath import re, im, arg, fabs

# Set high precision
mp.dps = 50

def partial_zeta(s, n):
    """Compute H_n(s) = sum_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed_form(s, jmax=250):
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

# First 20 nontrivial Riemann zeta zeros (imaginary parts)
# Source: LMFDB, Odlyzko databases
RIEMANN_ZEROS = [
    14.134725141734693790457251983562470270784257115699243175685567460149963429809,
    21.022039638771554992628479593896902777334340524902781754629520403587598586817,
    25.010857580145688763213790992562821818659549672557996672496542006745092098495,
    30.424876125859513210311897530584091320181560023715440180962146036993329389333,
    32.935061587739189690662368964074903488812715603517039009280003440784815608630,
    37.586178158825671257217763480705332821405597350830793218333001113433439300911,
    40.918719012147495187398126914633254395726165962777279536161303667916201804076,
    43.327073280914999519496122165406805782645668371836871442410186675237935267094,
    48.005150881167159727942472749427516041686844001144425117775312280998597815369,
    49.773832477672302181916784678563724057723178299676662824814897086310712372736,
    52.970321477714460644147603360823133929607645814814842010341888393210945093784,
    56.446247697063394804451976837453163243818485163809203283645143865975268811364,
    59.347044002602353079653587598801838493127812121257132198526079667726503541340,
    60.831778524609804760913878869815858592850624129467132223531205520073114763950,
    65.112544048081606660717149050475045031492460586275244119327034650903577077412,
    67.079810529494173714886161379874266556504898305237414907415758158393255081083,
    69.546401711173979319059716183514003414547116995593571020485840167643853875820,
    72.067157674481907582522041874352730040826329454441128850119512547966168131614,
    75.704690699083933168611097135591505339430604288922053925430202639343432733471,
    77.144840068874804200716531241650582761595130666311396787069235167811544364823,
]

def main():
    print("=" * 80)
    print("Testing L_M(s) at Riemann Zeta Zeros")
    print("=" * 80)
    print()
    print("Question: Does L_M(s₀) = 0 when ζ(s₀) = 0?")
    print()
    print("Testing first 20 Riemann zeros (all on Re(s) = 1/2 by RH)")
    print()
    print("-" * 80)
    print(f"{'k':<5} {'t_k':<20} {'|ζ(s_k)|':<20} {'|L_M(s_k)|':<20} {'L_M ≈ 0?':<10}")
    print("-" * 80)

    results = []

    for k, t in enumerate(RIEMANN_ZEROS, start=1):
        s = mp.mpc(0.5, t)

        try:
            # Verify ζ(s) ≈ 0 (sanity check)
            zeta_s = zeta(s)
            zeta_mag = fabs(zeta_s)

            # Compute L_M(s)
            L_M_s = L_M_closed_form(s, jmax=250)
            L_M_mag = fabs(L_M_s)

            # Check if L_M is close to zero
            is_zero = "✓" if L_M_mag < 1e-6 else "✗"

            # Print results
            t_str = f"{float(t):.6f}"
            zeta_str = f"{float(zeta_mag):.10e}"
            L_M_str = f"{float(L_M_mag):.10e}"

            print(f"{k:<5} {t_str:<20} {zeta_str:<20} {L_M_str:<20} {is_zero:<10}")

            results.append({
                'k': k,
                't': float(t),
                'zeta_mag': float(zeta_mag),
                'L_M_mag': float(L_M_mag),
                'is_zero': L_M_mag < 1e-6
            })

        except Exception as e:
            print(f"{k:<5} {float(t):<20.6f} ERROR: {e}")

    print()
    print("=" * 80)
    print("Analysis")
    print("=" * 80)
    print()

    # Statistics
    total = len(results)
    zeros = sum(1 for r in results if r['is_zero'])
    non_zeros = total - zeros

    print(f"Total Riemann zeros tested: {total}")
    print(f"L_M ≈ 0 (|L_M| < 10^-6): {zeros}")
    print(f"L_M ≠ 0: {non_zeros}")
    print()

    if zeros > 0:
        print("🎯 POTENTIAL DISCOVERY: L_M has zeros at some Riemann zero heights!")
        print()
        print("Zeros found at:")
        for r in results:
            if r['is_zero']:
                print(f"  k={r['k']}, t={r['t']:.6f}, |L_M|={r['L_M_mag']:.3e}")
    else:
        print("❌ NO coincident zeros found.")
        print()
        print("But L_M magnitudes at Riemann zeros:")
        min_mag = min(r['L_M_mag'] for r in results)
        max_mag = max(r['L_M_mag'] for r in results)
        avg_mag = sum(r['L_M_mag'] for r in results) / len(results)
        print(f"  Min: {min_mag:.3e}")
        print(f"  Max: {max_mag:.3e}")
        print(f"  Avg: {avg_mag:.3e}")
        print()
        print("If min is very small (< 10^-3), might be near-zero → investigate further")

    print()
    print("=" * 80)
    print("Interpretation")
    print("=" * 80)
    print()

    if zeros > 0:
        print("IF L_M zeros coincide with Riemann zeros:")
        print("  → Deep connection between M(n) divisor structure and primes")
        print("  → Potential path to Riemann Hypothesis insights")
        print("  → Publish-worthy result (even without full FR!)")
        print()
        print("Next steps:")
        print("  1. Verify with higher precision")
        print("  2. Test more zeros (100+)")
        print("  3. Prove the connection theoretically")
    else:
        print("L_M zeros do NOT coincide with Riemann zeros.")
        print()
        print("This means:")
        print("  → L_M has independent zero structure")
        print("  → Still interesting: where ARE the L_M zeros?")
        print("  → Study zero density, spacing, etc.")
        print()
        print("Next steps:")
        print("  1. Find L_M zeros on critical line (zero-finding algorithm)")
        print("  2. Compare distributions")
        print("  3. Look for interleaving patterns")

    print()

if __name__ == "__main__":
    main()
