#!/usr/bin/env python3
"""
CRITICAL TEST: Is Wildberger path length just measuring solution size?

Question: Is path_length ~ log(x₀)?
If YES: We're just measuring regulator R(d) (well-studied, boring)
If NO: Path length has independent structure (interesting!)

Also tests residual variance after fitting Wild = α×CF + ε
"""

import math
import statistics


def pellsol(d):
    """Wildberger algorithm - returns solution and path length"""
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
    """Continued fraction period for √d"""
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


def correlation(xs, ys):
    """Pearson correlation"""
    n = len(xs)
    mean_x, mean_y = sum(xs)/n, sum(ys)/n
    num = sum((x - mean_x) * (y - mean_y) for x, y in zip(xs, ys))
    denom = math.sqrt(sum((x - mean_x)**2 for x in xs) * sum((y - mean_y)**2 for y in ys))
    return num / denom if denom != 0 else 0


print("="*80)
print("CRITICAL TEST: Solution Size vs Path Length Correlation")
print("="*80)
print()

# Collect data
data = []
for d in range(2, 301):
    if int(math.sqrt(d))**2 == d:
        continue

    sol, wild = pellsol(d)
    cf = cf_period(d)
    if cf is None or cf == 0:
        continue

    x0, y0 = sol
    log_x = math.log(x0)
    regulator = log_x + 0.5 * math.log(d)  # Approximation: R(d) ≈ log(x₀ + y₀√d) ≈ log(x₀) + 0.5*log(d)

    data.append({
        'd': d,
        'wild': wild,
        'cf': cf,
        'x0': x0,
        'y0': y0,
        'log_x': log_x,
        'regulator': regulator,
        'alpha': wild / cf
    })

print(f"Sample size: n = {len(data)}")
print()

# Extract arrays
wilds = [item['wild'] for item in data]
cfs = [item['cf'] for item in data]
log_xs = [item['log_x'] for item in data]
regulators = [item['regulator'] for item in data]
alphas = [item['alpha'] for item in data]

# ============================================================================
# TEST 1: Is path length just measuring solution size?
# ============================================================================
print("="*80)
print("TEST 1: PATH LENGTH vs SOLUTION SIZE")
print("="*80)

corr_wild_logx = correlation(wilds, log_xs)
corr_cf_logx = correlation(cfs, log_xs)
corr_wild_reg = correlation(wilds, regulators)

print(f"Correlation Wild path vs log(x₀):     {corr_wild_logx:>7.4f}")
print(f"Correlation CF period vs log(x₀):     {corr_cf_logx:>7.4f}")
print(f"Correlation Wild path vs R(d):        {corr_wild_reg:>7.4f}")
print()

if abs(corr_wild_logx) > 0.8:
    print("❌ HIGH CORRELATION: Wild path is just measuring solution size!")
    print("   → This means we're NOT discovering anything new")
    print("   → Path length ≈ function of regulator R(d)")
elif abs(corr_wild_logx) > 0.5:
    print("⚠️  MODERATE CORRELATION: Path length partially determined by x₀")
    print("   → But there's additional structure beyond solution size")
elif abs(corr_wild_logx) > 0.3:
    print("◐ WEAK CORRELATION: Some connection to solution size")
    print("   → But path length has significant independent structure")
else:
    print("✅ LOW CORRELATION: Path length is INDEPENDENT of solution size!")
    print("   → This is genuinely interesting!")
print()

# Compare CF vs Wild correlation with log(x₀)
print("Which is more correlated with solution size?")
print(f"  Wild - log(x₀) correlation: {abs(corr_wild_logx):.4f}")
print(f"  CF - log(x₀) correlation:   {abs(corr_cf_logx):.4f}")
if abs(corr_wild_logx) > abs(corr_cf_logx) + 0.1:
    print("  → Wild is MORE correlated than CF (Wildberger adds size dependence)")
elif abs(corr_cf_logx) > abs(corr_wild_logx) + 0.1:
    print("  → CF is MORE correlated than Wild (surprising!)")
else:
    print("  → Similar correlation (both measure similar complexity)")
print()

# ============================================================================
# TEST 2: Residual variance after fitting Wild = α × CF
# ============================================================================
print("="*80)
print("TEST 2: RESIDUAL ANALYSIS (Off-by-one test)")
print("="*80)

# Compute optimal α via least squares: α = Σ(Wild×CF) / Σ(CF²)
alpha_optimal = sum(w * c for w, c in zip(wilds, cfs)) / sum(c**2 for c in cfs)
print(f"Optimal scaling factor: α₀ = {alpha_optimal:.4f}")
print()

# Compute residuals: ε = Wild - α₀ × CF
residuals = [w - alpha_optimal * c for w, c in zip(wilds, cfs)]

mean_res = statistics.mean(residuals)
std_res = statistics.stdev(residuals)
abs_residuals = [abs(r) for r in residuals]
mean_abs_res = statistics.mean(abs_residuals)
max_abs_res = max(abs_residuals)

print(f"Residuals ε = Wild - {alpha_optimal:.3f}×CF:")
print(f"  Mean ε:        {mean_res:>8.3f}")
print(f"  Std dev ε:     {std_res:>8.3f}")
print(f"  Mean |ε|:      {mean_abs_res:>8.3f}")
print(f"  Max |ε|:       {max_abs_res:>8.3f}")
print()

