#!/usr/bin/env python3
"""Quick test for s=2 only"""

from mpmath import mp

mp.dps = 30

def M(n):
    if n < 4:
        return 0
    count = 0
    sqrt_n = int(n**0.5) + 1
    for d in range(2, sqrt_n + 1):
        if d * d > n:
            break
        if n % d == 0:
            count += 1
    return count

print("Testing truncation error:")
print()

for nmax in [500, 1000, 2000, 5000]:
    s = 2
    result = sum(M(n) / n**s for n in range(1, nmax + 1))
    print(f"nmax = {nmax:5d}: L_M(2) ≈ {result:.15f}")

print()
print("If values still changing → truncation was the issue!")
