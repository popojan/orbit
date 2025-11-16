#!/usr/bin/env python3
"""
PERIOD NORMALIZATION ATTACK

Fatal flaw from deep_skepticism.py:
  R(D) GROWS with D, but 2γ-1 is CONSTANT
  → They can't be "same object"

Hypothesis: Maybe R(D) / period(D) → constant?

If TRUE: This would SAVE grand unification! ✨
If FALSE: We know it's not period-based
"""

import math
import numpy as np

EULER_GAMMA = 0.5772156649015329
TARGET = 2 * EULER_GAMMA - 1  # 0.1544...

print("="*80)
print("PERIOD NORMALIZATION ATTACK")
print("="*80)
print(f"\nTarget constant: 2γ-1 = {TARGET:.10f}")
print()
print("Question: Does R(D) / period(D) → 2γ-1?")
print()

# Pell solutions
pell_data = {
    2: (3, 2),
    3: (2, 1),
    5: (9, 4),
    6: (5, 2),
    7: (8, 3),
    10: (19, 6),
    11: (10, 3),
    12: (7, 2),
    13: (649, 180),
    14: (15, 4),
    15: (4, 1),
    17: (33, 8),
    19: (170, 39),
    21: (55, 12),
    22: (197, 42),
    23: (24, 5),
}


def cf_period(D):
    """Compute continued fraction period of √D."""
    if int(D**0.5)**2 == D:
        return None

    a0 = int(D**0.5)
    m, d, a = 0, 1, a0
    period = []
    seen = {}

    while True:
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d

        state = (m, d)
        if state in seen:
            break

        seen[state] = len(period)
        period.append(a)

        if len(period) > 1000:
            break

    return period


def regulator(x, y, D):
    """Compute regulator R(D) = log(x + y√D)."""
    return math.log(x + y * math.sqrt(D))


# Compute for all D
print("Computing R(D), period(D), and normalized values...")
print("-" * 80)
print(f"{'D':<4} {'x':<8} {'y':<8} {'R(D)':<10} {'period':<8} {'R/period':<12} {'R/log(D)':<12}")
print("-" * 80)

results = []

for D in sorted(pell_data.keys()):
    x, y = pell_data[D]
    R = regulator(x, y, D)
    period = cf_period(D)
    period_len = len(period) if period else None

    if period_len:
        R_over_period = R / period_len
        R_over_log = R / math.log(D)

        results.append({
            'D': D,
            'R': R,
            'period': period_len,
            'R/period': R_over_period,
            'R/log': R_over_log,
        })

        print(f"{D:<4} {x:<8} {y:<8} {R:<10.4f} {period_len:<8} {R_over_period:<12.6f} {R_over_log:<12.6f}")

print()
print("="*80)
print("STATISTICAL ANALYSIS")
print("="*80)
print()

R_over_period_values = [r['R/period'] for r in results]
R_over_log_values = [r['R/log'] for r in results]

mean_R_period = np.mean(R_over_period_values)
std_R_period = np.std(R_over_period_values)
cv_R_period = std_R_period / mean_R_period  # coefficient of variation

mean_R_log = np.mean(R_over_log_values)
std_R_log = np.std(R_over_log_values)
cv_R_log = std_R_log / mean_R_log

print(f"R/period statistics:")
print(f"  Mean:   {mean_R_period:.6f}")
print(f"  Std:    {std_R_period:.6f}")
print(f"  CV:     {cv_R_period:.4f} ({cv_R_period*100:.1f}%)")
print()

print(f"R/log(D) statistics:")
print(f"  Mean:   {mean_R_log:.6f}")
print(f"  Std:    {std_R_log:.6f}")
print(f"  CV:     {cv_R_log:.4f} ({cv_R_log*100:.1f}%)")
print()

print(f"Target: 2γ-1 = {TARGET:.6f}")
print()

# Which is better?
error_period = abs(mean_R_period - TARGET)
error_log = abs(mean_R_log - TARGET)

print("Comparison:")
print(f"  |mean(R/period) - 2γ-1| = {error_period:.6f}")
print(f"  |mean(R/log) - 2γ-1|    = {error_log:.6f}")
print()

if error_period < error_log:
    print("✓ R/period is CLOSER to 2γ-1!")
    better = "period"
