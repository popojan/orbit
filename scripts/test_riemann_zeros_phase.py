#!/usr/bin/env python3
"""
Test: Phase θ(t) at Riemann zeros

Hypothesis: At Riemann zeros, phase behavior related to {t_zero}?

Strategy:
1. Compute θ(t) at precise Riemann zero locations
2. Compare with fractional part {t}
3. Look for pattern in local behavior
"""

from mpmath import mp, zeta, gamma, pi, arg, conj
import math

mp.dps = 50

# First 10 Riemann zeros (imaginary parts, high precision)
RIEMANN_ZEROS = [
    "14.134725141734693790457251983562470270784257115699243175685567460149",
    "21.022039638771554992628479593896902777334340524902781754629520403587",
    "25.010857580145688763213790992562821818659549672557996672496542006745",
    "30.424876125859513210311897530584091320181560023715440180962146036993",
    "32.935061587739189690662368964074903488812715603517039009280003440784",
    "37.586178158825671257217763480705332821223516907122693753374506616112",
    "40.918719012147495187398126914633254395726165962777279536161303667416",
    "43.327073280914999519496122165406805782645668371836871550219241212999",
    "48.005150881167159727942472749427516041686844001144425117775312864002",
    "49.773832477672302181916784678563724057723178299676662100781189447663",
]

def partial_zeta(s, n):
    """H_n(s) = Σ_{k=1}^n k^{-s}"""
    return sum(mp.power(k, -s) for k in range(1, n + 1))

def L_M_closed_form(s, jmax=200):
    """L_M(s) using closed form"""
    zeta_s = zeta(s)
    correction = mp.mpc(0)
    for j in range(2, jmax + 1):
        H_j_minus_1 = partial_zeta(s, j - 1)
        correction += H_j_minus_1 / mp.power(j, s)
    return zeta_s * (zeta_s - 1) - correction

def gamma_classical(s):
    """γ(s) = π^(-s/2) Γ(s/2)"""
    return mp.power(pi, -s/2) * gamma(s/2)

def compute_phase(t):
    """Compute arg(f(s)/f(1-s)) at s = 1/2 + it"""
    s = mp.mpc(0.5, t)
    L_s = L_M_closed_form(s, jmax=200)
    L_1ms = conj(L_s)
    g_s = gamma_classical(s)
    g_1ms = gamma_classical(1 - s)
    f_ratio = (L_1ms / L_s) / (g_1ms / g_s)
    return float(arg(f_ratio))

