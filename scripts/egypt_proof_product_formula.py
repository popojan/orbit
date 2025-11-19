#!/usr/bin/env python3
"""
Egypt-Chebyshev proof via Chebyshev product formulas

Key insight from trigonometric analysis:
  P_i(x) = T_i(x+1) · ΔU_i(x+1)
         = cos(iθ) · cos((i+0.5)θ) / cos(θ/2)
         where θ = arccos(x+1)

Strategy: Use product-to-sum formula to simplify this
"""

import sympy as sp
from sympy import symbols, expand, simplify, cos, sin, sqrt, atan, acos
from sympy import summation, collect, Poly, series, trigsimp
from math import comb

x, theta, i_sym, k_sym = symbols('x theta i k', real=True)

def product_to_sum_analysis():
    """
    cos(A) · cos(B) = 1/2 [cos(A+B) + cos(A-B)]

    For our case:
      cos(iθ) · cos((i+0.5)θ) = 1/2 [cos((2i+0.5)θ) + cos(-0.5θ)]
                                = 1/2 [cos((2i+0.5)θ) + cos(0.5θ)]

    So:
      P_i(x) = [cos((2i+0.5)θ) + cos(0.5θ)] / [2 cos(θ/2)]
    """
    print("="*80)
    print("PRODUCT-TO-SUM FORMULA APPROACH")
    print("="*80)

    print("\nStarting point (from trigonometric analysis):")
    print("  P_i(x) = cos(iθ) · cos((i+0.5)θ) / cos(θ/2)")
    print("  where θ = arccos(x+1)")

    print("\nApply product-to-sum:")
    print("  cos(A)·cos(B) = 1/2[cos(A+B) + cos(A-B)]")
    print("  A = iθ, B = (i+0.5)θ")
    print("  A+B = (2i+0.5)θ")
    print("  A-B = -0.5θ = -θ/2")

    print("\nResult:")
    print("  cos(iθ)·cos((i+0.5)θ) = 1/2[cos((2i+0.5)θ) + cos(θ/2)]")

    print("\nTherefore:")
    print("  P_i(x) = [cos((2i+0.5)θ) + cos(θ/2)] / [2cos(θ/2)]")
    print("         = cos((2i+0.5)θ)/(2cos(θ/2)) + 1/2")
    print("         = (1/2)·[cos((2i+0.5)θ)/cos(θ/2) + 1]")

    print("\nLet's define:")
    print("  Q_i(x) = cos((2i+0.5)θ) / cos(θ/2)")
    print("  Then: P_i(x) = (1/2)[Q_i(x) + 1]")

    print("\nThis is INTERESTING!")
    print("  - P_i(x) is related to shifted/scaled version of another cosine ratio")
    print("  - Q_i(x) might have simpler expansion")

