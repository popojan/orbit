#!/usr/bin/env python3
"""
Test M(p) ↔ R(p) correlation with mod 8 stratification

Now that we know:
- p ≡ 7 (mod 8) → x ≡ +1 (mod p) [PROVEN]
- p ≡ 1,3 (mod 8) → x ≡ -1 (mod p) [PROVEN]

Question: Does mod 8 structure the M-R anticorrelation?
"""

import math
from fractions import Fraction
from decimal import Decimal, getcontext
import statistics

getcontext().prec = 100

def is_perfect_square(n):
    """Check if n is a perfect square."""
    sqrt_n = int(math.sqrt(n))
    return sqrt_n * sqrt_n == n

def is_prime(n):
    """Simple primality test."""
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

def M(n):
    """Childhood function: count divisors 2 ≤ d ≤ √n."""
    count = 0
    sqrt_n = int(math.sqrt(n))
    for d in range(2, sqrt_n + 1):
        if n % d == 0:
            count += 1
    return count

def continued_fraction_sqrt(D, max_period=10000):
    """Compute continued fraction expansion of √D."""
    if is_perfect_square(D):
        return {'a0': int(math.sqrt(D)), 'period': [], 'period_length': 0}

    a0 = int(math.sqrt(D))
    seen = {}
    period = []
    m, d, a = 0, 1, a0

    for k in range(max_period):
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d

        state = (m, d)
        if state in seen:
            period_start = seen[state]
            actual_period = period[period_start:]
            return {
                'a0': a0,
                'period': actual_period,
                'period_length': len(actual_period)
            }

        seen[state] = len(period)
        period.append(a)

    raise ValueError(f"Period not found for D={D}")

def cf_convergents(a0, period, num_convergents=None):
    """Compute convergents p_k/q_k."""
    if num_convergents is None:
        num_convergents = 2 * len(period)

    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1
    convergents = [(p_curr, q_curr)]

    for k in range(num_convergents):
        a_k = period[k % len(period)]
        p_next = a_k * p_curr + p_prev
        q_next = a_k * q_curr + q_prev
        convergents.append((p_next, q_next))
        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

    return convergents

def regulator_direct_from_cf(D):
    """Compute regulator R = log(x₀ + y₀√D)."""
    cf = continued_fraction_sqrt(D)

    if cf['period_length'] == 0:
        return 0.0, 1, 0  # Perfect square

    period = cf['period']
    n = len(period)

    # Fundamental solution at convergent n-1 or 2n-1
    convergents = cf_convergents(cf['a0'], period, num_convergents=2*n)

    # Try n-1 first (odd period length)
    if n % 2 == 1:
        p, q = convergents[n-1]
    else:
        p, q = convergents[2*n-1]

    x0, y0 = p, q

    # Verify it's a solution
    if x0**2 - D * y0**2 != 1:
        raise ValueError(f"Not a Pell solution for D={D}")

    # Compute regulator using high precision
    D_dec = Decimal(D)
    x0_dec = Decimal(x0)
    y0_dec = Decimal(y0)

    sqrt_D = D_dec.sqrt()
    epsilon = x0_dec + y0_dec * sqrt_D

    R = float(epsilon.ln())

    return R, x0, y0

def pearson(x, y):
    """Pearson correlation coefficient."""
    n = len(x)
    mean_x = statistics.mean(x)
    mean_y = statistics.mean(y)

    cov = sum((x[i] - mean_x) * (y[i] - mean_y) for i in range(n)) / n
    std_x = statistics.stdev(x)
    std_y = statistics.stdev(y)

    return cov / (std_x * std_y)

# ============================================================================
# Main Analysis
# ============================================================================

print("="*80)
print("M(p) ↔ R(p) CORRELATION WITH MOD 8 STRATIFICATION")
print("="*80)
print()

# Collect data for primes p < 500
primes = [p for p in range(3, 500) if is_prime(p)]

data_mod1 = []
data_mod3 = []
data_mod7 = []

print(f"Computing for {len(primes)} primes...")
print()

