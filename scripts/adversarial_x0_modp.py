#!/usr/bin/env python3
"""
ADVERSARIAL FALSIFICATION: x₀ mod p pattern (ORIGINAL, STRONGER)

Pattern to test:
  p ≡ 1,5 (mod 8) → x₀ ≡ -1 (mod p)  [PROVEN via negative Pell]
  p ≡ 3   (mod 8) → x₀ ≡ -1 (mod p)  [311/311 empirical]
  p ≡ 7   (mod 8) → x₀ ≡ +1 (mod p)  [171/171 empirical]

This is STRONGER than ν₂(x₀) pattern!
  - Determines x₀ modulo p (exponentially large!)
  - Complete classification (4/4 classes)
  - 100% coverage

Edge cases to test:
  - Mersenne primes
  - Sophie Germain primes
  - Primes near powers of 2
  - Primes near perfect squares
  - Large primes (up to computable limits)

Goal: Falsify empirical cases (p ≡ 3,7 mod 8) or strengthen confidence
"""

import sys
sys.path.append('/home/user/orbit/scripts')
from pell_solver_integer import pell_fundamental_solution
from universal_prime_tester import PrimeTester

def x0_modp_pattern(p):
    """
    Test x₀ mod p pattern (ORIGINAL, STRONGER).

    Returns (predicted, actual, metadata) or None
    """
    p_mod_8 = p % 8

    if p_mod_8 in [1, 5]:
        # PROVEN cases
        predicted = p - 1  # ≡ -1 (mod p)
        proven = True
    elif p_mod_8 == 3:
        # EMPIRICAL case 1
        predicted = p - 1  # ≡ -1 (mod p)
        proven = False
    elif p_mod_8 == 7:
        # EMPIRICAL case 2
        predicted = 1      # ≡ +1 (mod p)
        proven = False
    else:
        # p ≡ 2,4,6 (mod 8) - even, skip
        return None

    # Compute actual
    x0, y0 = pell_fundamental_solution(p)
    actual = x0 % p

    metadata = {
        'p_mod_8': p_mod_8,
        'proven': proven,
        'x0': x0 if x0 < 10**50 else f"{x0:.5e}"  # Truncate huge x0 for display
    }

    return (predicted, actual, metadata)


def main():
    print("=" * 80)
    print("ADVERSARIAL TEST: x₀ mod p PATTERN (ORIGINAL, STRONGER)")
    print("=" * 80)
    print()
    print("Testing pattern:")
    print("  p ≡ 1,5 (mod 8) → x₀ ≡ -1 (mod p)  [PROVEN]")
    print("  p ≡ 3   (mod 8) → x₀ ≡ -1 (mod p)  [EMPIRICAL]")
    print("  p ≡ 7   (mod 8) → x₀ ≡ +1 (mod p)  [EMPIRICAL]")
    print()
    print("This is STRONGER than ν₂(x₀) - determines x₀ modulo p!")
    print()

    tester = PrimeTester(x0_modp_pattern, "x₀ mod p adversarial test")

    # Add sources (focus on edge cases)
    print("Sources to test:")
    print("  1. Random primes up to 100,000")
    print("  2. Mersenne primes (2^q - 1)")
    print("  3. Primes near powers of 2")
    print("  4. Primes near perfect squares")
    print("  5. Sophie Germain primes")
    print("  6. Safe primes (2q+1)")
    print()

    tester.add_source("random", p_max=100000)
    tester.add_source("mersenne", q_max=127)
    tester.add_source("near_powers_2", k_max=25, delta_max=50)
    tester.add_source("near_squares", n_max=5000, delta_max=15)
    tester.add_source("sophie_germain", p_max=500000)
    tester.add_source("safe", p_max=500000)

    # Run tests
    results = tester.run(verbose=True)

    # Additional analysis
    print()
    print("=" * 80)
    print("BREAKDOWN BY p mod 8")
    print("=" * 80)
    print()

    # Group results by p mod 8
    by_mod8 = {1: {'tested': 0, 'failures': 0, 'proven': True},
               3: {'tested': 0, 'failures': 0, 'proven': False},
               5: {'tested': 0, 'failures': 0, 'proven': True},
               7: {'tested': 0, 'failures': 0, 'proven': False}}

    # Count successes (reverse engineer from total - failures)
    # We need to track which mod8 class each test was
    # Actually, we can re-run just for classification
    for source_type, kwargs in tester.sources:
        for p, label in tester._generate_primes(source_type, **kwargs):
            p_mod_8 = p % 8
            if p_mod_8 not in by_mod8:
                continue

            result = x0_modp_pattern(p)
            if result is None:
                continue

            predicted, actual, metadata = result
            by_mod8[p_mod_8]['tested'] += 1

            if predicted != actual:
                by_mod8[p_mod_8]['failures'] += 1

    for mod8 in sorted(by_mod8.keys()):
        data = by_mod8[mod8]
        status = "PROVEN ✅" if data['proven'] else "EMPIRICAL 🔬"
        successes = data['tested'] - data['failures']

        if data['tested'] > 0:
            pct = 100.0 * successes / data['tested']
            print(f"p ≡ {mod8} (mod 8): {successes}/{data['tested']} = {pct:.2f}% | {status}")

            if data['failures'] > 0:
                print(f"  ✗ {data['failures']} COUNTEREXAMPLES!")

    print()

    # Final verdict
    if results['failures']:
        print("⚠️  PATTERN FALSIFIED - counterexamples found!")
        print()
        print("Empirical cases (p ≡ 3,7 mod 8) are NOT universal!")
    else:
        print("✓ NO COUNTEREXAMPLES in tested range")
        print()
        print("Empirical cases hold for:")
        print(f"  - {by_mod8[3]['tested']} primes p ≡ 3 (mod 8)")
        print(f"  - {by_mod8[7]['tested']} primes p ≡ 7 (mod 8)")
        print()
        print("This STRENGTHENS (but does not prove) the empirical conjecture.")

    return 1 if results['failures'] else 0


if __name__ == '__main__':
    exit_code = main()
    sys.exit(exit_code)
