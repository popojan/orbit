#!/usr/bin/env python3
"""
Deep analysis of continued fraction auxiliary sequences
Focus: Center convergent divisor property
"""

import math
from typing import List, Tuple, Dict

def isqrt(n: int) -> int:
    """Integer square root"""
    if n < 0:
        raise ValueError("Square root of negative number")
    if n == 0:
        return 0
    x = n
    y = (x + 1) // 2
    while y < x:
        x = y
        y = (x + n // x) // 2
    return x

def cf_expansion_full(D: int, max_steps: int = 10000) -> Dict:
    """
    Compute full CF expansion with P_k, Q_k, a_k sequences
    Returns sequences until period is detected
    """
    if isqrt(D) ** 2 == D:
        raise ValueError(f"{D} is a perfect square")

    a0 = isqrt(D)
    P = [0]
    Q = [1]
    a = [a0]

    # Track states for period detection
    seen = {}
    seen[(0, 1)] = 0  # Initial state

    k = 0
    while k < max_steps:
        # P_{k+1} = a_k * Q_k - P_k
        P_next = a[k] * Q[k] - P[k]

        # Q_{k+1} = (D - P_{k+1}^2) / Q_k
        Q_next = (D - P_next ** 2) // Q[k]

        # Check for period completion (state repetition)
        state = (P_next, Q_next)
        if state in seen and seen[state] == 0:
            # Returned to initial state - period complete
            break

        # a_{k+1} = floor((sqrt(D) + P_{k+1}) / Q_{k+1})
        a_next = (a0 + P_next) // Q_next

        P.append(P_next)
        Q.append(Q_next)
        a.append(a_next)

        if state not in seen:
            seen[state] = len(P) - 1

        k += 1

    period = len(a) - 1  # Subtract initial a0
    return {
        'P': P,
        'Q': Q,
        'a': a,
        'period': period,
        'a0': a0
    }

def compute_convergents(a: List[int]) -> Tuple[List[int], List[int]]:
    """
    Compute convergent numerators p_k and denominators q_k
    Standard recurrence:
      p_{-1} = 1, p_0 = a_0
      q_{-1} = 0, q_0 = 1
      p_k = a_k * p_{k-1} + p_{k-2}
      q_k = a_k * q_{k-1} + q_{k-2}

    Returns: (p, q) where p[k], q[k] are the k-th convergent
    """
    if len(a) == 0:
        return [], []

    # Initialize with p_{-1}, p_0 and q_{-1}, q_0
    p = [1, a[0]]
    q = [0, 1]

    # Compute remaining convergents
    for i in range(1, len(a)):
        p_next = a[i] * p[-1] + p[-2]
        q_next = a[i] * q[-1] + q[-2]
        p.append(p_next)
        q.append(q_next)

    return p, q

def gcd(a: int, b: int) -> int:
    """Greatest common divisor"""
    while b:
        a, b = b, a % b
    return abs(a)

def factor(n: int) -> List[Tuple[int, int]]:
    """Simple integer factorization (sufficient for small numbers)"""
    if n == 0:
        return [(0, 1)]
    if n == 1:
        return [(1, 1)]

    n = abs(n)
    factors = []
    d = 2
    while d * d <= n:
        exp = 0
        while n % d == 0:
            n //= d
            exp += 1
        if exp > 0:
            factors.append((d, exp))
        d += 1
    if n > 1:
        factors.append((n, 1))
    return factors

def divisors(n: int) -> List[int]:
    """All divisors of n"""
    if n == 0:
        return [0]
    n = abs(n)
    divs = []
    for i in range(1, isqrt(n) + 1):
        if n % i == 0:
            divs.append(i)
            if i != n // i:
                divs.append(n // i)
    return sorted(divs)

def analyze_prime(p: int):
    """Deep analysis of CF structure for prime p"""
    print(f"\n{'='*60}")
    print(f"ANALYSIS FOR p = {p}")
    print(f"{'='*60}\n")

    p_minus_1 = p - 1
    p1_factors = factor(p_minus_1)
    print(f"p - 1 = {p_minus_1} = {' × '.join(f'{b}^{e}' if e > 1 else str(b) for b, e in p1_factors)}")
    print()

    # Get CF expansion
    seq = cf_expansion_full(p)
    tau = seq['period']

    print(f"Period length τ = {tau}")
    print(f"τ = p - 1? {tau == p_minus_1}")
    print()

    if tau % 2 != 0:
        print("Period is odd - no center convergent")
        return

    m = tau // 2
    print(f"Center position m = τ/2 = {m}")
    print()

    # Center values from auxiliary sequences (P, Q are indexed from 0)
    # P[0]=0, Q[0]=1 are initial, then P[1], Q[1], ... from iterations
    P_m = seq['P'][m]
    Q_m = seq['Q'][m]

    print("At center (k = m):")
    print(f"  P_m = {P_m}")
    print(f"  Q_m = {Q_m}")
    Q_m_factors = factor(Q_m)
    print(f"  Q_m = {' × '.join(f'{b}^{e}' if e > 1 else str(b) for b, e in Q_m_factors)}")
    print()

    # Compute convergents
    # Returns p, q where:
    #   p[0] = 1 (p_{-1}), p[1] = a_0 (p_0), p[2] = a_1*a_0 + 1 (p_1), ...
    #   So p[k+1] corresponds to the k-th convergent p_k/q_k
    p_conv, q_conv = compute_convergents(seq['a'])

    # Get center convergent p_m / q_m
    # Since p_conv[k+1] holds p_k, we want p_conv[m+1] for center at position m
    # But wait: seq['a'] has [a_0, a_1, ..., a_tau], so length is tau+1
    # and convergents p[k+1] = p_k means p[1] = p_0, ..., p[m+1] = p_m
    if m + 1 < len(p_conv):
        p_m = p_conv[m + 1]
        q_m = q_conv[m + 1]
    else:
        print(f"ERROR: Center index {m} out of range for convergents (len={len(p_conv)})")
        return

    print(f"Center convergent p_m / q_m:")
    print(f"  p_m = {p_m}")
    print(f"  q_m = {q_m}")
    print()

    # Verify Pell equation: p_m^2 - p*q_m^2 = (-1)^m * Q_{m+1}
    lhs = p_m ** 2 - p * q_m ** 2
    rhs = ((-1) ** m) * seq['Q'][m + 1]
    print(f"Pell equation verification: p_m² - p·q_m² = (-1)^m · Q_(m+1)")
    print(f"  LHS = {lhs}")
    print(f"  RHS = {rhs}")
    print(f"  Match? {lhs == rhs}")
    print()

    # Divisor analysis
    gcd_qm = gcd(q_m, p_minus_1)
    gcd_qm_minus = gcd(q_m - 1, p_minus_1)
    gcd_qm_plus = gcd(q_m + 1, p_minus_1)

    print(f"Divisor analysis for p - 1 = {p_minus_1}:")
    print(f"  gcd(q_m, p-1)     = {gcd_qm:6d} = {factor(gcd_qm)}")
    print(f"  gcd(q_m - 1, p-1) = {gcd_qm_minus:6d} = {factor(gcd_qm_minus)}")
    print(f"  gcd(q_m + 1, p-1) = {gcd_qm_plus:6d} = {factor(gcd_qm_plus)}")

    max_gcd = max(gcd_qm, gcd_qm_minus, gcd_qm_plus)
    largest_prime_power = max(b**e for b, e in p1_factors)

    print(f"  max(gcds)        = {max_gcd}")
    print(f"  largest prime power in p-1 = {largest_prime_power}")
    print(f"  ★ Pattern holds? {max_gcd == largest_prime_power}")
    print()

    # Q_m divisibility analysis
    print(f"Q_m divisibility by factors of p - 1:")
    p1_divs = divisors(p_minus_1)
    for d in p1_divs:
        if Q_m % d == 0:
            print(f"  {d:6d} | Q_m")
    print()

    # Q_k sequence near center
    print(f"Q_k sequence around center (m = {m}):")
    for k in range(max(0, m - 5), min(tau + 1, m + 6)):
        if k < len(seq['Q']):
            Q_k = seq['Q'][k]
            Q_k_factors = factor(Q_k)
            print(f"  Q_{k:3d} = {Q_k:8d} = {' × '.join(f'{b}^{e}' if e > 1 else str(b) for b, e in Q_k_factors)}")
    print()

    # Q_k mod (p-1) near center
    print(f"Q_k mod (p-1) near center:")
    for k in range(max(0, m - 5), min(tau + 1, m + 6)):
        if k < len(seq['Q']):
            Q_k_mod = seq['Q'][k] % p_minus_1
            print(f"  Q_{k:3d} ≡ {Q_k_mod:6d} (mod {p_minus_1})")
    print()

    # Additional: multiplicative order analysis
    print(f"Additional analysis:")
    print(f"  q_m mod p = {q_m % p}")
    print(f"  Q_m mod p = {Q_m % p}")
    print()

if __name__ == '__main__':
    print("CENTER CONVERGENT DEEP ANALYSIS")
    print("=" * 60)

    # Primary example
    analyze_prime(89)

    # Secondary example
    analyze_prime(113)

    # Another one with τ = p-1
    analyze_prime(523)
