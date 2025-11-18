#!/usr/bin/env python3
"""
Center Convergent Analysis (CORRECT VERSION)

Pattern: Sign of center convergent norm predicts x₀ mod p

Center convergent = convergent at index floor(τ/2)
where τ is the ACTUAL (small) CF period length
"""

import sys
sys.path.append('/home/user/orbit/scripts')
from pell_solver_integer import continued_fraction_period, pell_fundamental_solution

def analyze_center_convergent(p):
    """
    Analyze center convergent for prime p

    Returns: {
        'p': prime,
        'tau': CF period length,
        'center_index': floor(tau/2),
        'x_center': center convergent numerator,
        'y_center': center convergent denominator,
        'norm': x_c² - p·y_c²,
        'norm_sign': +1 or -1,
        'x0': fundamental solution x₀,
        'y0': fundamental solution y₀,
        'x0_mod_p': x₀ mod p,
        'prediction': predicted x₀ mod p from norm sign
    }
    """
    # Get CF period
    a0, period = continued_fraction_period(p)
    tau = len(period)
    center_idx = tau // 2

    # Compute convergents up to center
    # p[k], q[k] are k-th convergent numerator/denominator
    # p_{-1} = 1, p_0 = a_0
    # q_{-1} = 0, q_0 = 1
    # p_k = a_k * p_{k-1} + p_{k-2}
    # q_k = a_k * q_{k-1} + q_{k-2}

    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1

    # Convergent 0 is (a_0, 1)
    # Need to compute up to convergent center_idx
    # which corresponds to partial quotient a_{center_idx}

    convergents = [(a0, 1)]  # 0-th convergent

    for i in range(tau):
        a_i = period[i]
        p_next = a_i * p_curr + p_prev
        q_next = a_i * q_curr + q_prev

        convergents.append((p_next, q_next))

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

    # Center convergent
    x_c, y_c = convergents[center_idx]
    norm = x_c * x_c - p * y_c * y_c
    norm_sign = 1 if norm > 0 else -1

    # Get fundamental solution
    x0, y0 = pell_fundamental_solution(p)
    x0_mod_p = x0 % p

    # Prediction from center norm sign
    # Pattern from pell-center-convergent-BREAKTHROUGH.md:
    # norm > 0 → x₀ ≡ -1 (mod p)
    # norm < 0 → x₀ ≡ +1 (mod p)
    if norm > 0:
        predicted_x0_mod_p = p - 1  # ≡ -1 (mod p)
    else:
        predicted_x0_mod_p = 1

    return {
        'p': p,
        'tau': tau,
        'center_index': center_idx,
        'x_center': x_c,
        'y_center': y_c,
        'norm': norm,
        'norm_sign': norm_sign,
        'x0': x0,
        'y0': y0,
        'x0_mod_p': x0_mod_p,
        'predicted_x0_mod_p': predicted_x0_mod_p,
        'prediction_correct': (x0_mod_p == predicted_x0_mod_p)
    }

def print_analysis(result):
    """Pretty print analysis result"""
    r = result
    print(f"{'='*60}")
    print(f"Prime p = {r['p']}")
    print(f"{'='*60}")
    print(f"CF period τ = {r['tau']}")
    print(f"Center index = floor(τ/2) = {r['center_index']}")
    print()
    print(f"Center convergent:")
    print(f"  x_c = {r['x_center']}")
    print(f"  y_c = {r['y_center']}")
    print(f"  Norm = x_c² - p·y_c² = {r['norm']}")
    print(f"  Norm sign = {'+' if r['norm_sign'] > 0 else '-'}")
    print()
    print(f"Fundamental solution:")
    print(f"  x₀ = {r['x0']}")
    print(f"  y₀ = {r['y0']}")
    print(f"  x₀ mod p = {r['x0_mod_p']}")
    print()
    print(f"Prediction:")
    print(f"  From norm sign: x₀ ≡ {r['predicted_x0_mod_p']} (mod {r['p']})")
    print(f"  Actual: x₀ ≡ {r['x0_mod_p']} (mod {r['p']})")
    print(f"  ✓ CORRECT!" if r['prediction_correct'] else "  ✗ MISMATCH!")
    print()

if __name__ == '__main__':
    # Test cases
    test_primes = [89, 113, 523, 1327, 31397]

    print("CENTER CONVERGENT ANALYSIS (CORRECT VERSION)")
    print("=" * 60)
    print()

    for p in test_primes:
        result = analyze_center_convergent(p)
        print_analysis(result)

    # Summary statistics
    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)

    results = [analyze_center_convergent(p) for p in test_primes]
    correct_count = sum(1 for r in results if r['prediction_correct'])

    print(f"Tested {len(results)} primes")
    print(f"Correct predictions: {correct_count}/{len(results)}")
    print(f"Accuracy: {100.0 * correct_count / len(results):.1f}%")
