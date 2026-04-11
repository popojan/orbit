"""
Factor differential operators for diagonal lattice path GFs.

Key question: does the ODE for slope k factor into smaller pieces?
If yes, the factors may be identifiable as known special functions.
If no (irreducible), the solution is genuinely new.

For comparison: Small Step Walks ODE factors as [2,1,1] (Chyzak et al.).
"""

import sys
import os
import time

from passagemath_flint import QQ, ZZ, PolynomialRing
from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

scripts_dir = os.path.dirname(__file__)

Rx = PolynomialRing(QQ, 'x')
x = Rx.gen()
Ax = OreAlgebra(Rx, 'Dx')
Dx = Ax.gen()

# === k=2: ODE order 4 ===
print("=== Slope k=2: factoring ODE of order 4 ===")
seq_file = os.path.join(scripts_dir, "seq_slope_2.txt")
with open(seq_file) as f:
    seq2 = [ZZ(line.strip()) for line in f if line.strip()]

ode2 = guess(seq2, Ax)
print(f"ODE order: {ode2.order()}")

print("Factoring...")
sys.stdout.flush()
t0 = time.time()
try:
    fac2 = ode2.factor()
    dt = time.time() - t0
    print(f"  Done in {dt:.1f}s")
    print(f"  Number of factors: {len(fac2)}")
    print(f"  Factor orders: {[f.order() for f in fac2]}")
    for i, f in enumerate(fac2):
        print(f"  Factor {i}: order {f.order()}, {f}")
    # Verify
    prod_check = fac2[0]
    for f in fac2[1:]:
        prod_check = prod_check * f
    print(f"  Product == original: {prod_check == ode2}")
except Exception as e:
    dt = time.time() - t0
    print(f"  Failed after {dt:.1f}s: {e}")

print()

# === k=3: ODE order 11 ===
print("=== Slope k=3: factoring ODE of order 11 ===")
seq_file = os.path.join(scripts_dir, "seq_slope_3.txt")
with open(seq_file) as f:
    seq3 = [ZZ(line.strip()) for line in f if line.strip()]

ode3 = guess(seq3, Ax)
print(f"ODE order: {ode3.order()}")

print("Factoring (may take a while)...")
sys.stdout.flush()
t0 = time.time()
try:
    fac3 = ode3.factor()
    dt = time.time() - t0
    print(f"  Done in {dt:.1f}s")
    print(f"  Number of factors: {len(fac3)}")
    print(f"  Factor orders: {[f.order() for f in fac3]}")
    for i, f in enumerate(fac3):
        print(f"  Factor {i}: order {f.order()}")
        if f.order() <= 3:
            print(f"    {f}")
except Exception as e:
    dt = time.time() - t0
    print(f"  Failed after {dt:.1f}s: {e}")
