#!/usr/bin/env python3
"""
Corrected recurrence approach for ΔU_n(x+1)

Bug in previous: Wrong derivation of ΔU recurrence

Correct approach:
From U_n = 2(x+1)U_{n-1} - U_{n-2}

ΔU_n = U_n - U_{n-1}
     = [2(x+1)U_{n-1} - U_{n-2}] - U_{n-1}
     = [2x + 1]U_{n-1} - U_{n-2}

Now express in terms of previous ΔU:
We have: U_{n-2} = U_{n-1} - ΔU_{n-1}

So: ΔU_n = [2x + 1]U_{n-1} - [U_{n-1} - ΔU_{n-1}]
         = 2x·U_{n-1} + U_{n-1} - U_{n-1} + ΔU_{n-1}
         = 2x·U_{n-1} + ΔU_{n-1}

Wait, that's what I had before... let me recalculate.
"""

import sympy as sp
from sympy import symbols, expand, Poly
from math import comb

def verify_delta_U_formula_induction():
    """
    Try to prove via induction:

    Base case: ΔU_2(x+1)
    Inductive step: If formula holds for ΔU_n, prove for ΔU_{n+2}

    Key insight: We're proving for EVEN n only!
    So induction goes: 2 → 4 → 6 → ...
    """
    print("="*80)
    print("INDUCTION PROOF ATTEMPT")
    print("="*80)

    x = symbols('x')

    # Base case: n = 2
    print("\n" + "-"*80)
    print("BASE CASE: n = 2")
    print("-"*80)

    def compute_U(n):
        if n == 0:
            return sp.Integer(1)
        elif n == 1:
            return 2*(x+1)
        else:
            U_prev2 = sp.Integer(1)
            U_prev1 = 2*(x+1)
            for i in range(2, n+1):
                U_curr = expand(2*(x+1)*U_prev1 - U_prev2)
                U_prev2 = U_prev1
                U_prev1 = U_curr
            return U_prev1

    U_2 = compute_U(2)
    U_1 = compute_U(1)
    delta_U_2 = expand(U_2 - U_1)

    print(f"ΔU_2(x+1) = {delta_U_2}")

    poly = Poly(delta_U_2, x)
    coeffs_2 = poly.all_coeffs()[::-1]

    print(f"\nCoefficients: {[int(c) for c in coeffs_2]}")
    print(f"Formula 2^k·C(2+k,2k): {[2**k * comb(2+k,2*k) for k in range(len(coeffs_2))]}")

    # Check if base case holds
    base_holds = all(int(coeffs_2[k]) == 2**k * comb(2+k, 2*k)
                     for k in range(len(coeffs_2)))
    print(f"\nBase case holds: {base_holds} ✓" if base_holds else "Base case FAILS ✗")

    # Inductive step: Assume true for n, prove for n+2
    print("\n" + "-"*80)
    print("INDUCTIVE STEP: n → n+2")
    print("-"*80)

    print("\nAssume: [x^k] ΔU_n(x+1) = 2^k · C(n+k, 2k)")
    print("Prove:  [x^k] ΔU_{n+2}(x+1) = 2^k · C(n+2+k, 2k)")

    print("\nRecurrence relations:")
    print("  U_{n+2} = 2(x+1)·U_{n+1} - U_n")
    print("  U_{n+1} = 2(x+1)·U_n - U_{n-1}")

    print("\nΔU_{n+2} = U_{n+2} - U_{n+1}")
    print("         = [2(x+1)·U_{n+1} - U_n] - U_{n+1}")
    print("         = (2x+1)·U_{n+1} - U_n")

    print("\nAlso:")
    print("  ΔU_{n+1} = U_{n+1} - U_n")
    print("  So: U_n = U_{n+1} - ΔU_{n+1}")

    print("\nTherefore:")
    print("  ΔU_{n+2} = (2x+1)·U_{n+1} - [U_{n+1} - ΔU_{n+1}]")
    print("           = 2x·U_{n+1} + ΔU_{n+1}")

    print("\n  [x^k] ΔU_{n+2}(x+1) = 2·[x^{k-1}] U_{n+1}(x+1) + [x^k] ΔU_{n+1}(x+1)")

    print("\nProblem: This relates ΔU_{n+2} to ΔU_{n+1}, not to ΔU_n")
    print("But our formula is for EVEN n only!")
    print("\nNeed different approach...")

