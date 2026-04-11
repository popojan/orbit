"""
Targeted guess for slope 3/2 — try specific order/degree ranges.

Mathematica found: order 15, degree 20 (from NullSpace with 400 terms).
ore_algebra guess() was running too long with no constraints.

Strategy: try ODE (Dx) first, which may be smaller, then shift (Sn).
"""

import sys
import os
import time

from passagemath_flint import QQ, ZZ, PolynomialRing
from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

seq_file = os.path.join(os.path.dirname(__file__), "seq_slope_3_2.txt")
with open(seq_file) as f:
    seq = [ZZ(line.strip()) for line in f if line.strip()]

print(f"Loaded {len(seq)} terms for slope 3/2")
print(f"First 10: {seq[:10]}")
print()

# Try ODE first (differential operator)
Rx = PolynomialRing(QQ, 'x')
x = Rx.gen()
Ax = OreAlgebra(Rx, 'Dx')

print("=== Guessing ODE (Dx algebra) ===")
sys.stdout.flush()
t0 = time.time()
try:
    ode = guess(seq, Ax, infolevel=1)
    dt = time.time() - t0
    print(f"\nODE found in {dt:.1f}s")
    print(f"  Order: {ode.order()}")
    lc = ode.leading_coefficient()
    print(f"  Leading coeff degree: {lc.degree()}")
    print(f"  Leading coeff factored: {lc.factor()}")
    print()

    # Local basis at x=1/4
    print("  Local basis at x=1/4:")
    sys.stdout.flush()
    try:
        expansions = ode.local_basis_expansions(QQ(1)/4, order=3)
        for i, exp in enumerate(expansions):
            s = str(exp)
            if len(s) > 120:
                s = s[:120] + "..."
            print(f"    y_{i} = {s}")
    except Exception as e:
        print(f"    Error: {e}")
    print()

    # Transition matrix
    print("  Numerical transition matrix (0 → 1/4):")
    sys.stdout.flush()
    try:
        tmat = ode.numerical_transition_matrix([0, QQ(1)/4])
        # Just print the shape and first few entries
        print(f"    Shape: {tmat.nrows()}×{tmat.ncols()}")
        print(f"    [0,0] = {tmat[0,0]}")
        print(f"    [1,1] = {tmat[1,1]}")
    except Exception as e:
        print(f"    Error: {e}")

except Exception as e:
    dt = time.time() - t0
    print(f"\nODE guess failed after {dt:.1f}s: {e}")

print()

# Now try recurrence with bounded search
Rn = PolynomialRing(QQ, 'n')
n = Rn.gen()
An = OreAlgebra(Rn, 'Sn')

for min_ord, max_ord in [(12, 20)]:
    print(f"=== Guessing recurrence (Sn, order {min_ord}-{max_ord}) ===")
    sys.stdout.flush()
    t0 = time.time()
    try:
        rec = guess(seq, An, min_order=min_ord, order=max_ord, infolevel=1)
        dt = time.time() - t0
        print(f"\nRecurrence found in {dt:.1f}s")
        print(f"  Order: {rec.order()}")
        max_deg = max(rec[i].degree() for i in range(rec.order()+1))
        print(f"  Max poly degree: {max_deg}")
    except Exception as e:
        dt = time.time() - t0
        print(f"\nFailed after {dt:.1f}s: {e}")
