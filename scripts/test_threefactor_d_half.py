#!/usr/bin/env python3
"""Test d[τ/2] = 2 for 3-factor composites D = p×q×r ≡ 3 (mod 4)"""

import math
from typing import List, Tuple, Optional

def is_prime(n: int) -> bool:
    """Check if n is prime"""
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

def factor_into_three_primes(n: int) -> Optional[Tuple[int, int, int]]:
    """
    Try to factor n into exactly three primes p×q×r (not necessarily distinct).
    Returns (p, q, r) with p ≤ q ≤ r, or None if n doesn't have exactly 3 prime factors.
    """
    factors = []
    temp = n

    # Trial division
    d = 2
    while d * d <= temp:
        while temp % d == 0:
            factors.append(d)
            temp //= d
        d += 1 if d == 2 else 2

    if temp > 1:
        factors.append(temp)

    # Check if exactly 3 prime factors (counting multiplicity)
    if len(factors) == 3:
        return tuple(sorted(factors))
    else:
        return None

def cf_aux_sequence(D: int) -> Tuple[List, int]:
    """Compute CF auxiliary sequence for √D

    Returns: (sequence, period_length)
    sequence = [(k, m_k, d_k, a_k), ...]
    """
    a0 = int(math.sqrt(D))
    m, d, a = 0, 1, a0

    seq = [(0, m, d, a)]
    k = 0

    while True:
        k += 1
        m = d * a - m
        d = (D - m*m) // d
        a = (a0 + m) // d

        seq.append((k, m, d, a))

        # Period detected when we return to start (a = 2*a0)
        if a == 2 * a0 and k > 1:
            break

        # Safety: max 500 iterations
        if k > 500:
            break

    return seq, k

def pell_solution(D: int, max_k: int = 1000) -> Optional[Tuple[int, int]]:
    """
    Find fundamental Pell solution (x₀, y₀) to x² - Dy² = 1
    using CF convergents.
    """
    if int(math.sqrt(D))**2 == D:
        return None  # D is perfect square

    a0 = int(math.sqrt(D))
    m, d, a = 0, 1, a0

    # Convergents p_k/q_k
    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1

    for k in range(1, max_k):
        # Update auxiliary sequence
        m = d * a - m
        d = (D - m*m) // d
        a = (a0 + m) // d

        # Update convergents
        p_next = a * p_curr + p_prev
        q_next = a * q_curr + q_prev

        # Check if this is a solution
        if p_next*p_next - D*q_next*q_next == 1:
            return (p_next, q_next)

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

        # Period detection
        if a == 2 * a0 and k > 1:
            # If we completed period without finding +1, might need to continue
            # (happens for D ≡ 2,3 mod 4 with even period)
            pass

    return None

