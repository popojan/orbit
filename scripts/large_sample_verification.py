#!/usr/bin/env python3
"""
Large sample verification of x₀ mod 8 patterns.

Test 100+ primes in each mod 8 class to:
1. Confirm patterns hold at scale
2. Find any counterexamples
3. Gather statistics for rigorous proof
"""

import math

def is_prime(n):
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

def v2(n):
    """2-adic valuation."""
    if n == 0:
        return float('inf')
    k = 0
    while n % 2 == 0:
        k += 1
        n //= 2
    return k

def cf_sqrt(D, max_iter=10000):
    """Compute continued fraction expansion of √D."""
    a0 = int(math.sqrt(D))
    if a0 * a0 == D:
        return None

    seen = {}
    period = []
    m, d, a = 0, 1, a0

    for k in range(max_iter):
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d
        state = (m, d)
        if state in seen:
            return {'a0': a0, 'period': period[seen[state]:], 'n': len(period[seen[state]:])}
        seen[state] = len(period)
        period.append(a)

    return None  # Period not found

def convergent(a0, period, k):
    """Compute k-th convergent."""
    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1

    for i in range(k):
        a_k = period[i % len(period)]
        p_next = a_k * p_curr + p_prev
        q_next = a_k * q_curr + q_prev
        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

    return p_curr, q_curr

def fundamental_unit(p, timeout_k=10000):
    """Compute fundamental Pell solution (x₀, y₀)."""
    cf = cf_sqrt(p, max_iter=timeout_k)
    if cf is None:
        return None

    n = cf['n']

    x1, y1 = convergent(cf['a0'], cf['period'], n-1)
    norm1 = x1**2 - p * y1**2

    if norm1 == 1:
        return x1, y1
    elif norm1 == -1:
        x0 = x1**2 + p * y1**2
        y0 = 2 * x1 * y1
        return x0, y0
    else:
        x0, y0 = convergent(cf['a0'], cf['period'], min(2*n-1, timeout_k))
        if x0**2 - p * y0**2 == 1:
            return x0, y0
        else:
            return None

# ============================================================================
# Large Sample Test
# ============================================================================

print("="*80)
print("LARGE SAMPLE VERIFICATION: x₀ mod 8 PATTERNS")
print("="*80)
print()
print("Testing 100+ primes per mod 8 class...")
print()

# Collect large samples
samples = {1: [], 3: [], 7: []}
target_per_class = 100

for p in range(3, 10000):
    if not is_prime(p):
        continue

    mod8 = p % 8
    if mod8 in samples and len(samples[mod8]) < target_per_class:
        samples[mod8].append(p)

    # Check if we've collected enough
    if all(len(v) >= target_per_class for v in samples.values()):
        break

print(f"Collected samples:")
for mod8_class in [1, 3, 7]:
    print(f"  p ≡ {mod8_class} (mod 8): {len(samples[mod8_class])} primes")
print()

# Verify patterns
print("="*80)
print("VERIFICATION RESULTS")
print("="*80)
print()

