"""
Plot C(alpha) from the survey data.
Loads both coarse survey and (if available) dense detail survey.
"""

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import os

scripts_dir = os.path.dirname(os.path.abspath(__file__))

def load_tsv(path):
    data = []
    with open(path) as f:
        f.readline()  # header
        for line in f:
            parts = line.strip().split('\t')
            if len(parts) >= 4:
                try:
                    alpha = float(parts[0].strip('"'))
                    c = float(parts[1].strip('"'))
                    p = int(parts[2].strip('"'))
                    q = int(parts[3].strip('"'))
                    data.append((alpha, c, p, q))
                except ValueError:
                    pass
    return data

def load_irrational_tsv(path):
    data = []
    if not os.path.exists(path):
        return data
    with open(path) as f:
        f.readline()
        for line in f:
            parts = line.strip().split('\t')
            if len(parts) >= 3:
                try:
                    alpha = float(parts[0].strip('"'))
                    c = float(parts[1].strip('"'))
                    label = parts[2].strip('"')
                    data.append((alpha, c, label))
                except ValueError:
                    pass
    return data

# Load coarse survey
data = load_tsv(os.path.join(scripts_dir, "survey_C_alpha.tsv"))
print(f"Coarse survey: {len(data)} points")

# Load dense survey if available
detail_file = os.path.join(scripts_dir, "survey_C_detail.tsv")
if os.path.exists(detail_file):
    detail = load_tsv(detail_file)
    print(f"Dense survey: {len(detail)} points")
    # Merge, dedup by alpha
    seen = {d[0] for d in data}
    for d in detail:
        if d[0] not in seen:
            data.append(d)
            seen.add(d[0])
    data.sort()
    print(f"Merged: {len(data)} points")

# Separate integer and non-integer slopes
integers = [(a, c, p, q) for a, c, p, q in data if q == 1]
rationals = [(a, c, p, q) for a, c, p, q in data if q > 1]

# === Plot 1: full survey ===
fig, ax = plt.subplots(1, 1, figsize=(10, 6))

if rationals:
    ax.scatter([r[0] for r in rationals], [r[1] for r in rationals],
               c='steelblue', s=15, zorder=3, alpha=0.7, label=f'Rational p/q (n={len(rationals)})')

if integers:
    ax.scatter([r[0] for r in integers], [r[1] for r in integers],
               c='red', s=100, marker='*', zorder=4, label=f'Integer k (n={len(integers)})')

ax.axhline(y=0.5, color='gray', linestyle='--', alpha=0.5, label='C = 1/2 (limit)')

ax.annotate('$C_2 = 1/\\varphi^2$', xy=(2, 0.3831), xytext=(2.4, 0.34),
            arrowprops=dict(arrowstyle='->', color='red', lw=1.2), fontsize=10, color='red')

# Add irrationals
irr_data = load_irrational_tsv(os.path.join(scripts_dir, "survey_C_irrational.tsv"))
if irr_data:
    ax.scatter([d[0] for d in irr_data], [d[1] for d in irr_data],
               c='limegreen', s=40, marker='o', zorder=5, edgecolors='darkgreen',
               linewidths=0.8, label=f'Irrational (n={len(irr_data)})')

ax.set_xlabel('Slope $\\alpha = p/q$', fontsize=12)
ax.set_ylabel('Asymptotic constant $C(\\alpha)$', fontsize=12)
ax.set_title('$C(\\alpha)$ for diagonal lattice paths under $y \\leq \\alpha x$\n'
             '$a(n,n) \\sim C(\\alpha) \\cdot 4^n / \\sqrt{\\pi n}$', fontsize=13)
ax.legend(fontsize=10, loc='lower right')
ax.grid(True, alpha=0.3)
ax.set_xlim(1, 6.5)
ax.set_ylim(0, 0.55)

fig_dir = os.path.join(scripts_dir, '..', 'figures')
os.makedirs(fig_dir, exist_ok=True)
out_path = os.path.join(fig_dir, 'C_alpha_survey.png')
fig.savefig(out_path, dpi=150, bbox_inches='tight')
print(f"Saved to {out_path}")
plt.close()

# === Plot 2: zoom with denominator-colored markers ===
detail_data = [(a, c, p, q) for a, c, p, q in data if 1.4 <= a <= 3.6]
if len(detail_data) > 15:
    fig, axes = plt.subplots(1, 2, figsize=(14, 5.5))

    # Color/size by denominator
    denom_styles = {
        1: ('red', '*', 120, '$q=1$ (integer)'),
        2: ('darkorange', 'D', 50, '$q=2$'),
        3: ('green', 's', 35, '$q=3$'),
        4: ('purple', '^', 30, '$q=4$'),
    }

    for ax_i, (lo, hi, k_val) in enumerate([(1.4, 2.6, 2), (2.4, 3.6, 3)]):
        ax = axes[ax_i]
        local = [(a, c, p, q) for a, c, p, q in data if lo <= a <= hi]

        # Plot high-q points first (background)
        high_q = [(a, c, p, q) for a, c, p, q in local if q > 4]
        if high_q:
            ax.scatter([r[0] for r in high_q], [r[1] for r in high_q],
                       c='steelblue', s=12, zorder=2, alpha=0.5, label='$q \\geq 5$')

        # Plot small-q points on top
        for q_val in sorted(denom_styles.keys(), reverse=True):
            pts = [(a, c, p, q) for a, c, p, q in local if q == q_val]
            if pts:
                color, marker, size, label = denom_styles[q_val]
                ax.scatter([r[0] for r in pts], [r[1] for r in pts],
                           c=color, marker=marker, s=size, zorder=3+q_val,
                           label=label)
                # Label integer slopes
                if q_val == 1:
                    for a, c, p, q in pts:
                        ax.annotate(f'$k={p}$', xy=(a, c), xytext=(a+0.04, c-0.006),
                                   fontsize=9, color='red')

        # Add irrationals in this range
        irr_local = [(a, c, lb) for a, c, lb in irr_data if lo <= a <= hi]
        if irr_local:
            ax.scatter([d[0] for d in irr_local], [d[1] for d in irr_local],
                       c='limegreen', s=60, marker='o', zorder=10, edgecolors='darkgreen',
                       linewidths=1.0, label='Irrational')
            for a, c, lb in irr_local:
                # Short label
                ax.annotate(f'${lb}$', xy=(a, c), xytext=(5, -12),
                           textcoords='offset points', fontsize=7, color='darkgreen')

        ax.set_xlabel('$\\alpha$', fontsize=12)
        ax.set_ylabel('$C(\\alpha)$', fontsize=12)
        ax.set_title(f'Detail around $k={k_val}$', fontsize=12)
        ax.grid(True, alpha=0.3)
        if ax_i == 0:
            ax.legend(fontsize=8, loc='upper left')

    fig.suptitle('Kinks at every rational: excess $\\sim 1/q$ (smaller denominator $\\Rightarrow$ larger kink)',
                 fontsize=12, y=1.02)
    fig.tight_layout()
    out_path2 = os.path.join(fig_dir, 'C_alpha_detail.png')
    fig.savefig(out_path2, dpi=150, bbox_inches='tight')
    print(f"Saved to {out_path2}")
    plt.close()
