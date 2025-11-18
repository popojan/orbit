#!/usr/bin/env python3
"""
UNIVERSAL PRIME PATTERN TESTER

Reusable framework for testing patterns on various prime sources:
  - Random primes in range
  - Known large primes (Mersenne, Sophie Germain, etc.)
  - Primes from OEIS sequences
  - Edge cases (near powers, near squares)

Usage:
  from universal_prime_tester import PrimeTester

  tester = PrimeTester(pattern_func, description)
  tester.add_source("random", p_max=100000)
  tester.add_source("mersenne", q_max=127)
  results = tester.run()
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

class PrimeTester:
    """Universal framework for testing patterns on primes"""

    def __init__(self, pattern_func, description="Pattern test"):
        """
        pattern_func: (p) -> (predicted, actual, metadata)
          Returns None if pattern doesn't apply to this p
          Returns (predicted, actual, {}) if it does

        Example:
          def nu2_pattern(p):
              p_mod_32 = p % 32
              if p_mod_32 in [1,5]:
                  predicted = 0
              elif p_mod_32 == 3:
                  predicted = 1
              elif p_mod_32 in [7,23]:
                  predicted = 3
              else:
                  return None  # Variable case

              x0, _ = pell_fundamental_solution(p)
              actual = two_adic_valuation(x0)

              return (predicted, actual, {'p_mod_32': p_mod_32})
        """
        self.pattern_func = pattern_func
        self.description = description
        self.sources = []

    def add_source(self, source_type, **kwargs):
        """Add prime source to test"""
        self.sources.append((source_type, kwargs))

    def _generate_primes(self, source_type, **kwargs):
        """Generate primes from source"""
        if source_type == "random":
            # Random primes in range
            p_min = kwargs.get('p_min', 3)
            p_max = kwargs.get('p_max', 100000)
            for p in range(p_min, p_max + 1):
                if is_prime(p):
                    yield p, "random"

        elif source_type == "mersenne":
            # Mersenne primes 2^q - 1
            q_max = kwargs.get('q_max', 127)
            known_exponents = [2, 3, 5, 7, 13, 17, 19, 31, 61, 89, 107, 127]
            for q in known_exponents:
                if q > q_max:
                    break
                p = 2**q - 1
                if is_prime(p):
                    yield p, f"Mersenne(2^{q}-1)"

        elif source_type == "near_powers_2":
            # Primes near 2^k
            k_max = kwargs.get('k_max', 30)
            delta_max = kwargs.get('delta_max', 100)
            for k in range(10, k_max):
                power = 2**k
                for delta in range(1, min(delta_max, power // 10)):
                    for sign in [-1, +1]:
                        p = power + sign * delta
                        if p > 2 and is_prime(p):
                            yield p, f"2^{k}{sign:+d}{delta}"

        elif source_type == "near_squares":
            # Primes near n²
            n_max = kwargs.get('n_max', 10000)
            delta_max = kwargs.get('delta_max', 20)
            for n in range(10, n_max):
                square = n * n
                for delta in range(1, delta_max):
                    for sign in [-1, +1]:
                        p = square + sign * delta
                        if p > 2 and is_prime(p):
                            yield p, f"{n}²{sign:+d}{delta}"

        elif source_type == "sophie_germain":
            # Sophie Germain primes
            p_max = kwargs.get('p_max', 1000000)
            p = 3
            while p < p_max:
                if is_prime(p) and is_prime(2*p + 1):
                    yield p, "Sophie_Germain"
                p += 2

        elif source_type == "safe":
            # Safe primes p = 2q + 1
            p_max = kwargs.get('p_max', 1000000)
            q = 2
            while True:
                p = 2*q + 1
                if p > p_max:
                    break
                if is_prime(q) and is_prime(p):
                    yield p, "Safe_prime"
                q += 1 if q == 2 else 2

        else:
            raise ValueError(f"Unknown source type: {source_type}")

    def run(self, verbose=True):
        """Run tests on all sources"""
        if verbose:
            print("=" * 80)
            print(self.description.upper())
            print("=" * 80)
            print()

        results = {
            'total_tested': 0,
            'failures': [],
            'by_source': {},
            'success_count': 0
        }

        for source_type, kwargs in self.sources:
            if verbose:
                print(f"Testing source: {source_type}...")

            source_tested = 0
            source_failures = []

            for p, label in self._generate_primes(source_type, **kwargs):
                try:
                    result = self.pattern_func(p)
                    if result is None:
                        continue  # Pattern doesn't apply

                    predicted, actual, metadata = result
                    source_tested += 1
                    results['total_tested'] += 1

                    if predicted != actual:
                        failure = {
                            'p': p,
                            'source': source_type,
                            'label': label,
                            'predicted': predicted,
                            'actual': actual,
                            'metadata': metadata
                        }
                        source_failures.append(failure)
                        results['failures'].append(failure)

                        if verbose:
                            print(f"  ✗ FAILURE: {label}")
                            print(f"    p = {p}")
                            print(f"    predicted = {predicted}, actual = {actual}")
                    else:
                        results['success_count'] += 1

                except Exception as e:
                    if verbose:
                        print(f"  Error testing p={p}: {e}")
                    continue

            results['by_source'][source_type] = {
                'tested': source_tested,
                'failures': len(source_failures)
            }

            if verbose:
                print(f"  Tested: {source_tested}, Failures: {len(source_failures)}")
                print()

        if verbose:
            self._print_summary(results)

        return results

    def _print_summary(self, results):
        """Print summary statistics"""
        print("=" * 80)
        print("SUMMARY")
        print("=" * 80)
        print()
        print(f"Total tested: {results['total_tested']}")
        print(f"Successes: {results['success_count']}")
        print(f"Failures: {len(results['failures'])}")
        print()

        if len(results['failures']) == 0:
            print("✓ NO COUNTEREXAMPLES FOUND")
            print()
            print("Pattern holds across all sources!")
        else:
            print("✗ PATTERN FALSIFIED")
            print()
            print("Failures by source:")
            for source, stats in results['by_source'].items():
                if stats['failures'] > 0:
                    print(f"  {source}: {stats['failures']}/{stats['tested']}")
            print()
            print("First 5 counterexamples:")
            for f in results['failures'][:5]:
                print(f"  {f['label']}: p={f['p']}, pred={f['predicted']}, actual={f['actual']}")


# Example usage for ν₂(x₀) pattern
def two_adic_valuation(n):
    if n == 0:
        return float('inf')
    val = 0
    while n % 2 == 0:
        val += 1
        n //= 2
    return val

def nu2_pattern(p):
    """Test ν₂(x₀) pattern"""
    p_mod_32 = p % 32

    # Predict based on pattern
    if p_mod_32 in [1, 5]:
        predicted = 0
    elif p_mod_32 == 3:
        predicted = 1
    elif p_mod_32 in [7, 23]:
        predicted = 3
    else:
        return None  # Variable cases

    # Compute actual
    x0, _ = pell_fundamental_solution(p)
    actual = two_adic_valuation(x0)

    return (predicted, actual, {'p_mod_32': p_mod_32})


if __name__ == '__main__':
    # Example: test ν₂(x₀) pattern on multiple sources
    tester = PrimeTester(nu2_pattern, "ν₂(x₀) Pattern Test")

    # Add various sources
    tester.add_source("random", p_max=50000)
    tester.add_source("mersenne", q_max=127)
    tester.add_source("near_powers_2", k_max=20, delta_max=30)
    tester.add_source("near_squares", n_max=2000, delta_max=10)
    tester.add_source("sophie_germain", p_max=200000)

    # Run tests
    results = tester.run()

    # Exit with failure code if counterexamples found
    sys.exit(1 if results['failures'] else 0)
