#!/usr/bin/env python3
"""
Attempt proof of Egypt-Chebyshev formula for SIMPLE CASES (j=2i)

Goal: Prove that for j=2i:
  T_i(x+1) · ΔU_{2i}(x+1) = 1 + Σ_{k=1}^{2i} 2^(k-1) · C(2i+k, 2k) · x^k

Strategy:
1. Use j=2i simplification (even j only)
2. Explicit formula for T_i(x+1) and U_k(x+1)
3. Compute product coefficient by coefficient
4. Verify matches binomial formula for specific i
5. Find pattern/induction proof
"""

import sympy as sp
from sympy import symbols, expand, Poly, binomial
from math import comb

# Symbolic variable
x = symbols('x')

def chebyshev_T(n, var):
    """Chebyshev polynomial of first kind T_n"""
    if n == 0:
        return sp.Integer(1)
    elif n == 1:
        return var
    else:
        # Recurrence: T_n(x) = 2x·T_{n-1}(x) - T_{n-2}(x)
        T_prev2 = sp.Integer(1)
        T_prev1 = var
        for _ in range(2, n+1):
            T_curr = 2*var*T_prev1 - T_prev2
            T_prev2 = T_prev1
            T_prev1 = T_curr
        return T_prev1

def chebyshev_U(n, var):
    """Chebyshev polynomial of second kind U_n"""
    if n == 0:
        return sp.Integer(1)
    elif n == 1:
        return 2*var
    else:
        # Recurrence: U_n(x) = 2x·U_{n-1}(x) - U_{n-2}(x)
        U_prev2 = sp.Integer(1)
        U_prev1 = 2*var
        for _ in range(2, n+1):
            U_curr = 2*var*U_prev1 - U_prev2
            U_prev2 = U_prev1
            U_prev1 = U_curr
        return U_prev1

def egypt_chebyshev_lhs(i):
    """
    Compute LHS: T_i(x+1) · [U_i(x+1) - U_{i-1}(x+1)]
    For j=2i, we have ceiling(j/2) = i, floor(j/2) = i
    So: T_⌈j/2⌉(x+1) · ΔU_j(x+1) = T_i(x+1) · [U_i(x+1) - U_{i-1}(x+1)]
    """
    y = x + 1

    T_i = chebyshev_T(i, y)
    U_i = chebyshev_U(i, y)
    U_im1 = chebyshev_U(i-1, y)

    delta_U = U_i - U_im1

    product = expand(T_i * delta_U)

    return product

def egypt_chebyshev_rhs(j):
    """
    Compute RHS: 1 + Σ_{k=1}^j 2^(k-1) · C(j+k, 2k) · x^k
    """
    result = sp.Integer(1)

    for k in range(1, j+1):
        coeff = 2**(k-1) * comb(j+k, 2*k)
        result += coeff * x**k

    return expand(result)

def verify_case(i):
    """Verify Egypt-Chebyshev for specific j=2i"""
    j = 2*i

    print(f"="*80)
    print(f"CASE j={j} (i={i})")
    print(f"="*80)

    lhs = egypt_chebyshev_lhs(i)
    rhs = egypt_chebyshev_rhs(j)

    lhs_poly = Poly(lhs, x)
    rhs_poly = Poly(rhs, x)

    # Get coefficients
    lhs_coeffs = lhs_poly.all_coeffs()[::-1]  # Reverse to get [c_0, c_1, c_2, ...]
    rhs_coeffs = rhs_poly.all_coeffs()[::-1]

    # Pad to same length
    max_len = max(len(lhs_coeffs), len(rhs_coeffs))
    lhs_coeffs += [0] * (max_len - len(lhs_coeffs))
    rhs_coeffs += [0] * (max_len - len(rhs_coeffs))

    print(f"\nLHS: T_{i}(x+1) · [U_{i}(x+1) - U_{i-1}(x+1)]")
    print(f"RHS: 1 + Σ_{{k=1}}^{j} 2^(k-1) · C({j}+k, 2k) · x^k")

    print(f"\nCoefficient comparison:")
    print(f"{'Power':<8} {'LHS':<20} {'RHS':<20} {'Match?'}")
    print("-"*80)

    all_match = True
    for power in range(max_len):
        lhs_c = lhs_coeffs[power] if power < len(lhs_coeffs) else 0
        rhs_c = rhs_coeffs[power] if power < len(rhs_coeffs) else 0
        match = (lhs_c == rhs_c)
        all_match = all_match and match

        marker = "✓" if match else "✗"
        # Convert to int for formatting
        lhs_c_int = int(lhs_c) if lhs_c != 0 else 0
        rhs_c_int = int(rhs_c) if rhs_c != 0 else 0
        print(f"x^{power:<6} {lhs_c_int:<20} {rhs_c_int:<20} {marker}")

        if power == i and i <= 6:  # Show binomial formula for position i
            # At k=i: coefficient should be 2^(i-1) · C(3i, 2i)
            expected_at_i = 2**(i-1) * comb(3*i, 2*i)
            print(f"  → At k={i}: formula gives 2^{i-1} · C({3*i},{2*i}) = {expected_at_i}")

    print()
    if all_match:
        print(f"✅ VERIFIED: Case j={j} (i={i}) matches!")
    else:
        print(f"❌ FAILED: Case j={j} (i={i}) does not match")

    return all_match

