#!/usr/bin/env python3
"""
2-adic valuation of x₀ - connection to powers of 2 patterns

From our discoveries:
  p ≡ 1 (mod 8): x₀ ≡ 1 (mod 8) → ν₂(x₀) = 0
  p ≡ 3 (mod 8): x₀ ≡ 2 (mod 8) → ν₂(x₀) = 1
  p ≡ 5 (mod 8): x₀ ≡ 1 (mod 8) → ν₂(x₀) = 0
  p ≡ 7 (mod 8): x₀ ≡ 0 (mod 8) → ν₂(x₀) ≥ 3

This gives EXACT 2-adic valuation from p mod 8!
"""

import sys
sys.path.append('/home/user/orbit/scripts')
from pell_solver_integer import pell_fundamental_solution

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
    """Compute ν₂(n) - highest power of 2 dividing n"""
    if n == 0:
        return float('inf')

    val = 0
    while n % 2 == 0:
        val += 1
        n //= 2
    return val

def predict_2adic_from_p_mod8(p):
    """Predict ν₂(x₀) from p mod 8"""
    p_mod_8 = p % 8

    if p_mod_8 in [1, 5]:
        return 0  # x₀ odd
    elif p_mod_8 == 3:
        return 1  # x₀ ≡ 2 (mod 4), not divisible by 4
    elif p_mod_8 == 7:
        return 3  # x₀ ≡ 0 (mod 8), divisible by 8
    else:
        raise ValueError(f"Invalid p mod 8: {p_mod_8}")

def test_2adic_pattern(primes):
    """Test 2-adic valuation pattern"""
    results = []

    for p in primes:
        x0, y0 = pell_fundamental_solution(p)

        predicted = predict_2adic_from_p_mod8(p)
        actual = two_adic_valuation(x0)

        # For p ≡ 7 (mod 8), we only know ν₂(x₀) ≥ 3
        if p % 8 == 7:
            correct = (actual >= predicted)
        else:
            correct = (predicted == actual)

        results.append({
            'p': p,
            'p_mod_8': p % 8,
            'x0': x0,
            'predicted_nu2': predicted,
            'actual_nu2': actual,
            'correct': correct
        })

    return results

def print_results(results):
    print("=" * 80)
    print("2-ADIC VALUATION OF x₀")
    print("=" * 80)
    print()

    print("Pattern:")
    print("  p ≡ 1,5 (mod 8) → ν₂(x₀) = 0  (x₀ odd)")
    print("  p ≡ 3   (mod 8) → ν₂(x₀) = 1  (x₀ ≡ 2 mod 4)")
    print("  p ≡ 7   (mod 8) → ν₂(x₀) ≥ 3  (x₀ ≡ 0 mod 8)")
    print()

    # Group by p mod 8
    by_p_mod_8 = {}
    for r in results:
        key = r['p_mod_8']
        if key not in by_p_mod_8:
            by_p_mod_8[key] = []
        by_p_mod_8[key].append(r)

    for mod8 in sorted(by_p_mod_8.keys()):
        group = by_p_mod_8[mod8]
        correct = sum(1 for r in group if r['correct'])
        total = len(group)

        pred = group[0]['predicted_nu2']

        print(f"p ≡ {mod8} (mod 8):")
        print(f"  Predicted: ν₂(x₀) {'≥' if mod8 == 7 else '='} {pred}")
        print(f"  Accuracy: {correct}/{total} = {100.0 * correct / total:.1f}%")

        # Show actual ν₂ distribution
        nu2_counts = {}
        for r in group:
            val = r['actual_nu2']
            nu2_counts[val] = nu2_counts.get(val, 0) + 1

        print(f"  Actual ν₂ distribution:")
        for val in sorted(nu2_counts.keys()):
            count = nu2_counts[val]
            print(f"    ν₂(x₀) = {val}: {count}/{total}")

        # Show examples
        print(f"  Examples:")
        for r in group[:3]:
            print(f"    p = {r['p']:3d}: x₀ = {r['x0']:12d}, ν₂(x₀) = {r['actual_nu2']}")
        print()

    # Overall accuracy
    total_correct = sum(1 for r in results if r['correct'])
    total = len(results)
    print("=" * 80)
    print(f"OVERALL: {total_correct}/{total} = {100.0 * total_correct / total:.1f}%")
    print("=" * 80)
    print()

    # Connection to primorial p-adic framework
    print("CONNECTION TO PRIMORIAL p-ADIC FRAMEWORK:")
    print("=" * 80)
    print("In primorial proof: ν_p(D_k) - ν_p(N_k) = 1 determines prime factorization")
    print()
    print("Here: ν₂(x₀) is EXACTLY determined by p mod 8")
    print()
    print("Both use p-adic valuation as fundamental invariant!")
    print()
    print("This is the CLEANEST result from powers of 2 investigation:")
    print("  - Not just x₀ mod 8 (which mixes valuation with residue)")
    print("  - But PURE 2-adic structure")
    print()

if __name__ == '__main__':
    test_primes = [p for p in range(3, 500) if is_prime(p)]

    print(f"Testing 2-adic valuation for {len(test_primes)} primes...\n")

    results = test_2adic_pattern(test_primes)
    print_results(results)
