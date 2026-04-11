"""
Analyze the ODE for slope k=2 diagonal lattice paths using ore_algebra.

The ODE annihilates F(x) = sum_{n>=1} a_k2(n) x^n where a_k2(n) = BeattyBallotCount[1/2, {n,n}].

Known: C_2 = 1/phi^2 (golden ratio), GF is algebraic.
Expected: singularity at x=1/4, local exponent -1/2.
"""

import sys
import os

from passagemath_flint import QQ, ZZ, PolynomialRing, QQbar
from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

# Load sequence
seq_file = os.path.join(os.path.dirname(__file__), "seq_slope_2.txt")
with open(seq_file) as f:
    seq = [ZZ(line.strip()) for line in f if line.strip()]

print(f"Loaded {len(seq)} terms for slope k=2")

# Setup differential operator algebra
Rx = PolynomialRing(QQ, 'x')
x = Rx.gen()
Ax = OreAlgebra(Rx, 'Dx')
Dx = Ax.gen()

# Guess ODE
print("Guessing ODE...")
sys.stdout.flush()
ode = guess(seq, Ax)
print(f"ODE order: {ode.order()}")
print(f"ODE: {ode}")
print()

# Factor the leading coefficient
lc = ode.leading_coefficient()
print(f"Leading coeff: {lc}")
fac = lc.factor()
print(f"Factored: {fac}")
print()

# Singular points
print("=== Singular points ===")
sings = lc.roots(QQ)
for r, m in sings:
    print(f"  x = {r}, multiplicity {m}")
print()

# Local basis expansions at each singular point
print("=== Local basis expansions ===")

for r, m in sings:
    print(f"\n--- At x = {r} (mult {m} in leading coeff) ---")
    try:
        expansions = ode.local_basis_expansions(r, order=4)
        for i, exp in enumerate(expansions):
            print(f"  y_{i}(x) = {exp}")
    except Exception as e:
        print(f"  Error: {e}")
    sys.stdout.flush()

# Monodromy matrices
print("\n=== Monodromy matrices ===")
try:
    from ore_algebra.analytic.monodromy import monodromy_matrices
    # Base point must not be a singular point
    # Singularities: 0, 1/4, -4/9, -14/9
    # Use base = 1/8 (between 0 and 1/4)
    mono = monodromy_matrices(ode, QQ(1)/8)
    for i, (label, mat) in enumerate(mono):
        print(f"\n  Loop {i} around {label}:")
        print(f"    {mat}")
except Exception as e:
    print(f"  Monodromy failed: {e}")

# Numerical transition matrix from 0 to near 1/4
print("\n=== Numerical transition matrix (0 → 1/4) ===")
try:
    # This is the key computation: how solutions at 0 connect to solutions at 1/4
    # The connection constants determine C_2
    tmat = ode.numerical_transition_matrix([0, QQ(1)/4])
    print(f"  Transition matrix (0 → 1/4):")
    print(f"  {tmat}")
except Exception as e:
    print(f"  Transition matrix failed: {e}")

# Also try: convert ODE to recurrence (shift operator)
print("\n=== Convert ODE to recurrence ===")
try:
    Rn = PolynomialRing(QQ, 'n')
    n = Rn.gen()
    An = OreAlgebra(Rn, 'Sn')
    rec = ode.to_S(An)
    print(f"  Recurrence order: {rec.order()}")
    print(f"  Recurrence: {rec}")
except Exception as e:
    print(f"  Conversion failed: {e}")
