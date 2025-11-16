#!/usr/bin/env python3
"""
Analyze convergence pattern of (s-1)² · L_M(s)
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

def L_M_closed(s, jmax=500):
    """L_M(s) via closed form"""
    zeta_s = mp.zeta(s)
    C_s = C_func(s, jmax)
    return zeta_s * (zeta_s - 1) - C_s

print("=== Convergence Pattern Analysis ===")
print("")

# Collect data
data = []
for k in range(1, 10):
    eps = mp.power(10, -k)
    s = 1 + eps
    L_val = L_M_closed(s, jmax=500)
    coeff = eps**2 * L_val
    deviation = coeff - 1
    data.append((k, float(eps), float(coeff), float(deviation)))

print("| k | eps = 10^-k | (s-1)² · L_M(s) | Deviation from 1 | Dev/eps ratio |")
print("|---|-------------|-----------------|------------------|---------------|")

for i, (k, eps, coeff, dev) in enumerate(data):
    if i > 0:
        # Ratio of consecutive deviations
        ratio = data[i-1][3] / dev if dev != 0 else float('inf')
        # Deviation / eps
        dev_eps_ratio = dev / eps if eps != 0 else 0
        print(f"| {k} | 10^-{k} | {coeff:.10f} | {dev:+.4e} | {dev_eps_ratio:.4f} |")
    else:
        dev_eps_ratio = dev / eps if eps != 0 else 0
        print(f"| {k} | 10^-{k} | {coeff:.10f} | {dev:+.4e} | {dev_eps_ratio:.4f} |")

print("")
print("Pattern interpretation:")
print("- If Dev/eps ≈ constant: deviation is O(eps) → next order term is 1/(s-1)")
print("- If Dev/eps → 0: deviation shrinks faster → converging to exactly 1.0")
print("- If Dev/eps → constant C ≠ 0: A = 1, residue = C")
print("")

# Extrapolation
print("Extrapolating Dev/eps ratio:")
ratios = [data[i][3] / data[i][1] for i in range(3, 9)]  # Use k=4..9
print(f"Mean Dev/eps (k=4..9): {sum(ratios)/len(ratios):.6f}")
print(f"This suggests: (s-1)² · L_M(s) ≈ 1 + {sum(ratios)/len(ratios):.6f} · (s-1) + ...")
