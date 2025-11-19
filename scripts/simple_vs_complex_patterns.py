#!/usr/bin/env python3
"""
Distinguish between "simple" and "complex" LR string patterns

Simple: [i, 2i, i] run structure (3 runs total)
Complex: Irregular run structure (more runs)

Question: What property of d determines simple vs complex?
"""

from wildberger_pell_trace import wildberger_pell
from math import gcd

def classify_lr_pattern(d):
    """Classify d as simple or complex based on LR pattern"""
    x, y, trace = wildberger_pell(d, verbose=False)

    branches = [step[1] for step in trace]
    plus_count = branches.count('+')
    minus_count = branches.count('-')

    # Only symmetric cases
    if plus_count != minus_count:
        return None

    # Extract runs
    runs = []
    current_char = branches[0]
    current_len = 1
    for b in branches[1:]:
        if b == current_char:
            current_len += 1
        else:
            runs.append((current_char, current_len))
            current_char = b
            current_len = 1
    runs.append((current_char, current_len))

    run_lengths = [length for _, length in runs]

    # Check if simple pattern [i, 2i, i]
    i = len(branches) // 4

    is_simple = (len(runs) == 3 and
                 run_lengths == [i, 2*i, i])

    return {
        'd': d,
        'i': i,
        'num_runs': len(runs),
        'run_lengths': run_lengths,
        'is_simple': is_simple,
        'string': ''.join(branches),
        'fundamental': (x, y)
    }

def analyze_simple_vs_complex():
    """Analyze what distinguishes simple from complex cases"""
    print("="*100)
    print("SIMPLE vs COMPLEX LR PATTERN ANALYSIS")
    print("="*100)

    # Symmetric d values (negative Pell exists)
    symmetric_d = [2, 5, 10, 13, 17, 29, 37, 41, 53, 61]

    classified = []
    for d in symmetric_d:
        result = classify_lr_pattern(d)
        if result:
            classified.append(result)

    simple = [c for c in classified if c['is_simple']]
    complex_cases = [c for c in classified if not c['is_simple']]

    print(f"\nSimple cases: {len(simple)}")
    for c in simple:
        print(f"  d={c['d']:<3} i={c['i']:<3} pattern=[{c['i']}, {2*c['i']}, {c['i']}]")

    print(f"\nComplex cases: {len(complex_cases)}")
    for c in complex_cases:
        print(f"  d={c['d']:<3} i={c['i']:<3} runs={c['num_runs']:<3} pattern={c['run_lengths']}")

    # Look for properties distinguishing the groups
    print("\n" + "="*100)
    print("PROPERTY ANALYSIS")
    print("="*100)

    def analyze_property(name, property_func):
        """Analyze a property for simple vs complex"""
        print(f"\n{name}:")
        simple_vals = [property_func(c['d']) for c in simple]
        complex_vals = [property_func(c['d']) for c in complex_cases]

        print(f"  Simple: {simple_vals}")
        print(f"  Complex: {complex_vals}")

        # Check for pattern
        simple_set = set(simple_vals)
        complex_set = set(complex_vals)

        if simple_set.isdisjoint(complex_set):
            print(f"  → DISJOINT! Simple ∈ {simple_set}, Complex ∈ {complex_set}")
        else:
            overlap = simple_set & complex_set
            print(f"  → Overlap: {overlap}")

    # Test various properties
    analyze_property("d mod 4", lambda d: d % 4)
    analyze_property("d mod 8", lambda d: d % 8)
    analyze_property("d mod 12", lambda d: d % 12)

    # Prime vs composite
    def is_prime(n):
        if n < 2:
            return False
        for i in range(2, int(n**0.5) + 1):
            if n % i == 0:
                return False
        return True

    analyze_property("Is prime?", lambda d: is_prime(d))

    # Factorization structure
    def factor_structure(n):
        """Return (num_distinct_primes, total_prime_power)"""
        factors = {}
        temp = n
        d = 2
        while d * d <= temp:
            while temp % d == 0:
                factors[d] = factors.get(d, 0) + 1
                temp //= d
            d += 1
        if temp > 1:
            factors[temp] = factors.get(temp, 0) + 1

        return (len(factors), sum(factors.values()))

    print("\nFactorization structure (ω(d), Ω(d)):")
    for c in simple:
        omega, Omega = factor_structure(c['d'])
        print(f"  d={c['d']:<3} ω={omega}, Ω={Omega}")
    print("Complex:")
    for c in complex_cases:
        omega, Omega = factor_structure(c['d'])
        print(f"  d={c['d']:<3} ω={omega}, Ω={Omega}")

    # CF period
    def cf_period_estimate(d):
        """Estimate CF period (not exact, just for pattern)"""
        # For sqrt(d), period relates to fundamental solution size
        # But we don't have direct CF here, using approximation
        c = classify_lr_pattern(d)
        if c:
            x, y = c['fundamental']
            # Period roughly log(x)
            import math
            return math.log(x) if x > 1 else 0
        return 0

    print("\nFundamental solution size:")
    for c in simple:
        x, y = c['fundamental']
        print(f"  d={c['d']:<3} x={x:<10} y={y:<10}")
    print("Complex:")
    for c in complex_cases:
        x, y = c['fundamental']
        print(f"  d={c['d']:<3} x={x:<15} y={y:<15}")

