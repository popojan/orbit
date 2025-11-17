#!/usr/bin/env python3
"""
Compute Hilbert symbols (x₀, p)₂ for fundamental Pell solutions.

Test hypothesis: Hilbert symbol at p=2 distinguishes mod 8 classes
and explains x₀ ≡ ±1 (mod p) pattern.

Hilbert symbol (a,b)₂ = ±1 encodes local solvability of x² - ay² = bz² over Q₂.

Explicit formula (from Serre, "A Course in Arithmetic"):
    (a,b)₂ = (-1)^ε(a,b)

where ε(a,b) = ω(a)·ω(b) + ν₂(a)·ε(b) + ν₂(b)·ε(a)

and:
    ω(a) = (a-1)/2 mod 2  [a ≡ 1 or 3 (mod 4)]
    ε(a) = (a²-1)/8 mod 2  [a ≡ ±1 or ±3 (mod 8)]
    ν₂(a) = 2-adic valuation
"""

import math

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

def v2(n):
    """2-adic valuation: largest k such that 2^k divides n."""
    if n == 0:
        return float('inf')
    k = 0
    while n % 2 == 0:
        k += 1
        n //= 2
    return k

def omega(a):
    """ω(a) = (a-1)/2 mod 2, defined for odd a."""
    if a % 2 == 0:
        raise ValueError("omega requires odd input")
    return ((a - 1) // 2) % 2

def epsilon(a):
    """ε(a) = (a²-1)/8 mod 2, defined for odd a."""
    if a % 2 == 0:
        raise ValueError("epsilon requires odd input")
    return ((a * a - 1) // 8) % 2

def hilbert_symbol_2(a, b):
    """
    Compute 2-adic Hilbert symbol (a,b)₂.

    Returns +1 or -1.

    Formula (Serre): (a,b)₂ = (-1)^E where
        E = ω(a)·ω(b) + ν₂(a)·ε(b) + ν₂(b)·ε(a)

    Here a, b are nonzero integers, and we compute modulo 2-adic units.
    """
    # Handle signs and extract 2-adic valuation
    sign_a = 1 if a > 0 else -1
    sign_b = 1 if b > 0 else -1

    a_abs = abs(a)
    b_abs = abs(b)

    v2_a = v2(a_abs)
    v2_b = v2(b_abs)

    # Reduce to odd parts
    a_odd = a_abs // (2 ** v2_a)
    b_odd = b_abs // (2 ** v2_b)

    # Sign contribution (from Serre's formula, needs adjustment for negative inputs)
    # For negative a or b, use (−1, −1)₂ = -1
    sign_contrib = 0
    if sign_a == -1 and sign_b == -1:
        sign_contrib = 1

    # Main formula
    E = omega(a_odd) * omega(b_odd) + v2_a * epsilon(b_odd) + v2_b * epsilon(a_odd) + sign_contrib

    return (-1) ** (E % 2)

def cf_sqrt(D):
    """Compute continued fraction expansion of √D."""
    a0 = int(math.sqrt(D))
    if a0 * a0 == D:
        return None  # Perfect square

    seen = {}
    period = []
    m, d, a = 0, 1, a0

    for k in range(10000):
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d
        state = (m, d)
        if state in seen:
            return {'a0': a0, 'period': period[seen[state]:], 'n': len(period[seen[state]:])}
        seen[state] = len(period)
        period.append(a)

    raise ValueError(f"CF period not found for {D}")

def convergent(a0, period, k):
    """Compute k-th convergent of CF [a0; period]."""
    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1
    for i in range(k):
        a_k = period[i % len(period)]
        p_next = a_k * p_curr + p_prev
        q_next = a_k * q_curr + q_prev
        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next
    return p_curr, q_curr

def fundamental_unit(p):
    """Compute fundamental Pell solution (x₀, y₀) for x² - py² = 1."""
    cf = cf_sqrt(p)
    if cf is None:
        return None

    n = cf['n']

    # Check convergent at position n-1
    x1, y1 = convergent(cf['a0'], cf['period'], n-1)
    norm1 = x1**2 - p * y1**2

    if norm1 == 1:
        # Already positive Pell
        return x1, y1
    elif norm1 == -1:
        # Negative Pell, square it
        x0 = x1**2 + p * y1**2
        y0 = 2 * x1 * y1
        return x0, y0
    else:
        # Try 2n-1
        x0, y0 = convergent(cf['a0'], cf['period'], 2*n-1)
        if x0**2 - p * y0**2 == 1:
            return x0, y0
        else:
            raise ValueError(f"Could not find fundamental unit for p={p}")

# ============================================================================
# Main Analysis
# ============================================================================

print("="*80)
print("HILBERT SYMBOL (x₀, p)₂ ANALYSIS")
print("="*80)
print()

# Test primes by mod 8 class
test_primes = {
    1: [17, 41, 73, 89, 97, 113, 137],
    3: [3, 11, 19, 43, 59, 67, 83],
    7: [7, 23, 31, 47, 71, 79, 103]
}

for mod8_class in [1, 3, 7]:
    primes = test_primes[mod8_class]

    print(f"p ≡ {mod8_class} (mod 8):")
    print("="*80)
    print("   p      x₀ mod p    x₀ mod 8    p mod 8   (x₀,p)₂   Interpretation")
    print("-"*80)

    results = []

    for p in primes:
        try:
            x0, y0 = fundamental_unit(p)

            x0_mod_p = x0 % p
            x0_mod_8 = x0 % 8
            p_mod_8 = p % 8

            # Compute Hilbert symbol (x₀, p)₂
            hilb = hilbert_symbol_2(x0, p)

            x0_sign = "+1" if x0_mod_p == 1 else ("-1" if x0_mod_p == p-1 else str(x0_mod_p))
            hilb_str = "+1" if hilb == 1 else "-1"

            interp = "split" if hilb == 1 else "nonsplit"

            results.append((p, x0_mod_p, x0_mod_8, hilb))

            print(f"{p:4d}      {x0_sign:>4s}        {x0_mod_8}           {p_mod_8}        {hilb_str:>4s}     {interp}")

        except Exception as e:
            print(f"{p:4d}   ERROR: {e}")

    # Summary statistics
    print()
    print("Summary:")
    plus_one_hilb = sum(1 for _, _, _, h in results if h == 1)
    minus_one_hilb = sum(1 for _, _, _, h in results if h == -1)

    plus_one_mod_p = sum(1 for _, xmod, _, _ in results if xmod == 1)
    minus_one_mod_p = sum(1 for p, xmod, _, _ in results if xmod == p - 1)

    print(f"  (x₀,p)₂ = +1: {plus_one_hilb}/{len(results)}")
    print(f"  (x₀,p)₂ = -1: {minus_one_hilb}/{len(results)}")
    print(f"  x₀ ≡ +1 (mod p): {plus_one_mod_p}/{len(results)}")
    print(f"  x₀ ≡ -1 (mod p): {minus_one_mod_p}/{len(results)}")
    print()
    print()

print("="*80)
print("CONCLUSION")
print("="*80)
print()
print("Question: Does (x₀,p)₂ correlate with x₀ mod p pattern?")
print("Answer: [See data above]")
print()
print("Expected correlation:")
print("  - p ≡ 7 (mod 8) with x₀ ≡ +1 (mod p): specific (x₀,p)₂ value?")
print("  - p ≡ 1,3 (mod 8) with x₀ ≡ -1 (mod p): different (x₀,p)₂ value?")
