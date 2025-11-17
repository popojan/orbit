#!/usr/bin/env python3
"""
Deep exploration of p ≡ 3 (mod 8) case for x₀ ≡ -1 (mod p) conjecture.

Goal: Find structural patterns that might lead to rigorous proof.
"""

import math

def is_prime(n):
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

def cf_sqrt(D, max_iter=10000):
    """Compute continued fraction expansion of √D."""
    a0 = int(math.sqrt(D))
    if a0 * a0 == D:
        return None

    seen = {}
    period = []
    convergents = []
    m, d, a = 0, 1, a0

    # Track convergents
    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1
    convergents.append((a0, 1))

    for k in range(max_iter):
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d

        # Compute convergent
        p_next = a * p_curr + p_prev
        q_next = a * q_curr + q_prev
        convergents.append((p_next, q_next))

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

        state = (m, d)
        if state in seen:
            period_start = seen[state]
            return {
                'a0': a0,
                'period': period[period_start:],
                'n': len(period[period_start:]),
                'convergents': convergents,
                'period_start': period_start
            }
        seen[state] = len(period)
        period.append(a)

    return None

def fundamental_pell(p):
    """Find fundamental Pell solution for x² - py² = 1."""
    cf = cf_sqrt(p)
    if cf is None:
        return None

    n = cf['n']

    # For p ≡ 3 (mod 4), period is even, solution at position n-1
    if p % 4 == 3:
        pos = n - 1
    else:
        # p ≡ 1 (mod 4), check if negative Pell exists
        pos = n - 1
        if pos < len(cf['convergents']):
            x, y = cf['convergents'][pos]
            if x*x - p*y*y == -1:
                # Negative Pell exists, square it
                x0 = x*x + p*y*y
                y0 = 2*x*y
                return (x0, y0)
        # Otherwise use position 2n-1
        pos = 2*n - 1

    if pos >= len(cf['convergents']):
        return None

    x0, y0 = cf['convergents'][pos]

    # Verify
    if x0*x0 - p*y0*y0 != 1:
        return None

    return (x0, y0)

def analyze_cf_symmetry(p):
    """Analyze CF period symmetry for p ≡ 3 (mod 8)."""
    cf = cf_sqrt(p)
    if cf is None:
        return None

    period = cf['period']
    n = len(period)

    # Check palindrome structure
    is_palindrome = period == period[::-1]

    # Analyze first half vs second half
    half = n // 2
    first_half = period[:half]
    second_half = period[half:n-1] if period[-1] == 2*cf['a0'] else period[half:]

    return {
        'period': period,
        'n': n,
        'is_palindrome': is_palindrome,
        'first_half': first_half,
        'second_half': second_half,
        'a0': cf['a0']
    }

def compute_partial_products(p):
    """Compute products of convergents at special positions."""
    sol = fundamental_pell(p)
    if sol is None:
        return None

    x0, y0 = sol
    cf = cf_sqrt(p)
    n = cf['n']

    # Positions of interest
    positions = {
        'n/2': n // 2 - 1,
        'n': n - 1,
        '3n/2': 3*n//2 - 1,
        '2n': 2*n - 1
    }

    results = {}
    for name, pos in positions.items():
        if pos < len(cf['convergents']):
            x, y = cf['convergents'][pos]
            norm = x*x - p*y*y
            x_mod_p = x % p
            results[name] = {
                'x': x,
                'y': y,
                'norm': norm,
                'x_mod_p': x_mod_p,
                'x_mod_8': x % 8
            }

    return results

def test_quadratic_form_theory(p):
    """Test if x₀ relates to specific quadratic form representations."""
    sol = fundamental_pell(p)
    if sol is None:
        return None

    x0, y0 = sol

    # Check various quadratic forms
    forms = {}

    # Form 1: x² + y²
    # Check if p or related values are sum of two squares
    for a in range(1, int(math.sqrt(p)) + 2):
        b_sq = p - a*a
        if b_sq > 0:
            b = int(math.sqrt(b_sq))
            if b*b == b_sq:
                forms['p_as_sum'] = (a, b)
                break

    # Form 2: x² + 2y²
    for a in range(1, int(math.sqrt(p)) + 2):
        b_sq = (p - a*a) // 2
        if b_sq > 0 and (p - a*a) % 2 == 0:
            b = int(math.sqrt(b_sq))
            if 2*b*b == p - a*a:
                forms['p_as_x2_plus_2y2'] = (a, b)
                break

    # Form 3: Check if x₀ + 1 or x₀ - 1 has special form
    for val, name in [(x0 + 1, 'x0+1'), (x0 - 1, 'x0-1'), (p*y0*y0, 'py02')]:
        # Check if it's a perfect square
        sqrt_val = int(math.sqrt(val))
        if sqrt_val * sqrt_val == val:
            forms[f'{name}_square'] = sqrt_val

    return forms

# ============================================================================
# Main Analysis
# ============================================================================

print("="*80)
print("DEEP ANALYSIS: p ≡ 3 (mod 8) Structure")
print("="*80)
print()

# Test primes p ≡ 3 (mod 8)
test_primes = [p for p in range(3, 200) if is_prime(p) and p % 8 == 3]

print(f"Testing {len(test_primes)} primes p ≡ 3 (mod 8)")
print()