def test_threefactor_composites():
    """Test d[τ/2] = 2 for 3-factor composites D ≡ 3 (mod 4)"""

    print("Testing 3-factor composites D = p×q×r ≡ 3 (mod 4)\n")

    # Generate 3-factor composites D ≡ 3 (mod 4), D < 1000
    composites = []
    for D in range(15, 1000, 4):
        if not is_prime(D):
            factors = factor_into_three_primes(D)
            if factors is not None:
                composites.append((D, factors))

    print(f"Found {len(composites)} three-factor composites to test\n")

    results = []

    for D, (p, q, r) in composites:
        # Compute CF
        seq, tau = cf_aux_sequence(D)

        # Check if period is even
        if tau % 2 != 0:
            results.append({
                'D': D,
                'factors': (p, q, r),
                'tau': tau,
                'even': False
            })
            continue

        half = tau // 2

        # Extract d[τ/2]
        _, _, d_half, _ = seq[half]

        # Solve Pell equation
        pell_sol = pell_solution(D)
        if pell_sol is None:
            print(f"WARNING: Could not find Pell solution for D={D}")
            continue

        x0, y0 = pell_sol

        # Compute x0 mod each factor
        x0_mod_p = x0 % p
        x0_mod_q = x0 % q
        x0_mod_r = x0 % r

        # Normalize to ±1
        sign_p = +1 if x0_mod_p == 1 else (-1 if x0_mod_p == p-1 else 0)
        sign_q = +1 if x0_mod_q == 1 else (-1 if x0_mod_q == q-1 else 0)
        sign_r = +1 if x0_mod_r == 1 else (-1 if x0_mod_r == r-1 else 0)

        # Check sign patterns
        all_same = (sign_p == sign_q == sign_r)
        signs = (sign_p, sign_q, sign_r)

        results.append({
            'D': D,
            'factors': (p, q, r),
            'tau': tau,
            'd_half': d_half,
            'x0_mod_p': x0_mod_p,
            'x0_mod_q': x0_mod_q,
            'x0_mod_r': x0_mod_r,
            'sign_p': sign_p,
            'sign_q': sign_q,
            'sign_r': sign_r,
            'all_same': all_same,
            'even': True
        })

    # Filter to even period only
    even_results = [r for r in results if r.get('even', False)]

    print("RESULTS:\n")
    print("D      p   q   r    τ    d[τ/2]  sign_p  sign_q  sign_r  All same?  d=2?")
    print("-" * 85)

    for r in even_results:
        p, q, rr = r['factors']
        d_eq_2 = '✓' if r['d_half'] == 2 else '✗'
        all_same_mark = '✓' if r['all_same'] else '✗'

        print(f"{r['D']:4d}  {p:3d} {q:3d} {rr:3d}  {r['tau']:4d}  "
              f"{r['d_half']:6d}  {r['sign_p']:+2d}      {r['sign_q']:+2d}      "
              f"{r['sign_r']:+2d}      {all_same_mark:4s}       {d_eq_2}")

    # Statistics
    print("\n" + "=" * 85)
    print("STATISTICS:\n")

    d_half_is_2 = [r for r in even_results if r['d_half'] == 2]
    all_same_sign = [r for r in even_results if r['all_same']]

    print(f"Total 3-factor composites tested: {len(even_results)}")
    print(f"d[τ/2] = 2: {len(d_half_is_2)} ({100.0 * len(d_half_is_2)/len(even_results):.1f}%)")
    print(f"All three signs same: {len(all_same_sign)} ({100.0 * len(all_same_sign)/len(even_results):.1f}%)")
    print()

    # Check correlation
    both_conditions = [r for r in even_results if r['all_same'] and r['d_half'] == 2]
    only_same_sign = [r for r in even_results if r['all_same'] and r['d_half'] != 2]
    only_d_eq_2 = [r for r in even_results if not r['all_same'] and r['d_half'] == 2]
    neither = [r for r in even_results if not r['all_same'] and r['d_half'] != 2]

    print("CORRELATION TABLE:\n")
    print("                        d[τ/2]=2    d[τ/2]≠2    Total")
    print(f"All same sign           {len(both_conditions):4d}        {len(only_same_sign):4d}        {len(all_same_sign):4d}")
    print(f"Different signs         {len(only_d_eq_2):4d}        {len(neither):4d}        {len(even_results) - len(all_same_sign):4d}")
    print(f"Total                   {len(d_half_is_2):4d}        {len(even_results) - len(d_half_is_2):4d}        {len(even_results):4d}")
    print()

    # Show examples of each category
    if both_conditions:
        print(f"\n✓ All same sign AND d[τ/2]=2: {len(both_conditions)} cases")
        for r in both_conditions[:5]:
            p, q, rr = r['factors']
            print(f"  D={r['D']} = {p}×{q}×{rr}, signs=({r['sign_p']:+d},{r['sign_q']:+d},{r['sign_r']:+d}), d[τ/2]={r['d_half']}")

    if only_same_sign:
        print(f"\n✗ All same sign BUT d[τ/2]≠2: {len(only_same_sign)} cases (COUNTEREXAMPLES!)")
        for r in only_same_sign[:5]:
            p, q, rr = r['factors']
            print(f"  D={r['D']} = {p}×{q}×{rr}, signs=({r['sign_p']:+d},{r['sign_q']:+d},{r['sign_r']:+d}), d[τ/2]={r['d_half']}")

    if only_d_eq_2:
        print(f"\n? Different signs BUT d[τ/2]=2: {len(only_d_eq_2)} cases (INTERESTING!)")
        for r in only_d_eq_2[:5]:
            p, q, rr = r['factors']
            print(f"  D={r['D']} = {p}×{q}×{rr}, signs=({r['sign_p']:+d},{r['sign_q']:+d},{r['sign_r']:+d}), d[τ/2]={r['d_half']}")

    print("\nDONE")

    return results

if __name__ == "__main__":
    results = test_threefactor_composites()
