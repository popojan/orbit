#!/usr/bin/env python3
"""Check actual norms at τ/2-1 for same-sign vs different-sign semiprimes"""

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

def factor_semiprime(n: int) -> Optional[Tuple[int, int]]:
    """Factor n into two primes p×q"""
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

def cf_convergents(D: int) -> Tuple[list, int]:
    """
    Compute CF convergents for √D
    Returns: (convergents, period_length)
    convergents = [(k, p_k, q_k, norm_k), ...]
    where norm_k = p_k² - D·q_k²
    """
    a0 = int(math.sqrt(D))
    m, d, a = 0, 1, a0

    # Initial convergents
    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1

    convergents = [
        (0, p_curr, q_curr, p_curr*p_curr - D*q_curr*q_curr)
    ]

    k = 0
    while True:
        k += 1
        # Update CF auxiliary
        m = d * a - m
        d = (D - m*m) // d
        a = (a0 + m) // d

        # Update convergents
        p_next = a * p_curr + p_prev
        q_next = a * q_curr + q_prev

        norm = p_next*p_next - D*q_next*q_next

        convergents.append((k, p_next, q_next, norm))

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

        # Period detection
        if a == 2 * a0 and k > 1:
            break

        if k > 500:
            break

    return convergents, k

def pell_solution(D: int, max_k: int = 1000) -> Optional[Tuple[int, int]]:
    """Find fundamental Pell solution"""
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

def check_norms():
    """Check norms at τ/2-1 for semiprimes"""

    print("Checking norms at position τ/2-1 for semiprimes D = p×q ≡ 3 (mod 4)\n")
    print("=" * 100)

    # Get semiprimes D < 400
    semiprimes = []
    for D in range(15, 400, 4):
        if not is_prime(D):
            factors = factor_semiprime(D)
            if factors is not None:
                semiprimes.append((D, factors))

    results_same = []
    results_diff = []

    for D, (p, q) in semiprimes:
        # Get convergents
        convergents, tau = cf_convergents(D)

        if tau % 2 != 0:
            continue  # Skip odd period

        half = tau // 2

        # Norm at τ/2-1
        _, p_h, q_h, norm_h = convergents[half]  # This is at k=τ/2, we want τ/2-1
        if half > 0:
            _, p_hm1, q_hm1, norm_hm1 = convergents[half - 1]  # At k=τ/2-1
        else:
            norm_hm1 = None

        # Actually we want norm at τ/2-1 which is convergents[half-1] since convergents[0] is k=0
        # So convergents[k] corresponds to k-th convergent
        # Wait, let me check indexing...
        # convergents = [(0, ...), (1, ...), (2, ...), ...]
        # convergents[k] is k-th convergent
        # τ/2 - 1 is index half-1 if convergents are 0-indexed

        norm_at_center_minus_1 = norm_hm1 if half > 0 else None

        # Solve Pell
        pell_sol = pell_solution(D)
        if pell_sol is None:
            continue

        x0, y0 = pell_sol

        # Signs
        sign_p = +1 if x0 % p == 1 else (-1 if x0 % p == p-1 else 0)
        sign_q = +1 if x0 % q == 1 else (-1 if x0 % q == q-1 else 0)

        if sign_p == 0 or sign_q == 0:
            continue

        same_sign = (sign_p == sign_q)

        result = {
            'D': D,
            'p': p,
            'q': q,
            'tau': tau,
            'sign_p': sign_p,
            'sign_q': sign_q,
            'same_sign': same_sign,
            'norm_at_half_minus_1': norm_at_center_minus_1,
            'D_mod_8': D % 8
        }

        if same_sign:
            results_same.append(result)
        else:
            results_diff.append(result)

    # Print results
    print("\nSAME SIGN cases:\n")
    print("D      p   q    D%8  τ    sign_p sign_q  norm[τ/2-1]")
    print("-" * 100)

    for r in results_same:
        print(f"{r['D']:4d}  {r['p']:3d} {r['q']:3d}   {r['D_mod_8']:1d}  {r['tau']:4d}   "
              f"{r['sign_p']:+2d}     {r['sign_q']:+2d}      {r['norm_at_half_minus_1']:+6d}")

    print("\n" + "=" * 100)
    print("\nDIFFERENT SIGN cases (first 20):\n")
    print("D      p   q    D%8  τ    sign_p sign_q  norm[τ/2-1]")
    print("-" * 100)

    for r in results_diff[:20]:
        print(f"{r['D']:4d}  {r['p']:3d} {r['q']:3d}   {r['D_mod_8']:1d}  {r['tau']:4d}   "
              f"{r['sign_p']:+2d}     {r['sign_q']:+2d}      {r['norm_at_half_minus_1']:+6d}")

    # Statistics
    print("\n" + "=" * 100)
    print("NORM STATISTICS:\n")

    norms_same = [r['norm_at_half_minus_1'] for r in results_same if r['norm_at_half_minus_1'] is not None]
    norms_diff = [r['norm_at_half_minus_1'] for r in results_diff if r['norm_at_half_minus_1'] is not None]

    print(f"Same sign ({len(results_same)} cases):")
    print(f"  Norms: {set(norms_same)}")
    print(f"  All ±2? {all(abs(n) == 2 for n in norms_same)}")
    print()

    print(f"Different sign ({len(results_diff)} cases):")
    unique_norms_diff = sorted(set(abs(n) for n in norms_diff))
    print(f"  Unique |norm| values: {unique_norms_diff[:20]}")  # First 20
    print(f"  Any ±2? {any(abs(n) == 2 for n in norms_diff)}")
    print(f"  Count with |norm|=2: {sum(1 for n in norms_diff if abs(n) == 2)}/{len(norms_diff)}")
    print()

    # Check D mod 8 pattern
    same_by_mod8 = {}
    diff_by_mod8 = {}

    for r in results_same:
        m8 = r['D_mod_8']
        if m8 not in same_by_mod8:
            same_by_mod8[m8] = 0
        same_by_mod8[m8] += 1

    for r in results_diff:
        m8 = r['D_mod_8']
        if m8 not in diff_by_mod8:
            diff_by_mod8[m8] = 0
        diff_by_mod8[m8] += 1

    print("D mod 8 distribution:")
    print(f"  Same sign: {same_by_mod8}")
    print(f"  Different sign: {diff_by_mod8}")

    print("\nDONE")

if __name__ == "__main__":
    check_norms()
