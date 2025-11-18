#!/usr/bin/env python3
"""
Global soft-min series with twist: F(s) = Sum[F_n(1) / n^s, {n, 2, infinity}]
Variant A: Fair comparison - both F(s) and ζ(s) aggregate over all n
"""

import numpy as np
import matplotlib.pyplot as plt
from typing import Dict, Tuple
import pickle
import os
from pathlib import Path

# ============================================================================
# SOFT-MIN IMPLEMENTATION (from local comparison)
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


def compute_F_n_at_1(n: int, alpha: float = 7.0, max_d: int = 500) -> float:
    """
    Compute F_n(1) = Sum[soft-min_d(n)^(-1), {d, 2, maxD}]
    This is the CANONICAL soft-min metric with exponent t=1
    """
    cutoff = min(max_d, 10 * n)
    terms = []

    for d in range(2, cutoff + 1):
        soft_min = soft_min_squared(n, d, alpha)
        if soft_min > 0:
            terms.append(1.0 / soft_min)  # Exponent s=1

    return sum(terms)


# ============================================================================
# CACHING MECHANISM
# ============================================================================

def load_or_compute_F_values(max_n: int, alpha: float = 7.0,
                             cache_file: str = "cache/F_n_values.pkl") -> Dict[int, float]:
    """
    Load F_n(1) values from cache or compute them
    """
    cache_path = Path(cache_file)
    cache_path.parent.mkdir(parents=True, exist_ok=True)

    # Try to load from cache
    if cache_path.exists():
        print(f"Loading cached F_n(1) values from {cache_file}...")
        with open(cache_path, 'rb') as f:
            cached_data = pickle.load(f)

        # Check if cache covers our range
        if cached_data.get('max_n', 0) >= max_n and cached_data.get('alpha') == alpha:
            print(f"✓ Cache valid for n ≤ {max_n}")
            return {n: val for n, val in cached_data['values'].items() if n <= max_n}
        else:
            print(f"⚠ Cache incomplete (max_n={cached_data.get('max_n', 0)}), recomputing...")

    # Compute F_n(1) for all n
    print(f"Computing F_n(1) for n ∈ [2, {max_n}]...")
    F_values = {}

    for n in range(2, max_n + 1):
        if n % 100 == 0:
            print(f"  Progress: {n}/{max_n} ({100*n/max_n:.1f}%)", end="\r")

        F_values[n] = compute_F_n_at_1(n, alpha)

    print(f"\n✓ Computed {len(F_values)} values")

    # Save to cache
    with open(cache_path, 'wb') as f:
        pickle.dump({'max_n': max_n, 'alpha': alpha, 'values': F_values}, f)
    print(f"✓ Cached to {cache_file}")

    return F_values


# ============================================================================
# GLOBAL SERIES
# ============================================================================

def global_softmin_series(s: float, F_values: Dict[int, float]) -> float:
    """
    Compute F(s) = Sum[F_n(1) / n^s, {n, 2, max_n}]
    """
    total = sum(F_n / (n ** s) for n, F_n in F_values.items())
    return total


def riemann_zeta_partial(s: float, max_n: int) -> float:
    """
    Compute partial sum of Riemann zeta: Sum[1/n^s, {n, 1, max_n}]
    """
    return sum(1.0 / (n ** s) for n in range(1, max_n + 1))


def prime_zeta_partial(s: float, max_n: int) -> float:
    """
    Compute partial sum of prime zeta: Sum[1/p^s] for primes p ≤ max_n
    """
    # Simple primality test for small n
    def is_prime(n):
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

    primes = [n for n in range(2, max_n + 1) if is_prime(n)]
    return sum(1.0 / (p ** s) for p in primes)


# ============================================================================
# ANALYSIS
# ============================================================================

def analyze_F_distribution(F_values: Dict[int, float]):
    """
    Analyze distribution of F_n(1) values by type
    """
    def is_prime(n):
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

    primes = {n: F for n, F in F_values.items() if is_prime(n)}
    composites = {n: F for n, F in F_values.items() if not is_prime(n)}

    print("=" * 70)
    print("DISTRIBUTION ANALYSIS OF F_n(1) VALUES")
    print("=" * 70)
    print()
    print(f"Total computed: {len(F_values)}")
    print(f"  Primes: {len(primes)}")
    print(f"  Composites: {len(composites)}")
    print()
    print("Primes:")
    print(f"  Mean F_p(1) = {np.mean(list(primes.values())):.3f}")
    print(f"  Std dev = {np.std(list(primes.values())):.3f}")
    print(f"  Range: [{min(primes.values()):.3f}, {max(primes.values()):.3f}]")
    print()
    print("Composites:")
    print(f"  Mean F_c(1) = {np.mean(list(composites.values())):.3f}")
    print(f"  Std dev = {np.std(list(composites.values())):.3f}")
    print(f"  Range: [{min(composites.values()):.3f}, {max(composites.values()):.3f}]")
    print()
    print(f"Ratio: Mean(F_p) / Mean(F_c) = {np.mean(list(primes.values())) / np.mean(list(composites.values())):.2f}x")
    print()

    return primes, composites


