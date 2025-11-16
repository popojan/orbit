#!/usr/bin/env python3
"""
Verify equivalence of two formulations in Egypt.wl:

term0[x, j] = 1 / (1 + Sum[2^(i-1) x^i (j+i)!/(j-i)!/(2i)!, {i,1,j}])

term[x, k] = 1 / (T_{ceil(k/2)}(x+1) * (U_{floor(k/2)}(x+1) - U_{floor(k/2)-1}(x+1)))

where T_n, U_n are Chebyshev polynomials of first and second kind.
"""

import numpy as np
from scipy.special import eval_chebyt, eval_chebyu
import math


def factorial(n):
    """Factorial function."""
    return math.factorial(n)


def term0(x, j):
    """
    Original factorial-based term.

    term0[x, j] = 1 / (1 + Sum[2^(i-1) x^i (j+i)!/(j-i)!/(2i)!, {i,1,j}])
    """
    summation = 0.0
    for i in range(1, j + 1):
        coeff = 2**(i - 1) * x**i
        coeff *= factorial(j + i) / factorial(j - i) / factorial(2 * i)
        summation += coeff

    return 1.0 / (1.0 + summation)


def term_chebyshev(x, k):
    """
    Chebyshev-based term.

    term[x, k] = 1 / (T_{ceil(k/2)}(x+1) * (U_{floor(k/2)}(x+1) - U_{floor(k/2)-1}(x+1)))
    """
    n_T = math.ceil(k / 2)
    n_U = math.floor(k / 2)

    arg = x + 1

    T_val = eval_chebyt(n_T, arg)
    U_val = eval_chebyu(n_U, arg)
    U_prev_val = eval_chebyu(n_U - 1, arg)

    denominator = T_val * (U_val - U_prev_val)

    return 1.0 / denominator


def test_equivalence(x_values, j_max=10):
    """
    Test if term0[x, j] = term[x, k] for various x and j values.
    """
    print("="*80)
    print("TESTING EQUIVALENCE: term0[x, j] vs term[x, k]")
    print("="*80)
    print()

    for x in x_values:
        print(f"x = {x}")
        print("-" * 80)
        print(f"{'j':<4} {'term0':<20} {'term(j)':<20} {'Ratio':<15} {'Match?'}")
        print("-" * 80)

        for j in range(1, j_max + 1):
            try:
                t0 = term0(x, j)
                t_cheb = term_chebyshev(x, j)  # Try k=j first

                ratio = t_cheb / t0 if abs(t0) > 1e-15 else np.inf
                match = abs(ratio - 1.0) < 1e-10

                marker = "✓" if match else "✗"

                print(f"{j:<4} {t0:<20.12e} {t_cheb:<20.12e} {ratio:<15.6f} {marker}")
            except Exception as e:
                print(f"{j:<4} ERROR: {e}")

        print()


def investigate_index_relationship(x=1.0, max_j=10, max_k=15):
    """
    Try to find the relationship between j and k indices.
    For each j, find which k gives the closest match.
    """
    print("="*80)
    print("INVESTIGATING INDEX RELATIONSHIP")
    print("="*80)
    print(f"Testing x = {x}")
    print()

    results = []

    for j in range(1, max_j + 1):
        t0 = term0(x, j)

        best_k = None
        best_error = float('inf')

        for k in range(1, max_k + 1):
            try:
                t_cheb = term_chebyshev(x, k)
                error = abs(t_cheb - t0)

                if error < best_error:
                    best_error = error
                    best_k = k
            except:
                pass

        results.append((j, best_k, best_error))

        match = "✓" if best_error < 1e-10 else "✗"
        print(f"j={j:2d} → best k={best_k:2d}, error={best_error:.2e} {match}")

    print()
    print("Index relationship analysis:")

    # Check if k = j
    if all(j == k for j, k, _ in results):
        print("  ✓ Relationship: k = j")
    # Check if k = 2j
    elif all(k == 2*j for j, k, _ in results):
        print("  ✓ Relationship: k = 2j")
    # Check if k = j+1
    elif all(k == j+1 for j, k, _ in results):
        print("  ✓ Relationship: k = j+1")
    else:
        print("  ? Complex relationship, listing (j, k) pairs:")
        for j, k, err in results:
            if err < 1e-10:
                print(f"     (j={j}, k={k})")

    return results


def explore_chebyshev_expansion(n_max=5):
    """
    Explicitly compute Chebyshev polynomials and look for factorial patterns.
    """
    print("="*80)
    print("CHEBYSHEV POLYNOMIAL EXPLICIT FORMS")
    print("="*80)
    print()

    print("T_n(x) - First kind:")
    for n in range(n_max + 1):
        coeffs = np.polynomial.chebyshev.cheb2poly([0]*n + [1])
        print(f"  T_{n}(x) = {np.poly1d(coeffs)}")

    print()
    print("U_n(x) - Second kind:")
    for n in range(n_max + 1):
        # U_n has different representation
        # U_n(cos θ) = sin((n+1)θ) / sin(θ)
        # For explicit polynomial, we can evaluate at specific points
        x_test = 0.5
        val = eval_chebyu(n, x_test)
        print(f"  U_{n}({x_test}) = {val:.6f}")


if __name__ == '__main__':
    # Test 1: Direct equivalence with k=j
    print("\n" + "="*80)
    print("TEST 1: DIRECT EQUIVALENCE (k = j)")
    print("="*80 + "\n")

    test_equivalence([1.0, 2.0, 0.5, -0.5], j_max=8)

    # Test 2: Investigate index relationship
    print("\n" + "="*80)
    print("TEST 2: INDEX RELATIONSHIP")
    print("="*80 + "\n")

    for x in [1.0, 2.0, 0.5]:
        print(f"\n--- x = {x} ---")
        investigate_index_relationship(x, max_j=10, max_k=20)

    # Test 3: Explore Chebyshev structure
    print("\n" + "="*80)
    print("TEST 3: CHEBYSHEV STRUCTURE")
    print("="*80 + "\n")

    explore_chebyshev_expansion(n_max=5)