def main():
    print("=" * 80)
    print("Phase θ(t) at Riemann Zeros")
    print("=" * 80)
    print()
    print("Hypothesis: θ behavior at zeros relates to fractional part {t}")
    print()
    print("=" * 80)

    results = []

    print()
    print(f"{'Zero #':<8} {'t (precise)':<25} {'{t}':<15} {'θ(t)':<15} {'⌊t⌋':<8}")
    print("-" * 75)

    for i, t_str in enumerate(RIEMANN_ZEROS, 1):
        # Parse with high precision
        t_zero = mp.mpf(t_str)
        t_float = float(t_zero)

        # Fractional and integer parts
        t_floor = math.floor(t_float)
        t_frac = t_float - t_floor

        # Compute phase
        theta = compute_phase(t_float)

        print(f"{i:<8} {t_float:<25.10f} {t_frac:<15.10f} {theta:<15.6f} {t_floor:<8}")

        results.append({
            'index': i,
            't': t_float,
            't_frac': t_frac,
            't_floor': t_floor,
            'theta': theta
        })

    print()
    print("=" * 80)
    print("Analysis: Grouping by floor(t)")
    print("=" * 80)
    print()

    # Group by floor
    by_floor = {}
    for r in results:
        floor = r['t_floor']
        if floor not in by_floor:
            by_floor[floor] = []
        by_floor[floor].append(r)

    for floor in sorted(by_floor.keys()):
        zeros_in_floor = by_floor[floor]
        print(f"Floor = {floor} ({len(zeros_in_floor)} zeros):")
        print(f"  {'t':<20} {'{t}':<15} {'θ(t)':<15} {'Δθ (from first)':<20}")
        print("  " + "-" * 70)

        theta_first = zeros_in_floor[0]['theta']

        for r in zeros_in_floor:
            delta_theta = r['theta'] - theta_first
            print(f"  {r['t']:<20.10f} {r['t_frac']:<15.10f} {r['theta']:<15.6f} {delta_theta:<20.6f}")

        print()

    print()
    print("=" * 80)
    print("Testing correlation: θ vs {t}")
    print("=" * 80)
    print()

    # Scatter-like analysis
    print(f"{'Zero #':<8} {'{t}':<15} {'θ(t)':<15} {'θ/2π':<15} {'Relation?':<20}")
    print("-" * 75)

    for r in results:
        t_frac = r['t_frac']
        theta = r['theta']
        theta_normalized = theta / (2 * math.pi)  # Normalize to [0,1) range

        # Look for patterns
        relation = ""
        if abs(theta_normalized - t_frac) < 0.1:
            relation = "θ/2π ≈ {t}"
        elif abs(theta_normalized + t_frac) < 0.1:
            relation = "θ/2π ≈ -{t}"
        elif abs(abs(theta_normalized) - t_frac) < 0.1:
            relation = "|θ/2π| ≈ {t}"

        print(f"{r['index']:<8} {t_frac:<15.10f} {theta:<15.6f} {theta_normalized:<15.10f} {relation:<20}")

    print()
    print("=" * 80)
    print("Detailed: Zeros with same floor")
    print("=" * 80)
    print()

    # Focus on floors with multiple zeros
    multi_floors = {f: zs for f, zs in by_floor.items() if len(zs) > 1}

    if multi_floors:
        for floor, zeros in multi_floors.items():
            print(f"Floor {floor}: {len(zeros)} zeros")
            print()

            # Compute differences
            for i in range(len(zeros)):
                for j in range(i+1, len(zeros)):
                    z1, z2 = zeros[i], zeros[j]
                    delta_t = z2['t'] - z1['t']
                    delta_frac = z2['t_frac'] - z1['t_frac']
                    delta_theta = z2['theta'] - z1['theta']

                    print(f"  Zero {z1['index']} → Zero {z2['index']}:")
                    print(f"    Δt = {delta_t:.10f}")
                    print(f"    Δ{{t}} = {delta_frac:.10f}")
                    print(f"    Δθ = {delta_theta:.6f}")
                    print(f"    Ratio Δθ/Δ{{t}} = {delta_theta/delta_frac if abs(delta_frac) > 1e-10 else 'N/A'}")
                    print()

            print()
    else:
        print("No floors with multiple zeros in this range.")

    print()
    print("=" * 80)
    print("CONCLUSION")
    print("=" * 80)
    print()

    # Check if zeros with same floor have similar theta
    same_floor_similar = True
    for floor, zeros in by_floor.items():
        if len(zeros) > 1:
            thetas = [z['theta'] for z in zeros]
            theta_range = max(thetas) - min(thetas)
            if theta_range > 1.0:  # More than 1 radian variation
                same_floor_similar = False
                break

    if same_floor_similar and len(multi_floors) > 0:
        print("✓ Zeros with same floor(t) have similar θ(t)")
        print("  → θ depends primarily on floor(t), not {t}")
    else:
        print("Testing for relationship between θ and {t}...")

        # Linear regression-like test
        t_fracs = [r['t_frac'] for r in results]
        thetas = [r['theta'] for r in results]

        # Simple correlation
        mean_frac = sum(t_fracs) / len(t_fracs)
        mean_theta = sum(thetas) / len(thetas)

        cov = sum((f - mean_frac) * (t - mean_theta) for f, t in zip(t_fracs, thetas)) / len(t_fracs)
        var_frac = sum((f - mean_frac)**2 for f in t_fracs) / len(t_fracs)
        var_theta = sum((t - mean_theta)**2 for t in thetas) / len(thetas)

        corr = cov / math.sqrt(var_frac * var_theta) if var_frac > 0 and var_theta > 0 else 0

        print(f"Correlation θ vs {{t}}: {corr:.6f}")

        if abs(corr) > 0.5:
            print("✓ Moderate to strong correlation found!")
        else:
            print("✗ No strong correlation")

    print()

if __name__ == "__main__":
    main()
