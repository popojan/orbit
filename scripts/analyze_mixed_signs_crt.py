#!/usr/bin/env python3
"""Analyze CRT and parity for mixed-sign semiprime cases"""

import math
from typing import Tuple, Optional

def is_prime(n: int) -> bool:
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

def pell_solution(D: int, max_k: int = 1000) -> Optional[Tuple[int, int]]:
    """Find fundamental Pell solution using CF convergents"""
    if int(math.sqrt(D))**2 == D:
        return None

    a0 = int(math.sqrt(D))
    m, d, a = 0, 1, a0

    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1

    for k in range(1, max_k):
        m = d * a - m
        d = (D - m*m) // d
        a = (a0 + m) // d

        p_next = a * p_curr + p_prev
        q_next = a * q_curr + q_prev

        if p_next*p_next - D*q_next*q_next == 1:
            return (p_next, q_next)

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

        if a == 2 * a0 and k > 1:
            pass

    return None

def factor_semiprime(n: int) -> Optional[Tuple[int, int]]:
    """Factor n into two primes p×q, return (p, q) with p < q"""
    factors = []
    temp = n
    d = 2
    while d * d <= temp and len(factors) < 3:
        while temp % d == 0:
            factors.append(d)
            temp //= d
        d += 1 if d == 2 else 2
    if temp > 1:
        factors.append(temp)

    if len(factors) == 2:
        return tuple(sorted(factors))
    return None

def extended_gcd(a: int, b: int) -> Tuple[int, int, int]:
    """Extended Euclidean algorithm: returns (gcd, x, y) such that ax + by = gcd"""
    if a == 0:
        return (b, 0, 1)
    gcd, x1, y1 = extended_gcd(b % a, a)
    x = y1 - (b // a) * x1
    y = x1
    return (gcd, x, y)

def crt_two(r1: int, m1: int, r2: int, m2: int) -> Optional[int]:
    """
    Chinese Remainder Theorem for two equations:
    x ≡ r1 (mod m1)
    x ≡ r2 (mod m2)
    Returns x mod (m1*m2), or None if no solution
    """
    gcd, u, v = extended_gcd(m1, m2)
    if (r2 - r1) % gcd != 0:
        return None

    # Solution: x = r1 + m1 * u * (r2 - r1) / gcd
    x = r1 + m1 * u * ((r2 - r1) // gcd)
    return x % (m1 * m2)

def analyze_mixed_signs():
    """Analyze CRT behavior for mixed-sign semiprimes"""

    print("Analyzing mixed-sign semiprime cases via CRT\n")

    # Get semiprimes D ≡ 3 (mod 4), D < 400
    semiprimes = []
    for D in range(15, 400, 4):
        if not is_prime(D):
            factors = factor_semiprime(D)
            if factors is not None:
                semiprimes.append((D, factors))

    # Solve Pell and analyze
    results = []

    for D, (p, q) in semiprimes:
        pell_sol = pell_solution(D)
        if pell_sol is None:
            continue

        x0, y0 = pell_sol

        # x0 mod factors
        x0_mod_p = x0 % p
        x0_mod_q = x0 % q

        # Normalize to ±1
        sign_p = +1 if x0_mod_p == 1 else (-1 if x0_mod_p == p-1 else 0)
        sign_q = +1 if x0_mod_q == 1 else (-1 if x0_mod_q == q-1 else 0)

        if sign_p == 0 or sign_q == 0:
            continue  # Skip if not ±1

        # x0 mod D
        x0_mod_D = x0 % D

        # CRT reconstruction
        # We want x ≡ ±1 (mod p) and x ≡ ±1 (mod q)
        # Use normalized form
        r1 = 1 if sign_p == 1 else p - 1
        r2 = 1 if sign_q == 1 else q - 1

        crt_result = crt_two(r1, p, r2, q)

        # Check parity
        x0_parity = x0 % 2
        crt_parity = crt_result % 2 if crt_result is not None else None

        same_sign = (sign_p == sign_q)

        results.append({
            'D': D,
            'p': p,
            'q': q,
            'x0': x0,
            'sign_p': sign_p,
            'sign_q': sign_q,
            'same_sign': same_sign,
            'x0_mod_D': x0_mod_D,
            'crt_result': crt_result,
            'x0_parity': x0_parity,
            'crt_parity': crt_parity,
            'x0_normalized': x0_mod_D if x0_mod_D <= D//2 else x0_mod_D - D
        })

    # Separate by sign pattern
    same_sign_cases = [r for r in results if r['same_sign']]
    diff_sign_cases = [r for r in results if not r['same_sign']]

    print("=" * 100)
    print("SAME SIGN CASES (both +1 or both -1):\n")
    print("D      p   q    sign_p sign_q  x0_mod_D  CRT_result  x0_parity  Normalized")
    print("-" * 100)

    for r in same_sign_cases[:15]:
        print(f"{r['D']:4d}  {r['p']:3d} {r['q']:3d}   {r['sign_p']:+2d}     {r['sign_q']:+2d}      "
              f"{r['x0_mod_D']:6d}    {r['crt_result']:6d}      {r['x0_parity']:1d}          "
              f"{r['x0_normalized']:+6d}")

    print("\n" + "=" * 100)
    print("DIFFERENT SIGN CASES (+1 vs -1):\n")
    print("D      p   q    sign_p sign_q  x0_mod_D  CRT_result  x0_parity  Normalized")
    print("-" * 100)

    for r in diff_sign_cases[:15]:
        print(f"{r['D']:4d}  {r['p']:3d} {r['q']:3d}   {r['sign_p']:+2d}     {r['sign_q']:+2d}      "
              f"{r['x0_mod_D']:6d}    {r['crt_result']:6d}      {r['x0_parity']:1d}          "
              f"{r['x0_normalized']:+6d}")

    # Analyze parities
    print("\n" + "=" * 100)
    print("PARITY ANALYSIS:\n")

    same_even = sum(1 for r in same_sign_cases if r['x0_parity'] == 0)
    same_odd = sum(1 for r in same_sign_cases if r['x0_parity'] == 1)

    diff_even = sum(1 for r in diff_sign_cases if r['x0_parity'] == 0)
    diff_odd = sum(1 for r in diff_sign_cases if r['x0_parity'] == 1)

    print(f"Same sign cases ({len(same_sign_cases)} total):")
    print(f"  Even: {same_even} ({100.0*same_even/len(same_sign_cases):.1f}%)")
    print(f"  Odd:  {same_odd} ({100.0*same_odd/len(same_sign_cases):.1f}%)")
    print()

    print(f"Different sign cases ({len(diff_sign_cases)} total):")
    print(f"  Even: {diff_even} ({100.0*diff_even/len(diff_sign_cases):.1f}%)")
    print(f"  Odd:  {diff_odd} ({100.0*diff_odd/len(diff_sign_cases):.1f}%)")
    print()

    # Check x0 normalized values
    print("=" * 100)
    print("NORMALIZED x0 mod D (centered at 0):\n")

    same_pos = sum(1 for r in same_sign_cases if r['x0_normalized'] > 0)
    same_neg = sum(1 for r in same_sign_cases if r['x0_normalized'] < 0)

    diff_pos = sum(1 for r in diff_sign_cases if r['x0_normalized'] > 0)
    diff_neg = sum(1 for r in diff_sign_cases if r['x0_normalized'] < 0)

    print(f"Same sign: +1 count = {same_pos}, -1 count = {same_neg}")
    print(f"Different sign: positive = {diff_pos}, negative = {diff_neg}")

    print("\nDONE")

if __name__ == "__main__":
    analyze_mixed_signs()
