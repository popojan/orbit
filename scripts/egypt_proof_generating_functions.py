#!/usr/bin/env python3
"""
Egypt-Chebyshev proof via generating function composition

Strategy:
1. Find G_T(x,t) = Σ T_n(x+1) t^n (known)
2. Find G_U(x,t) = Σ U_n(x+1) t^n (known)
3. Derive G_ΔU(x,t) = G_U - t·G_U (from ΔU_n = U_n - U_{n-1})
4. Compute G_P(x,t) = G_T · G_ΔU (Cauchy product)
5. Extract coefficient [t^i][x^k] and prove it equals 2^(k-1)·C(2i+k, 2k)
"""

import sympy as sp
from sympy import symbols, expand, series, simplify, apart, factor
from math import comb

x, t, s = symbols('x t s')

def chebyshev_T_generating_function_shifted():
    """
    Derive generating function for T_n(x+1)

    Standard: Σ T_n(y) t^n = (1 - yt) / (1 - 2yt + t²)

    Shifted (y = x+1):
    Σ T_n(x+1) t^n = (1 - (x+1)t) / (1 - 2(x+1)t + t²)
    """
    numerator = 1 - (x+1)*t
    denominator = 1 - 2*(x+1)*t + t**2

    # Simplify
    num_expanded = expand(numerator)
    den_expanded = expand(denominator)

    print("="*80)
    print("CHEBYSHEV T GENERATING FUNCTION (SHIFTED)")
    print("="*80)

    print(f"\nG_T(x,t) = Σ T_n(x+1) t^n")
    print(f"\nNumerator: {num_expanded}")
    print(f"Denominator: {den_expanded}")
    print(f"\nG_T(x,t) = {num_expanded} / {den_expanded}")

    # Partial fraction decomposition (optional)
    G_T = num_expanded / den_expanded

    return G_T

def chebyshev_U_generating_function_shifted():
    """
    Derive generating function for U_n(x+1)

    Standard: Σ U_n(y) t^n = 1 / (1 - 2yt + t²)

    Shifted (y = x+1):
    Σ U_n(x+1) t^n = 1 / (1 - 2(x+1)t + t²)
    """
    denominator = 1 - 2*(x+1)*t + t**2

    den_expanded = expand(denominator)

    print("\n" + "="*80)
    print("CHEBYSHEV U GENERATING FUNCTION (SHIFTED)")
    print("="*80)

    print(f"\nG_U(x,t) = Σ U_n(x+1) t^n")
    print(f"\nDenominator: {den_expanded}")
    print(f"\nG_U(x,t) = 1 / {den_expanded}")

    G_U = 1 / den_expanded

    return G_U

def delta_U_generating_function():
    """
    Derive generating function for ΔU_n(x+1) = U_n(x+1) - U_{n-1}(x+1)

    If G_U(x,t) = Σ U_n(x+1) t^n, then:
    Σ U_{n-1}(x+1) t^n = t · Σ U_{n-1}(x+1) t^{n-1} = t · G_U(x,t)

    Therefore:
    G_ΔU(x,t) = G_U(x,t) - t·G_U(x,t) = (1-t) · G_U(x,t)
    """
    G_U = chebyshev_U_generating_function_shifted()

    print("\n" + "="*80)
    print("DELTA U GENERATING FUNCTION")
    print("="*80)

    print("\nΔU_n(x+1) = U_n(x+1) - U_{n-1}(x+1)")
    print("\nG_ΔU(x,t) = Σ ΔU_n(x+1) t^n")
    print(f"          = G_U(x,t) - t·G_U(x,t)")
    print(f"          = (1-t) · G_U(x,t)")

    G_delta_U = (1 - t) * G_U

    G_delta_U_simplified = simplify(G_delta_U)

    print(f"\nG_ΔU(x,t) = {G_delta_U_simplified}")

    return G_delta_U_simplified

