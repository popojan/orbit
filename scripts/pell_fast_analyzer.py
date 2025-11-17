"""
Fast Pell Structure Analyzer
Computes polynomial-time properties for primes p to find hidden patterns.

Properties computed:
1. Period τ of continued fraction for √p
2. Center convergent (x_c, y_c) and its norm
3. Correlations with p mod 8, h! sign, x₀ mod p pattern

Goal: Reduce exponential chaos (Pell x₀) to polynomial structure (p mod 8, τ, center norm)
"""

import sys
sys.path.append('/home/user/orbit')

from scripts.pell_solver_integer import continued_fraction_period, isqrt
from sympy import isprime, primerange, factorial, legendre_symbol
import csv
from collections import defaultdict

def center_convergent(D):
    """
    Compute center convergent of √D continued fraction.

    For period length τ:
    - Center index: floor((τ-1)/2) or floor(τ/2) depending on theory

    Returns: (x_c, y_c, norm) where norm = x_c² - D·y_c²
    """
    a0, period = continued_fraction_period(D)

    if not period:
        raise ValueError(f"{D} is a perfect square")

    tau = len(period)

    # Center convergent index (convention: mid-point of period)
    # For τ even: index τ/2
    # For τ odd: index (τ-1)/2
    center_idx = tau // 2

    # Build CF sequence up to center
    cf_seq = [a0] + period[:center_idx]

    # Compute convergent at center
    if len(cf_seq) == 1:
        return a0, 1, a0*a0 - D

    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1

    for i in range(1, len(cf_seq)):
        a_i = cf_seq[i]
        p_next = a_i * p_curr + p_prev
        q_next = a_i * q_curr + q_prev

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

    x_c = p_curr
    y_c = q_curr
    norm = x_c * x_c - D * y_c * y_c

    return x_c, y_c, norm

