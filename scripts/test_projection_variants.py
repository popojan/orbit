#!/usr/bin/env python3
"""
Test alternative projection variants for Primal Forest simplification

Variants tested:
1. Anchor points: F_n = Σ|n - d²|^(-α)
2. Rational approximations: Farey-based distance
"""

import numpy as np
import matplotlib.pyplot as plt
from fractions import Fraction

# ============================================================================
# VARIANT 1: ANCHOR POINT PROJECTION
# ============================================================================

def F_anchor_points(n, alpha, eps=1.0, max_d=None):
    """
    Simplest projection: distance to anchor points (d², 1)

    F_n(α) = Σ_{d=2}^∞ [|n - d²| + ε]^(-α)

    No modulo, no minimum - just pure distance to squares.
    """
    if max_d is None:
        max_d = int(10 * np.sqrt(n)) + 100

    total = 0.0
    for d in range(2, max_d + 1):
        dist = abs(n - d**2)
        if dist + eps > 0:
            total += (dist + eps)**(-alpha)

    return total


# ============================================================================
# VARIANT 2: RATIONAL APPROXIMATIONS (FAREY-BASED)
# ============================================================================

def farey_neighbors(n, max_q=100):
    """
    Find Farey neighbors of n (treating n as n/1)

    Returns pairs (p/q) where q ≤ max_q that are closest to n.
    """
    # For integer n, closest rationals are (n-1)/1, n/1, (n+1)/1
    # But more interesting: find rationals p/q close to n

    neighbors = []

    for q in range(1, max_q + 1):
        # Closest p for this q
        p_low = int(np.floor(n * q))
        p_high = int(np.ceil(n * q))

        for p in [p_low, p_high]:
            if p >= 0:
                frac = Fraction(p, q)
                dist = abs(float(frac) - n)
                neighbors.append((frac, dist, p, q))

    # Sort by distance
    neighbors.sort(key=lambda x: x[1])

    return neighbors[:20]  # Return 20 closest


def F_farey_approximations(n, alpha, eps=1.0, max_q=50):
    """
    Distance to rational approximations (Farey sequence)

    F_n(α) = Σ_{p/q Farey neighbors} [|n - p/q| + ε]^(-α)

    Idea: Measure how well n can be approximated by rationals.
    """
    neighbors = farey_neighbors(n, max_q)

    total = 0.0
    for frac, dist, p, q in neighbors:
        if dist + eps > 0:
            # Weight by denominator (penalize complex fractions)
            weighted_dist = (dist + eps) * q**0.5
            total += weighted_dist**(-alpha)

    return total


# ============================================================================
# VARIANT 3: ORIGINAL PROJECTION (for comparison)
# ============================================================================

def F_projection_diagonal(n, alpha, eps=1.0, max_d=None):
    """
    Original projection to diagonal (from feasibility study)

    F_n(α) = Σ_{d=2}^∞ [|(n-d²) mod d| + ε]^(-α)
    """
    if max_d is None:
        max_d = int(10 * np.sqrt(n)) + 100

    total = 0.0
    for d in range(2, max_d + 1):
        residue = abs((n - d**2) % d)
        # Symmetric modulo: take min(residue, d - residue)
        residue_sym = min(residue, d - residue)
        total += (residue_sym + eps)**(-alpha)

    return total


# ============================================================================
# TESTING
# ============================================================================

