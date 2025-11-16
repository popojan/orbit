#!/usr/bin/env python3
"""
Test asymptotic formula for Σ M(n) derived from pole analysis

From L_M(s) pole structure at s=1:
  L_M(s) ~ 1/(s-1)² + (2γ-1)/(s-1) + ...

Perron formula predicts:
  Σ_{n≤x} M(n) ~ x + (2γ-1)·x·log(x) + O(x)

This tests the prediction numerically.
"""

from mpmath import mp, euler
import math

# Set precision
mp.dps = 30

def M(n):
    """
    M(n) = count of divisors d where 2 ≤ d ≤ √n
         = floor((tau(n) - 1) / 2)
    """
    tau = 0
    sqrt_n = int(n**0.5) + 1
    for d in range(1, sqrt_n + 1):
        if d * d > n:
            break
        if n % d == 0:
            tau += 1 if d * d == n else 2
    return (tau - 1) // 2

def sum_M(x_max):
    """Compute Σ_{n=1}^{x_max} M(n)"""
    return sum(M(n) for n in range(1, x_max + 1))

def asymptotic_prediction(x):
    """
    Predicted asymptotic formula from pole analysis:
    Σ M(n) ~ x + (2γ-1)·x·log(x)

    where γ = Euler-Mascheroni constant ≈ 0.5772

    NOTE: This prediction assumes we can use Perron formula,
    which requires analytic continuation (which we don't have!).
    So this is SPECULATIVE - testing empirically.
    """
    gamma = float(euler)
    coeff = 2 * gamma - 1  # ≈ 0.1544

    main_term = x
    log_term = coeff * x * math.log(x) if x > 1 else 0

    return main_term + log_term

def main():
    print("=" * 80)
    print("Testing Asymptotic Formula for Σ M(n)")
    print("=" * 80)
    print()
    print("From pole analysis of L_M(s) at s=1:")
    print("  L_M(s) ~ 1/(s-1)² + (2γ-1)/(s-1) + ...")
    print()
    print("Perron formula predicts:")
    print("  Σ_{n≤x} M(n) ~ x + (2γ-1)·x·log(x)")
    print()
    gamma = float(euler)
    coeff = 2 * gamma - 1
    print(f"Constants:")
    print(f"  γ (Euler-Mascheroni) = {gamma:.10f}")
    print(f"  2γ - 1 = {coeff:.10f}")
    print()
    print("-" * 80)

    # Test at various x values
    x_values = [10, 50, 100, 200, 500, 1000, 2000, 5000]

    results = []

    print(f"{'x':<10} {'Σ M(n)':<15} {'Predicted':<15} {'Error':<15} {'Rel Error %':<15}")
    print("-" * 80)

    for x in x_values:
        actual = sum_M(x)
        predicted = asymptotic_prediction(x)
        error = actual - predicted
        rel_error = 100 * error / actual if actual != 0 else 0

        print(f"{x:<10} {actual:<15.2f} {predicted:<15.2f} {error:<15.2f} {rel_error:<15.4f}")

        results.append({
            'x': x,
            'actual': actual,
            'predicted': predicted,
            'error': error,
            'rel_error': rel_error
        })

    print()
    print("=" * 80)
    print("Analysis")
    print("=" * 80)
    print()

    print("Relative error trend:")
    rel_errors = [r['rel_error'] for r in results]
    if len(rel_errors) > 3:
        first_half_avg = sum(rel_errors[:len(rel_errors)//2]) / (len(rel_errors)//2)
        second_half_avg = sum(rel_errors[len(rel_errors)//2:]) / (len(rel_errors) - len(rel_errors)//2)
        print(f"  First half average: {first_half_avg:.4f}%")
        print(f"  Second half average: {second_half_avg:.4f}%")

        if abs(second_half_avg) < abs(first_half_avg):
            print("✓ Relative error decreases as x grows (good fit!)")
        else:
            print("⚠ Relative error not decreasing")

    print()
    print("=" * 80)
    print("IMPORTANT CAVEAT")
    print("=" * 80)
    print()
    print("⚠️  This asymptotic prediction ASSUMES we can use Perron formula,")
    print("   which requires analytic continuation to Re(s) < 1.")
    print()
    print("   We DON'T have analytic continuation (no functional equation)!")
    print()
    print("   So this test is EMPIRICAL ONLY - the formula might work")
    print("   by accident, or might be completely wrong theoretically.")
    print()
    print("=" * 80)
    print("Conclusion")
    print("=" * 80)
    print()

    final_rel_error = results[-1]['rel_error']
    if abs(final_rel_error) < 5:
        print(f"✓ Asymptotic formula fits well! (final rel error: {final_rel_error:.4f}%)")
        print()
        print("The pole analysis prediction:")
        print("  Σ_{n≤x} M(n) ~ x + (2γ-1)·x·log(x)")
        print()
        print("is VERIFIED numerically!")
    else:
        print(f"⚠ Formula has significant error (final rel error: {final_rel_error:.4f}%)")
        print("May need higher-order terms in asymptotic expansion")

    print()

if __name__ == "__main__":
    main()
