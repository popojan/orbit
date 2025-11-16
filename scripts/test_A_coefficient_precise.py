#!/usr/bin/env python3
"""
Precise test: Is A = 0, A = 1, or something else?

Test the limit: lim_{s→1} (s-1)² · L_M(s)

If A = 0 (miracle cancellation) → L_M is ANALYTIC at s=1 (revolutionary!)
If A = 1 → Standard double pole behavior
"""

from mpmath import mp, zeta, log, exp, mpf
import sys

# Set precision
mp.dps = 100  # 100 decimal places for extreme precision

def C_func(s, jmax=1000):
    """C(s) = sum_{j=2}^{jmax} H_{j-1}(s) / j^s"""
    result = mp.mpf(0)
    for j in range(2, jmax + 1):
        # H_{j-1}(s) = sum_{k=1}^{j-1} k^{-s}
        H_j_minus_1 = sum(mp.power(k, -s) for k in range(1, j))
        result += H_j_minus_1 / mp.power(j, s)
    return result

def L_M_closed(s, jmax=1000):
    """L_M(s) via closed form"""
    zeta_s = zeta(s)
    C_s = C_func(s, jmax)
    return zeta_s * (zeta_s - 1) - C_s

def test_A_coefficient():
    """
    Test: what is lim_{s→1} (s-1)² · L_M(s)?

    Three hypotheses:
    H0: A = 0 (miracle cancellation, analyticity)
    H1: A = 1 (standard double pole)
    H2: A = something else
    """

    print("="*80)
    print("PRECISE TEST: What is the double pole coefficient A?")
    print("="*80)
    print()
    print(f"Precision: {mp.dps} decimal places")
    print(f"jmax: 1000 (C(s) truncation)")
    print()

    results = []

    for k in range(2, 11):
        eps = mp.power(10, -k)
        s = 1 + eps

        # Compute L_M(s)
        L_val = L_M_closed(s, jmax=1000)

        # Compute (s-1)² · L_M(s)
        A_estimate = eps**2 * L_val

        # Compute relative to A=0 and A=1
        dist_from_0 = abs(A_estimate - 0)
        dist_from_1 = abs(A_estimate - 1)

        results.append({
            'k': k,
            'eps': eps,
            'A_estimate': A_estimate,
            'dist_0': dist_from_0,
            'dist_1': dist_from_1,
            'ratio_1_0': dist_from_1 / dist_from_0 if dist_from_0 > 0 else mp.inf
        })

        print(f"ε = 10^-{k}:")
        print(f"  (s-1)² · L_M(s) = {mp.nstr(A_estimate, 20)}")
        print(f"  Distance from 0: {mp.nstr(dist_from_0, 10)}")
        print(f"  Distance from 1: {mp.nstr(dist_from_1, 10)}")
        print()

    print("="*80)
    print("CONVERGENCE ANALYSIS")
    print("="*80)
    print()

    # Analyze convergence pattern
    print("Pattern analysis:")
    print()

    # Check if converging to 0
    print("Testing H0: A = 0 (miracle cancellation)")
    print("  If true, |A_estimate - 0| should → 0")
    for i in range(len(results)-1):
        r1, r2 = results[i], results[i+1]
        reduction_0 = r1['dist_0'] / r2['dist_0']
        print(f"  ε={mp.nstr(r1['eps'],5)} → ε={mp.nstr(r2['eps'],5)}: reduction factor = {mp.nstr(reduction_0, 5)}")

    print()
    print("Testing H1: A = 1 (standard double pole)")
    print("  If true, |A_estimate - 1| should → 0")
    for i in range(len(results)-1):
        r1, r2 = results[i], results[i+1]
        reduction_1 = r1['dist_1'] / r2['dist_1']
        print(f"  ε={mp.nstr(r1['eps'],5)} → ε={mp.nstr(r2['eps'],5)}: reduction factor = {mp.nstr(reduction_1, 5)}")

    print()
    print("="*80)
    print("EXTRAPOLATION TO ε → 0")
    print("="*80)
    print()

    # Fit linear model: A_estimate = A + b·ε
    # Use last 3 points for better extrapolation

    if len(results) >= 3:
        # Simple linear regression
        x_vals = [float(r['eps']) for r in results[-3:]]
        y_vals = [float(r['A_estimate']) for r in results[-3:]]

        # Linear fit: y = a + b*x
        n = len(x_vals)
        sum_x = sum(x_vals)
        sum_y = sum(y_vals)
        sum_xx = sum(x*x for x in x_vals)
        sum_xy = sum(x*y for x, y in zip(x_vals, y_vals))

        b = (n*sum_xy - sum_x*sum_y) / (n*sum_xx - sum_x**2)
        a = (sum_y - b*sum_x) / n

        print(f"Linear extrapolation using last 3 points:")
        print(f"  A_estimate(ε) ≈ {a:.15f} + {b:.10f}·ε")
        print(f"  Extrapolated A (ε→0): {a:.15f}")
        print()

        if abs(a) < 0.1:
            print("  *** EVIDENCE FOR A = 0 (miracle cancellation!) ***")
        elif abs(a - 1) < 0.1:
            print("  *** EVIDENCE FOR A = 1 (standard double pole) ***")
        else:
            print(f"  *** EVIDENCE FOR A ≈ {a:.3f} (unexpected value!) ***")

    print()
    print("="*80)
    print("CONCLUSION")
    print("="*80)
    print()

    # Final verdict based on last estimate
    last = results[-1]

    if last['dist_0'] < 1e-8:
        print("VERDICT: A = 0 (MIRACLE CANCELLATION)")
        print("  → L_M(s) is ANALYTIC at s=1")
        print("  → Σ M(n)/n CONVERGES")
        print("  → REVOLUTIONARY RESULT!")
    elif last['dist_1'] < 1e-8:
        print("VERDICT: A = 1 (STANDARD DOUBLE POLE)")
        print("  → L_M(s) has double pole at s=1")
        print("  → Standard L-function behavior")
    else:
        print("VERDICT: INCONCLUSIVE or A ≠ {0, 1}")
        print(f"  → A ≈ {mp.nstr(last['A_estimate'], 15)}")
        print("  → Need more investigation")

if __name__ == "__main__":
    test_A_coefficient()
