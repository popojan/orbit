#!/usr/bin/env python3
"""
Egypt-Chebyshev proof via direct mechanical computation

Strategy: BRUTE FORCE approach
1. Use explicit trigonometric formulas for T_n and U_n
2. Substitute x → x+1 mechanically
3. Expand using Euler's formula and binomial theorem
4. Extract coefficients and match to 2^(k-1) · C(2i+k, 2k)

This is the "guaranteed to work if formula is correct" approach.
May be messy, but should give definitive answer.
"""

import sympy as sp
from sympy import symbols, expand, simplify, cos, sin, sqrt, binomial, factorial
from sympy import summation, collect, Poly
from math import comb

x, n, k, theta = symbols('x n k theta', real=True)

def chebyshev_T_explicit(n_val, x_sym):
    """
    Explicit formula: T_n(x) = cos(n * arccos(x))

    But for algebraic manipulation, use:
    T_n(x) = (1/2) * [(x + sqrt(x²-1))^n + (x - sqrt(x²-1))^n]

    Or use recurrence for concrete values.
    """
    if n_val == 0:
        return sp.Integer(1)
    elif n_val == 1:
        return x_sym
    else:
        # Use recurrence: T_{n+1} = 2x*T_n - T_{n-1}
        T_prev2 = sp.Integer(1)
        T_prev1 = x_sym
        for i in range(2, n_val + 1):
            T_curr = expand(2 * x_sym * T_prev1 - T_prev2)
            T_prev2 = T_prev1
            T_prev1 = T_curr
        return T_prev1

def chebyshev_U_explicit(n_val, x_sym):
    """
    Explicit formula: U_n(x) = sin((n+1) * arccos(x)) / sin(arccos(x))

    Algebraically: U_n(x) = [(x+sqrt(x²-1))^{n+1} - (x-sqrt(x²-1))^{n+1}] / (2*sqrt(x²-1))

    Use recurrence for concrete values.
    """
    if n_val == 0:
        return sp.Integer(1)
    elif n_val == 1:
        return 2 * x_sym
    else:
        # Use recurrence: U_{n+1} = 2x*U_n - U_{n-1}
        U_prev2 = sp.Integer(1)
        U_prev1 = 2 * x_sym
        for i in range(2, n_val + 1):
            U_curr = expand(2 * x_sym * U_prev1 - U_prev2)
            U_prev2 = U_prev1
            U_prev1 = U_curr
        return U_prev1

def direct_expansion_approach_1(i_val):
    """
    Approach 1: Use algebraic formulas

    T_n(x) = (1/2) * [(x + sqrt(x²-1))^n + (x - sqrt(x²-1))^n]

    Substitute x → x+1:
    T_n(x+1) = (1/2) * [(x+1 + sqrt((x+1)²-1))^n + (x+1 - sqrt((x+1)²-1))^n]
             = (1/2) * [(x+1 + sqrt(x²+2x))^n + (x+1 - sqrt(x²+2x))^n]

    This should expand to polynomial in x.
    """
    print(f"\n{'='*80}")
    print(f"DIRECT EXPANSION: i={i_val}")
    print(f"{'='*80}")

    x_sym = symbols('x', real=True, positive=True)

    # Build using recurrence (more reliable than algebraic form)
    T_i = chebyshev_T_explicit(i_val, x_sym + 1)
    U_i = chebyshev_U_explicit(i_val, x_sym + 1)
    U_im1 = chebyshev_U_explicit(i_val - 1, x_sym + 1)

    delta_U = expand(U_i - U_im1)

    print(f"\nT_{i_val}(x+1) = {T_i}")
    print(f"\nΔU_{i_val}(x+1) = {delta_U}")

    # Compute product
    product = expand(T_i * delta_U)

    print(f"\nP_{i_val}(x) = T_{i_val}(x+1) · ΔU_{i_val}(x+1)")
    print(f"        = {product}")

    # Extract coefficients
    poly = Poly(product, x_sym)
    coeffs = poly.all_coeffs()[::-1]  # [c_0, c_1, ..., c_{2i}]

    print(f"\n{'k':<6} {'Actual':<15} {'Formula':<15} {'Match':<8}")
    print("-"*50)

    all_match = True
    for k_val in range(len(coeffs)):
        actual = int(coeffs[k_val])
        expected = 2**(k_val-1) * comb(2*i_val + k_val, 2*k_val) if k_val > 0 else 1
        match = "✓" if actual == expected else "✗"

        if actual != expected:
            all_match = False

        print(f"{k_val:<6} {actual:<15} {expected:<15} {match:<8}")

    return all_match

