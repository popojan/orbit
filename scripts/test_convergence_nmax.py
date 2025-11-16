#!/usr/bin/env python3
"""
Test convergence as n_max increases

Goal: Check if ε^α · G(s,α,ε) → L_M(s) with larger n_max
"""

import numpy as np
from scipy.special import zeta

def M(n):
    """M(n) = #{d: d|n, 2 ≤ d ≤ √n}"""
    if n < 2:
        return 0
    divisors = [d for d in range(2, int(np.sqrt(n)) + 1) if n % d == 0]
    return len(divisors)

def F_n_dominant(n, alpha, epsilon):
    """Dominant term (complete with tail)"""
    sqrt_n = int(np.sqrt(n))
    result = 0.0

    for d in range(2, sqrt_n + 1):
        r_d = (n - d**2) % d
        result += (r_d**2 + epsilon)**(-alpha)

    tail_max = int(sqrt_n + 20)
    for d in range(sqrt_n + 1, tail_max + 1):
        dist_sq = (d**2 - n)**2
        term = (dist_sq + epsilon)**(-alpha)
        result += term
        if term < 1e-15:
            break

    return result

def G_dominant(s, alpha, epsilon, n_max):
    """G(s,α,ε) = Σ_{n=2}^{n_max} F_n^dom(α,ε) / n^s"""
    result = 0.0
    for n in range(2, n_max + 1):
        F_val = F_n_dominant(n, alpha, epsilon)
        result += F_val / (n**s)
    return result

def L_M_closed_form(s, j_max=300):
    """L_M(s) = ζ(s)[ζ(s)-1] - Σ H_{j-1}(s)/j^s"""
    zeta_s = zeta(s)
    C_s = sum((sum(k**(-s) for k in range(1, j))) / (j**s) for j in range(2, j_max + 1))
    return zeta_s * (zeta_s - 1) - C_s

# ============================================================================
# Test convergence with increasing n_max
# ============================================================================

print("="*80)
print("TEST: Convergence of ε^α · G(s,α,ε) as n_max increases")
print("="*80)

s = 2.0
alpha = 3.0
eps = 0.01
n_max_values = [50, 100, 200, 500, 1000, 2000]

L_M_ref = L_M_closed_form(s, j_max=500)

print(f"\nParameters: s={s}, α={alpha}, ε={eps}")
print(f"L_M({s}) reference: {L_M_ref:.8f}\n")

print(f"{'n_max':>10} {'ε^α · G':>15} {'Error vs L_M':>18} {'Error %':>10} {'Improvement':>12}")
print("-" * 80)

prev_error_pct = None
for n_max in n_max_values:
    print(f"Computing n_max={n_max}...", end='\r')
    G_val = G_dominant(s, alpha, eps, n_max)
    scaled_G = (eps**alpha) * G_val

    error = scaled_G - L_M_ref
    error_pct = 100 * abs(error) / abs(L_M_ref)

    improvement = ""
    if prev_error_pct is not None:
        ratio = prev_error_pct / error_pct
        improvement = f"{ratio:.2f}×"
    prev_error_pct = error_pct

    print(f"{n_max:10d} {scaled_G:15.8f} {error:18.8f} {error_pct:10.2f}% {improvement:>12}")

print("\n" + "="*80)
print("CONCLUSION:")
print("="*80)

print(f"""
If error decreases systematically with n_max, then:
  - Truncation is the main issue
  - ε^α · G(s,α,ε) → L_M(s) as n_max → ∞
  - Residue theorem WORKS for G(s,α,ε)!

If error plateaus, then:
  - Systematic error from approximation
  - May need full F_n (not dominant term)
  - OR correction term needed

Expected L_M({s}): {L_M_ref:.8f}
Current at n_max={n_max_values[-1]}: will see above
""")