# Analysis 1: CF Period Structure
print("="*80)
print("1. CONTINUED FRACTION PERIOD STRUCTURE")
print("="*80)
print()

print("   p   period  a0  palindrome?  period_mod_4")
print("-"*60)

for p in test_primes[:15]:
    sym = analyze_cf_symmetry(p)
    if sym:
        is_pal = "YES" if sym['is_palindrome'] else "NO"
        print(f"{p:4d}   {sym['n']:4d}   {sym['a0']:3d}      {is_pal:3s}         {sym['n'] % 4}")

print()

# Analysis 2: Special Convergent Values
print("="*80)
print("2. CONVERGENT VALUES AT SPECIAL POSITIONS")
print("="*80)
print()

print("Testing: Do convergents at n/2 have special x mod p value?")
print()
print("   p   period  x_{n/2} mod p   x_0 mod p   pattern")
print("-"*65)

for p in test_primes[:20]:
    products = compute_partial_products(p)
    sol = fundamental_pell(p)
    if products and sol:
        x0, y0 = sol
        x0_mod_p = x0 % p

        if 'n/2' in products:
            x_half_mod_p = products['n/2']['x_mod_p']

            # Check for patterns
            pattern = ""
            if x_half_mod_p == x0_mod_p:
                pattern = "x_{n/2} = x_0 mod p"
            elif x_half_mod_p == (p - x0_mod_p):
                pattern = "x_{n/2} = -x_0 mod p"
            elif (x_half_mod_p * x_half_mod_p) % p == x0_mod_p:
                pattern = "x_{n/2}² = x_0 mod p"

            cf = cf_sqrt(p)
            print(f"{p:4d}   {cf['n']:4d}      {x_half_mod_p:4d}         {x0_mod_p:4d}      {pattern}")

print()

# Analysis 3: Quadratic Form Connections
print("="*80)
print("3. QUADRATIC FORM REPRESENTATIONS")
print("="*80)
print()

print("Can p ≡ 3 (mod 8) be written in special forms?")
print()
print("   p   x²+y²  x²+2y²  (x0+1) is square?  (x0-1) is square?")
print("-"*70)

for p in test_primes[:20]:
    forms = test_quadratic_form_theory(p)
    sol = fundamental_pell(p)

    if forms and sol:
        x0, y0 = sol

        sum_sq = "YES" if 'p_as_sum' in forms else "NO"
        sum_2sq = "YES" if 'p_as_x2_plus_2y2' in forms else "NO"
        x0p1_sq = "YES" if 'x0+1_square' in forms else "NO"
        x0m1_sq = "YES" if 'x0-1_square' in forms else "NO"

        print(f"{p:4d}   {sum_sq:4s}   {sum_2sq:5s}       {x0p1_sq:3s}               {x0m1_sq:3s}")

print()

# Analysis 4: Relationship with x₀ mod 8
print("="*80)
print("4. x₀ mod 8 vs x₀ mod p RELATIONSHIP")
print("="*80)
print()

print("For p ≡ 3 (mod 8), we know x₀ ≡ 2 (mod 8).")
print("Testing: Is there a deterministic rule?")
print()
print("   p   x0_mod_8  x0_mod_p  (x0+1)/2 mod p  gcd(x0+1,p)")
print("-"*70)

for p in test_primes[:20]:
    sol = fundamental_pell(p)
    if sol:
        x0, y0 = sol
        x0_mod_8 = x0 % 8
        x0_mod_p = x0 % p

        # Check if (x0+1)/2 has special property
        if (x0 + 1) % 2 == 0:
            half = ((x0 + 1) // 2) % p
        else:
            half = "N/A"

        g = math.gcd(x0 + 1, p)

        print(f"{p:4d}      {x0_mod_8}        {x0_mod_p:4d}          {half}           {g}")

print()

# Analysis 5: Connection to 2-adic Structure
print("="*80)
print("5. 2-ADIC STRUCTURE")
print("="*80)
print()

print("For p ≡ 3 (mod 8): (2/p) = -1 (2 is NOT quadratic residue)")
print("Testing: Does this force x₀ ≡ -1 (mod p)?")
print()

print("   p   (2/p)  x0²mod p  (x0+1)(x0-1)mod p  py0² mod p")
print("-"*70)

def legendre_symbol(a, p):
    """Compute Legendre symbol (a/p)."""
    if p == 2:
        return 1
    a = a % p
    if a == 0:
        return 0
    result = pow(a, (p - 1) // 2, p)
    return -1 if result == p - 1 else result

for p in test_primes[:20]:
    sol = fundamental_pell(p)
    if sol:
        x0, y0 = sol

        leg_2 = legendre_symbol(2, p)
        x0_sq_mod_p = (x0 * x0) % p
        product = ((x0 + 1) * (x0 - 1)) % p
        py0_sq = (p * y0 * y0) % p

        print(f"{p:4d}   {leg_2:+2d}      {x0_sq_mod_p}          {product}             {py0_sq}")

print()

print("="*80)
print("SUMMARY")
print("="*80)
print()
print("Key observations to investigate:")
print("1. CF period structure (always ≡ 2 mod 4)")
print("2. Convergent values at special positions")
print("3. Relationship between x₀ mod 8 and x₀ mod p")
print("4. 2-adic constraints from (2/p) = -1")
print("5. Possible connection to quadratic forms")