for mod8_class in [1, 3, 7]:
    primes = samples[mod8_class]

    print(f"p ≡ {mod8_class} (mod 8) ({len(primes)} primes tested)")
    print("-"*80)

    # Pattern expectations
    if mod8_class == 1:
        expected_x0_mod8 = 1
        expected_y0_parity = "even"
    elif mod8_class == 3:
        expected_x0_mod8 = 2
        expected_y0_parity = "odd"
    elif mod8_class == 7:
        expected_x0_mod8 = 0
        expected_y0_parity = "odd"

    # Statistics
    x0_mod8_counts = {}
    x0_mod16_counts = {}
    y0_parity_counts = {"even": 0, "odd": 0}
    x0_modp_counts = {"+1": 0, "-1": 0, "other": 0}
    v2_x0_counts = {}
    v2_y0_counts = {}
    period_mod4_counts = {}
    failures = []
    timeouts = []

    for p in primes:
        try:
            result = fundamental_unit(p, timeout_k=5000)
            if result is None:
                timeouts.append(p)
                continue

            x0, y0 = result

            # Verify solution
            if x0**2 - p*y0**2 != 1:
                failures.append((p, "invalid solution"))
                continue

            # Gather statistics
            x0_mod8 = x0 % 8
            x0_mod16 = x0 % 16
            x0_modp = x0 % p
            y0_parity = "even" if y0 % 2 == 0 else "odd"

            x0_mod8_counts[x0_mod8] = x0_mod8_counts.get(x0_mod8, 0) + 1
            x0_mod16_counts[x0_mod16] = x0_mod16_counts.get(x0_mod16, 0) + 1
            y0_parity_counts[y0_parity] += 1

            if x0_modp == 1:
                x0_modp_counts["+1"] += 1
            elif x0_modp == p - 1:
                x0_modp_counts["-1"] += 1
            else:
                x0_modp_counts["other"] += 1
                failures.append((p, f"x₀ ≡ {x0_modp} (mod p)"))

            v2_x0 = v2(x0)
            v2_y0 = v2(y0)
            v2_x0_counts[v2_x0] = v2_x0_counts.get(v2_x0, 0) + 1
            v2_y0_counts[v2_y0] = v2_y0_counts.get(v2_y0, 0) + 1

            # Period
            cf = cf_sqrt(p)
            if cf:
                period_mod4 = cf['n'] % 4
                period_mod4_counts[period_mod4] = period_mod4_counts.get(period_mod4, 0) + 1

        except Exception as e:
            failures.append((p, str(e)))

    # Report
    successful = len(primes) - len(failures) - len(timeouts)

    print(f"Successfully tested: {successful}/{len(primes)}")
    print(f"Timeouts: {len(timeouts)}")
    print(f"Failures: {len(failures)}")
    print()

    print("x₀ mod 8 distribution:")
    for mod_val in sorted(x0_mod8_counts.keys()):
        count = x0_mod8_counts[mod_val]
        pct = 100.0 * count / successful if successful > 0 else 0
        print(f"  x₀ ≡ {mod_val} (mod 8): {count}/{successful} = {pct:.1f}%")
    print()

    print("x₀ mod 16 distribution:")
    for mod_val in sorted(x0_mod16_counts.keys()):
        count = x0_mod16_counts[mod_val]
        pct = 100.0 * count / successful if successful > 0 else 0
        print(f"  x₀ ≡ {mod_val:2d} (mod 16): {count}/{successful} = {pct:.1f}%")
    print()

    print("y₀ parity:")
    for parity in ["even", "odd"]:
        count = y0_parity_counts[parity]
        pct = 100.0 * count / successful if successful > 0 else 0
        print(f"  y₀ {parity}: {count}/{successful} = {pct:.1f}%")
    print()

    print("x₀ mod p:")
    for sign in ["+1", "-1", "other"]:
        count = x0_modp_counts[sign]
        pct = 100.0 * count / successful if successful > 0 else 0
        print(f"  x₀ ≡ {sign:5s} (mod p): {count}/{successful} = {pct:.1f}%")
    print()

    print("v₂(x₀) distribution:")
    for val in sorted(v2_x0_counts.keys()):
        count = v2_x0_counts[val]
        pct = 100.0 * count / successful if successful > 0 else 0
        print(f"  v₂(x₀) = {val}: {count}/{successful} = {pct:.1f}%")
    print()

    print("Period mod 4:")
    for val in sorted(period_mod4_counts.keys()):
        count = period_mod4_counts[val]
        pct = 100.0 * count / successful if successful > 0 else 0
        print(f"  period ≡ {val} (mod 4): {count}/{successful} = {pct:.1f}%")
    print()

    if failures:
        print(f"FAILURES ({len(failures)}):")
        for p, reason in failures[:10]:  # Show first 10
            print(f"  p={p}: {reason}")
        if len(failures) > 10:
            print(f"  ... and {len(failures) - 10} more")
        print()

    print("="*80)
    print()

print("="*80)
print("SUMMARY")
print("="*80)
print()
print("Pattern verification:")
print("  p ≡ 1 (mod 8) → x₀ ≡ 1 (mod 16), y₀ even: [See above]")
print("  p ≡ 3 (mod 8) → x₀ ≡ 2 (mod 4), y₀ odd: [See above]")
print("  p ≡ 7 (mod 8) → x₀ ≡ 0 (mod 8), y₀ odd: [See above]")
print()
print("Any counterexamples found? [See FAILURES sections]")
