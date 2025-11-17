#!/usr/bin/env python3
"""
CRITICAL TEST: Is Wildberger path length same as CF period?

If YES: All our findings are trivial (just restating CF theory)
If NO: Wildberger has unique structure (interesting!)
"""

import math
import sys


def pellsol(d):
    """Wildberger algorithm"""
    a, b, c = 1, 0, -d
    u, v, r, s = 1, 0, 0, 1
    path = []

    while True:
        t = a + b + b + c
        if t > 0:
            path.append("R")
            a = t
            b += c
            u += v
            r += s
        else:
            path.append("L")
            b += a
            c = t
            v += u
            s += r

        if a == 1 and b == 0 and c == -d:
            break

    return (u, r), "".join(path), len(path)


def continued_fraction_sqrt(d, max_terms=1000):
    """Compute continued fraction of √d"""
    if int(math.sqrt(d))**2 == d:
        return None  # Perfect square

    m, d_val, a = 0, 1, int(math.sqrt(d))
    a0 = a
    cf = [a0]

    seen = {}
    while True:
        key = (m, d_val, a)
        if key in seen:
            period_start = seen[key]
            return a0, cf[period_start:], len(cf) - period_start
        seen[key] = len(cf) - 1

        m = d_val * a - m
        d_val = (d - m * m) // d_val
        a = (a0 + m) // d_val
        cf.append(a)

        if len(cf) > max_terms:
            break

    return a0, cf[1:], len(cf) - 1


print("="*80)
print("CRITICAL TEST: Wildberger Path Length vs. Continued Fraction Period")
print("="*80)
print()

print(f"{'d':>4} {'Wild Path':>10} {'CF Period':>10} {'Equal?':>8} {'Ratio':>8} {'Path String'}")
print("-"*80)

equal_count = 0
total_count = 0
differences = []

for d in range(2, 101):
    # Skip perfect squares
    sqrt_d = int(math.sqrt(d))
    if sqrt_d * sqrt_d == d:
        continue

    # Wildberger
    sol, path_str, wild_len = pellsol(d)

    # CF period
    cf_result = continued_fraction_sqrt(d)
    if cf_result is None:
        continue

    a0, period, cf_len = cf_result

    # Compare
    equal = (wild_len == cf_len)
    ratio = wild_len / cf_len if cf_len > 0 else None

    if equal:
        equal_count += 1
    else:
        differences.append((d, wild_len, cf_len, ratio))

    total_count += 1

    # Print first 30 and any interesting cases
    if d <= 30 or not equal or wild_len > 20:
        path_display = path_str[:30] + ("..." if len(path_str) > 30 else "")
        print(f"{d:4d} {wild_len:10d} {cf_len:10d} {str(equal):>8} {ratio:>8.2f} {path_display}")

print()
print("="*80)
print("SUMMARY")
print("="*80)
print(f"Total comparisons: {total_count}")
print(f"Exact matches: {equal_count} ({100*equal_count/total_count:.1f}%)")
print(f"Differences: {len(differences)} ({100*len(differences)/total_count:.1f}%)")
print()

if differences:
    print("Cases where Wildberger ≠ CF Period:")
    print(f"{'d':>4} {'Wild':>6} {'CF':>6} {'Ratio':>8}")
    print("-"*30)
    for d, wild, cf, ratio in differences[:20]:
        print(f"{d:4d} {wild:6d} {cf:6d} {ratio:>8.2f}")
    if len(differences) > 20:
        print(f"... and {len(differences) - 20} more")
    print()

    # Analyze ratio pattern
    ratios = [r for _, _, _, r in differences]
    print(f"Ratio statistics:")
    print(f"  Mean ratio: {sum(ratios)/len(ratios):.3f}")
    print(f"  Min ratio:  {min(ratios):.3f}")
    print(f"  Max ratio:  {max(ratios):.3f}")
    print()

print("="*80)
print("INTERPRETATION")
print("="*80)

if equal_count == total_count:
    print("✓ RESULT: Wildberger path length = CF period (ALWAYS)")
    print()
    print("CONCLUSION: Our 'findings' are TRIVIAL!")
    print("  - Prime/composite difference → just CF period behavior")
    print("  - M(d) correlation → already known in CF literature")
    print("  - No novel structure in Wildberger algorithm")
    print()
    print("ACTION: Check CF literature for divisor/period connection")
elif equal_count > 0.9 * total_count:
    print("⚠ RESULT: Wildberger path ≈ CF period (mostly equal)")
    print()
    print(f"CONCLUSION: {len(differences)} exceptions ({100*len(differences)/total_count:.1f}%)")
    print("  - Need to investigate why these differ")
    print("  - Pattern may still be trivial")
elif equal_count > 0:
    print("◐ RESULT: Wildberger path ~ CF period (correlated but not equal)")
    print()
    print("CONCLUSION: Systematic relationship but with variation")
    print("  - Ratio pattern suggests deeper structure")
    print("  - Wildberger captures additional information")
    print("  - Worth investigating further!")
else:
    print("✗ RESULT: Wildberger path ≠ CF period (INDEPENDENT)")
    print()
    print("CONCLUSION: Wildberger has UNIQUE structure!")
    print("  - Not just restating CF theory")
    print("  - Path length measures different complexity")
    print("  - Genuinely interesting finding!")

print()
print("="*80)
