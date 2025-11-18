#!/usr/bin/env python3
"""
Verify x₀ mod 2 pattern discovery

Pattern hypothesis:
  p ≡ 1 (mod 4) → x₀ is ODD
  p ≡ 3 (mod 4) → x₀ is EVEN
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

def test_x0_mod2_pattern(primes):
    """Test x₀ mod 2 pattern"""
    results = []

    for p in primes:
        x0, y0 = pell_fundamental_solution(p)

        p_mod_4 = p % 4
        x0_mod_2 = x0 % 2

        # Predicted parity
        predicted_parity = 1 if p_mod_4 == 1 else 0  # 1=odd, 0=even

        correct = (x0_mod_2 == predicted_parity)

        results.append({
            'p': p,
            'p_mod_4': p_mod_4,
            'p_mod_8': p % 8,
            'x0_mod_2': x0_mod_2,
            'predicted': predicted_parity,
            'correct': correct,
            'x0': x0
        })

    return results

def print_results(results):
    print("=" * 80)
    print("x₀ MOD 2 PATTERN VERIFICATION")
    print("=" * 80)
    print()

    print("Pattern hypothesis:")
    print("  p ≡ 1 (mod 4) → x₀ ≡ 1 (mod 2)  [ODD]")
    print("  p ≡ 3 (mod 4) → x₀ ≡ 0 (mod 2)  [EVEN]")
    print()

    # Group by p mod 4
    by_p_mod_4 = {1: [], 3: []}
    for r in results:
        by_p_mod_4[r['p_mod_4']].append(r)

    for mod4_class in [1, 3]:
        group = by_p_mod_4[mod4_class]
        if not group:
            continue

        print(f"p ≡ {mod4_class} (mod 4):")
        print("-" * 80)

        correct_count = sum(1 for r in group if r['correct'])
        total = len(group)

        print(f"  Tested: {total} primes")
        print(f"  Correct: {correct_count}/{total} = {100.0 * correct_count / total:.1f}%")

        # Show failures if any
        failures = [r for r in group if not r['correct']]
        if failures:
            print(f"  FAILURES:")
            for r in failures:
                print(f"    p={r['p']}: predicted {r['predicted']}, actual {r['x0_mod_2']}")
        else:
            print(f"  ✓ All correct!")

        print()

    # Overall
    total_correct = sum(1 for r in results if r['correct'])
    total = len(results)
    print("=" * 80)
    print(f"OVERALL: {total_correct}/{total} = {100.0 * total_correct / total:.1f}%")
    print("=" * 80)
    print()

    # Show distribution by p mod 8
    print("Breakdown by p mod 8:")
    print("-" * 80)
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
        x0_parity = "ODD" if group[0]['predicted'] == 1 else "EVEN"
        print(f"  p ≡ {mod8} (mod 8): {correct}/{total} correct → x₀ is {x0_parity}")

if __name__ == '__main__':
    # Test with primes up to 1000
    test_primes = [p for p in range(3, 1000) if is_prime(p)]

    print(f"Testing x₀ mod 2 pattern for {len(test_primes)} primes...\n")

    results = test_x0_mod2_pattern(test_primes)
    print_results(results)

    # CRT implications
    print("\nCRT RECONSTRUCTION IMPLICATIONS:")
    print("=" * 80)
    print("We now know:")
    print("  1. x₀ mod p  (from previous pattern)")
    print("  2. x₀ mod 2  (from this pattern)")
    print()
    print("→ Via CRT: x₀ mod (2p)")
    print()
    print("For p ≡ 1 (mod 4): x₀ ≡ -1 (mod p) and x₀ ≡ 1 (mod 2)")
    print("  → x₀ ≡ p - 1 (mod 2p)  [since p-1 is even and ≡ -1 mod p]")
    print()
    print("For p ≡ 3 (mod 4): x₀ ≡ ±1 (mod p) and x₀ ≡ 0 (mod 2)")
    print("  → Need to determine which of {p-1, 2p-1} for p≡3 mod 8")
    print("  → Need to determine which of {1, p+1} for p≡7 mod 8")
    print()