def test_hypothesis_double_composite():
    """Test hypothesis: Simple cases are 2p (double of prime)?"""
    print("\n" + "="*100)
    print("HYPOTHESIS: Simple cases = 2×prime?")
    print("="*100)

    symmetric_d = [2, 5, 10, 13, 17, 29, 37, 41, 53, 61]

    def is_prime(n):
        if n < 2:
            return False
        for i in range(2, int(n**0.5) + 1):
            if n % i == 0:
                return False
        return True

    for d in symmetric_d:
        result = classify_lr_pattern(d)
        if not result:
            continue

        is_simple = result['is_simple']
        is_2p = (d % 2 == 0 and is_prime(d // 2))
        is_prime_d = is_prime(d)

        marker = "✓" if is_simple else " "
        print(f"{marker} d={d:<3} simple={str(is_simple):<6} prime={str(is_prime_d):<6} 2×prime={str(is_2p):<6}")

    print("\nSimple cases: d ∈ {2, 5, 10, 17, 37}")
    print("  2 = 2")
    print("  5 = 5")
    print("  10 = 2×5")
    print("  17 = 17")
    print("  37 = 37")
    print("\n→ Pattern: 4 primes + 1 composite (2×5)")
    print("→ Hypothesis REJECTED (not all 2×prime)")

def explore_alternative_pattern():
    """Look for alternative characterization"""
    print("\n" + "="*100)
    print("ALTERNATIVE PATTERN SEARCH")
    print("="*100)

    simple_d = [2, 5, 10, 17, 37]
    complex_d = [13, 29, 41, 53, 61]

    print("Simple d values: ", simple_d)
    print("Complex d values:", complex_d)

    # Check mod patterns
    print("\nmod 13:")
    print("  Simple:", [d % 13 for d in simple_d])
    print("  Complex:", [d % 13 for d in complex_d])

    print("\nmod 17:")
    print("  Simple:", [d % 17 for d in simple_d])
    print("  Complex:", [d % 17 for d in complex_d])

    # Check if d ≡ 1, 2, or 5 (mod something)
    print("\nChecking small moduli:")
    for m in [3, 4, 5, 6, 7, 8, 9, 10, 11, 12]:
        simple_mods = set(d % m for d in simple_d)
        complex_mods = set(d % m for d in complex_d)

        if simple_mods.isdisjoint(complex_mods):
            print(f"  mod {m}: DISJOINT! Simple={simple_mods}, Complex={complex_mods}")

    # Connection to i values
    print("\nParameter i:")
    for d in simple_d:
        c = classify_lr_pattern(d)
        print(f"  d={d:<3} i={c['i']}")
    print("Complex:")
    for d in complex_d:
        c = classify_lr_pattern(d)
        print(f"  d={d:<3} i={c['i']}")

if __name__ == "__main__":
    analyze_simple_vs_complex()
    test_hypothesis_double_composite()
    explore_alternative_pattern()

    print("\n" + "="*100)
    print("CONCLUSION")
    print("="*100)
    print("\nSimple pattern [i, 2i, i]:")
    print("  - d ∈ {2, 5, 10, 17, 37}")
    print("  - Mostly primes (4/5), one composite (10 = 2×5)")
    print("  - No clear mod pattern found")
    print("\nComplex pattern (irregular runs):")
    print("  - d ∈ {13, 29, 41, 53, 61}")
    print("  - All primes")
    print("  - Larger fundamental solutions")
    print("\n⚠️  Characterization incomplete - need more analysis or theory")
