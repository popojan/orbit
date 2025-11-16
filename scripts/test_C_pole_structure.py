#!/usr/bin/env python3
"""
Test pole structure of C(s) at s=1
"""
import mpmath as mp

mp.dps = 50

def C_func(s, jmax):
    """C(s) = sum_{j=2}^{jmax} H_{j-1}(s) / j^s"""
    result = mp.mpf(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = sum(mp.power(k, -s) for k in range(1, j))
        result += H_j_minus_1 / mp.power(j, s)
    return result

print("=== Pole Structure of C(s) at s=1 ===")
print()
print("Testing: (s-1)^k · C(s) for k=0,1,2")
print()

jmax = 500

print(f"Using jmax={jmax}")
print()

for k_exp in range(1, 8):
    eps = mp.power(10, -k_exp)
    s = 1 + eps

    C_val = C_func(s, jmax)

    # Test different pole orders
    test0 = C_val                    # k=0: just C(s)
    test1 = eps * C_val              # k=1: (s-1) · C(s)
    test2 = eps**2 * C_val           # k=2: (s-1)² · C(s)

    print(f"eps = 10^-{k_exp}:")
    print(f"  C(s)           = {mp.nstr(test0, 12)}")
    print(f"  (s-1)·C(s)     = {mp.nstr(test1, 12)}")
    print(f"  (s-1)²·C(s)    = {mp.nstr(test2, 12)}")
    print()

print("=== Interpretation ===")
print()
print("If (s-1)²·C(s) → constant ≠ 0:  C has double pole")
print("If (s-1)·C(s) → constant ≠ 0:   C has simple pole")
print("If C(s) → constant:             C is analytic at s=1")
print("If C(s) → ∞:                    C diverges at s=1 (series doesn't converge)")
