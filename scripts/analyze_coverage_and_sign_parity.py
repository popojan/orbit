#!/usr/bin/env python3
"""
1. Coverage analysis: What % of composites D ≡ 3 (mod 4) have same-sign pattern?
2. Sign sum parity: For different signs, does sum(signs) mod 2 matter?
"""

import math
from typing import Tuple, Optional, List

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

def prime_factorization(n: int) -> List[int]:
    """Return list of prime factors with multiplicity"""
    factors = []
    temp = n
    d = 2
    while d * d <= temp:
        while temp % d == 0:
            factors.append(d)
            temp //= d
        d += 1 if d == 2 else 2
    if temp > 1:
        factors.append(temp)
    return factors

def cf_aux_sequence(D: int) -> Tuple[List, int]:
    """Compute CF auxiliary sequence for √D"""
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
        if a == 2 * a0 and k > 1:
            break
        if k > 500:
            break

    return seq, k

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

    return None

def analyze_coverage_and_parity():
    """Main analysis"""

    print("ANALYSIS 1: Coverage - What % of composites have same-sign pattern?")
    print("ANALYSIS 2: Sign sum parity for different-sign cases\n")
    print("=" * 100)

    # Collect all composites D ≡ 3 (mod 4), D < 1000
    composites = []
    for D in range(15, 1000, 4):
        if not is_prime(D):
            composites.append(D)

    print(f"\nTotal composites D ≡ 3 (mod 4), D < 1000: {len(composites)}\n")

    # Analyze each
    results = []

    for D in composites:
        # Get prime factors (with multiplicity)
        factors_list = prime_factorization(D)
        unique_factors = list(set(factors_list))  # Unique primes

        # Get d[τ/2]
        seq, tau = cf_aux_sequence(D)
        if tau % 2 != 0:
            continue  # Skip odd period

        half = tau // 2
        _, _, d_half, _ = seq[half]

        # Solve Pell
        pell_sol = pell_solution(D)
        if pell_sol is None:
            continue

        x0, y0 = pell_sol

        # Get signs for each unique prime factor
        signs = []
        for p in unique_factors:
            x0_mod_p = x0 % p
            sign = +1 if x0_mod_p == 1 else (-1 if x0_mod_p == p-1 else 0)
            if sign == 0:
                break  # Skip if not ±1
            signs.append(sign)

        if len(signs) != len(unique_factors):
            continue  # Skip if any factor didn't give ±1

        # Check if all same
        all_same = len(set(signs)) == 1

        # Sign sum and parity
        sign_sum = sum(signs)
        sign_sum_parity = sign_sum % 2  # 0 for even, 1 for odd (though sum can be negative)

        # Count +1 and -1
        count_plus = sum(1 for s in signs if s == 1)
        count_minus = sum(1 for s in signs if s == -1)

        results.append({
            'D': D,
            'num_factors': len(factors_list),  # With multiplicity
            'num_unique_primes': len(unique_factors),
            'unique_primes': unique_factors,
            'signs': signs,
            'all_same': all_same,
            'd_half': d_half,
            'd_eq_2': d_half == 2,
            'sign_sum': sign_sum,
            'sign_sum_mod2': abs(sign_sum) % 2,  # Absolute value mod 2
            'count_plus': count_plus,
            'count_minus': count_minus,
            'parity_diff': (count_plus - count_minus) % 2  # Parity of difference
        })

    # ANALYSIS 1: Coverage
    print("=" * 100)
    print("COVERAGE ANALYSIS:\n")

    total = len(results)
    same_sign = sum(1 for r in results if r['all_same'])
    diff_sign = total - same_sign

    print(f"Total composites analyzed: {total}")
    print(f"Same sign (all factors): {same_sign} ({100.0*same_sign/total:.1f}%)")
    print(f"Different signs: {diff_sign} ({100.0*diff_sign/total:.1f}%)")
    print()

    # By number of unique primes
    by_primes = {}
    for r in results:
        k = r['num_unique_primes']
        if k not in by_primes:
            by_primes[k] = {'total': 0, 'same': 0}
        by_primes[k]['total'] += 1
        if r['all_same']:
            by_primes[k]['same'] += 1

    print("Breakdown by number of UNIQUE prime factors:")
    for k in sorted(by_primes.keys()):
        stats = by_primes[k]
        pct = 100.0 * stats['same'] / stats['total']
        print(f"  {k} unique primes: {stats['same']}/{stats['total']} same-sign ({pct:.1f}%)")

    # ANALYSIS 2: Sign sum parity for DIFFERENT sign cases
    print("\n" + "=" * 100)
    print("SIGN SUM PARITY ANALYSIS (different-sign cases only):\n")

    diff_sign_cases = [r for r in results if not r['all_same']]

    # Group by sign_sum mod 2
    even_sum = [r for r in diff_sign_cases if r['sign_sum_mod2'] == 0]
    odd_sum = [r for r in diff_sign_cases if r['sign_sum_mod2'] == 1]

    print(f"Different-sign cases: {len(diff_sign_cases)} total")
    print(f"  |sum(signs)| even: {len(even_sum)} ({100.0*len(even_sum)/len(diff_sign_cases):.1f}%)")
    print(f"  |sum(signs)| odd:  {len(odd_sum)} ({100.0*len(odd_sum)/len(diff_sign_cases):.1f}%)")
    print()

    # Check d[τ/2]=2 correlation with sign sum parity
    even_sum_d2 = sum(1 for r in even_sum if r['d_eq_2'])
    odd_sum_d2 = sum(1 for r in odd_sum if r['d_eq_2'])

    print("Correlation with d[τ/2]=2 among different-sign cases:")
    if even_sum:
        print(f"  |sum| even: d[τ/2]=2 in {even_sum_d2}/{len(even_sum)} ({100.0*even_sum_d2/len(even_sum):.1f}%)")
    if odd_sum:
        print(f"  |sum| odd:  d[τ/2]=2 in {odd_sum_d2}/{len(odd_sum)} ({100.0*odd_sum_d2/len(odd_sum):.1f}%)")
    print()

    # Alternative: parity of (count_+ - count_-)
    parity_diff_even = [r for r in diff_sign_cases if r['parity_diff'] == 0]
    parity_diff_odd = [r for r in diff_sign_cases if r['parity_diff'] == 1]

    print("By parity of (#plus - #minus):")
    print(f"  Even parity: {len(parity_diff_even)} cases")
    print(f"  Odd parity:  {len(parity_diff_odd)} cases")
    print()

    # Show examples
    print("=" * 100)
    print("EXAMPLES of different-sign cases:\n")
    print("D      primes        signs          sum  |sum|%2  d[τ/2]  d=2?")
    print("-" * 100)

    for r in diff_sign_cases[:20]:
        primes_str = '×'.join(map(str, r['unique_primes']))
        signs_str = str(tuple(r['signs']))
        d2_mark = '✓' if r['d_eq_2'] else '✗'
        print(f"{r['D']:4d}  {primes_str:12s}  {signs_str:15s}  {r['sign_sum']:+3d}    {r['sign_sum_mod2']:1d}      "
              f"{r['d_half']:4d}    {d2_mark}")

    print("\nDONE")

if __name__ == "__main__":
    analyze_coverage_and_parity()
