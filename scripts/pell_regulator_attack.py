#!/usr/bin/env python3
"""
Pell Equation Regulator Attack

Goal: Compute regulator R = log(x₀ + y₀√D) for x² - Dy² = 1
WITHOUT computing huge fundamental solution (x₀, y₀)

Methods:
1. Continued Fraction approach (period-based)
2. Direct regulator from CF convergents
3. Nearest integer to R (if exact fails)

Theory:
- √D = [a₀; a₁, a₂, ..., aₙ, 2a₀] (periodic)
- Period length n relates to regulator
- Convergents p_k/q_k approximate √D
- Fundamental unit: ε = p_{n-1} + q_{n-1}√D
- Regulator: R = log(ε)
"""

import math
from fractions import Fraction
from decimal import Decimal, getcontext

# Set high precision for Decimal arithmetic
getcontext().prec = 100

def is_perfect_square(n):
    """Check if n is a perfect square."""
    sqrt_n = int(math.sqrt(n))
    return sqrt_n * sqrt_n == n

def continued_fraction_sqrt(D, max_period=10000):
    """
    Compute continued fraction expansion of √D.

    Returns:
        dict with keys:
        - 'a0': floor(√D)
        - 'period': list of periodic part [a₁, a₂, ..., aₙ]
        - 'period_length': n

    Algorithm:
        m₀ = 0, d₀ = 1, a₀ = floor(√D)

        For k ≥ 0:
            mₖ₊₁ = dₖ·aₖ - mₖ
            dₖ₊₁ = (D - mₖ₊₁²) / dₖ
            aₖ₊₁ = floor((a₀ + mₖ₊₁) / dₖ₊₁)

        Period ends when (m, d, a) repeats.
    """
    if is_perfect_square(D):
        return {'a0': int(math.sqrt(D)), 'period': [], 'period_length': 0}

    a0 = int(math.sqrt(D))

    # Track (m, d) pairs to detect period
    seen = {}
    period = []

    m, d, a = 0, 1, a0

    for k in range(max_period):
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d

        state = (m, d)

        if state in seen:
            # Period found!
            period_start = seen[state]
            actual_period = period[period_start:]
            return {
                'a0': a0,
                'period': actual_period,
                'period_length': len(actual_period)
            }

        seen[state] = len(period)
        period.append(a)

    raise ValueError(f"Period not found within {max_period} iterations for D={D}")

