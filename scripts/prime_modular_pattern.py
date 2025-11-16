#!/usr/bin/env python3
"""
Find pattern in Egypt modular property for PRIMES only.

Data so far:
  p=2: k ≡ 0 (mod 2)
  p=3: k ≡ 0 (mod 6)
  p=5: k ≡ 0 (mod 10)
  p=7: ALL k work!

Hypotheses to test:
  1. k ≡ 0 (mod 2p) for p > 2?
  2. Related to CF period of √p?
  3. Related to (x-1) mod p?
"""

import math

# Pell solutions for primes
pell_primes = {
    2: (3, 2),
    3: (2, 1),
    5: (9, 4),
    7: (8, 3),
    11: (10, 3),
    13: (649, 180),
    17: (33, 8),
    19: (170, 39),
    23: (24, 5),
}

def cf_period(n):
    """Compute continued fraction period of √n."""
    if int(n**0.5)**2 == n:
        return None  # perfect square

    a0 = int(n**0.5)

    m, d, a = 0, 1, a0
    period = []
    seen = {}

    while True:
        m = d * a - m
        d = (n - m * m) // d
        a = (a0 + m) // d

        state = (m, d)
        if state in seen:
            break

        seen[state] = len(period)
        period.append(a)

        if len(period) > 100:
            break

    return period


print("="*80)
print("PATTERN SEARCH: Egypt Modular Property for PRIMES")
print("="*80)
print()

# Observed moduli from previous test
observed = {
    2: 2,    # k ≡ 0 (mod 2)
    3: 6,    # k ≡ 0 (mod 6)
    5: 10,   # k ≡ 0 (mod 10)
    7: 1,    # ALL k (mod 1 = always)
}

print("Observed moduli:")
print("-" * 80)
for p in sorted(observed.keys()):
    print(f"p={p}: k ≡ 0 (mod {observed[p]})")
print()

# Compute additional properties
print("Analysis:")
print("-" * 80)
print(f"{'p':<4} {'x':<6} {'y':<6} {'x-1':<6} {'(x-1)%p':<8} {'period':<15} {'mod':<6} {'mod/p':<8} {'mod/(2p)':<10}")
print("-" * 80)

for p in sorted(observed.keys()):
    x, y = pell_primes[p]
    xm1 = x - 1
    xm1_mod_p = xm1 % p

    period = cf_period(p)
    period_len = len(period) if period else None

    mod = observed[p]

    ratio_p = mod / p if p != 0 else None
    ratio_2p = mod / (2*p) if p != 0 else None

    print(f"{p:<4} {x:<6} {y:<6} {xm1:<6} {xm1_mod_p:<8} {str(period_len):<15} {mod:<6} {ratio_p:<8.2f} {ratio_2p:<10.2f}")

print()

# Test hypotheses
print("="*80)
print("HYPOTHESIS TESTING")
print("="*80)
print()

print("Hypothesis 1: mod = 2p (for p > 2)")
print("-" * 80)
for p in sorted(observed.keys()):
    if p == 2:
        continue
    predicted = 2 * p
    actual = observed[p]
    match = "✓" if predicted == actual else "✗"
    print(f"p={p}: predicted={predicted}, actual={actual} {match}")
print()

print("Hypothesis 2: mod = period × something")
print("-" * 80)
for p in sorted(observed.keys()):
    period = cf_period(p)
    period_len = len(period) if period else None
    actual = observed[p]

    if period_len:
        ratio = actual / period_len
        print(f"p={p}: period_len={period_len}, mod={actual}, ratio={ratio:.2f}")
    else:
        print(f"p={p}: period=None")
print()

print("Hypothesis 3: Related to (x-1) mod p")
print("-" * 80)
for p in sorted(observed.keys()):
    x, y = pell_primes[p]
    xm1_mod = (x-1) % p
    actual = observed[p]

    # Special case: if (x-1) ≡ 0 (mod p), then ALL k work
    if xm1_mod == 0:
        print(f"p={p}: (x-1)≡0 (mod p) → ALL k work ✓")
    else:
        print(f"p={p}: (x-1)≡{xm1_mod} (mod p), mod={actual}")
print()

# Look for p=7 pattern in other primes
print("="*80)
print("SPECIAL CASE: When does (x-1) ≡ 0 (mod p)?")
print("="*80)
print()

for p in sorted(pell_primes.keys()):
    x, y = pell_primes[p]
    xm1_mod = (x-1) % p

    marker = "✓ SPECIAL!" if xm1_mod == 0 else ""
    print(f"p={p:2d}: x={x:4d}, (x-1)={x-1:4d}, (x-1) mod p = {xm1_mod:2d} {marker}")

print()

# Try to predict for other primes
print("="*80)
print("PREDICTIONS for untested primes")
print("="*80)
print()

print("Based on pattern: mod = 2p (for p>2, unless (x-1)≡0 (mod p))")
print()

for p in [11, 13, 17, 19, 23]:
    x, y = pell_primes[p]
    xm1_mod = (x-1) % p

    if xm1_mod == 0:
        prediction = "ALL k (special case)"
    else:
        prediction = f"k ≡ 0 (mod {2*p})"

    print(f"p={p:2d}: Predicted: {prediction}")

print()
print("💡 CONJECTURE:")
print("   For prime p and Pell solution (x,y):")
print("     IF (x-1) ≡ 0 (mod p):")
print("       → Property holds for ALL k")
print("     ELSE:")
print("       → Property holds for k ≡ 0 (mod 2p)")
print()
print("   (Special case p=2: mod 2, not mod 4)")
