#!/usr/bin/env python3
"""
Generate synthetic data from FOPDT (First-Order Plus Dead Time) system

This script demonstrates the Python approach to system simulation.
Compare with the Wolfram version (01_generate_synthetic_data.wl) to see
the difference in complexity and expressiveness.
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import os

print("=== Synthetic System Data Generation ===\n")

# System parameters - typical industrial process (e.g., temperature control)
K = 2.0      # DC gain
tau = 0.5    # Dead time [s]
T = 3.0      # Time constant [s]

print(f"True system (unknown to identification):")
print(f"G(s) = {K} * exp(-{tau}*s) / ({T}*s + 1)")
print()

# Create transfer function (scipy doesn't support delay directly in tf)
# We'll use Pade approximation for delay: exp(-tau*s) ≈ Pade(n, m)
num_delay, den_delay = signal.pade(tau, 2)  # 2nd order Pade approximation

# First-order system: K / (T*s + 1)
num_fopdt = K * num_delay
den_fopdt = np.convolve([T, 1], den_delay)

# Create system
sys = signal.TransferFunction(num_fopdt, den_fopdt)

print("NOTE: Python/scipy requires Pade approximation for delay!")
print(f"  Approximating exp(-{tau}*s) with 2nd-order Pade rational function")
print(f"  This introduces approximation error (unlike symbolic Wolfram)\n")

# Time vector
dt = 0.1  # Sampling time [s]
t_max = 20.0  # Simulation time [s]
t = np.arange(0, t_max + dt, dt)

# Step response
t_step, y_clean = signal.step(sys, T=t)

# Add measurement noise (±5% of final value)
np.random.seed(42)  # Reproducible
noise_level = 0.05 * K
noise = np.random.normal(0, noise_level, len(y_clean))
y_noisy = y_clean + noise

# Input signal (step at t=0)
u_input = np.ones_like(t)

print(f"Generated {len(t)} samples from t=0 to t={t_max} s")
print(f"Sampling time: {dt} s")
print(f"Noise level: ±{noise_level:.3f} (±5% of steady-state)")
print()

# Create data directory
os.makedirs("control-theory/data", exist_ok=True)

# Export to CSV
data_file = "control-theory/data/synthetic_step_response.csv"
data = np.column_stack([t, u_input, y_clean, y_noisy])
np.savetxt(
    data_file,
    data,
    delimiter=',',
    header='time,input,output_clean,output_noisy',
    comments=''
)
print(f"Data exported to: {data_file}")
print()

# Visualization
print("Generating plot...")
os.makedirs("control-theory/visualizations", exist_ok=True)

plt.figure(figsize=(10, 6))
plt.plot(t, y_clean, 'b-', linewidth=2, label='True response (no noise)')
plt.plot(t, y_noisy, 'r.', markersize=3, alpha=0.5, label='Measured (with noise)')
plt.xlabel('Time [s]', fontsize=12)
plt.ylabel('Output', fontsize=12)
plt.title('Step Response: FOPDT System', fontsize=14)
plt.legend(fontsize=10)
plt.grid(True, alpha=0.3)
plt.tight_layout()

plot_file = "control-theory/visualizations/step_response.png"
plt.savefig(plot_file, dpi=150)
print(f"Plot saved to: {plot_file}")
print()

# Summary statistics
print("=== Summary ===")
print(f"Steady-state value: {K}")
print(f"Time to reach 63.2% (1 time constant): {tau + T} s")
print(f"Time to reach 95%: {tau + 3*T} s")
print()

print("✓ Synthetic data generation complete!")
print()

# Comparison note
print("=" * 60)
print("PYTHON vs. WOLFRAM comparison:")
print("=" * 60)
print("Python challenges:")
print("  - Pade approximation required (introduces error)")
print("  - Manual numpy array manipulation")
print("  - Verbose matplotlib setup")
print("  - No symbolic representation of delay")
print()
print("Wolfram advantages:")
print("  - Native delay support: Exp[-tau*s]")
print("  - Symbolic transfer functions")
print("  - One-liner plots: ListPlot[...]")
print("  - LaTeX export: TeXForm[G[s]]")
print("=" * 60)
