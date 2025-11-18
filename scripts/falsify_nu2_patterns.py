#!/usr/bin/env python3
"""
FALSIFICATION TEST: Try to break ν₂(x₀) patterns

Alleged 100% patterns (in sample p < 10000):
  p ≡ 1  (mod 32) → ν₂(x₀) = 0
  p ≡ 3  (mod 32) → ν₂(x₀) = 1
  p ≡ 5  (mod 32) → ν₂(x₀) = 0
  p ≡ 7  (mod 32) → ν₂(x₀) = 3
  p ≡ 23 (mod 32) → ν₂(x₀) = 3

Goal: FIND COUNTEREXAMPLE or strengthen evidence

Strategy:
  - Test larger primes (p up to 100,000 or more)
  - Focus on edge cases (large p, unusual cases)
  - Report FIRST failure immediately
  - If no failures: report statistics
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
    if n == 0:
        return float('inf')
    val = 0
    while n % 2 == 0:
        val += 1
        n //= 2
    return val

def predict_nu2(p):
    """Predicted ν₂(x₀) based on alleged pattern"""
    p_mod_32 = p % 32

    if p_mod_32 in [1, 5]:
        return 0
    elif p_mod_32 == 3:
        return 1
    elif p_mod_32 in [7, 23]:
        return 3
    else:
        return None  # Variable cases (15, 31)

def test_falsification(p_max, verbose=True):
    """
    Test patterns up to p_max.

    Returns: (total_tested, failures, first_failure)
    """
    print("=" * 80)
    print("FALSIFICATION TEST")
    print("=" * 80)
    print()
    print(f"Testing primes p ≡ 1,3,5,7,23 (mod 32) up to {p_max}")
    print()

    # Only test allegedly deterministic classes
    deterministic_classes = [1, 3, 5, 7, 23]

    tested = {mod: 0 for mod in deterministic_classes}
    failures = {mod: [] for mod in deterministic_classes}

    print("Progress: ", end="", flush=True)

    count = 0
    for p in range(7, p_max + 1):
        if not is_prime(p):
            continue

        p_mod_32 = p % 32
        if p_mod_32 not in deterministic_classes:
            continue

        if count % 100 == 0:
            print(f"{count} ", end="", flush=True)
        count += 1

        # Get actual ν₂(x₀)
        try:
            x0, y0 = pell_fundamental_solution(p)
            nu2_actual = two_adic_valuation(x0)
            nu2_predicted = predict_nu2(p)

            tested[p_mod_32] += 1

            # Check for failure
            if nu2_actual != nu2_predicted:
                failure_data = {
                    'p': p,
                    'p_mod_32': p_mod_32,
                    'predicted': nu2_predicted,
                    'actual': nu2_actual,
                    'x0': x0
                }
                failures[p_mod_32].append(failure_data)

                # IMMEDIATE REPORT on first failure
                if verbose and sum(len(f) for f in failures.values()) == 1:
                    print("\n\n" + "!" * 80)
                    print("COUNTEREXAMPLE FOUND!")
                    print("!" * 80)
                    print(f"  p = {p}")
                    print(f"  p mod 32 = {p_mod_32}")
                    print(f"  Predicted: ν₂(x₀) = {nu2_predicted}")
                    print(f"  Actual: ν₂(x₀) = {nu2_actual}")
                    print(f"  x₀ = {x0}")
                    print("!" * 80)
                    print()
                    print("Continuing to find more...\n")

        except Exception as e:
            if verbose:
                print(f"\nError at p={p}: {e}")
            continue

    print(f"\n\nCompleted: {count} primes tested\n")

    return tested, failures

def print_results(tested, failures):
    """Print summary statistics"""
    print("=" * 80)
    print("RESULTS")
    print("=" * 80)
    print()

    total_tested = sum(tested.values())
    total_failures = sum(len(f) for f in failures.values())

    print(f"Total tested: {total_tested}")
    print(f"Total failures: {total_failures}")
    print()

    if total_failures == 0:
        print("✓ NO COUNTEREXAMPLES FOUND")
        print()
        print("Pattern holds for all tested primes!")
        print()
        print("Breakdown by class:")
        print("-" * 80)
        for mod in sorted(tested.keys()):
            predicted = predict_nu2(mod)
            print(f"  p ≡ {mod:2d} (mod 32): {tested[mod]:5d} primes, "
                  f"all have ν₂(x₀) = {predicted}")
        print()
        print("This strengthens (but does NOT prove) the pattern.")
        print("For rigorous proof, need theoretical argument.")
    else:
        print("✗ PATTERN FALSIFIED!")
        print()
        print("Counterexamples found:")
        print("-" * 80)
        for mod in sorted(failures.keys()):
            if failures[mod]:
                print(f"\np ≡ {mod} (mod 32): {len(failures[mod])} failures")
                for f in failures[mod][:5]:  # Show first 5
                    print(f"  p = {f['p']:8d}: predicted {f['predicted']}, "
                          f"actual {f['actual']}")
                if len(failures[mod]) > 5:
                    print(f"  ... and {len(failures[mod]) - 5} more")
        print()
        print("Pattern is NOT universal!")

def main():
    import argparse
    parser = argparse.ArgumentParser(description='Falsify ν₂(x₀) patterns')
    parser.add_argument('--pmax', type=int, default=100000,
                        help='Maximum prime to test (default: 100000)')
    args = parser.parse_args()

    tested, failures = test_falsification(args.pmax)
    print_results(tested, failures)

    # Return exit code
    total_failures = sum(len(f) for f in failures.values())
    if total_failures > 0:
        print("\nExit code 1: Counterexamples found")
        return 1
    else:
        print("\nExit code 0: No counterexamples found")
        return 0

if __name__ == '__main__':
    exit_code = main()
    sys.exit(exit_code)
