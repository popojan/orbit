#!/usr/bin/env python3
"""
Compute class number h(p) for Q(√p) and correlate with mod 8 class.

Test hypothesis: mod 8 class of p determines structural properties of Q(√p)
including class number, 2-rank, and fundamental unit congruences.

Class number formula:
    h(p) = (√p / (2·R(p))) · L(1, χ)

where:
    R(p) = log(x₀ + y₀√p) is the regulator
    L(1, χ) = Σ_{n=1}^∞ χ(n)/n is Dirichlet L-function with χ = (p/·)
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

def kronecker_symbol(a, n):
    """Compute Kronecker symbol (a/n)."""
    if n == 0:
        return 1 if abs(a) == 1 else 0
    if n == 1:
        return 1
    if n == -1:
        return -1 if a < 0 else 1

    # Handle negative n
    if n < 0:
        return kronecker_symbol(a, -n) * (-1 if a < 0 else 1)

    # Remove factors of 2 from n
    if n % 2 == 0:
        if a % 2 == 0:
            return 0
        v = 0
        n_odd = n
        while n_odd % 2 == 0:
            v += 1
            n_odd //= 2
        # (a/2) = 1 if a ≡ ±1 (mod 8), -1 if a ≡ ±3 (mod 8)
        a_mod8 = a % 8
        if a_mod8 in [1, 7]:
            two_part = 1
        elif a_mod8 in [3, 5]:
            two_part = -1
        else:
            two_part = 0
        return (two_part ** v) * kronecker_symbol(a, n_odd)

    # Now n is odd, use quadratic reciprocity
    if a == 0:
        return 0
    if a == 1:
        return 1
    if a == -1:
        return 1 if n % 4 == 1 else -1
    if a == 2:
        return 1 if n % 8 in [1, 7] else -1

    # Reduce a mod n
    a = a % n
    if a == 0:
        return 0

    # Remove factors of 2 from a
    v = 0
    while a % 2 == 0:
        v += 1
        a //= 2
    if a % 2 == 0:
        return 0

    result = 1
    if v % 2 == 1:
        if n % 8 in [3, 5]:
            result = -result

    # Quadratic reciprocity for odd a, n
    if a % 4 == 3 and n % 4 == 3:
        result = -result

    if a == 1:
        return result

    return result * kronecker_symbol(n, a)

def dirichlet_L_1(p, terms=10000):
    """
    Compute L(1, χ) where χ(n) = (p/n) is Kronecker symbol.

    L(1, χ) = Σ_{n=1}^∞ χ(n)/n
    """
    total = Decimal(0)
    for n in range(1, terms + 1):
        chi_n = kronecker_symbol(p, n)
        total += Decimal(chi_n) / Decimal(n)
    return float(total)

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

def regulator_and_unit(p):
    """Compute regulator R(p) and fundamental unit (x₀, y₀)."""
    cf = continued_fraction_sqrt(p)

    if cf['period_length'] == 0:
        return 0.0, 1, 0  # Perfect square

    period = cf['period']
    n = len(period)

    # Generate enough convergents
    convergents = cf_convergents(cf['a0'], period, num_convergents=2*n+1)

    # Check convergent at position n-1 (for odd period) or 2n-1 (for even)
    # For odd period: may give negative Pell x² - py² = -1
    # For even period: gives positive Pell x² - py² = 1

    x0, y0 = None, None

    if n % 2 == 1:
        # Odd period: convergent n-1 gives solution to x² - py² = -1
        # Need to square it: (x + y√p)² = x² + 2xy√p + py² = (x²+py²) + 2xy√p
        p_neg, q_neg = convergents[n-1]
        # Check if it's negative Pell
        if p_neg**2 - p * q_neg**2 == -1:
            # Square it to get positive Pell
            x0 = p_neg**2 + p * q_neg**2
            y0 = 2 * p_neg * q_neg
        elif p_neg**2 - p * q_neg**2 == 1:
            # Already positive Pell
            x0, y0 = p_neg, q_neg
        else:
            # Try 2n-1
            p_conv, q_conv = convergents[2*n-1]
            if p_conv**2 - p * q_conv**2 == 1:
                x0, y0 = p_conv, q_conv
    else:
        # Even period: convergent 2n-1 gives positive Pell
        p_conv, q_conv = convergents[2*n-1]
        if p_conv**2 - p * q_conv**2 == 1:
            x0, y0 = p_conv, q_conv

    if x0 is None:
        raise ValueError(f"Could not find Pell solution for p={p}")

    # Verify it's a solution
    if x0**2 - p * y0**2 != 1:
        raise ValueError(f"Not a valid Pell solution for p={p}: {x0}² - {p}·{y0}² = {x0**2 - p*y0**2}")

    # Compute regulator
    p_dec = Decimal(p)
    x0_dec = Decimal(x0)
    y0_dec = Decimal(y0)

    sqrt_p = p_dec.sqrt()
    epsilon = x0_dec + y0_dec * sqrt_p

    R = float(epsilon.ln())

    return R, x0, y0

def class_number(p):
    """
    Compute class number h(p) for Q(√p).

    Formula: h(p) = (√p / (2·R(p))) · L(1, χ)
    """
    R, x0, y0 = regulator_and_unit(p)

    if R == 0:
        return None  # Perfect square

    L_1 = dirichlet_L_1(p, terms=10000)

    sqrt_p = math.sqrt(p)
    h = (sqrt_p / (2 * R)) * L_1

    return round(h), R, x0, y0, L_1

# ============================================================================
# Main Analysis
# ============================================================================

print("="*80)
print("CLASS NUMBER h(p) vs MOD 8 STRATIFICATION")
print("="*80)
print()

# Collect data for primes p < 200 (smaller range for speed)
primes = [p for p in range(3, 200) if is_prime(p)]

data_mod1 = []
data_mod3 = []
data_mod7 = []

print(f"Computing class numbers for {len(primes)} primes...")
print()

for p in primes:
    try:
        result = class_number(p)
        if result is None:
            continue

        h_p, R, x, y, L_1 = result
        period = continued_fraction_sqrt(p)['period_length']
        x_mod_p = x % p

        entry = {
            'p': p,
            'h': h_p,
            'R': R,
            'L_1': L_1,
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

        # Print progress for interesting cases
        if h_p > 1:
            print(f"  p={p} (mod 8: {p%8}): h={h_p}, R={R:.3f}, x≡{'+1' if x_mod_p==1 else '-1'} (mod p)")

    except Exception as e:
        print(f"Failed for p={p}: {e}")

print()
print("="*80)
print("STATISTICS BY MOD 8 CLASS")
print("="*80)
print()

for mod_class, data, label in [(1, data_mod1, "p ≡ 1 (mod 8)"),
                                 (3, data_mod3, "p ≡ 3 (mod 8)"),
                                 (7, data_mod7, "p ≡ 7 (mod 8)")]:
    if len(data) == 0:
        continue

    h_vals = [d['h'] for d in data]
    R_vals = [d['R'] for d in data]
    period_vals = [d['period'] for d in data]

    mean_h = statistics.mean(h_vals)
    mean_R = statistics.mean(R_vals)
    mean_period = statistics.mean(period_vals)

    # Count h=1 vs h>1
    h_eq_1 = sum(1 for h in h_vals if h == 1)
    h_gt_1 = sum(1 for h in h_vals if h > 1)

    # Check x mod p pattern
    x_plus1 = sum(1 for d in data if d['x_mod_p'] == 1)
    x_minus1 = sum(1 for d in data if d['x_mod_p'] == d['p'] - 1)

    print(f"{label}:")
    print(f"  Count: {len(data)}")
    print(f"  Mean h(p): {mean_h:.3f}")
    print(f"  h=1: {h_eq_1}/{len(data)} = {100*h_eq_1/len(data):.1f}%")
    print(f"  h>1: {h_gt_1}/{len(data)} = {100*h_gt_1/len(data):.1f}%")
    print(f"  Mean R(p): {mean_R:.4f}")
    print(f"  Mean period: {mean_period:.2f}")
    print(f"  x ≡ +1 (mod p): {x_plus1}/{len(data)} = {100*x_plus1/len(data):.1f}%")
    print(f"  x ≡ -1 (mod p): {x_minus1}/{len(data)} = {100*x_minus1/len(data):.1f}%")
    print()

print("="*80)
print("PRIMES WITH h(p) > 1")
print("="*80)
print()

all_data = data_mod1 + data_mod3 + data_mod7
large_h = [d for d in all_data if d['h'] > 1]
large_h.sort(key=lambda d: d['h'], reverse=True)

print("   p    h(p)   mod 8  period  x mod p")
print("-" * 45)
for d in large_h[:20]:  # Top 20
    x_mod_label = "+1" if d['x_mod_p'] == 1 else "-1"
    print(f"{d['p']:4d}   {d['h']:3d}     {d['p']%8}      {d['period']:4d}     {x_mod_label}")

print()
print("="*80)
print("CONCLUSION")
print("="*80)
print()
print("Question: Does mod 8 class correlate with h(p)?")
print("Answer: [See statistics above]")
print()
print("Key observations:")
print("1. h(p) > 1 is relatively rare for small primes")
print("2. Check if h(p) > 1 primes cluster in specific mod 8 classes")
print("3. Connection to x ≡ ±1 (mod p) pattern")
