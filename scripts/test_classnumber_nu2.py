#!/usr/bin/env python3
"""
Test: Does class number h(p) determine ν₂(x₀) for variable cases?

Using PARI/GP qfbclassno() to compute h(p).

Falsifiable hypotheses:
1. h(p) mod 2 determines ν₂(x₀)?
2. h(p) size correlates with ν₂(x₀)?
3. (M(p±1), h(p)) joint determines ν₂(x₀)?
"""

import sys
sys.path.append('/home/user/orbit/scripts')
from pell_solver_integer import pell_fundamental_solution
import subprocess

def is_prime(n):
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(n**0.5) + 1, 2):
        if n % i == 0:
            return False
    return True

def two_adic_valuation(n):
    if n == 0:
        return float('inf')
    val = 0
    while n % 2 == 0:
        val += 1
        n //= 2
    return val

def class_number_pari(D):
    """Compute h(D) via PARI/GP."""
    try:
        disc = D if D % 4 == 1 else 4 * D
        result = subprocess.run(
            ['gp', '-q', '-f'],
            input=f'print(qfbclassno({disc}))\n',
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            return int(result.stdout.strip())
        return None
    except:
        return None

def count_divisors(n):
    if n <= 0:
        return 0
    count = 0
    i = 1
    while i * i <= n:
        if n % i == 0:
            count += 1
            if i * i != n:
                count += 1
        i += 1
    return count

def M(n):
    tau_n = count_divisors(n)
    return (tau_n - 1) // 2

def test_classnumber_correlation(primes, mod_class):
    """Test h(p) correlation with ν₂(x₀)"""
    results = []

    print(f"Computing h(p) for p ≡ {mod_class} (mod 32)...")
    print(f"Progress: ", end="", flush=True)

    count = 0
    for p in primes:
        if p % 32 != mod_class:
            continue

        if count % 10 == 0:
            print(f"{count} ", end="", flush=True)
        count += 1

        x0, y0 = pell_fundamental_solution(p)
        nu2_x0 = two_adic_valuation(x0)

        h = class_number_pari(p)
        if h is None:
            continue

        M_p_minus_1 = M(p - 1)
        M_p_plus_1 = M(p + 1)

        results.append({
            'p': p,
            'h': h,
            'h_mod_2': h % 2,
            'h_mod_4': h % 4,
            'M_p_minus_1': M_p_minus_1,
            'M_p_plus_1': M_p_plus_1,
            'nu2_x0': nu2_x0
        })

    print(f"\n{len(results)} primes analyzed\n")
    return results

def analyze_h_correlation(results, mod_class):
    """Analyze h(p) correlation"""
    print("=" * 80)
    print(f"CASE: p ≡ {mod_class} (mod 32)")
    print("=" * 80)
    print(f"Sample size: {len(results)}")
    print()

    # h distribution
    from collections import Counter
    h_vals = [r['h'] for r in results]
    h_dist = Counter(h_vals)

    print("Class number h(p) distribution:")
    print("-" * 80)
    for h_val in sorted(h_dist.keys()):
        count = h_dist[h_val]
        pct = 100.0 * count / len(results)
        print(f"  h = {h_val:2d}: {count:2d}/{len(results)} = {pct:5.1f}%")
    print()

    # h mod 2
    print("Correlation: h(p) mod 2 → ν₂(x₀)")
    print("-" * 80)
    by_h_mod_2 = {}
    for r in results:
        key = r['h_mod_2']
        if key not in by_h_mod_2:
            by_h_mod_2[key] = []
        by_h_mod_2[key].append(r['nu2_x0'])

    for val in sorted(by_h_mod_2.keys()):
        nu2_vals = by_h_mod_2[val]
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        h_label = "ODD" if val == 1 else "EVEN"
        status = "DETERMINISTIC ✅" if is_det else "VARIABLE"
        print(f"\nh(p) ≡ {val} (mod 2) [{h_label}]: {len(nu2_vals)} primes → {status}")

        if is_det:
            print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
        else:
            for nu2 in sorted(counts.keys()):
                pct = 100.0 * counts[nu2] / len(nu2_vals)
                print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    # h value directly
    print()
    print("Correlation: h(p) value → ν₂(x₀)")
    print("-" * 80)
    by_h = {}
    for r in results:
        key = r['h']
        if key not in by_h:
            by_h[key] = []
        by_h[key].append(r['nu2_x0'])

    for h_val in sorted(by_h.keys()):
        nu2_vals = by_h[h_val]
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 2:
            status = "DETERMINISTIC ✅" if is_det else "VARIABLE"
            print(f"\nh(p) = {h_val}: {len(nu2_vals)} primes → {status}")

            if is_det:
                print(f"  ν₂(x₀) = {list(counts.keys())[0]} ALWAYS")
            else:
                for nu2 in sorted(counts.keys()):
                    pct = 100.0 * counts[nu2] / len(nu2_vals)
                    print(f"  ν₂(x₀) = {nu2}: {counts[nu2]:2d}/{len(nu2_vals)} = {pct:5.1f}%")

    # Joint: (M(p-1), h(p))
    print()
    print("Joint: (M(p-1), h(p)) → ν₂(x₀)")
    print("-" * 80)
    by_joint = {}
    for r in results:
        key = (r['M_p_minus_1'], r['h'])
        if key not in by_joint:
            by_joint[key] = []
        by_joint[key].append(r['nu2_x0'])

    deterministic_count = 0
    total_with_samples = 0

    for (M_val, h_val) in sorted(by_joint.keys()):
        nu2_vals = by_joint[(M_val, h_val)]
        counts = Counter(nu2_vals)
        unique = len(counts)
        is_det = (unique == 1)

        if len(nu2_vals) >= 2:
            total_with_samples += 1
            if is_det:
                deterministic_count += 1

        if len(nu2_vals) >= 2:
            status = "✅ DET" if is_det else "VAR"
            print(f"(M(p-1)={M_val:2d}, h={h_val:2d}): n={len(nu2_vals):2d} → {status}", end="")

            if is_det:
                print(f" | ν₂(x₀) = {list(counts.keys())[0]}")
            else:
                print(f" | {dict(counts)}")

    print()
    print(f"Deterministic: {deterministic_count}/{total_with_samples} = {100.0*deterministic_count/total_with_samples:.1f}%")
    print()

def main():
    test_primes = [p for p in range(7, 10000) if is_prime(p) and p % 8 == 7]

    # Test p ≡ 15 (mod 32)
    results_15 = test_classnumber_correlation(test_primes, 15)
    analyze_h_correlation(results_15, 15)

    print()
    print("=" * 80)
    print()

    # Test p ≡ 31 (mod 32)
    results_31 = test_classnumber_correlation(test_primes, 31)
    analyze_h_correlation(results_31, 31)

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print("If h(p) determines ν₂(x₀):")
    print("  → DEEP connection: class group structure → 2-adic Pell behavior")
    print("  → Algebraic number theory explains chaos!")
    print()
    print("If still variable:")
    print("  → h(p) alone insufficient")
    print("  → May need finer invariants (2-rank? genus?)")
    print()

if __name__ == '__main__':
    main()