def compute_series_comparison(s_range: np.ndarray, F_values: Dict[int, float],
                              max_n: int) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    """
    Compute F(s), ζ(s), and P(s) for range of s values
    """
    print("Computing series for s ∈ [%.1f, %.1f]..." % (s_range[0], s_range[-1]))

    F_series = []
    zeta_series = []
    prime_zeta_series = []

    for s in s_range:
        print(f"  s = {s:.2f}...", end="\r")

        F_s = global_softmin_series(s, F_values)
        zeta_s = riemann_zeta_partial(s, max_n)
        P_s = prime_zeta_partial(s, max_n)

        F_series.append(F_s)
        zeta_series.append(zeta_s)
        prime_zeta_series.append(P_s)

    print(" " * 50, end="\r")
    print(f"✓ Computed {len(s_range)} points")
    print()

    return np.array(F_series), np.array(zeta_series), np.array(prime_zeta_series)


# ============================================================================
# VISUALIZATION
# ============================================================================

def plot_global_comparison(s_range: np.ndarray, F_series: np.ndarray,
                          zeta_series: np.ndarray, prime_zeta_series: np.ndarray,
                          max_n: int):
    """
    Create comprehensive comparison plots
    """
    # Plot 1: All three series with dual axis
    fig, ax1 = plt.subplots(figsize=(12, 7))

    color_F = 'tab:orange'
    ax1.set_xlabel('s', fontsize=13)
    ax1.set_ylabel('$\\mathcal{F}(s)$ [soft-min series]', color=color_F, fontsize=13)
    ax1.plot(s_range, F_series, 'o-', color=color_F, label='$\\mathcal{F}(s)$',
             linewidth=2.5, markersize=6)
    ax1.tick_params(axis='y', labelcolor=color_F)
    ax1.grid(True, alpha=0.3)

    ax2 = ax1.twinx()
    color_zeta = 'tab:blue'
    color_P = 'tab:green'
    ax2.set_ylabel('$\\zeta(s)$ and $P(s)$', fontsize=13)
    ax2.plot(s_range, zeta_series, '^--', color=color_zeta, label='$\\zeta(s)$',
             linewidth=2, markersize=5)
    ax2.plot(s_range, prime_zeta_series, 's:', color=color_P, label='$P(s)$ [prime zeta]',
             linewidth=2, markersize=5)
    ax2.tick_params(axis='y')

    plt.title(f'Global comparison (partial sums to n={max_n})\\n' +
              f'$\\mathcal{{F}}(s) = \\sum_{{n=2}}^{{{max_n}}} F_n(1)/n^s$ vs. ' +
              f'$\\zeta(s)$ and $P(s)$',
              fontsize=14, pad=20)

    lines1, labels1 = ax1.get_legend_handles_labels()
    lines2, labels2 = ax2.get_legend_handles_labels()
    ax1.legend(lines1 + lines2, labels1 + labels2, loc='upper right', fontsize=11)

    fig.tight_layout()
    plt.savefig("visualizations/global-comparison-dual-axis.pdf", dpi=300, bbox_inches='tight')
    print("✓ Saved: visualizations/global-comparison-dual-axis.pdf")
    plt.close()

    # Plot 2: Ratios
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

    # F(s) / ζ(s)
    ratio_zeta = F_series / zeta_series
    ax1.plot(s_range, ratio_zeta, 'o-', color='purple', linewidth=2.5, markersize=6)
    ax1.axhline(y=1, color='gray', linestyle='--', alpha=0.5, label='y=1')
    ax1.set_xlabel('s', fontsize=12)
    ax1.set_ylabel('$\\mathcal{F}(s) / \\zeta(s)$', fontsize=12)
    ax1.set_title('Ratio: Soft-min series / Riemann zeta', fontsize=13)
    ax1.grid(True, alpha=0.3)
    ax1.legend()

    # F(s) / P(s)
    ratio_prime = F_series / prime_zeta_series
    ax2.plot(s_range, ratio_prime, 'o-', color='darkgreen', linewidth=2.5, markersize=6)
    ax2.axhline(y=1, color='gray', linestyle='--', alpha=0.5, label='y=1')
    ax2.set_xlabel('s', fontsize=12)
    ax2.set_ylabel('$\\mathcal{F}(s) / P(s)$', fontsize=12)
    ax2.set_title('Ratio: Soft-min series / Prime zeta', fontsize=13)
    ax2.grid(True, alpha=0.3)
    ax2.legend()

    plt.tight_layout()
    plt.savefig("visualizations/global-comparison-ratios.pdf", dpi=300, bbox_inches='tight')
    print("✓ Saved: visualizations/global-comparison-ratios.pdf")
    plt.close()

    # Plot 3: Rescaled shapes
    F_rescaled = (F_series - F_series.min()) / (F_series.max() - F_series.min())
    zeta_rescaled = (zeta_series - zeta_series.min()) / (zeta_series.max() - zeta_series.min())
    P_rescaled = (prime_zeta_series - prime_zeta_series.min()) / \
                 (prime_zeta_series.max() - prime_zeta_series.min())

    plt.figure(figsize=(11, 7))
    plt.plot(s_range, F_rescaled, 'o-', color='tab:orange',
             label='$\\mathcal{F}(s)$', linewidth=2.5, markersize=6)
    plt.plot(s_range, zeta_rescaled, '^--', color='tab:blue',
             label='$\\zeta(s)$', linewidth=2, markersize=5)
    plt.plot(s_range, P_rescaled, 's:', color='tab:green',
             label='$P(s)$ [prime zeta]', linewidth=2, markersize=5)

    plt.xlabel('s', fontsize=12)
    plt.ylabel('Normalized value [0, 1]', fontsize=12)
    plt.title(f'Shape comparison (all rescaled to [0,1]), n ≤ {max_n}', fontsize=14)
    plt.legend(fontsize=11, loc='best')
    plt.grid(True, alpha=0.3)
    plt.tight_layout()

    plt.savefig("visualizations/global-comparison-rescaled.pdf", dpi=300, bbox_inches='tight')
    print("✓ Saved: visualizations/global-comparison-rescaled.pdf")
    plt.close()


