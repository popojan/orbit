#!/usr/bin/env python3
"""
Prove ΔU_n(x+1) coefficient formula via recurrence relations

Goal: Prove [x^k] ΔU_n(x+1) = 2^k · C(n+k, 2k) for even n

Strategy:
1. Use recurrence relation: U_n(x) = 2x·U_{n-1}(x) - U_{n-2}(x)
2. Shift to U_n(x+1): substitute x → x+1
3. Derive recurrence for coefficients [x^k] U_n(x+1)
4. Find formula for [x^k] ΔU_n(x+1) = [x^k](U_n - U_{n-1})
"""

import sympy as sp
from sympy import symbols, expand, Poly, simplify
from math import comb

def compute_U_coefficients(n_val):
    """
    Compute all coefficients of U_n(x+1) using recurrence
    """
    x = symbols('x')

    # Base cases
    U_0 = sp.Integer(1)
    U_1 = 2*(x + 1)

    if n_val == 0:
        poly = Poly(U_0, x)
    elif n_val == 1:
        poly = Poly(expand(U_1), x)
    else:
        # Recurrence: U_n(y) = 2y·U_{n-1}(y) - U_{n-2}(y)
        # For y = x+1:
        U_prev2 = U_0
        U_prev1 = expand(U_1)

        for i in range(2, n_val + 1):
            U_curr = expand(2*(x+1)*U_prev1 - U_prev2)
            U_prev2 = U_prev1
            U_prev1 = U_curr

        poly = Poly(U_prev1, x)

    coeffs = poly.all_coeffs()[::-1]  # [c_0, c_1, ..., c_n]
    return [int(c) for c in coeffs]

def analyze_recurrence_pattern():
    """
    Analyze how coefficients evolve through recurrence

    U_n(x+1) = 2(x+1)·U_{n-1}(x+1) - U_{n-2}(x+1)

    If U_{n-1}(x+1) = Σ a_k x^k
    and U_{n-2}(x+1) = Σ b_k x^k

    Then U_n(x+1) = 2(x+1)·Σa_k x^k - Σb_k x^k
                  = 2x·Σa_k x^k + 2·Σa_k x^k - Σb_k x^k
                  = Σ[2a_{k-1} + 2a_k - b_k] x^k

    So: c_k^{(n)} = 2·a_{k-1}^{(n-1)} + 2·a_k^{(n-1)} - b_k^{(n-2)}
    """
    print("="*80)
    print("RECURRENCE PATTERN ANALYSIS")
    print("="*80)

    print("\nU_n(x+1) = 2(x+1)·U_{n-1}(x+1) - U_{n-2}(x+1)")
    print("\nCoefficient recurrence:")
    print("  [x^k] U_n(x+1) = 2·[x^{k-1}] U_{n-1}(x+1)")
    print("                 + 2·[x^k] U_{n-1}(x+1)")
    print("                 - [x^k] U_{n-2}(x+1)")

    # Test on specific cases
    for n in [2, 4, 6]:
        print(f"\n{'-'*80}")
        print(f"n = {n}")
        print(f"{'-'*80}")

        U_n = compute_U_coefficients(n)
        U_nm1 = compute_U_coefficients(n-1)
        U_nm2 = compute_U_coefficients(n-2)

        print(f"\nVerifying recurrence:")
        max_k = len(U_n)

        for k in range(min(5, max_k)):
            c_k = U_n[k]

            a_km1 = U_nm1[k-1] if k > 0 and k-1 < len(U_nm1) else 0
            a_k = U_nm1[k] if k < len(U_nm1) else 0
            b_k = U_nm2[k] if k < len(U_nm2) else 0

            predicted = 2*a_km1 + 2*a_k - b_k

            match = "✓" if c_k == predicted else "✗"
            print(f"  k={k}: {c_k} = 2·{a_km1} + 2·{a_k} - {b_k} = {predicted} {match}")