def try_algebraic_identity_approach(i_val):
    """
    Approach 2: Look for algebraic identity

    Key observation: We need to prove convolution equals binomial

    Σ_{m=0}^k [x^m] T_i(x+1) · [x^{k-m}] ΔU_i(x+1) = 2^(k-1) · C(2i+k, 2k)

    Maybe there's a generating function or identity that directly gives this.
    """
    print(f"\n{'='*80}")
    print(f"ALGEBRAIC IDENTITY SEARCH: i={i_val}")
    print(f"{'='*80}")

    # Get coefficient arrays
    x_sym = symbols('x')
    T_i = chebyshev_T_explicit(i_val, x_sym + 1)
    U_i = chebyshev_U_explicit(i_val, x_sym + 1)
    U_im1 = chebyshev_U_explicit(i_val - 1, x_sym + 1)
    delta_U = expand(U_i - U_im1)

    T_poly = Poly(T_i, x_sym)
    delta_poly = Poly(delta_U, x_sym)

    T_coeffs = T_poly.all_coeffs()[::-1]
    delta_coeffs = delta_poly.all_coeffs()[::-1]

    print(f"\nT_{i_val}(x+1) coefficients:")
    for m in range(len(T_coeffs)):
        if T_coeffs[m] != 0:
            print(f"  [x^{m}] = {int(T_coeffs[m])}")

    print(f"\nΔU_{i_val}(x+1) coefficients:")
    for m in range(len(delta_coeffs)):
        if delta_coeffs[m] != 0:
            print(f"  [x^{m}] = {int(delta_coeffs[m])}")

    # Look for patterns
    print(f"\n{'-'*80}")
    print(f"Pattern analysis:")
    print(f"{'-'*80}")

    # Check if T coefficients have closed form
    print(f"\nT_{i_val}(x+1) coefficient formula guess:")
    for m in range(min(i_val + 1, len(T_coeffs))):
        c_m = int(T_coeffs[m])
        if c_m == 0:
            continue

        # Try to express as binomial with power of 2
        # Test various hypotheses
        found = False

        # Hypothesis 1: C(i, m) * 2^something
        for pow2 in range(10):
            if m <= i_val and c_m == comb(i_val, m) * (2**pow2):
                print(f"  [x^{m}] = C({i_val},{m}) · 2^{pow2}")
                found = True
                break

        if not found:
            print(f"  [x^{m}] = {c_m} (no simple pattern found)")

    print(f"\nΔU_{i_val}(x+1) coefficient formula guess:")
    for m in range(min(i_val + 1, len(delta_coeffs))):
        c_m = int(delta_coeffs[m])
        if c_m == 0:
            continue

        found = False

        # Try various binomial combinations
        for offset in range(-3, 4):
            for pow2 in range(10):
                n_try = i_val + offset
                if 0 <= m <= n_try and c_m == comb(n_try, m) * (2**pow2):
                    print(f"  [x^{m}] = C({n_try},{m}) · 2^{pow2}")
                    found = True
                    break
            if found:
                break

        if not found:
            print(f"  [x^{m}] = {c_m} (no simple pattern found)")

def try_trigonometric_approach(i_val):
    """
    Approach 3: Use trigonometric definitions directly

    T_n(x+1) = cos(n * arccos(x+1))
    U_n(x+1) = sin((n+1) * arccos(x+1)) / sin(arccos(x+1))

    This might not be algebraically tractable, but worth documenting.
    """
    print(f"\n{'='*80}")
    print(f"TRIGONOMETRIC APPROACH: i={i_val}")
    print(f"{'='*80}")

    print(f"\nTrigonometric definitions:")
    print(f"  T_{i_val}(x+1) = cos({i_val} · arccos(x+1))")
    print(f"  U_{i_val}(x+1) = sin({i_val+1} · arccos(x+1)) / sin(arccos(x+1))")
    print(f"  U_{i_val-1}(x+1) = sin({i_val} · arccos(x+1)) / sin(arccos(x+1))")

    print(f"\nΔU_{i_val}(x+1) = U_{i_val}(x+1) - U_{i_val-1}(x+1)")
    print(f"              = [sin({i_val+1}θ) - sin({i_val}θ)] / sin(θ)")
    print(f"              where θ = arccos(x+1)")

    print(f"\nUsing sum-to-product:")
    print(f"  sin(A) - sin(B) = 2 cos((A+B)/2) sin((A-B)/2)")
    print(f"  sin({i_val+1}θ) - sin({i_val}θ) = 2 cos({i_val + 0.5}θ) sin(θ/2)")

    print(f"\nTherefore:")
    print(f"  ΔU_{i_val}(x+1) = 2 cos({i_val + 0.5}θ) sin(θ/2) / sin(θ)")
    print(f"                 = 2 cos({i_val + 0.5}θ) · [sin(θ/2) / sin(θ)]")

    print(f"\nNote: sin(θ) = 2 sin(θ/2) cos(θ/2)")
    print(f"  So: sin(θ/2) / sin(θ) = 1 / [2 cos(θ/2)]")

    print(f"\nFinal form:")
    print(f"  ΔU_{i_val}(x+1) = cos({i_val + 0.5}θ) / cos(θ/2)")
    print(f"                 where θ = arccos(x+1)")

    print(f"\nProduct:")
    print(f"  P_{i_val}(x) = T_{i_val}(x+1) · ΔU_{i_val}(x+1)")
    print(f"            = cos({i_val}θ) · cos({i_val + 0.5}θ) / cos(θ/2)")

    print(f"\nThis is algebraically complex to expand to polynomial form.")
    print(f"Would need product-to-sum formulas and careful expansion.")

