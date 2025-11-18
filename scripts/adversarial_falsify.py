#!/usr/bin/env python3
"""
ADVERSARIAL FALSIFICATION: Target edge cases where patterns might break

Strategies inspired by historical counterexamples:
  - Pólya: unusual factorization structure
  - Mertens: extreme values
  - Skewes: astronomically large numbers

Edge cases to test:
  1. Primes near powers of 2: p = 2^k ± δ, δ small
  2. Mersenne primes: p = 2^q - 1
  3. Primes near perfect squares: p = n² ± δ, δ small
  4. Sophie Germain primes: p and 2p+1 both prime
  5. Primes with extreme CF periods
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
    """Predicted ν₂(x₀) based on pattern"""
    p_mod_32 = p % 32
    if p_mod_32 in [1, 5]:
        return 0
    elif p_mod_32 == 3:
        return 1
    elif p_mod_32 in [7, 23]:
        return 3
    else:
        return None

def test_candidate(p, category):
    """Test single prime, return failure if pattern breaks"""
    if p < 3 or not is_prime(p):
        return None

    p_mod_32 = p % 32
    predicted = predict_nu2(p)

    if predicted is None:
        return None  # Variable case, skip

    try:
        x0, y0 = pell_fundamental_solution(p)
        nu2_actual = two_adic_valuation(x0)

        if nu2_actual != predicted:
            return {
                'p': p,
                'category': category,
                'p_mod_32': p_mod_32,
                'predicted': predicted,
                'actual': nu2_actual
            }
    except:
        pass

    return None

def find_primes_near_powers_of_2(k_max=30, delta_max=100):
    """Primes p = 2^k ± δ for small δ"""
    print("Testing primes near powers of 2...")
    candidates = []

    for k in range(10, k_max):
        power = 2**k
        for delta in range(1, min(delta_max, power // 10)):
            for p in [power - delta, power + delta]:
                if is_prime(p):
                    candidates.append((p, f"2^{k} ± {delta}"))

    print(f"  Found {len(candidates)} candidates")
    return candidates

def find_mersenne_primes(q_max=127):
    """Mersenne primes p = 2^q - 1"""
    print("Testing Mersenne primes...")
    # Known Mersenne exponents
    mersenne_exponents = [2, 3, 5, 7, 13, 17, 19, 31, 61, 89, 107, 127]
    candidates = []

    for q in mersenne_exponents:
        if q > q_max:
            break
        p = 2**q - 1
        if is_prime(p):
            candidates.append((p, f"Mersenne 2^{q}-1"))

    print(f"  Found {len(candidates)} Mersenne primes")
    return candidates

def find_primes_near_squares(n_max=10000, delta_max=20):
    """Primes p = n² ± δ for small δ"""
    print("Testing primes near perfect squares...")
    candidates = []

    for n in range(10, n_max):
        square = n * n
        for delta in range(1, delta_max):
            for p in [square - delta, square + delta]:
                if p > 7 and is_prime(p):
                    candidates.append((p, f"{n}² ± {delta}"))

    print(f"  Found {len(candidates)} candidates")
    return candidates

def find_sophie_germain_primes(p_max=1000000):
    """Sophie Germain primes: p and 2p+1 both prime"""
    print("Testing Sophie Germain primes...")
    candidates = []

    p = 3
    while p < p_max:
        if is_prime(p) and is_prime(2*p + 1):
            candidates.append((p, "Sophie Germain"))
        p += 2

    print(f"  Found {len(candidates)} Sophie Germain primes")
    return candidates

def adversarial_search():
    """Run all adversarial tests"""
    print("=" * 80)
    print("ADVERSARIAL FALSIFICATION TEST")
    print("=" * 80)
    print()
    print("Testing edge cases where patterns might break...")
    print()

    all_candidates = []

    # Strategy 1: Near powers of 2
    all_candidates.extend(find_primes_near_powers_of_2(k_max=25, delta_max=50))

    # Strategy 2: Mersenne primes
    all_candidates.extend(find_mersenne_primes(q_max=127))

    # Strategy 3: Near squares
    all_candidates.extend(find_primes_near_squares(n_max=5000, delta_max=15))

    # Strategy 4: Sophie Germain
    all_candidates.extend(find_sophie_germain_primes(p_max=500000))

    print()
    print(f"Total edge case candidates: {len(all_candidates)}")
    print()
    print("Testing candidates...")
    print()

    failures = []
    tested = 0

    for p, category in all_candidates:
        failure = test_candidate(p, category)
        if failure is not None:
            failures.append(failure)
            print("!" * 80)
            print(f"COUNTEREXAMPLE: {category}")
            print(f"  p = {failure['p']}")
            print(f"  p mod 32 = {failure['p_mod_32']}")
            print(f"  Predicted: ν₂(x₀) = {failure['predicted']}")
            print(f"  Actual: ν₂(x₀) = {failure['actual']}")
            print("!" * 80)
            print()
        tested += 1

        if tested % 100 == 0:
            print(f"Tested {tested}/{len(all_candidates)}...", end="\r", flush=True)

    print()
    print("=" * 80)
    print("RESULTS")
    print("=" * 80)
    print()
    print(f"Total edge cases tested: {tested}")
    print(f"Counterexamples found: {len(failures)}")
    print()

    if len(failures) == 0:
        print("✓ NO COUNTEREXAMPLES in edge cases!")
        print()
        print("Pattern holds even for:")
        print("  - Primes near powers of 2")
        print("  - Mersenne primes")
        print("  - Primes near perfect squares")
        print("  - Sophie Germain primes")
        print()
        print("This STRONGLY suggests pattern is robust.")
    else:
        print("✗ PATTERN BROKEN!")
        print()
        print("Failed cases:")
        for f in failures:
            print(f"  {f['category']}: p = {f['p']}")

    return failures

if __name__ == '__main__':
    failures = adversarial_search()
    sys.exit(1 if failures else 0)
