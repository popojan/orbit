#!/usr/bin/env python3
"""
Test Analytic Continuation via Hurwitz Zeta

Idea: L_M(s) = Σ_{d=2}^∞ d^{-s} Σ_{m=d}^∞ m^{-s}
              = Σ_{d=2}^∞ d^{-s} ζ(s,d)

where ζ(s,a) is Hurwitz zeta, which has KNOWN continuation!

If this sum converges for Re(s) < 1, we have analytic continuation WITHOUT FR!
"""

from mpmath import mp, zeta
from mpmath import re, im, fabs

# Set precision
mp.dps = 40

def partial_zeta(s, n):
    """Compute H_n(s) = sum_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed_form(s, jmax=200):
    """
    Standard closed form (works for Re(s) > 1):
    L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s
    """
    zeta_s = zeta(s)
    correction = mp.mpf(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = partial_zeta(s, j - 1)
        correction += H_j_minus_1 / mp.power(j, s)
    return zeta_s * (zeta_s - 1) - correction

def L_M_hurwitz(s, d_max=200):
    """
    Analytic continuation candidate via Hurwitz zeta:
    L_M(s) = Σ_{d=2}^{d_max} d^{-s} ζ(s,d)

    Uses mpmath's zeta(s,a) which includes analytic continuation.
    """
    total = mp.mpc(0)
    for d in range(2, d_max + 1):
        # zeta(s, d) is Hurwitz zeta = Σ_{n=0}^∞ 1/(n+d)^s
        # mpmath handles continuation automatically
        hurwitz_term = zeta(s, d)
        total += hurwitz_term / mp.power(d, s)
    return total

def main():
    print("=" * 80)
    print("Testing Analytic Continuation via Hurwitz Zeta")
    print("=" * 80)
    print()
    print("Method: L_M(s) = Σ_{d=2}^∞ d^{-s} ζ(s,d)")
    print()
    print("Test: Compare with closed form where it works (Re(s) > 1)")
    print("Then: Try in critical strip (Re(s) < 1) to see if sum converges")
    print()
    print("-" * 80)

    # Test points - start with Re(s) > 1 (known to work)
    test_cases = [
        ("Re(s) > 1 (safe)", [
            (2.0 + 0j, "Real s=2"),
            (1.5 + 5j, "s = 1.5 + 5i"),
            (1.2 + 10j, "s = 1.2 + 10i"),
        ]),
        ("Critical line Re(s) = 1/2", [
            (0.5 + 10j, "s = 0.5 + 10i"),
            (0.5 + 14.135j, "s = 0.5 + 14.135i (Riemann zero)"),
            (0.5 + 20j, "s = 0.5 + 20i"),
        ]),
        ("Critical strip Re(s) < 1/2", [
            (0.3 + 10j, "s = 0.3 + 10i"),
            (0.0 + 10j, "s = 0 + 10i"),
            (-0.5 + 10j, "s = -0.5 + 10i"),
        ]),
    ]

    all_results = []

    for category, points in test_cases:
        print()
        print(f"Category: {category}")
        print("-" * 80)
        print(f"{'s':<25} {'Closed Form':<20} {'Hurwitz':<20} {'Match?':<10}")
        print("-" * 80)

        for s, label in points:
            s = mp.mpc(s)

            try:
                # Compute via closed form (may fail for Re(s) ≤ 1)
                if re(s) > 1:
                    closed = L_M_closed_form(s, jmax=150)
                    closed_str = f"{float(fabs(closed)):.6e}"
                else:
                    closed = None
                    closed_str = "N/A (Re(s)≤1)"

                # Compute via Hurwitz zeta (the test!)
                hurwitz = L_M_hurwitz(s, d_max=150)
                hurwitz_str = f"{float(fabs(hurwitz)):.6e}"

                # Check match
                if closed is not None:
                    error = fabs(closed - hurwitz)
                    match = "✓" if error < 1e-6 else "✗"
                    match_str = f"{match} (err: {float(error):.2e})"
                else:
                    match_str = "? (no ref)"

                print(f"{label:<25} {closed_str:<20} {hurwitz_str:<20} {match_str:<10}")

                all_results.append({
                    's': s,
                    'label': label,
                    'closed': closed,
                    'hurwitz': hurwitz,
                    'category': category
                })

            except Exception as e:
                print(f"{label:<25} ERROR: {e}")

    print()
    print("=" * 80)
    print("Analysis")
    print("=" * 80)
    print()

    # Check convergence in critical strip
    safe_results = [r for r in all_results if r['category'] == "Re(s) > 1 (safe)"]
    critical_results = [r for r in all_results if "Critical" in r['category']]

    if safe_results:
        print("Validation (Re(s) > 1):")
        all_match = all(
            fabs(r['closed'] - r['hurwitz']) < 1e-6
            for r in safe_results
            if r['closed'] is not None
        )
        if all_match:
            print("  ✓ Hurwitz method MATCHES closed form in safe region")
            print("    → Method is correct for Re(s) > 1")
        else:
            print("  ✗ Mismatch in safe region - method may be wrong!")

    print()

    if critical_results:
        print("Continuation (Re(s) ≤ 1):")
        print()
        for r in critical_results:
            mag = float(fabs(r['hurwitz']))
            print(f"  {r['label']}: |L_M| = {mag:.6e}")

        print()
        if all(fabs(r['hurwitz']) < 1e10 for r in critical_results):
            print("  ✓ Hurwitz sum appears FINITE in critical strip!")
            print("    → This suggests analytic continuation EXISTS")
            print()
            print("  🎉 POTENTIAL BREAKTHROUGH:")
            print("     We may have found analytic continuation WITHOUT FR!")
        else:
            print("  ✗ Sum appears to diverge or blow up")
            print("    → Method may not work for Re(s) < 1")

    print()
    print("=" * 80)
    print("Convergence Test")
    print("=" * 80)
    print()

    # Test convergence at one critical strip point
    s_test = mp.mpc(0.5, 10)
    print(f"Testing convergence at s = {s_test}")
    print()

    d_values = [50, 100, 150, 200, 250]
    print(f"{'d_max':<10} {'|L_M(s)|':<20} {'Change from prev':<20}")
    print("-" * 50)

    prev = None
    for d_max in d_values:
        result = L_M_hurwitz(s_test, d_max=d_max)
        mag = float(fabs(result))

        if prev is not None:
            change = abs(mag - prev)
            change_str = f"{change:.6e}"
        else:
            change_str = "N/A"

        print(f"{d_max:<10} {mag:<20.10f} {change_str:<20}")
        prev = mag

    print()
    if d_values:
        final_two = [L_M_hurwitz(s_test, d) for d in d_values[-2:]]
        convergence = fabs(final_two[1] - final_two[0])

        if convergence < 1e-4:
            print(f"✓ Series converges! (change < {float(convergence):.2e})")
            print("  → Analytic continuation via Hurwitz zeta WORKS!")
        else:
            print(f"⚠ Series may not converge (change = {float(convergence):.2e})")

    print()
    print("=" * 80)
    print("Conclusion")
    print("=" * 80)
    print()
    print("If Hurwitz method works:")
    print("  → We have L_M(s) for ALL s (except poles)")
    print("  → Can compute in critical strip")
    print("  → Can find zeros")
    print("  → Can derive asymptotics (with Perron formula)")
    print()
    print("This would be a MAJOR result - continuation without FR!")
    print()

if __name__ == "__main__":
    main()
