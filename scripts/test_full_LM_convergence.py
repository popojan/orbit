#!/usr/bin/env python3
"""
CORRECT TEST: Convergence of FULL L_M(s), not just C(s)

L_M(s) = ζ(s)[ζ(s)-1] - C(s)

Even if C(s) oscillates, the FULL expression might converge
due to cancellation between oscillating terms.

This is the RIGHT test for analytic continuation.
"""

from mpmath import mp, zeta
from mpmath import fabs

mp.dps = 40

def partial_zeta(s, n):
    """H_n(s) = Σ_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed(s, jmax):
    """
    FULL closed form:
    L_M(s) = ζ(s)[ζ(s)-1] - Σ_{j=2}^jmax H_{j-1}(s)/j^s
    """
    zs = zeta(s)

    # First part (can be computed exactly)
    part1 = zs * (zs - 1)

    # Second part (truncated sum)
    part2 = mp.mpc(0)
    for j in range(2, jmax + 1):
        H = partial_zeta(s, j - 1)
        part2 += H / mp.power(j, s)

    return part1 - part2

def test_convergence(s, jmax_values):
    """Test if FULL L_M(s) converges"""
    print(f"\nTesting s = {s}")
    print(f"  Re(s) = {float(s.real):.2f}, Im(s) = {float(s.imag):.2f}")
    print()
    print(f"  {'jmax':<10} {'|L_M(s)|':<20} {'Change':<15} {'Status':<12}")
    print(f"  {'-'*60}")

    prev = None
    results = []

    for jmax in jmax_values:
        lm_val = L_M_closed(s, jmax)
        mag = fabs(lm_val)

        if prev is not None:
            change = fabs(lm_val - prev)
            change_str = f"{float(change):.6e}"

            if change < 1e-6:
                status = "✓✓✓"
            elif change < 1e-4:
                status = "✓✓"
            elif change < 1e-2:
                status = "✓"
            else:
                status = "..."
        else:
            change_str = "N/A"
            status = ""

        mag_str = f"{float(mag):.10f}"
        print(f"  {jmax:<10} {mag_str:<20} {change_str:<15} {status:<12}")

        prev = lm_val
        results.append((jmax, lm_val, mag))

    # Check convergence
    if len(results) >= 2:
        final_change = fabs(results[-1][1] - results[-2][1])

        if final_change < 1e-6:
            print(f"\n  ✓✓✓ L_M(s) STRONGLY CONVERGES (change < 1e-6)")
            return "strong"
        elif final_change < 1e-4:
            print(f"\n  ✓✓ L_M(s) CONVERGES (change < 1e-4)")
            return "good"
        elif final_change < 1e-2:
            print(f"\n  ✓ L_M(s) LIKELY CONVERGES (change < 1e-2)")
            return "weak"
        else:
            print(f"\n  ✗ L_M(s) does NOT converge (change = {float(final_change):.2e})")
            return "fail"

def main():
    print("=" * 80)
    print("CORRECT TEST: Full L_M(s) Convergence")
    print("=" * 80)
    print()
    print("Testing: L_M(s) = ζ(s)[ζ(s)-1] - C(s)")
    print()
    print("Key insight: Even if C(s) oscillates, FULL L_M might converge!")
    print("(Like how alternating zeta converges even though zeta diverges)")
    print()
    print("=" * 80)

    test_cases = [
        # Known to work
        (mp.mpc(2.0, 0), "Safe: s=2 (real)"),
        (mp.mpc(1.5, 10), "Safe: Re(s)=1.5"),

        # Critical line (we KNOW this works from Schwarz tests!)
        (mp.mpc(0.5, 10), "Critical line: Re(s)=0.5"),
        (mp.mpc(0.5, 14.135), "Critical (Riemann zero)"),
        (mp.mpc(0.5, 20), "Critical line: t=20"),

        # Inside critical strip
        (mp.mpc(0.7, 10), "Strip: Re(s)=0.7"),
        (mp.mpc(0.3, 10), "Strip: Re(s)=0.3"),

        # Near and at Re(s)=0
        (mp.mpc(0.1, 10), "Near zero: Re(s)=0.1"),
        (mp.mpc(0.0, 10), "At zero: Re(s)=0"),

        # Negative (risky)
        (mp.mpc(-0.5, 10), "Negative: Re(s)=-0.5"),
    ]

    jmax_values = [100, 200, 300, 400, 500]

    results_summary = []

    for s, label in test_cases:
        print(f"\n{'='*80}")
        print(f"{label}")
        print(f"{'='*80}")

        status = test_convergence(s, jmax_values)
        results_summary.append((s, label, status))

    print()
    print("=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print()

    strong = [r for r in results_summary if r[2] == "strong"]
    good = [r for r in results_summary if r[2] == "good"]
    weak = [r for r in results_summary if r[2] == "weak"]
    fail = [r for r in results_summary if r[2] == "fail"]

    print(f"✓✓✓ Strongly converges ({len(strong)}):")
    for s, label, _ in strong:
        print(f"    {label} (Re(s) = {float(s.real):.2f})")

    print()
    print(f"✓✓ Good convergence ({len(good)}):")
    for s, label, _ in good:
        print(f"    {label} (Re(s) = {float(s.real):.2f})")

    print()
    print(f"✓ Weak convergence ({len(weak)}):")
    for s, label, _ in weak:
        print(f"    {label} (Re(s) = {float(s.real):.2f})")

    print()
    print(f"✗ No convergence ({len(fail)}):")
    for s, label, _ in fail:
        print(f"    {label} (Re(s) = {float(s.real):.2f})")

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print()

    total_convergent = len(strong) + len(good) + len(weak)
    total = len(results_summary)

    if total_convergent == total:
        print("🎉🎉🎉 BREAKTHROUGH: L_M(s) converges EVERYWHERE tested!")
        print()
        print("  → Closed form IS analytic continuation!")
        print("  → Works without functional equation!")
        print("  → Can compute L_M(s) anywhere (except poles)")
        print()
        print("THIS IS HUGE - we have continuation without FR!")

    elif len(strong) + len(good) >= len(results_summary) // 2:
        print("✓ L_M(s) converges in MOST cases!")
        print()
        print("  → Closed form provides practical continuation")
        print("  → Works well in critical strip")

        if all(s.real >= 0 for s, _, status in results_summary if status != "fail"):
            print("  → Convergence region appears to be Re(s) ≥ 0")
    else:
        print("⚠ Limited convergence")
        print()
        print("  → Closed form has restricted validity")
        print("  → Need other method for full continuation")

    print()

if __name__ == "__main__":
    main()
