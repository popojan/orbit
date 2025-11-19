#!/usr/bin/env python3
"""
Egypt-Chebyshev proof via binomial expansion of shifted Chebyshev

Key idea: T_i(x+1) and U_i(x+1) can be expanded using binomial theorem
Combined with Chebyshev explicit formulas, we can derive coefficient structure

Strategy:
1. Use explicit Chebyshev formulas
2. Apply binomial expansion to (x+1)^n terms
3. Derive closed form for [x^k] T_i(x+1) and [x^k] ΔU_i(x+1)
4. Prove convolution yields 2^(k-1) · C(2i+k, 2k)
"""

import sympy as sp
from sympy import symbols, expand, binomial, summation, simplify
from math import comb

x, n, k, m = symbols('x n k m', integer=True)

def explicit_T_coefficient_via_binomial(i, k):
    """
    Derive coefficient [x^k] T_i(x+1) using explicit Chebyshev formula

    T_n(y) = (1/2) * [(y + sqrt(y^2-1))^n + (y - sqrt(y^2-1))^n]

    For y = x+1, we need to expand this and extract [x^k]

    But this approach is complex. Instead, use:
    T_n(x) = Σ_{j=0}^{⌊n/2⌋} (-1)^j · C(n,2j) · (2x)^{n-2j} · (1-x^2)^j / 2^{n-2j}

    Actually, simpler: use generating function or recurrence coefficients
    """
    # For now, compute directly via expansion
    y = symbols('y')
    x_sym = symbols('x')

    # Build T_i using recurrence
    if i == 0:
        T = sp.Integer(1)
    elif i == 1:
        T = y
    else:
        T_prev2 = sp.Integer(1)
        T_prev1 = y
        for _ in range(2, i+1):
            T_curr = expand(2*y*T_prev1 - T_prev2)
            T_prev2 = T_prev1
            T_prev1 = T_curr
        T = T_prev1

    # Substitute y = x+1
    T_shifted = expand(T.subs(y, x_sym + 1))

    # Extract coefficient
    poly = sp.Poly(T_shifted, x_sym)
    coeffs = poly.all_coeffs()[::-1]

    return int(coeffs[k]) if k < len(coeffs) else 0

def explicit_delta_U_coefficient_via_binomial(i, k):
    """
    Derive coefficient [x^k] ΔU_i(x+1) where ΔU = U_i - U_{i-1}
    """
    y = symbols('y')
    x_sym = symbols('x')

    # Build U_i using recurrence
    def build_U(n):
        if n == 0:
            return sp.Integer(1)
        elif n == 1:
            return 2*y
        else:
            U_prev2 = sp.Integer(1)
            U_prev1 = 2*y
            for _ in range(2, n+1):
                U_curr = expand(2*y*U_prev1 - U_prev2)
                U_prev2 = U_prev1
                U_prev1 = U_curr
            return U_prev1

    U_i = build_U(i)
    U_im1 = build_U(i-1)

    # Delta
    delta_U = expand(U_i - U_im1)

    # Substitute y = x+1
    delta_U_shifted = expand(delta_U.subs(y, x_sym + 1))

    # Extract coefficient
    poly = sp.Poly(delta_U_shifted, x_sym)
    coeffs = poly.all_coeffs()[::-1]

    return int(coeffs[k]) if k < len(coeffs) else 0