def product_generating_function():
    """
    Derive generating function for P_i(x) = T_i(x+1) · ΔU_i(x+1)

    This is the Cauchy product of G_T and G_ΔU:

    If G_T = Σ a_n t^n and G_ΔU = Σ b_n t^n, then:
    G_P = Σ (Σ_{k=0}^n a_k b_{n-k}) t^n

    But we want coefficient of specific power of x in each term, which is more complex.

    Alternatively: G_P(x,t) where coefficient [t^i] gives polynomial P_i(x)
    """
    G_T = chebyshev_T_generating_function_shifted()
    G_delta_U = delta_U_generating_function()

    print("\n" + "="*80)
    print("PRODUCT GENERATING FUNCTION")
    print("="*80)

    print(f"\nWe want: G_P(x,t) where [t^i] G_P = P_i(x) = T_i(x+1) · ΔU_i(x+1)")
    print(f"\nNaive approach: G_P = G_T · G_ΔU")
    print(f"\nBut this gives Cauchy product in t, NOT the product of polynomials!")

    print(f"\n{'-'*80}")
    print(f"CORRECT APPROACH")
    print(f"{'-'*80}")

    print(f"\nG_T(x,t) = Σ T_i(x+1) t^i gives coefficient [t^i] = T_i(x+1) as polynomial in x")
    print(f"G_ΔU(x,t) = Σ ΔU_i(x+1) t^i gives coefficient [t^i] = ΔU_i(x+1) as polynomial in x")

    print(f"\nFor product P_i(x) = T_i(x+1) · ΔU_i(x+1), we need:")
    print(f"  [t^i] of (Cauchy product G_T ⊗ G_ΔU)")

    print(f"\nCauchy product: G_T ⊗ G_ΔU = Σ_i (Σ_{{j=0}}^i T_j(x+1) · ΔU_{{i-j}}(x+1)) t^i")

    print(f"\nBut we want DIAGONAL: T_i(x+1) · ΔU_i(x+1), not cross terms!")

    print(f"\n{'-'*80}")
    print(f"REALIZATION: This approach doesn't work directly")
    print(f"{'-'*80}")

    print(f"\nThe generating function G_P(x,t) where [t^i] = P_i(x) is NOT simply G_T · G_ΔU")
    print("because that gives cross-terms T_j · ΔU_{i-j}, not T_i · ΔU_i")

    print(f"\nWe need a DIFFERENT approach:")
    print(f"  Extract [t^i] from G_T and G_ΔU separately")
    print(f"  Multiply them as polynomials in x")
    print(f"  Analyze coefficient structure")

def explicit_coefficient_extraction():
    """
    Extract coefficients directly from generating functions

    For G_T(x,t) and G_ΔU(x,t), expand as power series in t,
    then for each [t^i], expand as power series in x
    """
    print("\n" + "="*80)
    print("EXPLICIT COEFFICIENT EXTRACTION")
    print("="*80)

    G_T = chebyshev_T_generating_function_shifted()
    G_delta_U = delta_U_generating_function()

    print(f"\nApproach: Expand generating functions as series in t, then in x")

    # Expand G_T as series in t
    print(f"\n{'-'*80}")
    print(f"Expanding G_T(x,t) as series in t")
    print(f"{'-'*80}")

    G_T_series = series(G_T, t, 0, 7)

    print(f"\nG_T(x,t) = {G_T_series}")

    # For each coefficient [t^i], this is T_i(x+1)
    print(f"\nExtracting coefficients:")

    for i in range(1, 5):
        coeff_t_i = G_T_series.coeff(t, i)
        coeff_expanded = expand(coeff_t_i)

        print(f"\n[t^{i}] G_T = T_{i}(x+1) = {coeff_expanded}")

        # Now expand this as series in x to get individual coefficients
        if i <= 3:
            print(f"  Coefficients of x:")
            poly = sp.Poly(coeff_expanded, x)
            coeffs = poly.all_coeffs()[::-1]

            for k in range(len(coeffs)):
                c_k = coeffs[k]
                if c_k != 0:
                    print(f"    [x^{k}]: {c_k}")

    # Same for G_ΔU
    print(f"\n{'-'*80}")
    print(f"Expanding G_ΔU(x,t) as series in t")
    print(f"{'-'*80}")

    G_delta_U_series = series(G_delta_U, t, 0, 7)

    print(f"\nG_ΔU(x,t) = {G_delta_U_series}")

    for i in range(1, 5):
        coeff_t_i = G_delta_U_series.coeff(t, i)
        coeff_expanded = expand(coeff_t_i)

        print(f"\n[t^{i}] G_ΔU = ΔU_{i}(x+1) = {coeff_expanded}")