def try_explicit_formula_approach():
    """
    Use explicit formula for U_n:

    U_n(x) = Σ_{j=0}^{⌊n/2⌋} (-1)^j · C(n-j, j) · (2x)^{n-2j}

    Then U_n(x+1) = Σ_{j=0}^{⌊n/2⌋} (-1)^j · C(n-j, j) · (2(x+1))^{n-2j}

    Expand (2(x+1))^{n-2j} = 2^{n-2j} · Σ_m C(n-2j, m) · x^m

    Extract [x^k] coefficient
    """
    print("\n" + "="*80)
    print("EXPLICIT FORMULA APPROACH")
    print("="*80)

    print("\nChebyshev U_n explicit formula:")
    print("  U_n(x) = Σ_{j=0}^{⌊n/2⌋} (-1)^j · C(n-j, j) · (2x)^{n-2j}")

    print("\nFor U_n(x+1):")
    print("  U_n(x+1) = Σ_j (-1)^j · C(n-j, j) · 2^{n-2j} · (x+1)^{n-2j}")

    print("\nExpanding (x+1)^{n-2j} with binomial theorem:")
    print("  (x+1)^{n-2j} = Σ_m C(n-2j, m) · x^m")

    print("\nSo [x^k] U_n(x+1) = Σ_j (-1)^j · C(n-j, j) · 2^{n-2j} · C(n-2j, k)")

    print("\nFor ΔU_n = U_n - U_{n-1}:")
    print("  [x^k] ΔU_n(x+1) = [x^k] U_n(x+1) - [x^k] U_{n-1}(x+1)")

    # Test this for n=2, k=1
    n, k = 2, 1
    print(f"\n{'-'*80}")
    print(f"TEST CASE: n={n}, k={k}")
    print(f"{'-'*80}")

    # U_2 term
    sum_U2 = 0
    for j in range(n//2 + 1):
        if n-2*j >= k:
            term = ((-1)**j) * comb(n-j, j) * (2**(n-2*j)) * comb(n-2*j, k)
            sum_U2 += term
            print(f"  j={j}: ({(-1)**j}) · C({n-j},{j}) · 2^{n-2*j} · C({n-2*j},{k}) = {term}")

    print(f"\nΣ for U_2: {sum_U2}")

    # U_1 term
    sum_U1 = 0
    n1 = n-1
    for j in range(n1//2 + 1):
        if n1-2*j >= k:
            term = ((-1)**j) * comb(n1-j, j) * (2**(n1-2*j)) * comb(n1-2*j, k)
            sum_U1 += term
            print(f"  j={j}: ({(-1)**j}) · C({n1-j},{j}) · 2^{n1-2*j} · C({n1-2*j},{k}) = {term}")

    print(f"\nΣ for U_1: {sum_U1}")

    delta_U_2_k1 = sum_U2 - sum_U1
    expected = 2**k * comb(n+k, 2*k)

    print(f"\n[x^{k}] ΔU_{n}(x+1) = {delta_U_2_k1}")
    print(f"Formula 2^{k}·C({n}+{k},{2*k}) = {expected}")
    print(f"Match: {delta_U_2_k1 == expected}")

if __name__ == "__main__":
    print("="*80)
    print("CORRECTED RECURRENCE APPROACH")
    print("="*80)

    # Try induction (will hit wall with even n)
    verify_delta_U_formula_induction()

    # Try explicit formula
    try_explicit_formula_approach()

    print("\n" + "="*80)
    print("STATUS")
    print("="*80)
    print("\nRecurrence approach: Stalled (even n only, recursion mismatch)")
    print("Explicit formula: Complex, needs more work")
    print("\nNext: Literature search or ask expert")