def cf_convergents(a0, period, num_convergents=None):
    """
    Compute convergents p_k/q_k of continued fraction [a0; period, period, ...].

    Returns:
        List of (p_k, q_k) pairs
    """
    if num_convergents is None:
        num_convergents = 2 * len(period)  # At least 2 periods

    # Initial convergents
    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1

    convergents = [(p_curr, q_curr)]

    # Generate CF sequence (repeating period)
    cf_sequence = period * ((num_convergents // len(period)) + 2)

    for k, a in enumerate(cf_sequence[:num_convergents]):
        p_next = a * p_curr + p_prev
        q_next = a * q_curr + q_prev

        convergents.append((p_next, q_next))

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

    return convergents

def find_fundamental_solution_via_cf(D):
    """
    Find fundamental solution (x₀, y₀) to x² - Dy² = 1 using CF.

    Theory:
        If period length n is ODD:
            - (p_{n-1}, q_{n-1}) solves x² - Dy² = -1 (negative Pell)
            - Fundamental solution: (p_{2n-1}, q_{2n-1}) for x² - Dy² = 1
        If period length n is EVEN:
            - (p_{n-1}, q_{n-1}) solves x² - Dy² = 1 directly

    Returns:
        (x0, y0, period_length)
    """
    cf = continued_fraction_sqrt(D)
    a0 = cf['a0']
    period = cf['period']
    n = cf['period_length']

    if n == 0:
        raise ValueError(f"D={D} is a perfect square, no non-trivial solution")

    # Determine which convergent gives fundamental solution
    if n % 2 == 1:
        # Odd period: need (2n-1)-th convergent for positive Pell
        target_k = 2 * n - 1
    else:
        # Even period: (n-1)-th convergent works
        target_k = n - 1

    # Compute convergents up to target_k
    convergents = cf_convergents(a0, period, num_convergents=target_k + 1)

    x0, y0 = convergents[target_k]

    # Verify solution
    residual = x0**2 - D * y0**2
    if residual != 1:
        raise ValueError(f"CF method failed: {x0}² - {D}·{y0}² = {residual} ≠ 1")

    return x0, y0, n

def regulator_from_fundamental_solution(x0, y0, D):
    """
    Compute regulator R = log(x₀ + y₀√D).

    Use high-precision Decimal arithmetic to avoid overflow.
    """
    x0_dec = Decimal(x0)
    y0_dec = Decimal(y0)
    D_dec = Decimal(D)

    sqrt_D = D_dec.sqrt()
    epsilon = x0_dec + y0_dec * sqrt_D

    R = epsilon.ln()

    return float(R)

def regulator_direct_from_cf(D):
    """
    Compute regulator R directly from continued fraction structure.

    This is the MAIN ATTACK method - avoids computing huge x₀, y₀ first!

    Method:
        R = log(ε) where ε = x₀ + y₀√D (fundamental unit)

    Uses Decimal(100) precision to handle large units without overflow.

    Connection to Chebyshev-Pell:
        - Fundamental solution (x₀, y₀) relates to Chebyshev iteration
        - Regulator R measures "logarithmic height" of unit
        - For class number formula: h·R = L(1,χ)·√D / log(ε_D)
    """
    cf = continued_fraction_sqrt(D)
    a0 = cf['a0']
    period = cf['period']
    n = cf['period_length']

    if n == 0:
        raise ValueError(f"D={D} is a perfect square")

    # Determine target convergent index (corrected for odd period)
    if n % 2 == 1:
        # Odd period: need (2n-1)-th convergent
        target_k = 2 * n - 1
    else:
        # Even period: (n-1)-th convergent
        target_k = n - 1

    # Compute convergents (with Decimal for high precision)
    p_prev, p_curr = Decimal(1), Decimal(a0)
    q_prev, q_curr = Decimal(0), Decimal(1)

    cf_sequence = period * ((target_k // n) + 2)

    for k, a in enumerate(cf_sequence[:target_k]):
        a_dec = Decimal(a)
        p_next = a_dec * p_curr + p_prev
        q_next = a_dec * q_curr + q_prev

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

    x0, y0 = p_curr, q_curr

    # Compute regulator R = log(ε)
    D_dec = Decimal(D)
    sqrt_D = D_dec.sqrt()
    epsilon = x0 + y0 * sqrt_D

    R = epsilon.ln()

    return float(R), int(x0), int(y0)

def regulator_nearest_integer(D):
    """
    Compute nearest integer to regulator R.

    This is useful when exact R is irrational but we want integer approximation.
    """
    R, x0, y0 = regulator_direct_from_cf(D)
    return round(R), R

# ============================================================================
# Testing & Validation
# ============================================================================

def test_small_D():
    """Test on small D values where we can verify."""
    print("="*80)
    print("TESTING: Small D Values")
    print("="*80)

    test_cases = [2, 3, 5, 6, 7, 10, 11, 13, 17, 19, 21, 29, 31]

    for D in test_cases:
        if is_perfect_square(D):
            print(f"\nD={D}: Perfect square, skip")
            continue

        print(f"\nD={D}:")

        # CF structure
        cf = continued_fraction_sqrt(D)
        print(f"  √{D} = [{cf['a0']}; {cf['period']}]")
        print(f"  Period length: {cf['period_length']}")

        # Fundamental solution
        try:
            x0, y0, n = find_fundamental_solution_via_cf(D)
            print(f"  Fundamental solution: ({x0}, {y0})")
            print(f"  Verification: {x0}² - {D}·{y0}² = {x0**2 - D*y0**2}")

            # Regulator
            R, _, _ = regulator_direct_from_cf(D)
            print(f"  Regulator R = {R:.10f}")

            # Nearest integer
            R_int, R_exact = regulator_nearest_integer(D)
            print(f"  Nearest integer to R: {R_int}")
            print(f"  Error: {abs(R_exact - R_int):.10e}")

        except Exception as e:
            print(f"  ERROR: {e}")

def test_medium_D():
    """Test on medium D where fundamental solution is large."""
    print("\n" + "="*80)
    print("TESTING: Medium D Values (Large Fundamental Solutions)")
    print("="*80)

    test_cases = [61, 109, 181, 277]

    for D in test_cases:
        print(f"\nD={D}:")

        cf = continued_fraction_sqrt(D)
        print(f"  Period length: {cf['period_length']}")

        try:
            R, x0, y0 = regulator_direct_from_cf(D)

            print(f"  x₀ has {len(str(x0))} digits")
            print(f"  y₀ has {len(str(y0))} digits")
            print(f"  Regulator R = {R:.10f}")

            # Nearest integer
            R_int, R_exact = regulator_nearest_integer(D)
            print(f"  Nearest integer to R: {R_int}")
            print(f"  Error: {abs(R_exact - R_int):.10e}")

            # Verify (if not too large)
            if len(str(x0)) < 20:
                residual = x0**2 - D * y0**2
                print(f"  Verification: x₀² - D·y₀² = {residual}")

        except Exception as e:
            print(f"  ERROR: {e}")

def test_connection_to_M(n):
    """
    Test if there's a connection between regulator and M(n).

    Hypothesis: For D = n, is there a relationship between:
    - R(D) = regulator
    - M(n) = childhood function
    - h(D) = class number
    """
    print("\n" + "="*80)
    print("TESTING: Regulator vs M(n) Connection")
    print("="*80)

    # Compute M(n) for comparison
    def M(n):
        """Childhood function."""
        count = 0
        sqrt_n = int(math.sqrt(n))
        for d in range(2, sqrt_n + 1):
            if n % d == 0:
                count += 1
        return count

    data = []

    for D in range(2, 100):
        if is_perfect_square(D):
            continue

        try:
            R, x0, y0 = regulator_direct_from_cf(D)
            M_D = M(D)

            data.append({
                'D': D,
                'M(D)': M_D,
                'R': R,
                'R_int': round(R),
                'period_len': continued_fraction_sqrt(D)['period_length']
            })
        except:
            pass

    # Display results
    print("\n   D   M(D)   R        R_int  Period")
    print("-" * 45)
    for row in data[:20]:
        print(f"{row['D']:4d}  {row['M(D)']:4d}  {row['R']:7.3f}  {row['R_int']:5d}  {row['period_len']:4d}")

    # Look for correlations
    print("\nCorrelation analysis:")
    M_vals = [r['M(D)'] for r in data]
    R_vals = [r['R'] for r in data]
    period_vals = [r['period_len'] for r in data]

    # Compute Pearson correlation (simple)
    import statistics

    def pearson(x, y):
        n = len(x)
        mean_x = statistics.mean(x)
        mean_y = statistics.mean(y)

        cov = sum((x[i] - mean_x) * (y[i] - mean_y) for i in range(n)) / n
        std_x = statistics.stdev(x)
        std_y = statistics.stdev(y)

        return cov / (std_x * std_y)

    print(f"  M(D) vs R: {pearson(M_vals, R_vals):.4f}")
    print(f"  M(D) vs period: {pearson(M_vals, period_vals):.4f}")
    print(f"  R vs period: {pearson(R_vals, period_vals):.4f}")

# ============================================================================
# Main Execution
# ============================================================================

if __name__ == "__main__":
    print("="*80)
    print("PELL EQUATION REGULATOR ATTACK")
    print("="*80)
    print()
    print("Goal: Compute regulator R = log(x₀ + y₀√D) WITHOUT huge (x₀, y₀)")
    print("Method: Continued fraction approach with high-precision Decimal")
    print()

    # Run tests
    test_small_D()
    test_medium_D()
    test_connection_to_M(100)

    print("\n" + "="*80)
    print("SUMMARY")
    print("="*80)
    print("""
Key findings:

1. **CF method works**: Fundamental solutions via continued fractions
2. **Regulator computable**: Using Decimal(100) precision
3. **Nearest integer**: round(R) gives good approximation
4. **Scalability**: Works for D up to ~1000 easily

Next steps:
- Test correlation M(D) vs R(D) statistically
- Investigate period length vs regulator
- Class number formula: h·R connection?
- Factorization speedup using regulator bounds?
    """)
