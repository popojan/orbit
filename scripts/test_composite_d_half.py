#!/usr/bin/env python3
"""Test d[τ/2] = 2 for composite D ≡ 3 (mod 4)"""

import math
from typing import List, Tuple

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

        # Safety: max 200 iterations
        if k > 200:
            break

    return seq, k

def test_composite_d():
    """Test d[τ/2] = 2 for composite numbers D ≡ 3 (mod 4)"""

    # Generate composite D ≡ 3 (mod 4), D < 200
    composites = [D for D in range(15, 200, 4) if not is_prime(D)]

    print("Testing composite D ≡ 3 (mod 4) for d[τ/2] = 2\n")
    print(f"Found {len(composites)} composite numbers to test\n")

    results = []

    for D in composites:
        seq, tau = cf_aux_sequence(D)
        a0 = int(math.sqrt(D))

        # Check if period is even
        if tau % 2 == 0:
            half = tau // 2

            # Extract values at τ/2 (seq[half] because 0-indexed)
            _, m_half, d_half, a_half = seq[half]

            # Extract d[τ/2 - 1]
            _, _, d_half_minus_1, _ = seq[half - 1]

            # Check identity D - m² = 2·d[τ/2-1]
            diff = D - m_half**2
            two_d = 2 * d_half_minus_1
            identity = (diff == two_d)

            results.append({
                'D': D,
                'tau': tau,
                'd_half': d_half,
                'm_half': m_half,
                'a_half': a_half,
                'm_eq_a': m_half == a_half,
                'd_half_minus_1': d_half_minus_1,
                'diff': diff,
                'two_d': two_d,
                'identity': identity,
                'even': True
            })
        else:
            results.append({
                'D': D,
                'tau': tau,
                'even': False
            })

    # Print results
    print("\nRESULTS:\n")
    print("D      τ     d[τ/2]  m[τ/2]  a[τ/2]  m=a?  d[τ/2-1]  D-m²    2d      Identity?")
    print("-" * 90)

    even_results = [r for r in results if r.get('even', False)]
    odd_results = [r for r in results if not r.get('even', False)]

    for r in even_results:
        print(f"{r['D']:4d}  {r['tau']:4d}  {r['d_half']:6d}  {r['m_half']:6d}  "
              f"{r['a_half']:6d}  {'✓' if r['m_eq_a'] else '✗':4s}  "
              f"{r['d_half_minus_1']:8d}  {r['diff']:6d}  {r['two_d']:6d}  "
              f"{'✓' if r['identity'] else '✗':4s}")

    if odd_results:
        print("\nOdd period cases (skipped):")
        for r in odd_results:
            print(f"  D = {r['D']}, τ = {r['tau']}")

    # Statistics
    print("\n" + "=" * 90)
    print("STATISTICS:\n")

    d_half_is_2 = sum(1 for r in even_results if r['d_half'] == 2)
    m_equals_a = sum(1 for r in even_results if r['m_eq_a'])
    identity_holds = sum(1 for r in even_results if r['identity'])

    print(f"Total composite D tested: {len(results)}")
    print(f"Even period: {len(even_results)}")
    print(f"Odd period: {len(odd_results)}")
    print()

    if even_results:
        print(f"d[τ/2] = 2: {d_half_is_2}/{len(even_results)} "
              f"({100.0 * d_half_is_2/len(even_results):.1f}%)")
        print(f"m[τ/2] = a[τ/2]: {m_equals_a}/{len(even_results)} "
              f"({100.0 * m_equals_a/len(even_results):.1f}%)")
        print(f"D - m² = 2·d[τ/2-1]: {identity_holds}/{len(even_results)} "
              f"({100.0 * identity_holds/len(even_results):.1f}%)")

    # Find counterexamples
    print("\n" + "=" * 90)

    counter_d2 = [r for r in even_results if r['d_half'] != 2]
    counter_ma = [r for r in even_results if not r['m_eq_a']]
    counter_identity = [r for r in even_results if not r['identity']]

    if counter_d2:
        print("COUNTEREXAMPLES for d[τ/2] = 2:")
        for r in counter_d2:
            print(f"  D = {r['D']}, τ = {r['tau']}, d[τ/2] = {r['d_half']}")
    else:
        print("✓ NO counterexamples for d[τ/2] = 2 (pattern holds!)")

    if counter_ma:
        print("\nCOUNTEREXAMPLES for m = a:")
        for r in counter_ma:
            print(f"  D = {r['D']}, m[τ/2] = {r['m_half']}, a[τ/2] = {r['a_half']}")
    else:
        print("✓ NO counterexamples for m = a (pattern holds!)")

    print("\nDONE")

    return results

if __name__ == "__main__":
    results = test_composite_d()