def half_factorial_sign_via_qr(p):
    """
    Compute sign of ((p-1)/2)! mod p using QR ratio criterion.
    Returns +1 or -1.
    """
    if p % 4 != 3:
        raise ValueError("QR ratio criterion only applies to p ≡ 3 (mod 4)")

    h = (p - 1) // 2
    QR_prod = 1
    NQR_prod = 1

    for k in range(1, h + 1):
        legendre = pow(k, (p - 1) // 2, p)
        if legendre == 1:
            QR_prod = (QR_prod * k) % p
        else:
            NQR_prod = (NQR_prod * k) % p

    # Ratio R = QR_prod / NQR_prod
    NQR_inv = pow(NQR_prod, -1, p)
    R = (QR_prod * NQR_inv) % p

    # Test if R is QR or NQR
    R_legendre = pow(R, (p - 1) // 2, p)

    if R_legendre == 1:
        return 1  # h! ≡ +1 (mod p)
    else:
        return -1  # h! ≡ -1 (mod p)

def x0_modp_pattern(p):
    """
    Return predicted x₀ mod p based on empirical pattern.
    p ≡ 1,5 (mod 8): x₀ ≡ -1 (PROVEN)
    p ≡ 3 (mod 8): x₀ ≡ -1 (EMPIRICAL 100%)
    p ≡ 7 (mod 8): x₀ ≡ +1 (EMPIRICAL 100%)

    Returns: +1 or -1 (representing x₀ mod p)
    """
    if p % 8 in [1, 3, 5]:
        return -1  # x₀ ≡ -1 (mod p)
    else:  # p % 8 == 7
        return 1   # x₀ ≡ +1 (mod p)

def analyze_prime(p):
    """
    Analyze single prime p and return all relevant properties.

    Returns dict with:
    - p: prime value
    - p_mod_8: p mod 8
    - tau: period length
    - tau_parity: 'even' or 'odd'
    - tau_mod_4: τ mod 4
    - x_c, y_c: center convergent coordinates
    - center_norm: x_c² - p·y_c²
    - center_norm_sign: sign of norm (+1, -1, or 0)
    - h_sign: ((p-1)/2)! mod p sign (for p ≡ 3 mod 4)
    - x0_pattern: predicted x₀ mod p (+1 or -1)
    """
    a0, period = continued_fraction_period(p)
    tau = len(period)

    x_c, y_c, norm = center_convergent(p)

    result = {
        'p': p,
        'p_mod_8': p % 8,
        'tau': tau,
        'tau_parity': 'even' if tau % 2 == 0 else 'odd',
        'tau_mod_4': tau % 4,
        'x_c': x_c,
        'y_c': y_c,
        'center_norm': norm,
        'center_norm_sign': 1 if norm > 0 else (-1 if norm < 0 else 0),
    }

    # h! sign only for p ≡ 3 (mod 4)
    if p % 4 == 3:
        result['h_sign'] = half_factorial_sign_via_qr(p)
    else:
        result['h_sign'] = None  # Not applicable

    # x₀ pattern (all primes)
    result['x0_pattern'] = x0_modp_pattern(p)

    return result

def analyze_range(pmax=10000):
    """
    Analyze all primes p ≡ 3 (mod 4) up to pmax.
    Returns list of analysis dicts.
    """
    primes = [p for p in primerange(3, pmax+1) if p % 4 == 3]

    print(f"Analyzing {len(primes)} primes p ≡ 3 (mod 4) in range [3, {pmax}]")
    print()

    results = []

    for i, p in enumerate(primes):
        if (i + 1) % 100 == 0:
            print(f"Progress: {i+1}/{len(primes)} primes analyzed...")

        try:
            analysis = analyze_prime(p)
            results.append(analysis)
        except Exception as e:
            print(f"Error analyzing p={p}: {e}")

    print(f"Complete: {len(results)}/{len(primes)} primes analyzed successfully")
    print()

    return results

def compute_correlations(results):
    """
    Compute correlation statistics from analysis results.

    Key questions:
    1. τ parity vs p mod 8?
    2. center norm sign vs p mod 8?
    3. center norm sign vs x₀ pattern?
    4. center norm sign vs h! sign?
    5. τ mod 4 vs all of the above?
    """
    print("="*80)
    print("CORRELATION ANALYSIS")
    print("="*80)
    print()

    # Partition by p mod 8
    p3_results = [r for r in results if r['p_mod_8'] == 3]
    p7_results = [r for r in results if r['p_mod_8'] == 7]

    print(f"p ≡ 3 (mod 8): {len(p3_results)} primes")
    print(f"p ≡ 7 (mod 8): {len(p7_results)} primes")
    print()

    # Correlation 1: τ parity vs p mod 8
    print("-" * 80)
    print("CORRELATION 1: Period parity vs p mod 8")
    print("-" * 80)

    for mod8, subset in [(3, p3_results), (7, p7_results)]:
        even_count = sum(1 for r in subset if r['tau_parity'] == 'even')
        odd_count = sum(1 for r in subset if r['tau_parity'] == 'odd')
        total = len(subset)

        print(f"p ≡ {mod8} (mod 8):")
        print(f"  τ even: {even_count}/{total} ({100*even_count/total:.1f}%)")
        print(f"  τ odd:  {odd_count}/{total} ({100*odd_count/total:.1f}%)")
        print()

    # Correlation 2: center norm sign vs p mod 8
    print("-" * 80)
    print("CORRELATION 2: Center norm sign vs p mod 8")
    print("-" * 80)

    for mod8, subset in [(3, p3_results), (7, p7_results)]:
        pos_count = sum(1 for r in subset if r['center_norm_sign'] == 1)
        neg_count = sum(1 for r in subset if r['center_norm_sign'] == -1)
        zero_count = sum(1 for r in subset if r['center_norm_sign'] == 0)
        total = len(subset)

        print(f"p ≡ {mod8} (mod 8):")
        print(f"  norm > 0: {pos_count}/{total} ({100*pos_count/total:.1f}%)")
        print(f"  norm < 0: {neg_count}/{total} ({100*neg_count/total:.1f}%)")
        print(f"  norm = 0: {zero_count}/{total} ({100*zero_count/total:.1f}%)")
        print()

    # Correlation 3: center norm sign vs x₀ pattern
    print("-" * 80)
    print("CORRELATION 3: Center norm sign vs x₀ mod p pattern")
    print("-" * 80)

    for x0_val in [-1, 1]:
        x0_label = "-1" if x0_val == -1 else "+1"
        subset = [r for r in results if r['x0_pattern'] == x0_val]

        pos_count = sum(1 for r in subset if r['center_norm_sign'] == 1)
        neg_count = sum(1 for r in subset if r['center_norm_sign'] == -1)
        total = len(subset)

        print(f"x₀ ≡ {x0_label} (mod p):")
        print(f"  center norm > 0: {pos_count}/{total} ({100*pos_count/total:.1f}%)")
        print(f"  center norm < 0: {neg_count}/{total} ({100*neg_count/total:.1f}%)")
        print()

    # Correlation 4: center norm sign vs h! sign (p ≡ 3 mod 4 only)
    print("-" * 80)
    print("CORRELATION 4: Center norm sign vs h! sign")
    print("-" * 80)

    for h_val in [-1, 1]:
        h_label = "-1" if h_val == -1 else "+1"
        subset = [r for r in results if r['h_sign'] == h_val]

        pos_count = sum(1 for r in subset if r['center_norm_sign'] == 1)
        neg_count = sum(1 for r in subset if r['center_norm_sign'] == -1)
        total = len(subset)

        print(f"h! ≡ {h_label} (mod p):")
        print(f"  center norm > 0: {pos_count}/{total} ({100*pos_count/total:.1f}%)")
        print(f"  center norm < 0: {neg_count}/{total} ({100*neg_count/total:.1f}%)")
        print()

    # Correlation 5: τ mod 4 distribution
    print("-" * 80)
    print("CORRELATION 5: Period τ mod 4 distribution")
    print("-" * 80)

    for mod8, subset in [(3, p3_results), (7, p7_results)]:
        tau_mod4_dist = defaultdict(int)
        for r in subset:
            tau_mod4_dist[r['tau_mod_4']] += 1

        total = len(subset)
        print(f"p ≡ {mod8} (mod 8):")
        for tau_mod in sorted(tau_mod4_dist.keys()):
            count = tau_mod4_dist[tau_mod]
            print(f"  τ ≡ {tau_mod} (mod 4): {count}/{total} ({100*count/total:.1f}%)")
        print()

def save_results_to_csv(results, filename='/tmp/pell_analysis_results.csv'):
    """Save analysis results to CSV for further analysis."""
    if not results:
        print("No results to save.")
        return

    fieldnames = results[0].keys()

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(results)

    print(f"Results saved to {filename}")
    print()

if __name__ == "__main__":
    print("Pell Fast Analyzer - Breaking the Strange Loop")
    print("=" * 80)
    print()
    print("Goal: Reduce exponential chaos (Pell x₀) to polynomial structure")
    print()

    # Analyze primes up to 10000
    results = analyze_range(pmax=10000)

    # Compute correlations
    compute_correlations(results)

    # Save to CSV
    save_results_to_csv(results)

    print("="*80)
    print("Analysis complete!")
    print("Next: Look for patterns in the correlation matrix")
    print("="*80)
