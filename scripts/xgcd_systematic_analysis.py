#!/usr/bin/env python3
"""
Systematic XGCD analysis for understanding d_{τ/2} = 2

Focus: What does XGCD reveal when x₀ ≡ ±1 (mod p)?
"""

import math
from typing import List, Tuple, Dict


def cf_surd_sequence(D: int) -> Tuple[List[Tuple[int, int, int, int]], int]:
    """Compute CF(√D) using surd algorithm."""
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

        if a == 2*a0 and k > 1:
            break
        if k > 200:
            break

    return seq, k


def cf_convergents(partial_quotients: List[int]) -> List[Tuple[int, int]]:
    """Compute convergents."""
    if len(partial_quotients) < 1:
        return []

    p = [1, partial_quotients[0]]
    q = [0, 1]

    for k in range(1, len(partial_quotients)):
        p_new = partial_quotients[k] * p[-1] + p[-2]
        q_new = partial_quotients[k] * q[-1] + q[-2]
        p.append(p_new)
        q.append(q_new)

    return list(zip(p, q))


def extended_gcd_full(a: int, b: int, modulus: int = None) -> Dict:
    """
    Extended GCD with full trace INCLUDING Bézout coefficients.
    Optionally track everything modulo a prime.
    """
    r = [a, b]
    s = [1, 0]
    t = [0, 1]
    quotients = []

    while r[-1] != 0:
        quot = r[-2] // r[-1]
        quotients.append(quot)

        r_new = r[-2] - quot * r[-1]
        s_new = s[-2] - quot * s[-1]
        t_new = t[-2] - quot * t[-1]

        r.append(r_new)
        s.append(s_new)
        t.append(t_new)

    # Also compute modulo p if provided
    r_mod, s_mod, t_mod = None, None, None
    if modulus:
        r_mod = [x % modulus for x in r[:-1]]
        s_mod = [x % modulus for x in s]
        t_mod = [x % modulus for x in t]

    return {
        "gcd": r[-2],
        "remainders": r[:-1],
        "s_coeffs": s[:-1],
        "t_coeffs": t[:-1],
        "quotients": quotients,
        "r_mod": r_mod,
        "s_mod": s_mod,
        "t_mod": t_mod
    }