# Key test: Is std(ε) ~ O(1)? (User's "off by one" hypothesis)
if std_res < 2.0:
    print("✅ EXCELLENT: std(ε) < 2 → Wild ≈ α×CF + O(1)")
    print("   → Wildberger path is ALMOST EXACTLY a constant multiple of CF period!")
    print("   → Only constant additive noise")
elif std_res < 5.0:
    print("✓ GOOD: std(ε) ~ O(1) → Wild ≈ α×CF with small deviations")
    print("   → Linear relationship with bounded noise")
elif std_res < 10.0:
    print("◐ MODERATE: std(ε) ~ O(1-10) → Some systematic deviation")
    print("   → Not perfectly linear, but close")
else:
    print("✗ LARGE: std(ε) >> 1 → Wild ≠ simple linear function of CF")
    print("   → Significant non-linear or additional structure")
print()

# Distribution of residuals
print("Residual distribution (how far off from α×CF?):")
print(f"  |ε| < 1:       {sum(1 for r in abs_residuals if r < 1):3d} ({100*sum(1 for r in abs_residuals if r < 1)/len(residuals):.1f}%)")
print(f"  |ε| < 2:       {sum(1 for r in abs_residuals if r < 2):3d} ({100*sum(1 for r in abs_residuals if r < 2)/len(residuals):.1f}%)")
print(f"  |ε| < 5:       {sum(1 for r in abs_residuals if r < 5):3d} ({100*sum(1 for r in abs_residuals if r < 5)/len(residuals):.1f}%)")
print(f"  |ε| >= 5:      {sum(1 for r in abs_residuals if r >= 5):3d} ({100*sum(1 for r in abs_residuals if r >= 5)/len(residuals):.1f}%)")
print()

# Find worst outliers
outliers = [(data[i]['d'], residuals[i], wilds[i], cfs[i])
            for i in range(len(residuals))
            if abs(residuals[i]) > 2 * std_res]
if outliers:
    print(f"Outliers (|ε| > 2σ = {2*std_res:.2f}):")
    for d, eps, w, c in sorted(outliers, key=lambda x: abs(x[1]), reverse=True)[:10]:
        print(f"  d={d:3d}: ε={eps:>6.2f}, Wild={w:3d}, CF={c:2d}, Wild/CF={w/c:.2f}")
    print()

# ============================================================================
# TEST 3: Correlation matrix
# ============================================================================
print("="*80)
print("TEST 3: CORRELATION MATRIX")
print("="*80)
print()

variables = {
    'Wild': wilds,
    'CF': cfs,
    'log(x₀)': log_xs,
    'R(d)': regulators,
    'α': alphas
}

print("       ", "  ".join(f"{name:>8s}" for name in variables.keys()))
print("-" * 60)
for name1, vals1 in variables.items():
    corrs = []
    for name2, vals2 in variables.items():
        c = correlation(vals1, vals2)
        corrs.append(f"{c:>8.4f}")
    print(f"{name1:>7s}  " + "  ".join(corrs))
print()

# ============================================================================
# FINAL VERDICT
# ============================================================================
print("="*80)
print("FINAL VERDICT")
print("="*80)
print()

score = 0

# Factor 1: Independence from solution size
if abs(corr_wild_logx) < 0.3:
    score += 2
    print("✅ Path length INDEPENDENT of solution size (exciting!)")
elif abs(corr_wild_logx) < 0.6:
    score += 1
    print("◐ Path length WEAKLY depends on solution size")
else:
    print("❌ Path length STRONGLY depends on solution size (boring)")

# Factor 2: Residual variance
if std_res < 2.0:
    score += 2
    print("✅ Wild ≈ α×CF + O(1) with VERY small noise")
elif std_res < 5.0:
    score += 1
    print("◐ Wild ≈ α×CF + O(1) with moderate noise")
else:
    print("❌ Wild ≠ simple linear function of CF")

# Factor 3: α variance meaningful
cv_alpha = statistics.stdev(alphas) / statistics.mean(alphas)
if cv_alpha > 0.3:
    score += 1
    print(f"✓ α(d) has HIGH variance (CV={cv_alpha:.3f}) - interesting pattern")
elif cv_alpha > 0.1:
    print(f"◐ α(d) has MODERATE variance (CV={cv_alpha:.3f})")
else:
    print(f"✗ α(d) has LOW variance (CV={cv_alpha:.3f}) - mostly constant")

print()
print(f"SCORE: {score}/5")
print()

if score >= 4:
    print("🎉 VERDICT: Path length has GENUINE independent structure!")
    print("   → NOT just restating solution size")
    print("   → Wild ≈ α(d)×CF where α(d) varies meaningfully")
    print("   → Worth investigating what determines α(d)")
elif score >= 2:
    print("🤔 VERDICT: Mixed results")
    print("   → Some independent structure, but partially tied to solution size")
    print("   → May still be interesting")
else:
    print("😐 VERDICT: Probably just measuring known quantities")
    print("   → Path length ≈ function of solution size")
    print("   → Not discovering anything new")

print()
print("="*80)
