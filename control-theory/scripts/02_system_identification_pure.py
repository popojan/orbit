#!/usr/bin/env python3
"""
System Identification from Step Response Data - PURE PYTHON

This demonstrates the challenge of fitting FOPDT model without scipy.optimize.
We'll use a simple grid search (brute force) instead of proper optimization.

Compare with Wolfram's NonlinearModelFit!
"""

import math
import csv

print("=== System Identification: FOPDT Model (Pure Python) ===\n")

# Load data
time = []
output_noisy = []

with open("control-theory/data/synthetic_step_response.csv", 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        time.append(float(row['time']))
        output_noisy.append(float(row['output_noisy']))

print(f"Loaded {len(time)} data points")
print()

# FOPDT step response model
def fopdt_step_response(t, K, tau, T):
    if t < tau:
        return 0.0
    else:
        return K * (1 - math.exp(-(t - tau) / T))

# Cost function (sum of squared errors)
def cost_function(params, time, output):
    K, tau, T = params
    total_error = 0.0
    for t, y_meas in zip(time, output):
        y_pred = fopdt_step_response(t, K, tau, T)
        total_error += (y_meas - y_pred) ** 2
    return total_error / len(time)  # MSE

print("Fitting FOPDT model: G(s) = K*exp(-tau*s)/(T*s+1)")
print("Using GRID SEARCH (pure Python has no optimizer!)")
print("This is VERY inefficient compared to Wolfram's NonlinearModelFit...")
print()

# Grid search over parameter space
# NOTE: This is inefficient! Real optimization needs scipy or similar.
K_range = [1.5, 1.7, 1.9, 2.0, 2.1, 2.3, 2.5]
tau_range = [0.3, 0.4, 0.5, 0.6, 0.7]
T_range = [2.0, 2.5, 3.0, 3.5, 4.0]

best_params = None
best_cost = float('inf')

total_iterations = len(K_range) * len(tau_range) * len(T_range)
iteration = 0

for K in K_range:
    for tau in tau_range:
        for T in T_range:
            iteration += 1
            if iteration % 10 == 0:
                print(f"  Progress: {iteration}/{total_iterations}", end='\r')

            cost = cost_function([K, tau, T], time, output_noisy)
            if cost < best_cost:
                best_cost = cost
                best_params = [K, tau, T]

print(f"\nCompleted {total_iterations} evaluations")
print()

K_id, tau_id, T_id = best_params

print("=== Identified Parameters ===")
print(f"K   = {K_id:.4f}")
print(f"tau = {tau_id:.4f} s")
print(f"T   = {T_id:.4f} s")
print()

print("True values:")
print("K   = 2.0")
print("tau = 0.5 s")
print("T   = 3.0 s")
print()

print(f"MSE = {best_cost:.6f}")
print()

# Validation: compute R²
y_fitted = [fopdt_step_response(t, K_id, tau_id, T_id) for t in time]
ss_res = sum((y_meas - y_fit)**2 for y_meas, y_fit in zip(output_noisy, y_fitted))
y_mean = sum(output_noisy) / len(output_noisy)
ss_tot = sum((y_meas - y_mean)**2 for y_meas in output_noisy)
r_squared = 1 - (ss_res / ss_tot)

print(f"R² = {r_squared:.4f}")
print()

print("✓ System identification complete (with limitations)")
print()

# Save fitted model parameters
with open("control-theory/data/identified_model.txt", 'w') as f:
    f.write(f"K = {K_id}\n")
    f.write(f"tau = {tau_id}\n")
    f.write(f"T = {T_id}\n")
    f.write(f"MSE = {best_cost}\n")
    f.write(f"R² = {r_squared}\n")

print("=" * 70)
print("PYTHON CHALLENGES:")
print("=" * 70)
print("✗ No built-in optimizer (used inefficient grid search)")
print("✗ Grid search limited resolution → less accurate")
print("✗ No symbolic representation of G(s)")
print("✗ Manual implementation of cost function")
print("✗ Manual R² calculation")
print("✗ No automatic plotting")
print("✗ No LaTeX export")
print()
print("WOLFRAM ADVANTAGES:")
print("✓ NonlinearModelFit with multiple algorithms (NMinimize, etc.)")
print("✓ Automatic gradient computation (symbolic differentiation!)")
print("✓ Symbolic G(s) = K*Exp[-tau*s]/(T*s+1)")
print("✓ Built-in R², AIC, confidence intervals")
print("✓ One-liner: TeXForm[G[s]] → LaTeX for paper")
print("=" * 70)
