"""
Analyze slope k=3 diagonal lattice paths using ore_algebra.

Expected: order ~5, C_3 = smallest root of x^3 - 4x^2 + 6x - 2 = 0
"""

import sys
import os

from passagemath_flint import QQ, ZZ, PolynomialRing, QQbar
from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

seq_file = os.path.join(os.path.dirname(__file__), "seq_slope_3.txt")
with open(seq_file) as f:
    seq = [ZZ(line.strip()) for line in f if line.strip()]

print(f"Loaded {len(seq)} terms for slope k=3")
print(f"First 10: {seq[:10]}")

# Shift operator algebra
Rn = PolynomialRing(QQ, 'n')
n = Rn.gen()
An = OreAlgebra(Rn, 'Sn')

print("\nGuessing recurrence...")
sys.stdout.flush()
rec = guess(seq, An)
print(f"  Order: {rec.order()}")
print(f"  Operator: {rec}")
for i in range(rec.order() + 1):
    coeff = rec[i]
    print(f"  p_{i}(n) = {coeff}  [deg {coeff.degree()}]")
print()

# ODE
Rx = PolynomialRing(QQ, 'x')
x = Rx.gen()
Ax = OreAlgebra(Rx, 'Dx')

print("Guessing ODE...")
sys.stdout.flush()
ode = guess(seq, Ax)
print(f"  ODE order: {ode.order()}")

# Factor leading coeff
lc = ode.leading_coefficient()
print(f"  Leading coeff factored: {lc.factor()}")
print()

# Singularities
sings = lc.roots(QQ)
print("Singular points:")
for r, m in sings:
    print(f"  x = {r}, mult {m}")
print()

# Local basis at x=1/4
print("=== Local basis at x = 1/4 ===")
sys.stdout.flush()
try:
    expansions = ode.local_basis_expansions(QQ(1)/4, order=4)
    for i, exp in enumerate(expansions):
        print(f"  y_{i} = {exp}")
except Exception as e:
    print(f"  Error: {e}")
print()

# Transition matrix 0 -> 1/4
print("=== Transition matrix (0 → 1/4) ===")
sys.stdout.flush()
try:
    tmat = ode.numerical_transition_matrix([0, QQ(1)/4])
    print(f"  {tmat}")
except Exception as e:
    print(f"  Error: {e}")

# ODE -> recurrence conversion
print("\n=== ODE → recurrence ===")
try:
    An2 = OreAlgebra(Rn, 'Sn')
    rec_from_ode = ode.to_S(An2)
    print(f"  Order: {rec_from_ode.order()}")
except Exception as e:
    print(f"  Error: {e}")
