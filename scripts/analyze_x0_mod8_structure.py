#!/usr/bin/env python3
"""
Analyze x₀ mod 8 structure for fundamental Pell solutions.

Goal: Understand WHY x₀² ≡ 0 (mod 8) implies x₀ ≡ 0 (mod 8) specifically,
not just x₀ ≡ 0,4 (mod 8).

Approach:
1. Factor x₀² = 1 + py₀² to understand 2-adic structure
2. Analyze CF convergent structure modulo 8
3. Test specific predictions
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

def v2(n):
    """2-adic valuation."""
    if n == 0:
        return float('inf')
    k = 0
    while n % 2 == 0:
        k += 1
        n //= 2
    return k

def cf_sqrt(D):
    """Compute continued fraction expansion of √D."""
    a0 = int(math.sqrt(D))
    if a0 * a0 == D:
        return None

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
    """Compute k-th convergent."""
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
    """Compute fundamental Pell solution (x₀, y₀)."""
    cf = cf_sqrt(p)
    if cf is None:
        return None

    n = cf['n']

    x1, y1 = convergent(cf['a0'], cf['period'], n-1)
    norm1 = x1**2 - p * y1**2

    if norm1 == 1:
        return x1, y1
    elif norm1 == -1:
        x0 = x1**2 + p * y1**2
        y0 = 2 * x1 * y1
        return x0, y0
    else:
        x0, y0 = convergent(cf['a0'], cf['period'], 2*n-1)
        if x0**2 - p * y0**2 == 1:
            return x0, y0
        else:
            raise ValueError(f"Could not find fundamental unit for p={p}")

# ============================================================================
# Analysis
# ============================================================================

print("="*80)
print("DETAILED x₀ mod 8 STRUCTURE ANALYSIS")
print("="*80)
print()

# Focus on p ≡ 7 (mod 8) where x₀ ≡ 0 (mod 8)
primes_mod7 = [p for p in range(7, 200) if is_prime(p) and p % 8 == 7]

print("p ≡ 7 (mod 8): Analyzing 2-adic structure")
print("="*80)
print()
print("   p    x₀ mod 16  y₀ mod 8  v₂(x₀)  v₂(y₀)  v₂(x₀²)  period  period mod 4")
print("-"*80)

for p in primes_mod7[:15]:
    x0, y0 = fundamental_unit(p)
    cf = cf_sqrt(p)
    period = cf['n']

    x0_mod16 = x0 % 16
    y0_mod8 = y0 % 8
    v2_x0 = v2(x0)
    v2_y0 = v2(y0)
    v2_x0sq = v2(x0 * x0)
    period_mod4 = period % 4

    print(f"{p:4d}     {x0_mod16:2d}        {y0_mod8}       {v2_x0}       {v2_y0}        {v2_x0sq}       {period:3d}      {period_mod4}")

print()
print("Observations:")
print("1. v₂(x₀) = 2-adic valuation of x₀ (how many factors of 2)")
print("2. If x₀ ≡ 0 (mod 8), then v₂(x₀) ≥ 3")
print("3. If x₀ ≡ 0 (mod 16), then v₂(x₀) ≥ 4")
print()

# Check other mod 8 classes
print("="*80)
print("COMPARISON: ALL MOD 8 CLASSES")
print("="*80)
print()

for mod8_class in [1, 3, 7]:
    primes = [p for p in range(3, 150) if is_prime(p) and p % 8 == mod8_class]

    print(f"p ≡ {mod8_class} (mod 8):")
    print("   p    x₀ mod 16  y₀ mod 8  v₂(x₀)  v₂(y₀)")
    print("-"*50)

    for p in primes[:7]:
        x0, y0 = fundamental_unit(p)
        x0_mod16 = x0 % 16
        y0_mod8 = y0 % 8
        v2_x0 = v2(x0)
        v2_y0 = v2(y0)

        print(f"{p:4d}     {x0_mod16:2d}        {y0_mod8}       {v2_x0}       {v2_y0}")

    print()

# Analyze x₀² = 1 + py₀² factorization
print("="*80)
print("FACTORIZATION: x₀² = 1 + py₀² (mod 32)")
print("="*80)
print()

for mod8_class in [1, 3, 7]:
    primes = [p for p in range(3, 100) if is_prime(p) and p % 8 == mod8_class]

    print(f"p ≡ {mod8_class} (mod 8):")
    print("   p    x₀² mod 32  py₀² mod 32  1+py₀² mod 32  check")
    print("-"*60)

    for p in primes[:5]:
        x0, y0 = fundamental_unit(p)

        x0sq_mod = (x0 * x0) % 32
        py0sq_mod = (p * y0 * y0) % 32
        sum_mod = (1 + p * y0 * y0) % 32

        check = "✓" if x0sq_mod == sum_mod else "✗"

        print(f"{p:4d}      {x0sq_mod:2d}          {py0sq_mod:2d}            {sum_mod:2d}          {check}")

    print()

# Pattern in y₀ mod 8
print("="*80)
print("y₀ PARITY PATTERN")
print("="*80)
print()

for mod8_class in [1, 3, 7]:
    primes = [p for p in range(3, 150) if is_prime(p) and p % 8 == mod8_class]

    y0_mods = []
    for p in primes[:10]:
        x0, y0 = fundamental_unit(p)
        y0_mods.append(y0 % 8)

    from collections import Counter
    counts = Counter(y0_mods)

    print(f"p ≡ {mod8_class} (mod 8): y₀ mod 8 distribution:")
    for mod_val in sorted(counts.keys()):
        print(f"  y₀ ≡ {mod_val} (mod 8): {counts[mod_val]}/10")
    print()

print("="*80)
print("KEY QUESTION")
print("="*80)
print()
print("For p ≡ 7 (mod 8):")
print("  x₀² = 1 + 7y₀² with y₀ odd")
print("  x₀² = 1 + 7(2k+1)² = 1 + 7(4k² + 4k + 1) = 8 + 28k(k+1)")
print("  x₀² = 8(1 + 7k(k+1)/2) [since k(k+1) always even]")
print()
print("So x₀² ≡ 0 (mod 8), meaning x₀ is even.")
print()
print("But WHY x₀ ≡ 0 (mod 8) specifically? Need to show v₂(x₀) ≥ 3.")
print()
print("Hypothesis: CF structure for p ≡ 7 (mod 8) forces period ≡ 0 (mod 4),")
print("which creates specific 2-adic properties in convergents.")
