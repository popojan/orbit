#!/usr/bin/env python3
"""
ADVERSARIAL TEST: Is α(d) ratio meaningful or just noise?

Question: Wild = α × CF where α(d) varies [1.4, 18]
Is this interesting variation or trivial scaling + noise?
"""

import math
import statistics


def pellsol(d):
    """Wildberger algorithm"""
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


def continued_fraction_sqrt(d):
    """CF period"""
    if int(math.sqrt(d))**2 == d:
        return None

    m, d_val, a = 0, 1, int(math.sqrt(d))
    a0 = a
    seen = {}
    period_len = 0

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


def M_function(n):
    """Primal forest measure"""
    if n < 4:
        return 0
    count = 0
    for d in range(2, int(math.sqrt(n)) + 1):
        if n % d == 0:
            count += 1
    return count


def is_prime(n):
    """Primality test"""
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(math.sqrt(n)) + 1, 2):
        if n % i == 0:
            return False
    return True


print("="*80)
print("ADVERSARIAL: Is α(d) = Wild/CF variance meaningful?")
print("="*80)
print()

# Collect data
data = []
for d in range(2, 201):  # Extended to d=200
    sqrt_d = int(math.sqrt(d))
    if sqrt_d * sqrt_d == d:
        continue

    sol, wild = pellsol(d)
    cf = continued_fraction_sqrt(d)
    if cf is None or cf == 0:
        continue

    alpha = wild / cf
    data.append({
        'd': d,
        'wild': wild,
        'cf': cf,
        'alpha': alpha,
        'M': M_function(d),
        'is_prime': is_prime(d),
        'log_d': math.log(d),
        'log_x': math.log(sol[0])
    })

# Extract arrays
alphas = np.array([item['alpha'] for item in data])
ds = np.array([item['d'] for item in data])
Ms = np.array([item['M'] for item in data])
primes = np.array([item['is_prime'] for item in data])

print(f"Sample size: n = {len(data)}")
print()

# Basic statistics
print("="*80)
print("VARIANCE ANALYSIS")
print("="*80)
print(f"α(d) statistics:")
print(f"  Mean:   {np.mean(alphas):.3f}")
print(f"  Median: {np.median(alphas):.3f}")
print(f"  Std:    {np.std(alphas):.3f}")
print(f"  Min:    {np.min(alphas):.3f}")
print(f"  Max:    {np.max(alphas):.3f}")
print(f"  Range:  {np.max(alphas) - np.min(alphas):.3f}")
print()
print(f"Coefficient of Variation (CV): {np.std(alphas)/np.mean(alphas):.3f}")
print(f"  CV interpretation:")
print(f"    < 0.1 = low variance (boring)")
print(f"    0.1-0.3 = moderate variance")
print(f"    > 0.3 = high variance (interesting!)")
print()

cv = np.std(alphas) / np.mean(alphas)
if cv < 0.1:
    print("→ VERDICT: LOW variance - probably just scaling factor + noise")
elif cv < 0.3:
    print("→ VERDICT: MODERATE variance - worth investigating")
else:
    print("→ VERDICT: HIGH variance - definitely meaningful structure!")
print()

# Test: Is α(d) correlated with d itself?
print("="*80)
print("CORRELATION TESTS")
print("="*80)

corr_d = np.corrcoef(ds, alphas)[0, 1]
corr_logd = np.corrcoef([math.log(d) for d in ds], alphas)[0, 1]
corr_M = np.corrcoef(Ms, alphas)[0, 1]

print(f"Correlation α vs d:      {corr_d:>6.3f}")
print(f"Correlation α vs log(d): {corr_logd:>6.3f}")
print(f"Correlation α vs M(d):   {corr_M:>6.3f}")
print()

if abs(corr_d) > 0.5:
    print("⚠ WARNING: α strongly correlated with d - might be trivial growth!")
elif abs(corr_logd) > 0.5:
    print("⚠ WARNING: α strongly correlated with log(d) - logarithmic scaling!")
elif abs(corr_M) > 0.3:
    print("✓ INTERESTING: α correlated with M(d) - supports our hypothesis!")
else:
    print("? UNCLEAR: Low correlations - need deeper analysis")
print()

