#!/usr/bin/env python3
"""
Consistency check for grand unification.

If Pell, L_M, Forest are "the same object", their constants should relate somehow.

Test: Does 2γ-1 ≈ 0.1544 appear in Pell statistics?
"""

import numpy as np
import math

# Euler-Mascheroni constant
EULER_GAMMA = 0.5772156649015329

# L_M residue constant
B_CONSTANT = 2 * EULER_GAMMA - 1
print(f"2γ - 1 = {B_CONSTANT:.10f}")
print()

# From earlier session: Pell statistics
# We found M(D) anticorrelates with R(D)

# Hypothesis: Maybe 2γ-1 relates to AVERAGE log-regulator?

# Sample Pell regulators (from earlier tests)
pell_data = {
    13: (649, 180),   # R = log(649 + 180*sqrt(13))
    61: (29718, 3805),
    109: (8890182, 851525),
    181: (2469645423824185, 183461899603),
    277: (None, None),  # Large
}

def regulator(x, y, D):
    """Compute regulator R(D) = log(x + y*sqrt(D))"""
    return math.log(x + y * math.sqrt(D))

print("Pell regulators:")
print("-" * 50)
for D, (x, y) in pell_data.items():
    if x is None:
        continue
    R = regulator(x, y, D)
    print(f"D={D:3d}: R = {R:8.4f}, R/log(D) = {R/math.log(D):.4f}")

print()

# Check: Does average R/log(D) relate to 2γ-1?
valid_data = [(D, x, y) for D, (x, y) in pell_data.items() if x is not None]
R_values = [regulator(x, y, D) for D, x, y in valid_data]
D_values = [D for D, x, y in valid_data]

normalized_R = [R / math.log(D) for R, D in zip(R_values, D_values)]

print(f"Mean R/log(D) = {np.mean(normalized_R):.4f}")
print(f"2γ - 1        = {B_CONSTANT:.4f}")
print()

if abs(np.mean(normalized_R) - B_CONSTANT) < 0.1:
    print("✓ POSSIBLE CONNECTION!")
else:
    print("✗ NO OBVIOUS CONNECTION")

print()
print("=" * 50)
print("CONTRADICTION CHECK:")
print("=" * 50)

# Contradiction 1: Discreteness
print("\n1. DISCRETENESS MISMATCH:")
print(f"   Pell residuals: discrete (±1, ±4, ±9, ...)")
print(f"   L_M constant:   continuous (2γ-1 = {B_CONSTANT:.4f})")
print(f"   → Are these reconcilable?")

# Contradiction 2: Growth rates
print("\n2. GROWTH RATE MISMATCH:")
print(f"   Pell regulator: R(D) grows ~ period ~ sqrt(D)?")
print(f"   L_M pole:       Fixed value 2γ-1")
print(f"   → Why doesn't L_M constant grow?")

# Contradiction 3: Modular values
print("\n3. MODULAR VALUE MISMATCH:")
print(f"   HalfFactorialMod[p] ∈ {{±1, ±i}} (mod p)")
print(f"   2γ-1 ≈ 0.1544 (real constant)")
print(f"   → How do ±1, ±i relate to 0.1544?")

print("\n" + "=" * 50)
print("FALSIFICATION TESTS:")
print("=" * 50)

# If unification is real, predict:
# - M(D) should predict L_M behavior
# - Pell residuals should relate to 2γ-1

print("\nPrediction 1: M(D) distribution")
print("   If M(n) counts divisors ≤ √n, average M(n) ~ ???")
print("   Does this average relate to 2γ-1?")

# Compute average M(n) for n ≤ 100
def M(n):
    """M(n) = number of divisors d where 2 <= d <= sqrt(n)"""
    if n < 4:
        return 0
    sqrt_n = int(n**0.5)
    count = 0
    for d in range(2, sqrt_n + 1):
        if n % d == 0:
            count += 1
    return count

N_MAX = 1000
M_values = [M(n) for n in range(1, N_MAX + 1)]
avg_M = np.mean(M_values)

print(f"\n   Average M(n) for n ≤ {N_MAX}: {avg_M:.4f}")
print(f"   2γ - 1 = {B_CONSTANT:.4f}")
print(f"   Ratio: {avg_M / B_CONSTANT:.4f}")

if abs(avg_M - B_CONSTANT) < 0.1:
    print("   ✓ MATCH!")
else:
    print("   ✗ NO MATCH")

print("\nPrediction 2: Pell residual statistics")
print("   Small Pell residuals (|R| ≤ 5) are rare")
print("   If R appears in fundamental solution, it encodes arithmetic")

# Distribution of Pell residuals for small D
residuals = []
for D in range(2, 100):
    # Skip perfect squares
    if int(D**0.5)**2 == D:
        continue
    # Fundamental Pell residual is always ±1 by definition!
    # So this doesn't make sense...
    pass

print("   WAIT: Fundamental Pell residual is ALWAYS ±1!")
print("   This is the DEFINITION of Pell equation solution.")
print("   → Can't have statistics here!")

print("\n   💡 INSIGHT: Pell residual is MINIMIZED (=1)")
print("      Convergent residuals R_k vary, but x₀² - D·y₀² = 1 exactly")

print("\n" + "=" * 50)
print("CONCLUSION:")
print("=" * 50)

print("\n❓ POTENTIAL CONTRADICTIONS FOUND:")
print("   1. Discrete (Pell ±1) vs continuous (2γ-1)")
print("   2. Growing (R(D)) vs fixed (2γ-1)")
print("   3. Modular (±1, ±i) vs real (0.1544)")

print("\n💡 POSSIBLE RESOLUTIONS:")
print("   - Different SCALES of same phenomenon")
print("   - 2γ-1 = AVERAGE or LIMIT of discrete values")
print("   - Modular values project to real via ???")

print("\n🔬 VERDICT: Unification is NON-TRIVIAL")
print("   Not obviously contradictory, but requires deeper math")
print("   to reconcile discrete ↔ continuous")
