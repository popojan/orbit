#!/usr/bin/env python3
"""Simple alpha variance analysis (pure Python, no dependencies)"""

import math
import statistics


def pellsol(d):
    a, b, c = 1, 0, -d
    u, v, r, s = 1, 0, 0, 1
    path_len = 0
    while True:
        t = a + b + b + c
        if t > 0:
            a = t; b += c; u += v; r += s
        else:
            b += a; c = t; v += u; s += r
        path_len += 1
        if a == 1 and b == 0 and c == -d:
            break
    return (u, r), path_len


def cf_period(d):
    if int(math.sqrt(d))**2 == d:
        return None
    m, d_val, a = 0, 1, int(math.sqrt(d))
    a0, seen, period_len = a, {}, 0
    while True:
        key = (m, d_val, a)
        if key in seen:
            return period_len - seen[key]
        seen[key] = period_len
        m = d_val * a - m
        d_val = (d - m * m) // d_val
        a = (a0 + m) // d_val
        period_len += 1
        if period_len > 1000:
            break
    return period_len


def M_func(n):
    if n < 4:
        return 0
    return sum(1 for d in range(2, int(math.sqrt(n)) + 1) if n % d == 0)


def is_prime(n):
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    return all(n % i != 0 for i in range(3, int(math.sqrt(n)) + 1, 2))


def correlation(xs, ys):
    """Pearson correlation"""
    n = len(xs)
    mean_x, mean_y = sum(xs)/n, sum(ys)/n
    num = sum((x - mean_x) * (y - mean_y) for x, y in zip(xs, ys))
    denom = math.sqrt(sum((x - mean_x)**2 for x in xs) * sum((y - mean_y)**2 for y in ys))
    return num / denom if denom != 0 else 0


print("="*80)
print("ADVERSARIAL: Is α(d) = Wild/CF variance meaningful?")
print("="*80)
print()

# Collect data
data = []
for d in range(2, 201):
    if int(math.sqrt(d))**2 == d:
        continue
    sol, wild = pellsol(d)
    cf = cf_period(d)
    if cf is None or cf == 0:
        continue
    data.append({
        'd': d, 'wild': wild, 'cf': cf, 'alpha': wild/cf,
        'M': M_func(d), 'prime': is_prime(d)
    })

alphas = [d['alpha'] for d in data]
ds = [d['d'] for d in data]
Ms = [d['M'] for d in data]
primes = [d['prime'] for d in data]

print(f"Sample size: n = {len(data)}\n")

# Statistics
print("="*80)
print("VARIANCE ANALYSIS")
print("="*80)
mean_alpha = statistics.mean(alphas)
std_alpha = statistics.stdev(alphas)
cv = std_alpha / mean_alpha

print(f"α(d) statistics:")
print(f"  Mean:   {mean_alpha:.3f}")
print(f"  Median: {statistics.median(alphas):.3f}")
print(f"  Std:    {std_alpha:.3f}")
print(f"  Min:    {min(alphas):.3f}")
print(f"  Max:    {max(alphas):.3f}")
print(f"  Range:  {max(alphas) - min(alphas):.3f}")
print()
print(f"Coefficient of Variation: {cv:.3f}")
print(f"  Interpretation: {('HIGH (interesting!)' if cv > 0.3 else 'MODERATE' if cv > 0.1 else 'LOW (boring)')}")
print()

# Correlations
print("="*80)
print("CORRELATION TESTS")
print("="*80)

corr_d = correlation(ds, alphas)
corr_logd = correlation([math.log(d) for d in ds], alphas)
corr_M = correlation(Ms, alphas)

print(f"Correlation α vs d:      {corr_d:>6.3f}")
print(f"Correlation α vs log(d): {corr_logd:>6.3f}")
print(f"Correlation α vs M(d):   {corr_M:>6.3f}")
print()

# Prime vs composite
alpha_prime = [d['alpha'] for d in data if d['prime']]
alpha_comp = [d['alpha'] for d in data if not d['prime']]

print("="*80)
print("PRIME vs COMPOSITE")
print("="*80)
print(f"Primes:     mean α = {statistics.mean(alpha_prime):.3f}, std = {statistics.stdev(alpha_prime):.3f}")
print(f"Composites: mean α = {statistics.mean(alpha_comp):.3f}, std = {statistics.stdev(alpha_comp):.3f}")
print(f"Difference: {statistics.mean(alpha_prime) - statistics.mean(alpha_comp):.3f}")
print()

# By M(d)
print("="*80)
print("α(d) BY M(d) VALUE")
print("="*80)
for m_val in range(0, 6):
    alpha_m = [d['alpha'] for d in data if d['M'] == m_val]
    if alpha_m:
        print(f"M(d)={m_val}: n={len(alpha_m):3d}, mean α={statistics.mean(alpha_m):6.3f}, std={statistics.stdev(alpha_m) if len(alpha_m) > 1 else 0:6.3f}")
print()

# Verdict
print("="*80)
print("FINAL VERDICT")
print("="*80)
print()

score = 0
if cv > 0.3:
    score += 2; print("✓ HIGH CV: substantial variance")
elif cv > 0.1:
    score += 1; print("◐ MODERATE CV")
else:
    print("✗ LOW CV: mostly constant")

if abs(corr_M) > 0.3:
    score += 2; print("✓ CORRELATION: α ~ M(d)")
elif abs(corr_M) > 0.1:
    score += 1; print("◐ WEAK CORRELATION with M(d)")
else:
    print("✗ NO M(d) CORRELATION")

diff = statistics.mean(alpha_prime) - statistics.mean(alpha_comp)
if abs(diff) > 1.0:
    score += 1; print("✓ PRIME EFFECT: significant difference")
else:
    print("◐ NO PRIME EFFECT")

if abs(corr_d) < 0.3 and abs(corr_logd) < 0.3:
    score += 1; print("✓ INDEPENDENT of d")
else:
    print("⚠ WARNING: correlates with d")

print(f"\nVERDICT SCORE: {score}/6")
print()
if score >= 5:
    print("🎉 DEFINITELY INTERESTING!")
elif score >= 3:
    print("🤔 POSSIBLY INTERESTING")
else:
    print("😐 PROBABLY BORING")
print("\n" + "="*80)
