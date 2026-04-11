"""
Guess holonomic recurrence for BeattyBallotCount[2/3, {n,n}] (slope 3/2)
using ore_algebra.

Expected from Mathematica NullSpace: order 15, polynomial degree 20.
"""

import sys
import os

# MUST import passagemath_flint first to bootstrap sage internals
from passagemath_flint import QQ, ZZ, PolynomialRing

from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

# Load sequence
seq_file = os.path.join(os.path.dirname(__file__), "seq_slope_3_2.txt")
with open(seq_file) as f:
    seq = [ZZ(line.strip()) for line in f if line.strip()]

print(f"Loaded {len(seq)} terms for slope 3/2")
print(f"First 10: {seq[:10]}")
print()

# Setup shift operator algebra
Rn = PolynomialRing(QQ, 'n')
n = Rn.gen()
An = OreAlgebra(Rn, 'Sn')
Sn = An.gen()

# Guess the recurrence
print("Guessing recurrence (shift operator)...")
sys.stdout.flush()

rec = guess(seq, An)

print(f"\nRecurrence order: {rec.order()}")
print(f"Operator: {rec}")
print()

# Extract and display polynomial coefficients
print("=== Polynomial coefficients p_i(n) in Σ p_i(n) a(n+i) = 0 ===")
for i in range(rec.order() + 1):
    coeff = rec[i]
    print(f"  p_{i}(n) = {coeff}")
    if hasattr(coeff, 'degree'):
        print(f"    degree = {coeff.degree()}")
print()

# Also try differential operator (ODE for GF)
print("Guessing ODE for generating function...")
Rx = PolynomialRing(QQ, 'x')
x = Rx.gen()
Ax = OreAlgebra(Rx, 'Dx')
Dx = Ax.gen()

try:
    ode = guess(seq, Ax)
    print(f"ODE order: {ode.order()}")
    print(f"ODE: {ode}")
except Exception as e:
    print(f"ODE guess failed: {e}")
