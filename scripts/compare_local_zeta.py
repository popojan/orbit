#!/usr/bin/env python3
"""
Comparison of F_n(s) with local zeta function ζ_n(s)
Variant B: Fair comparison - both functions study local structure of n
"""

import numpy as np
import matplotlib.pyplot as plt
from typing import List, Tuple
import sympy as sp

# ============================================================================
# SOFT-MIN IMPLEMENTATION (from Wolfram script)
# ============================================================================

def soft_min_squared(x: int, d: int, alpha: float = 7.0) -> float:
    """
    Compute soft-min of squared distances from x to all points k*d + d^2
    Uses log-sum-exp trick for numerical stability
    """
    max_k = x // d
    distances_sq = [(x - (k*d + d**2))**2 for k in range(max_k + 1)]

    # Log-sum-exp with numerical stability
    neg_dist_sq = [-alpha * d for d in distances_sq]
    M = max(neg_dist_sq)

    log_sum_exp = M + np.log(sum(np.exp(nd - M) for nd in neg_dist_sq))

    return -log_sum_exp / alpha


def dirichlet_like_sum(n: int, s: float, alpha: float = 7.0, max_d: int = 500) -> float:
    """
    Compute F_n(s) = Sum[soft-min_d(n)^(-s), {d, 2, maxD}]
    """
    cutoff = min(max_d, 10 * n)
    terms = []

    for d in range(2, cutoff + 1):
        soft_min = soft_min_squared(n, d, alpha)
        if soft_min > 0:
            terms.append(soft_min ** (-s))

    return sum(terms)


# ============================================================================
# LOCAL ZETA FUNCTION
# ============================================================================

def divisors(n: int) -> List[int]:
    """Find all divisors of n"""
    divs = []
    for i in range(1, int(np.sqrt(n)) + 1):
        if n % i == 0:
            divs.append(i)
            if i != n // i:
                divs.append(n // i)
    return sorted(divs)


def local_zeta(n: int, s: float) -> float:
    """
    Compute ζ_n(s) = Sum[d^(-s)] for d dividing n
    """
    divs = divisors(n)
    return sum(d ** (-s) for d in divs)


# ============================================================================
# COMPARISON
# ============================================================================

def compare_functions(n: int, s_range: np.ndarray, alpha: float = 7.0):
    """
    Compare F_n(s) with ζ_n(s) for given n
    """
    print(f"Computing for n = {n}")
    print(f"Divisors: {divisors(n)}")
    print(f"Number of divisors: {len(divisors(n))}")
    print()

    f_values = []
    zeta_values = []

    for s in s_range:
        print(f"  s = {s:.1f}...", end="\r")
        f_val = dirichlet_like_sum(n, s, alpha, max_d=500)
        z_val = local_zeta(n, s)

        f_values.append(f_val)
        zeta_values.append(z_val)

    print(" " * 50, end="\r")  # Clear line
    print(f"✓ Computed {len(s_range)} points")
    print()

    return np.array(f_values), np.array(zeta_values)


# ============================================================================
# VISUALIZATION
# ============================================================================

def plot_comparison(n: int, s_range: np.ndarray, f_values: np.ndarray,
                   zeta_values: np.ndarray, output_file: str):
    """
    Create dual-axis plot to show both curves
    """
    fig, ax1 = plt.subplots(figsize=(10, 6))

    # Left axis: F_n(s)
    color1 = 'tab:orange'
    ax1.set_xlabel('s', fontsize=12)
    ax1.set_ylabel(f'$F_{{{n}}}(s)$ [soft-min series]', color=color1, fontsize=12)
    ax1.plot(s_range, f_values, 'o-', color=color1, label=f'$F_{{{n}}}(s)$', linewidth=2)
    ax1.tick_params(axis='y', labelcolor=color1)
    ax1.grid(True, alpha=0.3)

    # Right axis: ζ_n(s)
    ax2 = ax1.twinx()
    color2 = 'tab:blue'
    ax2.set_ylabel(f'$\\zeta_{{{n}}}(s)$ [divisor sum]', color=color2, fontsize=12)
    ax2.plot(s_range, zeta_values, '^--', color=color2, label=f'$\\zeta_{{{n}}}(s)$', linewidth=2)
    ax2.tick_params(axis='y', labelcolor=color2)

    # Title
    plt.title(f'Local comparison for n = {n}\n' +
              f'$F_n(s)$ vs. $\\zeta_n(s) = \\sum_{{d|n}} d^{{-s}}$',
              fontsize=14, pad=20)

    # Legends
    lines1, labels1 = ax1.get_legend_handles_labels()
    lines2, labels2 = ax2.get_legend_handles_labels()
    ax1.legend(lines1 + lines2, labels1 + labels2, loc='upper right', fontsize=11)

    fig.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"✓ Saved: {output_file}")

    return fig