def derive_delta_U_recurrence():
    """
    Derive recurrence for ΔU_n = U_n - U_{n-1}

    ΔU_n(x+1) = U_n(x+1) - U_{n-1}(x+1)

    From U_n = 2(x+1)·U_{n-1} - U_{n-2}:

    ΔU_n = U_n - U_{n-1}
         = [2(x+1)·U_{n-1} - U_{n-2}] - U_{n-1}
         = 2(x+1)·U_{n-1} - U_{n-1} - U_{n-2}
         = (2x+1)·U_{n-1} - U_{n-2}
         = (2x+1)·U_{n-1} - U_{n-2}

    But also:
    ΔU_{n-1} = U_{n-1} - U_{n-2}
    So: U_{n-2} = U_{n-1} - ΔU_{n-1}

    Therefore:
    ΔU_n = (2x+1)·U_{n-1} - (U_{n-1} - ΔU_{n-1})
         = (2x+1)·U_{n-1} - U_{n-1} + ΔU_{n-1}
         = 2x·U_{n-1} + ΔU_{n-1}
    """
    print("\n" + "="*80)
    print("ΔU RECURRENCE DERIVATION")
    print("="*80)

    print("\nStarting from: U_n = 2(x+1)·U_{n-1} - U_{n-2}")
    print("\nΔU_n = U_n - U_{n-1}")
    print("     = 2(x+1)·U_{n-1} - U_{n-2} - U_{n-1}")
    print("     = (2x+1)·U_{n-1} - U_{n-2}")

    print("\nUsing U_{n-2} = U_{n-1} - ΔU_{n-1}:")
    print("ΔU_n = (2x+1)·U_{n-1} - U_{n-1} + ΔU_{n-1}")
    print("     = 2x·U_{n-1} + ΔU_{n-1}")

    print("\n" + "="*80)
    print("KEY RECURRENCE FOR ΔU:")
    print("="*80)
    print("\nΔU_n(x+1) = 2(x+1)·U_{n-1}(x+1) + ΔU_{n-1}(x+1)")
    print("          = 2x·U_{n-1}(x+1) + 2·U_{n-1}(x+1) + ΔU_{n-1}(x+1)")

    # Verify this recurrence
    print("\n" + "-"*80)
    print("VERIFICATION:")
    print("-"*80)

    x = symbols('x')

    for n in [2, 4, 6]:
        # Compute ΔU_n directly
        U_n = compute_U_coefficients(n)
        U_nm1 = compute_U_coefficients(n-1)
        delta_U_n_direct = [U_n[k] - (U_nm1[k] if k < len(U_nm1) else 0)
                           for k in range(len(U_n))]

        # Compute via recurrence: ΔU_n = 2x·U_{n-1} + ΔU_{n-1}
        U_nm1_coeffs = compute_U_coefficients(n-1)
        U_nm2_coeffs = compute_U_coefficients(n-2)
        delta_U_nm1 = [U_nm1_coeffs[k] - (U_nm2_coeffs[k] if k < len(U_nm2_coeffs) else 0)
                       for k in range(max(len(U_nm1_coeffs), len(U_nm2_coeffs)))]

        # 2x·U_{n-1} shifts coefficients: [a_0, a_1, ...] → [0, 2a_0, 2a_1, ...]
        two_x_U_nm1 = [0] + [2*c for c in U_nm1_coeffs]

        # Add 2·U_{n-1}
        two_U_nm1 = [2*c for c in U_nm1_coeffs]

        # ΔU_n = 2x·U_{n-1} + 2·U_{n-1} + ΔU_{n-1}
        max_len = max(len(two_x_U_nm1), len(two_U_nm1), len(delta_U_nm1))
        delta_U_n_recurrence = []
        for k in range(max_len):
            term1 = two_x_U_nm1[k] if k < len(two_x_U_nm1) else 0
            term2 = two_U_nm1[k] if k < len(two_U_nm1) else 0
            term3 = delta_U_nm1[k] if k < len(delta_U_nm1) else 0
            delta_U_n_recurrence.append(term1 + term2 + term3)

        print(f"\nn = {n}:")
        match = all(delta_U_n_direct[k] == delta_U_n_recurrence[k]
                   for k in range(min(len(delta_U_n_direct), len(delta_U_n_recurrence))))
        print(f"  Recurrence matches direct computation: {match}")

        if not match:
            print("  Direct:", delta_U_n_direct[:6])
            print("  Recurrence:", delta_U_n_recurrence[:6])

def test_coefficient_formula_via_recurrence(n_val):
    """
    Given: [x^k] ΔU_n(x+1) = 2^k · C(n+k, 2k)

    Can we prove this satisfies the recurrence?

    ΔU_n = 2x·U_{n-1} + 2·U_{n-1} + ΔU_{n-1}
    """
    print(f"\n{'='*80}")
    print(f"TESTING FORMULA VIA RECURRENCE: n={n_val}")
    print(f"{'='*80}")

    print(f"\nHypothesis: [x^k] ΔU_{n_val}(x+1) = 2^k · C({n_val}+k, 2k)")

    # Compute actual ΔU_n coefficients
    U_n = compute_U_coefficients(n_val)
    U_nm1 = compute_U_coefficients(n_val - 1)
    delta_U_n = [U_n[k] - (U_nm1[k] if k < len(U_nm1) else 0)
                 for k in range(len(U_n))]

    # Compare to formula
    print(f"\n{'k':<6} {'Actual':<15} {'Formula':<15} {'Match':<8}")
    print("-"*50)

    all_match = True
    for k in range(min(8, len(delta_U_n))):
        actual = delta_U_n[k]
        expected = (2**k) * comb(n_val + k, 2*k)
        match = "✓" if actual == expected else "✗"
        if actual != expected:
            all_match = False
        print(f"{k:<6} {actual:<15} {expected:<15} {match:<8}")

    return all_match

if __name__ == "__main__":
    print("="*80)
    print("EGYPT-CHEBYSHEV: RECURRENCE APPROACH FOR ΔU_n(x+1)")
    print("="*80)

    # Phase 1: Understand recurrence structure
    analyze_recurrence_pattern()

    # Phase 2: Derive ΔU recurrence
    derive_delta_U_recurrence()

    # Phase 3: Test if formula satisfies recurrence
    print("\n" + "="*80)
    print("TESTING FORMULA")
    print("="*80)

    results = {}
    for n in [2, 4, 6, 8]:
        results[n] = test_coefficient_formula_via_recurrence(n)

    print(f"\n{'='*80}")
    print("SUMMARY")
    print(f"{'='*80}")

    for n, result in results.items():
        status = "✓" if result else "✗"
        print(f"  n={n}: Formula verified {status}")

    if all(results.values()):
        print(f"\n✓ Formula holds for all tested cases")
        print(f"\nNext: Prove formula satisfies recurrence algebraically")
    else:
        print(f"\n✗ Formula does not match recurrence")
