#!/usr/bin/env python3
"""
Binomial identity proof for ΔU_n(x+1) coefficients

Goal: Prove Σ_j (-1)^j·C(n-j,j)·2^{n-2j}·C(n-2j,k) - (n→n-1) = 2^k·C(n+k,2k)

Strategy:
1. Start with explicit Chebyshev U_n formula
2. Apply to U_n(x+1) and extract [x^k]
3. Compute ΔU_n = U_n - U_{n-1}
4. Simplify using binomial identities (Vandermonde, etc.)
"""

import sympy as sp
from sympy import symbols, binomial, summation, simplify, expand
from math import comb, factorial

def explicit_U_n_coefficient(n, k):
    """
    Explicit formula for [x^k] U_n(x+1):

    U_n(x) = Σ_{j=0}^{⌊n/2⌋} (-1)^j · C(n-j, j) · (2x)^{n-2j}

    U_n(x+1) = Σ_j (-1)^j · C(n-j, j) · 2^{n-2j} · (x+1)^{n-2j}

    (x+1)^{n-2j} = Σ_m C(n-2j, m) · x^m

    So: [x^k] U_n(x+1) = Σ_{j: n-2j≥k} (-1)^j · C(n-j, j) · 2^{n-2j} · C(n-2j, k)
    """
    result = 0
    for j in range((n+1)//2 + 1):  # j from 0 to floor(n/2)
        exponent = n - 2*j
        if exponent >= k:  # Can contribute to x^k term
            term = ((-1)**j) * comb(n-j, j) * (2**exponent) * comb(exponent, k)
            result += term
    return result

def explicit_delta_U_coefficient(n, k):
    """
    [x^k] ΔU_n(x+1) = [x^k] U_n(x+1) - [x^k] U_{n-1}(x+1)
    """
    U_n_k = explicit_U_n_coefficient(n, k)
    U_nm1_k = explicit_U_n_coefficient(n-1, k)
    return U_n_k - U_nm1_k

def verify_formula(n, k):
    """
    Verify: [x^k] ΔU_n(x+1) = 2^k · C(n+k, 2k)
    """
    actual = explicit_delta_U_coefficient(n, k)
    expected = (2**k) * comb(n+k, 2*k)
    return actual, expected, actual == expected

def analyze_sum_structure(n, k):
    """
    Analyze the double sum structure to find simplification

    [x^k] ΔU_n(x+1) = Σ_j (-1)^j · C(n-j,j) · 2^{n-2j} · C(n-2j,k)
                     - Σ_j (-1)^j · C(n-1-j,j) · 2^{n-1-2j} · C(n-1-2j,k)
    """
    print(f"\n{'='*80}")
    print(f"SUM STRUCTURE ANALYSIS: n={n}, k={k}")
    print(f"{'='*80}")

    print(f"\nFirst sum (U_n):")
    sum_U_n = 0
    terms_U_n = []
    for j in range((n+1)//2 + 1):
        exp = n - 2*j
        if exp >= k:
            term = ((-1)**j) * comb(n-j, j) * (2**exp) * comb(exp, k)
            sum_U_n += term
            terms_U_n.append((j, exp, term))
            print(f"  j={j}: (-1)^{j} · C({n-j},{j}) · 2^{exp} · C({exp},{k}) = {term}")

    print(f"\nSecond sum (U_{{n-1}}):")
    sum_U_nm1 = 0
    terms_U_nm1 = []
    for j in range(n//2 + 1):
        exp = n-1 - 2*j
        if exp >= k:
            term = ((-1)**j) * comb(n-1-j, j) * (2**exp) * comb(exp, k)
            sum_U_nm1 += term
            terms_U_nm1.append((j, exp, term))
            print(f"  j={j}: (-1)^{j} · C({n-1-j},{j}) · 2^{exp} · C({exp},{k}) = {term}")

    delta = sum_U_n - sum_U_nm1
    expected = (2**k) * comb(n+k, 2*k)

    print(f"\nΔU_n = {sum_U_n} - {sum_U_nm1} = {delta}")
    print(f"Formula: 2^{k} · C({n+k},{2*k}) = {expected}")
    print(f"Match: {delta == expected}")

    return delta, expected

def try_symbolic_simplification():
    """
    Try to simplify the double sum symbolically using SymPy
    """
    print(f"\n{'='*80}")
    print("SYMBOLIC SIMPLIFICATION ATTEMPT")
    print(f"{'='*80}")

    n, k, j = symbols('n k j', integer=True, positive=True)

    # Expression for [x^k] U_n(x+1)
    # Σ_{j=0}^{⌊n/2⌋} (-1)^j · C(n-j,j) · 2^{n-2j} · C(n-2j,k)

    print("\nTrying to find closed form for:")
    print("  Σ_j (-1)^j · C(n-j,j) · 2^{n-2j} · C(n-2j,k)")

    # For concrete values
    for n_val in [2, 4, 6]:
        for k_val in [1, 2]:
            if k_val <= n_val:
                print(f"\nn={n_val}, k={k_val}:")

                # Manual computation
                result = 0
                for j_val in range((n_val+1)//2 + 1):
                    exp = n_val - 2*j_val
                    if exp >= k_val:
                        term = ((-1)**j_val) * comb(n_val-j_val, j_val) * (2**exp) * comb(exp, k_val)
                        result += term

                # Expected from ΔU formula
                delta_U_result = explicit_delta_U_coefficient(n_val, k_val)
                formula_result = (2**k_val) * comb(n_val + k_val, 2*k_val)

                print(f"  U_n sum: {result}")
                print(f"  ΔU_n:    {delta_U_result}")
                print(f"  Formula: {formula_result}")

def look_for_telescoping():
    """
    Check if ΔU_n = U_n - U_{n-1} telescopes nicely

    Maybe terms cancel in a pattern?
    """
    print(f"\n{'='*80}")
    print("TELESCOPING ANALYSIS")
    print(f"{'='*80}")

    # For n=4, k=2
    n, k = 4, 2

    print(f"\nComparing terms for n={n} vs n-1={n-1}, k={k}:")
    print(f"\n{'j':<4} {'exp_n':<8} {'U_n term':<15} {'exp_n-1':<8} {'U_n-1 term':<15} {'Diff':<15}")
    print("-"*80)

    for j in range(max((n+1)//2 + 1, n//2 + 1)):
        # U_n term
        exp_n = n - 2*j
        if exp_n >= k and j <= n//2:
            term_n = ((-1)**j) * comb(n-j, j) * (2**exp_n) * comb(exp_n, k)
        else:
            term_n = 0

        # U_{n-1} term
        exp_nm1 = n-1 - 2*j
        if exp_nm1 >= k and j <= (n-1)//2:
            term_nm1 = ((-1)**j) * comb(n-1-j, j) * (2**exp_nm1) * comb(exp_nm1, k)
        else:
            term_nm1 = 0

        diff = term_n - term_nm1

        if term_n != 0 or term_nm1 != 0:
            print(f"{j:<4} {exp_n:<8} {term_n:<15} {exp_nm1:<8} {term_nm1:<15} {diff:<15}")

    delta_total = explicit_delta_U_coefficient(n, k)
    formula_val = (2**k) * comb(n+k, 2*k)

    print(f"\nTotal ΔU_n: {delta_total}")
    print(f"Formula:    {formula_val}")

if __name__ == "__main__":
    print("="*80)
    print("BINOMIAL IDENTITY PROOF ATTEMPT")
    print("="*80)

    # Phase 1: Verify formula on test cases
    print("\n" + "="*80)
    print("VERIFICATION")
    print("="*80)

    test_cases = [(2,1), (2,2), (4,1), (4,2), (4,3), (6,2), (6,3)]

    all_match = True
    for n, k in test_cases:
        actual, expected, match = verify_formula(n, k)
        status = "✓" if match else "✗"
        print(f"  n={n}, k={k}: {actual} = {expected} {status}")
        if not match:
            all_match = False

    if all_match:
        print("\n✓ All test cases verified numerically")

    # Phase 2: Analyze sum structure
    print("\n" + "="*80)
    print("DETAILED SUM ANALYSIS")
    print("="*80)

    for n, k in [(2,1), (4,2)]:
        analyze_sum_structure(n, k)

    # Phase 3: Look for patterns
    try_symbolic_simplification()

    # Phase 4: Check for telescoping
    look_for_telescoping()

    print("\n" + "="*80)
    print("SUMMARY")
    print("="*80)

    print("\n✓ Numerical verification: Formula holds")
    print("⏸️ Algebraic proof: Requires binomial identity")
    print("\nNext steps:")
    print("1. Try Vandermonde convolution identity")
    print("2. Try generating function for the double sum")
    print("3. Look for combinatorial interpretation")
    print("4. Consult advanced binomial identity references")