def plot_single_axis_rescaled(n: int, s_range: np.ndarray,
                              f_values: np.ndarray, zeta_values: np.ndarray,
                              output_file: str):
    """
    Rescale both to [0,1] to compare shapes on single axis
    """
    # Rescale to [0, 1]
    f_rescaled = (f_values - f_values.min()) / (f_values.max() - f_values.min())
    z_rescaled = (zeta_values - zeta_values.min()) / (zeta_values.max() - zeta_values.min())

    plt.figure(figsize=(10, 6))
    plt.plot(s_range, f_rescaled, 'o-', color='tab:orange',
             label=f'$F_{{{n}}}(s)$ [rescaled]', linewidth=2, markersize=5)
    plt.plot(s_range, z_rescaled, '^--', color='tab:blue',
             label=f'$\\zeta_{{{n}}}(s)$ [rescaled]', linewidth=2, markersize=5)

    plt.xlabel('s', fontsize=12)
    plt.ylabel('Normalized value [0, 1]', fontsize=12)
    plt.title(f'Shape comparison (both rescaled) for n = {n}', fontsize=14)
    plt.legend(fontsize=11)
    plt.grid(True, alpha=0.3)
    plt.tight_layout()

    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"✓ Saved: {output_file}")


# ============================================================================
# MAIN
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("LOCAL COMPARISON: F_n(s) vs. ζ_n(s)")
    print("=" * 70)
    print()

    # Parameters
    alpha = 7.0
    s_range = np.arange(0.8, 3.1, 0.1)

    # Test for n = 97 (prime)
    print("=" * 70)
    print("CASE 1: n = 97 (prime)")
    print("=" * 70)
    n1 = 97
    f1, z1 = compare_functions(n1, s_range, alpha)

    print(f"F_{n1}(s) range: [{f1.min():.3f}, {f1.max():.3f}]")
    print(f"ζ_{n1}(s) range: [{z1.min():.3f}, {z1.max():.3f}]")
    print(f"Ratio F/ζ range: [{(f1/z1).min():.3f}, {(f1/z1).max():.3f}]")
    print()

    plot_comparison(n1, s_range, f1, z1,
                   "visualizations/local-comparison-97-dual-axis.pdf")
    plot_single_axis_rescaled(n1, s_range, f1, z1,
                              "visualizations/local-comparison-97-rescaled.pdf")

    # Test for n = 96 (highly composite, close to 97)
    print("=" * 70)
    print("CASE 2: n = 96 (composite, many divisors)")
    print("=" * 70)
    n2 = 96
    f2, z2 = compare_functions(n2, s_range, alpha)

    print(f"F_{n2}(s) range: [{f2.min():.3f}, {f2.max():.3f}]")
    print(f"ζ_{n2}(s) range: [{z2.min():.3f}, {z2.max():.3f}]")
    print(f"Ratio F/ζ range: [{(f2/z2).min():.3f}, {(f2/z2).max():.3f}]")
    print()

    plot_comparison(n2, s_range, f2, z2,
                   "visualizations/local-comparison-96-dual-axis.pdf")
    plot_single_axis_rescaled(n2, s_range, f2, z2,
                              "visualizations/local-comparison-96-rescaled.pdf")

    # Summary comparison
    print("=" * 70)
    print("SUMMARY")
    print("=" * 70)
    print()
    print("Prime (97):")
    print(f"  F_97 exhibits U-shape: min at s ≈ {s_range[np.argmin(f1)]:.1f}")
    print(f"  ζ_97 = 1 + 97^(-s) is monotone decreasing")
    print(f"  Scales differ by factor ~{(f1/z1).mean():.1f}x")
    print()
    print("Composite (96):")
    print(f"  F_96 exhibits U-shape: min at s ≈ {s_range[np.argmin(f2)]:.1f}")
    print(f"  ζ_96 has {len(divisors(96))} divisors, monotone decreasing")
    print(f"  Scales differ by factor ~{(f2/z2).mean():.1f}x")
    print()
    print("CONCLUSION:")
    print("  • Both F_n and ζ_n are 'local' (study single n)")
    print("  • F_n encodes GEOMETRY (Primal Forest distances)")
    print("  • ζ_n encodes DIVISIBILITY (classical number theory)")
    print("  • F_n has intrinsic scale (U-shape) vs ζ_n monotone")
    print("  • Fair comparison, but measure different properties!")
    print()