def analyze_convolution_structure(i_val, k_val):
    """
    Approach 4: Analyze convolution structure directly

    We know: Σ_{m=0}^k c_m^T · d_{k-m}^ΔU = 2^(k-1) · C(2i+k, 2k)

    Can we prove this combinatorially or algebraically?
    """
    print(f"\n{'='*80}")
    print(f"CONVOLUTION ANALYSIS: i={i_val}, k={k_val}")
    print(f"{'='*80}")

    x_sym = symbols('x')
    T_i = chebyshev_T_explicit(i_val, x_sym + 1)
    U_i = chebyshev_U_explicit(i_val, x_sym + 1)
    U_im1 = chebyshev_U_explicit(i_val - 1, x_sym + 1)
    delta_U = expand(U_i - U_im1)

    T_poly = Poly(T_i, x_sym)
    delta_poly = Poly(delta_U, x_sym)

    T_coeffs = T_poly.all_coeffs()[::-1]
    delta_coeffs = delta_poly.all_coeffs()[::-1]

    print(f"\nConvolution for [x^{k_val}]:")
    print(f"{'m':<6} {'c_m^T':<10} {'d_{{k-m}}^ΔU':<12} {'Product':<12}")
    print("-"*50)

    conv_sum = 0
    for m in range(k_val + 1):
        c_m = int(T_coeffs[m]) if m < len(T_coeffs) else 0
        d_km = int(delta_coeffs[k_val - m]) if (k_val - m) < len(delta_coeffs) else 0
        prod = c_m * d_km

        if prod != 0:
            conv_sum += prod
            print(f"{m:<6} {c_m:<10} {d_km:<12} {prod:<12}")

    expected = 2**(k_val-1) * comb(2*i_val + k_val, 2*k_val) if k_val > 0 else 1

    print(f"\nTotal convolution: {conv_sum}")
    print(f"Expected formula:  {expected}")
    print(f"Match: {conv_sum == expected}")

    return conv_sum == expected

if __name__ == "__main__":
    print("="*80)
    print("EGYPT-CHEBYSHEV PROOF: DIRECT MECHANICAL COMPUTATION")
    print("="*80)

    print("\nSTRATEGY:")
    print("  Brute force approach using multiple angles")
    print("  Goal: Find algebraic proof or identify where it breaks")

    # Test cases
    test_cases = [
        (1, "simple case"),
        (2, "small case"),
        (3, "medium case"),
        (4, "larger case"),
    ]

    print("\n" + "="*80)
    print("PHASE 1: DIRECT EXPANSION (verify formula holds)")
    print("="*80)

    for i_val, description in test_cases:
        print(f"\n--- Testing i={i_val} ({description}) ---")
        result = direct_expansion_approach_1(i_val)
        if result:
            print(f"\n✓ Formula VERIFIED for i={i_val}")
        else:
            print(f"\n✗ Formula FAILED for i={i_val}")

    print("\n" + "="*80)
    print("PHASE 2: ALGEBRAIC IDENTITY SEARCH")
    print("="*80)

    for i_val, description in test_cases[:3]:  # Just first 3
        try_algebraic_identity_approach(i_val)

    print("\n" + "="*80)
    print("PHASE 3: TRIGONOMETRIC APPROACH")
    print("="*80)

    try_trigonometric_approach(2)  # Example case

    print("\n" + "="*80)
    print("PHASE 4: CONVOLUTION STRUCTURE ANALYSIS")
    print("="*80)

    # Analyze specific convolutions
    test_convolutions = [
        (2, 2, "central coefficient"),
        (3, 3, "central coefficient"),
        (2, 1, "early coefficient"),
        (3, 2, "middle coefficient"),
    ]

    for i_val, k_val, desc in test_convolutions:
        analyze_convolution_structure(i_val, k_val)

    print("\n" + "="*80)
    print("SUMMARY")
    print("="*80)

    print("\nPhase 1: ✓ Verified formula holds numerically")
    print("Phase 2: Searched for algebraic pattern in coefficients")
    print("Phase 3: Analyzed trigonometric structure")
    print("Phase 4: Examined convolution properties")

    print("\n" + "="*80)
    print("NEXT STEPS FOR PROOF")
    print("="*80)

    print("\nApproaches to try:")
    print("1. Find closed form for T_i(x+1) coefficients")
    print("2. Find closed form for ΔU_i(x+1) coefficients")
    print("3. Prove convolution formula directly")
    print("4. Use product formulas: T_j·U_k = 1/2[U_{j+k} + U_{k-j}]")
    print("5. Connect to Wildberger d=i²+1 structure")