# Prime vs composite
print("="*80)
print("PRIME vs COMPOSITE ANALYSIS")
print("="*80)

alpha_prime = alphas[primes]
alpha_composite = alphas[~primes]

print(f"Primes:     mean α = {np.mean(alpha_prime):.3f}, std = {np.std(alpha_prime):.3f}")
print(f"Composites: mean α = {np.mean(alpha_composite):.3f}, std = {np.std(alpha_composite):.3f}")
print()

diff = np.mean(alpha_prime) - np.mean(alpha_composite)
print(f"Difference: {diff:.3f}")
if abs(diff) > 1.0:
    print("✓ SIGNIFICANT: Prime/composite affects α substantially")
else:
    print("✗ INSIGNIFICANT: Prime/composite doesn't affect α much")
print()

# Binning by M(d)
print("="*80)
print("α(d) BY M(d) VALUE")
print("="*80)

for m_val in range(0, 6):
    mask = Ms == m_val
    if np.sum(mask) > 0:
        alpha_m = alphas[mask]
        print(f"M(d)={m_val}: n={np.sum(mask):3d}, mean α={np.mean(alpha_m):6.3f}, std={np.std(alpha_m):6.3f}")
print()

# Check if α ~ 1/M relationship (inverse)
M_nonzero = Ms[Ms > 0]
alpha_nonzero = alphas[Ms > 0]
corr_inv = np.corrcoef(1.0/M_nonzero, alpha_nonzero)[0, 1]
print(f"Correlation α vs 1/M(d): {corr_inv:>6.3f}")
if abs(corr_inv) > 0.3:
    print("✓ INTERESTING: α ~ 1/M relationship detected!")
print()

# Extra correlation: α vs log(solution size)
print("="*80)
print("SOLUTION SIZE CORRELATION")
print("="*80)

log_xs = np.array([item['log_x'] for item in data])
corr_logx = np.corrcoef(log_xs, alphas)[0, 1]
print(f"Correlation α vs log(solution x): {corr_logx:>6.3f}")
if abs(corr_logx) > 0.5:
    print("⚠ WARNING: α correlates with solution size - might be size artifact")
else:
    print("✓ INDEPENDENT: α not determined by solution size")
print()

# Final verdict
print("="*80)
print("FINAL VERDICT")
print("="*80)
print()

verdict_score = 0

# Factor 1: Coefficient of variation
if cv > 0.3:
    verdict_score += 2
    print("✓ HIGH CV: α shows substantial relative variance")
elif cv > 0.1:
    verdict_score += 1
    print("◐ MODERATE CV: some variance, needs investigation")
else:
    print("✗ LOW CV: mostly constant scaling")

# Factor 2: Correlation with M
if abs(corr_M) > 0.3:
    verdict_score += 2
    print("✓ CORRELATION: α correlates with M(d) (our hypothesis!)")
elif abs(corr_M) > 0.1:
    verdict_score += 1
    print("◐ WEAK CORRELATION: some signal with M(d)")
else:
    print("✗ NO CORRELATION: α independent of M(d)")

# Factor 3: Prime/composite difference
if abs(diff) > 1.0:
    verdict_score += 1
    print("✓ PRIME EFFECT: α differs for primes vs composites")
else:
    print("◐ NO PRIME EFFECT: primality doesn't strongly affect α")

# Factor 4: NOT just d scaling
if abs(corr_d) < 0.3 and abs(corr_logd) < 0.3:
    verdict_score += 1
    print("✓ INDEPENDENT: α not trivially correlated with d")
else:
    print("⚠ WARNING: α correlates with d itself (less interesting)")

print()
print(f"VERDICT SCORE: {verdict_score}/6")
print()

if verdict_score >= 5:
    print("🎉 DEFINITELY INTERESTING: α(d) has meaningful structure!")
    print("   → Worth deep investigation")
    print("   → Likely encodes non-trivial mathematical property")
elif verdict_score >= 3:
    print("🤔 POSSIBLY INTERESTING: α(d) shows some structure")
    print("   → Worth further exploration")
    print("   → Need more tests to confirm significance")
else:
    print("😐 PROBABLY BORING: α(d) looks like noise/scaling")
    print("   → Might be trivial relationship")
    print("   → Consider other directions")

print()
print("="*80)
