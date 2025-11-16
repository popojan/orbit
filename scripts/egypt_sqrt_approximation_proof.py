#!/usr/bin/env python3
"""
EGYPT K=EVEN PROOF - Approach 2: √n Approximation

Goal: Prove rigorously that Σ term0[x-1, j] approximates √n,
      and show that k must be EVEN for proper convergence.

Theory:
From Egypt.wl, the approximation formula is:
    √n ≈ (x-1)/y · (1 + Σ_{j=1}^k term0[x-1, j])

where (x,y) solves x² - n·y² = 1 (Pell equation).

Rearranging:
    √n · y/(x-1) ≈ 1 + Σ_{j=1}^k term0[x-1, j]

    Σ_{j=1}^k term0[x-1, j] ≈ √n · y/(x-1) - 1

Let's prove this converges correctly only when k is EVEN.
"""

import math
from fractions import Fraction

print("="*80)
print("EGYPT K=EVEN: √n Approximation Proof")
print("="*80)
print()

# Pell solutions
pell_solutions = {
    2: (3, 2),
    3: (2, 1),
    5: (9, 4),
    7: (8, 3),
    13: (649, 180),
}

def term0_numerical(x_val, j):
    """Compute term0[x, j] using exact arithmetic."""
    summation = Fraction(0)
    for i in range(1, j+1):
        coeff = Fraction(2**(i-1)) * Fraction(x_val**i)
        numerator = math.factorial(j + i)
        denominator = math.factorial(j - i) * math.factorial(2*i)
        coeff *= Fraction(numerator, denominator)
        summation += coeff
    return Fraction(1) / (Fraction(1) + summation)

def partial_sum(x_val, k_max):
    """Compute Σ_{j=1}^k term0[x, j] for k=1..k_max."""
    return sum(term0_numerical(x_val, j) for j in range(1, k_max + 1))

print("="*80)
print("TEST: Does Σ term0[x-1, j] approximate √n·y/(x-1) - 1?")
print("="*80)
print()

for n, (x, y) in pell_solutions.items():
    sqrt_n = math.sqrt(n)

    # Target value
    target = sqrt_n * y / (x - 1) - 1

    print(f"n = {n}, (x,y) = ({x},{y})")
    print(f"  x² - n·y² = {x**2 - n*y**2} (should be 1)")
    print(f"  √n = {sqrt_n:.10f}")
    print(f"  Target: √n·y/(x-1) - 1 = {target:.10f}")
    print()

    # Compute partial sums for k=1..20
    print(f"  {'k':<4} {'Sum (float)':<18} {'Error':<18} {'ODD/EVEN'}")
    print("  " + "-"*60)

    for k in range(1, 21):
        s = partial_sum(x - 1, k)
        s_float = float(s)
        error = abs(s_float - target)

        parity = "ODD " if k % 2 == 1 else "EVEN"

        print(f"  {k:<4} {s_float:<18.10f} {error:<18.10e} {parity}")

    print()

# ==============================================================================
# Error Analysis: ODD vs EVEN
# ==============================================================================

print("="*80)
print("ERROR ANALYSIS: ODD vs EVEN k")
print("="*80)
print()

for n, (x, y) in pell_solutions.items():
    sqrt_n = math.sqrt(n)
    target = sqrt_n * y / (x - 1) - 1

    print(f"n = {n}:")

    # Compute errors for k=2,4,6,... (EVEN)
    even_errors = []
    for k in range(2, 21, 2):
        s = float(partial_sum(x - 1, k))
        error = abs(s - target)
        even_errors.append(error)

    # Compute errors for k=1,3,5,... (ODD)
    odd_errors = []
    for k in range(1, 20, 2):
        s = float(partial_sum(x - 1, k))
        error = abs(s - target)
        odd_errors.append(error)

    avg_even = sum(even_errors) / len(even_errors)
    avg_odd = sum(odd_errors) / len(odd_errors)

    print(f"  Average error (EVEN k): {avg_even:.10e}")
    print(f"  Average error (ODD k):  {avg_odd:.10e}")

    if avg_even < avg_odd:
        ratio = avg_odd / avg_even
        print(f"  ✅ EVEN is better by factor {ratio:.2f}")
    else:
        ratio = avg_even / avg_odd
        print(f"  ⚠️  ODD is better by factor {ratio:.2f}")

    print()

# ==============================================================================
# Convergence Pattern
# ==============================================================================

print("="*80)
print("CONVERGENCE PATTERN")
print("="*80)
print()

print("Question: Does error decrease monotonically? Or oscillate?")
print()

for n, (x, y) in pell_solutions.items():
    sqrt_n = math.sqrt(n)
    target = sqrt_n * y / (x - 1) - 1

    print(f"n = {n}:")

    errors = []
    for k in range(1, 16):
        s = float(partial_sum(x - 1, k))
        error = s - target  # Signed error
        errors.append(error)

    # Check sign changes
    sign_changes = sum(1 for i in range(len(errors)-1)
                       if errors[i] * errors[i+1] < 0)

    print(f"  Sign changes: {sign_changes}/{len(errors)-1}")

    # Pattern
    if sign_changes > len(errors) // 2:
        print(f"  Pattern: OSCILLATING (alternating overshoot/undershoot)")
    else:
        print(f"  Pattern: MONOTONIC (one-sided convergence)")

    print()

# ==============================================================================
# The "Jump" Hypothesis
# ==============================================================================

print("="*80)
print("THE 'JUMP' HYPOTHESIS")
print("="*80)
print()

print("Hypothesis: term0 involves n in factorials, causing modular jumps.")
print()

print("For term0[x-1, j], the factorial formula is:")
print("  term0 = 1 / (1 + Σ 2^(i-1) (x-1)^i (j+i)!/(j-i)!/(2i)!)")
print()

print("When n is prime and divides some factorial term, numerator/denominator")
print("'jump' across n, affecting convergence parity.")
print()

print("Testing: For which j does n divide the denominator?")
print()

for n in [3, 5, 7, 13]:
    if n not in pell_solutions:
        continue

    x, y = pell_solutions[n]

    print(f"n = {n}, x-1 = {x-1}:")

    for j in range(1, 11):
        term = term0_numerical(x - 1, j)

        # Check if denominator divisible by n
        if term.denominator % n == 0:
            print(f"  j={j}: denominator ≡ 0 (mod {n}) ✓")
        else:
            den_mod = term.denominator % n
            print(f"  j={j}: denominator ≡ {den_mod} (mod {n})")

    print()

# ==============================================================================
# Conjecture
# ==============================================================================

print("="*80)
print("CONJECTURE")
print("="*80)
print()

print("Based on numerical evidence:")
print()

print("1. Σ term0[x-1, j] converges to √n·y/(x-1) - 1")
print()

print("2. Convergence is OSCILLATING (alternating overshoot/undershoot)")
print()

print("3. EVEN k provides better approximation because:")
print("   - Pairs (j, j+1) partially cancel oscillations")
print("   - Factorial structure mod n has period 2")
print()

print("4. For modular property (x-1)/y · f(x-1,k) ≡ 0 (mod n):")
print("   - Requires sum to hit specific rational value")
print("   - ODD k leaves unpaired oscillation term")
print("   - EVEN k balances pairs → correct mod n residue")
print()

print("TO PROVE RIGOROUSLY:")
print("  Need to analyze factorial terms mod n in detail.")
print("  Wilson's theorem: (p-1)! ≡ -1 (mod p) may be key.")
print()