def test_variant(func, name, n_values, alpha_range):
    """
    Test a variant for stratification and U-shape
    """
    print(f"\n{'='*70}")
    print(f"Testing: {name}")
    print(f"{'='*70}\n")

    # Test for fixed alpha, varying n (stratification)
    alpha_test = 3.0
    print(f"Stratification test (α = {alpha_test}):\n")

    for n in n_values:
        value = func(n, alpha_test)
        prime_str = " (PRIME)" if is_prime(n) else " (composite)"
        print(f"  n = {n:3d}{prime_str:15s}  →  F_n = {value:.6f}")

    # Test for fixed n, varying alpha (U-shape)
    print(f"\nU-shape test (n = 97, prime):\n")

    n_test = 97
    alpha_values = alpha_range
    F_values = [func(n_test, a) for a in alpha_values]

    # Find minimum
    min_idx = np.argmin(F_values)
    min_alpha = alpha_values[min_idx]
    min_value = F_values[min_idx]

    print(f"  Range α ∈ [{alpha_range[0]}, {alpha_range[-1]}]")
    print(f"  Minimum at α ≈ {min_alpha:.2f}")
    print(f"  Min value: {min_value:.6f}")
    print(f"  F(0.5) = {F_values[0]:.6f}")
    print(f"  F(5.0) = {F_values[-1]:.6f}")

    # Check if U-shape (min not at boundaries)
    if min_idx == 0:
        print(f"  ❌ Minimum at LEFT boundary (α={alpha_range[0]}) - monotonically INCREASING")
    elif min_idx == len(alpha_values) - 1:
        print(f"  ❌ Minimum at RIGHT boundary (α={alpha_range[-1]}) - monotonically DECREASING")
    else:
        print(f"  ✅ U-SHAPE detected! (minimum in middle)")

    return alpha_values, F_values


def is_prime(n):
    """Simple primality test"""
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(np.sqrt(n)) + 1, 2):
        if n % i == 0:
            return False
    return True


# ============================================================================
# MAIN
# ============================================================================

if __name__ == "__main__":
    print("="*70)
    print("PROJECTION VARIANTS COMPARISON")
    print("="*70)

    # Test cases
    n_values = [96, 97, 98, 99, 100, 101, 102, 103]  # Mix of primes and composites
    alpha_range = np.arange(0.5, 5.1, 0.1)

    # Variant 1: Anchor points
    alpha_vals_1, F_vals_1 = test_variant(
        F_anchor_points,
        "Anchor Points: F_n = Σ|n - d²|^(-α)",
        n_values,
        alpha_range
    )

    # Variant 2: Farey approximations
    alpha_vals_2, F_vals_2 = test_variant(
        F_farey_approximations,
        "Farey Approximations: Distance to rational neighbors",
        n_values,
        alpha_range
    )

    # Variant 3: Original projection (for comparison)
    alpha_vals_3, F_vals_3 = test_variant(
        F_projection_diagonal,
        "Diagonal Projection (Original): F_n = Σ|(n-d²) mod d|^(-α)",
        n_values,
        alpha_range
    )

    # Plot comparison
    fig, axes = plt.subplots(1, 3, figsize=(15, 5))

    for ax, alpha_vals, F_vals, title in zip(
        axes,
        [alpha_vals_1, alpha_vals_2, alpha_vals_3],
        [F_vals_1, F_vals_2, F_vals_3],
        ["Anchor Points", "Farey Approx", "Diagonal (Original)"]
    ):
        ax.plot(alpha_vals, F_vals, 'o-', linewidth=2, markersize=4)
        ax.set_xlabel('α', fontsize=12)
        ax.set_ylabel('F_n(α)', fontsize=12)
        ax.set_title(f'{title}\nn=97 (prime)', fontsize=11)
        ax.grid(True, alpha=0.3)

        # Mark minimum
        min_idx = np.argmin(F_vals)
        ax.plot(alpha_vals[min_idx], F_vals[min_idx], 'r*', markersize=15,
                label=f'Min at α={alpha_vals[min_idx]:.1f}')
        ax.legend()

    plt.tight_layout()
    plt.savefig('visualizations/projection_variants_comparison.pdf', dpi=150, bbox_inches='tight')
    print(f"\n✓ Saved: visualizations/projection_variants_comparison.pdf")

    # Summary
    print("\n" + "="*70)
    print("SUMMARY")
    print("="*70)
    print("""
Variants tested:
1. Anchor Points     - Simplest (no modulo)
2. Farey Approx      - Rational approximation distance
3. Diagonal Original - Modulo-based (from feasibility study)

Check output above and visualization to determine:
- Which variant stratifies primes vs composites?
- Which variant shows U-shape?
- Which is simplest while preserving properties?
    """)