def analyze_Q_polynomial(i_val):
    """
    Analyze Q_i(x) = cos((2i+0.5)θ) / cos(θ/2)  where θ = arccos(x+1)

    This is similar to ΔU, but with different multiplier.
    """
    print(f"\n{'='*80}")
    print(f"ANALYZING Q_{i_val}(x)")
    print(f"{'='*80}")

    print(f"\nQ_{i_val}(x) = cos({2*i_val + 0.5}θ) / cos(θ/2)")
    print(f"         where θ = arccos(x+1)")

    print(f"\nNote: This is a Chebyshev-like polynomial")
    print(f"Similar structure to ΔU_{i_val}(x+1) = cos({i_val+0.5}θ) / cos(θ/2)")

    print(f"\nRelationship:")
    print(f"  ΔU_{i_val}(x+1) uses (i+0.5)θ")
    print(f"  Q_{i_val}(x) uses (2i+0.5)θ")
    print(f"  Q_{i_val}(x) = ΔU_{2*i_val}(x+1) ???")

    # Let's compute both and compare
    print(f"\n{'-'*80}")
    print(f"COMPUTATIONAL VERIFICATION:")
    print(f"{'-'*80}")

    x_sym = symbols('x')

    # Compute P_i directly
    def chebyshev_T(n, y):
        if n == 0:
            return sp.Integer(1)
        elif n == 1:
            return y
        else:
            T_prev2 = sp.Integer(1)
            T_prev1 = y
            for _ in range(2, n + 1):
                T_curr = expand(2*y*T_prev1 - T_prev2)
                T_prev2 = T_prev1
                T_prev1 = T_curr
            return T_prev1

    def chebyshev_U(n, y):
        if n == 0:
            return sp.Integer(1)
        elif n == 1:
            return 2*y
        else:
            U_prev2 = sp.Integer(1)
            U_prev1 = 2*y
            for _ in range(2, n + 1):
                U_curr = expand(2*y*U_prev1 - U_prev2)
                U_prev2 = U_prev1
                U_prev1 = U_curr
            return U_prev1

    T_i = chebyshev_T(i_val, x_sym + 1)
    U_i = chebyshev_U(i_val, x_sym + 1)
    U_im1 = chebyshev_U(i_val - 1, x_sym + 1)
    delta_U = expand(U_i - U_im1)

    P_i = expand(T_i * delta_U)

    print(f"\nP_{i_val}(x) = {P_i}")

    # If P_i = (1/2)[Q_i + 1], then Q_i = 2*P_i - 1
    Q_i_implied = expand(2*P_i - 1)

    print(f"\nImplied Q_{i_val}(x) = 2P_{i_val} - 1:")
    print(f"  Q_{i_val}(x) = {Q_i_implied}")

    # Now compute ΔU_{2i}(x+1)
    if 2*i_val > 0:
        U_2i = chebyshev_U(2*i_val, x_sym + 1)
        U_2im1 = chebyshev_U(2*i_val - 1, x_sym + 1)
        delta_U_2i = expand(U_2i - U_2im1)

        print(f"\nΔU_{2*i_val}(x+1) = {delta_U_2i}")

        print(f"\n{'-'*80}")
        print(f"COMPARISON:")
        print(f"{'-'*80}")

        if Q_i_implied == delta_U_2i:
            print(f"✓ Q_{i_val}(x) = ΔU_{2*i_val}(x+1) EXACTLY!")
            print(f"\nThis is a BREAKTHROUGH!")
            print(f"  P_{i_val}(x) = (1/2)[ΔU_{2*i_val}(x+1) + 1]")
            return True
        else:
            print(f"✗ Q_{i_val}(x) ≠ ΔU_{2*i_val}(x+1)")
            print(f"\nLet's check if they're related by a constant...")

            ratio = simplify(Q_i_implied / delta_U_2i) if delta_U_2i != 0 else None
            if ratio and ratio.is_constant():
                print(f"  Q_{i_val}/ΔU_{2*i_val} = {ratio}")
            else:
                print(f"  Not a simple constant ratio")

            return False

