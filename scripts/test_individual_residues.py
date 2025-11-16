#!/usr/bin/env python3
"""
Test: Does ε^α · F_n^dom(α,ε) → M(n) for individual n?

This checks if dominant term approximation preserves residue theorem.
"""

import numpy as np

def M(n):
    """M(n) = #{d: d|n, 2 ≤ d ≤ √n}"""
    if n < 2:
        return 0
    divisors = [d for d in range(2, int(np.sqrt(n)) + 1) if n % d == 0]
    return len(divisors)

def F_n_dominant(n, alpha, epsilon, tail_max=None):
    """
    Dominant term (COMPLETE):
    F_n^dom = Σ_{d≤√n} [(r_d)² + ε]^{-α} + Σ_{d>√n} [(d²-n)² + ε]^{-α}
    """
    sqrt_n = int(np.sqrt(n))
    result = 0.0

    # First sum: d ≤ √n
    for d in range(2, sqrt_n + 1):
        r_d = (n - d**2) % d
        result += (r_d**2 + epsilon)**(-alpha)

    # Tail sum: d > √n
    if tail_max is None:
        tail_max = int(sqrt_n + 20)

    for d in range(sqrt_n + 1, tail_max + 1):
        dist_sq = (d**2 - n)**2
        term = (dist_sq + epsilon)**(-alpha)
        result += term
        if term < 1e-15:
            break

    return result

# ============================================================================
# Test individual n values
# ============================================================================

print("="*80)
print("TEST: Does ε^α · F_n^dom(α,ε) → M(n) for individual n?")
print("="*80)

alpha = 3.0
epsilon_values = [1.0, 0.1, 0.01, 0.001]
test_n_values = [4, 6, 12, 35, 60]  # Mix of composites

print(f"\nParameters: α={alpha}")
print()

for n in test_n_values:
    M_n = M(n)
    print(f"\nn = {n}, M({n}) = {M_n}")
    print(f"{'ε':>10} {'F_n^dom':>15} {'ε^α · F_n^dom':>18} {'M(n)':>6} {'Error %':>10}")
    print("-" * 75)

    for eps in epsilon_values:
        F_val = F_n_dominant(n, alpha, eps)
        scaled_F = (eps**alpha) * F_val
        error_pct = 100 * abs(scaled_F - M_n) / max(M_n, 1e-10)

        print(f"{eps:10.4f} {F_val:15.6e} {scaled_F:18.8f} {M_n:6d} {error_pct:10.2f}%")

print("\n" + "="*80)
print("INTERPRETATION:")
print("="*80)

print("""
If errors are SMALL (< 5%) for individual n, then dominant term approximation
preserves the residue theorem:

  ε^α · F_n^dom(α,ε) → M(n)

If errors are LARGE, then:
  - Dominant term approximation is NOT sufficient
  - Non-dominant terms contribute to M(n) residue
  - Full double sum F_n is needed

This is the CRITICAL test to understand the G(s,α,ε) discrepancy!
""")