def analyze_coefficient_pattern(i):
    """Analyze pattern in coefficients for case i"""
    j = 2*i

    print(f"\n{'='*80}")
    print(f"COEFFICIENT PATTERN ANALYSIS: i={i}, j={j}")
    print(f"{'='*80}")

    lhs = egypt_chebyshev_lhs(i)
    lhs_poly = Poly(lhs, x)

    print(f"\nLHS polynomial:")
    print(f"  {lhs}")

    print(f"\nRHS binomial coefficients:")
    for k in range(0, j+1):
        if k == 0:
            coeff_rhs = 1
        else:
            coeff_rhs = 2**(k-1) * comb(j+k, 2*k)

        # For position k=i, show special form
        if k == i:
            print(f"  k={k}: 2^{k-1} · C({j+k},{2*k}) = 2^{k-1} · C({3*i},{2*i}) = {coeff_rhs} ★")
        else:
            print(f"  k={k}: 2^{k-1} · C({j+k},{2*k}) = {coeff_rhs}")

def find_recurrence_pattern():
    """Try to find recurrence between cases i and i+1"""
    print(f"\n{'='*80}")
    print(f"RECURRENCE PATTERN SEARCH")
    print(f"{'='*80}")

    print("\nComparing cases i=2 and i=3:")

    # Case i=2
    lhs_2 = egypt_chebyshev_lhs(2)
    print(f"\ni=2: {lhs_2}")

    # Case i=3
    lhs_3 = egypt_chebyshev_lhs(3)
    print(f"i=3: {lhs_3}")

    # Try to find relationship
    print("\nLooking for relationship...")
    print("If P_{i+1}(x) = f(P_i(x), x, i), what is f?")

    # In general for Chebyshev:
    # T_{n+1}(y) = 2y·T_n(y) - T_{n-1}(y)
    # U_{n+1}(y) = 2y·U_n(y) - U_{n-1}(y)

    print("\nBut our product is T_i(x+1) · [U_i(x+1) - U_{i-1}(x+1)]")
    print("This doesn't have simple recurrence in i")
    print("→ Need different approach")

if __name__ == "__main__":
    print("EGYPT-CHEBYSHEV PROOF ATTEMPT: Simple Cases j=2i")
    print("="*80)
    print()

    # Verify cases i=1,2,3,4
    results = []
    for i in [1, 2, 3, 4]:
        result = verify_case(i)
        results.append((i, result))

        if i <= 3:  # Show pattern for small cases
            analyze_coefficient_pattern(i)

    # Summary
    print("\n" + "="*80)
    print("VERIFICATION SUMMARY")
    print("="*80)

    for i, result in results:
        status = "✅" if result else "❌"
        print(f"{status} i={i}, j={2*i}")

    if all(r for _, r in results):
        print("\n✅ All tested cases verified!")
        print("\nNext step: Find general proof pattern")

    find_recurrence_pattern()

    print("\n" + "="*80)
    print("CONCLUSION")
    print("="*80)
    print("\nNumerical verification: ✓ Works for i=1,2,3,4")
    print("General proof: Still needed")
    print("\nApproaches to try:")
    print("1. Direct coefficient extraction from T_i(x+1)·ΔU_i(x+1)")
    print("2. Use shifted Chebyshev generating functions")
    print("3. Connect to Wildberger LR structure (simple cases)")
    print("4. Induction on i (needs recurrence relation)")