for p in primes:
    try:
        R, x, y = regulator_direct_from_cf(p)
        M_p = M(p)  # Should always be 0 for primes
        period = continued_fraction_sqrt(p)['period_length']

        x_mod_p = x % p

        entry = {
            'p': p,
            'M': M_p,
            'R': R,
            'period': period,
            'x': x,
            'y': y,
            'x_mod_p': x_mod_p
        }

        if p % 8 == 1:
            data_mod1.append(entry)
        elif p % 8 == 3:
            data_mod3.append(entry)
        elif p % 8 == 7:
            data_mod7.append(entry)
    except Exception as e:
        print(f"Failed for p={p}: {e}")

# Display statistics
print("="*80)
print("STATISTICS BY MOD 8 CLASS")
print("="*80)
print()

for mod_class, data, label in [(1, data_mod1, "p ≡ 1 (mod 8)"),
                                 (3, data_mod3, "p ≡ 3 (mod 8)"),
                                 (7, data_mod7, "p ≡ 7 (mod 8)")]:
    if len(data) == 0:
        continue

    R_vals = [d['R'] for d in data]
    period_vals = [d['period'] for d in data]
    x_mod_p_vals = [d['x_mod_p'] for d in data]

    mean_R = statistics.mean(R_vals)
    std_R = statistics.stdev(R_vals) if len(R_vals) > 1 else 0
    mean_period = statistics.mean(period_vals)

    # Check x mod p pattern
    x_plus1 = sum(1 for x in x_mod_p_vals if x == 1)
    x_minus1 = sum(1 for x in x_mod_p_vals if x == d['p'] - 1)

    print(f"{label}:")
    print(f"  Count: {len(data)}")
    print(f"  Mean R: {mean_R:.4f}")
    print(f"  Std R: {std_R:.4f}")
    print(f"  Mean period: {mean_period:.2f}")
    print(f"  x ≡ +1 (mod p): {x_plus1}/{len(data)} = {100*x_plus1/len(data):.1f}%")
    print(f"  x ≡ -1 (mod p): {x_minus1}/{len(data)} = {100*x_minus1/len(data):.1f}%")
    print()

# Compare R distributions
print("="*80)
print("COMPARISON: R(p) BY MOD 8 CLASS")
print("="*80)
print()

R_mod1 = [d['R'] for d in data_mod1]
R_mod3 = [d['R'] for d in data_mod3]
R_mod7 = [d['R'] for d in data_mod7]

if R_mod1 and R_mod3 and R_mod7:
    print(f"Mean R (p ≡ 1): {statistics.mean(R_mod1):.4f}")
    print(f"Mean R (p ≡ 3): {statistics.mean(R_mod3):.4f}")
    print(f"Mean R (p ≡ 7): {statistics.mean(R_mod7):.4f}")
    print()

    # ANOVA-style comparison
    grand_mean = statistics.mean(R_mod1 + R_mod3 + R_mod7)

    between_var = (len(R_mod1) * (statistics.mean(R_mod1) - grand_mean)**2 +
                   len(R_mod3) * (statistics.mean(R_mod3) - grand_mean)**2 +
                   len(R_mod7) * (statistics.mean(R_mod7) - grand_mean)**2)

    print(f"Grand mean R: {grand_mean:.4f}")
    print(f"Between-group variance: {between_var:.4f}")

    if between_var > 10:
        print("  → SIGNIFICANT difference between mod 8 classes! ⭐")
    else:
        print("  → No significant difference by mod 8")

print()
print("="*80)
print("SAMPLE DATA (first 10 from each class)")
print("="*80)
print()

for mod_class, data, label in [(1, data_mod1, "p ≡ 1 (mod 8)"),
                                (3, data_mod3, "p ≡ 3 (mod 8)"),
                                (7, data_mod7, "p ≡ 7 (mod 8)")]:
    print(f"{label}:")
    print("   p     R      Period  x mod p")
    print("-" * 40)
    for d in data[:10]:
        x_mod_label = "+1" if d['x_mod_p'] == 1 else f"{d['x_mod_p']}"
        print(f"{d['p']:4d}  {d['R']:7.3f}  {d['period']:4d}    {x_mod_label}")
    print()

print("="*80)
print("CONCLUSION")
print("="*80)
print()
print("Question: Does mod 8 structure R(p)?")
print("Answer: [See statistics above]")
print()
print("Next: Test M(D) ↔ R(D) for composites with mod 8 stratification?")
