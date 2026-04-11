"""
Analyze slope 3/2 diagonal lattice paths using ore_algebra.

We have a recurrence of order 12, degree 50 from guess().
Convert to ODE, then analyze singularities and local basis.
"""

import sys
import os

from passagemath_flint import QQ, ZZ, PolynomialRing
from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

seq_file = os.path.join(os.path.dirname(__file__), "seq_slope_3_2.txt")
with open(seq_file) as f:
    seq = [ZZ(line.strip()) for line in f if line.strip()]

print(f"Loaded {len(seq)} terms for slope 3/2")

# Guess recurrence
Rn = PolynomialRing(QQ, 'n')
n = Rn.gen()
An = OreAlgebra(Rn, 'Sn')
Sn = An.gen()

print("Guessing recurrence...")
sys.stdout.flush()
rec = guess(seq, An)
print(f"  Order: {rec.order()}")
max_deg = max(rec[i].degree() for i in range(rec.order()+1))
print(f"  Max poly degree: {max_deg}")
print()

# Convert to ODE
print("Converting to ODE (rec → D)...")
sys.stdout.flush()
Rx = PolynomialRing(QQ, 'x')
x = Rx.gen()
Ax = OreAlgebra(Rx, 'Dx')
Dx = Ax.gen()

try:
    ode = rec.to_D(Ax)
    print(f"  ODE order: {ode.order()}")

    lc = ode.leading_coefficient()
    print(f"  Leading coeff degree: {lc.degree()}")
    print(f"  Leading coeff factored: {lc.factor()}")
    print()

    # Singularities
    print("Rational singular points:")
    sings = lc.roots(QQ)
    for r, m in sings:
        print(f"  x = {r}, mult {m}")
    print()

    # Local basis at x = 1/4
    print("=== Local basis at x = 1/4 ===")
    sys.stdout.flush()
    try:
        expansions = ode.local_basis_expansions(QQ(1)/4, order=3)
        for i, exp in enumerate(expansions):
            s = str(exp)
            if len(s) > 150:
                s = s[:150] + "..."
            print(f"  y_{i} = {s}")
    except Exception as e:
        print(f"  Error: {e}")
    print()

    # Local basis at x = 0
    print("=== Local basis at x = 0 (first 5 solutions) ===")
    sys.stdout.flush()
    try:
        expansions = ode.local_basis_expansions(0, order=3)
        for i, exp in enumerate(expansions[:5]):
            s = str(exp)
            if len(s) > 150:
                s = s[:150] + "..."
            print(f"  y_{i} = {s}")
        if len(expansions) > 5:
            print(f"  ... ({len(expansions)} solutions total)")
    except Exception as e:
        print(f"  Error: {e}")
    print()

    # Transition matrix (might be slow for high-order ODE)
    print("=== Transition matrix 0 → 1/4 ===")
    print("(This may take a while for order 12+ ODE...)")
    sys.stdout.flush()
    try:
        tmat = ode.numerical_transition_matrix([0, QQ(1)/4])
        print(f"  Shape: {tmat.nrows()}×{tmat.ncols()}")
        # Print diagonal and first column
        for i in range(min(5, tmat.nrows())):
            print(f"  T[{i},0] = {tmat[i,0]}")
    except Exception as e:
        print(f"  Error: {e}")

except Exception as e:
    print(f"  Conversion to ODE failed: {e}")
    print()
    print("  Trying alternative: use ODE from Theta operator...")
    try:
        # Try Theta operator: x*Dx
        Aθ = OreAlgebra(Rx, 'Tx')
        ode_theta = rec.to_T(Aθ)
        print(f"  Theta ODE order: {ode_theta.order()}")
    except Exception as e2:
        print(f"  Also failed: {e2}")