def derive_formula_from_product(i_val):
    """
    If P_i(x) = (1/2)[ΔU_{2i}(x+1) + 1], can we derive the coefficient formula?

    [x^k] P_i(x) = (1/2) [x^k] ΔU_{2i}(x+1)  for k > 0
    [x^0] P_i(x) = (1/2) [x^0] ΔU_{2i}(x+1) + 1/2
    """
    print(f"\n{'='*80}")
    print(f"DERIVING FORMULA FROM PRODUCT RELATIONSHIP: i={i_val}")
    print(f"{'='*80}")

    print(f"\nHypothesis: P_{i_val}(x) = (1/2)[ΔU_{2*i_val}(x+1) + 1]")

    print(f"\nThis means:")
    print(f"  [x^k] P_{i_val}(x) = (1/2)[x^k] ΔU_{2*i_val}(x+1)  for k > 0")
    print(f"  [x^0] P_{i_val}(x) = (1/2)[x^0] ΔU_{2*i_val}(x+1) + 1/2")

    print(f"\nNow, ΔU_n(x+1) has known structure (it's Chebyshev second kind)")
    print(f"We need to find [x^k] ΔU_n(x+1) in terms of k and n")

    # Compute ΔU_{2i}(x+1) explicitly
    x_sym = symbols('x')

    def chebyshev_U(n, y):
        if n == 0:
            return sp.Integer(1)
        elif n == 1:
            return 2*y
        else:
            U_prev2 = sp.Integer(1)
            U_prev1 = 2*y
            for _ in range(2, n + 1):
                U_curr = expand(2*y*U_prev1 - U_prev2)
                U_prev2 = U_prev1
                U_prev1 = U_curr
            return U_prev1

    U_2i = chebyshev_U(2*i_val, x_sym + 1)
    U_2im1 = chebyshev_U(2*i_val - 1, x_sym + 1)
    delta_U_2i = expand(U_2i - U_2im1)

    poly = Poly(delta_U_2i, x_sym)
    coeffs = poly.all_coeffs()[::-1]

    print(f"\nΔU_{2*i_val}(x+1) coefficients:")
    print(f"{'k':<6} {'[x^k] ΔU':<15} {'[x^k] P (pred)':<15} {'[x^k] P (act)':<15} {'Match':<8}")
    print("-"*70)

    # Get actual P_i coefficients
    def chebyshev_T(n, y):
        if n == 0:
            return sp.Integer(1)
        elif n == 1:
            return y
        else:
            T_prev2 = sp.Integer(1)
            T_prev1 = y
            for _ in range(2, n + 1):
                T_curr = expand(2*y*T_prev1 - T_prev2)
                T_prev2 = T_prev1
                T_prev1 = T_curr
            return T_prev1

    T_i = chebyshev_T(i_val, x_sym + 1)
    U_i = chebyshev_U(i_val, x_sym + 1)
    U_im1 = chebyshev_U(i_val - 1, x_sym + 1)
    delta_U_i = expand(U_i - U_im1)
    P_i = expand(T_i * delta_U_i)

    P_poly = Poly(P_i, x_sym)
    P_coeffs = P_poly.all_coeffs()[::-1]

    all_match = True
    for k in range(max(len(coeffs), len(P_coeffs))):
        delta_U_k = int(coeffs[k]) if k < len(coeffs) else 0

        if k == 0:
            pred_P_k = delta_U_k // 2 + 1  # (1/2)*coeff + 1/2
        else:
            pred_P_k = delta_U_k // 2  # (1/2)*coeff

        act_P_k = int(P_coeffs[k]) if k < len(P_coeffs) else 0

        match = "✓" if pred_P_k == act_P_k else "✗"
        if pred_P_k != act_P_k:
            all_match = False

        if k < 8:  # Show first 8
            print(f"{k:<6} {delta_U_k:<15} {pred_P_k:<15} {act_P_k:<15} {match:<8}")

    return all_match

if __name__ == "__main__":
    print("="*80)
    print("EGYPT-CHEBYSHEV PROOF: PRODUCT FORMULA APPROACH")
    print("="*80)

    # Phase 1: Derive product-to-sum structure
    product_to_sum_analysis()

    # Phase 2: Analyze Q polynomial
    print("\n" + "="*80)
    print("TESTING Q POLYNOMIAL HYPOTHESIS")
    print("="*80)

    results = {}
    for i_val in [1, 2, 3, 4]:
        results[i_val] = analyze_Q_polynomial(i_val)

    print("\n" + "="*80)
    print("Q POLYNOMIAL RESULTS:")
    print("="*80)

    for i_val, result in results.items():
        status = "✓" if result else "✗"
        print(f"  i={i_val}: Q_i = ΔU_{2*i_val} ? {status}")

    # Phase 3: Derive formula
    print("\n" + "="*80)
    print("FORMULA DERIVATION")
    print("="*80)

    for i_val in [1, 2, 3]:
        result = derive_formula_from_product(i_val)
        status = "✓" if result else "✗"
        print(f"\nFormula derivation for i={i_val}: {status}")

    print("\n" + "="*80)
    print("CONCLUSION")
    print("="*80)

    print("\nKey findings:")
    print("1. P_i(x) = (1/2)[cos((2i+0.5)θ)/cos(θ/2) + 1]")
    print("2. Testing if this equals (1/2)[ΔU_{2i}(x+1) + 1]")
    print("3. If true, connects to known Chebyshev structure")
    print("\nIf relationship holds, we can:")
    print("  - Use known ΔU formulas")
    print("  - Derive P_i coefficients from ΔU_{2i}")
    print("  - Connect to Egypt-Chebyshev formula")
