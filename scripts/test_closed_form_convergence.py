#!/usr/bin/env python3
"""
Test: Does closed form converge in critical strip (Re(s) < 1)?

Closed form: L_M(s) = ζ(s)[ζ(s)-1] - C(s)
where C(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s

PROVEN to work for Re(s) > 1
NUMERICALLY tested for Re(s) = 1/2 (Schwarz symmetry)
UNKNOWN for other Re(s) < 1

This script tests convergence of C(s) for various s values.
"""

from mpmath import mp, zeta
from mpmath import fabs

mp.dps = 40

def partial_zeta(s, n):
    """H_n(s) = Σ_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def C_sum(s, jmax):
    """Compute C(s) = Σ_{j=2}^jmax H_{j-1}(s)/j^s"""
    total = mp.mpc(0)
    for j in range(2, jmax + 1):
        H = partial_zeta(s, j - 1)
        total += H / mp.power(j, s)
    return total

def L_M_closed(s, jmax):
    """Full closed form"""
    zs = zeta(s)
    c = C_sum(s, jmax)
    return zs * (zs - 1) - c

def test_convergence(s, jmax_values):
    """Test if C(s) converges by trying different jmax"""
    print(f"\nTesting s = {s}")
    print(f"  Re(s) = {float(s.real):.2f}, Im(s) = {float(s.imag):.2f}")
    print()
    print(f"  {'jmax':<10} {'|C(s)|':<20} {'Change':<15} {'Converged?':<12}")
    print(f"  {'-'*60}")

    prev = None
    results = []

    for jmax in jmax_values:
        c_val = C_sum(s, jmax)
        mag = fabs(c_val)

        if prev is not None:
            change = fabs(c_val - prev)
            change_str = f"{float(change):.6e}"
            converged = "✓" if change < 1e-4 else "..."
        else:
            change_str = "N/A"
            converged = ""

        mag_str = f"{float(mag):.10f}"
        print(f"  {jmax:<10} {mag_str:<20} {change_str:<15} {converged:<12}")

        prev = c_val
        results.append(mag)

    # Check final convergence
    if len(results) >= 2:
        final_change = abs(results[-1] - results[-2])
        if final_change < 1e-4:
            print(f"\n  ✓ C(s) CONVERGES (change < 1e-4)")
            return True
        else:
            print(f"\n  ⚠ C(s) may NOT converge (change = {float(final_change):.2e})")
            return False

def main():
    print("=" * 80)
    print("Convergence Test: Closed Form in Critical Strip")
    print("=" * 80)
    print()
    print("Question: Does C(s) = Σ H_{j-1}(s)/j^s converge for Re(s) < 1?")
    print()
    print("If YES → closed form works → we have analytic continuation! ✓")
    print("If NO  → closed form fails → need other method ✗")
    print()
    print("=" * 80)

    # Test different values of Re(s)
    test_cases = [
        # Safe region (known to work)
        (mp.mpc(1.5, 10), "Safe: Re(s) > 1"),
        (mp.mpc(1.1, 10), "Near boundary"),

        # Critical line (tested numerically before)
        (mp.mpc(0.5, 10), "Critical line"),
        (mp.mpc(0.5, 14.135), "Critical (Riemann zero)"),

        # Inside critical strip
        (mp.mpc(0.7, 10), "Strip: Re(s) = 0.7"),
        (mp.mpc(0.3, 10), "Strip: Re(s) = 0.3"),

        # Near Re(s) = 0
        (mp.mpc(0.1, 10), "Near zero: Re(s) = 0.1"),
        (mp.mpc(0.0, 10), "On zero: Re(s) = 0"),

        # Negative Re(s)
        (mp.mpc(-0.5, 10), "Negative: Re(s) = -0.5"),
    ]

    jmax_values = [100, 200, 300, 400, 500]

    converged_cases = []
    failed_cases = []

    for s, label in test_cases:
        print(f"\n{'='*80}")
        print(f"{label}")
        print(f"{'='*80}")

        converged = test_convergence(s, jmax_values)

        if converged:
            converged_cases.append((s, label))
        else:
            failed_cases.append((s, label))

    print()
    print("=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print()

    print(f"Converged ({len(converged_cases)}):")
    for s, label in converged_cases:
        re_s = float(s.real)
        print(f"  ✓ {label} (Re(s) = {re_s:.2f})")

    print()
    print(f"Failed/Uncertain ({len(failed_cases)}):")
    for s, label in failed_cases:
        re_s = float(s.real)
        print(f"  ✗ {label} (Re(s) = {re_s:.2f})")

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print()

    if len(failed_cases) == 0:
        print("🎉 AMAZING: Closed form converges EVERYWHERE tested!")
        print()
        print("  → Closed form IS the analytic continuation!")
        print("  → No need for functional equation to extend domain!")
        print("  → Can compute L_M(s) anywhere (except poles)")
        print()
        print("This is a MAJOR finding!")

    elif all(s.real >= 0 for s, _ in converged_cases):
        print("✓ Closed form works in critical strip (Re(s) ≥ 0)")
        print()
        print("  → Analytic continuation to critical strip ✓")
        print("  → May fail for Re(s) < 0")

    else:
        print("⚠ Closed form convergence is LIMITED")
        print()
        print("  → Works for some s, fails for others")
        print("  → Need to determine exact convergence region")

    print()

if __name__ == "__main__":
    main()
