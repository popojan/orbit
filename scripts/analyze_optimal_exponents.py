#!/usr/bin/env python3
"""
Systematic analysis of optimal exponents s*(n)
Tests U-shape primality signature hypothesis
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import minimize_scalar
from typing import Dict, Tuple, Optional
import pickle
from pathlib import Path

# ============================================================================
# SOFT-MIN IMPLEMENTATION
# ============================================================================

def soft_min_squared(x: int, d: int, alpha: float = 7.0) -> float:
    """Compute soft-min of squared distances from x to all points k*d + d^2"""
    max_k = x // d
    distances_sq = [(x - (k*d + d**2))**2 for k in range(max_k + 1)]

    neg_dist_sq = [-alpha * d for d in distances_sq]
    M = max(neg_dist_sq)

    log_sum_exp = M + np.log(sum(np.exp(nd - M) for nd in neg_dist_sq))

    return -log_sum_exp / alpha


def compute_F_n(n: int, s: float, alpha: float = 7.0, max_d: int = 500) -> float:
    """Compute F_n(s) = Sum[soft-min_d(n)^(-s), {d, 2, maxD}]"""
    cutoff = min(max_d, 10 * n)
    terms = []

    for d in range(2, cutoff + 1):
        soft_min = soft_min_squared(n, d, alpha)
        if soft_min > 0:
            terms.append(soft_min ** (-s))

    return sum(terms)


# ============================================================================
# PRIMALITY TESTING
# ============================================================================

def is_prime(n: int) -> bool:
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
# OPTIMAL EXPONENT FINDING
# ============================================================================

def find_optimal_s(n: int, alpha: float = 7.0, s_bounds: Tuple[float, float] = (0.5, 5.0),
                   tol: float = 0.01) -> Tuple[Optional[float], float, bool]:
    """
    Find s*(n) = argmin F_n(s)

    Returns:
        s_opt: optimal s (or None if monotonic)
        F_min: minimum value of F_n
        has_minimum: True if genuine minimum exists
    """

    # Define objective function
    def objective(s):
        return compute_F_n(n, s, alpha)

    # Find minimum using Brent's method
    result = minimize_scalar(objective, bounds=s_bounds, method='bounded',
                            options={'xatol': tol})

    s_opt = result.x
    F_min = result.fun

    # Check if it's a genuine minimum (not at boundary)
    boundary_tolerance = 0.1
    is_at_boundary = (s_opt < s_bounds[0] + boundary_tolerance or
                     s_opt > s_bounds[1] - boundary_tolerance)

    # Also check endpoints to verify it's not monotonic
    F_left = compute_F_n(n, s_bounds[0] + 0.1, alpha)
    F_right = compute_F_n(n, s_bounds[1] - 0.1, alpha)

    # If minimum is at boundary and endpoint value is lower, it's monotonic
    is_monotonic = is_at_boundary and (F_left <= F_min or F_right <= F_min)

    has_minimum = not is_monotonic

    return (s_opt if has_minimum else None, F_min, has_minimum)


# ============================================================================
# BATCH ANALYSIS
# ============================================================================

def analyze_range(n_min: int, n_max: int, alpha: float = 7.0,
                 cache_file: str = "cache/optimal_exponents.pkl") -> Dict:
    """
    Analyze optimal exponents for range of n
    """
    cache_path = Path(cache_file)
    cache_path.parent.mkdir(parents=True, exist_ok=True)

    # Try to load cache
    if cache_path.exists():
        print(f"Loading cached results from {cache_file}...")
        with open(cache_path, 'rb') as f:
            cached = pickle.load(f)

        if cached.get('n_max', 0) >= n_max and cached.get('alpha') == alpha:
            print(f"✓ Cache valid for n ≤ {n_max}")
            return {n: data for n, data in cached['results'].items()
                   if n_min <= n <= n_max}

    # Compute
    print(f"Analyzing n ∈ [{n_min}, {n_max}]...")
    results = {}

    for n in range(n_min, n_max + 1):
        if n % 50 == 0:
            print(f"  Progress: {n}/{n_max} ({100*n/n_max:.1f}%)", end="\r")

        s_opt, F_min, has_min = find_optimal_s(n, alpha)
        prime = is_prime(n)

        results[n] = {
            's_opt': s_opt,
            'F_min': F_min,
            'has_minimum': has_min,
            'is_prime': prime
        }

    print(f"\n✓ Analyzed {len(results)} values")

    # Save cache
    with open(cache_path, 'wb') as f:
        pickle.dump({'n_max': n_max, 'alpha': alpha, 'results': results}, f)
    print(f"✓ Cached to {cache_file}")

    return results


# ============================================================================
# STATISTICAL ANALYSIS
# ============================================================================

def compute_statistics(results: Dict) -> Dict:
    """Compute precision/recall and other statistics"""

    # Classify
    primes_with_min = [n for n, d in results.items()
                      if d['is_prime'] and d['has_minimum']]
    primes_without_min = [n for n, d in results.items()
                         if d['is_prime'] and not d['has_minimum']]
    composites_with_min = [n for n, d in results.items()
                          if not d['is_prime'] and d['has_minimum']]
    composites_without_min = [n for n, d in results.items()
                             if not d['is_prime'] and not d['has_minimum']]

    # Precision/Recall
    TP = len(primes_with_min)  # True Positives
    FN = len(primes_without_min)  # False Negatives
    FP = len(composites_with_min)  # False Positives
    TN = len(composites_without_min)  # True Negatives

    precision = TP / (TP + FP) if (TP + FP) > 0 else 0
    recall = TP / (TP + FN) if (TP + FN) > 0 else 0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0
    accuracy = (TP + TN) / len(results) if len(results) > 0 else 0

    # s*(p) distribution for primes with minimum
    s_opt_primes = [results[n]['s_opt'] for n in primes_with_min]

    stats = {
        'TP': TP,
        'FN': FN,
        'FP': FP,
        'TN': TN,
        'precision': precision,
        'recall': recall,
        'f1_score': f1,
        'accuracy': accuracy,
        'primes_with_min': primes_with_min,
        'primes_without_min': primes_without_min,
        'composites_with_min': composites_with_min,
        'composites_without_min': composites_without_min,
        's_opt_primes_mean': np.mean(s_opt_primes) if s_opt_primes else None,
        's_opt_primes_std': np.std(s_opt_primes) if s_opt_primes else None,
        's_opt_primes_median': np.median(s_opt_primes) if s_opt_primes else None,
    }

    return stats


# ============================================================================
# VISUALIZATION
# ============================================================================

def plot_scatter(results: Dict, output_file: str):
    """Scatter plot: n vs. s*(n), color-coded by primality"""

    # Separate by type
    primes_with_min = [(n, results[n]['s_opt']) for n in results
                      if results[n]['is_prime'] and results[n]['has_minimum']]
    composites_with_min = [(n, results[n]['s_opt']) for n in results
                          if not results[n]['is_prime'] and results[n]['has_minimum']]

    fig, ax = plt.subplots(figsize=(12, 7))

    if primes_with_min:
        n_p, s_p = zip(*primes_with_min)
        ax.scatter(n_p, s_p, c='red', s=30, alpha=0.6, label=f'Primes with U-shape ({len(n_p)})')

    if composites_with_min:
        n_c, s_c = zip(*composites_with_min)
        ax.scatter(n_c, s_c, c='blue', s=20, alpha=0.4, label=f'Composites with U-shape ({len(n_c)})')

    ax.set_xlabel('n', fontsize=12)
    ax.set_ylabel('$s^*(n)$ [optimal exponent]', fontsize=12)
    ax.set_title('Optimal Exponent Distribution\n(only n with U-shape shown)', fontsize=14)
    ax.legend(fontsize=11)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"✓ Saved: {output_file}")
    plt.close()


def plot_heatmap(results: Dict, n_sample: int, s_range: np.ndarray,
                alpha: float, output_file: str):
    """Heatmap: F_n(s) in (n, s) space"""

    # Sample n values (evenly spaced)
    n_values = sorted(results.keys())
    step = max(1, len(n_values) // n_sample)
    n_sampled = n_values[::step][:n_sample]

    print(f"Computing heatmap for {len(n_sampled)} values of n...")

    # Compute F_n(s) grid
    grid = np.zeros((len(n_sampled), len(s_range)))

    for i, n in enumerate(n_sampled):
        if i % 10 == 0:
            print(f"  Row {i}/{len(n_sampled)}", end="\r")
        for j, s in enumerate(s_range):
            grid[i, j] = compute_F_n(n, s, alpha)

    print(" " * 50, end="\r")
    print(f"✓ Computed {grid.size} grid points")

    # Plot
    fig, ax = plt.subplots(figsize=(14, 8))

    im = ax.imshow(grid, aspect='auto', origin='lower', cmap='viridis',
                  extent=[s_range[0], s_range[-1], n_sampled[0], n_sampled[-1]])

    # Mark primes with red horizontal lines
    prime_ns = [n for n in n_sampled if is_prime(n)]
    for p in prime_ns:
        ax.axhline(y=p, color='red', alpha=0.3, linewidth=0.5)

    ax.set_xlabel('s (exponent)', fontsize=12)
    ax.set_ylabel('n', fontsize=12)
    ax.set_title(f'$F_n(s)$ Heatmap\n(red lines = primes)', fontsize=14)

    cbar = plt.colorbar(im, ax=ax)
    cbar.set_label('$F_n(s)$', fontsize=11)

    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"✓ Saved: {output_file}")
    plt.close()


def plot_distributions(results: Dict, stats: Dict, output_file: str):
    """Distribution plots for s*(p)"""

    s_opt_primes = [results[n]['s_opt'] for n in stats['primes_with_min']]

    if not s_opt_primes:
        print("⚠ No primes with U-shape found, skipping distribution plot")
        return

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

    # Histogram
    ax1.hist(s_opt_primes, bins=30, color='red', alpha=0.7, edgecolor='black')
    ax1.axvline(np.mean(s_opt_primes), color='blue', linestyle='--',
               linewidth=2, label=f'Mean = {np.mean(s_opt_primes):.2f}')
    ax1.axvline(np.median(s_opt_primes), color='green', linestyle='--',
               linewidth=2, label=f'Median = {np.median(s_opt_primes):.2f}')
    ax1.set_xlabel('$s^*(p)$', fontsize=12)
    ax1.set_ylabel('Count', fontsize=12)
    ax1.set_title('Distribution of Optimal Exponents for Primes', fontsize=13)
    ax1.legend(fontsize=11)
    ax1.grid(True, alpha=0.3)

    # s*(p) vs. p
    primes_sorted = sorted(stats['primes_with_min'])
    s_vals = [results[p]['s_opt'] for p in primes_sorted]

    ax2.scatter(primes_sorted, s_vals, c='red', s=30, alpha=0.6)
    ax2.set_xlabel('Prime p', fontsize=12)
    ax2.set_ylabel('$s^*(p)$', fontsize=12)
    ax2.set_title('Optimal Exponent vs. Prime Size', fontsize=13)
    ax2.grid(True, alpha=0.3)

    # Trend line
    if len(primes_sorted) > 1:
        z = np.polyfit(primes_sorted, s_vals, 1)
        p = np.poly1d(z)
        ax2.plot(primes_sorted, p(primes_sorted), "b--", alpha=0.5,
                label=f'Linear fit: slope={z[0]:.4f}')
        ax2.legend(fontsize=10)

    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"✓ Saved: {output_file}")
    plt.close()


# ============================================================================
# MAIN
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("SYSTEMATIC ANALYSIS: OPTIMAL EXPONENTS s*(n)")
    print("=" * 70)
    print()
    print("Hypothesis: n is prime ⟺ F_n(s) has U-shape (local minimum)")
    print()

    # Parameters
    n_min = 2
    n_max = 300  # Start with smaller range for speed
    alpha = 7.0

    # Step 1: Analyze range
    results = analyze_range(n_min, n_max, alpha)
    print()

    # Step 2: Compute statistics
    print("=" * 70)
    print("STATISTICAL ANALYSIS")
    print("=" * 70)
    print()

    stats = compute_statistics(results)

    print(f"Total analyzed: {len(results)}")
    print(f"  Primes: {stats['TP'] + stats['FN']}")
    print(f"  Composites: {stats['FP'] + stats['TN']}")
    print()

    print("Confusion Matrix:")
    print(f"  True Positives (primes WITH U-shape): {stats['TP']}")
    print(f"  False Negatives (primes WITHOUT U-shape): {stats['FN']}")
    print(f"  False Positives (composites WITH U-shape): {stats['FP']}")
    print(f"  True Negatives (composites WITHOUT U-shape): {stats['TN']}")
    print()

    print("Metrics:")
    print(f"  Precision: {stats['precision']:.3f}")
    print(f"  Recall: {stats['recall']:.3f}")
    print(f"  F1 Score: {stats['f1_score']:.3f}")
    print(f"  Accuracy: {stats['accuracy']:.3f}")
    print()

    if stats['s_opt_primes_mean']:
        print("s*(p) distribution for primes with U-shape:")
        print(f"  Mean: {stats['s_opt_primes_mean']:.3f}")
        print(f"  Median: {stats['s_opt_primes_median']:.3f}")
        print(f"  Std dev: {stats['s_opt_primes_std']:.3f}")
        print()

    # Step 3: Report exceptions
    print("=" * 70)
    print("EXCEPTIONS")
    print("=" * 70)
    print()

    if stats['FN'] > 0:
        print(f"⚠ False Negatives ({stats['FN']} primes WITHOUT U-shape):")
        print(f"  {stats['primes_without_min'][:20]}")
        if stats['FN'] > 20:
            print(f"  ... and {stats['FN'] - 20} more")
    else:
        print("✓ No false negatives!")
    print()

    if stats['FP'] > 0:
        print(f"⚠ False Positives ({stats['FP']} composites WITH U-shape):")
        print(f"  {stats['composites_with_min'][:20]}")
        if stats['FP'] > 20:
            print(f"  ... and {stats['FP'] - 20} more")
    else:
        print("✓ No false positives!")
    print()

    # Step 4: Visualizations
    print("=" * 70)
    print("GENERATING VISUALIZATIONS")
    print("=" * 70)
    print()

    plot_scatter(results, "visualizations/optimal-exponents-scatter.pdf")
    plot_distributions(results, stats, "visualizations/optimal-exponents-distribution.pdf")

    # Heatmap (smaller sample for speed)
    s_range_heatmap = np.linspace(0.8, 4.0, 40)
    plot_heatmap(results, n_sample=50, s_range=s_range_heatmap, alpha=alpha,
                output_file="visualizations/optimal-exponents-heatmap.pdf")

    # Step 5: Summary
    print()
    print("=" * 70)
    print("SUMMARY")
    print("=" * 70)
    print()

    if stats['recall'] > 0.95:
        print("✓ STRONG SUPPORT for U-shape ⟹ prime (high recall)")
    elif stats['recall'] > 0.8:
        print("⚠ MODERATE SUPPORT for U-shape ⟹ prime (some exceptions)")
    else:
        print("✗ WEAK SUPPORT for U-shape ⟹ prime (many exceptions)")

    if stats['precision'] > 0.95:
        print("✓ STRONG SUPPORT for prime ⟹ U-shape (high precision)")
    elif stats['precision'] > 0.8:
        print("⚠ MODERATE SUPPORT for prime ⟹ U-shape (some false positives)")
    else:
        print("✗ WEAK SUPPORT for prime ⟹ U-shape (many false positives)")

    print()
    print(f"Hypothesis 'U-shape ⟺ prime' has F1 score: {stats['f1_score']:.3f}")
    print()
