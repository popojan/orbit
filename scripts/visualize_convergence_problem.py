#!/usr/bin/env python3
"""
Visualize: How does convergence F_n → M(n)/ε^α depend on n?

Key question: Does larger n need smaller ε to converge?
"""

import numpy as np

def M(n):
    """M(n) = #{d: d|n, 2 ≤ d ≤ √n}"""
    if n < 2:
        return 0
    divisors = [d for d in range(2, int(np.sqrt(n)) + 1) if n % d == 0]
    return len(divisors)

def F_n_dominant(n, alpha, epsilon):
    """Dominant term approximation"""
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

print("="*80)
print("CONVERGENCE ANALYSIS: Does larger n need smaller ε?")
print("="*80)

alpha = 3.0
test_n = [4, 12, 35, 100, 200, 500, 1000]
epsilon_values = [1.0, 0.1, 0.01, 0.001]

print(f"\nα = {alpha}\n")
print(f"{'n':>6} {'M(n)':>6} | {'ε=1.0':>12} {'ε=0.1':>12} {'ε=0.01':>12} {'ε=0.001':>12}")
print("-" * 80)

for n in test_n:
    M_n = M(n)
    errors = []

    for eps in epsilon_values:
        F_val = F_n_dominant(n, alpha, eps)
        scaled_F = (eps**alpha) * F_val
        error_pct = 100 * abs(scaled_F - M_n) / max(M_n, 1)
        errors.append(error_pct)

    print(f"{n:6d} {M_n:6d} | ", end='')
    for err in errors:
        if err < 0.5:
            print(f"{err:10.2f}% ✓", end=' ')
        elif err < 5:
            print(f"{err:10.2f}% ~", end=' ')
        else:
            print(f"{err:10.2f}% ✗", end=' ')
    print()

print("\n" + "="*80)
print("INTERPRETATION:")
print("="*80)
print("""
✓ = converged (< 0.5% error)
~ = close     (< 5% error)
✗ = not converged (> 5% error)

KEY OBSERVATION:
If larger n requires smaller ε to converge, then:

  For FIXED ε, increasing n_max adds terms that HAVEN'T converged yet!

  This explains why ε^α · G(s,α,ε) doesn't converge to L_M(s).

SOLUTION:
  - Either use ADAPTIVE ε (smaller for larger n)
  - Or use FULL double sum (not dominant approximation)
  - Or accept that G(s,α,ε) ≠ L_M(s) * ε^{-α} exactly
""")
