#!/usr/bin/env python3
"""
Generate synthetic data from FOPDT system - PURE PYTHON (no dependencies)

This demonstrates how painful it is to do control theory without specialized tools.
Compare with Wolfram's built-in capabilities!
"""

import math
import random
import os

print("=== Synthetic System Data Generation (Pure Python) ===\n")

# System parameters
K = 2.0
tau = 0.5
T = 3.0

print(f"True system (unknown to identification):")
print(f"G(s) = {K} * exp(-{tau}*s) / ({T}*s + 1)")
print()

# Step response for FOPDT: y(t) = K*(1 - exp(-(t-tau)/T)) for t >= tau
def step_response(t):
    if t < tau:
        return 0.0  # Dead time
    else:
        return K * (1 - math.exp(-(t - tau) / T))

# Time vector
dt = 0.1
t_max = 20.0
time_points = []
t = 0.0
while t <= t_max:
    time_points.append(t)
    t += dt

# Generate clean and noisy outputs
random.seed(42)
noise_level = 0.05 * K

data_rows = []
for t in time_points:
    y_clean = step_response(t)
    noise = random.gauss(0, noise_level)
    y_noisy = y_clean + noise
    u_input = 1.0
    data_rows.append([t, u_input, y_clean, y_noisy])

print(f"Generated {len(data_rows)} samples from t=0 to t={t_max} s")
print(f"Sampling time: {dt} s")
print(f"Noise level: ±{noise_level:.3f} (±5% of steady-state)")
print()

# Create directory
os.makedirs("control-theory/data", exist_ok=True)

# Export to CSV
data_file = "control-theory/data/synthetic_step_response.csv"
with open(data_file, 'w') as f:
    f.write("time,input,output_clean,output_noisy\n")
    for row in data_rows:
        f.write(f"{row[0]:.2f},{row[1]:.1f},{row[2]:.6f},{row[3]:.6f}\n")

print(f"Data exported to: {data_file}")
print()

# Summary
print("=== Summary ===")
print(f"Steady-state value: {K}")
print(f"Time to reach 63.2% (1 time constant): {tau + T} s")
print(f"Time to reach 95%: {tau + 3*T} s")
print()

print("✓ Synthetic data generation complete!")
print()

# Show first and last few samples
print("First 5 samples:")
print("time\tinput\toutput_clean\toutput_noisy")
for row in data_rows[:5]:
    print(f"{row[0]:.2f}\t{row[1]:.1f}\t{row[2]:.4f}\t\t{row[3]:.4f}")
print()
print("Last 5 samples:")
print("time\tinput\toutput_clean\toutput_noisy")
for row in data_rows[-5:]:
    print(f"{row[0]:.2f}\t{row[1]:.1f}\t{row[2]:.4f}\t\t{row[3]:.4f}")
print()

print("=" * 70)
print("NOTE: This pure Python approach demonstrates the pain without tools!")
print("=" * 70)
print("Challenges in pure Python:")
print("  ✗ No transfer function representation")
print("  ✗ No symbolic math (had to manually code step response formula)")
print("  ✗ No plotting (would need matplotlib)")
print("  ✗ Manual CSV writing")
print("  ✗ Manual noise generation")
print()
print("Wolfram Language advantages:")
print("  ✓ TransferFunctionModel[K*Exp[-tau*s]/(T*s+1), s]")
print("  ✓ OutputResponse[sys, UnitStep[t], t]")
print("  ✓ Automatic plotting: ListPlot[data]")
print("  ✓ Built-in Export[\"file.csv\", data]")
print("  ✓ RandomVariate[NormalDistribution[...]]")
print("=" * 70)
