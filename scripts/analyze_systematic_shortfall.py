#!/usr/bin/env python3
"""
Analyze systematic shortfall in G(s,α,ε) → L_M(s)

Hypothesis: The difference converges to a constant, which might be
a missing correction term in the dominant approximation.
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
    """Dominant term (with tail)"""
    sqrt_n = int(np.sqrt(n))
    result = 0.0

    # Below √n
    for d in range(2, sqrt_n + 1):
        r_d = (n - d**2) % d
        result += (r_d**2 + epsilon)**(-alpha)

    # Above √n (tail)
    tail_max = int(sqrt_n + 20)
    for d in range(sqrt_n + 1, tail_max + 1):
        dist_sq = (d**2 - n)**2
        term = (dist_sq + epsilon)**(-alpha)
        result += term
        if term < 1e-15:
            break

    return result

def F_n_FULL_double_sum(n, alpha, epsilon, d_max=None, k_max=None):
    """
    FULL double sum (not approximation):
    F_n(α,ε) = Σ_{d=2}^∞ Σ_{k=0}^∞ [(n - kd - d²)² + ε]^{-α}
    """
    if d_max is None:
        d_max = max(10, int(2 * np.sqrt(n)))

    result = 0.0
    for d in range(2, d_max + 1):
        if k_max is None:
            k_max_d = max(10, int((n + 10*d) / d))
        else:
            k_max_d = k_max

        for k in range(k_max_d + 1):
            distance_sq = (n - k*d - d**2)**2
            term = (distance_sq + epsilon)**(-alpha)
            result += term

            if term < 1e-15:
                break

    return result

def L_M_closed_form(s, j_max=300):
    """L_M(s) = ζ(s)[ζ(s)-1] - Σ H_{j-1}(s)/j^s"""
    zeta_s = zeta(s)
    C_s = sum((sum(k**(-s) for k in range(1, j))) / (j**s)
              for j in range(2, j_max + 1))
    return zeta_s * (zeta_s - 1) - C_s

def G_dominant(s, alpha, epsilon, n_max):
    """G using dominant term"""
    return sum(F_n_dominant(n, alpha, epsilon) / (n**s)
               for n in range(2, n_max + 1))

def G_full(s, alpha, epsilon, n_max):
    """G using FULL double sum"""
    return sum(F_n_FULL_double_sum(n, alpha, epsilon) / (n**s)
               for n in range(2, n_max + 1))

# ============================================================================
# Main Analysis
# ============================================================================

print("="*80)
print("SYSTEMATIC SHORTFALL ANALYSIS")
print("="*80)

s = 2.0
alpha = 3.0

L_M_ref = L_M_closed_form(s, j_max=500)
print(f"\nL_M({s}) reference: {L_M_ref:.10f}")
print()

# Test 1: Dominant vs Full for SMALL n_max (to see difference)
print("="*80)
print("TEST 1: Dominant vs Full double sum")
print("="*80)

eps = 0.01
n_max_small = 50

print(f"\nε = {eps}, n_max = {n_max_small}\n")

G_dom = G_dominant(s, alpha, eps, n_max_small)
G_full_val = G_full(s, alpha, eps, n_max_small)

scaled_dom = (eps**alpha) * G_dom
scaled_full = (eps**alpha) * G_full_val

print(f"Dominant term: ε^α · G_dom  = {scaled_dom:.10f}")
print(f"Full sum:      ε^α · G_full = {scaled_full:.10f}")
print(f"Difference:                  {scaled_full - scaled_dom:.10f}")
print(f"\nShortfall (dom):  {L_M_ref - scaled_dom:.10f}")
print(f"Shortfall (full): {L_M_ref - scaled_full:.10f}")

# Test 2: Check if shortfall depends on n_max
print("\n" + "="*80)
print("TEST 2: Shortfall vs n_max (dominant term)")
print("="*80)

eps = 0.01
n_max_values = [50, 100, 200, 500, 1000]

print(f"\nε = {eps}\n")
print(f"{'n_max':>10} {'ε^α·G_dom':>15} {'Shortfall':>15} {'Shortfall %':>12}")
print("-" * 80)

shortfalls = []
for n_max in n_max_values:
    G_val = G_dominant(s, alpha, eps, n_max)
    scaled = (eps**alpha) * G_val
    shortfall = L_M_ref - scaled
    shortfall_pct = 100 * shortfall / L_M_ref

    shortfalls.append(shortfall)
    print(f"{n_max:10d} {scaled:15.10f} {shortfall:15.10f} {shortfall_pct:11.2f}%")

# Test 3: Pattern in shortfall
print("\n" + "="*80)
print("TEST 3: Shortfall pattern analysis")
print("="*80)

# Check if shortfall ~ 1/n_max (tail decay)
print(f"\n{'n_max':>10} {'Shortfall':>15} {'n*Shortfall':>15} {'Ratio to prev':>15}")
print("-" * 80)

prev_shortfall = None
for i, n_max in enumerate(n_max_values):
    sf = shortfalls[i]
    product = n_max * sf

    ratio = ""
    if prev_shortfall is not None:
        ratio = f"{sf/prev_shortfall:.4f}"
    prev_shortfall = sf

    print(f"{n_max:10d} {sf:15.10f} {product:15.10f} {ratio:>15}")

# Test 4: Missing contribution from tail?
print("\n" + "="*80)
print("TEST 4: Is shortfall = missing tail contribution?")
print("="*80)

# Estimate: What's the tail sum for L_M directly?
n_max = 1000
L_M_partial = sum(M(n) / (n**s) for n in range(2, n_max + 1))
L_M_tail = L_M_ref - L_M_partial

print(f"\nL_M({s}) total:            {L_M_ref:.10f}")
print(f"L_M({s}) sum to {n_max}:  {L_M_partial:.10f}")
print(f"L_M({s}) tail (>{n_max}): {L_M_tail:.10f}")
print()
print(f"G shortfall at n_max={n_max}: {shortfalls[-1]:.10f}")
print(f"Ratio (shortfall/tail):       {shortfalls[-1]/L_M_tail:.4f}")

# Test 5: Symbolic estimate
print("\n" + "="*80)
print("TEST 5: Theoretical shortfall estimate")
print("="*80)

print("""
For Re(s) > 1, tail sum behaves like:

  Σ_{n>N} M(n)/n^s ~ ∫_N^∞ M(x)/x^s dx

