#!/usr/bin/env python3
"""
Domain Coloring Visualization of L_M(s)

Classic complex plot showing:
- Hue: phase arg(L_M(s))
- Brightness: log magnitude log|L_M(s)|

This reveals poles, zeros, and phase structure in single image.
"""

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from scipy.special import zeta
import colorsys

def L_M_closed_form(s, j_max=200):
    """
    L_M(s) = ζ(s)[ζ(s)-1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s

    Works for Re(s) > 1
    """
    s_array = np.asarray(s)
    is_array = s_array.ndim > 0

    if is_array:
        result = np.zeros_like(s_array, dtype=complex)

        for idx, s_val in np.ndenumerate(s_array):
            if np.real(s_val) > 1.01:  # Avoid pole region
                zeta_s = zeta(s_val)

                # Correction sum C(s)
                C_s = 0.0
                for j in range(2, j_max + 1):
                    H_jm1 = sum(k**(-s_val) for k in range(1, j))
                    C_s += H_jm1 / (j**s_val)

                result[idx] = zeta_s * (zeta_s - 1) - C_s
            else:
                result[idx] = np.nan + 1j*np.nan

        return result
    else:
        s_val = complex(s_array)
        if np.real(s_val) > 1.01:
            zeta_s = zeta(s_val)
            C_s = sum((sum(k**(-s_val) for k in range(1, j))) / (j**s_val)
                     for j in range(2, j_max + 1))
            return zeta_s * (zeta_s - 1) - C_s
        else:
            return np.nan + 1j*np.nan

def complex_to_rgb(z, log_scaling=True, brightness_scale=1.0):
    """
    Convert complex number to RGB using domain coloring.

    - Hue: phase angle arg(z) ∈ [-π, π]
    - Saturation: 1 (full color)
    - Value (brightness): log|z| (scaled)
    """
    # Handle NaN
    if np.isnan(z):
        return (0.5, 0.5, 0.5)  # Gray for undefined

    # Phase → Hue (0 to 1)
    phase = np.angle(z)
    hue = (phase + np.pi) / (2 * np.pi)

    # Magnitude → Brightness
    mag = np.abs(z)

    if log_scaling:
        # Log scale for magnitude (handles large variations)
        if mag > 0:
            brightness = np.tanh(brightness_scale * np.log10(mag + 1e-10))
            # Map to [0, 1]
            brightness = (brightness + 1) / 2
        else:
            brightness = 0.5
    else:
        # Linear scale
        brightness = np.clip(mag * brightness_scale, 0, 1)

    # Saturation = 1 (full color)
    saturation = 1.0

    # If magnitude is very small, reduce saturation (→ white/black)
    if mag < 1e-6:
        saturation = 0.0
        brightness = 0.0

    # Convert HSV to RGB
    rgb = colorsys.hsv_to_rgb(hue, saturation, brightness)

    return rgb

# ============================================================================
# Create domain coloring plot
# ============================================================================

print("="*80)
print("DOMAIN COLORING: L_M(s) in Complex Plane")
print("="*80)

# Grid parameters
sigma_min, sigma_max = 1.1, 3.5
t_min, t_max = -30, 30
n_sigma, n_t = 200, 300  # Optimized resolution for speed

sigma_vals = np.linspace(sigma_min, sigma_max, n_sigma)
t_vals = np.linspace(t_min, t_max, n_t)

Sigma, T = np.meshgrid(sigma_vals, t_vals)
S = Sigma + 1j*T

print(f"\nGrid: σ ∈ [{sigma_min}, {sigma_max}], t ∈ [{t_min}, {t_max}]")
print(f"Resolution: {n_sigma} × {n_t} = {n_sigma*n_t} points")
print("\nComputing L_M(σ+it)...")

# Compute L_M over grid (with progress)
L_M = np.zeros((n_t, n_sigma), dtype=complex)

for i in range(n_t):
    for j in range(n_sigma):
        s_val = S[i, j]
        L_M[i, j] = L_M_closed_form(s_val, j_max=80)

    if i % 50 == 0:
        print(f"  Progress: {i}/{n_t} rows ({100*i/n_t:.1f}%)")

print("Done!")

# Convert to RGB image
print("\nGenerating domain coloring...")

rgb_image = np.zeros((n_t, n_sigma, 3))

for i in range(n_t):
    for j in range(n_sigma):
        z = L_M[i, j]
        rgb_image[i, j, :] = complex_to_rgb(z, log_scaling=True, brightness_scale=0.5)

    if i % 100 == 0:
        print(f"  Row {i}/{n_t}...")

print("Done!")

# ============================================================================
# Plot domain coloring
# ============================================================================

fig, ax = plt.subplots(1, 1, figsize=(12, 10))

# Display RGB image
ax.imshow(rgb_image, extent=[sigma_min, sigma_max, t_min, t_max],
          origin='lower', aspect='auto', interpolation='bilinear')

