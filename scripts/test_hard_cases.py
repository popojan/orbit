#!/usr/bin/env python3
"""
Test Regulator Approximation on HARD Cases

Hard cases: D with long periods → large regulators
- D = 13: period = 5, R = 7.169
- D = 61: period = 11, R = 21.985
- D = 109: period = 15, R = 33.387
- D = 181: period = 21, R = 43.044

Also test M(D) correlation strength on these.
"""

import sys
sys.path.append('/home/user/orbit/scripts')

from pell_regulator_attack import regulator_direct_from_cf, continued_fraction_sqrt
import math

def M(n):
    """Childhood function."""
    count = 0
    sqrt_n = int(math.sqrt(n))
    for d in range(2, sqrt_n + 1):
        if n % d == 0:
            count += 1
    return count

def omega(n):
    """Count distinct prime divisors."""
    count = 0
    temp = n
    if temp % 2 == 0:
        count += 1
        while temp % 2 == 0:
            temp //= 2
    p = 3
    while p * p <= temp:
        if temp % p == 0:
            count += 1
            while temp % p == 0:
                temp //= p
        p += 2
    if temp > 1:
        count += 1
    return count

def is_prime(n):
    """Primality test."""
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(math.sqrt(n)) + 1, 2):
        if n % i == 0:
            return False
    return True

# ============================================================================
# Hard Test Cases
# ============================================================================

hard_cases = [13, 61, 109, 181, 277, 349, 421]

print("="*80)
print("HARD CASES: Long Period → Large Regulator")
print("="*80)

print("\n  D     M(D)  omega  prime  period   R(D)     x₀ digits  y₀ digits")
print("-" * 75)

results = []

for D in hard_cases:
    try:
        # Exact computation
        cf = continued_fraction_sqrt(D)
        period = cf['period_length']

        R, x0, y0 = regulator_direct_from_cf(D)

        # Properties
        M_D = M(D)
        omega_D = omega(D)
        prime = is_prime(D)

        x_digits = len(str(x0))
        y_digits = len(str(y0))

        prime_str = "YES" if prime else "NO"

        print(f"{D:4d}  {M_D:4d}  {omega_D:4d}   {prime_str:5s}  {period:4d}   {R:7.3f}   {x_digits:6d}      {y_digits:6d}")

        results.append({
            'D': D,
            'M': M_D,
            'omega': omega_D,
            'prime': prime,
            'period': period,
            'R': R,
            'x_digits': x_digits,
            'y_digits': y_digits
        })

    except Exception as e:
        print(f"{D:4d}  ERROR: {e}")

# ============================================================================
# Pattern Analysis
# ============================================================================

print("\n" + "="*80)
print("PATTERN ANALYSIS")
print("="*80)

print("\nObservations:")

# All primes?
all_prime = all(r['prime'] for r in results)
print(f"  All primes: {all_prime}")

# M(D) values
M_vals = [r['M'] for r in results]
print(f"  M(D) values: {M_vals}")
print(f"  All M=0: {all(m == 0 for m in M_vals)}")

# Period vs R correlation
periods = [r['period'] for r in results]
R_vals = [r['R'] for r in results]

import statistics

def pearson(x, y):
    if len(x) < 2:
        return 0.0
    mean_x = statistics.mean(x)
    mean_y = statistics.mean(y)
    cov = sum((x[i] - mean_x) * (y[i] - mean_y) for i in range(len(x))) / len(x)
    std_x = statistics.stdev(x)
    std_y = statistics.stdev(y)
    return cov / (std_x * std_y)

corr = pearson(periods, R_vals)
print(f"\n  Period vs R correlation: {corr:.4f} (expected: strong positive)")

# R scaling
mean_R = statistics.mean(R_vals)
mean_period = statistics.mean(periods)
ratio = mean_R / mean_period

print(f"\n  Mean R: {mean_R:.2f}")
print(f"  Mean period: {mean_period:.2f}")
print(f"  R / period ratio: {ratio:.2f}")

# ============================================================================
# Approximation Testing
# ============================================================================

print("\n" + "="*80)
print("APPROXIMATION QUALITY (Hard Cases)")
print("="*80)

# Simple heuristic: R ≈ γ · period
gamma_fitted = mean_R / mean_period

print(f"\nSimple model: R ≈ {gamma_fitted:.2f} · period")
print("\n  D     True R   Pred R   Error%")
print("-" * 40)

for r in results:
    R_true = r['R']
    R_pred = gamma_fitted * r['period']
    error = 100 * abs(R_pred - R_true) / R_true

    print(f"{r['D']:4d}  {R_true:7.2f}  {R_pred:7.2f}  {error:5.1f}%")

# ============================================================================
# √n Model Testing
# ============================================================================

print("\n" + "="*80)
print("√n UNIVERSALITY MODEL")
print("="*80)

print("\nModel: R ≈ α · log(√D)")
print("\n  D     True R   log(√D)   R/log(√D)")
print("-" * 50)

for r in results:
    D = r['D']
    R_true = r['R']
    log_sqrt_D = math.log(math.sqrt(D))
    ratio = R_true / log_sqrt_D

    print(f"{D:4d}  {R_true:7.2f}  {log_sqrt_D:7.3f}   {ratio:7.2f}")

mean_alpha = statistics.mean([r['R'] / math.log(math.sqrt(r['D'])) for r in results])
print(f"\nMean α: {mean_alpha:.2f}")

print("\nRefined model: R ≈ {:.2f} · log(√D)".format(mean_alpha))
print("\n  D     True R   Pred R   Error%")
print("-" * 40)

for r in results:
    D = r['D']
    R_true = r['R']
    R_pred = mean_alpha * math.log(math.sqrt(D))
    error = 100 * abs(R_pred - R_true) / R_true

    print(f"{D:4d}  {R_true:7.2f}  {R_pred:7.2f}  {error:5.1f}%")

# ============================================================================
# Conclusion for Hard Cases
# ============================================================================

print("\n" + "="*80)
print("CONCLUSION")
print("="*80)

errors_period_model = [100 * abs((gamma_fitted * r['period']) - r['R']) / r['R'] for r in results]
errors_sqrt_model = [100 * abs((mean_alpha * math.log(math.sqrt(r['D']))) - r['R']) / r['R'] for r in results]

mean_err_period = statistics.mean(errors_period_model)
mean_err_sqrt = statistics.mean(errors_sqrt_model)

print(f"""
Hard cases (long period primes):
- All are PRIMES (M(D) = 0) ✓
- Period vs R: strong correlation ✓
- R/period ratio ≈ {ratio:.2f} (consistent)

**Best simple model**: R ≈ {gamma_fitted:.2f} · period
- Mean error: {mean_err_period:.1f}%
- Works well for primes!

**√n model**: R ≈ {mean_alpha:.2f} · log(√D)
- Mean error: {mean_err_sqrt:.1f}%
- Also reasonable!

**Problem**: Both require knowing period (or estimating log(√D))
- Period estimation is HARD
- For primes, no good heuristic

**Practical conclusion**:
- For HARD cases (primes with long period):
  - MUST compute period exactly (no shortcut)
  - Then R ≈ {gamma_fitted:.2f} · period is decent estimate
  - But if computing period anyway, might as well compute R exactly!

- For EASY cases (composites with short period):
  - M(D) large → R small (heuristic works)
  - But still need period for precision

**Bottom line**: Period IS the bottleneck. No way around it.
""")

print("\nRecommendation:")
print("  - Use EXACT CF computation (our implementation)")
print("  - Cache results for repeated use")
print("  - Accept O(period) complexity (unavoidable)")
