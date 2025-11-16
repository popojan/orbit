#!/usr/bin/env python3
"""
EGYPT K=EVEN PROOF - Approach 1: Explicit Term Expansion

Goal: Expand term0[x-1, j] for small j and find pairing pattern mod n.
"""

import math
from fractions import Fraction
from sympy import symbols, factorial, simplify, expand, Rational

print("="*80)
print("EGYPT K=EVEN: Explicit Term Expansion")
print("="*80)
print()

# Symbolic variable
x = symbols('x', integer=True)

def term0_symbolic(x_val, j):
    """Compute term0[x, j] symbolically."""
    summation = 0

    for i in range(1, j+1):
        coeff = 2**(i-1) * x_val**i

        # (j+i)! / (j-i)! / (2i)!
        numerator = factorial(j + i)
        denominator = factorial(j - i) * factorial(2*i)

        coeff *= Rational(numerator, denominator)
        summation += coeff

    return 1 / (1 + summation)

print("Computing term0[x-1, j] for j=1,2,3,4...")
print()

for j in range(1, 5):
    print(f"j = {j}:")
    term = term0_symbolic(x-1, j)
    term_simplified = simplify(term)
    print(f"  term0[x-1, {j}] = {term_simplified}")

    # Evaluate at x=-1 (from Pell: x ≡ -1 mod n)
    term_at_minus1 = term_simplified.subs(x, -1)
    print(f"  At x=-1: {term_at_minus1} = {float(term_at_minus1):.10f}")
    print()

# Pairing
print("="*80)
print("PAIRING: term0[x-1, odd] + term0[x-1, even]")
print("="*80)
print()

for j_odd in [1, 3]:
    j_even = j_odd + 1
    print(f"Pair: j={j_odd} + j={j_even}")

    term_odd = term0_symbolic(x-1, j_odd)
    term_even = term0_symbolic(x-1, j_even)
    pair_sum = simplify(term_odd + term_even)

    print(f"  Sum = {pair_sum}")

    # At x=-1
    sum_at_minus1 = pair_sum.subs(x, -1)
    print(f"  At x=-1: {sum_at_minus1} = {float(sum_at_minus1):.10f}")
    print()

# Numerical test mod n
print("="*80)
print("NUMERICAL TEST: Pairing mod n")
print("="*80)
print()

def term0_numerical(x_val, j):
    """Numerical computation using Fraction."""
    summation = Fraction(0)
    for i in range(1, j+1):
        coeff = Fraction(2**(i-1)) * Fraction(x_val**i)
        numerator = math.factorial(j + i)
        denominator = math.factorial(j - i) * math.factorial(2*i)
        coeff *= Fraction(numerator, denominator)
        summation += coeff
    return Fraction(1) / (Fraction(1) + summation)

pell_solutions = {
    3: (2, 1),
    5: (9, 4),
    13: (649, 180),
}

for n, (x_pell, y_pell) in pell_solutions.items():
    print(f"n = {n}, x = {x_pell}, x-1 = {x_pell-1}")

    # Check pairing mod n
    for j_odd in [1, 3, 5]:
        j_even = j_odd + 1

        term_odd = term0_numerical(x_pell - 1, j_odd)
        term_even = term0_numerical(x_pell - 1, j_even)
        pair_sum = term_odd + term_even

        # Compute mod n
        num_mod = pair_sum.numerator % n
        den_mod = pair_sum.denominator % n

        if math.gcd(den_mod, n) == 1:
            den_inv = pow(den_mod, -1, n)
            result_mod = (num_mod * den_inv) % n
            print(f"  term0[{x_pell-1},{j_odd}] + term0[{x_pell-1},{j_even}] ≡ {result_mod} (mod {n})")
        else:
            print(f"  [{j_odd}+{j_even}] ≡ {num_mod}/{den_mod} (mod {n})")

    print()

print("="*80)
print("CONCLUSION")
print("="*80)
print()
print("Look for pattern in pairing results above.")
print("Does pair sum = 0 mod n? Constant? Telescoping?")
print()