def analyze_xgcd_structure(p: int, verbose: bool = True) -> Dict:
    """
    Systematic XGCD analysis for prime p.

    Key question: How does x₀ ≡ ±1 (mod p) manifest in XGCD structure?
    """
    if verbose:
        print(f"\n{'='*70}")
        print(f"SYSTEMATIC XGCD ANALYSIS: p = {p}")
        print('='*70)

    # 1. Compute surd sequence
    surd_seq, period = cf_surd_sequence(p)
    partial_quotients = [entry[3] for entry in surd_seq]
    surd_d = [entry[2] for entry in surd_seq]
    surd_m = [entry[1] for entry in surd_seq]

    if verbose:
        print(f"\n1. SURD ALGORITHM:")
        print(f"   Period τ = {period}")
        print(f"   Partial quotients: {partial_quotients[:10]}{'...' if len(partial_quotients) > 10 else ''}")
        print(f"   d sequence: {surd_d}")
        print(f"   m sequence: {surd_m}")

    # 2. Compute convergents
    convergents = cf_convergents(partial_quotients)

    # Find Pell solution (fundamental unit)
    # Check convergents to find first with norm +1 (skip trivial i=0)
    x0, y0 = None, None
    pell_idx = -1
    for i, (x, y) in enumerate(convergents[1:], start=1):  # Skip i=0
        norm = x*x - p*y*y
        if norm == 1:
            x0, y0 = x, y
            pell_idx = i
            break

    if x0 is None:
        # Fallback: use last convergent in our list
        x0, y0 = convergents[-1]
        pell_idx = len(convergents) - 1

    pell_check = x0*x0 - p*y0*y0

    if verbose:
        print(f"\n2. PELL SOLUTION:")
        print(f"   Index: {min(pell_idx, len(convergents)-1)}")
        print(f"   (x₀, y₀) = ({x0}, {y0})")
        print(f"   Check: x₀² - py₀² = {pell_check}")
        print(f"   x₀ mod p = {x0 % p}")
        print(f"   Expected: {'±1' if p % 4 == 3 else 'varies'}")

    # 3. Run XGCD with full trace
    xgcd = extended_gcd_full(x0, y0, modulus=p)

    if verbose:
        print(f"\n3. XGCD STRUCTURE:")
        print(f"   GCD = {xgcd['gcd']}")
        print(f"   Number of steps = {len(xgcd['quotients'])}")
        print(f"   Quotients: {xgcd['quotients']}")

    # 4. Analyze remainders and norms
    norms = []
    convergent_indices = []

    for i in range(0, len(xgcd['remainders'])-1, 2):
        if i+1 < len(xgcd['remainders']):
            p_i = xgcd['remainders'][i]
            q_i = xgcd['remainders'][i+1]
            norm = p_i*p_i - p*q_i*q_i
            norms.append(norm)
            convergent_indices.append(i//2)

    if verbose:
        print(f"\n4. CONVERGENT NORMS FROM XGCD:")
        print(f"   Step | Remainder pair | Norm")
        print(f"   " + "-"*50)
        for i, (idx, norm) in enumerate(zip(convergent_indices[:8], norms[:8])):
            rems = (xgcd['remainders'][2*i], xgcd['remainders'][2*i+1]) if 2*i+1 < len(xgcd['remainders']) else ('?', '?')
            print(f"   {i:4d} | ({rems[0]:6d}, {rems[1]:6d}) | {norm:8d}")
        if len(norms) > 8:
            print(f"   ... ({len(norms)-8} more)")

    # 5. Check palindrome center
    if period % 2 == 0:
        half = period // 2
        d_half = surd_seq[half][2]
        m_half = surd_seq[half][1]
        a_half = surd_seq[half][3]

        # Which XGCD step corresponds to convergent at τ/2-1?
        # XGCD starts from convergent τ-1 and walks backward
        # So convergent at τ/2-1 is at XGCD step (τ-1) - (τ/2-1) = τ/2
        xgcd_step_for_center = period // 2

        if verbose:
            print(f"\n5. PALINDROME CENTER (τ/2 = {half}):")
            print(f"   From surd:")
            print(f"     d[{half}] = {d_half}")
            print(f"     m[{half}] = {m_half}")
            print(f"     a[{half}] = {a_half}")
            print(f"     m = a ? {m_half == a_half}")

            if xgcd_step_for_center < len(norms):
                center_norm = norms[xgcd_step_for_center]
                print(f"   From XGCD (step {xgcd_step_for_center}):")
                print(f"     Norm = {center_norm}")
                print(f"     |Norm| = {abs(center_norm)}")
                print(f"     Match d[τ/2] = {abs(center_norm) == d_half}")

    # 6. CRITICAL: Bézout coefficients modulo p
    if verbose and xgcd['s_mod'] and len(xgcd['s_mod']) > 0:
        print(f"\n6. BÉZOUT COEFFICIENTS MODULO p:")
        print(f"   Step | s mod p | t mod p | r mod p")
        print(f"   " + "-"*50)
        num_steps = min(10, len(xgcd['s_mod']), len(xgcd['r_mod']))
        for i in range(num_steps):
            s_mod = xgcd['s_mod'][i]
            t_mod = xgcd['t_mod'][i]
            r_mod = xgcd['r_mod'][i]
            print(f"   {i:4d} | {s_mod:7d} | {t_mod:7d} | {r_mod:7d}")

    # 7. Key observation: What forces norm = ±2?
    if verbose:
        print(f"\n7. KEY QUESTION:")
        print(f"   x₀ ≡ {x0 % p} (mod {p})")
        if period % 2 == 0 and xgcd_step_for_center < len(norms):
            print(f"   Norm at center = {norms[xgcd_step_for_center]}")
            print(f"   Is |norm| = 2? {abs(norms[xgcd_step_for_center]) == 2}")
            print(f"\n   Can we DERIVE norm = ±2 from x₀ ≡ ±1 (mod p)?")

    return {
        "p": p,
        "period": period,
        "x0": x0,
        "y0": y0,
        "x0_mod_p": x0 % p,
        "d_sequence": surd_d,
        "norms": norms,
        "quotients": xgcd['quotients'],
        "has_center": period % 2 == 0,
        "d_half": surd_seq[period//2][2] if period % 2 == 0 else None,
        "norm_at_center": norms[period//2] if period % 2 == 0 and period//2 < len(norms) else None
    }


def compare_multiple_primes(primes: List[int]) -> None:
    """Compare XGCD structure across multiple primes."""
    print("\n" + "="*70)
    print("COMPARATIVE ANALYSIS ACROSS MULTIPLE PRIMES")
    print("="*70)

    results = []
    for p in primes:
        result = analyze_xgcd_structure(p, verbose=False)
        results.append(result)

    print("\n" + "="*70)
    print("SUMMARY TABLE")
    print("="*70)
    print(f"{'p':>5} | {'τ':>3} | {'x₀ mod p':>10} | {'d[τ/2]':>8} | {'norm@τ/2':>10} | Match?")
    print("-"*70)

    for r in results:
        if r['has_center']:
            norm_str = str(r['norm_at_center']) if r['norm_at_center'] is not None else "N/A"
            match = abs(r['norm_at_center']) == r['d_half'] if r['norm_at_center'] is not None else False
            print(f"{r['p']:5d} | {r['period']:3d} | {r['x0_mod_p']:10d} | {r['d_half']:8} | {norm_str:>10} | {'✓' if match else '✗'}")

    print("\n" + "="*70)
    print("PATTERN OBSERVATIONS:")
    print("="*70)

    # Look for patterns
    p7_results = [r for r in results if r['p'] % 8 == 7]
    p3_results = [r for r in results if r['p'] % 8 == 3]

    if p7_results:
        print(f"\nPrimes ≡ 7 (mod 8): {len(p7_results)} cases")
        x0_mod_patterns = [r['x0_mod_p'] for r in p7_results]
        print(f"  x₀ mod p: {set(x0_mod_patterns)}")
        print(f"  All ≡ 1? {all(x == 1 for x in x0_mod_patterns)}")
        print(f"  All d[τ/2] = 2? {all(r['d_half'] == 2 for r in p7_results if r['has_center'])}")

    if p3_results:
        print(f"\nPrimes ≡ 3 (mod 8): {len(p3_results)} cases")
        x0_mod_patterns = [r['x0_mod_p'] for r in p3_results]
        print(f"  x₀ mod p values: {set(x0_mod_patterns)}")
        print(f"  All d[τ/2] = 2? {all(r['d_half'] == 2 for r in p3_results if r['has_center'])}")


def main():
    """Run systematic analysis."""
    print("SYSTEMATIC XGCD ANALYSIS")
    print("="*70)
    print("\nGoal: Understand if XGCD perspective helps prove d[τ/2] = 2")
    print("      when x₀ ≡ ±1 (mod p)")

    # Test with various period lengths
    test_cases = [
        7,    # τ=4
        23,   # τ=4
        31,   # τ=8
        47,   # τ=5 (odd)
        71,   # τ=7 (odd)
        103,  # τ=11 (odd)
        127,  # τ=12 (even, longer!)
        151,  # τ=14 (even, longer!)
    ]

    # Detailed analysis for a few cases
    for p in [7, 31, 127]:
        analyze_xgcd_structure(p, verbose=True)

    # Comparative analysis
    compare_multiple_primes(test_cases)

    print("\n" + "="*70)
    print("NEXT: Look for patterns that could lead to proof!")
    print("="*70)


if __name__ == "__main__":
    main()
