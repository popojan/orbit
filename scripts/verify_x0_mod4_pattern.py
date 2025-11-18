#!/usr/bin/env python3
"""
Derive and verify x₀ mod 4 pattern from k pattern

From k pattern:
  p ≡ 1,5 (mod 8): k ≡ 2 (mod 4), x₀ = kp - 1
  p ≡ 3 (mod 8):   k ≡ 1 (mod 4), x₀ = kp - 1
  p ≡ 7 (mod 8):   k ≡ 1 (mod 4), x₀ = kp + 1

Can we predict x₀ mod 4 directly from p?
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

def predict_x0_mod4(p):
    """
    Predict x₀ mod 4 from p mod 8

    Derivation:
    p ≡ 1 (mod 8): x₀ = kp - 1, k ≡ 2 (mod 4)
      k = 4m + 2 → x₀ = (4m+2)p - 1 = 4mp + 2p - 1
      p ≡ 1 (mod 8) → 2p ≡ 2 (mod 16) ≡ 2 (mod 4)
      x₀ mod 4 = (2 - 1) mod 4 = 1

    p ≡ 3 (mod 8): x₀ = kp - 1, k ≡ 1 (mod 4)
      k = 4m + 1 → x₀ = (4m+1)p - 1 = 4mp + p - 1
      p ≡ 3 (mod 4) → x₀ mod 4 = (3 - 1) mod 4 = 2

    p ≡ 5 (mod 8): x₀ = kp - 1, k ≡ 2 (mod 4)
      k = 4m + 2 → x₀ = (4m+2)p - 1 = 4mp + 2p - 1
      p ≡ 5 (mod 8) → 2p ≡ 10 ≡ 2 (mod 4)
      x₀ mod 4 = (2 - 1) mod 4 = 1

    p ≡ 7 (mod 8): x₀ = kp + 1, k ≡ 1 (mod 4)
      k = 4m + 1 → x₀ = (4m+1)p + 1 = 4mp + p + 1
      p ≡ 7 (mod 8) ≡ 3 (mod 4) → x₀ mod 4 = (3 + 1) mod 4 = 0
    """
    p_mod_8 = p % 8

    if p_mod_8 == 1:
        return 1
    elif p_mod_8 == 3:
        return 2
    elif p_mod_8 == 5:
        return 1
    elif p_mod_8 == 7:
        return 0
    else:
        raise ValueError(f"Invalid p mod 8: {p_mod_8}")

def test_x0_mod4_pattern(primes):
    """Test x₀ mod 4 prediction"""
    results = []

    for p in primes:
        x0, y0 = pell_fundamental_solution(p)

        predicted = predict_x0_mod4(p)
        actual = x0 % 4
        correct = (predicted == actual)

        results.append({
            'p': p,
            'p_mod_8': p % 8,
            'x0': x0,
            'x0_mod_4': actual,
            'predicted': predicted,
            'correct': correct
        })

    return results

def print_results(results):
    print("=" * 80)
    print("x₀ MOD 4 PATTERN VERIFICATION")
    print("=" * 80)
    print()

    print("Predicted pattern:")
    print("  p ≡ 1 (mod 8) → x₀ ≡ 1 (mod 4)")
    print("  p ≡ 3 (mod 8) → x₀ ≡ 2 (mod 4)")
    print("  p ≡ 5 (mod 8) → x₀ ≡ 1 (mod 4)")
    print("  p ≡ 7 (mod 8) → x₀ ≡ 0 (mod 4)")
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
        pred_val = group[0]['predicted']

        print(f"p ≡ {mod8} (mod 8): predicted x₀ ≡ {pred_val} (mod 4)")
        print(f"  Accuracy: {correct}/{total} = {100.0 * correct / total:.1f}%")

        failures = [r for r in group if not r['correct']]
        if failures:
            print(f"  FAILURES:")
            for r in failures:
                print(f"    p={r['p']}: predicted {r['predicted']}, actual {r['x0_mod_4']}")
        print()

    # Overall
    total_correct = sum(1 for r in results if r['correct'])
    total = len(results)
    print("=" * 80)
    print(f"OVERALL: {total_correct}/{total} = {100.0 * total_correct / total:.1f}%")
    print("=" * 80)
    print()

    # Show what we now know
    print("CUMULATIVE KNOWLEDGE:")
    print("=" * 80)
    print("We can now predict:")
    print("  1. x₀ mod p   (from sign pattern)")
    print("  2. x₀ mod 2   (parity pattern)")
    print("  3. x₀ mod 4   (this pattern)")
    print()
    print("Via CRT, we can reconstruct:")
    print("  → x₀ mod (4p)")
    print()
    print("For p ≡ 1 (mod 8):")
    print("  x₀ ≡ -1 (mod p), x₀ ≡ 1 (mod 4)")
    print("  → Can determine x₀ mod (4p)")
    print()

if __name__ == '__main__':
    test_primes = [p for p in range(3, 1000) if is_prime(p)]

    print(f"Testing x₀ mod 4 pattern for {len(test_primes)} primes...\n")

    results = test_x0_mod4_pattern(test_primes)
    print_results(results)