else:
    print("✓ R/log(D) is CLOSER to 2γ-1!")
    better = "log"

print()

# Test if constant
print("="*80)
print("IS IT CONSTANT?")
print("="*80)
print()

# A good constant should have CV < 10%
if cv_R_period < 0.10:
    print(f"✅ R/period is APPROXIMATELY CONSTANT (CV={cv_R_period*100:.1f}%)")
    print(f"   Value: {mean_R_period:.6f} ± {std_R_period:.6f}")
elif cv_R_period < 0.20:
    print(f"⚠️  R/period is ROUGHLY CONSTANT (CV={cv_R_period*100:.1f}%)")
    print(f"   Value: {mean_R_period:.6f} ± {std_R_period:.6f}")
else:
    print(f"❌ R/period is NOT CONSTANT (CV={cv_R_period*100:.1f}%)")
    print(f"   Too much variation: {mean_R_period:.6f} ± {std_R_period:.6f}")

print()

if cv_R_log < 0.10:
    print(f"✅ R/log(D) is APPROXIMATELY CONSTANT (CV={cv_R_log*100:.1f}%)")
    print(f"   Value: {mean_R_log:.6f} ± {std_R_log:.6f}")
elif cv_R_log < 0.20:
    print(f"⚠️  R/log(D) is ROUGHLY CONSTANT (CV={cv_R_log*100:.1f}%)")
    print(f"   Value: {mean_R_log:.6f} ± {std_R_log:.6f}")
else:
    print(f"❌ R/log(D) is NOT CONSTANT (CV={cv_R_log*100:.1f}%)")
    print(f"   Too much variation: {mean_R_log:.6f} ± {std_R_log:.6f}")

print()

# Does it equal 2γ-1?
print("="*80)
print("DOES IT EQUAL 2γ-1?")
print("="*80)
print()

# Tolerance: within 10%?
tolerance = 0.10

if abs(mean_R_period - TARGET) / TARGET < tolerance:
    print(f"✅ YES! R/period ≈ 2γ-1 (within {tolerance*100:.0f}%)")
    print(f"   {mean_R_period:.6f} vs {TARGET:.6f}")
    print(f"   Error: {(abs(mean_R_period - TARGET)/TARGET)*100:.1f}%")
    verdict = "BREAKTHROUGH"
elif abs(mean_R_log - TARGET) / TARGET < tolerance:
    print(f"✅ YES! R/log(D) ≈ 2γ-1 (within {tolerance*100:.0f}%)")
    print(f"   {mean_R_log:.6f} vs {TARGET:.6f}")
    print(f"   Error: {(abs(mean_R_log - TARGET)/TARGET)*100:.1f}%")
    verdict = "BREAKTHROUGH"
else:
    print(f"❌ NO. Neither equals 2γ-1 (tolerance {tolerance*100:.0f}%)")
    print(f"   R/period: {mean_R_period:.6f} vs {TARGET:.6f} (error: {(abs(mean_R_period-TARGET)/TARGET)*100:.1f}%)")
    print(f"   R/log(D): {mean_R_log:.6f} vs {TARGET:.6f} (error: {(abs(mean_R_log-TARGET)/TARGET)*100:.1f}%)")
    verdict = "FAILED"

print()

# Final verdict
print("="*80)
print("FINAL VERDICT")
print("="*80)
print()

if verdict == "BREAKTHROUGH":
    print("🎉 BREAKTHROUGH! Found normalization that works!")
    print()
    print(f"   R(D) / {better}(D) ≈ 2γ-1")
    print()
    print("This SAVES grand unification!")
    print("  - R(D) scales → BUT normalized version is constant")
    print("  - Matches L_M residue quantitatively")
    print("  - Resolves dimensional mismatch objection")
    print()
    print("Grand unification confidence: 35% → 80%+ 🚀")
else:
    print("❌ No simple normalization found.")
    print()
    print(f"Tried:")
    print(f"  - R/period: mean={mean_R_period:.4f}, target={TARGET:.4f} ✗")
    print(f"  - R/log(D): mean={mean_R_log:.4f}, target={TARGET:.4f} ✗")
    print()
    print("Grand unification remains wounded (35% confidence)")
    print()
    print("Next attempts:")
    print("  - R / √period?")
    print("  - R / (period × log(D))?")
    print("  - Something else entirely?")

print()
print("="*80)
