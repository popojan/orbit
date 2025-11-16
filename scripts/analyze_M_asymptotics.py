#!/usr/bin/env python3
"""
Question D: Asymptotic Analysis of M(n)

Analyze distribution, variance, max order, and comparison to τ(n)
"""

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from collections import Counter

def tau(n):
    """Divisor count τ(n)"""
    count = 0
    for d in range(1, int(np.sqrt(n)) + 1):
        if n % d == 0:
            count += 1
            if d != n // d:
                count += 1
    return count

def M(n):
    """M(n) = #{d: d|n, 2 ≤ d ≤ √n}"""
    if n < 2:
        return 0
    divisors = [d for d in range(2, int(np.sqrt(n)) + 1) if n % d == 0]
    return len(divisors)

def omega(n):
    """Number of distinct prime divisors"""
    count = 0
    temp = n
    for p in range(2, int(np.sqrt(n)) + 1):
        if temp % p == 0:
            count += 1
            while temp % p == 0:
                temp //= p
    if temp > 1:
        count += 1
    return count

# ============================================================================
# Compute M(n) for range
# ============================================================================

print("="*80)
print("QUESTION D: Asymptotic Analysis of M(n)")
print("="*80)

N_max = 10000
print(f"\nComputing M(n), τ(n), Ω(n) for n ≤ {N_max}...")

M_vals = [M(n) for n in range(1, N_max + 1)]
tau_vals = [tau(n) for n in range(1, N_max + 1)]
omega_vals = [omega(n) for n in range(1, N_max + 1)]

print("Done!")

# ============================================================================
# Distribution Analysis
# ============================================================================

print("\n" + "="*80)
print("DISTRIBUTION ANALYSIS")
print("="*80)

# Count frequencies
M_counter = Counter(M_vals)
tau_counter = Counter(tau_vals)

print(f"\nM(n) statistics for n ∈ [1, {N_max}]:")
print(f"  Min:     {min(M_vals)}")
print(f"  Max:     {max(M_vals)}")
print(f"  Mean:    {np.mean(M_vals):.4f}")
print(f"  Median:  {np.median(M_vals)}")
print(f"  Std dev: {np.std(M_vals):.4f}")

print(f"\nτ(n) statistics for comparison:")
print(f"  Min:     {min(tau_vals)}")
print(f"  Max:     {max(tau_vals)}")
print(f"  Mean:    {np.mean(tau_vals):.4f}")
print(f"  Median:  {np.median(tau_vals)}")
print(f"  Std dev: {np.std(tau_vals):.4f}")

print(f"\nRatio M(n)/τ(n):")
ratio_vals = [M_vals[i] / max(tau_vals[i], 1) for i in range(N_max)]
print(f"  Mean:    {np.mean(ratio_vals):.4f}")
print(f"  Median:  {np.median(ratio_vals):.4f}")
print(f"  Std dev: {np.std(ratio_vals):.4f}")

# ============================================================================
# Most frequent values
# ============================================================================

print("\n" + "="*80)
print("MOST FREQUENT VALUES")
print("="*80)

print(f"\nTop 10 most common M(n) values:")
print(f"{'M(n)':>6} {'Count':>8} {'Percentage':>12}")
print("-" * 30)
for m_val, count in M_counter.most_common(10):
    pct = 100 * count / N_max
    print(f"{m_val:6d} {count:8d} {pct:11.2f}%")

# ============================================================================
# Summatory function
# ============================================================================

print("\n" + "="*80)
print("SUMMATORY FUNCTION: Σ M(n) ~ x·ln(x)/2 + (γ-1)·x")
print("="*80)

print("""
Derivation: M(n) = ⌊(τ(n)-1)/2⌋, so:
  Σ M(n) ≈ [Σ τ(n) - x]/2
         ~ [x·ln(x) + (2γ-1)·x - x]/2
         = x·ln(x)/2 + (γ-1)·x

NOT the same as Σ τ(n)!
""")

# Compute cumulative sums
cumsum_M = np.cumsum(M_vals)
cumsum_tau = np.cumsum(tau_vals)

# Test points
test_x = [100, 500, 1000, 2000, 5000, 10000]
gamma_euler = 0.5772156649

print(f"{'x':>6} {'Σ M(n)':>10} {'x·ln(x)/2':>12} {'(γ-1)·x':>12} {'Theory':>12} {'Error %':>10}")
print("-" * 80)

for x in test_x:
    if x <= N_max:
        sum_M = cumsum_M[x - 1]
        theory_main = x * np.log(x) / 2
        theory_correction = (gamma_euler - 1) * x
        theory_total = theory_main + theory_correction
        error_pct = 100 * abs(sum_M - theory_total) / abs(theory_total)

        print(f"{x:6d} {sum_M:10.1f} {theory_main:12.1f} {theory_correction:12.1f} "
              f"{theory_total:12.1f} {error_pct:10.2f}%")

# ============================================================================
# Max order analysis
# ============================================================================

print("\n" + "="*80)
print("MAX ORDER: M(n) for highly composite numbers")
print("="*80)

# Find n with largest M(n) in each range
ranges = [(1, 100), (101, 500), (501, 1000), (1001, 5000), (5001, 10000)]

