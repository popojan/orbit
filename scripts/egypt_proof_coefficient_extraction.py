#!/usr/bin/env python3
"""
Extract explicit formula for coefficients of T_i(x+1) · ΔU_i(x+1)

Goal: Find closed form for coefficient of x^k in product
Then prove it equals 2^(k-1) · C(2i+k, 2k)
"""

import sympy as sp
from sympy import symbols, expand, collect, Poly, binomial, factorial
from math import comb

x = symbols('x')

def chebyshev_T_explicit(n, var):
    """T_n(x) using explicit formula"""
    # T_n(x) = Σ_{k=0}^{⌊n/2⌋} (-1)^k · C(n, 2k) · (2x)^{n-2k} · (1-x^2)^k
    # But simpler: use recurrence
    if n == 0:
        return sp.Integer(1)
    elif n == 1:
        return var
    else:
        T_prev2 = sp.Integer(1)
        T_prev1 = var
        for _ in range(2, n+1):
            T_curr = expand(2*var*T_prev1 - T_prev2)
            T_prev2 = T_prev1
            T_prev1 = T_curr
        return T_prev1

def chebyshev_U_explicit(n, var):
    """U_n(x) using explicit formula"""
    if n == 0:
        return sp.Integer(1)
    elif n == 1:
        return 2*var
    else:
        U_prev2 = sp.Integer(1)
        U_prev1 = 2*var
        for _ in range(2, n+1):
            U_curr = expand(2*var*U_prev1 - U_prev2)
            U_prev2 = U_prev1
            U_prev1 = U_curr
        return U_prev1

def extract_coefficient_formula(i):
    """
    For given i, extract all coefficients and look for pattern
    """
    print(f"="*80)
    print(f"COEFFICIENT EXTRACTION: i={i}")
    print(f"="*80)

    y = x + 1
    T_i = chebyshev_T_explicit(i, y)
    U_i = chebyshev_U_explicit(i, y)
    U_im1 = chebyshev_U_explicit(i-1, y)

    delta_U = expand(U_i - U_im1)
    product = expand(T_i * delta_U)

    poly = Poly(product, x)
    coeffs = poly.all_coeffs()[::-1]  # [c_0, c_1, c_2, ...]

    print(f"\nT_{i}(x+1) = {T_i}")
    print(f"\nU_{i}(x+1) - U_{i-1}(x+1) = {delta_U}")
    print(f"\nProduct = {product}")

    print(f"\nCoefficients:")
    for k in range(len(coeffs)):
        lhs_coeff = int(coeffs[k])
        rhs_coeff = 2**(k-1) * comb(2*i+k, 2*k) if k > 0 else 1

        # Try to factor lhs_coeff and see pattern
        if lhs_coeff != 0 and k > 0:
            # Check how many factors of 2
            temp = lhs_coeff
            power_of_2 = 0
            while temp % 2 == 0:
                temp //= 2
                power_of_2 += 1

            odd_part = lhs_coeff // (2**power_of_2) if power_of_2 > 0 else lhs_coeff

            print(f"  c_{k} = {lhs_coeff} = 2^{power_of_2} × {odd_part}")
            print(f"       RHS = 2^{k-1} × C({2*i+k},{2*k}) = {rhs_coeff}")

            # Check if odd_part is C(2i+k, 2k)
            binom_val = comb(2*i+k, 2*k)
            if odd_part == binom_val:
                print(f"       ✓ Odd part matches C({2*i+k},{2*k})")
                if power_of_2 == k-1:
                    print(f"       ✓ Power of 2 matches (2^{k-1})")
        else:
            print(f"  c_{k} = {lhs_coeff}")