# Add pole line
ax.axvline(x=1, color='white', linestyle='--', linewidth=2, alpha=0.8,
          label='Re(s)=1 (pole)')

# Add real axis
ax.axhline(y=0, color='white', linestyle='-', linewidth=1, alpha=0.5,
          label='Real axis')

# Add Schwarz symmetry axis
ax.text(3.3, 2, 'Schwarz symmetry\naround t=0', color='white',
        fontsize=10, ha='right', bbox=dict(boxstyle='round',
        facecolor='black', alpha=0.5))

ax.set_xlabel(r'$\sigma = \mathrm{Re}(s)$', fontsize=14)
ax.set_ylabel(r'$t = \mathrm{Im}(s)$', fontsize=14)
ax.set_title(r'Domain Coloring: $L_M(s)$ (Hue=phase, Brightness=log|L_M|)',
            fontsize=16, fontweight='bold')
ax.legend(loc='upper right', fontsize=12)
ax.grid(True, alpha=0.3, color='white', linewidth=0.5)

plt.tight_layout()
plt.savefig('/home/user/orbit/visualizations/L_M_domain_coloring.png', dpi=200)
print("\nSaved: visualizations/L_M_domain_coloring.png")

# ============================================================================
# Alternative: Enhanced phase plot with contours
# ============================================================================

fig2, ax2 = plt.subplots(1, 1, figsize=(12, 10))

# Extract phase and magnitude
L_M_phase = np.angle(L_M)
L_M_mag = np.abs(L_M)

# Phase coloring
phase_plot = ax2.imshow(L_M_phase, extent=[sigma_min, sigma_max, t_min, t_max],
                        origin='lower', aspect='auto', cmap='twilight',
                        interpolation='bilinear')

# Add magnitude contours
contour_levels = [0.1, 0.5, 1.0, 2.0, 5.0, 10.0]
ax2.contour(Sigma, T, L_M_mag, levels=contour_levels,
           colors='white', alpha=0.4, linewidths=1)

# Add pole line
ax2.axvline(x=1, color='yellow', linestyle='--', linewidth=2, alpha=0.8)

# Add real axis
ax2.axhline(y=0, color='white', linestyle='-', linewidth=1, alpha=0.5)

ax2.set_xlabel(r'$\sigma = \mathrm{Re}(s)$', fontsize=14)
ax2.set_ylabel(r'$t = \mathrm{Im}(s)$', fontsize=14)
ax2.set_title(r'Phase Portrait: $\arg[L_M(s)]$ with $|L_M|$ Contours',
             fontsize=16, fontweight='bold')

# Colorbar
cbar = plt.colorbar(phase_plot, ax=ax2, label=r'Phase $\arg[L_M(s)]$ (radians)')
cbar.set_ticks([-np.pi, -np.pi/2, 0, np.pi/2, np.pi])
cbar.set_ticklabels([r'$-\pi$', r'$-\pi/2$', '0', r'$\pi/2$', r'$\pi$'])

ax2.grid(True, alpha=0.3, color='white', linewidth=0.5)

plt.tight_layout()
plt.savefig('/home/user/orbit/visualizations/L_M_phase_portrait.png', dpi=200)
print("Saved: visualizations/L_M_phase_portrait.png")

# ============================================================================
# Summary
# ============================================================================

print("\n" + "="*80)
print("DOMAIN COLORING INTERPRETATION")
print("="*80)

print("""
Domain coloring shows complex function structure in single plot:

**Color (Hue)**:
- Red: arg(L_M) ≈ 0 (positive real)
- Yellow: arg(L_M) ≈ π/3
- Green: arg(L_M) ≈ 2π/3
- Cyan: arg(L_M) ≈ π (negative real)
- Blue: arg(L_M) ≈ 4π/3
- Magenta: arg(L_M) ≈ 5π/3

**Brightness**:
- Bright: large |L_M(s)|
- Dark: small |L_M(s)|
- Black: |L_M| → 0 (zeros!)
- Very bright near σ=1: pole!

**Patterns to look for**:

1. **Pole at s=1**:
   - Very bright vertical stripe at σ=1
   - Color cycling rapidly (phase singularity)

2. **Zeros** (if any):
   - Black points
   - Color cycling around them

3. **Schwarz symmetry**:
   - Reflection symmetry around t=0
   - Upper/lower halves mirror each other

4. **Phase structure**:
   - Horizontal bands: phase varies with t
   - Smooth transitions: analytic function
   - Discontinuities: branch cuts (none expected here)

5. **Magnitude growth**:
   - Brightness increases toward σ=1 (pole)
   - Decreases for large σ (exponential decay)
   - Oscillates with t (periodic structure)

**Comparison to Riemann ζ(s)**:
- Similar structure but L_M has double pole (brighter!)
- More complex oscillation pattern (non-multiplicative)
- Richer color structure (more phase variation)
""")

print("\nVisualization complete!")
print("Check: visualizations/L_M_domain_coloring.png")
print("       visualizations/L_M_phase_portrait.png")