# ============================================================================
# MAIN
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("GLOBAL SOFT-MIN SERIES (VARIANT A WITH TWIST)")
    print("=" * 70)
    print()
    print("Definition:")
    print("  F(s) = Sum[F_n(1) / n^s, {n, 2, infinity}]")
    print()
    print("where F_n(1) is the canonical soft-min metric.")
    print()
    print("Twist: We fix the inner exponent at t=1 and study only")
    print("       the dependence on outer Dirichlet exponent s.")
    print()
    print("=" * 70)
    print()

    # Parameters
    max_n = 1000
    alpha = 7.0
    s_range = np.arange(1.2, 5.1, 0.2)

    # Step 1: Compute or load F_n(1) values
    F_values = load_or_compute_F_values(max_n, alpha)
    print()

    # Step 2: Analyze distribution
    primes, composites = analyze_F_distribution(F_values)

    # Step 3: Compute series
    F_series, zeta_series, prime_zeta_series = compute_series_comparison(
        s_range, F_values, max_n
    )

    # Step 4: Print numerical results
    print("=" * 70)
    print("NUMERICAL RESULTS")
    print("=" * 70)
    print()
    print(f"{'s':>6} {'F(s)':>10} {'ζ(s)':>10} {'P(s)':>10} {'F/ζ':>8} {'F/P':>8}")
    print("-" * 70)
    for i, s in enumerate(s_range):
        print(f"{s:6.2f} {F_series[i]:10.4f} {zeta_series[i]:10.4f} "
              f"{prime_zeta_series[i]:10.4f} {F_series[i]/zeta_series[i]:8.3f} "
              f"{F_series[i]/prime_zeta_series[i]:8.3f}")
    print()

    # Step 5: Visualizations
    print("=" * 70)
    print("GENERATING VISUALIZATIONS")
    print("=" * 70)
    print()
    plot_global_comparison(s_range, F_series, zeta_series, prime_zeta_series, max_n)

    # Step 6: Summary
    print()
    print("=" * 70)
    print("SUMMARY")
    print("=" * 70)
    print()
    print(f"Computed for n ∈ [2, {max_n}]:")
    print(f"  • F(s) encodes GEOMETRY (Primal Forest distances)")
    print(f"  • ζ(s) is UNIVERSAL (all integers equally)")
    print(f"  • P(s) encodes PRIMES ONLY")
    print()
    print(f"Key finding:")
    print(f"  • Mean F/ζ ratio = {np.mean(F_series/zeta_series):.2f}")
    print(f"  • Mean F/P ratio = {np.mean(F_series/prime_zeta_series):.2f}")
    print()
    print(f"Interpretation:")
    if np.mean(F_series/zeta_series) > 1:
        print(f"  F(s) > ζ(s) suggests geometry overweights ALL numbers")
    else:
        print(f"  F(s) < ζ(s) suggests geometry underweights numbers")

    if np.mean(F_series/prime_zeta_series) < np.mean(F_series/zeta_series):
        print(f"  F(s) is CLOSER to P(s) than ζ(s)")
        print(f"  → Geometry preferentially encodes PRIMES!")
    else:
        print(f"  F(s) is closer to ζ(s) than P(s)")
    print()