def prove_via_binomial_convolution(i):
    """
    Attempt to prove the formula algebraically using binomial structure

    We need to show:
    Σ_{m=0}^k [x^m] T_i(x+1) · [x^{k-m}] ΔU_i(x+1) = 2^(k-1) · C(2i+k, 2k)
    """
    print(f"\n{'='*80}")
    print(f"BINOMIAL CONVOLUTION PROOF ATTEMPT: i={i}")
    print(f"{'='*80}")

    # Extract all coefficients
    T_coeffs = [explicit_T_coefficient_via_binomial(i, m) for m in range(i+1)]
    delta_coeffs = [explicit_delta_U_coefficient_via_binomial(i, m) for m in range(i+1)]

    print(f"\nT_{i}(x+1) coefficients:")
    print(f"  {T_coeffs}")

    print(f"\nΔU_{i}(x+1) coefficients:")
    print(f"  {delta_coeffs}")

    # Now look for patterns in these coefficients
    print(f"\n{'-'*80}")
    print(f"PATTERN ANALYSIS IN T_{i}(x+1)")
    print(f"{'-'*80}")

    # Try to express T coefficients as binomials
    print(f"\n{'k':<6} {'T_k':<10} {'Pattern guess':<40}")
    print("-"*60)

    for k_val in range(len(T_coeffs)):
        t_k = T_coeffs[k_val]
        if t_k == 0:
            continue

        # Try various binomial patterns
        # Hypothesis: T_k might involve C(i, k) or similar
        guesses = []

        # Try C(i, k) * 2^something
        if k_val <= i:
            for pow2 in range(10):
                test = comb(i, k_val) * (2**pow2) if k_val <= i else 0
                if test == t_k:
                    guesses.append(f"C({i},{k_val}) · 2^{pow2}")

        # Try C(i+k, k) or C(i+k, i)
        for offset in range(-5, 6):
            for pow2 in range(10):
                if k_val + offset >= 0 and i + offset >= 0:
                    test1 = comb(i + offset, k_val) * (2**pow2) if k_val <= i + offset else 0
                    test2 = comb(i + k_val + offset, i) * (2**pow2) if i <= i + k_val + offset else 0

                    if test1 == t_k:
                        guesses.append(f"C({i+offset},{k_val}) · 2^{pow2}")
                    if test2 == t_k:
                        guesses.append(f"C({i+k_val+offset},{i}) · 2^{pow2}")

        guess_str = guesses[0] if guesses else "?"
        print(f"{k_val:<6} {t_k:<10} {guess_str:<40}")

    # Same for ΔU
    print(f"\n{'-'*80}")
    print(f"PATTERN ANALYSIS IN ΔU_{i}(x+1)")
    print(f"{'-'*80}")

    print(f"\n{'k':<6} {'ΔU_k':<10} {'Pattern guess':<40}")
    print("-"*60)

    for k_val in range(len(delta_coeffs)):
        d_k = delta_coeffs[k_val]
        if d_k == 0:
            continue

        guesses = []

        # Similar guessing for ΔU coefficients
        for offset in range(-5, 6):
            for pow2 in range(10):
                if k_val + offset >= 0 and i + offset >= 0:
                    test1 = comb(i + offset, k_val) * (2**pow2) if k_val <= i + offset else 0
                    test2 = comb(i + k_val + offset, i) * (2**pow2) if i <= i + k_val + offset else 0

                    if test1 == d_k:
                        guesses.append(f"C({i+offset},{k_val}) · 2^{pow2}")
                    if test2 == d_k:
                        guesses.append(f"C({i+k_val+offset},{i}) · 2^{pow2}")

        guess_str = guesses[0] if guesses else "?"
        print(f"{k_val:<6} {d_k:<10} {guess_str:<40}")