def double_generating_function_approach():
    """
    Use double generating function: G(x, s, t) where:
    - [s^k] gives coefficient of x^k
    - [t^i] gives index i

    This might allow extraction of [t^i][s^k] = [x^k] P_i(x)
    """
    print("\n" + "="*80)
    print("DOUBLE GENERATING FUNCTION (ADVANCED)")
    print("="*80)

    print(f"\nIdea: Encode both x and index i in generating function")
    print(f"\nG(s, t) = Σ_i Σ_k [x^k] P_i(x) · s^k · t^i")
    print(f"\nThen [s^k][t^i] G = coefficient of x^k in P_i(x)")

    print(f"\n{'-'*80}")
    print(f"Challenge: Deriving G(s,t) from G_T and G_ΔU")
    print(f"{'-'*80}")

    print(f"\nThis requires advanced manipulation of generating functions")
    print(f"and may not lead to simpler proof than direct computation.")

    print(f"\n{'-'*80}")
    print(f"VERDICT: Might work but very technical")
    print(f"{'-'*80}")

def verify_known_result():
    """
    Verify that we can extract correct coefficients from generating functions
    """
    print("\n" + "="*80)
    print("VERIFICATION: Extract P_2(x) coefficients")
    print("="*80)

    # We know P_2(x) = 8x⁴ + 28x³ + 30x² + 10x + 1
    # with formula [x^k] = 2^(k-1) · C(4+k, 2k)

    print(f"\nKnown: P_2(x) = 8x⁴ + 28x³ + 30x² + 10x + 1")
    print(f"\nFormula: [x^k] P_2(x) = 2^(k-1) · C(4+k, 2k) for k ≥ 1")

    print(f"\n{'k':<4} {'Actual':<10} {'Formula':<10} {'Match':<6}")
    print("-"*40)

    actual_coeffs = [1, 10, 30, 28, 8]

    for k in range(len(actual_coeffs)):
        actual = actual_coeffs[k]
        formula = 2**(k-1) * comb(4+k, 2*k) if k > 0 else 1

        match = "✓" if actual == formula else "✗"

        print(f"{k:<4} {actual:<10} {formula:<10} {match:<6}")

    print(f"\n{'-'*80}")
    print(f"OBSERVATION")
    print(f"{'-'*80}")

    print(f"\nFor i=2, the binomial is C(4+k, 2k) = C(2i+k, 2k)")
    print(f"\nThis suggests the formula generalizes as:")
    print(f"  [x^k] P_i(x) = 2^(k-1) · C(2i+k, 2k)")

    print(f"\nTo PROVE this, we need to show:")
    print(f"  Σ_{{m=0}}^k [x^m] T_i(x+1) · [x^{{k-m}}] ΔU_i(x+1) = 2^(k-1) · C(2i+k, 2k)")

if __name__ == "__main__":
    print("="*80)
    print("EGYPT-CHEBYSHEV PROOF: GENERATING FUNCTION APPROACH")
    print("="*80)

    # Build generating functions
    G_T = chebyshev_T_generating_function_shifted()
    G_U = chebyshev_U_generating_function_shifted()
    G_delta_U = delta_U_generating_function()

    # Attempt product generating function
    product_generating_function()

    # Extract explicit coefficients
    explicit_coefficient_extraction()

    # Advanced approach
    double_generating_function_approach()

    # Verify known results
    verify_known_result()

    print("\n" + "="*80)
    print("CONCLUSION: GENERATING FUNCTION APPROACH")
    print("="*80)

    print("\nFindings:")
    print("1. ✓ Generating functions for T_i(x+1) and ΔU_i(x+1) are known")
    print("2. ✓ Can extract individual coefficients via series expansion")
    print("3. ✗ Product G_T · G_ΔU gives Cauchy product (cross terms), not diagonal")
    print("4. ⏸️ Double generating function might work but very technical")

    print("\nConclusion:")
    print("  Generating function approach does NOT directly simplify the proof")
    print("  We still need to analyze convolution sum structure")

    print("\nNext approach:")
    print("  → Look for Chebyshev polynomial identities")
    print("  → Use explicit formulas for T_n(x) and U_n(x)")
    print("  → Connect to binomial theorem via shifted argument (x+1)")