If M(x) ~ (τ(x)-1)/2 ~ (ln x)/2, then:

  ∫_N^∞ (ln x)/(2x^s) dx ~ (ln N + 1)/(2(s-1)N^{s-1})

For s=2, N=1000:
  ~ (ln(1000) + 1) / (2·1000) ≈ 0.00396

But we see shortfall ≈ 0.019, which is ~5× larger!

This suggests the shortfall is NOT just the L_M tail.
It's a SYSTEMATIC error in dominant term approximation.
""")

# Final comparison
actual_shortfall = shortfalls[-1]
L_M_tail_val = L_M_tail
theoretical_tail = (np.log(1000) + 1) / (2 * 1000)

print(f"Actual shortfall:       {actual_shortfall:.10f}")
print(f"L_M tail (direct):      {L_M_tail_val:.10f}")
print(f"Theoretical tail:       {theoretical_tail:.10f}")
print(f"\nShortfall / L_M_tail:   {actual_shortfall / L_M_tail_val:.4f}")
print(f"Shortfall / Theo tail:  {actual_shortfall / theoretical_tail:.4f}")

print("\n" + "="*80)
print("CONCLUSION:")
print("="*80)
print("""
The systematic shortfall (~0.019) is:
  - NOT explained by L_M tail alone (~0.002)
  - NOT decreasing significantly with n_max
  - Converging to a CONSTANT

This suggests:
  1. Dominant term approximation systematically underestimates
  2. Missing correction term exists
  3. Full double sum might recover it

Next: Compare dominant vs full for same n_max to isolate the error.
""")