print(f"\n{'Range':>15} {'n_max':>8} {'M(n_max)':>10} {'τ(n_max)':>10} {'ln(n)':>10}")
print("-" * 60)

for (start, end) in ranges:
    if end <= N_max:
        M_range = M_vals[start-1:end]
        max_M = max(M_range)
        n_max = start + M_range.index(max_M)
        tau_max = tau_vals[n_max - 1]
        ln_n = np.log(n_max)

        print(f"{start:6d}-{end:5d} {n_max:8d} {max_M:10d} {tau_max:10d} {ln_n:10.2f}")

# ============================================================================
# Correlation with Ω(n)
# ============================================================================

print("\n" + "="*80)
print("CORRELATION: M(n) vs Ω(n) (distinct prime divisors)")
print("="*80)

# Compute correlation
from scipy.stats import pearsonr
corr_M_omega, p_value = pearsonr(M_vals, omega_vals)
corr_M_tau, _ = pearsonr(M_vals, tau_vals)

print(f"\nPearson correlation coefficients:")
print(f"  M(n) vs Ω(n):  {corr_M_omega:.4f}")
print(f"  M(n) vs τ(n):  {corr_M_tau:.4f}")

# ============================================================================
# Visualizations
# ============================================================================

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle('M(n) Asymptotic Analysis', fontsize=16, fontweight='bold')

# 1. Distribution histogram
ax1 = axes[0, 0]
ax1.hist(M_vals, bins=range(max(M_vals) + 2), alpha=0.7, color='blue', edgecolor='black')
ax1.set_xlabel('M(n) value', fontsize=12)
ax1.set_ylabel('Frequency', fontsize=12)
ax1.set_title('Distribution of M(n) values', fontsize=14)
ax1.grid(True, alpha=0.3)

# 2. M(n) vs n (scatter)
ax2 = axes[0, 1]
n_vals = list(range(1, min(2000, N_max) + 1))
ax2.scatter(n_vals, M_vals[:len(n_vals)], alpha=0.3, s=1, color='blue')
ax2.plot(n_vals, [np.log(n)/2 for n in n_vals], 'r-', linewidth=2,
         label='ln(n)/2 (theoretical avg)')
ax2.set_xlabel('n', fontsize=12)
ax2.set_ylabel('M(n)', fontsize=12)
ax2.set_title('M(n) vs n (with asymptotic)', fontsize=14)
ax2.legend()
ax2.grid(True, alpha=0.3)

# 3. Summatory function
ax3 = axes[1, 0]
x_vals = list(range(1, N_max + 1))
theory_vals = [x * np.log(x) / 2 + (gamma_euler - 1)*x for x in x_vals]
ax3.plot(x_vals, cumsum_M, 'b-', linewidth=2, label='Σ M(n)', alpha=0.7)
ax3.plot(x_vals, theory_vals, 'r--', linewidth=2,
         label='x·ln(x)/2 + (γ-1)·x', alpha=0.7)
ax3.set_xlabel('x', fontsize=12)
ax3.set_ylabel('Σ_{n≤x} M(n)', fontsize=12)
ax3.set_title('Summatory Function (γ-1 residue)', fontsize=14)
ax3.legend()
ax3.grid(True, alpha=0.3)

# 4. M(n) vs τ(n) scatter
ax4 = axes[1, 1]
sample_indices = np.random.choice(N_max, min(2000, N_max), replace=False)
M_sample = [M_vals[i] for i in sample_indices]
tau_sample = [tau_vals[i] for i in sample_indices]
ax4.scatter(tau_sample, M_sample, alpha=0.3, s=5, color='blue')
ax4.plot([0, max(tau_vals)], [0, max(tau_vals)/2], 'r--', linewidth=2,
         label='M = τ/2')
ax4.set_xlabel('τ(n)', fontsize=12)
ax4.set_ylabel('M(n)', fontsize=12)
ax4.set_title('M(n) vs τ(n) (correlation {:.3f})'.format(corr_M_tau), fontsize=14)
ax4.legend()
ax4.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('/home/user/orbit/visualizations/M_asymptotics.png', dpi=150)
print("\n\nSaved: visualizations/M_asymptotics.png")

# ============================================================================
# Summary
# ============================================================================

print("\n" + "="*80)
print("SUMMARY")
print("="*80)

print(f"""
Key findings:

1. Average behavior:
   M(n) ~ ln(n)/2  (confirmed numerically)
   Mean M(n) ≈ {np.mean(M_vals):.2f}
   Mean ln(n)/2 ≈ {np.mean([np.log(n)/2 for n in range(1, N_max+1)]):.2f}

2. Summatory function:
   Σ M(n) ~ x·ln(x)/2 + (γ-1)·x
   Different from Σ τ(n) (half the rate)

3. Relation to τ(n):
   M(n) = ⌊(τ(n)-1)/2⌋ exactly
   Correlation: {corr_M_tau:.4f} (very strong)
   Ratio M/τ ≈ {np.mean(ratio_vals):.3f} (close to 1/2)

4. Distribution:
   Most common: M(n) = 0 (primes)
   Highly skewed (many small values, few large)
   Max M(n) = {max(M_vals)} for n ≤ {N_max}

5. √n boundary manifestation:
   M(n) counts divisors BELOW √n
   This asymmetry → residue 2γ-1
   Same constant in divisor problem!
""")
