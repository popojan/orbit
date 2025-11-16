#!/usr/bin/env python3
"""
QUICK WIN: Test Egypt.wl modular property

Claim from sqrt.pdf:
  (x-1)/y · f(x-1, k) ≡ 0 (mod n)

where (x,y) solves x² - n·y² = 1

Jan says: "neplatí to pro každé k ale jen pro sudá nebo lichá"

GOAL: Find exactly which k values make this true!
"""

import math
from fractions import Fraction

print("="*80)
print("EGYPT.WL MODULAR PROPERTY TEST")
print("="*80)
print()

# Pell solutions for small n
pell_solutions = {
    2: (3, 2),
    3: (2, 1),
    5: (9, 4),
    6: (5, 2),
    7: (8, 3),
}

def term0_rational(x, j):
    """
    Factorial-based term (rational exact).

    term0[x, j] = 1 / (1 + Sum[2^(i-1) * x^i * (j+i)!/(j-i)!/(2i)!, {i,1,j}])

    Returns Fraction for exact arithmetic.
    """
    summation = Fraction(0)

    for i in range(1, j + 1):
        coeff = Fraction(2**(i-1))
        coeff *= Fraction(x**i)

        # (j+i)! / (j-i)! / (2i)!
        numerator = math.factorial(j + i)
        denominator = math.factorial(j - i) * math.factorial(2 * i)

        coeff *= Fraction(numerator, denominator)
        summation += coeff

    return Fraction(1) / (Fraction(1) + summation)


def f_rational(x, k):
    """
    Compute f(x, k) = (1/x) * Sum_{j=1}^{k} term0[x, j]

    From Egypt pdf, but we need to figure out the exact formula.

    Actually, looking at the pdf:
    f(n, k) = (1/n) * Sum_{i=0}^{k} a(n, i)

    where a(n,i) is the recurrence sequence.

    Let me use the simpler interpretation:
    f(x, k) ≈ Sum_{j=1}^{k} term0[x, j]
    """
    total = Fraction(0)
    for j in range(1, k + 1):
        total += term0_rational(x, j)

    return total


def test_modular_property(n, k_max=20):
    """
    Test: Does (x-1)/y · f(x-1, k) ≡ 0 (mod n) for various k?

    Returns list of k values where property holds.
    """
    if n not in pell_solutions:
        return None

    x, y = pell_solutions[n]

    print(f"n = {n}")
    print(f"Pell solution: (x, y) = ({x}, {y})")
    print(f"Testing: ({x}-1)/{y} · f({x}-1, k) ≡ 0 (mod {n})")
    print("-" * 80)

    base = Fraction(x - 1, y)
    print(f"Base factor: (x-1)/y = {base} = {float(base):.6f}")
    print()

    results = []

    for k in range(1, k_max + 1):
        # Compute f(x-1, k)
        f_val = f_rational(x - 1, k)

        # Compute product
        product = base * f_val

        # Check if product ≡ 0 (mod n)
        # For rational a/b ≡ 0 (mod n), we need: n | a and gcd(b, n) = 1
        # Or more generally: a ≡ 0 (mod n·b) when reduced

        # Simplify to lowest terms
        a = product.numerator
        b = product.denominator

        # Check: does n divide a/b?
        # Equivalently: does a ≡ 0 (mod n) when b is coprime to n?

        # Better: compute (a/b) mod n
        # If b is coprime to n, then a/b mod n = a * b^(-1) mod n

        from math import gcd

        if gcd(b, n) != 1:
            # b not coprime to n - more complex
            mod_result = "undefined"
            holds = False
        else:
            # Compute modular inverse of b
            # a/b mod n = a * modinv(b, n) mod n
            def modinv(a, m):
                """Modular inverse using extended Euclidean algorithm."""
                def extended_gcd(a, b):
                    if a == 0:
                        return b, 0, 1
                    gcd_val, x1, y1 = extended_gcd(b % a, a)
                    x = y1 - (b // a) * x1
                    y = x1
                    return gcd_val, x, y

                _, x, _ = extended_gcd(a % m, m)
                return (x % m + m) % m

            b_inv = modinv(b, n)
            mod_result = (a * b_inv) % n

            holds = (mod_result == 0)

        marker = "✓" if holds else "✗"

        print(f"k={k:2d}: f = {float(f_val):.6f}, product = {float(product):.6f}, "
              f"mod {n} = {mod_result:>10}, {marker}")

        if holds:
            results.append(k)

    print()
    print(f"Property holds for k ∈ {results}")

    # Pattern analysis
    if results:
        if all(k % 2 == 0 for k in results):
            print("PATTERN: All k are EVEN")
        elif all(k % 2 == 1 for k in results):
            print("PATTERN: All k are ODD")
        elif len(results) > 1:
            diffs = [results[i+1] - results[i] for i in range(len(results)-1)]
            if len(set(diffs)) == 1:
                print(f"PATTERN: Arithmetic sequence with step {diffs[0]}")
            else:
                print(f"PATTERN: Irregular (differences: {diffs})")
    else:
        print("PATTERN: NEVER holds (or formula is wrong)")

    print()
    return results


def quick_test_all():
    """Quick test for all small n."""
    all_results = {}

    for n in sorted(pell_solutions.keys()):
        results = test_modular_property(n, k_max=15)
        all_results[n] = results
        print("="*80)
        print()

    # Summary
    print("="*80)
    print("SUMMARY")
    print("="*80)
    print()

    for n, results in all_results.items():
        if results:
            print(f"n={n}: k ∈ {results}")
        else:
            print(f"n={n}: NEVER (tested k≤15)")

    print()

    # Check for universal pattern
    if all_results:
        all_k_values = [k for results in all_results.values() if results for k in results]

        if all_k_values:
            if all(k % 2 == 0 for k in all_k_values):
                print("🎯 UNIVERSAL PATTERN: k must be EVEN")
            elif all(k % 2 == 1 for k in all_k_values):
                print("🎯 UNIVERSAL PATTERN: k must be ODD")
            else:
                print("⚠️  NO UNIVERSAL PATTERN (varies by n)")


if __name__ == '__main__':
    quick_test_all()
