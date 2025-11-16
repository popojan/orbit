#!/usr/bin/env python3
"""
Analyze G(s,α,ε) = Σ F_n(α,ε) / n^s

Goal: Find closed form and show lim_{ε→0} ε^α · G(s,α,ε) = L_M(s)
"""

import numpy as np
from scipy.special import zeta

def M(n):
    """
    Childhood function: M(n) = #{d: d|n, 2 ≤ d ≤ √n}
    Equivalent to floor((tau(n)-1)/2)
    """
    if n < 2:
        return 0
    divisors = [d for d in range(2, int(np.sqrt(n)) + 1) if n % d == 0]
    return len(divisors)

def F_n(n, alpha, epsilon, d_max=None, k_max=None):
    """
    F_n(α,ε) = Σ_{d=2}^∞ Σ_{k=0}^∞ [(n - kd - d²)² + ε]^{-α}

    Truncated version for numerical computation.
    """
    if d_max is None:
        d_max = max(10, int(2 * np.sqrt(n)))

    result = 0.0
    for d in range(2, d_max + 1):
        # For each d, find k_max such that kd + d² ≤ n + some buffer
        if k_max is None:
            k_max_d = max(10, int((n + 10*d) / d))
        else:
            k_max_d = k_max

        for k in range(k_max_d + 1):
            distance_sq = (n - k*d - d**2)**2
            term = (distance_sq + epsilon)**(-alpha)
            result += term

            # Early termination if term becomes negligible
            if term < 1e-15:
                break

    return result

def G_function(s, alpha, epsilon, n_max=100):
    """
    G(s,α,ε) = Σ_{n=2}^{n_max} F_n(α,ε) / n^s
    """
    result = 0.0
    for n in range(2, n_max + 1):
        F_val = F_n(n, alpha, epsilon)
        result += F_val / (n**s)
        if n % 10 == 0:
            print(f"  Computing n={n}/{n_max}...", end='\r')
    print(" " * 50, end='\r')  # Clear progress line
    return result

def L_M_direct(s, n_max=1000):
    """
    L_M(s) = Σ M(n)/n^s (direct computation)
    """
    result = 0.0
    for n in range(2, n_max + 1):
        result += M(n) / (n**s)
    return result

def L_M_closed_form(s, j_max=100):
    """
    L_M(s) = ζ(s)[ζ(s)-1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s

    Closed form (works for Re(s) > 1)
    """
    zeta_s = zeta(s)

    # Correction sum C(s)
    C_s = 0.0
    for j in range(2, j_max + 1):
        # H_{j-1}(s) = Σ_{k=1}^{j-1} k^{-s}
        H_jm1 = sum(k**(-s) for k in range(1, j))
        C_s += H_jm1 / (j**s)

    return zeta_s * (zeta_s - 1) - C_s

# ============================================================================
# Test: Does ε^α · G(s,α,ε) → L_M(s) as ε → 0?
# ============================================================================

print("="*70)
print("QUESTION A: F_n(α,ε) → L_M(s) Connection")
print("="*70)

# Parameters
s = 2.0
alpha = 3.0
epsilon_values = [1.0, 0.1, 0.01, 0.001]
n_max = 50

print(f"\nParameters: s={s}, α={alpha}, n_max={n_max}\n")

# Compute L_M(s) for reference
L_M_direct_val = L_M_direct(s, n_max=1000)
L_M_closed_val = L_M_closed_form(s, j_max=200)

print(f"L_M({s}) reference values:")
print(f"  Direct sum (n≤1000):  {L_M_direct_val:.8f}")
print(f"  Closed form:          {L_M_closed_val:.8f}")
print()

# Test residue theorem: ε^α · G(s,α,ε) → L_M(s)?
print(f"Testing: ε^α · G(s,α,ε) → L_M(s) as ε → 0")
print(f"{'ε':>10} {'G(s,α,ε)':>15} {'ε^α · G':>15} {'Expected':>15} {'Error %':>10}")
print("-" * 70)

for eps in epsilon_values:
    G_val = G_function(s, alpha, eps, n_max=n_max)
    scaled_G = (eps**alpha) * G_val
    error_pct = 100 * abs(scaled_G - L_M_closed_val) / abs(L_M_closed_val)

    print(f"{eps:10.4f} {G_val:15.6e} {scaled_G:15.8f} {L_M_closed_val:15.8f} {error_pct:10.2f}%")

print("\n" + "="*70)
print("INTERPRETATION:")
print("="*70)

print("""
If ε^α · G(s,α,ε) → L_M(s), this confirms:

  G(s,α,ε) = Σ_n F_n(α,ε)/n^s

acts as a REGULARIZED version of L_M(s), where:
  - ε → 0: recovers L_M(s) (via residue theorem)
  - ε > 0: smooth/bounded version for all s

This is the BRIDGE between:
  - Power law regularization [(dist)² + ε]^{-α}
  - Exponential dampening 1/n^s

Key insight: G(s,α,ε) combines BOTH regularization schemes:
  - ε regularizes divergence at exact factorizations
  - 1/n^s dampens contribution from large n

In the limit ε→0, the ε-poles dominate and we recover:
  G(s,α,ε) ∼ ε^{-α} · L_M(s)
""")