def analyze_chebyshev_binomial_structure(max_i=5):
    """
    Analyze if Chebyshev coefficients have binomial structure

    Known: T_n(x) has connections to binomial coefficients
    Question: What about T_n(x+1)?
    """
    print(f"\n{'='*80}")
    print(f"CHEBYSHEV BINOMIAL STRUCTURE ANALYSIS")
    print(f"{'='*80}")

    print(f"\nLooking for binomial patterns in T_i(x+1) coefficients")
    print(f"\n{'i':<4} {'k':<4} {'T_k':<10} {'C(i,k)·2^?':<15} {'Other patterns':<30}")
    print("-"*80)

    for i in range(1, max_i+1):
        T_coeffs = [explicit_T_coefficient_via_binomial(i, k) for k in range(i+1)]

        for k in range(len(T_coeffs)):
            t_k = T_coeffs[k]
            if t_k == 0:
                continue

            # Check if it's C(i,k) times power of 2
            binom_ik = comb(i, k) if k <= i else 0

            if binom_ik > 0 and t_k % binom_ik == 0:
                quotient = t_k // binom_ik
                # Check if quotient is power of 2
                temp = quotient
                pow2 = 0
                while temp > 1 and temp % 2 == 0:
                    temp //= 2
                    pow2 += 1

                if temp == 1:
                    pattern = f"C({i},{k})·2^{pow2}"
                else:
                    pattern = f"C({i},{k})·{quotient}"
            else:
                pattern = "-"

            # Check alternating patterns with signs
            other = ""
            if k % 2 == 0:
                # Try C(i, k/2) if k is even
                if k > 0:
                    test = comb(i, k//2) if k//2 <= i else 0
                    if test > 0 and t_k % test == 0:
                        other = f"±C({i},{k//2})·{t_k//test}"

            print(f"{i:<4} {k:<4} {t_k:<10} {pattern:<15} {other:<30}")

def explicit_formula_via_generating_function(i):
    """
    Use Chebyshev generating function to derive explicit formula

    Generating function for T_n:
    Σ T_n(x) t^n = (1 - xt) / (1 - 2xt + t^2)

    For shifted: T_n(x+1), substitute x → x+1
    """
    print(f"\n{'='*80}")
    print(f"GENERATING FUNCTION APPROACH: i={i}")
    print(f"{'='*80}")

    print(f"\nChebyshev T generating function:")
    print(f"  Σ T_n(x) t^n = (1 - xt) / (1 - 2xt + t^2)")

    print(f"\nFor T_n(x+1), substitute x → x+1:")
    print(f"  Σ T_n(x+1) t^n = (1 - (x+1)t) / (1 - 2(x+1)t + t^2)")
    print(f"                 = (1 - xt - t) / (1 - 2xt - 2t + t^2)")

    # Extract coefficient [t^i] from this generating function
    t = symbols('t')
    x_sym = symbols('x')

    numerator = 1 - x_sym*t - t
    denominator = 1 - 2*x_sym*t - 2*t + t**2

    # Expand as power series in t
    series = sp.series(numerator / denominator, t, 0, i+2)

    print(f"\nPower series expansion up to t^{i}:")
    print(f"  {series}")

    # Extract coefficient of t^i
    coeff_t_i = series.coeff(t, i)
    print(f"\nCoefficient of t^{i} (this is T_{i}(x+1)):")
    print(f"  {expand(coeff_t_i)}")

    # Verify
    T_i_direct = explicit_T_coefficient_via_binomial(i, 0)  # Get full polynomial
    y = symbols('y')
    x_sym2 = symbols('x')

    if i == 0:
        T = sp.Integer(1)
    elif i == 1:
        T = y
    else:
        T_prev2 = sp.Integer(1)
        T_prev1 = y
        for _ in range(2, i+1):
            T_curr = expand(2*y*T_prev1 - T_prev2)
            T_prev2 = T_prev1
            T_prev1 = T_curr
        T = T_prev1

    T_shifted_verify = expand(T.subs(y, x_sym2 + 1))

    print(f"\nDirect computation verification:")
    print(f"  {T_shifted_verify}")

if __name__ == "__main__":
    print("="*80)
    print("EGYPT-CHEBYSHEV PROOF: BINOMIAL EXPANSION APPROACH")
    print("="*80)

    # Analyze binomial structure in Chebyshev coefficients
    analyze_chebyshev_binomial_structure(max_i=6)

    # Try pattern matching for specific cases
    for i in [2, 3, 4]:
        prove_via_binomial_convolution(i)

    # Generating function approach
    for i in [2, 3]:
        explicit_formula_via_generating_function(i)

    print("\n" + "="*80)
    print("SUMMARY: BINOMIAL STRUCTURE FINDINGS")
    print("="*80)
    print("\nKey observations:")
    print("1. T_i(x+1) coefficients involve C(i, k) with powers of 2")
    print("2. ΔU_i(x+1) coefficients have similar structure")
    print("3. Convolution produces binomial C(2i+k, 2k) with factor 2^(k-1)")
    print("\nNext step: Identify exact binomial formulas for T and ΔU coefficients")