def analyze_delta_U_structure(i):
    """
    Analyze ΔU_i(x+1) = U_i(x+1) - U_{i-1}(x+1) structure
    """
    print(f"\n{'='*80}")
    print(f"DELTA U STRUCTURE: i={i}")
    print(f"{'='*80}")

    y = x + 1
    U_i = chebyshev_U_explicit(i, y)
    U_im1 = chebyshev_U_explicit(i-1, y)
    delta_U = expand(U_i - U_im1)

    print(f"\nU_{i}(y) where y=x+1:")
    U_i_expanded = expand(U_i)
    print(f"  {U_i_expanded}")

    print(f"\nU_{i-1}(y) where y=x+1:")
    U_im1_expanded = expand(U_im1)
    print(f"  {U_im1_expanded}")

    print(f"\nΔU = U_{i}(y) - U_{i-1}(y):")
    print(f"  {delta_U}")

    # Check degree and leading coefficient
    poly = Poly(delta_U, x)
    degree = poly.degree()
    leading = poly.LC()

    print(f"\nDegree: {degree}")
    print(f"Leading coefficient: {leading}")

def analyze_T_structure(i):
    """
    Analyze T_i(x+1) structure
    """
    print(f"\n{'='*80}")
    print(f"T STRUCTURE: i={i}")
    print(f"{'='*80}")

    y = x + 1
    T_i = chebyshev_T_explicit(i, y)

    print(f"\nT_{i}(y) where y=x+1:")
    T_i_expanded = expand(T_i)
    print(f"  {T_i_expanded}")

    # Check degree and leading coefficient
    poly = Poly(T_i_expanded, x)
    degree = poly.degree()
    leading = poly.LC()

    print(f"\nDegree: {degree}")
    print(f"Leading coefficient: {leading}")

def test_explicit_formula_hypothesis():
    """
    Test hypothesis: coefficient of x^k is 2^(k-1) · C(2i+k, 2k)
    """
    print(f"\n{'='*80}")
    print(f"TESTING EXPLICIT FORMULA HYPOTHESIS")
    print(f"{'='*80}")

    print("\nHypothesis: [x^k] (T_i(x+1) · ΔU_i(x+1)) = 2^(k-1) · C(2i+k, 2k)")
    print("\nVerifying for multiple (i, k) pairs:")

    test_cases = [
        (1, 1), (1, 2),
        (2, 1), (2, 2), (2, 3), (2, 4),
        (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6),
        (4, 2), (4, 4),
    ]

    all_match = True
    for i, k in test_cases:
        j = 2*i
        y = x + 1
        T_i = chebyshev_T_explicit(i, y)
        U_i = chebyshev_U_explicit(i, y)
        U_im1 = chebyshev_U_explicit(i-1, y)
        delta_U = expand(U_i - U_im1)
        product = expand(T_i * delta_U)

        poly = Poly(product, x)
        coeffs = poly.all_coeffs()[::-1]

        lhs = int(coeffs[k]) if k < len(coeffs) else 0
        rhs = 2**(k-1) * comb(2*i+k, 2*k) if k > 0 else 1

        match = (lhs == rhs)
        all_match = all_match and match

        marker = "✓" if match else "✗"
        print(f"  (i={i}, k={k}): LHS={lhs:<10} RHS={rhs:<10} {marker}")

    print()
    if all_match:
        print("✅ All test cases match the formula!")
    else:
        print("❌ Some cases don't match")

if __name__ == "__main__":
    # Analyze structure for small i
    for i in [2, 3]:
        extract_coefficient_formula(i)
        analyze_delta_U_structure(i)
        analyze_T_structure(i)

    test_explicit_formula_hypothesis()

    print("\n" + "="*80)
    print("NEXT STEP: Direct algebraic proof")
    print("="*80)
    print("\nNeed to prove:")
    print("  [x^k] (T_i(x+1) · [U_i(x+1) - U_{i-1}(x+1)]) = 2^(k-1) · C(2i+k, 2k)")
    print("\nfor all k ∈ {1, ..., 2i} and all i ≥ 1")
    print("\nApproaches:")
    print("1. Use explicit Chebyshev formulas and multinomial theorem")
    print("2. Find generating function for T_i(x+1)·ΔU_i(x+1)")
    print("3. Use orthogonality properties of shifted Chebyshev")
    print("4. Connect to simple case Wildberger transitions (a=1,b=±i,c=-1)")
