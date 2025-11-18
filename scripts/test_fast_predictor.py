#!/usr/bin/env python3
"""
Test fast x₀ mod p predictor based on p mod 8
Compare predictions with actual Pell solutions
"""

import sys
sys.path.append('/home/user/orbit/scripts')
from pell_solver_integer import pell_fundamental_solution

def predict_x0_mod_p_fast(p):
    """
    Predict x₀ mod p in O(1) time based on p mod 8

    Based on:
    - PROVEN: p ≡ 1 (mod 4) → x₀ ≡ -1 (mod p)
    - EMPIRICAL: p ≡ 3 (mod 8) → x₀ ≡ -1 (mod p)
    - EMPIRICAL: p ≡ 7 (mod 8) → x₀ ≡ +1 (mod p)
    """
    p_mod_8 = p % 8

    if p_mod_8 in [1, 5]:  # p ≡ 1 (mod 4)
        return p - 1  # ≡ -1 (mod p) [PROVEN via negative Pell]
    elif p_mod_8 == 3:
        return p - 1  # ≡ -1 (mod p) [EMPIRICAL 100%]
    elif p_mod_8 == 7:
        return 1      # ≡ +1 (mod p) [EMPIRICAL 100%]
    else:
        raise ValueError(f"p = {p} is not odd prime")

def is_prime(n):
    """Quick primality check"""
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

def test_predictor(primes):
    """Test predictor against actual Pell solutions"""
    results = []

    for p in primes:
        # Get actual Pell solution
        x0, y0 = pell_fundamental_solution(p)
        actual_x0_mod_p = x0 % p

        # Predict
        predicted_x0_mod_p = predict_x0_mod_p_fast(p)

        # Compare
        correct = (predicted_x0_mod_p == actual_x0_mod_p)

        results.append({
            'p': p,
            'p_mod_8': p % 8,
            'actual': actual_x0_mod_p,
            'predicted': predicted_x0_mod_p,
            'correct': correct,
            'x0': x0,
            'y0': y0
        })

    return results

def print_results(results):
    """Print test results"""
    print("=" * 80)
    print("FAST x₀ mod p PREDICTOR TEST")
    print("=" * 80)
    print()

    # Group by p mod 8
    by_mod8 = {1: [], 3: [], 5: [], 7: []}
    for r in results:
        by_mod8[r['p_mod_8']].append(r)

    for mod8_class in [1, 5, 3, 7]:
        if not by_mod8[mod8_class]:
            continue

        print(f"p ≡ {mod8_class} (mod 8):")
        print("-" * 80)

        for r in by_mod8[mod8_class]:
            status = "✓" if r['correct'] else "✗"
            print(f"  p = {r['p']:5d}: predicted {r['predicted']:5d}, actual {r['actual']:5d}  {status}")

        correct_count = sum(1 for r in by_mod8[mod8_class] if r['correct'])
        total = len(by_mod8[mod8_class])
        print(f"  Accuracy: {correct_count}/{total} = {100.0 * correct_count / total:.1f}%")
        print()

    # Overall
    print("=" * 80)
    total_correct = sum(1 for r in results if r['correct'])
    total = len(results)
    print(f"OVERALL ACCURACY: {total_correct}/{total} = {100.0 * total_correct / total:.1f}%")
    print("=" * 80)

if __name__ == '__main__':
    # Test with primes up to 1000
    test_primes = [p for p in range(3, 1000) if is_prime(p)]

    print(f"Testing {len(test_primes)} primes from 3 to 997...")
    print()

    results = test_predictor(test_primes)
    print_results(results)

    # Show failures if any
    failures = [r for r in results if not r['correct']]
    if failures:
        print("\nFAILURES:")
        for r in failures:
            print(f"  p = {r['p']}: predicted {r['predicted']}, actual {r['actual']}")
