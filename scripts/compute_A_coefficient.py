#!/usr/bin/env python3
"""
Compute coefficient A of double pole in L_M(s) at s=1
Using closed form: L_M(s) = ζ(s)[ζ(s)-1] - C(s)
"""
import mpmath as mp

mp.dps = 50  # 50 decimal places precision

def M(n):
    """Childhood function M(n) = floor((tau(n)-1)/2)"""
    tau = mp.nint(sum(1 for k in range(1, n+1) if n % k == 0))
    return int((tau - 1) // 2)

def C_func(s, jmax):
    """
    C(s) = sum_{j=2}^{jmax} H_{j-1}(s) / j^s
    where H_j(s) = sum_{k=1}^j k^{-s}
    """
    result = mp.mpf(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = sum(mp.power(k, -s) for k in range(1, j))
        result += H_j_minus_1 / mp.power(j, s)
    return result

def L_M_closed(s, jmax=500):
    """L_M(s) via closed form"""
    zeta_s = mp.zeta(s)
    C_s = C_func(s, jmax)
    return zeta_s * (zeta_s - 1) - C_s

print("=== Computing A via Closed Form (Python/mpmath) ===")
print("")
print("L_M(s) = ζ(s)[ζ(s)-1] - C(s)")
print("A = lim_{s->1} (s-1)² · L_M(s)")
print("")

print("Testing with different jmax for C(s):")
print("")

# Test s = 2 first (should converge)
s_test = mp.mpf(2)
for jmax in [100, 200, 500]:
    L_val = L_M_closed(s_test, jmax)
    print(f"s=2, jmax={jmax:4d}: L_M(2) = {mp.nstr(L_val, 15)}")

print("")
print("Computing (s-1)² · L_M(s) near s=1:")
print("")

jmax = 500  # Fixed jmax for remainder of computation

for k in range(1, 8):
    eps = mp.power(10, -k)
    s = 1 + eps

    L_val = L_M_closed(s, jmax)
    coeff = eps**2 * L_val

    print(f"eps = 10^-{k}: (s-1)² · L_M(s) = {mp.nstr(coeff, 20)}")

print("")
print("Pattern analysis:")
print("If values converge to constant A ≠ 0: double pole with coefficient A")
print("If values → 0: pole order < 2 OR computation issue")
print("If values → ∞: pole order > 2")
