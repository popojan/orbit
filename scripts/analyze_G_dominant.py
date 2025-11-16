#!/usr/bin/env python3
"""
Analyze G(s,α,ε) using DOMINANT TERM approximation

F_n^dom(α,ε) ≈ Σ_{d=2}^{√n} [(r_d)² + ε]^{-α}
where r_d = (n - d²) mod d

This is O(√n) instead of O(n) for full double sum!
"""

import numpy as np
from scipy.special import zeta

def M(n):
    """M(n) = #{d: d|n, 2 ≤ d ≤ √n}"""
    if n < 2:
        return 0
    divisors = [d for d in range(2, int(np.sqrt(n)) + 1) if n % d == 0]
    return len(divisors)

def F_n_dominant(n, alpha, epsilon, tail_max=None):
    """
    Dominant term approximation (COMPLETE with tail):
    F_n^dom(α,ε) = Σ_{d=2}^{√n} [(r_d)² + ε]^{-α}
                 + Σ_{d>√n}^{tail_max} [(d²-n)² + ε]^{-α}

    where r_d = (n - d²) mod d
    """
    sqrt_n = int(np.sqrt(n))
    result = 0.0

    # First sum: d ≤ √n (modulo structure)
    for d in range(2, sqrt_n + 1):
        r_d = (n - d**2) % d
        result += (r_d**2 + epsilon)**(-alpha)

    # Second sum: d > √n (tail, squared distance to d²)
    if tail_max is None:
        tail_max = int(sqrt_n + 20)  # Reasonable cutoff

    for d in range(sqrt_n + 1, tail_max + 1):
        dist_sq = (d**2 - n)**2
        term = (dist_sq + epsilon)**(-alpha)
        result += term

        # Early termination if negligible
        if term < 1e-15:
            break

    return result

def G_dominant(s, alpha, epsilon, n_max=200):
    """
    G(s,α,ε) = Σ_{n=2}^{n_max} F_n^dom(α,ε) / n^s
    """
    result = 0.0
    for n in range(2, n_max + 1):
        F_val = F_n_dominant(n, alpha, epsilon)
        result += F_val / (n**s)
    return result

def L_M_closed_form(s, j_max=200):
    """L_M(s) = ζ(s)[ζ(s)-1] - Σ H_{j-1}(s)/j^s"""
    zeta_s = zeta(s)
    C_s = sum((sum(k**(-s) for k in range(1, j))) / (j**s) for j in range(2, j_max + 1))
    return zeta_s * (zeta_s - 1) - C_s

# ============================================================================
# Test with dominant term approximation
# ============================================================================

print("="*70)
print("QUESTION A: Dominant Term Approximation")
print("="*70)

s = 2.0
alpha = 3.0
epsilon_values = [1.0, 0.1, 0.01, 0.001, 0.0001]
n_max = 200

print(f"\nParameters: s={s}, α={alpha}, n_max={n_max}")
print(f"Using DOMINANT TERM approximation (O(√n) per F_n)")
print()

L_M_ref = L_M_closed_form(s, j_max=300)
print(f"L_M({s}) reference (closed form): {L_M_ref:.8f}\n")

print(f"Testing: ε^α · G^dom(s,α,ε) → L_M(s) as ε → 0")
print(f"{'ε':>10} {'G^dom':>15} {'ε^α · G^dom':>15} {'L_M(s)':>15} {'Error %':>10}")
print("-" * 70)

for eps in epsilon_values:
    G_val = G_dominant(s, alpha, eps, n_max=n_max)
    scaled_G = (eps**alpha) * G_val
    error_pct = 100 * abs(scaled_G - L_M_ref) / abs(L_M_ref)

    print(f"{eps:10.5f} {G_val:15.6e} {scaled_G:15.8f} {L_M_ref:15.8f} {error_pct:10.2f}%")

print("\n" + "="*70)
print("ANALYSIS:")
print("="*70)

print("""
Key observations:

1. Dominant term approximation is MUCH faster (O(√n) vs O(n) per F_n)
2. This allows larger n_max for better accuracy
3. Error should decrease as ε → 0 IF residue theorem holds

If error stays large (~20%), possible issues:
  - Dominant term misses important contributions
  - Tail sum (n > n_max) is significant
  - Residue theorem needs correction for G(s,α,ε) case

Next: Check contribution from different n ranges
""")

# ============================================================================
# Diagnostic: Check contribution by n range
# ============================================================================

print("\n" + "="*70)
print("DIAGNOSTIC: Contribution by n range")
print("="*70)

eps = 0.01
ranges = [(2, 20), (21, 50), (51, 100), (101, 200)]

print(f"\nFor ε={eps}, α={alpha}, s={s}:")
print(f"{'Range':>15} {'Contribution':>15} {'Scaled (ε^α·C)':>18} {'% of total':>12}")
print("-" * 70)

total_G = 0.0
contributions = []

for (n_start, n_end) in ranges:
    contrib = 0.0
    for n in range(n_start, n_end + 1):
        F_val = F_n_dominant(n, alpha, eps)
        contrib += F_val / (n**s)
    total_G += contrib
    contributions.append((n_start, n_end, contrib))

for (n_start, n_end, contrib) in contributions:
    scaled_contrib = (eps**alpha) * contrib
    pct = 100 * contrib / total_G if total_G > 0 else 0
    print(f"{n_start:7d}-{n_end:5d} {contrib:15.6e} {scaled_contrib:18.8f} {pct:11.2f}%")

print(f"{'TOTAL':>15} {total_G:15.6e} {(eps**alpha)*total_G:18.8f}")

print(f"\nExpected L_M({s}): {L_M_ref:.8f}")
print(f"Shortfall: {L_M_ref - (eps**alpha)*total_G:.8f}")
